Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B7C35E944;
	Fri, 17 Jul 2026 21:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784322639; cv=none; b=unCxVtDGhHY4YVG0YHiaPZijxznvnS/Xz+I04DcaJqiXxa2hOr7Yey7wbt55oqiBDZ4pohCaJRWOk2BT23Vyn5gZYXSybB08n5+LlLT4Zj+wiRzxl19Ksk1yPCJpgJ9XUAx28E0myH1yvPnrBVa1T3DgXIE4wFZWcd32Qe4CeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784322639; c=relaxed/simple;
	bh=Asu6LlzeSyRAekEood1ebtTy9RPpVi5m5x1E22q/YoU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XCPNhus7AeTWp0tIkLLqgopHXngbCE/TeLR7tHrOy98AQ0q0TPI/BNjiVNWHp3ing1SzQbPp9vKO+ekw0pCdocGXMwljPUL87nk7Y5WrZXKFO/MIobF+prjeBClBCW5Vqev5Ts+TKa/yUwMHSvhCiESoHi9saISAwuJJXzUY7P8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=0U/0awyI; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="0U/0awyI"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4h22cs5TYJzlh309;
	Fri, 17 Jul 2026 21:10:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1784322633; x=1786914634; bh=3Oj7Es9OxZsQkG/dRxJ0eXNS
	RD8JY6r+FrgE6JkyAd8=; b=0U/0awyIpk5k6id7m2JEDKTPkB/KMf/QDvhkCtRx
	fBNyx0hV7NmRzpmIbE8scq1DqLRZ2gHvOdi3+U7Cd3xq+CHzCM5Kn4y67fi2gxQs
	Ko9xVe2O9+78vE+xAR6YrU4V4IaBrMYomkH57z1iK7qNzHUuUXfjhyK4jlBSwzzm
	XIVf3zINFoHQ9ZpDjMSzzVGUShCw8B9sQL6xU5MKyMzMFJkL2lZZekVW2pL6Fehp
	7W03LJEPaSig8rdd5sTzudUcXt6P5HDt902QEz6EZMGrURY9eyqZ2znOYA8/5PqA
	AqeUYAmbhu4MUDIUk3+/jS8Lq4MHNuZfOdr8kaUQsQqJYw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id Y5wAkRDxldxh; Fri, 17 Jul 2026 21:10:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4h22ck14Ctzlh30D;
	Fri, 17 Jul 2026 21:10:29 +0000 (UTC)
Message-ID: <745f117a-253a-4b17-ad87-710f330c56c5@acm.org>
Date: Fri, 17 Jul 2026 14:10:28 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] ufs: rpmb: retry power-on UNIT ATTENTION on the RPMB
 WLUN
To: Jorge Ramirez-Ortiz <jorge.ramirez@oss.qualcomm.com>,
 alim.akhtar@samsung.com, avri.altman@wdc.com,
 James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
 beanhuo@micron.com, can.guo@oss.qualcomm.com
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 op-tee@lists.trustedfirmware.org, jenswi@kernel.org,
 sumit.garg@oss.qualcomm.com
References: <20260715214327.1933560-1-jorge.ramirez@oss.qualcomm.com>
 <20260715214327.1933560-2-jorge.ramirez@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260715214327.1933560-2-jorge.ramirez@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 7/15/26 2:39 PM, Jorge Ramirez-Ortiz wrote:
> +	/* Retry the power-on UNIT ATTENTION (ASC 0x29); the SCSI core does not. */

If this patch is reposted please leave out "; the SCSI core does not"
because most developers consider scsi_execute_cmd() as a SCSI core
function. Hence, this patch makes the SCSI core retry upon a power-on
unit attention. Otherwise this patch looks good to me.

Thanks,

Bart.
