Received: from outbound.easymail.ca (outbound.easymail.ca [64.68.200.34])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B31A82F39C7
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 20:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=64.68.200.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774558770; cv=none; b=RDvvbGVnxRo1+1TUV+JK9uaghlPlwlEjWoxFTBkj5iztCaS0tnQibo8FwF75YDqoFKNZrX7t2bVWzK30nWM5Hvxj2/krK75UlYVVvppJx3+VKfhR/9p5lDqD2cpttPFrFn8Lb7PYMZoOrUkINSPn4zQYc89fXP7ALzrUUZsbtP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774558770; c=relaxed/simple;
	bh=jziiH1efX54c24mXW3ypoxdMvvr9IC56VyCU9e8kbaY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LlohMmZcDTSv/k8LtFY/dfRzaoEaMMzIlIwL/fRaWYPo6kNz383I5I4LLxYhBr6Dma6p0Y7dlGjU8BthEBZDcYZ0vyUyBG02pc3a3sgzEsJfmBT6HxILyG5J0bPHFywf0TQpQgyENkzDwgOg0feNzAbKilUt/vqS6jynV23omS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org; spf=pass smtp.mailfrom=gonehiking.org; arc=none smtp.client-ip=64.68.200.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=gonehiking.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gonehiking.org
Received: from esv2.easydns.net (pco.easydns.net [64.68.203.197])
	by outbound.easymail.ca (Postfix) with ESMTP id 3FAD620C80
	for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2026 20:59:28 +0000 (UTC)
X-Envelope-From: <khalid@gonehiking.org>
Received: from mailout.easymail.ca (unknown [10.5.10.137])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by esv2.easydns.net (Postfix) with ESMTPS id 4fhbk246X9zHhns;
	Thu, 26 Mar 2026 16:59:22 -0400 (EDT)
Received: from localhost (localhost [127.0.0.1])
	by mailout.easymail.ca (Postfix) with ESMTP id 7DAC96432A;
	Thu, 26 Mar 2026 20:59:22 +0000 (UTC)
X-Virus-Scanned: Debian amavisd-new at emo07-pco.easydns.vpn
Received: from mailout.easymail.ca ([127.0.0.1])
	by localhost (emo07-pco.easydns.vpn [127.0.0.1]) (amavisd-new, port 10024)
	with ESMTP id UzIV5EnMiQYJ; Thu, 26 Mar 2026 20:59:22 +0000 (UTC)
Received: from mail.gonehiking.org (unknown [38.175.187.108])
	by mailout.easymail.ca (Postfix) with ESMTPA id E3232641EE;
	Thu, 26 Mar 2026 20:59:21 +0000 (UTC)
Received: from [192.168.1.4] (rhapsody.internal [192.168.1.4])
	by mail.gonehiking.org (Postfix) with ESMTP id 66BE47EB48;
	Thu, 26 Mar 2026 14:59:21 -0600 (MDT)
Message-ID: <adf25720-70d9-429d-8da2-a3f2916976bf@gonehiking.org>
Date: Thu, 26 Mar 2026 14:59:21 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Reply-To: khalid@gonehiking.org
Subject: Re: [PATCH 06/36] scsi: BusLogic: Prepare for enabling lock context
 analysis
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
References: <20260312211636.3245119-1-bvanassche@acm.org>
 <20260312211636.3245119-7-bvanassche@acm.org>
From: Khalid Aziz <khalid@gonehiking.org>
Content-Language: en-US
Autocrypt: addr=khalid@gonehiking.org; keydata=
 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
In-Reply-To: <20260312211636.3245119-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-edns-Libra-ESVA-Information: Please contact easyDNS for more information
X-edns-Libra-ESVA-ID: 4fhbk246X9zHhns
X-edns-Libra-ESVA: No virus found
X-edns-Libra-ESVA-SpamScore: ss
X-edns-Libra-ESVA-From: khalid@gonehiking.org
X-edns-Libra-ESVA-Watermark: 1775163562.89279@oqcB+a088DeMdr1LFTsGdw

On 3/12/26 3:15 PM, Bart Van Assche wrote:
> Document locking requirements with __must_hold().
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/BusLogic.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
> index e3790ff24e56..bb5a63baf897 100644
> --- a/drivers/scsi/BusLogic.c
> +++ b/drivers/scsi/BusLogic.c
> @@ -2879,6 +2879,7 @@ static int blogic_hostreset(struct scsi_cmnd *SCpnt)
>   */
>   
>   static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
> +	__must_hold(command->device->host->host_lock)
>   {
>   	void (*comp_cb)(struct scsi_cmnd *) = scsi_done;
>   	struct blogic_adapter *adapter =
> @@ -3183,6 +3184,7 @@ static int blogic_abort(struct scsi_cmnd *command)
>   */
>   
>   static int blogic_resetadapter(struct blogic_adapter *adapter, bool hard_reset)
> +	__must_hold(adapter->scsi_host->host_lock)
>   {
>   	struct blogic_ccb *ccb;
>   	int tgt_id;

Looks good to me.

Acked-by: Khalid Aziz <khalid@gonehiking.org>

--
Khalid
