Received: from mx0b-002e3701.pphosted.com (mx0b-002e3701.pphosted.com [148.163.143.35])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 396E226A1B9;
	Fri, 22 Aug 2025 19:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=148.163.143.35
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755891879; cv=fail; b=CUzolnt4fRYmVIgODSpT/pAjzxS/+8sqbOFQG+Je5ObtKUpLcJT8gLJ1dvif7qc8elR7lNvvXDfKDpZ53nsA+o0DN61xy3EUK4KanhYGHDLJzkSZNARAXySOl7U3V/4+aKiY66GSqY4IXEI5k3ERFAsf7b6gTDHpX+xxCbMYqSo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755891879; c=relaxed/simple;
	bh=nYUhUlDhJZCVWFm8MjfysBKOeV1PXBvVIje5JBVOMgY=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=nzgT+gtYuQXhQIce3XXR4WREH7dsoaOeB1AYcGRFRLCgSH8j1OUjgCQhzDqQyV5nBC+i8iW86MNo/+/TKDS5jZ0FmpAxH+srg+/FmUWkJyAPZIIUQPR/73FeWYNqDAjn9zC7wCstv4tjl0+nsTfVMaUEJ82v7wS7LwPvIx7rw2k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com; spf=pass smtp.mailfrom=hpe.com; dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b=Kc0nrutD; arc=fail smtp.client-ip=148.163.143.35
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=hpe.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=hpe.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=hpe.com header.i=@hpe.com header.b="Kc0nrutD"
Received: from pps.filterd (m0150244.ppops.net [127.0.0.1])
	by mx0b-002e3701.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57MHaVoe001198;
	Fri, 22 Aug 2025 19:43:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=hpe.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=pps0720; bh=nY
	UhUlDhJZCVWFm8MjfysBKOeV1PXBvVIje5JBVOMgY=; b=Kc0nrutD4pyp+PfW6x
	AC/00oqG5kZX4TYefx2vCH+Mg2Rbl1WoOvHdGN2xOBkAOfirXyc2WKjD/oyOXlEn
	T4oW4QSS1dsbhFmv2JGmFWwsv6cjXP66Xt/WEAWZpmmDxPPAo1jT1qAk6WcHDPyo
	/5pzN/Y5lDCkjR5hi/YfiXiNoP/puaRXQJZClq0pr3L5qgV9FTG4Iw7ZCmTE5A+t
	DSebpbo3WNEJmpIMOIJOXdPlk99E80qOyDqfH5J0bepUH0KUTiy4NxHN9fixx1RZ
	tBaloxQye3P/UD3nJcTZrfxihC+2dW1iJUDtw6af4E4UMUF+ikey6ElfXgBJ1qU7
	l3xQ==
Received: from p1lg14879.it.hpe.com ([16.230.97.200])
	by mx0b-002e3701.pphosted.com (PPS) with ESMTPS id 48pw3kgtwu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
	Fri, 22 Aug 2025 19:43:19 +0000 (GMT)
Received: from p1wg14926.americas.hpqcorp.net (unknown [10.119.18.115])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by p1lg14879.it.hpe.com (Postfix) with ESMTPS id C3996132D3;
	Fri, 22 Aug 2025 19:43:16 +0000 (UTC)
Received: from p1wg14927.americas.hpqcorp.net (10.119.18.117) by
 p1wg14926.americas.hpqcorp.net (10.119.18.115) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10; Fri, 22 Aug 2025 07:42:25 -1200
Received: from p1wg14925.americas.hpqcorp.net (10.119.18.114) by
 p1wg14927.americas.hpqcorp.net (10.119.18.117) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 07:42:24 -1200
Received: from P1WG14918.americas.hpqcorp.net (16.230.19.121) by
 p1wg14925.americas.hpqcorp.net (10.119.18.114) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1748.10 via Frontend Transport; Fri, 22 Aug 2025 07:42:24 -1200
