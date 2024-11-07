Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE7712B63;
	Thu,  7 Nov 2024 15:08:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730992126; cv=none; b=g0Z2MEV0sWMsk81/PpVsw0MLr9YSEqsM4tPEkBwhxkobKnlLo8UaSJeVJIsF7B1E+gd8rJ3MzTSMxNaZlcq+dQGxCE5wA3Xt42CDuu3yfOds3C1s41MagN0re3vhEchyuW1HVGIHrbcp8Nqyr9uRgNVVt6WmZINkqZzwe4UpaN0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730992126; c=relaxed/simple;
	bh=yROB/JSPfGg8ulwgUuxtnrZVFOSaC6aEtuR/Eigags8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CXU9q4YwLPzG+K2SQYN7Xt/pLXLXQoJMDBqdTS+kRhHKmqiHwYiocuuPbf2lDd/RDaGMtTOlVcUt+Jx0uk0TJCQdkUuj8Jcvn49yO67M9AdQMps5sLhuF4ZogZrGCx3hhzZCVkqQ1TKqs5h0y9AAgu47T/BsdExo/ZN3zzPWKSE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ty4JSfUb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ty4JSfUb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C069C4CECC;
	Thu,  7 Nov 2024 15:08:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730992126;
	bh=yROB/JSPfGg8ulwgUuxtnrZVFOSaC6aEtuR/Eigags8=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=ty4JSfUb09Cg+HIJZ8WJJ80DrZK8OHt7CRsIYjnRf2Vk2oCVH7vRrfZ0O1+r/fvZv
	 aTjTWbv/24l1jNkV9ezjcAcaF8uVX5UiuCUNSl2UyDkBEtKrdCjHd+lAkw8DDdp4Ev
	 iI4sXBC+YI6pqqLvJrwimOplFsuE0WzFTCho2mVY=
Date: Thu, 7 Nov 2024 16:08:25 +0100
From: Greg KH <gregkh@linuxfoundation.org>
To: Qiu-ji Chen <chenqiuji666@gmail.com>
Cc: linuxdrivers@attotech.com, James.Bottomley@hansenpartnership.com,
	martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
	linux-kernel@vger.kernel.org, baijiaju1990@gmail.com,
	stable@vger.kernel.org
Subject: Re: [PATCH] [SCSI] esas2r: fix possible buffer overflow caused by
 bad DMA value in esas2r_process_vda_ioctl()
Message-ID: <2024110706-spoilage-driven-7523@gregkh>
References: <20241107113617.402343-1-chenqiuji666@gmail.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20241107113617.402343-1-chenqiuji666@gmail.com>

On Thu, Nov 07, 2024 at 07:36:17PM +0800, Qiu-ji Chen wrote:
> In line 1854 of the file esas2r_ioctl.c, the function 
> esas2r_process_vda_ioctl() is called with the parameter vi being assigned 
> the value of a->vda_buffer. On line 1892, a->vda_buffer is stored in DMA 
> memory with the statement 
> a->vda_buffer = dma_alloc_coherent(&a->pcid->dev, ..., indicating that the 
> parameter vi passed to the function is also stored in DMA memory. This 
> suggests that the parameter vi could be altered at any time by malicious 
> hardware.

As James pointed out, "malicious hardware" is not a threat model that
Linux worries about at this point in time, sorry.

If you wish to have Linux care about this, random driver changes like
this is not going to be the way forward, but rather, major things need
to be rearchitected in order to "protect" the kernel from bad hardware.

But really, if you can't trust the hardware, you have bigger problems,
any software can't protect you from that :)

sorry,

greg k-h
