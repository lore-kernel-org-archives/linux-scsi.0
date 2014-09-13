From: Thomas Backlund <tmb@mageia.org>
Subject: Re: [PATCH fix for 3.17 v2] uas: Add a quirk for rejecting ATA_12
 and ATA_16 commands
Date: Sat, 13 Sep 2014 22:21:15 +0300
Message-ID: <5414992B.8020309@mageia.org>
References: <1410631347-8406-1-git-send-email-hdegoede@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.multi.fi ([85.134.37.151]:34249 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254AbaIMTdt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 13 Sep 2014 15:33:49 -0400
In-Reply-To: <1410631347-8406-1-git-send-email-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, stable@vger.kernel.org

Den 13.09.2014 21:02, Hans de Goede skrev:
> And set this quirk for the Seagate Expansion Desk (0bc2:2312), as that one
> seems to hang upon receiving an ATA_12 or ATA_16 command.
>
> https://bugzilla.kernel.org/show_bug.cgi?id=79511
>
> While at it also add missing documentation for the u value for usb-storage
> quirks.
>
> Cc: stable@vger.kernel.org # 3.16
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
>
> --
> Changes in v2: Add documentation for new t and u usb-storage.quirks flags
> ---
>   Documentation/kernel-parameters.txt |  3 +++
>   drivers/usb/storage/uas.c           | 13 +++++++++++++
>   drivers/usb/storage/unusual_uas.h   | 16 ++++++----------
>   drivers/usb/storage/usb.c           |  6 +++++-
>   include/linux/usb_usual.h           |  2 ++
>   5 files changed, 29 insertions(+), 11 deletions(-)
>
> diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
> index 5ae8608..7c32053 100644
> --- a/Documentation/kernel-parameters.txt
> +++ b/Documentation/kernel-parameters.txt
> @@ -3541,6 +3541,9 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
>   					bogus residue values);
>   				s = SINGLE_LUN (the device has only one
>   					Logical Unit);
> +				t = NO_ATA_1X (don't allow ATA12 and ATA12
> +					commands, uas only);

I guess you meant ATA12 and *ATA16*

> +				u = IGNORE_UAS (do not try to use uas);
>   				w = NO_WP_DETECT (don't test whether the
>   					medium is write-protected).
>   			Example: quirks=0419:aaf5:rl,0421:0433:rc

--

Thomas

