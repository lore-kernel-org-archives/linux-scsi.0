Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 435522DAFD7
	for <linux-scsi@vger.kernel.org>; Thu, 30 Apr 2026 16:21:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777566089; cv=fail; b=k5+POrO6mbKKM+Czl/8HGEhesSccQwbKZRkQXSuwGttwsFunfypRySDxH5XZqqVeYpruC6WjiD5lyiRqJJa0R2AdVmdvigMRWXavhGf1ytP4qG+NAB1vsDfX2C2zDkMm0zU7CP3XrbyT+7/w5imyN412ZCc8HtK1GPn6izIZCsQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777566089; c=relaxed/simple;
	bh=AlY+XbWFFNwFQXq5XxVORtQw9EN/VAyGFVL9KaYfdGw=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=iSkA6zbxZgORN24UOnV1Xp7fTVb1cVVaZ1E0+5RfMai12Q2VPNfGjDhx+0x2bj0VkJRvNVhFoMETk6kYwgIHApy4+w59Jj2YJedWwJ+hkzOcQL/TVTOthyeq4yuFqsvkd7jbswjiaHXj2EF2r9xi4V+cyDV3vLapLXRDXEaYzYY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=U5kyzVnx; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=D2u1xcRT; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="U5kyzVnx";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="D2u1xcRT"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63UCfOKj3325574;
	Thu, 30 Apr 2026 16:21:23 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-type:date:from:in-reply-to:message-id:mime-version
	:references:subject:to; s=corp-2025-04-25; bh=FR0OcGRhbPjz6yqG/H
	tIndHYMS+6gQK7rDjXKOKzhQQ=; b=U5kyzVnxOhE7f6MbjEsD0Xq1rdjc3fOqNJ
	UrSFgSIFuC0cEUXezYAd205keAdS41otEhBMreImV2xkhKhKHmsRCKC/U9rR3bkE
	hj1W1X5Pt1lgfpRSh/YVHd3Vqf4JoJX+rT0pY4mFXQAx8ii0gAPxoNxyeuk1YvXc
	Elt6BoUtRGEgMpK8vBZyJWAhAlIyc2GqQJMlcz55GeSs8bk1TfO7Kf96w1WZiSiW
	C5fwWCLP1Jack34TH0LWw1/zppTo3KcST7Q8IdosvmtYvfYLvgHdOYwNgxReq357
	HIbf1jULHGXvGkWpPh7kAR7qxDfT5XL3M8ttBtzIUQTV83m+A/cA==
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4drnnenpnm-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:21:23 +0000 (GMT)
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63UGGGAs036461;
	Thu, 30 Apr 2026 16:21:21 GMT
Received: from byapr05cu005.outbound.protection.outlook.com (mail-westusazon11010009.outbound.protection.outlook.com [52.101.85.9])
	by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 4drm2g5rdr-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Thu, 30 Apr 2026 16:21:21 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=yQ39EIbtGhuBjZ+5zR68hQ0C+9Hhjul/m4wyKFE1ODDTt3lXi9OL/5JjjS9c6m/z9nq/EXgaAJQfZJcbT1brPOm0Jw3Q14D9s8ThNOtnKwUTA0SfMJdHK10at8vUKpScUiNSuGz14dKYxMxz3fubb5Yinrf0x4ngjXIm3p0GDZ9oNmEftbYXZBCPxOFAJ/BdemP6EeqYWPO0BcmIdtw1SJ5kQtKRLzYgEt3/RCHh4OW7PmfEPqyR/19B8mJKEwWoAJYlCcP5JBzE8bX8iVNdvv/47YQ4flndl/ApKlDBR3tcn/5l8/gRpKvLafGwzGCkujVmXPZubenp8vIbL/IrWA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FR0OcGRhbPjz6yqG/HtIndHYMS+6gQK7rDjXKOKzhQQ=;
 b=WlwYo5MF6U68iH3gF2y2Ct/mLzgBd3BDDrhD+aWB5a8j6Xz14vnZJfq/TB4tK9RHqKjk8KqkX+oQz5kS3PzcWB+wBiA9EdUGJDqfkhI5HN8vl6XZIcWlgj/DnlelS8wrVLEk6gNtxqZhbCg1NTtskLr76N/4YPuaZ/IRiW60Z2Ipe8eIqTLTVRpPTO6hI2nTEn4UxR4WiSJtJlbjkUFSXBUq01Zhx4n/i5wcAm9VeRbGe3DJl4fcjsbiiyoeBKhoKpIb/UEcYXPMFkq9TQajEUwXWotC2D90V5WzliCEoKNQooWgRdyj7DeYzP+lV9i38XuD2vZI+1AsBqhJ+a64Ng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FR0OcGRhbPjz6yqG/HtIndHYMS+6gQK7rDjXKOKzhQQ=;
 b=D2u1xcRTM3An0wRQ+wdKrWgxqnHvP0ZlVX2Hc0PmqQNo+lVdo9lzYJMvjVS091upzxDvfOefKfOZepqigR+jOkV5CjEB04QSSGxc85KqwQOtdxTxLrq4GsuXs9thQrOxzHVZHdMi0aSHDQatUCz+VWuNy7+G1UzTYcaDcY2d6ug=
