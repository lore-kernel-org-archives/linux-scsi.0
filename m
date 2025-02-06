Received: from mout.web.de (mout.web.de [212.227.17.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B54272147E4;
	Thu,  6 Feb 2025 11:56:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.17.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738843016; cv=none; b=Y/IqwSoW8l5hnp6TnerJyA6BnJ54Y3GcU9rGPu102WoA94a6qRquHIneJJn3dJLjHavI+5h9Zi4wsu+ncccUNx413o+JSHdBWxyDAu6JJOV06f0nYs8jmPF+vs5Uy54iqxz0PAJqd65RSTzpVF/UhoxwuQ1HLmP6GXFiL6vNWkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738843016; c=relaxed/simple;
	bh=BGlSKccPxT719mAxhpjdkqxTeGBrueKExZ0KoLZdAGc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=WM1KFlNwlyysr+h6Ul3TYq83LIsSpDS3wi6OrQFzZgiE2kkLWH4uPWP94HOKBoT+E7o71NW7oBtU3Yr3Qp68cO7Kx9qDQBW7CsoaiDGXUR2/OereaAIeJrMZ3D1k/x81kK+MCs1Zc5e7HKhBqGI5NcQW+t74q3kNdcWZrxWdYQ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=i2lxC9Lm; arc=none smtp.client-ip=212.227.17.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="i2lxC9Lm"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1738842992; x=1739447792; i=markus.elfring@web.de;
	bh=BGlSKccPxT719mAxhpjdkqxTeGBrueKExZ0KoLZdAGc=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:Subject:To:Cc:
	 References:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding:cc:content-transfer-encoding:
	 content-type:date:from:message-id:mime-version:reply-to:subject:
	 to;
	b=i2lxC9LmWK9qCs/uRjf+qVWijHsndt/bTsrl/aEmDLSRswuk1P3uLCIx/sz0eJOW
	 3ynfS0G2viQiRFxsSnxSiKX5jDrnOBXVIaCjWs4YLjMHcB7AfyEuSBZCyH44owjxV
	 5hzDJgl8vIhEF7xqxJ2VtE+e3JoujqGFHwz2M30g4nMoS9XsgztoDhow7h2v7ITXn
	 mGaWGN8pNIZqxKefc+dhgLzaRdOaIkHyHBezYVEXwEcYVzALBomixa2zN+GEA3sMv
	 yAx2pLtJeUwQkfq0U3DXC400IPYDpKqFWMw6+GRy1CIdg4GpB7trKot2ReFn9dIgM
	 zUvk3RX4afo0iHCBPg==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.8]) by smtp.web.de (mrweb105
 [213.165.67.124]) with ESMTPSA (Nemesis) id 1MSqTE-1tqV8235A6-00L2ey; Thu, 06
 Feb 2025 12:56:32 +0100
Message-ID: <87b286ce-9670-4f9a-b217-9ef88ce2c0c6@web.de>
Date: Thu, 6 Feb 2025 12:56:30 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v5? 0/2] scsi: qedf: Replace alloction API and add null
 check
To: Jiasheng Jiang <jiashengjiangcool@gmail.com>, linux-scsi@vger.kernel.org
Cc: GR-QLogic-Storage-Upstream@marvell.com,
 James Bottomley <James.Bottomley@hansenpartnership.com>,
 Javed Hasan <jhasan@marvell.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Saurav Kashyap <skashyap@marvell.com>, LKML <linux-kernel@vger.kernel.org>,
 Arun Easi <arun.easi@cavium.com>, Bart Van Assche <bvanassche@acm.org>,
 Manish Rangankar <manish.rangankar@cavium.com>,
 Nilesh Javali <nilesh.javali@cavium.com>
