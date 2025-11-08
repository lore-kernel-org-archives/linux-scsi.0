Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C39B624337B
	for <linux-scsi@vger.kernel.org>; Sat,  8 Nov 2025 18:09:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762625393; cv=fail; b=E9XXAHw6hPaLzi2v7gvqzPnfz41gz47EvAWevw8xFN+8sUsEsCvqQae08p1dFOcymjlG0mS6/vyHU4sICXoaaNYwNbY5oNr1BDANVaAcr9ttsy+OTQEIbSJTxsI1nquZ5vhvLnsGozXax88oIKVi0B5xtRBN0TM1y7Ixkqt5lrw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762625393; c=relaxed/simple;
	bh=JmK8IBYTpBHmT+c3al3CNsrvtt2jMoXZofpjx8guaII=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=cOuzQiHTOAj1g2PlIO6vMJcrCzZp3IZ3wxTP2F/7udtS95aCDgnk7xGg1NLHGEnXhVXqySk7Ujz6B4AcdPBpQJQQIkC6MPrEa+8ikso/Hcu+8btoFIZCKqNMKJUB36SRwd+bqyyxIIHKqAvZ/FotZgtIIiFCjg5UfEmzKQ7vsO8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=jUHck8ca; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=dB121dJ2; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="jUHck8ca";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="dB121dJ2"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HaDGc025467;
	Sat, 8 Nov 2025 18:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=AbG4Y/h9Bkcu3qSDIr
	FuYJ5BPdlP5XzjNeFvWrWf+A4=; b=jUHck8camwVxZfiT3kc5HRsCkxA7Pf6lqv
	/mCFRSrKfGY2X/B3g7ZtGKwIS6td2He0EfPBAi0DZ8CmxHK+GK4vnvLl4I02yhql
	LhfvGrc9grPt8eD+CoqzhMWTcmHToRadW4hNQ54JPmLyK3fw0k3llrTZ1VvZYqF2
	uib2BMX3C6d0X/4DKSfGRrAzwaGfWKmKqraayDVa+eyIMt8OaT4pU9uT7L+Bq7Wd
	Em6oR5WQGu3z8znCgn9paNR0ht8v0Qmw3DxeM7DM0doUgBmFNX8fpxGo2UvR50im
	TfEns+kCr2ISylvTWYk4yuRgq5Ucv7ykp4s0ghBmSYjN/q/uEDcQ==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aa8se038h-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:09:36 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5A8HQjtd007458;
	Sat, 8 Nov 2025 18:09:35 GMT
