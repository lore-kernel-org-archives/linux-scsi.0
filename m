From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 18:38:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040929183858.A15586@infradead.org>
References: <415A67B8.2080003@suse.de> <20040929130332.A11785@infradead.org> <415AAB0F.2080802@suse.de> <20040929171251.GA5368@us.ibm.com> <1096478376.2123.32.camel@mulgrave> <20040929182204.A15308@infradead.org> <20040929173642.GB5368@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:48900 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S268755AbUI2RjD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 13:39:03 -0400
Content-Disposition: inline
In-Reply-To: <20040929173642.GB5368@us.ibm.com>; from andmike@us.ibm.com on Wed, Sep 29, 2004 at 10:36:42AM -0700
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>, Alan Stern <stern@rowland.harvard.edu>

On Wed, Sep 29, 2004 at 10:36:42AM -0700, Mike Anderson wrote:
> Christoph Hellwig [hch@infradead.org] wrote:
> > On Wed, Sep 29, 2004 at 01:19:28PM -0400, James Bottomley wrote:
> > > On Wed, 2004-09-29 at 13:12, Mike Anderson wrote:
> > > > We may want to reconsider a method to distinguish unexpected removals
> > > > from clean removals.
> > > 
> > > Technically we have this: it's the recovery flag to scsi_host_cancel(). 
> > > Unfortunately, scsi_remove_host doesn't have such a flag so it's always
> > > set to zero at the moment.
> > 
> > and ->remove for the bus drivers doesn't know either, so adding such
> > a flag wouldn't help us much.
> 
> In some cases the knowledge would be in the driver would it not. When the
> drivers remove function is called the driver knows the state of the
> transport or in the case of the usb storage device it knows it will
> not process anymore commands. 
> 
> Alan / Matthew / others can correct if I have mis-read something in
> usb_stor_release_resources but it knows that it will not process anymore
> commands prior to calling scsi_remove_host so if we had a method to flag
> this it would help in our shutdown if we want to support both devices
> that can and cannot process commands.

Well, we're certainly not going to change the scsi_remove_host signature,
but we could add a separate one.

But I don't like that change at all as we would still have that problem
with all driver that don't have a way to magically find out.  We should
really try to make scsi_remove_host foolprof.

