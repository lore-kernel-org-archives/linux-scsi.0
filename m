Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 07087C433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD1FE61A0E
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:54:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230044AbhCYDyP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:15 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:57356 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230026AbhCYDyB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:01 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pkAB099819;
        Thu, 25 Mar 2021 03:53:57 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=jsNppSAHBV3h6ap3lbiN59RdCjUpv+WF46rVJkhAyR8=;
 b=ID/jFJP0Y+c9FpypjJ0uFAjA3mDaLzS/yogfHoUlfX/O76EVgZVvLMhtyR5vK7TsgLpD
 MyHLXo9k330fyxgJGXxtytq6eOG6+PtlzCuF+J6MegXwyOu24WlEGY/APJYW1uJS8v6V
 WMkSqJY0XQeQ6pVxoDOpGA8iuRVnLlKnaP2tPrTBVsnTriEskYRuXJ+Cr3x7I1lG+CZl
 awb2pIzNXfs44hRp2hqYj9WwiJaq/zjyF3E31Y5VY0wznJZ+XqwZjJ5HyjNf30szUnj3
 F8nE6oyThtEsbvtzRkUhXSwTQu4lBtHso3lsXxdLmTl2QwOxrCJD0XFA0uss/x4/XAmt eQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2120.oracle.com with ESMTP id 37d90mmvnw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:57 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pFBR134352;
        Thu, 25 Mar 2021 03:53:57 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2176.outbound.protection.outlook.com [104.47.55.176])
        by aserp3030.oracle.com with ESMTP id 37dtmrmum5-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:53:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=f1J+QQGFmIWafG8UdWVof95TsZav7udTGaUQ21IgIlSmqJqd/IWMbnzxfu7KUl91VnAlynWUXlw2oS+2g2k6/zK6iu6SYfrfYee3GxA/2AwBefQKXiNx1r9xIQeppAOsTwoCwPtzpv+t8srGNmGCs950oPmpbOJzjtpJS1r5QN+/npdmiQ85+CwwFdJ7vFqhFd3SH/1+gVVl3UkLNayxa1VkEUjtwWwlECLy8VYnr8zU85Y/Pu3DJpg3L2occIoW+clI0vQXneDhrhwiRiBcnF0zw6FipDYu7TqGAKHLeNbDKovv4S53gYXhLFTNkUFnpzIKu+nRzA2TJ1hPt8AbGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsNppSAHBV3h6ap3lbiN59RdCjUpv+WF46rVJkhAyR8=;
 b=CmxYIQu5htpxh1myPNJgVUkkwflhS22RbIf+wRmuMtGy8KPxWvmESdTjA/OANDw6qz3FtUjvLvnS/zpkASR1zqER5kYhHarFTrnj9NBHTlteTSPxiSC9fIb+NjuegZ4qWvgXumheQrX//P14yKeVIKcr2QGhXN8NXqGFmsjeeATBDwhf937Li3pZ5jlVr7/MyzJ1fD0c1pa99GdsT+VAonw+rW/BXOB0pDDze1QjPduLnb5+/fqP5tVrCrtA08mnJnjGly1G6MnZinaHI+oG9npsCUfA7i2ZJNzb0VzsQqlyLJCrRaGEgPdmIwas/rOoyxZ++Y+OuSZCmFGTuXa/lw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jsNppSAHBV3h6ap3lbiN59RdCjUpv+WF46rVJkhAyR8=;
 b=Vv9fX+tR3Ltq+8YmkOEQ/w+EYs3DGzDZ9bkRkxJg/nRZ+/TGAl1JSqRmYNjWDqZuEu5y07pLEmQj6kfwPEi7SQV59GsZrvr+L9C9Pyv+kOjMCMJN1hWRlyhEdW8TOb5zm5EQeIA0gsfahHT4BcYjUxXUMQ9fTStZTx7RiPvmSng=
Authentication-Results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:53:55 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:53:55 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     mrangankar@marvell.com, njavali@marvell.com,
        Jia-Ju Bai <baijiaju1990@gmail.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH] scsi: qedi: fix error return code of qedi_alloc_global_queues()
