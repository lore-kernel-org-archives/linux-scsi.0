Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B6C47347A
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jul 2024 00:37:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=fail smtp.client-ip=205.220.177.32
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721695056; cv=fail; b=Q10nyJVPUHb5eU2i+4nnBnHmDqpb1LukmuVMn/Ku3Fo0Av7Bpl+Fxil8cQCHkgSCW1kYNebQwBSp0ezKXl51tGOrsh1sWZZRWJIBmnXoS4pdYvePKovXdIJVJgGD0XZlihrsUmlKkES1dyB0SnlPg3BY1l6dPwHwPvbkbbUQ4Nk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721695056; c=relaxed/simple;
	bh=5kMq07biXCpfpHO5t0yF3Gt3XHXuzdPGQA+Yu7AUtg0=;
	h=To:Cc:Subject:From:In-Reply-To:Message-ID:References:Date:
	 Content-Type:MIME-Version; b=PJjCei7+kWYRvkUnSg+XOOlT2mi9k449QBnl8JmPSRrbDUl9bChYPABBMcBREP6UhzTEnb5iM24SjbuRXzhdxZi/NNxU0i+x5jYlNRn8n7D8d5a6GdnEkBK4j1HfZe6fe1UHBvO5CHqGkeD9Vbc/3DZjCV34+oN/dZ1wXdWXBC8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com; spf=pass smtp.mailfrom=oracle.com; dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b=Jk8KA8UV; dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b=PXEsnaoa; arc=fail smtp.client-ip=205.220.177.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oracle.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oracle.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="Jk8KA8UV";
	dkim=pass (1024-bit key) header.d=oracle.onmicrosoft.com header.i=@oracle.onmicrosoft.com header.b="PXEsnaoa"
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
	by mx0b-00069f02.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 46MKuNNH030401;
	Tue, 23 Jul 2024 00:37:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to
	:cc:subject:from:in-reply-to:message-id:references:date
	:content-type:mime-version; s=corp-2023-11-20; bh=8GN0r4H9BoMHNi
	mNvdKgWIg+k2YGNZg1BKvmNHeWNOg=; b=Jk8KA8UV4SJm3wKmWKBtf0eVTH7nkV
	9ndUJWx6JgephhACs1j+DOLcNM0SBWmqGiHO7aDKWdYJd2N0I8uMTFodhcBh+Qp4
	+h0oAU+zf20gbNfmpTmkALn3VB2TWdhJ5ZwgKEOTp5FBsmZ7X3xJwgV6uCoovZ7P
	gMSQ8UPcg70LWY/gjqi+on6RuYXRAFfeoeKMKQMZux6XEJvT7PcGW0F7XmtwdDae
	+rbl96fu8B4Yd3iuh3PM0rlEzLWlf6mCuQSHxU9gVRuG3p+s2b2SH3aa73bzjqZ9
	YEfl0dknwYkAVsY6jtmiXhL/hAR1EmesL/wpswLebxXHWxJffzBJ7+Zg==
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
	by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 40hfe7ccdy-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:37:22 +0000 (GMT)
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 46N0XwpF011020;
	Tue, 23 Jul 2024 00:37:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
	by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 40h29qfxum-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
	Tue, 23 Jul 2024 00:37:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector10001; d=microsoft.com; cv=none;
 b=JGGKQzWT7YTNTZZMejzwwzTb24t9wXmDjQRxeFpIUTDC5brF/vSDbpm84wpj7VHuLo7RT2iyoVZ5toJRhR4bPcvKZVvbwwCwnfeo1VBI2GrvoqLbUho2VwuA9ZzuBt+wbNT2k+H3d3ZESTh6xpLiaGHR2ImWChi+cSavdZ3H/UTljclsaBPC8SDqbFe+Aie5Rq9wHrYefDJf9qjMVddnn8F6DKIDs7YkRQ/YDTeKdKw9j5DtRRZjJeyN7Q5oo8AOelMIYKv/cR5nfppt1nIJUsfGTJ+UcMv2Na1oXIs2y3dVUGs1NMXhLHS0linavgfWKUYAhiwTtAjMHt97DU5Oxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector10001;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8GN0r4H9BoMHNimNvdKgWIg+k2YGNZg1BKvmNHeWNOg=;
 b=VFBV9UG21n+qAjPLNPdxXNkkkAqhOZ4pM7utHAogaQO6UaBgZw+zberbdJp0lIiK1hziqazVGffKET+mhse2ID7g+sD+fsoSbVeYO5qM9oy/yNpzH28NIacfS1+CgIgxlFS4XZZXWv/BsR1V17g0OZ8DBPJn/P+4kfeJq6AUAzIfuftjwo1Vzi8Fu+HoPg2WtVoL0AY14AEKSI4wpDLRKop9AF0SByvMWTM6NWAxkRApa8+2vslkjjs9gM95tPqrZ6/IF2e06nz56fAaUDgR8W2JZT2A7glQHKF+Yy9DlxgLGJP18GPFmdrNssW1Ax0y3cRoe/XvOlE5if69DjbOZQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8GN0r4H9BoMHNimNvdKgWIg+k2YGNZg1BKvmNHeWNOg=;
 b=PXEsnaoagq/vvB8XPEOpLIq/pmbOIP6/XA8kAMLawG+fSWJm4rqZhOpQhdvqIuHWLfv3amrRwor7xV/bEhZmPrP2PUd+WfpDiJTHVXEpHe0hSKI6hr88hbmNhBKosZRjtLTt4xbSkuzQRNBXSlJ+qb/NbJZ4alhOw7ix3Q8ePEs=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DS0PR10MB8008.namprd10.prod.outlook.com (2603:10b6:8:1fc::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.7784.19; Tue, 23 Jul
 2024 00:37:19 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::5c74:6a24:843e:e8f7%4]) with mapi id 15.20.7784.017; Tue, 23 Jul 2024
 00:37:19 +0000
