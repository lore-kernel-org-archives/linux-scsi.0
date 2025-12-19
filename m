Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B40737D54B
	for <linux-scsi@vger.kernel.org>; Fri, 19 Dec 2025 18:18:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766168319; cv=none; b=TOtV+SmN10SRkYgW0bJmEuKtD0vfhU95xTwrsiCjXSUCbKhdLx4fNh23UXQHg9VL/dn2nKlwguJMfY49bAXbOS09IyMFgpAOgQ14OaW30i/7N6XeKbqVeOK+VweRgFGmqPislmnJwjPeymltFA51S7jX4PydzV0ndy3Ft0DsAEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766168319; c=relaxed/simple;
	bh=dDobMecDScXTuOD5vo1jJ7Nt2z8xkDy2R58sRX3h3Z4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=PU6uNXsDTXyAbq2CBMDdMWpljrxedYdTfpA/8Ab64rXY5SdNAP8BILXXsalbffZECQGJwsmE3G3tJcLLk+2W7HEUcWDbw0Rm4Mf0bSKzyPUC7WzyGn0sBKGs210He9YVNomlnK1Q0CCjkyJydKv7LDjw7vQ9pJe5dHLfBvvu4nM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=WcPiwhcM; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="WcPiwhcM"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4dXwlJ4rLTzlwmGv;
	Fri, 19 Dec 2025 18:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1766168313; x=1768760314; bh=6YaQsv0P6TIlgHLkXT7+RR7C
	iuRLzcUpctEvPAChUrU=; b=WcPiwhcMktItuTDX1xP5CHdeKoQ3q3USFL4H49Z2
	L2VM9oOm3EA+Dh6QJEnlJXnMrHQgr4uzApGsXMNO7a9rwr2HY9vpQp1wqSFZupll
	B48eenX94F/KvfKxzZNOl1XuBzjEngIJ+AWjCc3lpFAyflWMmpYYB4DsqvAlfUac
	9LrhFVMVmNz+/jWmmYwXNjXL0zp/TmKMOz44KbDQwJ++EayxKGxjRXc9wW6BK2i3
	Q2qHZrP1Hf/WrkIrh3SvT5mG/gwRTcQ6tAgQUED6B633sTOlgrUAqVUumSR+7Q4U
	t5f0KvE4E/A46OA0xL7Na+C24uzHpiSaTd5ne6Z7ZW/SGA==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jpw9X9Xft50J; Fri, 19 Dec 2025 18:18:33 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4dXwlB3qcczlwmGq;
	Fri, 19 Dec 2025 18:18:29 +0000 (UTC)
Message-ID: <e49c1ea8-bc13-4881-bc6b-2e1a08b1184f@acm.org>
Date: Fri, 19 Dec 2025 10:18:29 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 2/8] scsi: Make use of bus callbacks
To: =?UTF-8?Q?Uwe_Kleine-K=C3=B6nig?= <u.kleine-koenig@baylibre.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 =?UTF-8?Q?Kai_M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>, Matthias Brugger
 <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 linux-arm-kernel@lists.infradead.org, linux-mediatek@lists.infradead.org
References: <cover.1766133330.git.u.kleine-koenig@baylibre.com>
 <a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <a54e363a3fd2054fb924afd7df44bca7f444b5f1.1766133330.git.u.kleine-koenig@baylibre.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: quoted-printable

On 12/19/25 1:25 AM, Uwe Kleine-K=C3=B6nig wrote:
> +static int scsi_bus_probe(struct device *dev)
> +{
> +	struct scsi_device *sdp =3D to_scsi_device(dev);
> +	struct scsi_driver *drv =3D to_scsi_driver(dev->driver);
> +
> +	if (drv->probe)
> +		return drv->probe(sdp);
> +	else
> +		return 0;
> +}

If this series has to be reposted, please leave out the "else" statement
from the above function. It is uncommon in Linux kernel code to have an
"else" statement after a "return" statement.

Thanks,

Bart.
