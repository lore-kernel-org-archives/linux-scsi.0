Received: from esa.hc6817-7.iphmx.com (esa.hc6817-7.iphmx.com [216.71.154.88])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E7E1325FA05
	for <linux-scsi@vger.kernel.org>; Fri, 26 Sep 2025 06:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=216.71.154.88
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758867178; cv=fail; b=clg0GN8wUDTRDpOUpoVSE0IGP4PS9uWOJMgvJ1lMBSYAynTYgXaNcWBtPMi3mohmsi02FN2WD2dTsvxHdweCaWAo/GFRSd9kRvAkOS4/yleHW9XR0gQDaMDX67p8B3FlYgP7qpcEDRUFae8yvdA6bmIiZNGuFsER1GgRu7Ric1I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758867178; c=relaxed/simple;
	bh=/jR4Xe6LNd4qYrgRFQT5lST70adjwXjiVaob1+VMT5w=;
	h=From:To:CC:Subject:Date:Message-ID:References:In-Reply-To:
	 Content-Type:MIME-Version; b=O8iJti6MafIFw6NWQFaUQISpXfil19AtDT/PiCdjtacaW/DGL7pPcVpPlvgi+ZI9JETpgXvAjiWynLKp5WooyfLUTZdpAG2wCmSwDzRqIa0s4Ynu/kSXP3iVEeTHbp3Poemxwdm/vb6GjV1Q81x4EWibzITc4VSRT+Sm8/qPOHs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com; spf=pass smtp.mailfrom=sandisk.com; dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b=f9Fc+RHs; arc=fail smtp.client-ip=216.71.154.88
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=sandisk.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=sandisk.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=sandisk.com header.i=@sandisk.com header.b="f9Fc+RHs"
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=sandisk.com; i=@sandisk.com; q=dns/txt;
  s=dkimnew.sandisk.com; t=1758867177; x=1790403177;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=/jR4Xe6LNd4qYrgRFQT5lST70adjwXjiVaob1+VMT5w=;
  b=f9Fc+RHsw6Ny0/83C4YINvhpWPGwZJuBDb6CIjjmanqnhRnUYoDX1CIc
   MGAuIi/0u646WPIOUR25DEPHmEEuRwCcz5bzTp7B1K/FACWgbCN4eu6UO
   WfBSfgQm3UqW1J/u/GZXokB0IPDQ4OYHpJM/WzW+rjhWmlo2hh/MGG+0/
   RW+WrqLsPb6LU+CDGgIwIhUCWPQ01MqeDIUmbQa+ahOuSEFhzmdveZzB/
   4M3Yth2+i4BtJ/9gFlk3ITRkTQmQ6HMk5EEVXSFXp4hGRCIoumfhMrujH
   Q3kwQoc7HOi/hEpbiOnbXfDDA+MODVMiYNlI2buwO4AnQk06W9XUR+NmY
   Q==;
X-CSE-ConnectionGUID: R/39vEpwRxyvANbfANS3/Q==
X-CSE-MsgGUID: y7UjU3RcSRqKtGaKbfgg9A==
Received: from mail-southcentralusazon11023114.outbound.protection.outlook.com (HELO SA9PR02CU001.outbound.protection.outlook.com) ([40.93.196.114])
  by ob1.hc6817-7.iphmx.com with ESMTP; 25 Sep 2025 23:12:55 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=iPXfGnwzsdl34klQR+xmYhg7yfcjef3r4tsPDcT8pSyP0VZxzt3nouyo6IAUhKlpq9j7sI4C/qEorXv61OkJyIJ1s2pfk/LY1bhU3a4aOpeRa7zaswY55aG7yn5qYFy5QiGYT5oCbMFvipkih2tzjn8p26kkrA9A1IZfPGuGmOVJ90qgQflCgL8MJU4yhUbBmcnpnTmcsE8xz4OX2jl3vWeRRus4xjB6AyxFymCQzvnVGuRAREy/rKbA9uqGS7eFoafBubJJvyYlyoHtXygMgjHady8TRPQVtqIpRhjdkDZVDXMrrltiRl0dsdFhUQUWI1CiYWye7TiL0AUwAKxinQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=a0wVWUX4fTtrXqQKOBjIgOfNgQUpyPe8iZYno8qRgGI=;
 b=eL5ShSp3Mq11sxGLk/iQRAybcjHpx5IjtIFzv5xQIiFiIQ5vAZ4O4yEg5sZAAV22tGF5aQyhdo1i5U3Bbqgu0WpKcW6iDiEsb9YsukujzjJ0UUXsWF2B/qKyOBCU+wT167xucCvLfgjMVejQa2B+vOnkfVofaDTTAW/Cxh+tBCG2Ph8P/Z2yealTcXsm1FZ44IIynt0H+5osLcuRbgORGxw1jGcaubWkCzcRdBdS0CZmicSAoIbnMAcpEufVxgN3afXRkYR7vonmSTvbBBPslyXJyElWfAMd06vu2OD8JVCJjo++ze5BrOGsk89Yf4SarRd1HRCKSaL/h5zxvVnbQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=sandisk.com; dmarc=pass action=none header.from=sandisk.com;
 dkim=pass header.d=sandisk.com; arc=none
