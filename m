Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E9E615A85A
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 02:51:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764384683; cv=none; b=Ky73DtzvTXnL0owr7oYKb9vJDTxeQDgRYt/UzyhyOeVwzfndK/n89+lWWl240BYaYMfB0CDcPXF0xvQbeXk0jtTJY+DwnlmJRZXujSzQxpjsjJZqtcvNBktjxAwZTDcvGYykvcP1rvSiKyineCCK3cHhhQZhnGjgx3y0jPUOkPg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764384683; c=relaxed/simple;
	bh=40talP2Sb1pQuDXVviduAC2Vk0KzlEbmXgGLePvU1QQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=qd2Jg0rE/5yzIWJ26VWwAM3aKrDmHYMLlrZFXn2BKWVstGrCWpBZZr1lHq5P5lYazqYErGmlEgdM6vqK+74C5FK0nZxQ9CuGst5WqMTBjdoeYbXaUpOlb5WfXBrCyDtmEUzNsc16/gF6N9DGalO6zMTY7URdGY313XL7FzrBKhA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=m0M2f8Nr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="m0M2f8Nr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37B2BC4CEF1;
	Sat, 29 Nov 2025 02:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764384682;
	bh=40talP2Sb1pQuDXVviduAC2Vk0KzlEbmXgGLePvU1QQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=m0M2f8Nrro6ETVTOtT1VCA5AmswWbhbJ1JVccB/LomoGW/j7ceLMeVqxx6FIk0NBX
	 Xuq6iULd/H66h8KNaoOsREnTnoFWM7eiaYrlDRz3ZgfjPbizqp74DC4gpSWZX/ZSgo
	 0ApFJTq5V2ERgDOXssgI8OXPRIhcFIZ/6zTHAoo+9P5wYbli24HbSIsNo2ievRztTx
	 /h4XPTo9t8oSWklWsIEgzlZ7O/rySEFCpvPp9gLgrKxbRI7uCTPi0LoZEC7I3kC5Jt
	 o134MXz1wJutqvn/c57jfpuXxgp64531jLZ7C6xyaYmvmLe4gCF2ksT+Gm7pXexJSG
	 8lMseUny33hDg==
Date: Sat, 29 Nov 2025 08:21:09 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, 
	linux-scsi@vger.kernel.org, "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>, 
	Peter Wang <peter.wang@mediatek.com>, Avri Altman <avri.altman@sandisk.com>, 
	Bean Huo <beanhuo@micron.com>, "Bao D. Nguyen" <quic_nguyenb@quicinc.com>, 
	Adrian Hunter <adrian.hunter@intel.com>, Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
Message-ID: <6fw4oikdxwkzbamtvu55fn2gqxr3ngfzymvxr6nxcrjpnpdb2s@v325mijraxmg>
References: <20251031204029.2883185-1-bvanassche@acm.org>
 <20251031204029.2883185-22-bvanassche@acm.org>
 <ehorjaflathzab5oekx2nae2zss5vi2r36yqkqsfjb2fgsifz2@yk3us5g3igow>
 <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <5f75d98a-2c0a-4fdf-a2a9-89bfe09fe751@acm.org>

On Fri, Nov 28, 2025 at 06:31:36PM -0800, Bart Van Assche wrote:
> On 11/27/25 8:59 AM, Manivannan Sadhasivam wrote:
> > [1] https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/
> 
> This log fragment is only 55 lines long. Please provide the full kernel
> log.
> 

I just copied the relevant log. But you can find the full log here:
https://gist.github.com/Mani-Sadhasivam/770022b53f11340fbaba06d8eaac1843

Unfortunately, there is not much useful information in the log.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
