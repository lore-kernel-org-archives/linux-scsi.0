Received: from mout.web.de (mout.web.de [212.227.17.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07F362288F5;
	Thu,  6 Feb 2025 12:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738844233; cv=none; b=EnhGyJaI7LCr90V2H8NLaCR1Tes7eLwaQq4edMwycdV+/Qr6a5UYNbEYgLWXScKaMCwRJ90du9ac2ZfxfWYoai0UCXvprUkd3E9emZ7Un2HqtHZ7t2TS3nn0CU3RcTBZPvpNwKWhtMlgLuTxb3/9Xuvkgyb23xq/kbD3kjFae0Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738844233; c=relaxed/simple;
	bh=RF9i8fI99oiQlijX4zqgR1eMdrECioD43cBuNhfOr5Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=X0xk9eDXNj+9tIPMGVjmswf4fKtvWd4htr+nLsIfJpydzm4dGtOaZb6k6KTLzttBtSBMWwdbgTLpCIowMj0h56ptiTSIZ2d5VraBSCx09I+e4B8txSm1+NXhP8+4m4eCuXsmLeAidKU0ZSKV7zOPvPVj6YfS0dy2SGAS/BfMlXE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=wTksTYYk; arc=none smtp.client-ip=212.227.17.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="wTksTYYk"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738844188; x=1739448988; i=markus.elfring@web.de;
	bh=RF9i8fI99oiQlijX4zqgR1eMdrECioD43cBuNhfOr5Q=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=wTksTYYkvIsG2xujOtK3UcYMVA0VasAxK8DxVJVHOorSp0feNoScQlhEbwL0/3+3
	 3NwMnhgDJh02rFFRgDcjracDzoO+EWRID/NDO2lxGa72Mh8v2z0/GHRDPTyjzxAjp
	 MbGyiFAKcSgSya15mreSwvmkB1klUfou2/A+AmkeBIiP2pXeHGAPCCCOQXbbB0VPk
	 S55+T4BaKPyyf3CLuwfbU6hUBdrZWtw0C3457yZ58LfzYrnK6DJysV15iIzm04x0I
	 FO0f1RgB2FneAPCISPf5zpk8zPRSrBx67sDeHsmexGerD/Ud7oo9KHo94hzo7FIXe
	 QkC4WOTNH3wQJd3D8A==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.8]) by smtp.web.de (mrweb106
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1M8kAN-1tkhlV1FWT-00FjKr; Thu, 06
 Feb 2025 13:16:28 +0100
Message-ID: <c0bd1b97-bc6a-4842-baa3-98b1192fa2a3@web.de>
Date: Thu, 6 Feb 2025 13:16:26 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [v3?] scsi: qedf: Replace kmalloc_array() with kcalloc()
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-scsi@vger.kernel.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Javed Hasan <jhasan@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Saurav Kashyap <skashyap@marvell.com>, LKML <linux-kernel@vger.kernel.org>,
 Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bvanassche@acm.org>,
 Manish Rangankar <manish.rangankar@cavium.com>,
 Nilesh Javali <nilesh.javali@cavium.com>
References: <d5d13945-da84-4886-bdc7-9a3ac182b2be@web.de>
 <20250202213239.49065-1-jiashengjiangcool@gmail.com>
 <6221018a-873d-4fd5-bfaa-5c83d09ea2ac@web.de>
 <CANeGvZX5gcYj+Wjp+t=GLtOePHBjMNmVxiPsk2nruqsbiRaqVQ@mail.gmail.com>
 <444d6d33-d916-467b-aea8-25c61977713a@web.de>
 <CANeGvZWWFk4HjFGnzqW9aGc_FPFw_8xx_vizY48AYsP2T7q_WQ@mail.gmail.com>
 <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
 <CANeGvZWVJQdCDDboHN7RPm2aq+oBZYQ0CSWcPF5mVQxh2fb_CA@mail.gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <CANeGvZWVJQdCDDboHN7RPm2aq+oBZYQ0CSWcPF5mVQxh2fb_CA@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:pC4t54NqyGD8fqBiTRlHVHx6+SHr+bxotpIo7VPiO6QKCCmGpSP
 2Mpdub+cgUrG0kHrrAn5ru2kq5P2eKOWCenLtMjQpu8YNsKPHv4jHokPbtIioSXAgpXjydf
 GTpohXL1fZXbKCCvdyvvUQ7YNNtPrMw/VnPKac5X9hGhqefiqrCE83BwopHVxhr6BxdNFeS
 uci4SNWhcd/SWAotk7MlQ==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:ltxZIrZtu4Q=;RVZM4SPlL8iWJYk4VWw+0KZ15MZ
 DknNcum+pjghl4po9MbdFv0zD+yHT4migkoJ9n9Re4uU/GkrQNF1Lvtclqd8DnieefiuhVTdV
 PcijMgcv0jSCLzsdj97yB6H4BfR/RW6wRqHB005sqci7RTYgSiN8Os91HcN1aeXFzC8Et3BYX
 CR31N5SxwsGR6dxKDHWtI17QQE2DsVffPihBINqvcV5A0dtRmbCZBcXoz/73+mXSvHMFoY4b8
 TXPAs8mqBdkxo6NcPatUxZJiOp5AF8DBJDM+Vutz4NP2e5hYpP+9hl0IRleciDkQ97AN62IEb
 g/uHfcOwBCWp83AtTfGBidbre1hemriEwrTBKeiCUEjSzb+XnERe7+QpuyR9wBT4xXjkdEf5+
 nqycZnwe7AaL97hN44jn+Hn/kV9/tiLv4BRynk0dCQ7Mp+CVwXOhQujgrdsFxSQuPbqRwLi5n
 Xd7wOqL6u0KoUe+FH+GmImFCQVzTCpQrsbTZ5q/YV3uz3j51DY0VETy20/vvkMa0NrsnktCJ6
 j0vvT8GXQf6Ub+VulLM4tehDk5xcGv0KjX6hs/zVsC95NhPLQ4Krtnp0yxYGbo2nH4BLVNAhs
 Gqff+V2kSMj1DP2BY4zz0V67xCjNiIU2SJF5vssYBiq9TM5Rmy9gaIjcJQ8kMxEpViuvJhgiB
 pijiXXSrF2WqGAugJ0rJ2paoj3grxZUTTUFNjidk7lqEvKXwqGJvNfxOgHQLC1V2ZuDhZK+oN
 7+WCA6QDnIQj3u2LuW+iKX3TpKMcvvu6d2MgQLDWhWcce78gT4cvJ0ZMMybw5k0fbCdQkpIqk
 HfYLyx2hz74+RyTnBjKs66hgc1ZcWm4nActPG4Oy8Dr4ZBH2u+BYmEasD1EXJ34lij825X9dn
 FnB4PDjgk1CD6qk3erAJwzBIrlp3buOwKkddv3iFLD7kEBYeC99Op/MZoZWZNuJpuCyIXyYcf
 OS+SFjGE4uesSEAaTb0u4G3Uhw4e3vvIS/+enwUIejB6h79d65IaSwa2a518A/rHGOIBPAb7G
 ONgMCWs1oF64eXxXm82MvN2rkZgO74hR1z86rImrcv1u4OrMIRnP71XHN2DaHI1M56Hux0G/L
 f/XWBOA+9CDfUBQM1ZPP+muLKmUrWPj0kW8cU3PoVJdMJFFdE9m2esHOaI6lKGvnTldSGrq3I
 E6gKoV+8wj+7PexAbfnDEwviXardFcEiCz2t1iIMnbsZsFViQ75Al8Z15JOIlw+Y8CkAfK3+d
 pyu0X0DUhV/bMKLemg4ZsNCA2JAafNFirDJVf1L/MQ3nlCndPXZty6EoplrDuaIHlHi3i1pdX
 KmVcw1//zqDyw4aTwkUhFFsAgflqDYj9z3+ReLZ4fPLeAKlwhgynkXRpfp+mYfLEYP8H1mwIW
 BAWe/jjCrCH80vEeabk3YvF6QswMwu4TVrDVviAyiag56gMLWfk+e0GvnZlgNAb25cSt0cC9w
 jzv/tkw==

>> * Is there a need to increase version numbers?
>
> Okay, I will keep v2.
I hope that remaining communication difficulties will be resolved
in other directions.
Are you still looking for better guidance?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/researcher-guidelines.rst?h=3Dv6.13#n5

Regards,
Markus
