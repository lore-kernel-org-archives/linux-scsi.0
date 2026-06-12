Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 56BA13DA5A0
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 12:45:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781268337; cv=none; b=Dn0bF4yNqkehvWufdT2RitwhAx+Ic9KGESMldIzI+Ml2yYduqZ9wx8JIXb/gWWmKMdFdxdEsNLKmGhrQJeRHwZelvumLDp6kOodwZKs7yNy2bYNc9MyDS0PamKdi0JiJGuBt0J9EJFvieCeF8vSEoy6+UHTRilJAZ5nOxogTsik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781268337; c=relaxed/simple;
	bh=F8evUBGPM8P6bsQB8BzgMepf1LrBBQ6N813Yko6PSKs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RzPNctJjyNTC8Qxr8fvouK6nr2aoDTwSgBob9h3Sqr47sDhOdPU737rXwxi7VXajj8WPQDoVoBfcKaixnXEdPOZI1tfTTYPEV/kqYpZKFrXpOUdFvX3eQ1G+Q0rU5mlpvyh82aaGIKdujgJMZOcHxXBENadNn3ahbzuQbu5dlLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Ed/fubtH; arc=none smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Ed/fubtH"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490ace40f4bso8592055e9.3
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 05:45:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781268332; x=1781873132; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=9jl2EdQkkotIW/A1wv7nujqbADoUdWbZ1fHfrFp9h8w=;
        b=Ed/fubtH/8tgECxY1M7V7UWlXz/XmedwNVNemsvqEy7bv1iZDJysX3wLzKqb3OMJKq
         U3tReC4GFMM/+JafsfkF30zLbOS8EcwSHGawxQccw99Fy/2s3tG9+XiyyXrd/JFabvw0
         JEI0JNbfVJNEDfLbL/LqjOb/sHLB7M3QZ8THDMsM/GsspR3MvOKZ78v2jtv9Odz51Hdu
         eGb4Broa1RqvSwY4AfsxIIA0ZtiNdRtdxjUEyNHjW3r+ZJl+HlfRVRl6/SwFP6FLhoYk
         fZJsiYhbdjM57/mr5LQwdIU9Lro4CfvbfrQAySVdySB4HRgKbnu07kwOub9/6bgaNVga
         THuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781268332; x=1781873132;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9jl2EdQkkotIW/A1wv7nujqbADoUdWbZ1fHfrFp9h8w=;
        b=KtM/lQoFJaJkhqeq6HUedtgvN3kKdlDG7GUGAs0yl6i5pYJpP5MUQkVCl7CAg1NrYe
         6gjD6meWoqkRyT5q5otbey3WLSBX08v1BfijxEJDrnlWmxpIUhXCH0F4+SR2uL5vq3Mt
         Z5iSBRkq0V18iJFtjY0RQYgEU4PBmD2UsUj6G99Gvd+04mY1rciZHC9ix5sy83Oc7iZL
         rG0vo3r0vEtn6OyvlOEOFmGgim1R4JXRouQxMJZveVoxcRFZ8yvouQFnA5GI1c2G2ptb
         dHeGQmWjlxcMCpLf/VCNrxiPToehFVH/r6PMD1MfjX3VJFmqCCJXJ0JuABTYxi8ljc+m
         3KRg==
X-Gm-Message-State: AOJu0YyGi1h9iK0DPBWhZRxp+WFIZoO56BU0a6eMinXX7l6rxIHhB+49
	k13VBtnNgD8afr6bzl+PlcOSrOdOXZ+DOTVr1cH194LAmc98kcdgA5aqKT0Ejx+6CyU=
