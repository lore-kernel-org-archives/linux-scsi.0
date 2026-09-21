Received: from mail-wm2-f13.google.com (mail-wm2-f13.google.com [74.125.225.141])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22FCE493D3D
	for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 10:58:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.141
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789988331; cv=none; b=LmbjQz+NIe3gLsnMIUF4D1tGjD9/rJh81P7OdMp+NDtHGPI6GlUmGJljRI/4oAf1N5rf6S8gF4yCiS03hdCmM1adF8+Wn7xbiTvjg6GRhgU4A1KHN39bYKk/YAn3DKLJNDanwjWzAx6JsEyjtzCkB1RshLYH6nGE99os696zq+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789988331; c=relaxed/simple;
	bh=9d+9ZBvxo6G6q3+OJNAocJqza+l2mLOys7SvfT4EZYc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ElIGmLOLRdFHWrbqTdxbjrrUTEBx081TJ+xdcmWjmxLhKkiVJvue6F0244bPaDq8g6Gkh+lCfMgKDpRXREdMHJ3wA/J0ZmvcX3lf3tQNIIXRiDWgpI4L6jJPE3KJ/bOaSADgIGx9dX1rehT9Asjn7xv2mRA2ce0BTYeB515d7fs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FVpF/4Y/; arc=none smtp.client-ip=74.125.225.141
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FVpF/4Y/"
Received: by mail-wm2-f13.google.com with SMTP id 5b1f17b1804b1-49e8185e037so15812555e9.3
        for <linux-scsi@vger.kernel.org>; Mon, 21 Sep 2026 03:58:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789988326; x=1790593126; darn=vger.kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=B7gJgiKzwHYQowFViJmep5j79EdGUMtu2GzF/1ItERw=;
        b=FVpF/4Y/gIh7FMCWrtBK7h7XQ6wDsnZvMDOSyk6xhiqrTuvT0Qc8dLqwiTxp66vgPk
         +U+gC2cE+3N1E7oeIw86Z7unHMIEirBI0V6VeuIs3ci2kgzKPqrMPoVYb2prHkvhTA8t
         PKc3wRA78LFzjba+qifcEZ0UvW6pJVdSr5G2OJGTFSZ4SMzvHtQ18q8ELsY2ZiM4Xtud
         bN+wV0Ik3FGSAZuoZsVDLjlaEr/dKBbELKcwHjSTWFqY4LVQ1EJ/UgkkKTKPP0Sp8lca
         8ZAgr4H/TWrOQL932zIEtkHiGRf404f3fueAs+hBE669WY5vfYNO7oqj6dR3o0Comu3m
         q3Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789988326; x=1790593126;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=B7gJgiKzwHYQowFViJmep5j79EdGUMtu2GzF/1ItERw=;
        b=2hj5lGvO0O5xTQFueVWxlEDMs6rI5oIFVLLrEQbnRWL3UxS3hU/jw6MmvYKT5haZ5v
         uy005bODc54tKOiYGUmlDuybAO3e/nb00GG+RuZF48GXhfyVrHnTT4uJ7uIEpn/OhqUj
         WIw6IIdrCLSRTLyDfEIOE8Zp07wXMnLanTa+feCIfqgKrfIhWB3sdBWAWeuQvPBX9+DD
         lajDhksNUPfWVit5XDqdBKr2h799JFx5AforCbAvWMHW02toAz5a9pgmG2IOmPYSkEe7
         rYITm8Mj4fFZb2uLuCFH4ltIikkB7bVVGBU2Ua+kmXzID4ReIqEWFK2IL9rbqO742VjF
         k8IQ==
X-Forwarded-Encrypted: i=1; AKwUvByNygwIppKimWecd+QyJXUsv3epYMm9xmORq4iKtxqS8mZYAWG6fZzTTpxAZO6VUI8E6Wib51Xryd1t@vger.kernel.org
X-Gm-Message-State: AFuF++m1SkVgOHuR+h3ZUHynwz5AMl9AbrPAAVQTma0UiY6OspslAMPO
	ckQwIa8DiOn3WFTTXI6BDJwDdAneQCsxoUVHXyVY3gz02tO8LXKt0A84
