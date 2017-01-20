From: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Subject: Re: [PATCH v2 3/4] mpt3sas: Fix Firmware fault state 0x2100 during
 heavy 4K RR FIO stress test.
Date: Fri, 20 Jan 2017 21:44:04 +0530
Message-ID: <CAK=zhgrDrLy3qBG_ZWJ_pGh9rJwJa2QM14C73hDMyuR1O3e05A@mail.gmail.com>
References: <1484923333-8509-1-git-send-email-chaitra.basappa@broadcom.com>
 <1484923333-8509-4-git-send-email-chaitra.basappa@broadcom.com> <20170120151036.GD9315@linux-x5ow.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170120151036.GD9315@linux-x5ow.site>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Chaitra P B <chaitra.basappa@broadcom.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <Sathya.Prakash@broadcom.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Krishnaraddi Mankani <krishnaraddi.mankani@broadcom.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

On Fri, Jan 20, 2017 at 8:40 PM, Johannes Thumshirn <jthumshirn@suse.de> wr=
ote:
> On Fri, Jan 20, 2017 at 08:12:12PM +0530, Chaitra P B wrote:
>> Due existence of loop in the IO path our HBA will receive heavy IOs and
>> also as driver is not updating the Reply Post Host Index frequently, So
>> there will be a high chance that our Firmware unable to find any free en=
try
>> in the Reply Post Descriptor Queue (i.e. Queue overflow occurs) and can
>> observe 0x2100 firmware fault.
>> So to fix this, we have defined a thresh hold value. After continuously
>> processing this thresh hold number of reply descriptors driver will upda=
te
>> the Reply Descriptor Host Index so that this thresh hold number of reply
>> descriptors entries will be freed and these entries will be available fo=
r
>> firmware and we won't observe this Firmware fault. We have defined this
>> threshold value as 1/3rd of the hba queue depth.
>>
>> Signed-off-by: Chaitra P B <chaitra.basappa@broadcom.com>
>> Signed-off-by: Suganath Prabu S <suganath-prabu.subramani@broadcom.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c |   19 +++++++++++++++++++
>>  1 files changed, 19 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/=
mpt3sas_base.c
>> index 722fab9..a3fe1fb 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -1040,6 +1040,25 @@ _base_interrupt(int irq, void *bus_id)
>>                   reply_q->reply_post_free[reply_q->reply_post_host_inde=
x].
>>                   Default.ReplyFlags & MPI2_RPY_DESCRIPT_FLAGS_TYPE_MASK=
;
>>               completed_cmds++;
>> +             /* Update the reply post host index after continuously
>> +              * processing the threshold number of Reply Descriptors.
>> +              * So that FW can find enough entries to post the Reply
>> +              * Descriptors in the reply descriptor post queue.
>> +              */
>> +             if (completed_cmds > ioc->hba_queue_depth/3) {
>> +                     if (ioc->combined_reply_queue) {
>> +                             writel(reply_q->reply_post_host_index |
>> +                                             ((msix_index  & 7) <<
>> +                                              MPI2_RPHI_MSIX_INDEX_SHIF=
T),
>> +                                 ioc->replyPostRegisterIndex[msix_index=
/8]);
>> +                     } else {
>> +                             writel(reply_q->reply_post_host_index |
>> +                                             (msix_index <<
>> +                                              MPI2_RPHI_MSIX_INDEX_SHIF=
T),
>> +                                             &ioc->chip->ReplyPostHostI=
ndex);
>> +                     }
>> +                     completed_cmds =3D 1;
>> +             }
>>               if (request_desript_type =3D=3D MPI2_RPY_DESCRIPT_FLAGS_UN=
USED)
>>                       goto out;
>>               if (!reply_q->reply_post_host_index)
>
> Do I understand it correctly that you fill the HBA's internal queue up to=
 a
> 3rd and then kick it to start processing?

No, driver will continuously process the reply descriptors from Reply
Descriptor Post Queue (RDPQ) but will update it's Host Index (tail
index) with the firmware after continuously processing 1/3rd of the
HBA queue depth number of descriptors instead of updating it's host
index only at after it see unused descriptor entry. So that firmware
can always get enough free descriptors entries to post reply
descriptors and won't see any 0x2100 fault which will occur if
firmware doesn't find any free descriptor entry in the  RDPQ queue.

Thanks,
Sreekanth

>
> Thanks,
>         Johannes
> --
> Johannes Thumshirn                                          Storage
> jthumshirn@suse.de                                +49 911 74053 689
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: Felix Imend=C3=B6rffer, Jane Smithard, Graham Norton
> HRB 21284 (AG N=C3=BCrnberg)
> Key fingerprint =3D EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