X-Gm-Gg: Acq92OFhBiphuKGp4hHP6/Hk6ak4syR3vGcR0o6VQIZq5Z1sLV78napG1SEX11bOf6+
	KZE2dyaizrBHot+sWggv4vHQyPUJ3OcwJdfzkLXWdAFTRQR8lnip7wUbBdWqGSOd/mpuAGeYy3C
	0/U58Q5hfo318i5/btZTc5eJ1TD/i9LH+cMEpvS8Gn8sVGnNycGBabflcAKalGjtjmaEtpsfXsV
	UoGIjTC0XQNWH3Ilx9zbsAtCmCv4Kcsv5llissDZSuE4qjh+1gpRQQdtPLaFVOqUkMs0L8LE2RY
	goTQrIT/pHE8oh7YcXCrZwXfpwjhBuXjEK5UwLYjf408UDygrk1rROfCkt4+MC05HxnX6Z8h7zw
	9dBUsU2ZHy1928O3LrhoW0rSLHzODtKoMDSj/TfHXnOaDs6z9gsJEV4fqcn0zziWhnFbQcHbiE4
	avpGF8KDKmCmuUnRUH/TacuMHt/rTCTdCA19/lokKqWD36l+CCW60eDS+E
X-Received: by 2002:a05:600c:4253:b0:490:50c5:8153 with SMTP id 5b1f17b1804b1-490ec4b5edbmr25040505e9.2.1781268332206;
        Fri, 12 Jun 2026 05:45:32 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-490e2d0475asm234595115e9.12.2026.06.12.05.45.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 05:45:31 -0700 (PDT)
Message-ID: <b8f3542b-38ee-4968-894f-08c2ccb157a8@suse.com>
Date: Fri, 12 Jun 2026 14:45:31 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 39/60] scsi: qla2xxx: Add build-time size check for VP
 config IOCB layout
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-40-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-40-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> Add a BUILD_BUG_ON for struct vp_config_entry_24xx_ext to verify its
> 128-byte size at compile time alongside the existing 64-byte check for
> struct vp_config_entry_24xx.
> 
> Document in qla24xx_modify_vp_config() that the ext variant overlays
> the base 24xx layout for the first 64 bytes (all fields this helper
> reads and writes), so the IOCB can be built through a single struct
> vp_config_entry_24xx pointer regardless of the adapter's IOCB stride.
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_mbx.c | 8 +++++++-
>   drivers/scsi/qla2xxx/qla_os.c  | 1 +
>   2 files changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mbx.c
> index ea39f3793296..bdf03d92e552 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4372,6 +4372,13 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>   		return QLA_MEMORY_ALLOC_FAILED;
>   	}
>   
> +	/*
> +	 * vp_config_entry_24xx_ext overlays vp_config_entry_24xx for the
> +	 * full 64-byte 24xx layout (the ext variant merely appends fields
> +	 * at offset 64+ which this helper never touches), so the IOCB is
> +	 * built and inspected through a single struct vp_config_entry_24xx
> +	 * pointer regardless of adapter stride.
> +	 */
>   	vpmod->entry_type = VP_CONFIG_IOCB_TYPE;
>   	vpmod->entry_count = 1;
>   	vpmod->command = VCT_COMMAND_MOD_ENABLE_VPS;
> @@ -4400,7 +4407,6 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>   		    le16_to_cpu(vpmod->comp_status));
>   		rval = QLA_FUNCTION_FAILED;
>   	} else {
> -		/* EMPTY */
>   		ql_dbg(ql_dbg_mbx + ql_dbg_verbose, vha, 0x10c0,
>   		    "Done %s.\n", __func__);
>   		fc_vport_set_state(vha->fc_vport, FC_VPORT_INITIALIZING);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index bf5f3b16bdae..397f2ffa56d1 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -8435,6 +8435,7 @@ qla2x00_module_init(void)
>   	BUILD_BUG_ON(sizeof(struct verify_chip_rsp_84xx) != 52);
>   	BUILD_BUG_ON(sizeof(struct vf_evfp_entry_24xx) != 56);
>   	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx) != 64);
> +	BUILD_BUG_ON(sizeof(struct vp_config_entry_24xx_ext) != 128);
>   	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx) != 64);
>   	BUILD_BUG_ON(sizeof(struct vp_ctrl_entry_24xx_ext) != 128);
>   	BUILD_BUG_ON(sizeof(struct vp_rpt_id_entry_24xx) != 64);

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