To: Damien Le Moal <dlemoal@kernel.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Sathya
 Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy
 <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani
 <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 0/2] Fix IOMMU page fault on report zones
From: "Martin K. Petersen" <martin.petersen@oracle.com>
In-Reply-To: <20240719073913.179559-1-dlemoal@kernel.org> (Damien Le Moal's
	message of "Fri, 19 Jul 2024 16:39:10 +0900")
Organization: Oracle Corporation
Message-ID: <yq11q3ldjux.fsf@ca-mkp.ca.oracle.com>
References: <20240719073913.179559-1-dlemoal@kernel.org>
Date: Mon, 22 Jul 2024 20:37:17 -0400
Content-Type: text/plain
X-ClientProxiedBy: BLAPR05CA0025.namprd05.prod.outlook.com
 (2603:10b6:208:335::6) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|DS0PR10MB8008:EE_
X-MS-Office365-Filtering-Correlation-Id: 1208f24b-d31c-4924-eeea-08dcaaaf9bc6
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;ARA:13230040|366016|1800799024|376014;
X-Microsoft-Antispam-Message-Info:
	=?us-ascii?Q?i+PusC4exNopIADWDcSVK+kEU4PwLCjjtSKMFxTse0gukzHzbwE8NYhMfWb1?=
 =?us-ascii?Q?gCkoSporN1+Gz23M2sbl150s6TJgL3ZYRAYGiqCJEpOxldvw8nFlHfAYzbZO?=
 =?us-ascii?Q?gVVMFUc5sd1yWKh3+Z1Htzo25u/59HLr7bMeWL7JjjSbzQ3N2r+gOp6ObDt7?=
 =?us-ascii?Q?25xpYcpZvZcN2Kz9rulErDjN4pBUI6cMAdJwxzw5vUrJtN38mydmksMJLVro?=
 =?us-ascii?Q?YLi2gOV0ofQhqjvlefAlnUrp0BNN3jsTslAClIZgVlcnCgs4m4XuTZxPBLhe?=
 =?us-ascii?Q?DN1NPlUL/cl0jpbVOlvhN/vsLWI1pI5PP5BZi5H/NONXz2o8nbfcMB/FmaW6?=
 =?us-ascii?Q?HbxDZExWSH5QyR/Fajv3wWdQ3hGfXMGHfJKrEOudBkjTE8m55Jkw/xxzD32h?=
 =?us-ascii?Q?sp7I5hxvi7PYloacXNq7erbfJcR2ckqsD0PhK45E1IHLju3qXl5doTR7xocT?=
 =?us-ascii?Q?gkBE/E4k19MY1+F6O17TaIo+owyRrQ1W6Z61h3Clstej9IhL6PO+3wf8hjFy?=
 =?us-ascii?Q?bY93fUxPMB9+0I0giNYNVTgXiAPelxWswxNBOf7bGzbj7ekeeNABbSzz5W90?=
 =?us-ascii?Q?NOeK7eVQ+tvdNBBoZn580stelQpGCgq1B6r7o49V1BaBoYzpOv0eYNmWXvH6?=
 =?us-ascii?Q?rW1+h0Xvp2+wNRSWrcLoQzNXKVO1y6tk8HNJKmLc2ocI0isNbBPFLvJaOG3E?=
 =?us-ascii?Q?P8ca2AbrFOsvloC0i9sNeJSuieZsupuB/UFwNN4nkaaNwmtYyy+Q1RkGlgPR?=
 =?us-ascii?Q?leFqEr1rdivsO2eVjtvl5gEjVVh8Xt+DGfgu2D7HyP63Zu/NRzZEcIpjb4Mw?=
 =?us-ascii?Q?AW1YeGaxPTWpO+31KcvIK0+RxdWW4oTc7IKB4ELjOjZLVNalAyxUntF/lw0U?=
 =?us-ascii?Q?4jN7D081Ekny/bCg7JPaflkdOUSD1moIMsmBNNQKgoHfxAXxCC/koDfgD+tM?=
 =?us-ascii?Q?ahpmzqmHuET3Rv6kI0qkP+Tew5zn3cxIohs4N3IbwxagBtG6AXX7S9p2y0Ga?=
 =?us-ascii?Q?DDtqCSPgbl6CnBmVZy1Rlnnw3bY+2q6qdl3Yvkn92ZT7akqE0FCSxiCsn6mE?=
 =?us-ascii?Q?5zevvSd+qx7h5oI7uxFFlfQPubIj1tGmuU84fjGX+Hum8C9VdT0YtWh2rhAN?=
 =?us-ascii?Q?5UzFnhpIHC+Ejf0NeqVhhV86NxT6C2mgFZqyOQTbWp4pU3zl/PfT8oEK48a9?=
 =?us-ascii?Q?zezQFP1Zx+2qRRf/g/xIDqC7HFuQSGy5XtJfrfVQGTmRFM6SPfaqiMPjlxdN?=
 =?us-ascii?Q?euu7QyEhhcWqtHoEQ1OaKET9mZ/fpwMcg1yBvyysVLU7V9Ks2yYzgLO5auZU?=
 =?us-ascii?Q?+L3/jpcEtPKGueQ6xZQ5d2w8p9ZKRfoCxJ5h9052bEsh2A=3D=3D?=
