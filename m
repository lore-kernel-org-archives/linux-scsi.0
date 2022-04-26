Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8251FC433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 26 Apr 2022 02:43:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242356AbiDZCqc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 22:46:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231448AbiDZCqa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 22:46:30 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A877026FA
        for <linux-scsi@vger.kernel.org>; Mon, 25 Apr 2022 19:43:24 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 23PM23Il025368;
        Tue, 26 Apr 2022 02:43:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=dFdwxkszAvGBR5pm1MbI2mFISRAQYd0wTw+JPyCYgjI=;
 b=kecyelS9qW0wXYK5MZ7CyefTl93lqVBO2zetFz+11sXq2l+uat/Is2uDfuOmKl5RbzBs
 eZrQsYStzAx12Lw51JOluP+bpC8loW1Rio3IAnT9FlyEwDT3JgKRFXGLwC7xBQ5+7Wo0
 dZcxa+zEFUk+QyBUkXTUJxoGKNy6Q7h0Yqvwc80VSvnBf3wMxgKZKw4EseoA+UeB5m92
 gz62kAhUZTO4eb5QFq5anwXt0HhYalf5px/Um97ihtCSCRk2aztitNhKcW0IXuCrsZG5
 uzF8OrOqBMWMy9jsHqZyy40Utnx0GeoiruY+meXjf1n7dmFkd8TJail421sdFuC5Y3jh CA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3fmb1mmu6f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:43:16 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 23Q2ewlo001862;
        Tue, 26 Apr 2022 02:43:16 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com with ESMTP id 3fm7w2uax7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 26 Apr 2022 02:43:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LJKTPRZxal0Q7v8U7h9rjHR9/GiHk2r25jF5bm+QnWesFwdb6xUFsxuKjEF7zO2B6eixqN5onj+Wz9EYbKeFl0vTR0TXdbDGePvrFrZwaQ6OrtCdonvvl3MSvXAO1JNNdKyPVwW5xrllPDxgAgL69NQ14Qkslim6xNSVgXNHDt0VP2HYtqCW4oPiZkG0/oF4hAmGfMBhRpQ/xN1xMPvU3wUP5+qRzcoISPnPUqWtEvhBSYN9kFo7gwUXYWlr7hS/X/VFLmqoYzoP5gIWOULgrCAMS8NCcReOtcNFzwk4UFd29V0eWgdT+Zy3Poq01UiP1eybwc0KuYI6HnElckJZjQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dFdwxkszAvGBR5pm1MbI2mFISRAQYd0wTw+JPyCYgjI=;
 b=Bk5oVskAXME8s07IuvrH6dNijjugmAWH0eugBDeqnR5O38/G0gO6kqbi2lp0WXPIvgD7pSupqj3XIWgTAPM+SiJtXv9b9ot0KOx5oBtfeO3FHFdfBf3XWosb2CQX9rZXgS/6V866JBo8DSYBBN3bjJQRc0tNtTxVfn6fcCg+15rkUUkcIdXOazj34te4LdBnpNPmL3pt3nAmfzolI31QIyhf5kT53zRuNhjslZEO63GlUowkkH2q6k5nlIABiILghP3Uw15mGmuleb+wAxZJTN74V/PrMmRI9+gu+cyWd4qVrpWzFbxZ6l70o4lKWYQwvpoMgmw+KWG8jxoYF+kM4A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dFdwxkszAvGBR5pm1MbI2mFISRAQYd0wTw+JPyCYgjI=;
 b=UlChbmBsQ9gFS+s0OeZIgNv62AHrMS135tyypA11TgwDmimG/R9XJEQljkresQp6R868d+Ao4diS7fBzHkMVNCEma854aonnfMTtjefrCxreLY8f450DeewEfRVQKuPprb2lypWZ796TzZrI+nQRGQLwWKjwg2zBfCOz7xC+csA=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by DM8PR10MB5416.namprd10.prod.outlook.com (2603:10b6:8:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5186.14; Tue, 26 Apr
 2022 02:43:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::d1db:de4e:9b71:3192%9]) with mapi id 15.20.5186.021; Tue, 26 Apr 2022
 02:43:13 +0000
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v3 00/28] Split the ufshcd.h header file
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1levswong.fsf@ca-mkp.ca.oracle.com>
References: <20220419225811.4127248-1-bvanassche@acm.org>
Date:   Mon, 25 Apr 2022 22:43:11 -0400
In-Reply-To: <20220419225811.4127248-1-bvanassche@acm.org> (Bart Van Assche's
        message of "Tue, 19 Apr 2022 15:57:43 -0700")
