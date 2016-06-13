From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] scsi:stex.c Support Pegasus 3 product
Date: Mon, 13 Jun 2016 21:49:34 +1000
Message-ID: <CAGRGNgW2Om_1rJdby0YJEmdNUy+NzEe--MTnBir3rf+j16FQyQ@mail.gmail.com>
References: <1465199633-21182-1-git-send-email-ch1102chiou@gmail.com>
 <CAGRGNgWBwBUbnmvBxf_tCkBL-Am+iLzdxWi57xKAbGuvEE1-pg@mail.gmail.com> <575E9BBE.3060403@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <575E9BBE.3060403@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com, paul.lyu@tw.promise.com
List-Id: linux-scsi@vger.kernel.org

Hi Charles,

On Mon, Jun 13, 2016 at 9:40 PM, Charles Chiou <ch1102chiou@gmail.com> wrote:
> Hi Julian,
>
>
> On 06/10/2016 08:10 AM, Julian Calaby wrote:
>>
>> Hi Charles,
>>
>> On Mon, Jun 6, 2016 at 5:53 PM, Charles Chiou <ch1102chiou@gmail.com>
>> wrote:
>>>
>>> From: Charles <charles.chiou@tw.promise.com>
>>>
>>> Pegasus series is a RAID support product by using Thunderbolt technology.
>>>
>>> The newest product, Pegasus 3 is support Thunderbolt 3 technology with
>>> another chip.
>>>
>>> 1.Change driver version.
>>>
>>> 2.Add Pegasus 3 VID, DID and define it's device address.
>>>
>>> 3.Pegasus 3 use msi interrupt, so stex_request_irq P3 type enable msi.
>>>
>>> 4.For hibernation, use msi_lock in stex_ss_handshake to prevent msi
>>> register write again when handshaking.
>>>
>>> 5.Pegasus 3 don't need read() as flush.
>>>
>>> 6.In stex_ss_intr & stex_abort, P3 only clear interrupt register when
>>> getting vendor defined interrupt.
>>>
>>> 7.Add reboot notifier and register it in stex_probe for all supported
>>> device.
>>>
>>> 8.For all supported device in restart flow, we get a callback from
>>> notifier and set S6flag for stex_shutdown & stex_hba_stop to send restart
>>> command to FW.
>>>
>>> Signed-off-by: Charles <charles.chiou@tw.promise.com>
>>> Signed-off-by: Paul <paul.lyu@tw.promise.com>
>>> ---
>>>   drivers/scsi/stex.c | 282
>>> +++++++++++++++++++++++++++++++++++++++-------------
>>>   1 file changed, 214 insertions(+), 68 deletions(-)
>>>
>>> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
>>> index 5b23175..9de2de2 100644
>>> --- a/drivers/scsi/stex.c
>>> +++ b/drivers/scsi/stex.c
>>> @@ -87,7 +95,7 @@ enum {
>>>          MU_STATE_STOP                           = 5,
>>>          MU_STATE_NOCONNECT                      = 6,
>>>
>>> -       MU_MAX_DELAY                            = 120,
>>> +       MU_MAX_DELAY                            = 50,
>>
>>
>> This won't cause problems for older adapters, right?
>
>
> Correct.
>
>>
>>>          MU_HANDSHAKE_SIGNATURE                  = 0x55aaaa55,
>>>          MU_HANDSHAKE_SIGNATURE_HALF             = 0x5a5a0000,
>>>          MU_HARD_RESET_WAIT                      = 30000,
>>> @@ -540,11 +556,15 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg
>>> *req, u16 tag)
>>>
>>>          ++hba->req_head;
>>>          hba->req_head %= hba->rq_count+1;
>>> -
>>> -       writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
>>> -       readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
>>> -       writel(addr, hba->mmio_base + YH2I_REQ);
>>> -       readl(hba->mmio_base + YH2I_REQ); /* flush */
>>> +       if (hba->cardtype == st_P3) {
>>> +               writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
>>> +               writel(addr, hba->mmio_base + YH2I_REQ);
>>> +       } else {
>>> +               writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
>>> +               readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
>>> +               writel(addr, hba->mmio_base + YH2I_REQ);
>>> +               readl(hba->mmio_base + YH2I_REQ); /* flush */
>>> +       }
>>
>>
>> The first writel() lines in each branch of the if statement are
>> identical, so they could be outside of it.
>
>
> I'll revise it in next patch.

