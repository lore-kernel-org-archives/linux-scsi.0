Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D768B28DC4
	for <linux-scsi@vger.kernel.org>; Fri, 24 Oct 2025 02:59:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761274801; cv=fail; b=NEkMhpE8ZVrbQ+Z3MSfABcUqknhoLGCno6Zr7O9hl6tY6FvFiF/cQEzkpTFM52b2jG2lqgdyvwemmdKZWdfDThU42cLCjVhj01m4HKearVwRFkr3HjujNNHlDebJht5E21W2D3AF3/g2k6GWeVh9ubW7VM398azZhwtIgv2sq5U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761274801; c=relaxed/simple;
	bh=k5pDdri6locilTLlHx6ESyL6Oh7HKAOXV+hwF6g5jYg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YGI6brYJqkrAu6rV4XcUGxNq9EFs37IjCKF1PAoZnP6T62KnE7hvZrOg4IT6XAg+zZ8bC2E2pYLzN0WUY9RqIBDb05R/5tIbzqMHkr1VXDR6id1zw88evdbVqeiHIm69dD0vyVxYCS7STq0LsP2fvJN/4x4gzvwbnHhQZ7ZubNo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=rr/e8zgb; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OjgPQzNt; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="rr/e8zgb";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OjgPQzNt"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 59NLO2vl021066;
	Fri, 24 Oct 2025 02:59:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=7vVfR/DeQNKeaq86i4
	6O+CnllSNJ00Pt26IIkwg/QDE=; b=rr/e8zgbkaCEzsQMjlBAjvhwlRB2SJz5Ow
	uBlUSooKU9SZSd0t2mwLY47v7LNYhAhJYIp3slmWC1JjaA/Fe+ccHeGKmUhMZlaL
	9upr7wD8T6DvKKe7sE4UbFOMVMeFV0PA7OJY/zjmhrEZT5wbbuK623qmVzy3+LGk
	Svh0Yh7gjQW47wTumQtlOjkwA0CqvwpYBe9jBoZIssDp9/E0Vg8z9wobn7sqGzrE
	kebH9NfLjKpdidzyp8PGulKxzWPSiOKEErjI7arGjYOudjPYy24TFux54EQR1ug+
	dWtjY6wBWNxGCyypzomPp/aLntoka2cc4sdc0eeyQBo0Gypmn6JA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 49v2vw32rm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 02:59:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 59O2WKJ7012459;
	Fri, 24 Oct 2025 02:59:52 GMT
