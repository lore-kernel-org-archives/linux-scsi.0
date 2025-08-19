Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1428BEE
	for <linux-scsi@vger.kernel.org>; Tue, 19 Aug 2025 02:10:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755569446; cv=fail; b=MPumATGBjsWp5zfqxAc65QyskrBhOZ0XHRn+cTrY/hvqUs+381y5SAksZ/AtkhTsFwsPdFGH2t4aJMZGSKhp+xzeEiRR89ntoL8OtCX7lyb2X3mnkEtlcfZ0fUR7TWrCLufazOs62JwnnqHs7sqKZJnFz/EVKDd5EQlskQFyUfQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755569446; c=relaxed/simple;
	bh=e77kfXm48oeAKJtsxSVjgSW/5BhmfU1WvpJVD5EIZLY=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=YpvozzaGZwhXZddp5L3bxRIbPXr3nKRSLrjNMkJjd9kaCxjZ0cyeztIXbOjKm/hux6GytbM7DGmDEnWbqrm0nuFTSobALHu/Ivm0P0b6WIjrFW26NVK39DsotacFcyNAFi1XlSOxH9PUs6Az15q4CO4lYvtF1ypgp6+94/gwJaQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=HnjTV88y; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=OYCY5Jcx; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="HnjTV88y";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="OYCY5Jcx"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 57IJgNNV011634;
	Tue, 19 Aug 2025 02:10:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=nATyM8YG2uM43VFQs+
	Bz3YKLLA1uAFjuY43LRnL7EII=; b=HnjTV88yI6zHlZVTcd64Ts5Wr40c20ffDc
	cq/gvXt1QxnW7eTYtqDu55DFDpxIWSsKnFye4OfpNmWzgCw/0x5rN5vzWwhDmQUB
	LlMEYdhX8/GkvxgPZdTSUojxMcuYuJt+cXv1Dsnx8lhIgKjRgUSDJWzyeS3JIW4s
	XEHGPT2StbHxoB+06vSGSe3dRpIeTo7IJqF3eKrruhIUr8w5bvkWG+kTxU2BdEiX
	ghViTKZF3unMzeE5U3WP9nh9fJS1RN66OnX0ULq151vJosTBpJTbijB44fVXOkCM
	eWQcs2hR4H9T7bxsXkCSRHVVtzfzb5fFQfgz8Wyipu6N4PM6x0ig==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 48jhkuv8fc-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:10:26 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 57J1ETGo036904;
	Tue, 19 Aug 2025 02:10:25 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12on2061.outbound.protection.outlook.com [40.107.237.61])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 48jgea94nu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 19 Aug 2025 02:10:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=nX6ihiW8wfJ2r8KuEiJ1rBrfNfxVrfyr1QLd4h/CJyNRHneEilN/4LLY6zrAPYDpsUqSDqvIXVY29Qk6keHysV2mZDjTRarfd37mBOKjbQQk99181U7IWjkWTcGG34moGdY15iXtJhlsX0IysByUm/3gVIBXKbrKo4pu/23Ix+0U2WUfOjrtxPh6cESJpCC65PYXM2f+O2fmPAOtJalZqb158yh5wLsa+mDlk93vFMp0VBgmdkSY+m+pnKNX5S8fFFp7L/lXZixnImah1MVh6cu4xsOQNjZajdfYgFe0Hg1mb+DZqepD08k0wuk1c30JSdbkBB5GIwNhdasDSHanCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nATyM8YG2uM43VFQs+Bz3YKLLA1uAFjuY43LRnL7EII=;
 b=f7hESEjsSejiuD+HoqS7w9OgkwjyP/461ZOMMyvUBORSMLfV9l+fGYqjL5juWJmPdojbtkYFshTeJZmDxZLbWNxycYbV83l+U+jGAJW0DpTpte5Vu5qLPK2igf7Rq1OMCzAz09q7yCDGQQvYMkGU67WRnbLpk+XknG47fY6TXjJE1b7w4wZxyeC9+9Ui4rMRyt34BqwI5jo1ay4bxlUHbQ0RYd2hjMQldNS+2jkY1CgQ1wDTxF0DeGTdpF/KY1RbM2/ukDwQHq9vvuUiNSi0GegY5/YJfsd6Ze0PfQNLyocE6OOijqLTl7BZzQ/h6TwbyO9eMrPquuIXPnEjCP3bkQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nATyM8YG2uM43VFQs+Bz3YKLLA1uAFjuY43LRnL7EII=;
 b=OYCY5JcxvScyhFJXwihoCysXEx4FAfe3EOssCSRlV9F3ljvOYBSBVYasxCYI/EeS2fUk44udrnjsvkUSJ3iHHhSQI3iU4j+Z2Bp/KpXhqgSDMOK50vN3A6egZWmguKrBctD5vQqQJJUaru1zq1dGOhu1IZxSQWCPiU4eWEJUkSw=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by MW4PR10MB6322.namprd10.prod.outlook.com (2603:10b6:303:1e3::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9031.24; Tue, 19 Aug
 2025 02:10:21 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9031.014; Tue, 19 Aug 2025
 02:10:21 +0000
To: Niklas Cassel <cassel@kernel.org>
Cc: Yihang Li <liyihang9@h-partners.com>,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        "Martin K. Petersen"
 <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>, Jason Yan <yanaijie@huawei.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>,
        Terrence Adams <tadamsjr@google.com>,
        Igor Pylypiv
 <ipylypiv@google.com>,
        Salomon Dushimirimana <salomondush@google.com>,
        Deepak Ukey <deepak.ukey@microsemi.com>,
        Viswas G
 <Viswas.G@microsemi.com>,
        Jack Wang <jinpu.wang@profitbricks.com>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/10] scsi: pm80xx: Fix expander support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20250814173215.1765055-12-cassel@kernel.org> (Niklas Cassel's
	message of "Thu, 14 Aug 2025 19:32:15 +0200")
