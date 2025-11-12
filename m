Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727882D839E
	for <linux-scsi@vger.kernel.org>; Wed, 12 Nov 2025 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762985521; cv=fail; b=t9CSZs62Dd1MC1OazRWtlJa01gYSbZWyd/VXIsntYIhmcsujVdd6go9zR2Te/NDy8tQ9jdRpKMb79N21tFK/ZsRzSUMn3MAFkHNTY3r4rBt1vfMRP1dNx16F7XOnw/+5EbSTefQVDIDhZZU686Ox8bcoNcuVkQ+qe6uJZ8Q8ew4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762985521; c=relaxed/simple;
	bh=C8lX3xblcXftloFvuZ1lVUh5gov1kKP8+e5+RMv5mtI=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ECwSbSC6Toqb45N7Gf84zlNb83QbDhz8ygXhYsxBR6rPfwP6Avow65AVos/cWrapWxn6cNtcOR37pLocEOd//Kkz0Z0l35XsanX8vfOyIH7les8VMRrhaoo/GIrSJrO0XWP+IZbl5eOhqiiBpGRjkEaPaSFzHKNNDyDGgZqxvxE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Cv5JhLTm; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=qg9iTIlA; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Cv5JhLTm";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="qg9iTIlA"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACLCCEH015659;
	Wed, 12 Nov 2025 22:11:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=b2o/Ab7Xj5pRiQucpF
	9WCiv+/jrxnfm9q9D4+OO7PQ0=; b=Cv5JhLTm2AAsThGgU5zfLv/g/lFdQ47dle
	W8LpeJ/EIQCy0ICH8rdlaVzn/eFzcgeFBUkfkrqGAtVZPWPhFVNVP8m57DiNd7QN
	bO/DRz6/Dz9tExwiHtb70ag5byQ/75FGMltxzwaDSwiDqI+j04psZh+PVlr/dwbQ
	jODPKC0BWkv81qegzllLTPI1NKe1rGPRzePDUGlgYr7jYU1lTUdtU3Q18a0UvrO0
	YxTXK9JJysVxrDYrRtyOeyQIJ2bZzJTKlRZwpG07qXhQCEgmSWLvQMN38rOBXYjY
	r0+otBXar+onNlK0HXaD32/VT9JY+ZbI1qIciyULWp+mCxjrJWPQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acvssrxum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 22:11:53 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ACK5ZEB005287;
	Wed, 12 Nov 2025 22:11:53 GMT
Received: from ch4pr04cu002.outbound.protection.outlook.com (mail-northcentralusazon11013026.outbound.protection.outlook.com [40.107.201.26])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vaba60d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 12 Nov 2025 22:11:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=FMwZWUvmDvd1Te7kVLio79R0DnLoeCf+yOBSSZBzvaPixkapmbNfQuh/E0QG62iifGOwyj8kKi4EtqPZvWC/rWcdCAh5licFYtJxLU6TfNR/eJ2B0uCj+NUxgZcVqL/rmtVyq7st88TKWi+XLmjSJw/VdUVhMQetpH+Ig+1gSLL5vzRPgqTfEX9a+Qk2wFC9uj18u4bihl9TKn0rCwf+awT2uO5d0iG4R3TOJ/tnb4gYn+nHq2aeqDnjbVZD5TAjFFSdQoC+9uyrDN4hyemCfioglY1fTvS7lewsbkrzBPAaPkJZf8Dwwoyeu3Dq8KczQx9rjXL6Ibnd3glukXZrLg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=b2o/Ab7Xj5pRiQucpF9WCiv+/jrxnfm9q9D4+OO7PQ0=;
 b=UdalNf3ysjM3Ne0TfDknhbvFLr5xy+G1vBlDsLi+ENEOYHCgtPcntqWd2uUs0FgN1kkNW6s9+fSB7hcyWC9x9cn3iiHmCfeY9lPXqoBNgD8g6iW2pnZshC338CaVgdZlF1fWHgQDb8n/p9yhsjA3/S66hymS8l+BeMzcLPwPwuYonr7FgZvYZaRl+9JOQ+OSHFInJ3boHveThHYH/Ni4D+10QSSYl6faepqR2x7Nk130JJRJXBh3T/I+TFEs0NvLu4UwcRwB3iEH0Ret8hDC9ptUm+74m8jb5rO5CtVeqyUBoKs66GryKXTdjleKUe2s52DncLKMFOehkvo8fxn6GQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=b2o/Ab7Xj5pRiQucpF9WCiv+/jrxnfm9q9D4+OO7PQ0=;
 b=qg9iTIlAWjUyXc9gU/rn8Bc6oQrakkmjY2bNMjyUxHofL+7xhZXGMNXVIYOrChzu0/0qlE9ZcaoHX0vm6A1HpnsIAXBUyHg9+fMpz7fi2Kpdt/nc6Lz3uDaB85caoeYyuwPmOpZNF5BpuB0IlEhNwGz4OAiHmJXlKzP7a7MeFOs=
