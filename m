Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAA88321F5B
	for <linux-scsi@vger.kernel.org>; Mon, 18 Aug 2025 15:50:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755532248; cv=none; b=CRV/E3vAgSmd75ZePXIgmDPBbbFGgWsZlFirqx5bTcJ6mZXnRjA6hx3cvFYNmXgOaWrMtuAxjTY/2vu4j4RkiSULzyXh+09JuCnGiXJOpvcGBVriQbg8r9p5m30IvWl5engG2qs2reSPV+4wHoBKvaQNfnkYZ8IjA3V9tevK+34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755532248; c=relaxed/simple;
	bh=/UaHwuXGa6GvwQ7nl4F8DxqIuEcrRS4LUE7Lt0duuxc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=hDFPP6WtD6H9wld5B1FVlh+mrCNe7NtrqrxtmxrY5OD5hJkMK/TvrqlVCKvLupqy3dkE9DnYowtPgsfgjWH4I1AedkSl5iGcoYvBxqRjQpJpOjUoV8fwvFa9iffSDsBcQIlmN2Sy22owj9nx54BOkZS6EJwMq4lqsE8huLlMzvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=sSjN49AT; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="sSjN49AT"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c5HHN3PbNzlgqW0;
	Mon, 18 Aug 2025 15:50:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755532238; x=1758124239; bh=YqD0HlBSbPNFYRxutP3xCd7m
	LogvVkwitqWelyZE0So=; b=sSjN49ATxOV65GEJlYAJfYZaJY5jMoFS/XT8An6V
	ItGw+Bt2U3zhCa3f5t+l88V9Rm+blRtuI/vwMtNk0xgC0a75JhKGnDhi0zb2jPGR
	mPaZ/KMHBRfLU2wa0Z86yRGMYr0Gy+GjC8LCuuau8zFqNuKY2oFttba8nZ5TxmRd
	/S/X8igoFJiy0GwnB9/luFMdYG09m9iVDRqGs0+jNtUsHAbOTKiqk06anF9PU0S1
	A85sBNZduD4jLMY5qIQytO4wGX895nUo6dXzvYaYT8i3bJlbnLM0ojsf25jmM4ip
	vaeMjdJ+7qLb7lh2NdXtzHU+c4C3rYTXyGP9/cWeOVAlbQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id pDBi8NoNr9xO; Mon, 18 Aug 2025 15:50:38 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c5HHB71Grzlgqxq;
	Mon, 18 Aug 2025 15:50:30 +0000 (UTC)
Message-ID: <85e042e9-8ba9-445e-9cc1-65d2e5bccef5@acm.org>
Date: Mon, 18 Aug 2025 08:50:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ufs: core: Only collect timestamps if the monitoring
 functionality is enabled
To: daejun7.park@samsung.com, "Martin K . Petersen"
 <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 Can Guo <cang@codeaurora.org>, Bean Huo <beanhuo@micron.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>
References: <20250815160049.473550-1-bvanassche@acm.org>
 <CGME20250815160114epcas2p43832aa1b9ad0b0efb98ec59f5b568c96@epcms2p8>
 <1891546521.01755492302739.JavaMail.epsvc@epcpadp1new>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <1891546521.01755492302739.JavaMail.epsvc@epcpadp1new>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/17/25 7:36 PM, Daejun Park wrote:
> How about modifying ufshcd_compl_one_cqe() to skip updating compl_time_stamp?

I think my patch already does that:

@@ -5622,8 +5624,10 @@ void ufshcd_compl_one_cqe(struct ufs_hba *hba, 
int task_tag,
  	enum utp_ocs ocs;

  	lrbp = &hba->lrb[task_tag];
-	lrbp->compl_time_stamp = ktime_get();
-	lrbp->compl_time_stamp_local_clock = local_clock();
+	if (hba->monitor.enabled) {
+		lrbp->compl_time_stamp = ktime_get();
+		lrbp->compl_time_stamp_local_clock = local_clock();
+	}
  	cmd = lrbp->cmd;
  	if (cmd) {
  		if (unlikely(ufshcd_should_inform_monitor(hba, lrbp)))

Bart.
