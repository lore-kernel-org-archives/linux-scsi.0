From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH] uas: Add missing le16_to_cpu calls to asm1051 / asm1053 usb-id check
Date: Thu, 11 Sep 2014 12:02:02 +0200
Message-ID: <87fvfytqzp.fsf@nemi.mork.no>
References: <1410426372-10151-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:58086 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752392AbaIKKCY convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 06:02:24 -0400
In-Reply-To: <1410426372-10151-1-git-send-email-hdegoede@redhat.com> (Hans de
	Goede's message of "Thu, 11 Sep 2014 11:06:12 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Hans de Goede <hdegoede@redhat.com> writes:

> --- a/drivers/usb/storage/uas-detect.h
> +++ b/drivers/usb/storage/uas-detect.h
> @@ -73,8 +73,8 @@ static int uas_use_uas_driver(struct usb_interface =
*intf,
>  	 * broken on the ASM1051, use the number of streams to differentiat=
e.
>  	 * New ASM1053-s also support 32 streams, but have a different prod=
-id.
>  	 */
> -	if (udev->descriptor.idVendor =3D=3D 0x174c &&
> -			udev->descriptor.idProduct =3D=3D 0x55aa) {
> +	if (le16_to_cpu(udev->descriptor.idVendor) =3D=3D 0x174c &&
> +			le16_to_cpu(udev->descriptor.idProduct) =3D=3D 0x55aa) {
>  		if (udev->speed < USB_SPEED_SUPER) {
>  			/* No streams info, assume ASM1051 */
>  			flags |=3D US_FL_IGNORE_UAS;


Not that it matters much in this case, but I believe converting the
constants is preferred so that this can be resolved at build time
instead of runtime.

I.e.
	if (udev->descriptor.idVendor =3D=3D cpu_to_le16(0x174c) &&
etc



Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