Date:   Wed, 24 Mar 2021 23:53:46 -0400
Message-Id: <161664413899.21300.5389880023818907979.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210308033024.27147-1-baijiaju1990@gmail.com>
References: <20210308033024.27147-1-baijiaju1990@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: CH2PR05CA0053.namprd05.prod.outlook.com
 (2603:10b6:610:38::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by CH2PR05CA0053.namprd05.prod.outlook.com (2603:10b6:610:38::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.10 via Frontend Transport; Thu, 25 Mar 2021 03:53:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0beec48a-a0bc-4563-ea8d-08d8ef419cda
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774C0157B4F7212B06F6FAA8E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bVTYunBrW13k7gSEeNpMtexTRyz+2vickzHXFZkKhwEravMjMqVSJaha7RjqD1TsnMPBLiusxy7gFA30dGIQ1F42BnF8LiUv0mY/EmmLRJlSYMTOif1Ud/iJIrmmd85MRf6lY1v90Ax1GK/jyeeaubemZq/ENvWbmCKI8kXBQotpAa4lIfikTWUG+SOt1mFHEGsK6pbspUomZ20iYrUuWLPIvnZzuiKtafrL8CwvtSXaDREyxkq5eRnmqYi3Gs1FO6MdbkDW00qJLpgDdsndjGVBo+MlrDEgfK8LGVwa8lPFzt9pmlvcoXzeYWyuZ5e7DsG1zJPtWzk64xpjeIrugSLFwF4kdTSUYb8tuF65ImPKkAmpH2QrirPEWUlPBhsTziGNtyysZqaNVahu6aWqUm9i2WTRXX/1h+ThvBM1JcyVEdk9qUM3z0F2mUXeeoRho3QH6FxrcbyStSBF9C937JgyJd6ELWVWRoBcO+hDH0r+JlgYVoBpSZjHD+PKsAln9t9CvAKuFNJ87Wy3SvgYcc7uwe5CuO7R8Uro8C8eaJCN8rfEZ1Ew3DSHXz2Q4RvHepskNXBDWDkTf4S9t9yv37TwkGnRCAeJIvk5TO8dTeYCetRUfh6Kllp5lzk3IzABLL4KbOkzJDyy3m/lZIVnnXMZSfCn/q4+ufM+VJWoiXEx8pRA07+us0jxK762tegR3v+rN3r43Wp4u81QxP5jxESn0XxgogXsxS6tQaucF74=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UHRSVERYZmJOc0owam1meFRpM2FidlRLZ2Y3b3FXdFRSMEgveHk4c0k2V044?=
 =?utf-8?B?cnRHTUtqeEpzY1FWZGsrZnBJMGxxbmRhWWEwSDFzL3pEQ0tLMTBHbkExU2Nv?=
 =?utf-8?B?QkM5K24remUxaUJROTc0dFBxd0FtSHlLR3hRUXdPcHMzdzNxc1BCTkQvMjlq?=
 =?utf-8?B?dEVSenArTFhrdExSMWZaeU42ZzdHRm5QaHdXcW54NHQra1NBMUl1OXp4L2Fp?=
 =?utf-8?B?eTRBVlVCbllxcmxyTXN2M3l3VW93Z0c2VUM3aW55ZWM3QXhmS0w0OEZCQ0RN?=
 =?utf-8?B?NllKZThyM1YrbzJVbUxFNTljRHdVWVpkSWVaMENkbmdBeW1Nc2MyTEEwc1JV?=
 =?utf-8?B?dElySlRqNm0wWllUMHdNUjFnUUZ6QXBtQW11ZyttZHJvT2pqYmN0UjgzZ0Ex?=
 =?utf-8?B?WC9VUFF1S3JKdEcwNFFrZFVkbXJBQzhSTHhROGlWMTJYYUhBRVJVMlM3NWdi?=
 =?utf-8?B?MlFnWFJHN283K2p2QUN4c0pQN215cEttaUxPall5Y3pzbERIZjAzQjJ2QUI5?=
 =?utf-8?B?UkNxYWpCMEM2TURYVE1ZUnhxb0RnZFFLK0Z6SmlLb3h4bHJ3QVNLT01iTkZt?=
 =?utf-8?B?dDhscEpYM0JQejd0YzVhTFVYU09uWHd2OHJtRWo2MVBiSkpIVEpGMkNocW4r?=
 =?utf-8?B?WEFaSzd5WktTbGRnQTNxc0RnWVNUR0NPS05oQWNoSGFPcU50cm1IUTEzRDFs?=
 =?utf-8?B?WjdDTHZNOXBjeUpVdGthVXdSZ21DZmNQck1HS2pheUJja2g4UmdTUTNsZGVk?=
 =?utf-8?B?YkgvejFMNFFjN1g0dE90Q1JEcEkrR1JrYzlzS2EzQ3dXZW5HUTVwMVRrTXZq?=
 =?utf-8?B?alNRZDhNL3F0VWNlMmVmNSt1bHdsVVI2ckdvQXRRd1VuTG1HT2lXQTFIKzdU?=
 =?utf-8?B?OE1XdHVvMUduSDhtWG9KY1UyU3RkVklGMjNNTlgvOWh2UHR5aFNmNUpLOVEv?=
 =?utf-8?B?RitweHVUeUplcS80TmNZNVhvTng5RSthNzB0Y0ZxYUVQaGxJOVAzalRYdU9w?=
 =?utf-8?B?WHhyTWVZOTYvR0M4UjJiaHhlYktPU3VQWEhsZnpLQXBNS29nUlc0Q0RmMVJL?=
 =?utf-8?B?UGtwVWs2UFMzWmdBMHJnMlFOZzcwdi9seGE5eVRvOVdlUG5EaDQxYW9KVDJk?=
 =?utf-8?B?U3hTbmhCbjZKNlNicUI4RldrMXc1TWtYeVVUWmRLR01Za2NCeXdsTFo4VFFi?=
 =?utf-8?B?dDM1TnY1VjVNSkFwcEhoSm96dDdTTStTcXZlSHdwdVptRUtqSVRwdENUM3lq?=
 =?utf-8?B?R1JaUkh1cWJiakd5U2NTc3ZWLzJYZkFtOUhQcmwwdDJyNUlUNmNXT2phVlZE?=
 =?utf-8?B?RjFrdUZFaGZNTUZvNVRaQ0ZUc0xtZ0xRcnJGYTVKWG5zbE5iYmJjRWpDdE9t?=
 =?utf-8?B?aVRCWGJsM2lvRWxvMVBhbkFZd2lOak9QM1J5R0c0V1hNT0VsWEcyRkN5em1Y?=
 =?utf-8?B?S0E5clhudWozM05jb3NhOVY5cCt1RWJsQW9XMTYyamRRWW5aNGQxa3FJeXA5?=
 =?utf-8?B?TVJ6a0craWV0SHpSNUswMGVPYkxOUGNsNmpnM2pRY1ppK1M5RmZVZHBEK2dJ?=
 =?utf-8?B?OUhyZjN4Nno1TDlybkFMWDg3YlpJc2ZWZHk3VmN3WFNrbkpCcXJxQ3U3QW53?=
 =?utf-8?B?MEIvWjBPSWlrWjMzOWZLWldyeWkzWjY3aDQwQzFna1hNaGZIQS9PQVF4VStZ?=
 =?utf-8?B?YnNRaWMyeHZaRDlxVEI3c0JSU2tzOElMYUdaeUVUMmRUWldRZ0NGYzFwck93?=
 =?utf-8?Q?rzEpefEeg4dEWIa5szkMUnFvfQBiohqnoEyOz4t?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0beec48a-a0bc-4563-ea8d-08d8ef419cda
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:53:55.8411
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GxccwLP5Ai3gJmxO+zcJfhu+VflIjMORVeff2MSUw2IsKzApPA1PXs2MN8BbxQ5g2wJvFF7DWHBAsXxKTN1qbVaFdfeBMyhSvTMuJ1db+ok=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 phishscore=0
 bulkscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 mlxscore=0
 priorityscore=1501 bulkscore=0 impostorscore=0 lowpriorityscore=0
 phishscore=0 mlxlogscore=999 suspectscore=0 clxscore=1015 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 7 Mar 2021 19:30:24 -0800, Jia-Ju Bai wrote:

> When kzalloc() returns NULL to qedi->global_queues[i], no error return
> code of qedi_alloc_global_queues() is assigned.
> To fix this bug, status is assigned with -ENOMEM in this case.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: qedi: fix error return code of qedi_alloc_global_queues()
      https://git.kernel.org/mkp/scsi/c/f69953837ca5

-- 
Martin K. Petersen	Oracle Linux Engineering
