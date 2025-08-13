Received: from 003.mia.mailroute.net (003.mia.mailroute.net [199.89.3.6])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB535287510
	for <linux-scsi@vger.kernel.org>; Wed, 13 Aug 2025 16:04:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.3.6
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755101063; cv=none; b=j6fIXJQQv1IjkibHBBw98TYFdHeZxxrZ6EfveUH6e6rrjuDMw6EqYaqrk0uqJ9BzVPqbxvkJCBsoP7ER8yF9qPmdXjCcRfz3HWiUuvTr8DouJhHVm9hb3vbb6gnGE9XKNP+KdGZo1hRSZ7NBa9a/oMrk/qxSV0xmWzY+TBC7utI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755101063; c=relaxed/simple;
	bh=1CdDSLxLxNhC8aamI1JOnJ1KxEvA5UCJHIOgIBzP7Zg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Kb372G0JZBJJzfW4mTlYZ+F0Ydtk1Pn+NRvPbvk7ZAZW9ZOSViMrPrw9kQzy6to475hWT6TOw2mjxDs78pby/XF0HhSLb7Pp95s5cCNsAzpf+POSfBotEiup46p37pbe/lex9vlVYwcXXCP7A0WI3Z0XIjhH0qTA+HyoEyRTXdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=fDZ1hVao; arc=none smtp.client-ip=199.89.3.6
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="fDZ1hVao"
Received: from localhost (localhost [127.0.0.1])
	by 003.mia.mailroute.net (Postfix) with ESMTP id 4c2CqM4MrVzltP0T;
	Wed, 13 Aug 2025 16:04:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1755101053; x=1757693054; bh=1CdDSLxLxNhC8aamI1JOnJ1K
	xEvA5UCJHIOgIBzP7Zg=; b=fDZ1hVaotGNJD3PIccepHVZCapjB04NqwiqqnpHM
	nVSMmGCBNXdiANHgpZ6zpOzYguDnSnoiBr4V8bXfF5ET/UDthIhpbfkVjNIJLhTG
	Fi1FBKPtU2rg3GowPxAs0d9hwsbw9Yv3PWO744MHJb9FR+9ZacWq1wPVTB8Swj7b
	dTyz7OQQPyuEpZrNYOgLcOOZujUTBcKhek4enyu12Kb9GwOYkitdPC7wicjNvtiY
	9gVV+nP+p9Eg1vxdvcvQPu4abHoH4BbvzjCN75Irr4gkTEaK/1n4MbtwdbMzx2Q3
	OdNeIqSRaTgo/Fl8uT4RuwFEjEeQW4rEHwcoeXvQnzuQig==
X-Virus-Scanned: by MailRoute
Received: from 003.mia.mailroute.net ([127.0.0.1])
 by localhost (003.mia [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id gQFAD1fkPDFT; Wed, 13 Aug 2025 16:04:13 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 003.mia.mailroute.net (Postfix) with ESMTPSA id 4c2Cq73jn3zlfnBh;
	Wed, 13 Aug 2025 16:04:02 +0000 (UTC)
Message-ID: <b707f40c-707f-4ef4-af9d-915dd8d5ea52@acm.org>
Date: Wed, 13 Aug 2025 09:04:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 4/4] ufs: core: Rename ufshcd_wait_for_doorbell_clr()
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>, "mani@kernel.org"
 <mani@kernel.org>, "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20250811154711.394297-1-bvanassche@acm.org>
 <20250811154711.394297-5-bvanassche@acm.org>
 <f11710482738e2550ede731eb8699a2c9967fe8a.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f11710482738e2550ede731eb8699a2c9967fe8a.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/12/25 2:03 AM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> According to the UFS specification, switching gears does not
> require waiting for IO to complete. Therefore, should we consider
> removing this function entirely?

I don't think so. Switching gears involves submitting an UIC power mode=20
change. From the UFSHCI 4.1 standard: "The Adapt is always performed in
conjunction with Power Mode Change. During the Power Mode Change
(and hence for the whole duration of the Adapt sequence) there will be
no data traffic on the link."

Bart.
