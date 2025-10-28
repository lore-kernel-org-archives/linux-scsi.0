Received: from 004.mia.mailroute.net (004.mia.mailroute.net [199.89.3.7])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C34893346B5
	for <linux-scsi@vger.kernel.org>; Tue, 28 Oct 2025 13:34:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.7
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761658445; cv=none; b=uV+KcjTjKZVJUbW3iVnqMV99OSXOuXeo77nI41XrMfz1ZZLq8F5r95xFXuEPfmriP2GfgcyxMUOzkczS719RSe2Q6+eEZy16KWgwP1Y/jwUHk7Vqm9ue8gvopottvWnPwWustrtoS+D8tCEKzTktH6YWEvaM4TUPRG7VCL76XXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761658445; c=relaxed/simple;
	bh=W5UIEfXUghUxjHlubmgKDCd2vy7cdKj/3oVEzn/VbeU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=rd/+qtQpV3bjWaMq3heCuNvhn1WDbuOHr5snK4PqKPFkiESujUAwry1lg8rBR/arbWaVQGdoICLyC2sZe6vZFpaALYIKuqWiFxzdd6Jd9yosBf0URFoVcD7mWg2razXWUF8xqtJuN/+JGWcmw4PvyJCmXDp3OLc6CWUVL5RaTKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=kf2pkfuY; arc=none smtp.client-ip=199.89.3.7
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="kf2pkfuY"
Received: from localhost (localhost [127.0.0.1])
	by 004.mia.mailroute.net (Postfix) with ESMTP id 4cwrtv3hhfzm0yTC;
	Tue, 28 Oct 2025 13:33:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1761658436; x=1764250437; bh=W5UIEfXUghUxjHlubmgKDCd2
	vy7cdKj/3oVEzn/VbeU=; b=kf2pkfuY5Ffu50MRswI8FagXPee3bCXPQhLq7iDj
	zIYtrX+05ixt7H7CKIt4+HaEscV0/2W/umf9LnOyKSKFXo7TMtpqAH9ITIHVKyH8
	W9PYfYDrqCYm9rq9yn7TbGVaui3O8WAcExFSoKRXe+E39dl/zL6Hw9tTv0Djo1xe
	GCJzRfXeWWpVqsTdpcCE0PUBMJmPpRiDrN+zySyxt9JSuWqcOPnHE0i54cvr60QV
	4FrYK4Ley19SvfHw/pDS/Tb6u5DPsP5+Z4I+nzF7bH4f90JgN5up04QGvdbI74sC
	HnFKL6nyoFNx72WFeT1rlYu4SIu+MMNGLyNhTqMoMbnJGw==
X-Virus-Scanned: by MailRoute
Received: from 004.mia.mailroute.net ([127.0.0.1])
 by localhost (004.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id GI9dAqRwXL44; Tue, 28 Oct 2025 13:33:56 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 004.mia.mailroute.net (Postfix) with ESMTPSA id 4cwrtT5Tbczm0yTy;
	Tue, 28 Oct 2025 13:33:36 +0000 (UTC)
Message-ID: <305280d8-4e9c-477f-9b50-b789e6fdb615@acm.org>
Date: Tue, 28 Oct 2025 06:33:34 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] ufs: core: Really fix the code for updating the "hid"
 attribute group
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "andersson@kernel.org" <andersson@kernel.org>
Cc: "neil.armstrong@linaro.org" <neil.armstrong@linaro.org>,
 "quic_nitirawa@quicinc.com" <quic_nitirawa@quicinc.com>,
 "James.Bottomley@hansenpartnership.com"
 <James.Bottomley@hansenpartnership.com>,
 "chullee@google.com" <chullee@google.com>,
 "tanghuan@vivo.com" <tanghuan@vivo.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>,
 "ebiggers@kernel.org" <ebiggers@kernel.org>,
 "gwendal@chromium.org" <gwendal@chromium.org>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "huobean@gmail.com" <huobean@gmail.com>, "mani@kernel.org"
 <mani@kernel.org>, "matthias.bgg@gmail.com" <matthias.bgg@gmail.com>,
 "avri.altman@wdc.com" <avri.altman@wdc.com>,
 "liu.song13@zte.com.cn" <liu.song13@zte.com.cn>,
 "quic_cang@quicinc.com" <quic_cang@quicinc.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
References: <20251027170950.2919594-1-bvanassche@acm.org>
 <20251027170950.2919594-3-bvanassche@acm.org>
 <fysnm3cpnz6ipqw4tbw2jh3rvxqjzgabmz2oppccjus3gv2sab@oi6dz4o4zkw2>
 <98c45a4b9a409d0fb187bc5228076d088650555c.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <98c45a4b9a409d0fb187bc5228076d088650555c.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable


On 10/28/25 5:47 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> Agreed, ensuring the correct flow is better than using some
> tricky protection to solve racing issues.
> Previously, I asked about fixing the flow:
> "Would it be better to ensure that ufshcd_async_scan completes before
> invoking ufs_sysfs_add_nodes?"
There is another reason why delaying the ufs_sysfs_add_nodes() call=20
further is wrong: ideally sysfs attributes should be added before the
uevent is emitted for the associated device. This is why Greg KH keeps
asking to use the groups member of struct device instead of calling
sysfs_create_groups() directly.

Bart.
