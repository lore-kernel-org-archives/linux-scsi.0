Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A18F4A02
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 16:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766161966; cv=none; b=IZdCGQzhu4gYWmY1iJaB7XUcHs9sb+xjJ+XhbQjqt2KwIGXDKuCSzFSTCl+ICdz7KZapOmeG2wIlYgH1HYmcw2mxL28oS6yWsPAdMXUKihOxDyuIfrRxSdCFNPrgCGiE5M6K1Q0mIIzelQVjhsgE5r3FNFxos/07KrrF+Cm1r6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766161966; c=relaxed/simple;
	bh=GKdoXsKww3/qcfEeDT3zgg0U5DB6DsBN2E2cJEdynhw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=t8cV6V1fLAQCQ/RvZhvJge7xpYqT9htpsERHPIsWdpVZFcXe0mFl1Ix/FBFnYMhP0JJrdO/id8WSQOB+CPA/U6a5GNfFrfGXBZ+fxl93Awro/sCjgvCrik4H47/5OBwWmkzrSKwiBdukfMhFHTYhfHLNF/lr9CwpTf80B+/UWQU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=hhC3LHS4; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="hhC3LHS4"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4dXtP75RVrz1XLyhj;
	Fri, 19 Dec 2025 16:32:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766161961; x=1768753962; bh=GKdoXsKww3/qcfEeDT3zgg0U
	5DB6DsBN2E2cJEdynhw=; b=hhC3LHS4Olm1S56tQv34vU/1WdpxC3lTEB4aTxzJ
	R451sSZyjVdihEwE0JDII11rbSfxlgoYenD8VZw2mSWJ0PddOKdjeCeNTUOq8rCe
	LoJFym9XNgteTQmskzN7OyP+H37tfBgBQBPZ70eJhQkvKm8qCN34G9RrLm4676jN
	MUnomQOs/IPqiW8xb65NtxxmJsiDEllzei32nOUxGsz98A2Ie71eypYpqElIg2YM
	Eyy+kbTJ2uI+7+oieD9UC2Rloc2Cm047XixQax04vEZ8kBhFOe20mlxAAroXaxMk
	h18+9iV2PG1jTYTFs8PpE7tA/TOv9D/bJoIWWBJiwnoUBw==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 8dwHQLPgrS6r; Fri, 19 Dec 2025 16:32:41 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4dXtP31WcJz1XM6Jk;
	Fri, 19 Dec 2025 16:32:38 +0000 (UTC)
Message-ID: <6745d2d0-e8c4-407c-a22d-5577997f1ca3@acm.org>
Date: Fri, 19 Dec 2025 08:32:38 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH for rc] ufs: core: Configure MCQ after link startup
To: =?UTF-8?B?UGV0ZXIgV2FuZyAo546L5L+h5Y+LKQ==?= <peter.wang@mediatek.com>,
 "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
 "beanhuo@micron.com" <beanhuo@micron.com>,
 "nitin.rawat@oss.qualcomm.com" <nitin.rawat@oss.qualcomm.com>,
 "avri.altman@sandisk.com" <avri.altman@sandisk.com>,
 "James.Bottomley@HansenPartnership.com"
 <James.Bottomley@HansenPartnership.com>,
 "quic_nguyenb@quicinc.com" <quic_nguyenb@quicinc.com>,
 "adrian.hunter@intel.com" <adrian.hunter@intel.com>
References: <20251218230741.2661049-1-bvanassche@acm.org>
 <877f7704215c36bfb15808e3a168767845ce09c4.camel@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <877f7704215c36bfb15808e3a168767845ce09c4.camel@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/18/25 11:32 PM, Peter Wang (=E7=8E=8B=E4=BF=A1=E5=8F=8B) wrote:
> It seems strange to me that ufshcd_mcq_enable is called before
> ufshcd_link_startup.
>=20
> In driver development, configuration (config) should generally
> be done before enabling (enable) the hardware.
> Reason:
> Configuring first ensures the hardware operates correctly and
> avoids unexpected behavior or safety issues.
>=20
> Typical steps:
> 1. Set registers/parameters
> 2. Initialize resources
> 3. Configure interrupts/DMA
> 4. Enable the hardware
>=20
> So, do you also consider moving ufshcd_mcq_enable after
> ufshcd_config_mcq?

This has been considered but unfortunately the UFSHCI register set
definition makes this impossible. hba->host->can_queue must be set
before scsi_add_host() is called. hba->host->can_queue is derived
from the controller capabilities register (CAP). MCQ must be enabled
before NUTRS is extracted from the CAP register. Otherwise NUTRS is
reported as 32 - 1 instead of 64 - 1 (assuming that the host
controller supports 64 outstanding commands in MCQ mode).

Thanks,

Bart.
