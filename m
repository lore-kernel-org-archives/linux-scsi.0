From: David Webb <djw-8SE8IwxHpK9aa/9Udqfwiw@public.gmane.org>
Subject: Re: [PATCH] uas: Add a new NO_REPORT_LUNS quirk
Date: Thu, 31 Mar 2016 18:35:48 +0100
Message-ID: <7977162.W24Fksp8b7@ok64>
References: <1459426971-11927-1-git-send-email-hdegoede@redhat.com> <1459437073.2958.29.camel@HansenPartnership.com> <56FD40FE.3030302@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <56FD40FE.3030302-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-usb-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Hans de Goede <hdegoede-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, Greg Kroah-Hartman <gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org>, Gerd Hoffmann <kraxel-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-usb-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Hi,

> Actually it does support REPORT LUNS, some of the time. When you first
> boot the computer with uas blacklisted for this device, so initialize
> it once with usb-storage, and then reboot with out the blacklist
> (and without removing power to the drive) uas will work with REPORT LUNS
> bit cold-booting directly into uas mode and then doing a REPORT LUNS
> upsets the drive / disk enclosure (this has all been observed by
> David Webb, I do not own such a drive).

Just to confirm what Hans has reported.  After power has been removed the 
Seagate Expansion usb disk always produces faults unless it has been 
blacklisted in some way.  Once the disk is working the computer can be powered 
off and restarted without the blacklist and, as long as its power has not been 
removed, the disk can be reconnected many times without any error.

With Hans's changes the disk mounts correctly with the uas module every time.

My guess is that one of the interface registers is not or cannot be 
initialized correctly.  If after a failure I try unplugging and reinserting 
the usb connector many times it has sometimes connected correctly - which to 
me means that some random bit eventually has the right value. 

Regards,

David Webb.

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
