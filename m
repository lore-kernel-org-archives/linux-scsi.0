From: Julian Calaby <julian.calaby@gmail.com>
Subject: Re: [PATCH] scsi:stex.c Support Pegasus 3 product
Date: Fri, 10 Jun 2016 10:10:26 +1000
Message-ID: <CAGRGNgWBwBUbnmvBxf_tCkBL-Am+iLzdxWi57xKAbGuvEE1-pg@mail.gmail.com>
References: <1465199633-21182-1-git-send-email-ch1102chiou@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1465199633-21182-1-git-send-email-ch1102chiou@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Charles Chiou <ch1102chiou@gmail.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, linus.chen@tw.promise.com, grace.chang@tw.promise.com, victor.p@promise.com, eva.cheng@tw.promise.com, charles.chiou@tw.promise.com, paul.lyu@tw.promise.com
List-Id: linux-scsi@vger.kernel.org

Hi Charles,

On Mon, Jun 6, 2016 at 5:53 PM, Charles Chiou <ch1102chiou@gmail.com> wrote:
> From: Charles <charles.chiou@tw.promise.com>
>
> Pegasus series is a RAID support product by using Thunderbolt technology.
>
> The newest product, Pegasus 3 is support Thunderbolt 3 technology with another chip.
>
> 1.Change driver version.
>
> 2.Add Pegasus 3 VID, DID and define it's device address.
>
> 3.Pegasus 3 use msi interrupt, so stex_request_irq P3 type enable msi.
>
> 4.For hibernation, use msi_lock in stex_ss_handshake to prevent msi register write again when handshaking.
>
> 5.Pegasus 3 don't need read() as flush.
>
> 6.In stex_ss_intr & stex_abort, P3 only clear interrupt register when getting vendor defined interrupt.
>
> 7.Add reboot notifier and register it in stex_probe for all supported device.
>
> 8.For all supported device in restart flow, we get a callback from notifier and set S6flag for stex_shutdown & stex_hba_stop to send restart command to FW.
>
> Signed-off-by: Charles <charles.chiou@tw.promise.com>
> Signed-off-by: Paul <paul.lyu@tw.promise.com>
> ---
>  drivers/scsi/stex.c | 282 +++++++++++++++++++++++++++++++++++++++-------------
>  1 file changed, 214 insertions(+), 68 deletions(-)
>
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index 5b23175..9de2de2 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -87,7 +95,7 @@ enum {
>         MU_STATE_STOP                           = 5,
>         MU_STATE_NOCONNECT                      = 6,
>
> -       MU_MAX_DELAY                            = 120,
> +       MU_MAX_DELAY                            = 50,

This won't cause problems for older adapters, right?

>         MU_HANDSHAKE_SIGNATURE                  = 0x55aaaa55,
>         MU_HANDSHAKE_SIGNATURE_HALF             = 0x5a5a0000,
>         MU_HARD_RESET_WAIT                      = 30000,
> @@ -540,11 +556,15 @@ stex_ss_send_cmd(struct st_hba *hba, struct req_msg *req, u16 tag)
>
>         ++hba->req_head;
>         hba->req_head %= hba->rq_count+1;
> -
> -       writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
> -       readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
> -       writel(addr, hba->mmio_base + YH2I_REQ);
> -       readl(hba->mmio_base + YH2I_REQ); /* flush */
> +       if (hba->cardtype == st_P3) {
> +               writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
> +               writel(addr, hba->mmio_base + YH2I_REQ);
> +       } else {
> +               writel((addr >> 16) >> 16, hba->mmio_base + YH2I_REQ_HI);
> +               readl(hba->mmio_base + YH2I_REQ_HI); /* flush */
> +               writel(addr, hba->mmio_base + YH2I_REQ);
> +               readl(hba->mmio_base + YH2I_REQ); /* flush */
> +       }

The first writel() lines in each branch of the if statement are
identical, so they could be outside of it.

Would it make sense to add a helper that does the readl() flush only
for non-st_P3? This could be a function pointer in the hba structure
which shouldn't slow stuff down.

>  }
>
>  static void return_abnormal_state(struct st_hba *hba, int status)
> @@ -974,15 +994,31 @@ static irqreturn_t stex_ss_intr(int irq, void *__hba)
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
>
> -       data = readl(base + YI2H_INT);
> -       if (data && data != 0xffffffff) {
> -               /* clear the interrupt */
> -               writel(data, base + YI2H_INT_C);
> -               stex_ss_mu_intr(hba);
> -               spin_unlock_irqrestore(hba->host->host_lock, flags);
> -               if (unlikely(data & SS_I2H_REQUEST_RESET))
> -                       queue_work(hba->work_q, &hba->reset_work);
> -               return IRQ_HANDLED;
> +       if (hba->cardtype == st_yel) {

I note that there's a few different card types beyond sd_yel and
st_P3. Does this function only get called for st_yel and st_P3?

> +               data = readl(base + YI2H_INT);
> +               if (data && data != 0xffffffff) {
> +                       /* clear the interrupt */
> +                       writel(data, base + YI2H_INT_C);
> +                       stex_ss_mu_intr(hba);
> +                       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +                       if (unlikely(data & SS_I2H_REQUEST_RESET))
> +                               queue_work(hba->work_q, &hba->reset_work);
> +                       return IRQ_HANDLED;
> +               }
> +       } else {
> +               data = readl(base + PSCRATCH4);
> +               if (data != 0xffffffff) {
> +                       if (data != 0) {
> +                               /* clear the interrupt */
> +                               writel(data, base + PSCRATCH1);
> +                               writel((1 << 22), base + YH2I_INT);
> +                       }
> +                       stex_ss_mu_intr(hba);
> +                       spin_unlock_irqrestore(hba->host->host_lock, flags);
> +                       if (unlikely(data & SS_I2H_REQUEST_RESET))
> +                               queue_work(hba->work_q, &hba->reset_work);
> +                       return IRQ_HANDLED;
> +               }
>         }
>
>         spin_unlock_irqrestore(hba->host->host_lock, flags);
> @@ -1085,14 +1121,27 @@ static int stex_ss_handshake(struct st_hba *hba)
>         int ret = 0;
>
>         before = jiffies;
> -       while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
> -               if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> -                       printk(KERN_ERR DRV_NAME
> -                               "(%s): firmware not operational\n",
> -                               pci_name(hba->pdev));
> -                       return -1;
> +
> +       if (hba->cardtype == st_yel) {

Same question as above. Does this only get called for st_yel and st_P3?

> +               while ((readl(base + YIOA_STATUS) & SS_MU_OPERATIONAL) == 0) {
> +                       if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> +                               printk(KERN_ERR DRV_NAME
> +                                       "(%s): firmware not operational\n",
> +                                       pci_name(hba->pdev));
> +                               return -1;
> +                       }
> +                       msleep(1);
> +               }
> +       } else if (hba->cardtype == st_P3) {

If it does only get called for st_yel and st_P3, then the if part of
this else-if is redundant.

> +               while ((readl(base + PSCRATCH3) & SS_MU_OPERATIONAL) == 0) {
> +                       if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> +                               printk(KERN_ERR DRV_NAME
> +                                       "(%s): firmware not operational\n",
> +                                       pci_name(hba->pdev));
> +                               return -1;
> +                       }
> +                       msleep(1);
>                 }
> -               msleep(1);
>         }
>
>         msg_h = (struct st_msg_header *)hba->dma_mem;
> @@ -1111,30 +1160,63 @@ static int stex_ss_handshake(struct st_hba *hba)
>         scratch_size = (hba->sts_count+1)*sizeof(u32);
>         h->scratch_size = cpu_to_le32(scratch_size);
>
> -       data = readl(base + YINT_EN);
> -       data &= ~4;
> -       writel(data, base + YINT_EN);
> -       writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
> -       readl(base + YH2I_REQ_HI);
> -       writel(hba->dma_handle, base + YH2I_REQ);
> -       readl(base + YH2I_REQ); /* flush */
> +       if (hba->cardtype == st_yel) {

Same question again.

> +               data = readl(base + YINT_EN);
> +               data &= ~4;
> +               writel(data, base + YINT_EN);
> +               writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
> +               readl(base + YH2I_REQ_HI);
> +               writel(hba->dma_handle, base + YH2I_REQ);
> +               readl(base + YH2I_REQ); /* flush */
> +       } else if (hba->cardtype == st_P3) {
> +               data = readl(base + YINT_EN);
> +               data &= ~(1 << 0);
> +               data &= ~(1 << 2);
> +               writel(data, base + YINT_EN);
> +               if (hba->msi_lock == 0) {
> +                       /* P3 MSI Register cannot access twice */
> +                       writel((1 << 6), base + YH2I_INT);
> +                       hba->msi_lock  = 1;
> +               }
> +               writel((hba->dma_handle >> 16) >> 16, base + YH2I_REQ_HI);
> +               writel(hba->dma_handle, base + YH2I_REQ);
> +       }

