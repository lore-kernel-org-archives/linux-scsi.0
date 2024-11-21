Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C008713B584
	for <linux-scsi@vger.kernel.org>; Thu, 21 Nov 2024 02:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1732157658; cv=fail; b=eoYwdOt3pVOGg4zKvLOKmweIVKRf49OYKL2Xh6E8iCQdqFVsBQe0AjW3fzw8rdSGrWtmolLehxYMx+vO6Wc7DPCVcHv+X9euwxvFqXGbJm4fqIpNBdZ/ygaCRBLNI1mwAbt/FPx/fzVA8/VHbb6bdBzmDQL4EbwPScFuw8b4gOY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1732157658; c=relaxed/simple;
	bh=lPwkzjQA8gz+oFou3xhc6Bci6bNa8NlbLFsqM/Jm66o=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=ezBpHEQKfL/+KKV0NjcEiAY9BpIU5SLXLCG2PCjTLYu2XmQo4Lk0RC/PkSCTmhj7Cal2eCDWyQ5bl7uln52h5Kpegm9dyiBFM17it0NjsS7U99GEBx6YOY9qwm05ciy3nUwS3ek6z41yO+pOrtDMXGgfr+TqQBjZDkzWEIcOGCY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ZZa+7Qaq; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=sntx5yPb; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ZZa+7Qaq";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="sntx5yPb"
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL1gC1G006461;
	Thu, 21 Nov 2024 02:54:12 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2023-11-20; bh=MzfkG8vNy+sY2ev80p
	jzEQgbI6Mlj73k4+d3aflRkv4=; b=ZZa+7Qaq1rwuTfFzSLKOaPRZJumv/Y/p/o
	iC47fDbnuX1XxvqM+eopUhDtuboZ3tyMKbRc76PkKmRDFntlCrS/DF54H1QKxHsj
	ha+WzZlPBb9vXenPsN79TPE4XRR1ToEL6zDISQZBtP6WIwPWp0jw3+s7BTGSAOls
	Ech3X56U8IgSq5RkxiWKF0AfoVuOMERSk+A/tgB0l/61AA3MMr91rIsizaocF2aI
	5QOUVVqhHZwLPCfxyA/aUDigSVnYdGsgESMp2O5SJq7crOHSovheO3Bw6T5jZuX1
	qiPB51QboYKqMtKMOte6hbEmlE2Uino3C/82W7u1t2B1Kezc2duA==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 42xhyygqcp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:54:12 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 4AL06GV2037958;
	Thu, 21 Nov 2024 02:54:11 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 42xhub5v9a-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 21 Nov 2024 02:54:11 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yB0TSaybv6WBiVArD2Z0h8Zs5w54vR7broHSeUTZ9cQvbsa/v4+JPMkU8SrSFPldNu7BbokjrwGrAndCRCUnFyvy1RcsSB4e8JFMcBRoQznhfaeB2OIowlaTSraT03iA6MNgEy9wKHdeOvITsEfi/6tpcdX0sNVqZYm6dWHNwyvwUBmJtafycoeOnOWzw8yXApjmC4lH0pBaxD/t/OKN+zHBj3rGkoGtdpkcU3u2W5YlsmI+J9oUNr/RKpqJqlX1TYlWTroeQfuRlncqrssGbHNK3Qt9lxU1jYW5KXq/hf+W1GSoSrX/aptoubxkb71BmitQKC2GCehCDEOYOeHcGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=MzfkG8vNy+sY2ev80pjzEQgbI6Mlj73k4+d3aflRkv4=;
 b=WFDngNrwAnafR7Z4gdWEAYyWJ8SzCO5wsDK1dHVTHI067pYGtByRLhL3QN1B77wZMnQfLH5r5hvd4m1iHhEEKc3df35tMyYrL19b1tGY/or5NVfHntcjkOpYLERZPi+4FlTv5cCsGvPVdRjzjfGCfHIaML6W+vLhRJfLsFLoyMgqUqyh9GHTOKvmakUa0kZfOyleZYonacy96u4E58uWFkmu8bjOUCoCIJvNJu0yAi1eaMipl9Mb8M04CWNHiKrl/VwRw9nT6XQszzA4QwiZBkY/DRkJXvQzPJ6QreBxs/YZaUEHsVEm0oe5k4O4A5SLndYsua06ZpT8MKT7abkZ+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MzfkG8vNy+sY2ev80pjzEQgbI6Mlj73k4+d3aflRkv4=;
 b=sntx5yPbNkIxK1taHyjFbp4SfSSZAhVad2wwVYVXKDZWVQLmI+SVKYQUNArxeAVXE3MYMw67GmSBDB/mSQGiKfw5qYDCEKH6SJ+RlgmAHpOq0KLqNdvLFFCRqAP0ZrATxwheV3Wv8bkS3IdFQBPgls4knvbf3CR9RYpPwHjB0IM=