Received: from PH7PR16MB6196.namprd16.prod.outlook.com (2603:10b6:510:312::5)
 by MW5PR16MB5055.namprd16.prod.outlook.com (2603:10b6:303:1aa::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9160.13; Fri, 26 Sep
 2025 06:12:53 +0000
Received: from PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491]) by PH7PR16MB6196.namprd16.prod.outlook.com
 ([fe80::df4a:1576:a40e:5491%6]) with mapi id 15.20.9160.008; Fri, 26 Sep 2025
 06:12:52 +0000
From: Avri Altman <Avri.Altman@sandisk.com>
To: Bart Van Assche <bvanassche@acm.org>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J.
 Bottomley" <James.Bottomley@HansenPartnership.com>, Peter Wang
	<peter.wang@mediatek.com>, Chenyuan Yang <chenyuan0y@gmail.com>, ping.gao
	<ping.gao@samsung.com>, Al Viro <viro@zeniv.linux.org.uk>
Subject: RE: [PATCH v5 08/28] ufs: core: Move an assignment in
 ufshcd_mcq_process_cqe()
Thread-Topic: [PATCH v5 08/28] ufs: core: Move an assignment in
 ufshcd_mcq_process_cqe()
Thread-Index: AQHcLZKuwXfpt8ZUEk2ucBiCtMbb/7Sk/eCQ
Date: Fri, 26 Sep 2025 06:12:52 +0000
Message-ID:
 <PH7PR16MB619697A13D359F36B97A029AE51EA@PH7PR16MB6196.namprd16.prod.outlook.com>
References: <20250924203142.4073403-1-bvanassche@acm.org>
 <20250924203142.4073403-9-bvanassche@acm.org>
