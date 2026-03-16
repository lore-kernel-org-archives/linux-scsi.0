Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2CD7A13A3ED;
	Mon, 16 Mar 2026 17:12:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773681156; cv=none; b=VCeSxWpjRv112o/6WvI1BN22DncMoVVp0cgYLhL+5VMzYQ9/uM6QeStM3It52aauFspXVOnAffwSX6fQexdC9pjQPIXCJEQOqsKYwC/h2Sni9dbV+z7A/xWI7H/CaLba4G0H3Vpe6M1GNX+t6vsYLNekhaKkUe2bguDcD4Oz1Os=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773681156; c=relaxed/simple;
	bh=Aw5NgfydFWJy+QC4rwr0YhOYLBPi89zLyGA6LcHIR7E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uWF1lBPNv8V5yyHartXHFrch9lSujhzmv6AMOJwjf2pDJfuLPXMlx6w3Q1KTMejSvmBYM+KGhqyxZwupaV/YtvuTnIx+8hq8KUOVYS+zd+nLu4WAtm1ldN+a7mNmxjE67w+J3GFvpKk0t/xUR8uy8JG6avOezidVK0Nm1xYiWcg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=VYNL61aR; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="VYNL61aR"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fZM8y4gLkzlh1TD;
	Mon, 16 Mar 2026 17:12:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1773681150; x=1776273151; bh=Aw5NgfydFWJy+QC4rwr0YhOY
	LBPi89zLyGA6LcHIR7E=; b=VYNL61aRR8rC2IC9lAC/itt3IWf5xLr7qT9l08oM
	JRyvJ4rUM7SDzfZzl/REseboLzh8A/H0nzDQo2qmqWTKawl7oWcwUhAmaNI57276
	0maV7lP3BLrV4gDfpOWUJiuw8JToTEQpV/LMffQ0FR+2PJc5mObrHF6fSa1vKqu5
	Pwvh7LYeOTc8tK3y898Zd5JvT37LtOdIPctffGwcfTC2JdpS5wP54WB8bJlcM7n/
	oJfNn6AuUhD6S5XZm0QDXL2sfNoK5McdNVS2SxK2K8yIm/hH+5U9PnW/JpqL4Pr7
	6MUt/SX46HgGHFYrpHWq8/PYyjhsMfxc3B1BWNL/zDs9cg==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 9YuiwlQCdQCj; Mon, 16 Mar 2026 17:12:30 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fZM8r213xzlgwNC;
	Mon, 16 Mar 2026 17:12:28 +0000 (UTC)
Message-ID: <ddba7b38-d156-4ba6-a678-14c9c6d80331@acm.org>
Date: Mon, 16 Mar 2026 10:12:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 06/12] scsi: ufs: core: Add helpers to pause and resume
 command processing
To: Can Guo <can.guo@oss.qualcomm.com>, avri.altman@wdc.com,
 beanhuo@micron.com, martin.petersen@oracle.com, mani@kernel.org
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 Peter Wang <peter.wang@mediatek.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 open list <linux-kernel@vger.kernel.org>
References: <20260308151409.3779137-1-can.guo@oss.qualcomm.com>
 <20260308151409.3779137-7-can.guo@oss.qualcomm.com>
 <edaac4ff-4d8d-498e-a38d-6474b9d39743@acm.org>
 <8c992c0c-6694-4b30-8e57-3bf12323dd77@oss.qualcomm.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <8c992c0c-6694-4b30-8e57-3bf12323dd77@oss.qualcomm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/14/26 3:38 AM, Can Guo wrote:
> Can we do it later as a separate patch and with enough testing conducted?

That sounds good to me.

Thanks,

Bart.
