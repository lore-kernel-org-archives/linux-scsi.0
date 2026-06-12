Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB95382298
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:02:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269365; cv=none; b=n4F30SD4531tu/MMs/e+c2v1y5xIrt5ydVDiOfPy4eRx6RRJNnLQmGpLYToEGIlotYkPNn+bg8jZIOeyDthCk3FvjvPOUWXCkyMf3yMnA9oLuSTmJ/Jr01nctqr6OfXhoWv5pM/uJzviCKcVakhSsxUb9qISYI/LHs7lSogGxDc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269365; c=relaxed/simple;
	bh=V5RENKBuFZrLNTfUGv3ZnK+lJTiZFGg20rysXLktKrI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tA2haNz316KxspbzuSFoRAzZwwmTz2hAItVAf8OvwBxFw7Hvn5FmYM0Wc+0bhA230oCjRMizTv5YzuyMmoyv+cjZcP/od17gK+7M8mOxNCCaihp2LS02r8/dQpfcL592NzXBYsd1FvJPp7w5gD7f9XRwp2Lg/3ozHL5G3vvONS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=V2g8KMua; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="V2g8KMua"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-45eea68dd6fso541759f8f.2
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:02:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269360; x=1781874160; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=2V4K15nIvBlXdWjITspPCeK3Axr21+j/mrff0wXlHP4=;
        b=V2g8KMuaEhr/0LO6XH1pGcMTI1J4BDi7MB4+cMWajPVHsw4neGqkqlrumR3WSx5B6d
         1neXu4t3/EArv2w6VYuqAE+6L7OnJT23msrIzRQBKHTXVHkzlMIdoGZAh0wACWd/auYl
         9iy/HDokhnZgfasbJhA1LAUaZOQdDIWMcNLCQkjVyNoblvR9qkQUKLuIdHYvAtoFmoBl
         +4xZ/beSJar1yQvUW7X+34JFVI9yFxTuSlktsUws9dJ5EgsPyLfJgT7uAhVpq+U4qkJj
         5YxfJd357TRIvqSD+4QI11L5IM8E1cWCINGKlcNCkAhDUJRU4SPzfciYa/PNViO5Ng8L
         fCXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269360; x=1781874160;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2V4K15nIvBlXdWjITspPCeK3Axr21+j/mrff0wXlHP4=;
        b=MQxBLsO5yD1i7ICnhmDGNnOIuC15+ZvN9xTulyE8bzHUEMYhy91AuWDDzjg46hygOa
         tWir0tJSXfX9nrEH6IeuyagSxw7w8Z/7jks5aEkRMTMU4bsy09HtYYqNkRUcjxS5BX+3
         uw0r6huNT/jFGJZpRp7PdSjzinkDXtBeF9GTec0eU7ubL66YVzkxx3DRxIvnNlX9dMbi
         2mdhhs2V6sKFEa9yfUeC99jNMjidpnsDky5ovRHJgU5+aN3GEOp8aFB9kYUqY2vfp4vd
         tam605Mo0D649MZnfNxtIoeilMXFiF1pEeO9yggplgWp1qTOdAy17wGlYfPxWx8/8mAu
         IUdw==
X-Gm-Message-State: AOJu0YwhDvF2K/28jaF8bhDGNlGp+U3Svs0udVpBXy5kpo8Al/uuBEfj
	kF8ZSm6F6DxA5Bl2AakLgfD/v8ulSdiYNWS/+kGaohz+IBZjOgyf+aRrV7vLaZBnK1KYJXyaYQV
	MibYz