In-Reply-To: <20250924203142.4073403-9-bvanassche@acm.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach:
X-MS-TNEF-Correlator:
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=sandisk.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: PH7PR16MB6196:EE_|MW5PR16MB5055:EE_
x-ms-office365-filtering-correlation-id: 032597d1-0953-4713-af18-08ddfcc3ba2e
x-ms-exchange-atpmessageproperties: SA
sndkipoutbound: EOP-TRUE
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;ARA:13230040|1800799024|376014|366016|38070700021;
x-microsoft-antispam-message-info:
 =?us-ascii?Q?PQ0RJN2S8jgogksHTzYN6Q8YYsyXwksFxZvzISZMVnCGeCUs+ThHWgLyAHVq?=
 =?us-ascii?Q?JovSklTmZ0eVBhHxQcGQNxnls0KWlQ2pzYiI8uPfvyQtKB41+rsmR4nfB3QV?=
 =?us-ascii?Q?CgRzGEpbzXUc7QeAZKVG5zNz0inTV/+MSRWIJrx4cqC0ym3ecnqr2kKohO+M?=
 =?us-ascii?Q?wdMAz08eBfuGeeJ/q9Aan6yigopwiavypqOLq5hFvPo1oAbbCmN56yl/1nu8?=
 =?us-ascii?Q?i3FhuqdLpdN9gwe6Rp8gGKZtgb6TB9n4Eg+rP4UPtQviQY6W8CHj8uufJcqU?=
 =?us-ascii?Q?kuFs+pZRntC4WmPYgOva4g/1EyVZln+9cvd7dnyX9yEPbkVhlpygvZ3r6LBC?=
 =?us-ascii?Q?Jl/9VEYv1yBoyQop5rzQQcSaAAFCZOipaEgWmwxfYYz8wIjmdPGYsQkjuuLI?=
 =?us-ascii?Q?fCfpryfQsGXahRYoOOQzchCvA95Vbzy/h+UdKGz0QBlGuKsfa4HJTYQkwrRZ?=
 =?us-ascii?Q?CsvgVeQdoekj9KTQfKpVzrRyjz/yQOLXxd5gJ2GueankIroqnGAGgtoKA32x?=
 =?us-ascii?Q?Qpelq+iN9lwQSzWumyGUyPWCAhMJqjoKVe8HIZSHeSxtvTUjK1gNula/1WWg?=
 =?us-ascii?Q?qz2495BDl08rHVRqEBMfusDEB9tj65c/x8+0XwUDQjPJFvKQfN3gq0PBLY1U?=
 =?us-ascii?Q?gpnmsLOVFt5yKEhUNpae5/jYAz5FNKaTHw/SDcx4zREYuHRBFoNT0mVsJpss?=
 =?us-ascii?Q?hJN6FUImBsNFVKHN4gmhwKN+C4glw+ofvtx2tjd2I8/KSGdY8GxYUAbEp2Vk?=
 =?us-ascii?Q?4ZkHl7JWtkXmCrCdRp+lAnlg+u4iTuwMS/uBagt4h3he/QM+X/EkvLl0B4wH?=
 =?us-ascii?Q?ibicupCSRlJOy6z/4ogk7B9qf3efFAZPkRNT+qctUh5CIBhXYYYyhWk4BBxD?=
 =?us-ascii?Q?Hrr9QAvRCL4FFMeO0wb1GBGJ+k+gC1JQ7WRLuZfhokbUfiqJI/LlCcdgOe37?=
 =?us-ascii?Q?EWd6kypstmFDo7Po/QbQYCr1l1qyUxBQ2eVgR7ZEsUicef9bYPcDm3mHWm6u?=
 =?us-ascii?Q?bYMmfvOoiGpChPbtjp3lBgMKYPuVGFKVfPgdt81vAfB+P9OAdbKsMaBil1h6?=
 =?us-ascii?Q?F5taI0zloPjOZwq0hCn8YLbjIre+l7fKg6sZjOX9UPiGJF/HE4JEr538hX6N?=
 =?us-ascii?Q?eigr4/gW+qJXtD676kIufcS4QWKTLUuXCQepmmSKvwAPnrI8YOpRQyv8IFbH?=
 =?us-ascii?Q?OEN6GltNfha76SxQ62IT6YlZBTSs4lkjioAJZ5/JKKV30jkxiLbCLRxyrSPc?=
 =?us-ascii?Q?GxGNgEGV8mD/L4WXkdhic3o+2t3oIySWHAQEvSZFQD26u4h9zu+qcuMZEZeK?=
 =?us-ascii?Q?4aBXBygr6JisErSLFPOBZrTGIFh6/AVgScI94CDZHRcIz1o4ljhHvmF0YjYi?=
 =?us-ascii?Q?HDCFBVBtAg8tr5BGID6HixZCcP8dt+Rt7Fg6857SAdC9UbFKQBCdcPqmfzf4?=
 =?us-ascii?Q?z/mFHGtgS08hEhSCmL+NG5mYmriGXmJV5QZpBEDquvYYLFpgf+YLVg=3D=3D?=
