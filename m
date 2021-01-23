Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0FDEDC433DB
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA9F623AF8
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726598AbhAWEXL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:23:11 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:56784 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726523AbhAWEXH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:07 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4EnW7060761;
        Sat, 23 Jan 2021 04:22:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2XQ5ibGjlFG6tT6sQlFi1gOQl6fKv49nWngsnQj+15I=;
 b=Q4XeLqKM3dmSzxRdmee+g7prm0peyfCZTnOSy60K08yqiGt1noplF10PyKjGSOWQ6cfr
 lQ96DV7yCi0yFKTrRaRrk2rdX39E2gt789pAuPMNifwEk0Tg8Trrv/7yaGE+/fwyuJ87
 jwaig6Y+rms7NugTyjgyAHI7vXDoQWk5hb7Z/JKLoFYsWrkJZphsEMvvIXsin/SkM40v
 EufMfy+udWB4GIpANqVgiHbJ/RHBqYwsATWazAUuswIXIrRj2KKKE5LMsZL650Ac/KaP
 gsgX32qlfUKEhDaN1JJXatS1y5XQSAdTvh3bksID1kKA5/QK37QrQVA/BmMny9+4pZOU bg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 368brk82x9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:19 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4L2Yb192996;
        Sat, 23 Jan 2021 04:22:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3020.oracle.com with ESMTP id 368b4gswys-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=is3Vie11IVc2CUXBXDsk54lPeLIY9LveAyXZwZDiyaG15M/3sSbKdtF68B6F61/MWxim6fCarVLAXtDhV0lIo3J9JOun3NlHVY7x5Xz/3bwddb25o1oq1au2bMEcsouCxE4ngi/bvGXNhYS1k57/CxZ5W3RjFoNAQFh08z7Yl8Jk4/Y6qWHPPlX4gsfMHaUiVGqfw6fqt9QJ10qfHWuU/KOPvpDzjjdAgf3NSERNr1Xdu9Regiz65yQSpWPJwMr6Xy42fdoF1OZsGZM+fgXdATkcwnOooomjRky/wrGSM1bY77OxKkeeGXIms3vHzZ2yF2yuoOCCjGFY8fn+Mp7QWg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XQ5ibGjlFG6tT6sQlFi1gOQl6fKv49nWngsnQj+15I=;
 b=l1AN8NuhESrpS04lwJO2jMPBJu8FTP/w7hGWvmq9i336/O/Xj8O7krKCG2ckb6ygukDQWUwAK2CpF8e1AIPu8bnTiHDvev/fBL0cGywctaHomYf46YITiM4biXDOEi0hXpWNI8EneZq7Z+vYJeTdkG5In9gWbeaAmKokTQhsM/Kmq32PiVc3oTjC3Bxjp7PjbLCbawFZWOv0+nb49VD1e+hkV7x++cNA+ghAKvHe4PjveAGq64d6pPeSeGLJOICfY104tLNVnYji34MOVRCEb7uhDrKOyGZP7wEM24MyeD8C5vyxYrjqp7YcFW5vUDTfieWbKhGWWGi2q4QKDdOq6w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2XQ5ibGjlFG6tT6sQlFi1gOQl6fKv49nWngsnQj+15I=;
 b=YSRFs6pT1CGFxECz13P4xwjWjtS4rCO+W+AkQkgHTmt32F9bvY89y6YhTJ1hwtaUEYt55pG+qTwBhp0J5pd+GhjlQoTdp6oAbE2jNhbMyhGcVwW835C+vrUv1K7RcwBTTVGAmf/tZp4C1rT+n8v58PW+uJuXIiHU/Mawixrw3Ho=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:17 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:17 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com,
        Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        jinpu.wang@cloud.ionos.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: pm80xx: switch from 'pci_' to 'dma_' API
