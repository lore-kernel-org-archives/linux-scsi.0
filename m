Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DD972AE99;
	Mon, 14 Jul 2025 16:54:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752512047; cv=fail; b=CT6ZyeyXGxsivPcOSo4ufX30Lub+oj0cFeqOuKPhAgyn5rRbTnEbNdNxihWseL93VWc6fDUvFk0odxjOc5HXejjSmFhn1vr6CQz3iEb50j2pcC5Wu4O70wcZBx5fiG9vkD/ee4jJJ6283DWRG2o6tA4LDmTumw6Gx+tGS9Bevys=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752512047; c=relaxed/simple;
	bh=MQVS6IgFRLkljydO46lR12mCn5MSHl6u02Ti9fiwy4g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=tTKMzu3Lt4RrtVchNIdLezYVryA6Ii7P6rrf92aX7y9WAJvt7ADyvjZQFbW0r1GPej8oKKjcFojrjw8giecDeVDsm7omufMsWCQYXo+GUqV/nIQ3v1kVAmqM5Lqw4rjKVKMxElUGl48G+EmbvZVb6mIEkf+0N4HT8mwlm0MSWtk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=sJivDokg; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=KjZfh9qp; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="sJivDokg";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="KjZfh9qp"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 56EGl9qJ026762;
	Mon, 14 Jul 2025 16:54:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=5Pn33h5qNOtt+LSuwB
	SwEkwUhLZ9sLSpH8uxIKbY9dQ=; b=sJivDokgWBXjm/m3CvK6K2kOmjm+9n2SlZ
	hlONQgGky7NAmbVXKD24xswGe1UCqsOifs/yvIp7AjLoN0BXuKsns1JOdcXA8Qnl
	pcExaWphF/vMoV2p0DjTK4oq8D6wx3arIFmMT68F851VC19J95uqUCBFE2YSXngq
	zSRZyaXgv+UvoH3GGbZuWHLaxZ1/q9fRX1It0p84VNLTuQC2bWVJ/HJQLS17Tp9U
	6Erqd7M9kW9/hT78l/naRjiQOrSFQWpCD0N5nvRXZV1YpUg8DB/2Xaw5fOXeX15z
	jgeGknIDrxFuJ/qjMtBC4WWcvPmHJCRDOBDGsatICtfPNBBRavxQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 47uhjf522b-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:54:04 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 56EG1okB030314;
	Mon, 14 Jul 2025 16:54:03 GMT
Received: from cy4pr02cu008.outbound.protection.outlook.com (mail-westcentralusazon11011066.outbound.protection.outlook.com [40.93.199.66])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 47ue58s4an-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 14 Jul 2025 16:54:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=UHW++sYr/gl7Oi01DICtMnBG1/cin8CEqwNx+0D851AlueMneT5XRxQfjkRhE0IRZTBC3rVZ2hY7D9vneilAZtT+5VHjVmxHY1am6lXbgHKgbkVRG4XtyGZQOvv4w5mNSwEZEqRCDV0J2+gjgXHt8f/4HBCjk504XChN5TZnvRlsewzGwnM/v45WfYBC25eLGdD/phEtopUUzzlta3GPFCmMh5MomlpHzB3x1UbBf+Oao7VXJaMp4a6vGcFINrkUhY0WGzcSFbf7T/CsN2gpT+GK352+Zkez37H4WopDHnFaIMjz3/VCPpgPIjYnVRmSfc1zhm82Co3vJg56KpEorA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=5Pn33h5qNOtt+LSuwBSwEkwUhLZ9sLSpH8uxIKbY9dQ=;
 b=r5Aw8jcOwRBSInlB/383PttYosqUC6QPt2Re4o2+FWLqNx1mIFJREK97CjyoXslZcsgM4BpYjn3qiQJgTIbTfOC6McjY1qOPgxPv9wIV25jNB4yaML0ijEsZRlYH3FVzhcX2MEHK5P4OuxdL2nRmHvlBZ2lvTdWZwCk16yyJXRGREYFrQvJujS4WSASukZr2SB+x3JMHUjIzYPUlZpu2aqlC61o8J2TAM47VynkamK0P6920xSTK8QnGFSb0XD8eWqBd48+qDFL+G6MUKmOs+MFgwvLZzywFtWooRPSW9MRdnOP5sx6CwOiSqRuyEozE1Q0FNNjHlnVT9vvS1Kp7pw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=5Pn33h5qNOtt+LSuwBSwEkwUhLZ9sLSpH8uxIKbY9dQ=;
 b=KjZfh9qp06BPG5H+JVAZGR/OVdVkVDR7M8vz0a1THxVKajU5rQ9lNqm4uX29B4rC749iSX2L1Q0BPyQf/Nj0M9WZKdbSikPZOF2c0p6Gk1wItm0SUaVJCcy+3VylbOqZzwGTb12x87X80HyepFQoaYLvByhNiaUTDUmtEHoZ58k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH3PR10MB6882.namprd10.prod.outlook.com (2603:10b6:610:14e::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8922.33; Mon, 14 Jul
 2025 16:54:01 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%5]) with mapi id 15.20.8922.028; Mon, 14 Jul 2025
 16:54:01 +0000
