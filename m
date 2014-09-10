From: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Subject: Re: [REGRESSION 3.17] scsi (uas) disks no longer using tagged
 command queuing
Date: Wed, 10 Sep 2014 08:45:35 -0700
Message-ID: <20140910154535.GA5102@infradead.org>
References: <540EC52C.3000804@redhat.com>
 <20140909152730.GA17882@infradead.org>
 <540FFBF4.9090001@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <540FFBF4.9090001-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-usb <linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, SCSI development list <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Linux Kernel Mailing List <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Sep 10, 2014 at 09:21:24AM +0200, Hans de Goede wrote:
> I've applied the patch, this results in the following new dmesg output
> when using uas:
> 
> [  120.602632] initialized host-wide tag map!
> 
> Thank you for looking into this.

So we're initializing the tag map, but scsi_activate_tcq doesn't pick it
up.  I can't really come up with a good explanation for it, but there
even without that there is an elephant in the room:  as part of the
scsi-mq series I moved the bqt field used for this into a union with the
new blk_mq_tag_set.  Below is a patch to get rid of that union, can you
try if that fixes it?


diff --git a/include/scsi/scsi_host.h b/include/scsi/scsi_host.h
index d0f69a3..bcffff2 100644
--- a/include/scsi/scsi_host.h
+++ b/include/scsi/scsi_host.h
@@ -584,10 +584,8 @@ struct Scsi_Host {
 	 * Area to keep a shared tag map (if needed, will be
 	 * NULL if not).
 	 */
-	union {
-		struct blk_queue_tag	*bqt;
-		struct blk_mq_tag_set	tag_set;
-	};
+	struct blk_queue_tag	*bqt;
+	struct blk_mq_tag_set	tag_set;
 
 	atomic_t host_busy;		   /* commands actually active on low-level */
 	atomic_t host_blocked;
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
