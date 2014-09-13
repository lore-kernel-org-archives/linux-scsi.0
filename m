From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH fix for 3.17] uas: Add a quirk for rejecting ATA_12 and
 ATA_16 commands
Date: Sat, 13 Sep 2014 10:11:13 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1409131009530.7476-100000@netrider.rowland.org>
References: <1410603548-3579-2-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1410603548-3579-2-git-send-email-hdegoede@redhat.com>
Sender: stable-owner@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, 13 Sep 2014, Hans de Goede wrote:

> And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
> seems to hang upon receiving an ATA_12 or ATA_16 command.
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=79511
> 
> Cc: stable@vger.kernel.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>

> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -478,7 +478,8 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
>  			US_FL_CAPACITY_OK | US_FL_IGNORE_RESIDUE |
>  			US_FL_SINGLE_LUN | US_FL_NO_WP_DETECT |
>  			US_FL_NO_READ_DISC_INFO | US_FL_NO_READ_CAPACITY_16 |
> -			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE);
> +			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
> +			US_FL_NO_ATA_1X);
>  
>  	p = quirks;
>  	while (*p) {
> @@ -543,6 +544,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, unsigned long *fflags)
>  		case 's':
>  			f |= US_FL_SINGLE_LUN;
>  			break;
> +		case 't':
> +			f |= US_FL_NO_ATA_1X;
> +			break;
>  		case 'u':
>  			f |= US_FL_IGNORE_UAS;
>  			break;

You must not add an aditional value for a module parameter without 
documenting it in Documentation/kernel-parameters.txt.

Alan Stern