Received: from SN6PR10MB2957.namprd10.prod.outlook.com (2603:10b6:805:cb::19)
 by SJ0PR10MB4479.namprd10.prod.outlook.com (2603:10b6:a03:2af::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8158.23; Thu, 21 Nov
 2024 02:54:08 +0000
Received: from SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c]) by SN6PR10MB2957.namprd10.prod.outlook.com
 ([fe80::72ff:b8f4:e34b:18c%5]) with mapi id 15.20.8158.023; Thu, 21 Nov 2024
 02:54:08 +0000
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, sumit.saxena@broadcom.com,
        ranjan.kumar@broadcom.com
Subject: Re: [PATCH] megaraid_sas: fix for a potential deadlock
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <CABvwm=NNbtLa1e7aqCCV8ebkDYfhES+jNurbZXK4eA+FcdtDCw@mail.gmail.com>
	(Chandrakanth Patil's message of "Thu, 7 Nov 2024 14:27:17 +0530")
Organization: Oracle Corporation
Message-ID: <yq1y11dpa9o.fsf@ca-mkp.ca.oracle.com>
References: <20240923174833.45345-1-thenzl@redhat.com>
	<CABvwm=NNbtLa1e7aqCCV8ebkDYfhES+jNurbZXK4eA+FcdtDCw@mail.gmail.com>
Date: Wed, 20 Nov 2024 21:54:06 -0500
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0382.namprd03.prod.outlook.com
 (2603:10b6:a03:3a1::27) To SN6PR10MB2957.namprd10.prod.outlook.com
 (2603:10b6:805:cb::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2957:EE_|SJ0PR10MB4479:EE_
X-MS-Office365-Filtering-Correlation-Id: ec4e5738-06b2-42ab-408c-08dd09d7c521
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?6w8pjDr/QlbjysuVj15uVsmThDHNqfGdLI2f8IwRQaDjguLXVuRyb8ETPEHb?=
 =?us-ascii?Q?OQ2iI3efxfUCdNd8JfPL4NkWSlFpH+syqYXjv5jo3nU76Fm8D9zaTKBosQTS?=
 =?us-ascii?Q?8+WG1J1DpgnBFoiiCmeNQYqCjL0H74k6p5DxOjQUBsWfnXVPpNcJSkT9lqLt?=
 =?us-ascii?Q?okaPdGvJguBdonIdn0AVWdjYZRivkYsnN7WEHhMgUehHl+/3qyaosOmsq7D7?=
 =?us-ascii?Q?0XaU3cTCfsZYyd4uUEoEqa8Mdzdlq7TBRA+b+gLh6WsSqg0Dm6GI666MMsGZ?=
 =?us-ascii?Q?owucIUVBpuYGdW6hYxBGBVatX4JGS/VENzbnoxWJ8K9AF/csn5C6qTJeNiom?=
 =?us-ascii?Q?3TYh7cBcCWfc3+dMgznnFG3sWEDL+hjEIul5AzW2zm+f6MT5LIfJBBsiFLWa?=
 =?us-ascii?Q?oj1rvba9xy+jPl6iHXxbUgrwwnuhD59UXziGb17C1NtWILS0Y+cIXkREOoW1?=
 =?us-ascii?Q?LOpJHoyRBMJeSDWgz0ElEErHEcuFnCtUk9WsQGDVLEOLUqUjZ/eLxjTPgcUh?=
 =?us-ascii?Q?AZfxHu53ZrYJIYVouUEhDmbQfrg7pKEWOVo8C6HYL9oJcyXaYz1KA0FRUkCB?=
 =?us-ascii?Q?9J3dYwhuDXHlvJF9Ypj5MQ0zu9vqfcONhqvDyjhpwRUOBve+419QkakOn5nr?=
 =?us-ascii?Q?lWMIGoa6R0vbxjFuwpOqvhYeY2MLsGtSG5tvG22qp3usF1wJjte4Odr6ACvs?=
 =?us-ascii?Q?5VmZv1Q+CiwTYw9oqBiaL7dgzwtt1dZJvW2LF7e0xtTNptoGDeFG3WxJ5lzl?=
 =?us-ascii?Q?Ar2wFLGtzfnJxibH8hsn8lmXa4PD945mszKvp1N9LBvc+OiM6pIUAG9ifyh9?=
 =?us-ascii?Q?gdzwV8UBzvdpQW8q6fYrSQLdXbTJkgNpx4+eXr4dqJPwjlUzGTDRcNtqcf2I?=
 =?us-ascii?Q?Xjqa4f+ZuI2GUbdQHFh+ChM+vhRT4yFmLs39P6B6C7leuyEekSpBZk6VIhgr?=
 =?us-ascii?Q?EDA4Dv36QNzizRp8xNZQ5dKEi7BviilzccC6SA0s+IyjjpHj5qKgLn0f+TAG?=
 =?us-ascii?Q?ETrCyc3VPoxQkSONhlBtEPLm8uV2PsZNQ01fUvrb6/OKSnjBiAYD5KnJtmkP?=
 =?us-ascii?Q?6cUklR9LBjZcLIp/QQCECGSTfNZbNhSF0kg3BSF4ja+KElUCmJvDbVSVJlMv?=
 =?us-ascii?Q?T2pAaoAzLqC8/wIAHmvAd5fEayNO5tfZZ1sKQK3blmxmqHmSwYWWqPeSo/5x?=
 =?us-ascii?Q?UDn5mvcU+wlb8rLoZAYsiRzEP5z+JD8RSZNu7XNco7CNNfVLOkPg1YqJnFCb?=
 =?us-ascii?Q?LkteNMH+LygCdyhkwJazuWyEwfD8t9fPo9O6rjmSl7IZNmnqeRfGqaPUZoox?=
 =?us-ascii?Q?rYPgNSqf4JR1Ox/lyVPBq/8m?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2957.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?0srb0lKkRxUt8LcKneiZrt5bNcIFqxFazC+jQc9TtauEwI2KgmT400wSaC2B?=
 =?us-ascii?Q?vcCQxFDXGxMpkDOzTLnmoY4z/b4lExGsDKEOgTqe5qa7jrsR/ijgLQo9Szhk?=
 =?us-ascii?Q?/M5CCRy7+qzysmwQrnCzsZP82M/fS/nedQf23mac0oIbdq8s7K7K+d7Vo4Q2?=
 =?us-ascii?Q?vnp81rSmldTLdAVp/J0dho7IwwiH17dfbQQjfrGqYCNrLkFdAX7f9FodwLlN?=
 =?us-ascii?Q?OBfKqsbUoM7/Cwo1l8TXu+7M+PCoN85AAxmN4ptXCL+j2dAWsjNgcqaIruP2?=
 =?us-ascii?Q?UYK3egOzm2rVPgm5z8SdRmF1z/sZBIbbOfiGyg5EWf6Fy/pw6djmEghKZnqW?=
 =?us-ascii?Q?sdwZAdvGvTkrmGoU3iNFHlYhThjGNVOz3MelIRxZ8m9JIQIAkZZgaVkK0WKd?=
 =?us-ascii?Q?aoAjNkC596kDyBmSZVV/olfv1Sq4j42EcD/wP8ivqhqlZByWIP0PXvFcGN4N?=
 =?us-ascii?Q?FiHpSKjKFmnr+DG4Dxrq32O1t20CpY0cML9MpK4/D6xngoJSJpFDsfqCqMub?=
 =?us-ascii?Q?N2sfPhYklgdsIYOsKqCTpXKAWlfZu2QybrKHcBadn4mx8NY9WOvMGJonBDda?=
 =?us-ascii?Q?oavP9m23n/5bjOvag7bWWBnhaa7ozNhlLJzasX4l7BAU3Qb2yrr4Ca8sDkCC?=
 =?us-ascii?Q?s/CHTBCuF1VNVDs2gVMW5wlIHHlIb7Zr+MfbKu+9JwSDJkDm2MCDpwZWwJwI?=
 =?us-ascii?Q?rJ2SKUiumcTBEXUuNks3pusk8P6xq5m7ZHDHis1eCAkjQt+URmtmKGSptfdl?=
 =?us-ascii?Q?RQtm2aub14R5M3gOx2g7qSzwr4UCDdI/3+epN2vUmnohbnj9JvPyScHQviCN?=
 =?us-ascii?Q?Mq5asMiDDsPtBPNAI+FQiXvvHHJ86sfZUJenXbLScuvZsxSTRtD6un+BQFbc?=
 =?us-ascii?Q?mnXps/hBrNj2BiMxfqwlSPORTAaXYL3gg3DgKclcPshorOfy4klcxDKEJudn?=
 =?us-ascii?Q?tgVALuonYKPGP2Gy9dytn0GmEalinHSPqAamD8MXKoLAECiQELpIDNTAjhy+?=
 =?us-ascii?Q?m/vzqUzUlSaqnwCiJW/eqihFhljMX9btLhBR0E7BmWAYl9NB3/jGZz1q37me?=
 =?us-ascii?Q?P0yCAzd9Kq+7EoQ5AEfVCnEq5FH3aK+smSCMZVzCDd2af3j7J4kySKIBkgBx?=
 =?us-ascii?Q?NJKgBxBaFb5yvQZh8FzlEqsw5cPv5stNB78GDYJIW5YDYgNj5yOm99AQngaF?=
 =?us-ascii?Q?zboqmI6inrFq6qkNdm7WC7KSQc5onzHp3Cy/D+G9iUhMIh6N+I3z7yEh7kkG?=
 =?us-ascii?Q?a657UzSlJKC2ncbNzkEki/6Dqb3+YxEHS7RYCA/6IAiEwRpxfhl69s/nuQpI?=
 =?us-ascii?Q?VX/WzdF2l/Q+1/vrq8qj+JvRgClsFopJ+pqnUsMhPqaUeKPFKIHq1/yxYcyJ?=
 =?us-ascii?Q?yvtdBhtkhvmO2lgDXtnjwcTI4TWme5i5kCOS+mcbBpTFp9djP7d/5TFF2ZWN?=
 =?us-ascii?Q?hhp0QriEIvdJ/gNWJwka06w7loZa1XCgMgzaUATh9wOWrdzWFynNCwQppqbO?=
 =?us-ascii?Q?6/K7vFx22+ARozr5zL6+z2whohq2uY1UVtVpispsVAtV9att5aNC8xyYuRWq?=
 =?us-ascii?Q?YpY9fA1qfxpEUbXfeoEbypDuBorRoSucUWn2G3PoJDS5CZrIlnzI9ufP+tkJ?=
 =?us-ascii?Q?Fg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	UzVvwj6Vc2junnQBVyLHSta9bMs7CxDX5rvSP0SiuFHLIH35NGPsbWOJrhhVp/Fgu/ikbtGII3XhpyApJXJ0YTIfW6LrdS8oWlgOM39oE7kr1SXzUD7u55K73NmFHLYjQIq99Ypslp6XBgVmdgD8lDUCKCzv4dVgqvPvVhsDdf34VihJiBxI9e4lrfQmcDFwp9UllSzIIxNq04kOqooXADlsCpbT0xeWaEnI8Vz05HgqyLAuxar/3U32clGPT8FZ/aP4jTa9WI/1YawN9qokpclSl3RmuPcuI7OrmRg0n2P0Ppd0ImszKymrU3+V+RQlyNm8w1X08c+8mGm1S6wbFkNG4QG8NAcneSFs71lYhOuiVgltPFcs46MxFbtI+kmYLsqX8JurEmxalpioK22zAMhOMVvEwOFG1LRvk6cK3CV3KK/lbZIMPbofVrC/87CaeXfm30qaz7NwcJbqpk1D/6caxAmxnzztor7RGf/lo6WrFLwD6H/566qeZHiAdc4B0VzO8+f8dec4KSSoVHvMhjAP8TwWeU1akTpQXAPwQd5w31OcOtkAk2KSJlJq2/3sOCsByWf41f6dyUYfDoOSRmuzdIEfnk+/BMYKrx/vnyk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec4e5738-06b2-42ab-408c-08dd09d7c521
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2957.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2024 02:54:08.8142
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KwR2zqbaH/cj30rr9wl3AdFCv4f3UDsyyWVkFfacUFV9BaHrDLV07tpo/kvKEfBhuu7ZPT0APv5+xZVX+2Xv3dMH+bZ3KDxUBNle2skpZAk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4479
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.62.30
 definitions=2024-11-21_01,2024-11-20_01,2024-09-30_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 adultscore=0
 suspectscore=0 mlxlogscore=504 phishscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2409260000
 definitions=main-2411210022
X-Proofpoint-ORIG-GUID: HGc1BQM8E6Y8a7wixAoj_-taLbXV0rcL
X-Proofpoint-GUID: HGc1BQM8E6Y8a7wixAoj_-taLbXV0rcL


Chandrakanth,

>> This fixes a 'possible circular locking dependency detected' warning

Applied to 6.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