Received: from NAM04-MW2-obe.outbound.protection.outlook.com (192.58.206.35)
 by edge.it.hpe.com (16.230.19.121) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.2562.17; Fri, 22 Aug 2025 19:42:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHAZWZWRNc3vg0IyUOKr0ZuVxFu7Bt1ow8GmauudAcSITVTY22rtU37jRJ+OFV/EPCobuJJvxpN5Ku/7gKLZf8Tq5JEacfzBZUMCEQJdrD5+Ji6wfNwUAPBOOm0/DffJRboPiKvoBefn2C1p05yTlV2EspZ1FbGsjQEHHZtWDN4txgXAuYnAnrVe/6aiwQBEGKFIFrdO4VQp5qiXrPnXSREQLiFvqpNjOiNSgPnofH8Id3fM7IzuvC+spx+0Q2ygOwTJvufYsm1HjjzaUxb7cGKbziIs1RYbXbYIHSDWQC9gQBaYnwwPh9zu238PF5jp98hlnwTHbFmaec1ZPwC6nw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nYUhUlDhJZCVWFm8MjfysBKOeV1PXBvVIje5JBVOMgY=;
 b=LYgXnrkePNJq31d9bvJprsyIK7vCPY0dot9Fb3g8pKWvieCdlYoE+ss455QtVXkK4NRM0Ujm7Yjp5dqOHjuxcpFhSDyFez2FSOchQ+CafU3WawJruzIu5x5QoyVWThqZoz69XiRR/CaYHxesq0jIFobTkv9L8gcVsigQX0mt/Ps5TbpfMW7hgzODo8lpqkP4yr/WYCj9Dw3wnhCIOxhhqBTpdicpoY4qSjYgdcKpvc7JrKagLbDGoRq99nyycn4BVXoQG7UMTuBiLPkkswQtsmF3VB96qEmOCgyQUCGGw+DMAIh+R0vV95QrY5tI5JD5cLx/lU/SCrnnaSZMDKVwBg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=hpe.com; dmarc=pass action=none header.from=hpe.com; dkim=pass
 header.d=hpe.com; arc=none
Received: from MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:303:1c2::10)
 by SJ1PR84MB3092.NAMPRD84.PROD.OUTLOOK.COM (2603:10b6:a03:45d::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9052.14; Fri, 22 Aug
 2025 19:42:21 +0000
Received: from MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fe0b:8c08:d30:f869]) by MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM
 ([fe80::fe0b:8c08:d30:f869%3]) with mapi id 15.20.9052.017; Fri, 22 Aug 2025
 19:42:21 +0000
From: "Manikarnike, Vasuki" <vasuki.manikarnike@hpe.com>
To: Xose Vazquez Perez <xose.vazquez@gmail.com>
CC: Xose Vazquez Perez <xose.vazquez@gmail.com>,
        Wayne Berthiaume
	<Wayne.Berthiaume@dell.com>,
        Matthias Rudolph
	<Matthias.Rudolph@hitachivantara.com>,
        Martin George <marting@netapp.com>,
        NetApp RDAC team <ng-eseries-upstream-maintainers@netapp.com>,
        Zou Ming
	<zouming.zouming@huawei.com>,
        Li Xiaokeng <lixiaokeng@huawei.com>,
        "Randy
 Jennings" <randyj@purestorage.com>,
        Jyoti Rani <jrani@purestorage.com>,
        "Brian Bunker" <brian@purestorage.com>,
        Uday Shankar
	<ushankar@purestorage.com>,
        Chaitanya Kulkarni <kch@nvidia.com>, Sagi
 Grimberg <sagi@grimberg.me>,
        Keith Busch <kbusch@kernel.org>, Christoph
 Hellwig <hch@lst.de>,
        "Marco Patalano" <mpatalan@redhat.com>,
        "Ewan D. Milne"
	<emilne@redhat.com>,
        "John Meneghini" <jmeneghi@redhat.com>,
        Daniel Wagner
	<dwagner@suse.de>, "Daniel Wagner" <wagi@monom.org>,
        Hannes Reinecke
	<hare@suse.de>, Martin Wilck <mwilck@suse.com>,
        Benjamin Marzinski
	<bmarzins@redhat.com>,
        "Christophe Varoqui" <christophe.varoqui@opensvc.com>,
        BLOCK-ML <linux-block@vger.kernel.org>,
        NVME-ML
	<linux-nvme@lists.infradead.org>,
        SCSI-ML <linux-scsi@vger.kernel.org>,
        DM_DEVEL-ML <dm-devel@lists.linux.dev>
Subject: Re: [PATCH v3] nvme-cli: nvmf-autoconnect: udev-rule: add a file for
 new arrays
Thread-Topic: [PATCH v3] nvme-cli: nvmf-autoconnect: udev-rule: add a file for
 new arrays