X-Forefront-Antispam-Report:
	CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230040)(366016)(1800799024)(376014);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0:
	=?us-ascii?Q?T77a7GBagkvt7jZnrH6FE4gMotxyApUcoewUtmyb0fJ3ifPmvpeG7204DlMD?=
 =?us-ascii?Q?RbNW14IX+QOfuWnjyJnmT6jO6N6g979kw6u5P1vgvyqG7gj2RFYmd0lmeHgH?=
 =?us-ascii?Q?uQ9/FvEFvLGeYoT0l2nCz3ez/uJVDj+79iuwpeFdDOBxLu11zolesMQDrrVd?=
 =?us-ascii?Q?Hv4v4dIkBfGvGGi4hhSE6EGU+UDdI7PBAoB8beQ7KZQr+CDRNvFKHdRMCcX3?=
 =?us-ascii?Q?FhJyiFAFT+TSDAkYXVTw8WiSguGa+bUwJQsoZKkm6Mz2iBYY8D12PqRLSC33?=
 =?us-ascii?Q?lGX61UYaPECd8yBCr++sK8SQCTf+FC/72bCFKvJyUMYLzRCWTx4EmTU/l838?=
 =?us-ascii?Q?edVSKyTHYFpj/tpnnCOBf7LAfbmvs7dPwZBXH1EbGIvWP0LmRM5+JxXxIBUu?=
 =?us-ascii?Q?rvXi+MOSQi0p2RkrCvE/OkNxBVyCgu3/tUp5YTasGTp2JCKecBrmLeNZw5ZP?=
 =?us-ascii?Q?ZLssgZPNFjCIU+Uee0M4zVyM3XMYCPD5mjreK0pHGECf4Lwr96xs/5dK7QNB?=
 =?us-ascii?Q?3vh2e1Glor19a8DIq9+6KHSPRDLvZdIVZuWoqPDbYnpMHkxbGRYx0GQJv1mr?=
 =?us-ascii?Q?jlzxZkPEixx9WHzffel8g2hXpgHywT6Vgn5MC0Y7cBJ++UeHxBVPSKI5i8sn?=
 =?us-ascii?Q?+jzZ4Ogb+mu4DN14J/biUezPre5XXsxXvZnKzPnAispplV4tR3437q1jqdVm?=
 =?us-ascii?Q?f1IxcWldMrucZrWgYz8OnKXnNdLOZ7mrpW1SoAyJrOLWYBfrlE0o7zq1Zcxp?=
 =?us-ascii?Q?Ww4uyY3AOjvS0rUJ0ZZrTwfM7wpr2NovrXDc/UaJwdcIJejyMqALYLXpXXx7?=
 =?us-ascii?Q?xZSeyV5NpY/u2L3PLHjW+JGL4RhB9WtEBYx5yzYx0dKgXrKuU/uoFcHZaNdy?=
 =?us-ascii?Q?ulI465thSYtzp/PR5u6aModWFpuAJXthW0mO7ghlknwOmZh8rvG5C+kipFlj?=
 =?us-ascii?Q?9Etx7PjqZt6IKc9QmdYM70Kf3UcHbb00BxXwerju3FcI0bDpPiYPBhzwitVI?=
 =?us-ascii?Q?hmFSuG3rZSvTvzYGfQ1VPNuGwR26aYAyJq8kO2olPtTswwQjp7c1+25XUQkb?=
 =?us-ascii?Q?NpSYUkNdy+aocW1S5Qj9qxd78I1zcgbtGTIRRkUs2Lm7Vc/Oa8TQ6nT7i7ts?=
 =?us-ascii?Q?urOFE2I6b8ejK3m9ccUyMarIny0ChXFiXMSA41y644RanvHfj0O5Lekvpvk2?=
 =?us-ascii?Q?hI6p9UpAVoGegA0wo90+t6xoVx7a+wHqAGs6prvcLwNW8duoTO1nCRvWMsCh?=
 =?us-ascii?Q?OFK55zxP7M4mV/TgVQWOlHOtSOb4LPiXaet3JWxXZU7hjBqx24jPwOupUr5t?=
 =?us-ascii?Q?oeLMv1VawBb2Jop/V/P/PRjALTe7ddzwRoHLTHqQDerOgMP7NNYY/DhphsRk?=
 =?us-ascii?Q?nrRII+sATYUMfUqc7Tk79kww2E6QhJ+K+2PW8PLWZWlVmfYyBhV2EuJ2II5o?=
 =?us-ascii?Q?QolH+FuG/KoCyxXV6FlbRxEEweEf8PKmIUhCyezLHBQ7UqRiGiYJQlU5kqK+?=
 =?us-ascii?Q?MriHuZvleyqfGkx8HzIQBBU7oNHNVs8yXYTKh54vNSIbxxtxDr6oUbgNEaHd?=
 =?us-ascii?Q?HrZAMSlTxoObTt1bXQHWODpW47fCVAoTyAS73svA3/OgEnfrSv8D52CRCkFT?=
 =?us-ascii?Q?pg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0:
	ruaC4CAgOFDrMuQFOrl+nICJrPdlIzAP0Cbf2gdxEG5xHB6GRYKtTxzczARrNg6izOA6iIG7hRcMmUkVzQj7kVzeuDT/BSBQR0tnOwp5UXk/ZdtUJK/Gh08veUyGt/2aV184m7K7hCFImfb/M1q9H5MGEv1tkmkWu6V1ypPGEXtPTMMTlzNOcAUjGCOmy/LcSDs5ZFvnje9THOzGbSa4JELUFfpV1pTRUpF1mO8Z3JsRGToZMZZrxI0GqnYcy2EfBBvBKGDdR0ulKdAY+rLRD23TvJkSLhmFOqDowxjtJ+OYay4Q1yMoKNWrEtIzWp3p2SrUfan8SxwFK89zHqEPX876+H6FZ5q3y6CHWnP4dKq8F0vDffuIuY3QFHaMjo4jS4z26TGMHbip5WvdF4gbeOEk2p3wgEw36IcFaqG9krla1/dpYMj4JMCMzDARuUCXK2yf4xYx2KSJ5zqv7yWqUU2jzkKe9H4bxYvHezaP2Tw6oishKroqkdrvwZ2MHe3VanKzjT1D0f2dBH6l7rmItgRGExI7GGV20PxeMY9/FZiWCOiP9dCLfHx3iVYtUj0/Z21RDzxbcJXH/yWr4cUHGCZn0MnpiKfGUWHZ9XRlx88=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1208f24b-d31c-4924-eeea-08dcaaaf9bc6
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jul 2024 00:37:19.0135
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: JrYVNCL9ZHJusebGX1fxepvhGgASHnh0dhV/dYU8q+eYwCxezu4+00vnwJiPjrNAeOFK9eF0iMJx+jyz8HLYJP4Y8nznVofC6LENYpfZML8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB8008
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1039,Hydra:6.0.680,FMLib:17.12.28.16
 definitions=2024-07-22_18,2024-07-22_01,2024-05-17_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 adultscore=0
 suspectscore=0 mlxscore=0 mlxlogscore=999 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2407110000
 definitions=main-2407230002
X-Proofpoint-GUID: xC1jNBF18bADDnqHshB4QNAdE65lAsXv
X-Proofpoint-ORIG-GUID: xC1jNBF18bADDnqHshB4QNAdE65lAsXv


Damien,

> A couple of patches to avoid IOMMU page faults error when executing a
> report zones command on ATA SMR drives connected to mpt3sas or mpi3mr
> SAS HBAs. These page faults happen only with AMD hosts and are not
> triggered with Intel machines.

Applied to 6.11/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
