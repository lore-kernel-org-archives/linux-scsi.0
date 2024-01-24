Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 737F9FBFC
	for <linux-scsi@vger.kernel.org>; Wed, 24 Jan 2024 02:46:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706064407; cv=fail; b=eYOjVyfIkr+AXH8tsFqV9k45SQASPe/m1mzcbx0STi7eNRt2wo8Wwc4pcoox0zwytPsi9L/AqTBV+DXyxJg07nvdOwMbLYWiLwoyeY96zQAUvHBJB9AmKreqQuxiMY7KY4ED79cHqL09ySV884hOwR9jOtPh4EHJ31JHMt9Fpsw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706064407; c=relaxed/simple;
	bh=JzvgN6+mW/qMVdvu4XAruT/f20nfGMkakMZUqtta8rY=;
	h=To:Cc:Subject:From:Message-ID:References:Date:In-Reply-To:
	 Content-Type:MIME-Version; b=JI1Bb2EQnyeaPExU2mwcbNRMvX/DWBA1W5LEThy3VXCWZtcp0z/LQ39NI/Mk2W/8C9m5Q9Nuv5b8U/tQ37uK7WvnHwn7dvRUcfglVKWpVlXan6l4YU0VyegrhXtTqzzaZ/nqwA06nLuwNW2pt1SDGrflattUjCUym23eYBZV1Ac=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=ey78/GrR; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=aFFAKxmp; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="ey78/GrR";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="aFFAKxmp"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 40NMrmLd025190;
	Wed, 24 Jan 2024 02:46:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-11-20;
 bh=/l76+x0VX5p0XVfIPP4kUzkQLFWJsmziFaxwVbwsKi8=;
 b=ey78/GrRKtB2OeG5iKl7jf3OAoFb3/G/PcWRzS/jtD+39gKi4VHr+X8LvrqXt9zchGY3
 FdaM3AdtNs5MDdeitNZ3pbd7HmEVUdeGinekN47l1VaHPKGadzen5lfaGc7am53Hr7e9
 JhHZJDFxO0BgjoILPyugBWFfKZ79FOpM4jAnjfmL7DeVnAGCYNULHk5AYuD0ibJ3BAUs
 KjHirsx1drxrhBlAMDVglQQVss072bLF0v0ssCW3khCOvJ9P8TBlJsHxlDLubOJiAXBn
 FEOYEJzK98Oubl09eh8cYh8rWlPbSNoW7u16A07+c6MS7hkkHcuFjajHVYfoeqw0EnuG ew== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3vr7abyytn-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:46:34 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 40O1DdAa014745;
	Wed, 24 Jan 2024 02:46:33 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2169.outbound.protection.outlook.com [104.47.59.169])
	by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3vs37281np-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Wed, 24 Jan 2024 02:46:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQkw0md/sijujk5BTeVmPWvqccgf35DNBYkb392jzywu4NTkL1HOJx6bFPuL5zBypP9leMelXVkjLPOPu7DAwoswjKw2PcQ+cyJ4n1V3gMyywYSnF37zlMWRkghDztpJc5WY7axItlKYhRxjP15D/VRlFH7swT7JUrojB+0UWlBLLe2n1WkLlD0C9Sd5fYrOjyVnJMGyFVvNKhvRDJWZsHYQe9JxDN39DkbCoMiJC2to1nVybIfD76VpnDJE9GAKn73mc87/uzuSJ0XxgGZGsbrxNIu1E7uMZYceRqK4adVv4hiE6lBANBGtlkmAsEEwJeUIDg84YAwDZ/heQHg/tg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=/l76+x0VX5p0XVfIPP4kUzkQLFWJsmziFaxwVbwsKi8=;
 b=BgBm8dxrXSZRBluLR+/MDNbe3ZoW0ktrRZV2W5tZ0sgnMXtufZvXOjR7xZDuWZfObgt/H7VLlYCSCpGpy22F2Ojut6AqCoG7/QLDA4sxe2r6l1yCk4RrG/lOifHXOrvV7jn8ilYwdHE9kGFrOcIBiwDyba3ts9UnC3lXOaHPTJqhLItU2b1F49IEbMWRVWMW86N+bJJwYmv5FRWP6DCD2qKVgd+3eWTyNwe9uvUSV16yu5jJFZGKCntSwi6qiAkw4LRCend/IwZqcgVW185rJNQSvbFLlvMr1oF2GTE5hdhN4+OOI0i1+o0CcqEdXbMNQCxtYLTrO8eXOClsldfVbg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/l76+x0VX5p0XVfIPP4kUzkQLFWJsmziFaxwVbwsKi8=;
 b=aFFAKxmpGH/MjZLyNCMiiMqmlXt7Xc8/vj6vz6+0ezTdk1VahPAiljVtcP0KKr4ch0oX7Fxi8533p0oJrcS7yGJyMNZcPL0RUeUNexDvqWd65QGSjpAiEzMicVPwgR9J5sU0/8yZXSlZnaMFT29jz4cEnBqjsTgZrWtLIX9vcM0=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7057.namprd10.prod.outlook.com (2603:10b6:a03:4c8::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7228.22; Wed, 24 Jan
 2024 02:46:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::3676:ea76:7966:1654%4]) with mapi id 15.20.7202.035; Wed, 24 Jan 2024
 02:46:29 +0000
