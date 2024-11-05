Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E16D36127;
	Tue,  5 Nov 2024 03:48:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=96.44.175.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730778525; cv=none; b=qeNoLaub8ICPFIZ55jQWTZl+DDTv0t8KvLAzxxKBzYTC3dxP2YcQtPU1klTYZ4RPHGhs1hT1cMszh9aoR9G3YaE3hH4scGXmLhoeJ2UCZrUisnkj2M5t9PaT6iqDw1N5vsVIdwudTA+w0co2p0z/8/agtOSTGZFmHDg8LL4KoC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730778525; c=relaxed/simple;
	bh=C5al7sr9+zIr62fShfzSdJHgAt3jSR3yCrIrGo96LcE=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=VLpBzFKJ3LmXWRDqqJkFiWMnXXyMQ8o+kVfLU8zfDMA+qAVTSQHJRZMUeTdc9TRS/cSX/hEYxfs3bgjtUxhtICOi6Hr6k5RofCujgu4nkQYd0/N4CKa/vzPCO43ACrP0SdsiC03cOMjkUDXLVpQI7IvKAnO9ZdOQ9b2sxivVo1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com; spf=pass smtp.mailfrom=HansenPartnership.com; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=q0eVVRkB; dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b=q0eVVRkB; arc=none smtp.client-ip=96.44.175.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=HansenPartnership.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q0eVVRkB";
	dkim=pass (1024-bit key) header.d=hansenpartnership.com header.i=@hansenpartnership.com header.b="q0eVVRkB"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730778522;
	bh=C5al7sr9+zIr62fShfzSdJHgAt3jSR3yCrIrGo96LcE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=q0eVVRkB6mRL5EFQRI1KlglHfYHSb2SXmtKoQLzU5/GQB0Q9PrNEpzXg3PNc6Vqub
	 6bwy0q4gP0+9CX2qXIfa+s/DD71cDeJZDOyqRXf0PmVNXT5kfwmGgyNOv/guXeAhjG
	 yQEmG+EOhOQ3OTzqrRaH4BuPUCrauuYfRELBGkoY=
Received: from localhost (localhost [127.0.0.1])
	by bedivere.hansenpartnership.com (Postfix) with ESMTP id BFABD1281086;
	Mon, 04 Nov 2024 22:48:42 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id Xh3NB1Dxkbjq; Mon,  4 Nov 2024 22:48:42 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
	d=hansenpartnership.com; s=20151216; t=1730778522;
	bh=C5al7sr9+zIr62fShfzSdJHgAt3jSR3yCrIrGo96LcE=;
	h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
	b=q0eVVRkB6mRL5EFQRI1KlglHfYHSb2SXmtKoQLzU5/GQB0Q9PrNEpzXg3PNc6Vqub
	 6bwy0q4gP0+9CX2qXIfa+s/DD71cDeJZDOyqRXf0PmVNXT5kfwmGgyNOv/guXeAhjG
	 yQEmG+EOhOQ3OTzqrRaH4BuPUCrauuYfRELBGkoY=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::a774])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits))
	(Client did not present a certificate)
	by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 742B01280659;
	Mon, 04 Nov 2024 22:48:41 -0500 (EST)
Message-ID: <74c56b1f29a08df52c22a0ac01c1b31813ce454b.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: ufs: Start the RTC update work later
From: James Bottomley <James.Bottomley@HansenPartnership.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Bart Van Assche
	 <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, Neil Armstrong <neil.armstrong@linaro.org>, 
 Bean Huo <beanhuo@micron.com>, stable@vger.kernel.org, Peter Wang
 <peter.wang@mediatek.com>, Avri Altman <avri.altman@wdc.com>, Manivannan
 Sadhasivam <manivannan.sadhasivam@linaro.org>,  Maramaina Naresh
 <quic_mnaresh@quicinc.com>, Mike Bi <mikebi@micron.com>, Thomas
 =?ISO-8859-1?Q?Wei=DFschuh?= <linux@weissschuh.net>, Luca Porzio
 <lporzio@micron.com>
Date: Mon, 04 Nov 2024 22:48:39 -0500
In-Reply-To: <yq1ttcm4dju.fsf@ca-mkp.ca.oracle.com>
References: <20241031212632.2799127-1-bvanassche@acm.org>
	 <yq1ttcm4dju.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit

On Mon, 2024-11-04 at 21:31 -0500, Martin K. Petersen wrote:
> 
> Bart,
> 
> > The RTC update work involves runtime resuming the UFS controller.
> > Hence, only start the RTC update work after runtime power
> > management in the UFS driver has been fully initialized. This patch
> > fixes the following kernel
> > crash:
> 
> Applied to 6.12/scsi-fixes, thanks!

Hey, this one causes a nasty merge conflict due to 3192d28ec660 scsi:
ufs: core: Introduce ufshcd_post_device_init() ... I fixed it up in my
for-next branch but conflicting with someone else's patches can be
considered unfortunate; conflicting with your own looks like
carelessness ...

Since ufshcd_post_device_init is now called twice can you just check
that the simple fixup of removing the schedule_delayed_work() from it
is actually correct.

Thanks,

James

