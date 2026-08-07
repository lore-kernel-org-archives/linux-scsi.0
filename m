Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF2D63A7591
	for <linux-scsi@vger.kernel.org>; Fri,  7 Aug 2026 14:39:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786113575; cv=fail; b=OAZSpxeUjBVgU3WWr/rS7QQHxkp3UDF6oDrZkNYKXtByEwTK68+vDW4GAJnnXwN23Y0IOepk6/6x/X2hOl3MhdXapVt3wBJQhq/y+rqoj4lgpNO4j5tevtuNs7oRU8Cfq0/PXwxHYA7D1IhD4pFAG/5yCeZMlhd0hjbm8g8bIdY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786113575; c=relaxed/simple;
	bh=ZRNCeX19AnPg66FIbgs9qabDJ39P75pEzr7nalI7oy4=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=uVWkmbAFrCVEHpJKw6dK0eVD4lHRcvhtx/rOfVmaKIvJtcXaKQhNv4+WhHFmE1i3RhMFVy8r1Mt9YVREvDE1v21h27U+HxWa1TZ5mP+sU5ccMimQT1uq+mlIQhgjIDc97r/txbH7xiFL6QkcigBy2i2faouwfesGTYPQZ0SB0zg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=FZj+LW29; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=BDnN2NjQ; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="FZj+LW29";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="BDnN2NjQ"
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 677D1SiX1047677;
	Fri, 7 Aug 2026 14:39:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=98jQKzOECtooAItSwx
	P2AvIgLRjxIgOdcRjBlQDnBIc=; b=FZj+LW29RlGMsdOFXg5ebevIj/KFy783Hw
	npE80+jYeQ7bmpVoHEkyGY1LUWg5Qrk98R9emrkGaiLPMegvvlbVxYg/nQ6n7uIg
	p0gA9VFIuazSiXPISinIwinPXEIePOg/6CaYYooWrjfLCmmjzLd3i25trikmj5Kr
	z6tkEuyQe0YaDC3QzKA9o/stRpLNKagKePE9ZOCpUM3bFL7E97GM0hJMUAHUDOgJ
	ohKAGC2htV/aNmwBd2/2/XYTeO7FOItjpRi7OK2HlYph3veemRZ9YxlXbo1ek6ga
	coKfB9g76vB9NVk0qT5UwkuWR0AijllhZPmosIgB6ZcIQUkjs9xw==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs7k3qxhu-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 07 Aug 2026 14:39:22 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 677EUB2W010029;
	Fri, 7 Aug 2026 14:39:21 GMT
