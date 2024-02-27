Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 538EFEAF6
	for <linux-scsi@vger.kernel.org>; Tue, 27 Feb 2024 02:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708999792; cv=fail; b=CHsNkzNgUcfyawm79CuDYm8SYtAkWAP9XwpGRG/JIAqb0OuT65zt1zi1VJaKqjvkMJ4qw6yDl2X/4dpM8/s9tcbTjaBC/AK1k0Fkr9rcTC8a9Is0m7X2xHQ6j7UdpaASOSV18Q/kAsElF00b+xUqHo2Jd2Y2mUVxSU3h8dkjjyI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708999792; c=relaxed/simple;
	bh=e7//fQW0WNnHmqJCZUWruqca9c5xw3e7n8vcVOnnP+8=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=RUuZAtaGQcAlfiMIJPiE7kEG8foIt3EcRiXV2bX0Ugmq7CWEY2s1DT3sW6gl8egZ0dRZe/YDW+1jhWjUdMesUVQGdAw1UI+K0yYPUmgNk2xhpfoMj/RuwHAQ3TgChR7ChJGTT4FUobI+IZt+arj0W/GQAj1gmFqSshXt/q8hTS0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=cmGD7Rvl; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=t4uQA3JU; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="cmGD7Rvl";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="t4uQA3JU"
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 41R1ENSH024521;
	Tue, 27 Feb 2024 02:09:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=xa5zeVFjqafA1blOdAUH+A0Q12K9DKCEqgV9zFsj0zk=;
 b=cmGD7Rvl82UVojrpv+17tdpUyKWA9tda64oPRvPJ+MZ883aW0MOf3Lva51VVt0s5EX0y
 v8ltxjLMeLr+gja4IJ9h2Bt4gctRi8Pvq51RPNRjbrp8/TEBi9k/9FSKRllPEj6a1fod
 K9udKRmhna65iPJwBlnw+3Os7noXEVzwh709l4ZCDneR8x8sX+TvzfQV4xufx6/XrVZe
 NQ6bDLVfjUgjNnzaQG4+xWwPrVao5Yjs0SXBBIPQdwsva1PKST0yohCrbibMsBkM5Jnf
 69/VFUr9i9UaVeR7IahWa+Il2f4ixFZ3Bs0DbUmmksIK8nkpFgOyznIJX9oICRLhK0zy EQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3wf7cce083-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 02:09:46 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 41R0Ukq8015331;
	Tue, 27 Feb 2024 02:09:45 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2169.outbound.protection.outlook.com [104.47.55.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3wf6w6q8tj-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 27 Feb 2024 02:09:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f6dmVrs6eMrTy6CTxkA/rYfcuARJQ6NI3fLO73cRtmMBk/ByLaFWp8MymY7gK2KFCS0eHdTGGAI3+l1cJeW8NFKZEjhUZiAoRlaBavyyLmBNNlRipRPBqbGdEahx2+C9P15RIeQj0GBv1dYDZIBYkwoczAK1hZvk+4sPjuAc2DhLvmgTlRJBUijLpZ0ifwbjNMpbF2W51I4VFcnzlSElU9XnGx+AOCuoRFbsRhx3XY3yg16HqNhwqSuklFJ/u5pwgcDSzZhi770ZVSphDyhPSdlMqjF5p7dxNQAheZMBQfDSV0u6aQx4Mnjt9ow12km5TwU+EDBNgwJPg4kEzQKzNg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xa5zeVFjqafA1blOdAUH+A0Q12K9DKCEqgV9zFsj0zk=;
 b=V3Pkj9Y+vWgn/WrTnKAoQPUl55SAR/5C/hmAdrkfJAB/zHlatfDULmYO//hsZ8Y1WshMlbkoWn0iJwFwjXCmdAAzSgUou3ETkrrtivuiI8x0pu23ZOWgTVYYU63NOPPUEMynK4QJfsujaWd83//wen1hzgypgLQHQTC5sPCzAx5yIkDZA9VYJx2p+iFZqINkcXJy2vN+sjqCj8AZ3EKQ6Edu42hxwX41KcOdW/F2wk1iUoNHC7OmwFf2jVex1N58JaQhNo56snbyi+ZfmTByOD45bdLonlNFY2VvdNJGVyreloolWrGb6/RJ2GyutcfTI91RMx9u25yiybpG3npS3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xa5zeVFjqafA1blOdAUH+A0Q12K9DKCEqgV9zFsj0zk=;
 b=t4uQA3JUi3HU8lnuEXgYyMrXVD8noqde9IGhq91DeR/MOP9zj2dImup61Mr66L6Dq9Pzi2C4Zo2WZ0/s8GJJQGo1FbzqmYWsyP+mU264x3hUfxX3whA2Tz2Ua7ATahfZl6EpvQ8hkysjcsz8xcZOiPeOLqGD34HJKDvr7pzM1Lc=
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by BL3PR10MB6066.namprd10.prod.outlook.com (2603:10b6:208:3b5::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7316.36; Tue, 27 Feb
 2024 02:09:43 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::e542:e35:9ec8:7640]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::e542:e35:9ec8:7640%4]) with mapi id 15.20.7316.035; Tue, 27 Feb 2024
 02:09:43 +0000
