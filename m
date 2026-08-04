Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9146B3AE6E6
	for <linux-scsi@vger.kernel.org>; Tue,  4 Aug 2026 11:16:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842195; cv=fail; b=OUnqiIKNU8A8vCJWHKXT4SC4eqv9vSztiI3rFCTQOmDSx4kd3G+np2QuXfud+FU5RiXi2dTRK5rP65K++/rMvmKPtaCo+ac3s9J+aPZ/rxBo8ubGoRXmyslxeWZD7cKLrXM+WvU6itgGvYLORtGvmZ33GlgfcJOsHTGy6sRn3HM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842195; c=relaxed/simple;
	bh=P4iuZY92ifFBKtAUisg4LtwgOmIpJVwaj9zLOAtcIYI=;
	h=From:To:Cc:Subject:Date:Message-ID:Content-Type:MIME-Version; b=NytnqGdhLUgpG0/1b5s8DAVeeioT752B0KlbNepm8e8zJZUUYo+qCW7GFv1icQj1nT+8feaOpnueSeyYOL0KgylaQ8JsvXkjMXgPzXl/TJVQhCttrGtRglhu3LR68RzDwlGGPXG+v5Pjz1hwxW8r9GUm/7YdJZY/7kwT9LKiib4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=L8dqInPA; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=am9J4H9k; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="L8dqInPA";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="am9J4H9k"
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 673KvF9x2725583;
	Tue, 4 Aug 2026 11:16:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:message-id
	:mime-version:subject:to; s=corp-2025-04-25; bh=Gp/uDp+JvTeNxZdP
	iGSOagNYcdSgRqDMwqBYm0lz+nU=; b=L8dqInPAO1VElbjS/m3VJLyHry9FO+MW
	ktKPNHdV8hDVsOv5TV96kxGHxwLghruvS5ZECj9AzDFLqZNjHUUANR8g2s5pUQw0
	wfOd94AC2JYDM+wpt2u3hMBPOaC6IutacNWRGdwwhg7IiIf9s0Y/MhWqlxQPvNus
	AtCXyLGZJXpT29E9Vum5tdfAH9ztnw98uuBgK1DCNu+cM0al+M1WwIwhzCNJnSRW
	aGrqAXrlYPNi6Ofv8c5C9gMKvI++2lnjmAV+KFWU9pXziUp9XFAalV+PB/iTMRYC
	bB6GA38AcX+ewgwJQoJFe4Y0d8vSU9q00prfwTJLG9U8iqxg1YCvFQ==
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4fs8e4wc00-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 04 Aug 2026 11:16:28 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 674BAHva015406;
	Tue, 4 Aug 2026 11:16:27 GMT
Received: from dm1pr04cu001.outbound.protection.outlook.com (mail-centralusazon11010063.outbound.protection.outlook.com [52.101.61.63])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4ftpys46yp-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
	Tue, 04 Aug 2026 11:16:27 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=b4WXUE3d9i1RTnqyOIu0a/6QxtLTs4VyevKjg+W+2b2tqyEs0oiIfXpQ98S1NZk7Iq9YoEGFVxoDW4Y0hR63F69FyEcSB9ZdNjQygcdx9jkO/4RQzX0WwyYonjmiOUg3c4/+VGLCdqFCxccxMr86xbow2NB1Ceb/ViTsHABl+Cwm/ohthvKH1xRpa51tUF/zVCilHGYf+3YHs+U13M2Ethjr3z3Xpjjv913DozpUtBNtJS2R3N0vd3c79BRbz4pG8/d5o5SIg1XH4WGyS0L9Oh86XsgNJ0KNaQCU36hP0KN7GtEIaomnYek9pT1K07Q6+ZQTDOwEBLqQK5EDkzZBIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Gp/uDp+JvTeNxZdPiGSOagNYcdSgRqDMwqBYm0lz+nU=;
 b=wQnJoJIAkuCTL7bpAl467kBob+9i6eo6I5X4fYrv5nuZHyEKRilYH4hjrLIZiDqKuC9w+a+Df3/RcwI1ik7swBKuBJ+ESitare0yp/YH9XPmBcFAJbv4JDIxt3F57I9EAF4Puh4PnRWQ+H2Tb6X5c3Ui+UjKzUm0EDFakalxv0x+ylz5G1kduNhLBrpE4gZ0wui5vifsaOX28A59iOhDv9zt702shZFtxKHb1tVctv9K+SIXbHYf0bdJKP121/XWtHmTY4LIH3xiSyUvJs84ft4pFe0BASz16KiECup1RCMp/E2+QxfAy6l9bLO9qcmamWoSng2uGOqTlWInrI4qGw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Gp/uDp+JvTeNxZdPiGSOagNYcdSgRqDMwqBYm0lz+nU=;
 b=am9J4H9knilmh79fjygRIXg5W//ZC8Rk6YSCmKOPlTA+GnOvL79iHdqt5V3RipH2aBG2KLXBiZZAqENXc6XU2WOCwnEDDJlU8gi3GCGoGnbK8v5V55CNtAAZMDHSzvOVFisAbG+4SuA8Tis2UfUu6zPWcRUMZuQZnkVIkO+NMio=