To: ankitdange37@gmail.com
Cc: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: ibmvscsi_tgt: Fix typo 'transitition' to
 'transition' in comment
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250628125320.295824-1-ankitdange37@gmail.com> (ankitdange's
	message of "Sat, 28 Jun 2025 18:23:20 +0530")
Organization: Oracle Corporation
Message-ID: <yq1ikjuaf41.fsf@ca-mkp.ca.oracle.com>
References: <20250628125320.295824-1-ankitdange37@gmail.com>
Date: Mon, 14 Jul 2025 12:53:58 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH2PEPF00003853.namprd17.prod.outlook.com
 (2603:10b6:518:1::73) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH3PR10MB6882:EE_
X-MS-Office365-Filtering-Correlation-Id: ee8211b4-b875-4e99-96bd-08ddc2f70859
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?gxqcv6Xr9km6iHDo3oMhOO5y0nw1t1AqB5r4XcOoHjlgCtXS1cfLL+TUP61c?=
 =?us-ascii?Q?vIGb4y1BqM4z+mycsDUOoyMiNBjCnSOvGmkG/SlSD834H70mcGp5B49DjRm9?=
 =?us-ascii?Q?fcXjNOnXzIoWxP1oo3KAsUwVzFAtVipTytbKE2Gu/OO7eqMMGp2+pWORclsa?=
 =?us-ascii?Q?R9DOXWZAdKcQyvpAQn0Y30Q2J5UUBlthyuhYsuL39QJqYXle1UwVG/RM4WkW?=
 =?us-ascii?Q?vKoPE94MEo9LzL1gpO87gcWPJNyoFw3WZNKmf64ewZRVc4BnKbwaXSrXJRZZ?=
 =?us-ascii?Q?1G0UWkdEy9DQq1bw9YgwFnZo7cs5xZjJ/HSmx27AmoBA4XRde/b4vjM0PslH?=
 =?us-ascii?Q?LlMzmJIYpE4E5h7FdGWr5DTn6NoUlme/yA3g4gZPDj3ni4LO0Vp8epkyqIrl?=
 =?us-ascii?Q?xRNVTYMjMVtB5KzN8csVv/F4NuQHHzEdyUfh2gr2HsRSLFHN+gdHiBNFdoG/?=
 =?us-ascii?Q?j5tfQvytXnL180umSdTWfBCbe955dprGxNzu2xtemsQefW32DbGZ08RLIID9?=
 =?us-ascii?Q?UJV/WlAoR4SEpKdeYlqf2CGFI7+QCz2BQ4vdK/AwvaBzyv+lT+3+QmnUdBhN?=
 =?us-ascii?Q?WsqDrVdyeu7QiIEowBFnYadDx2EFdKvonOh00XPC6wZQhe0lePBlNANkq/tn?=
 =?us-ascii?Q?SsGBfyW/wYbzhXbTnqY0eiOCQ94h3NinbEPiNWQYzVb0eFSWeIfplbQe4mg/?=
 =?us-ascii?Q?cs5jIqBacO5Z7IqH801jx7w/p6AWNlPlfXXoATA7jZJUh0lWrSbYZ51XiZpI?=
 =?us-ascii?Q?SZ/mfuO+0iUiYpZ57d8qyTlLGJuZbX7wQafkPf+a2tdHUtN5JYQ3D3pm7LhN?=
 =?us-ascii?Q?f1iOTR6t0gwbj3ScPV6NoG2tIk8UASUXPYL97oaHMUtIKGZL7sm83WhD+Xrf?=
 =?us-ascii?Q?/i9k0eXKDywu6o9FtGckFcZyRrckpFaEIC2+AU5lzxsw3Uba8/Hk2yKfb//J?=
 =?us-ascii?Q?8uJ3dZ/6M1QZ8OFW5Gk4ZhqT5omf6OztyzUKlNUjNnu92DWDhteszy6ugCqG?=
 =?us-ascii?Q?KunPLX4uPxwKi70bolHJ2ZycpLOnWaqlhAejezlZa1roauNfCIeu73DbBZ19?=
 =?us-ascii?Q?QrzE8F0T6qL78q6FS+RNDS8IoON7CJw9eaGFTe0ZBUxRux3WgZsJtPJecgS1?=
 =?us-ascii?Q?nMFuSglrcXCDFPpsRVlYST+109UYiw0ebVZ8LGWgDtZnXY2rtXmT2ip60DFp?=
 =?us-ascii?Q?7LBpuDlWDH44jrsevT77Av+CtBySkF7J7JgJ1eIZVkI/oZmq4nFjR+M19Cmk?=
 =?us-ascii?Q?PlK+DDKbVv2KbYAbbDdfXikVp+bQXqn/qd03QJuNurTxeXjoodASSVixOQI9?=
 =?us-ascii?Q?Z6KlsL5Azew5sDxuNiOBrNBLR/QIrMna3s75uTH8mCitRWCbRFJZ/bWMdC9+?=
 =?us-ascii?Q?gkTvhYzrl95+53jLyX99xPS5pbuulujwbs1dzTMWlTQ0bEbmCpJWiEbvgiIm?=
 =?us-ascii?Q?x6kSBvLuhZg=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?oEB3xxSjAojdkWHVa1z2kfwhGEL62Ymg0V6+/Mpj8EkqgyezCb81XQv8krsE?=
 =?us-ascii?Q?cA1erINXOJZyZOUGToLiYXc5rSzJ1U56zq2Cha3+ILiRxvwKSophggyGVNmZ?=
 =?us-ascii?Q?5MIrYQGw5sTNYPxHs3WUX69m+dpXvNZ1o0OZYOZHepwL2Q0js2MKkdPgILRS?=
 =?us-ascii?Q?D/1rM30m28i3iy38gy2/1lYcO9LQzm5ZH9vp3qzFcGA6CUNAEZkJzEIW6Asr?=
 =?us-ascii?Q?QZPvXKW8KyG20rvP045VsGv0oQ7BGTPD7LCxIxFMIsUo99DhbTDtpoGCLBbB?=
 =?us-ascii?Q?WThXxG/wFv5hXTjsgYCrc3eNyYLuD1ZvAo5JF7irCgqe62IWwKsmnRZd9ryB?=
 =?us-ascii?Q?Is9qqaWWTR6HO7A3wb/rfroRnAql39NXv+xM8xd4gQgLlvfyGDGg9+nUk4iu?=
 =?us-ascii?Q?jOENljhLc0GpsKGEX6RE4z5B/hKKfRBd2iZ06dEZpPHiETNVm61DlnxFsNnD?=
 =?us-ascii?Q?IJ8jHE37n1QpY7wJ3nFrchg9LOvvDQ1c1qz9L73eT/e9TEuMtuLuYg0PKOUe?=
 =?us-ascii?Q?TgrBi2kgyFfyXwkIwlDtDKUTwvYFMCuGaoMZatFBCcpsGy9FhhHeH/TTXQ2x?=
 =?us-ascii?Q?sBaY2CjFZKj5PB+Andzkd0xh9H3fwmbqmPdv6uGhv72uxuasmwWwRSOTvJTs?=
 =?us-ascii?Q?NgdA4ak5xFZBfexYJniTUXoVwnsxfwcPmvHkI2LgjYa0DkclP8QAl3lH/ixN?=
 =?us-ascii?Q?90p0S3gwiBA375EY0hoCgwvTsPmOaXAWG81GOeqECLK0f5d6UPiD79mSlLL2?=
 =?us-ascii?Q?XW5z86E7uH9eAV/7kJMltpz/65LiY/mXobdOkTNVypE2OMKfXrTHnqlFOwbC?=
 =?us-ascii?Q?XNI9ilNvShFmwCbPKnCpXmpmcKtyJJYGyBSl6kKS1gt8TxN9OOqvIpMdJOVv?=
 =?us-ascii?Q?SrBqyExGVaQ1842TJ2nQ2dSoNS0KnvHHRc2tCjnPK1yljAKENwyaxPVc6LCm?=
 =?us-ascii?Q?A9jB5UnwDaTtR4FoEEATlZK43SFuUknY1P4iPpkBsjPpIjXhjuE5Tddwbb4A?=
 =?us-ascii?Q?17qc/KjW7PPfhWCH1amRS4lS68Tg9w0Oxctv4XA0I9vJwsdTvqpJ5x9q/608?=
 =?us-ascii?Q?mu/EB1+HGcPJ37AnkMBRDv4YQGhf/j3pOUA3YHZ0z9zI7FVF0ejvz+BBIW5B?=
 =?us-ascii?Q?z+L2tV5EEBztwb9kyr8+nWNLZ/TNYnfV6SzSeKq/84Msv1C1oDheQJNbji4B?=
 =?us-ascii?Q?JIV6wKUdy3AqJVxQVXuQIRPUNWXWVmp2kzHseHBL32V5XONLR4YEsNfCxcq1?=
 =?us-ascii?Q?jHwfoZXuysmjFfE+GfNJjm0jPRrjpG0DeLD7YvwKZQEwJm3k5Fwl2k3LEOrn?=
 =?us-ascii?Q?Yl3tsnxaTAzU82qUU1MX7uAPCV2Byf+NuxpkXL8NooY4LEpD+HQXUkTatPsd?=
 =?us-ascii?Q?GK/VdS9fJ2ups5eHxDU69q75cc7jDAqwLvMOmfMg/2wHKmSHxckNng2ijxEw?=
 =?us-ascii?Q?k1tLd04wPTlJeYMIxmg3TWR4385TO9XXz6a6VByP90CBBrCAhSLqRW7u23k3?=
 =?us-ascii?Q?qmcvQtHHOM1an1c7fSieV91FaOXMDt2XxTJocURCCcPFtg0MTBdoOQh53n/k?=
 =?us-ascii?Q?h+FrGLsGi0ED7s18YjeDreH9Gt6C76wIoXKWesGEk2CTz7UF1qJowKokoR+k?=
 =?us-ascii?Q?vQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	2X3HbWup2bJfk0sZjIyjzP1mFKZpcnPq+w0hU3IMbXL7f7bD6LTgjo2EAVgLaGWwrgPAQD67+0JBEDfoDkrdtzZfqEkLN5npXxi21+LQnlpEMm/QzNQm/2Gd2lUj+81gTG/fVU0NVtsx126DHVPzwmXVbMX2uSUbmxL2s35f24eBaPiTRre/PDtsV/Kw8ODb4rsN5prxIPl/1Y+ELP144OiKP541i559Hm2FB5oPJ/a1ZRwQuKYjvJKtbz7TX9e6IclZKcJ+mIWS7ptFyTVhhosPTtmXzmkSZrgH/oPGRn4/OCL2o59fLA1mg0LC6AuE8H7/HDs/p5MBXtXDt4xYLWwlaaXayl0tlw0olVfEjqAzpQ3nN7nbURygqwMSzQ0diKccXy73Ge7eRJ34gBm2KT4Mb/vZY0u3D5Ni7YB2Z3oPlbRVt9hVbhz/4Gv/ZdhrVf7ouTZtYZurU455520aT41cdzMOJ5TEbnWy9bAS5SOj2wna20JHkncEdLbthbS0Kyv6zS9ZL9Qdyc6KxrkZq1cuW53bIhYpE60vH9J4YzqPkRWiYtfT5Pjvejm2zGDcSnlQNZ+slIa7igsnxk3RdUydoTY6kFGYy2v4irB/ua8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ee8211b4-b875-4e99-96bd-08ddc2f70859
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Jul 2025 16:54:01.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: VelkZdnPpsIeZkuPNoNRm8BofhQ6gv9AK+Fdh0i2sDe3TQa3NodDLF0ukodUMgiZUDBG7TJtI9hrNXfWFr5IrcBrnl9CnCgXzGFNIqSBNns=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH3PR10MB6882
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.7,FMLib:17.12.80.40
 definitions=2025-07-14_01,2025-07-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 suspectscore=0
 malwarescore=0 bulkscore=0 adultscore=0 spamscore=0 mlxlogscore=804
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2505160000 definitions=main-2507140104
X-Proofpoint-GUID: WL22uJN6bvF1b71qfr9_yTY71lHRctim
X-Authority-Analysis: v=2.4 cv=O6g5vA9W c=1 sm=1 tr=0 ts=6875362c cx=c_pps a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=Wb1JkmetP80A:10 a=GoEa3M9JfhUA:10 a=cewXuGIsSzsw8c2jRYwA:9
X-Proofpoint-ORIG-GUID: WL22uJN6bvF1b71qfr9_yTY71lHRctim
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwNzE0MDEwNCBTYWx0ZWRfX20uI/o0l+kut UtmPKHGG4B5gVo4lSwp/k5sBCmGzgbeqgJ+ZTDxKAZxwVZBOTkfIcx/XXjC3pKuAOWJz0Zjk8sm xuWj3+FMbLgmUiWYH1m7GS9vrdsnF7VP+x9nth4csJahX9yDfNqa50tKsQSwn7M/bgFo6V25ETu
 pnMo2kQ2KFPnLkU8lft1Gle8SjeifbxBNCK8yhr1Aq5Uq1B2HwP9gIkrUwxmr8LL2jsGDHI8nzm qi8AiWua9+wmeHAezEZ6zjjiqT7B2Mx1hdAn9eJUjZOcceddYJI+VPnz17kmsZMYEiBGIciTxH2 5LApF4HQLrGNpSKqQG7H+zVE1utuP4D4JBgWaq2UgTw7imyahQ5GqVjho4w8zo3finpwtCnZSyO
 THei/oKk2cnZM8+5ll9qlzPCaLaUMg5NFW3Z7kpFPgBD+zsCQTtyrDJrAexQhBIr2wyIWUOC


Ankit,

> Corrected the misspelling of "transitition" to "transition" in a comment
> in ibmvscsi_tgt.c for clarity.

Applied to 6.17/scsi-staging, thanks!

-- 
Martin K. Petersen
