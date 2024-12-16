Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE80F204573;
	Mon, 16 Dec 2024 17:18:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734369503; cv=none; b=XFlnt72yrAQaQXlO8H9zh9b/53uRUG+HrEQle7w6+PuVmrr9ApTKlTk3gZFZnm9wj3MtUdG32Odzl4a47me6B8CgGgECSfZ9Tx6OHnSoB8KNFdzPgIQvpsF4UEW3GHPb8WT1P8GiyV2rKecDAlXJQbZqmnxFM5XORshMljGUzrY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734369503; c=relaxed/simple;
	bh=CjqzE7087AiBvEx9gmYi2U2pPIZKyrNkIagRVsPG68o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UAMCH7UDAbBrJGZQo46G7w0NbToIp6hYyyyJBw2n2NvWpDqNPnAv3ngkrODMhg41EGeL5787kgYmZv3iV71YEoleWBfo5X7ldXoMedPMPnsrVrAq6SCoq9HkTv6nDpqTWz/L6bdrIdJ1dK4OtjQI7jIbZ090sWqeaDT7xOltaEQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=CKeNsS6D; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="CKeNsS6D"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4YBmqW65b3zlff0B;
	Mon, 16 Dec 2024 17:18:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1734369492; x=1736961493; bh=kD55034H1P07ZxJFhjl6aYS/
	UIu6mVlWOUEuS19clkA=; b=CKeNsS6D1xcj7UhY/jkhiVzwopBPUQHVAgjYCNVA
	tue1SFZgpfBYuja/JB4DfSQ2afDDO6J4ThdF7di9FbAqkl41aM2DMc9VyMUrXQQ/
	ng22IWBnI6JiIJzdknUhlFRQXK86lMUE0UIf8AP2eHuxVcw691tT6z8r2KTit7kJ
	QV8WdpDWPVbR4Ocp0xvstNqYRk4BGkwvizhmuRzgnecLEYKf9l10fnMfgWbXQkeo
	JdF8dGlZi0141XRsRIvD21qDnGw15E33eUml7Z5LuWyz7nMtKUASUq8rXZ30ES7P
	75K+ejYq5JYLi9j/4yL2pqzg9MB/YzJR3xyAPjOb/mZiSA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id cFPmocDecuep; Mon, 16 Dec 2024 17:18:12 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4YBmqQ458Dzlff01;
	Mon, 16 Dec 2024 17:18:10 +0000 (UTC)
Message-ID: <89a972a4-64e3-4fdb-b2ce-994469546bee@acm.org>
Date: Mon, 16 Dec 2024 09:18:09 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: st: Regression fix: Don't set pos_unknown just
 after device recognition
To: =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>,
 linux-scsi@vger.kernel.org, jmeneghi@redhat.com
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 loberman@redhat.com, stable@vger.kernel.org
References: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241216113755.30415-1-Kai.Makisara@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/16/24 3:37 AM, Kai M=C3=A4kisara wrote:
> diff --git a/drivers/scsi/st.h b/drivers/scsi/st.h
> index 7a68eaba7e81..1aaaf5369a40 100644
> --- a/drivers/scsi/st.h
> +++ b/drivers/scsi/st.h
> @@ -170,6 +170,7 @@ struct scsi_tape {
>   	unsigned char rew_at_close;  /* rewind necessary at close */
>   	unsigned char inited;
>   	unsigned char cleaning_req;  /* cleaning requested? */
> +	unsigned char first_tur;     /* first TEST UNIT READY */
>   	int block_size;
>   	int min_block;
>   	int max_block;

Why 'unsigned char' instead of 'bool'?

Should perhaps all 'unsigned char' occurrences in struct scsi_tape be
changed into 'bool'? I'm not aware of any other Linux kernel code that
uses the type 'unsigned char' for boolean values.

Thanks,

Bart.
