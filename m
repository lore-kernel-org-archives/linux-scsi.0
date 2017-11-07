From: Hannes Reinecke <hare@suse.de>
Subject: Re: [ata_scsi_offline_dev] BUG: sleeping function called from invalid
 context at kernel/locking/mutex.c:238
Date: Tue, 7 Nov 2017 07:55:45 +0100
Message-ID: <f932a4c8-639a-b7ef-d377-851a4498f557@suse.de>
References: <CA+55aFxSJGeN=2X-uX-on1Uq2Nb8+v1aiMDz5H1+tKW_N5Q+6g@mail.gmail.com>
 <20171029225155.qcum5i75awrt5tzm@wfg-t540p.sh.intel.com>
 <20171029231835.3725fnd5yehlmqob@wfg-t540p.sh.intel.com>
 <20171030110511.scfrdtlnf5lbdhu5@pd.tnic>
 <CA+55aFy2c88wKndjRAds-3MZ+MsArGBySOog+Rxmd2AciGFGkA@mail.gmail.com>
 <CA+55aFwW7sbguREtVzKAUkNGb4cGh_eADqkEYcUurX5xS60_ww@mail.gmail.com>
 <526e7cf2-0672-e44b-c32f-26128a2dfd37@codeaurora.org>
 <20171106224635.qopgsszwxzuitkpf@wfg-t540p.sh.intel.com>
 <20171106225354.6ucl4f4ipsjlntzl@wfg-t540p.sh.intel.com>
 <CA+55aFy+ok0wvjCmf4gPr+TSUHTs8i42APx=xmi1RnZN=0nFkg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <CA+55aFy+ok0wvjCmf4gPr+TSUHTs8i42APx=xmi1RnZN=0nFkg@mail.gmail.com>
Content-Language: en-US
Sender: linux-ide-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>, Fengguang Wu <fengguang.wu@intel.com>
Cc: IDE-ML <linux-ide@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Tejun Heo <tj@kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

On 11/07/2017 12:12 AM, Linus Torvalds wrote:
> On Mon, Nov 6, 2017 at 2:53 PM, Fengguang Wu <fengguang.wu@intel.com> wrote:
>>
>> The same dmesg happen to contain another libata related bug. Attached again.
>> It's rare and in the error handling path, so unlikely a new regression.
>>
>> [   49.608280] BUG: sleeping function called from invalid context at kernel/locking/mutex.c:238
>> [   49.647821]  mutex_lock+0x20/0x50
>> [   49.651443]  kernfs_find_and_get_ns+0x23/0x60
>> [   49.656104]  sysfs_notify+0x77/0x90
>> [   49.659900]  scsi_device_set_state+0x63/0x150
>> [   49.664559]  ata_scsi_offline_dev+0x1c/0x30 [libata]
>> [   49.669817]  ata_eh_detach_dev+0x3b/0xb0 [libata]
> 
> ata_eh_detach_dev() does
> 
>         spin_lock_irqsave(ap->lock, flags);
> 
> and then does
> 
>         if (ata_scsi_offline_dev(dev)) {
>                 dev->flags |= ATA_DFLAG_DETACHED;
>                 ap->pflags |= ATA_PFLAG_SCSI_HOTPLUG;
>         }
> 
> inside that spinlock. And this code is not new - it has done it since
> 2006 or so.
> 
> But it does seem to be a new regression in 4.14, caused by commit
> 8a97712e5314 ("scsi: make 'state' device attribute pollable"), because
> that's what added the sysfs_notify() call to scsi_device_set_state(),
> which made that spinlock be a problem.
> 
> That commit came in through the SCSI merge this merge window, and it
> seems to still revert cleanly.
> 
> So I do suspect that by now we should just revert that commit. It's
> not clear why that state attribute should be pollable, and the new
> code is clearly very much buggy.
> 
> Hannes, Martin?
> 
Seeing the complexity involved, yes, please revert that.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: F. Imendörffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG Nürnberg)