Content-Type: text/plain
X-ClientProxiedBy: BY5PR20CA0025.namprd20.prod.outlook.com
 (2603:10b6:a03:1f4::38) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eeff1e75-0b1b-404b-c0a7-08da272e824d
X-MS-TrafficTypeDiagnostic: DM8PR10MB5416:EE_
X-Microsoft-Antispam-PRVS: <DM8PR10MB54160709A2A06CC95148CDBA8EFB9@DM8PR10MB5416.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: azWgSyBJaDbm1aTEnk+9XcODUt5pV3I6tQ7qe3urTRyt+wDIImsMXhoxDr1Grvlh5AjGWUi29Wnmz8dq3F+figdl1dIZs69CcpNq3TxzLRw102zux4P7yGT39W/hK7Gk9FWo45Rjua2sq3pZMGHOLB0AbeCIR2Sd2oKppKwgkctKa5h6hmGBefU94lgxKT7ylcQ9ab08P59RFQYlKK005CCz2wC14e5vuYBD0RFJBPqMsuOqxN0DvprhzhJrinswzcIi2X/C6dxaO5aUXqMhN5MdbKpBix3FbmHwpZvKeO5zrMYgCcrJ6YlyVPHivBATfQMM6vNnJkh4m6Qs4+peiQy3OzZIsX9YuYR4lEou6y/SRyQ2/yxlMx3SxB9bscxQ4YpaHbJRtyml6UF9SAy3niUyyR7VSPXt4OYH4xvy+plfVZpxEJ+0SKqmQfSU17TGLzVPA1gxkZzyEvbsK4IdRIg+ls76KvofMicrD8LuWdQwwR7I8nR0RqITuAcBnmDVtuI+SjJfODCFdjukqYCa/kumWBf6W0qx2cas8QNKC+9CDuktDTuokRlMgPpf2/Oc9uRNOvwzIxGFnlf15O4RxKpFVHhZ7MBdbUale1wSf+8farfFbUvTg8LoyhwZmkD0xgHib9bscPBUCdkkU5Fwg7DCKFZkUytql2gKns1OPoDTOvl9+ZuTJaEWW9mv4iHh32Jp/aATDGh6s9Je8kpAEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(26005)(8936002)(316002)(86362001)(5660300002)(52116002)(36916002)(186003)(6506007)(4744005)(54906003)(38100700002)(2906002)(508600001)(6486002)(38350700002)(8676002)(4326008)(66476007)(66946007)(66556008)(6916009);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?ofkN0aLRwTW+6Tx/Qckpmhs8NBPWizFqTTUXDv0lyDc+MCMvC5jv3yYqJ2Gr?=
 =?us-ascii?Q?yvnobmFmEZDakxKbmOCUChTXdWwtPIMfOIvUrJgSFq9zbV0yDqqesTzmAP7x?=
 =?us-ascii?Q?lVcDtMjgb59XUszBgugOSrO8lTjZv2+xfS+EsVBJ4RtOnuf+/dNrRWMdwbyh?=
 =?us-ascii?Q?0wfFnnhosBiRu9x0b4At1a4RV3KY62PXhEGnhwJeLyyqNwVmSdBonvdx4AEF?=
 =?us-ascii?Q?zigBSWhqCWcmsaGL3W2OZ2HjYnAfSeinRdRI04ir1TOvrH8F2bz3oWJ1zhVP?=
 =?us-ascii?Q?qJsk8wDWmAjLiSfy8oneKn82TnNEP/V6t/G4MSZWxsy0vDchTsGQQboJz+Ew?=
 =?us-ascii?Q?htycrhZQzNQdfE5Ogjw1McA1iRJ2uJIrBdCE8IncbI/y4M5SqoGUEJCi104+?=
 =?us-ascii?Q?jU+6aI2VXEC67DwiqodSeUBi4nlN8dc8/oVL9djTIIcT3z5VOwJG61riXdZQ?=
 =?us-ascii?Q?aPYLP9Z6P3x3tE4+98uxBJLNaEK1aw+HP9IUUbnxcn4a4uA01iBfMQSIFFkG?=
 =?us-ascii?Q?TGlb8bNrvibNFvXYg9uRP7HXUcfHPdV7fu2++EWm3i2EUjQ7StYFR3v3UZLs?=
 =?us-ascii?Q?/IwZjzjAgGWWa4+L1/0ScH16CW/5Llh1KBuLrfhZeqATNYfTAQR+smuUrHZk?=
 =?us-ascii?Q?MJILAg0lOQvS2U053jmj2p//xu6oA+7WNsIMDubKsORkSefDFEeCX/+eC+YH?=
 =?us-ascii?Q?agHR9CavpbBscuSGsu7hDoMlOp2mzfnrOaA5duGcNJoqs/k2My4ql9hrH+d2?=
 =?us-ascii?Q?n41sRLyVJ+fwpr5RGCjTQSls2Hz+Wzb8xkwhafMLKEE3/FgLmSv8MRFqM2lk?=
 =?us-ascii?Q?/SDZ7fuEpNOBenQ9EdxZ2ya8UfyHw5e/BQUD2xiA8y+6E/rloAkoQKOLzxC9?=
 =?us-ascii?Q?jHCqouLf2TSlDxXsr+fJuGCYvrfCFlgndE+l4gJ4KDB4wAMCPFvMxdPgf5FN?=
 =?us-ascii?Q?d+jDTt3v6KJGAkcjgD6DiseM6PmzkiRimfmEvr2z3tnjTJ8ZydB7CfJ6y7jJ?=
 =?us-ascii?Q?aIAYE+JS9H6eP0w6gtlwMgcU2tAQ8+TrSKQ3cYlhMCBox4H8bUeJrNt/zNpB?=
 =?us-ascii?Q?xJGIvp7Wpqh5R9Ua23gaOnHnZoCqW84miU5TTCInjz8r6yya7mA2/zgnNfTY?=
 =?us-ascii?Q?hL7EA3mxPAxGmE9F7guhDqbrDAFwxnls9wC5/pLziitwTljGVKZaWhMSiIN+?=
 =?us-ascii?Q?NgxcF2P18TuXQtjcKb1kKxu3n4jZAlImA4DpL2ewl4pb460ALqPLmdC/pIA/?=
 =?us-ascii?Q?xyfti8tikhyhOidPFU3Cp9lYYSRTAcxafU9EMNZye4hiqzZYaUWEi35UlYhl?=
 =?us-ascii?Q?ADP2fLERsc6UzCPS+MzaINQTH0RZz66B5xcTM/bmt/tZqV/5fTfhjNd0iCdK?=
 =?us-ascii?Q?RQeRWXwz2GEZA7vyNiexPlXGd3pedijv5eXblP/Y69oZzHpza7NcfCFHdLLD?=
 =?us-ascii?Q?NSEKgd9DGIt9PrVKhV2ZMLriA5zg1ksza6WmIeLtiNT4ywr3R/Q8o9B9jmxN?=
 =?us-ascii?Q?tzxojp280iFaf0ixC8yjnN2vmLTtF1xL/Y5ztwOtgwSQFIS8yGeJJ5qh7qw+?=
 =?us-ascii?Q?IiOA1HxHapYR7a/iCJcUWv/rcQjKvkg1+Sn91B1k8LEq/RZIM9N3yKvQ8f3s?=
 =?us-ascii?Q?aHANc+B/DEg5tipg+1GNBSMmJxxPLXJjyGLowOxNYHdwyx+m7nT55DAmFsT5?=
 =?us-ascii?Q?/JC3U3Com0Us6wOgExyk74hyzMj1Nj8Fmmk81wdjxi5pHormjV9pb5oDhqL4?=
 =?us-ascii?Q?EuUKzaRtcn0ukjAa9g9/bN2WC/CS+Aw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eeff1e75-0b1b-404b-c0a7-08da272e824d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2022 02:43:13.6333
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qf1OHg9gKOWEiGga5k96Ie0vJeO+fMu20itNoFZ2ZbcEc7NiC5kKdyQoG58l/j+6KDX/Dt017PwJX/NQXS+GQlgjkXf0o9TjiAXEMzi3usk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM8PR10MB5416
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.858
 definitions=2022-04-25_08:2022-04-25,2022-04-25 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=747 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2204260015
X-Proofpoint-GUID: 9Obpn-TMca-DzELch-gr9d6cbAHR-8DQ
X-Proofpoint-ORIG-GUID: 9Obpn-TMca-DzELch-gr9d6cbAHR-8DQ
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Bart,

> - Split the ufshcd.h header file into two header files - one file that
>   defines the interface with UFS drivers and another file with definitions
>   only used in the core.
> - Multiple source code cleanup patches.
> - A few patches with minor functional changes.

Applied to 5.19/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
