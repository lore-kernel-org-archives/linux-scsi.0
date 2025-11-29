Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41DFB1391
	for <linux-scsi@vger.kernel.org>; Sat, 29 Nov 2025 02:37:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764383826; cv=none; b=OyrAw1zsbq27xOrXHGH9fD/JQuXTaEsDNaQm/zLKaVYz+j5dM/3XwOh4K2Z4i8+cbdRuCntvaUzwMAjy/hS0Su/Owrwv0QlEdac/vXB9ROUGofFd0TVyATQ8w315Njn90TIK4A0xZKIYUZsx8nTQ/6TlMafvMAlbRjQ5UfpFMTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764383826; c=relaxed/simple;
	bh=v9eU8SFU+Iv5CAmBnrrSIh5cu4/IOmhyjS5qqitPcfg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=dFK5UnisLQFXDz1oScPk9Q9WNL3MHeBIVMZbCiJfnFTHCxBXeBQ0XG+sp2J44MVqFAjjVhtnYzSzJ8JrDnZcWVLPtfo3WZ9lPcvQxHJ5erCr4KO/Oj3V5O/47OxaMNy2JdV1+DgTfB+WBkiUhDjTSvimkQzslLKzyD882XuR7aE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=ry3Fz0OX; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="ry3Fz0OX"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4dJDp10p9hzlgqjF;
	Sat, 29 Nov 2025 02:36:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1764383814; x=1766975815; bh=lRPlK9s5hoRRDzOspRgIAwJi
	miBF5c54kqMXM6OEVHs=; b=ry3Fz0OXQM5VnIjfgRiqu65KvDUyNKH4GT2fHsVt
	LHtFTKiL8Fzy/sUY/Ykp/1yXKQ9ue1nGBgNoKgxqVwOZHhQgW0RFNC7d6gRkf4EN
	thMUJoZW0crUu5vSFe5JfpihOwli08ZUFUTUxHbpDtN1+ucfS1lS4eQTwb5CUY0V
	YIIJQd9wWa6Rk79tcnb58DGufPBwO6HB7mOWJnu6/RT9Ho9xg4L+JgzG6CISEJ83
	qMAD642qanQHp1FhMjqmnlvtbGi0NraeVl1LGdk0HRDlR2QL3QLy8mEnPpb4sO8d
	n4hck7ddJwuD6bUcDJVwDWvlhty/LNf/lcNUIVaq3il9UQ==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gVIUvKM3M0TL; Sat, 29 Nov 2025 02:36:54 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4dJDnl59J1zlgqVX;
	Sat, 29 Nov 2025 02:36:42 +0000 (UTC)
Message-ID: <cb777f15-1017-4183-91a8-b7e968d0df9c@acm.org>
Date: Fri, 28 Nov 2025 18:36:37 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v8 21/28] ufs: core: Make the reserved slot a reserved
 request
To: Roger Shimizu <rosh@debian.org>, mani@kernel.org
Cc: James.Bottomley@hansenpartnership.com, adrian.hunter@intel.com,
 avri.altman@sandisk.com, beanhuo@micron.com,
 Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
 linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
 peter.wang@mediatek.com, quic_nguyenb@quicinc.com,
 Hongyang Zhao <hongyang.zhao@thundersoft.com>
References: <CAEQ9gE=Yo71Aji02a5uGdv7uZ+fJcCa1TKAEZskdM_-VZedTqQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CAEQ9gE=Yo71Aji02a5uGdv7uZ+fJcCa1TKAEZskdM_-VZedTqQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/28/25 12:12 AM, Roger Shimizu wrote:
> While testing Rubik Pi 3 [2], I found the above UFS issue, too.
> for next-20251121, I used the revert cmd below to workaround:
> $ git revert 7ff1cca -m 1
> 
> for next-20251128, I used cmd below, and there's a conflict to resolve.
> $ git revert f10ce81 -m 1

Does your kernel tree include this patch:
https://lore.kernel.org/linux-scsi/20251114193406.3097237-1-bvanassche@acm.org/? 
If not, please try a more recent for-next
kernel. If your kernel tree includes that patch, please share the
kernel log.

Thanks,

Bart.
