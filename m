Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAFB31A267;
	Sat, 29 Nov 2025 21:40:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764452445; cv=fail; b=MozpZ51EiFoY1ci9pMuibqzSpilOZ79HSs1w7tDWykrmkKzd1fyYYloVtuX9mYsNQEIAylmJn0rjFMYv7d8ApwIfVJYHoxzBQBJwm7JvOENGb/T2WmJJWsYkxfRMq4o4sZB4PUqrALTakK+iVXkOGsKfzGFKwtRswpX8x/btqQc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764452445; c=relaxed/simple;
	bh=rZnK1RhORFoM9Gx8IZO+Ub2qoQ9BAnDnhizvIzdaOg4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=i/x5hECBuv9RqgQIjJBtwLoZuAb638EAeRZDLR6z7lM3K5jFYMHthctd+acJJv1y1qRPJo4FvwOIjfWdjlrCU/6G+MN+YfwtllM6Dc3VWNMwJu5lGVDd5NafLHTkf47P606IjreiNzg/glnaAwhw2B7eT98HLJDaRjTcwFegtGA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=B8kjyRk+; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=NA46HOK6; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="B8kjyRk+";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="NA46HOK6"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 5ATKA7uL2236280;
	Sat, 29 Nov 2025 21:40:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=ddNQnBigBv5Vews4CH
	bNm1KBMRG2R9jQUFmKcyqmrmU=; b=B8kjyRk+ylLOabFRx8F5IcBfpxH9DJgAig
	39JkkREHwxUkSEHnVMPTfIHOx0lSpfFI9r5ArXz+PBDYyKs5YjKMF3WM8CfK24JL
	haXiDAmrmzErYTAe8d4SdQpWoHlNXzsOL5fHT1SaVcExNoLpFOIIO7HH+1pFPaWQ
	42nDETP3ahVdy82FCRfiNu7NdB8N+21nXCpZC9CoSVvD4o+dDZfhJD76qEBAgknU
	xfVnfTWNW7zMXy+uD9LViKKAqOACwC+i/Hwq7qGouMxxN7nVHpFSGfnblY4/mRGK
	xBMDKG74ybqvA2gRsmQ7mM/aBkWIGh9hkVy3hcULd8OHUtmR6dpw==
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4aqq8c0mte-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:40:40 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 5ATL4weW029650;
	Sat, 29 Nov 2025 21:40:39 GMT
Received: from ph0pr06cu001.outbound.protection.outlook.com (mail-westus3azon11011001.outbound.protection.outlook.com [40.107.208.1])
	by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4aqq96revh-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Sat, 29 Nov 2025 21:40:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=kMdGKWmx2LnMeevnHew8VdSbpntjB8aVcajoAKTfcCXJb0kl9OD4wxCUXuwio2ld8WK2dKEgUOa5s7u6sNskGUnOFrLJbxlICd8WTjV7LQ1PCAv5iNDRBvj5DEIflAqTyqRWhtxceOZyOzIja6q49hFY4FErUaZQTsqu2ownGlseZngaxn5g8MR+T+P/uGCB6JfGAj/LXZqo4QnfQIGCLO/AYQuHT69vCMKFQORFsrUI46ykdlErpUZU6cm9yA1CwnqQm8wl+dw0f7KJVhA7cKRH5mmjlmY6hBiRiFU/Vj+JinJd+Ai5U4TDu0DaYGtWh4R9obt/22HupQRSSiDerQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ddNQnBigBv5Vews4CHbNm1KBMRG2R9jQUFmKcyqmrmU=;
 b=KZYkEa0SOHCDY9RW+sLH4i3y57mGWjGbpyVzjVKE8Zg594PhYcRjP643MgR2iqh1x3VpnT+XtabbY469Bt9okFEfMik6dOhg7VbwAj44s8jz0i+AewsnALI5K0O0xf+O9Gczhl344JjC2UZ6jEOqruuAn3uERY518UoU6gxD9Fzr39/NfzdBIpdQejkiv98VFg10Zh3vmDolvCftyaNtbRjuqgbMS9bxYob0oQ1IJtt3T3wpW++GCBCa0et+vtwO8hlSM4lQQivmfBFRVPSkubJn+etR7DeoqGcGMZNlUGTDvP7bKwY7eOMRN2qetuGsvsKafp4KF7agO/zaRHsb4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ddNQnBigBv5Vews4CHbNm1KBMRG2R9jQUFmKcyqmrmU=;
 b=NA46HOK6h1Pw0B11Y0yMH2uC1raB+CohCskXldcC1/ZDgM/lq0U72l4U7CPLyak3iyEFeo3eC8CFxp4Y88hxXkIKUxOX/beFbgZliX6s/UvwaZ6Tvwp/kqDU2i9k14tTExFBIOX3kH7zZV2tB/dGzlyIjW2atPiayrmYbnG/qEY=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by PH7PR10MB7086.namprd10.prod.outlook.com (2603:10b6:510:269::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9366.17; Sat, 29 Nov
 2025 21:40:35 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::5cca:2bcc:cedb:d9bf%6]) with mapi id 15.20.9366.012; Sat, 29 Nov 2025
 21:40:35 +0000
