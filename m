Received: from sonic302-19.consmr.mail.sg3.yahoo.com (sonic302-19.consmr.mail.sg3.yahoo.com [106.10.242.139])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E95B179DD
	for <linux-scsi@vger.kernel.org>; Mon,  1 Apr 2024 05:31:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=106.10.242.139
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711949493; cv=none; b=c6rsoNMLZDrk3RdLZ5FRT72Lq8xTc0sUgTzwp0KrqElkkxv0pXxHrZ5Z9QwHUScBMtZLWAnKWYLYasK2AjM7h87lf/D8J7KtjOnd9I8jJThZozhDkwG8cKFGXrVnyh5TuJlZDEbQG1B92gmN5YD7grQLN4kQCTscMrHYbiYoaz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711949493; c=relaxed/simple;
	bh=FCAEwwjfuUoCUisf0ocwdAnZ9hbLlLp5UAmgLLuHts8=;
	h=Date:From:To:Cc:Message-ID:In-Reply-To:References:Subject:
	 MIME-Version:Content-Type; b=hOGSoCTJ+OhIyemvqjjgS/H1en+jWR3xQe4PkM+foU0it2AjjJoxNi4ze5LZ9jwfmFyyNQ7EQhUDhC9F2GIGefQGTCpR7li3aGaYzXjQacaB9c2RfI8YgwqOxXVLMePMHBfNxGuPVd4KeJkfDMRtHJxeN9Lcoawxvh/PtBLsqFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org; spf=fail smtp.mailfrom=fedoraproject.org; dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b=BaQMB0Qr; arc=none smtp.client-ip=106.10.242.139
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=fedoraproject.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=yahoo.com header.i=@yahoo.com header.b="BaQMB0Qr"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1711949488; bh=FCAEwwjfuUoCUisf0ocwdAnZ9hbLlLp5UAmgLLuHts8=; h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From:Subject:Reply-To; b=BaQMB0QrEx9B8LbzVenwG9zSm0XzYEvCkMs+PAUB/L011k8IRutPk0XZT6LX8JJ25cRsbL2u7wwmZEm/t8fyJg5jF4avhWM0veguBRzHglPg4yVUHFo//S0RP87cu7vlR4KytU1T0ktxlDYZTOSI8Xtyu7WdEfqCIgjF8q1aPMR/W2bW+GA2WW7RY/0SOfuZF7j2XvRvStl/YaFgAv3s7nlmdEM12dzwvHkJzObnIpxy1h2NbbMwSjnE/8laySR/hKOW8TQ0H/vrrcqSAZr5SkPMbZPdGMaYQ6GPzYaVNaVdlolnFxeqJuP2L2I1PtloXQ6C/5yHQcTRbdvMn4LDwQ==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1711949488; bh=yoFIhDk3O9T1/xABq4rponAF6L02uQPuCgOcxvBCSv3=; h=X-Sonic-MF:Date:From:To:Subject:From:Subject; b=VnSJJfPpnOjN8SL1Ygq1/LeIAGCQ+nOPA7x+ly4/3ePRq0jPgZFdVC1/SSfvPQTERLUhGuNRwmZSCgJ+jDWUigLE7E2TuYRSY2pH1HP9Xwd5m8j7/CjpNVe//jJilNcf9uqtf9Unm2o2EcGAXc3AoqV4cDhmmXfpWYqwIrhXibmvtKsBRs1TE7samDSCmYLrYhNg0HnZwxQ7Bzi48lCsOSDqSzHphyvtOxc5Scmla0T3fgeEHm7S6AGKJng7sWHQRcXeyLWYsGeDA/4zv7mtkNGjm2Wu2sOvPlHVEIxAZ0pjsLCCKtsj8j3uq7USjyMiHO2zeewuHuKukUPTdXiP7w==
X-YMail-OSG: Icv1eUYVM1nuZSQ9EyNJNAZecHTRmHMAh5f5vEjOuxsUTlIlmdVZKD.U9HNYLQr
 vIVydPYZ_gt3YOrJh33lt57Q.zbdMx1jsLN0wPHRMsxuSj.3tp9JGiCfAuAae6MNfNfoLWYSTjhP
 XowgeLBYbdCDM2hyee3ybXP29sJtlkDCs0lRneqk7YDDcM8h1eXEC2BDrzUVyunaqmyd3AjjrtVN
 2_DYh_Sm2eVHC5LFqlR9a9r_mlEBv2IYCBkf1IScRO.U0niO1uc4DBvdrHpfLUvaIsYwHGHkFR8h
 YznZ4Yr0nEdtuDc4iIquK85lRtRkMaiCTRHVaC3g44iMGVXSyyA62X31S3UvSIPFpAS9hXXgxJhR
 cDSrAJyOcnuZxWULP5I_9Ymy1xgV1ylN0wwnRfVPhenddVBQc0tAd2BNMFfJWUaES.iiE783VWy0
 z99i0LWNRs.NqMm75oelUXfNUgVVfaWNgJlvBDmNii3bOKS6PhDRh7XepLOkDObUQCdII8sTqFTZ
 4uPMSliHWnFjKtdPDHRdnsi_VwyTJpUkuWKZNaKUDYMGYT5Cn._hg3cBcQXez5qsZ.OUcUQUfCNI
 jxHcPxW8kY87.TurwTQqOfJqnGlvdgOTznUhDEotPcPTXhKArUHwM5leglP0aQz.QpvjK1Iyeslw
 toXnQdNY5S1SPKeLaO3E2OYUVrm6j3Tms.FHhsRUUO.pW5Eap44hD4KbytTU4W3sDt_ixRVqhgI2
 5PBMSnuOkIDLPJFv1gzlRchGorn1DrG9IW6AajPneDY.znoMeXKFLXf3kaFTqyAGgEjE_ycMZi1y
 67M2l3XKy.QGM8iRnnMUNk5_jEpOYuVf8CUwNCCvy7Nep1d3oQMovRVhlOjB4k6lQg6VXjgoDLdp
 Vbb086d2T89Cl9.EMKopVl4enQ6S5CyuNk_4PuEiStbTMIB36rkfXKko9LBFNqi.2WqGCjiHZI6b
 BZFfOxKbMe_WprGowxhAHhrP_RYLGBWmlYxJ0y.nYYijGCnfEKwxmDUum4jYk2t0Yw9HHi0SVJal
 UoRVkDNKmXRxIMUO64Q8E.TQhfM4mVpDjNQ28Y4_MCFx0D7A7zjdfCeNes0N.6d15wiKpybFTBd_
 f10CG7lck464Qq6k5_FjxyXk4LpX.7uMQ0g562LNUWe6FaFeQb5a6dy2iEw4FbAgOoASTUBZB8V6
 2YNKQHYJ5G42vWKe00IL9aDYsd47WBA.yWeoMkME23gZicogm0yEwoa.vgNcuHEUiDSerEwGszi9
 CguZyP_WKwvhO5L1PUzJ6NDyvw_d.euvgKlEqqA_p27yDOfJ5X2EVYWYnzcdZuMKDz7QY4smqlgm
 ypT7bfcnc1lpvstQxREJvvzMeV7c0GoEqmIZSPaACf5rj_V2.SYK.HBdOQ0AeVQY1T76keW4zOGS
 W5Sgv7ehr2zx8U.f50fiW.tojlglpbuY2POPN1Ru9qhXfWEpr1G5Sad1GwgKF9Gpuw6_Q2h9UCfX
 ufhU6hFSxq5arNzTK6zbJ_aUvSvWzotW2ucapQXyYqzoG_Pzt0UlX5z47XzWWI73Z_2J_1ydqtEt
 HHVMdysN6FlMeWzgSMJJI_7zDhiu0KQpI5E6Qlk.7IXzHWaEKRpYZqhir5M5ZIQPL..AUpNIpQQA
 hnJ4jLISN4EhXzAMI84O3rXlwx.FX8NrcjJJa7.Jb0tj.M7ANNbhjOcGsu6JTPnRRZJGnc5n4kz0
 EZ10sE.LCwb9lwYrwz7njNaMI5i4Yc59TcW_H6Cf0MaIFbH_oZL_OefgtTWRmQHFH8Bb1HT3FYLE
 Y3HLFqR_DzZjkL28Z9NGjRXhzVcZOPBnT99IYOFGd19HCeVS6q6Yf5l0EXa1zzF.xBzO_y3P0yMw
 ug5Gj_RPWVPawyA1TkuNkfRTr5v8Nn.IGtALr0FtQG_kS1hAfMl_C0SVYpQg7zaYvDuxAkDw9..g
 i2KwJZYmVvHEnl0nHOO7psHjJOa3mxjyAURxdhqtlKr2_l2dzP1RWlgFrs_pND7R1MGAY5yyOk4z
 _.DE46zTVKxoIaYsuwck4fE.WWmw8OVKbV0MoJGMmhEDnhoUMp2tfXV6ovEoeKwMRETocAX2Wd2Z
 Qn7myY49B84Zo67Uf.WkVhAp5LGUQIgBsHVYDo5KpHO6jPTqNbXijzWtblcHmVQ5nm_zjSyZzaRc
 d3ydUVIifnJ_nw3fXeF2stslK6vCjiyXIKpTwdoBj.PokY8pYs3f9UVScqLQ00fKlBQkANptE7LL
 LWPvVSEWkyEUPN1Ws10CxZF33T4tgVifo82pvJFSiPGwiKcUyD1e1CG6n7Eo-
