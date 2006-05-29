From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Asynchronous scsi scanning, version 9
Date: Mon, 29 May 2006 07:05:15 -0600
Message-ID: <20060529130515.GE23405@parisc-linux.org>
References: <20060511143352.GI12272@parisc-linux.org> <20060518172258.GL1604@parisc-linux.org> <20060529031915.GB23405@parisc-linux.org> <447AB2F5.2000700@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:24984 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1750785AbWE2NFQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 May 2006 09:05:16 -0400
Content-Disposition: inline
In-Reply-To: <447AB2F5.2000700@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi@vger.kernel.org

On Mon, May 29, 2006 at 10:38:13AM +0200, Stefan Richter wrote:
> Matthew Wilcox wrote:
> > Add the scsi_mod.scan kernel parameter to determine how scsi busses
> > are scanned.  "sync" is the current behaviour.  "none" punts scanning
> > scsi busses to userspace.  "async" is the new default.
> 
> This parameter is only relevant with LLDDs which use scsi_scan_host, right?

Not entirely.  If you set it to "none", scsi_scan_target() also returns
without doing anything.  If you use the scsi_prep_async_scan() and
scsi_finish_async_scan() API, you can also use this infrastructure to
make scanning sbp2 synchronised with other scsi hosts.  Then the setting
of sync vs async also triggers old vs new behaviour.

> Furthermore, "sync|async" basically means "serialized|parallelized
> across host adapters". Does it also mean "finishing before|after driver
> initialization"? (With LLDDs which use scsi_scan_host.)

That's what scsi_complete_async_scans() is for.  If you have a built-in
module, it will wait for the async scans to finish before we get as far
as trying to mount root.  It does change observable behaviour in that
sys_module_init() will return before scans are complete.  However, I
believe most distros userspace copes with this these days.  For example,
Debian has:

    # wait for the udevd childs to finish
    log_action_begin_msg "Waiting for /dev to be fully populated"
    while [ -d /dev/.udev/queue/ ]; do
        sleep 1
        udevd_timeout=$(($udevd_timeout - 1))
[...]

Since the scsi scan is going to be finding new devices the entire time,
the queue directory is going to not empty.

> ...
> > --- ./include/scsi/scsi_host.h	27 May 2006 15:58:17 -0000	1.27.2.1
> > +++ ./include/scsi/scsi_host.h	19 May 2006 02:43:19 -0000	1.27
> > @@ -541,6 +541,9 @@ struct Scsi_Host {
> >  	 */
> >  	unsigned ordered_tag:1;
> >  
> > +	/* Are we currently performing an async scan? */
> 
> Perhaps add "private to scsi core" to the comment.

Sure, good idea.

> > +	unsigned async_scan:1;
> 
> This flag is written under protection of async_scan_lock but read
> without lock protection and without being an atomic variable. Is this
> safe? I suppose it is as long as scan methods (by do_scan_async kthread,
> by another thread associated to the LLDD or transport, by userspace) are
> not mixed.

Hmmm.  It looks to me like there's some really narrow windows where
it's unsafe.  For example, drivers call scsi_add_host() which makes it
visible to userspace.  Then userspace could ask to scan something before
the driver calls scsi_scan_host(), get past the check for async_scan,
then the other thread sets async_scan, so when the first thread calls
scsi_add_lun(), it then doesn't add the lun to sysfs.  Actually, this
one's safe because it'll get added by the second thread when it completes.

I've looked some more and there are other races, but I can't see one
which results in a double-add or a failed add.  Can anyone see one?
