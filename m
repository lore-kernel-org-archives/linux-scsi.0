Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB1B429993E
	for <linux-scsi@vger.kernel.org>; Thu, 13 Nov 2025 01:59:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762999156; cv=fail; b=iLDNMbJ34qL2hgqNS0UtDXX72xYed6pwP4A6fWoTdMS9PODiyo6YWHnYbVJpFR/Pq4EpMHFC1j0D3RWo+juCmI1CToDpjyWA/K2uBDz5GcKgDeOD4Dd9wt1Si4z1tupyTJAMmpu8RQWTmqUX0sTi3ur5E2MUZFNmiFcvsgsUFxU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762999156; c=relaxed/simple;
	bh=tkGM/CBYubmwK/iW21jT1C6GEbj2xJ8SEMgELv+sE1g=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=Q3/UObV7ooj5xgEYmzPiO5Nf9raJ/IDaMpxkZB/uWxY1lfMNekcFJNJ/atE8BSgxFB5Xedw7JswEQ6UNoQ4bqU8iCQXW/lAEVB4FEuiwKIlYLvIADCCl5CUUAkDUguAvin6aP2SZuUF8GmpkGwzeEl/WkbahejgvbpsyWeJ/di4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FqYPtIPK; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PYgwxXH0; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FqYPtIPK";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PYgwxXH0"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD1glGA004661;
	Thu, 13 Nov 2025 01:59:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=mbTB+onLlc3NCJUAs3
	knVizj52fNBnchnhITBoo7Jks=; b=FqYPtIPKuWOSvYT5oGAW13IuB3o8HMsZyW
	51db5Ai+O2AyVrnJgB8HZiOslOmnf94sr7Yid+Kdxj2mq8zD+Wl/I4sM1HKDfMvx
	T0LtT8L+ElAb0s0zo4Qk/octXVBhNoQ0I4ryi6zGa5U7MqTTXtkvMk/xTnplxjOG
	OCrzTJBSbUezZXvnsV7iSO7asqGS8CEEpmoSM69TpDyxO72v6FCkyl247G1Ok2gh
	SgfR4mugq9qo89iZvkXjxuMJQjp3wi6TEFCWLS83kzJIo5rkzGCV6J7A2HhTbnQK
	DAWqJrXKfpzaseosexrszXfve7xYVvb3uPHpA0nnto55AJ56aK2w==
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4acxwq0t65-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 01:59:05 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5AD0hnDG029188;
	Thu, 13 Nov 2025 01:59:03 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011002.outbound.protection.outlook.com [40.107.208.2])
	by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4a9vafhucq-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 13 Nov 2025 01:59:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=S5dqQKqfPvwzhDUNi2D78uBz5Q9FSYKsiD64A327XQNroQFzxSt6agUM79p1TKgTdYau/Xz1G7J8BCmcZ3MX5y/ayP5aMR8bXLOZM9GRS6D766rGyAreGaTT0o+6onhtX76evNmmNsDRVji6iBydOsZbPeYPewHaHrEacLTrQOrRH548EiusfIf+VTx7q1p8cKa/SqBe4WIUs2w0N6Vq4qGdV0FUbojE1QRjqJO1vuHAJpsxtRLuxgvDUX1dzauuLynAWvNzw6/3qZh6X8hk0XeIpnFRxy4TMz/bG1o2MBZ/FljTRU7W3sHA6+lSr9UhnxmNRg1GGnzHjAksCOhHEQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mbTB+onLlc3NCJUAs3knVizj52fNBnchnhITBoo7Jks=;
 b=U0uHmRdZi2dIOo9uH5mB9QzhqAMiLBJRzDmvqDC4fJmZLvp9vOE5UklE8tSSrGAKx0ZyTcS1a9vhbcog68EUUG/7ULsgXs9sQ8XsGfVcNbq9E+7MyZ2ChqjmbSOYVicGYPABzYNiyt7y4PrYlJZE60w8Bs7dZerZGT19m3Kgt4udfmrA9jLC4cVjNbtwNJoK/GkMlpaTbIi5ZBL0MnBQR50ftUxYpgANUtI8czkrnh5d5I5TNeHgx1cfXmkS9o8vhYHkjRHM00yB4ooplVdkZzi6apPAmFnTtDrccZwGb2vSWcRST3nx3GrqvyMwgSeU3QlT8zurgFbs9WvWXcmoHQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mbTB+onLlc3NCJUAs3knVizj52fNBnchnhITBoo7Jks=;
 b=PYgwxXH0hRXe1oQbLsNj+zu+f/u36EaLFPBQBK+o70466AI5txwXrZNVbtl9XNyKjM6bhVFQzu8dc8DKdI7RvwRlalYhbwMpA1rRJvejBJNCO4ygqSoOMLNTXAFc2dC2+NNThvbUr0eN7GaCkNJIFyG9tikf85qAUlrtUGCZVa4=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by DS0PR10MB8055.namprd10.prod.outlook.com (2603:10b6:8:1fc::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9320.15; Thu, 13 Nov
 2025 01:59:00 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9320.013; Thu, 13 Nov 2025
 01:59:00 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley"
 <James.Bottomley@HansenPartnership.com>,
        Avri Altman
 <avri.altman@wdc.com>, Bean Huo <beanhuo@micron.com>,
        Guixin Liu
 <kanie@linux.alibaba.com>,
        Ziqi Chen <quic_ziqichen@quicinc.com>,
        Arthur
 Simchaev <arthur.simchaev@sandisk.com>
Subject: Re: [PATCH] ufs: core: Remove an unnecessary NULL pointer check
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251111184802.125111-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Tue, 11 Nov 2025 10:47:59 -0800")
Organization: Oracle Corporation
Message-ID: <yq1cy5melro.fsf@ca-mkp.ca.oracle.com>
References: <20251111184802.125111-1-bvanassche@acm.org>
Date: Wed, 12 Nov 2025 20:58:58 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQ1P288CA0009.CANP288.PROD.OUTLOOK.COM
 (2603:10b6:c01:9e::17) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|DS0PR10MB8055:EE_
X-MS-Office365-Filtering-Correlation-Id: cb85626e-996c-4ecf-86ae-08de225836c5
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?duFzJdCRxz5lck1liHO7/Afoqu3zJuB2asBYQdbiV4+rsua6pzh/Cc6JcGg+?=
 =?us-ascii?Q?MOCkmJV+UwFptwM1Mlpv3DExJ8MAd9PDyuVVEqU3ZLFHGf1JiUopNE3tz0dh?=
 =?us-ascii?Q?j20t50MWsXEwxZfyhFzM0Pngkzet/oz6MNEL9mqiYS8XlVpZkkxCi9PMYoIW?=
 =?us-ascii?Q?XsymGZOZtHE0S/mCZhTEBmJulkjIgBRYY/RTdkyE9Rk88y40EVUiLvzl9mU2?=
 =?us-ascii?Q?OrTjk9x2P7JYzbGAEE/Hy2UJXAL5SqrGS3yq8muyenDv6GPT0lyWR5MO78/c?=
 =?us-ascii?Q?6K9qXby/UmFuK0CSVs+Ji0RqA0GXu9rGXR1CULEGsLg+cxBGrtcJe+D55cZi?=
 =?us-ascii?Q?7Uf2WstB8y5Qfc6XaV+vN8zYtEI3/tRwZJnLKiQnbbkaU28ktBfKl6s4Pcuu?=
 =?us-ascii?Q?F9IiaEXl7neUf5K8HUJaM+s3I0yC7IrfTREPVIbjiXCycRCkjiU8PPbvD9H4?=
 =?us-ascii?Q?WC/VRMhVgYh4k5DF7ojU2rwuZhuZsXgBuCMu+52O6BRDQJzbhridHH+E3uLp?=
 =?us-ascii?Q?zDQdPhEGyKn0dwihIV/L3PWeG1Ev84VAJW+GVMv5f2oMrcJoc1IVMp5F9vMp?=
 =?us-ascii?Q?vApiArLJ9N1Hpk2rJOxE3Rz3vomUdtSfaboB6BYmAGF9vNt4NPjkFRDVvSFk?=
 =?us-ascii?Q?nS8ssGGT27HNJUfbr579M+2KAZ1tGNLZVp8OiWZrRRNFggI+XccWSbWySIQc?=
 =?us-ascii?Q?ULYQQjT7nS3StGNkFqXPS5CjY0wC1lzJNJHBlK1LRBHY+SEUFmCemHFLIpvx?=
 =?us-ascii?Q?rA+9LjEJsZ8VV23BJJ4ez0GEP53PYq1o2/hgpa8ychoDcMA0xwh8m4uxVqTy?=
 =?us-ascii?Q?jcPIulKlpvzRCXnOelG6tPPkp5zKzOjqTIwTuzFuiy1eljbmi4SgcVvjIUYZ?=
 =?us-ascii?Q?O+XQIRPIm4agQq8J0INr6v6uGx2G0qSu3vywyIrlN6oREhVa4AnvRnlduE52?=
 =?us-ascii?Q?TqjvlkGJVYMEWVh4cqG1Kzi9Y4SItNsjow8Fw3PBmYooWq+YY/8cWAfg8vYP?=
 =?us-ascii?Q?2TB9UtK+cMk8K9mkPllwA+eFheZhz9pizurJh3VWQcViu1C7PRM5QrB/vtFr?=
 =?us-ascii?Q?zwlh9SJ7u3Lg1/jxYpapQ0kuHYFe7PbWCQ4veHFee55HkAxRNarI2uQ7WnnP?=
 =?us-ascii?Q?J9WF9oOA8HC1wsUaMJHDkJWsgg4MR3+5R8jVxs17SkEVOnhhqJzlqbu7DIr6?=
 =?us-ascii?Q?51/ibek+LUUGTvqaKOD//O7vhBvrXKJYE8mLNUZOIO1BZyYtn243eppd11jn?=
 =?us-ascii?Q?8Z9JlT+2i65KMwVP/oAdpeXxnVmWCzsDxgHQZk9ytQ/m81D4depOJk2Zx6B2?=
 =?us-ascii?Q?Pe9P+WbQGgMQ/pFUjYpR61jovkLIWQ+39MPnssCnDAsT59q723S4i5qQAEDo?=
 =?us-ascii?Q?b8MauOYaJi+7uiJDCoi6h6J21DDQHuMFWq0ovYzySR+lhix43AlCsEXdcNvq?=
 =?us-ascii?Q?OLbBYFaTkay16pWnG0qs4+a9KIxcHta0?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?DhxZQm02uA4AyWh4luDcblnLlAyb3Qr5Ik8lr8HsnEa8UECPEmSkC3jcJzu2?=
 =?us-ascii?Q?BslBQJN8MRxZgSzgXPPfY847afKCx2BgQN0i1aMHO0phRroH9hldZLHnJO0O?=
 =?us-ascii?Q?lXjDw0Xr06brNr/R943NYLqqj0AkQYU+Rt8tCup4SxK36fGG4fr1NGXIeahd?=
 =?us-ascii?Q?DODHE4T9mB5n+TXx/NN1qKw6nasEU8zbPbG7D9gjR0OmtmoxqpSNLSm++lGg?=
 =?us-ascii?Q?zzZViKvIOeoE9UuPtFdoTTEvRpzrvIy78L0LBxvTD4sQGMkkEjhOBLOqkDBj?=
 =?us-ascii?Q?Hvg8i9a+YgwvPP3VZ79nAmnlMKvntmcG2HPpI6iRItlnHg8wdEh7Pth5qLPc?=
 =?us-ascii?Q?Nk9sq68ZzhrOprAMT6YXUEMABrlw2b3KnAE5+m/ui1y8X1HttspOyQO7t+VX?=
 =?us-ascii?Q?cvYgpo2VWtji/a3sKgAkvglFwwMeZEtgNAwUtG0QKXeKdeIx8Jd8AAtg4XOT?=
 =?us-ascii?Q?ZrfIZS2nIwzZcL7fxMxfcd/M7yG+Xd3VLXMTHi4yydW/wKUZs/P7h6BGmn0Q?=
 =?us-ascii?Q?/unvs4ViELLKFenqyXUVZE1Dt7Y6ItJd1Oa0NUtqTJMCigzWZyRoAxbeZCEG?=
 =?us-ascii?Q?lEwsJ9V8MjeLGk1NbEdicKHJKdKnsHMP0B0c29EZEhThSlRc3uAGSmPtg5xL?=
 =?us-ascii?Q?yOazMQCX6H1OXnz5Uf00VMZ6LkxPPMAw08aTaga82G8ob6CwdZsgz1ljH0Cb?=
 =?us-ascii?Q?zfwOj9LYgSv1kEfXRbpodJ/tidx6YnWKTtbizIyx+ojq4bSfFjyl+0ZOzdDz?=
 =?us-ascii?Q?JbdipcjL+jUwDmodZhVfbot+4UFljLr+L2X+fJLeGmwDefOgnBwtLyPOCc+e?=
 =?us-ascii?Q?GTvE0C34ZMsN6OeH5raShPSP5DHqVEuVItvYdCGPJ2mdSDn+Kph0E1PjICLn?=
 =?us-ascii?Q?oOa2pPhNpHL+YnwX6aMeAzSz48ThwuSozjM2GkINf2RkuWd2LDnffek4YUQ0?=
 =?us-ascii?Q?owwtlbg0TM87pHfThm3B/16UVDgw0ebDc2AYaxmIYvZAQGvHBe9qO5/Id6YK?=
 =?us-ascii?Q?129L2VNFXXk4QByPhGb8i3f+kyVFVNXM2ylnI2Rr/PkDrOlBssU/igxYm0F3?=
 =?us-ascii?Q?T//Qi1h+bp8hfiy1RsHinbO3aAklQ/IMTuPCUCqswaXSzdP1clY8nwRIS9pM?=
 =?us-ascii?Q?B2AC9IBaJ3Q5Rn5atzrjAsaX1l8vDiGuyCj4QiddHJ3+5lj5gbgiqZi9leBQ?=
 =?us-ascii?Q?/Du+8IqsnYyVT5q1Kjnwv0D8oyECIuzbegxuSedWlHr3urgFMzVUSCMdMyyo?=
 =?us-ascii?Q?QY+nIqex+7rCWCrl6PTB7NhP56sztLtXsZAkV6d9pncg/qALyTyZRBEQR2fz?=
 =?us-ascii?Q?o43zzBrz/YPCw4x1otI71NJ9dMC0IacIeS5ale4ksss29ctq3LzlBOdWsaty?=
 =?us-ascii?Q?9k7LSwxi0EFFSiqUNrgJU7PdRvAoiJ6JyYQPgAvBlnQcr0JipaQKGvXRHDfK?=
 =?us-ascii?Q?W1V6Owq7U6rDhbG43YTGezqvWrQ3OnoIG+m970yUgjvxiwnUW0gp/+zaFquM?=
 =?us-ascii?Q?T1jyAmt/z94WPHyYc3o8jQQh2vF7Yc45gHWujy9JczWQ8vq0yR/jikEM18Ez?=
 =?us-ascii?Q?kSP7u0jM4DRw1Lr7m+JlE1V9sBLqtSbs4gfUEavW4+4mNieHdDFThtsnI5no?=
 =?us-ascii?Q?4g=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	q1Kn3eUi/DvWxgQIaCsTTonbvwkUUMPcJ5QaO2FqySLOqbILytDdyLcIWj0BQTiSd34LQ7ly7PgY/3E23BqVs4AKqy4IYvK5be5SJBIbrXaOLo7dKTr6sbo6FsnD7d+qshUgSswh/74D8lC5i1FM1eH0FKVoRcH3NFWvmOOifWGV5uQNJNj2GwoqbpfTNlk9fZBC95lTm+LIFXdZGDMlumQCNYvSxejoxiHCBl2ekMhgmatZaBgkAaiDNwdzjvmoTVTJYsJoHlsDv3vZYfeoOjHCq1m2SHdcpi4+VvOCcEoHjYYNRdfmdmEAzjczt7wrfPzdkM21vZzpXRFmyK7c2UEk4pasSStsv+c2UFDb6BXFGEpZOrKWO3TcdANDxAo1Z1QcnpuK7CkqP2PvJC7VpWkAl084ccMNaMqSJ70ETWSH5bbAgQ30myme2EScWd9EkXZSMt33fJEam25o6LNxqfTLhu961Fu26JrwDaYVTk29lwIQ7F0oyLhdGgGDRM4ak0ScpGUevyOjBumAZ+pcEKrShFo3JRAjf0O5ytWL/19LuNGAu09OBUw53E9DK5klA8xWKSHTaP5YtJHP3oJnrmA7MkQhja8ubi1W+15Tx8g=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cb85626e-996c-4ecf-86ae-08de225836c5
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Nov 2025 01:59:00.6261
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Xzk6svVmLoMIRnlSVEU82XvP/O/+u/jJ68CfxgiNJ69f3HtZP2mwEUw6vIoRoG7z9fYk1eBxED9poq5LzbleU+tvLbofjOTLzJncWrJ2ht4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8055
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-12_06,2025-11-12_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 adultscore=0
 malwarescore=0 spamscore=0 suspectscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=988 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2510240000 definitions=main-2511130011
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTEyMDE0MSBTYWx0ZWRfX0PxlzpMoSEzn
 kKKrvKsmA4591lRtux4zH73cR9enEU3GzWtqNmRx9yNKUJ1QR00bTkWWW7+ssAfAlLZ0W8A4h+o
 8DzpLMuVPXmRu+4V1LJ/961PuOVthCcvqNvn8o6dmDW0uJpXBvLjCQTcfM5DDLsuBmiVYstwy9v
 M+Tln2VZecy3wqBoH/89P91sWYag7lPNltvjJqbw0w2HIza69Vtpmz2tM967Oy6uFNkIGjzMBi2
 7otq7D1KGLatrBjSZLs1H20+yP4KslEa4d5e3UdzSF3S4w9Ug9jveD4ByCR2ca11vvLxG9NJ9bH
 bxE0F2qgQ1Kg9/rn/S5gI06Q9+sihlE4PBke8mIM/l8uapquT2f0PRiFgOpcTY839BjiSpQpRh9
 GGSsw8ARwomGV1Ki2jizUVh90f1hQpVbzMjZeykCMPEDf8G+R4E=
X-Proofpoint-ORIG-GUID: VPe5pxlaM0UNHdATrvzXOnV6w2BqyxCv
X-Authority-Analysis: v=2.4 cv=RrjI7SmK c=1 sm=1 tr=0 ts=69153b69 b=1 cx=c_pps
 a=e1sVV491RgrpLwSTMOnk8w==:117 a=e1sVV491RgrpLwSTMOnk8w==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9 cc=ntf
 awl=host:13634
X-Proofpoint-GUID: VPe5pxlaM0UNHdATrvzXOnV6w2BqyxCv


Bart,

> The !payload check tests the address of a member of a data structure.
> We know that the start address of this data structure (job) is not
> NULL since the 'job' pointer has already been dereferenced. Hence, the
> !payload check is superfluous. Remove this test. This was reported by
> the CodeSonar static analyzer.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