X-Sonic-MF: <pjp@fedoraproject.org>
X-Sonic-ID: 059b106b-2dae-4b95-a2da-2a587f2db37b
Received: from sonic.gate.mail.ne1.yahoo.com by sonic302.consmr.mail.sg3.yahoo.com with HTTP; Mon, 1 Apr 2024 05:31:28 +0000
Date: Mon, 1 Apr 2024 05:10:59 +0000 (UTC)
From: P J P <pjp@fedoraproject.org>
Reply-To: P J P <pj.pandit@yahoo.in>
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: 
	"gr-qlogic-storage-upstream@marvell.com" <gr-qlogic-storage-upstream@marvell.com>, 
	Nilesh Javali <njavali@marvell.com>, Arnd Bergmann <arnd@kernel.org>
Message-ID: <423951940.2187218.1711948259301@mail.yahoo.com>
In-Reply-To: <20240321112438.1759347-1-ppandit@redhat.com>
References: <20240321112438.1759347-1-ppandit@redhat.com>
Subject: Re: [PATCH] scsi: qla2xxx: indent help text
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: WebService/1.1.22205 YMailNorrin

>On Thursday, 21 March, 2024 at 04:54:58 pm IST, Prasad Pandit wrote:=C2=A0
>From: Prasad Pandit <pjp@fedoraproject.org>
>
>Fix indentation of config option's help text by adding
>leading spaces. Generally help text is indented by couple
>of spaces more beyond the leading tab <\t> character.
>It helps Kconfig parsers to read file without error.
>
>---
>drivers/scsi/Kconfig=C2=A0 =C2=A0 =C2=A0 =C2=A0 |=C2=A0 4 ++--
>drivers/scsi/qla2xxx/Kconfig | 42 +++++++++++++++++++-----------------
>2 files changed, 24 insertions(+), 22 deletions(-)


Ping...!
---
=C2=A0 -Prasad
