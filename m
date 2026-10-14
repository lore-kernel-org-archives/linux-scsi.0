Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21A5C30F803;
	Wed, 14 Oct 2026 04:59:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791953966; cv=none; b=rduMHYdB3kumvXLGfOZJVZmQk75H+8kMEFiDlBU0Ks5hkb6s0lh1imlbQ+CI1XMHfq3RQL9Fk0DeaXgOsvFG+ivTlS/ag1GKJKpte2w690VXA8waiwYBKvrMg2PDPWRAlXIwCXWA7H4sm7tstb6V3h5Jg6Dg0r50ozC8/9tiPpU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791953966; c=relaxed/simple;
	bh=k2G1gGW7lhO5m5s8SoUEHosvhmLHajlLPnUGO/LbcQ4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DmKiG+paPtTJ3pTF+5zV8pVRlLEd0x4GRrQRxNFAc9LA3+un6Q8Bycnhktxyr5Mlhi2XLh8SfjSRELn9pVARu869FsjGHYNDjEPN6CVIWy1R2noZbBwSjDP+UgIiZYiEu2JKkedDR1nnoFiOOC3o/XGxyFt9b232BDfJw4Qcjys=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rt6mJKKh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rt6mJKKh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 049511F000FF;
	Wed, 14 Oct 2026 04:59:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791953964;
	bh=lz89EZ5EYVxYJOKYY6jYn9HslcKbAALQidGCQ+zsu+M=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=Rt6mJKKhFKaBTu3FLOge+9WtxpYekrxNKcx/wN1DDPvpB113c09qBxE6AVVoOz7m9
	 /S9ihVJQzRW/yxqyjWdR3hM8Jo8VrsihCItVH2d9cEPt1bgoUOC/L1V+HML4tehYlf
	 9IpBGQdPM5pEO9Ua/HFn+63YGHdbWyTxe98YPt6U=
Date: Wed, 14 Oct 2026 06:59:28 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
Cc: linux-usb@vger.kernel.org, oneukum@suse.com, stern@rowland.harvard.edu,
	linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
	stable@vger.kernel.org
Subject: Re: [PATCH] usb: uas: validate status URB length before parsing the
 IU
Message-ID: <2026101453-worry-arose-6024@gregkh>
References: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20261013221937.41490-1-olivier.kaloudoff@gmail.com>

On Wed, Oct 14, 2026 at 12:19:37AM +0200, Olivier Kaloudoff wrote:
> uas_stat_cmplt() dereferences iu->tag without verifying that the
> status URB actually carried a full IU header.  The transfer buffer is
> a freshly-zeroed sense_iu, so a status URB that completes
> successfully but with a short or empty actual_length — observed in
> the wild during link-level upsets (Thunderbolt-chain xhci blips) and
> on a wedging bridge — reads back as iu_id=0/tag=0 and produces the
> misleading
> 
>   stat urb: no pending cmd for uas-tag 0
> 
> log spam seen e.g. on an ASMT135x enclosure and a Samsung T7, right
> before the affected commands time out into the error handler.
> 
> Beyond the noise, a short packet that happens to carry a
> plausible-looking header could be matched to an inflight command and
> drive the state machine off garbage.  Bail out on anything shorter
> than a full struct iu.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Olivier Kaloudoff <olivier.kaloudoff@gmail.com>
> ---
>  drivers/usb/storage/uas.c | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/drivers/usb/storage/uas.c b/drivers/usb/storage/uas.c
> index 265162981269..88fed50c262b 100644
> --- a/drivers/usb/storage/uas.c
> +++ b/drivers/usb/storage/uas.c
> @@ -315,6 +315,13 @@ static void uas_stat_cmplt(struct urb *urb)
>  		goto bail;
>  	}
>  
> +	if (urb->actual_length < sizeof(struct iu)) {
> +		dev_err(&urb->dev->dev,
> +			"stat urb: short transfer (%u bytes)\n",
> +			urb->actual_length);

Do not allow broken / malicious devices to spam the kernel log.

And how was this tested?

thanks,

greg k-h
