Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D904637F8A2
	for <linux-scsi@vger.kernel.org>; Mon, 23 Feb 2026 23:27:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771889266; cv=fail; b=j/FqRXXNghOgPilAfCVYruhPrMhIm+/RDCKHP4bg17ClmN3YvoxfpGp1Inam18uOZDYaJecNbI67H0LlqIy3k4LTFEuhc1aHDxrkNaLugFQDiJOME7QASGsKRFMPnlUl4XW5UOKDT89uE1DVW0hc+zlgFMhgcxBKUUmg+SYHTJQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771889266; c=relaxed/simple;
	bh=qWHlzSdQXFBTaua1Hkx5vnvT6HdcvqQYPAedYhiN+2Y=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=IfCv70/vsIOUBGrnThnnVSdWZtLL6xfhO8Ea9LmMP1A/U3U3dT0zcVzIh3tBVm9Zt6ixnlt4cEYPWQfj0KxFoYiOHIV7CS2xka6Ssxj+eD2E4TbNsR7w1u1gsahbhow0UU3vYtnmGNMCXZf5cLgnF5UC7xA4cs3QcCMVMYSsve0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=nUw+VU2s; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=jr3ACBhi; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="nUw+VU2s";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="jr3ACBhi"
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 61NMv4k12948644;
	Mon, 23 Feb 2026 23:27:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=zsfdkOPljJB65Dpb
	Hs2+8DdNIf00OEhfj+fQfc9uMc8=; b=nUw+VU2siXKtW44yI+bp9z4p9gHaY660
	tc3f6+TmQ5wtm+NcMTmaEcaoUfaoKFOcKXZkIDY2GbZeiW0smyGYILyupKJYT7w9
	Y8l3RJHDjABnCE4N2utXG41y5IA5+fzX/nO/6nxJTdnRF1Gt2JeHCGZkxKqmQ/sW
	g+nMRRw4egyhduCJmZtVjYMrel05vrycEFYbWyhSACDuSZbbOoI0Jambec/Qhl0H
	iR+xtg9Z+Q+yFtuszCjHe6sbHzZR5MS7A5kfsWHjJd9PKfQgetcodxm8UL3+SOvJ
	DWMsHz1cGTBMFAAq0HYt3UF3s1WCQUFNTkILNCDf92WsHh4/Sbw/Xg==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4cf34b3c0j-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 23:27:43 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.2/8.18.1.2) with ESMTP id 61NL3YEi015682;
	Mon, 23 Feb 2026 23:27:42 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010045.outbound.protection.outlook.com [52.101.85.45])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4cf3598y5n-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 23 Feb 2026 23:27:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=igvMBDNHMIvoiBwTxDUOIAbskrX6dA9Lg2W0gk+1Ecl0bYqkQVr9/g10gB9FQWsOGvNJuZnleqBZKahPczWf2HUaHqpGupcA48DruiwNjPafldHFggT9/zuorT/MC9Z/UgW3uBvvk/a/akrPy1IaPlByT1Yk8+8DPllRWt1XlarkRaTvl33qfa1Pi2sq58PZGplBxeZTk9QjTsPi6LfzPZjy1c9sLlGjikeblq9RGWzfM210cQTk6DekBze/jx9RMAwfv1hUBGyjuZqdfSr/It9r8+JGwQBTjpf3208wQwL4s+acybMeAlkXBY3rs+7adCUMZIwspUXQ61R12lch5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zsfdkOPljJB65DpbHs2+8DdNIf00OEhfj+fQfc9uMc8=;
 b=nI3ktGnRRliAMupNNkyzntyfJS0A3PMuBCXB2NnMW13FrEi/TZv5m2t8ds9+GNWUUNkmxCdYMpfc4eh3cLr93KB8GlwKLDDy7hFfvWQFlIElEMAZ8XuGeoVSG9SMYozM2BYg+tPbKyRJFzfsrE9P9K8GD3dYG/xKvEMGWx0K88t4RYRrxPpilN6CO1tez8bGtlYGW6x3fO60Cm8Sck5e8uYyoKhgfN7IorOn4Ax2NzESYNNthTcNvDWSUfPFxoeDNstCk0gnhV8OvOcLzSe1h/Aysdv+z+EOsMDu5orrB2fFNwmegSGtCc76mbLL2bnGxDObH4mDBWEtsYStkAacEw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zsfdkOPljJB65DpbHs2+8DdNIf00OEhfj+fQfc9uMc8=;
 b=jr3ACBhixE3K2Y0pt0Q3bOzqpRaHCZEgxmyYQufuhm7LrBKUgZ4s66yOeLH6mL5ofdPDO5cwD4Ub5Ynz2KVYL5GeBmfkG1gjfYsu0CdodN2T+w8bCMu9T1MtjSOiKQhQKZVCiEUbXu2QGEb5vRa+GrBCTNPORrUNEH3tke/nFSU=