On second thought, don't worry about doing this, keep the two
(slightly) different sets of code separate.

>>
>> Would it make sense to add a helper that does the readl() flush only
>> for non-st_P3? This could be a function pointer in the hba structure
>> which shouldn't slow stuff down.
>>
>
> Would you means to register another function pointer in struct "struct
> st_card_info" then point to hba strucrure for non-st_P3?
>
> struct st_card_info {
>         struct req_msg * (*alloc_rq) (struct st_hba *);
>         int (*map_sg)(struct st_hba *, struct req_msg *, struct st_ccb *);
>         void (*send) (struct st_hba *, struct req_msg *, u16);
>         unsigned int max_id;
>         unsigned int max_lun;
>         unsigned int max_channel;
>         u16 rq_count;
>         u16 rq_size;
>         u16 sts_count;
> };

Again, on second thought, don't worry about it.

>>>   }
>>>
>>>   static void return_abnormal_state(struct st_hba *hba, int status)
>>> @@ -1111,30 +1160,63 @@ static int stex_ss_handshake(struct st_hba *hba)
>>>          scratch_size = (hba->sts_count+1)*sizeof(u32);
>>>          h->scratch_size = cpu_to_le32(scratch_size);
>>>
>>> -       data = readl(base + YINT_EN);
>>> -       data &= ~4;
>>> -       writel(data, base + YINT_EN);
>>> -       writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
>>> -       readl(base + YH2I_REQ_HI);
>>> -       writel(hba->dma_handle, base + YH2I_REQ);
>>> -       readl(base + YH2I_REQ); /* flush */
>>> +       if (hba->cardtype == st_yel) {
>>
>>
>> Same question again.
>
>
> I'll revise it in next patch.
>
>>
>>> +               data = readl(base + YINT_EN);
>>> +               data &= ~4;
>>> +               writel(data, base + YINT_EN);
>>> +               writel((hba->dma_handle >> 16) >> 16, base +
>>> YH2I_REQ_HI);
>>> +               readl(base + YH2I_REQ_HI);
>>> +               writel(hba->dma_handle, base + YH2I_REQ);
>>> +               readl(base + YH2I_REQ); /* flush */
>>> +       } else if (hba->cardtype == st_P3) {
>>> +               data = readl(base + YINT_EN);
>>> +               data &= ~(1 << 0);
>>> +               data &= ~(1 << 2);
>>> +               writel(data, base + YINT_EN);
>>> +               if (hba->msi_lock == 0) {
>>> +                       /* P3 MSI Register cannot access twice */
>>> +                       writel((1 << 6), base + YH2I_INT);
>>> +                       hba->msi_lock  = 1;
>>> +               }
>>> +               writel((hba->dma_handle >> 16) >> 16, base +
>>> YH2I_REQ_HI);
>>> +               writel(hba->dma_handle, base + YH2I_REQ);
>>> +       }
>>
>>
>> The two writel()s at the end of each branch of the if statement are
>> identical except for the readl() calls to flush the data in the non-P3
>> case. This would be simplified by adding a helper as discussed above.
>>
>
> Sorry, I don't know what you means "adding a helper", would you please tell
> me more details?

Don't worry about it. I was referring to the additional function pointer above.

