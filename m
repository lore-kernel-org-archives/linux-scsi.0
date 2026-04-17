Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8FA2368974
	for <linux-scsi@vger.kernel.org>; Fri, 17 Apr 2026 23:08:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776467286; cv=fail; b=N/D6q0Pk5Amp9r8eJ8me0LtSQF99lhzejZEfbgbX2lAsRcllYlXb1MSkg/ifPRJedUya3gMvmsx8cN4CzmgtK306PVICoTi01tu17e5Ph/BFq2whLn29YTKcJUFKkiJAQrH3bdwnyBadiCoIdX6y10NHXPyWZQmTZC1c94psH3k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776467286; c=relaxed/simple;
	bh=TOiqipolI8xCU62zYE061gH3CGI91vd7F6vjVK0ralU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=XqMRomLmHyK5yU+DbwYom8DpuQS+pFF6VSsMWScRGGPXFBodHT77wMpeCSQwV9niSAxMZzlRHaTSZGgIxEq/ujPB/Xmlbf0ndo6r1pZULet4AfPX6GLEUyJy2nhrP3qnyMSYt3JQxAARkRTNpU8JnHFADVQ56bJR17EmihOp34Y=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Vqs61Xay; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=lw0YoGXA; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Vqs61Xay";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="lw0YoGXA"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.11/8.18.1.11) with ESMTP id 63HKfP0W704301;
	Fri, 17 Apr 2026 23:08:00 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=cc
	:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=
	corp-2025-04-25; bh=HLP/hyxoiPklov08SR+etva27IaGbmmIcb7KA9sg2pQ=; b=
	Vqs61XayVhGGXCMAWoIbYyuU7UVTBRx54y/GUeJseHUtTyYGTOutBAveuxX0d6DE
	XjmP6qLbw8cxtopTQNynQjs+aLLmGJk4gNB9Y0UaoeoNDRH+tIeg6OVh0OvkeeJX
	tXhF7t68px20kd2FkUTOaymfGMIBu5qyj4BYI6AQwMKg1kXYeyuB3TmuCBu39t0X
	HdJlp/lbNur+cMJWc0aPz/AHcN9Dl3L3DLWZXeQSSAz5eQCJwiE723yzo95ey+36
	gAMErh42qcuSJ/DSkwkQCbpG8eT43pq0vUySKOy3g/H3+hhgj2KtetVF7AMoRbQx
	Mn1OtOFUUkAVzX7GiP7rwA==
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 4dh867k1gs-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:08:00 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.18.1.7/8.18.1.7) with ESMTP id 63HN4SK4029884;
	Fri, 17 Apr 2026 23:07:59 GMT
Received: from cy3pr05cu001.outbound.protection.outlook.com (mail-westcentralusazon11013043.outbound.protection.outlook.com [40.93.201.43])
	by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 4dh7nrbsev-2
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Fri, 17 Apr 2026 23:07:59 +0000 (GMT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=xG4BZ3NDqGZvunH8hLRMGOmJgfqGFAA3kpULJZAmxqA7OgwTq/pJ34p8FN/Cva8Az0Jjlw5pFxa5Q8856V78oNn1/LNemjt1K99i5Buoe7t1r69OthllxfI25d859UFxBpCYG2vZlihPbfAjLP0GImiwq10cn2zdqJEPMNY6fYIH4Qm1+q/WeJ+vHmk71kY2udfcGz9X/8nnLubw2JbUmFPHAHHLUseSJ6rP2tA25Ti4ibIOR0TST2pmx4gi6At9yJ2/EBoPPdc4Mw2Y6I+DHxKXn3PpuiMkY9WnCl0umau6bBAUodjZi+e8Q+vN9BDeIJVXZRXG8Cnt4L1bHqom6Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=HLP/hyxoiPklov08SR+etva27IaGbmmIcb7KA9sg2pQ=;
 b=Awyg3cyj4x3amUOxo9bPY/tD2S6NoYDKgNgB6gAdDmppQvTTTpvP+90YBU+1+ccZkYRMB+ig+LjOA197EibpvhydlJv8FNUS8QIMwyE9MOVPi6+nx6vRues9hhvBULsOhNXzeHNedZ5nIfZYSVwQPjCNdUwoQReIUgOSZ5vp2WVbnW4jgXPy0we84uMdVElhC7YCZGE2wxs/7MMvDzwOyYz0W18Fy1QuGbqrkFT01XScGPITYWOCI/qBGShy4kfG6CgXJPkJU3SjWospwBiuP+eHGiUFgSJscuKrOq/6xRda0+rMLjngPTGEU2KkfhoGqiefW7RkC0mnxI78FcJ+9A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=HLP/hyxoiPklov08SR+etva27IaGbmmIcb7KA9sg2pQ=;
 b=lw0YoGXA3SiGwjiOZYA1Lef5AKGejzCdX4jYV0/k7MB2YiNE7JjFe6bAq95REVNywKTSJIXDT4wGR5IJKWekU8gVotfEFpuAa/XErHW9hXWrp9LKVVImbY48gI/qv9qwILPcJMFjG9Pl0a5SZj0BZQKq3h0sWUiGscYpPgPBZ5s=
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37) by MN2PR10MB4205.namprd10.prod.outlook.com
 (2603:10b6:208:1d3::9) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.9818.25; Fri, 17 Apr
 2026 23:07:57 +0000