Received: from DM4PR10MB6885.namprd10.prod.outlook.com (2603:10b6:8:103::19)
 by SA1PR10MB7554.namprd10.prod.outlook.com (2603:10b6:806:379::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9632.21; Mon, 23 Feb
 2026 23:27:39 +0000
Received: from DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba]) by DM4PR10MB6885.namprd10.prod.outlook.com
 ([fe80::544a:41ae:543a:f8ba%5]) with mapi id 15.20.9632.017; Mon, 23 Feb 2026
 23:27:39 +0000
From: Junxiao Bi <junxiao.bi@oracle.com>
To: linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        junxiao.bi@oracle.com
Subject: [PATCH] scsi: fix refcount leaking for "tagset_refcnt"
Date: Mon, 23 Feb 2026 15:27:28 -0800
Message-ID: <20260223232728.93350-1-junxiao.bi@oracle.com>
X-Mailer: git-send-email 2.50.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: BY5PR17CA0014.namprd17.prod.outlook.com
 (2603:10b6:a03:1b8::27) To DM4PR10MB6885.namprd10.prod.outlook.com
 (2603:10b6:8:103::19)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6885:EE_|SA1PR10MB7554:EE_
X-MS-Office365-Filtering-Correlation-Id: 62b752b9-aa6b-4864-1a64-08de73332243
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|1800799024|376014|366016;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?iQ5vJ/FWQjXkLBdWDXWa4rE8fAhXCOVqSF5dQek4pLxJZkt/kd6+DrEn3tdK?=
 =?us-ascii?Q?1fpKGU7MqtR5+8GdJgI4Ih/NqeHtIzHU9A8kwW6SvWEmokSjHeIkcZf1jqt4?=
 =?us-ascii?Q?Muv89M+/h8k3uh5kC9tdxPbSYkmK2HkXc47G51EPQsiwVEAohwgiv/mYxtXz?=
 =?us-ascii?Q?R0ACaYOZ4chXQzRHBZHtlaaBkHsZ2SI1pihcLnOOUUWPsGgdJyU4/Un7wzBy?=
 =?us-ascii?Q?JWcjiZCmmXCazcKOqxF7GOKNXdHq4COrzCP20v6xBFadD5UKqk6nAxPem1f8?=
 =?us-ascii?Q?oy6+xi5e2ro0os4QNQolacHP6BdVRaRfU8xI7TiNSa72IMlcV/81l9zH7vSN?=
 =?us-ascii?Q?Hnfnp8JGbiNBbaraRewp70B4iywNls4raaNB9ZkbgYG/XmJnIFiHA1Jpj5kZ?=
 =?us-ascii?Q?QdrZJFmEjeQnOISPmN6bkXBgcjNx9EM34NLBWfrXF+T2HwUBwB/vwltJwUsY?=
 =?us-ascii?Q?MSm5AduUcObpGCq2a7PJWADsu27T0hwjnEL4jiaCgXx3dVgc7v+VkSID/UmV?=
 =?us-ascii?Q?bG/NNRbKHSPOpxmLovDFScGW+kQe3IZSiNcI4ieWedHdB7j1rqv9QG6k2Udq?=
 =?us-ascii?Q?Ip8x1qfB9Bv0W4GY28xwSt0nO0UX6mF8BsVr5NHAaR4FHcwoNqJP2Fma2i1w?=
 =?us-ascii?Q?d1W670OikCvuLZ6z2kvfjioGCPxPpPbW9udkkrfEcpN1I8X016gCgI6GsDfl?=
 =?us-ascii?Q?pwHk/wiMjPLIayd1FYekaN6OhOrmkR24X+3+yW1NTKqHzZqc7EARxG9JzPBZ?=
 =?us-ascii?Q?LFltlGXgUScV307mZN49AqFneRZF7K+DCbEn4NlgggGTEnvdYokkVkb2RZfz?=
 =?us-ascii?Q?3gx2IVCFt27yARKoUn1mHX4kdvTovGDEyttHWKFpAq22bDnd4/7PozHNbKPH?=
 =?us-ascii?Q?AmT+2T9gowlwHat8gxoMWg+5GvA/wWlllM+iksHh2VdMmF2GNBQmINdUBKCz?=
 =?us-ascii?Q?BAYh9u1bOi1UJ3bfXDULy+cUrwEOsXsrrwq554iLfy6AKZRQhrJawY4M5oZb?=
 =?us-ascii?Q?8gbsAyrXOugR5jVHW0DhpJC8k87KIG9lNW6fVH5tUPEQo1jKGqTFCY9XBVbG?=
 =?us-ascii?Q?bmIb0q4Kt6ZYT9RRhW3OXkRHdkPsJV8miWeNlT5cn/+NmPuF3BvjxGXrgilZ?=
 =?us-ascii?Q?fCdsy/t5PnnA+GNt07tMKwOPMkkSURjAUdlHV3Aq4Qk/B0l50H8sBmZCln1S?=
 =?us-ascii?Q?oWsBOUjdlf1fmhMpuQr9fyTKSCObdY1iZPHGGRj5U2SMArXYC0Hm8rrDGjro?=
 =?us-ascii?Q?Ra18ZqXiU2T10kXaD1NOLfOlYAF0Ma40vWbKrDF7Z3nCxLfcSDnBzYXzDUZz?=
 =?us-ascii?Q?M6luCNJebOWeomKFaPaKXs6QzBtOmsR/+w4i8UP7vkggYt3EfmaVZrJYiCC+?=
 =?us-ascii?Q?bagAKGcB++Fxo6iwXw+wIUtUalkXr2DNuBPoXYdH8ehYRMTrZvaG686ziakK?=
 =?us-ascii?Q?iaE+n3QqN87VmqX+1+N6ESfzeVOTdTEvPFrVyRiaLbQ5xpB5IGd2W45iYod3?=
 =?us-ascii?Q?j5V7BlQXC7ZL7jwFqPwtmDoLL6sX3TDat9KPTStg/v+MP+vDQ/Az1xwdAbAR?=
 =?us-ascii?Q?h8FgzOTx4LCehE0z5Ss=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6885.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(376014)(366016);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GEu95mM4s11UPmdL/W4jZzhxMs5QsXZ2OwJGpF/xPCQgMsMquH7EM7q13tQw?=
 =?us-ascii?Q?kMxZ1oD36sqTo5MfOftM8U4j4kbIJxpNHn1CNS4AARoqACi7hmJuTPQN9+AM?=
 =?us-ascii?Q?pyBO5Aigwll7TndvgsH79mfuTYMzXAEBsQdZPE363RhJsGGuUwH0YyrBqo25?=
 =?us-ascii?Q?723HOWmWfgfljh0BsL+g3XwEhDGAwG1FecucYpqhoGMnruKdusqcS7wfFqk6?=
 =?us-ascii?Q?TAidLvCVyrAOq4LWgSa+kJqVksBJkpz1SuOpmbcdgzYlwtqU0o4N8k0Gywkp?=
 =?us-ascii?Q?K+2DPTA8Zcw9ReJozga3o2Igyw5bgoxLGbphVqDYzTt2o4oEIh2B8jotfwCa?=
 =?us-ascii?Q?9eQK6kHpPkbOcfAa2h5Nv4JhTZaaNRffdTgXIK2dkumFBMiMSaTmQiO62wWE?=
 =?us-ascii?Q?GQWW0JLb92u6DL2Ju5h5FAhBCErJMi67MIHKfjE8LRpl0xuFhHG+fWgXdiux?=
 =?us-ascii?Q?bHP9/VFXzkz+ldG3AvJ1iVYqolRTa3MRvtorwbAOY9YIg7YqVbb7x8ZSkQhp?=
 =?us-ascii?Q?80/ybIRPYjWFpR/FfOg41L6+trkOKkYqlyTuroI5S+7v81XqQtAuBAF68a+u?=
 =?us-ascii?Q?AnvEKW6YiVKzdVuDuZqtRisiQGsV6b2w0SyTUmc+4NZ4vc0LCxtWI/KAqMHE?=
 =?us-ascii?Q?xRwwFYc1DL2DfJJ+oAZQKGa6fJs6T8bb3o6/agjqZ2S/L+n+aRbIchSyZZEu?=
 =?us-ascii?Q?MOKMMpKMM5Qgx2smb4blSVeTOyufqi1cT8f2Skeb3IZ1/OniAmR1tsDIg8Zb?=
 =?us-ascii?Q?C41KOzThUwgI/VJrZqxjkvTfvYvBNz3oW5yvOhSQ4HCDUBRdkX2M0oTSrn8Z?=
 =?us-ascii?Q?kHOs97x7/odENRxC06vj22u+MvvAED3+4lwvA3xph5NIPo1h2bDiT++YXzFu?=
 =?us-ascii?Q?YcK/Aix+8/qhftf8Gaawp+okBGDUet09s39RNYl5zPFzhQUdFMgf3xeZxRDT?=
 =?us-ascii?Q?7ns1+3oaiAGRG68pznA7Rg9Bl+czaU5bUsydHjxTatOKJjrn3LW0AVp45qAA?=
 =?us-ascii?Q?FyJnGSwJ7U4AmF6e+Yn7LV+SQqK1YyPWXE55dbCSxyTTeIYFBrEKucSqH2IG?=
 =?us-ascii?Q?MDGOvNbQe22VA0zPGy3Vl/w4+irgJZwoI5aWabtS0MCczpTPllU0thXSkbYG?=
 =?us-ascii?Q?KvLG7V0o8Qs4FaBgin/UJyCvtUVaPAcQE2i5I0MphYbtNw4DaupD7lL6ijyg?=
 =?us-ascii?Q?qTcHxz5fyLpFwQw/W1g5AoJO2Jrgd5x2JtbX8G/Lb6MvogPT1Gjkot5WbkMr?=
 =?us-ascii?Q?GYb6o9zibse4Ow7/l6SjKZCs04nnxn0MJvKiv8w1eMp3UvQa5mRfPIzh/bMo?=
 =?us-ascii?Q?x0LHbgXN+dmt9nMZLMxGjKbJ4gMCxr8FVV0ZJBT6IIMufbEAj7mUtHf//QUR?=
 =?us-ascii?Q?P5UuCGkPaV75Lu29z06CwQv976JjQHVYydznzYHnTCnudtugMM5rSQRqExOb?=
 =?us-ascii?Q?MXHHz0ZMVRFGe73ZHSOuw5J/8/TWTwtH2I/Xs9hs956hNVeBfpnWK2NBO5aA?=
 =?us-ascii?Q?9K0aanwXuRwnH06PwvDvEUNAAMoVOEDPZ7a6PJqR/Ojkmp24xr+0PS2bEmXY?=
 =?us-ascii?Q?GnKKOcXRv8gOERpuGQosTsgB4I3JaJegpqu2BX6P4nBu5sdV3zCRDinW+JGI?=
 =?us-ascii?Q?FEwKsIwvAoHNDE5XgHGZm24M3tZIyWjFynx8rC5uMNQkC2KAya0hdfXbC/HW?=
 =?us-ascii?Q?bWr3e/yNn6+R9bMrpNe7aVoW8E4/JuE0fNxcRFtH55BmUqiBk5WOsgTaK9gP?=
 =?us-ascii?Q?ngk8lKywXA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	31JlFoJ+3YxbnQUsiVXreJOF3m4Dda6ghMSIZbxpg/q/xEBV2z0Q+rYjh9UfbTIjPsmd/cdexddy1QQO2COjfcdyiaPDlR6jT12cBJKMddatu9o0IK9unCHS5+BkyzfxAuDZyWOOdQbz8/Zav4DeWIbcb6PF/rGTPBas0e6NWUCYu8TKq3zvdM8xxEzr5snjCZLP7YH2DVhtZ28BKgaQkVovxvi7c5g2srSxaA4VJkFLXPeDwnpgiumfnfw02KS13V9vxglkhJd/5bzjmwODoTrjcvQXkmQqSFKRiVr+YgvaGMKONdC/CRkz/W4SWnLMnzF21o22L/3XP4uO3Tod3zhr0kOjexjB/ZsvikJ25+vQBs723Ntu4l6FgPUPBtxzJrB9SHjmir7KQNA/CGUHShASQOjJLOrIBG6x6NBNyp9XDG3GXBbi3KTrKMt4ROUNp4F5LpoJPtZjd4zDcA1X1QpWn5wNUxwyxvSFboyaCUyK1AXsEn33Z5JfdbC6gvqLqVpTfspZpd1Hg/Co4wMhKPq1hzy6S7xhvWNQWapS2kotpCDQnXj5A+VlBEAsI9BNWr8A+fU8O/ptxw7wYzl6ZrZdZEcp3NVWzCxe6qMWfgk=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 62b752b9-aa6b-4864-1a64-08de73332243
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6885.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2026 23:27:39.0443
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rAgAPSrqjQyn55F/jsgVh3c8dt6wjHGtsu3j9cvQclWC3z+P+ySnZcQGzz9nZFxnDPcqPNbw0QRMnidw1B76tw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7554
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1121,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-02-23_05,2026-02-23_03,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 phishscore=0 malwarescore=0
 spamscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2602130000
 definitions=main-2602230204
