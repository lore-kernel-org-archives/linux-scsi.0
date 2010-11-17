From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libata: remove unlock+relock cycle in ata_scsi_queuecmd
Date: Wed, 17 Nov 2010 10:11:16 -0600
Message-ID: <1290010276.4736.51.camel@mulgrave.site>
References: <20101117062958.GA2894@havoc.gtf.org>
	 <AANLkTikQysiwSV_m38vKaEuPQ=NH10o2s69d=aNGOhLr@mail.gmail.com>
	 <4CE38D70.4010507@garzik.org> <1290007719.4736.9.camel@mulgrave.site>
	 <20101117154741.GA16768@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20101117154741.GA16768@infradead.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Jeff Garzik <jeff@garzik.org>, Linus Torvalds <torvalds@linux-foundation.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>, Tejun Heo <tj@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2010-11-17 at 10:47 -0500, Christoph Hellwig wrote:
> > Right ... I couldn't persuade anyone else to do it, so I'll probably end
> > up coding it.  It looks like the serial number zero check might be
> > bogus.  If so I'll remove it, then push the serial number acquisition
> > down only into the locked queuecommand of only those drivers that
> > actually use it (which were listed in the quoted email, and which might
> > have a big impetus to remove it if the use is trivial).  Then we can
> > begin unwinding the locking.
> 
> In dc395x, eata_pio, in2000, lpfc, megaraid_legacy, megaraid_mbox,
> megaraid_sas, mesh, ncr53c8xx, qla1280, qla4xxx, wd33c93 and i2o_scsi
> use it in printks only, and all this can be safely removed.
> 
> Except for EH that only leaves dpt_i2o, eata, mpt2sas, u14-34f, mptscsi
> as non-trivial users.  If you sort out the EH side I'll volunteer to
> kill the printks and add private serial numbers to the five drivers
> mentioned above.

You're on (you were cc'd on the patch) ... I was planning just to move
the scsi_cmnd_get_serial() call into the locked queuecommand routine,
but a more permanent solution might be better.

James
