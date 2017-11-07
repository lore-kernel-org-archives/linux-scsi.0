From: Tejun Heo <tj@kernel.org>
Subject: Re: [ata_scsi_offline_dev] BUG: sleeping function called from
 invalid context at kernel/locking/mutex.c:238
Date: Mon, 6 Nov 2017 16:12:07 -0800
Message-ID: <20171107001207.GH3252168@devbig577.frc2.facebook.com>
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
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+55aFy+ok0wvjCmf4gPr+TSUHTs8i42APx=xmi1RnZN=0nFkg@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, IDE-ML <linux-ide@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Johannes Thumshirn <jthumshirn@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@hansenpartnership.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Nov 06, 2017 at 03:12:31PM -0800, Linus Torvalds wrote:
> But it does seem to be a new regression in 4.14, caused by commit
> 8a97712e5314 ("scsi: make 'state' device attribute pollable"), because
> that's what added the sysfs_notify() call to scsi_device_set_state(),
> which made that spinlock be a problem.

Yeah, pinged Hannes about it a couple of weeks ago.

> That commit came in through the SCSI merge this merge window, and it
> seems to still revert cleanly.
> 
> So I do suspect that by now we should just revert that commit. It's
> not clear why that state attribute should be pollable, and the new
> code is clearly very much buggy.

I think reverting is the right thing to do right now.  If necessary,
we can make kernfs_notify() safe to be called from atomic contexts.

Thanks.

-- 
tejun