x-forefront-antispam-report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH7PR16MB6196.namprd16.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016)(38070700021);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0:
 =?us-ascii?Q?1a82QzDe9r3k7oqYCzlyYL9hF53kXiW6F8hzlK9YXmDW25Ye2S7b+WVMVen1?=
 =?us-ascii?Q?siUqvWhnpGlyQt7DU56kMkWkpDMOA0F6r3S8TdAZweH3ia68bYEWabv6AS/x?=
 =?us-ascii?Q?OKzuDa3TrlV92xagSuWwk7Scq0WHFZNv1VbmD13zKbdViyywurjMe2F5zZw/?=
 =?us-ascii?Q?85kYmTNt2xY0fPFZcSJRoyrFY/DOyx4lPQ0YR5wLU0FtoDosEB7NyMEW5If2?=
 =?us-ascii?Q?c/vouFmck/ydsT5SA+0bXsIE4rB2UfZW5/H7nc28FQCuGJWCwkdBFQuHWr60?=
 =?us-ascii?Q?SK0+uwnKrqEi29mSS0klm+pNiTWEr3CmBtmgYdk8bdIodx6z/YVd2IZvOcFD?=
 =?us-ascii?Q?Y9FblhXFdz32zgqjCKbHmiZVN3LQCiQSC/3gNLeAaSVmgteLOYpF4K76d4/o?=
 =?us-ascii?Q?m+fuVVcL0zGiTiej4iktctO1vQMl3cCi5ILB6Dq2LALNjJAWMsW+gXZQFFwQ?=
 =?us-ascii?Q?hf/si/pPBs67L+5E/+8Qcmbi1deRubq2e6wz+sQszC4nmg1qqwaxrfztHXI7?=
 =?us-ascii?Q?IJVbl++PC+fZw6TYRLOhdOgK8r8HZFlHq6EQT7HN+fJqeCw+Mq4jEsMcSiiW?=
 =?us-ascii?Q?IcaB51u/oZD2ZrTe2m/3ho4SR8YHBpqMfi9VszLDGvw6VqpEG0rwbPJSYqar?=
 =?us-ascii?Q?ETadW+2hR5t6Z5FimLNG9W8K9nDpn48oOTXeJvKkEwObiB42rtf1yLFfffvp?=
 =?us-ascii?Q?t65iNIo2LJS5WIiJIFo135T1rUrJxb8gnZIsHcQRhagDtMiXTtxIamRHH45F?=
 =?us-ascii?Q?+z081Sr9QBD1viZMiZ5VzWqQ6ZHnCLCJ6ye6aOqXZpguSecCr29RYx3TjMQI?=
 =?us-ascii?Q?yheqy4KSie8JASYdFdQheLwJATjPy7yiKYOjL8PlmppN1VRmKqKe9R/JEpRY?=
 =?us-ascii?Q?+pBl2y662YuFYy6sHyB1dj03f6d5NK0COc03WMVmyiLEJBL8FMw45f/DFK0N?=
 =?us-ascii?Q?IeAhp0i07aWvO5VQEDI50rumTtApRUtaRrMmwF3eD5hvxT2lsURHGPbQPRyM?=
 =?us-ascii?Q?qaYCg6+VS3+2eDGCijuOOVviTz/SL5CraDBfKKN5YhfvrS0pfty42yt1wh+f?=
 =?us-ascii?Q?lGwc/SbjDWyJRCTZdRnt6f17sns0gZYfU/1QasKrICORXAwbooJlvPJs14fb?=
 =?us-ascii?Q?XUDzPNpGCCm2d5r6Bpg5AD3DxhyZX1y2bsI2miPrfRBmUInpNhPzLvo1fess?=
 =?us-ascii?Q?ASo4h5wJBrEIS3agGaTLWzkvwa4VsT8y4F3PWDQW3qC9SAI7zdbLfyyO4OEt?=
 =?us-ascii?Q?smoq/yK6chl21t3hCb/KT2caUukWFtWX0wkxj7eDy3ET8Rfy4iKRy3W8N+RY?=
 =?us-ascii?Q?q2YEzu/l/+6CKQHX32Y+FsYQoVCl2T2Zuf0GrCl9ULNK4u1EhSFkg7rFixq+?=
 =?us-ascii?Q?1FYXHIaEdzVnWI0buPcnihk3uPHUAGIkWVunpdGrbKBBv6NZ73Kco48NmtvO?=
 =?us-ascii?Q?pqqVbK4p9xKc+QsxTaAWab/SLRwU/mViLm269hPM8jycrZV3ac+CvlHA6w0g?=
 =?us-ascii?Q?e4Ko7qSL2uYGSJGBwsvjlCXtJ9ID379j2g1XGBUgnd+n5sWNn0XV/znBS3CQ?=
 =?us-ascii?Q?B9ihy2FZ7NvJn5mgOcxuWJMOVfgMew/L+tQw/HPV?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	uCASCnfO9oFUF4Ro31dpRpw8xL8fZTxNALG45T/w7MBHy/j/KMBsfamDhT2uCmPKvwwXToGme+U8jpTX+nVExetUNHBFVy1pwNWY5APVmocLsa/LJ5zioEHnSLsCk10ORvX83OdOUAOfXXLeDj94QDUM5r8qqm9N4s6fTgqXBLt9y89FiWghUTHzPRW6V+fy1qFjiqm+KSz9MypMt7kXWRl9AXkNMcXCUVFK3uR7Img1AG0wtdoQJi+oE9LZN/33bfSK/vNhf8CIjk+o4rsG+LYGBF7C7kV4376HRFMG5nn+MHrbW0SiWL5JrUKfj4trjrValQKdOg1CvTVfk98zr49ULa7gIFQldzFr4TZQd46Kt6Eok3A4b/VJIx6xFAImcaeQOhNXcaXHeM4hWObWE2EXrpXs24jQ2MqqwGa3RYUzIygq+xV2JLLHwSKMRPGVohKcG92jgAAqCJ8lz8URdfzXhi/kYO7ddrzl8wrUgc0xG/ALNiAi8lf5ETecGNCAMEJg051Gm+ZiH4BgraNtys3RtJ0d963derFayecGPCwwLSNsh7m20EiW3uIVDLSKi9kS9lzlG9P+HREGHnwQ5DU8RFVFOqD+op1CAmgyZ6b1HRYCaEUdaBxYla0dBKneMS/i+JrtguDR4X/0P+8l6w==
