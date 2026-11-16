Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794821787;
	b=LEPJC0AW29bFXex/A2AvnugfEDBJRU5C3W1fzRjgoizPpUygXh+No208MLc3Xz19gIcZ
	 xXP6y79Reqz6ytC4Ms+BkGtsT7tjM7q9JosnxoZK7L1vzRFtzdb3bBPrDKevjJm4HVisY
	 OBd9UyqY1qOK85DML8qeyQ0wZpiD4yF4O3NQX73EyY75lrWYRcguBB1MoblEB7iRjc6VS
	 InVRD1GX87RaTRMfBBG+Wq5uv+A4SqOrWwWFqESnUvZ7GbL2mo6bbGyB/YcaNT7c2RLwb
	 z9yTkF+1vHtWxuPBsiwVnsuylMxwwtVLvD9JqaSINpioFWuX7pE3MnTsVnCgpFaFExw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794821787;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:
	 Content-Transfer-Encoding:In-Reply-To;
	bh=MQQEl2CB0qMao+OKMDT3huNXIC05TmBxw41BWi7PHdY=;
	b=1drdRfR6w9YIfChYLnpIPaHew2Bit9HauWtrEtsYuF7DFdTl7Ub9KmEEzAF74kX3E8Cx
	 r4c4ZM7JXktsItS8guT4EKLM0dLE9X0Lafh1FjFTigvUGlpgO/Ln0Dkm3OaqLd7sbmiuu
	 VyZkFZSA8un7R1vxGtZdmz1V+8ejHZO+PxrkcnGgMbnnz+uyzGS1vr8Uym99iWw9b/Nge
	 y5+UvueAq4+Ca6dqYKhLhWselUIL1fWTrDmLO7R+OqQCJYUk/h2wXpEqszWX+OuEzDLru
	 qH5x+yjJqWtOD4AYQmwr7CdD2EzV0BFBcPTmYVqWt8mWc2cVBhoDzWabV2Ich72WP1g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIjuQCmh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F44606A329;
	Mon, 16 Nov 2026 09:36:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=LIjuQCmh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 012C31F000C5;
	Mon, 16 Nov 2026 09:36:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794821786;
	bh=MQQEl2CB0qMao+OKMDT3huNXIC05TmBxw41BWi7PHdY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=LIjuQCmhg9Mo40fpAVttkvT/qGFkUosvEIaju4bRqb2bSiXiJl09++rGFXrdYMJ4Q
	 xCh3kSUarmPugJUq8hjs+CFl5zawWPNE8GdRUMMZlM1DCWoHBx6fTUtbEK6qqLRofM
	 /r8FJlrGN5qM3F6bLe7sbrj0WrO3uSmcdTYqC8dI=
Date: Mon, 16 Nov 2026 10:36:23 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Mateusz =?utf-8?Q?Jo=C5=84czyk?= <mat.jonczyk@o2.pl>
Cc: Oliver Neukum <oneukum@suse.com>,
	Alan Stern <stern@rowland.harvard.edu>, linux-usb@vger.kernel.org,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	linux-kernel@vger.kernel.org,
	smartmontools-support@listi.jpberlin.de,
	Christian Franke <Christian.Franke@t-online.de>
Subject: Re: [PATCH] usb: uas: expose US_FL_NO_ATA_1X in sysfs as
 deny_ata_passthrough
Message-ID: <2026111639-paprika-smock-4b01@gregkh>
References: <20261115124046.5286-1-mat.jonczyk@o2.pl>
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261115124046.5286-1-mat.jonczyk@o2.pl>

On Sun, Nov 15, 2026 at 01:40:46PM +0100, Mateusz Jończyk wrote:
> The uas driver blocks access to ATA passthrough commands for some
> devices it considers buggy (via the US_FL_NO_ATA_1X flag in
> unusual_uas.h and uas_detect.h). However, it does not expose any
> meaningful information whether the command was blocked by the driver or
> is genuinly not supported by the hardware. This creates a problem for
> the smartmontools program and makes it difficult for it to provide a
> useful error message (with instructions to disable UAS on the drive to
> get SMART readings).
> 
> So, expose the information in sysfs as deny_ata_passthrough. Other
> quirks may be added in the future if there is any demand.
> 
> Link: https://www.smartmontools.org/wiki/SAT-with-UAS-Linux
> Signed-off-by: Mateusz Jończyk <mat.jonczyk@o2.pl>
> ---
>  drivers/usb/storage/uas.c | 20 ++++++++++++++++++++
>  1 file changed, 20 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b1..aaea74297026 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -910,6 +910,25 @@ static int uas_sdev_configure(struct scsi_device *sdev,
>  	return 0;
>  }
>  
> +/* Sysfs interface */
> +static ssize_t deny_ata_passthrough_show(struct device *dev, struct device_attribute *attr,
> +					 char *buf)
> +{
> +	struct scsi_device *sdev = to_scsi_device(dev);
> +	struct uas_dev_info *devinfo = sdev->hostdata;
> +
> +	return sprintf(buf, "%d\n", !!(devinfo->flags & US_FL_NO_ATA_1X));
> +}
> +
> +static DEVICE_ATTR_RO(deny_ata_passthrough);
> +
> +static struct attribute *uas_sdev_attrs[] = {
> +	&dev_attr_deny_ata_passthrough.attr,
> +	NULL,
> +};
> +
> +ATTRIBUTE_GROUPS(uas_sdev);

Sorry, but random sysfs atttributes that are not documented are not a
good idea.  Especially ones that don't even use sysfs_emit().

thanks,

greg k-0h
