Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EAED0C38A2D
	for <linux-scsi@archiver.kernel.org>; Thu, 27 Oct 2022 02:14:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233810AbiJ0COY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 Oct 2022 22:14:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54422 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233822AbiJ0COW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Oct 2022 22:14:22 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B67E77A9
        for <linux-scsi@vger.kernel.org>; Wed, 26 Oct 2022 19:14:22 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 29QLNwKt032718;
        Thu, 27 Oct 2022 02:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2022-7-12;
 bh=T2bAc6KpbI6cwxeje7srhqtI2zGxsyj7gEJ9utvLuSI=;
 b=b6w4rlJ5zHpdR6OqCWtuytOQ3vatSpTkoP0QQXinGC8lhB9neLG5qk0OhZA2na8Cm1zQ
 e+D2QS+cAIRb2tBiVVCyiiiTinyrlnMEx7LkhAB9ULAAGPfmDw/QUHn/YXc1pktyl3Bm
 qE2DbH1Xf8zbEXoKMJyQgMCBPXueKSq0Ek+B/1l7BEBNuDA7bYTpGJP8orAiTSPZFTHg
 A9QgOHvon6u/Zhyqznozz384JDRrPuMjVQLlBaCA5uuLUACSSg1+LmlVnkeCX0nGhebq
 qLQa7mED0Bv5HbmC06ZgPMGr4TLR1Zs1B/YGL+KwJW941Jfbqu+3BaJXBMSsCG2p8GwY 2A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kfagv0t59-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:14:05 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 29QM2quc026367;
        Thu, 27 Oct 2022 02:14:04 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2040.outbound.protection.outlook.com [104.47.57.40])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kfagpgpmv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 Oct 2022 02:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N46LFM7nS1PsV7kt6ft7PEFg2LioGQzcyKCPyxEUVk9xlad7w1mDap50Jk3L3r6k9chAoeR2dkr2sjOZASEhhG5yQEbUmzS7dhp4omhktskP34uAXr+M43iH/VQO6Oc6Jufpzqtc2HgKYB7l3KsJV/xxyf2BmkiAnRPoxDcsbTQEcE0i02Hmi227raj4YRR8RMD9fQXW3mhPaV9nLS5CLZReY+ag6EXIeJiWp1NWPk6/qZqLIb3cwBA7m1AwhKIbXO1ZnnbE321tDftzBt5yLRBwgt3shj9CALIEGl6uGquOj39kPU7NJn8FdaH3ZLzvLRVRw7YqMnYYi96vYcBMsg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=T2bAc6KpbI6cwxeje7srhqtI2zGxsyj7gEJ9utvLuSI=;
 b=dh7XfwyQLjWoPBxf1u5fnzulkdvQrU+JwVhIEdrDRhtrqIb+6OPzMDPwcbpSbp31fuaoLOkMIfdUEFwpyQ4Du6lAL0zYBiHXzVnnMsKXfKGyxOGbFHYzaXvMMZleIpEiX6kGX9iYDZoE8TZ/s4UAyne2XvC72eUyt2YNkdG6pTJk8XKugmN1LqT+QAgewOKIB4pPkpZJK9TmZcveuVAkeyth4l3K/e17jN9vmib28oxOySuaCyGTTxou6gyBTa3IGQMzoVmg0fJKRh9Edfmn2kJpTOV1rwej19fmjBXypoo2KZcl+MeItO8FXEW8+ScOYO+Zhvle32wIkHYrEMzyNQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=T2bAc6KpbI6cwxeje7srhqtI2zGxsyj7gEJ9utvLuSI=;
 b=AOqGxUCTIBdAUTgT/lKP5mn0rWNeK3DpQaAGD3hOFU5gEq0TmQDZJ59eaB2X6qGoqbtWCllTL8aM3kU8G6mSn5A2Afo4DHL//UxQeX8Dv5prNFnITBzbfKbyIYAg0Z1inTFmZ3GzzG/rSia/VFCNTBMCcfjexxO9Fo7aB2wVsu8=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by IA1PR10MB6169.namprd10.prod.outlook.com (2603:10b6:208:3a7::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5746.23; Thu, 27 Oct
 2022 02:14:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::17b2:d97c:d322:c28c%7]) with mapi id 15.20.5746.028; Thu, 27 Oct 2022
 02:14:02 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <qilin.tan@mediatek.com>, <lin.gui@mediatek.com>