X-OriginatorOrg: sandisk.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: PH7PR16MB6196.namprd16.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 032597d1-0953-4713-af18-08ddfcc3ba2e
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Sep 2025 06:12:52.8401
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 7ffe0ff2-35d0-407e-a107-79fc32e84ec4
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: xI+cVe0bS+ZMw2DltF5lPudMhlDesuEe2507I1xiGOsD+HRjnxqNMJ6+Ifamb5FD1yDY6yD4SSYoIfHuVZbZNA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR16MB5055

> Prepare for introducing a WARN_ON_ONCE() call in ufshcd_mcq_get_tag() if
> the tag lookup fails.
>=20
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Reviewed-by: Avri Altman <avri.altman@sandisk.com>

> ---
>  drivers/ufs/core/ufs-mcq.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/ufs/core/ufs-mcq.c b/drivers/ufs/core/ufs-mcq.c inde=
x
> 1e50675772fe..4eb4f1af7800 100644
> --- a/drivers/ufs/core/ufs-mcq.c
> +++ b/drivers/ufs/core/ufs-mcq.c
> @@ -303,9 +303,10 @@ static void ufshcd_mcq_process_cqe(struct ufs_hba
> *hba,
>                                    struct ufs_hw_queue *hwq)  {
>         struct cq_entry *cqe =3D ufshcd_mcq_cur_cqe(hwq);
> -       int tag =3D ufshcd_mcq_get_tag(hba, cqe);
>=20
>         if (cqe->command_desc_base_addr) {
> +               int tag =3D ufshcd_mcq_get_tag(hba, cqe);
> +
>                 ufshcd_compl_one_cqe(hba, tag, cqe);
>                 /* After processed the cqe, mark it empty (invalid) entry=
 */
>                 cqe->command_desc_base_addr =3D 0;