X-Authority-Analysis: v=2.4 cv=GrlPO01C c=1 sm=1 tr=0 ts=699ce26f cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=HzLeVaNsDn8A:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=Mpw57Om8IfrbqaoTuvik:22
 a=GgsMoib0sEa3-_RKJdDe:22 a=VwQbUJbxAAAA:8 a=yPCof4ZbAAAA:8
 a=NVNeSgdTw4A7TOf7lyQA:9
X-Proofpoint-ORIG-GUID: AsDr4dEY5tuT89QcuypmDWAP4OU2N1sy
X-Proofpoint-GUID: AsDr4dEY5tuT89QcuypmDWAP4OU2N1sy
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwMjIzMDIwNCBTYWx0ZWRfX8nNHsMQ+sh+9
 01VGNGfxsRqGHBDMRDI0C+1zK+liRAItswzSCR5G/n6oXBfgaz7rbDpbuUqxHuK/NEh+U5tiDva
 X8UhbxkcKsYM++CJ0YmvqWUUr6QrV7UMSym9Vcr1xQEM5vwZh4nEhLKPDlSYGaeMVsE0iNjAC5I
 TXdMlHMyVqtPRGNfOJuo3CP5+mZS0dYX6G7BYpCmYQjVtLp2FQPK3sgPLDCAK2hEgAfWDj3w8h6
 Z39XsJBoarv0a3zM1I2cfjRtc7d9sVOQb+C913FSUeKwRRks9/KXxqm9lCOKsK3+H9q3cP1SXI8
 FFy/IAmS0PwRF4fleSxSsEgkDFidDpky5kBowNSkUF9DuSSHsnCVpv5OUKM5eX9w9dwGRluuDsT
 asGxhOK4zp/8+j/YfS8akuI5S95u6/KIer/oqVr1RzylMkqH0xN5a/u3wbEreD+zOVO6ZfIQ5Rx
 /uGijOk+kBhqMFr4kww==

