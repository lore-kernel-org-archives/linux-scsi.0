Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BF5B303CA0
	for <linux-scsi@vger.kernel.org>; Mon, 12 Jan 2026 03:03:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768187018; cv=fail; b=tk//3mUwfmrtuf21/Xwm4EyCFlJCSDuqqpDc/6tC1ZV50wupTV4pbqG3hx8aC0VKUgWnZwKVTrqg1QdHSebThCkQ9ty7ASrGXVoAKqYMXK5cOMoA0ioabQQaNpYQ4E8D9jSVHWqJGIEedzI/gBB+Pwk3XsjimbzJvKBz7nnHQHA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768187018; c=relaxed/simple;
	bh=C2nn3wdxqSVPmo4lf93MrZZOyeHTx82aUw+YBUgk3TA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=aSP+Ho0HrYTaoleNKKpmb6ouergHdaDUxf3OZix20ikGuThwsZMjiyRkEIO6ppfk8z1TSBisG2KfhfqKLuPWZcP084HgkXNOHXy46e+YAAMfnXjO4edtZtigXslKQUlEqAd3NvvOZ0Fmn2oKT51KHTBAj6k92ZVh/hBLe1/CkLs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Ej9yV4Ah; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=fmuZJLtF; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Ej9yV4Ah";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="fmuZJLtF"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 60C0AJWf296453;
	Mon, 12 Jan 2026 03:03:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=Xb5Hzl8Z+IGgavONFS
	W9cSCYDZw6DV1rzrLGZq3g0LA=; b=Ej9yV4Ahzoa4nWC9Od/yepp4Au/sYU++zl
	TCkD8Yof2sjMonEsvUxzUtTAQMg1zDZYobC/HcqmjxUxW8EntYueatUK1OPKI/r5
	AYISD0/GbSvd+dpL4XuvbAymqjZ0DCkaQo+f3rNpR9yEokRDL7LYVLPWPIQb7D8d
	m53oTiw25sakcrhrsMcWBxl7Ep1AKSzVVYqGcHEVIzbvHE1MXI5XO8LFe4LOZ4nh
	EWXQAg7Dn42brE3OMHBf7Urh55e/cxiUH5nqPT/wkbxsynVoRcH3/bN+G4/JivO3
	CWWLGu/yy3a0SFicZnedGXB6LHZc8pH3wUYI4W4cLPIFHhZ85RTQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4bkh7nh423-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:03:31 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 60C0OtWH001838;
	Mon, 12 Jan 2026 03:03:30 GMT
