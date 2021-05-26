Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D96FC2B9F7
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5573561090
	for <linux-scsi@archiver.kernel.org>; Wed, 26 May 2021 04:08:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230161AbhEZEKK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 00:10:10 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:51816 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232552AbhEZEJj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 00:09:39 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q3x2ME183775;
        Wed, 26 May 2021 04:07:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BsYWucM/WDf53nV/mprVAYdVKIW+LJQh3+GMEOb/O3U=;
 b=WPTlpDiTjikU/fHj1rkkvulHXtiad6hbZfFcUvTV0CVW3kuigxNyK7dmgPa3ydBS/Chc
 0uC8D5At35C024Il4aRhwDNnbfDzYRmKzCT0biu9VEwRdkBUpsryaPiX6Ruvl1JUSWS8
 gy8kupDroLD2Z32V3RDL91QlToo5tCuK3tBJmIRBCyqLGMGMR6Wxn77BryIc7jXzd2dm
 HX5iyhazPMJ6PaVsAWd5U0IFZjUtJh7zPusFqd/R/PUJNZBKyxdScdutEDheNm8U7dFy
 vYKddpCIdymJYWw3b1FlfDKDzeYTbi5EGfEm8gKS6XOSCu+dGz8bXwtgzmZC6FieG3mF IQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38pqfcftey-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:54 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14Q465TN164130;
        Wed, 26 May 2021 04:07:54 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3030.oracle.com with ESMTP id 38pr0ccmg2-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 26 May 2021 04:07:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oLvi3zPBLp86WJkytltpyEcOqI6Z/QWbKLNokBmbN+TPYjCNxwxb3w6k07pxlv+hQ3ji0Uaa+MeiUbPMwtJBqp7U/1a2YI+XPNp9kfVSkJ4mWfWaZ5XXr25EDj7kJQcmo1KJQrMN4yTYUNeloZvYExYaQnt8l3jFrpIT1UeHK9/LWcojGNSvWE7BtpQZIkklk+Kdn2O5dvoyWlWLpkdLNbBjIfraCptkQiaP1b7VpvDr5bc0rLHaZI3ox9LlOz73wAKzTp9L6PpYT52bO79/1LOLnO5Ug04C4n/0l8MYyHvb/vVFIeHOwxZRmOdzYejKxhRx27tsYvxzxjGnVqJTSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsYWucM/WDf53nV/mprVAYdVKIW+LJQh3+GMEOb/O3U=;
 b=lUsmFxzzk14NPdcrvo7mWMAvcZCPpMCG25DeVQCHbUjDKQwlJ31GrkIZluY2xaN2vHNZqfFfMtt/oqcKQnkvRYSeMr+uL3s1OHFOp9MEpoMZyqPa98mOvq5Waj8/kNZOD6LrFptmM5rr2ON76+dNAfso1MHKgnsQgEDMo4y4X+HVV5yzMcaKvHqtxbibRPQQer5aZge8Q7KoTicr6dqSO+8I8y7pR9mL2GZoTdtuB90j3gU24WucWslwaWYQujpYf4WlEoTFtjIbial3ZZlabF3pWf8Z1MiW0OAworEtVXO8orr2UbXnWOBWMkj6Sgqgiedum4drttpZaQ1q3cZARw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BsYWucM/WDf53nV/mprVAYdVKIW+LJQh3+GMEOb/O3U=;
 b=ojYMeEo5Yvu6vfj552Sw2A0Go7zYVA0sk5SnjZVMITdpn1nbI+6ayPK3bVfuwCuzLD13NG9m+mkbwfn6q83XNuNeCakH4J1p+hyumOliWAav1ACAtmiYg7yrBA03JuK7iy41wUD/JJ6pj3Lkv264mRFreSpZ6Rod8pHAyBuDH4I=
