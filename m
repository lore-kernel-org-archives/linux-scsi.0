From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [BUG] 2.6.39.1 crash in scsi_dispatch_cmd()
Date: Wed, 6 Jul 2011 11:25:00 +0200
Message-ID: <20110706092459.GC2580@osiris.boeblingen.de.ibm.com>
References: <20110615112016.GA4227@osiris.boeblingen.de.ibm.com>
 <20110616160155.GB3843@osiris.boeblingen.de.ibm.com>
 <1308242275.2436.56.camel@mulgrave>
 <20110616184023.GA2362@osiris.boeblingen.de.ibm.com>
 <20110620153021.GA2572@osiris.boeblingen.de.ibm.com>
 <CAL1RGDVFR5eYHOX-jiUrU4_Ezw19FzNcCcyo0qKNYictK5He5g@mail.gmail.com>
 <1309547081.2722.33.camel@mulgrave>
 <CAG4TOxM=-8P495xSNvySOhOcKwqCNun99SNmkC1LTUon4jQxXQ@mail.gmail.com>
 <20110706064751.GA2580@osiris.boeblingen.de.ibm.com>
 <CAL1RGDXFER5v08=Wy4Pv7CX0s1RqAThJmEy_0rpDfFCP9xjTJA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.uk.ibm.com ([194.196.100.162]:55122 "EHLO
	mtagate2.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754393Ab1GFJZ0 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Jul 2011 05:25:26 -0400
Received: from d06nrmr1806.portsmouth.uk.ibm.com (d06nrmr1806.portsmouth.uk.ibm.com [9.149.39.193])
	by mtagate2.uk.ibm.com (8.13.1/8.13.1) with ESMTP id p669P1pv017993
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2011 09:25:01 GMT
Received: from d06av06.portsmouth.uk.ibm.com (d06av06.portsmouth.uk.ibm.com [9.149.37.217])
	by d06nrmr1806.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id p669P1sT2699284
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2011 10:25:01 +0100
Received: from d06av06.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av06.portsmouth.uk.ibm.com (8.14.4/8.13.1/NCO v10.0 AVout) with ESMTP id p669P0il012918
	for <linux-scsi@vger.kernel.org>; Wed, 6 Jul 2011 03:25:01 -0600
Content-Disposition: inline
In-Reply-To: <CAL1RGDXFER5v08=Wy4Pv7CX0s1RqAThJmEy_0rpDfFCP9xjTJA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Jens Axboe <jaxboe@fusionio.com>, linux-scsi@vger.kernel.org, Steffen Maier <maier@linux.vnet.ibm.com>, "Manvanthara B. Puttashankar" <manvanth@linux.vnet.ibm.com>, Tarak Reddy <tarak.reddy@in.ibm.com>, "Seshagiri N. Ippili" <sesh17@linux.vnet.ibm.com>, Alan Stern <stern@rowland.harvard.edu>, dm-devel@redhat.com, Alasdair G Kergon <agk@redhat.com>

On Wed, Jul 06, 2011 at 01:06:44AM -0700, Roland Dreier wrote:
>  > > I booted with slub_debug=FZUP and the 6b pattern in RAX pretty much
>  > > does prove that this is a use-after-free issue.  Any thoughts about
>  > > how to pin this down before I muddle on in my lowbrow way?
>  >
>  > Alan Stern came up with a patch that could fix this:
>  >
>  > http://marc.info/?l=linux-kernel&m=130963676907731&w=2
> 
> Thanks!  It seems my crash is actually a different problem (or perhaps
> the same problem in different code), since I'm not going through SCSI
> directly but rather a dm-multipath device on top of SCSI disks.  But
> it does seem that it is another case of the block queue elevator
> getting freed while requests can still be submitted.
> 
> In my case, to reproduce this I have to hold the multipath device file
> open with something like "cat > /dev/dm-X" and then kill the
> underlying drive.  What I think is happening (although I haven't
> traced all the layers to be sure) is that then the multipath daemon
> notices that all the paths to the disk are lost and tries to kill the
> multipath device, which ends up in dm.c:dm_destroy().
> 
> This ends up in blk_cleanup_queue() which frees q->elevator, which of
> course leads to the crash.

So it's the identical crash that I reported also (well, at least one of
the crashes I reported).

> What's not clear to me is how things are supposed to work.  It seems
> that the dm stuff at least is missing a lot of required reference
> counting, to make sure that some structure sticks around to reject IOs
> to the device after it is destroy but while it is still open.  But I
> don't understand why people don't hit this more since it is completely
> reproducible for me with a fairly normal setup (hot-remove a multipath
> device that some process has open).

cc'ing Alasdair as well, maybe he knows...

> Alan Stern's patch looks a bit fishy -- the scsi_free_queue() is moved
> earlier than the
> 
> 	/* cause the request function to reject all I/O requests */
> 	sdev->request_queue->queuedata = NULL;
> 
> which seems to leave a small window where the use-after-free can
> happen, and it's not clear to me why the scsi_free_queue() has to move
> at all.
> 
> Thanks,
>  - R.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
