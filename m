Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 450D9C433E9
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1444664F09
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Mar 2021 04:18:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbhCDERt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 3 Mar 2021 23:17:49 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47770 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233331AbhCDERj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Mar 2021 23:17:39 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243xfmW135377;
        Thu, 4 Mar 2021 04:16:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Qkso+8nvUa/aXlTa91l2RNCukM1RqikNAx3wusAFDNI=;
 b=aoVrK7hoUm5M63prw7MoIyfm+8qGRLbFrxS4gkE3dk46ewB1TDy2tOcASrQQdTADG7oG
 JImqsBXWfQ6dEpzdqqw6OgTNdzM8LwmDTrB4+JXCcTP//8MJLdGW/Msnct3xJW0IIIvj
 RstnxfdHDR41UDxVQJVzJJqtrE7R7cdqC4pgUnVGHr4rvwFAe6geklSShMoGJ0lzZKgr
 dbcJYvtHp1MYYca8jDwFwz9vQv/pOqi+sTHmakS7Ne0rAaFedKphKyJustdl9EgJLZO/
 cmt+RKy3CifajTlv7LDW3jjW+ORWiDOMXfm5sbW0bo14c9JJ+X6kMiSTpZw38VJ7IGEp xQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 371hhc7340-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1243sdKw058393;
        Thu, 4 Mar 2021 04:16:47 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3020.oracle.com with ESMTP id 36yyuuarf3-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 04 Mar 2021 04:16:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=m2iXEKeXF/LGK86w0CL30uQyzyB38o44tRYl8Iy77ufVBcZSxygpKWzC0eXdM2DHw7RhM2QdiMFJOUgrvsgPL+2z0mCqV0iVw6sBa1pxRiReUkrb7qdbf5Yg0rUnfsV8jtMNB4a01SyhS325zvccGA/6pPhb/7qQdk7gPJWsxzd0d7lo3IPFljLPTqJ7m2ultFIkgxulGQOa53s/TZ2tG3tpyYrPpbWR1rslYT1NjyDXEENnwu8yfv4zI8ModIk5YP843a3kVdOXMSqOj8b6OM3/E+Pp2mIIfU5hAi40Wb5sBTTPGKB5Or6RsCfplMpVMfq+Fguj2EZ2potkt38yFw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qkso+8nvUa/aXlTa91l2RNCukM1RqikNAx3wusAFDNI=;
 b=C6qznrOpiGlWHYDwFMy4yrVnteXNCzz9/qY6Uqfg6NIWcXBoNzdGJs5s1whQ4b6tqxrs21o796fwIeKLDNexleEXYObLT9eKi5JdCipBfMm/FzSEINKzEm1xmhQa/J2roj8eciAq2/NUP6DzuQFKNqDQfY2TCYb9nK0azV6ApCYezRZqV7iLMK061gErohEUmRBDzeTODgWj3VTrpphyc3MvNtIgp6eL7TvaQL+bZxdJycXMdGASopXs8nIrweV/5jtHndaA9hI6Kk09AdhiZu/EGp4hgz7m28JyfaMCOK6P3IZgzGzu5SlkGXhoSm36CnOMwKo2AlLlYuhYkVnW+w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Qkso+8nvUa/aXlTa91l2RNCukM1RqikNAx3wusAFDNI=;
 b=CH5DiXSIBN7KNxJH3xcO5jnEYqt3j3hZ5GpH/PDvhOmTqrOKAdnv1YtI5yiL5Xv9toTkWWQ261Rxi/G2EkZXMID0Gme3nMWQOQ0Hf11pWKsmV4mN+9EggeLIMOhHmtbMrD5VPD3L0srxbmW7lUH+7uFsNd0amdnFHcCIq1i5h1s=
