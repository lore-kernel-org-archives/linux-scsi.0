Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45C2AC433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 04:48:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236030AbhLWEsf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Dec 2021 23:48:35 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:52642 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229704AbhLWEsf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Dec 2021 23:48:35 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1BN0jctB026407;
        Thu, 23 Dec 2021 04:46:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=beke5z7DTwS8UjNjMmwgPB8+n4PzyKhk8Yy27/ZNoyG0TA1RlxAAu5f842Jluyw17+yY
 oJS11VHmEqyUIm4oqDPoZHucmaJMXL3e1anTb3Qjla2A761KYeMr4yiVtxVM59LBc7gj
 RViBiBJU8Yt+qYttiTBYvsujbNgeUmlmd9nBtpmyoRvEMHpRVX7Zs9A0UPkfqNB2I1Rp
 80e1KbjCOyZhxKQeditJF/molup1VM83nbF3jfS+QE8JyndqLV9wLHGSze36TFFQWdMS
 Gx6NVl2KU/1MYUNSV+hnXyqtBEDx5EfWc0Pd2khv7FUWwPO1rJNVFI2s+V6x/gfVeupV ZQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3d4103a0qm-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:32 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1BN4eXWE066393;
        Thu, 23 Dec 2021 04:46:13 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2173.outbound.protection.outlook.com [104.47.57.173])
        by userp3020.oracle.com with ESMTP id 3d193r0agd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 23 Dec 2021 04:46:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DeJikHceRBZHsRcWBkqtz5dDxUah86XPAvHkMQqbgDWy+lsi0DR8Fd29XaU8/yL8JwsfV2HzhZoKfF6tx0oIas4isXNyf7dH6L00e5riF0wcepQueWR9y1tRpJ0LRw1iJThcFYjZgsoxwYyn7jUdzINcjIILJz96spJ12A/HMRlMnHU9k/N6pNDLmyt9mffgA66WwMi6DU7gg4vr6JWeLZC9z/pcA5gixJW6AamJ10/5tNROK4aIA1g6xzd2+LUOJcmoFwSWPL9hZWtYaz3+6JddEyOMk41e2/jpAGzREXAamxY+3yRZC1NEVLsHhCRKi/uOfAjX8bjOzDI14otomw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=fbN7bG9w4OMuH4GBZ8RctzWeRD4KwevCYywUB2RIZoR7zF0v+FX/6CNS7vFEEL+gNDQXCOQwoZV/h/egThaHzF2kse4EmyHVoMhenpaxWzUfQaELo6/2T/WFgZ5Yl1ERimnxrj2WsNtVuqvHuHfJ90f4Ltmkhv6wIMFd2PkBsh1VQ4DtSY1sclX+RNi+p77iYNy8bLmuCLRJrt/gZqwQTv09/CHfFedUMx+RLmrKR7fG96tBLA7QxAo1Vb4SgcB13njbCAarrUoiXGztWJrbTi/ovxhA0A4tELPGDCsPbpCQwJkeGg5EIgob4hET/L8K+scz69w7Zz1z/3cJLupPZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3HcyYOZQkJLVInvFYlZf2JUWCBF906NIjzHSOdAENgU=;
 b=GP6l834uRYRRKAUb+H+p7+3w9yeGa2X3XtpQit8ENKQ/Nt3/Ze0M+rzC3fnUK+lJWNL7AbVLZT9leJ22kTE2wbJ/9cn5XJJzy4jkMXkUxqAgeY+d53HE7M3e4AdVcd9u1Lo/SIa+wst2k1/0BC1Vm2YyZxRlKdrjLCPpcznPU+A=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4599.namprd10.prod.outlook.com (2603:10b6:510:39::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4823.19; Thu, 23 Dec
 2021 04:46:11 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::f4fb:f2ea:bda5:441e%8]) with mapi id 15.20.4823.019; Thu, 23 Dec 2021
 04:46:11 +0000
To:     Christoph Hellwig <hch@lst.de>
Cc:     martin.petersen@oracle.com, kartilak@cisco.com, sebaddel@cisco.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] snic: don't use GFP_DMA in snic_queue_report_tgt_req
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq14k70gc8j.fsf@ca-mkp.ca.oracle.com>
References: <20211222092048.925829-1-hch@lst.de>
Date:   Wed, 22 Dec 2021 23:46:09 -0500
In-Reply-To: <20211222092048.925829-1-hch@lst.de> (Christoph Hellwig's message
        of "Wed, 22 Dec 2021 10:20:48 +0100")
