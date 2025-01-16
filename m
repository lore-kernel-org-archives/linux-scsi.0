Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3511154BE5;
	Thu, 16 Jan 2025 17:04:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737047051; cv=fail; b=mNT7Bg23xVOy27bsp21NlaSFV63VZsPfamJ1P3Jg6kke0e21TU1aK5kN5sMk6PApK+67+YYHKZvQDlqrAnlXrRkN1leZstf3fi+eCPfr9ujk2k00e25tM3y2sYQQJitgO8AJ4xT/g3clTpytomTt/lC+KgTZZQqSVl6XwSSeAzA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737047051; c=relaxed/simple;
	bh=F+RP7B5Bw991OHHY+NwYg1gQU/8Z6WhhMC/WV0c1dmw=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 Content-Type:MIME-Version; b=r/BOS17m0RsnYW9BahTyZTII3hheZ3FHNruI2kr7qYgbw/nmfMMBncuZIlBqNqkSkOru/v9hEqSp9rWbPR8WUzBPz0QtJIB7pDEOCtkV+3YDHBg8tijwpRPktb2eShuRC1pMG6NdzmLVLsbh4wb7mfYP+5ZfJxQ+UY5eq5mNd40=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=SW9fa21I; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=XuuuUisR; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="SW9fa21I";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="XuuuUisR"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 50GH0isp019982;
	Thu, 16 Jan 2025 17:03:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2023-11-20; bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=; b=
	SW9fa21IGZP5m57CVNzei3ZrXzoYomIvj7zgDpXqHToD/0hm1FKdfGpaXEc15+d4
	4yaXux+acwIE5/gd/4RgEDenRX7Nnl98fSsYtwU0dcqQ3i/JSyDcFsz+FL0bfNqH
	s4812m9aXsoT/1J7txUt4bDziNJma7YkDcCLzGKLx3lPMQhlCg8B0evb4Uf3JkEn
	4AVe4gW7woVS4ocumhXP8TCdDazSvM2H1HP8pZZ/b+VdvKP+4kucVPWFqNv8Ddr6
	QNVwryTWYvtgzVy/p2jtrrl+ZGtmO+PTPSA4b+FwQGN0sDZRtgXx/TKsyf0uKyhh
	vy3XsXLt+anSVXOL7i1+XQ==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 443fjatpr5-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:41 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 50GFUNMp005208;
	Thu, 16 Jan 2025 17:03:40 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2044.outbound.protection.outlook.com [104.47.70.44])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4473e57p44-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 16 Jan 2025 17:03:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=LjmVdmqyC0FLVOeXp94R9vF80T/TtECw5Mv3P/DQO8rqUxBmj6dWZOOyxPhapeN+4lLNrQZqIbOuW5pinD3zr9uizKtekfl4skgHFZf+l+YlyA2/hXFDqnH+0wENHDYbrbrsAys1RokXIwzETEbjkXu0oY3sceWVCjP35SrBoiw6jCNlnmq1PZq0/CMT2ps1Xp+dImEPHOiS4qwTgT9eGfroHxB8dQBBP9vFPuH3lDyQsVJZosUNFKv0IT4680PI+QGbVMBmvRae+eU1ko+5bKsCSsiQU1BVxhooLH4q1ys2Bt97fYURtI0MV6+apYzaNcIz9qzl3Wk8+qRYxDE96w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=;
 b=IoeZxRjg823sAu42rSqnsMY8jdSS93jJKdukG67jyCp7ouEZ7jtQLd1mN/FfODSS6EVEzt+uZlXqiKK/JSnf567uyiThVpAkR7YBwujQ/M/Oqrgf2NsyBLAV67Znu5XkCz5ahTQkv4mwHuao4duuakkKc/ggWg062oSE09GiSMS8r5GZcRrz2ENRhA70VWyuanUN9v5Aaaili/8UTIMoRw5CqVQuyn0McbUURA6d/vgaHQ/iNQ3/+UBgs40F+ekoz9RH8KphxBF+G1TXPFhyOV3NRU65a8WtXJFbanTPqT6IGSS29ujoiiX3I0XvHf8vczMW9i1b55mmXDxcGCK3ag==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=9RvRaCj1qXoc71O+4ar8RblUY1mnlIDr1xYBjAFSGms=;
 b=XuuuUisRTFzEuHn+KZ5OHa9Cucb4L1lGGtk5dPJgzR3LgN7DSYPv4TVdLVTkfiiMaz72T4O3hRfUuRmErum+e5YjNuVFDOUj/Jfzf0rPybQTd3DxL2SpuEOSNeTkSZ/67vY3SjK5ZhC+ZjECSeDhuAEMXWz0Vo+vzFcMdnhPAIY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH7PR10MB5829.namprd10.prod.outlook.com (2603:10b6:510:126::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.8356.13; Thu, 16 Jan
 2025 17:03:38 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::4f45:f4ab:121:e088%4]) with mapi id 15.20.8356.010; Thu, 16 Jan 2025
 17:03:38 +0000
