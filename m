Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04F4733D8
	for <linux-scsi@vger.kernel.org>; Tue, 13 Aug 2024 02:01:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723514471; cv=fail; b=Aq8j5inBNOlYopRJYY2qhxBVPPa7usYfmPQSeCd6n57ilXAJTtrjqRwm1i1nXPPzJhXuI9scWcUwdG9w+KCPS3bsqVKdicqdeLdDGg60YG1/WqnOjuNkpwKZBHJM90QtcJWUg0qwI+7KtjaKWZuWjCrHFf0WeROAdByc6dGeJ4A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723514471; c=relaxed/simple;
	bh=owUywAzRdUjEkJy9zDTxLEhdlMpi0LX8C3bdLDoLOZg=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Sy8Mmce7sLM3tR6M9ctQIX6mBIg92lWJwW/sjKi79+YcfTNNZq/TJ7oCbkQmQV+/GA6El7uiGdAkqcHXFxEmhDfwA93UrjatFZ0IN8Cr2rMiRYT06hmmmk3z2tumgcWA/81Ordwne2mZGdUwCodjDccEXsUROYh8U48w83zd1J0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=XGuudacW; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jE7Qhcmj; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="XGuudacW";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jE7Qhcmj"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 47CL7J0K015026;
	Tue, 13 Aug 2024 02:00:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=kupxye+sV4QfEu
	58n72AiEjtw0REhiRF7TQMMWIpKdo=; b=XGuudacW1CiaDJLcp3cXICjTlpJHrr
	7yoibf9dlKOltJ5n2useguHkhuAYB/gBJnc7taey8XpNJPkXlXOgcVzIG202Llqz
	LHUqw76QWSq6LciHNPD3qVPWsIwWSN6u0J0YY6QdbSCsbJhfojCOFBqY95ZSdvz+
	Hh+EaZBy/eZit9eiEaUi8G7PlnIZKTxBpaEB5os6BqDygToBhEc3h9tsGADiNNTq
	BRcASe1dKfxTEeki4d7eEvT3mVQJe13l61y5uXW8rilby1zSCn5vjXu0IrUIz7+w
	EfSuBFQNv9Fj7K2+gLkSDkMG5W+vQuU5AJdmz/PgCmXluzzr/mUa4yig==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40x0rtmx54-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:00:55 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 47D17JK5003771;
	Tue, 13 Aug 2024 02:00:53 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1nam02lp2040.outbound.protection.outlook.com [104.47.57.40])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40wxn8ww49-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 13 Aug 2024 02:00:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=c7ehk4rAYgjmPrvLjUwFYv6twISl8fLeuZXotYYpvzC/0P6pl0uUPIqClEjZf0XZ+v+58k3ER0ZDcFbxGn5H4kC4ukJNBxbpvglxnX2v6kqbt226dQXk1d6v3xlhz7jQ3ub3irkHjRL7EiDAcZYIb3T+mdp2cB+Ywktj8EMhMAgK95fLmO6uz/wAD7rCZKZMnwVXfAQ8FXAy2LPx75GOmi4X4ufThq2IfMsMcueB1fgQD4sXfh/pUQGlyarzR6XUQ5PV2JYbyT7jS9gYoycyQUeGO9yYt1Ta3zvoHfI803dSRB7jl72bzoLCasYVf5D3ezF2FBY/ewjOJDupQ6PAgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kupxye+sV4QfEu58n72AiEjtw0REhiRF7TQMMWIpKdo=;
 b=qkcUBDIqYTImk50hxBwjShTq1EdWVod0Ni+k7dyeewKYjd5cxHPwEz8Z+tW8kJKh+AEFhTnPkoKGFW8wrrxCpM/STrt7iiDVs+146QVi+b2yvbVzkdy65HGpxWN+4AVmW4YzT4A5IMAjZYK8J6F2YV5RpvvQMSYUMreMiy966GnPS5Ahsky9kh9MrQvNAhXQDm99Nt03jNMsJ4ot3e4TFnUxXwBJp/1VIsZtO28by4BNudFRA6Ng1U+sMCJYaPRzQVmZl7b7iGhgZz8WE95b2KKlzNVjAQXrjSJzmlDB7Viu+xLPtk//NVAhBllYO7sBLqOKXKwaDbeBH/fvPMqldQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kupxye+sV4QfEu58n72AiEjtw0REhiRF7TQMMWIpKdo=;
 b=jE7QhcmjMMJhtKBQK1KaRTf0hNbkDlXLEwV0GSlVsjEp5R9PVXzKYZWW/XI2YQxUMd3fKzfBDLfgKN3XbG95tjjdexgE904ORsNkhgc0hJ3hxY6uuxCr0HaHfGgEWQU6AWMKv+ysOKlUQjCLku0U/YGRAPDWyKNYVTsaitgtjAA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CY8PR10MB7289.namprd10.prod.outlook.com (2603:10b6:930:7d::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7875.15; Tue, 13 Aug
 2024 02:00:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7875.015; Tue, 13 Aug 2024
 02:00:41 +0000
To: Tomas Henzl <thenzl@redhat.com>
Cc: linux-scsi@vger.kernel.org, chandrakanth.patil@broadcom.com,
        sathya.prakash@broadcom.com, jjurca@redhat.com,
        sumit.saxena@broadcom.com, ranjan.kumar@broadcom.com
Subject: Re: [PATCH] mpi3mr: a perfomance fix
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240803150433.17733-1-thenzl@redhat.com> (Tomas Henzl's message
	of "Sat, 3 Aug 2024 17:04:33 +0200")
Organization: Oracle Corporation
Message-ID: <yq1ikw5w5ao.fsf@ca-mkp.ca.oracle.com>
References: <20240803150433.17733-1-thenzl@redhat.com>
Date: Mon, 12 Aug 2024 22:00:40 -0400
Content-Type: text/plain
X-ClientProxiedBy: BN6PR17CA0056.namprd17.prod.outlook.com
 (2603:10b6:405:75::45) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CY8PR10MB7289:EE_
X-MS-Office365-Filtering-Correlation-Id: e8dd8ee1-627b-4ac5-94de-08dcbb3bbc5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|366016|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?akHsctao3JdpOSqp63TxEcI0b0sceCYJHkejf1mQzEOAujtaFH8joGBI5YVk?=
 =?us-ascii?Q?diNwPJR70f6ft7JZVHr0HSis2+zfMaO3lJAu9hzVkasDg41BY6c0tTFof0s0?=
 =?us-ascii?Q?ALifxLakaOSqKGzN5bwNPyFxvip2F+iBoxNaMmIFO0yVUtFeSqD5AjEUN8ht?=
 =?us-ascii?Q?wvoCXzpXdlRHanj84Koi2xaUuuTIuPkyr20lfO5MFUxioiw9q/abagEDcbuZ?=
 =?us-ascii?Q?1Kk6JZ6UnIpBhMrgohzqS3yFrEN8k34UZLHHqQfi3Hfq4yhzJzx9JaNseJcL?=
 =?us-ascii?Q?IVxyXhLSM197+CaVaj8+EX0+2lCCs7MWcAKHhpOIB/9x5P+/cou/s+91ZRtF?=
 =?us-ascii?Q?oGJ9ykOIMJMY5B5esSrUpAnO6TYyaBV74CN5RyjvRq/iySlKtYgti2yABkdx?=
 =?us-ascii?Q?dZVdIam7ytYwS9yq9hkm6YGFvRa4Y0l40ZaGtWxGL/dfmRb1KkDmneweFEwn?=
 =?us-ascii?Q?b23kWSTIoQqDjsNW86+geXa22ushQDGqi1KX4wlZMfOV9BLyD+1J7KuQ0M8f?=
 =?us-ascii?Q?MYcHdHYoDSrFyzT3BxYOsJw5gWWXv2W/lfspl4n2u2AnB9vb+BK4bK2+XHoM?=
 =?us-ascii?Q?kq7AR4T4aqQ1EHNWdlO3WU+zPD2WpLFpshSKuQN/XzPwhro+7OfGzI9woLBJ?=
 =?us-ascii?Q?9YKHV45Fa98ywz7U625242hJCJimD61wcgQo1UV6eYLNNlc/p8IGs5d6Dcok?=
 =?us-ascii?Q?XkJg/qX9pRDfXR0OTX6uXzwFepgFY+NRzJnxEMzooWJ2u3d9sfgeToX1cHQQ?=
 =?us-ascii?Q?tblZ8GEXDfUxbsWgYMXsnyTUUZuWpscQdHYufEdAIWzfQptVwQR1tZ5tTFnT?=
 =?us-ascii?Q?95PoKnj5y3wOVYTLIe5cC6EjiQAGQgeJk4muxqX2edZ/hD0UqbkeoFCZUEXf?=
 =?us-ascii?Q?k/BmLMIckX3VjgmXSQVPTUe/pa0eyZcYXERR7sZTGQhNoO2TA5+m357C9cHp?=
 =?us-ascii?Q?TJ6oY1IHl8yuPp78eQGjXzWtE8VSBfaEpzi2nUPCdGraeOKEJEI5uvnwbYDv?=
 =?us-ascii?Q?RP2vW3r9U1BgKSqAyJluWk2gPlE6RTTBflLDQjSsr5aK8xsEZhOLlW57ecS7?=
 =?us-ascii?Q?SPU5xL0VUN7Zoo9FR2Ha//qCWfHpCKFDiW6lSWHYdaEWHlzuEyvIi9nL2oYG?=
 =?us-ascii?Q?w8qZxqExzPlfGxwqNitJCrYDYHuaxxt/Yk2pgULIOvzsYt4QWf7Qh3Za6abt?=
 =?us-ascii?Q?SqoBO2EywaSbw0bkQ8NEkKC8OgNq2lFAnsD9EyV2lKIwdO7lWVUNJW5qxab6?=
 =?us-ascii?Q?Cl+i4YZr3B+ckLcuAlatAO2nuUU1HmCglxUUzBe3mDSiDkhW+1d1MXELyUIe?=
 =?us-ascii?Q?H3hQU95V0DtLnSJjTnfu9V9UFk1O5wQf+E2vsRzZjzGmnw=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(366016)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?cPnAX/yKiZNX2Qq9jderapERPZiWLcSir3qxdETt7KgDAZS7Frra8JlJnWAd?=
 =?us-ascii?Q?bgTyXzWs0mQIv6aP6cw7ZglOwDA5U8hM88Rz8alSzL5IXeDTw0ieiWhlNtic?=
 =?us-ascii?Q?hMRdGAlD8AXNZV0voe4rhu06qsAMD3q50Jfn6vXHm0Bvv0czucfH5/GlQrtr?=
 =?us-ascii?Q?dgKsLBQNPjjxb7s44i3zcGdzdLrHZWykJgHWPRrrkPqSUGI7pRF5Qfnwk133?=
 =?us-ascii?Q?F6NvjmWMJ6DsXgYc/MIrXYHfoTJdGxwTuT9848BD7rBSc8rjVRgtO/PLY6KG?=
 =?us-ascii?Q?Ph0Qo3dWWtmhd8mhcQiV0E1WWQBwxcCACCC6A4BK0wkS3aQ8lb0KTpqDlyUu?=
 =?us-ascii?Q?nBMFXj6GvLaXXUryJORHi9KRjXrtH3gLK+8Nym2kLuEv5AJvnQ4ONSvTIsbM?=
 =?us-ascii?Q?6vrL41NgOFCrsPwu16TL0cDMb8fUsR1VxyfTolmA9d8vh9V5eHQ02sX3Ji+f?=
 =?us-ascii?Q?9j+ci2VwU51hmXnyEsQLqi+7lTMPk0wId1Oe1KcVLHp3FV4hcxMEVT89nLS9?=
 =?us-ascii?Q?M3SPLgULRBtxNEDvo73u7mEObLflDIba2vpbpn5Dr9HrwAZpCl6svq03Rfdc?=
 =?us-ascii?Q?4hb4z2Uf1GS2h2EfOCgCk2fYcLdJACytXhe3A/oPygTGYQjsxMPfmYo8+BB5?=
 =?us-ascii?Q?aDzgUfLxpmqQyXxpRr6VAHNF9KJ7CLH5m7mS1ddlZ/xRbEk5pkBKq20qpNIn?=
 =?us-ascii?Q?i4MdM919cStRnxfXnQ55OWoSJ1ki0AguYZOv+spzEhwn0vIzgSteb2fqgc/F?=
 =?us-ascii?Q?VmPQeGgNxAoOJLUKCYwhbtp8Z38cDrruJ6Q1v+VRfnYAYUTZ7dWFjJ3p47Lj?=
 =?us-ascii?Q?2+3XK+TsgwF1dgjXtiWE3IlhDPuXoAz46TAyHRXGM00hxzIa6m/deH2lXFVa?=
 =?us-ascii?Q?h551QM3W7Cz3+YYo2RHQKN7sC47zRjTE3SSwUnFqqIkfaX0qTpTXgZA9BwpB?=
 =?us-ascii?Q?VXZ6MpasxMJDc+9Cv7Cu89zHI2xsWTwO3GAV+c/c00LoHmQeNXyPxEMfLC/I?=
 =?us-ascii?Q?Lz31GCoODeML0tlzEqhsHIz0MzUPZNj0ZvVZyP/l59kdM+fpDFM9k4jVp/53?=
 =?us-ascii?Q?+NsEhyEWdJT0/hE16K4QlwiwRDTGzjZLUhST1VLug17XJxuctA9O2rdxQy5d?=
 =?us-ascii?Q?mBG0vPJEWC3uPueqXYFKS51D40vi6U0tf3mPmZq0/r6/Jv+S75H09Tb9ojpg?=
 =?us-ascii?Q?wlFLgXNbxn2pNRxN5sjYmC/UCZd2kZ0CIgCAtChIZz9wEUkhj4UTIKDDQ/vL?=
 =?us-ascii?Q?WNxaTxACpDRIUL/N57yBToad07WHCPmckGFX/et5cMArd/UTbzeVkJVz4nu7?=
 =?us-ascii?Q?XdB3TjgdHpaoFPnv2LOI+w1Xah/W3kTXlvyOh453vkJdUK2SOUYipIiyOOch?=
 =?us-ascii?Q?/i8tI3gwmNTzAWOTgHVzan4HjWqXjsuaaPGDx77NANBtpRIeblaH3eu/oHAq?=
 =?us-ascii?Q?4EQojQ48JpE3oKqTUHAiVz/bIYerALKocCa/g4QXUhZs3I49oCE38oWx+Zc2?=
 =?us-ascii?Q?RkhFn3rd8CfEDTDJzZi4Hn518KpLghrRv3iUcdFdBxqXjTmtySg12sGxNYkU?=
 =?us-ascii?Q?AvkyiHZyL1yl4oUYHB60VqGLxVdvdwj1bZJuqKtu8wfuuBR/dcnNK89N7vBe?=
 =?us-ascii?Q?Dw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	YGbiUFWBInmR44ngTG+9Xf6AXKl7JEn6HVHFSt5OzCkSOMZgqIFLTVEtpgWStgQzXLGZTrDQ82+8UjgKYNQBrUatPAvfDUuRIajwLzAe+kRjwmzLXYO2w8NEuyQCQiDg7yG/5JeFIC0UM5uEue9IErai+qHY6idodjhvrQ5TGKztjNqsmLUrAZ/qrS6z0CpqvIjUvmCYu3szVpqMISJHRlU02Qql3HlIRasTpmdx/tctCocLbgVgTzalHUM+8ysdqZb8KBNRYB3rE4x1x23zKhwcI1pPv6ss4FSzblhBPHSg62INEoAox9YdPDsgedVp+f90qFBuukkKiRfLM/MDuYaaeCNoIjl448hvtiDCbFp9XEUIShXjXugvxObdcZYY8C+FRjSqyJLKQZuYfz5ot8lk6FnzB07MIOyD4yyjofNDDb5mQ0gIqvZVGcF5i0yKVqIAo6Ene2nC65sgnfYOwBbekqn8waxFbK5bH1zDoecukCJaS12JoYo77wBDMngsV31jTftXKNSkZeHJ/OMfsSw1bITXb+TS1ArCGKQznmtXXO2ri2elJ7h3/TP+0g98Kl/ybC3XvdZgGl2GTAr96h3zwbhKKca/Sba21YsO9xQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e8dd8ee1-627b-4ac5-94de-08dcbb3bbc5e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Aug 2024 02:00:41.8277
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vkcuyiyZRG1TJacUVvCiOnJt26tExrq48f0IWRJLS+iFLeQvxX8uW3LFdiLzBJ38ktE97Ehgqycba7K4ROcuMXR3X5JwwCqyxR8EYYYusig=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB7289
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-08-12_12,2024-08-12_02,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 mlxscore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2408130012
X-Proofpoint-ORIG-GUID: gh9QpITVMurtEzQM6mWr8HOQJwbu5ivm
X-Proofpoint-GUID: gh9QpITVMurtEzQM6mWr8HOQJwbu5ivm


> Patch 0c52310f2600 ("hrtimer: Ignore slack time for RT tasks in
> schedule_hrtimeout_range()") effectivelly shortens a sleep in a
> polling function in the driver. That is causing a perfomance
> regression as the new value of just 2us is too low. In certain test
> the perf drop is ~30%. Fix this by adjusting the sleep to 20us (close
> to the previous value).

Broadcom: Please review, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
