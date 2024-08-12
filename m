Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06BA818786E;
	Mon, 12 Aug 2024 17:12:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723482739; cv=none; b=B+surlmtxWuFfSijaxTQhdPBGO/p4TIBtBAWgozWgxMx0CfRUri7j3RmKSi3AwBeav4YzCtvO+D0WrcaCVsUZsSa9Qr3wQT25dgdCXpZ37I7xFLqCB+jYTfWKnYHDWZ6sNOLfm3DeowE0W0FSwoUbYRJgkpaU3RzxUWvKK69AJM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723482739; c=relaxed/simple;
	bh=f99OzS1Z5JIkC48o0XX4rlzPg4J6OYFjpIe3nFvw2HM=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=kc7lp5T22Z568RpwSxPuJYi9NZRleyAYEzSRUi2YeEudbsv3q9HkxXWHF4jay/0luBkLkITC7tHz61G6Kn1NYudHyF4aBvYxOqpAPAH4PQqUJoAiNrQJfJhc6xkoCVUXRYuwiaLeJQABp1nmY+DIcwVzDNSBNnRG2cFtONxUAFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=NWS36yqB; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="NWS36yqB"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WjLfg3G27zlgTGW;
	Mon, 12 Aug 2024 17:12:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1723482727; x=1726074728; bh=f99OzS1Z5JIkC48o0XX4rlzP
	g4J6OYFjpIe3nFvw2HM=; b=NWS36yqBdxMhigw9CZ1nLzQlCUyJb3viExke25b/
	4i/SiK6GXURhsPEsByZz31oEqFa9IBKd2I6fT/NEz87nJz2pxBtnRN2davVn/m4o
	qG37WLJmBdWzMBOMs06DjhqY/BB9+pHulSIXs4q2ovdQGMPFaIW/u6PScA0MMdAV
	MJQuNO1GHiWctUGL2j17uRM2y/wHbdIrlV0FALNzsZ31cnQ4QpgQBZ4LZExS8U11
	ajlkqZN215oyGL3vkGtMOcae5JRWpfJM3t+qi1BAlA2jcMfHGTnyC8+Z0v1Lc5Tq
	acTbb6o4S2fWGtqx9XuQ/QTCLNgXoNg65fL6F70haX82uA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id nNAXvhAr9w7r; Mon, 12 Aug 2024 17:12:07 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WjLfW418XzlgVnN;
	Mon, 12 Aug 2024 17:12:03 +0000 (UTC)
Message-ID: <8e0c2a00-1744-4cfd-b576-5efe74b21f9b@acm.org>
Date: Mon, 12 Aug 2024 10:12:01 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1] scsi: ufs: core: introduce override_cqe_ocs
To: Bean Huo <huobean@gmail.com>, Kiwoong Kim <kwmad.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, beanhuo@micron.com, adrian.hunter@intel.com,
 h10.kim@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com,
 kwangwon.min@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <CGME20240812065927epcas2p4ace98e8757a76e62efa3165de719408a@epcas2p4.samsung.com>
 <1723446114-153235-1-git-send-email-kwmad.kim@samsung.com>
 <f4de493e53b6d2ea543d10bc07a030b32b1e2107.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f4de493e53b6d2ea543d10bc07a030b32b1e2107.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/12/24 8:41 AM, Bean Huo wrote:
> On Mon, 2024-08-12 at 16:01 +0900, Kiwoong Kim wrote:
>> +static inline enum utp_ocs ufshcd_vops_override_cqe_ocs(struct
>> ufs_hba *hba,
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=
=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0enum utp_ocs
>> ocs)
>> +{
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0if (hba->vops && hba->vops-=
>override_cqe_ocs)
>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=
=A0=C2=A0=C2=A0=C2=A0return hba->vops->override_cqe_ocs(hba);
>=20
> it is useless until you should introduce an usage case.

Indeed. If a new callback is introduced, a user for that callback should
be introduced in the same patch series.

Thanks,

Bart.

