Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 90C3B379991
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:41:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617305; cv=none; b=ciawQM36Ih8q6T5RaLXLzV0Qqd3+nayEHSFyzylj44eanCXaAfg4ua6344STFTLxkWBtDXclWESo2mmjVD1CVGl+xrl2ErzDpE6KgM1y/Y8OKbA6HtGpGQG0HkulH2AFHjRcuzTLf3Ha0BBj02KDywrCTGvS+jacglydFdFGF5s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617305; c=relaxed/simple;
	bh=i/KQdFwLGMoKlaGO01YUB9rLyRh2wjhtUgMcRi+dkgQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=IC3f6sw9I3M132NlRluyfz2YA3EaOeVv7ThnmVXIuYJ6CQSHJpl4+C92OTrxV07mstjOIfO1YIQrEt+qmfibi4Uc+slujqndbOaLeG6ii8Q5hDVYHzX2Um3SH4987JWDLUQZjtHZNl2QZGD7h+Qe383CpVG1wpSkmQAj++8L20E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=AHAYM4JV; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="AHAYM4JV"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4htpX80XLFzlfddx;
	Mon, 28 Sep 2026 17:41:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790617301; x=1793209302; bh=mpMBTSQxVHbDDjux8cIHANd+
	NUsvbczsLmJxx4VwDp0=; b=AHAYM4JVh+WqP3LXKfUB+S/z52n6Z3U4Kc3YStds
	oFCFpklLz0JHn5KGenvZuOq7lFVQGpO4aTsmuXbB2P7NSGApO14CUUtoup1HgGg2
	BLPb8rVSvQH09f1ig8LBsDoOV0Uqnw7ZP6ssnl7LolRtMdewgNOHSCvr20lMoCPT
	91SJ2Qfl/B78FSK5noiFRJ6iOewh6638JFhGmpOVSOJd8QCYQE7QD8Sn7sjOqthy
	ECODK4UUOvZSOr/lRddQw5tguREaOK5zMX6qRRmTqTKJl9hfQloaoaASkGIuBooN
	qU4JnrvWMRdQJLLT27TOrxxhVHS2NZvXjK8dvCRUmRqGpQ==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Xn14tPWBDMUO; Mon, 28 Sep 2026 17:41:41 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:334e:163d:7b65:8f42] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4htpX35wF2zlfddw;
	Mon, 28 Sep 2026 17:41:39 +0000 (UTC)
Message-ID: <97ab2119-2067-4c6c-9edf-286666f94e40@acm.org>
Date: Mon, 28 Sep 2026 10:41:38 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 04/54] scsi: BusLogic: Pass the host pointer directly
 to several functions
To: Khalid Aziz <khalid@gonehiking.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <09e99ec9c6fa24ee5fe3c47110c88a1be076e01a.1790360262.git.bvanassche@acm.org>
 <argk3DLMl_YSDOsV@gonehiking.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <argk3DLMl_YSDOsV@gonehiking.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/26/26 1:02 PM, Khalid Aziz wrote:
> On Fri, Sep 25, 2026 at 11:25:42AM -0700, Bart Van Assche wrote:
>> -static enum scsi_qc_status blogic_qcmd_lck(struct scsi_cmnd *command)
>> +static enum scsi_qc_status blogic_qcmd_lck(struct Scsi_Host *shost, struct scsi_cmnd *command)
> 
> Buslogic.c defines blogic_qcmd() usind "DEF_SCSI_QCMD(blogic_qcmd)" which in turn will call
> blogic_qcmd_lck() with just struct *scsi_cmd as a single parameter as defined in
> include/scsi/scsi_host.h. I did not see an update to DEF_SCSI_QCMD in patches 1-3. With this
> change, callers are not being updated and that will not work. Can you double check this?

[ ... ]

>> -static DEF_SCSI_QCMD(blogic_qcmd)
>> +static enum scsi_qc_status blogic_qcmd(struct Scsi_Host *shost, struct scsi_cmnd *cmd)
>> +{
>> +	enum scsi_qc_status rc;
>> +
>> +	spin_lock_irq(&shost->host_lock);
>> +	rc = blogic_qcmd_lck(shost, cmd);
>> +	spin_unlock_irq(&shost->host_lock);
>> +	return rc;
>> +}
Hi Khalid,

Please take a look at the above changes. It seems like these have been
overlooked.

Thanks,

Bart.
