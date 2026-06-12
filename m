Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77C7B31ED8B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:12:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269964; cv=none; b=bhOCwGGfR5Hlx+LyraOJfH1OKNpAoMv4Lz7l4mvc1Meaw95CUniC3ID05PEMv4YxyX7jM3D0zCxG9EN3KCwVV9Pmt+OldShPA/PNn5B35yuQTFNtC616TS65uJpknliyBtp22r206lJkAhTyfcRnhhJoQjchvPxvQ5q9f36LaK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269964; c=relaxed/simple;
	bh=pGDZt9udmopoRvtXoR7kbtvFwnphZGd/pL/vGRlSsvA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=s6VCiYzb7AXunMBNS+NrTZpTKvM6KgQ3NUig7IATdoehT5Gb9m6KpS1+BQNWNoOjYniJVJCIU7+AzdNDb40sq5rTTlpOSVHUJK5KYANUDpUVzdcFYjvlpPSYy1t7Xv1wIm4ksi55GciTw0nvmFaMKiGkkpTX8s9kSGJXwIYbuUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=KKu+SYAz; arc=none smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="KKu+SYAz"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-490ace40f4bso8824625e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:12:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269962; x=1781874762; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=nBVQkErr5NFsIfvdPC/6dtaoQU5KC6DDmVzXZ3Kt+00=;
        b=KKu+SYAzxDyamktu/tSCJIysu3T1mhxC/K3wsPHol5q29ZAL7AgiwUcEeg/IqPXWsL
         rOeAUxNos5mluUTyNrsLogzJ1okCZUFa+L77MIaMKhPLPvWTAFciPUch3IHzdBqPXMsU
         C5r3pIRbupig81Eu5Jw2bCbyeHA++cVmQATMLmR4/WVldTQJOtHB1Qx0DTDlDfVhELyN
         oWbtyyrNB1l5UlJ9qx72g00oGF4bBVB7lfFORhrfZScddgI9qlpNjEq7o1d24cXiLA/E
         fWdXuc0uloH7a9nHERZQCT9P9gLz8oW7sjFw/8IPWM82hhBW+eyJ8RhCQ/6esIvDJ1DY
         F4Hw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269962; x=1781874762;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nBVQkErr5NFsIfvdPC/6dtaoQU5KC6DDmVzXZ3Kt+00=;
        b=GuD9nWTcvjxT+AQSI4+KPR8Oo7w/sKefbk40fjrMPINOnT+1R2OWOpLilakcawvoSv
         OSWfVqs2drZXKmJn4l1yh8kStFlq/ir/OluubKPdP3fRPtSPKevKhWNPXtFrxc2fin0H
         zQUTXcLvk9bhob5pwPmy5QodulSHoK6FcSklFwIRyu0uIyCAeyVs4qBhxZxrt065AXBX
         cjv51Yxd9rjK225WNax5mKfk/k+UMTf5PEB88iTmdMNooHGfzZaIEwHG34RYROZUiQlH
         WNQ3asp2futnPOIn7IhbZLQcUkR+esDfb/WVJFV6RSLn4487G8pxIVrTcZdgcvVwEG2O
         uyOw==
X-Gm-Message-State: AOJu0YyBivhQqlmUIEqqX60Q/Jhha0ckuFhu2UKT7en8c0zrNQVsZjkS
	1KW4X8W7zqlwI/ksxNdny4J7+y8dYjPZxRKpFKDAPkRXY3IQ6TPTBuDAu2taEZBM77Q=
X-Gm-Gg: Acq92OHU/QViOxKwUWQFaZQTfo7kl3DVNEO3iZGDV/AZXLgTAlCE6+UI5sDkHooWYgp
	KHLbk4G+x/z/ylqZI4tA5AVG4VoDhByGb9D83Ti8UcZcpkoOPbEYW/SjqSghYXziCPetN01fWiO
	GeXmw4jYd/jKbkPzV0iYYD8bc+Xbwxq+TOJRZSd/5ZJQkbr/duBUXBF6WVaBXCiUGVHelGIcVWG
	rA1wrF5x9MgBjCGuemn436uHxXlLw8raysOZlTd35OPADFFdbJzFR3MocqFYyDGB4CT5cVa6cX5
	qDNEphEpc0ruu3QkuMQBbvprZAFBS3ny5syjKf78u1/AJB+eHoAq1Jbcb2JBCxEQWi0btExocG1
	qybpZKyMh6mTOaHAourUcqpk92C9NjmnFujZskZyw8pRk+CC2M49zuPdfPi8zFjG88UIh+yjb2F
	iIF9MMRIdp4CZOQKABNfv3ODhM8tVa72IvM/vEEbx2Y1shxz7BEfxBHjL9
X-Received: by 2002:a05:600c:8012:b0:490:b9d3:a9ce with SMTP id 5b1f17b1804b1-490ec5047d3mr38237525e9.30.1781269961824;
        Fri, 12 Jun 2026 06:12:41 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2d0475asm237592175e9.12.2026.06.12.06.12.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:12:41 -0700 (PDT)
Message-ID: <e898b200-8cc8-4629-8101-dcdce6b022a7@suse.com>
Date: Fri, 12 Jun 2026 15:12:40 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 59/60] scsi: qla2xxx: Fix BSG job leak on validate
 flash image error path
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-60-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-60-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla28xx_validate_flash_image() returns QLA_SUCCESS (0) unconditionally,
> telling the FC BSG transport (fc_bsg_host_dispatch()) that the driver
> owns and will complete the request. But bsg_job_done() is guarded by
> "if (!rval)", so on the error path (rval == -EINVAL) neither the driver
> nor the transport completes the job. The request dangles until it times
> out, leaking block layer resources.
> 
> Commit c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double
> free") added the "if (!rval)" guard to a batch of BSG handlers. That is
> correct for handlers that also return the error code (the transport then
> completes the job once via fail_host_msg), but this function returns
> QLA_SUCCESS unconditionally, so the guard turned a correct single
> completion into a leak.
> 
> Always call bsg_job_done(): bsg_reply->result is DID_OK and the error is
> reported in vendor_rsp[0], and since the function returns 0 the transport
> will not complete the job a second time.
> 
> Fixes: c2c68225b145 ("scsi: qla2xxx: Fix bsg_done() causing double free")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_bsg.c | 5 ++---
>   1 file changed, 2 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_bsg.c b/drivers/scsi/qla2xxx/qla_bsg.c
> index b57c55964f9e..22be6c822dda 100644
> --- a/drivers/scsi/qla2xxx/qla_bsg.c
> +++ b/drivers/scsi/qla2xxx/qla_bsg.c
> @@ -3734,9 +3734,8 @@ static int qla28xx_validate_flash_image(struct bsg_job *bsg_job)
>   	bsg_reply->result = DID_OK << 16;
>   	bsg_reply->reply_payload_rcv_len = 0;
>   	bsg_job->reply_len = sizeof(struct fc_bsg_reply);
> -	if (!rval)
> -		bsg_job_done(bsg_job, bsg_reply->result,
> -			     bsg_reply->reply_payload_rcv_len);
> +	bsg_job_done(bsg_job, bsg_reply->result,
> +		     bsg_reply->reply_payload_rcv_len);
>   
>   	return QLA_SUCCESS;
>   }

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