Subject: Re: [PATCH v1] ufs: core: print more evt history
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15yg6t3nd.fsf@ca-mkp.ca.oracle.com>
References: <20221024120602.30019-1-peter.wang@mediatek.com>
Date:   Wed, 26 Oct 2022 22:13:58 -0400
In-Reply-To: <20221024120602.30019-1-peter.wang@mediatek.com> (peter wang's
        message of "Mon, 24 Oct 2022 20:06:02 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR03CA0094.namprd03.prod.outlook.com
 (2603:10b6:a03:333::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|IA1PR10MB6169:EE_
X-MS-Office365-Filtering-Correlation-Id: 924bf42a-fd03-4e42-7d74-08dab7c0ea1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: I5SYXKUrtbU9hVg0Q6UvkTYXdmLz5HGasBPqrvZwPDc7BIxNL0eTtyOH3MWO6PtP98tHULVfcOFrBULdIEWwjZ3ezVQQtMYu0K5syqPNftIhKbqzagq0AZKTLKgRLdlGo77UvUnqYRQJSKZXuTM+smjhG94MGNFBq3UVPtnoW1pDmUlGmo2/HOrDtHwIshLi4GJoijEeQSws/GywK00iT1iDStnUiCnNUrP5N/PNkeorrB5rfDevVnYof/3KT9X2VCQvcAaVGRzONe0qpxp5drbNXxdjW1WawoYpNxV1enTRiSE9P0T+eG1BYRHwnf45j01r8P3BiLiZo6a2i8Rv1+elWY6GQ/Jz2rXJ9fB8uOdddx7PjkBfHKCKnAshLnyAOIGJKD+yN+s08OfG2p2cGVDuAN49RGz7iRatYXEX4eVHVHyVicYknDzvBcgMtq6T42OoEhmvabQ2UkQFfeRdfSBKaf3hvt1R+0kfyz8jCOwsg3QL4fWClT+Kznnc8Mqv3BAbTcXzW+AW+/Cp4hRP15qJ+RkKOppAEj7vHKgsGEYJMfHNV+koIfi4w3ekjiG0AoDu3ra6mxVUOMZq+b4Bl0GE9JqsFnGc7gX3cp4KbPYZvMt5iwZaSBuVMF2NPkWvtv4sCUXwz8x5fzZdPRi8xR3QFY+/AXwQR03l1HbRhwThODLy1qfgr1DHVAVucncydEYTSMNkr4gJHpau3cc0+w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199015)(186003)(86362001)(38100700002)(2906002)(7416002)(41300700001)(36916002)(54906003)(8936002)(5660300002)(478600001)(6486002)(6666004)(66476007)(66946007)(4326008)(6916009)(66556008)(8676002)(6512007)(316002)(26005)(6506007)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?hGqHdtYE5ZPqbSyQPEQoDsQVX3HynZKiGW6QgvZhPSlZkSxde4OZa8ceISnK?=
 =?us-ascii?Q?fkShzH/hg22+O+KWzvwy6jXRnbZZrsLqqgcbgN96IV6VBC2QPMQ6TgDBTMBE?=
 =?us-ascii?Q?0lnpM3bhpJ8uUaDfY8U/LT4CR4YQ3Sh+UHLKaen+NmI8RFXR7V8DBPxx5hy1?=
 =?us-ascii?Q?d+isxIIUXUB7o3zMcgTQ23vWH6QVM/fi7V2ara8eC6+gYU/8i0MR8XAhvUL5?=
 =?us-ascii?Q?B5B/SyJzBkFeevQsYHC532ASXoQDQj+wiR35Oe12fke3Don+8OXdnXow674n?=
 =?us-ascii?Q?qS+RyDWeJG6QGLvmP/oRJw7/hRRYMClOGtHzFAfeEo4fxqkEGSRXn0Cp8d2t?=
 =?us-ascii?Q?0/7/KwLmU7KgmKk4O4U0q7J6+8w/Zs+rbwfftIkYAa8MPvyExc9z1frtYOCK?=
 =?us-ascii?Q?uPGFr2lAKNSKl4O9j5wTVh0ihfn8MujFkCiplcOsJTYVwFE2N+DAitMsmmxb?=
 =?us-ascii?Q?nmvowPmwaq8cWrBApwbtbL8s3iLYVw+qoodOJCKSRd+G/2fdrRKkrl2EtzuL?=
 =?us-ascii?Q?nP7nqwMYjJ4PE5VtKJUWRjRG/jG8KGIIbiXSJeTLSK4TAr4Sr/hfCp4RWosN?=
 =?us-ascii?Q?1QN8GskGjsbr0PxoYOE29ynjcilhHoar6tG27UL0vtkdZr/Gjl92GFjra37M?=
 =?us-ascii?Q?337+6mSsakWi8KOIAp5UO8mNG+iIbKgHJF6fWDI+Xbpma5KnxWUpQgLeQN0Y?=
 =?us-ascii?Q?VamwyW4eTkKMrxSRDuDxHMOImhUjDV5NY45eDZpqoILG1ERjqQlglbAK9l7u?=
 =?us-ascii?Q?eLXSmG1S0VBu/bjv+g+DpS5DLE9U5cGcJ89YeGHUsMltPKj7al4QdYXosbvr?=
 =?us-ascii?Q?VxO7SGKVKEv65yiRVNMkIyfO2i7ZoFs2AhapVEfzgw1F9rhpQ07Wiuiu3SaD?=
 =?us-ascii?Q?Ah1Nqp8RMuE4Upf3/GLwOTg1R9F3GjpXk2P4Y0zaR0gv7PKUK30/D3xm4LnC?=
 =?us-ascii?Q?Xnqrm+q3J6ImOPfj9UYWQlsdrzG+kxVNDWhBwP8U8LCrpwyDEMNBSWDOCY0N?=
 =?us-ascii?Q?JG9rYsule4MJ2hZ15IqWfWtNP8RGgVmdhKgyJKwCprr6JAFRIRlazXinKavO?=
 =?us-ascii?Q?xEhLzVL4BmOOLy81Ng4/JpuhjUjk5+IXeJ1jv9ZgFvtTFr39dAPQKY4CqEnW?=
 =?us-ascii?Q?2f5fT500Ax9y4OkM9Ki1UCzvtEy7XhZvQUTgLhII0025eKSqK/ccQ/fZrAIO?=
 =?us-ascii?Q?Z6w6TWw3vAze08hj4b6RLeTDt07+5IZUxsPf3O6XO3hgdpE+r9iRPZakJWAN?=
 =?us-ascii?Q?BmoO7H9AQZjtVSi8flh9ic+1uQKp8n4DeeL8ttIRlgCnvFHD9aJP8YNBFn+r?=
 =?us-ascii?Q?6nX05IZX8symfmF12uFbnHO/k6mx08N6myataYxdiIC48HZquycubAZBPev1?=
 =?us-ascii?Q?TdlprU81MF4kjPRazG+ctzqesFmQmsSsg6artQlLSQy5lPkcfsx9ZrBdb4Nn?=
 =?us-ascii?Q?t/zULIv1Sahth04WwZb8xiuyo4pLkRVOdOqqxKWKWDZKjD+fa4I4rfp1IPZB?=
 =?us-ascii?Q?ZNrmBz/7go/tbtcqXZOK61CTaU74U/bzMEKtEWgtmhCf1CDhuziMegC8kjeY?=
 =?us-ascii?Q?rZcWcQ/C8JwyIIsUXqkgvBsggk2GUNvvv8FZvHKOeniNCLBnahk1RJ1an55s?=
 =?us-ascii?Q?qg=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 924bf42a-fd03-4e42-7d74-08dab7c0ea1f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Oct 2022 02:14:02.1368
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: a0Dp2JbRD7bDAerN5bDygenlv+pgkl1itlwr/m63OYkRmkJ9ofXLt3W8UCxotxJOdjjDl5s+d8n5lQDxpp/6xqkFnXs+plAPXXZnqLHGIsY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6169
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-10-26_10,2022-10-26_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 mlxlogscore=974
 spamscore=0 phishscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2210270012
X-Proofpoint-ORIG-GUID: CD_NvV3LUI_RLciiz0oA-tCWMUyELfuF
X-Proofpoint-GUID: CD_NvV3LUI_RLciiz0oA-tCWMUyELfuF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Some error event is missing in ufshcd_print_evt_hist.  Add print for
> this error event.

Applied to 6.2/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
