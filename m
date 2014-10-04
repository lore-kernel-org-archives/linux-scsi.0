From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v2 2/2] uas: Make uas work with blk-mq
Date: Sat, 04 Oct 2014 07:46:21 -0700
Message-ID: <1412433981.21548.6.camel@jarvis.lan>
References: <1412330937-22630-1-git-send-email-hdegoede@redhat.com>
	 <1412330937-22630-2-git-send-email-hdegoede@redhat.com>
	 <20141003214712.GA3579@kroah.com> <542FB590.4030902@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39564 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750857AbaJDOqX (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Oct 2014 10:46:23 -0400
In-Reply-To: <542FB590.4030902@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Christoph Hellwig <hch@infradead.org>, Douglas Gilbert <dgilbert@interlog.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Sat, 2014-10-04 at 10:53 +0200, Hans de Goede wrote:
> Hi,
> 
> On 10/03/2014 11:47 PM, Greg Kroah-Hartman wrote:
> > On Fri, Oct 03, 2014 at 12:08:57PM +0200, Hans de Goede wrote:
> >> With uas over usb-3 the tags inside the uas iu-s must match the usb-3 stream
> >> ids, and those go from 1 - qdepth.
> >>
> >> Before blk-mq calling scsi_activate_tcq(sdev, qdepth) guaranteed that we would
> >> only get cmnd->request->tag from 0 - (qdepth - 1), and we used those as
> >> uas-tags / stream-ids.
> >>
> >> With blk-mq however we are guaranteed to never get more then qdepth commands
> >> queued at the same time, but the cmnd->request->tag values may be much larger,
> >> which breaks uas.
> >>
> >> This commit fixes this by generating uas tags in the 1 - qdepth range ourselves
> >> instead of using cmnd->request->tag.
> >>
> >> While touching all involved code anyways also rename the uas_cmd_info stream
> >> field to uas_tag, because when using uas over usb-2 streams are not used.
> >>
> >> Cc: Christoph Hellwig <hch@infradead.org>
> >> Reported-by: Douglas Gilbert <dgilbert@interlog.com>
> >> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> > 
> > This doesn't apply to my usb-next branch of usb.git, care to refresh it
> > and resend?
> 
> I did this v2 to resolve a conflict with a last minute fix for 3.17 which
> James Bottomley pushed out yesterday. So if this does not apply that likely
> is because that fix is not (yet) in next. See:
> 
> https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/log/?h=fixes
> 
> And specifically:
> 
> https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git/commit/?h=fixes&id=2c2d831c81ec75a7b0d8e28caa8e3d9c1fe546f9
> 
> I'm not sure how to proceed here, maybe the best thing is to cherry pick
> that fix into usb-next (should disappear on merge), and then apply
> this one on top ?

Depends:  The fixes tree is based on -rc1, so you could just use that as
the base for the topic branch uas goes in.  That's the usual way.  Or we
could just do it via the SCSI tree, which will have the necessary base.

Which would you prefer?

James


