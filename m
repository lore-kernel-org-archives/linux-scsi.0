Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9F1FC433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8165B613C4
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344827AbhDMFtg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:36 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:52726 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344742AbhDMFtJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:49:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5ivcl160874;
        Tue, 13 Apr 2021 05:48:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nNmdd5oqWKxWRVo6t+sZhiy4BGAh0DyBkhdTVJDSC9w=;
 b=cODVp+st2AmbRMxDuIMjJgHWQThMmGqIzhh8F9XHZTtEVWaNrgGjYc4tva7j+0aTPyJu
 zXmfMnLhWgKGETwB6iIc3F5WXRCX3apG23UnuB0SGNl4KrhM+K6DCIVeFrtEtkVzs09S
 yszqb60PjLZ9LjON1lMhnkF+2x/I9vr3rnfVK24BJUcSJD65NVCt46aSsVU+jdNQm2pS
 wZtmhbDi5MnaDmGgLKFlGSVHwdWk0iqMeaGXnU6n9qNUKEdhoNnoPVUqkaK37usNeHmQ
 HwZcG4zJkOgGd453frBRnjEcK7BcJwDHgvjOgHg0rQDYGcADHWz2l1LDFz2ADqhcQjjE zQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37u3ymdsqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:31 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5jRk7090719;
        Tue, 13 Apr 2021 05:48:30 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 37unsrxccu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CiLqLUdu09v1TziPRqQPxFPksb0/+MxdCSjn8IUQErwhDIdRKYz44dYQi5AUXGNlp2FJSnZEjioFdnKGfqNMuTt5/ik1URBlVyXwJraaTCgz1oxGORMYwsst4iuQr3pn6iSMwdPZ263xOEC9AFOg85sDEy2UikG4UelJSVlIBEFW8MPFn4dVw6eAbRRuFw5BL7OsiHQUr7sCnLLKIu0KJd8cU7EVV33yrU2GcT3RYs8JkqVWRo52jMmk0vGeO8Kp8pWBkuoaQjiLED+ulYGZF3ukVhiVUE/WYWhUOnkHeFfaaxlR2SauB/xh35+v94/tbqb9sX87wnptDR20I4AMmA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNmdd5oqWKxWRVo6t+sZhiy4BGAh0DyBkhdTVJDSC9w=;
 b=N1PIkKEuon69qPmiyhBpz450X3Ib5D405R/zQPgU8nFHuS+5CnmGNjHP7Sw7QS9Zp4WJhKf9pjjw68xd0WIY4Yzdccj34bqjKFQ9LIhgW+LLcfVGxgtdrZCSzp2e4DTEmQp1f8iXxXieofVzodAqe4bxx6K5Tls6fWBB1LvjSzVsRbT9I6PYl2Hs0YxTf3XIuRBtCfs0vl61zRtIpi3hm8lzjNVZbVZevGIjWQHZvqkbIyUIr7d1QVWQs1jvlQ3N65NygkTAcNgykvqmEdcBeGxx9BZna9VFU5m/WmtLJ+Xauf8OSrNJPv8Vm/+jcL9R9nbKSru5X8EJWsdBoixURg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nNmdd5oqWKxWRVo6t+sZhiy4BGAh0DyBkhdTVJDSC9w=;
 b=eiWXq2ELtUVPJxFTev0PpZxcKWv/lCo15YQlIK07H3YLaatluscynHeTCWAA55UH8eCQNU/EfhDZ4+N9IGy7Bc3UAaA+3rReX/cTGFR7A9cAIS+v5pmRMvJIr9N7TqYSrZTEmRRuSXxrEPifKJiqBmnaNf0kl2CA8VT+RESlhLY=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4614.namprd10.prod.outlook.com (2603:10b6:510:42::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     john.garry@huawei.com, yanaijie@huawei.com,
        Luo Jiaxing <luojiaxing@huawei.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linuxarm@openeuler.org,
        chenxiang66@hisilicon.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 0/2] scsi: libsas: few clean up patches
