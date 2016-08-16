From: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: Re: [PATCH] scsi: introduce a quirk for false cache reporting
Date: Tue, 16 Aug 2016 00:44:40 -0400
Message-ID: <yq14m6ll3uv.fsf@sermon.lab.mkp.net>
References: <1470657309-9564-1-git-send-email-oneukum@suse.com>
	<yq18tw4rpsy.fsf@sermon.lab.mkp.net>
	<1471188464.4879.9.camel@suse.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1471188464.4879.9.camel-IBi9RG/b67k@public.gmane.org> (Oliver Neukum's message of
	"Sun, 14 Aug 2016 17:27:44 +0200")
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org>
Cc: "Martin K. Petersen" <martin.petersen-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, jejb-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org, usb-storage-ijkIwGHArpdIPJnuZ7Njw4oP9KaGy4wf@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

>>>>> "Oliver" == Oliver Neukum <oneukum-IBi9RG/b67k@public.gmane.org> writes:

Oliver,

Oliver> wce_default_on controls the default if the device provides no
Oliver> indication. The problem here is that the indication the device
Oliver> provides must be overridden, as they are false.

Can't you just blacklist the mode select on the device in question?

Something like:

	if (us->fflags & US_FL_ALWAYS_SYNC) {
		sdev->skip_ms_page_3f = 1;
		sdev->skip_ms_page_8 = 1;
		sdev->wce_default_on = 1;
	}

?

-- 
Martin K. Petersen	Oracle Linux Engineering
--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
