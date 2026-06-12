Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 686B23E5EF1
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:09:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269758; cv=none; b=cVafAKacC0qqKxOO0dx6VfET6eL2vIKsY9+ZuKK8Z4/2n/ej0w+IzL1Z+oaECxK8h0kd5CL0YHGfjiTvvNBBUA9qzdQ4sea48YgBb/Z36N0QEoU5RA9AAHG8YWbwRSLaeRqmj6krprQXkkdhVROK8SZN2pIiHqzjDeF5A4LgItI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269758; c=relaxed/simple;
	bh=0D5E2Lg6DDFA3IiT/nidQaiHeH9Yz3qHG4XcZ1k/lEc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IXGdzKbfRFZQBL3hWmpPVx9zki10FehJgAT6lPMBNiXbE+U04emfn91odHxnTbBlwDA71BWlYJNOxZI+oeGqixj5oIYbB0QISawW4DBzq1LoWFr7i8v9cRPlngFz5KUCqCxJG+gEm4Cm2u5YQjcvYdLvBnsMjHXxX4uss+2G/CA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=L/1b/zhG; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="L/1b/zhG"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so4441135e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:09:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269754; x=1781874554; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=eiR3AZzWmPHQQLMRGbFKgYC9l+2sz0bIyEfzyk26NRo=;
        b=L/1b/zhGYhYb4FnhqFEz3fe+pwtxhzdilRpC9qQq/udLouzX/E7lUpB65qqbws1urJ
         U40fBzokbR8NfsRMP9o4PakOL6qMhmGqMQPqxsmaB67xt0Jsr7ckatKrKFYZ1Aqhm/0u
         GzoBnxVZ+OW+Vt47aGz3/XWJmZuLnPZJJ6UDJF0kr0UnMEJjHpYUN0RTyQVWLIgOTTz/
         lRPe+lbf+BaESaSnH2d66dfCSKPO4ksxgFbtvnSCo92eWhMqjOahryWN6Wf9l8ZGqtY0
         3vohIz57wTYCiMeHaqge+R5qHvL4r3PK7BSFvGjzPuVxmhvl+7Vh6D5fbXcJM6B8McB5
         SGrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269754; x=1781874554;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eiR3AZzWmPHQQLMRGbFKgYC9l+2sz0bIyEfzyk26NRo=;
        b=NYTp3ceSFfXigvwGwsBg+44wbrYtrKeJfZYUMbKJmgGY4ED/mZIDggVLjfT+qih9hG
         L7HpeSBqn+6Go+nK5ZHcGwuKfV7YzujysAk/ckaMMleJzX0kP2GJPSxtabfLkuPHWmra
         R7VNQJlB22cThuRZTb0LUqvqpWtMV82x+0v2di9Ms2ea/WTGOnRTnmhU9oK5arK2GcH0
         tIpifEx718MHNw1Jp2ZOn2Y0Z47CDNfVWsqPen3CsKW3q4H4CPBssonJmBEuWmM1nRos
         Lj0hTfrB7oo7qIOPnfi+hjkTxd2CDowuWRbBS+b/GduCkCydVOT4QaIqnEW0ThsXMOEg
         ZFlQ==
X-Gm-Message-State: AOJu0YyszEdeV2GywY3HEwn8qSmuKa9PHi7Jxg6SvMggt/P1avROEfUJ
	XqzQlaqQ9UZ4Xe8S2XyS+9N8vuH4Semikym1OHVpL5EVwyYIcnnzyvR5Mt3lUFJdWrBqd11UR3X
	ZAe2H
X-Gm-Gg: Acq92OH0kGzYZicpygbnhW4U2V4PE8Np4yLmAnhXFYEQF+JkrFIZHCfNu1Ay3ai0T1f
	a2lF6GHRZn4l4OQQ06CHf56YlvGpes3zrdeCjaXva+t6S9lFTxFau5JfyjTV/NGjbmydbYu4aZ/
	baBK9SAPn7Thw1yoRUbjToyQznBb9HfqjejMrh/XzYdBAiBQ/yCQVXWR6XdA+MN9lYtgql34BkJ
	21m8bLJGL6pmojgr++t7Wk0pZjKlEBVlm4uRiiB2kREjJF6g1hb6ekatnjENUc++We+KgM6z8MQ
	9OdnoFzmLnzKsDEMdnhwDCysLSDuGJRudYfHR8H7oZcfqv7c+UxbH853UNh5VwoH3dL9/ylnlpn
	ikSilN+eskrdi2TFe3WoMv4bFZtW0NmTVMKXoF+6D6v3/ZwQix4wAINt4qo8KgK1C3BK1s1HsCZ
	o7KhpXw/nWoakyfYkaKMLsFxM5l/wxDuxAMuJGK8B32umNVgQG+wVqJiIdSZU+VVSq2HA=
