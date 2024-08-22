Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E7251CCEEB;
	Thu, 22 Aug 2024 16:26:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724343979; cv=none; b=aUY6dSg1dXoWeR1V1HGl8Nf/EOCl6Qp01SPI/MGkUttfmCXv4rWoiv2J4Sqdh+mi9qWlV9DkBpBDc7Scgz+x1ER9BpMzqx6E3/wZ6AbFZ0KD9mdwZR+EVCMNaEJLiqCpp5qvZrvDM7mFAw6fOQqelp1aEuBe02w6+R2s19AjLOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724343979; c=relaxed/simple;
	bh=qj9ZIU8ryzdTxvvRkpC6wojsZb9qx7JD9R0+KOzJ8vQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=cEVETxkGgwMIGvffH42hvlsZ83T8aqJVKaNymO4W3RIllWGedwJFwL8c3WYV4vauO1gdr6s4f76iR2N9YGBcQsvQeeDQwENEOULZPQT5HHMGyDjpHVT1vo33DdeNORb1JvTYoVjAGw42LHwPIqqJ+7kFK5w3lwfZeQi5BOUvfk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=whUrTEz/; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="whUrTEz/"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4WqT8z21GHzlgVnK;
	Thu, 22 Aug 2024 16:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1724343966; x=1726935967; bh=uwXtexiiApM2ZjIZ0EAA4qeH
	2ZzD69Meamj7U3JQK4M=; b=whUrTEz/TdIbG4MdBaWpLU5gAbunSzFCMCfJv/9O
	2xar1uZal7U12S9iyYGkdvsS68UqZzrH3IO8l6lMVROy6yfSbNc8upHKAg0wHFsT
	4FlthHolO7c/xIpbI6SwxhpLtf1l4njhTRRyM/IFMcqbW+kTu9o1VUED3PU2gOFK
	KrUnOaar84gfWPyDEsHmpQvDfx1Bsg4m+BahqypEeWMirnn81XddiDpCp/5zzug2
	2J10OKRmSaGt8tlnnmuko3/4zaDsi7j4K2r5IoX4TZr6IM6CwMLvKYKzfPOUQEa1
	k6btRjOmMjwhSmH0H7mzH3pjvHlpd/KnLbAiyneRnEAiXA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id lwkJYkDn9dTQ; Thu, 22 Aug 2024 16:26:06 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2e14:8:2a97:b8c7:bd2d:fb28] (unknown [104.135.204.80])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4WqT8s1VcBzlgVnF;
	Thu, 22 Aug 2024 16:26:05 +0000 (UTC)
Message-ID: <2e7e0a2e-39e3-47d1-adc4-24b7e9761b5f@acm.org>
Date: Thu, 22 Aug 2024 09:26:04 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/2] scsi: ufs: introduce a callback to override OCS
 value
To: Bean Huo <huobean@gmail.com>, Kiwoong Kim <kwmad.kim@samsung.com>,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
 martin.petersen@oracle.com, beanhuo@micron.com, adrian.hunter@intel.com,
 h10.kim@samsung.com, hy50.seo@samsung.com, sh425.lee@samsung.com,
 kwangwon.min@samsung.com, junwoo80.lee@samsung.com, wkon.kim@samsung.com
References: <CGME20240822111247epcas2p2d3051255f42af05fd049b7247c395da4@epcas2p2.samsung.com>
 <cover.1724325280.git.kwmad.kim@samsung.com>
 <04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <04306da77d74e16edab1d682a8602f61b35025a3.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 8/22/24 8:42 AM, Bean Huo wrote:
> On Thu, 2024-08-22 at 20:15 +0900, Kiwoong Kim wrote:
>> Kiwoong Kim (2):
>>  =C2=A0 scsi: ufs: core: introduce override_cqe_ocs
>>  =C2=A0 scsi: ufs: ufs-exynos: implement override_cqe_ocs
>=20
>=20
> Hi Kiwoong Kim,
>=20
> I didn't see your patch email,just post your second patch here, and
> provide my comments:
>=20
>  =20
> +static enum utp_ocs exynos_ufs_override_cqe_ocs(enum utp_ocs ocs)
> +{
> +	if (ocs =3D=3D OCS_ABORTED)
> +		ocs =3D OCS_INVALID_COMMAND_STATUS;
> +	return ocs;
> +}
>=20
>=20
> I wonder if you have considered the case where the command is aborted
> by the host software or by the device itself?
>=20
> If you change OCS to OCS_INVALID_COMMAND_STATUS, there will report a
> DID_REQUEUE to SCSI.

The decision about what to do probably should depend on whether or not
the command has been nullified.

Thanks,

Bart.