Received: from CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
 by CH9PR10MB997858.namprd10.prod.outlook.com (2603:10b6:610:342::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9870.20; Thu, 30 Apr
 2026 16:21:18 +0000
Received: from CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5]) by CH0PR10MB5338.namprd10.prod.outlook.com
 ([fe80::e525:dd71:b002:6ad5%6]) with mapi id 15.20.9870.020; Thu, 30 Apr 2026
 16:21:18 +0000
To: Bart Van Assche <bvanassche@acm.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] ufs-qcom: Reduce interrupt latency
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20260402171404.3008494-1-bvanassche@acm.org> (Bart Van Assche's
	message of "Thu, 2 Apr 2026 10:14:00 -0700")
Organization: Oracle Corporation
Message-ID: <yq1lde4e7yg.fsf@ca-mkp.ca.oracle.com>
References: <20260402171404.3008494-1-bvanassche@acm.org>
Date: Thu, 30 Apr 2026 12:21:16 -0400
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0072.namprd05.prod.outlook.com (2603:10b6:8:57::7)
 To CH0PR10MB5338.namprd10.prod.outlook.com (2603:10b6:610:cb::8)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CH0PR10MB5338:EE_|CH9PR10MB997858:EE_
X-MS-Office365-Filtering-Correlation-Id: 5d897e62-d201-4b91-664b-08dea6d4823a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	CU9RHcRlApPsIBDNt2c/NbvhMnyz3dkYE7NERnR+I0Ss7mdKumPU588ff6Z8ZTH1UF6bRyROIIZYidfKI1dBdll6x/gU07EVCJf5SpxOAjQqCED7L2IRdhKz5ub1VN/qDoG8FyMe7rQHyRYDOA1h9XQIuFJ8UsWNCNi7+Cw2bhfBiY8EuMwPNahmf1WCSrcTjfkN+MFXF17JO8wwCin1cBVNFy+4HAX1PgHxshwFB27TCaNpxLedKl8UwyOGZxsN+gG5MnNITGfb+Z6XuHOEb9t9tsfWZ2RbS7V0N2JP7R8kFPyuLRlXxGVX7xMom0sw+Sda/Ksymg6hqK7cmo0884gdmompb/WjxVV9qOLKO5HWwWrRaI6KvxPzjL24LuXmpPCHIV2N8SJNXcPk++uWKmaUFZhtnJTmAzl8msoLdAMHvjWE/JaHVmFh/L8VPhsrbbdzED/54T+97w+CZ5DDpzqMieobfmxcA0G9EyjVgO0v5n1nwdxqmL4afzPNFnW0Xxk2n2L3Vmp8F9grdz+JBsXbCMRmzOMVSpvosbtVam4iYHBw7DjRKSflPpCcEFRr8DYGzEXIBPRzstB+OgBO0RYlzx6BLTg0edp30jul5lnjj2vZBtRRXtmE81Qyq1ksLj3gOhwPXdJ1A7mnb9uIqhXg9/lwMify4C0dwVuyRGuavVOwmPBsoF5O3/+fRSvm
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CH0PR10MB5338.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?b8TPwT7LnoEOpDc/AaL9hwtQ8IEXuJ77INO0IPjUsHaMVigaTxi58dRJwfyH?=
 =?us-ascii?Q?aeCnfVK/9MUyOfBCX3BVqF9BPqkGPf64PMAoN5ibTY/b8JRlylv8BZkdDuZX?=
 =?us-ascii?Q?HDZAcU4xk5Cws3OUT87kaLljzZ2yDYBDPQWCfYQwKnsgFIud2HUjJ9tt+znb?=
 =?us-ascii?Q?Q7Au6fgiUR8SJj9hKnobiD59YCAr93QrPo1Hp0KGNt5ZgFJIIFCNtqc9LxzL?=
 =?us-ascii?Q?4QKlnUE3oFUs9QrtqAyFne3GGQIHo777hWj4qhyhF9Trk0Mf00eektTxQZgh?=
 =?us-ascii?Q?snspO+WMeb5KiBjJRyiHKSEhUdMzxrJ05DcYOaFHhkSpwyMEtYNm3LYtQEFn?=
 =?us-ascii?Q?Oe5fanPccGuAfBEiqGhnJTaLVzrfoulOFO70lq04ZFYpK4A9eAhvaf75aDxT?=
 =?us-ascii?Q?itppMIk/q6eGya8AbThuO3Th9no/N+lWKn+7oUDt0SHCmESnf4dtbZyvc9cT?=
 =?us-ascii?Q?oNUOCgT7cVG6i3RwQLJ7OBtjYfYbVAOIPmp8HNfIZeW2jaDmER189uqrpxiT?=
 =?us-ascii?Q?i6KVHGnmV4RqDJYNhqEQnmyp2COi9QKxLxOAqnOmUEQE8H8vQCbxYBOR+zIQ?=
 =?us-ascii?Q?KkwM1TM6gyv447Awu2RSH5xOWqG8Z32V9wTRjUcgMb7A8BayI2DKIGUxH+e5?=
 =?us-ascii?Q?QU1gRSg+jCS77YLtnhXetErJwnf2NspzGMzvmkhA5Zw28T83n08uWuOIzzAG?=
 =?us-ascii?Q?NoexTia/yePgLg0D7TxD84nIXdAuFZXkX8Yl82hIVBJJyCj+keBAvSs98iL7?=
 =?us-ascii?Q?RQQYWXjU2DQ163sA9d3tK3z3TKvntsk4QQQQs43x2cv9yiHzipZego2hNKME?=
 =?us-ascii?Q?zj4aZkdIFrVsWD5UH/WE1QJql7WPzzZdTF2DpehzGZkJm50fNfrfEIwTYFwG?=
 =?us-ascii?Q?EK36rKPTvqa2zUcjaaMQULIlcO+A7t8UpTQed5iUEDXfkU+ojj/6iV2l4F+j?=
 =?us-ascii?Q?dBJEQbvK8VEVyLqlVBCz5QWg994ZGfxr/eWWteo5VAHuwaJDFqRumiaZlWal?=
 =?us-ascii?Q?gpPxtaXGjSiivRpB9sfrpuOMjBTrHybqzxK0Mw21x/R4OG4K+0AGIOCUUGMP?=
 =?us-ascii?Q?Lt2MKlEgy8P4WRUkzS3EoYdj9CegWouEOXcoZNm7p1+r9iy/aVai08j+nxdn?=
 =?us-ascii?Q?VWiu9Qkm5w+/n+sBOXWxx/n1vcSEITLQENZkqIowKu+kDceQA5bOQ4jNzP+B?=
 =?us-ascii?Q?qn8O58fA7aemSMozdN8wlzTuXrF/NoOrsDLwYtP8QXKJB5Tk4P4I11XFEmWm?=
 =?us-ascii?Q?co10jUblvbtM/DvynjkDRnrzw46aTA26vc+4YLc/uljC8pJKub00cqobUKgw?=
 =?us-ascii?Q?QtV4jmZJAyiSae3Sl5ZR+dVdjrva+cFZ6nMrbgvP1L0Qdi36SeZirNVWJtee?=
 =?us-ascii?Q?gdHi55mFyfdBgYmKIaMAk5IeQAtyzzrTKa9BHm26gSquKHGwYoYNuKjvNfVt?=
 =?us-ascii?Q?SnLWgmuzFC5qpXxBt5LkBF60Y6PLF4g3V8tjVqvhRT/+Vq3W+l9vXqYt8c8J?=
 =?us-ascii?Q?rX1bfnBTb1Co63lpSOO8eJjj7tiX2rAjTWVAXjuJbIOaPf1YG8plIkTqbaFN?=
 =?us-ascii?Q?3cHt2J4TSNvXrIuop2PPv3ttWymaXhLZUUEgBwl2hQhj3eRg33PU5HU45f8j?=
 =?us-ascii?Q?z8PCQZCW5hTS0xkFqzAz9NkWljTKElJ16N015nVU93houEArUOFw/uT49YYj?=
 =?us-ascii?Q?DHen/P9TKiwlkiCS1Ne+vh53tqbCFGgxerEM8fhbUX1Gs+w2SSy67+WOKLz3?=
 =?us-ascii?Q?AhbWFuc1QcRjqf6RbfwAmC5K0uzEIWQ=3D?=