To: Guixin Liu <kanie@linux.alibaba.com>
Cc: sathya.prakash@broadcom.com, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, sreekanth.reddy@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH V2] scsi: mpi3mr: use ida to manage mrioc's id
From: "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1zfwvwis3.fsf@ca-mkp.ca.oracle.com>
References: <20231229040331.52518-1-kanie@linux.alibaba.com>
Date: Tue, 23 Jan 2024 21:46:27 -0500
In-Reply-To: <20231229040331.52518-1-kanie@linux.alibaba.com> (Guixin Liu's
	message of "Fri, 29 Dec 2023 12:03:31 +0800")
Content-Type: text/plain
X-ClientProxiedBy: PH7PR10CA0013.namprd10.prod.outlook.com
 (2603:10b6:510:23d::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7057:EE_
X-MS-Office365-Filtering-Correlation-Id: 5fd8a26e-e4cb-472e-1d9f-08dc1c86aa84
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 
	Swfhk7XYpPPwStwAqt97giiDsMwKsCvrH9LnXMzatXAfFP2WxfBQ94i8k/fO7U1vCIqSBBIZjwRMqirg927lH5PLz0lWZec1fyNWTV3mjfYBj+KlomawSsmrgpJkvP/jB6iXPnT6MyafF/aEi37TrAq0mwf83T28/a0xOYInNNFNU0g0bj+E/RBQIuS9B4gdWQiHLrASOitPB6HaA0ilKYwQqlJ+ZVqlUZaXyGOGkiYsYntfPOqYp0O9/fjXGEXQKSA8VUw6K3wowjYgetidZsLhSe4vGNPZHHnCJQrqjOZPCzU+OaennL+L2MUi7H/QGNCM7epPFtNv0dcbKrLq9OLK4bvb61CYVCf9ymWd3HKOSBsaLuDCjrhMO+lXGEx8lR4+bIT7j7oTGDjSQJ+2zAIRgFIvKZsfRTJug++BE1LoBCBXOqGJ95Uyiuev8lYG0kmsCqX66H8VuDEPRqX6fivJ+wjbdDOgmDjW/grg6TxOooOjDljCptH333jsmjyEx+NsgkFUL3M2YfmbsAb90Ln91zVgBY0XwIpru14xe7CyF7PUwVZz/jMnZu6uLQWwArRYHauwkl8J5HQzj8UkEIwTr+OZILtgYcJxJNyDBBw=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(39860400002)(396003)(136003)(366004)(346002)(376002)(230922051799003)(451199024)(186009)(64100799003)(1800799012)(2906002)(5660300002)(41300700001)(86362001)(558084003)(38100700002)(316002)(6916009)(66946007)(66476007)(66556008)(6512007)(8676002)(26005)(478600001)(36916002)(6506007)(6486002)(8936002)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?+mvNv2kYbCqdEXoSFbgbMWahY7BJcAUbu0gInTCEejQmgyVQRIDYd8Qd2vFf?=
 =?us-ascii?Q?AhgamnBJ95pRwrQ8h9pHNd8DmdE2UNdTXqztR1iDjbqjs2ko8C1WRMciJLrP?=
 =?us-ascii?Q?whoZr+ImhhZpXmnAjQjFBTZQQpc8pD1IkvBTxSEv733FJmtvFalG4vVjNpn5?=
 =?us-ascii?Q?ZlQjWjWufNsPAwk/PyzC6N0IwTuLdr7S94kHKNkJ2qn3XYzwIE54gvtOKgmK?=
 =?us-ascii?Q?6GuC+T1IGVn19lKKNcTne77qY1lCHU8OLR5jy5VEJz2b40GPGgzrZ22UVxIv?=
 =?us-ascii?Q?F0HCnZsKR9T4J9h9CUk5Ue5wiHeyJHuS6yUVNaGhakDSQd8huHF4UHSIhUHz?=
 =?us-ascii?Q?3lO7+a+a9Cea71WPjMEr7tXngRWkIKiSIBZMWy6LbNefnlGP1C4ZNsG/UH6Z?=
 =?us-ascii?Q?AIYOQl59FhRObzu5Kbc66tP08uNSQHbz/RXzrPaqK/OzVRCzrULPdcla7xUZ?=
 =?us-ascii?Q?pJc/kcXgn+/XAnAimt00azr0DBCOnArfvFoAd7BEGSd5h9UVY2Ul/WvnTuDW?=
 =?us-ascii?Q?kAgFk17duoPjKj9P2Fy/dDmt1pToPTCjkQOIIkhFSlKlx8Gn6zAcegc8tBFy?=
 =?us-ascii?Q?dym1SIph6JIpDnobTxDZ/SNLE8S/mybgAEWmnbwYijeK7FvI2rp4ZWiZIh1G?=
 =?us-ascii?Q?2ZvU8LHO1fu3VU0ecdKrchzx+cO9e/k6D3vvkow58a0Z9xFgvbw9vc00I7xq?=
 =?us-ascii?Q?7oQRo5CWt5U4XZRswhy8DQdxbDwk89r9RMLbXevPLn7cL6ak+iIFWQY1DviQ?=
 =?us-ascii?Q?Q+p2EO9nC9ShRyD4wxHTATC176/rHrqim/aNLDIvj3ey5bPwLWC/nCDXncxb?=
 =?us-ascii?Q?wKREBaBIC/pipus0yNK6ODO++O2LqULsDzXPKKbz5DTHmfzMJBPD6eUx2oLy?=
 =?us-ascii?Q?O9teGpuDzL3gzahbovJFdlV+4hi+H3UrqJtfGA6HjAa0r9vQJU+9/FXaCrGE?=
 =?us-ascii?Q?KjApHnHoyuHRb4mv8PsVXcYdukwWAYgpOY3Ab+kxlMv4Jyje+bayBsR2cW8+?=
 =?us-ascii?Q?7vAUl7JLuDwUMCHNOujXgFyvDAeOdF8ncJxLFSUgO7PJcEYaCM22pk+CPpj/?=
 =?us-ascii?Q?oA15/5EDZKEtZdcrV/i9e0alCNGNmzaHjWTnASSoF8Y9wzoaIBnjMkt5/p5L?=
 =?us-ascii?Q?mLpiXNiV0PA3PiJ4MJN28eFjSskz0yV7b7q1hHTrELCGUSjASE0wkqvrpvck?=
 =?us-ascii?Q?1OJvipexhlYy3OKc2Mfh+eG0qXX27EXmVF6W0HxjEsk8UQ5fp9gKh3pKxtUU?=
 =?us-ascii?Q?qy5aTjGVA1dkguvgiy8EscWkOBZIP26WLs/m+sM+a/q/UpN7vdSvsFozY+qP?=
 =?us-ascii?Q?l6SaxnoKY0NHhStNH02PjaLo2/3iR9Gp7MrD2wXnB/SB2IjzLRIZmeb9ka08?=
 =?us-ascii?Q?Ka8qN8jSdpoFW7O4gf5YScG0ItQiByAvXREEuzq7AZChJx/r93wMMWsSYE08?=
 =?us-ascii?Q?JXLIXXPcsBfsIpMwXOMM9lM6K0KafQfM0Xrd6kSTbwuXOfLKIGOJmn+yDAmY?=
 =?us-ascii?Q?GfZSKrLX/UUSdIsLTxPxFx3465OtRinQ82ITfrsBvxGBjh50plGHkrGiJ9hO?=
 =?us-ascii?Q?Zc2HSSerl2MnFpU7IBa9+VRf9JTnehLmMiRxtFwhf2sbiTrOi5CDaEvqGiRc?=
 =?us-ascii?Q?KA=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	n6ATaqB3Rwoc8fD2/MXQAjKkVwkSsxLRvcE42N8Kf12xczOuPXCF1zZ+lU/qM9+C/kc1qqqF9ynKWvkzvZ7wLYEij8QOUh/nbWLocWvse00UB+7WBAtHZqs0v8bsKtnvZ2tfJ9vaQl5enOPFjvyf3Y4wZg5GaH5oughOcgeoo/oa2Q3PBm97aTbyBm0toATOVf2DJI2OxKhAbJFAXwvAbc9dWO4GMc0AoLwcitcv+gvzByLo08Oi6JE20BOakiHhvngbdPUXM/zNttsdnDgwSCKyWHrPUSrbhzgYfgmAAxp2yMgw56Q/9woRgmHFTXAFIBmIfPFu8op8PaUMpH98MjrJ4PHticM8y5W/KOg/oAb3EPT80won6KllBXSxO3hbTysajB0SUT1EoIlMJacYHV8jAMDTZVKtFxVehEvsdzbnfFNo/kPkTTqD+GTKUBPY7eTLeTsmrqzwyKHyY7GfQfQJIBYKEauxKvjyJKXi0IxzBI36KA+cEI21ys7N1faamd9Ie3BQJozIFpD58nRGvyq9xDXikNTXiRjZ1bmdJANwcX5bUTU10n5Y3tCftZQUxMoJx0lKd+XsKppKqQY1pl7T0qZQbhs8Ilq9crsCvwI=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5fd8a26e-e4cb-472e-1d9f-08dc1c86aa84
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2024 02:46:29.3382
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ULvGGm9oMlBK98B46xEkxR5Z1n/xYScOw01ETazZ+6aSVrYTOP8mPkpQad8604YIEx/rXMwXl3sA/KUDy7PqQTdVCjEar+9H7zgCEe4L6eo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7057
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.1011,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2024-01-23_15,2024-01-23_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=667
 malwarescore=0 mlxscore=0 phishscore=0 bulkscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2311290000 definitions=main-2401240019
X-Proofpoint-GUID: AObjxImh-Qm6S5LClLpbBldXkaqIdpiZ
X-Proofpoint-ORIG-GUID: AObjxImh-Qm6S5LClLpbBldXkaqIdpiZ


Guixin,

> To ensure that the same id is not obtained during concurrent execution
> of the probe, an ida is used to manage the mrioc's id.

Applied to 6.9/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
