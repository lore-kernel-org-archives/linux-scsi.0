Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF31AE94100
	for <linux-scsi@archiver.kernel.org>; Fri,  6 Oct 2023 18:55:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233466AbjJFSzE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Oct 2023 14:55:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233321AbjJFSys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Oct 2023 14:54:48 -0400
Received: from netrider.rowland.org (netrider.rowland.org [192.131.102.5])
        by lindbergh.monkeyblade.net (Postfix) with SMTP id AE6831AA
        for <linux-scsi@vger.kernel.org>; Fri,  6 Oct 2023 11:53:39 -0700 (PDT)
Received: (qmail 54323 invoked by uid 1000); 6 Oct 2023 14:53:38 -0400
Date:   Fri, 6 Oct 2023 14:53:38 -0400
From:   Alan Stern <stern@rowland.harvard.edu>
To:     Milan Broz <gmazyland@gmail.com>
Cc:     linux-usb@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        oneukum@suse.com, jonathan.derrick@linux.dev
Subject: Re: [RFC PATCH 5/6] usb-storage,uas,scsi: allow to pass through
 security commands (OPAL)
Message-ID: <2a6a819a-899d-4431-95ef-cbf3c75a49e7@rowland.harvard.edu>
References: <20231006125445.122380-1-gmazyland@gmail.com>
 <20231006125445.122380-6-gmazyland@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231006125445.122380-6-gmazyland@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Oct 06, 2023 at 02:54:44PM +0200, Milan Broz wrote:
> This patch enables pass-through OPAL command for USB-attached storage
> (which does not support UAS or SCSI security commands).
> All common USB/SATA or USB/NVMe adapters I tested need this patch.
> 
> USB mass storage devices that do not support SECURITY IN/OUT SCSI
> commands can support ATA12 pass-thru command.
> 
> Internal kernel implementation for OPAL interface currently supports
> only SCSI SECURITY IN/OUT wrapper.
> USB mass storage also turns off SCSI command enumeration, so SECURITY
> IN/OUT in the SCSI layer will be disabled.
> 
> Note: sedutils and some other OPAL tools already use ATA-12 pass-thru.
> 
> This patch
>  - enables SCSI security flag for USB mass storage and UAS device by default.
> 
>  - adds an optional wrapper to the SCSI layer for the ATA-12 pass-thru
>    command as an alternative if SECURITY IN/OUT is unavailable.
> 
> In short, the patch runs these steps:
>   1) USB drives (mass-storage, UAS) enables security driver flag by default
>      if not disabled by quirk
>   2) SCSI device enumerates SECURITY IN/OUT support. If detected,
>      SECURITY ON/OUT wrapper is used (as in the current code).
>      If not, new ATA12 pass-thru wrapper is used instead.
>   3) SED OPAL code tries OPAL discovery command for device. If it receives
>      correct reply, OPAL is enabled for the device.
> 
> With the changes above, the TCG OPAL support works with USB adapters
> that support the ATA-12 command. As kernel OPAL code runs discover
> commands on initialization, on devices that do not support pass-through,
> OPAL remains disabled.

You don't explicitly mention what will happen with devices that don't 
support ATA-passthrough.  Presumably the ATA12 commands will simply be 
rejected and OPAL will not be enabled.

> The patch also adds a quirk flag to disable security commands for particular
> devices if firmware is buggy.
> 
> Signed-off-by: Milan Broz <gmazyland@gmail.com>
> ---

I think it might be better to split this into two patches: One adding 
the security driver flag in the USB drivers and one for the SCSI changes 
-- those can be added separately through the SCSI tree after the USB 
changes have been merged.

I'm not going to try to review the SCSI changes.

> diff --git a/drivers/usb/storage/usb.c b/drivers/usb/storage/usb.c
> index f3a53c3eeb45..04211ac803e4 100644
> --- a/drivers/usb/storage/usb.c
> +++ b/drivers/usb/storage/usb.c
> @@ -478,7 +478,7 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
>  			US_FL_INITIAL_READ10 | US_FL_WRITE_CACHE |
>  			US_FL_NO_ATA_1X | US_FL_NO_REPORT_OPCODES |
>  			US_FL_MAX_SECTORS_240 | US_FL_NO_REPORT_LUNS |
> -			US_FL_ALWAYS_SYNC);
> +			US_FL_ALWAYS_SYNC | US_FL_IGNORE_OPAL);
>  
>  	p = quirks;
>  	while (*p) {
> @@ -567,6 +567,9 @@ void usb_stor_adjust_quirks(struct usb_device *udev, u64 *fflags)
>  		case 'y':
>  			f |= US_FL_ALWAYS_SYNC;
>  			break;
> +		case 'z':
> +			f |= US_FL_IGNORE_OPAL;
> +			break;
>  		/* Ignore unrecognized flag characters */
>  		}
>  	}

You need to add a corresponding entry to the usb-storage.quirks entry in 
Documentation/admin-guide/kernel-parameters.txt.

Alan Stern
