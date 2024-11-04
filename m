Received: from mailout4.samsung.com (mailout4.samsung.com [203.254.224.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA861C3022
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 11:29:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=203.254.224.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730719760; cv=none; b=I4WZcCY+hp9/ct17L27JMgRp0LMRCm0q01F5/HB4xABM6M8eB0ZedApeo6wt2kZ4P3pjj8RmWYR6B+hYi/CDqtEOxDfILuKNEPdHxRTZr0Yuk54BoteB8QBCpm6vjQgf2HjOcEAKg9Rgag5gCI07hwUU7GpPjzr7QDG653BwXOg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730719760; c=relaxed/simple;
	bh=iDd8slF5N7csNOR+PtgVCK3+kkri3oqX/3EqKPO39PE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:Message-ID:MIME-Version:
	 Content-Type:References; b=kFZ9RPWtRUd4wCP17ULfF+1814+hyr42JhUryQx++lC+08HDixcjCHQbI7eHY8fnGOaCAofISmiTpq5L7/dBWp9dEYjzmAWfCMu03lNtIQuIJOVuHA/q97PqHpCuYq2uv/sgVrrhJNizQe5W/VW0SeVKw1Mujw/CgEaECR0BXX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com; spf=pass smtp.mailfrom=samsung.com; dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b=dXzmDXyP; arc=none smtp.client-ip=203.254.224.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=samsung.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=samsung.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=samsung.com header.i=@samsung.com header.b="dXzmDXyP"
Received: from epcas5p2.samsung.com (unknown [182.195.41.40])
	by mailout4.samsung.com (KnoxPortal) with ESMTP id 20241104112915epoutp0449a8ed393149e5d0aeb18aa7c78d8f83~EwHKN8x0g2570125701epoutp04b
	for <linux-scsi@vger.kernel.org>; Mon,  4 Nov 2024 11:29:15 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout4.samsung.com 20241104112915epoutp0449a8ed393149e5d0aeb18aa7c78d8f83~EwHKN8x0g2570125701epoutp04b
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
	s=mail20170921; t=1730719755;
	bh=u8hCNjyV4KIImElR4gHHT0N9YbPGoDH0xwSkwumilPE=;
	h=From:To:Cc:In-Reply-To:Subject:Date:References:From;
	b=dXzmDXyP4D1IQKI+u+4p/W8hqDgs1aXri61NU55h9xLhYtt2ooPO+gkX7x2c8Nece
	 wpuwnAs4XmXmurEXmsZ9c6ee7tq4bej4PltSiht7zAcgYNk/90bIZY29xQchP72O0T
	 /1fxba+JnuT1XJ46lx5rsZ9MHz2bUfdNH6NN4YkE=
Received: from epsnrtp1.localdomain (unknown [182.195.42.162]) by
	epcas5p1.samsung.com (KnoxPortal) with ESMTP id
	20241104112914epcas5p1a4de3251704b4186b1ed2cc025ac63ab~EwHJ1wrR-2778827788epcas5p15;
	Mon,  4 Nov 2024 11:29:14 +0000 (GMT)
Received: from epsmges5p3new.samsung.com (unknown [182.195.38.179]) by
	epsnrtp1.localdomain (Postfix) with ESMTP id 4Xhq486rDBz4x9Pp; Mon,  4 Nov
	2024 11:29:12 +0000 (GMT)
Received: from epcas5p2.samsung.com ( [182.195.41.40]) by
	epsmges5p3new.samsung.com (Symantec Messaging Gateway) with SMTP id
	21.84.09800.800B8276; Mon,  4 Nov 2024 20:29:12 +0900 (KST)
Received: from epsmtrp2.samsung.com (unknown [182.195.40.14]) by
	epcas5p2.samsung.com (KnoxPortal) with ESMTPA id
	20241104112912epcas5p21f80c9615e3ba9db23428fd524106d83~EwHH2ppKt2058320583epcas5p2v;
	Mon,  4 Nov 2024 11:29:12 +0000 (GMT)
Received: from epsmgmcp1.samsung.com (unknown [182.195.42.82]) by
	epsmtrp2.samsung.com (KnoxPortal) with ESMTP id
	20241104112912epsmtrp24cc6e92f40757ed4e60bcad5adebf9aa~EwHH05i_W2013320133epsmtrp2o;
	Mon,  4 Nov 2024 11:29:12 +0000 (GMT)
X-AuditID: b6c32a4b-4a7fa70000002648-dc-6728b008109c
Received: from epsmtip2.samsung.com ( [182.195.34.31]) by
	epsmgmcp1.samsung.com (Symantec Messaging Gateway) with SMTP id
	77.82.18937.800B8276; Mon,  4 Nov 2024 20:29:12 +0900 (KST)
Received: from INBRO002756 (unknown [107.122.12.5]) by epsmtip2.samsung.com
	(KnoxPortal) with ESMTPA id
	20241104112910epsmtip27ee2183ec8fc729518a6bb0611aa65c5~EwHFuvfow2913929139epsmtip2s;
	Mon,  4 Nov 2024 11:29:10 +0000 (GMT)
From: "Alim Akhtar" <alim.akhtar@samsung.com>
To: "'Peter Griffin'" <peter.griffin@linaro.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<avri.altman@wdc.com>, <bvanassche@acm.org>, <krzk@kernel.org>
Cc: <tudor.ambarus@linaro.org>, <ebiggers@kernel.org>,
	<andre.draszik@linaro.org>, <kernel-team@android.com>,
	<willmcvicker@google.com>, <linux-scsi@vger.kernel.org>,
	<linux-arm-kernel@lists.infradead.org>, <linux-samsung-soc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>
In-Reply-To: <20241031150033.3440894-15-peter.griffin@linaro.org>
Subject: RE: [PATCH v3 14/14] MAINTAINERS: Update UFS Exynos entry
Date: Mon, 4 Nov 2024 16:59:08 +0530
Message-ID: <000801db2eac$c5867ea0$50937be0$@samsung.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQGpHNBxPlSoL7oKvevQtOJlaLn5RgKmbH/8AoOUSlyy4c80YA==
Content-Language: en-us
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrCJsWRmVeSWpSXmKPExsWy7bCmhi7HBo10g6uNRhZbXm1msXj58yqb
	xbQPP5kt1u75w2yxsZ/DYsd2EYvz5zewW2x6fI3V4vKuOWwWM87vY7Lovr6DzWL58X9MFhtm
	/GOx+HQrzmLVp/+MDvwel694e2zbvY3VY8GmUo9pk06xeWxa1cnmcefaHjaPzUvqPT4+vcXi
	8XmTnEf7gW6mAK6obJuM1MSU1CKF1Lzk/JTMvHRbJe/geOd4UzMDQ11DSwtzJYW8xNxUWyUX
	nwBdt8wcoA+UFMoSc0qBQgGJxcVK+nY2RfmlJakKGfnFJbZKqQUpOQUmBXrFibnFpXnpenmp
	JVaGBgZGpkCFCdkZ/18tYivYx1HRsPAKWwPjEvYuRk4OCQETiWcT3rF0MXJxCAnsZpRYea6J
	DcL5xCix5OwPsCowZ8peL5iOjn8dUPGdjBKTzgdCNLxglLh6+zYjSIJNQFdix+I2sEkiIGNv
	zXvNDuIwC8xiklj/bAFYFaeAo0THrSesILawgJPEw0XTgGwODhYBFYkt981AwrwClhLNl/vZ
	IGxBiZMzn7CA2MwC8hLb385hhrhIQeLn02VgrSJAY5ZOzoUoEZd4efQI2FoJgSccEm++NLJC
	1LtIrHp/CKpXWOLV8S3QsJCS+PxuLxuEnS1x/OIsKLtCorv1I1SNvcTORzdZQHYxC2hKrN+l
	D7GLT6L39xMmkLCEAK9ER5sQRLWqRPO7qywQtrTExO5uqAs8JD48+sk4gVFxFpLHZiF5bBaS
	D2YhLFvAyLKKUTK1oDg3PbXYtMA4L7UcHt3J+bmbGMHJW8t7B+OjBx/0DjEycTAeYpTgYFYS
	4Z2Xqp4uxJuSWFmVWpQfX1Sak1p8iNEUGNgTmaVEk/OB+SOvJN7QxNLAxMzMzMTS2MxQSZz3
	devcFCGB9MSS1OzU1ILUIpg+Jg5OqQamwL+PH0nP5J1x1uWXuvSG0O2xOeZz7072DjJdbfc6
	IFSu8uWE2+fTZ2nlapV6Lhba6mi9sCfAolNijtUr5Ue6udO2X9mfMWvnwvY7dUzCipJHVltf
	ChBKfyO6Ot/6XOss2ysFsZc/eax+O/PKRZ5wmc68wJvbl+2IWOx5LqvkxNLj/cpHJyzfoH7a
	30mu9d19lwt8+UER/8zMNpk7yBxa33tcTvlsxBaGZ1/0H0jskd/569WJTfyr2VxMm+Yx7bCb
	dsYo5IPuzYJdyVP/tXG0tugxZSzsN/pcyyfvavxp76HjOj8mbLYtFvYuV4j4O3Vjr1Jp373i
	fT9EVnf/qt3BWbnIhk1Ibf6UrN7Zlz4xKbEUZyQaajEXFScCAB57Fm5nBAAA
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsWy7bCSvC7HBo10g68LxCy2vNrMYvHy51U2
	i2kffjJbrN3zh9liYz+HxY7tIhbnz29gt9j0+BqrxeVdc9gsZpzfx2TRfX0Hm8Xy4/+YLDbM
	+Mdi8elWnMWqT/8ZHfg9Ll/x9ti2exurx4JNpR7TJp1i89i0qpPN4861PWwem5fUe3x8eovF
	4/MmOY/2A91MAVxRXDYpqTmZZalF+nYJXBn/Xy1iK9jHUdGw8ApbA+MS9i5GTg4JAROJjn8d
	QDYXh5DAdkaJDeceMkMkpCWub5wAVSQssfLfczBbSOAZo8TsM7wgNpuArsSOxW1sILaIwEFG
	ifU3c0EGMQssYpLo6NrJCtFwjFGie5kSiM0p4CjRcesJWFxYwEni4aJpQDYHB4uAisSW+2Yg
	YV4BS4nmy/1sELagxMmZT1hASpgF9CTaNjKChJkF5CW2v50DdaaCxM+ny8CmiABNXDo5F6JE
	XOLl0SPsExiFZyEZNAth0Cwkg2Yh6VjAyLKKUTS1oDg3PTe5wFCvODG3uDQvXS85P3cTIzhq
	tYJ2MC5b/1fvECMTB+MhRgkOZiUR3nmp6ulCvCmJlVWpRfnxRaU5qcWHGKU5WJTEeZVzOlOE
	BNITS1KzU1MLUotgskwcnFINTJGlHLPPXJwQIiLAqca5ln+ijO1ua22dGXMLpc6lzM/8Grrs
	yT7lu9/lDd9aGf24c7FjjTP/bdecxY90mZ+VTqk9Nv9sLZdx50Nt6a7dwcw5KbezZyxysfSp
	LJl69PzPcNP2c7ektF7zX9H8mXX2Qh9Labc+q/KhvdUdz4VPWJxdozGv9IxPaOb/S0KaUg61
	gaWdOYcPxi77XHDhoSTn2htKqXxnuhZwW25beN6P1/FT0HmOqTFHP65+9NHQXd+Wv2Aa18ug
	KZsezX2jfnGFo8ol4famvzE5AbU7BBrdSzvytUN6bq+R8b58QT1mU8OWOzO9lkXudZ9lPWn3
	+fL5EzPZvjqcfbhhtrgIf8gODiWW4oxEQy3mouJEAMqOm4lJAwAA
X-CMS-MailID: 20241104112912epcas5p21f80c9615e3ba9db23428fd524106d83
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
CMS-TYPE: 105P
DLP-Filter: Pass
X-CFilter-Loop: Reflected
X-CMS-RootMailID: 20241031150102epcas5p2b485ea44b17629f3abd0a53fd8d172e7
References: <20241031150033.3440894-1-peter.griffin@linaro.org>
	<CGME20241031150102epcas5p2b485ea44b17629f3abd0a53fd8d172e7@epcas5p2.samsung.com>
	<20241031150033.3440894-15-peter.griffin@linaro.org>

Hi Peter

> -----Original Message-----
> From: Peter Griffin <peter.griffin@linaro.org>
> Sent: Thursday, October 31, 2024 8:31 PM
> To: alim.akhtar@samsung.com; James.Bottomley@HansenPartnership.com;
> martin.petersen@oracle.com; avri.altman@wdc.com; bvanassche@acm.org;
> krzk@kernel.org
> Cc: tudor.ambarus@linaro.org; ebiggers@kernel.org;
> andre.draszik@linaro.org; kernel-team@android.com;
> willmcvicker@google.com; linux-scsi@vger.kernel.org; linux-arm-
> kernel@lists.infradead.org; linux-samsung-soc@vger.kernel.org; linux-
> kernel@vger.kernel.org; Peter Griffin <peter.griffin@linaro.org>
> Subject: [PATCH v3 14/14] MAINTAINERS: Update UFS Exynos entry
> 
> Add myself as a reviewer for ufs-exynos as I'm doing various work in this
> driver currently for gs101 SoC and would like to help review relevant
patches.
> 
> Additionally add the linux-samsung-soc@vger.kernel.org list as that is
> relevant to this driver.
> 
> Signed-off-by: Peter Griffin <peter.griffin@linaro.org>
> ---
Thanks!

Acked-by: Alim Akhtar <alim.akhtar@samsung.com>