Received: from ch1pr05cu001.outbound.protection.outlook.com (mail-northcentralusazon11010023.outbound.protection.outlook.com [52.101.193.23])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4a9va77ggy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 08 Nov 2025 18:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=zU/tthZ2rSjJws/wcuO4rls4Xd0RGv6qPY98mKPlZIaxEUQwGiXbUJfTcEnXzAF+YzI+tj62iEbBRrdbpksV/6noWXFewZ4U/+X5+RUU7eJ/+FLx0Zj+t2B74dOxZvdd1KlhEIDnqhKS+ePMzFvpDXT4wZM4cJN24OzVpHjnijGlyclX3inXOI3qPVIvcnr1PcWJJrkG94np7AIvtHtW5F8tuF6Bvwc8PFbGjfiH1pN0Z5BZqaItvJEh1mxqeBjGZcqTb53Ych4WeOSzmA7slFAB4sDl11BOt58htnngcLDP+UInZ4968TpNm3QB1i8rO9OwYRsvYCeyFGdaNmpfQA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AbG4Y/h9Bkcu3qSDIrFuYJ5BPdlP5XzjNeFvWrWf+A4=;
 b=htQcmguNXWlqrXTMRrhGe+MmTv0EP2UvfHStFavhk0SD2nqlKnU1C2jNPy1N42JA4PRvp7HI2FkxVv/T8yn2K/dcPOEpXifLvgrhrl7S7hIt8axwvwCMtRqFLVCSNaGuhyxlYA4VHCFPLU7Vf3HtrkO9O3pAegZyhhwxZNQT6UlzbYcWghNd+MfTa/VYJhDg4ycSFJS+YzF9gC2OjHRVWvEB2U/Mo+whnA4qxgH2zEDkzGtY7ZSvZo8/tekSk7zlaWm5wV5q+hJ7k2x9vQJWw+E/YnWUMMLv9lVc7EXfiQ3dS/pgGKhn5uINlUqUF+TA1MHubMtmXydP0HtuvBuybw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AbG4Y/h9Bkcu3qSDIrFuYJ5BPdlP5XzjNeFvWrWf+A4=;
 b=dB121dJ23jh0gIO9TYrgRXxLFypV4Ci4fzAKUL4FKMQfG/xB2XBqQ8SAaVOzIMoxwePmfDzGCqQUELTF40L0Cfc+nx1O3++2ndKd8o+PhuXhsSd9/9uCZclCB/PiMMXPk87tW6d31fE4+5KYJYh9nvLDx5eqD3sGjbH4q41VT6w=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SA1PR10MB6639.namprd10.prod.outlook.com (2603:10b6:806:2b8::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9298.13; Sat, 8 Nov
 2025 18:09:31 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9298.012; Sat, 8 Nov 2025
 18:09:31 +0000
To: Don Brace <don.brace@microchip.com>
Cc: <scott.teel@microchip.com>, <scott.benesh@microchip.com>,
        <gerry.morong@microchip.com>, <mahesh.rajashekhara@microchip.com>,
        <mike.mcgowen@microchip.com>, <murthy.bhat@microchip.com>,
        <kumar.meiyappan@microchip.com>, <jeremy.reeves@microchip.com>,
        <david.strahan@microchip.com>, <hch@infradead.org>,
        <James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
        <joseph.szczypek@hpe.com>, <POSWALD@suse.com>,
        <cameron.cumberland@suse.com>, Yi Zhang <yi.zhang@redhat.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 0/4] smartpqi updates
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251106163823.786828-1-don.brace@microchip.com> (Don Brace's
	message of "Thu, 6 Nov 2025 10:38:18 -0600")
