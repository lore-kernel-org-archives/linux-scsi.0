Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54C4B25A634
	for <linux-scsi@vger.kernel.org>; Tue,  4 Feb 2025 02:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738637345; cv=fail; b=g6TPV3A2ZUxj83bzC16Nx8eBmgHIxy/I7LMKmOuymv+SgTTRd6bNlRCH/49PBADwDtXeEmVS4XCo748gFGdvsS6Znl0IUCMOA38uKo8T3SxzoVB3Ds9T37eIyGG/8GXIhgjSOyg0+Hr/+gJ+Z0WBqN/9AauvNnybpUW4mXCKaLc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738637345; c=relaxed/simple;
	bh=E8iG6dtAUo4NGDBLEF2+Tv50ic9hGTXPrvoKaBoOceA=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ATNSOXcCl0upn0MZYmeuwoSy5xk20J6QBXZOXrZi30i2JVPB57lRWtHe3ZZpyr7ZIdw7f6aSJTgXr0aJHO/N33gtp19FO7Ege9csvi/9m7xfrl4ZX309M9kh0oLgzEcs4ZuwsfFbtyfVBzRLT1FW4XJkXzlrQS2p3kM2EwZE1NI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=P8A7But0; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=CKiHFP+j; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="P8A7But0";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="CKiHFP+j"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5141MsKf020492;
	Tue, 4 Feb 2025 02:48:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=p2GXtpP3M1sbJt/tlA
	9c00hLc8dOc/s9Etq2oUaEA/w=; b=P8A7But03TEftJk5tCjrCILK3UDmE43U3T
	95vu96VqUZKmHoeQUfGHoCfyY99S0ZQSSWU28G4VQq1GAFXgh1hW97dTo5B+Uyx7
	JcwNZDIPxxd38Tt/O2sXXSmUF2hOud1BPaUwInMO+a9ZeClcBWQMI+j3KvvasyPT
	hLedEMdlovC9H4TjS/VYBlkxzkD6+d4JXKiJopzhHN7tU+wJXDbWQ7EBmGJ5UQpB
	B822Nftr/YQ6jmGhXW2PcZNMRDcSdIVMJ4TAkO30hAjjEKHKGGjUlSxn5kEkSis0
	tRcnU7U0vCGEgGOBXhWH6XL+XuRkkL+uEir9RFS/RefMlqdil25g==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 44hfcgv2vy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 02:48:59 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 513NhJY7038962;
	Tue, 4 Feb 2025 02:48:59 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2042.outbound.protection.outlook.com [104.47.70.42])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 44j8e75m5x-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Feb 2025 02:48:59 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=lcizP108PwTy7vJcKxzS43dDXsag6ua8VodpOjxAgUlKqP2kYHXNP8ob8o2BkGL4yvGecBdbryhdbSt2Js2SKAcuo9E0SgVsKxY7zDitt5zChRIPbWaNKUtTNxhdaTUau+dB1JCv0AZrgJ9GXFIIw/2qoklfhOFrIz4foMAZPaPLWgngkMQqYQNUOd46l9llPQrL+NI5q90nifh9HZbzeHAHZOiIep1ZELMagx2L8xNyQ9s2Nr1E6ucUJvLdtcQ49Jr+ET4ICA5w9tr2I7WksVaT7LlbBezlYWTgTCh8vSOaTTZx/81TCCj7y1D9w0oNT/n47aM3TB9BqOzpiOvEbA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=p2GXtpP3M1sbJt/tlA9c00hLc8dOc/s9Etq2oUaEA/w=;
 b=QhwgLKAKoRC4131E/pc4f6GvEmV1UhL3zKTjvM7CeStBaCbGRScbc2bfDuuD2pxYgkr8PAMc+dWq3yQrA9BqJeZyHkQx7QyNW5X6RgGeO4zuGRb9OGkXBI9hTvvzPKBdMpXKdQ+Kt3TLShovWYTGdR0MdEsAdlNJ0F6PeWbMs8ICJBC3GgISz29ak1BB7PTViWS2lnAMZdk19zZ/CNNdNmUKmya1cmkEWJeqT2a0PhsfBQjRY8gcJfp9g1uL73MU1erDVfKiHj/5fvhUSmshiLLBRKnxHgWEYUjy+Mov2egYJB50DWsI8mE9rm60OmhY66bqit/Nzjl9+EMxd0Jq0w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=p2GXtpP3M1sbJt/tlA9c00hLc8dOc/s9Etq2oUaEA/w=;
 b=CKiHFP+jtF23tEnakv8YJ5aY0FCt35asNCnCGAtNzBglFBJM8ODLMav9o970Icq4YZ203mTBZZs7SppjIHEuoV6csBiVA3Az2dqGm5uOUpqFM8B3VVBAxu/es4ffLkrDwPaHk3BNnu1CDwJhD0FLrl1l/3g7gmUtvna5LYoIoBo=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by BN0PR10MB4966.namprd10.prod.outlook.com (2603:10b6:408:128::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8398.25; Tue, 4 Feb
 2025 02:48:56 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%4]) with mapi id 15.20.8398.025; Tue, 4 Feb 2025
 02:48:56 +0000