Received: from ch5pr02cu005.outbound.protection.outlook.com (mail-northcentralusazon11012045.outbound.protection.outlook.com [40.107.200.45])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftq45pm2d-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Fri, 07 Aug 2026 14:39:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=oM8HKa9OsgvjY+2LeOcDoBJXoghkRiSngEIFN+Tgk/uJtCXwhP7GktKUA0WC4HtALF07lmpQzuiH7y7+1zG8zyxH7229XUs97O3ltVK+tVGfEQ+LUjl2aIoAZZ4E4vQYWL4v1B6EktMUjUreVApDNdo5eSNQHY5LNhPCrwv3wU9jTssdy7o50YcImW/IQZT6kyYBbttLzOyJpFZBmb0aTmDWOe6PKEdwwHjBOf9oS2PB1rq4HBo9AGWMcWC20l8TDrMjBE6/lzhmLHqH7u5iBIX6y6AFEdN2ZYCJDuFAbpxn9XwJeWo4FEUruTiDVID8anqLUyvB2EbuxMO3VPNUVg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=98jQKzOECtooAItSwxP2AvIgLRjxIgOdcRjBlQDnBIc=;
 b=H6pWVlCk+phFNVFJzQD2FiLEsF2OqXLsSYD3PrXBojBN5JdNx53pe6nK3S4i1Mspf3Vy09DLUhJyK7h+PJ1E24FvBNdKUGdUM1Aaevzaqh3sGAOQnp/5qXVojarNsSvpUlORYqE4Y0d0FjiWLPMUNIp/A9UoUVMhB0PUrSMS/wv1lyigkbJSRndH136xykexuhTfRDlyXpIYi5X2AQi9JqXvEQnDiu81gcPUV0pJBbFFbKfRbs0nLUSThoaU6ZvAQEkvwIqU7HHaK3BYZ1rC2LNGUeN3T0AR7GEPgPqN9fFBUt2/paOZQ17uP6cUymcIH/yX7w+wQlyj3deQERNRww==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=98jQKzOECtooAItSwxP2AvIgLRjxIgOdcRjBlQDnBIc=;
 b=BDnN2NjQeHegw3p9heGZvMgY3MjPD4Fn1/DmCZgS055VZ25NThuudgLglRr4OwlLQfJrp9ZF7s2FYW7jIuw+Oz4/vCydbrZPWzr/FHeu7RBFXFmkfgJUd6Vm1aY305Zbya9IVubAqFsNaPAsbs30gEyCW84FCudCEOuBLyQxR+k=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by SN7PR10MB6332.namprd10.prod.outlook.com (2603:10b6:806:270::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.21.292.23; Fri, 7 Aug
 2026 14:39:11 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.21.0292.019; Fri, 7 Aug 2026
 14:39:11 +0000
To: Nilesh Javali <njavali@marvell.com>
Cc: <martin.petersen@oracle.com>, <linux-scsi@vger.kernel.org>,
        <GR-FC-Storage-Upstream@marvell.com>, <agurumurthy@marvell.com>,
        <emilne@redhat.com>, <jmeneghi@redhat.com>, <hare@suse.com>
Subject: Re: [PATCH v6 00/56] scsi: qla2xxx: Add QLA29xx series adapter support
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260723050413.3897522-1-njavali@marvell.com> (Nilesh Javali's
	message of "Thu, 23 Jul 2026 10:33:17 +0530")
Message-ID: <yq1ldai3shz.fsf@ca-mkp.ca.oracle.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
Date: Fri, 07 Aug 2026 10:39:09 -0400
Content-Type: text/plain
X-ClientProxiedBy: YT3PR01CA0044.CANPRD01.PROD.OUTLOOK.COM
 (2603:10b6:b01:82::29) To CH0PR10MB5338.namprd10.prod.outlook.com
 (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|SN7PR10MB6332:EE_
X-MS-Office365-Filtering-Correlation-Id: 22e3fd64-3478-42fb-e64b-08def491a4de
X-LD-Processed: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
 BCL:0;ARA:13230040|1800799024|366016|376014|23010399003|56012099006|22082099003|18002099003|10067099003;
X-Microsoft-Antispam-Message-Info:
 Xuks/D+VuZRCebYYRoMLQv/+Kd+9I7MpgmSVloHvLINhBCP9NU5GrBQPUzSghouci0WttGMoOgAR+qHzjiAmDLjZ7GIbJ7o05zTgYgGYBOChe1+/nSmrg8RReBfonNy5N7g9XsWSBnVGuqTlga5eumKmY4R7qqN2b4hIy7czE0WXfKAZvv2b9zaBOe7mhWCWzDGO6Rx+jUIxZi3IJXFBthm6WiikumcKcgJJZNzKpc83xv8vxkbQx6K2Shjvf2ukGOCkh+wzk9LmTDsMU/hKvBc0S5j7Y0bulBbe7MBFj//16A9/+bdtRB7UIhqSxEXUGaXzEUzc7Z6iBhGoQPMfbThDAzPpuY9WQ9yg7e0UJlJ688VjGbK7qj7rdTwrBWHr7KyXKmqEdUomK3M7ve8HnMMTXq/NHvr6ry1A1SpmLIZDRVhxhLT2yWmyF6qnWBu34vXCeruBrc5a+SkxM5ftXl6ChoaC6PimGjREv8U+A21Ve1k0Z8jh37ZYsWs3P+MABfNQXJfPdPxo5A2kDASotdb9YM61gRCNTmRu3w87vOY1lpT0XD52uVSQqXzxMgcaq46lfGjhLsZtdFnuGNGJB6VHUVl7BRNS6W5OSw2D+I4RV+gZeVQxBBzNyX+kOV/CNylOLBvXxba/LSd4RQH0N4Jufb+XIj/quz6TSEasaw8=
X-Forefront-Antispam-Report:
 CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(1800799024)(366016)(376014)(23010399003)(56012099006)(22082099003)(18002099003)(10067099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
 =?us-ascii?Q?3IUBNhwYqSQb/2N78ymEdWbZ61A2n8HRfHXGQgb0C79HsbtlZJCO2GTEnt0p?=
 =?us-ascii?Q?xEKd/ql6kpe+3s4gLr7nLpzRrFPDsZDi8wJ/AI1KPlo/Z9YicrLbqJ/qz/rD?=
 =?us-ascii?Q?JOfcQ0oCbdtpv6gfSbxRUHjxPokzfuK21I5swWCxUAsBzXsy8O59IF2aiwLO?=
 =?us-ascii?Q?e2VTJVk8ym+sNWovdCN+go6p7yDifNONp619xnvXhg81khcCSw/Gh8LEXNtK?=
 =?us-ascii?Q?wxtCJElKJVWVwJug4XVCmKdH9W9tOumIAibj/je44LQUQQpDjYRztmyorrsM?=
 =?us-ascii?Q?PVGECtsuqlBv8utYEe0wJjwUssiOuj7gtr5724OBXVsdaHjiSNB0/Xn7X0hA?=
 =?us-ascii?Q?U4L20yvz826BHAbNlDmrlJwGnRp/iZI0adfmEfXKuyITGO53eRqwQS4HTEDN?=
 =?us-ascii?Q?6gPxDPFX5+US0DnmBC8UkY2vG36thCLInWs5QNuPTFPyZk8LkN2zJtrbQJkQ?=
 =?us-ascii?Q?164wM6OszeoFTrHQLdKdhtDKhAjkDqFKv+sfn6jMaAzntdV842vIYgsdUQST?=
 =?us-ascii?Q?WCBhUZIx1FIQpKdn9xZQboJYn7zrTVSlv/KcjgDkTpqU4xberMZ20US02Vvo?=
 =?us-ascii?Q?Bw3I6tzB6Cnhk5X6Di2ZHTRzlBBeuXxwLlSfo0GzZz46IXrnHgepUs/xin8O?=
 =?us-ascii?Q?nF80dY+cD7Gkf4OB/xVWRDjanid+7Msom8TgLfmHgzQQx3hSTfHL+yW7TraM?=
 =?us-ascii?Q?xOFXagcN/HjM/jiy4Jx89vE0oJkxolk0+YEFffYBw2VtSHKzFgLMsuoOsfs5?=
 =?us-ascii?Q?H//cGhfdiuqpbiOn1xVWTt+4pi6XPfJsJfbcj6z8sOGIFrEAEsiOizjvXbr7?=
 =?us-ascii?Q?z8vmbETA1vmxhRP5fsV1KFfL6HPtuSZtycRVZ+uqJL9BbztaKzlcJ9lt2wEc?=
 =?us-ascii?Q?MHxTGw2SJi6uw47Zk2cPKO35wWQNm2ygLMqbeBU+uGE45ZuKYngl3rFMlEi9?=
 =?us-ascii?Q?rEpc5pSzzmCC8ggQoxaUzEL9OA2reBXNmSCjCaUxxxy+VpWlGPE/8gc5RQO0?=
 =?us-ascii?Q?oSuQLUv8GXEYkPatuSsif2XtJ7DmAlL/w4fSfNQkChkdPclZsK/8oVNVn40I?=
 =?us-ascii?Q?EUuoXtXFQmxIetcrsc5zZKan73+KdaccQbFCEPZasuXizv4Ibi8bDuigi8eO?=
 =?us-ascii?Q?YCFHIvWwfuYpqcgVlq97Mj46BRSsHST8fwxpax5IPckF37OkrCb1ih0KbMp4?=
 =?us-ascii?Q?papOyfjcd5YufS7ZQiNys+vHygWyRHw1GlpDQg0PBpo8VuROFleEaqb7fAMD?=
 =?us-ascii?Q?Ak+23mKERdLPlQ79OgvPOU3nmZv0O/oWKCN32KyeFDf9l/1fLUyerXFhK2Tz?=
 =?us-ascii?Q?5q3po9y3SHTBMmoaXraOdARp0rSapgQoLnQ2Pfo5tEVqYnWf1P4344l5zw+/?=
 =?us-ascii?Q?tWxH5yFozFrnvp+ZExG5ECPlJ3fkLdMixKRA+Kk4vl5e35P2vqSOKKLWvBvJ?=
 =?us-ascii?Q?83MxvSOvW5+ydm/9eSO8giLXf6nfO2qyYEvvTtO1pSTMV4cZBHhxulFxEaL+?=
 =?us-ascii?Q?tplGAAZO9XVGLXjPt05J6jZ1ombItPk4XlyCWt93S8sHTibcM3s/z1S/cBtg?=
 =?us-ascii?Q?imlsKs2pkVCA5FuKQWPD3ZBFlQ142R+Sc4kOiqgaFjypXl4v1ZxohoLbG8fZ?=
 =?us-ascii?Q?2nlzH8QdJ+hTs8M4GALOZvMYI8XvHQIxsZtXjwsQCrOcl5rGP2hebrhYjPph?=
 =?us-ascii?Q?Xt43JASnxHYUmq6wq586zuPXTRkfA36erArPVRhTXtswNCuwg1d85KLs6j0h?=
 =?us-ascii?Q?1O+qt+Hf22ZpCx1IPJLJpnu6ppR1CvA=3D?=
X-Exchange-RoutingPolicyChecked:
	oO3tkVpIJ27s3pEBLIHdYZsDxsYg5xiFwIAMr1Werifqlwapf0ZWVe8BhcJshwkfFLmar9XR09CRlBcO8DBIH/Rhjw6ckK2zJ9h/GsQJmK2Ci1LPEoiN0acV3WgMV4jYNTQziCQefLOmdmpIY0nhcCF0kKDJii2a9zu6hqkL967u1KowpPLb7K4m3gcingkDg0KE0eCGMeT75HqrGP7qzIFfLk0lRE1u69z0raVnHRMTii9aePvMX+6Gr4UJTMFfwAbKgEaaKiO7Sjqy+s5ryr83Ei2/X5SYwJUF/StBQcbPgqvdMgPiV4Ma72ErDo69ROOVItEMBbi6dQj07QIi5A==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	tSVAFsAQ9V2p1MWFJsEGGqyLYoOtZALrRzAcQNJMuNZyOp+/zIqZ282KX4CMhsWKort40nqIRxcHzE0CslL2qC+5jfXruljUPxOA/WHbl/vKqKFi4t+CS/a/N5up4x410G7m4pVkAWCjBIdA/2CTo5+cM9TTYZCvAq/zyMsjVBJQwjQbyVkuM9iXmqQBHGgAuDm1Jcj5WPm1wHmYvZLxR7EQoCvc0VnanumKTRFjCnhI/SkSgQVJRNqeHONtg7M0jHKOuvsxeJ1+nHQYrgOv0FVKoZTQbbDsTKedbqUR6wryGmlbHWP8t/K+pwxtxeNH5B5/VXJ0DFcefiGC6U7z2zaT/fx0eiekRDzMV6eCvs1NyCY8AZY/5XVUa+U7UCNkivZW17LgxhsiRtB3L1+JlqQmoG6fYlDq5zntMgZAcdVEPbvt5/S0QDqs03TC+KMeRFmXe9Okn02h6Urz103+xJkmlCiTy7HDJ7rWQhh7bUYrnURnWSEHqmo7Q2HbSINLyVAb7Z0N5l8BcOg1dMw3P8G/8lBg46tVjgIx0IPqw4WDDJ1EYg8/Gpn5/WAF2UbEziR9CBdhQGxFexKuwNg9xJMqrV1Yg7dFgO62KAtn9hQ=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22e3fd64-3478-42fb-e64b-08def491a4de
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2026 14:39:11.2408
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nWSl2e5MLdVr71LDXLi2I66ut/74TXiyOkXmjT+dAV5ggaCAjr3SQdpUMYDQ3VfasIF2S5GnQIR8gsWpqT7G2q2DWKR98ySxuLentTSdZVI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN7PR10MB6332
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-07_02,2026-08-06_01,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 lowpriorityscore=0 suspectscore=0 phishscore=0 malwarescore=0
 bulkscore=0 mlxlogscore=886 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.19.0-2606160000 definitions=main-2608070114
X-Proofpoint-GUID: _6eF261wbeJNUAHa7nw0WDgoM9hwmmjA
X-Proofpoint-ORIG-GUID: _6eF261wbeJNUAHa7nw0WDgoM9hwmmjA
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfX5Q5CgkE3+xwJ
 /nqb95viIpbNtc7rJFQiug622Z6MbI3G0uTckPWAh23MXAFSiDMG4M40GgQDHoY94t3+bl3Ry9L
 sSXyD+yzLSGY9+MWv5x4DD7N0d74RGwrdL9Rl9WxB8XszYXFy/ks
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA3MDExNSBTYWx0ZWRfX1xxqNghcXogA
 U2gUcgJTcc/q+OrPO5Y0RWLqQyTxKV8wBpgXE8ZXzRfpgfEfHrlQDfZ2qruo+8uHswYymwS/rh7
 vyh/JWIg1cJgASPahVfZ4IzKw3wz2LZGTpOqcxknPHPeNO8/1/1GcaxJhKW723ZsgKFA9k9St3V
 pJfOzSnnPRkB2Wl3mmCCZy7M5wOW4FiE7rhZpn++ys1WywmDFIVFLuVnLLK48qegbih46B/Ivgr
 kgMCPd/elhBPZRPveCDD8+nmOCXsmAgwqUBCqe2di9RRCzfjszejxgQ8a2sqoU0m+Une0U3AFlx
 2KhIMiTmjoVh69r5QlssGb7jkxCvaHYXpDNVgAHs+jlDm9rj5G9h8UcoFWAoRAUXbI2sRjM2S6G
 10yt25YUG97Mh1Ch6FPhy3eyl42jwo71RtmuREhy4wexI2Phbu7Pvwm8mKBBCRD8Z7rXWFBF4/B
 V9udq3kymxAROxdAPBg==
X-Authority-Analysis: v=2.4 cv=Iqcutr/g c=1 sm=1 tr=0 ts=6a75ee1a cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=o5oIOnhZENCTenyL_yNV:22 a=Pmha24cLc4MSRJ2ASOYA:9


Nilesh,

> Add support for the QLA29xx generation of Marvell QLogic Fibre Channel
> HBAs (ISP2091/ISP2291/ISP2099/ISP2299). The 29xx family shares much of
> its architecture with the existing 27xx/28xx adapters but introduces
> 128-byte request and response ring entries (up from 64 bytes),
> requiring extended IOCB definitions and updated ring management
> throughout the driver.

Applied to 7.3/scsi-staging, thanks!

-- 
Martin K. Petersen
