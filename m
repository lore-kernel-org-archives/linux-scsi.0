Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F2AB255240;
	Thu, 24 Jul 2025 15:06:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753369571; cv=none; b=FwJKhQKDdnrgIS2h7oxCr9XPon+lF+unzU13mpVGSz1xDX/3gHNW1O48rsnZctwAiIdgb0ZAbw7gF1kqduirvn+MHnjWPYe4fqbYonHIWItovrVFhFX3ySc5caWuFJoCm7aNrOf5wlVJ7Py/GC1uZafL9gFOddKc+btFX7PitJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753369571; c=relaxed/simple;
	bh=GDNFSUdFEiCdMAQUPXagz2PNovF4bBFEFrhSf8WU/ek=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=mBIYnRb3JB2rcR26yOajQI8WBwhTj5Ik4s3XecYLJvOmRMWI44+9TOKD4gDmXczl3vce2+v5vw0d2Fa+ZTNiAUDPoCnuRzQMlby2dKtgIABJv45xQR/k8puPEBoKlSuKzI+MMn1jyszeGhF6ghqfEvmsnBegebW/zmeY7yDor2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ipd9xOdi; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ipd9xOdi"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bnvTX4KfJzm174V;
	Thu, 24 Jul 2025 15:06:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753369567; x=1755961568; bh=tTwjfnNOEVG96gNCQcIaBeuC
	yRGfa4I6J3XhGWCVJFg=; b=ipd9xOdiQd7bPwboHVBLDnJuTjAdpg3dZxEoWp+Z
	W6mXe2/SThjglk/oOKxjnv0qfv34El4qooTQZi/sZLRfX8SkIV/0J6VUGgd+q6Q1
	SwdtQTMbE5KHmtqsF4uHPINa7KkJWTafI0qbNxEMPdLjo23luc/yHG+hoo0EKbLk
	1TPArICxA5j4vzGS3Bnndg7xe8jc6YSi4MwsTxCS7Srent0sji1IFjos2M76XCQH
	Jq9sHd4uokSZVHlyVwbgDySSRKYBVCqrtFc81ua8wnXpEadb3cmP1KkN6H8aA7gg
	duvHqROIsKNS9fl074OQnVnwhVw+URLeBVi+kS16LnzqQw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 6BXkYVp9Qigy; Thu, 24 Jul 2025 15:06:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bnvTS5W83zm1753;
	Thu, 24 Jul 2025 15:06:03 +0000 (UTC)
Message-ID: <f4b61b0e-ec90-4a84-9679-74cbbda5cbae@acm.org>
Date: Thu, 24 Jul 2025 08:06:02 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/1] scsi: target: Move LUN stats to per CPU
To: Mike Christie <michael.christie@oracle.com>, martin.petersen@oracle.com,
 linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20250724004558.40993-1-michael.christie@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250724004558.40993-1-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/23/25 5:45 PM, Mike Christie wrote:
> diff --git a/include/target/target_core_base.h b/include/target/target_core_base.h
> index c4d9116904aa..e73fb224625d 100644
> --- a/include/target/target_core_base.h
> +++ b/include/target/target_core_base.h
> @@ -744,9 +744,9 @@ struct se_port_stat_grps {
>   };
>   
>   struct scsi_port_stats {
> -	atomic_long_t	cmd_pdus;
> -	atomic_long_t	tx_data_octets;
> -	atomic_long_t	rx_data_octets;
> +	u32			cmd_pdus;
> +	u32			tx_data_octets;
> +	u32			rx_data_octets;
>   };
>   
>   struct se_lun {
> @@ -773,7 +773,7 @@ struct se_lun {
>   	spinlock_t		lun_tg_pt_gp_lock;
>   
>   	struct se_portal_group	*lun_tpg;
> -	struct scsi_port_stats	lun_stats;
> +	struct scsi_port_stats	__percpu *lun_stats;
>   	struct config_group	lun_group;
>   	struct se_port_stat_grps port_stat_grps;
>   	struct completion	lun_shutdown_comp;

Is this perhaps an open-coded implementation of struct percpu_counter? 
Why hasn't struct percpu_counter been used? I think this should be
explained in the patch description.

Thanks,

Bart.
