Received: from mout.web.de (mout.web.de [212.227.15.3])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D66C720FA96;
	Wed, 12 Feb 2025 14:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=212.227.15.3
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739370268; cv=none; b=S6psJb8lplJ1jomU3qs38Oh6wDtuyiJ5+wLUu69Di4Aq+o0oI0XBhGkbglJLTabBApbnH0u2CDKUMYHcoahb/lE34NoM9h7fCoKtVOozCsQLVV0KRF8yuTkSZlCyFqLcZhxbrPUeI4pjqu3UHhvnReSOA9zv/U/TZPnK9v4ZamQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739370268; c=relaxed/simple;
	bh=vEXjeWfHt/GnjwPBKS9nSHww3TcZql79tqxxT7vOdlI=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=mjJEXPrQpPHSW7OiFX0C2/uqUEpaBbli9Mt9YOsxRYyFmQ3oaLoknIT6kMPEFTU4aGUCskuRHbJfEkbnj3PQJehLEM5KTM25WKAp04YA4dXEcAKlK6HTwIPDikcvZK1GqjAEcsoVep0xlw6YQmgs7UXMtjdEvsl7Ih3mN3ZiG+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de; spf=pass smtp.mailfrom=web.de; dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b=rh37m2c7; arc=none smtp.client-ip=212.227.15.3
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=web.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=web.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=web.de header.i=markus.elfring@web.de header.b="rh37m2c7"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=web.de;
	s=s29768273; t=1739370258; x=1739975058; i=markus.elfring@web.de;
	bh=vEXjeWfHt/GnjwPBKS9nSHww3TcZql79tqxxT7vOdlI=;
	h=X-UI-Sender-Class:Message-ID:Date:MIME-Version:To:Cc:References:
	 Subject:From:In-Reply-To:Content-Type:Content-Transfer-Encoding:
	 cc:content-transfer-encoding:content-type:date:from:message-id:
	 mime-version:reply-to:subject:to;
	b=rh37m2c7NxOjQJViUuhWpXDfpvC+pVFFu1iGko/x4MlPK0ooBBMDF1B+oZJ4sW08
	 CBXUp+pLv1DiaHWWLn9Tm+EUR/WdU1RuK8TzKNAmiHIOse+66AJx5Ev5mqPWEEs4R
	 t14XBRBbc2X6+Jle4XCYbIvG8XphauRNXoJZVS7hz3ASG2eWTNgt0kbf2hKrk7MFa
	 +mDnBadP+aobBcujbF14LTgSIvHxRNiBX/8hd/lRug09Fb3qfT1WVNvwukWa7fIZ/
	 L8gxdibR3Fs3a3rLtZQsFtZ7wpACSCgpmwcNPOLOytN5TArLRJO73sar6kvHyua46
	 xQZ7t11BmD8ApLhbUA==
X-UI-Sender-Class: 814a7b36-bfc1-4dae-8640-3722d8ec6cd6
Received: from [192.168.178.29] ([94.31.93.11]) by smtp.web.de (mrweb005
 [213.165.67.108]) with ESMTPSA (Nemesis) id 1MTfon-1to0yt2den-00XvFD; Wed, 12
 Feb 2025 15:24:18 +0100
Message-ID: <ac6c3389-6f97-4aad-a6cd-f4e1322e608e@web.de>
Date: Wed, 12 Feb 2025 15:24:15 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: vulab@iscas.ac.cn, GR-QLogic-Storage-Upstream@marvell.com,
 linux-scsi@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>,
 James Bottomley <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Manish Rangankar <mrangankar@marvell.com>,
 Nilesh Javali <njavali@marvell.com>
References: <20250211133844.855-1-vulab@iscas.ac.cn>
Subject: Re: [PATCH] scsi: qla4xxx: Add missing is_qla4022 check in device
 initialization
Content-Language: en-GB
From: Markus Elfring <Markus.Elfring@web.de>
In-Reply-To: <20250211133844.855-1-vulab@iscas.ac.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:O+hwUP0Y0HqQecPzNMnGXtnyW6PNtcwUlwae++ErRIwMYbct3x0
 glJ0kvJc3sc3duLGCtnG75+FpFXYdQLsIlotFeoIq01f6jL6PejD9e3l/9dCF44Th+ynGiU
 rfKdkeGXthKYaNrLpKZqrtxlX3oqynjuy3xPujm3vnMmYhsi8lBszp6sywEkn4Vcebd2Lq2
 YcjgqUgNX8/bVJS0dHQXw==