X-Exchange-RoutingPolicyChecked:
	hj37dZYSF3aQhC/9+aWFVt7lUG1vnEV/Fx98nsMAMyOxNTR2aLes+htdFkb0hi1O8Fxh6NtcM5JBvp5UEiuz3l35p+WpUkHYPPaQGjBixV7vbG2Yndq/4jooyOKr2/dpOUw/YPCpAVjYt+8VIJVf35bUHzol4JwLo740ZE7wfqAU9XejIuc+YKCMm9rPjq57ktKZ2mRUkhbYhFq1NeNlINqV7OWlnXN9nDTnsyMR45dL9FMDgc79ler9Pd2jwWnspqvnK2FqyhDP0V/BZF4QQJZ9D73hciQDw0zWlBdXbsFc71slnheA0G0j3o1AYtG1PCZdzJvpdJyq1jD34dcIhQ==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	/pq3UzY/Q3inQOUocyTwb2QsHistm8eW/VnfcJUPTkw+jW3tyuJdbm6shC/eOf5uDd2sR2vr7avo0NbftrrldAKSyPCISI43Xv3aKkfvKwxeibTiVA/TsX/KvHynv13zbh9FdKjNcLm+ixybH0uoBq/7GD11RstWwMczTAWbr/OKqt8I6KpNWcdUoHF7xRjReMl5iyXbUlzpKn2Q9Wb3wU54yscYHEu6+k0vte9563i9JLSwNzckeAyS1IyR81cvH7Mu7GVtHgRfnUuzU1I7AFSKlNsFyGXcu2zEm7wHrzuYddJzzBEIWeLUL63bL4NGtJXTK2Nrqja1amAIMrG4ggBmPdmHcGLfH956EDryVZXEuZq+wKSt7fENVu5b3K8LneRuyd3eQC+GPSvCvRVbI1vxSXQk4uW/K6ptl+YJTJMAbe4dSr/o9fNw8fFbkrUJadUF9YNKcObSspNplHvL02rkdDp+GeTdN/HG0IOMwMfwKu7svQH0cuUnT/FYeCsuAAj/BlBBciswASvKFofQu967KXiRBU2xBkAkoNJTRf6aT0UevJJ7vG1GcbzMzX/amcYjpGQjUIl/v8Vl3SvcCvZyfHPgL3xmcW7TRR910EA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5d897e62-d201-4b91-664b-08dea6d4823a