Received: from DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6) by
 PH0PR10MB4808.namprd10.prod.outlook.com (2603:10b6:510:35::23) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.9320.15; Wed, 12 Nov 2025 22:11:50 +0000
Received: from DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680]) by DS7PR10MB5344.namprd10.prod.outlook.com
 ([fe80::b527:ca1f:1129:a680%4]) with mapi id 15.20.9320.013; Wed, 12 Nov 2025
 22:11:49 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v8 00/28] Optimize the hot path in the UFS driver
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251031204029.2883185-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Fri, 31 Oct 2025 13:39:08 -0700")
Organization: Oracle Corporation
Message-ID: <yq1tsyyewa3.fsf@ca-mkp.ca.oracle.com>
References: <20251031204029.2883185-1-bvanassche@acm.org>
Date: Wed, 12 Nov 2025 17:11:47 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0026.CANPRD01.PROD.OUTLOOK.COM (2603:10b6:c01::34)
 To DS7PR10MB5344.namprd10.prod.outlook.com (2603:10b6:5:3ab::6)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DS7PR10MB5344:EE_|PH0PR10MB4808:EE_
X-MS-Office365-Filtering-Correlation-Id: 0776aef0-f4b1-49b0-4e55-08de223879cd
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?NUcxc5hid9IwXr/h4yPTH7JuNThX1j7raHbPWyczFxh1SkJBGTWCsnDjLobK?=
 =?us-ascii?Q?Y+TZyt/EQYFM98B16YENzmaOnXqsBCFQEfy4zD2mNEd/fgk5U0CGDNpR4W2I?=
 =?us-ascii?Q?PoTlfn4Om2CmKO7f4zWwOHdPtftqUnMxyeVaGJaPd+uhEn/6PP7smWjfmdyl?=
 =?us-ascii?Q?nFYXRVHsiL2T41uVCWiylXiFAUlX+Q885jWihTudkz9+c/Mp9neQHfys1CXX?=
 =?us-ascii?Q?D5eZWKhYUiYdf0N1hNsoJDjaqTWUI1iCBmWtlfS8Pad6AS7Ht7WVCegqavTX?=
 =?us-ascii?Q?QQ04bqN6Q2pHVPCfuEobiUgW5+YkiU8GXTR9aeLL7XeQIoC5YmRFGqpSc4Dc?=
 =?us-ascii?Q?aioa70Xx5kPS40B6q6/nEjZaisX7Ls0zl8gtgboPZ1m7/EdOsBtTiAQWPnu7?=
 =?us-ascii?Q?AZdTfYj+L2O4jC7UGTov+f4ne03jzcWWXwTDg39k+Y6lQYm8HDtFAzrDIOrF?=
 =?us-ascii?Q?zp9FuERtAmDk3VgA+iCn19IXPEVIGxPoSqL+JzS+VJnnpOUsWBnaxApP1Esz?=
 =?us-ascii?Q?5ethuBWwKnn4DyZbogZC93O4oFqu8wbN5BNpSNoF2u0sIsfB1+WNe+HZtKsx?=
 =?us-ascii?Q?5/qjiUceoQLgzw8OWntC+vGrYYauWFN7V4g3TYfjczOFVgWAEfdDtLPNtcL0?=
 =?us-ascii?Q?LG+hha5H4ZWZSUtV1WhLo7fJHkXNRWbHIGt7HgihjZhDZM92JwRmBHcGX7hY?=
 =?us-ascii?Q?U0zhhk0b2pq6jdJu2xcmuUzlcghRfbgIbY1wr+XajjA8QzRR+aL4D9FkvoSc?=
 =?us-ascii?Q?sNHskMD5MWyENb0QoOm8G3CKMZztShTcm0HjvAcM3q/Ikx/cGrdGZvmGkOdi?=
 =?us-ascii?Q?24g+wp+v2VdJipwJqhajr+FKUhfxwJv4LGIk13ig4JkTVcNHkvVbcYdUiLQ3?=
 =?us-ascii?Q?59BqbmLHwgHpDtfiVaQ37O8m7cRYSmHBhiu7DBAyt80pW1eianXwOaY8AbxK?=
 =?us-ascii?Q?hAvNLNtfS78enRR/UFjB8c0xWmiFOnTHy46/C++vA9f6ckVLHw1Zyu042DbG?=
 =?us-ascii?Q?NP/ol5cDyXCooDdZcAmHmPCmsZOcCBt4W37LLOmH6QbOv1x3o5fYz/ZXKrIa?=
 =?us-ascii?Q?0lPeAZ1fvTfgstvM2+kuZGzyCX5jNOEbM2JuFFZohc6xUePQWFt4wgnkXbyN?=
 =?us-ascii?Q?GKTWEunxwtVts9g1xn94KblLAmkGnWESygT5FArvcHypkGVjJXcCGQ8yzYMh?=
 =?us-ascii?Q?4zk6DSroDy/IPh/3xUziSicYNVpcTKdxSeC6hZ3aCsZyREAdOORtIqBzmROg?=
 =?us-ascii?Q?GOu1U3pOnFcVsl/1pnouNW0nw/l05MSTr8ZDuI+mE1LTaF+os8325mDChCCS?=
 =?us-ascii?Q?UBRaxXI6ZBCgYMOjIIdoBIlJ167+7fIIKtviES49fYHZ54YiNHXBWO4wNS9u?=
 =?us-ascii?Q?NYz+fUNvEJBcTMeKbZQN3qGrbt75/jCdkd3wN4Yh/HpzNIVfI4KghmmlEypu?=
 =?us-ascii?Q?F9bGoKALF5XlNB4gUruyXk0Pm1vg3ua3?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DS7PR10MB5344.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cYOnlRpyGblwWZKh0pkXbLpjQ1AG/8/GtIZzmvfJZxqIsat1meXIL0CFAnOs?=
 =?us-ascii?Q?xcxlkQCO8IOUtedUsniYpWDK8zUBlEnQrvUVRhF71H7aZfx1Wb49sANXv8RY?=
 =?us-ascii?Q?3fPGWIjNgmFL9fwQKsPG6hVHglRdTq57rTukFY1Jajbj2RVI7L+a78Uw9N/K?=
 =?us-ascii?Q?ZB8uk2H/JC2DJkwOAnu4txBhS9Ha8wZcCbbalLM5YerbIRAh6t8CzfOJzi21?=
 =?us-ascii?Q?WvYXtdNLRkCtdEgBKNUvgE+UX6L8RdPHRWS+N2b6gGWSxH66E1BQhumx1i2T?=
 =?us-ascii?Q?6uikYXomaLKOqyLyigQypf67zkDQwiCoGuSaEysMIaImhzDJldf7TXllO6F0?=
 =?us-ascii?Q?N4DR6lglRCvFQUcdf2lBpGbm4aWFolyJypCcbTBsAOj9DKvUCHdLsmCf8H/r?=
 =?us-ascii?Q?hAxYLD9D+tGlB0aGkvzgpe/Ueei3DSWISOf11Gm1VSZYp6wNl0mQJq7ZbHTj?=
 =?us-ascii?Q?NOG6j6dZP9fu6FScj6JNCp7FVJqBsVB8a4v1sVFN6qUV/KnNS+21ClLHht6n?=
 =?us-ascii?Q?XTzESTNANdi5s3v4pZPAa3Zj7HR6/Fip3D8j0OAoory2Iip1QxANawzozeJ3?=
 =?us-ascii?Q?rV4nVXI4x1D35KDTnvB/O9ycVQFj39ogjNrIshR1/821Xg0iJ+6ZUNczdqzS?=
 =?us-ascii?Q?khIkXihjVJYFwbb3JuQmFK5x/SdddC4RFDcQ86DGOI2JEC4UTiWFw1grU7f8?=
 =?us-ascii?Q?U2hy0VXUnf56uTDuyApz81o7b6+OeiJB/TWqHRTOLR7rtMVfxAZKB4TRFN/m?=
 =?us-ascii?Q?ek7TEI+XQAiQJXStI1VeiU6wqf+9goffHGnHn42Y+bq8lVwW2Utk1EkPz2kC?=
 =?us-ascii?Q?pYRrNxf6q5ZSSHheIN0UbssVGuQPnLxDAQ30glLVi5C56TDAJPljoW50cK3M?=
 =?us-ascii?Q?7pG+MA+G0kEsOJs26ahl1edTGZxTXMMi9Bpm+PaomsIA2+wb3RxNuXX6rCBd?=
 =?us-ascii?Q?RTH+rOZ2tdLTWGOrRx++mUE4EWMXRBXUIcZGs7aMLqkLUlZYzL+cGvKW06vv?=
 =?us-ascii?Q?PflM0bzm27zxMU23SpNjPlkpSOUeSvi5c1Q0ByUmsrwKwvYJdLYp8LeeR3vB?=
 =?us-ascii?Q?vtPk3+xyjw+YEg3T8rgxczCfM1uYtS+Klh17W90+dU7U2gCWv0+b6JICwttg?=
 =?us-ascii?Q?j4WgAGLwUBBGrU8xOoMol7Grk1gPbJUTXqAqBhJfD4bwKPqj6lKKJQjs4nVf?=
 =?us-ascii?Q?HEiOfoahhEcP2P0vMr9vgNu1z1NEh3DbIgUFa4L+ZHaBXWV7eN9NLfoqMzCG?=
 =?us-ascii?Q?7z6TPLLmS1DNXxqMC4GtNSmKCCZBez5dKtYCU0NBi3FqbAEncUF7kV9D5V2D?=
 =?us-ascii?Q?fbk3QV1WwlVuTiDNcd5B6/ZDdKOlSliMhuHSmiW8aTNXtSJjjcPw0jomd4T1?=
 =?us-ascii?Q?sZAf/FcF9+Y3S2JbYG7GQP0Lu3IDyOuJUu2n8uRBTttTgEk9c1OGAVHF6HA3?=
 =?us-ascii?Q?CWXedmVeQ09OdTF918ss+cR9vog1YttiOJlNDSMazv5B3YFvae+pDzD/OjK8?=
 =?us-ascii?Q?b100E/TS4+YJPCEaraq4jeasuRM1JCtAvCTk8Cc7AtJAUqyoBeZCSwQUf1SE?=
 =?us-ascii?Q?AYzJYKzwLM2z6spDDcRIGbsgvH03o2vd9Csg1ITfe/oYyOh11B2vVMo067Xa?=
 =?us-ascii?Q?gw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	CyoMX17dok7AJcIKU3tuEE75uLjTGWh3QzYbm69hVzI+GUlcYSpmnZPfgLHUtcq60gD133QG1R3ycPw32yTPj+uLVm7rRmEVHoASnCZ8iztPSQtU9BmfaCGfdxFs+cTjTmFSBzQ1BvodrfsQw+eibw0rrO2foLx+gkUS6V36JniTsTllglPWIFXr5tNhpNCnW/NIFdj0UGjCEF2YidPjqK4ndO9e5w75R8eT1PsOKCKe77/UqLdR99N1L4t6VYx6lt1O7YocO1QXXaLm9TFyh1yxpOloWSIiqw2Fp7l3xr8smdS7LRa7Mei+SH/oBUwbkcEatLjJ0Zy11b6VFunyKxD4lsQpSy8FdUNYr5TWeYBZVIqxgUTIC4FXzzHIH7WQ96GpaonwBtxB7OhEwmvj1iEfc/OvibtK41NWNduPTqd5KRwZp5I0UOMApz1TkwvQzKcTF+NvMSygAzqV/BhRHX2G0UMhFSjvFrveBiDmF1OIxRBzg9HiGm642Aiz84rbbgc5ou9UG+uf8ttSvhvgxo3KeQeG3OelUycNtJwxtGiyoqH6CiOimyQJPdA3sA6TYO336caHk56qr2Md0dyW9/GfPgcH5HFz+DXBvj95osM=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0776aef0-f4b1-49b0-4e55-08de223879cd