Received: from sn4pr0501cu005.outbound.protection.outlook.com (mail-southcentralusazon11011008.outbound.protection.outlook.com [40.93.194.8])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4bkd76wakw-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 12 Jan 2026 03:03:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=E/JPS4IXWYzY48oKAlVYzS4FZMhKTHYRkQeNc/VOjF6lIhGnbN3gKI5ZGnlNoUVQhgOKI0IZjz0OxfCF3a7QTa/9B4xP+dDs/b4IJ3aBOCO6jZ7/A/UbJopV/vi98dwcqPsZ/lmHK2TgHqW3iMiZpeO1vdo4IGFXaU50+MzBNkPPSBRuRNE4Dlk425m8xtpHqShYCrnx9MP5C8HYa9CGlDLkWM+79A0voOLhlKBzUZeRIGaT7CgLNJeFkTcaB1DyMGIYQztlOODol6+v5F3rlzb9SnXuisL5B+Bam9eLURngTyPSFG0Oq7v5KCtXuIegmBi6t9AnNrCume1zBqTkCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Xb5Hzl8Z+IGgavONFSW9cSCYDZw6DV1rzrLGZq3g0LA=;
 b=kgQlbfcLa0CaoGSmwOOmQZvD+BFII0cOChrjO5DyEZssWUqudc4o66ViT7DtVJ2ezve5KDunbij4B/GZu+y3X8whIgYJFWlPyaOFeYu3U+UY/ooimks1a3JN15qdXlD7h0kYw+QX78HcheUhwFqC/Dfdx9VT8E92eqX81+BrjrYgSSatIYOflKliGNEsGzxK6LbBA459d0FtIAXS4p+dqJ9elLNrNBB+Xzekk4QuHiYyua8EqajmCC7lMDhkvtWff2VsbjeO22tU1ASPDfGgeZsXy6aMVWfoxOhDdtydWqtfhqMrFtBL+Gecc0+EKjoVK2unYky3DndOs6eCa1y3Jw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xb5Hzl8Z+IGgavONFSW9cSCYDZw6DV1rzrLGZq3g0LA=;
 b=fmuZJLtF80sy+ZNoHre7GHa8yq1DKvej4jbqTMx9pIlUkbghpv6fV51y/ugbW2qgnCxF8yG1XnxAFhLtSyq99samX6wc+UYOF8YbQE2G2qm0UXDAcceSxOJJrGa2lJGQHlPxdN9yOvOZEyLXgkKYvIVuNOcxKdwsu8+V1fjL/ys=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN4PR10MB5558.namprd10.prod.outlook.com (2603:10b6:806:201::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9499.7; Mon, 12 Jan
 2026 03:03:24 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9499.005; Mon, 12 Jan 2026
 03:03:24 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: mpt3sas: Simplify the workqueue allocation code
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260106185655.2526800-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 6 Jan 2026 11:56:54 -0700")
Organization: Oracle Corporation
Message-ID: <yq1secb4jnv.fsf@ca-mkp.ca.oracle.com>
References: <20260106185655.2526800-1-bvanassche@acm.org>
Date: Sun, 11 Jan 2026 22:03:22 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQZPR01CA0188.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:8b::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN4PR10MB5558:EE_
X-MS-Office365-Filtering-Correlation-Id: 4c0ec524-48f6-4687-10bd-08de518726c1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?fNFtlEoIZhyioTOLijMrhZt5B1dfK6QxqCsAPy+FiioKQNF5a3yFfm67K52s?=
 =?us-ascii?Q?m5nUpaNQu9HrDLTkelhS7Axm1GvOKxkDPdNxQrV3EjaatcIZP4Bya/479pjZ?=
 =?us-ascii?Q?7N8DloKIf1AtLQ93ANmcyMGxEx6ubKVgxMIfdkHMNOFDCDkjP+kZjUlvHiE+?=
 =?us-ascii?Q?TXme8pb8m38CS8eyOxtBS7LhHLrGwBugljRqz5X6HKwUsW1hCxeGQQJ6WmQD?=
 =?us-ascii?Q?45tL+QGIKwlpHwU7qTq11TBwWSTAVJPKKKN0YQNMXcsye7/0Qj+V+orMk2f2?=
 =?us-ascii?Q?4/5RcjDY6O9UTXQLidjgaQ+x0odFPQtKyW+fyIA9u46vX3uZ9/S7u4x2mZ/b?=
 =?us-ascii?Q?Zt9eCWpkcfPFexxzRWeSKzyU7W6uEKn7emKo1IdDlJYkvj2AUqzbAZ6rOYZu?=
 =?us-ascii?Q?+J45tHyC49oZ4q8u1xAxWRZ8qSHKni+P7sMejsDrGhhmrPLjHsQlxCJdvICM?=
 =?us-ascii?Q?m2Bp7OQBl7uykAtmSsKP/fjV51N2cS7E4Py0qqKE/dW38FChB3Rx813NlQJO?=
 =?us-ascii?Q?s8nM4krZXmfntZQ7U9XHaxLoxuBiSUeKvgAYgmrdUGC32MUrmYGHX/xn4Ool?=
 =?us-ascii?Q?YPam2AOuFWnK4adT5fHg1c91/KEXo1jQGcOIf127p9q5wTgEq/85z4aI/ips?=
 =?us-ascii?Q?9u885QY3vwHg3Q/AuWtteZJSiXcuoc1ptkkYy11D2x7iSxfg3/V0YrvYh+3j?=
 =?us-ascii?Q?7LxkUgsedl5OigY217xuIDmftE4L0wMN+2wx/DM7gpA9Jmq3XlSQMc5JWzQW?=
 =?us-ascii?Q?WWYEJVkcgH3xGI/VTaSk4iirhkBF+nbYWdw6wrswAgtvYPu5zmksfasTU8BQ?=
 =?us-ascii?Q?FztgSfwu+PSXLuu1CtssR5a0hZD9grpy2onVUY94MqDOY4eUdSkvM0d9Xm5r?=
 =?us-ascii?Q?/8Aj2qj6ZvAdg9PQW+nGSq2Ds+P0LkWtlfs2hg50AsB9LKCyRXAro2HpwuLe?=
 =?us-ascii?Q?6uw079JPHvgnYGBxY5WiuYdBv2kXspFgXhN15bHmM/SwBiL3HuMoen2iUL+b?=
 =?us-ascii?Q?H+oOWSThPvR6KKLjKxwzRep6Izpaa0F7ZZ6WTGVHElgoZQs0fdlRL/PLLZps?=
 =?us-ascii?Q?8mlGtCXKSsTMiX1AWFiyIi0+JjbjnXqD50O+ckz/gE5ZzHDEFmKjxgl5FJ96?=
 =?us-ascii?Q?9CCHph5yzZaEBXbD2fqMFGcuSGeH6s+i5iaAvBYIMhTjo22QafY0Gz8XACiQ?=
 =?us-ascii?Q?g9YC2I2+13fDeINfBRHd5EXjw67BNOj2cZz6gW5s1dwijoL9hc6eiCx9Shjm?=
 =?us-ascii?Q?78AXqcXsXRBNuJgF1EwwndpsZUJ3CuScOKNobHtk+x16jRvRYBsaP+kScz+e?=
 =?us-ascii?Q?idREvIdaz3F50O+oW4f8fY0x2NJFregas+E+4VFXNqILmz4mDAGGWi6G+O6w?=
 =?us-ascii?Q?PICuaV68SKyRnQ7J35ZZm4G7FuQ37YH5bzSMfRvwr5xWHMeTg7aMoJPdG8wm?=
 =?us-ascii?Q?2Aux/cOYvxt8lPvsyCktcr9OEXUKdORe?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?HwbeTTCWwQN5YdRf44bcqFxAPvKF0gLFgiMniWX4sbm+fuTQ+hHyvZ48TiQB?=
 =?us-ascii?Q?tUG/gfYqtEY9BT/5O/L6tv4tzPUh5Oo0kPOJ83o4RpGk5/Zlq0h9uwvJukmN?=
 =?us-ascii?Q?gsp9jN+kVA9+I/Q6o2RDjsoq+AA49dB8F7q+5erFM4444CsgAf4b6v/yJz4O?=
 =?us-ascii?Q?pipvMyCx12lXCCniBFN1eoV82i9Ox8+adG4Tms5nkrYpCkJ49bfMj/s+vjev?=
 =?us-ascii?Q?eQ49s8L5AbuE4V81obzW5gV/43YBNrr6tgvU5t+dqyC0Hg8tSPmxjEVzsov5?=
 =?us-ascii?Q?fkplGLSVP8cBfq4oL01FCCbCJVk/bQ+zEVWKILhfYdkSEsTepAQyIaD/N+11?=
 =?us-ascii?Q?8VMoyrlq86Otj8OE0FMnA6uX3EtvF9fsP6yS3UIPE7E9PdDFPvHXrqLkzWhq?=
 =?us-ascii?Q?SgZlh8CVLwH07ii1nMmRcWkE8/y4yqNERgZUcV4VY4LFVy7fTI2C0GJPQgNy?=
 =?us-ascii?Q?0DRLQtuwMt+h6qyEX+otxN9Pp9Ncpbl94RpD+P21IHED2OztA3atuepKqCQk?=
 =?us-ascii?Q?C/4mDyKAjvGh4xFflhbWL7BqWAWlXDT373kW+q7qIYaeAyEI9MhnV/1M+Fp4?=
 =?us-ascii?Q?UUPb1Ub5pXiqzDMUX2DgO/yI9JkHA1xH+PoKUvcDjbuTaR/Kp1WaR9ilue1y?=
 =?us-ascii?Q?FfODVazBpl8NCBtk+P/2H+rjTvrq6nhdq6bttnSBMMpqGmsvv2z1fbIZ9uFp?=
 =?us-ascii?Q?AUOVahVyuPHTinKp+wVevtRpJqoCsF16fcM7/yAkHVVdgQalSnIAd8pypWW3?=
 =?us-ascii?Q?jYb/2tG8dBWO7KVWUoUJ2cUIGX5WyGWEurWJg+DrDjbeTzvKSsGD0jtkQgch?=
 =?us-ascii?Q?bTqb1ZN4cLppfV+H2cDQtNG/noMLqKNwC+4jBsvDOo78gG37TgqNc11zhapg?=
 =?us-ascii?Q?JoAkqP9NVxZ6K4ZAdjM5c1veU7mrismD1jQpZNf/GkdswdGbDX8HyDObt5Ng?=
 =?us-ascii?Q?pJFHY+nFOeey4SBPHgLHIgiJCDKsLRXr64dMnTrbs4GKoZGfA187FvaFIs7I?=
 =?us-ascii?Q?LwCdI09C8jPU3ELBNi3+M2DEx+0wSf/sU8qXJnrTvC4YyP1VUkTMXUR1cb2o?=
 =?us-ascii?Q?5y6O/81W+0JsDtw92+hIay8he5eDpAkvNOEXP6TDUM+0cV3BRdB84Zez0LTC?=
 =?us-ascii?Q?2q/aRcNmT0vKnU5MxemMeRcL56gErhvLQ9Eg9zjQF8lo+Ml9xkjDiL/7oH+1?=
 =?us-ascii?Q?lA6G3GFqseBvaeLCZ2EEtGu1piG8HrMAtCna7XA9vLf/acyeuDWLlIE3QfFF?=
 =?us-ascii?Q?7VNeWmFwfs1kKcS0OpcObQItGvxP5rAId+zXZRyNHdwiEaknmYpjXrezGrXm?=
 =?us-ascii?Q?7eLzJns2izfQ1TSMyzehN9OTNUqdoRAjkUWD2+jwCpYEsOm/PKzVm7aaxLVN?=
 =?us-ascii?Q?K058swX9kivZ+H7+fXYhO/eUPmXqr3Cx/L9+5RvQ/Y8rq2u1wT8n0wKzlKmB?=
 =?us-ascii?Q?w11yhvv5GYlxDnBQBWgxM8Ms7uWZWEF8kxuevqdN2cLRXsg81G3nUDjiv+DQ?=
 =?us-ascii?Q?IIq8dvnT7PXjtQkG8JcU+yhd+7g3O1F0lj49klZ1Q+1ST2fpFic2o27BCEqX?=
 =?us-ascii?Q?t5eLcEkcfrcRrKW/QwmCE5p+6WcAGp5cd2LZxAtTnIPFOiHsY1jCaKw5fPjV?=
 =?us-ascii?Q?dWymuiDHuYrsVS3TBoOa8+8UPQc951WNPSIbRrsn6AVaRkGmVotBbWCYFh68?=
 =?us-ascii?Q?Ix42ctLVIkzy/QZ6waqiHsWWvTcMfyP0/EEKuNS7bAprnwaFaIrC+1oWkGNl?=
 =?us-ascii?Q?SZqLUUGeNsPzfiPwrQPK4hkWi0cdbPQ=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	24bYmJwu2BSSbESqaJeCHt3yszy6j3AdZT2QHt59ndhB5XjDU/+8ELdb2Zi9btKaks8vagYEJ0UIJlM3YcD9YbzwMz9eTwHJ95EJ+EO0Ifc0dUOn4tZgGt+O8zQ/dvEXgDya/7TFFbu+qEu4Rv2oTE5DFM+MyvE5IA8W5GI1mM7/SwxbZzyFJ0YcGgrrogZrXuBM+QXLW/56G2fo2epb5ARjOtuLPt0OXJfKZIcTVseDCPijugH9wzvYBNjY9DXXcAtV6t3itK19fwiqLdjRuH5OJyEbgDzm5pi4TJl7TtJ4pM5UoQuhdSY2cI4YFi+Kr0pAgFtth5owZ1zIMaeDQkWfR9D+2/cVmJDhxpcKri4uD2tLf963oCu8BeZtRWX3far0Dj7rpq1FJFOxZgur/ki41MzcZrJmSaxY9jkz3wvl7pCrG4YuxB9MStjrXTPRVNR94qQOolDkbxgR6QMUjXlgdbA+JCmpoEbKnYAqj9HgY9XtgRUj0rOT2iY0KWRmu15NhoC8OnMLtv1BpQFAgIgPXvOEMWrgVYtPzbXn1p1Nisdb+z2xn18h5Sm7A862MANdDkM41uyg5N6FanJe3o57obDM2VQW/phCXcsfZcw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4c0ec524-48f6-4687-10bd-08de518726c1
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Jan 2026 03:03:24.6890
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: mXN6nBLOYdfPd1QzkP14QTMMSFcmgNvnxpM8JdKNulXirV9hGVYoNCgvGC5mWwiUclrltqm6nEiupEOnGkKYzQubP1hruhzsFpjy4TiLm3A=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN4PR10MB5558
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2026-01-11_09,2026-01-09_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 mlxlogscore=914 adultscore=0 suspectscore=0 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2512120000
 definitions=main-2601120024
X-Proofpoint-GUID: KuCZdrb84GXb0RU8w_L7OSMi3VDYyF6H
X-Authority-Analysis: v=2.4 cv=X7Bf6WTe c=1 sm=1 tr=0 ts=69646483 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=vUbySO9Y5rIA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=4UmxapGgOvRovlyjj6YA:9
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMTEyMDAyNCBTYWx0ZWRfX5OURcE+b/jip
 BXotXHJKCZ/8SkDGLaHipgQdSOH+/iVM8dDHRzfbgBVyayvr/ac2UvTB6VOYIpeo3BO6C/MPcR9
 gBD9ntDMTM24s1KNkjt9xmvUloUnqHZtP+d3zgdZObfVm9PEdemRnlLig06QHzqqm6q8eJ/xVsL
 YCFyTTHwGymiEkilStGSlPaajQpce1BRlsau9qB/wkl6r8Bffh3apVJvZ1GEwMnKx9sdSGEwlCI
 5XC1SvDWeEPJ1aFSXYAgGdjz8T1U9bhu8668hzTTZaGzTiGJzUvk+kJzFzD2wKBWUx8JuWnFEmU
 a7iLYIhC2pawjeI/w2woNuHTKmSQyMGuGFyFV6y6okn2dYhqjJwCpTJac9NXEm9Djsw9d1xdMq7
 zQkkcCORjym/lUMDIXtHIE/78+txBrBJ+ZghiVkwGRUl52l9C0SslPtSw6+qa5iJIaHi8h/tbzT
 TRh9sdOsqh6DHZ0bKrQ==
X-Proofpoint-ORIG-GUID: KuCZdrb84GXb0RU8w_L7OSMi3VDYyF6H


Bart,

> Let alloc_ordered_workqueue() format the workqueue name instead of
> calling scnprintf() explicitly. Compile-tested only.

Applied to 6.20/scsi-staging, thanks!

-- 
Martin K. Petersen