X-Gm-Gg: Acq92OFykhYlEQdTMjv9wc1cccmZ8KPzGIwPcr0AMhfhe1ANzcOiZNvUFlBhqlF7JqZ
	hxKS5oakcUqTG2PC8S6x47+nQsCOaZ/4Csyt/ybSxqRwAmAxDtohqppODEjTa6zub3crPGCE/MJ
	OW/CgwAt5WkLlhjgujKj28Jl0YxqB01SM01BljRSGNpj7cFeMx7iXxpZDVC6NEVxzrbHoC4Sb8n
	YDjCcpm33KX0Xt8BCG3Gs0PlajpOSU3g1u/KzdFoiddN/Sh6wGvGQxhkb8tK2mMTBJmnQtyiNYY
	q7EJb5gnsWuoM2HyJ2ej/6wz35r2xZmm92tVChcnEdTpzrJA4xINNR7Yzl0/u8in9kamCJutOrl
	V5QnSNGlLZ1naG5ja0H0eGAAQ985bhdequ88zjVjH9r5UCeb6yp9yDB139hMI+Fowst26y1kzO0
	xdoeyen9XYwtrVwZxKlV0doCLGLvBd+W05cDblKeUm1aYYy1vtBeAVEfYm
X-Received: by 2002:a05:6000:220a:b0:460:fff:be24 with SMTP id ffacd0b85a97d-4606da70d96mr4064383f8f.19.1781269360407;
        Fri, 12 Jun 2026 06:02:40 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f23fsm5713393f8f.9.2026.06.12.06.02.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:02:39 -0700 (PDT)
Message-ID: <41144b71-4ae0-455e-a63a-95151921372e@suse.com>
Date: Fri, 12 Jun 2026 15:02:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 49/60] scsi: qla2xxx: Add 64G/128G port speed setting
 support
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-50-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-50-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The port speed setting paths topped out at 32G: qla2x00_port_speed_store()
> only mapped sysfs inputs up to 32 (and their no-loss-of-sync forms up to
> 320), and qla2x00_set_data_rate() only accepted PORT_SPEED_AUTO/4/8/16/32
> in its switch.  A user request for 64G or 128G therefore hit the default
> arm and was silently downgraded to auto-negotiation.
> 
> Map the 64 and 128 sysfs inputs (and their /10 no-loss-of-sync forms 640
> and 1280) to PORT_SPEED_64GB and PORT_SPEED_128GB, and accept those
> values in qla2x00_set_data_rate().  The firmware validates the requested
> rate against the adapter's actual capability.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 8 +++++++-
>   drivers/scsi/qla2xxx/qla_mbx.c  | 2 ++
>   2 files changed, 9 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index 308b85e04f26..4c1812c4b420 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -1835,7 +1835,7 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
>   		return rval;
>   	speed = type;
>   	if (type == 40 || type == 80 || type == 160 ||
> -	    type == 320) {
> +	    type == 320 || type == 640 || type == 1280) {
>   		ql_dbg(ql_dbg_user, vha, 0x70d9,
>   		    "Setting will be affected after a loss of sync\n");
>   		type = type/10;
> @@ -1860,6 +1860,12 @@ qla2x00_port_speed_store(struct device *dev, struct device_attribute *attr,
>   	case 32:
>   		ha->set_data_rate = PORT_SPEED_32GB;
>   		break;
> +	case 64:
> +		ha->set_data_rate = PORT_SPEED_64GB;
> +		break;
> +	case 128:
> +		ha->set_data_rate = PORT_SPEED_128GB;
> +		break;
>   	default:
>   		ql_log(ql_log_warn, vha, 0x1199,
>   		    "Unrecognized speed setting:%lx. Setting Autoneg\n",
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 7c0cc3e9c738..5a5d33e8ee7f 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -5728,6 +5728,8 @@ qla2x00_set_data_rate(scsi_qla_host_t *vha, uint16_t mode)
>   	case PORT_SPEED_8GB:
>   	case PORT_SPEED_16GB:
>   	case PORT_SPEED_32GB:
> +	case PORT_SPEED_64GB:
> +	case PORT_SPEED_128GB:
>   		val = ha->set_data_rate;
>   		break;
>   	default:

I'd rather merge it with the patch introducing these speeds, but that
may be a matter of taste.

Otherwise:

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