To: Shi Hao <i.shihao.999@gmail.com>
Cc: njavali@marvell.com, mrangankar@marvell.com,
        GR-QLogic-Storage-Upstream@marvell.com,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: use time conversion macros
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20251117200949.42557-1-i.shihao.999@gmail.com> (Shi Hao's
	message of "Tue, 18 Nov 2025 01:39:49 +0530")
Organization: Oracle Corporation
Message-ID: <yq14iqcy0u3.fsf@ca-mkp.ca.oracle.com>
References: <20251117200949.42557-1-i.shihao.999@gmail.com>
Date: Sat, 29 Nov 2025 16:40:33 -0500
Content-Type: text/plain
X-ClientProxiedBy: YQBPR01CA0037.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:c01:2::9) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|PH7PR10MB7086:EE_
X-MS-Office365-Filtering-Correlation-Id: 979ccb05-17f3-415e-9da6-08de2f8fee0b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|376014|1800799024|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?wAUiW7cCrTadF96NxredBfSjx9KbvB+GTLn8/W+KYxv2gVfb0wYK5EGwoTuK?=
 =?us-ascii?Q?CKhp1dMNEdyNNL8hAeHBgVSvs2dlY6w5XJ1WSYq7OaiVghq1rr6YBrCoF8HM?=
 =?us-ascii?Q?sFbAOVmbfa+HxyPz0F0uFK0FpV/PObZ8O/0T+gRl9IrH4YNdYAxg+a2g3+fi?=
 =?us-ascii?Q?NLxxhYqKolTQUElSaD2bK6H7d9a+qFpTQ/SfFfUTDB+/157gTYldTL44QajD?=
 =?us-ascii?Q?zHo5oHZ4SLkT2BgPjoVkdZZeTMnFew8hY/qoVHa99Vrm63lsi4jNNIJZzYw6?=
 =?us-ascii?Q?pEge1NwMnrWGiZuiCfXjgMFXXeWSxONX2Mvxvvv1KRyj2P2P+EpWMV+99Xdf?=
 =?us-ascii?Q?SVCUcKhkbmH45JSmQJEc5g1d8PqjaIolEwKFl9lyvjW6E6DioYu4BQV2SK2K?=
 =?us-ascii?Q?wSuuBAoMwJ9Gv/WKpU/6x1cgTqLbjkucJjCIWjVT0VJED8shDqbXvFZQw+To?=
 =?us-ascii?Q?WTkmyxbqxVZH85Ltcwvse8iOfxT1QJ2BQtrpmB4x0utPol5hRRjOcTJ2anov?=
 =?us-ascii?Q?EKesORrnc4u5THiC3qEGUldwIf+Zjff83aUdv789cKrTUxHgibba0RRXg1g1?=
 =?us-ascii?Q?IX1wVANA9YwuCmc4AxCX5z+SrOLSaM9PoUWXZpTNbtm1H0VYhcCoaMHAk8d8?=
 =?us-ascii?Q?om/8xxjoLOMPODuHcpSleJ03E6onLjRSW+mYyj3e8l+CoKoh7VvztLgj+Jp5?=
 =?us-ascii?Q?9fkuKuUzNAYDn1MBChbTVohdhufTWzzBPLsDyl8vcv7H6OEU8CmuO1mZOsV2?=
 =?us-ascii?Q?PVtUUj/T89o0uyzhNpyGS+QJcB7HV8uroDZVREIQImpoae3is5LoUUkmWnMd?=
 =?us-ascii?Q?0Iip7KF27Yf3Xvs98Q2PbeE5V+CvrIfsJim3POOtVm9USVK6+OkeS6N+gfrx?=
 =?us-ascii?Q?zmrKgdTmB002L54WgPsu6RULNLVm6cbJPtMoLc+g5JUBwoz7R762q38BsxFg?=
 =?us-ascii?Q?PitcWIKizgwNKVpvLOjkQEv74+hGq2yB4GuyTyo2e4R5xDmVDPJRfpGwZZNP?=
 =?us-ascii?Q?JQcEYQsq6hnOGSkJL8jFUndu15/EoF/XkssnxT/t/6Hzrn1tKkaxJnCkHF7F?=
 =?us-ascii?Q?YgAWPCP1i/aHIxmYyrcRyEJXnGlMb0eIhblCBqMh9jeCM5MOIfdNgHmA7E1A?=
 =?us-ascii?Q?99L35DbcMJpd+rW8l5nGv9mfOupaaGHE3f9OjQX9Yu6txNpDINijWPXh492F?=
 =?us-ascii?Q?swS+VnrpowqcfAha4F6sRV+I7YV8ZtdOgKbeK1nc78uJhcutEuh+8JI88Zjy?=
 =?us-ascii?Q?epgjD75M7rE1+1isbOOLMgTPxPr80/04uITD0xQgVC1eBpGyKk41zjRSB4kE?=
 =?us-ascii?Q?WFo0UtT0eXWYRbnkPD/5Nshg7+yVdRzXdpDHz/wiBSGvpEG+7bZZ6uXWf1M3?=
 =?us-ascii?Q?gjE+s2inbgnPSeFodcInB03M52cit6h0yaZrKK5ACYy/qpSM6eWFVg52Ve5X?=
 =?us-ascii?Q?hjRtoXaDcyNE0e9ETkGghlVznOGByVL9?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(376014)(1800799024)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?baCo+QD5/UtimuXAFULhy0JysIGADoyk/xG1knX2bd1eAZG7LXvYtbt1ePh8?=
 =?us-ascii?Q?j8jB8/vrw48qI+2UTnz4zGc6ouw4yd+ecrJ4AUw3S9VhdB2rs1c9GJTP12um?=
 =?us-ascii?Q?7tTlPAU+aaLJQ3ClBANDDdOwvOwzo1R/h6LxEZLZPhkBocZuKltoD5l9/VoZ?=
 =?us-ascii?Q?y1xEsVh0PUcCjTSYRFQFc68dTKS21Nr4Oe3MmHt6YLHJR6EQLM1cwNq9Csyg?=
 =?us-ascii?Q?/gfG33OgFkDAOC/PBEbK7Jayx9xRb1eB/Mh41Px4HFjzfQ14NQekqVsQDcOZ?=
 =?us-ascii?Q?t1yEx+6XTto+JmAYORkO7amSF7s017uKBE+pEt02lM1O5VEIkixGdo7+z4jr?=
 =?us-ascii?Q?jan6jnURTpnRNQ8LXvqjUNMsrMNemg6HPYHz4xJMrniOmKd8W+UaixHy5oWl?=
 =?us-ascii?Q?phHfZKJCGBUzUZop93sVgM84b7Sc85fwTqATEM/zCVDI8dZhKyaYFHDvHgZs?=
 =?us-ascii?Q?PNDozOpT0r38rncy2IkJlUZQfygAYuhDlYkqiSX+BxsbfQN1bsIaxn5X5RT3?=
 =?us-ascii?Q?OEvf9AK7uPOV441mP+OWhvRSv6y207lNAOA4yQ4rVbOx4HLy9LkfwF5CsDlT?=
 =?us-ascii?Q?UhOdpAAjBQ3Ry9MbRO4hvYu/0wNL+f9PWlFc7g1Xq+AjPIte1gJ9oMXvTgw5?=
 =?us-ascii?Q?DvUrkdBAVLT5IVFJNkYckmBmv+KX22+Y0heuf6reOwERjj7ITD+SswkqRkHC?=
 =?us-ascii?Q?M1XF5hBBfiFpcV8bhZG+ZlOmZ+9Jx5loJRpw40kqeDqEO+MUusoWXK+1nZUM?=
 =?us-ascii?Q?jRd+IG7hhkFLyWE0COldTp92q5+aanJ98kkjAVWN7Jqw+kasIrGWukOZAp8l?=
 =?us-ascii?Q?69CMYLJ8Ed0lmhWjNkiAmU5A6TDS/smCEV/rFvSbk0cJyTZrI2oTM+2+G/sM?=
 =?us-ascii?Q?BECSdaaWFOhxElaRDUAU3BovjvQkh8rDChQYXkQKNx1rOlDLF5k9Z9d4IVMy?=
 =?us-ascii?Q?WXH7GQ0L2F14GQ62wJF11zC49WRS9tjwiyiy1ctzZ8/bljspJmx+NyF+QeNx?=
 =?us-ascii?Q?Wbr+s5L7Wtr+zhqqr5DV0n8PDzScRzRs4Pq1amJHkK9kKw4iUplEXpauSE4b?=
 =?us-ascii?Q?vIe/bWdRrMQPWGCdbCRnU2nY7xEkDWej8CIgCwCziHW3XEt+9UISRkbW+hxU?=
 =?us-ascii?Q?4pgr9OSihpL5E5icoCtaQ0QVFzwgcmeHuJhaSEK3s05sjK0YvmP39baBQGNv?=
 =?us-ascii?Q?+1IeW02FHKce2bti3eLU7xuEQQyPWtWgpTCoaxhOjUrJv03gvw6XDB6H2at+?=
 =?us-ascii?Q?ypl4eUb2mLldYcM1+ZwP0HB0y8ZIgQyOIN28zylaCecQ+BolfhP9onQF3+5X?=
 =?us-ascii?Q?nnnB6EcIM1maVccGHdNmWPnQjnccKg++OWHjpJP0QdAoXCzgiiCH7OCtDl5l?=
 =?us-ascii?Q?loGTgIrnLmHvxGhJrf5bQ901EMz5Pqy2+4uWb0z/hibW5cQBiqZkXfHpEhnj?=
 =?us-ascii?Q?B1daFvzHsO3npyfWLojpNpxjVxm7YD4xKnLccRtpoy6lpH0cAu7med51ZK9N?=
 =?us-ascii?Q?eiV6uGchRBrlOeIWLMYsxIkEtJBQ1Z1nMefljM3tH+vy8mv3R1JgNzH/t3Kk?=
 =?us-ascii?Q?UA1xdVhTYybvR8x88kLfsofhHxAA6gYFQ7r58TZXcIys8SA9gQ2KdibAoF9M?=
 =?us-ascii?Q?CQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	gn58L1K7JiLjZU+keo2gwjJBCniG9Eeybb2K78pQE26+Yr2xHq0+sNYUybf5+PTOryuxRSMB5uCfzshoX/RGpfBm1rDR+nQCsdf5IrbM5RP/gBn4OodV/TPuOrLaLc9RUwM2dPj9TSJD9n+6rw9KMIjXMQj6Fe/nafNdFnfeDAr9tmowKqy5EmlGmzmoe5lGABzQuw8cY/EL+vLK2wYRAFP27bHQbPSi3Fba/bFmH6OorFCEAfs22XfeSCQuB1xf/nQnXDLLzmEqC1oycCH2uFBhOE849z7/Db9a07CMZ0TrY2ihSxnyr+X0xXBAbFIDEHeXGkifNBWpHZdx0q6gjBFZKQs9Sj5CzH9Cqthbc+5wlwzxJ7NVdI8kCdaicLBstEgYJ8N5WxVxJnOec72fObQ0gdZw6BrIJN5gNRe9Eb2CttOkE2Ry6yiDBtuDcF9duwmC1HvvlSLkzjuLfBzpaNL8WUp4HF38nSy3M7s2NNHVmLCXL0blvfUW6aiQLGLILW4R1/h31jdNjtTLUrzf7IQpYPDlmKm7/PvWN9xPZa6jlBN/loKY7eRHGiwBQXEyvQ72gacHr4GUuNT3bwte+5k2xD5yeoSxh4NhvBb3VUc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 979ccb05-17f3-415e-9da6-08de2f8fee0b
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Nov 2025 21:40:35.5045
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HV1wduttAUv/6m8OK10XJLYwCsy94clDvghf/A2wIQ4mxSpkyyO3bMovj6vGEBBbKchZZuiWy9jzHj49J46/06tXRDye0qAEQTd+HpQtUQ4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB7086
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.9,FMLib:17.12.100.49
 definitions=2025-11-28_08,2025-11-27_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 mlxscore=0 suspectscore=0 phishscore=0 mlxlogscore=661 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2510240000
 definitions=main-2511290179
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjUxMTI5MDE3OSBTYWx0ZWRfX9UtRHd2zyP5W
 ctoAS2x0sjwkcQKVwwqXukXO/4dJg12FF9liOTQRsktUJFrXued8bbLPjUhL4Pc8yqOeE/FX/2u
 C220aW0c5NQKgN6LwcTORI7QK54LK/Ji1VxC+AqlFs3U+e8fQvzUER/gJQbS7MKkvFmyvLUG13C
 s2vZJLfSBMORtYusnUUsqCba0RTz8jeZfOUXMbT8/D+WbcRkrp8R4CYf/7JkmQjm68p98eeIiS7
 nLcvVKrajrNAT71jRwJ1B3fSgcu0/kB0/pv91QP2L6vGhGn7yKLMfBX/HHP3/L58KGVBlnhnhJW
 gstaqGlenrlTszvaP/qchpq3Yze1UtU7OIy7D0BKFPeD0tB0U8k+8q4Sxm2NGJJfdlvxL0NKkCs
 Tv9kiX5Ql8fRpGGK7KDKizz3sc8Ucg==
X-Proofpoint-GUID: yi394zrAqvaxJx5_bFyWUqM_LqyNLBze
X-Proofpoint-ORIG-GUID: yi394zrAqvaxJx5_bFyWUqM_LqyNLBze
X-Authority-Analysis: v=2.4 cv=EpHfbCcA c=1 sm=1 tr=0 ts=692b6858 b=1 cx=c_pps
 a=WeWmnZmh0fydH62SvGsd2A==:117 a=WeWmnZmh0fydH62SvGsd2A==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=6UeiqGixMTsA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=APdTsy1mPjVvL4qEmPYA:9


Shi,

> Replace the raw use of 500 value in schedule_timeout() function with
> msecs_to_jiffies() to ensure intended value across different kernel
> configurations regardless of HZ value.

Applied to 6.19/scsi-staging, thanks!

-- 
Martin K. Petersen