Received: from DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c]) by DM3PPF905D77450.namprd10.prod.outlook.com
 ([fe80::4ee0:38a:f5b6:336c%3]) with mapi id 15.20.9818.023; Fri, 17 Apr 2026
 23:07:57 +0000
From: Mike Christie <michael.christie@oracle.com>
To: martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com, virtualization@lists.linux.dev,
        mst@redhat.com, pbonzini@redhat.com, stefanha@redhat.com,
        eperezma@redhat.com
Cc: Mike Christie <michael.christie@oracle.com>
Subject: [PATCH 2/4] scsi: qedi: Fix command overqueueing
Date: Fri, 17 Apr 2026 17:57:22 -0500
Message-ID: <20260417230751.117836-3-michael.christie@oracle.com>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20260417230751.117836-1-michael.christie@oracle.com>
References: <20260417230751.117836-1-michael.christie@oracle.com>
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DS7PR05CA0037.namprd05.prod.outlook.com
 (2603:10b6:8:2f::24) To DM3PPF905D77450.namprd10.prod.outlook.com
 (2603:10b6:f:fc00::c37)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM3PPF905D77450:EE_|MN2PR10MB4205:EE_
X-MS-Office365-Filtering-Correlation-Id: dc35e2da-68d6-4c33-b867-08de9cd629ae
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam:
	BCL:0;ARA:13230040|366016|376014|1800799024|22082099003|18002099003|56012099003;