Received: from DM4PR10MB6229.namprd10.prod.outlook.com (2603:10b6:8:8c::12) by
 DS0PR10MB997650.namprd10.prod.outlook.com (2603:10b6:8:313::5) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.21.270.18; Tue, 4 Aug 2026 11:16:25 +0000
Received: from DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d]) by DM4PR10MB6229.namprd10.prod.outlook.com
 ([fe80::867:63e7:13fa:fa7d%6]) with mapi id 15.21.0270.016; Tue, 4 Aug 2026
 11:16:25 +0000
From: John Garry <john.g.garry@oracle.com>
To: James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com,
        hare@suse.com
Cc: linux-scsi@vger.kernel.org, John Garry <john.garry@linux.dev>,
        John Garry <john.g.garry@oracle.com>
Subject: [PATCH] scsi: alua: Use access state macros
Date: Tue,  4 Aug 2026 11:16:15 +0000
Message-ID: <20260804111615.2368927-1-john.g.garry@oracle.com>
X-Mailer: git-send-email 2.43.7
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: PH5P220CA0006.NAMP220.PROD.OUTLOOK.COM
 (2603:10b6:510:34a::7) To DM4PR10MB6229.namprd10.prod.outlook.com
 (2603:10b6:8:8c::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM4PR10MB6229:EE_|DS0PR10MB997650:EE_
X-MS-Office365-Filtering-Correlation-Id: edf35731-bb05-4fcc-3d0a-08def219d268
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|1800799024|376014|23010399003|10067099003|56012099006|18002099003;
X-Microsoft-Antispam-Message-Info:
	0fIjVhRgnJ721aXZn2FX23z1LlS0SjDqDdvZm+nbDxb0fntuEVMSrp+P9zf4KP/cjuX92ey0V7O7Fqyj16VCmYu/McmEMTAO0cE94/8fUn0lCs4wRojYKVMwXaJOevr5ZN9EJD05kMKpFZd2KGvZwkWuQkxirqHlkZ2ypnPUXe5zL78wtzPKwTtbCfP3OC9oWtSNIQt859D9ZnEsl7dbbwoRYgDIEDT6zaEuY2ddmrYwPYMfenVyrmGdOcaHefDj66xRzAyM7EJhb+pUkxwshq45z1C2cMKLGHdBlRSLtUhcS/ujphsi3PzA9ZcTtymRfkSHMYuokvq1c30NvGM2yIY/XuGoeO0DIhWueqL2LXQAFxQgH/KHia0nVqd5x1DlDRF55mb+4HjbsHfoPHN840zpiPXGfSgS9uHIH5Hp90ZjeA0Z6sHqQ6ZPBvfhScaTecQ1aFIaEjRUgVC8CAtdcIIYl/z3paupbdEySh6sCCnDwKHtC6Nh321N4chuEw7lIvj7VrpPCsI7n8pWlyUHHyebJxYQcwXDSIdiO9oBHxOrz9C4FUctpNI3D2x64tNT0MQgTZUQ+ddN2xT1B4IXFALDVr5fxOBhwhcpUTM35Js3KNBfire1LdjS5cbhzoHzeZxC9pRY7vHtMcCjOz+9+rJ4Sgh2yHyabFq3hK+z7V8=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM4PR10MB6229.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014)(23010399003)(10067099003)(56012099006)(18002099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?2rfD+W5rq9TWAJsh4PfnNG5LNWfynlmDNeL4SJkJueZg/xpii0rvUd132BaV?=
 =?us-ascii?Q?bg4OJyJna8dO0dyNL7g0MfkNbwiMqkEOukLaU5gHNB1gHBWltDGCaVShAo7g?=
 =?us-ascii?Q?29r1tPZwF4LtIc3NMNFqhD0DWdpF9U0zMjhO/fzCMR6ca6Tqg3bLTXpcNMSC?=
 =?us-ascii?Q?8lJluhS7dl0OoAX8wVz4JnWWuT7bEAYssSH/3CVLFk5IIVy9L+SyubUpYfGV?=
 =?us-ascii?Q?7C0ZFFIqpS1RF+7OMxo9ll2JI6Idcc3YKxWpQPTMi3iky/ZzvKCWIEAJXPNf?=
 =?us-ascii?Q?wAi0K881zB6Jm9aqkcKyVZ40COSUoBTULd7RqKjl/+8Tr5YrQx8nFD6HVI3x?=
 =?us-ascii?Q?Vhdt2mSRiTCRlXTT4m8PTQLGfxPi7Ql5brxqR6tB6aNvvRkK+rn03EbrgZUr?=
 =?us-ascii?Q?GmYa/QXxkRsJr0Bl/+A/hql+60kvAWXWRuR8CNHJ23rFWs9GzXGkujQ8s8UY?=
 =?us-ascii?Q?0CQc0D0PHQ3Pv+E/7EJdsmp9xrQEwhcPJua7hJ32qYgz6U9uQ5+v7APUnaXX?=
 =?us-ascii?Q?ukh4v9if5VHzdAr1fHYidwX1M1g7lZvylk8VLe0p3SVoneAsD6kuASpWt3Ar?=
 =?us-ascii?Q?itHmwhHnPyDdJewwpzz8Ns0kAcPgEHG7LLqNZ0IivedoJr8sqjgxtf2Dshqa?=
 =?us-ascii?Q?Tv7ON35G57s0taeahzlbcUUyWzbHb/sJRzYAsixfa0to3Z5aoGRcCAELirEt?=
 =?us-ascii?Q?JoeGgfBhMFjRbjzxHfKrbiNGoIOHrlbSmn9RfCIlvLikX96K9DF3VJRsh02Z?=
 =?us-ascii?Q?khVesEBjpcZmsvPkd5lp3evH7UPBFV108XS5KSnE8SSx3yi6N9+yM7AqXKwO?=
 =?us-ascii?Q?CsXYne9+2lXnn6zyxx720kYgX/vpsg7ngWm45XA+i1zFeTtU+kWclpQvFcFu?=
 =?us-ascii?Q?ZAVTkxIQWOclGR82QulNzUblkuL0oD9N3TTwLTDEwWuzsoxCINlEc9c98hdv?=
 =?us-ascii?Q?mloylSd+ePTekJRhxFYESeUfEfeT0fEVt4U1amx/mS/at0kMlpsvuMALquI0?=
 =?us-ascii?Q?9o2sRrL1ELiI3WG4Kd0Lecn2vOw6JWcCiZftHXKcjdLHowH/D4X2OBL/U7LY?=
 =?us-ascii?Q?l3SrDvTKaNPnoQTwBvDXc1fIc/4ng+ONT6L6I/cpGzlHW5M4SQaeA4AO42a0?=
 =?us-ascii?Q?RCFI/PXDA7WY64czoha0Td4KvKsFJfd/uFgNNGbW37X5bdRaGmdkJtY0IJb/?=
 =?us-ascii?Q?t0YdLO+8bzHsVJWZXPu8xwSkRpIKFUjm1ig/KUw24IFzo8SFjSTCzNUIy9j8?=
 =?us-ascii?Q?a1P32qcHx6X5KzuM9kfkNrmB2JMMMfs1h3i5rkjiOs52daMcdMb7V2mwvjr4?=
 =?us-ascii?Q?uh612OvgZXgE+FWa9yVANrM/fFzKr6SdLOap4X9THyJujnHY3OYkwFGODJCj?=
 =?us-ascii?Q?jxGRmIFsOGU7fMSaNQgeJXnCQPp94ocHms1yr4lQKUaAEZlsJf1UCroxk0X5?=
 =?us-ascii?Q?EMYy73CXyhM+yVpu9E+BOOZBD+VaGj4N2YkPDfJBjb0THVTDrODMT9XG1LdM?=
 =?us-ascii?Q?MEbXXzg91jm0dfdoK2k5MEYvCNw9dc5I2tQOP7qD/Tf+SqH3PtMeR7ZKKcxD?=
 =?us-ascii?Q?W/Su7IOH+0RYCAjLlRK5nopYFP4J7N0UUn/ID6i60A071tSg0AFIQhXMG5WS?=
 =?us-ascii?Q?v7nUD4J1Ccbs3s8HwG9rjIrRHZCAAJm7nK2VpxGuVGiKDmgapThIFEVMsFgx?=
 =?us-ascii?Q?U/Np13TF64x4DIwGcLt/Rc7cjOwLJsQMrm4tg/Sql7gTBwo3mOohAFfMxG11?=
 =?us-ascii?Q?px+z2LZDgQ=3D=3D?=
X-Exchange-RoutingPolicyChecked:
	c8aoPlvd+8UfEnTUdYFOMpniHVc8auAa2M48bX49BEtKNRppNtCYXU/iBc+xnwwiDZSqms1AKSV0XqjNJeGOHSZkk3s1olURWDwCd5domZ+uxjig5SZHwIDZ7LvjxXhlCUipiJXqge4xxH6ZPh/pKXOXCmljh0af3xQ0Xv++2DfB3A5g9ncYiri4MMyt77nsYf7yAf7Q6KicRWdO7wkydtS5PS/h1whkdaJbQWdBf/o+y/ulmO4kkAtnXZX3JGAHlKd43rk4BgLTtTR3zz2A6oQisyKVOu8DtMwkrd3UXWEBUSf0vp3GLiOkJOBly7ma9XZjq6xctKwUAWTRNl/eDg==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	QhkErLBhWy4j2CfZxC/XtiUPjHApLwsPRJgDHf4xUyvP8nrG/3UFIJ3h6EtjBQhEKz8kt9VoyyPTcrDvdRL/02cVYvfXDRWhU+RTOn3ZNcOi7UjkKE4GdB6TIuQ1SQ8iZvBKAWScargMEfr46HYJyztLXwZurGvxPXmWyL3Y1iIF94JxdSVg8OZShKve5gPsXvyfA/K6YwbXS768fHyoYpot42zqT/hlQrZFS038gV+Dmao3mXjOoX1MaGwooSR8oZIYNPGKv7y6ZC9ctW7mb35cwt3N1YO6aWxo0lsoXLDj0F5QoVMBwhxSE88dh303FIo3ynJ4rUlUS1bzPyRBqDCBAHFswbKssUj6sDT+CBUsuRVAIfotI4sW+tTUxqRwEKdf+puEn7LRKcs/C7R5aHrey5ESUi2l4NyyRwU/Q2xTf2VLeHXT/Mim4ZfkCwHw0T8Z1UwObQpOqWpIXgkHnsDOmHwPVVcG45Hw2o4r++ymsuzz6c/BPod0+MSMnJxURaDhmGC5hWMZHvQVRem1i+WF3TjX5BsUjyypi7BLE+8eqsSsKfDihts/1Vc4fa3zE6BP8TXbG7F17Rp6kmZT8o2y7eZ7ZCyuIFTfYhGiYL4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: edf35731-bb05-4fcc-3d0a-08def219d268
X-MS-Exchange-CrossTenant-AuthSource: DM4PR10MB6229.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Aug 2026 11:16:25.2797
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: EnKotGlhHb8KfvQ0TZld3ZrzWoax89CIvPrAQlf4IiZq3D2CSj7M5nt/yjNMH6YYACIcfyP+kiqZK8hkUyrJOA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB997650
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1176,Hydra:6.1.134,FMLib:17.12.100.49
 definitions=2026-08-04_02,2026-08-03_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 mlxscore=0 suspectscore=0 adultscore=0 bulkscore=0 malwarescore=0
 phishscore=0 lowpriorityscore=0 mlxlogscore=999 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2606160000 definitions=main-2608040089
X-Proofpoint-ORIG-GUID: sln5HlAwlo8aZYz6he1mOCwD8F-i89W1
X-Proofpoint-Spam-Info: AW1haW4tMjYwODA0MDA4OSBTYWx0ZWRfX8d97D0Px6EYd
 gOLT9JBxV/B1EWWl3d/zOWkYzkmhGng6tgxeJwuUhRSW5SXR520ZAwKjZviYJl6SzcPFp4+9Yyv
 rXbosG19GKcVgcTjQZ7JeeDdUEox49kIDPghuSKBEeFX+MjrEGi3
X-Proofpoint-GUID: sln5HlAwlo8aZYz6he1mOCwD8F-i89W1
X-Authority-Analysis: v=2.4 cv=M/t97Sws c=1 sm=1 tr=0 ts=6a71ca0c cx=c_pps
 a=OOZaFjgC48PWsiFpTAqLcw==:117 a=OOZaFjgC48PWsiFpTAqLcw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=Sv0fKeRqtYgA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=3I1J8UUJPc9JN9BFgKH3:22 a=yPCof4ZbAAAA:8 a=G8YVpt9ppSg48nuIj5kA:9
 a=zZCYzV9kfG8A:10
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwODA0MDA4OSBTYWx0ZWRfX6n685x1dLv5D
 FICb+IzGI9mpxjSkHCG174HKLd3CAC14uE+GFy2L5XN++3OhZCZ8Plo15ZKmGWIv46SINRmELCX
 UPmoYjETQPi4Ip8lwQ06Jcza6yTT+aESYYslPglpR7tYrg2f+rIrAxsNSz7rq6xfy3vcASgln6P
 ZxA95X5XedPhhGtUJBQw9LoI0BzSuT6PVRfO9Jap2NY4Ty6cbKghaqhtyyEDu5x/QWgCdceNiAn
 gyfhv8risgROlJCoiePSz6Eg5BsuL4v/lL6wFRlbhRo0s8IybhhQaq2UYhswWoF5pFRMaEs9K/p
 HmO699DZjKs9ISQyrd5BzI8Ugzo+3bPtYvNlCbXQbMhxAK3ZiaRllR4xAKqH6eTbWX9sCUO5bJz
 7wm7gFwUyFClWfNhLHo8iWe6w1UPoOYOI82ixT1hFaGkuncJiC1RvA7Alb4fsywqowNSRs7j9Vd
 WkYGZj9U1wXm2ZLPQXw==

From: John Garry <john.garry@linux.dev>

Use the SCSI access state macros in alua_rtpg(), which is better than
hardcoding.

Signed-off-by: John Garry <john.g.garry@oracle.com>

diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
index 80ab0ff921d43..4258c48d93339 100644
--- a/drivers/scsi/device_handler/scsi_dh_alua.c
+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
@@ -693,8 +693,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
 				    !(tmp_pg->flags & ALUA_PG_RUNNING)) {
 					struct alua_dh_data *h;
 
-					tmp_pg->state = desc[0] & 0x0f;
-					tmp_pg->pref = desc[0] >> 7;
+					tmp_pg->state = desc[0] & SCSI_ACCESS_STATE_MASK;
+					tmp_pg->pref = desc[0] >> __fls(SCSI_ACCESS_STATE_PREFERRED);
 					rcu_read_lock();
 					list_for_each_entry_rcu(h,
 						&tmp_pg->dh_list, node) {
-- 
2.43.7