Received: from bl0pr03cu003.outbound.protection.outlook.com (mail-eastusazon11012056.outbound.protection.outlook.com [52.101.53.56])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 49v1bfbmtx-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 24 Oct 2025 02:59:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=jOZH452pOk1ZognLMn/tqPXGQZOK82Ug2Me34Ys3ueH25CLBfvtmVUWFPKl2z140LdKB03xRErkeeM+1nnSqwM4jIROdJw2TxEChOuX+ZlfJFyGkKIrC9R/qdvjFpRcGKbScNQthKHbERdkCc66fdEKLYlG10SuGsfidJXC1Swz073GD8aM1FaZV0SBoENf6GqIjUz8ZFKwTgOaeggZ3YWkGhnXNVG0o5ZYtN2GpCRkDVk2AXo2eWTqOGA9O6LjwMxpsN4SssuzwpU7moD2IlZsVjlIUfK7Zxr8D6cxNW7W1FBgomDOGfJy5I1u3io8LTkqdhelrfxoKdjbil8GpBw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7vVfR/DeQNKeaq86i46O+CnllSNJ00Pt26IIkwg/QDE=;
 b=QqGJncv08h8kYPjrow6JaVqhBBWTurlZGRE16xeWZrmYnbVh11qt4WN/lS2jWSFo30GsVbrs7pcszB8gPo9bH/SLQWt6AH1Ngey2fcM37T7nTjMkIJQAu5ERY0kerGwlWpwGoeCekbHhWDRFG0Q+JztEpGS40ZGnY93rR5A35oqEJM5MmqElnupJUvoMSfJNhFqPbLVId7DzLKV0LlBn5OE20W4oRl1aW7sZV1IEj6WtrCFjFrvszTbltTXsbVhnJ9w0EUaQCyoHR7LM8H1Z0XjSVfVwExVZZA4CHCW9fRSt018GJc7AFpRZ/EwaIFIP9LW1nxirE+MsOgOKimpFjg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=7vVfR/DeQNKeaq86i46O+CnllSNJ00Pt26IIkwg/QDE=;
 b=OjgPQzNtyIFMSVKAK1EowXoYN5wTqE25QmJwRAke+MafNQcpD7eboTZTfQosuXwdiPGRG0Xid/8AD63HiHiRsFu3tFigvedwOtdLxXpYCOxyBqZOvqW2RkEWPYz0qKaFbVBlYOnKh/EnBKAu2TUdDUZDacp3GjJ9BN3T9KJycmE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB7512.namprd10.prod.outlook.com (2603:10b6:8:165::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9253.13; Fri, 24 Oct
 2025 02:59:49 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9253.011; Fri, 24 Oct 2025
 02:59:49 +0000
To: John Garry <john.g.garry@oracle.com>
Cc: martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, bvanassche@acm.org
Subject: Re: [PATCH v2] scsi: core: Minor comment fixes for scsi_host_busy()
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251023082759.3927000-1-john.g.garry@oracle.com> (John Garry's
	message of "Thu, 23 Oct 2025 08:27:59 +0000")
Organization: Oracle Corporation
Message-ID: <yq1cy6dxaw7.fsf@ca-mkp.ca.oracle.com>
References: <20251023082759.3927000-1-john.g.garry@oracle.com>
Date: Thu, 23 Oct 2025 22:59:46 -0400
Content-Type: text/plain
X-ClientProxiedBy: YQBPR0101CA0303.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:6d::14) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB7512:EE_
X-MS-Office365-Filtering-Correlation-Id: 45a437e8-b937-4cd0-3e85-08de12a9654e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?vFtKSEG9I9t3x+BA+xzvgDJy3bh3Mt+Go+xIbgZmvqSQAWxX0cmMdBYiSUNf?=
 =?us-ascii?Q?Vh0cCcikZsf/7O6r3YlAxPRQS6Cj9cfOPFB0GE32UInJ/+VW41IzgbUdbtNC?=
 =?us-ascii?Q?ykMYVS7j9agqW17VUf7EiY/fNXFRZvUoBT8Bi1pUWv5Yr4eU2ViR6CZH6p38?=
 =?us-ascii?Q?F1W5Hk8vRGa/FkhT60IQ1MUNmKMtAa08buFztWYfk3xq4t29zTM9DLLpHgky?=
 =?us-ascii?Q?jNLj2kzkk8N36YsmatdfU+LaKMn86sPirO2q9LhTQB0p7hXo0X1J8iZ0af4F?=
 =?us-ascii?Q?JPenHgdkIyon1E8hYkKFIm942c/ECBQdy/oZlWsREchrPMa01kss7a/knjCS?=
 =?us-ascii?Q?TYmPxPIjEyWZ3k9YSh0gDOzTV6j7TcU4bAV6Ycxk581NiPXmcDTyB+6TZiiF?=
 =?us-ascii?Q?1ZIOSI5q1gP0ruperu59ZxbNJxLjfU0rZM1eKF7wYrOW9b6+haEh8WFpbWFY?=
 =?us-ascii?Q?ochV864ku1O2+LsUM2ThT6cH2zDKbZhPf5CjLJVYeX6mWBKtVZ8eji54mB4k?=
 =?us-ascii?Q?2Nc3owPZge+59uUbFnoYgrKmRnsAOMtSNZydYHKNqwiHqyo3g+Tacsrq3SKF?=
 =?us-ascii?Q?XNKLZgIwwUV3Vk8CUqV1xdBHiW72GG81oOWTJEYxomUQ8QBz880CcSUqjxQD?=
 =?us-ascii?Q?ZFJvr3LrLP3b93342xgV5w+mQ+IGtfQCXaLzejChw4IlfpY7/1RtQ3P6o+z8?=
 =?us-ascii?Q?OXCVTxieURwJtW31cR4YGcVTuPXmDEDYsrldBXgjgjflDgWOXbNiXQRApV0e?=
 =?us-ascii?Q?flYWErChIDLLPju/g3E+CkqNBlqpa87B/1gjX5IXQikDWWeSbRhKBJkq59c1?=
 =?us-ascii?Q?tXkfFizz7AfkB5f1sdQUXxXPCBI0YY4Ya8acSPEqMHMt+x5BM6r/3YGTkUTD?=
 =?us-ascii?Q?IQ7hbog1sFXFl+zEuy//sgAjoa9nREHcBZ/47g0+1IJ4UvMV7Sk5Lx7qA4Zp?=
 =?us-ascii?Q?TdKv4jWgDhNAqw72EW8o5EMCyvuMEhcRRj5fXvsoZwJk3l662c3DALvKzg/V?=
 =?us-ascii?Q?Md2jx+6hzurngytMxSVUaCDao/JUK38yZceBIpuG6gnmHdbvxqNAbupGyjz6?=
 =?us-ascii?Q?WzY2z+cXhwnVhJUQBuTfSt8vOEnPDO1Tc9lyGPxrzrHRW07ey8dPZq6lAn4h?=
 =?us-ascii?Q?t6MWoifY0zCCDuGQW80o25L4Q9k79O2t/eE5Mfr0WOuSMRUjSVO6it/kSCe/?=
 =?us-ascii?Q?YT53EcgXvu/EwHWvYCgAWDteSYt1zQzQ6ic3brx4Xf/W2BXd/gJQ0xUO9E41?=
 =?us-ascii?Q?7OlfhysNbgEH+xBn4OO17eFX8Z8wLlNlYSUWQS6I48+YCif3jweMgB+b+tho?=
 =?us-ascii?Q?z27df5DINJb15IiRD1ILt2FUSakQdXEdOqyG+nPDRodyOzc4aJfXFksRy6a+?=
 =?us-ascii?Q?krQWBazv0EtXTF1RAprK9nMVSQSAxSTTqJHjMlcG0kslYsZOCBOAiTheKmS+?=
 =?us-ascii?Q?JXufLh4qWCYtgwe1Im1x/r3udHJYOSau?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?aa9/0JgKznr0K30AqwW9Oxo3Ts7PkLYW84X3KS03l2wDMAQoOoTRphsOVw0U?=
 =?us-ascii?Q?RRCO7ZRIVHIoY72YbhTBLU4FgBrrbZ/8p/Jp7HENh/LW8BmZ5/khL1s4ucST?=
 =?us-ascii?Q?lRgcuzs19srdNAlbfe1kujBQLLTKek7KuLsaCx3Vjc4J+J54ZpOWV0TNIBSh?=
 =?us-ascii?Q?QGqhBGMNg5Z9F1jXiApwKTCGL5uiJNF63fFQsirLowXGRy+Y4hcdIECXg7B4?=
 =?us-ascii?Q?QJk3jHGcCL9JfVJaJ8AbjWBuW6QhZq8DL/9JHZCQdh8m8bQUVX2PEj5nHbx6?=
 =?us-ascii?Q?l4c+eNQeKxMSE6o9HWX7jIyhG8hy0E+OP1XI/P8yr2TE+8O92f8u0BGBTMca?=
 =?us-ascii?Q?6Nnd0fL7GqeaVVnzl+8tdx2zSv9wWcrDjPdnmGDsDhDnRZU0rqqVl+x1x20K?=
 =?us-ascii?Q?RZ1TGfuE0xcLCo+BtSn5qboJPpENDs0W2Tu6De2Wno2QS5XgnI434Pgt95kZ?=
 =?us-ascii?Q?Qs0jhQIoVHrHXtvL7YGNLvO7/WDY2mlKJCzm5KOvQNdu7nAZI3JG/D0KAVZc?=
 =?us-ascii?Q?f1IJwLbdSpWEUJ94CZeMzNcbUbDWhpQK2NPtru4BV484a4K1N3M/vybHLK7A?=
 =?us-ascii?Q?bkPJ0tYeP4TZQjm8J5fByUGaWaUZBZtr8/rUY1tymNeDGvdBwFSG/aXpXM37?=
 =?us-ascii?Q?ZqQHzMcsEAcBB5i/9yw8uVNqVu98wHEDYtk0rHisupWKEGe88d0STWwL6A7U?=
 =?us-ascii?Q?hGEvj/z2IDXnS26Ng2dXcowGE05MYfcFcN7wnSEqCoostw+lFFsg9qJGa14r?=
 =?us-ascii?Q?iBAbfg1QCTaMH0WwEFNN8Vgeq3pTbmdXOAr8NTBkBRobWm308jUR8AX+eaaD?=
 =?us-ascii?Q?wLPUf+1nZOtpSqXCcKZECXvD4zBA0Twc1anQdrdB7LBi5najIybdqrkNeW3V?=
 =?us-ascii?Q?F5aW95BfVLgi+nmz8k+5NhWz3HbeFpsPghFeMAHBRTcQuUnio9NbOSOOiPEp?=
 =?us-ascii?Q?qxsxvzD4x5vb0OlV7yjXQ/D+rifdRxzWX/c2WrRT+YHSxAi+T8+e295AHQvR?=
 =?us-ascii?Q?2eUY2x1AGWyDshvNXcEjIKHJ0IQwJmydzqiZEz12WZzt1r9c1ju/cj0smozJ?=
 =?us-ascii?Q?nq1pbs/Yby35LcOX3DOOLM7ioXZrvTxFypXJu151n4T1HExdc64fwENT2jVZ?=
 =?us-ascii?Q?Fctajr/AX06KZCOF5yJx3PYmhO5Z3QhxbxrxRpsxk6rL7JRKvnI6Bp7CAQU/?=
 =?us-ascii?Q?lD30MldZJ+ksCmjgeWILruG/SMQicKIzBFBp8j9+zHafFRiIN3xPc+hdZWTt?=
 =?us-ascii?Q?85orV5bMSQR4HAabGuMfi13xdUyZ8MyDCyk5WE/qSiyvuhIfCVKNAmIBHtYI?=
 =?us-ascii?Q?888HdlGRz8cYPcMvqOHQYJmXYzbbCny3iQ/vzTOr98kT0WzDO9PykvtF9I5q?=
 =?us-ascii?Q?5KjabuDPoOPz3+cERQxFop5DmYe4PtZSo8ThBPVpHJRJByPG/Ekw0+CEwlgI?=
 =?us-ascii?Q?OybRG0r+dqVU1kVkmD6uxJF8thAFm1jN130JfjrWdYASuODhoccpXZlL44+I?=
 =?us-ascii?Q?4hmWdc4J36XOV0xptPZuL8V14iPkjTUm6vMleQ/N8hRYniBB9zaO3qfOHN7p?=
 =?us-ascii?Q?VQHEHED7ptlpEsbZ3VGPsIwH9AB1/EmljsoKgpTFP7yNsPY/CDwFl6fQxbEK?=
 =?us-ascii?Q?vw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	Tyrvc1MMSH1fYi5gbt86cx1+M0E49q1k//ZCeJ4bGRrUM17cjGrbORRMLzUWD/i+zBspWwaMrCNsC+OxFlikrVWJnl5POLaS6m0K9DaN7yzHxY24OnMph1QnUX4ih8SmkpOGhokzfiUmeUxa/hldabs3NmTfr6HDLk70xvpV4YdhUqxGIYn1tT0kLr68G4ArISHVgdiBw2Wtp5PPpE2KGlvWlwhGwf/uTU/MUrREMYWaqsd7dvQVF1B8vn2U6vkc0fwh/URnLsQ/cP/xueM/NsSZBqfQg2HFi2vzqDntgyh/buc8+ysaQf1PK1GrQ15inCrnwkO0JWGFeStTUMdRoukDfK+CcGCoSw9z5G6MYaKrGcYqhlFPn9kx3Tk8axCv+vF0sWIO1QTThwTG2kBMe/PHfMb4Jnpkz0eBlmPMiUNK/4T+YLSR0Tw18HghvAUMGv+wACN8wbd37qXhagElS/dTt15QzY3VutUyS7gPn989YuvdGZBBGhnc0LvymUjnmgp9eh89zgQLbH9HsPr54ZQHyr4ewe1IFiPpqoWEEMXFpNdqkiTiwkFyXmyEHlN5F55inFS0JgToMImq2yY63OmcK5fPaDIiQM2tgNO3Qm0=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 45a437e8-b937-4cd0-3e85-08de12a9654e
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2025 02:59:49.3637
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: oV/0/TLoEpLe3mmDWJoK8xiOjo4V/IAs/nq0Otf2nhjnTB5+zr09bnCWr0fH694O+Dc1kFpuPruLdGqw//Lxc2bh/l8khZFB6fhHdSCb4eQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB7512
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-10-23_03,2025-10-22_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 spamscore=0
 adultscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510020000
 definitions=main-2510240026
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMDE4MDAyMiBTYWx0ZWRfX147rzca6aOqH
 hA3h+nAByvWTtyVxtozOzGGAW5pLUt9iE2rJHS7QVSr9FK8952j4/dxwfdr1e5EisQg8Q2tS0+b
 luVhmgzbV2kh67/0K6HJxjpr2NAferbvArwZ66gW0P8rmDMrO9yt6JyghyBVNynn1PDMd6UfseS
 AupKBMhy0R5DJzWcCL5g88z9f+QyYocpFqJs6QNTy9IjNSNw0aqj7S0mqK/7x1uaMVpAIWjfJJq
 +lqYtprzM6UsIfK4DVwEIxPR23R+Yzejt+Ic7vLBwKAYpeJeZWwPH4oI28djzQHn4AtxSGvPXBG
 REAawNFxLCKo775RkugutX/9T9IKtP1xgnVlAgxbDKdkX5Ulzadnn0YuCg9ModzEKQ3dJacQdu/
 W/Kw3o6wddxs/Jkt48xyX7+RlwB4rQ==
X-Proofpoint-ORIG-GUID: pGEe6t3iqMCyHq1eZLKL0a_KTeWs2W6i
X-Proofpoint-GUID: pGEe6t3iqMCyHq1eZLKL0a_KTeWs2W6i
X-Authority-Analysis: v=2.4 cv=FuwIPmrq c=1 sm=1 tr=0 ts=68faeba9 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=x6icFKpwvdMA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9


John,

> I guess that the @shost comment on scsi_host_busy() was copied from
> scsi_host_get() (as it is the same), however they do not do the same
> thing.
>
> Also drop reference to busy counter, which has been removed.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
