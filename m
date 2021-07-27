Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45663C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:20:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2811D60FF4
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Jul 2021 03:20:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhG0Cjx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Jul 2021 22:39:53 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:30130 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234513AbhG0Cjw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 26 Jul 2021 22:39:52 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16R3C1fA002222;
        Tue, 27 Jul 2021 03:20:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=sXW/5t6EfODcG6sYqJUy0+vottkzWdYcMQ3JY2BSvVA=;
 b=tajfcz+6Sy0AJ6lSo7KcuOUGEGZsIzIsCvhhMLP6thtlS8aYQQz5/0eN6blzz/R68Jw0
 SElW36KzRr2dmmCI67bGS8TKQsfSZZo6LxhcUXbhzgwsq3T3jjT4U9qxgexv7N31oOcR
 bx1YRIGvHZJfe3il5SbTXYXKGuAIZZjXU63n1/Reqsu1V9PL4relAFEGtnMRIDlyn688
 sYxVbQlGQR3phs7IomRjre1sogZCl3YQm9/KABuRk9eQYImHvPXFl1x3SJce6+ZY6IcG
 OypGtDInQCK2zdjMTXvqBvwd8wdEp3RmuQD3hZOtfWxxHIEjnZnIF0Qd99R1TwZ8Icpp Dg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=sXW/5t6EfODcG6sYqJUy0+vottkzWdYcMQ3JY2BSvVA=;
 b=B4EK02ssaje3i6BpSkFkd0C+ydQ4bbRZ8XCU5JceFzJnw/F5nW6Ncq26AWZ/LAk3HAoU
 HrDrmX42MNJ8S/NHT5Dsg/V4ZApCW4fK+fOTN6q2KN+ctx/WKvtToeZ9SpHoTwW3Kn0E
 Jwr3cab+saVOU7tgM+WditStBBrSpjKFf15w2MVwkQZX73HI7Mp1rnXBQl0MYy4B3IYw
 TImvjtsJmuwPM9QB4dTMJbE2YqEVq3UPxgVDbnhRisPVFoN9zt68sC+MT/P/wfZIkG9m
 rpP4VFfT3bXkGnvVNbwJIWL6pUw7keVRPg4w/FdtikPgcGNYDPoc9rghsgoMAmokYnFk SA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a235drmd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:20:17 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16R39fRo188867;
        Tue, 27 Jul 2021 03:20:16 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by aserp3030.oracle.com with ESMTP id 3a2349kv85-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 27 Jul 2021 03:20:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S6voloE/oSY9V6BfnnCnbdhDlg7jw3wIlhhaGssSabRGBRl/vQpi6NbqpBBSlpesOv64b5eZ/83BXP6BtPacNKaVdh99NaD/orkR2JZnhCOjz5i2GEk229nwCH+TP4Ogs2+wkfUeN3t/uxwE9NhM36aDxFHu/VwE9ThMIsdyt1suwWC23u/aOk6KgUXDIVZ2qAWLS43lzFB7EmLFUzumXPYcx0wc6OCrRhn0R7g+8NasY2gX5TzfqaqnhuWCqMFj6b/Mt4Jc88BBz5OyM418Y/Dm1G8P2Z03eeZB2g1ylDPCMBnmWhpa7K9+Z0MXKN7531tuC9zJ5+dqHCB44vqUcQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXW/5t6EfODcG6sYqJUy0+vottkzWdYcMQ3JY2BSvVA=;
 b=KYKHUmCGdRVx3m9oav8QCWhm388OJK+QGkkfh4ScGlvGX50F++/izcAWYwR9weaVwgD9h58hZJNiWqYgKtTxaORWGNS0USD7LBxK0TM8gGaAEBTi1vVJobeF/iwGwQcae2Stu3wrxuVKQ8CyTbDoYuM12HuRgi7OJ6x3+h/HNfi3kWsnGp/683LtaAoTkd4mw5c77vSW0n8Qa0OdBEfkfvu3rjVyVXFm5c8tvviTyQDAiJLMmasgNZtE5Qibx0t27M5TOg8A+GcHQEfEMK/1BLtGvdEeIxXF3FY8qnEtdqTiUphxXQr49r+sI5d2g2sbGn6UFM+LP3g/QpUc7w7W6g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXW/5t6EfODcG6sYqJUy0+vottkzWdYcMQ3JY2BSvVA=;
 b=MYAXeaDYNN/oXLNh0fM9dyne1yt6jAx1vnd1BAU3tGPblEg2mQr9OUu62rH1bYq2uaojK7xaSMNSbIFpNJh5ULtE+Yjud+Sp7ob0zODDeL+PqZ0lFVhYSmuySX3dvxoHMLubFole0aKvmyBLTidDeVlMsisUtFV2xF788cGVhpU=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4534.namprd10.prod.outlook.com (2603:10b6:510:30::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.28; Tue, 27 Jul
 2021 03:20:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4352.031; Tue, 27 Jul 2021
 03:20:15 +0000
To:     kashyap.desai@broadcom.com
Cc:     Harshvardhan Jha <harshvardhan.jha@oracle.com>,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH] scsi: megaraid_mm: Fix end of loop tests for
 list_for_each_entry
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1k0lcqw8v.fsf@ca-mkp.ca.oracle.com>
References: <20210708074642.23599-1-harshvardhan.jha@oracle.com>
Date:   Mon, 26 Jul 2021 23:20:11 -0400
In-Reply-To: <20210708074642.23599-1-harshvardhan.jha@oracle.com>
        (Harshvardhan Jha's message of "Thu, 8 Jul 2021 13:16:42 +0530")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0143.namprd11.prod.outlook.com
 (2603:10b6:806:131::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0143.namprd11.prod.outlook.com (2603:10b6:806:131::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4352.26 via Frontend Transport; Tue, 27 Jul 2021 03:20:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7a8d5d7b-626a-48f7-0b0c-08d950ad7394
X-MS-TrafficTypeDiagnostic: PH0PR10MB4534:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45341C5ADCBB73B22D5E042B8EE99@PH0PR10MB4534.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7wYrGAFYfYbT/y0uoWK8qTE0bU5sES2WZGVdkQPi6KWMSoHjssHcUmM+VkSR7n00O15J6DeHZdWber4pHEnJjfs+Q3HQU8jyzhp885ghl00VjtbOgjd73ompfQ3YiSBRpgTDNL1cs1STAtVqQ5IWIp7xu7W0ZLpWxUpwP400+50EILhvyywoASV2bNzfaTlwHXJj0xWnm7BfSzxcPlMCkDDH5DloAZ5B61uSjw4inibiwz+IE/PjIfqB8l5we4sV2ZwRekGClff2TVN3nbo2aCX2mpNJfrWXc24Xgx5p9t5AwMpyd468hn2sXLKEOQ6SZcaLc07cxXQaZrufY/OEHIljt2SHuNF1recROJ2z6OOxO10Ecje0caESy40hyP5/DZ2o4hkstXY7dVKFo85qj4boAu5coxNG4gX/mJTRwNmty7INGb+VTZOdZpkn//2Gg7k7pL2Z3RvgrttE0cXNd+Sn6UpMR+D2g3ibujvTDMuXc3t0T7ZuwzawkxD8T8MBSgDoNlh28mkFDGWTYzUYnPRUDDSxlW+IclnG0zDUiQ8QTw+CvDwojfRe1lC1HJBsP5u1sedQyUXpbFWMSdvsb0tAqaSKaN2g6AqcOUlzVe7moNox/cMMBHb17hvp0+IG68hRJapDbD8fUTnCe560NJbPSM/XZ3oSjVUjEiCK3oTWkgh0NqQiG1ZQPFEOrfBHolGYZpnAjN9FbjzXdFn8rw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(136003)(376002)(39860400002)(396003)(346002)(2906002)(316002)(7696005)(6916009)(4744005)(86362001)(107886003)(55016002)(4326008)(5660300002)(52116002)(38100700002)(478600001)(66946007)(956004)(6666004)(8936002)(36916002)(66556008)(8676002)(26005)(66476007)(38350700002)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?6fuqG5QEo/nmsPVBRAt2E4N4MQoQXHI/iFt56KbX4BMWvvHf5kc9bJ+pL1Wx?=
 =?us-ascii?Q?fCSHxqbnSoLgC7KZSLyHUeezCiVX0euh2x1FKQHI4kODXAbiQTR7IKPlFgCz?=
 =?us-ascii?Q?EJt55xm+cbsi6hL1d1OOIz5647QJRLoDKXk8ic2sv5PX8RlRYeQcAC0D1Wez?=
 =?us-ascii?Q?0Txa5TTb+vQZnDA0OLJJ4djsmNghAmhSjbGdjDvXcdPrZ2BAk4PLclOK0o2O?=
 =?us-ascii?Q?ZqpRr3jpr397qEnK/UUZtDfFmVK/sqvjm6Tj8HsA+sXk6SJVLzAZ0N9GlNFv?=
 =?us-ascii?Q?nUtJo8iQAT2cCWPSVpqGTZST7Rd+GotuHkLTTnT7R9Z+3oPb4+aS9x5wAiIv?=
 =?us-ascii?Q?tt96wgbMu87TtpWHZrqpPY+9sFt8l3IebddEDpT+J/0xV8KzIAg2eP5lqHph?=
 =?us-ascii?Q?hjMvtSckAU41TXHK2RmFIriPciZ6PxaqNFN+xig+rV+0aZRofV3z37W59r3n?=
 =?us-ascii?Q?uhI8+82YRKKnn3qmDeGj26hKvKtAwb0rgLaV2Bf91Gy20zzyh1I75YeVjUI6?=
 =?us-ascii?Q?YbMa1O8+5HPhZIGB2Hu/9BlPX5NaQj90jeys0PZAeAAGa0VWFmk4b2YH+/5Y?=
 =?us-ascii?Q?/hPe+VKCNSuudZH3r6HSNR6yJZr0DZumwtV34rosQ4Ka1mmObagDDeDX+qFt?=
 =?us-ascii?Q?PKmq+gaB6DK/SOJqUNfzRu5kpzKkYDXywt1OSz3jLZhlqeD5KH3vNvN/1jlY?=
 =?us-ascii?Q?bEV4IPn+oV8oONFCgLI+Q7rszKWfLbXiNtEy2Cb02A8vFn98Vr4/U0eUNfZP?=
 =?us-ascii?Q?HOoCcpgs3GywB2C9PjFdHhZfVJsU3Gb301ZAYC+ZPnbcppcLfqHS+OuXGVk3?=
 =?us-ascii?Q?e6UStxUqdI02hU85coESpX2BPUVTCfd2ow3S99zDYciI3OcTx43/JxOcJLBh?=
 =?us-ascii?Q?9dAteuiud3AQO3NCxt30viafEkQ+n65kXkqOZnz6SCshPU1msq1owXoF22tZ?=
 =?us-ascii?Q?9Mqs3gevu+vQNmPvXPPu7gE3mz1FRj6RFzU2gxABXfxMUcXDVMgi+CY09spz?=
 =?us-ascii?Q?iM4z3FWx6gGd0PzcKi/9JaFg6jl1TkLG55E6IYfR3lGSTFwtnY9a4no4KUOA?=
 =?us-ascii?Q?MOthjkwFEaqny87iimqAk6pmCmXDRDNrtMfH5z46X7KP72ujlONlzAv7VcaW?=
 =?us-ascii?Q?fYnlNXx0JtLYZxwdFlKNUioC8u6V7WS/o4tGqamkOR62E7JRMukjQYQkGAI0?=
 =?us-ascii?Q?t2P8HB9ygIp8ocUPTleZBO3jAXoIVe/f6oF/n0m8FNCCYsWkDqsHiYsweJTq?=
 =?us-ascii?Q?WFaSNxjYBOGI8Nb/gzNfky2/XF7tgr9I9KW+xR3DuNtvqj88EmE7INspYo+M?=
 =?us-ascii?Q?G+mjKAl9dj4wV1VA3vC/Zw/I?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7a8d5d7b-626a-48f7-0b0c-08d950ad7394
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jul 2021 03:20:15.0183
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: esJDHP1f6k9XY/wvcHJXAlma44L6cvro+9/DRx5eMc2w3O3mpyGPwF4Bb0p2N748WXZTH02P8PdF6ImkCXmZgTkOZ8KSJ7ALcc1qXtfxIMk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4534
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10057 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0
 suspectscore=0 mlxlogscore=671 bulkscore=0 spamscore=0 mlxscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107270017
X-Proofpoint-GUID: T1GqyfZY6bwMx4RJaL89Y6X7LuB8RU3F
X-Proofpoint-ORIG-GUID: T1GqyfZY6bwMx4RJaL89Y6X7LuB8RU3F
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Kashyap,

> The list_for_each_entry() iterator, "adapter" in this code, can never be
> NULL.  If we exit the loop without finding the correct  adapter then
> "adapter" points invalid memory that is an offset from the list head.
> This will eventually lead to memory corruption and presumably a kernel
> crash.

Please review. Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
