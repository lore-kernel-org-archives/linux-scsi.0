Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7968B368946
	for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 11:47:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264874; cv=none; b=EmPxSACO15h5tYDDCEUlz3XFacXik+9sWl9P2qlVYoPKDOqjFMB7W5YjLejJ7Ifa4m8E6mOoGMJAvarefizqiFcRifW5BZ2YOV6iJBTu65jXirTt3Yh4evcUFj2U7t1m01qpqUxFeEbEAF5adeKrrOx39Oh3zz8fZSgQvYRmXVI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264874; c=relaxed/simple;
	bh=fVOSbob9d8hsY4XIb4oM4EhSUFBIa8HVrW81A0q56YM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=gdgOrNyWwZpG/4qfzi/0GpFap1xDQGPjKoIS9P2npUavSLk2rptktoI/1VZ5NYDqq7oaI/M0PRuAXad1Wwds1H42BFGoS2oWAiIvS8OuwYRszHZd0PYRVClUWwQiOQr1JFTL8duXvXoTSqPyByEO0Tb+PRtS6YaSrPMRdMueXpw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b=RUdE9siD; arc=none smtp.client-ip=209.85.128.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=suse.com header.i=@suse.com header.b="RUdE9siD"
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-490cf3000f0so9209375e9.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Jun 2026 04:47:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=suse.com; s=google; t=1781264872; x=1781869672; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=saYLI4wB9U9hT6ImFtGdQfpcUC/+nMSmTcWzovuyFpU=;
        b=RUdE9siDmGMNZ8CjEf5x0ncSY8boicIAQGBu1BWCgS/TwQqxwgKGWHmffdg8HKs6Hl
         RM4QXUYf4tq9MIMVuh/0dDlRM9Uu0z/+SDFBwxmfFY/9yPlAV0692gvujldTZYSFFgnm
         90Jx5X8uiVUAqUGisjHC9ZMe2gY7q3bHU/SesULJNsI9U8Ahxma1VNLyC8Xqz+JjAIG5
         7LGAn6TsHv7GG8LuNYu7PmnCnXuWUcASWzkiwy5ZZuxPdEfd5fHoy467aWmHwo84BI6t
         wL+wzVHOm8HhA/cdH8kWM10plrD54B85zDhM3eO7DelLdeiOc2KvFFER+h2GqYxWaC4l
         uMcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264872; x=1781869672;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=saYLI4wB9U9hT6ImFtGdQfpcUC/+nMSmTcWzovuyFpU=;
        b=Q4OmunHh5F7TjmwYOYoFFkSU744cn5tubXIDnVbaZ68y4lGsLzgDuwqPkltd2pDSNn
         z9Dl9QV7II/+/ebseDfGcvpEMCM/m12+9pYx8wg5Wl1xfm8NeySiqt9D2AdDrBllHwrP
         qSgOPEoqyRokLy/yT7R266idCz36v2Z10Xm9CNK2olAw/U/NYHlDZLP1Hbw+zEfDGUl7
         8fAi/mek8z/Wzme72YNaUvkczJULi8XPi3p98HAFo9dTVI7VZcYphu9OxjfklGdFb3cy
         CrVLZSgixVOFqtCXGwPbhjvoKRwKAch2qezwkafbAPN2dS6moYd0RVFyLZECW4ziodiK
         PzQA==
X-Gm-Message-State: AOJu0Yy3CWksUuMBqdAWj/2j4RpzhAR2sxLN4rmz3Y3igzVjgzdYugOS
	GY6pBRgaiyu2ZHFRwFvuctemTZFqi461bq0Ox3BC4M6RAG+LJ3xXV0QKKNA+Fgxi4Qw=
