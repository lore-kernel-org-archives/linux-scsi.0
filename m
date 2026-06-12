Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AED6352017
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269805; cv=none; b=JdI7bbN/X1OQHXqlGrDSuNKb2Q1XMI6VepiEWRG8XtPF1O4bFTzVjXaNBjCFX2sg7SRNdHEjPVCPW6vLrm18UUg81pBmw5m18qOcgYg+MLCeGnGM92YD+XX8fcW9ltvI4rnRJIsSqjYh8G+kZmrzFNqcQk7+f3IwtBxbi11qvzc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269805; c=relaxed/simple;
	bh=qo37hH9o4IYYEA/93bmUz5IcEC7URqOybXyBprnsOkk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dpa786IlPIU18LNkkPmuaXWry1mBvEJFdoylFM74UEqX4KPYlUeBUI6BindIkai1Bm03i25imnkcLjoOwGyclNSLdh2D9OFjKEcNC4sMbBRd3OqoKaxEypXrQWYPv9mmBDp/kHZJSe7Hdvba0weCkCRBmEQGI8w3Y3VCWJ0yoyo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=JHpGQuDV; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="JHpGQuDV"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-490aebf33e9so4446375e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:10:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269803; x=1781874603; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iPeC7BkfAYwphte+EOoCK2zVEn5tGYbXHS5ERFiRbUQ=;
        b=JHpGQuDVH5+CxrsjGpAUlN65SsVobNKJhuI7uQ2ZQejFRX5qRLQxi0AUnoqd3jjOBq
         kjBp7N++gTTZK8YO5T9hripRbisiZhWyYLVb+uYmCHJSMrvKvXnFsHOSFRqnJlDQBeFt
         cdmIOqFyPa3Qs5wUMKa50nlMr1MAxH3saK+JSZ524+B9tNBl46tfAZegJfqFCid/t9NQ
         rARVgk+FQUA4/AKKvlcNAsfSd9Cht2WtBkvKWPW47rUgGt01LkzwPwzDrqpKvKxkgf2W
         aMqs4l4dDtJpAscLW6o7wYG3JoKvZzQQsJ0zSf+/1tIoJwRYDu0N5BUT5n1O4WZ1doW/
         Uwzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269803; x=1781874603;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=iPeC7BkfAYwphte+EOoCK2zVEn5tGYbXHS5ERFiRbUQ=;
        b=k/yWGh9JSli77wMte9XmANHZcqLxP1Bn4R3VDUb060sevBiz5Xvf9jZ/H7qRf+wvis
         rXS7NEnkrvHiXVzt/TDtc6FTgyaAY0LEuN+1kTEiDSavWcGkrWv6gDQBLof84LUI3DNj
         OzGLWWnkVG+ch975TWtToU/8dH7ARGz9or6Dib9nZRvmyvMfzCGYU2QI4woXq2rZNvlc
         HezW8r9KcNsgV4S5hd+fjqCUq641nTo5ol5h8cb2MFTqi+AD2qQsj64jtbBT+wmcEFRq
         mTMHzXJpakik6d98oinJjEUFIFJsk4oMnPCb/jYAvZZPKt9YnsxALc/WdV1EHZHeLMHE
         S9DA==
X-Gm-Message-State: AOJu0Yz+MiusUQnVZUsCDwN4nLBWeNhClWlXwaCu5EN7tjPPvRVSbNCh
	oTD9FD4c0cFWEjRe0RDOToXbCDFwBvcrn2V+9NRro/HmMaxrYXRORq1A01s4jQApQ54=
X-Gm-Gg: Acq92OH9NXeckN8JJQagZQBehpjfSwiA2MIMFDXNpKxQY/4VY9NfrH5uqNLcGIInyef
	pxG9MEXdhGpB41db1nYJCDX5ThvIdmQHELO/f93B48ZRciYmHcHh5+CMslOUgcXVNnTrJ9xIjFx
	5xQyv13M2paTqn+526GuxfLOHLLpPdcMm+PdZe87KwYjjBM65371Jg/4U1yYa17beEiiuX2HvT3
	ytQBrWL/i4ucSXnySts+KShOFmOddYFRTIaK2jhphd/JGwcDo1cMYkovNwDtg0zngbYatqXrBaw
	urpTp9qT/77dMqsNvWcIVNy0J1EDMC720e8Goq8BmiVmnDzSn1z6gK0tbRHOLrju4jWB2kT13Xt
	Frk/fOmWUXPmUp0la5xF6XRZN+SKMUjtgh547KpuiCjH791KG64cQtZnOHZHX7Fy5hHoZI/QEfZ
	w/800dz2ufIoiFNmbf507leWGo1sDsoZuY90dwsBPrlEAJ/Z6H7sTflsWy
X-Received: by 2002:a05:600d:6452:20b0:490:3f7a:108b with SMTP id 5b1f17b1804b1-490ec4fb540mr26873875e9.16.1781269802555;
        Fri, 12 Jun 2026 06:10:02 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490ea7c8f15sm67249475e9.4.2026.06.12.06.10.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:10:02 -0700 (PDT)
Message-ID: <e37fed00-ccc9-4997-99e4-9812c08ff48c@suse.com>
Date: Fri, 12 Jun 2026 15:10:01 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 54/60] scsi: qla2xxx: Check entry_status in
 qla24xx_modify_vp_config()
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-55-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-55-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> The Modify VP Config completion handler labelled its first error branch
> "error status" but tested vpmod->comp_status instead of
> vpmod->entry_status. Because CS_COMPLETE is 0, the following
> "comp_status != CS_COMPLETE" branch duplicated that test and was dead
> code, and entry_status was never examined at all.
> 
> When firmware rejects the IOCB early it sets entry_status while leaving
> comp_status zero. As the IOCB is allocated with dma_pool_zalloc(), both
> comp_status branches evaluate false and the handler falls through to the
> success path, calling fc_vport_set_state(FC_VPORT_INITIALIZING) for a
> configuration the firmware never accepted. This can leave the virtual
> port enabled on top of an invalid config and surface later as login
> timeouts or follow-on firmware errors.
> 
> Test entry_status in the first branch, matching qla_ctrlvp_completed()
> and the login/logout/abort/reset IOCB handlers; the comp_status branch
> then becomes the live completion-status check.
> 
> Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index d661662aed26..8a001b489fc0 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4409,10 +4409,10 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>   	if (rval != QLA_SUCCESS) {
>   		ql_dbg(ql_dbg_mbx, vha, 0x10bd,
>   		    "Failed to issue VP config IOCB (%x).\n", rval);
> -	} else if (vpmod->comp_status != 0) {
> +	} else if (vpmod->entry_status != 0) {
>   		ql_dbg(ql_dbg_mbx, vha, 0x10be,
>   		    "Failed to complete IOCB -- error status (%x).\n",
> -		    vpmod->comp_status);
> +		    vpmod->entry_status);
>   		rval = QLA_FUNCTION_FAILED;
>   	} else if (vpmod->comp_status != cpu_to_le16(CS_COMPLETE)) {
>   		ql_dbg(ql_dbg_mbx, vha, 0x10bf,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
