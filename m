Received: from mta0.migadu.com (out-133.mta0.migadu.com [91.218.175.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4DBA4854F0
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 08:58:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790585936; cv=none; b=PvDGITu26GZ0hxgPXEMnAdBD87EZBaqAbPg//g5+CDxYOfBFsey/mjPglSA3j2P/lONxhRI4Jv6CMR1nQ19B3UVwvgV+a1n0PtaqGFE5mbzzK05cY1fNn2GMjXD38UPFCTwM/wF8WnLuuFzS6kCHwhiD9VbH1KhGDwtvA6DuCU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790585936; c=relaxed/simple;
	bh=popaA2eJZE7q1shMgpb97Jp1klj3o6YeyNYJntzFVDU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=f3RX4Knsjs5oZqLsBGo7SOosNg29Cxn/BHVkC80JkNZaSgCZYHeBeYeBkQQ7N3sBITUh0hCSWHE7TR9knWu0NN2mzhG8A1ebtDGJvG2aSYIbu0bxN5gxB6Z+9YE8KzMuL+/9qvteT20N03Pm8FCMnI9iMLIR59YLGhmpbKKhXO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=onU3s6NJ; arc=none smtp.client-ip=91.218.175.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="onU3s6NJ"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=popaA2eJZE7q1shMgpb97Jp1klj3o6YeyNYJntzFVDU=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1790585932; v=1; x=1791190732;
 b=onU3s6NJ9jxItxxb/10xlPSFWFaXTT+437ZknrEAYiOb7k8a+0HMOLZ5kyi0tjcMnAtwsqE5
 /HwSorc4ubYDDMAZAtrJAeECJT426tzOdqGIP7c6zrpfIEb/Hn5lQGlAiRZ4rwYWr3YCSeCLH1a
 ulj3+Crb6E76KNRiEpbqjvmk=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id f4ad1df72025bc89;
	Mon, 28 Sep 2026 08:58:52 +0000
X-Mizu-Trace-ID: f4ad1df72025bc89
X-Migadu-Flow: FLOW_OUT
Message-ID: <a7faf316-b2a0-4c82-98bd-157fe3187cc5@linux.dev>
Date: Mon, 28 Sep 2026 09:58:48 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: core: Micro-optimize the hot path
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Hannes Reinecke <hare@kernel.org>
References: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <1ac0d4d0c06e55943e188d0dee9b6f2475715f21.1790359761.git.bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 19:09, Bart Van Assche wrote:

nit: I think that the subject can be more specific, like "don't 
unnecessarily init scmd->eh_entry"

> Every code path that inserts scmd->eh_entry into a list uses
> list_add_tail() (see also scsi_abort_command() and scsi_eh_scmd_add()).
> list_add_tail() overwrites the next and prev pointers. Hence, the only
> code that depends on the initialization of scmd->eh_entry is the
> BUG_ON(!list_empty(&scmd->eh_entry)) statement in scsi_abort_command().
> Remove this statement because scsi_timeout() already prevents
> scsi_abort_command() from being called twice for the same command by
> setting SCMD_STATE_COMPLETE. Remove the scmd->eh_entry initialization
> because the only statement that relied on this initialization has been
> removed.
> 
> Cc: John Garry <john.garry@linux.dev>
> Cc: Hannes Reinecke <hare@kernel.org>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Seems fine, so:
Reviewed-by: John Garry <john.garry@linux.dev>

> ---
>   drivers/scsi/scsi_error.c | 1 -
>   drivers/scsi/scsi_lib.c   | 3 ---
>   2 files changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
> index 2e0b1909dc69..75442d60c30e 100644
> --- a/drivers/scsi/scsi_error.c
> +++ b/drivers/scsi/scsi_error.c
> @@ -270,7 +270,6 @@ scsi_abort_command(struct scsi_cmnd *scmd)
>   	spin_lock_irqsave(&shost->host_lock, flags);
>   	if (shost->eh_deadline != -1 && !shost->last_reset)
>   		shost->last_reset = jiffies;
> -	BUG_ON(!list_empty(&scmd->eh_entry));
>   	list_add_tail(&scmd->eh_entry, &shost->eh_abort_list);
>   	spin_unlock_irqrestore(&shost->host_lock, flags);
>   
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index db64470f5229..f695a6605815 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1322,7 +1322,6 @@ void scsi_init_command(struct scsi_device *dev, struct scsi_cmnd *cmd)
>   	}
>   
>   	cmd->device = dev;
> -	INIT_LIST_HEAD(&cmd->eh_entry);
>   	INIT_DELAYED_WORK(&cmd->abort_work, scmd_eh_abort_handler);
>   }
>   
> @@ -1590,8 +1589,6 @@ static void scsi_complete(struct request *rq)
>   		return;
>   	}
>   
> -	INIT_LIST_HEAD(&cmd->eh_entry);
> -
>   	atomic_inc(&cmd->device->iodone_cnt);
>   	if (cmd->result)
>   		atomic_inc(&cmd->device->ioerr_cnt);

