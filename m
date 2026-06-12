Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE8AF37D104
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:04:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269476; cv=none; b=h3kILHqn8/X5EKxxbjaNNu5Suo/90IHDI8hcGuk6xje5UhWOOp6wUTTYA0tzOKKlTGyC+EPr6CzxpyRdIlG6z6teuePU18rN56oEX0gmFKVHMV337KlIx5lvCe1OvRfld4goiCQzCvldy1Rt21nZQFbObjKMy+LOx5hJXAsty8w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269476; c=relaxed/simple;
	bh=trvIFQDxjnx5yhNQiFPf838h1bXUxWXfdh/hop0dymM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=r5smsaf2Ii60Gy0WMRhR4/oZVJcbXJAZanQoar0e0XAz9kgzNrmuObdoldluh+xQcBEig85YZqqK1DrEApquTojcJF65nxv9dx/3D4jurSkay0GNzpHlgobXLjGMmEKdBoQ/mUozJ+E+qWPyBbkoEuhtn42kPlx4eG40uAd8zjE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=FpYv9C40; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="FpYv9C40"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-490ace40f4bso8753975e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:04:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269471; x=1781874271; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=75tOISUMOt4SIaXJrlETJ/JtaKpwbrnqeX5thUczVpo=;
        b=FpYv9C40w+IQ3lWzGeB6KjuHMsJ2SbS7lDutvyuJtOnYU2AaGE0Xmr+9NPRBwF0GZW
         zZFA4LzgbE8O6qh6VYKxNfMD24l0wzhC0stbaxmb8zaRjdOfmk9goZozmU8gi6bEfQ5n
         /o6l/Etn+GwufniyZ0m1ZWk/klGunJ3f9atzker3kU8eX8IVqjKGOcqQiLJ7IcGnANwX
         sxXNI0m3nSrk2mHgAQi4KcILPAVhl/hIrnsyNsS7VcwBuCiB5niGKlAxvzGnQxMce9aV
         jqWu9To9htfH87e6ESTeNsa5QqgvsGXigM3JYxeyX1XZZ4OVOJxaMXCFa8oHSjgmtiLm
         3H+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269471; x=1781874271;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=75tOISUMOt4SIaXJrlETJ/JtaKpwbrnqeX5thUczVpo=;
        b=sUeuqjmgyUEg8vGeRQIyGBDNEu+vOFoHm06fhgDgMZ6Do2xW20oQ2cQ4sKCNgwMCPt
         XqFIlwC7sgaPl0BAQtgkLfhcuimeZdFzbmpIwYyR1ibH3RbzpKxDDa2Ye9HsygETgUHN
         JhPPYt7Og9n+zk7ZvFy9hWKozkWIcxcwr+j+EgbOl9MWKWKn2IMaU9Gg2HQ8yP0WYrG9
         v1Ehw6krKtUcrs3MtLNGturNct9OTTGBeFNoaVgIHUtqpkN68iwuzEPk9z/HdabymLt/
         J/yb8k/VfclyvumtnrfvevRLfSRTu1IxvOr8RQapGDPmjr3bxEl4DocTNdaXLGOIPu/U
         cNXw==
X-Gm-Message-State: AOJu0YzNpcEfvzVKxbQ43TtU7ZqkkDvgAOGZcZqik/78pi957jF+J2im
	AraMyaJEJ3V1XsOxb+eHlCYU96OzBP9fYWG4ftuu/ebW+LHwpY0dUvask1FhBNd7Oag=
X-Gm-Gg: Acq92OFMA+8CZkhm7h2d1AFFI3HzXHhZRJ7zKy81BSQuflrEWb6o9+y0OgsgVqcD/p9
	u0BRJzeixVMakoM+GgaYJG4wF3iYIMMgEMvnBH+x25DaAOT4fE6/MsB9GHfFWexYWku4opnT44A
	dBJSD5ijwIEVtg0tz6kj2IaP2EhfGpASob/xRu2upA/yisZeY1mQCMLk/LVGg1vD6n7YSE9i8Aw
	RgnYAy3GKODxSTpK+qhCPhgUTTUgfHipAtxwD3FbDlvLs8vzDqIN2ydFq2p/yJ1WGXNmHU2SRw2
	oVEMKbaeiBj4Piqikn8ESzdx2xs8DuFlarx7+Q64dvjuuu6zKNTcpZr5RdePjmTExD5zLHKEbeD
	/YvHoJJH0u0XWQNoDr8lZs9tMvLvuwn/8lzH5p5hwWqmX9WRmT67bNGD1Dp5lCu6J1YzmoHrtP6
	nhQxTMQxm++U9J1aY4v4oOsshX1CgonJjXCaxVOKDf7Vpw21UWt8SR3S/T
X-Received: by 2002:a05:600c:3105:b0:490:e60b:6860 with SMTP id 5b1f17b1804b1-490ec4b5a3cmr39289745e9.7.1781269470854;
        Fri, 12 Jun 2026 06:04:30 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2c0d360sm169215885e9.0.2026.06.12.06.04.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:04:30 -0700 (PDT)
Message-ID: <99864d0b-f376-46da-9700-d476440c0a01@suse.com>
Date: Fri, 12 Jun 2026 15:04:30 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 51/60] scsi: qla2xxx: edif: Fix NULL pointer deref in
 RX SA delete check
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-52-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-52-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla_chk_edif_rx_sa_delete_pending() obtains the SCSI command via
> GET_CMD_SP(sp) and immediately dereferences cmd->sc_data_direction.
> That command pointer can be NULL: the firmware may post a status
> completion for a command that has already been returned or aborted.
> The caller qla2x00_status_entry() acknowledges this on the very same
> status path, re-fetching GET_CMD_SP(sp) and bailing out with the
> "Command already returned" message when it is NULL -- but that check
> runs only after qla_chk_edif_rx_sa_delete_pending() has already
> dereferenced the pointer, so a NULL cmd crashes the kernel in
> interrupt context.
> 
> Return early when cmd is NULL, before touching cmd->sc_data_direction.
> 
> Fixes: dd30706e73b7 ("scsi: qla2xxx: edif: Add key update")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_edif.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_edif.c b/drivers/scsi/qla2xxx/qla_edif.c
> index f8bc248e5d18..c8889ea199d3 100644
> --- a/drivers/scsi/qla2xxx/qla_edif.c
> +++ b/drivers/scsi/qla2xxx/qla_edif.c
> @@ -3543,6 +3543,9 @@ void qla_chk_edif_rx_sa_delete_pending(scsi_qla_host_t *vha,
>   	uint32_t handle;
>   	uint16_t sa_index;
>   
> +	if (!cmd)
> +		return;
> +
>   	handle = (uint32_t)LSW(sts24->handle);
>   
>   	/* find out if this status iosb is for a scsi read */

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
