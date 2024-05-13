Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ECC2F153823
	for <linux-scsi@vger.kernel.org>; Mon, 13 May 2024 14:27:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.165.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715610455; cv=fail; b=VjyMTfhBZ9HeaFuO5M75susWe/3roQqL6CD9tP9QOfiZuENPuNS472R6Igi7q7htjS8Q8KRHsLB5nsokoFb3BmFOtVQVUJ96+3PIarq+s3KiDUR9I+XpCQAEnf0qpwcbkhr2YngG/GgQmKzsiCNLrpiSWEPlNLtokgwv01sfJDM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715610455; c=relaxed/simple;
	bh=bDHHVpEqJFVxc2Q+ScpG/sG5VYJsa7golUj8RrQJkls=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=DrrFMHgLenjl2Nn8AoaqIdNbmopyJmPdqV+x25sw1AP3XI6eiKERdu92tKDUyp/5x1J88Y8X7HnsTfgV8nFJVVJVGRjb60sqweBJDt/DGe54Sunci49ruDEh9U3aU8MPUdFX3a91JPEQYiu4CwTiMrnhlUG9dC3h8020ZB6IKLk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=PqRpghx4; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=IpUR6aNd; arc=fail smtp.client-ip=205.220.165.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="PqRpghx4";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="IpUR6aNd"
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 44DE5n0W019146;
	Mon, 13 May 2024 14:27:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : in-reply-to : message-id : references : date : content-type :
 mime-version; s=corp-2023-11-20;
 bh=K3JjY7iL2x+Q8yQuISIWKJO2r29fP9mgYif9joXfmtI=;
 b=PqRpghx42vaGJEDHsTJmOQac/PslyF5ss1mQ1x2ygFNpz6TYYR3slUSPZQojqefr1c1w
 ADxSglzc3OETxiUnlmQ076FwqCojPP+oYUto6jP/6Lhg8unri7P8Um8dK7QvY8PZqPBM
 PkhSPFzlCjQMdsWnYjQsqS5YfqQ0YTYIoTxvFWiCEYtstQ0XuVVOb5MnExRCTqajBO1R
 hTR5nOzio/cfTyzeWMJik3dn/hbSMfqCxr0zMoAXNNA7AF21Rk3qv8J3Rt6+lAZCA9GW
 ZZ/tv0QF2DNEya3DTBlg2OpeDbHgkt/Kj1XWnvb2LyrLMzbjyywDg2Y1ZZtSDIgyCn1A og== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3y3dyx13fb-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 14:27:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 44DDG3BK028864;
	Mon, 13 May 2024 14:27:09 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3y1y45w5x0-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Mon, 13 May 2024 14:27:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y5SYkWZ5kBk6esd8ZUEOhrKO87FFa3pAVuDiXXE//AbmsiT3lEf3eKlUiYYTjIemwVnAS6n2RJbM1pSxVwpdhJcTnElKDdWPgttnXIqrUxyWkAgsGlx1qGA34uPH07R2KoZW6OdGqtrfMVH954YYANhALLnDUC0UkTbdvrn69OJDjAqWqBLwYesmRCETIhbMwSLftJ+mh5+71brS0iKe/3bnQHezyjNRjYlQ3n/iZhOxHVi1Zlhk2EIk3GefAvIxDmrUP6Wf0A81YpH9lXVwwAiQs/poELErlIRyOaFKnrbppsX6uMXlNl4w1bvRA4u71dPNpOYZdOSmFW3et0qtYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=K3JjY7iL2x+Q8yQuISIWKJO2r29fP9mgYif9joXfmtI=;
 b=cRTgfIQFK1CIvLYoZ7v5DjovqmNw9lOWhlVjIKDU/Q0TODRQYwK+n1HUwUsX2VXpTX87LqJMchN9lXPHwJgNQLWh6lzbwF6FRbN0obv9T5OEqDCW5ngOvuZt2OFeQXayXPczTlx1L/bovnC5QIIpYwxFaYBXMoonXYO6nrs+ZsgFsGqzhdLPnJXbMvmwSg9fmz8BX1w/bRlkhnEx1k8KitY4xKvzwmSH9rF4RpeOttIdA/u9WlFWcpi5CWi1OtvghXzInY33PETBqbeYl5P3s0JLc87JcqfbjoWTJWht7AbPCB8fyKqz+4oIRqZu/M2RzWBU8FcH0ydGkTs3XiqQJQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=K3JjY7iL2x+Q8yQuISIWKJO2r29fP9mgYif9joXfmtI=;
 b=IpUR6aNdgAnqiFyKnixzbyjlnrNFTeepf2t0OBtfvVnhDTgTN9la4AwRuFbWlDN+1K9vT+0jPDeu0YCDwoP5K3HAmht7/inuPTj+2UJiEGriNXYc4f1LNxhVu4/ArhhRdTKy5HYI5tG+CtUsnvLf00MOf/m2i3zk6RC9lKMG4Hw=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by CO1PR10MB4676.namprd10.prod.outlook.com (2603:10b6:303:9e::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7544.55; Mon, 13 May
 2024 14:27:08 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7544.052; Mon, 13 May 2024
 14:27:08 +0000
To: Martin Wilck <mwilck@suse.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig
 <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        James Bottomley
 <jejb@linux.vnet.ibm.com>,
        Ewan Milne <emilne@redhat.com>,
        Mike Christie
 <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org, Bart Van
 Assche <bvanassche@acm.org>,
        Damien Le Moal <dlemoal@kernel.org>, Rajashekhar M A <rajs@netapp.com>
Subject: Re: [PATCH v4] I/O errors for ALUA state transitions
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <a92a0786d687ab5f06d79005f2bb5c09d54e4a2e.camel@suse.com> (Martin
	Wilck's message of "Mon, 13 May 2024 15:51:19 +0200")
Organization: Oracle Corporation
Message-ID: <yq1o799u6vt.fsf@ca-mkp.ca.oracle.com>
References: <20240508102426.19358-1-mwilck@suse.com>
	<yq11q6bwyf6.fsf@ca-mkp.ca.oracle.com>
	<a92a0786d687ab5f06d79005f2bb5c09d54e4a2e.camel@suse.com>
Date: Mon, 13 May 2024 10:27:05 -0400
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0092.namprd03.prod.outlook.com
 (2603:10b6:a03:333::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|CO1PR10MB4676:EE_
X-MS-Office365-Filtering-Correlation-Id: c8e2890c-25cb-4435-5342-08dc7358c4f7
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230031|366007|1800799015|376005;
X-Microsoft-Antispam-Message-Info: 
	=?us-ascii?Q?f7jv600pNION+q4i00KONuiNkvL8KEOiVPiJAiXrnMYgumLvCLPIp30G4dRP?=
 =?us-ascii?Q?yT/b7+8NOOm9f7IVQwCT+QFKC+sO9zDV4Qo+lg52y6FHvIQREuZjr5h2k8s8?=
 =?us-ascii?Q?OQ4v1Q/7OX1VefFbf9aWvlD7HeDWoTObxVg3nkiJ+aYwx92WKgQw3beBjc2r?=
 =?us-ascii?Q?A2Ft4FVw8NMNU7cV4UM/1blNNgC93L2xHIv3OsdWOT6TgKZ34r5JkQxZ9VOp?=
 =?us-ascii?Q?pOtyyjNCqBQWTbAM1ansGplbw87kVwWU41X/iO3kEg2UXvhVVg11WguaawrB?=
 =?us-ascii?Q?m+gV+OpT8CLzUbx4qkKhM/pr3uO7KJd1dYpYZAMohL0+q5RnWEPQbKSEd2ZH?=
 =?us-ascii?Q?bDXniWWRVc3tO4nXRZ3ADYOz2LQtlhTj+yW1Tx1w1JfM3GaVWetIlQMO3SVS?=
 =?us-ascii?Q?FQTx2GELmVwRkcpvKKa3x+ZY3wbo5ygvTwrH/fPgMSIDbD5w2DwpxHn4Fb43?=
 =?us-ascii?Q?r8298uMlDl4AFCC4zEKIoRXeqEc6YLtJbsdfL+rfBns843bi+jCaXlLaKJZ0?=
 =?us-ascii?Q?PUmcMayVJuF/aE8bdzCvk9yGpmcMLPCc16hBDgrGvqVOTYSXAZDL24beOCpe?=
 =?us-ascii?Q?6WQ33YcGfij1hn8HZ/socdFbMGA9ZpVgtOt9AweDmpceC+6Uli1x6P/ZzGUP?=
 =?us-ascii?Q?5xwSDfhKUuG1NgB6IH5ikKKRJ6Ra6RHi/yB60w2O6hObalSdKWOtgRD6KrGJ?=
 =?us-ascii?Q?6duTMhbXbwowpuTDl7+ZdCt6oygcpjlDMkLROY2CzpD7zejkS2+/i4dXxDo2?=
 =?us-ascii?Q?3YfFdRaaWYKtAV4rMXkVYdWTeU079VacuO3mY/G6SxltcwdE78Szs8FANHFn?=
 =?us-ascii?Q?O5wVK9r4NZbulfMpMUMfLFWF61OrGlFjADa/sr+C5PJAMqpIDZVS4dGkKOZW?=
 =?us-ascii?Q?q4W5w/LTOz9XGT/pSOla9W4j/LG4VtzwWhdEV8/2MoH2RqqEnUZPYk04lV4S?=
 =?us-ascii?Q?UdVYsCeV2FEaQNVSESsJn7dqpxK/mDh+bXGVWAUPODGNdkYyzQta4iqPX5Xa?=
 =?us-ascii?Q?IHtfSwtSYBz3LCHO6eECWZuND/FnhHUotkhe8LPUj9v7PtnIoP01RyoGy1tn?=
 =?us-ascii?Q?QwgjCwihdRcHTPIAuH8jxIX1zSBMG6JCPM6i8uY09mlbi56ZQ7fFQb8eeqRU?=
 =?us-ascii?Q?IFh2tApW6AAwJcAfCNLatgXl+MGK/BsK0B44nBsoJAOkr1LZX/AqLu7KyWUr?=
 =?us-ascii?Q?BPEx0BYt3xqI5A+iSdX/JCpQ8tPHk+epwpPEt9UnwXTbI+yLNwvf6T0uyQWY?=
 =?us-ascii?Q?LxvBFixGXwqh62y7b+yqclv7Z8HoVkisLeU+3XyPuQ=3D=3D?=
X-Forefront-Antispam-Report: 
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(366007)(1800799015)(376005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: 
	=?us-ascii?Q?YlBk3SKDNHm2yHeVQCV0kOP5qmEYCLWaQm7hq/pvYJz837fT5HMBc7df6vy3?=
 =?us-ascii?Q?Kx9ISrRnD2zQDBeWJkNtAuqSZwPq+UlBnALg+thDTORfd+mNa+lCaT/zjhlI?=
 =?us-ascii?Q?Ngc1PEEdpSMkea2r0t+usyJhLqhgCHt/I/hRe8QcMBj2NZuk5Qwf7l8oa5OG?=
 =?us-ascii?Q?Uphd6Yutu4Noar5xylNxoxOfU8dh8xDr8vmh2f9HYAifLtjLdRWYoY/FMgRJ?=
 =?us-ascii?Q?btbEUqf2VUOQgpMcipdPykJJzDQRvD/+eD9QHEZtY4jP7eWruvvw8eWYguF1?=
 =?us-ascii?Q?JRI3Fg/WTeX5GiWR/CYUA+INAJeU2UNfkzUKPPOm6RweN7+Q+vZrYsLiMxqp?=
 =?us-ascii?Q?sohRNfMpMLVEW5lwcx0mjP/OTFigWc1GjpgCmo1YPwkar7NE6xMgUAtjCH5e?=
 =?us-ascii?Q?K3aJZiGwItzcx3x4FcEeBT6LQH62I/sA4clm3efta/Dtoi+QHdbawlaK3djY?=
 =?us-ascii?Q?TX6LxNCnyIK/XsyQWmwQMAgsFt3cN5Lt+DXM+J1Dv8DGXg+JCj6XFeSZr/8O?=
 =?us-ascii?Q?ZrDQT8AkdlY2X+ttpj9xg57gPIJz9wu0ysrEFYLVfejK8hBP0DhVGmJ793Tx?=
 =?us-ascii?Q?+cAVJsIGrhvgzeVYCgkBCyT/LODS04U7PUdtb8zO1AypQJlIENHBstKgT/bp?=
 =?us-ascii?Q?g4fhKpMky5yk1Fb7EcoX/O/qxHbdUjk+k2r74QR3exTyvLdLVBwgyBRBqTvc?=
 =?us-ascii?Q?DxPSI5kaNlaKGq38wYxEQxucBFq02iPfidw1NXVREXhKRYdFy9SXH56r4Vm3?=
 =?us-ascii?Q?MmTpHEYHs23Bk8M5yHoPQgJOC/L1AQnwFniKfG5cBpQ4ZxUXi8ax+FexRbwv?=
 =?us-ascii?Q?xfC6dyBbqb8ZKZp+cr521QEitx8mIfzPNhgenv4g2/p+o2Oq7OzvC/8gxqaM?=
 =?us-ascii?Q?P1b2dkSDN6Kc1pKNlskO76E6e1LH3wQQC+b5cCl1qktdultD9eBAD7zLnt7V?=
 =?us-ascii?Q?tyRBKyHGlOTLfzVkYCfM4razEoR1nSnSqgPZU3NTgpJS5k8Q5pYGDksJtXuJ?=
 =?us-ascii?Q?woJn/bvJJwpgZS/zrkUnNFxwz2BDy++cvQcfZdIIJe6AWoAW9kMzN9+sBFGh?=
 =?us-ascii?Q?vkmH3gbCKK9dI/4Z+jCfX8a+QvGD2UMGcRurxG4507ZaQeyn4lqQ8Vu3zgJ9?=
 =?us-ascii?Q?wueCV6ITxvU86hgVCaDLIB4iuUly4d3H2x98iDg1nmOShjs8op6U30KHuTk1?=
 =?us-ascii?Q?uhQRprJm/xqbRKktfqUqmNkF1HMJ3OxskiHp3GkhUb3qKIAzJ1f6ojTV00tf?=
 =?us-ascii?Q?6Rckvm9ASbUEblEeAlYK9tSCJTOXYYiT5MvhspY1pGLxVXgRNmPXHNa4yVMX?=
 =?us-ascii?Q?3j224OY0IM5pXg7RfmVrmglS4PmNag3Elg2EfWRIXS1raNjXGV65zilZjh8Y?=
 =?us-ascii?Q?asCGAcZVfwvqQgqEMs5HT8o+knzG5BL1qdIwvSYLo2WqfTr62mGgJd0gBl0O?=
 =?us-ascii?Q?WQSqLI6qn3YeGWjXRR0xtw9qAXM5fF9gf7pEtj6YZTsDBgXvux280md0Nsx1?=
 =?us-ascii?Q?8x9lCCmy1a64k1A/aQ8k+A/wKYRnnPOTQHrbm+FNWxr9CTaptp9LfIn6Aosm?=
 =?us-ascii?Q?vUUr1m+8dOWzaWQQMG1YUYKnjWzZ38AjWFN6tQi/2Ne+aYUFSuBzhl1/mjFL?=
 =?us-ascii?Q?cQ=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 
	3LoXTw3+mVnmWqNNttwZ5DIzagIGvpzSEOV3KJ/yKvzqanDqT9FQh4ShkEQOjsqwstXQ+7slA0lNIRoW8SeytSuXmbtwwzsls23T88fiaXRWlvYotc+tx33lZY4Jme17hhqlWkS1yAVHjIohEUWwoAoxq5AFMTLlIOaapW3cGmZ26Op7rFAu2vkkI5u2sNSkV43DepJfDB2tL4doib/iz9Iazq6qhI+iAFL1GbwIZVst7Y3qSF2iERQeRdVDF9/YgvhEEAN9OKVpXP8EA3vcU4O4qo0fZWBc1vAUqL3ahqUxyTM0/I1YAt3fCCzy0eSGI5zabwhB0bz+1Gi+3OX/juSQtrHEsoTHYXIXMfpNhAD2HdfuyGoX+nk+AarTOagNJRqJySr8sF/7ctTucl9fCaQ7SDiuLbsw+IAdTh6Gekm8fbGYoa4rk0SlSJBB+CXqR7VoYAIjyPjdmVp62nn5EAk1JP/HVUSgu7gqmjzurvv8KVbvkqMZ057y3XXhvksPwD3c+kVl0rcDmNE2euvILBD5RrUnDlJqO4oaUVkEhsUbvu9ckuXGPn5V9+Sbr3a39r7D4ly+WGpt8YGJZnrnzRXroymmxZSMtiZL8C5VPy8=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c8e2890c-25cb-4435-5342-08dc7358c4f7
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2024 14:27:07.9950
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 4c0tZUFTq2fWDq7sAKcJoS5qthd4hNkMh3CF850cx9BqotSC++ydzMSH8CDA4PBr4RXm6NXNDEtzZWYra3tx/RCaq86B7Edp5wd+YOE8Qx8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4676
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.650,FMLib:17.11.176.26
 definitions=2024-05-13_10,2024-05-10_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0 bulkscore=0
 suspectscore=0 mlxscore=0 spamscore=0 mlxlogscore=710 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2405010000
 definitions=main-2405130093
X-Proofpoint-GUID: BCMHL-2soONYjPSro8qn9UCKKf-6AelA
X-Proofpoint-ORIG-GUID: BCMHL-2soONYjPSro8qn9UCKKf-6AelA


Martin,

> Would it be acceptable if I resubmit with myself and Hannes as patch
> authors and him in a Co-authored-by: ?

Given the nature of how this patch has developed over time, sure.

-- 
Martin K. Petersen	Oracle Linux Engineering
