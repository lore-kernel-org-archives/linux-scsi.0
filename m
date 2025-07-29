Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D9B7207A0C;
	Tue, 29 Jul 2025 16:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753806006; cv=none; b=j9gp3h7UdO/7goEvBNfKuhHNPxCI/9zic4yFq5CW0UjWg4gB17XFuSPkYmrECqFAUcqOMxchkKSqegKKTCgNa8hIssW1OyO8T9Eh+euyjedWjfqwQoF2ac0+9P6RvrEXDl00h7bgGki36IIwzJWTjSIuFtNkVKHedL4Szi3vGGo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753806006; c=relaxed/simple;
	bh=xz834h4007/oGqcbudNCDcTtAzbRhiJqFWAJsGu6b4s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cVgBLoNJpYBl4KyLaY/MDwQbgoagh1BM9lNXSSKtW57hH1QXXMXzlM8TYluqbNQHzAA/wPnKMu/l0EQfk7Tm+yVTye4+//davlwx0QwhMIN1H4YrMxEY3Qf0SYkX/CNNEF08QrkfhEARqCVohy+jYe+GewarW5f5Cjnm4vnvA9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=EZa+QSPB; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="EZa+QSPB"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4bs0tQ4Qj7zm0ySX;
	Tue, 29 Jul 2025 16:19:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1753805997; x=1756397998; bh=ZdlVI0SgJVmqsaSjcEMnRebz
	60rKATRsCrMenRccPcg=; b=EZa+QSPB1eu0ShsEV4MENTv7Oy6IzAZUNnaybCqI
	RtkqAaaYh3IeGnNKAafIFolQqNHpRNUWNTA8GTv8PCIMZy4DueVscVEZKuBoP3sE
	4ZZ5J9nuMVK9Yvoi1JiALDiVt4f7ePU69+MIAcRcPBL2R7vNd0Q05vc1eoqFaUIA
	J66YzkENbknqBiZdqNdt34t+3L37Nuoc7HCF2FaRwMFP+qN3Zgp3B3len1mOm0CE
	ANa+CeNJ1Ctpbo3T07E7RalmaEUD6IpndoRx719QhvLg89mXMJnptET3ybUUMGPM
	0GfYPsBfvLPVNzVC3YDOwQauUtT1QZrDwupKYCQUuVAWAw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id hO1igF0WTK7s; Tue, 29 Jul 2025 16:19:57 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4bs0tK07RHzm174x;
	Tue, 29 Jul 2025 16:19:51 +0000 (UTC)
Message-ID: <ccac04ec-fe14-46bd-a482-b9cbb65fadf5@acm.org>
Date: Tue, 29 Jul 2025 09:19:49 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi_debug: add implicit zones in max_open check
To: Andrew Bernal <andrewlbernal@gmail.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>,
 Damien Le Moal <dlemoal@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20250722203213.8762-1-andrewlbernal@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20250722203213.8762-1-andrewlbernal@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/22/25 1:32 PM, Andrew Bernal wrote:
> https://zonedstorage.io/docs/introduction/zoned-storage Open Zones limit
> is defined as a "limit on the total number of zones that can simultaneously
> be in an implicit open or explicit open state"

That's not an official standard and hence should not be used to motivate
this patch. Additionally, I don't see how a zone could be simultaneously 
in the implicit open and the explicit open state. According to the ZBC-2 
standard, these states are mutually exclusive.

devip->max_open is reported to the initiator in VPD page B6
as the MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE REQUIRED ZONES. From
ZBC-2 section 4.5.3.4.2: "If the value in the MAXIMUM NUMBER OF OPEN
SEQUENTIAL WRITE REQUIRED ZONES field (see 6.5.2) is non-zero and
the number of zones with a Zone Condition of EXPLICITLY OPENED is equal
to the value in the MAXIMUM NUMBER OF OPEN SEQUENTIAL WRITE REQUIRED
ZONES field, then a command that writes to or attempts to open a
sequential write required zone with a zone condition of EMPTY or CLOSED
is terminated with CHECK CONDITION status with sense key set to DATA
PROTECT and the additional sense code set to INSUFFICIENT ZONE RESOURCES
(see 4.5.3.2.8)."

> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index aef33d1e346a..0edb9a4698ca 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -3943,7 +3943,7 @@ static int check_zbc_access_params(struct scsi_cmnd *scp,
>   	/* Handle implicit open of closed and empty zones */
>   	if (zsp->z_cond == ZC1_EMPTY || zsp->z_cond == ZC4_CLOSED) {
>   		if (devip->max_open &&
> -		    devip->nr_exp_open >= devip->max_open) {
> +		    devip->nr_imp_open + devip->nr_exp_open >= devip->max_open) {
>   			mk_sense_buffer(scp, DATA_PROTECT,
>   					INSUFF_RES_ASC,
>   					INSUFF_ZONE_ASCQ);
> @@ -6101,7 +6101,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	if (all) {
>   		/* Check if all closed zones can be open */
>   		if (devip->max_open &&
> -		    devip->nr_exp_open + devip->nr_closed > devip->max_open) {
> +		    devip->nr_imp_open + devip->nr_exp_open + devip->nr_closed > devip->max_open) {
>   			mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
>   					INSUFF_ZONE_ASCQ);
>   			res = check_condition_result;
> @@ -6136,7 +6136,7 @@ static int resp_open_zone(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>   	if (zc == ZC3_EXPLICIT_OPEN || zc == ZC5_FULL)
>   		goto fini;
>   
> -	if (devip->max_open && devip->nr_exp_open >= devip->max_open) {
> +	if (devip->max_open && devip->nr_imp_open + devip->nr_exp_open >= devip->max_open) {
>   		mk_sense_buffer(scp, DATA_PROTECT, INSUFF_RES_ASC,
>   				INSUFF_ZONE_ASCQ);
>   		res = check_condition_result;

Do you agree that the current code in the scsi_debug driver follows the
ZBC standard and also that the above changes would break compatibility
with the ZBC standard?

Thanks,

Bart.