References: <d4db5506-6ace-4585-972e-6b7a6fc882a4@web.de>
 <20250206052523.16683-1-jiashengjiangcool@gmail.com>
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250206052523.16683-1-jiashengjiangcool@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Qk65B3tsrovWufTT+JARSlXzJseoazrbq8xomazLgo1dFUPLBpC
 OtaNs42aB1SF88VjHrUnyf1O3kWQShhk6P18pE1dre4vycYp6qC4m8WmrUY30Ncivbl86G3
 Y4b2uICzrt8wy8Z9cvJKitOiL2PgOy6Ghtx4G7OjjhYT8rePGTLuv3BlLF9Nc2ECJ5PWV1E
 M+r/HKqC1gYZrmMheIldw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:V+h2keBVzZ4=;WDvBN5WcodaWPLh2co26vBSvkEH
 czRZHRw6ao7pDGza2OMEULH4a1ofk7jZ61RyZXgLl/sZTtpKRJCu6Pc+Ys/OJ/3rVYhe8IE6J
 Pmf+jjdcc+bZDsHP/88u+n008B2MAH9E+TBNToXx0Ic4Xsm0gpzx17Yza9Zyk+mpJRSNS5/R8
 VAHKLIdQ8i+u/vmKmwrnra0srsa3OVKQJxenaPTKe7Sg+qIU6zdu42zelEXO1O2DpSMHL3buS
 9ifayqoDpVinsZ7p//xpAwfCoGwtuyv/VEj/eLSc49AD3BXg+VD8og4bh3xGOli8OXrykaje3
 qMW9gJrID5KYHW0razF51zT7kKHDWRH0Sw694E2VmE2aikq9OR2Bf5ZDcqkwQDg30F3y0bkiG
 o+AiCEt96XDIEXFOc/3Lrt9NRV4UcdFyi2SnWyjMgm26f499Ij7zTfEEPcgrMAmbc+h808xXR
 VntfXvcbmVYPou7tOmr2qsX3HRNK2qiAHilzs/MGbkQyD4Hqyi4ty2oV1zch2foaMytG22tbo
 j23q7tmqB05FhvI+ps+FLZdTbSl7wxlJ5Ap1YhHnGuX0URmXqe4a6zTGMoT800+czC0bNX+ZC
 jz7PMgh6sFZ62v4mQ51zZj+8TF9wZtW//2H7/E+C222MHlaEPBm+jO6rl75htBcy9NxoJaDqQ
 /ZqbH/AtV02KvuaMUmoNdjpdRBm5/EYAtcMaN5IemNqCGS2zfgqHvmXy+/eH1Gu83n0pyrCR4
 CU8GZEdsgOCBnDud3fsbeBOd3qKWdz8D8POtvXxQwFFVYjOe/0XkjBQO53HDnGdNuR8iowh3z
 LOCSaMEzvx5KEVqt4QnPr7AItebf3mbAkD7StOkGnDSL2rz34pdAvZwKUALVprhNfdeGkeINl
 HIL5JCt1D1XO5xd92UDGATILEA7Ac9gp5z91X4J2xVS3w1nVHphqcsJ/6CUNmfh++gOMLYxC3
 zfokR4AIcUPvMYbWgDQqXQgyBiMfDptIBui4JHZQUDN8fN8TbhWMMJekChNzEiffFgcbJdxFT
 3ZVXfBToGG7AH4C1OwnlMzpL+/jOKV2YHdGiCuRVYOuLrRxZZr0hAB849JxyYYiM1iGgg2YPW
 IZwVT1QsBEPuZaiw/tE6gGKzj4U+uzNsvhHq5tt8v3IJFzPgoxMQ5XgRy4N03TB+/hrHTcz+M
 0kSctZCqjlyl752mh5jeINEEHxtFKFze3IkKKCWzRJn3m0Hfx9LfgaBDYL4w2HLuX9cb2nCKM
 shjGzioAmL2TE5/bbOVjGJmvd81IGuudp8nt8I3Zf+37aOz4ZbQFr/7hBLHzoAvbbKw8wVWp+
 bHOd0EngXGWQWRV2JAcPIBD5RGN5jw1oshW7D6dEerIFB4FWQ34KS0On5vSDhmR3kkicyOEgJ
 h0d89wUPAGzDdW9HJgRnFK422hG2FfrSq5Mk1I8TcbTWNsWSIVaW7G/f3BxfjfC8KGhUEkWMS
 2mm/ZuA==

=E2=80=A6
> ### Changelog:
> #### v2:
=E2=80=A6

Why did you overlook to increment version numbers once more?
https://lore.kernel.org/all/?q=3D%22This+looks+like+a+new+version+of+a+pre=
viously+submitted+patch%22
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.13#n605

Regards,
Markus