To: Ranjan Kumar <ranjan.kumar@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        rajsekhar.chundru@broadcom.com, sathya.prakash@broadcom.com,
        sumit.saxena@broadcom.com, chandrakanth.patil@broadcom.com,
        prayas.patel@broadcom.com
Subject: Re: [PATCH v1 0/4] mpi3mr: Few Enhancements and minor fixes
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250129100850.25430-1-ranjan.kumar@broadcom.com> (Ranjan
	Kumar's message of "Wed, 29 Jan 2025 15:38:46 +0530")
Organization: Oracle Corporation
Message-ID: <yq1seoufmr8.fsf@ca-mkp.ca.oracle.com>
References: <20250129100850.25430-1-ranjan.kumar@broadcom.com>
Date: Mon, 03 Feb 2025 21:48:55 -0500
Content-Type: text/plain
X-ClientProxiedBy: BL0PR0102CA0044.prod.exchangelabs.com
 (2603:10b6:208:25::21) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|BN0PR10MB4966:EE_
X-MS-Office365-Filtering-Correlation-Id: bad9b001-fc87-4e51-7c66-08dd44c67814
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?YWy2o/kCrGC0TbTt9qLZy4RfzM4K/gsAE5abHyv6QyjcjLI+Cnyf0ionsmK8?=
 =?us-ascii?Q?euFM6nmZtCuhQZxsyQtiiPta6Ja/9d1uG4CLtVOoLCJY5y4HKKLS2aQWgNMz?=
 =?us-ascii?Q?q5ehrXOaN3wZ63GJCI3boCBmmGjsbx4PNj4b2NFYQuJfk3rDMgaq9Qf3bMuX?=
 =?us-ascii?Q?Em9op8HKgADS2+5NSxrSiq/jGAGeTLNs+LNAbl8KB4WWC2gXFDbmp/Oarmuh?=
 =?us-ascii?Q?ci8cufHMcF0yUqCd3QZGweXqcyqqRSxRXo9B58AP1ngYzMmB5I7J1ALCO5/H?=
 =?us-ascii?Q?WPp77ClArS3cnnhTRLzTFPXwbwSK/2Jg5oVMa17CLibaNHpryPPgn5vYJFve?=
 =?us-ascii?Q?rOkL/MLTEOoEIIpfJ5Dxs/0LTTh1d7KxN0wLa7o3905uUNz5kAG/GHq5+CDQ?=
 =?us-ascii?Q?GOrYLxcVW7pRNu29B4YJZCW0qlO7JG2qzav6LeHbJ4+kLRTbIEHRfmXRK8DZ?=
 =?us-ascii?Q?bGT503Q0Mts6Qb0/6daz+u10Wog3hYcT6JPuxArLhU1L8Vy4azt9jI5ptky/?=
 =?us-ascii?Q?W6aNf8Wxf23LXPBOT5Y4KRqCBQfK2o9dCXThdxhWKwITLlyd23oM5R00qQ1B?=
 =?us-ascii?Q?FPhtzspdA6vr2aYNRsYSRzwpT8dEiWqL4XeVoj2GaE3p7lcO28bSekb2OT2s?=
 =?us-ascii?Q?rCJzS6qw+QW6FgI7k8YaRnrut29EKyn6gikpMVh0FJMjngSACgB9Gs8/5BGB?=
 =?us-ascii?Q?5ZfHA4O5Pwrzm3P58x/1JAas4NHxiNmGssM/Znbqawyw6pCkTLegLUYsH4Cf?=
 =?us-ascii?Q?2nJt513EqpllDHEjiIYJiYGX6Cpkimn/5A5oRRVxPNN6SGuhNauI+nU7vMRL?=
 =?us-ascii?Q?gvgOcT1lzZoTGK3XQnDpHAde6Ric2QSUxNzKiGKnkhgdOFe7ZNFMmctU8iJG?=
 =?us-ascii?Q?Rj17DoSHM2wyURj8Lyc2/K1xvlqO+8xbnlT7fjZCXtJsTwRAnGcv55uGhjzB?=
 =?us-ascii?Q?1HcrwXgopoSFmLt1zXjbabrWQ99bW/riTMXSdb9DFPLcvBcklpR5PoEa0qRC?=
 =?us-ascii?Q?n5pwn2pLPEvWNAPjdVQGHnSa27ylT1R+Z0ol9MQe3okB8kZA9DUrcNcaGls0?=
 =?us-ascii?Q?iBlzsZSSnvMfPzlsxH9qdQDSLbDxP4L2w/IdgiG245EXtsZflxkCGHH26SAL?=
 =?us-ascii?Q?gS456xp/I0cNuOC+s6fpkP2X0Yx8IhaNsgYUhXPIyMQv8TRA4+s8eyvwjkqs?=
 =?us-ascii?Q?95m5JMDRn2zFnV9NIYcYJNK/PI2YzSl2yaEhcpqmUXgXg7VuwT6pfYEXmGdY?=
 =?us-ascii?Q?AJX1xJT+HxNxM7OihMrvxKJiI85Dgy8JBOBvKEYiWWNfbYrkNeQEqnw2l2XI?=
 =?us-ascii?Q?gm7E8cWNLaxc3+RP3rjQRjYquqhnV5ZIyHUFzTA+z4DeCWhPGDvICzZig3tO?=
 =?us-ascii?Q?tlkdYOYy9Vxj1Wh9IGpVZbQsYxsT?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?MfEIyCZugqkUF1jouY9FP+ZQNsUrUFSDgI3KJeqkFAT6MiuLpYmfaNU2216T?=
 =?us-ascii?Q?NJPw8+RDymWA1EINn4FTSc1ZTfSF1YdWqORQZAmk1sb+3CTkKVgof6YFlexl?=
 =?us-ascii?Q?6ti8RJd0NI9zNuZ4AYZjpIlcyCUL/uPZ/51l2cYdjiqNipua6FHAzws7HD9R?=
 =?us-ascii?Q?aPAa7RAITXGrduiNpxgsNnyXyK3Qt3U6l9Rwjw8e6OZx55eNqy6ZnWjkBeMr?=
 =?us-ascii?Q?/88BGUFilh2HUzosgYR0KWclM5NF1LLjIwBUztXTxZkm6CsAlls3nixIxunU?=
 =?us-ascii?Q?IXVWhg+4vGMmnYZA7Dgy+P2MpzQE3L+YklHcMeS3ISGKVJVy4C7syTv9pzgs?=
 =?us-ascii?Q?dzYCMJwassjS8si8bRN0quc+7efxX5YArGC5jGdtxb1mNOmREsvwVjtRFY/W?=
 =?us-ascii?Q?j2l1Mm/qhz32+noVLgFXzDIa+QMLOtSVYpDmACB5qzg75id+Xc0eTsRaZOq7?=
 =?us-ascii?Q?jswdo3xhDU/MheNDc4lKtSJNop4UBFJ1BlPsMM7YODlx+jAWsUmWTZTgkkYS?=
 =?us-ascii?Q?aNqhn/wpC+/YV4jF3GrwhV6gVyEvRYB5PXlcTQz3oKkF0Q2hrF2AMheo/Pe3?=
 =?us-ascii?Q?XZVO0exW3HAet9yhWWVXpzI3Kk+rphBji0HueLqeODuFgzM8IU0AcQSrnH/g?=
 =?us-ascii?Q?b1ZgLgmpPiE+BmY3uUMvM6MndXETy7rp2an70Q1uq+iGmmsI3xYHdFttVTjx?=
 =?us-ascii?Q?DMZKZTAkDUwnF6Z468gqK61fGb1AULqDpvB0mu0Eyv4/h+xrcOdYz1ya7mKA?=
 =?us-ascii?Q?tgzsmVJhXjMxtH8FOsnpCDuP6qh/3WI+5dcTkbP8Di17QyXH1QVEhSjNqHu0?=
 =?us-ascii?Q?A4hGf0OOmNNFTQ6ZktluFA9ga/euiYIBkiy39yDoiI0tWVlhhXRNf5GcvV/Y?=
 =?us-ascii?Q?NB8/7VshX8Z9TzbdZ1Qep9Y77Ej3c7BBNznUBYiiHduOicO9Pf8RAXqVJm3F?=
 =?us-ascii?Q?l98W6wNXuFEfiFt7zHM9cZB6iEFjcCKkNosaMHCmqcTFdDntw1CRxjvspzSX?=
 =?us-ascii?Q?PIET3sur7g67OQfU0wiVhXKgcsMAaMOqY1eP5H69lBkpBWy0jTlJ0gfk8eSg?=
 =?us-ascii?Q?4u1RVfHxoGMOaGYKqcBO8+c29Vz0wO1D/dWJDq2i9hPdzpQE7z9EEc2+wuAA?=
 =?us-ascii?Q?zD64NSV9KteyAvx4l7XSLUraaIf+W9NKSu6sP4+QFGp5XY2GFAI4AilHVL3D?=
 =?us-ascii?Q?hTMavprnQdm4RPvJX63XMOYdZ4V4H3POZF+f5qHzdn9duF7I7x1TE3nEkKky?=
 =?us-ascii?Q?31yp16Xu/Gy/KtsBzbUNVyoQuxkgloqciN9nzhDWLH2SbLBGU+gaaZDl9lyQ?=
 =?us-ascii?Q?EESkXhOu/i452kU/iZc9mZmIak3g2vKvlpMcBaKi/4CF/BVaQatgAHk8GsJt?=
 =?us-ascii?Q?Hxa3/jihMga6hPTLBxuiJzIEbkDX4Rkc+lKrNehO4hqioCJLVrjGZw/b/dlW?=
 =?us-ascii?Q?P2//kKNCp7NEm1dpSsKez2bUWus9Y0yC1cuWTEjqvo57y+E9cX8Z7rdaE6mo?=
 =?us-ascii?Q?aq0mYeidsCWBiXZkIgNWHyQvRbFhsiVTm3utplb9pnKH/4UNGCisv4OWqy9L?=
 =?us-ascii?Q?auc3w4fbHP1LpaqwIjDSv16uFvM7vqMn5D2ZP6L7QrKnaNUgjFONyJaCPZMn?=
 =?us-ascii?Q?yA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	1KGjHZKkJJHql8T4GXpwi7MAKe/sqMBEqGZpLr4jTSP5SDYth6oueHbKyV23CYYVSE/RHxiX2VXC/GTGfCcq5IOAGGVQPG5vQRJL9tJQmn9i0u3i8nkS/Pp9GL0ppf+KJNfu1zzB1VXNX5Obc8IvYeadTTPHFfakTtYhZiwdqTxbg0Dw59fheIzBh77Ly+/DFgwCjXhm2XNwtcQ2IBlGIOa+n0XYgAvNu55VzLTssKHXQNHlpKIxJuAg76Qf+/HuJyr4JGv591sG00zy2m2DtTXKwbn6/kiuyQrOYY53FTZitVbq3GeU3tC7uE2dR0ZOUpf2c82oJHy1Aq27pVlXb6hbHqrsFFlbqOaLZy1g/tsKLhH0/TWsNRzzZ3zdS038lpY1ofwywm8/B1IvPdgpNyyCsDDVC0sz5b007Zk/FCRCV0iR75Imz4/nerBPJKa6XadiPm6jaUdsxxESO0ZqzgceILbv+PQvM6StNLlV3jsjJ+XfefqBu+IxEDeOVg/K1wiZF9TcixZ6bd5SbIeWE10FndmpeNx60o3FGftvEUBFmWmcfqYSm7WB4DBC1aCHTNFmIXAsKNKOXXV2TiNZhu4s8eZFhlNjK6GYw8h2cLU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bad9b001-fc87-4e51-7c66-08dd44c67814
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Feb 2025 02:48:56.6659
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qB19HeOcTeblFXKom9kNMg0oDeo1psuBirGsEaQSvDuFsizX0s6Rk1VUm3JqP7ILzuJMLL8pGG6yHteIHEWmG1OOJf6jyrevQC7unPMc4gY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN0PR10MB4966
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-02-04_01,2025-01-31_02,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=785
 phishscore=0 adultscore=0 malwarescore=0 bulkscore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2501170000 definitions=main-2502040021
X-Proofpoint-GUID: tSXupSEFAtmGUqh3yXtYvl28fvxcbZTp
X-Proofpoint-ORIG-GUID: tSXupSEFAtmGUqh3yXtYvl28fvxcbZTp


Ranjan,

> Few Enhancements and minor fixes of mpi3mr driver.

Applied to 6.15/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
