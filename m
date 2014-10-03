From: Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>
Subject: Re: [PATCH v2 2/2] uas: Make uas work with blk-mq
Date: Fri, 3 Oct 2014 14:47:12 -0700
Message-ID: <20141003214712.GA3579@kroah.com>
References: <1412330937-22630-1-git-send-email-hdegoede@redhat.com>
 <1412330937-22630-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <1412330937-22630-2-git-send-email-hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Fri, Oct 03, 2014 at 12:08:57PM +0200, Hans de Goede wrote:
> With uas over usb-3 the tags inside the uas iu-s must match the usb-3 stream
> ids, and those go from 1 - qdepth.
> 
> Before blk-mq calling scsi_activate_tcq(sdev, qdepth) guaranteed that we would
> only get cmnd->request->tag from 0 - (qdepth - 1), and we used those as
> uas-tags / stream-ids.
> 
> With blk-mq however we are guaranteed to never get more then qdepth commands
> queued at the same time, but the cmnd->request->tag values may be much larger,
> which breaks uas.
> 
> This commit fixes this by generating uas tags in the 1 - qdepth range ourselves
> instead of using cmnd->request->tag.
> 
> While touching all involved code anyways also rename the uas_cmd_info stream
> field to uas_tag, because when using uas over usb-2 streams are not used.
> 
> Cc: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
> Reported-by: Douglas Gilbert <dgilbert-qazKcTl6WRFWk0Htik3J/w@public.gmane.org>
> Signed-off-by: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
> Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>

This doesn't apply to my usb-next branch of usb.git, care to refresh it
and resend?

thanks,

greg k-h
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