X-Spam-Flag: NO
UI-OutboundReport: notjunk:1;M01:P0:3qdrEtRS+sY=;ZXQIFP669awB8d0+ydqtL6qFS6K
 Wl6sU+1SDAuREF9OUlca0meF8a8e17QwamgGCmEZwU2eOYcTMueWKD+T1cE/W1BL5jS4swblY
 a2TJvNLz/tj93Wid8xB2A3E6/JtuVWfT331TH2DnSSGg/4lglLa1WDTjj+PFAm3HzTJB2h+P2
 wAHSMHbPgmxmIRXM9FjorgtzjMqVN8Ek7N0gIDz8JYzqiCH+4zPY/r9oh3sWWg3rwwo1sV/Kt
 LU8HXPxo7MeH4m88mkQT9uH/b04BatACKU2Zksm3SwCaxI2IASAP2ZOXV8HnVGasTFZIDPO+e
 +x5aXYc0ZI9Iz/8tMp83TQFJ4fhq0NMNVyl1mEV8bsIjQNfy4ixrpa2ibpirPO/GuQmw3Es4R
 vqifdor8pHN4dqokQ1/3cCZGV+Zk61gBJihDFGKs7dLU7s5iZEYBlqSrxBM4LBQEAhq4404mK
 90+m0aOeLWLBA+/xC8lyOlveKLZUQlJaVfDnnhzax50utICxjUj4Aa2S6i2L4Co++/PAmjaxD
 pBcxkPev9Da5/8A2BUP/HliWT1sjIDGEeHEAI1ThzDm3z0gT7hSxAxOiTD2ndA4heqv8Pe9hw
 CXzRwiP8zr6XSGaoHFldJ8P4g80/iWARzzBnU8kGfnv4sZcJOLC6s+4TqKyDOO81j692u1CEU
 yC68Q8XBvuR/Kf1Nq9J9FJShIIh/dfAY/SMCYtU2jK6C/T1k0vaK8RdS6krCAqXsFmemy8pkT
 OkLyTVofPATyeHJLXbZeUvgsWff/DhTO5893tRf9lvr09LIojfuFvuq1ExbHW8p+1Ez08w3Hw
 O39RIvfa6eelRwsq6GK0ng223SzKoSeqNdKIX/aR4DrOVhfu/Qggy1qCuNMGol3vViDtxKObA
 WEav8rf9RHsmV9O9J2OKwSRVgmcPF6f5DxXB2fzqjKSiiZn1i+6ndRZhU0FYvfGagU8pzrNlN
 KjPcxM0hDwvLTj3ZBaVTBVBLq8NIrmjnZhmMD0zpLMllduZA1EJoSdva70Mb1WpA9ywcyvzcJ
 wJ7xH8jYM9FJua+99X0o2Bt7Q0Izq6hj4noU3j8lUC5J/Q0B330spmJgU80XQ9PMncMOm8bNT
 RsD7wunQRS2hR8acuYhtFmUHZo6Ifxrt1afX34h2amLtSMn1Z0PpFxQvlhAZQlouXDSK0tbYv
 eokYkGHwsU0PhAitJwMygFNN9dTN7DmYjBDDquxiMnDHtP/0ie0t/JO5pk3LGKCXzaj7T46bB
 iTFgPhwON4anXh/k2a1dC8jyk8YDsjaUZIIY6c1qtXjIACmAy/AD2g/Zo/D44HpOnpkcet93N
 h1UdXorNoHKKm1PqVGwypzrYa31gdDweOzjkUPyv87FSXrWEii2qBYQwnnaNILuSXlXPHdrz3
 S4axwoSyBQWK0zBrnK1mHlHmMrY3uKoTIi770Pd0t22QCHbbgL2GP0WiABFV36B90oIb/+JoV
 8FkGgmm2CV7vf4pV49T9wErwgFMY=

=E2=80=A6
> This patch adds the missing =E2=80=A6

See also:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Do=
cumentation/process/submitting-patches.rst?h=3Dv6.14-rc2#n94


Would you like to append parentheses to any function names?

Regards,
Markus
