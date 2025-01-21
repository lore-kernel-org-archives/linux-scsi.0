Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FA6A187FE4;
	Tue, 21 Jan 2025 17:21:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737480092; cv=fail; b=DI1+GVGk0LQyjfhAq52DmU6zFBoJ55qK1Qgf9xRiRJ70cGDWs7GzTKuaoPsylgmtUWVidctmzDCQ24h+ytmv3KQLBh4haOUV4bnAlEa366mJqzcndPt2myR854Fsyai3MiLEcpg/DvCA77WVyaaezlRAbTuMucOeL4c+jSmgOFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737480092; c=relaxed/simple;
	bh=Oa4Wl/ZnhlL4bQ6FqC63YN5zazjUoWPsOS+vnw2+WX8=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=duF0UV19w4cJbswBaRJMrIsm9MeN/UYSA1tADehzqpRnZD3LNKX2nzlxyuf7DWaXossRDYA0eBh31dvK/jI5mFnbLH2in0FJgEXJshbbmskC2Rb5UBGU2kb+UrtbT+NDPbG2aZ6C96vQikpL2uv/IU3oFf/5Ebtp9f8HW7IS2jU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=M/WU3bRk; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=nbYIjMT4; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="M/WU3bRk";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="nbYIjMT4"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50LFDviH030866;
	Tue, 21 Jan 2025 17:21:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=2ncC7vetHc89+iQ2D/
	2ayzInKh++yEkBO3MG5lOeA5g=; b=M/WU3bRkIuKOOv1fzlPlHZkkpD7zDSYMZm
	9RYawfYaPlrlxQQ2RAeGXEQZtvb2ZVL0XMTfC9sOxbmDiYUi+AR6ZTlJHgI/X5UB
	9mMfnceWH08M7tcSzK48dpb6dBX37Xy3K3NF5WLW7uEYVbVYzU+dEnV3G7pAvvIh
	FRa6BTBNOc2n2c6exomgtTyLG4Fec3mnUCLZS/Lwr392Tkh36+ng5f52bUZlDNAU
	UgI032iXmKuG1Xm5TcjxjXyRU4O8Bd+hLVNfB7L5VbjZ+SBpQE/2JsboQU3t3mLm
	LV+AeOwdb9BAvJIPoMsa6bP4mfVEPaIiGjCrbZy/AIOXYdkpnQ7A==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4485qkwwvn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:21:03 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50LHJwxU037991;
	Tue, 21 Jan 2025 17:21:02 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4491a09nww-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 21 Jan 2025 17:21:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=r7fHeYgVnlzmmgjQxVd7hYKrY552nzypqYIauxqsnJQ/bsYd11248rw4uFDUVtiYct29lof+u7IzKGV4p+6uCqlHj23haseDBbjRF/M83ttfmFapMobQ6OsGl7BSDB+E1Wgp6SqegbL1uPBmKhWHROODrsuDSJVkq/2VE85MyitsFQoEPIE4qbUkOb1tRT553KGH4PPsIeOS0IWAHtYU9Hn1l7uY80ld697EY8s/qnEmhN4TEe+1aN/Hi4AkY2fk9qwpMAr/xi1+TfIt2c3AncfkPuUha26A81K7AyV2dAZr+yWGXT/hQSlupIdhVHt3VMVFNCMM2z3gddXsucVpAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2ncC7vetHc89+iQ2D/2ayzInKh++yEkBO3MG5lOeA5g=;
 b=DJazyh3nLzJHxd39zKtWis8TgpSpp6ihl82HsIaS23qt3k0Klz3AqWfANlLn5ysnKZuZSUW4A4M/pIJzby7GnPdgPOvtsPOS9ph8C2Du39Elv+pSPAt38VtqaxcKOu+6MKs715BnegUOn048GoMY82Rsv4JzGZwv7jfPDif0gT/6GJ7Pz4qW/hY56coBZiZohAQj4FpUjVgtWN9o7ORlwERpFZdUWeWZ6AeIucvRvu2N5yNO13cv9soFJ8dNY4bz4MffWiX7KJCx+p2fTaWGydYB1CAx2iIIdghrNU4z5lFcc/5yRNs5JAT25DfwiXQsvf5PMIx07hQ7IfLcvJYzlQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2ncC7vetHc89+iQ2D/2ayzInKh++yEkBO3MG5lOeA5g=;
 b=nbYIjMT4D7irYdp1Zgv7or6aSdgJtd/Q2m7Wpev95MtdQpCvjbrDIMj6tV9OwKhU7NXlracTYFMaYLVYP/frmuJJNyAQ6zukHuA59EZCKh/MXjIa65Nmggg6i5UvtwgMwd/t6t3sMexAoLw6zGTbyr7JJdRLKvYsayn+INmqauE=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BY5PR10MB4113.namprd10.prod.outlook.com (2603:10b6:a03:20d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.22; Tue, 21 Jan
 2025 17:20:59 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.8356.020; Tue, 21 Jan 2025
 17:20:59 +0000
To: Avri Altman <avri.altman@wdc.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Guenter Roeck
 <linux@roeck-us.net>,
        Bart Van Assche <bvanassche@acm.org>
Subject: Re: [PATCH v2] scsi: ufs: core: Simplify temperature exception
 event handling
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250114181205.153760-1-avri.altman@wdc.com> (Avri Altman's
	message of "Tue, 14 Jan 2025 20:12:05 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ldv4w0b0.fsf@ca-mkp.ca.oracle.com>
References: <20250114181205.153760-1-avri.altman@wdc.com>
Date: Tue, 21 Jan 2025 12:20:56 -0500
Content-Type: text/plain
X-ClientProxiedBy: LO4P265CA0174.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:312::19) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BY5PR10MB4113:EE_
X-MS-Office365-Filtering-Correlation-Id: d0318196-0940-4e90-fcfa-08dd3a3ff950
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|366016|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?t4QzLpRHVDhVAv5xUFxkeVE27MBA6Kp2sva/WLvubv3gEWo8h09QmFndew/R?=
 =?us-ascii?Q?nI/LD6SukDCirSfUlYjt4h5QSXhm4PkIAAmGlT4jGV3SSaoBxrQeIpJ/3v8A?=
 =?us-ascii?Q?adXTX0S/vOXLD2pfbbpiz9XpgLUddOBk1oAExUXSSIKC+7WKcXngyiZ1UO2s?=
 =?us-ascii?Q?1bAmATGqtJYJl+uq7VoJX+12KB+aA+8PAwtiM+JzkoMoofwa4lET5FASZYGY?=
 =?us-ascii?Q?6mvrmaqaDJO5MrJWLkzf/7SYSu80KHixL7GtK7c1qx1UymRqtW/79ugEPS0x?=
 =?us-ascii?Q?/Dw+V5ZNP++0m5kQQYd/L1gq910xj4Lj1OeBae8ytJfEwg60krOcMEnel1E6?=
 =?us-ascii?Q?AffUHyI97rwpH12H4o5wPmMqUEELQipkBrMm4W4NSy+fe4rjsicFS9CFllAx?=
 =?us-ascii?Q?vSNYRE4d1IzddmAbfG1B5sPdb07e+w6XjKFp6CA1npv0MAVkw15LH4aFQ6Ei?=
 =?us-ascii?Q?eFDVgUzi5xoSZfZGJEAUxKHWLDni8KpL+QUINtJEyZz6qo/LL9qhyNr1vpRL?=
 =?us-ascii?Q?lcstVlcDDN6Z+GhbA7of5x4qZvONsD2YYkIBCo7nnl/BJd+4P1bcJwklZgub?=
 =?us-ascii?Q?mQqgXXj7nNchAeAvIztJTdmMxijPJ/63XOwkrvJgWl/+3kXsQS1OUyem7axg?=
 =?us-ascii?Q?zh8GNrfEV5MwmVfPG0qFKCaCqJCieJotv4npP9McLna798Fsh8ILroy6DwAM?=
 =?us-ascii?Q?9vEuwgwpsjSOK3vsg1pEpRgpHHMia/getyRbEXuJuwNg3g8tLO085TrQJbf/?=
 =?us-ascii?Q?hkHriq9VSOyJXBKcf50dwVr9ec8oGvsj+fh6Kzbd+/wB92ErmvfBYWXD/fvl?=
 =?us-ascii?Q?jVdKTr2p3PtpgQl+yB0pGmCs99GCN3mWx9tVt/OEP5dUwdnZ0jCii0LOFTs3?=
 =?us-ascii?Q?s1uDkdYAjKCq8CDiulXA5PxBiPeg+ffBtQxNxuv9MVQpdhy+fBGZ8mEcidOZ?=
 =?us-ascii?Q?fSLoaZssRpPmr/gx6IcM+Q3DVZDoim95/BR/zJSuKlj+JjkjIy+Jb1IFlsms?=
 =?us-ascii?Q?Qmm8Bg8yNpZhZppplxqGgEt17AadWMrsqzDJ8uGOi2h3hS9gRqmUoNiNTNoo?=
 =?us-ascii?Q?EWv4l9P8rNB/UnmXCpxmoOuklg8FUws9UZfOtFKl7nueOKYUDpLxSB845vp1?=
 =?us-ascii?Q?mEn/5SP9zka51d68tEX8toAWzuYpi20xELd+lHqGeBXdMblWWy09Vfd2vQlu?=
 =?us-ascii?Q?mEKCVdS0TjmkWgM7O9oQRsz6n2Mifo7Mdy11+llFLRMjTepIHH/DahLUG2Sw?=
 =?us-ascii?Q?uO1HckraFExRWVfKdBWhg8V1ywRjbhLK8gbMJXkVhmJrX/UkD4A8k6eUvTCB?=
 =?us-ascii?Q?5Tx2afG2ldu8BuEDMr4zE3DF5KrhJGd+fEdlWxXd5XZ/nziBeUz8AAOMqsss?=
 =?us-ascii?Q?PaOC1Ty0CJ46XVdG32C4e84oPXeo?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?mAhSq0O7UFcQaDV1JagO4fuB8eKfRXpxWYD5dflgH/GKr7WZ49gX2cTvkiPU?=
 =?us-ascii?Q?9k7mA3v7rHSVSUocU7mA03uZDzTV/3dbJSArOx7AgeHodheLDgakgwO8NQtI?=
 =?us-ascii?Q?xSJS8thE9TqymBbXR/aNbBT2KW0d1HTti+ixa05OLXlOWkmPE1w3ozHfFhZc?=
 =?us-ascii?Q?Oy4/5SJyAQRRwgWLon7IDQkoRjnqXWaFkRCnb47802jS3cGlo0/hDMc+LbUs?=
 =?us-ascii?Q?Tz6NSFPll/W508plTiMIf7/y7nU0xZ3Kz68BRZxzVmiiewVbPyTp6qUNWpif?=
 =?us-ascii?Q?GmMhXK8vXhQDhFDcbfu9fetl5ZRLGxGRzOaNa+dsf8w4DTLkcVxVE+6b7Hgh?=
 =?us-ascii?Q?bkcq1BhcNw0EYhjQIq/xLCKVpsgbdknCs+rceyI8gQzCcEz54bkBQAdzrY9e?=
 =?us-ascii?Q?gydRYaNrMrHusyAJydyMh2JpQNEyOQm8xxfZotEBPgjHa1UMGSr2f3OZCxl6?=
 =?us-ascii?Q?XIAyBN15BtfTCrxp2UqA5MwCUNjLT/mRRSIOhNjJ7Hju8nUKzEo9O7h6Xoj1?=
 =?us-ascii?Q?GxXpQH7A77570brgZW24I5EDkY5vZLXoRCOgN+VVGxjR4qoz0l5c/FwxHh8U?=
 =?us-ascii?Q?krZov1z/21aGLMFpVdyI1uggfYooLuYlw1frcCxdOsj6u8psx/a8h1uWMrVP?=
 =?us-ascii?Q?WLUfNxtpf74Vc20MyGMC+uI7DoLOmxghyDd466Xe8NyQ81Qk2EVgOnRmF1Nb?=
 =?us-ascii?Q?yue6mjjRc1TVxsATi74EzGUpNGif0OuiNRT1KTSfs3ASbD5zN99sJy9Jw7yx?=
 =?us-ascii?Q?jUSq0feOiPAd4rC+ytU/NmOmji4wuKG2XE9D9ZC3/tVj+f19n3H6agIuIabw?=
 =?us-ascii?Q?03hQ36ENRi09XvP85ou63c6Wzwql4EAG9S8E83RhEJeywtIlg10fl00TuJEv?=
 =?us-ascii?Q?lxc7Di2AYmK7RGtvpDh/GJCuNfR5Zyz/4jmJGlGbZTOQz+RBhn4kmUJ4sjQ9?=
 =?us-ascii?Q?vfYxmd20cv+pgc4JmpKRQUfVPFq7VkZX3T1HbBKbiVamIZXwquX/02LV0Hdn?=
 =?us-ascii?Q?LXwIScQPT90AA0ZWTn6smHTGE3FkwVuaTVKmjSJW2A1dFxAoEbMhT9FAPpMd?=
 =?us-ascii?Q?0hNGr9IQiDqHCmB6AyLHj3+i3AaDNvSasHmR6QJHngE4Kjg7eGrG0P9vqvJU?=
 =?us-ascii?Q?00B+Zu3bVlfzacf26g6Jaf5EgsJ+jBrz+huLiwB94zCqnZLs2fdoumsFhxct?=
 =?us-ascii?Q?lKwy8my65n5kRSZMm28aVjUJRFfawHwBcJ17SX0BZj0dHXhmpk90X12p5d5P?=
 =?us-ascii?Q?fJtAoPeBuKKfWEOXFX5BdlWn6G8a/DaFtF62C5Tt1Vwh0DsT7GypOhzVRk8V?=
 =?us-ascii?Q?5uJwK8KtRVd7arCPtOMs+x0DQ5ufrVewRvLc7Fpbe5UJMxfe6r7NyqID7ZP9?=
 =?us-ascii?Q?wZUDxTtnJWDVefoLX8aYlVBNYrQe8WjaQUWYS1By6Ks/hKeV2L/GW6NKpKT6?=
 =?us-ascii?Q?vC37QfwNI/tYKr43MAkPdaTm0Z13agBO0X/MW0T369LjElfatNXMq/r5agXa?=
 =?us-ascii?Q?0H/UeK/kWApL0JJszq0rW4akBASSCFJW9WO7NeW+/e0IAVnBHfdLuAisOBD9?=
 =?us-ascii?Q?x9KLUOVPtM3un7F42uZKSnjtFSvUlpdBfA7JV+tbAv7ZcJOXLxMPpVfbDZbR?=
 =?us-ascii?Q?WA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ob1nqeMItuS9TOabn96lGUZFVNphj/9D/6wNsN5Pz5g23Y9ZyZ8hrILASzRhGYrwvzTX0FJi0g/wKhSv1tCY4u386KPfSOUtIzBQbxi/W9Sefc+GI0vu+vFGrCc295UWNUVHq+Qw+BPFifwTtWDymGmEN+8nDuFoDFJqmrr7Ot6Uzm4IRNb8vVpo1RJqX1BwRa60KICtAjmy9lL7myVx/xUzutBgp30sW33/oH4nlxZp0QuGcKh/h5MGiwb6aUWDcC22ALtV/LsM9pd1VrIpIfDKh2tqpqlWchJK+NPGwbUQCLhLvXO3TSIxZSLxhRhFux3h1yrXVALLGQacfTkiIptVC1PQnqUdMH1CZs9iNhZkCLrsLH6bIIEMuR1+Iqy5I1C5ZB7FNSL/t53eO6rkT/QQWYkvbiMJvsraNzbyGp1JhxcMebwJ3NNYxfqJqXRXk+CPeLt/nNhr3xB2FeiiKE0dhbI65NKVOyBifKFEeQ7eRb1YumFiLqKGEYZn4kgbi7iDGbK30no6LHvHbiaRP0x0i6WXZR8Q5QDQWirGe4jOLMXERIzDlexrC0gs0NRUiIxVtuwEJZxLAGOquiiJVxFVWpBjvba+qozT462NN5k=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d0318196-0940-4e90-fcfa-08dd3a3ff950
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Jan 2025 17:20:59.7823
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: NmtLkZkKPheRarPfV1OinT+NCDvGuvDcqYg5trVr2Exl72ExKEijEZeU0TMW/V9bmq8E6ZwUjlwg6Y3wDU7L7EIYz7bYQUUUEHQs08p6rI8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4113
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-21_07,2025-01-21_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2411120000 definitions=main-2501210138
X-Proofpoint-GUID: P1TCX5dtqgybwf9RLvPQwfViQaWpDVBS
X-Proofpoint-ORIG-GUID: P1TCX5dtqgybwf9RLvPQwfViQaWpDVBS


Avri,

> This commit simplifies the temperature exception event handling by
> removing the `ufshcd_temp_exception_event_handler` function and directly
> calling `ufs_hwmon_notify_event` in the `ufshcd_exception_event_handler`
> function.

Applied to 6.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
