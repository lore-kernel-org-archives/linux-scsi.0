Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1168F352F96
	for <linux-scsi@vger.kernel.org>; Fri, 30 Jan 2026 08:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769761224; cv=none; b=J/i1neltEOhCCczZPDvbMrasqxK4PrrnZdDPWMtKsGV0t2xjRJCFd14ZxJkwx/c3heIoRU6WcdiCmBFI6NlKLD95weq+AhbFMc2sw9nJehmrJP2sB1zoiul4KLUh9jlxJxqhPb2wKayTFwx2BpKQj9X+EaeAsmLseSIKIr7NEQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769761224; c=relaxed/simple;
	bh=wsB60SsaB/aPvZrKLMCQ5mnLRzC2S/En0vBPvRfcRK8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uYayArLH3pe7dSeqALOn/+GkJTAyCQ0A5/ng0bn8AqF2dcBezLS32RvHNhlcqXVrISAxOkRSf+4+zdAvgtyNGkvyI1DoLit4HexVj8tjFbQ+ImYoLIHw6KAWrTazNYqvK/rYcmucebjTxjyz7ebhe4pyVlV+u9lfbFi9n2PkCW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B21SdwEk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B21SdwEk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99824C2BC86;
	Fri, 30 Jan 2026 08:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1769761223;
	bh=wsB60SsaB/aPvZrKLMCQ5mnLRzC2S/En0vBPvRfcRK8=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=B21SdwEkErwDxdDE2njNng0qzcnZgL7uaWhYo+hoFsz0jWzNBHP+OdL4ViJ6Az7MF
	 mid65saBIFLJGTZGEJ3ETHbzRl8IcIVuLa/NZbEww1xt1rHhxfcP9UE2IV7C5z72RL
	 rVA8qcY4K9wzb6fhjP9zqm709qPeEK0DGfUYdJL2j8FGgICWVk0hC9ZdL02icxkzGK
	 HOrvuvJFYOqXXyWmyK0qTtwOhutLScAXNlKtEt6chQgEbxQzLFHkRVWTxgtj1/eRaP
	 NCcBulFIR3EjrRmPSvWJUOijNMjvys8jM7LnfZfF1os3FnN+duhdm/QEfZ7hdHg4kF
	 jB4Xw3f4AyBAg==
Message-ID: <0d646281-f3c4-422b-ada3-56b81775bce3@kernel.org>
Date: Fri, 30 Jan 2026 17:20:21 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: mpi3mr: Make driver probing asynchronously
To: Guixin Liu <kanie@linux.alibaba.com>,
 Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
References: <20260130080207.90053-1-kanie@linux.alibaba.com>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20260130080207.90053-1-kanie@linux.alibaba.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 1/30/26 17:02, Guixin Liu wrote:
> Speed up the boot process by using the asynchronous probing feature
> supported by the kernel.
> 
> Set the PROBE_PREFER_ASYNCHRONOUS flag in the device_driver
> structure so that the driver core probes in parallel.
> 
> Signed-off-by: Guixin Liu <kanie@linux.alibaba.com>

Looks OK to me.

Reviewed-by: Damien Le Moal <dlemoal@kernel.org>



-- 
Damien Le Moal
Western Digital Research