Organization: Oracle Corporation
Message-ID: <yq1wm40gzwp.fsf@ca-mkp.ca.oracle.com>
References: <20251106163823.786828-1-don.brace@microchip.com>
Date: Sat, 08 Nov 2025 13:09:29 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0166.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:7e::28) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SA1PR10MB6639:EE_
X-MS-Office365-Filtering-Correlation-Id: 9ea2724e-74ac-4ecd-bec0-08de1ef1f721
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|7416014|376014|1800799024;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?GSC56v68RD94g+Sy8FRgD9KTUZlbn5Dq8ye1muAO5Rb+0b+X/GaiOSV862Rr?=
 =?us-ascii?Q?sfVuK4fNL5Wutb5k0l4ZQBNg5JV5D2E7lOuUQDu99T5QuU5mkyw75RJnRkyB?=
 =?us-ascii?Q?Dhm48x3Da87cHAEaYDVSzSGHIMn4nagYqPIvNpkEfeOiczog/6SnSIE9j1Db?=
 =?us-ascii?Q?hCC+DpCVRIY+F1h3m+vviq6ln478Qs4DW28PhiRR8eH9gsbeQmG+21LL8BIK?=
 =?us-ascii?Q?RGyH/20LqGm/xwrPooQQt3C/E8LmcocPcHBTeni4QF4CV+BhMBFSK7uWoE74?=
 =?us-ascii?Q?RQ9mzsgByRnCbPvZdA9iCq7A1GJd0Rc/ane/J100Egwwq2zVFZ4qA1VQ98yo?=
 =?us-ascii?Q?uvXfHzRJV9XEK82PEmq1oXTvPeOLQDyzZTK7w7WYK4lP9YrCXCaE96WsvkbK?=
 =?us-ascii?Q?BgFNecOc/llNswqoxqwXfSRiWWQZsUBdbqGNhQ9ixd49ntkl9w0EO0s//Keq?=
 =?us-ascii?Q?mfejux+U/wuBKbwqbSKvZa+/0S4u6vBIeIZzCjInQplsVtGGF/37NMih8rtg?=
 =?us-ascii?Q?2ngltXxA7pTgUNXa1nufz4JLxK5BUBkrFKHEPUTJ7qqVL97cgz85E7iUO9xp?=
 =?us-ascii?Q?SGcL0g9J/65u12i+TyOXrcnm2N0n7KDyFoiz2+aGvsntainrqIjtgC0EIsbj?=
 =?us-ascii?Q?lQ5KIEOhnbwwJd4PgbONpp7w0Df86QkXLnwLurYJ13814KTUMGYvPcDNCt95?=
 =?us-ascii?Q?TekN9iyHasPxyekjX+4mTslV9DqpqWHrtT4NW6BjVOGOt8iQAnwU1JZ/tQ/0?=
 =?us-ascii?Q?7X7tL/wUskPw2Ihp0oMT9fh24uuBfsStZtlDy1t7gMiFuyJeHzYjSF/1l7kk?=
 =?us-ascii?Q?dYQ+hVVVt2PbH+6/t03W+2x+S99mlmB6yCrXxV1IS4QjkqcUgq4KHYWeiV9j?=
 =?us-ascii?Q?0hFq7vMAk2ZS/VyxIpUmyyeyyLzQwno1QSnwYZMBI1v9FauRu3fJ4M0JLQqj?=
 =?us-ascii?Q?VVZCapJRtO8wTMZAi+GwvgcWexAbyUiLc0odpxZW3tXjkeyC92ZagE9WehS5?=
 =?us-ascii?Q?rghARO/BiF61wK1PZg8ueKJoMO9xWBwJK6IFON3sUmBQbqmZcJ7MGIxbgxvK?=
 =?us-ascii?Q?4XeeeIm3GG6VfC7Arr6RtLG382ka0yk3PimtYfJ5fLayo6ySG/NapdvtNilT?=
 =?us-ascii?Q?7rc8RhfSl57zfWPXOv8hoYdoOdIZYzKOdFlDWwTRvlCv7QaJVyZFFTXGdPNr?=
 =?us-ascii?Q?c/lqTyt2A6q31SfvU4iWLomwSxBmu702XgRBY/FFDCIu+9EbTgYh3nujRBT4?=
 =?us-ascii?Q?JKn0ZDaG48nAyQA0cit3xR4sbiLLqlLw+dmJJlfichlNPG8zM7YNBJVw6qkl?=
 =?us-ascii?Q?Zm5ldBx9qEv32QJpvjzw30QnaBwV/TDX/3uCN4k5ea7czzcuEuGV5oZAUpqy?=
 =?us-ascii?Q?JCPasNcCtHm4Yw2RgrZO72uU7GOOoIJhDvpvWA6eiuTMjHs6A6fbrLw4uWEw?=
 =?us-ascii?Q?Y23GxJ76visZyZGGN+6ZC+33jk/WsE5V?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(7416014)(376014)(1800799024);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?alUicaxyazWmo0Ao3EZKx/8oCO0QLIy1afncCn31GLnKdaq78OreIJJzMfe9?=
 =?us-ascii?Q?NlvLV1AjRzHoN6rBEWe/C+jTZQrlbPF3YjaVFblS1ELdQRgXFIlfxTR/dBF9?=
 =?us-ascii?Q?Y+j8m6Zn5AoWGJwrJeJjVyEz0y5yn3nn9V4yp5Z9Dr7Oa3ijT6Vuysv9Xqod?=
 =?us-ascii?Q?TUWX0haW3TmXghlqIY+n6EUieA7CrnIYneH0fukHijEyLkpfXKit2s7llHcW?=
 =?us-ascii?Q?4+ckVyYNSb8306N+7uKKBHkC6nJWpeOpUro64PZBAgkblvFGBazUw9NC90Wi?=
 =?us-ascii?Q?kMqcqeUcI/Rm2LzJiaAfQyDSBqpwa1Vg4zoTJxn8fsGPRZegayWiNth75kdF?=
 =?us-ascii?Q?+Aom5J88/xAEjAIRfbrekYMiNuLwpaIB99+71+wTDo7dyBcjaN4YUsppdCeB?=
 =?us-ascii?Q?Gnc2eoqLdce/zVJW+NhMA1e/TnSoJzfLWHcYsK3aVJozKVi72UsHcD26NXHk?=
 =?us-ascii?Q?j54DXD+7nSXMHMZbmmVNL9dkymOv8IAFkg2C3zFTmYsFAsloxg6XbFj5/VyC?=
 =?us-ascii?Q?HdR83vX8wDqQXF6zb1kquwxg4UK4+vSJBWBwiOv2u2dpEuYYTfHrWX6Z4yFe?=
 =?us-ascii?Q?fxuAFMNnS2CAQuKArBTFXNDNeLWN45Nx5auCaLWtKEPq/c5ParXOuetOROKR?=
 =?us-ascii?Q?Nduy3FYObc2AM7nWkJLqiYycFtRwZWJMmDf9XaIYBDZbuAa1OiPfj99RfYud?=
 =?us-ascii?Q?Sgc7g8fVO3HLAPIf+FJVA8EH7lv7o8pQ82HIWs6QI/x/UgKpSwaACLKPU+KB?=
 =?us-ascii?Q?WBBpbPnL2atmzxWuFAuOzFMPZG0gcDKDB4FFaYU1jjeZ93fUkMH5u1JVL7cR?=
 =?us-ascii?Q?t6Sw6+gER4jvXDk3+zzsdOyfWupBRwxDzLva705xyr8+kB8mKOLzFjlelb3E?=
 =?us-ascii?Q?cXZg/ZnWsRWVe4e6ys59KR8ecul9aLjyuGtHNbD3oWS6hhCp5RAAPw6kQjpR?=
 =?us-ascii?Q?hX5Y5Z0FUi/BOxtzej+KnKvvusTkl6Jwk2O98Z9uSFGb/PzSq80FuFmk5U73?=
 =?us-ascii?Q?6cm5s1Bz61UhCuqYSeDgLHep3SMphN/lvX3Z2X//CA6JP5LGW8z+ef3mTKzD?=
 =?us-ascii?Q?gBPju6b0dV3CYxjYtgO89F9fGBhSxbH5pigYX7yLKYV0TViLuPKMeXrSuaXr?=
 =?us-ascii?Q?k18yFcsFPYDGd8z/Lt5x6QqLXfsI0Zh1sp2kay9qM/HTuII0vvreZ7i7jexg?=
 =?us-ascii?Q?xrV2dGHoMN23V6aJJS+281Fb1Tyn1Lk/819W2Bz4C74Txa6aBChKMvZVFrI4?=
 =?us-ascii?Q?rQ7+SCbY3OxHru1QNfJoIwlp0kbctx8AJe8tlixeJxfb/XpR20Doz9WLg9Zb?=
 =?us-ascii?Q?DNCnOBf+YqCOc8NYOsTt+c56iRgUJ/xO8AzG85KgvUqVSgNQBvq/F2IWtwNP?=
 =?us-ascii?Q?kBBSEw+FZMDvksiMR6ARtVkkXZypp1OJUreFHCgszW0dG2T4Gn6m5kkDfsQa?=
 =?us-ascii?Q?jAsThdwBghTFNp5YnG08NTaEvbIDcyPQ68+1AFq0EhUNVYmEpK1UymseRwpF?=
 =?us-ascii?Q?oyGVTuRZsDQQtXyhW5BAm706zNlLRUN6fZDvd4whaPsVOfh5FRDYtUNSq9zv?=
 =?us-ascii?Q?FHZDskqwdV7nbRZdVj//6xx422QA0rRuq3QlzWrfU1HnZWvcvdkwb+GeXhAF?=
 =?us-ascii?Q?Mw=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	fj9R93YF65hU6TzgUPiFP5LZ6tqEpXCB5wmhii53USJLkUh9EC4HxrIWMW/MbTQ5f8NyBjh+jCt5yGHFCw0J41Y+R4xrp2G3aIYBW1Q2tFXLMMEl49wzRnK+7FnF1v4KHlMoXJGjwsp2Rk3FtuVnrkM9ZX08BEiXfZhQ1ix6CXCnOOVJgmPaUX3xUg4SPdLEsJThPPBG9/YKy3tRcXEnRpR+xSGI/qKMJcUxr2Q5dYIc7dquPlhhuyn3YTZZNHFMq217yfOg+ixpBz2oqXGTJa0+kPHCaP3O6HQTmTv8YCSY0byoH6QvdLfovx51YbAJ358UkQF6YowOUN4OvmHp3H0QcHHEP/7cRBVIH6K7ysRbAPhoekeiYaKOVmQ8WpzQ53Dr8ldKTc9GjorWSzNdBFjNBCEHbN2x3CjhDrB3jM8KVQJCZrVxvfK105Mo0m1yMr80RWdXoO5mC0XA4dn+SvRg0OkV/XTjFNvERvXW7kHSOp3Uln7Jf5u/4uUnQ9fLd6PcatrLNIhc/Uyz7P9Bm1vI4yrFPR2G7kH8Ftw8cBN7iPlDSB/HTzIYpoeg6H/5HprUrcKwdZ7xilLU2qE/42zcJC2mxP6twtr3l5LTeUo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9ea2724e-74ac-4ecd-bec0-08de1ef1f721
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Nov 2025 18:09:31.6666
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: SBkZG8G+qc6hAhaa+r+TPunMT63p3Q/reMlwK3VhOP1CdrlrT73Ayqvh5sNGX/nypIWqx6Hmq2PJcTvX6pZjTXyL07vdSDwk5yAIkIkldCM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6639
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-08_05,2025-11-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 bulkscore=0 suspectscore=0 mlxlogscore=697 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511080147
X-Proofpoint-GUID: HzfpRyQOLti6Kpx7DmUbnWv95b4O1Hwd
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTA4MDEyNiBTYWx0ZWRfX4d86bYSUtwxR
 Yh5C8U/MdRHt2hYZxlgBptx77Qt0X2nDrJ52Uz/a57y49zRt1Rv9/l+RzP1+XLdxmPMqI3rDeIL
 8qNezkgsFZHRl7cXexZRg0bto+hfw3zGkndDdoaQpRGojwX6yhu15AqhQkLgvL/ebMxLg+xW0vF
 nyMgr5qCHfjDJgRdaUIOjQHApjAr/6J++SDKoWGKEFz/DkVPTYHloWLGLKayvC+lxMM5fB6qbAd
 gwsGXLLYSTNd8czP/5Z6PBlJJ+xmdhL8wZeV/5CyvmXJITXPU0BU2ZkXKwiGlmt1vZnBPtdFC60
 Gbk5ExgjBYI3gppIfDXQWKUWMKjSteagNITAR7jURxYUw2n9bJZz6dBlWndGZJyqFPOCfYY4FB1
 oGg7OZSy4rPUd0fc7FxiRNjRRvsF9g==
X-Authority-Analysis: v=2.4 cv=XuL3+FF9 c=1 sm=1 tr=0 ts=690f8760 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=XAh58oZraF_OAtzByiIA:9
 a=cPQSjfK2_nFv0Q5t_7PE:22
X-Proofpoint-ORIG-GUID: HzfpRyQOLti6Kpx7DmUbnWv95b4O1Hwd


Don,

> David Strahan (1):
>   smartpqi: add support for Hurray Data new controller PCI device
>
> Don Brace (1):
>   smartpqi: update version to 2.1.36-026
>
> Mike McGowen (2):
>   smartpqi: Add timeout value to RAID path requests to physical devices
>   smartpqi: Fix device resources accessed after device removal

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