X-Gm-Gg: AYBFou1vYFPRlxnthvb6yGc3eAFta2MCX6wIT6I6fPVdM04+ayv6Xut+OipQMNcd0rn
	6JYeKX85Y6o2xmv8bGHXP6ULjyYltj8wUR5CEgNyAVt8hZ8kLef05eKB6k3vzO3F3GlNRz8Fu+M
	mm25YbLNdeq4rCCLAM/wwwkSW7r46tqr8HYcgKuw4oGll/aUCTOMkT48R1uJuL1VY1XO+qlnjQg
	TChxU2Kjw8X57sxC7wYMpNQ97zj3wlv8hlY+2plcLuuwM/mBSMBZlE33iVc05Yk6kqOBEWX0+0d
	5NXDWz3daACLzCxAaqLwg1RrHgM9VzY9+n+8hMY8e0P1o4AKVYOQiY63jKIqdMU+XK4r+9Ttqa8
	nrgvHkLDH8tAP7oz2g8JdpjwdPQ4kZ3WVEtX047HhRy1FRnW5c1VlJXFonNuXq/Re+Rr+TTb6tn
	VPn5vnQOISUm3/rUw58NGQd4wtdLYHucZPVGYf8BFQdxgcpUBcxR+CtDI04VcSXFNPyqIdOiLqa
	JKOpOw41UqtYjz32yoTWMdXsQYfrxIuqvDRm/xRLCDCjno=
X-Received: by 2002:a05:600c:3584:b0:49d:286:83d5 with SMTP id 5b1f17b1804b1-49fc5722755mr184267135e9.13.1789988326343;
        Mon, 21 Sep 2026 03:58:46 -0700 (PDT)
Received: from ?IPV6:2a02:810d:7e03:5f00:f6cc:18d8:115:cfda? ([2a02:810d:7e03:5f00:f6cc:18d8:115:cfda])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49fd757e97esm5954785e9.8.2026.09.21.03.58.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Sep 2026 03:58:45 -0700 (PDT)
Message-ID: <82fdf997-1e9a-4d67-88d3-fbd8a795b7bc@gmail.com>
Date: Mon, 21 Sep 2026 12:58:44 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] target: use assign_bit() where applicable
To: "Peng Fan (OSS)" <peng.fan@oss.nxp.com>,
 "Martin K. Petersen" <mkp@kernel.org>
Cc: linux-kernel@vger.kernel.org, Peng Fan <peng.fan@nxp.com>,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20260919130853.3041614-1-peng.fan@oss.nxp.com>
Content-Language: en-US, de-DE
From: =?UTF-8?B?Qm9kbyBTdHLDtsOfZXI=?= <bostroesser@gmail.com>
In-Reply-To: <20260919130853.3041614-1-peng.fan@oss.nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 19/09/2026 15:08, Peng Fan (OSS) wrote:

> From: Peng Fan <peng.fan@nxp.com>
>
> Convert open-coded if/else with set_bit/clear_bit to the assign_bit API.
>
> Signed-off-by: Peng Fan <peng.fan@nxp.com>
> ---
>   drivers/target/target_core_user.c | 5 +----
>   1 file changed, 1 insertion(+), 4 deletions(-)
>
> diff --git a/drivers/target/target_core_user.c b/drivers/target/target_core_user.c
> index edc2afd5f4ee..425ad1246a75 100644
> --- a/drivers/target/target_core_user.c
> +++ b/drivers/target/target_core_user.c
> @@ -3006,10 +3006,7 @@ static ssize_t tcmu_tmr_notification_store(struct config_item *item,
>   	if (val > 1)
>   		return -EINVAL;
>   
> -	if (val)
> -		set_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
> -	else
> -		clear_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags);
> +	assign_bit(TCMU_DEV_BIT_TMR_NOTIFY, &udev->flags, val);
>   	return count;
>   }
>   CONFIGFS_ATTR(tcmu_, tmr_notification);
Reviewed-by: Bodo Stroesser<bostroesser@gmail.com>

Best regards,
Bodo Strößer
