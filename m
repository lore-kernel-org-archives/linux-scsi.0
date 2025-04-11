Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED79E487BF
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2025 20:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744402997; cv=fail; b=TipfWAQ/MfwWE4GLfglY1A57uRN3iYV6L8gkzuUhp2PrAkw3NKnmpWl5Rs7D1iEKeFaWM4T3UrKDWN2XrCruOIKIKWC2dyaSQXHeFnFn14tOD5VJB+rgrnmEfzVSP6rW6N5GVocOp2uQBvmxhFNUUJKMN7mbxVdEkqz5apCHD9o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744402997; c=relaxed/simple;
	bh=9vgQzU1+KMxmsM4ySjJWm9GWA78eYegM1pg4XL+MVxg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=a0l+yXJy6xvADccKcA7Nkwt0KsNsJw0wR8NPjDSh8hOXJ2tycA8k3K3/8AW+sVwkIsw+ImcuPUQjdWV76BaxDKYTdSCVfwo1lehrFD14MuPvvd7e4PMs09pzyD1YdeyUp29xn4lKSNg13cgX1liS8p+ZuNeK8hZv8MoWgq5G9FI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZZ0nxWmK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=X6PAbvm0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZZ0nxWmK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="X6PAbvm0"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 53BKC0Um024349;
	Fri, 11 Apr 2025 20:23:07 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=KoRYQI/ge7HEJMr8UP
	yoU7Ygsd9Ek9MdTDbGNAoh1hk=; b=ZZ0nxWmKaz6XnHN8ZX+pXKdRp4WZLdyTIU
	labXtYuZqGwOfL1Dp7dt0g4uOy5dkns0KYk5GlnXAnEwSs2FjkV5xrN2eXhZNhy+
	gxEynW1remwiEk209f4PNIkWuLKl3/qlz90FkVIRQjRCCSOGwm8D2WuB+dhAd5aQ
	8gmKbgTES6wQwv6I4OX8DiklrvuD5eHq5EI+zcIDh+qiRRq0Kkl1Dzm7qd3OKGEa
	TrmsfzS+L9zotbyKnQHFEDOjh0e0aTUM6bkR1I7V0jGLcFLoASMly7n4EJh4Xn8o
	+2eUH4w40AGYNbPaJypD09xGMGKnQHKjKMuqMm8Zy+cGfoAUkjBA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 45y9wf00q3-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 20:23:07 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 53BIVZ1b022410;
	Fri, 11 Apr 2025 20:23:06 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazlp17013078.outbound.protection.outlook.com [40.93.6.78])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 45ttyevg2a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 11 Apr 2025 20:23:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=EFBJ+sp73ZDRhYc/pWXCie8ALs/AySvsLf6sIIKAAuUinsq51NCGe2fXPFYxVgkvTQ/2vSdZ9AFz79f6WjcW1quqBqfCWLdpHlml8guphKKQ2gWG9/h6ZoY7gt7OiGEYLcw74OOhY0MDB4VSImjZd19SvLvlZx8RvU6/dtWyCjWGsTj9AW5y3KEhhMupjhE8epBSSaNqsmY/K3POLYuTs2pIWpw2NAZL7orHWrx+LOWF9Wytpft4XOBTIwcsKASQPwIV7jaGDP1TY9Gi/ySkqWqaZf4bh3LGWR4lmdBG6miCs+OwyCIx8Qie8pQM9y1ORLlAvXhJFd0qenL4o2hQow==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KoRYQI/ge7HEJMr8UPyoU7Ygsd9Ek9MdTDbGNAoh1hk=;
 b=e7iXDqmgqmATtwXWlj3vxmxC1cvd7gSD3WV5dWZAg4VztE6VFEwoO/8W8aJjT5uL8MsuAdwc8MqBDJfOZlk6jSvaNwljA1ZPXbG79fSgnjzPhhRSN/347q1i6Od4o5PRsV+gk3kwbj1Woy/sLyQSXaYqNtpojZWYkGmm7sX4XZCN8dv/ESBRf6GwjnMseWT9uiusecELrjAWZC549776hnRsh7peybfbeUxBzPeCStpsjGFyHYOdZ+i4v3XfZ1Sy1bDlqeV9IaTLMZoUWFXp2rLOfDQTDfc0EdUnm00z/0KJpPPPh419HmhZsWcFW7VvVRrd3Fujg/zUHA0iIb/9Ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KoRYQI/ge7HEJMr8UPyoU7Ygsd9Ek9MdTDbGNAoh1hk=;
 b=X6PAbvm0XuKUJE58L2E+5TgzSXVdK+O/zbEqO62j9elZKRKNqRdTUuFBBgfokto8dAcTB4reqs8H1W2jNQe6J0ezmY3+2Sj528PVO9q0zJApq/22CVCLssWLTmPkMHrgFw/dG/eytt6s9aLuwTb0fMDRIsQxl2P+HbjBxq8CR9s=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by IA4PR10MB8543.namprd10.prod.outlook.com (2603:10b6:208:560::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8606.36; Fri, 11 Apr
 2025 20:23:03 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%3]) with mapi id 15.20.8632.025; Fri, 11 Apr 2025
 20:23:03 +0000
