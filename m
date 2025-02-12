Received: from mout.web.de (mout.web.de [212.227.15.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCD4E20F092;
	Wed, 12 Feb 2025 14:36:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739370967; cv=none; b=N0MhFw3l5PPGBSfIhsYE7Kaz92tG5X9/ArcDgySlanyK4MPTZsnI+dkazzyYXsy8jSOK14Znl0sXlRZVX9yZqZlthZ4PPc8Da/Mju5IbnNAxF95vRtEW5vVdJjHQqI3SzFuhpC7yn1hiKFU0aqGhorTx07oZzuGd2g1T2uYMPik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739370967; c=relaxed/simple;
	bh=zPPPVDyPCQy/uHZXmtEqFziYEoLwnzvm/k6HokPTs8Y=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=DRfs0NotBgBsAcN3A9mgPQTQLQfoCgP0Th5DNSH/vvQKQICPqzUPFVambgak/SPtcwWhXKVXSxqgVSct3ch18UDuK6S/GgVcK3RXJIg7NG85W503dQtBn2k64cAwYysxZmdJGK0JxaozpCT3I4p37FIQsgGBY13MqOkEnuQXs1k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=Gwd2nf4u; arc=none smtp.client-ip=212.227.15.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="Gwd2nf4u"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739370961; x=1739975761; i=markus.elfring@web.de;
	bh=zPPPVDyPCQy/uHZXmtEqFziYEoLwnzvm/k6HokPTs8Y=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=Gwd2nf4uGpWFVYwPZNR2f54bp1dAOn0+gxOxCHU7GjKNe73p5DqK/u+qOIJFSA/j
	 Uzl88cNZs1VGusZwAm5+303BXXSIyCZmK+Ibr14+NOLl4/f5HAWxiUIiEb4E3SaP2
	 IEGfjfuTJ3Z8E0SC2/bfl59gn5//befGz+SGv1Zthp1pVPHzgHeW8Jz1bj35A+8oa
	 kKdpsqyZviIe31icfEGUuPN+86YCJOqLNkW4hcDcghnuDNKe7yz8A3I828kAfAndy
	 B37ScyxLl7nxtU3dmv8NEnCbs776L/t8va/BY7nBydK1ToAeQTuGv2TOXOmGYYtA7
	 UHkd+PtqF9Qm59vSnQ==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.11]) by smtp.web.de (mrweb006
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MXGOI-1tshgt3Oc2-00MRfd; Wed, 12
 Feb 2025 15:36:01 +0100
Message-ID: <2a06847c-9060-47eb-aea7-901dd7816b59@web.de>
Date: Wed, 12 Feb 2025 15:36:00 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: vulab@iscas.ac.cn, linux-scsi@vger.kernel.org
Cc: storagedev@microchip.com, LKML <linux-kernel@vger.kernel.org>,
 Don Brace <don.brace@microchip.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250211123309.723-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH] scsi: hpsa: Fix missing error check for
 hpsa_scsi_do_simple_cmd_with_retry()
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250211123309.723-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:gJkvfD+tYzgcuzwiWb0TURFprS2qG6NCDBPpTgb9miQD8bUENO+
 O8aHneFQcCbRiCUUFAiz1/zXImbBoYrZyUY8xiiVsxF4hRjSWX9Bh6uQVJugNLC8mZfo4xV
 vJEPRyhLNQKEosVUZ19XT9IBz2XqGRjRCO6wFlaFTeSL6bkGZ9PjHN6KhPhm6EN8Sjbh2ok
 Mut2BGWFYJTXTXoA8n6jw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:lxIAYONmDI0=;995tViGduZo0xDg0+3ofsL3+EzH
 hkUVtPR4g8z7cSCk/pqUmgwrGYzMaeyg4t/rzLhFQNUks99yxI9CPS+L+Fo+Hj+Fn89RLR6FP
 3h0ntFdJS6aaANx6HBQI52Je+q9aS26nQmV3AsWkbILdRDjjPCVtlvMTFBeWNP95+d7Oac1Xd
 txxG/q/SFfIfov6TNTPVjF2gWaeFzLi+ZXGPrgEGNfEhtM6sWZRaVbel8D1UamHrkd5dJLlBb
 eOFB+Llv92X2sjD4fufTFvSIFdB24o63usstiic6kXhURRqUXrxwKlbOLo26iAmOtosE+6j59
 la7QF6g/LzTcAE6/5kQhKsMFrxu4oXNVy8guUMBuTlXjwXgaeb7dbwmYncF0KVFFcvtSMncXd
 Y/6bIHQuW/jGlGqyE6pWuCeio9jota5fe+G6zqze332KPmCQTGpnEhRdzB+H0p/zNCAc3eP25
 hhDtPgOMjGn+gLQ+49sp2rdVZpj7c6xvIuzwSYyxBDRCg2kToJSfVB+VAvBi9NK+2xtJ8jEWe
 O8oUQLhnL6nQykRsU8/VWHPBtugMWCHjGmq9uvFcig+ydUlVxFYYnw7xCdgZWG8IMBFm94M/b
 V4nSHCTWv1nu1WXEme8P/hMffAvvHNi+SKLxCCuj2mAA6ypkCKcghN7Cmg8p+QT5J9ORPcanj
 j9+G03rYl483zXpWfqVFD+/aY89yiKu7KBDcOVkApZ9q8wuKwaWquwimndjIUSJtX/DrBV4lQ
 v58lzBWQHltSmxnigjPUlpTPAJXhlaia71o7/JZiVcdBOJ55bSvwFR6MBtxalZPuKFabzh97a
 RcJPTMcm9ba68jTFRfv0vMrE48LEu6eP6sVAgT7mGo/mop6v0xvIJpETeJ39uv12wv/+8Tugu
 8nIstoml2Y06ZEfI90AKVgA6tbs0C7MEqo2rpUhqyWge2+H3ainibYEE16SVg+ehNyFUOEhRM
 MWpzi+DHSCIYCKyAqnaasrjPWLhPHGphN652n/zHayAKPvnD/lZGaUVXhPSrt2FTlCQsa8+Bb
 Ea1B9kixhnYiNb+Q5eN9stCzPONq38Fua6a3T3gfYsBIFRXtroEBCvBAYi6C9ZKWieLXE4Hj0
 7uDhhm7lMx3o6d/CKF6Q7UXBDuYlvqP2z6+JsyMTJZ0rE4uptTaxIYzYLrH052Cu2gMeGTh0c
 5n8fmzwllsMvt7NlVp0Pg7PGLNDhYCJd22RUokJPvRXC/Jy4VeGeuVgsrFQiMbcAT+RTmluNN
 dfrhDhSnH/ApOS6H6h0Wo1A3nQ1IcRWTWsuX7BLRdXPnUqxeWyda5giL5PYct0eXGSZxdCuFu
 Yac4pd+KoFFF4S+kR2GbwMxZeduQwqp+4poB70vANImBKThWxU3seChqbd3mDC8EO5KooFRoc
 /ci/k31nAgn/LwVMdMO2vb95+JX4Qrshwda7v1Q+C3SBSzWcDA9J87UBz3RThb2x7vtL0JMeJ
 +ab2Cb5bziTWgxm5KV9r+ttFcxIE=

=E2=80=A6
> This patch adds a check for the return value =E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.14-rc2#n94


How do you think about to add any tags (like =E2=80=9CFixes=E2=80=9D and =
=E2=80=9CCc=E2=80=9D) accordingly?
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.14-rc2#n145

Regards,
Markus