To: Tom Crane <TPClscsi@mklab.ph.rhul.ac.uk>
Cc: linux-scsi@vger.kernel.org
Subject: Re: Accessing discs connected to H/W RAID controller over SG interface
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1msrm65im.fsf@ca-mkp.ca.oracle.com>
References: <8593326e-3a54-da70-237c-dae3802d8b1d@mklab.ph.rhul.ac.uk>
Date: Mon, 26 Feb 2024 21:09:41 -0500
In-Reply-To: <8593326e-3a54-da70-237c-dae3802d8b1d@mklab.ph.rhul.ac.uk> (Tom
	Crane's message of "Mon, 12 Feb 2024 19:34:57 +0000 (GMT)")
Content-Type: text/plain
X-ClientProxiedBy: PH8PR15CA0020.namprd15.prod.outlook.com
 (2603:10b6:510:2d2::20) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CO1PR10MB4754:EE_|BL3PR10MB6066:EE_
X-MS-Office365-Filtering-Correlation-Id: 7233c076-ff7a-43bd-19cc-08dc373929b3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Xkj7clnf9OsNi0nFflsEmQmFAUkNK5vwa1fChSGtsXGfHxy9Q5tK7yS8QXo0wrTGPsZOq8ey+i2eow0gdiZk7bosDRTIwz6fqD0MCSp/YyZNj+EaPchNuQBhotiBNCAtiEUqvfj6ATVLGxg6N9Fwt9S6EY/CWVOqc0hRDcti+7c3mDh6T8BxU6BwIQHtXQYOZbsNLoMDtjj6Z9bnsdljwhfy1b9m5AygeQFy4L8RNGfUUWPZtOyycWtGOr3XKo4joSWMuryUbcqpnTj1kHKUS8sur1pAWfZ1wDtwUqS9315uhcMRnKZ8PtniOBcpq2IJ0pdSu6wYkqeBHFTsLz2Mev1Tk/Tl4m7VvGd/a60fT+YnQJCGk0MQk2Mk133+v4yfH5LsQEj02b+p1bjm+zoQQ7CDuGR0XB8piMzpfZ90nflPTuVdkNp0kThHvnRY6f2hPWagoQe+pnlwOoVPy58CTeZF9C3aC/ZWiEYvwkAfdiX1qZw3mE1+VsiYBiTybv7ce5sR8paGo1SO/y6AC294OBerTQyAxko0oIOBEYH5fZrtaHmG1mflK2J1r6PaNsiFMqbv5nBy/7mL071ETZcGdX8uP4TAttJ3yZWSKPCkiRlq69eISXfTtS2OeUSrG0UE
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?zIPmM0Dik2hUSeYPzo2D9U8EqnS4am+sDBrPRG4k15H9/5VVymiPXKDW81ap?=
 =?us-ascii?Q?4oNcCc+4vyXJ1I1wny7624nV5IfGnffVXebqIor0/KKMgXmV+IUi6gFHS929?=
 =?us-ascii?Q?JgPuTuRMISJKbx1YhAXUxf/hXllvLTW+U8qTiOSVfLjU2OR2wzj/O1C85mS4?=
 =?us-ascii?Q?b3DFIxO3lDUAwMFM4fad+28U/qrZQtoZmBxBf3/s4aSj+qmI9mBbb77ATkdl?=
 =?us-ascii?Q?CpzL9kNPSVaNisD/PCwbBgdE/Je+O5Z+YF8yh3NBOBRB6aOv3PZsvoQObKHA?=
 =?us-ascii?Q?RWLIvfEtLz9Uotq5oAQABmGl0Hgtjn2gOVvwVyjmJUdt/gzDArZnZXbiSCRD?=
 =?us-ascii?Q?eP6DaRD8Cj5/ohBelljhYLJXcF1ENmIPULd2T3zFy5r7ruKDlWmX/2qVYNmK?=
 =?us-ascii?Q?I6PE+s7k0fgj+W8vlaxOob7lprvXLo8gtopmYix7ZA52bXhno9bANJv0LlY0?=
 =?us-ascii?Q?PvCda8fFW3ByfgQ/4uvo8Ef0ZHSYdap/ScAFQ0VnusMyetpw9GyPVEtn0sIm?=
 =?us-ascii?Q?iJAXFv/vIpw6zQkysH3TvCtKUaQj1+dUq0VHA8oPHx2Uoh3Cc3KIjSdheJ2O?=
 =?us-ascii?Q?VNBhRVc5/gbdZBTy8FufeQN1fgW8dYUNCiAg5cefsOhiUWuXISNzpzjRwcin?=
 =?us-ascii?Q?7refGtxvQI2LeZcODF4IZ9/HJwzovxV4cIcJTFb9WLYnmZGlIrDoSevLEu8u?=
 =?us-ascii?Q?F6t2ZmDTExwm7VGVFV6RRqcZKnFMXfdc2UFguLO+Ttjx5y6vR6WioF3ncmXq?=
 =?us-ascii?Q?/Xob1XJ5og0S8bbGMpCAxFRGg5imb69m3YtXlkLgcvb8sDvD5ypkwqz0JiSn?=
 =?us-ascii?Q?wRNaGKrAs4R4PqeoBUCMmVdXNZKIe0i6xF4gID5/HbgajTaiJEmwqtKSWc1f?=
 =?us-ascii?Q?QU1h+6td3VHq+uBIBIiaFxWArN9bq1awSNPIOI6B8r2gM22P+kaqZwQeOd2m?=
 =?us-ascii?Q?inKZnS1wWWtKzPbWOcoWF4kYRMlzSSSxawmLv3C+sLISJrZWh2dMcQWrVeKG?=
 =?us-ascii?Q?oBO1INf0wKGMAl3nsn2Y4UezYDFZInIgiq0A9kaQz3UZ5TJXFKEqCgWdGGZG?=
 =?us-ascii?Q?uUV2H/pAo6WCEMFoHZcaSlyVbZV/0F27vduffHffdrdFugCbf64LnofRJEpv?=
 =?us-ascii?Q?bO9Bsoa8dTnBAY4QlQbStzcz2dBiFXsMXWkpIEF8VcGJqHErf/3PS7gfVNn6?=
 =?us-ascii?Q?5BOKhFNFRoQUA2aRosNK6Kwg25RpJS4HZ2Ok6d2DICB9CAVuxTxITVszrQUe?=
 =?us-ascii?Q?wYXBL5nK9YeRt5aFuDvmW4umDpCUSEQaD28NFwKRI63Nx4dwFn74jPy3Tmp/?=
 =?us-ascii?Q?zISINBUKYsUIajIBpeWLidtPJifBTtfkNzV4tPDM5ZWe0pnyttWONb0BLAd1?=
 =?us-ascii?Q?HDsi8RgJiqEtkFVRqiXZAGGkSlCAZZSgWsUR+rUqHfFWQWSW4ctwZhbF0qQu?=
 =?us-ascii?Q?HbVm2IQg/2S46SHX+7bT7LDfOO2yB/q5ErW6jy0xQBEsyB9jT/F1970nthAy?=
 =?us-ascii?Q?XYQfZ5wb8+KbUVb5kK2JvQTL80hB8gm75hkmUcFbYVR79X0tDW8AlRm2oABZ?=
 =?us-ascii?Q?uX7IEiOhZnI5r/EosUuox30maqydJkTXwksqZ9igzd9bUdujN4KrkZwAdk4d?=
 =?us-ascii?Q?4A=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	Kx9G/y4dDOotP5ses/hD6fH9KCYmfZiK93RAirGiq43EH3/4nXRr20GBPEvLAD/qk/KZgjulpqrtEW4oL0zEEKmzAuz0qiP45lrbKVoYY8XlHQESmGxT2P33iUq2/H8dz7gpRUfuGxdenf/Y2E8mnHOpPl3nEqSMHDrpgQV5kngC3jLGhoEGjVNdMYeUgudV4SqX+1ZmvWpOEl/mwDntE7ylrNlSrxMIicqukXzjx4oiogBJVikRfqDA4RILyub/NLdyUjhS+zRqo8xBf9bHDkDnImN6UTc5tKlc0hDaGp1ZVxTogjvMc8rigrJ9h/UsaDxfj1znYVmngHXSWPE33s68VDDj3WDcuDboZ3IGNIm4YZYL8mQQHhJ/wb2gpXh3Cmn60jSXjsrx1CR9u4NawZspGrO6zAlVIaGpAvOoqVrP/MfJNynyIuOMifSz2CLslQkPDrSnrkMwVM/DdWPBtYKL13EZ5KnkqOhW+pMBqe/E5HcdAcNwY8nQ1YirUkv1Vh28L6b5XSvj5cUqGFxxGMsAFsUtxpAdUc0IDzHByvScuIdo/mKKqJohkdZFqU2ou+tnRS+eMq9gPfhz+4SE4rmZYoN9jHBnEIPcXvVuQ/8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7233c076-ff7a-43bd-19cc-08dc373929b3
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Feb 2024 02:09:43.3584
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FkmSk8O+fSsjGk9WPLcH4Eu9r24P3ggOARuQutZbnMkFlZ9+NX7rQ4TJCN5AjoiFeXyHF6ryhFVjSEL3gOjKuUx4ODRsgPEk5eMCX13Y6ZM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6066
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-02-26_11,2024-02-26_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 spamscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2311290000
 definitions=main-2402270016
X-Proofpoint-ORIG-GUID: auWbMqhjU_7GnEuA6B5X8PzXvcsZxdP3
X-Proofpoint-GUID: auWbMqhjU_7GnEuA6B5X8PzXvcsZxdP3


Tom,

> The RAID controller from Areca is configured with 2-off RAID volumes
> and has 4-off 6TB discs attached to it.  I would like to be able to
> access the 4 discs individually, e.g. to be able to dd them to
> /dev/null to check on their performances.

It really depends on the RAID controller whether it is possible to
directly access physical disks. Most controllers disallow accessing any
drives that are part of a logical RAID volume.

Those controllers that expose physical disks will typically only present
them as generic SCSI devices for purposes of health monitoring and drive
firmware updates. The controller firmware will often only allow a few
carefully curated SCSI commands to be passed through to the physical
drive.

The reason you can query the drives through smartctl is that the latter
has special code which knows how to address individual drives behind an
areca interface. But querying SMART data is not the same as being able
to send or receive arbitrary SCSI commands.

-- 
Martin K. Petersen	Oracle Linux Engineering