Thread-Index: AQHcEhoLwdHibI9b6EyohNBGpVku5rRvDhgX
Date: Fri, 22 Aug 2025 19:42:20 +0000
Message-ID: <MW5PR84MB1644AE3A5C858D96B504DB258F3DA@MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM>
References: <20250820213254.220715-1-xose.vazquez@gmail.com>
In-Reply-To: <20250820213254.220715-1-xose.vazquez@gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
msip_labels:
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: MW5PR84MB1644:EE_|SJ1PR84MB3092:EE_
x-ms-office365-filtering-correlation-id: 2ebaaf6c-0635-4737-29f1-08dde1b40296
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|7416014|376014|366016|1800799024|38070700018;
x-microsoft-antispam-message-info: =?iso-8859-1?Q?4GnUJ0M6OJL9JsI6lE2TAH6aDcd8bpUIG+KjoLxSxLpvTTV575Svd6qG8i?=
 =?iso-8859-1?Q?6WPj/ZtVNqsMGvhGd65R1gqcxrL8mDCUXT9G8qIAqkvWzCBF6HtoNVngmL?=
 =?iso-8859-1?Q?kKlnFxNHfjwrAEN/gAKgiQQzSVeKI1lEGU6fkor+WvUlJTTEpXHeqntyqX?=
 =?iso-8859-1?Q?C9wkyJqu70XI7/V1Mx0PFE906QynfNlMdSXUDIdaCIDuyk3GdhUyINavAX?=
 =?iso-8859-1?Q?cpFdgMDgNRpiAhhFPkSL/9NM6Ho7F19Ha0vKZPRpFgGypvWbaXUE9tIPiB?=
 =?iso-8859-1?Q?LmpXHDwpw/LZcWIsU8nHV0TUg5Zfr0njGha05qhzjR4ERxg/9nrkSVRhMj?=
 =?iso-8859-1?Q?6MkP+YSqqXlimsPmEOXZs8ND8ii6jJvyaR9peTRd5K4V235av+X6FVpRSX?=
 =?iso-8859-1?Q?p9ClQgmIXAKDrZ/bAAMDoQld7Sj51hbzzReOZAMTD7jAnP8LjUWa5EMUo7?=
 =?iso-8859-1?Q?tVZ08Cl0KEQ36k7UQF+1KaaWe3z7OJdliyahWMZwYo7IvqvlAX5jaSHPzK?=
 =?iso-8859-1?Q?QstEHEW7MgMcBrpiSKkeSclid6R5OA55fhKhvkfm+X4zMz051vBjJhPQ1L?=
 =?iso-8859-1?Q?TDL92bm7R2iloWDtcvJTY1zc3g1Y1H1VeEbFo/ey6OpCXj+Iy1qPolyFR7?=
 =?iso-8859-1?Q?eSDVhNnjem+b5u9tYWP3BU6bznZQgiBa/9T1fsowOI5A6nbdDDF/ssXyUl?=
 =?iso-8859-1?Q?5KCurDu0j5+SKacL75eQeffudgKVVtH1Z3DmeY7NmDVYauCC+ZU5tiPzPS?=
 =?iso-8859-1?Q?A5j430txseq8o+DeaWQBSIfrXwyze7VvOUfXCmzkbuzijZAXFQgU9Hhonq?=
 =?iso-8859-1?Q?ls9EkwqxdOjPKErqwNPNisUiKLqonOld6U4vQGpK27DK5meefvhLOKMjBg?=
 =?iso-8859-1?Q?GCLA/aAi1UvrXJonwVUi3AtOgywGlPzX4O22QtroQf44IxhF64nw1WfIwT?=
 =?iso-8859-1?Q?9UGGsF2n1FbnKWi/TgxHbcuVoy9gxJjxaAcFG4/KLwIDhPbZSlSNKR7HV4?=
 =?iso-8859-1?Q?c5lAG1fR/VSjJdVFMw8AypO18YTq3WsXKvf5qdjY4cPHClvQ4BC4p9Paaa?=
 =?iso-8859-1?Q?hJSDPjKPUa1HpUx40vVwQ8NeSyyD/KaTESAG3q38ANO8YjVZWQSTnDr/6i?=
 =?iso-8859-1?Q?0Qt/etIIIgGk1t+KKAHC4+iNFpV/BWw1gMH4l1rYgXva27GLKKWA0T4rdz?=
 =?iso-8859-1?Q?rKvflkfhqHU6rVG9J+BpZ4taqbz9C+WLV1yrTiIA2mqw7lsN6bWTOO2HvN?=
 =?iso-8859-1?Q?cMPjPKFjGlkR6wu4zgpsYPHYmGyCutee3TXprSRnPcYLN0CaDY2U0Nze7h?=
 =?iso-8859-1?Q?66OQa6puWYvK7FohwupvcHG76uyUJ5ds21ogn63p/v4B75x28B8BbBMA36?=
 =?iso-8859-1?Q?jtB0/PLAdqy7Vvcu4Fx1kmeTz3oS082p3CnBVgvqXIppL/uBMLqBSCsG7+?=
 =?iso-8859-1?Q?7XynpiUaqoE/kvA5ziO99z1YWOSDbUS0WYea280VuIIe1OFgLEXlPTyQOL?=
 =?iso-8859-1?Q?qacfvfn5yYbyIf1Og+QNiQGVDlSYm3TrRshnhZWNew2w=3D=3D?=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM;PTR:;CAT:NONE;SFS:(13230040)(7416014)(376014)(366016)(1800799024)(38070700018);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?YIAO7bb2MxjLmAWE7s1iG5o7vKjbvcsZroPkwG9K1sc5dAW/UIl59GqVSZ?=
 =?iso-8859-1?Q?Pr2OZamVJnCGF5+BxZMUdEcIWKTG/9zFIQXnvOZL8XwfhNU8PSivVnKjQn?=
 =?iso-8859-1?Q?rDtFi8scB8mHqnSlwBTaK57itAFv5hH9+EFh3rBnXycRE0knEg3lfNOU8Q?=
 =?iso-8859-1?Q?leVPskmff/eYUSC7/ptVV4ZiLqOWQfzkQAFfVstluRjvxNCKsQ7O0dfnna?=
 =?iso-8859-1?Q?nP2hf0dVoQ9g9l33J4sPFpnbzQQwBvGH0KmkDCYVo1RdWcd9U3ZmDHn1Lf?=
 =?iso-8859-1?Q?CpqHAyx61sqAiXsjNBr7IEMe5NgW92e5l+DIRUYzfwDfg2rRWRUEBPLtq3?=
 =?iso-8859-1?Q?PLvhlVE+FH+6gAw6JIyTr7yw8GbneBmhFFPD8mODOh3CMfZS2KS0uK2Ry2?=
 =?iso-8859-1?Q?puHdvPvhQnxgcZqsUhSuOmGOAtUYoLbZCWUO4t+UeZyFLrt4ygeB6OmKH5?=
 =?iso-8859-1?Q?+Bqwjykk2gYvvkfqRqPvj+xO1FdvmNB3n4Vj7kAgVagqYZ9rkMK/ydfaj0?=
 =?iso-8859-1?Q?pTBC6eyxirSkeYKUdJzvjeyfS0yfQ8ffBvguV45471xvZ3r6dr06HV1+bJ?=
 =?iso-8859-1?Q?muxAMjvCRuvqeYA2zLIINZCP9ZxSsTuSakg8c1ci13Q2aCtl+BMmAC+kIt?=
 =?iso-8859-1?Q?s3wsYgwvDpwas1ftYP3f7YotjDocQ7TPiSbsOYwev3Yb6+0Dp7OFmMBBCn?=
 =?iso-8859-1?Q?LGMVX9Xq2c1GUuAHZ4HvN/xrBO0lbfy6I/fPBPAWxNysdO7AfgF3lC0awU?=
 =?iso-8859-1?Q?yDZOcW8271RH1KTu2llLfGT2Net/x0VOf1vKAFhti+BCHJxQAn1zbTOFtY?=
 =?iso-8859-1?Q?AHZImBUxzROzqUmXLLVx4WsOk+uVtQzvnPwRIFx7iTMJe2hnqghYH75tNA?=
 =?iso-8859-1?Q?irg33QfEAS5mEMW9aQiMqqqYd8gJcL/PTjHhkAEfF19+QsIBubXFHAf9iH?=
 =?iso-8859-1?Q?iYsxjA0j2OaMQnmKK9JhnkchIpgdqLDc3nI4NG26w+CeDG3zjFOR9y4F02?=
 =?iso-8859-1?Q?rG4HtN4j7zsROef4Dcby0WQfI/q969ow0SxZcDDmTrl3fHZABiViGCkQI7?=
 =?iso-8859-1?Q?5NzgYQpISffs9FQ31qL8A4jqOmVWDUbU8/j89raxJCD24QZOeT91PhhfMo?=
 =?iso-8859-1?Q?NB95sDGByZdcTu24RBvIe6BVyQdOlxqy06EjYoK+oClP7dxRPg79hP+ioi?=
 =?iso-8859-1?Q?gmzNm8gG8K0sT0jd7VUELI5npLkbDDsTKpqnp+zM2e1n7BUX04AR5IeU1d?=
 =?iso-8859-1?Q?tUl54gizsxyU+CLMDySSa8T6cN2ZEmgbqjKxKgjRL5Y/1m0Kgm1u/LPWkG?=
 =?iso-8859-1?Q?iZAYAwetPtLTQliJP/98cHupfYm9kdbyrl+c+mjRR2+u/gM5I9hjJrVv8k?=
 =?iso-8859-1?Q?/UKG/RsX9J7aaSKxtgkBzINQBJ3ACOXU0sCf7dSu9MX+mXzcNJLmTYsJ0N?=
 =?iso-8859-1?Q?Izp5YC5cvKiosalM9WMiGQx20OvZjW9Pxc33xQ7swqRQZwyV+vwB449FyO?=
 =?iso-8859-1?Q?4hXdEIwH2bjNcHyW5HdJWzTBOTWXOb9RamTZr/Z8asoELTfH7B7i2H0hOf?=
 =?iso-8859-1?Q?kr3kim9YR5C7P7UXInzdMY88AnIe1ZbEna0AqN6NdYRSIe9fZbBw04t6R5?=
 =?iso-8859-1?Q?bl4DwrEAncuMq0QHsvZtZbPGuhjIS/iyjs?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW5PR84MB1644.NAMPRD84.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ebaaf6c-0635-4737-29f1-08dde1b40296