X-Microsoft-Antispam-Message-Info:
	BKPhQi+yOqN8msa4N/7zsot/oIx/MblGiZdLZ4gd4M2/Aw53pdVzhywN/I1tnMGm9EevzzvsSpl9RUr3GNEqIeHQxqM6/UnEKVtal4a5k0BLzcpXB/iq0ey0jJ79VpnXMcodjf25oNP6Lz0F6DquTv5tDnNtxcAZy9tBxUGPuGAs71ICVz8TvGFczuFxkMJnQ+GLN7o77HWK+NVR3iG06QKTELAq86CBv+wD5hmsV14HrwRIJrNC6wOK/4cc6ERWI2BtBD+Mlg3q2WNNKgPhJhRQdvtKza5owPmTag1vGomSLgsCRh6ZF8Z9n4tv9ZfQZl+SqtaljXrwKmX6EqT1EzwbmA4C2yMWplMUkRPZILJOu32cAAWAM2eiyalD32U0zGsoFsqNrxEJ2Gdwp+OgWWd7azETPcD4ka3Yd479UfSKnmC5O/uTXUx7E+Rn0ncbj4ko+3swl6qcduZPJC2nAM+CpJ1lOamWm6yR8dA/RoJE8AvGG4PYblmwjL/I0UU1Ik975LXJO7Y4licqw3u+RzNrrBuA+Tp9ZjurCMfd9Jb8fvc3isHdbpISjPVgdnes/PoDjiVD1dO54Dk+SwcyQR9rPOTTAHkahneQn7m9ICO2UqtbXOmzvHiR9SuNKiMeIS3/o7/VPRHV28wa5hU9AIMTHx+Vzvm4Qz7IQrmaLXnESEqaYT3IzQqb/F7EJVAgLxk8YgzlCT6Cckis4lX2menznw+sVKnm7rrCXeedaKI=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM3PPF905D77450.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(376014)(1800799024)(22082099003)(18002099003)(56012099003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?GdFkR7mftDtQDpZkPlJ4MNQgaN/H/QLrhujdw17WWIcdvN478RLDb+HnKYTj?=
 =?us-ascii?Q?HErezO5sas/pF7XnZg+nkuKFfnNADE4dxQCOEeIm5l9gxTh4HuEueLlnm2pJ?=
 =?us-ascii?Q?7CLPLB1/4pB/CJ2SROQl9SYPTjcS/Whksa0RltLfcfMN8PaRwwh13GgNWu7R?=
 =?us-ascii?Q?aXU5O+MO+r8WuqVrlAdlFZbuyy3CXBOw/yPMVba8i3D0q6ttCAFymsBaqn3Z?=
 =?us-ascii?Q?7jOaOusMC9QqX9r443sY/M+MulLa3SN2lJ7lbZx+v7VuQeFYB4PCBn7jI2uu?=
 =?us-ascii?Q?FnP5kQ3F+eWbyW+6R1csrCMNCeWJMsHOq7rpekQJjUwzpr8Z7r0qDudb5UW0?=
 =?us-ascii?Q?ejko0MOioVc8+rGRRkoKcUPVDwkaTk07FFli3/pD/Nk421fxoGaLp7k2mHkO?=
 =?us-ascii?Q?b0ZWgOYA6dY9b5IaWdvDbyv5+OtqcuhF7eKn2q5IzaxdATRJyotMSSRbDHOJ?=
 =?us-ascii?Q?xE4JtID4bqd4JuAMRppDpSAUjwWamIhUJ0KG50f8nTcqtstVTwkLKdW9UjwY?=
 =?us-ascii?Q?+ogl2s+2TfJN7vZ0NwEUMjp0MJKeHZj65GkoLO485Du0Iy1bLK/XdZjTRTxu?=
 =?us-ascii?Q?EDmKHO6H2kV9jQLvJjb9iTwdYZQAinPdL7bZE/SL/27Fh7rUPfOaBqQk1BrT?=
 =?us-ascii?Q?rd7Kq2RFo4tG7spG72Gly4odprJ4gshE66IcVFQdKZ3Oc/V+4ZMno0xrw0Ta?=
 =?us-ascii?Q?hfvTU9MVHB6C8jtNfPMlP7Tk5rC4NDYsooWcPHmm+RhzqG/n7Y15Jw0+eoti?=
 =?us-ascii?Q?8DAsbLhz21rNlhv0EXai10dj4jeOUxkz2WC6zI8b5DHOH2XOtaOugEhQeVuf?=
 =?us-ascii?Q?C/YQLTrqi2H8KYdBKPO5hsN5reR1c59Dqn68FsV0eoWD3UTZMjurbSrgKtnC?=
 =?us-ascii?Q?SufmoRMQgS+rWNTrJVBIy6Yv6qSKeAh5agZKimvncwcMRFKIoEedOPOculSZ?=
 =?us-ascii?Q?+M1HanZuAunkkfKnzmiVZ1Y7pCFjlx91x42vonUOQ3FgWeBzn1FXZQZrMWu/?=
 =?us-ascii?Q?Gko0IAVrlHiLewwaS42UI4qryuScGDhla1cn0aSltP6xafXC4kw0JT76AhCE?=
 =?us-ascii?Q?8RxWd/Y7vZyGu1Fqcd8fPHxAYwR1PID543DBqWnM9n2GFEy6f44H8aIkBJ7H?=
 =?us-ascii?Q?jXii4jD9UbqjKaJCAqzkSqhNp7RFG0BWYenTYlxq1qe6WoHzS9DPH+y6GJl+?=
 =?us-ascii?Q?iU7+aqhuxQFiV3UkpSrcu3IsZWFC/opzuM6oqyOVaTHDSTbhZgUKcSuZt1zS?=
 =?us-ascii?Q?TxZj+s3XWlYJdw23jFsOGq3vhtF40ozhYSJIcyCVSHqVYe6noSAuLKIETwnf?=
 =?us-ascii?Q?eEvUJLJ/ACGAuzi6isf6c3T3Y5ezw666D403OP+nPtvrXfd/vTo1tIUBRLSS?=
 =?us-ascii?Q?F921VM8dirFAFt1KNXDXog2fLD9U6T4QelQ6ssgEg5vTuspHzePugWNTPwkp?=
 =?us-ascii?Q?jiWjcW16p59FoGz2qzRhUph9SyvAnG0+3vKIBbuEjhdWHWqgs/QOf1wzAMH6?=
 =?us-ascii?Q?I22oCogRO5tcumSUyF+kDII+aj+rQtxds98urgiweso9vmjmd5vKarAx0I9U?=
 =?us-ascii?Q?WeJdFGW21eIJA40D/0/WyneQKh62m4smftm+Y9xy9h4NNY3IxdKYhILqxGP+?=
 =?us-ascii?Q?Tdk763inu5cl4eZ6sHXeEOk9t7QFh6PVjHd5AQK4xwMh5rIB3CTNgLYhYW42?=
 =?us-ascii?Q?wz6rPVOQvbPNZbccNMRzeE7CmHKeU1BMZYzR3NlcRKcxNya1RSM9Oih4K8yq?=
 =?us-ascii?Q?epz+8iJR8OainTXAqpBWpbAVk6yknvU=3D?=
X-Exchange-RoutingPolicyChecked:
	kSaOkw0LRJTaU5j1tQZNUGDb2hYX6+fbyj7oafWapgLGBvmBADp1Cscdj56mFZzgu0vHehmq3YT2NVFxl0+Z+01xm7z4FuUeG0dKujQEtcCMsoVQKK8KFceP0SwkM5YwspFA33ceZkpgh3bJjkOOgtlBLpEzIGS1f4+eGh4kKubgzO3Kd5pGMAmrLBjy64pAPMffPU9s6maHccD04spKvN7CjkZ/tUwT8mfmuy76KYm2LRAxqqP41HigN5Uhl+tqj1Y96Es0enV/x/Vzbv03J/GTexPOzHbW9VZGCWFP35zsno9Xe8sA7ED9smiM4dGwHDEmhqx06GiKvE0YXd1JOw==
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	j4V7tB1wQOPgNLN6RuhHLUXgjCqPMfqBfmGCzlfDq3ym8qV6GZYdjMmMHNIgp1799fHUNLbpL2C1PVZJ+1o3Se4sLVgU56n8CUCC+EwOp/Zhmf+JG6iY51RyJ3D4DWpRpu64661LNj4ETvDLjxqWgC66NIP7U8dJgpHXnchxVmFmjOFi7nvD4lNWOpZXdZbgPeR1O7OZ1XiKq9jTxG6bpxmWQD5SttuFQsB16XRu0Aayi5ovMf3s6rjOLiqPjSqLqDyY8/okQZbw+7I7B44ju6virEUhpVM+sf7wD0v++cKdwjXMIOWnH0ZgKglFn/km4P46YlYt+cR8UHQRKHMlZpboQ44AEbudU5//12wLWr5shqWoElTQTimqa5h2md9npSWKLBFTutdw9bsYRtlkahZYU+45ZwnDHuxy8xNo39DCqO8FItdlfKIRUB57MBhtDTlzS1oaYHIiXnGJwJS9oRFYSYGbrNmTDpds5U0xc8qh5LVECbJTL65P52Rs49DnH/SnCZeJKy4u7x0yiet8ElREZaqz7KHl/VyaaVJ9A3B++mvFZiILqF9neNtgsAAY858gybrukQfrjifh8tpifEZGzxoDn43dyAyaRmleiZA=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: dc35e2da-68d6-4c33-b867-08de9cd629ae
X-MS-Exchange-CrossTenant-AuthSource: DM3PPF905D77450.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2026 23:07:57.0848
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OOC7/pGnnD+dRcRdRWYIyu4ZOrKcw9HrXm+YJegKsXCIzV03HatVE89UTAoDo3T+tS/CKzPh5DimJqttsfekZF1ivztBSgiI8W0jKlVbDuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4205
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1143,Hydra:6.1.51,FMLib:17.12.100.49
 definitions=2026-04-17_02,2026-04-17_04,2025-10-01_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0
 mlxlogscore=999 mlxscore=0 phishscore=0 adultscore=0 bulkscore=0
 lowpriorityscore=0 malwarescore=0 spamscore=0 classifier=spam adjust=0
 reason=mlx scancount=1 engine=8.19.0-2604070000 definitions=main-2604170232
X-Proofpoint-Spam-Details-Enc: AW1haW4tMjYwNDE3MDIzMSBTYWx0ZWRfX4WxT6VVfagpk
 XL2/YgLkR5ThfZztx2OssYjtjwnzXAioSG1/C8Ja+bI314V6M+G5FnHju25odprLlFRiRaxChuP
 4Z8PWurCQQZ8nd3KO4bkV3faV5tgkS6GEEfzVF0CdmteH8rO0u76drsFXxno+sYMs0ViA8etlyM
 nAig0AsTZ+GA/+uWSd1I7cKrmonQBQMClJDVWbFwDKtauqoVxCP0nPUR2HZitnQd3HOa4QF3cbK
 lSi82WbjVBuc97w07EaO9ZNy1ZQus0TrMUZ2mGwFEtsY11Wm/w/eDR2irm37MDvTo7sQ4mSl0aP
 I0N0i0gpiL4d/t5s1LxKHOWOdlkjjQPryxkzeS/RpECwAKIQ+bhMlghCjUbTNMII8V9ptt/tvcI
 yO7N/7aeNKqBEFKNAUFje/wq2FPecqxUNtk9Vri5tuQX0DS9BnZwhGfMKGxFXmGdIey6+KKCVZA
 JcmbwBy07uAB8h28TXrJZ6rObXlBU8dmjToCITCs=
X-Authority-Analysis: v=2.4 cv=cbjiaHDM c=1 sm=1 tr=0 ts=69e2bd50 b=1 cx=c_pps
 a=qoll8+KPOyaMroiJ2sR5sw==:117 a=qoll8+KPOyaMroiJ2sR5sw==:17
 a=6eWqkTHjU83fiwn7nKZWdM+Sl24=:19 a=z/mQ4Ysz8XfWz/Q5cLBRGdckG28=:19
 a=lCpzRmAYbLLaTzLvsPZ7Mbvzbb8=:19 a=xqWC_Br6kY4A:10 a=A5OVakUREuEA:10
 a=GoEa3M9JfhUA:10 a=VkNPw1HP01LnGYTKEx00:22 a=jiCTI4zE5U7BLdzWsZGv:22
 a=BqU2WV_vvsyTyxaotp0D:22 a=yPCof4ZbAAAA:8 a=3LqMXt-vk57QkWtdHxkA:9 cc=ntf
 awl=host:12292
X-Proofpoint-GUID: l2S9rVNCRb13afvwUrhPBGK70xWjCOAl
X-Proofpoint-ORIG-GUID: l2S9rVNCRb13afvwUrhPBGK70xWjCOAl

qedi supports a total of can_queue commands over all queues so set
host_tagset when multiple queues are used.

Signed-off-by: Mike Christie <michael.christie@oracle.com>
---
 drivers/scsi/qedi/qedi_main.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/qedi/qedi_main.c b/drivers/scsi/qedi/qedi_main.c
index 227ff7bd1bdc..0be0a9f30ee2 100644
--- a/drivers/scsi/qedi/qedi_main.c
+++ b/drivers/scsi/qedi/qedi_main.c
@@ -657,6 +657,8 @@ static struct qedi_ctx *qedi_host_alloc(struct pci_dev *pdev)
 	qedi->max_sqes = QEDI_SQ_SIZE;
 
 	shost->nr_hw_queues = MIN_NUM_CPUS_MSIX(qedi);
+	if (shost->nr_hw_queues > 1)
+		shost->host_tagset = 1;
 
 	pci_set_drvdata(pdev, qedi);
 
-- 
2.47.1

