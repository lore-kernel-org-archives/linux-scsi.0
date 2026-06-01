Received: from mail-wr1-f48.google.com (mail-wr1-f48.google.com [209.85.221.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440BB33F385
	for <linux-scsi@vger.kernel.org>; Mon,  1 Jun 2026 06:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780294483; cv=none; b=Y17tSqw/W2WjPmnBM25nleRRBX60T2R4adJuVbOTQdO1IXN9LzywjcvxrNt0ubvRI3yjBhYC8hTYiYDJyAKpzjpZhRcFlE9uESETuUlVrEVbfIjjqNdfpR4fQ20EjmVIqAtiHdbgwRNtGmeK1xTzeQWDcQBuMUhUUEkuYbvwcwA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780294483; c=relaxed/simple;
	bh=9MNzn12fHIiogHe+ExGRksoHKHMAM3exEmf5WZZ/azI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YXUfmnfsWtdmoYa+1OyNyUozjXE+0e25kuIjvTTT/dRUBIJgq+fkKbPClfNmTU92cSGetxh7eKA0QblEBE+B89VProQuuR3Sy/ph3DuKnxtc+GZKQhCXWLAeHNQRAfjHodQXcOH1jqmhB3Fi8TPenqS+Bkvd+7v4L5Xxaq6XNug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=Xbwlm1tI; arc=none smtp.client-ip=209.85.221.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="Xbwlm1tI"
Received: by mail-wr1-f48.google.com with SMTP id ffacd0b85a97d-45ef4223be7so1373650f8f.2
        for <linux-scsi@vger.kernel.org>; Sun, 31 May 2026 23:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1780294481; x=1780899281; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qnQ4Egkx2jvHi2uwwRkA+XvJq80HYWm7qvhBoPf3qpA=;
        b=Xbwlm1tI4FEILndE3UUHcpqJMPp+Du8rtYxMlSPiGzacjeuta6kaNYOz5iN2GG1HaF
         3Ab7uPt5pdAKS24xjoonBLZh6/uo8n/PNf1jBoGa4C2xfcNTfZRSmkLtrsIy4KpmDQuG
         Tc2RpyVKiYMu9ZMfY1Zm4gkW1Wa5qlOWzrO4goxRa/1ucsWeRN/ya1LNnbSVTJdSVBLK
         WJPoshQmK2zVJXRLwL7bwJXQUa34l8R+3KEj5Ody/eDBP/x4wf3RYQjTGDJ2NauS7TCV
         hRXeesld4X8yfRlnG/WKiOFny9LlnSsa9VjjJu/P33KPcTmJw64Aood1lGCP1WOOxtg6
         +LPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780294481; x=1780899281;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=qnQ4Egkx2jvHi2uwwRkA+XvJq80HYWm7qvhBoPf3qpA=;
        b=o2eZujqAqz+Wi+r2fZeL38PFt2tnO1h7W0DVdjp+uNhlEIBTlxg1bUJ7OyYHWJh9dS
         sNEyatQ5s5hr6csIuPyA1THpRFlMQx0s13pbNPfcs6hZWzcjFGVOcgOsod4QmJjLRPQq
         esCLO6wDQhHJVB2+iAeiFCpd14RzAVbgfD08C8FyAKESuu5IYxEkQRUd76VkLxVhZGRX
         Y9TOLLoz+3Yi7SXeURiUECjuSv1twFNUBPfuXgKUuQIL8RwVHNdISBcmxd3+edBrfaW8
         dTmhmY7nZmTIpXog9C5nb5VH3J4RNGAx+tazLmqQ24Sv5fZ6uErGa/wO/xRJyLo0d0TQ
         z3Xw==
X-Forwarded-Encrypted: i=1; AFNElJ8LQEwqroeOBUKDl477Kg6Rjk56vuD+yrnLX66/hvvXao8+rEFL8hZc3+OPhAYCbRt1LJtCFOMKjOtM@vger.kernel.org
X-Gm-Message-State: AOJu0Yx7m3KadiI/IKkCcvQhOy/gUXEdrOIElQpRV341WGgAWkxxhjxF
	58zGft0cCnakHQGUbBikAQFDNmDnTeB3g3Jdryj8NaxgUs2jcIAcRqs9pqe3NDMH2O3HOuw7eeM
	wNQ09
X-Gm-Gg: Acq92OEy9vgiFYBYEAJ83KNVULs/KaC9g2dTtY3nxUtsJr9RwJ8j62qhx7Q18TTSM+S
	3az0UQRlSsHjd0XopErA01JPAgY0dGfQjutMfbUZp5GVkD69Bn3fOSMCyGd/nDXfFUN1lcqqoA7
	ZVpXr2wxbovaN5LX/8RICT/WZebxbqKpZEDcMUC5z/IzOovBQ98w1j0D2KdxFgJm8Mdh6hbsQWu
	vA69Dis8us2KeQJyXVj+yUeSrgilO7WTOjCuUPwmj+1T4OqSN9BY02ZFBuwlHA8/BNO3GW7N9oj
	WVlcOcPHjoBRgKgNVqUZIcxsdiLsoKUGZk2L0ds22KhF2G7gc/YvZWPdWlIQzXuKbMooFG7bkdU
	X7JVasaFDGSReAYIkql8+HyqoP8jniF+nvk5gyCzscbPkBKb0b3tncic18N58Vxax7ZmggTcZVZ
	NzsFLh5CqK1Sd5I5zYfilmZjrPVilDtZEDPwuvwpIaMUKad3K/p90OPhY14RkE5JvMLur9ivc=
X-Received: by 2002:adf:f190:0:b0:44f:9b70:2996 with SMTP id ffacd0b85a97d-45ef6b4f4f5mr12541489f8f.21.1780294480614;
        Sun, 31 May 2026 23:14:40 -0700 (PDT)
Received: from ?IPV6:2001:a61:2a86:dc01:360a:1184:3ef3:86d5? ([2001:a61:2a86:dc01:360a:1184:3ef3:86d5])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-45ef354cd7csm22555338f8f.18.2026.05.31.23.14.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 31 May 2026 23:14:40 -0700 (PDT)
Message-ID: <c77edd76-39ec-4041-8185-366f76675c68@suse.com>
Date: Mon, 1 Jun 2026 08:14:39 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: target: Remove tcm_loop target reset handling
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc: josef@toxicpanda.com
References: <20260530052349.5134-1-michael.christie@oracle.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260530052349.5134-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 5/30/26 07:23, Mike Christie wrote:
> tcm_loop_target_reset is supposed to handle all the LUNs on a target
> but it's only doing a TMR_LUN_RESET so only that one LUN is handled.
> This will cause us to return early while IOs to other LUNs are still
> hung in lower layers. This just removes the target reset handler for
> the driver because LIO doesn't support target resets and for the
> common case where this is run from the scsi-ml error hamdler we have
> already tried an abort and lun reset so waiting again is most likely
> useless.
> 
> Fixes: 1333eee56cdf ("scsi: target: tcm_loop: Drain commands in target_reset handler")
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>   drivers/target/loopback/tcm_loop.c | 64 ------------------------------
>   1 file changed, 64 deletions(-)
> 
> diff --git a/drivers/target/loopback/tcm_loop.c b/drivers/target/loopback/tcm_loop.c
> index 110297345751..d29830b951f7 100644
> --- a/drivers/target/loopback/tcm_loop.c
> +++ b/drivers/target/loopback/tcm_loop.c
> @@ -270,69 +270,6 @@ static int tcm_loop_device_reset(struct scsi_cmnd *sc)
>   	return (ret == TMR_FUNCTION_COMPLETE) ? SUCCESS : FAILED;
>   }
>   
> -static bool tcm_loop_flush_work_iter(struct request *rq, void *data)
> -{
> -	struct scsi_cmnd *sc = blk_mq_rq_to_pdu(rq);
> -	struct tcm_loop_cmd *tl_cmd = scsi_cmd_priv(sc);
> -	struct se_cmd *se_cmd = &tl_cmd->tl_se_cmd;
> -
> -	flush_work(&se_cmd->work);
> -	return true;
> -}
> -
> -static int tcm_loop_target_reset(struct scsi_cmnd *sc)
> -{
> -	struct tcm_loop_hba *tl_hba;
> -	struct tcm_loop_tpg *tl_tpg;
> -	struct Scsi_Host *sh = sc->device->host;
> -	int ret;
> -
> -	/*
> -	 * Locate the tcm_loop_hba_t pointer
> -	 */
> -	tl_hba = *(struct tcm_loop_hba **)shost_priv(sh);
> -	if (!tl_hba) {
> -		pr_err("Unable to perform device reset without active I_T Nexus\n");
> -		return FAILED;
> -	}
> -	/*
> -	 * Locate the tl_tpg pointer from TargetID in sc->device->id
> -	 */
> -	tl_tpg = &tl_hba->tl_hba_tpgs[sc->device->id];
> -	if (!tl_tpg)
> -		return FAILED;
> -
> -	/*
> -	 * Issue a LUN_RESET to drain all commands that the target core
> -	 * knows about.  This handles commands not yet marked CMD_T_COMPLETE.
> -	 */
> -	ret = tcm_loop_issue_tmr(tl_tpg, sc->device->lun, 0, TMR_LUN_RESET);
> -	if (ret != TMR_FUNCTION_COMPLETE)
> -		return FAILED;
> -
> -	/*
> -	 * Flush any deferred target core completion work that may still be
> -	 * queued.  Commands that already had CMD_T_COMPLETE set before the TMR
> -	 * are skipped by the TMR drain, but their async completion work
> -	 * (transport_lun_remove_cmd → percpu_ref_put, release_cmd → scsi_done)
> -	 * may still be pending in target_completion_wq.
> -	 *
> -	 * The SCSI EH will reuse in-flight scsi_cmnd structures for recovery
> -	 * commands (e.g. TUR) immediately after this handler returns SUCCESS —
> -	 * if deferred work is still pending, the memset in queuecommand would
> -	 * zero the se_cmd while the work accesses it, leaking the LUN
> -	 * percpu_ref and hanging configfs unlink forever.
> -	 *
> -	 * Use blk_mq_tagset_busy_iter() to find all started requests and
> -	 * flush_work() on each — the same pattern used by mpi3mr, scsi_debug,
> -	 * and other SCSI drivers to drain outstanding commands during reset.
> -	 */
> -	blk_mq_tagset_busy_iter(&sh->tag_set, tcm_loop_flush_work_iter, NULL);
> -
> -	tl_tpg->tl_transport_status = TCM_TRANSPORT_ONLINE;
> -	return SUCCESS;
> -}
> -
>   static const struct scsi_host_template tcm_loop_driver_template = {
>   	.show_info		= tcm_loop_show_info,
>   	.proc_name		= "tcm_loopback",
> @@ -341,7 +278,6 @@ static const struct scsi_host_template tcm_loop_driver_template = {
>   	.change_queue_depth	= scsi_change_queue_depth,
>   	.eh_abort_handler = tcm_loop_abort_task,
>   	.eh_device_reset_handler = tcm_loop_device_reset,
> -	.eh_target_reset_handler = tcm_loop_target_reset,
>   	.this_id		= -1,
>   	.sg_tablesize		= 256,
>   	.max_sectors		= 0xFFFF,

Reviewed-by: Hannes Reinecke <hare@kernel.org>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