X-MS-Exchange-CrossTenant-AuthSource: DS7PR10MB5344.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Nov 2025 22:11:49.3124
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: r5hxOrT2PdFXPo2lAFfbgMWO4Qgd2Zopzg1hQolYxgN3XHz8F96PbkGieyX3Os49TyhnYmNh04z6ePHumhs6/GqM6nS2LDmGNZd5H0sEN1M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4808
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=527 malwarescore=0
 adultscore=0 bulkscore=0 suspectscore=0 spamscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511120179
X-Authority-Analysis: v=2.4 cv=bJUb4f+Z c=1 sm=1 tr=0 ts=69150629 cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9
X-Proofpoint-GUID: WuY2sY4WRf9Jty3lhuAB2VL8myhEgf-E
X-Proofpoint-ORIG-GUID: WuY2sY4WRf9Jty3lhuAB2VL8myhEgf-E
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDEyMyBTYWx0ZWRfX2KtYD9nfKddO
 Thg5j1WZmWJKRVjF2qRFFmmszbltgI5ScqbqZua3aq3e8dKxBimCKKrFoJsgEN8NjvXRBrUO8Ia
 cUu03FIJlZ3XMLZYeEm4z9WJxxSQZIJW0PoG9kiT5joRYczMP4sMHIFJLkixzgMzDmmrPKYiAfU
 w5aedxXh4AF6MtCrjc083zavGGdbZnOMX6NZ71P0P4+9DciohfB3MFLYaixiskVf7v7LjL5Pl7k
 XyL6R6cx92bPNN42b18Q4b+ZFs0zmace1uZ+qrsMIgG8jLphdiv6MrJa1v2hFqwHKP7cUMc4XZl
 qezwdKaCYtRwBEQSRh5+x3Sm5cW1Hc5gYAAIqT820SrSxprr2ZFcO1WFWLSOp5wref34oko6Kx4
 6tyy/MsNUJnQ8UsR61fMQN0zik1pLA==


Bart,

> This patch series optimizes the hot path of the UFS driver by making
> struct scsi_cmnd and struct ufshcd_lrb adjacent.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
