Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 871003E9F7B
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269837; cv=none; b=h6XhgqdyPGtSC6k0iWMBTL7EJHSd9HM0QvMo6z9hCafRzlvvM//8N32b9aCtUvhKhh4C8y97UYjEPQJvXRTyasKOA6c3/Sj8JUdkxyu+scfyLTYQx88ZxowHzWTflbc7Jqgs5pOpyMkqwADCl0jy+C+Bp4NqNeDgg9ZnlhW/WEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269837; c=relaxed/simple;
	bh=GSt/9/b584i9xFkGfSCcA1ufW34X7as5nrMgoeGpU+s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=KMOnB6lnssEeph3iKlMdFfiAZPLwP0o3enKUUU16OB+EZfVd0jBIXlmgc22QKqlaZHrxtfTOD3hFE4h84FzJDqE/Gt/FwqQX6yQAwLMBjmtSr5phnlRaC4I8hfES1jKiDjxoiZ1+mFjaKciLeGCfICK378rR8BqsLbhB1fvD59U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=CxetumlD; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="CxetumlD"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef41adbc1so723961f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:10:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269834; x=1781874634; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ua7l31kHZMj7bDzASWd/6xhxEGGw+tgsFAPuQVXbfrU=;
        b=CxetumlDxf+Ojkc+n4cM0lG8oHBIWzeXxH366LUC/c1B7ZIM71X3laQxYnAaGB+qKl
         MzQD33BMjDAcrPL1nE2HxYSRpBQLLbWeyQh40mUM5yLYIA5wJfsawCQIOk8+wYUhuTRP
         lk4VdJq5wV6lJhx/iWqSeAZp3IsS9kqtju1GfQiP/CzOrbtOYNTfxxkmO7BSYvFfR4/L
         c2L+Qb8OSYr2HxvSd6MAt0X8RSOWxQfKR7fYTLWZ9JCWOcQ17uwpucbrFZxVxvB17dn9
         3GsuUEE5fiZXLhHJ8gukwIfxrLfGf8yjx9NN6tCG48htnlG+25mFwJYZBrvqKEG4KkUZ
         ufRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269834; x=1781874634;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ua7l31kHZMj7bDzASWd/6xhxEGGw+tgsFAPuQVXbfrU=;
        b=W2BQNL2RAPqXJ9+TdWACa1+6iRyZZhRIE6+EHMvpIzYdRFMIr7cAOQrwmvL8vPMmBw
         GNXGx+ecoPXgkp95k/YoMGN1NDSAcTljPP/ZW/IbS2s98uTM1/uCZXUNxaonn57jlX4X
         PCwtKTQuVtC5Xt9WyxmrYMNZqUiM1shB51PZTZqz1neLHBC8MgYPVPe6eTTa0RS6L/2f
         ZPUyrKrcRmq/ZdC8Nw6ij5Eu0/EQ6iM/WH/pwu6tOLMmhwiiNRcHQYGFNeRJXSlb8VyI
         QG+fsnyuqE0JUE0tbGbP9damAXr82FRsqe2EAbcb9I6VH7ORvFMEOO2fhHZzr6meS+cV
         5vbw==
X-Gm-Message-State: AOJu0YxqArdTiycEA3zhUdL7Ze6BTNjs/csQE6/4O7AQURHLpTxLstQ1
	Ui8+F9yzS0If9Hp5nYNcPb8r9hT8vOdxXseONm3dFKNmhj8Gh5/qX9aKSrD6uLjCfhs=
X-Gm-Gg: Acq92OGPxzgX7+GxeQ7OgZMD+xuCaIKZHZMrzhtr9q6VG6szd3zS7ZErhsB0KU3GJpb
	/LKOlP9hLKGGP5QLH89g1i+0S+kl634uZT383eMDFwKEYMG7HwCv4MCJN5kNxJ9sDsH7KMhG0w5
	qdEn+DhceU41jugJc6uL/M8y5XMrg9PYFJ9tirWlZyHZdJ5g+jNSp5rJPYr9fn0m6An5MLoXxOC
	1Yk3tnN0vh8fAu0ZRP8ubewiUU4HNgyjSSCdj3wCvVnZG+Gs0loXBbwyGqWCKCx77zZ+//YQ5yn
	bR8tDcsp+0p19Znbzo2gYMAtmoFibXEOtHkHt6rbRX7GEecsB8YcRVBXNlhgWC7kl3/vVqFAuoX
	CunWAS0kQYrnF691R9H1HlmwTHqHzBXvqhFZduxZIA5Vc0c8EcuIMVZxoROw0LfLd5/7okWgL1W
	jvsdAULSXJXD9JTp2HQIbQVQCNPzhkZ8KqauLW/L86TueFxA2ruoN4Ucbe
X-Received: by 2002:a05:6000:4281:b0:45e:ea68:5237 with SMTP id ffacd0b85a97d-4606da6974cmr4443654f8f.11.1781269833984;
        Fri, 12 Jun 2026 06:10:33 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f2c4240sm5853945f8f.27.2026.06.12.06.10.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:10:33 -0700 (PDT)
Message-ID: <5b9ccd90-ab28-4fc5-b0a7-293e5af684ca@suse.com>
Date: Fri, 12 Jun 2026 15:10:33 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 55/60] scsi: qla2xxx: Hold vport reference in
 qla24xx_report_id_acquisition()
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-56-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-56-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> In the format 1 path, the virtual port is located on ha->vp_list while
> holding vport_slock, but the lock is dropped before vp is used:
> qla_update_host_map() is called and VP_IDX_ACQUIRED/REGISTER_FC4_NEEDED/
> REGISTER_FDMI_NEEDED are set on vp. No reference is taken across that
> window, so a concurrent qla24xx_deallocate_vp_id() can tear the vport
> down and free it, leading to a use-after-free.
> 
> Take a vport reference (vref_count) under vport_slock when the matching
> vp is found, and drop it after the last use of vp. qla24xx_deallocate_vp_id()
> waits for vref_count to reach zero before unlinking and freeing the vport,
> so the pointer stays valid. This matches the reference idiom already used
> by the other ha->vp_list traversals.
> 
> Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 3 +++
>   1 file changed, 3 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index 8a001b489fc0..bfb931eb14f6 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4275,6 +4275,7 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
>   			list_for_each_entry(vp, &ha->vp_list, list) {
>   				if (vp_idx == vp->vp_idx) {
>   					found = 1;
> +					atomic_inc(&vp->vref_count);
>   					break;
>   				}
>   			}
> @@ -4292,6 +4293,8 @@ qla24xx_report_id_acquisition(scsi_qla_host_t *vha, void *pkt)
>   			set_bit(VP_IDX_ACQUIRED, &vp->vp_flags);
>   			set_bit(REGISTER_FC4_NEEDED, &vp->dpc_flags);
>   			set_bit(REGISTER_FDMI_NEEDED, &vp->dpc_flags);
> +
> +			atomic_dec(&vp->vref_count);
>   		}
>   		set_bit(VP_DPC_NEEDED, &vha->dpc_flags);
>   		qla2xxx_wake_dpc(vha);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