This leaking will cause hung when tearing down the scsi host.
This is an example with iscsi, iscsid hung with the following
call trace after this kernel log.

[130120.652718] scsi_alloc_sdev: Allocation failure during SCSI scanning, some SCSI devices might not be configured

PID: 2528     TASK: ffff9d0408974e00  CPU: 3    COMMAND: "iscsid"
 #0 [ffffb5b9c134b9e0] __schedule at ffffffff860657d4
 #1 [ffffb5b9c134ba28] schedule at ffffffff86065c6f
 #2 [ffffb5b9c134ba40] schedule_timeout at ffffffff86069fb0
 #3 [ffffb5b9c134bab0] __wait_for_common at ffffffff8606674f
 #4 [ffffb5b9c134bb10] scsi_remove_host at ffffffff85bfe84b
 #5 [ffffb5b9c134bb30] iscsi_sw_tcp_session_destroy at ffffffffc03031c4 [iscsi_tcp]
 #6 [ffffb5b9c134bb48] iscsi_if_recv_msg at ffffffffc0292692 [scsi_transport_iscsi]
 #7 [ffffb5b9c134bb98] iscsi_if_rx at ffffffffc02929c2 [scsi_transport_iscsi]
 #8 [ffffb5b9c134bbf0] netlink_unicast at ffffffff85e551d6
 #9 [ffffb5b9c134bc38] netlink_sendmsg at ffffffff85e554ef

Fixes: 8fe4ce5836e9 ("scsi: core: Fix a use-after-free")
Cc: stable@vger.kernel.org
Signed-off-by: Junxiao Bi <junxiao.bi@oracle.com>
---
 drivers/scsi/scsi_scan.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
index 7acbfcfc2172..c64ef71633d8 100644
--- a/drivers/scsi/scsi_scan.c
+++ b/drivers/scsi/scsi_scan.c
@@ -361,6 +361,7 @@ static struct scsi_device *scsi_alloc_sdev(struct scsi_target *starget,
 	 * since we use this queue depth most of times.
 	 */
 	if (scsi_realloc_sdev_budget_map(sdev, depth)) {
+		kref_put(&sdev->host->tagset_refcnt, scsi_mq_free_tags);
 		put_device(&starget->dev);
 		kfree(sdev);
 		goto out;
-- 
2.50.1 (Apple Git-155)