The two writel()s at the end of each branch of the if statement are
identical except for the readl() calls to flush the data in the non-P3
case. This would be simplified by adding a helper as discussed above.

> -       scratch = hba->scratch;
>         before = jiffies;
> -       while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
> -               if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> -                       printk(KERN_ERR DRV_NAME
> -                               "(%s): no signature after handshake frame\n",
> -                               pci_name(hba->pdev));
> -                       ret = -1;
> -                       break;
> +
> +       if (hba->cardtype == st_yel) {

Again, is this only called for st_yel and st_P3?

> +               scratch = hba->scratch;
> +
> +               while (!(le32_to_cpu(*scratch) & SS_STS_HANDSHAKE)) {
> +                       if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> +                               printk(KERN_ERR DRV_NAME
> +                                       "(%s): no signature after handshake frame\n",
> +                                       pci_name(hba->pdev));
> +                               ret = -1;
> +                               break;
> +                       }
> +                       rmb();
> +                       msleep(1);
>                 }
> -               rmb();
> -               msleep(1);
> +               memset(scratch, 0, scratch_size);
> +       } else if (hba->cardtype == st_P3) {
> +               while ((readl(base + MAILBOX_BASE + MAILBOX_HNDSHK_STS)
> +                & SS_STS_HANDSHAKE) == 0) {
> +                       if (time_after(jiffies, before + MU_MAX_DELAY * HZ)) {
> +                               printk(KERN_ERR DRV_NAME
> +                                       "(%s): no signature after handshake frame\n",
> +                                       pci_name(hba->pdev));
> +                               ret = -1;
> +                               break;
> +                       }
> +                       rmb();
> +                       msleep(1);
> +               }
> +               memset(hba->scratch, 0, scratch_size);

The memsets at the end of each branch of the if statement are identical.

>         }
>
> -       memset(scratch, 0, scratch_size);
>         msg_h->flag = 0;
> +
>         return ret;
>  }
>
> @@ -1144,7 +1226,7 @@ static int stex_handshake(struct st_hba *hba)
>         unsigned long flags;
>         unsigned int mu_status;
>
> -       err = (hba->cardtype == st_yel) ?
> +       err = (hba->cardtype == st_yel || hba->cardtype == st_P3) ?
>                 stex_ss_handshake(hba) : stex_common_handshake(hba);