Authentication-Results: samsung.com; dkim=none (message not signed)
 header.d=none;samsung.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4552.namprd10.prod.outlook.com (2603:10b6:510:42::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19; Thu, 4 Mar
 2021 04:16:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.018; Thu, 4 Mar 2021
 04:16:46 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     alim.akhtar@samsung.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, avri.altman@wdc.com
Subject: Re: [PATCH] scsi: ufs: convert sysfs sprintf/snprintf family to sysfs_emit
Date:   Wed,  3 Mar 2021 23:16:39 -0500
Message-Id: <161483137625.31239.1626878817565618602.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1614665298-115183-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1614665298-115183-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:a03:33b::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0007.namprd05.prod.outlook.com (2603:10b6:a03:33b::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.13 via Frontend Transport; Thu, 4 Mar 2021 04:16:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 50c3f7a9-8a8c-42e5-ba00-08d8dec4532e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4552:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45526F20730BF4117809ACF28E979@PH0PR10MB4552.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ypjso4+at7eWC+uuL+/iWgwijPWB/hFZ3v/no+adAd5dUnkoqrbjPmXFfRYyVW8rAsaTfHTACUROIAfxQU3IR2Ug2IHM7GETQoQziOLHf7c4pQ58i+zuNOSbrFmhv9SWdSg88NhgZef70GFLg0ByNCwDgiu+tTiu6jnHAR13+Hq/8B6yI5HkmB8XjZVIHXJZ/jwTjQMa7D4vxkpJnQIoPG4Byfy11T45g/XpNWkOQP7HyzRCbO1eQggfJ9p2m5CvrrAWPRsRqPJ8sWx3fCDe+d+Dbbzo8SFyRLQGjMv/6lZSbjqusEus2ZqD11y31VK5v4RZ9EBLTw4+/npLp0yrbO8BI3QLqHG3d4/mYUs6xpxGkFqlYwMqjcBPhPu4ZHTCR32VYzc7JSa48bAAsN/MXx+RdJOMxiRqX+SaG3Pt2uAPel09N+S/gGxWTGEJ1sk/xmmTfGqa3oyq4gQxe2fZHEhIY9wvznW4Qytugu2Bpig0XQhcrA99LPNTXQVcDvfhq0W/a3DXGklbq41ABkTbn25FaIB5b8hUlrCtrCRc0kXZHdM2uiIH27zv2kbs5HWbFKQ2/SJnel13c95CZJaUcUoCkldiz4bXB53yf1nM4vE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(39860400002)(366004)(346002)(376002)(26005)(66946007)(6666004)(16526019)(316002)(6486002)(66476007)(478600001)(966005)(7696005)(66556008)(86362001)(4744005)(2906002)(83380400001)(186003)(103116003)(956004)(2616005)(36756003)(8936002)(4326008)(6916009)(8676002)(52116002)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dkFNRDlsOWRBaStXcVhZZm9OTzN3Z0MvQVhDUk5QeWNnb3dPSy9nR1NCR2Fs?=
 =?utf-8?B?ZFlXdWM2VmZKanBMSjFxb282NGYwK2xTMmpzbUlBci94Tk1HNGJXcnNMVHBG?=
 =?utf-8?B?Tmd2VlBUbUhadlQyYUtXN2twSFRwQ24vTWl2eGgwOVlkMUNnaUplS3c5Q1Ft?=
 =?utf-8?B?WVBLamFYVWVPR2lTcnZhdm44eGFGRVdTWGxBc0tFREtuSkQ3M3NvN0VJVXhj?=
 =?utf-8?B?dTBxYjY1dG1PZDJDY1VaejFXMzNCeGZOdlk3MjVJYXZ6Nm1ZeVovSmYyd3RE?=
 =?utf-8?B?eTVDU0dGZEhZNUJGcnJHVDVscVR3NkNJaWlCbk81ZzdYVnhMc2M1bWVjMDR6?=
 =?utf-8?B?dDVkcm5zY1FUcUpoQ25UY3Q3UC9KUmN1OXNhMFE4N21BbVBpcG55N1E1Mlp3?=
 =?utf-8?B?bVFEcTdIVHdLbW4zMHNQbFV3bEVSWk1RUWg0VkZmNkttM3l3SGIrOHlucHBk?=
 =?utf-8?B?ZWMra1haK20xR0dBVTZvNzA0Y0Zmck4yU2MwRG1oZlZBWVh5amg1amgyNmcz?=
 =?utf-8?B?UHlhL0pWR1Y1d2NTZHNJUHE0WXA5T1JMVHJodHBpN2JBeWI0MXp2YTdET2Vu?=
 =?utf-8?B?YWxpUjltNFFDSVB6NzNQZ0FycDZSQnBtcXpoUVdwUUx3TFRxdGxRK3M3clZ4?=
 =?utf-8?B?blZsTjF2WUFWbDdXOW5jRGhQT0RXbFNkemdtVmpKbGlUOUZYc3h4T3dpTFdR?=
 =?utf-8?B?NDU0T3prc1QvWElzd2dkS2FQN1R0S1kvY2xhM0RRL3B1WFR1bGdvSkxOTVVk?=
 =?utf-8?B?a1FjcGk0SFhjN25pM3JkekxuZmk0ckk0SXRKVDd1OFVtRXRBdzcrV25KeU5Z?=
 =?utf-8?B?bnpTTE5vSkFOU0p3NDIyNnQrYTU2RGIyamw2cW1SVXcvaW5JQW44N1k1di9p?=
 =?utf-8?B?UGVEcWZzWVBpZGlPYnFZUDc5azd5Q3RjMWJVS0NPVXA4TUljWkJHanpneEJU?=
 =?utf-8?B?OFlURDhCd2pjbHhVY0I0Q2x3QnJRbGJVYXZIblR3RHliMW9WNytuM0x1aDN3?=
 =?utf-8?B?VHRlWGpsODJQM3dyelJYQmZjQzlwbnNwYnlNeGVrQ0V1dEljUlh2TkY5NFg0?=
 =?utf-8?B?a1dRSjFrU1NheVVvbWxoVDBKYXJJc3lPTW83aFJvVzE2S3ZvOWxqc3VBWEVy?=
 =?utf-8?B?MFJDbklvdGtmZzVmTFB2MHNOSWwyOVU4SXV2VUhCUytkQnZySnN1elphR01B?=
 =?utf-8?B?V1ZZczZZYzd4TGlkdTZkMUlqaHVsTVN2cjh1Vkhva2F1cytpL2dBZXRISC9p?=
 =?utf-8?B?UktXanJzMjM2QzZONUJmd2hqckJUV1FFckFCTG5VeENxeWxqZCtTbUUvejNu?=
 =?utf-8?B?YmMxelFFZUpmK2RKY0N6RFNIYUdXUzhmSGdUbXZMQUVmWnA0aG90K2didUdm?=
 =?utf-8?B?dG5JTWRPSnZmV09BbHBES2M5aURUeHJiTW1MZ2FEcjM1dVFTQmhDSlcrNjFy?=
 =?utf-8?B?di81bXN5WDZYQTBsR2p0eDZlQWJhbXZESHBrcVNJT3dkTG51aG43UEtCQ1cr?=
 =?utf-8?B?cEZnL2x2RnRlSUhnMHlhTkVSOVlpalNGYk9HZUIweDdPcU1uK3ArMHpxR0lz?=
 =?utf-8?B?V2tFbDgwa20weGFPZ25NckthWHRVMThlczBTK3JVdHlXNGpDY3JUblc3SnRW?=
 =?utf-8?B?VFltbGp5elFDNjNRV001YlB1dWlhdUxENHFySitlNktUQUFLcFF6SmRsU0cv?=
 =?utf-8?B?Rk0xZFBVQXd6QlJTWjJ0eHpDS29KTnlYUDMzR0pIdnV6M29jTWFNZSs2dVNV?=
 =?utf-8?Q?rXtFGACmdnQETJR6KGniaz4AAcnqGftT+ldueW1?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 50c3f7a9-8a8c-42e5-ba00-08d8dec4532e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2021 04:16:46.5354
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: b9vw6sFGKGm6wexYvF0oNaQjenUBDxbUmaP5wezryuHxX8jwBoT2JUMGBoBCQAjx3hXf3Q6cb1uqcWq5/9QbB2mDUtFErEw+kNHaSMjReeY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4552
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 suspectscore=0
 mlxlogscore=999 bulkscore=0 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103040014
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9912 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 malwarescore=0
 mlxlogscore=999 spamscore=0 phishscore=0 lowpriorityscore=0
 impostorscore=0 mlxscore=0 suspectscore=0 bulkscore=0 adultscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103040014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2 Mar 2021 14:08:18 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/ufs/ufshcd.c:1538:8-16: WARNING: use scnprintf or
> sprintf.

Applied to 5.12/scsi-fixes, thanks!

[1/1] scsi: ufs: convert sysfs sprintf/snprintf family to sysfs_emit
      https://git.kernel.org/mkp/scsi/c/7393d296d6f2

-- 
Martin K. Petersen	Oracle Linux Engineering