Authentication-Results: omp.ru; dkim=none (message not signed)
 header.d=none;omp.ru; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4469.namprd10.prod.outlook.com (2603:10b6:510:32::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Wed, 26 May
 2021 04:07:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Wed, 26 May 2021
 04:07:52 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sergey Shtylyov <s.shtylyov@omp.ru>,
        John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: hisi_sas: propagate errors in interrupt_init_v1_hw()
Date:   Wed, 26 May 2021 00:07:30 -0400
Message-Id: <162200196242.11962.6279001586608193606.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru>
References: <49ba93a3-d427-7542-d85a-b74fe1a33a73@omp.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN6PR2101CA0004.namprd21.prod.outlook.com
 (2603:10b6:805:106::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN6PR2101CA0004.namprd21.prod.outlook.com (2603:10b6:805:106::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4195.2 via Frontend Transport; Wed, 26 May 2021 04:07:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5a7380bb-f278-4fdf-19d5-08d91ffbd555
X-MS-TrafficTypeDiagnostic: PH0PR10MB4469:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44690BD3B888EA7A03413A3F8E249@PH0PR10MB4469.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1388;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DxptJ56jCi37K0MDacBB+uiz0nTPjpWM8u+RqrvCNE9Tl9MOy7fXwO+RgA8GH/VrPDa5aGiINDEewnDF8oIDcyYloAtwdPonmTSUklS6ZjQ76aRYz0qQ64SdEUhIRDAIx9OsPIcqsSqiLwB7ofz8On2HdYLl/Sq2xsusYHYB8zsA/qNPvzopjlJ/ZHoCIerK2vHf3qq7wxWfqqc4pgrC02zsPF87Dkr1Lz6kOOyKSxCf0Z/5+RroFnLlOUAd5qJaPTAx5gTs6KlX2yvv+CXdDpwJAKHPVndPrIBRZ1TcOl4mP3OQa2IFyI8K94f213inCKKIXdEevz42HUySY+i/WxFJYeWAlrmNHjwPHQSb+JvBMROzmglXYGUaAbWChrzzEkaRBRhaVyBd/I/fJ/dCSBj8YH53TbihRLYInhSASz0/I6D4OSNHznXGLBm4KImzcHvYESS2EiH6rRVou/Y8ihFboSHdYQWBCvkkGl9Sas2uZXjUPDn82O7Xr8lhpntR/F4tbDxStVc2EnvaRg1pzHFZEokwPlFPWwmATTKAts747VMygskdM0JScvesQaqEZwkAfJGmx12EJlqe1oFe0NA9FaZ0lvwrASg9yNfo1pNn2ENOYs3zqmzZYTXKFYxkUjY5s8GCD/V9y2B1Xxp8u0qesHciJ8HY2k3CwcAcSTMalgknC+bLhsjf+AFE6NwBgxvpT11GhBgr/868TxsMIY3/O1z8wlsb2Z7BGoXrl1L9T8Ec9aiIT94RJ6lQGQ/xlOa0JT2o4fiN/5yq9ohaMA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(39860400002)(376002)(136003)(316002)(110136005)(16526019)(186003)(66946007)(4326008)(103116003)(26005)(2616005)(4744005)(8936002)(956004)(2906002)(66476007)(66556008)(7696005)(38350700002)(52116002)(38100700002)(5660300002)(8676002)(6486002)(86362001)(6666004)(83380400001)(478600001)(966005)(36756003)(107886003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eHYyZWUxSk5xODB6NHU0ME5vZmJmWlkwWk90MUt6cS94RSs4Tm81UGU1YVNG?=
 =?utf-8?B?ZWFKaUJCUHY4aWUzOWZ4SHZnUEYvcmtyYmd3bDZ5T2JMTFV2UkFxbHYveEhM?=
 =?utf-8?B?RlZrVmMwU2JqeE0wZEFzY3F3Q084OVRCUlE4dlpCbDY3WnB3YTJUVWxJbUFq?=
 =?utf-8?B?YlRQcU5wS0tZbXJWN25HODZwNzhoWU5xcEVxNDMyUGEwMDFaNXd6L1lSZTI4?=
 =?utf-8?B?cjd5Y3YrYTNoa3RqT0JUdkZJVEROOEhhRjY2SFhmajc1czd1K0pvd2NRSTNG?=
 =?utf-8?B?ZHIvam0yelhqbEJZS2IzYm8yeitwTDRORUd1Y2kxdUEwVUJuR3U1QldQSS90?=
 =?utf-8?B?cDRaelpRTWlwT05aeU9IZVhVek1tYlFpbXZnTCtBa1lqVEF5OTZ2TGtVbHZV?=
 =?utf-8?B?MzZoME5BbkpES2g3elIrRWpHT24wZlI3Wm9ENDFaNWtMWlppcVdYSWFzSnZN?=
 =?utf-8?B?UU8wazNmaFNlYUl4MXdnRHFESTA4bS9tSC96NUVBdjBhNGdWYUlhK0xxV0lt?=
 =?utf-8?B?clpHRzN3NlNHSzljeDhyVnlKMEJ4NE93RUVqaTV3ek5GaDJMWUVJMjRuSzlY?=
 =?utf-8?B?TnpmSk82aExXT3cxWTRraGpVZFJzb0RPY2VrUDRuU25pYW8xMVlqdWxJeDdS?=
 =?utf-8?B?TXRlaTVJRFRpY0xoenR5RWk4MEIwTTNaTEFHM0R2Y0tNaFNDZzBPS1NLSkxP?=
 =?utf-8?B?bUFaMTh6a0E5clc0bCs4elZYYit0ajdGdUlESm56Q3R4dmtSVWZjYnl6VTlU?=
 =?utf-8?B?a2xhcFlFbUx0Yy9xTEpOUDFGeTVLY1B5bURkZkIzWE1UT0RXQnhtMkF2amh5?=
 =?utf-8?B?eVhMSHNUZFBDYUx5Q0k1b21hSDRGK2l3MXVqYjExUmVwL0lmZE16RzhLNlRk?=
 =?utf-8?B?d2crUjRhcHVOaHZBNlliS3FmZGVXdUlPVmdGOUd1bU1hK1RTR3ZIc0h5OUFW?=
 =?utf-8?B?TjNTdVkzQkc0YnNqdm5Xa1VxUG9xTWtzbnAxMFErVFF0VUpBYzVPV1FVWU5l?=
 =?utf-8?B?c2lEVlZ2Mm5xbmpjcDRRL0llUGpMaERnd3hWWTRmNWxEa2hRK2JWNXBSN1Yr?=
 =?utf-8?B?OW9LbkQxTGtOOVE5cEtBVFlmUCtFVzc5V28vTklVZmJQY2dWV204QnBnQ3BY?=
 =?utf-8?B?aHNwRTZ0SDhrNjhWcWxCZUhjdDdQRWkwRDNxcHZ5UE1EUnpSdm94QUFNTU1q?=
 =?utf-8?B?VThaSVcxenNxdUJlb212ZnhOMFJtMGw5Vlc3c21rOTZmYmhVclJ6VkZNdm1i?=
 =?utf-8?B?YnRlQlJoSWJSU3g4RHAvN0xkajVVUnlyZG1EeWpQc2c3ekd2WnpmUElka1hW?=
 =?utf-8?B?WEdOWlJ3ZW95eXJYNUtPSXVpOFRWdmVzK3dkbkRLWDZnSjlvbTcyVzA4ZCtR?=
 =?utf-8?B?YjZqUWxSZEJSNWRvdXprQm5UbVczVlVjNE82a1ZBMzlkcGxNcmtqbTNqN0Yr?=
 =?utf-8?B?Y1czcTFVQkJvdjdGOGVNY25DbHhUdVFGTXBrSjVQM3daTEtMUys0VGdYemls?=
 =?utf-8?B?Wi9mbFhTRncrM2ZIU1BSTFBiM0hTUFh5a3o2V3dhVC9oYURPaDcyRzBpSWVT?=
 =?utf-8?B?UjNLUkwzdG45MFJrcHpVSk9yWmF6MzZNeDhPNEdvL2QvTnBTMjZYWDVsVndx?=
 =?utf-8?B?Y1JkL3lONzZWb0JtYWszWm9sa3lKY3NjQzlmNnZ1S3JsQ2xMTGdUb0xBbkhC?=
 =?utf-8?B?bXpiOFhQMmIvYllnQzg0OEVkNmJLYXNWcTMzR3lqVzJjRUQveW5hc0ZSZFdG?=
 =?utf-8?Q?SNMI5yHr7SXneNTv8u+8HwI4/fOM40ZJMWd7wWa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5a7380bb-f278-4fdf-19d5-08d91ffbd555
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 May 2021 04:07:52.8222
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: HIKNuSeHZtJoinJLJnQEXs/0uhFJf9QAqVyy5r/KeEgw+Rmyz5w761l6l1fNekvL0rRYX6L3sQHeK/1752h0CuROKmhNq/mLbm8pYQv1qeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4469
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 adultscore=0 phishscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260026
X-Proofpoint-ORIG-GUID: JzxU3w1kocYAAIjt5p9Ruagmben6N67S
X-Proofpoint-GUID: JzxU3w1kocYAAIjt5p9Ruagmben6N67S
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9995 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 mlxlogscore=999 lowpriorityscore=0 impostorscore=0
 adultscore=0 phishscore=0 priorityscore=1501 clxscore=1015 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105260025
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 22:20:15 +0300, Sergey Shtylyov wrote:

> After the commit 6c11dc060427 ("scsi: hisi_sas: Fix IRQ checks") we have
> the error codes returned by platform_get_irq() ready for the propagation
> upsream in interrupt_init_v1_hw() -- that will fix still broken deferred
> probing. Let's propagate the error codes from devm_request_irq() as well
> since I don't see the reason to override them with -ENOENT...

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: hisi_sas: propagate errors in interrupt_init_v1_hw()
      https://git.kernel.org/mkp/scsi/c/ab17122e758e

-- 
Martin K. Petersen	Oracle Linux Engineering