X-Gm-Gg: Acq92OHrx2UiE84Ww6afRUU1yU9VF2Qd5jqbkFJN/huY3KnJHhu3rLhBrfbQKDUfwqK
	vXNeAM3MZTHnCnNaG4sYkO3+VY8NiUDrH1UQpZgyNITkzP9zg4TJWz/RhA20oNAjkd9RK7uo/81
	zRMWhOfrX5zBjmt1KcQgPDVCY8kpB3lRvmzE/uJZaywfo/BH8VVnBVS6ErW/uS+wFBvuJXxHYBk
	T4QlyrUOuK4N7v4rXS6a1O/le20qUMPqUlkCKU/405BcUJ9LLi5rN+uuJxS//TwmhWCRXmmCSxT
	si0q07uXUnJkdetRE+ASePAGJtARUlaGAsN2MFesy3IsoHVheuoifUZqgPxNvHgqB14EGXzqE/6
	7kuWXLcqiXt+KU+hLfwEIUveCzou+pNPhWhI/7afVq2C/GpUmrTNHiJh0Y470YsSMYOxdVDeX6W
	CyvM+6/T2RTZ4Qj1nHWSQqe5gKZs9pr1myahGn71sNh8dh90iC2TV3KDoY
X-Received: by 2002:a05:600d:8494:10b0:490:c7dd:de3e with SMTP id 5b1f17b1804b1-490ec521187mr22864575e9.31.1781264871852;
        Fri, 12 Jun 2026 04:47:51 -0700 (PDT)
Received: from ?IPV6:2a07:de40:a101:3:ce70:3e6f:3b9c:9125? ([2a01:4a0:2e:ffff:ffff:ffff:ffff:ffff])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-4606f26f309sm5604578f8f.14.2026.06.12.04.47.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 12 Jun 2026 04:47:51 -0700 (PDT)
Message-ID: <6039739b-370a-4307-b2c3-d433f4b0e68f@suse.com>
Date: Fri, 12 Jun 2026 13:47:50 +0200
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 28/60] scsi: qla2xxx: Handle sts_cont_entry_ext_t for
 29xx adapters
To: Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org, GR-FC-Storage-Upstream@marvell.com,
 agurumurthy@marvell.com, emilne@redhat.com, jmeneghi@redhat.com
References: <20260612095333.1666592-1-njavali@marvell.com>
 <20260612095333.1666592-29-njavali@marvell.com>
Content-Language: en-US
From: Hannes Reinecke <hare@suse.com>
In-Reply-To: <20260612095333.1666592-29-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 6/12/26 11:53, Nilesh Javali wrote:
> 29xx adapters use 128-byte response queue entries
> (sts_cont_entry_ext_t) instead of 64-byte (sts_cont_entry_t).  Update
> all status continuation IOCB processing paths to branch on
> IS_QLA29XX() and use the correct entry type and data payload size.
> 
> The affected functions are __qla_copy_purex_to_buffer(),
> qla27xx_copy_multiple_pkt(), qla2x00_status_cont_entry(), and their
> call sites in qla2x00_process_response_entry() and
> qla24xx_process_response_queue().
> 
> Change qla2x00_status_cont_entry() to accept void * so callers no
> longer need an explicit cast and the function can internally select the
> right structure based on the adapter type.
> 
> Add BUILD_BUG_ON for sts_cont_entry_ext_t size (128 bytes).
> 
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_isr.c | 192 +++++++++++++++++++++++----------
>   drivers/scsi/qla2xxx/qla_os.c  |   1 +
>   2 files changed, 139 insertions(+), 54 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e95fb0e59f38..c18ee2459f5b 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -19,7 +19,7 @@
>   
>   static void qla2x00_mbx_completion(scsi_qla_host_t *, uint16_t);
>   static void qla2x00_status_entry(scsi_qla_host_t *, struct rsp_que *, void *);
> -static void qla2x00_status_cont_entry(struct rsp_que *, sts_cont_entry_t *);
> +static void qla2x00_status_cont_entry(struct rsp_que *, void *);
>   static int qla2x00_error_entry(scsi_qla_host_t *, struct rsp_que *,
>   	sts_entry_t *);
>   static void qla27xx_process_purex_fpin(struct scsi_qla_host *vha,

Using a void pointer is always awkward as it doesn't allow for an 
out-of-bounds check.

I would rather add a 'size' field, too, as then the size of 'void' 
pointer would be known and one doesn't need to sprinkle the code with
IS_QLA29XX() calls.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                  Kernel Storage Architect
hare@suse.com                               +49 911 74053 688
SUSE Software Solutions GmbH, Frankenstr. 146, 90461 Nürnberg
HRB 36809 (AG Nürnberg), GF: I. Totev, A. McDonald, W. Knoblich