From: John Garry <john.g.garry@oracle.com>
To: axboe@kernel.dk, agk@redhat.com, mpatocka@redhat.com, hch@lst.de
Cc: song@kernel.org, yukuai3@huawei.com, kbusch@kernel.org, sagi@grimberg.me,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
        linux-kernel@vger.kernel.org, linux-raid@vger.kernel.org,
        linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH RFC v2 5/8] dm-linear: Enable atomic writes
Date: Thu, 16 Jan 2025 17:02:58 +0000
Message-Id: <20250116170301.474130-6-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20250116170301.474130-1-john.g.garry@oracle.com>
References: <20250116170301.474130-1-john.g.garry@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0140.namprd03.prod.outlook.com
 (2603:10b6:a03:33c::25) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH7PR10MB5829:EE_
X-MS-Office365-Filtering-Correlation-Id: a51d56bc-07c2-4a8a-cc47-08dd364fb87b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014|7416014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?SqT7LJO7WY4ynliFEkmjUreO74dI8PimXBRAGFMFqsT+w+HtuInCyKInnApD?=
 =?us-ascii?Q?lzSQzsKF7TPywcxjkqn9JBBFOVcfBW7JPoU75HgIwvjcEBUKPhE1IpoIq9dX?=
 =?us-ascii?Q?TFf/NiKWhHRDfkGR3VnjBjgHdZHdtG7A8+EbLa4m7LuHjuXgI8LuwRNW7nYt?=
 =?us-ascii?Q?wqFHO/bvBVmPi0YangDcMQ5/05Rr8MSGLqUMhb3AdYnKtlocEfSbcgGqIrXy?=
 =?us-ascii?Q?7IsCwNfkXftGiIR3EVeWu+vuX2zeMelC4+XxONLpQ82iDoPa7VfWRAaQfDZd?=
 =?us-ascii?Q?eDBvG9r9zfBKJNf/YrrSPOEmElGC9ZouJqS+t4b4uXCAkoyPQdyRHnpg0FYR?=
 =?us-ascii?Q?d5159I7Dl0+37HKdJvdJ6od3445xySGKRzRvVNQ7U6Gsg62m6SnjQYwjkRFM?=
 =?us-ascii?Q?1ewe4ECs7uvisP3R6+NWfAM+trfm87cDLkTi1ZiIbU2+trN1PZzOPKSrV2U9?=
 =?us-ascii?Q?NhP52XBn7mr5LnjqRTQu2DFziLHl/Qqmi4rHlFBWDg1MD1j9sb0TyrNDjsUP?=
 =?us-ascii?Q?BsAGYJT9Vv6SJQWOrztCOfCk+nITkUKWaAwKCVZzp2gPzCEzocd8yeQF75RD?=
 =?us-ascii?Q?l23LgxxqMbACL3eW7BsdbVnkLdAu1Wtj6B/9GLpp4NGmM4UDgM++mo1tpbf7?=
 =?us-ascii?Q?iWIr6d0pT3g8X/YC2rV0tAy8bd8aRC9sPqzXfVbgP4MJ7N6/q38kgGSsFEzs?=
 =?us-ascii?Q?Sl1k+jxirEn5dG49yfkWpeo6a49mlD/QbD0CWcKJchdkkMn1YS+S3rgoE+UD?=
 =?us-ascii?Q?utoWYUfs2G+0p86Mn2FkT4SRfBZIXaXi4Wtzc34xiRDk60d3Bu/MZWYBHMqa?=
 =?us-ascii?Q?VMVsGnp7LEh7lOLyY5+daxRdOfF3xI+ofs7wZplRu6aHJ+iuGrdhMbSSzLd1?=
 =?us-ascii?Q?6vghwLdwMGYeHSdThFXt4cZZg4eADPnzK+w8lXup8wHQjUn6NiJIFht3wstn?=
 =?us-ascii?Q?os4P9WyRDpKAqUVk8S9aQw4EpiO0MeImhNjwDnEHkS52CkE1hIA89wyWh5CJ?=
 =?us-ascii?Q?5e6d0OsSoECXW1pz9mX6zuL99luAbw7zBr5Z8b7d5awDxJKCz0mUbQcip8a3?=
 =?us-ascii?Q?HPK8065ZyPQCdeiGVQreSLcRrPqCiJL9p+BcgqFv6raHviKq67GvAQoFfFmf?=
 =?us-ascii?Q?y5vO/KcOz0+3xto1SK/k6w/b9EVdTnu+o6OGJSuWmL/aV8RDXwskROQBKoWL?=
 =?us-ascii?Q?MTPL4Ac+d9l2ffaBX3HkuDf7Mx/bqEiZgSBfo1GIeJfuFDtMPEb/Yb7t8mVm?=
 =?us-ascii?Q?amYwUyMivrW22ccLbu6nEaLES2VBhH219ZQ2HjIFCr5sEpGk8Q5jB65fBVgc?=
 =?us-ascii?Q?OJW9qs5tg2aUjJBgBOTwpzCG5BNOkPHUgv7PCCGCPdLwCZFRgITH2MwHPq0b?=
 =?us-ascii?Q?xMRknIhjrQrEQo2R3ds7XHbEpsAx?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(7416014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?vQfqmn0PbN4pB3pnVrLb5xvojpSJUg1CNQ3fK5RTCDyYAP7Tz/xkqcbK7F6D?=
 =?us-ascii?Q?wjdNiREf5gdSPFXPOVR1xfpGLCaLpdweiP/VEM8HYtfwoDOPLXzAX3It4EC3?=
 =?us-ascii?Q?k2cDqBP9RwNC6Eq9BCHor4dO/ibMi8hAnwa5T1IZXVcyOIbGZogeDoLmaSLw?=
 =?us-ascii?Q?mrCWYEEUSSw1RO3W/dVpYgx0Z49VDn/imf4QbTD7AW7ICVaVHJCEms/RQRbs?=
 =?us-ascii?Q?LhZw7NeAlbAFA54/GB717IjG9ZJwsnTrxZhVwICv9ffxddcsQcwqi1RYjBW6?=
 =?us-ascii?Q?L3vvfHvmfr4PMGlrNJpWWM6HqSSg4WrQpZ3sl/5nY5wWFTmRFLRiLqKTSJli?=
 =?us-ascii?Q?wZZ9JYXeEA6wSekpghmN6XuaEqrzvCLkwxGSiop0enV1E+YpTGZk/kJtDzak?=
 =?us-ascii?Q?eAk1MByaMaTFV1R51O+30IcKZtEsJMZJ7ODByW8FhvEh+hcD2efbDHf+SgG7?=
 =?us-ascii?Q?2jhRVoaNuH1D2+MSVRVlJHkwWK40p4G8FWLaPGLiT9Is0EgISiC0OZCPsk4L?=
 =?us-ascii?Q?dt04oSsNEbuj7BBoDlCJJxXFrijbgGyyBYFEZU9mbmtDHO+9kV2KZuO+zsZ5?=
 =?us-ascii?Q?TTYASfmCC/c/tqHHLnqexJ6PHaR02pN2/nIzCupIIb+n8zaSntyJA1w19HdX?=
 =?us-ascii?Q?1zqaIvr+JH8WmLo9ll+bqBjQaG3CW2mwoPCAUvBUfbeUnTYglcVksKcDclhK?=
 =?us-ascii?Q?+Z4rmUy/7e41WGuwNoqYHoagwpOEBZDOofVtgL9rbundO3D6EGdL3SXD22il?=
 =?us-ascii?Q?WomG1gxS9wdHCadZIjrKR0Sy//Ovu4eGoUVtqBzVQ45oLrH0CZScAspMOVus?=
 =?us-ascii?Q?FhrvwrDuOolj3bpZ/QRxeTr1R+EB/qV5KT0BPMoNs0ispozdVyEj2R/Z/B0J?=
 =?us-ascii?Q?0Rtfmwb8bQfOr3M/QQ0ZV98wdwUvhUyQzNPPbgAcTR9U1KxB/vR6omX9oBaL?=
 =?us-ascii?Q?ZbJISkVD0DgoxW8ktSwp3MbRxX4S6NGFzFaQR59dHWpFTZKl7c998WItJTpp?=
 =?us-ascii?Q?fGJnaDSvgYXbsS6FqEdDim3QPjA5Oeo5Z5md1veiHC76b9NiV4KY8C6IgZHl?=
 =?us-ascii?Q?hH6GE2Kr3dNrfFzEQd3dE/u0oYYsY608tVktxeTpXkpfH04Tse4UqZLaIUwQ?=
 =?us-ascii?Q?lmhmOh5SoNsq91xmjjYf6/McUx90UQFLSAdI1qPQj6zm7jPio2/b+zJmBcR8?=
 =?us-ascii?Q?FZg+5Hu1C6z4KVAY2IwatjwT7gaqIop3FtTOJd9OU8YiRKWWZkzEGqBRaiKL?=
 =?us-ascii?Q?rNETa76sfXE5c4ATHJhm+f6XmXIdZPm0qdI4eMbu46zz+0HSi873yqPPAjwA?=
 =?us-ascii?Q?6l7aMsvf/JYylAUv53XP/XGOof31QysM2y6vy43JFJpBSwkxA+HeWQ263jVo?=
 =?us-ascii?Q?3F6t8pI8MBwBoqPp/dnxvgh14/AoKB+H0qZLfD69HwMdBHrp6qxNUhC27Xcx?=
 =?us-ascii?Q?UAIeVPH1kXN/XUt3lPdMaNItFE8ZyETxkdrojWpTicK+uvCbpanwqX+nK4Kv?=
 =?us-ascii?Q?csJKIYCYkQGWNNwjsg2AwE7/DODmJW1dq9dgkHISM5eIUIxxivALc9gwWoUk?=
 =?us-ascii?Q?z2oqNZ/Ca2tcyQPL2sAXDtejxb/P8epxNdoRH7cBcISESOoe6ieCAHprzvNs?=
 =?us-ascii?Q?QA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	V93G1+0FWyoQl+phO/pq9YnAdBS3LYajy8jrE7kQzzn+mCoLG8HjOyPExR4NtCC1WVZ8g7qrIu5R2dv0LXlN112VrYNFIBJ2tkPryyIdqkiDdmGNO1GN8k4www2fwPkQ9BBnM+HOwZkYFh4AGuxs6Cz/89jdC6pp1VmVtaLz2NbJFXP4v7Bm2GNxHje6/rcTLHKi7lLK+uDiDsF5dDdLtA2E0I+U6oKPS4KE8PqKE2nTpM8VC8XF+e9JRGJpV+rSgYczicWBvoWi0t4Eic01NwO5UcdCSuiz6xGhutWiyMhXtNrOxqzV1Lu0RF56/VUnTP9a+HLK+lcjTuRWoXIEVxsKpIzV5Y+l9Eni00wnX36GTw8xVM0gOylfnkjApOoHU/g6uvpHpgJY893xmqLH9nNkk/keuFw5dZbSCnxk7WfDdHuC+44rT2dy2+oC5HDaZosAwgVJUD2ogwJjWq/8NlPtpxMlbtXQ8U/9wO1iJu3uG2pEr3evvoq7JXIh4DBrsaf+30/RsFLZGO9rLjH3Wd/V9gKjmpF6pmyZvmLLpMD7IB/vrkr+A6qR1oe4IqK7hDq9IYhK+/muLCB+peMJ+V7ViZ7mX6NRDMq/saMgNp8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a51d56bc-07c2-4a8a-cc47-08dd364fb87b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jan 2025 17:03:38.3183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t6jN0Z1y0PFCQ19iwgYyO3u750oRxsHTbk4/XL7RTrQZMHZCRCJ8QnyPbe9nXN/gAi30oX6rLjE4w5+zhdyM5A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5829
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1057,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-01-16_07,2025-01-16_01,2024-11-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 adultscore=0
 spamscore=0 mlxlogscore=999 suspectscore=0 bulkscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2411120000
 definitions=main-2501160128
X-Proofpoint-GUID: 9OvAaC7cNKHaCmOKuDtW6F5hLKE6Cb8t
X-Proofpoint-ORIG-GUID: 9OvAaC7cNKHaCmOKuDtW6F5hLKE6Cb8t

Set feature flag DM_TARGET_ATOMIC_WRITES.

Signed-off-by: John Garry <john.g.garry@oracle.com>
---
 drivers/md/dm-linear.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/md/dm-linear.c b/drivers/md/dm-linear.c
index 49fb0f684193..351f4ee83997 100644
--- a/drivers/md/dm-linear.c
+++ b/drivers/md/dm-linear.c
@@ -201,7 +201,8 @@ static struct target_type linear_target = {
 	.name   = "linear",
 	.version = {1, 4, 0},
 	.features = DM_TARGET_PASSES_INTEGRITY | DM_TARGET_NOWAIT |
-		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO,
+		    DM_TARGET_ZONED_HM | DM_TARGET_PASSES_CRYPTO |
+		    DM_TARGET_ATOMIC_WRITES,
 	.report_zones = linear_report_zones,
 	.module = THIS_MODULE,
 	.ctr    = linear_ctr,
-- 
2.31.1

