From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH RESEND 0/3] scsi: fix internal write cache issue on usb
 hdd.
Date: Tue, 17 Jul 2012 08:46:53 -0700
Message-ID: <20120717154653.GF16283@kroah.com>
References: <1341716685-6631-1-git-send-email-linkinjeon@gmail.com>
 <20120716234805.GA9875@kroah.com>
 <1342509554.3039.4.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-gh0-f174.google.com ([209.85.160.174]:64962 "EHLO
	mail-gh0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752168Ab2GQPq7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 11:46:59 -0400
Received: by ghrr11 with SMTP id r11so516148ghr.19
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jul 2012 08:46:58 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <1342509554.3039.4.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Namjae Jeon <linkinjeon@gmail.com>, mdharm-usb@one-eyed-alien.net, stern@rowland.harvard.edu, sshtylyov@mvista.com, bvanassche@acm.org, akpm@linux-foundation.org, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Namjae Jeon <namjae.jeon@samsung.com>

On Tue, Jul 17, 2012 at 08:19:14AM +0100, James Bottomley wrote:
> On Mon, 2012-07-16 at 16:48 -0700, Greg KH wrote:
> > On Sat, Jul 07, 2012 at 11:04:45PM -0400, Namjae Jeon wrote:
> > > From: Namjae Jeon <namjae.jeon@samsung.com>
> > > 
> > > The numbers of USB HDDs(All USB HDD I checked) does not respond
> > > correctly to scsi mode sense command for retrieving the write cache
> > > page status. Even though write cache is enabled by default, due to
> > > scsi driver assume that cache is not enabled which in turn might lead
> > > to loss of data since data still will be in cache.
> > > This result that all filesystems is not stable on USB HDD when the
> > > device is unplugged abruptly, even though these are having journaling
> > > feature. Our first trying is that scsi driver send ATA command
> > > (ATA Pass through, #85) to USB HDD after failure from normal routine to
> > > know write cache enable.
> > > We have known it is dangerous after testing several USB HDD. some of
> > > HDD is stalled by this command(A-DATA HDD). So we tried to make the
> > > patch James Bottomley's suggestion(usb quirk) on version 2 that add
> > > product ID and verdor ID of USB HDD to USB quirk list after checking
> > > write cache.
> > > All filesystem will be stable on USB HDD registered in quirk list.
> > > And it will be updated continuously.
> > 
> > Now applied to the usb-next branch.
> 
> It's been in scsi#misc for ten days with no problems.  Lets leave it
> there rather than create merge and rebase issues.

No need for rebasing.  It's already in my tree, so we can handle the
merge when this hits Linus's tree.

thanks,

greg k-h
