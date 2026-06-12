Received: from mail-wr1-f43.google.com (mail-wr1-f43.google.com [209.85.221.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0768E2D94BA
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 13:11:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781269866; cv=none; b=R0QxGE3mEBZkbHkkBCkdYFApcvJTbtCUWR7brB0RgHDMwuwOu1WB82vNt41yAvUj8KNzMIeeDzMmZGOoEdxp82d5keehWoWSc/DhEdLp9kOcPNLTQ4dU0pKsSyN34GlwrQtIcyvWQ3vINv4yYApZfISYdE6KSjera3Uo93vR1sg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781269866; c=relaxed/simple;
	bh=fVectCKLmdiN6jLT9U17NdSKm6hnCsfy9F+i4piExxw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FVwxJdsq0SnSYr6nsPUBUJ0zLwqueIjeQff4dtdCG4gfIgQyW2eS/INI0bH9xlVuzE0yTH83X+rzcTFIjXtEve+RlgrNswxBpeRu+5ZwMGOP3zLJ1uuVctqJFSu+W0lNuYQBtmytZ4pf+kzYj2hEKBPJhH1Z+e9Ugq444wzI8o0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=F6FNiv7r; arc=none smtp.client-ip=209.85.221.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="F6FNiv7r"
Received: by mail-wr1-f43.google.com with SMTP id ffacd0b85a97d-45ef5146b56so1341813f8f.0
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 06:11:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781269863; x=1781874663; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=AKZ+ilGlmlEbsvI6P63towObL1jz8W6nDrpeEC5G8MM=;
        b=F6FNiv7rNCKO97w+fYRV1/TS+TTcTReE7Dk0+tbMKaC8kaRxklBKw9qm+C33pizKIW
         J4q1hzs0T7mqEnw2E8yQo2XM/yK18f3kKAGRijlX/G52I/d/wxemg6LBMgg1LYzWk8b/
         YaE7p9c+ZgGPCMzk4odVhMEZQxa0CzBfn6TIwjb9JYQh6zkdOLNXQGPCGFWQ+JTO24OK
         lafOOp7nQBUNezjAzaP1CixPOXgCOha7gbTEyWSU1qGM4kaHhiblM7k62LuOaGT8V3hz
         S1RnW7DlbEEiP/xjwMauHlcKwb0BpiOni3VfCjtwCUnaqEteNuCikTsJLbpt/LOBZhFq
         TbnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781269863; x=1781874663;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AKZ+ilGlmlEbsvI6P63towObL1jz8W6nDrpeEC5G8MM=;
        b=i3tydivmtWMqEDmVfFnK27a+nUfbPM6vVVnhl76KANFjVlOpU282MipiRnfXCcbpwk
         Tfb8AYKrc0DYSp56U2uvh2d5eT4Ij9k3JhurnLwrHx2Wg1Llo3YFyMxnydth4OP0T7qz
         ol4zhEXQJfrXxMYkPgVqYA92vgOftaCskFJ9UgixM84uP/smdufMALoYLcmAbkvrv67I
         2RqU/0kvrnwz6kzqFxHPIVaC9CFa0Z1QPt5KGc1g4VIVZjjaQyrrPcS0jZg3Zh0Sgh2O
         5CDWLiF7Tfg8n9Mw00QAswc0ilvxmuRLI40uMYPEhWupKsTHgFNeAKyoTBnbm/EMFxUF
         wEjA==
X-Gm-Message-State: AOJu0YyaQTn4PRy69Ig0VRwrmh+P74u3vuDIk8NtUnJbiVPEGuIIiFs/
	reQ2OrW1zINC+Ud7eA28B1gt/5yZjhDK5tS5hyYNCB2BmhR3i/A0y+dNO5gxswUOKkA=
X-Gm-Gg: Acq92OGHxrorgxcDgL6tYbCrS2G56n21jOBBzzLUNR/YhwvNw2OnL+iJEsheTEWhupN
	Dr5WmV0KbwpSNf2XHENIUgKb0DTekGbNGF59eqarPxUEFXoQtewyBm20Q3cliRg7Vbi05QO4ebR
	gBaJVClPqiaSmQgCxz1lYIyG/r8NKtvi6U02tlvHVoARVspnBvDs2N60WjYh2Hssv+c3WCudQFO
	AqugRca/XTmTOG3KzY+xjootK4B0H+w/VW/twI8pdlJaEeJ5/6Kn875J235Dpx1mNZ8geCBzWTr
	yQSWGWAN5hYFy0u58Sv19c6fqtWC/o1Jy4n1LkoFHsQrBhuOdmvvow+05ljvBc8hNNMt30GPpEh
	39ygMQGO+SToz95ZWQiXD/oeK+Pm/Xg5LVOuWytH4HERZZ+pqdEGoCJgv2j+LtCeo4//UzmonMH
	CWCa///72iMUXdvah6j4EAbNoIC8H28JlqBBv+QSZBXqztwu/XI1VruSM/
X-Received: by 2002:a5d:5d10:0:b0:45e:9304:a4c3 with SMTP id ffacd0b85a97d-4606f25dc7bmr3356121f8f.19.1781269863433;
        Fri, 12 Jun 2026 06:11:03 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f263945sm5941925f8f.8.2026.06.12.06.11.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 06:11:03 -0700 (PDT)
Message-ID: <c61fa355-40f1-4486-b725-bc8b20ec66e4@suse.com>
Date: Fri, 12 Jun 2026 15:11:02 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 56/60] scsi: qla2xxx: Initialize NVMe abort_work once
 at submission
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-57-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-57-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> qla_nvme_fcp_abort() and qla_nvme_ls_abort() ran INIT_WORK() on
> priv->abort_work immediately before schedule_work(). INIT_WORK()
> reinitializes the work_struct, resetting its list head and clearing the
> pending bit. If an abort is issued more than once for the same command
> (for example, concurrent transport teardown and a timeout-driven abort),
> the second INIT_WORK() reinitializes a work item that is already queued,
> which can corrupt the workqueue list and lead to crashes or a looping
> worker.
> 
> Initialize priv->abort_work once at command submission, next to the
> existing per-command spin_lock_init(&priv->cmd_lock), and leave only
> schedule_work() in the abort paths. schedule_work() already does nothing
> when the work item is still pending, so a repeated abort no longer
> disturbs an in-flight work item. The command is not returned to the
> transport until the final kref_put()/release callback runs after
> abort_work has completed, so the work item is idle before priv is
> reused and the single submission-time INIT_WORK() is safe.
> 
> Fixes: e473b3074104 ("scsi: qla2xxx: Add FC-NVMe abort processing")
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_nvme.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvme.c
> index 0038b6274d44..3b2f255a5d7d 100644
> --- a/drivers/scsi/qla2xxx/qla_nvme.c
> +++ b/drivers/scsi/qla2xxx/qla_nvme.c
> @@ -463,7 +463,6 @@ static void qla_nvme_ls_abort(struct nvme_fc_local_port *lport,
>   	}
>   	spin_unlock_irqrestore(&priv->cmd_lock, flags);
>   
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>   	schedule_work(&priv->abort_work);
>   }
>   
> @@ -501,6 +500,7 @@ static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
>   	priv->sp = sp;
>   	kref_init(&sp->cmd_kref);
>   	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>   	nvme = &sp->u.iocb_cmd;
>   	priv->fd = fd;
>   	nvme->u.nvme.desc = fd;
> @@ -545,7 +545,6 @@ static void qla_nvme_fcp_abort(struct nvme_fc_local_port *lport,
>   	}
>   	spin_unlock_irqrestore(&priv->cmd_lock, flags);
>   
> -	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>   	schedule_work(&priv->abort_work);
>   }
>   
> @@ -877,6 +876,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port *lport,
>   
>   	kref_init(&sp->cmd_kref);
>   	spin_lock_init(&priv->cmd_lock);
> +	INIT_WORK(&priv->abort_work, qla_nvme_abort_work);
>   	sp->priv = priv;
>   	priv->sp = sp;
>   	sp->type = SRB_NVME_CMD;

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