To: Kai =?utf-8?Q?M=C3=A4kisara?= <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org, dgilbert@interlog.com,
        martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com
Subject: Re: [PATCH v2 0/5] scsi: scsi_debug: Changes to improve support for
 device types
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi> ("Kai
	=?utf-8?Q?M=C3=A4kisara=22's?= message of "Mon, 10 Mar 2025 17:55:52
 +0200")
Organization: Oracle Corporation
Message-ID: <yq1plhijvo2.fsf@ca-mkp.ca.oracle.com>
References: <20250310155557.2872-1-Kai.Makisara@kolumbus.fi>
Date: Fri, 11 Apr 2025 16:23:00 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0046.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|IA4PR10MB8543:EE_
X-MS-Office365-Filtering-Correlation-Id: 2dec5505-dc15-48c5-be16-08dd7936a957
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fQNqm4BFMMqxmMVDI+b4P+X9xHxGDkxprJMKmL6WtWykr5cqZB5UlX+XP2kx?=
 =?us-ascii?Q?ze1Qlxigj8YG6rCKemecz0x3OFC/V4L+tCbzwJU3KOrKZsESpi3DdycvDTPG?=
 =?us-ascii?Q?Zsy1JJB1H7LrkN1wUkzMwaU1KCAl02uzmDaN+LAOjDdX2oEwGedJQ6WJS9X/?=
 =?us-ascii?Q?i06hHolxn09vgTWEVu0Y9uIJrNB8lAtT5DaQU4gmPZbpoHe55x0dvff8xRFN?=
 =?us-ascii?Q?g0f1Er1Goz0Iv7xCds/cyJLbaKdPW+DncuAVcZhd5Mua447qvzR8cViiwYzD?=
 =?us-ascii?Q?3X7b+qoYT7PdcYd4AJsN8oKSwULJic38jTf7ecGxRKpttDrCZmIMVFGAHSEH?=
 =?us-ascii?Q?HJOUaOtJ1T8pmMPwh5gBtSd54aD51DNABhFDzmS8mqzUlAx20OJx2mxHNBFt?=
 =?us-ascii?Q?6tqiX1aQ6biKxo7YteAiofVmIkwc6SvaEcLPqxq8ivn0fwN5NgUnkGKCv69I?=
 =?us-ascii?Q?tibGCNHViAqNQSc/TNm0LxqTZOThXd3p2tRa+z/XbAsyO01NXHpizJvxi61o?=
 =?us-ascii?Q?3CsWpziliEd5z+k2Ol6YqtAxHdJHquSvauuN9aFGqt+MgXwtWiyFsMHQO8tP?=
 =?us-ascii?Q?STAprltJETwFmCL3jzsHpjc/vbLuNyqUTKk0dqFKVgwnr2wL9jpqxrIk86Vo?=
 =?us-ascii?Q?jeau1kkJaHqOVJoFLwmjrxO4vX/tjURntcwq6JgHSxIp5NjdGlMwAF3dkhY3?=
 =?us-ascii?Q?w3I34T+Nngye6ZQPoEwINzSkMV0pvvWjBxinLXPCyz5GXsMd1p5SdEj4YRJe?=
 =?us-ascii?Q?OI7Qd+nrUowYlZJDHmMuoDGCSaL/s5g482VsF++nIXIecrREiKJdwnZ1O5Oz?=
 =?us-ascii?Q?dnFCzDmaBfe2x7CeDqWv+x+8gol9oxUQPG08ZUUaY5PLoVdrRrZXHaUD/tqj?=
 =?us-ascii?Q?+ISd7YB3SXLq/91FswQIe2G0SySuan8gru6vakUpD/xYU7f6vFLvceu73ML3?=
 =?us-ascii?Q?986TJneaVvjuI0Mj8G/WAKZN2js9N3VCWyygO7UkBUQwl4O4TbkFxI4wLSaz?=
 =?us-ascii?Q?LnuFwCDIHWzqTFFPgG0h/JHN+MQIy0pjCg2UXRlDlvRA8dROEQa+5dsDvKzY?=
 =?us-ascii?Q?dncOeHw1hczSrA9iqpdHrFpZGXegIQxj3kb2oGXJQy9XuLAGSxm7FRiI2uCD?=
 =?us-ascii?Q?sazbbp7xjW5Ela9rBys0lxzNY2nA3IvoaD8jE3qmF7r4/qhRrmjcSVvjuTXK?=
 =?us-ascii?Q?jwkM8R+IlUGSjnyLUOqLlwHIdODlo222DFDmYxHYxxtKOHq6Pl1sh8GcevFd?=
 =?us-ascii?Q?Z5xvvVkHmR9oyMcYpCY0vzlGSvWkKUkCTz93k9jjZBSx2QuzYtx2SeOmNsGo?=
 =?us-ascii?Q?zMcVLpTv96GM/p5f5OGKB4ecZPEl8SPvGWNVUx4o4e25ZdrV1VpNhM9kjD50?=
 =?us-ascii?Q?YJjziKtzUB10/m8jvz9ZbBKrOeEiUAoAnPkA/2312dJyQvKsqlAJjEEHPeYE?=
 =?us-ascii?Q?JdwpPcVACIg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?XkMcrjei3gMszJpobAKKeiWxgyUXwOM6eP2UIAQVu6130fgZ21pu32M5oLPJ?=
 =?us-ascii?Q?n496/ZlH47bYjB83OxKzcZNlGyzm4mQYC2FuvB8dxZrXU5sepzoiicSSymt7?=
 =?us-ascii?Q?J0b3l1phWvZ1MQm64gLMBv+vbQMPhuAmu/Ly7RuyPR6wzZLyJpxWq2jxwRmc?=
 =?us-ascii?Q?u8h0kJ/8QgBp6F4scy8YkHvWjsQ9X+A98uU8/BgEF2xucrixmAzTqlFbU+Jj?=
 =?us-ascii?Q?OSLc2vLVcAuznHuGGJcjl1yrO86L+wA6Ud0cIf6IPGBffd+OIn5PFPqtxuYq?=
 =?us-ascii?Q?jBvuHI3Wtpl+hjHAT3t9sCPltY5M4lknXIgFTiH9KjcSocR8eIEUNnvSDrFi?=
 =?us-ascii?Q?H7i+nX+nBqD1yuuYQx6Fv0t9cfZGk4zKnEWhTVdCVA6jmV3Vb+aVx5sI0h7M?=
 =?us-ascii?Q?lDSeVhvBRfwOJTM7w/Z2BpqxLB+yetRdT0I3vOjqcYXxteiBuxERjTgeZDO9?=
 =?us-ascii?Q?uybzZaN+iGe/+a3Ldl9crX5GChKwUHKThV9DgWnGuRxuUBMNapLFPv7AX6T9?=
 =?us-ascii?Q?iH8g+ECCoVWDYgnZBoy3YnaSimJMXkWXMhaPwY9MJhvHdG9QbXYFW0jfsyti?=
 =?us-ascii?Q?bTiXdmGr2IJUHzV7jqkSG+SE6wKYzB2hBevZqT258px8CuV2y3/j2VMUtcgk?=
 =?us-ascii?Q?lhpo99Sifyu58vBC5tVj6SSlNAQMY9Lu8wtlbNbttpChJm2fJd+qYMd5rzll?=
 =?us-ascii?Q?eihX27Nzfjr4ffpoOqs4kk40HJXxfUZV6+vwClwJJOhkstirFtzxNaJw61Bl?=
 =?us-ascii?Q?6kyT+qE5XP/4cJCTbxqF2YlvKpTOcepXDZoXApcIuN7GnAekwMX0x35Ev3+/?=
 =?us-ascii?Q?gnllUQkOljyiCvt1NTHSrkQ1ixXRjgeSZM4lvrSyz3U287L6EB06aPYXm3Zd?=
 =?us-ascii?Q?d9On5TAM56YskPCvd1+2L10p6hBqyWDOO7q2Etn9pGAG7Bc7SnmXH95o0s5E?=
 =?us-ascii?Q?37Tu+cShslK2VsueWPQOz97X1qyJwILUOw8GWlS0MBZuBGHJw2CdUzvOlZOl?=
 =?us-ascii?Q?BJE+RTniw6HXcuCuddRz7MeUbFH/IfentVq8itoAoel+DyAXuJr/lfSc9ZLY?=
 =?us-ascii?Q?l0Z5IC+tO4sTZ+i5GNfnDv5Dqan4yU6OT8iwKghoRhn+munigcNzY9cMEPRQ?=
 =?us-ascii?Q?51LGgxC9VZ7iL7P23eWt5N9cViW3pT2jpmwm8ao9Lh/hSdYeYAoiHCS90Qjo?=
 =?us-ascii?Q?XtFOiSdckse/DLyo9TxfaWWJ4oU3BwOWxDEZovJmjuxhBEeIe8CI8LXpBBzF?=
 =?us-ascii?Q?Bp1LL0YshniAXaDnYUnIRVaub8xXsah1vAYujlUhQU5ZctUMWMLOuit0/S/S?=
 =?us-ascii?Q?RdQZaI7Jzv03Rj8vJ3AFw1cbnTrTxE33rrqITjgPuw/q3t4HIMd5RyZ/aTXi?=
 =?us-ascii?Q?rc559GacpYOoHZZ266ev86rN6egIIuDUErm++7maJe8oWuShHZgfzt8UTrfs?=
 =?us-ascii?Q?XzTkiJkhgtDMyZewb3F/qaI99D622Jr4EVh65+NHlrDxGjIHybMMBRpHoLsC?=
 =?us-ascii?Q?fcutTbBPEeCw4NqSenCi1+6LusP0H/da8M9u26l9bJJHR7mhkK9YtR2UZumg?=
 =?us-ascii?Q?byCsk34J5FkQTVz43M/hAGYG6IieW/uhxJmhAI1znClmy1Oq2hAzOaS3KxDK?=
 =?us-ascii?Q?Cw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	LqwbDp9Usle66xs6U8+tC6UOUf90CzKTZsc1RYJmqP4CKH6/Zxy5GqngwcaR5HWpsFM1eL3ydX/sZZrXCR2Dfi9vMEfWfR8iuQV/6qpkQCCN4sAvADlRI7bvHsSCgwd5A8V2/yWoll8nRtmL4yk1lFaZLNZyq037e6dLhyxNpdm5SLClsMHHDkOIsbrb7DMJbCf4tg0VsdevahFE3RQLcL3XzFkmhPh7RU2OJkPsJ+ww4tRyAaX2kcwO+JvxGIcSLymBFdFdgU7R+G9jGQQh3smotebrdXkmK0BrM1igQnFn/njMxiSwENGWo2+NXcQcsbZNZu4goyQ49yb9X4cNuQnNhBl4qVkA1e6iAymFf4XYdpZXJDwifUVZbs0HHgnWh8+HKMfr4fvPdS4rAKpRnKWqu+ROeya7oNkni/WBGh455/0N1S0o46aZ4YVLRE4Yb/M64B82MntD2f6Fi9sij24N230yWajOFWblK9zETcilZ6koXPwH5vxABd7LZVi4PRSjeHaOgWecs3op5+u3OF69wSSaPRhfD7FsMwsflLdozwtEk13SDfZXGtkj+bVKtk26GbBxFjC8PVNbVg3biuozvDYIornTNYHSfDPRLDc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2dec5505-dc15-48c5-be16-08dd7936a957
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2025 20:23:03.4918
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JkYEVghtiNxGf79hM+FE4TK8XLB/8AGmh0ofXo9lEB98JQTy2cHp0HEfaKf7HJ0Ucdr6NM2Igl4vE/M1+VzBp0scFccjzLo5sUeKBH2/4w8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA4PR10MB8543
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-11_08,2025-04-10_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 phishscore=0 malwarescore=0 suspectscore=0 mlxlogscore=871
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2502280000
 definitions=main-2504110129
X-Proofpoint-ORIG-GUID: 1YP2JGjo6GnO2jIRkE7dVdSMI_TQCihq
X-Proofpoint-GUID: 1YP2JGjo6GnO2jIRkE7dVdSMI_TQCihq


Kai,

> The patch set includes changes to better support different device
> types.

Thanks for doing this! Applied to 6.16/scsi-staging.

-- 
Martin K. Petersen
