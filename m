Return-Path: <SRS0=AKtJ=6V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 71822C38A2A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 13:49:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 442832073A
	for <linux-scsi@archiver.kernel.org>; Thu,  7 May 2020 13:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1588859366;
	bh=EITDGaPX8swpQvDL2tLqcooypgIydo6yIyuNVXenMY0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=k1kklX6Ac2JoeWrrt8b8bf5i3mLVh6zhIrvlGQ/MvS7BJU9SXaubxsXWsa4h7+++j
	 A/ni5mPs0TqoRTXF8hQSlISoW6VdNPjGwzgo7MJ28dqtm6X60VqzmwO2TYFrhOc0OA
	 +GypNO74AALTGGf78/AS/Hk6z6UpRzbs8OOaIIIo=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726350AbgEGNtZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 May 2020 09:49:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:53822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725914AbgEGNtZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 May 2020 09:49:25 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 94D1620725;
        Thu,  7 May 2020 13:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588859365;
        bh=EITDGaPX8swpQvDL2tLqcooypgIydo6yIyuNVXenMY0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=voY85dPv1npGb/rOFUsk3nujLQxcoz+oAAT9l/b2bNCX/R3vRJGEoKYolIWRMV0t5
         vqvv9qMl48klN58J34bkW2DbseXVBvIYcnCvZHfB5qeQL2uzFRWoDQa+sxeFk1Z15K
         gwO390f0fxqEjIMNM88LLrV6TjByKSmgNwn/2vMk=
Date:   Thu, 7 May 2020 15:49:21 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Hans de Goede <hdegoede@redhat.com>
Cc:     Oliver Neukum <oneukum@suse.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org,
        Julian =?iso-8859-1?Q?Gro=DF?= <julian.g@posteo.de>
Subject: Re: [PATCH] USB: uas: Add US_FL_NO_REPORT_OPCODES for LaCie 2Big
 Quadra USB3 external disk
Message-ID: <20200507134921.GA1798390@kroah.com>
References: <20200507131708.250871-1-hdegoede@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200507131708.250871-1-hdegoede@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, May 07, 2020 at 03:17:08PM +0200, Hans de Goede wrote:
> The LaCie 2Big Quadra USB3 external disk does not like the REPORT_OPCODES
> request, causing probing it to take several minutes (and several resets).
> 
> Add US_FL_NO_REPORT_OPCODES flag for this model to fix the probing delay.
> 
> Reported-by: Julian Groﬂ <julian.g@posteo.de>
> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> ---
>  drivers/usb/storage/unusual_uas.h | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/unusual_uas.h b/drivers/usb/storage/unusual_uas.h
> index 1b23741036ee..37157ed9a881 100644
> --- a/drivers/usb/storage/unusual_uas.h
> +++ b/drivers/usb/storage/unusual_uas.h
> @@ -28,6 +28,13 @@
>   * and don't forget to CC: the USB development list <linux-usb@vger.kernel.org>
>   */
>  
> +/* Reported-by: Julian Groﬂ <julian.g@posteo.de> */
> +UNUSUAL_DEV(0x059f, 0x105f, 0x0000, 0x9999,
> +		"LaCie",
> +		"2Big Quadra USB3",
> +		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
> +		US_FL_NO_REPORT_OPCODES),
> +
>  /*
>   * Apricorn USB3 dongle sometimes returns "USBSUSBSUSBS" in response to SCSI
>   * commands in UAS mode.  Observed with the 1.28 firmware; are there others?
> -- 
> 2.26.0
> 

Already in my tree and in linux-next and will go to Linus this week,
sorry.

greg k-h