This might be cleaner as an if statement.

>         spin_lock_irqsave(hba->host->host_lock, flags);
>         mu_status = hba->mu_status;
> @@ -1197,9 +1288,9 @@ static int stex_abort(struct scsi_cmnd *cmd)
>
>                 writel(data, base + ODBL);
>                 readl(base + ODBL); /* flush */
> -
>                 stex_mu_intr(hba, data);
>         }
> +

Unrelated whitespace change.

>         if (hba->wait_ccb == NULL) {
>                 printk(KERN_WARNING DRV_NAME
>                         "(%s): lost interrupt\n", pci_name(hba->pdev));
> @@ -1502,18 +1620,30 @@ static int stex_request_irq(struct st_hba *hba)
>         struct pci_dev *pdev = hba->pdev;
>         int status;
>
> -       if (msi) {
> +       if (hba->cardtype == st_yel) {

Again, is this only run for st_yel or st_P3?

Why not simplify this to:

-        if (msi) {
+        if (msi || hba->cardtype == st_P3) {

> +               if (msi) {
> +                       status = pci_enable_msi(pdev);
> +                       if (status != 0)
> +                               printk(KERN_ERR DRV_NAME
> +                                       "(%s): error %d setting up MSI\n",
> +                                        pci_name(pdev), status);
> +                       else
> +                               hba->msi_enabled = 1;
> +               } else
> +                       hba->msi_enabled = 0;
> +       } else if (hba->cardtype == st_P3) {
>                 status = pci_enable_msi(pdev);
>                 if (status != 0)
>                         printk(KERN_ERR DRV_NAME
>                                 "(%s): error %d setting up MSI\n",
> -                               pci_name(pdev), status);
> +                                pci_name(pdev), status);
>                 else
>                         hba->msi_enabled = 1;
>         } else
>                 hba->msi_enabled = 0;
>
> -       status = request_irq(pdev->irq, hba->cardtype == st_yel ?
> +       status = request_irq(pdev->irq,
> +               (hba->cardtype == st_yel || hba->cardtype == st_P3) ?
>                 stex_ss_intr : stex_intr, IRQF_SHARED, DRV_NAME, hba);
>
>         if (status != 0) {
> @@ -1546,6 +1676,9 @@ static int stex_probe(struct pci_dev *pdev, const struct pci_device_id *id)
>
>         pci_set_master(pdev);
>
> +       S6flag = 0;
> +       register_reboot_notifier(&stex_notifier);
> +

Adding the reboot notifier applies to all cards, so it should probably
be a separate patch.

>         host = scsi_host_alloc(&driver_template, sizeof(struct st_hba));
>
>         if (!host) {
> @@ -1736,28 +1870,29 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
>
>         spin_lock_irqsave(hba->host->host_lock, flags);
>
> -       if (hba->cardtype == st_yel && hba->supports_pm == 1)
> -       {
> -               if(st_sleep_mic == ST_NOTHANDLED)
> -               {
> +       if ((hba->cardtype == st_yel && hba->supports_pm == 1)
> +               || (hba->cardtype == st_P3 && hba->supports_pm == 1)) {

if ((hba->cardtype == st_yel || hba->cardtype == st_P3) &&
hba->supports_pm == 1) {

is simpler.

> +               if (st_sleep_mic == ST_NOTHANDLED) {
>                         spin_unlock_irqrestore(hba->host->host_lock, flags);
>                         return;
>                 }
>         }
>         req = hba->alloc_rq(hba);
> -       if (hba->cardtype == st_yel) {
> +       if (hba->cardtype == st_yel || hba->cardtype == st_P3) {
>                 msg_h = (struct st_msg_header *)req - 1;
>                 memset(msg_h, 0, hba->rq_size);
>         } else
>                 memset(req, 0, hba->rq_size);
>
> -       if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel)
> +       if ((hba->cardtype == st_yosemite || hba->cardtype == st_yel
> +               || hba->cardtype == st_P3)
>                 && st_sleep_mic == ST_IGNORED) {
>                 req->cdb[0] = MGT_CMD;
>                 req->cdb[1] = MGT_CMD_SIGNATURE;
>                 req->cdb[2] = CTLR_CONFIG_CMD;
>                 req->cdb[3] = CTLR_SHUTDOWN;
> -       } else if (hba->cardtype == st_yel && st_sleep_mic != ST_IGNORED) {
> +       } else if ((hba->cardtype == st_yel || hba->cardtype == st_P3)
> +               && st_sleep_mic != ST_IGNORED) {

Er, this will never get run.

We have:

if (hba->cardtype == st_yosemite || hba->cardtype == st_yel ||
hba->cardtype == st_P3) {
    // stuff
} else if ((hba->cardtype == st_yel || hba->cardtype == st_P3) &&
st_sleep_mic != ST_IGNORED) {
    // stuff
}

Should the two branches of the if statement be reversed or should the
first one be written like:

if (hba->cardtype == st_yosemite || ((hba->cardtype == st_yel ||
hba->cardtype == st_P3) && st_sleep_mic == ST_IGNORED)) {

>                 req->cdb[0] = MGT_CMD;
>                 req->cdb[1] = MGT_CMD_SIGNATURE;
>                 req->cdb[2] = CTLR_CONFIG_CMD;
> @@ -1768,16 +1903,14 @@ static void stex_hba_stop(struct st_hba *hba, int st_sleep_mic)
>                 req->cdb[1] = CTLR_POWER_STATE_CHANGE;
>                 req->cdb[2] = CTLR_POWER_SAVING;
>         }
> -
>         hba->ccb[tag].cmd = NULL;
>         hba->ccb[tag].sg_count = 0;
>         hba->ccb[tag].sense_bufflen = 0;
>         hba->ccb[tag].sense_buffer = NULL;
>         hba->ccb[tag].req_type = PASSTHRU_REQ_TYPE;
> -
>         hba->send(hba, req, tag);
> -       spin_unlock_irqrestore(hba->host->host_lock, flags);
>
> +       spin_unlock_irqrestore(hba->host->host_lock, flags);

More unrelated whitespace changes.

>         before = jiffies;
>         while (hba->ccb[tag].req_type & PASSTHRU_REQ_TYPE) {
>                 if (time_after(jiffies, before + ST_INTERNAL_TIMEOUT * HZ)) {
> @@ -1821,24 +1954,29 @@ static void stex_remove(struct pci_dev *pdev)
>         scsi_host_put(hba->host);
>
>         pci_disable_device(pdev);
> +
> +       unregister_reboot_notifier(&stex_notifier);

Again, not P3 specific.

>  }
>
>  static void stex_shutdown(struct pci_dev *pdev)
>  {
>         struct st_hba *hba = pci_get_drvdata(pdev);
> -
> -       if (hba->supports_pm == 0)
> +       if (hba->supports_pm == 0) {
>                 stex_hba_stop(hba, ST_IGNORED);
> -       else
> +       } else if (hba->supports_pm == 1 && S6flag) {
> +               unregister_reboot_notifier(&stex_notifier);
> +               stex_hba_stop(hba, ST_S6);
> +       } else

Also not P3 specific.

>                 stex_hba_stop(hba, ST_S5);
>  }
>
> -static int stex_choice_sleep_mic(pm_message_t state)
> +static int stex_choice_sleep_mic(struct st_hba *hba, pm_message_t state)
>  {
>         switch (state.event) {
>         case PM_EVENT_SUSPEND:
>                 return ST_S3;
>         case PM_EVENT_HIBERNATE:
> +               hba->msi_lock = 0;
>                 return ST_S4;
>         default:
>                 return ST_NOTHANDLED;
> @@ -1864,6 +2003,13 @@ static int stex_resume(struct pci_dev *pdev)
>         stex_handshake(hba);
>         return 0;
>  }
> +
> +static int stex_halt(struct notifier_block *nb, unsigned long event, void *buf)
> +{
> +       S6flag = 1;
> +       return NOTIFY_OK;
> +}
> +

And again.

Why is this needed?

>  MODULE_DEVICE_TABLE(pci, stex_pci_tbl);
>
>  static struct pci_driver stex_pci_driver = {
> --
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

Thanks,

-- 
Julian Calaby

Email: julian.calaby@gmail.com
Profile: http://www.google.com/profiles/julian.calaby/
