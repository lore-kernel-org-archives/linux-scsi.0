From: Greg KH <gregkh@linuxfoundation.org>
Subject: Re: [PATCH 2/7] Revert "usb/uas: one only one status URB/host on
 stream-less connection"
Date: Mon, 25 Jun 2012 11:49:50 -0700
Message-ID: <20120625184950.GA16794@kroah.com>
References: <1340092494-18876-1-git-send-email-kraxel@redhat.com>
 <1340092494-18876-3-git-send-email-kraxel@redhat.com>
 <20120620235644.GD31520@kroah.com>
 <4FE2DE31.6030006@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pz0-f46.google.com ([209.85.210.46]:42920 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754760Ab2FYSty (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jun 2012 14:49:54 -0400
Received: by dady13 with SMTP id y13so5701168dad.19
        for <linux-scsi@vger.kernel.org>; Mon, 25 Jun 2012 11:49:54 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <4FE2DE31.6030006@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gerd Hoffmann <kraxel@redhat.com>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 10:41:21AM +0200, Gerd Hoffmann wrote:
> On 06/21/12 01:56, Greg KH wrote:
> > On Tue, Jun 19, 2012 at 09:54:49AM +0200, Gerd Hoffmann wrote:
> >> This reverts commit ceb3f91fd53c9fbd7b292fc2754ba4efffeeeedb.
> >>
> >> IMO the real bug is assigning status urbs to scsi requests.  First there
> >> is no such link in the non-stream case.  Also there isn't nessesarely a
> >> scsi request in the first place, for example when submitting task
> >> management requests.
> >>
> >> This patch just papers over the real bug and introduces different status
> >> urb handling in the stream/non-stream case for no good reason.
> >>
> >> Signed-off-by: Gerd Hoffmann <kraxel@redhat.com>
> >> ---
> >>  drivers/usb/storage/uas.c |   70 ++++++--------------------------------------
> >>  1 files changed, 10 insertions(+), 60 deletions(-)
> > 
> > Same here, should this also be reverted in 3.4-stable?
> 
> Well, even though the reverted patch is clumsy and takes the wrong
> direction, it actually does the job and fixes the issue at hand.
> 
> When reverting in stable patch #3 of this series (which fixes the issue
> in a better way) must be cherry-picked into stable too, otherwise we'll
> get a regression.
> 
> I'd tend to not revert this one in stable though.

Ok, thanks, I'll not revert it in staging.

greg k-h