X-MS-Exchange-CrossTenant-AuthSource: CH0PR10MB5338.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Apr 2026 16:21:18.2868
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: H65eI5S8ixJHv7dRLAuK0Y7mEMKAdm60Jv3YPlHZ54rj1sCDv6sw7TrugOpiRXfHju79Z57A9eiUpZaNWWXQZfh50bUd75I8u/sEh6iQ0TU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH9PR10MB997858
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-30_04,2026-04-30_02,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=5 bulkscore=0
 mlxscore=5 malwarescore=0 adultscore=0 spamscore=5 suspectscore=0
 mlxlogscore=132 lowpriorityscore=0 phishscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604200000 definitions=main-2604300169
X-Proofpoint-GUID: _HP-OR3rwjRjgXdOaeJGWmwS9u3__NCx
X-Authority-Analysis: v=2.4 cv=Y6XIdBeN c=1 sm=1 tr=0 ts=69f38183 cx=c_pps
 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:117 a=XiAAW1AwiKB2Y8Wsi+sD2Q==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=c92rfblmAAAA:8 a=N54-gffFAAAA:8
 a=GdcfUtq1El8w9GW_3gsA:9 a=GvGzcOZaWPEFPQC_NcjD:22
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDMwMDE2OSBTYWx0ZWRfX0LmGW7+LBFo0
 SprmkZk0dztP1tj0CUjf/XAEv0n4ffsRnbB5T5vobwdf2bd5Fle7MYnYx8u9LP0nhx6W4jeRKA7
 RLylkOf0Yr7C8jghR0ZMOfc0H9Q9liDWJJBX/YUx5oB8qA4wA5yazLCA+d9JAVBiYid5h12fiIU
 KgE9ndDVi+cUsLkNywLksG1qu+Yqm4tmngAI6z5midMFxebF5jJWZw9dwASyq0XUFN/rLLKtKTB
 nmhiM2/k1N1QgJ+dAAkMM8Y/bYFxv82uKwL15hazYmjiBqgOi43wAnl+yGb/ozdtzo7ZVV39NXq
 o4VHY9aVnTiGg9tATikZKj2MbcaG2wQUwNPXA9aQcM9QwwqkG8ZPWwWNJMMIncGVevnSzfJMoof
 6r2km+24tZljVbb50x8AmRoj4JeqqNefP42EbDMfE1up2Q72UaaciYIYSX4FowuaRHNjcDPYp6I
 oH6WbPNTrRUe1cP3HZA==
X-Proofpoint-ORIG-GUID: _HP-OR3rwjRjgXdOaeJGWmwS9u3__NCx


Bart,

> On Android systems it is important to keep the time spent in
> interrupts short. This keeps the user interface responsive and
> prevents audio stuttering. Hence this patch series to reduce the time
> spent in the UFS interrupt handler. Please consider this patch series
> for the next merge window after test results have been shared by
> Qualcomm.

https://sashiko.dev/#/patchset/20260402171404.3008494-1-bvanassche%40acm.org

-- 
Martin K. Petersen
