Received: from mail-wr2-f12.google.com (mail-wr2-f12.google.com [74.125.225.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE58243E4BB
	for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 08:35:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790066102; cv=none; b=tTJ8vlAXiS5FmAXp6/hcRFNsFY+HG9ujX2n8a5ZPXVC0iygE4tUWToDMfUYOHcL8uC2wzNzmO4vMItWqYLqpd3HXptJz64dwQFwPVDonG6GK5xhdyQq2AYFAV7BFRMM663YP78Wyboh0T9jXejJEBbt4AQF3jC/kj7KMAjM/xa8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790066102; c=relaxed/simple;
	bh=/MQ9q/kMBz035pPCnw9vOBp/PRzg9yLdoKxGmuxx3uw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XjUHud/0WdAJnTuBoMlC5sdcQY4Gpb2DdVbsZbLJq0F+PFdIuKTop3xq/6mFr3VqdYgWBGpmOSj0zCxPuIb/I2eP+kf+EGHOQfwnoMitQyMePTfn0xGHoyN5A5jTlM/uZWDK2KmO9cis0sbdFN8YuD1VrlKktOK+D5EK8Mc9tlI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=WUZNK4I3; arc=none smtp.client-ip=74.125.225.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="WUZNK4I3"
Received: by mail-wr2-f12.google.com with SMTP id ffacd0b85a97d-485ac898fa4so3356566f8f.0
        for <linux-scsi@vger.kernel.org>; Tue, 22 Sep 2026 01:35:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1790066099; x=1790670899; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6vCaHzev1h/MoHQH435Co/njJMhx1fq16i2vRv4vluc=;
        b=WUZNK4I3gs/n/SLhPw/0Q9mXJdnqA+J/UphS8qjja67DhSLDZktAf8akSnSXNTSbJq
         OdS+EIhUjSI5pqbjGVwWSVsrICOP4F4afN0obJU5B+bsyzLZC9dYq/4WZiuqf8iXIQ2E
         umsUhEYlCqXc8797ma5H8ziwz6aWpZH7qlVlT8hqoor8ePFz9WoXnhS6WUwkCiXOJ2xj
         8XbEj1ogJgr6OqQrHm6HzysRZmwJgS+o7LJ3XpaG3qT4ssiv7dL0Avkp0DKMcPca0jou
         Fc+wfO86vr0RzLfJXL+8fxS4MWzVRlttpp5IvGW/jlorwGsGzIzP4gP3KcnUVR4hRBwF
         lsQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790066099; x=1790670899;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6vCaHzev1h/MoHQH435Co/njJMhx1fq16i2vRv4vluc=;
        b=RV4MqgMnwDWd96+8aCJ0HXJpBbowcItNwPgd0IcaKNaFQRNo6/uI0t4uMh0bbSQbIz
         8N0ckk7zJ+4rhy9aH1vXYLVxRzmE4TeQlugInQw7It+0GdHgOLHTJu6rg5jMrIgV9YQ/
         7kfBM+BM7MHL1mBZ9yetp6BgTR0tZV+UnFccIDZJeaxRoLAj3vM3nQvWHMM/Z8iK7+qk
         LqJiYaWqUOP9GigftX0Gfcfdk63F9+dFAx1k+WPckkiRpUQ992jv9PG5HqgxazyNqWkl
         3wejnt0FoRNKJN80dnemPRl8T7KGYjXOiXpC4GjFHZw6Ly1/Cunvu3LZza+z2P9dwEzh
         w0tQ==
X-Forwarded-Encrypted: i=1; AKwUvBwk8+R386M0nvaMdvk0WvIrpZApzBGr3H7Yf/Vdjw8CUA2du6toB6CXR8T/rbmQNptUK4ZgoxqahE+X@vger.kernel.org
X-Gm-Message-State: AFuF++lDRWna5mnt07nwtlHc/cFhaIykIwU/UTLhS719Jt2wTpthju0w
	IQdUtynTf7I/8GEVK1tXXIPnU23opMLzDpDaebuPjz0bG3eVV2P5hGLBsQmCzH8hIG8osCKZ4iJ
	TioMT
X-Gm-Gg: AYBFou2QTyGiW+k/SYcaxiDUnk15jHfYxm/99cb3jAmCbu12j81xJ3WWOFkZ7X9sUap
	7ZfqASvDsx5iw4JaL1IHmJhEhye4tYTvlW/OKBRUSMVIaAMilhTVjoNvmBNP0T5moz9B/RR/Iwz
	p/+rOAXh/7VlOTiZuXFFNWDabriv97Dg2Aez/Ji28vcHg6vHqZhyt9AgWWKF/WxH4y7wzch44Vj
	379ED76wVh+FIZ2dPHga9afwMoYfCvKYHBsD3gmSXkLcFo1/B/arhC5VDG6J946Dw8r7eOj7Agz
	AMaVA5vr0Ve+i2ONPfbdQjCKen+CzCwHboOlF2bVerJqTKg3I9FZoKSzxLG+EEPxFJ6uGB1PCDQ
	83Jl38HaFwEBRSFsJK6IyRGX2fBiPxdxYuBKpuhgH0thq8uUOyAPLf5NIs4IvFDcftprvG4+WfB
	YcVF01gsa/DRgtoJjAlKaMO/TZ7MdpryJsquyRSNhwjWGD0CwuD8jIPkkLG12XlQfzKvD2mNoHM
	ZV3jWRYNkeWtK1U1qw3XJpz854SryFUr3+OgrIw
X-Received: by 2002:a05:6000:3113:b0:487:10a9:57cb with SMTP id ffacd0b85a97d-4871e3778e6mr19151883f8f.49.1790066099179;
        Tue, 22 Sep 2026 01:34:59 -0700 (PDT)
Received: from ?IPV6:2001:a61:13f0:9e01:9a7c:db93:afba:8f7f? ([2001:a61:13f0:9e01:9a7c:db93:afba:8f7f])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-488627314d2sm3372106f8f.2.2026.09.22.01.34.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 22 Sep 2026 01:34:58 -0700 (PDT)
Message-ID: <d3639d68-0213-4b70-a771-aa5dc3ec9767@suse.com>
Date: Tue, 22 Sep 2026 10:34:58 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] usb: uas: quiesce SCSI before stopping endpoints on
 unbind
To: Jiayi Li <lijiayi@kylinos.cn>
Cc: Alan Stern <stern@rowland.harvard.edu>,
 Michal Pecio <michal.pecio@gmail.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
 linux-kernel@vger.kernel.org
References: <20260922031102.141043-1-lijiayi@kylinos.cn>
Content-Language: en-US
From: Oliver Neukum <oneukum@suse.com>
In-Reply-To: <20260922031102.141043-1-lijiayi@kylinos.cn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 22.09.26 05:11, Jiayi Li wrote:
> Unbinding uas while READ commands are in flight can leave the storage
> device unusable after the driver is rebound.  The first post-bind
> INQUIRY Data-In transfer completes with -EOVERFLOW, and SCSI error
> handling eventually offlines the device:
> 
>    scsi host7: uas
>    scsi 7:0:0:0: tag#4 data cmplt err -75 uas-tag 1 inflight: CMD
>    scsi 7:0:0:0: tag#4 CDB: Inquiry 12 00 00 00 24 00
>    scsi 7:0:0:0: tag#4 uas_eh_abort_handler 0 uas-tag 1 inflight: CMD
>    usb 2-2: reset SuperSpeed USB device number 2 using xhci_hcd
>    scsi host7: uas_eh_device_reset_handler success
>    ...
>    scsi 7:0:0:0: tag#7 CDB: Test Unit Ready 00 00 00 00 00 00
>    scsi host7: uas_eh_device_reset_handler success
>    sd 7:0:0:0: Device offlined - not ready after error recovery
> 
> A command URB may already have delivered a SCSI command when usbcore
> disables the interface endpoints and kills the data and status URBs
> before ->disconnect.  uas_disconnect() then removes the SCSI host only
> after killing its anchored URBs, so SCSI teardown cannot first quiesce
> the accepted commands.  A newly bound UAS instance can encounter the
> residual transport state.
> 
> The failure reproduced with a VIA Labs 2109:0715 storage bridge on both
> Zhaoxin 1d17:9204 and Intel 8086:a2af xHCI controllers.  USB device reset
> and xHCI unbind/rebind did not recover the device; physical reconnection
> did.
> 
> Set soft_unbind so the endpoints remain available during driver unbind.
> Cancel pending scanning and remove the SCSI host before setting resetting
> and killing the anchored URBs.  Use the same teardown order for every
> disconnect path and rely on SCSI host removal to handle a device that can
> no longer communicate.
> 
> With the change, 10 of 10 zero-delay unbind/rebind iterations with 30
> READ commands in flight reattached the disk and completed a post-bind
> O_DIRECT read.  Unbind took 82 to 109 ms, with no UAS completion error or
> command timeout after rebind.
> 
> Signed-off-by: Jiayi Li <lijiayi@kylinos.cn>
Acked-by: Oliver Neukum <oneukum@suse.com>
> ---
> Changes in v2:
> - Remove the USB_STATE_NOTATTACHED-based disconnect classification.
> - Use the same teardown ordering for all disconnect paths.
> - Reword the commit message.
> 
> Link: https://lore.kernel.org/lkml/20260920012358.3362053-1-lijiayi@kylinos.cn/
> 
>   drivers/usb/storage/uas.c | 16 +++++++++-------
>   1 file changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 8655edbd66b16..8752cecb45915 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -1217,6 +1217,14 @@ static void uas_disconnect(struct usb_interface *intf)
>   	struct uas_dev_info *devinfo = (struct uas_dev_info *)shost->hostdata;
>   	unsigned long flags;
>   
> +	/*
> +	 * Prevent SCSI scanning (if it hasn't started yet)
> +	 * or wait for the SCSI-scanning routine to stop.
> +	 */
> +	cancel_work_sync(&devinfo->scan_work);
> +
> +	scsi_remove_host(shost);
> +
>   	spin_lock_irqsave(&devinfo->lock, flags);
>   	devinfo->resetting = 1;
>   	spin_unlock_irqrestore(&devinfo->lock, flags);
> @@ -1227,13 +1235,6 @@ static void uas_disconnect(struct usb_interface *intf)
>   	usb_kill_anchored_urbs(&devinfo->data_urbs);
>   	uas_zap_pending(devinfo, DID_NO_CONNECT);
>   
> -	/*
> -	 * Prevent SCSI scanning (if it hasn't started yet)
> -	 * or wait for the SCSI-scanning routine to stop.
> -	 */
> -	cancel_work_sync(&devinfo->scan_work);
> -
> -	scsi_remove_host(shost);
>   	uas_free_streams(devinfo);
>   	scsi_host_put(shost);
>   }
> @@ -1267,6 +1268,7 @@ static struct usb_driver uas_driver = {
>   	.suspend = uas_suspend,
>   	.resume = uas_resume,
>   	.reset_resume = uas_reset_resume,
> +	.soft_unbind = 1,
>   	.shutdown = uas_shutdown,
>   	.id_table = uas_usb_ids,
>   };

