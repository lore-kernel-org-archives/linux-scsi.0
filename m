Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AC6D569F04;
	Tue, 22 Sep 2026 16:34:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790094900; cv=none; b=laz0l1cag1TAxokDe72o5CEX7Z8owmQRtzSmO+GlPUnJhTnc0TpAmQmsaXlDPg5+JTr0fZQMcaE3Uzona+yQxxFZVYzIe6tmRAJA5EeVhCP+F25xd6Qq7NEP0OfiFFOVy+cVvWiqcjy35Dw76ywPrh+hqOc4ssmro2hEns0X3W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790094900; c=relaxed/simple;
	bh=JH8bUHoMVtekCvm62x0h6O584h/v3A/r8+Qpzy03oA8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LDrWyhPxEDdFP19zmMlup4UI5OGtafXc8P7cATF+lfr8sir+ptc6rOiU67eamKdqyFzzbavbuNcM+jQjadohy5NIeIOiXc+KpGJFWHwvdgq297IMnuIx0fYdIR+KABy0VaeQrIjSFhMZDjKlCRUWJ/xErCU/sxw8CR4jSukdq3k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=wz4vBzen; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="wz4vBzen"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4hq5Kt4D98z1XM5kW;
	Tue, 22 Sep 2026 16:34:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790094892; x=1792686893; bh=JH8bUHoMVtekCvm62x0h6O58
	4h/v3A/r8+Qpzy03oA8=; b=wz4vBzenxEznkgNx1G7KYo1lmZ6IraqGwOPKjgcB
	QUkSARJTf2bmnk1etD/x9+kY6bASX932xrW2jKSs4yKttmNzZMsiuFnmk1rxFcv/
	IAn/xsseYpfHWbKiTcL18FhAEpOhHhFv5ob1hjoQkw29uBZxDHWn+zTSkSkZSOuj
	VQJv5uABOUl78/yTXbZ/jrYbU72MUB9ePL17eytjJlbuyDhWigSITL0LUUfSJ69t
	lACXZKLLQlM0WQM0AmCKL37VlOvz91ZaDuW88GbnEuz2K1+oEXYBPbEJfqwS6rOO
	UwiXovraWBL+rGbyyB7ggZ/5LYvcQ8H4wuhQb2/gEbZSxw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id rdmk7zB-djfj; Tue, 22 Sep 2026 16:34:52 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:1f32:8c6:3a87:d280] (unknown [104.135.182.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4hq5Kj2TKKz1XM4Sx;
	Tue, 22 Sep 2026 16:34:48 +0000 (UTC)
Message-ID: <89e1ae39-dc01-46c6-b126-a7175847910d@acm.org>
Date: Tue, 22 Sep 2026 09:34:48 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 1/2] scsi: ufs: core: Release command resources instead of
 force-completing
To: Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <stanleyjhu@google.com>
Cc: "Martin K. Petersen" <mkp@kernel.org>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman
 <avri.altman@sandisk.com>, Bean Huo <beanhuo@micron.com>,
 Can Guo <can.guo@oss.qualcomm.com>, Manivannan Sadhasivam <mani@kernel.org>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20260920143319.3659543-1-stanleyjhu@google.com>
 <20260920143319.3659543-2-stanleyjhu@google.com>
 <fee250ea-8e0b-4320-880e-8e2627e7b103@acm.org>
 <20260921043755.1689675-1-stanleyjhu@google.com>
 <16af6539-24f8-425e-b411-f191897acfce@acm.org>
 <6288ff21af758e0f3739edb6c33abe3bfbdba3dd.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <6288ff21af758e0f3739edb6c33abe3bfbdba3dd.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 9/21/26 8:03 PM, Peter Wang wrote:
> It appears unreasonable to wait for the entire 30 second timeout,
> as many UIC errors recover promptly. The resulting 30 second stall
> would manifest as a noticeable UI freeze. Maybe we shouldn=E2=80=99t le=
t
> eh_host_reset_handler call the EH handler at all?
The default SCSI disk timeout is 30 seconds. That default timeout was
chosen when hard disks were the most widely used persistent storage
medium and before NAND storage became widespread. Isn't that default
timeout too big for UFS devices?

As mentioned in another email, .eh_host_reset_handler() must abort
all pending commands and must terminate all ongoing task management
functions. This implies resetting both the UFS device and the UFS
host controller. I'm not sure how to do that without calling
ufshcd_host_reset_and_restore()?

Thanks,

Bart.
