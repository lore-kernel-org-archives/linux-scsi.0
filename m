From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Linux 2.6.38-rc4 (target_core: rmmod GP fault)
Date: Wed, 09 Feb 2011 12:44:45 -0800
Message-ID: <1297284285.18212.71.camel@haakon2.linux-iscsi.org>
References: <AANLkTimmb26UiBSukdNnVdxLJpCGd=QqpCw8vQoHALh-@mail.gmail.com>
	 <20110209092851.bba6c40c.randy.dunlap@oracle.com>
	 <AANLkTikvGppAi1JCGY1vjAugzpk3g5rDriBjc8k6M9Qg@mail.gmail.com>
	 <1297281744.18212.44.camel@haakon2.linux-iscsi.org>
	 <1297282433.3016.43.camel@mulgrave.site>
	 <1297282835.18212.57.camel@haakon2.linux-iscsi.org>
	 <1297283335.3016.48.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1297283335.3016.48.camel@mulgrave.site>
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Randy Dunlap <randy.dunlap@oracle.com>, Joel Becker <jlbec@evilplan.org>, scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2011-02-09 at 14:28 -0600, James Bottomley wrote:
> On Wed, 2011-02-09 at 12:20 -0800, Nicholas A. Bellinger wrote:
> > On Wed, 2011-02-09 at 14:13 -0600, James Bottomley wrote:
> > > Firstly, could we get the serious bug fixes identified and separated
> > > from the general enhancement updates, so they can go in a fixes tree
> > > without depending on enhancements?  The former category would include
> > > the /proc interface removal, since we don't want the legacy interface to
> > > be in a released kernel.
> > > 
> > 
> > Everything in those two series should be considered bug fixes and
> > immediate for-38 mainline material.
> 
> Things like this:
> 
> target: remove EXTRA_CFLAGS
> target: Remove unnecessary container_of() pointer check
> target: Remove unnecessary se_clear_dev_ports legacy code
> target: Remove spurious double cast from structure macro accessors
> target: Convert TMR REQ/RSP definitions to target namespace

This is an important one, as using w/o TMR_* prefixed definitions for
task management response/response defs, we run into problems with
existing include/scsi/scsi.h message codes.

> target: Minor sparse warning fixes and annotations
> target: Remove unneeded test of se_cmd
> 
> Are not serious bug fixes.  I could go either way on some of the error path changes.
> 

Yes, these others are minor items that have been submitted by people
(hch, roland, jesper, danc) who have been reviewing target code since it
was merged for .38-rc1.

Considering how minor these are I would prefer to have these merged,
than deferring for-39.  If not, then I will need to respin tree w/o
their cleanups if what you prefer to be sent to Linus for-38, there are
3 other bugfix patches in the upstream LIO tree that I have been saving
for-38-rc5 since for-38-rc4 was cut(considering the two outstanding
series).  I would like to have these included as well.

Do you want me to send them all to the linux-scsi list again...?

--nab

  



> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
