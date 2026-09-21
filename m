Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 858C34AF169;
	Mon, 21 Sep 2026 16:52:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790009531; cv=none; b=E5S5JJC7KGtJJe5WBNXsPc9nz0n0jwipNJB6/7x187fcY28kbR3JPHmQ5IYx0EqMHf22IV0IpCLwz3aF3nOuU4IiIgwQCyWoQAria21SmG1XUc67EKLuyK/AmK3seoXQOKbb8M7EQDckzRdDt5/wEigN5s7Qj6jh6d+F/2+mywY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790009531; c=relaxed/simple;
	bh=66giKM6an+EtXnssTX6fwOPNfR7K1yRyBSvhdC6zF6Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kOQORynq56y7brXw3/YAas6zgVwcJzNhaJh2f8R65aTRJAxmseo3tNCKx43Y5I8qRm4lV1FwmxlX9HB2TSSKeNs0m4bUpSRDfvwxZxSuazF/Y81TZrMLtlK3aUfYTq3xfwUXxWBYiTEBiDqGdpBAF4RQeFcfSvpFlqA8UqCzjQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=rFre91vU; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="rFre91vU"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hpTm85Q5rz1XM5kW;
	Mon, 21 Sep 2026 16:52:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790009520; x=1792601521; bh=46LIWJijHQO9jyZJlG498yjm
	rMQ1c94F2Ko1vshe11o=; b=rFre91vUejHM2N0ObrdfyNeKKWQXzhbzQiCbVT8Y
	jwGkv2oo3xJq5mPf1U96IIA3IGMRciv4wzGE13dHb7ckkDZ0Be/F/4vlIQ2CBIRU
	fed0uRky26BGqtvcqCoWI9NW4jkGF9uM3WigHFj3E0AIlJLraBnsv4bHumSLxpRy
	uoBR/mqyMXdbl04UaVt0hGWBUfi/Y29wUVMjJDLbC2jb7S+rRsOsSUxHva3ezK0h
	ZlBtn7NmkgOzugrA/PcIpeglDgGJqCD+im/Pirdsl36abZQ4FApYezBTsIYGSoTT
	hqP7QMRR7exeCCIGtT+mgOBwvZfvUm6e1+BVLQV9wqdEfg==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id FouSPSgioO13; Mon, 21 Sep 2026 16:52:00 +0000 (UTC)
Received: from [100.80.231.125] (unknown [104.135.182.41])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hpTlw0tkXz1XM4TB;
	Mon, 21 Sep 2026 16:51:55 +0000 (UTC)
Message-ID: <16af6539-24f8-425e-b411-f191897acfce@acm.org>
Date: Mon, 21 Sep 2026 09:51:54 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Release command resources instead of
 force-completing
To: Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Peter Wang <peter.wang@mediatek.com>,
 Manivannan Sadhasivam <mani@kernel.org>, linux-scsi@vger.kernel.org,
 linux-kernel@vger.kernel.org
References: <20260920143319.3659543-1-stanleyjhu@google.com>
 <20260920143319.3659543-2-stanleyjhu@google.com>
 <fee250ea-8e0b-4320-880e-8e2627e7b103@acm.org>
 <20260921043755.1689675-1-stanleyjhu@google.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260921043755.1689675-1-stanleyjhu@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/20/26 9:37 PM, Stanley Jhu wrote:
> On 9/20/26 5:41 PM, Bart Van Assche wrote:
>> Regarding (3), the UFS driver is a SCSI LLD (low-level driver) and hence
>> should only do what is specific to the UFS driver. Completing commands
>> after .eh_host_reset_handler() has been called is the responsibility of
>> the SCSI core and should not be done by the UFS driver.
> 
> Agreed for the path where SCSI EH drove the reset. The case I am unsure
> about is the other caller: ufshcd_err_handler() also runs from
> hba->eh_work, scheduled by ufshcd_check_errors() on UIC and controller
> errors. Those commands have not timed out and are not on
> shost->eh_cmd_q, so SCSI EH never finishes them, and the handler leaves
> them to the reset path on purpose:
> 
> 	/*
> 	 * if host reset is required then skip clearing the pending
> 	 * transfers forcefully because they will get cleared during
> 	 * host reset and restore
> 	 */
> 
> Should those simply wait for the block layer timeout and come back
> through SCSI EH?

That sounds good to me.

Thanks,

Bart.
