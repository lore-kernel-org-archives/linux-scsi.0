From: dingxiang <dingxiang@huawei.com>
Subject: Re: [PATCH V2 resend] libata:fix kernel panic when hotplug
Date: Wed, 22 Jun 2016 14:46:24 +0800
Message-ID: <576A3440.9090803@huawei.com>
References: <1466052340-25520-1-git-send-email-dingxiang@huawei.com>
 <20160616202045.GF3262@mtj.duckdns.org> <yq160t35oas.fsf@sermon.lab.mkp.net>
 <CAPcyv4hnzAoiPQNHD_6C74exQrDQGaGG-fRw8XAAkj80bv5nqg@mail.gmail.com>
 <20160621154700.GH3262@mtj.duckdns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20160621154700.GH3262@mtj.duckdns.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tejun Heo <tj@kernel.org>, Dan Williams <dan.j.williams@intel.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, jejb@linux.vnet.ibm.com, Wei Fang <fangwei1@huawei.com>, miaoxie@huawei.com, wangyijing@huawei.com, zhangaihua1@huawei.com, zhaohongjiang@huawei.com, houtao1@huawei.com, linux-scsi <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


Hi,All
> Hello,
>
> On Mon, Jun 20, 2016 at 06:46:55PM -0700, Dan Williams wrote:
>> On Mon, Jun 20, 2016 at 6:22 PM, Martin K. Petersen
>> <martin.petersen@oracle.com> wrote:
>>>>>>>> "Tejun" == Tejun Heo <tj@kernel.org> writes:
>>>>> In fact,we don't need libata to deal with hotplug in sas environment.
>>>>> So we can't run ata hotplug task when ata port is sas host.
>>> Tejun> Martin, can you please confirm whether the above is true.  If so,
>>> Tejun> I'll route the patch through libata w/ stable cc'd.
>>>
>>> Not exactly a libsas expert. James? Dan?
>> While it is true that libsas itself handles adding / removing devices
>> we have historically avoided this conflict because
>> ATA_PFLAG_SCSI_HOTPLUG is never set for libsas ata_ports.  So the bug
>> / behavior change is that  ATA_PFLAG_SCSI_HOTPLUG gets set in the
>> first place.  Ignoring it is a band-aid / not the real fix afaics.
> I see.  I'll hold off for now then.  Ding Xiang, can you find out
> where that flag is getting set?
>
> Thanks!
There are two places will set flag ATA_PFLAG_SCSI_HOTPLUG in libata-eh.c.
I think both places should  be protected. Here is the suggestion.
Thanks~

diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
index 61dc7a9..2bee041 100644
--- a/drivers/ata/libata-eh.c
+++ b/drivers/ata/libata-eh.c
@@ -1385,7 +1385,8 @@ void ata_eh_detach_dev(struct ata_device *dev)

         if (ata_scsi_offline_dev(dev)) {
                 dev->flags |= ATA_DFLAG_DETACHED;
-               ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
+               if (!(ap->pflags & ATA_FLAG_SAS_HOST))
+                       ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
         }

         /* clear per-dev EH info */
@@ -3299,7 +3300,8 @@ static int ata_eh_revalidate_and_attach(struct 
ata_link *link,
                 }

                 spin_lock_irqsave(ap->lock, flags);
-               ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
+               if (!(ap->pflags & ATA_FLAG_SAS_HOST))
+                       ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
                 spin_unlock_irqrestore(ap->lock, flags);

                 /* new device discovered, configure xfermode */