X-MS-Exchange-CrossTenant-originalarrivaltime: 22 Aug 2025 19:42:20.9794
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 105b2061-b669-4b31-92ac-24d304d195dc
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: wKL+4U4wUnKObBwpSS3hxZI6IDGCFKEXngEir8B1xW2s/rMn9LuBrVdd5kMysdvP0C3Buacxm0mi0BpulR83/rlQ7KU6DCtWadSvEcG45N8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ1PR84MB3092
X-OriginatorOrg: hpe.com
X-Proofpoint-ORIG-GUID: k6oOhAHbD4kAEZjWJaTaJ3Ty083ef1Rf
X-Authority-Analysis: v=2.4 cv=Y/f4sgeN c=1 sm=1 tr=0 ts=68a8c857 cx=c_pps
 a=5jkVtQsCUlC8zk5UhkBgHg==:117 a=5jkVtQsCUlC8zk5UhkBgHg==:17
 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19
 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19
 a=xqWC_Br6kY4A:10 a=8nJEP1OIZ-IA:10 a=2OwXVqhp2XgA:10
 a=UGnZxlgPnXDcx8THQKQA:9 a=wPNLvfGTeEIA:10
X-Proofpoint-GUID: k6oOhAHbD4kAEZjWJaTaJ3Ty083ef1Rf
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODIyMDE4MiBTYWx0ZWRfX4FjLTeOg4E3A
 aKbZ1MN3HTfsmeXZxibsoRVLWfdXLe/SAuh2FNca8DXJUXz+wrFCekUVcFQUwPbi62sa0Fe+wNS
 EooK4EFnJFlLSMYEaAuD3Hn3Un18SzdM7e2pT+7cIzx+MRnJvgHzf6IV0fj4fI9AvAJFSM9MsgA
 UbsxRJe9xdspzmD1S50lGw3x0Jh1/N3583dmLhQ5JIUnqFNcmPKaaH5INfTV61MzH4Z0vLP5J3Y
 ZwAkfDyaMmj4O1KFLIyCgK7iLH/TdvBrZdPSOKqYmZfWMKFtulQ3Xq1APvwt0bHLjX8ohdLzEyB
 7w993HHwcpDmrch9PS1pj4ZzMfgZs6u2kH3RMLEsBy23rnF+MwHXbOxhImGpwItv/eEU25bExLJ
 LcVgSgNUKO0/owBhiBh/ZhbtzXleIdUt0YqEbUtvTVJwrIY9LiZfAjAvTeVFK7Iw0reMYjDY
X-HPE-SCL: -1
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-22_04,2025-08-20_03,2025-03-28_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0
 clxscore=1011 mlxlogscore=695 malwarescore=0 mlxscore=0 impostorscore=0
 bulkscore=0 adultscore=0 suspectscore=0 spamscore=0 lowpriorityscore=0
 phishscore=0 priorityscore=1501 classifier=spam authscore=0 authtc=n/a
 authcc= route=outbound adjust=0 reason=mlx scancount=1
 engine=8.19.0-2507300000 definitions=main-2508220182

On Wed, Aug 20, 2025, Xose Vasquez Perez wrote:=0A=
=0A=
> Maybe these rules should be merged into this new file. ???=0A=
> 71-nvmf-hpe.rules.in=0A=
> 71-nvmf-netapp.rules.in=0A=
> 71-nvmf-vastdata.rules.in=0A=
=0A=
That's a good idea. Will you merge the hpe rules into the new file in this =
patch?=0A=
=0A=
Regards,=0A=
Vasuki=0A=