Content-Type: text/plain
X-ClientProxiedBy: SN4PR0501CA0026.namprd05.prod.outlook.com
 (2603:10b6:803:40::39) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ef2c88c-b41c-41d2-a5c6-08d9c5cf2489
X-MS-TrafficTypeDiagnostic: PH0PR10MB4599:EE_
X-Microsoft-Antispam-PRVS: <PH0PR10MB4599AE8514907F231C48DB918E7E9@PH0PR10MB4599.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V5PWJhz6Hb4CSiNYWbr+bZ/s5esIklK54KMUl1hxlnHWaJxDAR0DpnaBo2VphFJOzUoq8DRuAmyytkw5G4V+N8oZ3z4BJnAMPR0botPMhjwAX6Adqu5/nMRCm93rvDQHZLGbZM7sJ3OdnRkYwvQ531jLzleHzyGU5X0gp+qj6WkGlXItjQnPK5BVXofhIPcCHQuHMgnIM7lAkk6S359Ly+S409uaI5JqH4GO2o08AZnR24RiJTHj36oA6lRoayWlcCy9cIqSDpqvCvrzfRNuJ+e1nQnFP1dQsY7D8bzug4XN6rOlliX5UWmQ4295ongGoSKLwTu/giZlVZ+hG/gFJvSanz9hFaRSHg2s5UUJ5lAEzJB5kLaaQ1J38+3j7fzOH+RgZ7FMaet+ibYyA1urbzQvP0+N8NTXk3ibwWqCcsV33Ekh6AvzHlSTs5VDynANd+hu8Fwnq8LitChRoa8Ilx5KTIjjVfY0Kqz1yOezxJqVT8YNDZ80i7L5JHC2e2MXbTj8oe+Dx0/YSRn8n9Sqrt739py8gnEdmRCBfujSnEwuJS4y0rQuqe9SWt7WKKY9CiE1kwzfKKjioPDZP+UPnPsEl458ScOZn3f/wo/xuzLXHH7azzfynyTGNNkRdisDBW1EyjXcodAysGZRlHqg981Kt7WDoS0L42Q/2/m3586I89xJuXGqI9d8DcZOqJQDhkRbp842GYZyF/4veDez2A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(8936002)(2906002)(66946007)(38100700002)(66556008)(38350700002)(8676002)(66476007)(4326008)(5660300002)(316002)(508600001)(6512007)(558084003)(52116002)(6916009)(6486002)(36916002)(83380400001)(6506007)(26005)(186003)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?crWAW1KWFNqc74q8fOwIc5LL0Ky9Jdw5mvvzzipVztf/rRNBV+Rr2Wn0CEOu?=
 =?us-ascii?Q?DwHs7i6eqHgu84tqDW/fZfQdCMrR545+0U5xHdDo4lmv4tM92d+/YzDR9IOx?=
 =?us-ascii?Q?UBjNms4o3eA8kj+2Mgkh+jDSCUW8bXJE1W8+XT3N4PV9JdISg3rRgHMCkIfk?=
 =?us-ascii?Q?EMCfQf+CSSm6KWV3fr/noGXvVnGH4cAUdlc1CRMQhkOlAZuCqzipHv6aLaJH?=
 =?us-ascii?Q?XHkuRJC+Pxeux1Ow84LPFgUdZ03rnMX3GwEKqV5JsjWLd+ksKO4p8elwXRNm?=
 =?us-ascii?Q?KCZ5vv/MpvwCDGfKya02CSaqZRkm5MCWjZg067kBVBWXnaNgDeD6Ai9u32/g?=
 =?us-ascii?Q?Oa+lA9ao94XeDkqteKgsSajFPaFuNbSrSAVxxmXK4RsOPHLs9qSTmfgAylh0?=
 =?us-ascii?Q?b06g9zqGc7Hg2/Xi2Vgtbnw2JitlHjLDaJiDsLdGK+iSpdFfzM7g+b+6kXUL?=
 =?us-ascii?Q?HEQ6MLVAirjXWGt5kXUAALFXezkhwQps5LU6wS2JVp7y6U9O3xSwTqdX5lL4?=
 =?us-ascii?Q?7Xil42O+keddS6fQmR69cMI7/Aw641dV0IN65tW1sVFB5Qtmz6b/Y0nETQK2?=
 =?us-ascii?Q?20Ppkz9CCAs/pSaEpnc+ABsaEyv8hNYqZMl1SGNM+ei1zxUSLdhAwb07UkYU?=
 =?us-ascii?Q?Ye/wf0DfKpuOIZrI0A1pjX7+Ko/kE7h2hMWsHPz+AJckkZdkhoY9jKRscFfR?=
 =?us-ascii?Q?Ju1IWGpsTLE5b8HQMYN3XjGhlw+lCGC0khTWMYKOrLFtIUSzgY6CRYYnlRqU?=
 =?us-ascii?Q?eHUm+dzQUChzpSi0FsP98L4L1RcYjKgoSmZQggt5wM1qkWY2xNfAXpcUsr9o?=
 =?us-ascii?Q?A/QVdGvp6O2j0am8/REQY2kOpMvfpwsb4Krehc6NcBtYBNdi8QU7ag1ep5sP?=
 =?us-ascii?Q?L7Y6qGJxk1BtEdhF/ZD/u/nAuTf3Si4XhHdS/uRGGJCKpsvM3OKaJ86PoKhB?=
 =?us-ascii?Q?+JBiHNbYExGaBVtZ/Gkh9S7qwI+7CQlx6mB3nKx4lHIO4pE90Jaw/QsDWKpu?=
 =?us-ascii?Q?5evTUQDA6KIynwsAnhsMevksU1Hs01z6YTpwsY+HYLtEmw8ipFPvWpmJWMfw?=
 =?us-ascii?Q?zkVH6Ma009Ghay9ALKjgkTm2tBrZfrdfRP83JJubMFQupcl8SnTEOAVm/AFy?=
 =?us-ascii?Q?JTULpiT59VMUMS7BL1m83xXkzyJtw/FJpzN1PkAhBl/oCWCJbS1/Ruoo8Yoc?=
 =?us-ascii?Q?o+j8y1pf8s7qAq7WhzM21+GgsYTkJT1Kf6iNBFa4HEuCcn5wN5VKj0uD8t1V?=
 =?us-ascii?Q?hBrdlt4zXmmCG6CUJGBf8Gvg+zzQw5jkDkr5Ha+XM4vBigm7DnSdbxCwuHVG?=
 =?us-ascii?Q?MDzD81GClrW6+4zpxKR5iRuVQP6tHMdCnpUCSDqgF+eDlMBCBjTHlz/O508s?=
 =?us-ascii?Q?1eia82iQA+XvPjorUBBTVAZZR+4tr8yJuQ8j0/5XmpQ6k3v6bF5g5Xj3znpZ?=
 =?us-ascii?Q?TUMAc0dyYnqkDJluZAq4FnQ7/Z4QWXXLXEWuj5lIVtV5jeFVmVCcLIf+eal3?=
 =?us-ascii?Q?sQanO+eXST9hnOuZsquybJM+Cf9Hw8VG6tmBkpDpRUZ4cMSMuf+5z9codpj/?=
 =?us-ascii?Q?sSws5XlMbOGtlhVbjNgllDPearHBAsjBNoXs/lEcZ/P34fVBcinN7hZDW8R7?=
 =?us-ascii?Q?BKuMXaIhEvy0UP3iZLhyVrJr5olzou+OGtEGDZLm7d/dvt5lUWmkKp3P761v?=
 =?us-ascii?Q?zUYL8Q=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ef2c88c-b41c-41d2-a5c6-08d9c5cf2489
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Dec 2021 04:46:11.2163
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: A+hrPJZyv660r9shKUWgo7y4xR3rWWjz35Zo8uCw9xKdPyg5ypY+GohnuaQ9KKqfLUiyE4IWKHd6pLz19ucJ48CYh14zDt6TuknAMelYmcI=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4599
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10206 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=677 spamscore=0
 suspectscore=0 phishscore=0 bulkscore=0 adultscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2110150000 definitions=main-2112230024
X-Proofpoint-ORIG-GUID: VKAEV2nB3fa_rYOU2ehJDLGo1qL33o-V
X-Proofpoint-GUID: VKAEV2nB3fa_rYOU2ehJDLGo1qL33o-V
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christoph,

> The driver doesn't express DMA addressing limitation under 32-bits
> anywhere else, so remove the spurious GFP_DMA allocation.

Applied to 5.17/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