Date:   Fri, 22 Jan 2021 23:22:04 -0500
Message-Id: <161136635065.28733.5978048378954329099.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210117132445.562552-1-christophe.jaillet@wanadoo.fr>
References: <20210117132445.562552-1-christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:15 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b364cc32-76a9-468c-9a17-08d8bf5677ed
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4439937F3F50DBB8071102198EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Vffsha8yeqlppyShlPqEzAiTU5KYzLsgevdRE/72TFg9KvY+lkIgYl5DM3m1kvqAG975HH0xJ80EcajtZfpODOhgSsKKwHHB/FjfuCI3hEgBecSiJIxBEk2HYNnKY5UHkYKLQ1nFzjFdKU7jI+Tpqo22wRfMev8rcpe2dYcNXOMGGbyRsTB3Z9gsleP5AJM8+IFrm5ZI2ANPIH7StotWgch1HGc1EirJKHQVVkiwcXeiRuZiCcrGnrIkQcJEHaXf4ZTrpPUI8NBAX6hjIkgZTT5zpNS4HIOGWcCGKIdQEIJDjsHjvDf4hmpuljv1zwFYyLii7qOmEMtqsc+FiQT89DViJ1B73//2UqEIgoRtRYsS6X4y4dsOT9wrYg1HKajI9gccoK/y23yIiBZS6gXWCpoAIE1cMiHhd7aFdDnDtOD99DwjvpUE9yPXfE1Af94jZvi/4lDU/pepb2ybBUTURw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(4744005)(86362001)(103116003)(966005)(66946007)(2906002)(66556008)(26005)(8936002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZVB6NVdlYzZ0ZjlDdVFWNEN5akM0S1picndibCtqTGV5WnJHWDZYOHRjbDV5?=
 =?utf-8?B?T2JzaUFjNEhaUC9GeGxmL2N6YUtOTHFKdnltRHErdGNkTHhGakluSG1LcUFy?=
 =?utf-8?B?WmFqaXhBR0ZHb2k1V2w1Q0hibzJQcjlvaEtwaGZzQ05CQ3JBNVp1aFRRNVVi?=
 =?utf-8?B?L2xmWlY5Sm1RUGlxajdnMXMwd2dyMm10L1VsV1dEaGZ1RUVmUnhCRE9iKzI4?=
 =?utf-8?B?cCtRRGhhSForNjdhM2krZWJnNVhEdjV4bnJpaDJ4RW5waGhqbitYc3U3aVdS?=
 =?utf-8?B?Mk5Tb0tNck4yRlNJdlR4dW1ZcGxiMXE2dmxmYTcyL3F2bDUzeTNQN0JmQytp?=
 =?utf-8?B?dmNPZW5sYld3R01jd3d2TnF3a01OSlhYTGRmY2lNbEx0ajcvRlgwM2ZZME1R?=
 =?utf-8?B?Ujc0QjR1dFJLNTY3UWN1RGhzRjB3VmZBcDJiR1lKS1lrbWxlckNPTmtIV09i?=
 =?utf-8?B?TXhNa2o5Zkl0Qk5INU9rbVRvOVg3K1cyUkltTGV6TEREYlJVVWVUTy85UFpk?=
 =?utf-8?B?R3BZQ1BMc09VVDdvcnJJOVI3MGVBOGhRQkNVck1nSkUybmdxbDBIWkkzM2JR?=
 =?utf-8?B?ZWo4SFBVOEc1LzlKZkxseHdFVEJpa29Ga3VpTCt1RU9EUEtENEY4YjBZaDlY?=
 =?utf-8?B?ZlhqWkM1Y3hDZHQwQzZWSlBNRWRPbHgzSGdsR2oveXRiUDYyb2czZUhGMldD?=
 =?utf-8?B?ZWNiZmxWMjRQM1hBY0I1aGVqNUhNSVZHcGl3eG5nVjN6MitZbVZTS3JoUEZP?=
 =?utf-8?B?R2FFSGtIVUtWZDJCTHlIVlJRYUpTMlN2RDFUM3hieHVrWFhqa0pSUzUrZEo4?=
 =?utf-8?B?Y3B5UmdPMVhWQXlxbWFRSnBoTnYzOUNGZklXdGpUSlo1RnFXVFhSdzNYR2xq?=
 =?utf-8?B?bTBCYldVcDVFSUJrdlBUSGIzemdPR1hSZmM4a3o4aFc1ZnI4OGd1TGI3ektJ?=
 =?utf-8?B?dEJDQzd2M3R0TzFoQXhIQ0FUVmMwZlg1aFh0bTFaeXlaMUxrTEdZM2owSU4v?=
 =?utf-8?B?aGF2dXE2cUJCYTczSzdvcXJVNGxLRnlBcTF3bFJlNW1sWlV5WWxER21EOWdY?=
 =?utf-8?B?cFF6Z0xJcGdKbDdEdkxTNThRUEVTNElwQ2NFWEtsNWlZRVEvTFd4cFJWZmts?=
 =?utf-8?B?YUhjQzFRdXY5U2x6TExJSTVEbThPZDF4dXp2N2dUVDN2VGR3Nk1RUVlPck0y?=
 =?utf-8?B?UGlCYThkeWxSZkp1M2VmaW1ZSVRuK2lxSFRtSFcwK3Q0RWdHTUE5enpkMlhQ?=
 =?utf-8?B?Nm8rd0Z6MWVRcFk4YWUrVThORStoQTAvbVdaQnlCQUlldXBQc0x4eGNRRlBj?=
 =?utf-8?B?ek9QSmFIb2dOd1cvSkRVVnJWci94S2doa0R0bmhybkpmZDZhbmQrZnp0RWtX?=
 =?utf-8?B?MndhU25NUFh6MGFWSnJ1SmpjY05rOXlxWUVnVDlZZjIyOEZVYmtLcExCZWdD?=
 =?utf-8?Q?C+wGpA89?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b364cc32-76a9-468c-9a17-08d8bf5677ed
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:17.5776
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: m9Ey3Oq+/wPv0ZqpaNeLl5GuiXuz6fqnQIfuiRjdGIqbO+T0i2e01l8zXz5Azp5rmKCv5ysqm4Q+WefvIJ4gcHYEvTM6nP6mxIVNUUpWmeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 17 Jan 2021 14:24:45 +0100, Christophe JAILLET wrote:

> The wrappers in include/linux/pci-dma-compat.h should go away.
> 
> The patch has been generated with the coccinelle script below and has been
> hand modified to replace GFP_ with a correct flag.
> It has been compile tested.
> 
> When memory is allocated in 'pm8001_init_ccb_tag()' GFP_KERNEL can be used
> because this function already uses this flag a few lines above.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/1] scsi: pm80xx: switch from 'pci_' to 'dma_' API
      https://git.kernel.org/mkp/scsi/c/8e60a7deca3d

-- 
Martin K. Petersen	Oracle Linux Engineering
