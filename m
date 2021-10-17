Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 892CAC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:20:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5917B6023D
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Oct 2021 02:20:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244828AbhJQCWx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Oct 2021 22:22:53 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:15464 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231467AbhJQCWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Oct 2021 22:22:52 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 19H07HYR003947;
        Sun, 17 Oct 2021 02:20:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=oRNgf3Zy2u/TEVERvRUvLsxjZbPwF9nlEnkm9811cOw=;
 b=GNLG3JDSTi59BpQAX+s0cNYkNzuqZoYrO8qFYYs7UDuI0L0IiMveaIs3octknwIwDSJm
 shln0DtKOZWKd5PFFfqn4XzUPc2QkOLQWXwjKl3A5useCe9XMGKhoY67ocF520ZtoTcj
 uTgcxAPYKT+IzzCAn9VSII/NRPPMh+nskbYCpINZMP2xsHhiJxQ3ahJP0d1UHU4ztPU6
 FoD1Hmmf+ymfiNMrUdiDGB/mJEZNB12Jg0/0UAkqf6VCH/1kMAMMPxuFLLyv41tD1k8K
 ohlOkH3Db8xlNgROPaF3bO0eelE0Kvrn7bRPiDRc4tzpMeeoZ8MG0XfCl+NMZAXsqwdP RQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3bqqj6sqee-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:20:41 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 19H2H0qs098042;
        Sun, 17 Oct 2021 02:20:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by aserp3020.oracle.com with ESMTP id 3bqpj28cxq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 17 Oct 2021 02:20:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HNvga2etLVTNsnj90M8boGeJErM6NVkUJFz/Ioyfn/Tv1LzBozJZonq9lH3INtI+TtlTlGWTN9QGbD9PXerDV0AcTGgW/lRivTdKcR1M/VkMdaytpYlwu2X/KaYN+Crjz8ZKxeGGh5wsZStlApIZIOuyQvnmYlY0Ry7XQgyqtu2dlNm1cMUO/PkubPxQQWyiEN7bC3kMAugbzy08a65xgCjjZF+kdbew5oZ/0+dgc1SUc3lHSh7vMyD4ll5SMME1QQbqbmo8Eg7MYqLBifhu+vuNzKxbkOpQjfv+hp7gdvHoOdb8dWkhuk37iS3W3qNqMp8LdGgyZtWi9d07LsOakA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=oRNgf3Zy2u/TEVERvRUvLsxjZbPwF9nlEnkm9811cOw=;
 b=QU8WQ/arIlHfF0ClR9pGfrujHCNoSADHk90tWvjwd7kGntRD1rPqigh5In9zdE8zNjxBLIn3jtM2KnB6ebk9Vwj7dQ9iSN4jSEmYtKmgB8vuUzALH4XPdAL3JzdiZ0MTUbQntNwhu79MqpiubHJRFplkFgtR2QYF9e5YDM2q5GYypBEZV44Afkx69xHpztIl8gLLLDRdV/QC/goknf23jU1qXX7dywSZmkY4ygIulCdPBFmF7rbzTUIX+nw3nBj6Gvnp11VxqyA6FQgNtjcNdiuvD+aGS1/Bis1iHSK8B9CzqncY3zZnZZGFqqGbL73aDEAsEGLl45yxerIMq9Aqyg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oRNgf3Zy2u/TEVERvRUvLsxjZbPwF9nlEnkm9811cOw=;
 b=ccZL8gGr/RkokbKekW8JxGotyVgzp3EuaiWolavl2SuqJhKMbEzAsZq/NH2gM+xw2bvTiPnTXKkmnSIi+6MJjQUVBRdocKYP5uYOIx+LK/q98IOvVpIpkBPxmyA34WYLQSUk+8+z5xGhSCuwRl+4NZBbP25lHpbwd5l5lDHuGlw=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16; Sun, 17 Oct
 2021 02:20:38 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::a457:48f2:991f:c349%9]) with mapi id 15.20.4608.018; Sun, 17 Oct 2021
 02:20:38 +0000
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        mpi3mr-linuxdrv.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: mpi3mr: use scnprintf() instead of snprintf()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1h7dggzo7.fsf@ca-mkp.ca.oracle.com>
References: <20211013083005.GA8592@kili>
Date:   Sat, 16 Oct 2021 22:20:36 -0400
In-Reply-To: <20211013083005.GA8592@kili> (Dan Carpenter's message of "Wed, 13
        Oct 2021 11:30:05 +0300")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0401CA0023.namprd04.prod.outlook.com
 (2603:10b6:803:21::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.5) by SN4PR0401CA0023.namprd04.prod.outlook.com (2603:10b6:803:21::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4608.16 via Frontend Transport; Sun, 17 Oct 2021 02:20:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a100d38b-b9f5-4a58-e7ef-08d99114b5c3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805D88026ED7A148DDB96918EBB9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: G0UOQ0Hw7n8iLcajdFKqEG/39LMUWA+ce9k2/i8QkIs2bOihFYplhHuMafKedKNnMa2ig7XpjmvY3D4/cJ+nQFN9POkWPBjlI3g5eS0AkTubr83Wc7e2n00eLSlm8yBRdiLhmgnAAVRu/N2wccEAGl1zThiWnFlKuKtDlvCHq2nGgpoqSblSVrWqCWvvMcS2AIHncw0VqTA/UocCLUEMxonrRU4uWFpXAdyDDN8FrWhpulQoS1Xy2JSHK73vLZ60QmuXPUxhY60zPzHgWBGmfqxmQ7sCOCW7ULygG+HiX53NiSsZqwVo6KS8NzzD1Pz3AA1Mh8kpcW0UhVizN1FzwpMUybrZwGuu57ExzwQRsI87ah3jtXgAxRs0M5onrOiNUwfnWLzNZtBeVI2XAX1KU7p3r8NrMdLOUenLooyvihxy85gIozWRnwp/dfx2A+zyPiKR3QDQpObHkBfWHE7g4RkC9rO8keSHCgKLewdiaVO5SpHJOXNPWq/MFW73b3Rnjyv+mn80zpql+NFrXqfWN1pN5rG5g7gLyX7U68kg+zxpf6wdB0dUt8VoRAXRTcbYS15n0ZMIqOp5bZ8wszbDxKVE8YzUZ4mMr5EbAOsqZ/oJw0O7xOwii5wHV0gZ8opYjKwdrIVS3C4ZmumO39TAd+0uPxSg+RIh7MraA9CrIPAWQ2Dx/E4Y7N4zDAn1ILfsxDZpf0wwXFRmJD//zGx1T6ZCwsFVFkQwie2bcca8zWg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(55016002)(4744005)(38350700002)(66556008)(26005)(5660300002)(8676002)(86362001)(186003)(316002)(36916002)(54906003)(66476007)(6862004)(508600001)(7696005)(66946007)(6636002)(2906002)(52116002)(956004)(38100700002)(8936002)(4326008)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?J/pp+XYpXRS33tIFKN2yZY2ubU4MwUiNXe2G/5w88kGH89rNZvt9BoQHKWdW?=
 =?us-ascii?Q?LP+zQLGxVgR/ejhDhG7vSL68k7ayVS/KB/56IL6BoU91Ym+J0SVcBZAyh2GE?=
 =?us-ascii?Q?xl0YzUoyU9A38TGKjYL8iJq2eHe2tLSrOvzy8vRxjG6jHG4sguOegAsOog2f?=
 =?us-ascii?Q?fIvFA5uOlg2cGW5vkTtq5vJwjr2mrDyWCAjS0dv7KDISZg1SaAdATOqZF806?=
 =?us-ascii?Q?QRUJ5bZPZ4iu/U8RYA6q+uvJp+MahAH6lP9QqhqIf+qXY49juJx+9LDO2x8S?=
 =?us-ascii?Q?I6WJFHEZudTQ8z2Mgkz5gfnglzkH40Svhyfdk/knrAMzpgT3vz/Qfufa/vk1?=
 =?us-ascii?Q?H6eKl+hvScMyZZe2OTUVfoHCrFiG4cjWOD0EzF61IcfKfqy9e7z6KTaYoQ9N?=
 =?us-ascii?Q?UU6Ns4Oo3u/1SfYtr6M+682PdtFN33JRIwFxAwETDE6RS3ukecEEdfPymJdH?=
 =?us-ascii?Q?q5qM+NFjsTcYU5FFNr9qTtZlfHQyMgBCe4RvUOeTXWkbuwFOJnbQ9qx0tORR?=
 =?us-ascii?Q?TapNVN4fpTClJS4iT0OotGniCcoaFBIU0dSw4tmzsWpbkRct2FwSeWr8f6qm?=
 =?us-ascii?Q?LnxKqC18IK0b8R1NLbWLMemWRjrLq/2QrxgX9QG2pbPmifjLZkeA6tbYw/2Z?=
 =?us-ascii?Q?GbQkzaL7FwEIcKJEt8QNTm/uK8kxWeBsiv+OwdZ6HsykEut915Im4g3EJU3F?=
 =?us-ascii?Q?YlVOUxgFpOQtrhqKlfZzEAiHc5RM7PB0Cc3Hf9qPGSEXg69nN3tYP1UcPpR8?=
 =?us-ascii?Q?elpTv5H9U+zZmxdTy6mHqsdUVUxDP5uhnmmQYOYpTDxlrlAOpGFF0UCPlusK?=
 =?us-ascii?Q?aBwW+olTM9uVscGuKAUY3Z+JnqcEfh7vPGGjQb2wfwjV5Q+x8bswHhpb7pth?=
 =?us-ascii?Q?CmUJUHzfmCKPLJNYGvvvDk3+QW0OzQx0St/gTAJJEja/x+FhL8CMd6LWO5Gt?=
 =?us-ascii?Q?D+pIXGrJ/Szjv0XXyQ2QIDg+6+hZT51UNfrASFGw26bMVFXzkJLu/RDo6UR5?=
 =?us-ascii?Q?iJCMQ5zkUONMIOyBQkJTwvD38Ib72uk+qjO73E0lFgh4hVWJz8oQ2c1+afy7?=
 =?us-ascii?Q?nn2wk7pehyDWUTrokVF3+m/+ZvqHCdOYxuh1UE6hxSwlD2Tn2ShDMHSTFd78?=
 =?us-ascii?Q?HP4qqO0hjBC0G73TcuPuXZy0KfJfGdy2f6WNP7No0vxTUgg+PodxoWBX/cqi?=
 =?us-ascii?Q?FZ69SbOkMU3tPna4YXYKG9g+BrsYXKwznu7SGJ+t1iclEmGZCqSQNfljysx6?=
 =?us-ascii?Q?vXq45Z7gam8Ljv1ZCwkMKs7tkQQUeHWqvFzI4FkMrLWMCS/QFSvmoDSP65J7?=
 =?us-ascii?Q?saBvLYJYlGq/dabS73zXtEvC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a100d38b-b9f5-4a58-e7ef-08d99114b5c3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Oct 2021 02:20:38.5420
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q74XkitVfYz1olBC4f/FFr/IHsokBcqYQ4/rgA6fsLp6rbtoeQY1DfQR1iUYYbu1EDz6PM5Kz6qp9cIcykUDkPBrLBo/61Tz0sVPfPx/01w=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10139 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxlogscore=909 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109230001
 definitions=main-2110170014
X-Proofpoint-GUID: k0c1OYjeyWJI8ghmK6UhTq5K8GNB_1Dm
X-Proofpoint-ORIG-GUID: k0c1OYjeyWJI8ghmK6UhTq5K8GNB_1Dm
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Dan,

> I intended to move from snprintf() to scnprintf() in the previous
> patch but I messed up and did not do that.  The result of my bug is
> that it this function could trigger a WARN() if the buffer is too
> large.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