X-Received: by 2002:a05:6000:2384:b0:45e:945b:276 with SMTP id ffacd0b85a97d-4606dbc6787mr4353820f8f.20.1781269753628;
        Fri, 12 Jun 2026 06:09:13 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f3dcsm5627025f8f.13.2026.06.12.06.09.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:09:13 -0700 (PDT)
Message-ID: <a9e878d5-cff2-4e2d-9835-c8ec18208178@suse.com>
Date: Fri, 12 Jun 2026 15:09:12 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 53/60] scsi: qla2xxx: Bound VP index against VP_CTRL
 IOCB bitmap size
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-54-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-54-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The VP control IOCB selects its target virtual port by setting one bit
> in vp_idx_map, a fixed 16-byte (128-bit) array in both
> vp_ctrl_entry_24xx and vp_ctrl_entry_24xx_ext. qla25xx_ctrlvp_iocb()
> computes map = (vp_index - 1) / 8 and writes vce->vp_idx_map[map]
> without checking that map stays within the array.
> 
> max_npiv_vports is taken from firmware and only sanitized to a
> MIN_MULTI_ID_FABRIC-aligned boundary, so it can legitimately be 191 or
> 255, and qla24xx_control_vp() only rejects vp_index >= max_npiv_vports.
> A vp_index above 128 therefore yields map >= 16 and an out-of-bounds
> write of up to 16 bytes past vp_idx_map, corrupting the trailing IOCB
> fields (or the adjacent request-ring slot on the 64-byte layout).
> 
> Reject a vp_index that cannot be represented in the IOCB bitmap in
> qla24xx_control_vp(), and add a defensive ARRAY_SIZE() guard in
> qla25xx_ctrlvp_iocb() before the write. Adapters that report the usual
> 63 or 127 NPIV vports are unaffected.
> 
> Fixes: 2853192e154b ("scsi: qla2xxx: Use IOCB path to submit Control VP MBX command")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_iocb.c | 6 ++++++
>   drivers/scsi/qla2xxx/qla_mid.c  | 8 ++++++++
>   2 files changed, 14 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_iocb.c
> index a103be30fddb..8b5a13823b3d 100644
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c
> @@ -4068,6 +4068,12 @@ qla25xx_ctrlvp_iocb(srb_t *sp, void *pkt)
>   	vce->entry_count = 1;
>   	vce->command = cpu_to_le16(sp->u.iocb_cmd.u.ctrlvp.cmd);
>   	vce->vp_count = cpu_to_le16(1);
> +	if (map >= ARRAY_SIZE(vce->vp_idx_map)) {
> +		ql_log(ql_log_warn, sp->vha, 0x307c,
> +		       "ctrlvp: vp_index %u exceeds vp_idx_map capacity\n",
> +		       sp->u.iocb_cmd.u.ctrlvp.vp_index);
> +		return;
> +	}
>   	vce->vp_idx_map[map] |= 1 << pos;
>   }
>   
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mid.c
> index 7072af5b4217..b7d9c1a53f3c 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -987,6 +987,14 @@ int qla24xx_control_vp(scsi_qla_host_t *vha, int cmd)
>   	if (vp_index == 0 || vp_index >= ha->max_npiv_vports)
>   		return QLA_PARAMETER_ERROR;
>   
> +	/*
> +	 * The VP_CTRL IOCB selects the target VP through a fixed 128-bit
> +	 * (16-byte) vp_idx_map bitmap, so vp_index must fit within it even
> +	 * if firmware advertises more NPIV vports.
> +	 */
> +	if (vp_index > sizeof_field(struct vp_ctrl_entry_24xx, vp_idx_map) * 8)
> +		return QLA_PARAMETER_ERROR;
> +
>   	/* ref: INIT */
>   	sp = qla2x00_get_sp(base_vha, NULL, GFP_KERNEL);
>   	if (!sp)

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