Date:   Tue, 13 Apr 2021 01:48:14 -0400
Message-Id: <161828336219.27813.14849607159789110806.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
References: <1616675396-6108-1-git-send-email-luojiaxing@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: feba1764-2005-4f96-dfcf-08d8fe3fc368
X-MS-TrafficTypeDiagnostic: PH0PR10MB4614:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46149F0D14802AC9DD3A73488E4F9@PH0PR10MB4614.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dUYpwZKWPry9xbMNe11CsLKmGbBouQOAw3zuSmC0JD+AaD3ST4FvrOu+XDuwuaRRcmhv6SrNfk+JuwVyH+S00PVH0ONMqv9+6yXbRb2YuODvN0oWxigyzvV4jJ31gdcxPpjZq1i4Ri/0OS2t6DDhzoWyjJmCx3rGQjK/1GXM0iRboPuyQ3RnvUhq5tV0g6WI+K7Sp3+dU7iywNEcd4MMbNG6OlkyuLAcGhNYoBY4v5UFKltXBVcXnL7cR1WAsTc+99jx1N1oH756ixFBa0MgWfiXPqy7q7g/57uM5Mt/JmYXrdmCVwjpgTXaUwjolMq1hb1k1S0vrXUJ7qYdESOvUhsBN8qpFLTfGflqkoZZTn/NdqQevmf9PUaPFzMYBNSNiHE0b63fjJ7pOB8nItBiwt3vChPdX0HtiYIX/FZCOOOUDnmvI6s42XbvvVdhf7/WmIh4YweFLHr3Ub1v12yc/v65TPteOdMTstkh9LjsGe9WU5idKX+dlAD6lR5IQjuDHOU3sIuqGAv/6d3fthCfVi5n2WyRFUO+D07lu9oXDwpoZ4Vup3f0mPeHcw1IwzeVDXsI94aBBJIfW1iGXNv/x6/9A8TMFIxTMILGT23SbD3RPOpKHSxKZMWG4DEOgQarKtMeI/yazCyA5QSrB3n0AlgTHwplw/ViT2R8YTvQvBSUQHSjsY2L690suzOG7tYWbL3p38hxGxwBbV9b/apCvjSPJ1M9jqlhhgr9lsqzwUo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(136003)(346002)(396003)(39860400002)(966005)(2906002)(4744005)(6486002)(4326008)(316002)(478600001)(66946007)(8936002)(38350700002)(83380400001)(66476007)(16526019)(38100700002)(186003)(5660300002)(6666004)(66556008)(26005)(7696005)(956004)(36756003)(86362001)(52116002)(2616005)(103116003)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dTlLSEl3N0daN1FmanZSaFR6R0toN0NRWmk4YkZRNW9JL2VKMy81Z1FSSVg4?=
 =?utf-8?B?MkVSWHp3OTYxeW9SS055UU5kOGJLRzVvZjJQWEo2WUs3T0RlT0tXanhLT3h2?=
 =?utf-8?B?NDNQdEtvMitXRzB6b0J3RHpNWWdYRFIxdUF4QmhtaTM2OS80ZXR4dVBLL0x3?=
 =?utf-8?B?NmtrNXo2V05YMUlFQmhWNCs1NkVRMUg0V0QybjFkajFZYlhhQ0lURzJZbGhu?=
 =?utf-8?B?RjU1T1BPMTExeHlpa2MzOS9mczZ3RFpoVmt3cEMrMXZzSkNiWjJqZmVSNGhB?=
 =?utf-8?B?MEY5WmoxRXBaSWtOTkd4UjlmV1d4R3pEbHBPUHJOcUVyYkU0VlpzUk9ubHpP?=
 =?utf-8?B?SitPaTlHWmNtTkJMOTFzNm4ydGpibU9RK1ZNQVpxNGh1SUVZZGRXOERCM1ow?=
 =?utf-8?B?WU1MQTBaKzRMWnlDMG5CRTBCa0FycWtadGd0WDJFbnBERTk3aTFCeFBLYXRL?=
 =?utf-8?B?TmxFak5hVklqVHlYZXBDU2FZZlVobjk1bUZ1c2MwMkthV2JvMGJFYVUrVDJy?=
 =?utf-8?B?UXJKeGlMakMvMEdpQkZmSHZzSkJLNjR5NU1LN0tYQVIwYTdzRXNJbDFiTkk5?=
 =?utf-8?B?Y0NjeUlla055Vy9CK0QvL3psYy9lQS8rcGl0K3pCVmFSQm1VTXh2Vjl5ODZI?=
 =?utf-8?B?SFpuSktVbmxja2ZWRXpqUzVtYXpUVzVreFB1UnZ0RHVSSEcrMGdzZkNtUGpz?=
 =?utf-8?B?anhRVUJtNkV3a3RVdE02dFFaV0VBckk2UFRYdW0wbGp5eXVOS29YcXAyZWdM?=
 =?utf-8?B?V0ZxZzhGaGRXWVlIRlFYVmZHMEZlZjBlN1drd1dqZmZnYmdXTFFIaXk1aTdy?=
 =?utf-8?B?NW9qN3d0UmU5cUEzLzFSaFZzVElOMGFoZmlOSDdSVk1wdGpLWUVWdWd5cnpF?=
 =?utf-8?B?OWV5dlk0SWVPL3Bhb1FhaVRUbjN0NzhXTGlGcWlud3VwTk8yOW1YdWdRTm9X?=
 =?utf-8?B?Ukwxc1VCUEdRd1NJTGNwQ1B5NWZpQUdCUlljTEVSSjAzT1l5Rnd2SzlpNTVt?=
 =?utf-8?B?MnE3c0VzT2pXdWNHdHRxQ2d5bjlHbmJjcXZmVjg3UC80NjFyZS91eWRjZ2I3?=
 =?utf-8?B?cDIzS0xuSmRxa0pLc2F2S2h2UzNseUswVHVNd0Q0QUZUQTlXR01QQ0VuS1pm?=
 =?utf-8?B?Y0lDUWR1a0VWMFRuaG5WSUZjVEpSU01hWVNjUVJLcThwOGhkUG5vM2tESVRk?=
 =?utf-8?B?b0NIZ3I0WDdRMU84MFN4eTlFWHJaRWxNVmhvd0QzRUxJS0ZHTi9mUkdYb3d5?=
 =?utf-8?B?bDE0Q2MvNjRqOEpiRkMrYVM3SnAxbUM1ekk0RFdlQ2RKbFd1ZERlaGlZL2l1?=
 =?utf-8?B?WWpUL1Y3UU9Bc3djTzVENTc2V0hMVDFVTGNtYWlESXUyWGQwK00rbVJuS0xH?=
 =?utf-8?B?eElheUxvbXIxcUF3Q2xEclRQK2oxd2FCQmtPUEYwQVY3R2gwbXAyeVI4UGRJ?=
 =?utf-8?B?OElMYllNZUYwNlk4WGtpN2hoQ0FIOXhaeCtDUHFyMDdoZG1PMXMzYXRKaDVF?=
 =?utf-8?B?RTN2K1FBVTgxQ0w1eGNuRDNuNk5pbFZtQWtBaUY3NVFyRWYzdVBZM0lNSlRz?=
 =?utf-8?B?eWFPY2U2anJaR0RVN2ZldFNPajI1RU5mV01Bck1XOUZjdk5Lb2FWcE1VVnhW?=
 =?utf-8?B?NC8yazlQSmVDcjlOa2NveFBpSzVKL2JkVDBkYWtSVkxLOVFldG5YL20rNGxo?=
 =?utf-8?B?WlNuK0FtZWlhVm1RbTZpZzRSWjMvMkEvZ2dGSmZPWFlYQytTeHRFVWpMSEdZ?=
 =?utf-8?Q?j2M9vxJafOeIvY+1XyASPZgfwqebfH99t+DA93N?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: feba1764-2005-4f96-dfcf-08d8fe3fc368
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:28.9751
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: w/+3nlMm16BwUCOi5Dci0/CsIUxkPiAtqh6n82r4JK9geDntATUUOSfd+pYWHFilZBX9fWMbTPdPQrMq7w8OWdAWl8Y2ecJSWTmvwDmLjw0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4614
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 bulkscore=0 mlxscore=0 spamscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-GUID: 3LHyxENvQ9eHumX1GkzBlYTeG6p-TM4O
X-Proofpoint-ORIG-GUID: 3LHyxENvQ9eHumX1GkzBlYTeG6p-TM4O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 spamscore=0
 impostorscore=0 priorityscore=1501 lowpriorityscore=0 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 25 Mar 2021 20:29:54 +0800, Luo Jiaxing wrote:

> Two types of errors are detected by the checkpatch.
> 1. Alignment between switches and cases
> 2. Improper use of some spaces
> 
> Here are the clean up patches.
> 
> Luo Jiaxing (2):
>   scsi: libsas: make switch and case at the same indent in
>     sas_to_ata_err()
>   scsi: libsas: clean up for white spaces
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/2] scsi: libsas: make switch and case at the same indent in sas_to_ata_err()
      https://git.kernel.org/mkp/scsi/c/c03f2422b9f5
[2/2] scsi: libsas: clean up for white spaces
      https://git.kernel.org/mkp/scsi/c/857a80bbd732

-- 
Martin K. Petersen	Oracle Linux Engineering