Organization: Oracle Corporation
Message-ID: <yq1plcsxds7.fsf@ca-mkp.ca.oracle.com>
References: <20250814173215.1765055-12-cassel@kernel.org>
Date: Mon, 18 Aug 2025 22:10:19 -0400
Content-Type: text/plain
X-ClientProxiedBy: PH8PR07CA0046.namprd07.prod.outlook.com
 (2603:10b6:510:2cf::24) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|MW4PR10MB6322:EE_
X-MS-Office365-Filtering-Correlation-Id: ace0d8e5-35cc-41fd-314d-08dddec58d13
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|376014|7416014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?IkXvTb69Wx1yA3GpZiprNr+GYXD9U+3AG6utK/Z60NgRtPpk2x8nNKqQ1yU4?=
 =?us-ascii?Q?deQeeJytisCovuqNqid+o/jyiEgCZgB+/S9cUApx0Ke0NuyBrDpd7BhKCHDJ?=
 =?us-ascii?Q?J7n7tjUrsAme358eSNxaBPwX3W/Ij+wSo7uBsYqxMcgmqezHS6iHsxtlEM7s?=
 =?us-ascii?Q?k02+UWzDcUn0j8sxGA7q4fSsGkezl9RQRIV5mXuIEaQGhs9qo+LKkT+x1T+a?=
 =?us-ascii?Q?/1qk9uCCKJ8tcRCHJ8CfIJ1Yj57tiWdlb0DWXjV3wdyzHfaPnKRjP3dFANcO?=
 =?us-ascii?Q?yA2W9idUoWzoWYENOMZaTPb0pjf9zF+fBvT46C8rfd07Lfqv7c5scZVXSRem?=
 =?us-ascii?Q?3rg+TGImqc04gbtlm4e9OL75gkdlfqdSUxsZxH1d+59xzpjsxBV4UmNwwDZT?=
 =?us-ascii?Q?d+l8HmEb3zjj6ij9E3eaLrHPigBIjzpTk9iy2bJjbG7tXKstx9IGeLs1Sc/n?=
 =?us-ascii?Q?YOrAohb41WzcyrgZdjFEGodMsCKLth5tY2W32M5qNRZRH7PeXKtx4FdBDI1D?=
 =?us-ascii?Q?o2c6QHHUxBxrpToLZgUjeA8RZ1p1lvtjhfpIhO9qtqvLPn4/YoYuQZB7mME7?=
 =?us-ascii?Q?dkkzxMKyOa3+FJsWybbfk4ZRpl1drXczK6Db6eS2JTmfZJe+nM40GGhy01bf?=
 =?us-ascii?Q?ZOcvcfUJBmhy9L/1zi7Vt4l7i+/MFFpKNrmpJ3rMRPjxVWP3j2S/+K3KK53S?=
 =?us-ascii?Q?LJD15v/0iXXKVm1VAM7k5LIFJu1jL6ii943Ncmn8/ntIGBIdK2vbul9aayjg?=
 =?us-ascii?Q?ykRmX33JqA2Kpn9HOAvRneCVJUIoXXlbkPxs6N6H9utbZNOYfjL6orcQGDFM?=
 =?us-ascii?Q?y1UqMfo0d6U+p2Ukc4VTrbTtEeM3aIQz/+pd7HQ5akpKfRXcWvT14Co7bdpE?=
 =?us-ascii?Q?1D9D/KpNPhohSoyELlmTgcnPJUh5GeeoErmJl2ZPRpxP1cg1f6tCYartwk72?=
 =?us-ascii?Q?8V+QNL3Ju/Zb9GsXaUdCKIllgR60y1PhcES5lxx8KR/ij8QELtazxfXPw2a3?=
 =?us-ascii?Q?u3qm+r7iBx6ziAf+IV0C2cAb8luimAi84gE/WqirPCskdWjVX91xvMCtek+z?=
 =?us-ascii?Q?DXj5+1S2Ud1wYSYSDlksWjSLkbT3CbnUOYnrxMJL9bpk2a3s0BB7sC00hP0u?=
 =?us-ascii?Q?FG2Xc3d3Xu1zBJ0MIyCa8DIPdu3bWVaDRzVys5iPh2WL7qSMGNOsfPvuUVdV?=
 =?us-ascii?Q?LCprnRZy4iN8CsFpXdlYgMAeawER2Eni7CURezZ1dYU+tUI/ynITC5Eir3n/?=
 =?us-ascii?Q?UNF84za1Ke3nRyoHDtNuK1NZccRg32hNOxO+HYpRr4RsRmtnTwXOULfBsucP?=
 =?us-ascii?Q?ssA3QA2xKIr7prwkwLgV1Efzc6hZJR3BSsXo8JCWYdcIRU2nsa7fKtXywiSS?=
 =?us-ascii?Q?FIKXXh2BV87UyJkVcFRQMSNgz4uN5u/3t0Kf7YN/HEpJu+a+yavfMEb/P5j8?=
 =?us-ascii?Q?ySAQRfevV94=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(7416014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?nS0Hinvo9ZOfP8EBnkaVZlkif+D5iRODhZD84ORiaUmT2nkWBjGFOsTdHAwW?=
 =?us-ascii?Q?RwsJzuS7t06b3mrNTyueICkYDroLW9nnEr77hpXOOG3Urj81wtVl7ausZ1sQ?=
 =?us-ascii?Q?qHgFhcfsJp2AHjo1enyFz3Qx+LIXyheU0DD/zFUSj7mXUCib5jReTHD1EGUT?=
 =?us-ascii?Q?hgw625diSOfEB6NSYp9AGaR4eTkH9Gx7viXTBNXbhF8C+uDnqv33CJ1HvYhS?=
 =?us-ascii?Q?uuSp4L4LsrT/2r8ZtKU5HnSoJuMMid89+TAQK1SDZTo8EBf8dMkyQy2siZyr?=
 =?us-ascii?Q?rl3dyZ0Co15h9ZLUDHQScgmFJnVWDWLxsXEJqZX6Yyvm0IfCJ+NKK3UZXD6i?=
 =?us-ascii?Q?wxdFNSTIscKVLtyKzsTdgvyTa8+Rt3yA5F9zIXDu1PZsKfJTII8cF4dMnf27?=
 =?us-ascii?Q?CCPR1N8PURo2nUc993Jc28bJFusP/UBK6KcDUnieHgxxQ8nXOyXzCehVYOoS?=
 =?us-ascii?Q?HHgKRgM9T8uThbbmhDJGrqBMaCDTYQ/bxvtVDOlhjY71f5hO4F8SsHXnq+1x?=
 =?us-ascii?Q?555yTuvpGSGrHAhZKQt0io06bafJU7bcLXp2ddR3y7fP7YQiBFZ5UxPG0F7z?=
 =?us-ascii?Q?vle2dARsUY8l+s/D/N683MJba2lavOb/zG5+PfmTR4MV58ryr4zab6RglXOt?=
 =?us-ascii?Q?Z3hsWTowPAAnrf0qdrPC9LBhQksZAFeLrLectVV0sDPLvfCAswlb+cS/pZla?=
 =?us-ascii?Q?s0SoBGAr5tFNwdFOfMbwDHoH/BFsmDdWY5ydR11SWxEt3QcV8moHdAZA0Azb?=
 =?us-ascii?Q?K3audoUq8qCOuaXpy78xtj97sjM/9l/LZmSGL6XlApzYZ4g9crzufpjPLzo7?=
 =?us-ascii?Q?TwtXVWgeYOQkOWjsDR+V3a4uRXuTqWkQOlqOMr7SZ22Mwvn5rqAHwFmlYtGT?=
 =?us-ascii?Q?3CLs5rjCXVPhkfuoy8ZIpMkShgGezA7qxmPDSKVFliM9k5p81TKTxOkvESCN?=
 =?us-ascii?Q?jKrAIr2VeHbIAbHTN0Qmcov2Iv8qDRDmboccw0mPlTrGYpS5vMiKR8oKuz3r?=
 =?us-ascii?Q?TxOMdcmjz98RKVKdeZ6/A+s/m5GOBjtbPfwUHAlKmWALed0qbkOSRS9HpUhk?=
 =?us-ascii?Q?bTGcMB041gO5xJNDywchgOEYeV2ACN+OfZLHqWCtDqT3T+GcYBUyIk1oQ51l?=
 =?us-ascii?Q?KwwL8PsFGG8gzMbXdscqPFwhmgY0ZOqGTxmmu0+n5HrV8/HRMKGGIKNqx5NL?=
 =?us-ascii?Q?mDF/UoXANAvEAo1LIWtI4fpHjTYEkPVfN1vhFx8N9bFASS5q/4XWwuw+UndS?=
 =?us-ascii?Q?GK8Efc2uqABfiQj5fdSB68ppaTBxcHuxRxHJyHmZhiXEfkZEUeUaar47rQg6?=
 =?us-ascii?Q?w2rGwAFnOxnoQVuhZK1d64M4VgbK6l/IXDBU28iKs2UdOA3Qf5kMOkJ+v/EN?=
 =?us-ascii?Q?r72NCAnraDRk2JUF3h+ZGzmmjdPTkj/GTE3kXKsE9rgQyPDb4yplI3QNSJvl?=
 =?us-ascii?Q?mctXF9Pcc3z9jrxQTIzqeMGFLZVlS9WeVscXzDCMFVNgRvG9Uy2ONiRIpkXq?=
 =?us-ascii?Q?Nx2FhFcX4t4xpeTNzfGqvSfpl7q+x8a0L1ffyJkS+dDFAcrNtdssik2XiljE?=
 =?us-ascii?Q?oWUkqMxbmi0dr/34m+RpbYmg6CTNdJo1+tM81KKUzEYM6U0yBlr34+UmRmjr?=
 =?us-ascii?Q?RA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	WIppBLJFYwmPdQN8G7xyEl1vXLVbEyzHMvdOMu+akyX8F0KvlpBaEy0g2sQ5hNap02TWyrxvfFm6A+s/tV9Id+qNZNvZvGJYxw2U7wAjVPSzmuMKqQRUUgYo8C8teJ9w7gN8I6QBdSoeQhXgwKYkAVXcx9gnSnyfRUDHqch2tkwI17+QIFpB45a9kM2wSUSamZ+fA2y+ryV8j6NKKvHRKucxfb1zEHaGqC7dlaIk0kYiuIsd/2RN4zhMC2q5NJ66iUi/F4ftaLCpQtoqHQK9Zv7ngU8MTQEIaslAK7Ni6mt0OGd9IeF4NSkl40bsultkhwWknDrdse6CwkFGUYsdnPOyAb8B5Vmw1RKcPt5QWIRtuCjeKg6CF475rZcXwyQs1fs/jzwT075lyxFGS2ZcYpvmvluEv5rH1f2oS/ZFqrzuVaXs5aOmidbX7c5+qXrJMYDvksIsrmHQfJiEhpxRb7joWqoWs5V+Ld4qF7LoC7no0CX6kQhwY1TPC4OKzJaufwcA+7/4TDAtbdZFGxexQISZ4ZpCAw4vxb2SEbbGETblGUiJgzSmx2MCtdihbnUtjkA9VtlryBRw6o21J1aVyk75AIHNZrPr9kejOMAieCE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ace0d8e5-35cc-41fd-314d-08dddec58d13
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Aug 2025 02:10:21.4375
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9O8sQpq8ysQ5ScQvJn6m4POkjQnHZ5MMrui3Rycpk1BF+cLuIPRNeTXUzWAMsHg5/b8i8FVh5gg4QKZn34Bh2e22+ZNHkKR6raIlkQ4lPUU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6322
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1099,Hydra:6.1.9,FMLib:17.12.80.40
 definitions=2025-08-19_01,2025-08-14_01,2025-03-28_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 bulkscore=0 mlxlogscore=891 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2507300000
 definitions=main-2508190019
X-Proofpoint-GUID: ks_kBOvwKJ86WrMOQImPSzTG3-DzmiLJ
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUwODE5MDAxOCBTYWx0ZWRfX3mFdSeFEWOv1
 oJ1xRPr9XoxypGEl0rRwuCzxpoZthezIoR64JZeME2UekELrszASNNE04elIFLSPl5edfKb8gb6
 8v9cz898p7zZuQV9sourYeLIeln6Sf01vEhWt3FAqjr7H+8oAu0OZwQBFGtcAmzkOs2GK2UMAaJ
 g8ERONrFc4KXBjZBuLN5hy4jmf/f8Nj/B1pZkbsgP/MCXCR2PGbQhXe+xe9XvTl03ic2lvZU+IS
 FBBS/GvxwpIP72SO+2ZH36ojd9VqMUMq/EoOff9QzojALutFTbIhQO/JTrS+1fNvCMU3aFNlJ3C
 wV+FgyazNeXNJNZlmSRk9576HjvtbAgeY7CajYkQ1Ht0pclaq82OcZS9vJAaUhc/Fji/u9IwQRR
 90tqrPUhwqf+lCTRzJbj5Xs4bFquCS9/nzXH5zozIiLjpItRX74QGRZf7CO78xBMIcr2F8J2
X-Proofpoint-ORIG-GUID: ks_kBOvwKJ86WrMOQImPSzTG3-DzmiLJ
X-Authority-Analysis: v=2.4 cv=HKzDFptv c=1 sm=1 tr=0 ts=68a3dd12 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=wKuvFiaSGQ0qltdbU6+NXLB8nM8=:19
 a=Ol13hO9ccFRV9qXi2t6ftBPywas=:19 a=xqWC_Br6kY4A:10 a=2OwXVqhp2XgA:10
 a=GoEa3M9JfhUA:10 a=CEIZDvEd9kZ5D99qYfAA:9


Niklas,

> Some recent patches broke expander support for the pm80xx driver.

Applied to 6.18/scsi-staging, thanks!

-- 
Martin K. Petersen