>>> -       scratch = hba->scratch;
>>>          before = jiffies;
>>> -       while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
>>> -               if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
>>> -                       printk(KERN_ERR DRV_NAME
>>> -                               "(%s): no signature after handshake
>>> frame\n",
>>> -                               pci_name(hba->pdev));
>>> -                       ret = -1;
>>> -                       break;
>>> +
>>> +       if (hba->cardtype == st_yel) {
>>
>>
>> Again, is this only called for st_yel and st_P3?
>>
>
> This function only for st_yel & st_P3.
>
>
>>> +               scratch = hba->scratch;
>>> +
>>> +               while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
>>> +                       if (time_after(jiffies, before + MU_MAX_DELAY *
>>> HZ)) {
>>> +                               printk(KERN_ERR DRV_NAME
>>> +                                       "(%s): no signature after
>>> handshake frame\n",
>>> +                                       pci_name(hba->pdev));
>>> +                               ret = -1;
>>> +                               break;
>>> +                       }
>>> +                       rmb();
>>> +                       msleep(1);
>>>                  }
>>> -               rmb();
>>> -               msleep(1);
>>> +               memset(scratch, 0, scratch_size);
>>> +       } else if (hba->cardtype == st_P3) {
>>> +               while ((readl(base + MAILBOX_BASE + MAILBOX_HNDSHK_STS)
>>> +                & SS_STS_HANDSHAKE) == 0) {
>>> +                       if (time_after(jiffies, before + MU_MAX_DELAY *
>>> HZ)) {
>>> +                               printk(KERN_ERR DRV_NAME
>>> +                                       "(%s): no signature after
>>> handshake frame\n",
>>> +                                       pci_name(hba->pdev));
>>> +                               ret = -1;
>>> +                               break;
>>> +                       }
>>> +                       rmb();
>>> +                       msleep(1);
>>> +               }
>>> +               memset(hba->scratch, 0, scratch_size);
>>
>>
>> The memsets at the end of each branch of the if statement are identical.
>>
>
> I'll revise it in next patch.
>
>>>          }
>>>
>>> -       memset(scratch, 0, scratch_size);
>>>          msg_h->flag = 0;
>>> +
>>>          return ret;
>>>   }
>>>
>>> @@ -1736,28 +1870,29 @@ static void stex_hba_stop(struct st_hba *hba, int
>>> st_sleep_mic)
>>>
>>>          spin_lock_irqsave(hba->host->host_lock, flags);
>>>
>>> -       if (hba->cardtype == st_yel && hba->supports_pm == 1)
>>> -       {
>>> -               if(st_sleep_mic == ST_NOTHANDLED)
>>> -               {
>>> +       if ((hba->cardtype == st_yel && hba->supports_pm == 1)
>>> +               || (hba->cardtype == st_P3 && hba->supports_pm == 1)) {
>>
>>
>> if ((hba->cardtype == st_yel || hba->cardtype == st_P3) &&
>> hba->supports_pm == 1) {
>>
>> is simpler.
>>
>
> I'll revise it in next patch.
>
>
>>> +               if (st_sleep_mic == ST_NOTHANDLED) {
>>>                          spin_unlock_irqrestore(hba->host->host_lock,
>>> flags);
>>>                          return;
>>>                  }
>>>          }
>>>          req = hba->alloc_rq(hba);
>>> -       if (hba->cardtype == st_yel) {
>>> +       if (hba->cardtype == st_yel || hba->cardtype == st_P3) {
>>>                  msg_h = (struct st_msg_header *)req - 1;
>>>                  memset(msg_h, 0, hba->rq_size);
>>>          } else
>>>                  memset(req, 0, hba->rq_size);
>>>
>>> -       if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel)
>>> +       if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel
>>> +               || hba->cardtype == st_P3)
>>>                  && st_sleep_mic == ST_IGNORED) {
>>>                  req->cdb[0] = MGT_CMD;
>>>                  req->cdb[1] = MGT_CMD_SIGNATURE;
>>>                  req->cdb[2] = CTLR_CONFIG_CMD;
>>>                  req->cdb[3] = CTLR_SHUTDOWN;
>>> -       } else if (hba->cardtype == st_yel && st_sleep_mic != ST_IGNORED)
>>> {
>>> +       } else if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
>>> +               && st_sleep_mic != ST_IGNORED) {
>>
>>
>> Er, this will never get run.
>>
>> We have:
>>
>> if (hba->cardtype == st_yosemite || hba->cardtype == st_yel ||
>> hba->cardtype == st_P3) {
>>      // stuff
>> } else if ((hba->cardtype == st_yel || hba->cardtype == st_P3) &&
>> st_sleep_mic != ST_IGNORED) {
>>      // stuff
>> }
>>
>> Should the two branches of the if statement be reversed or should the
>> first one be written like:
>>
>> if (hba->cardtype == st_yosemite || ((hba->cardtype == st_yel ||
>> hba->cardtype == st_P3) && st_sleep_mic == ST_IGNORED)) {
>>
>
> The first statement is:
>
> if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel ||
> hba->cardtype == st_P3) && st_sleep_mic == ST_IGNORED) {
>
> So I think the if statement didn't need to revise.

You're right, I can't read.

>>>                  req->cdb[0] = MGT_CMD;
>>>                  req->cdb[1] = MGT_CMD_SIGNATURE;
>>>                  req->cdb[2] = CTLR_CONFIG_CMD;

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
