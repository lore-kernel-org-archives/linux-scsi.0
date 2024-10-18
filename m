Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9445373477
	for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2024 19:39:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729280379; cv=none; b=jx4OoA+gRG2F4/4/X/J1QdNnAS/yN7hBNRwmuqq0Pk1m7FUaqr3IRD+yCcVeMXycIO4mbrcMsI1JQADtYB51hHHuYFnZhXbgeCl3st/JSOy8PlH99/TWx2Hw0rlQkj8BFyc7JeLPxVaW0DuuNH/Wdh7FqsNJMqEmazCfO53faN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729280379; c=relaxed/simple;
	bh=Mxozfoc2wFCPw8q1s2Sax8TXVP8glwkB4JRZ4wXfUfo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PUPGPjuENz8az6rfgNNm/UtTS2NXEdZ0IWCu2olGSB6qgI26OQU4C1JSZPYTraODlHWrKtGFEoRTCCmppSioeQbaQj6y8XZjB4l1tbuj+IYgEEbLpyvQ8SOUBRahNMLFLPvxKvZMYBG4Yh8uzjy4xHBy7Z1VJ8ja++Dcz/5R0rc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Zus8MW0i; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Zus8MW0i"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4XVZlr6TRZz6ClSqS;
	Fri, 18 Oct 2024 19:39:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1729280374; x=1731872375; bh=Mxozfoc2wFCPw8q1s2Sax8TX
	VP8glwkB4JRZ4wXfUfo=; b=Zus8MW0iYn+u0XCNzSsozp2Lp2EbYReti7U/11bA
	1eoetH0E3ZIEJ4ElM8QE49Ctd+tzgFq7m0tVaM6MLk9FEhUqAlSJeV3xjdAW/mEj
	APCxwOB/+JNjMjtoZPBhmRZtgKBNlUorg/UdTpiM0996xjj9IkauoqTtNr9CYE7I
	3Ie7rNFyircrgJl86+0Bhv35YqeIejDgUSlX3Q1aM2o6glOt7E0KyRgvnPbHi80f
	l287bTOwqH8B/eZRr87eHzSjNW/EB0Lp7O4tdGrry7DfARjxr/+BGkVdGIZlpO53
	f/bxcELxtZeBk70a8pcWgpwpn0jvPLP8QqoqeyQ0fSxx+g==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id TplzT_VNfpfV; Fri, 18 Oct 2024 19:39:34 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4XVZlh6Gr9z6ClSqP;
	Fri, 18 Oct 2024 19:39:28 +0000 (UTC)
Message-ID: <74bcee3c-927b-401c-a526-f4daf557e01a@acm.org>
Date: Fri, 18 Oct 2024 12:39:26 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 5/7] scsi: ufs: core: Simplify
 ufshcd_err_handling_prepare()
To: Avri Altman <Avri.Altman@wdc.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
 Peter Wang <peter.wang@mediatek.com>, Andrew Halaney <ahalaney@redhat.com>,
 Bean Huo <beanhuo@micron.com>, Maramaina Naresh <quic_mnaresh@quicinc.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Eric Biggers <ebiggers@google.com>,
 Minwoo Im <minwoo.im@samsung.com>
References: <20241016211154.2425403-1-bvanassche@acm.org>
 <20241016211154.2425403-6-bvanassche@acm.org>
 <DM6PR04MB6575CBAB006C0228F1520268FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <DM6PR04MB6575CBAB006C0228F1520268FC402@DM6PR04MB6575.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/17/24 10:53 PM, Avri Altman wrote:
> Maybe also add a sentence indicating that this was the last caller of
> scsi_block_requests hence it can be removed.

I will do that.

Bart.
