Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9BCE6C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 724AB61929
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:55:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230359AbhC3DzM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:12 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:42574 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhC3DzI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:08 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jAsC192023;
        Tue, 30 Mar 2021 03:54:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ozuKx+cDafhlr/8h3wTJLto0yid/ifPxaFWhI2hEKXM=;
 b=jOmo6ykocA8VDSvaMqbueTy/reDGJ080hz2v0nM35GpSq0kUHWS3kQPI3avQReX5bZ2t
 VUIRzXHMVGRpZVqhU/+B7RW3iODHCUk8jCv9ua+t+mQA4zf5GJBTYSzJsoZnDjWxRy90
 ZoZmBWgPNZ92mv3xNS9aGFCxx8SLtUEbVArO7xzvRmj6S+T+ONtZy9zyEOKodzRw0zOa
 O7b+6YkIUZiIc0rB48PNrD6+ZQG2yYAKk5QZiEPbFI4uF1XmcW4T6QnJswXH85e2ita7
 BGeJ6K2QGqkV/bPs6LKKxScdZ6sfWYgv4WKGVVoZ0vaN9adG8U5liFEaRu+uL4HYwh/o jw== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 37ht7bdq4s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:59 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3jmr5152440;
        Tue, 30 Mar 2021 03:54:58 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by aserp3030.oracle.com with ESMTP id 37je9p60mt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:54:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mlSJfFo+XcH/6K8sHLBucc/yo1iT7CCLPRwfpRuuCqDpji9ZZEnhDdj+a8yiBiH5ccX++PDO+OwSHRfk9fhv+8bQSXRrjTlXfighIeNyMRYYBP7STxEGrZv2gi5+0XXfXmoMuczkf+z1zwnRd7bwvFSsPLgxuwdnGRA1WDd9ASx7h9WsLwB76nGHBsWAhrbAOaUeWI9yyyl6ZYW075Fa7yhAwqV3SkteuUkqqggWnyQDHvDR5MR8GiP0nTxe0Aeg4Jeti9ZSZLbwsAZYFjCBHbWYvXAB1duCMDtbDv2EVzNWKPdj6ksJ7rDBfPN2MDfvUPjWg3peJ9vokVNXvwuvOA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozuKx+cDafhlr/8h3wTJLto0yid/ifPxaFWhI2hEKXM=;
 b=ibZdg0NITJ3d3gj0PpWH0S7y6miWV1MaqhvCaV4NbTQPs04fbgSAV6wRjk1fZ/Ga2Y92qPYgdMG5erejf6QMVGl8uuFcu7h9yowlyr3Ump1yIbVGJc8fTK2oWkCQU0i1S5dNlft6VzhUC7MpvB5qGguxpKdBqojUEUEsq/IzoPpKuNCGhFG7iCwfuD7+njZPEeSJS5fHy/oU9xOLJdqmGyACWFwYpnZnnOalf3lZXCiWnpLo10T+IDEUmqJ+7h7+HrdF0kSFnYtVSaMztV3Hg6/9y+Njeyt4Fwvq55gzfeYzcVio+xMhlH2JEZNhf4n1BhoIw7SIypzH+HAj/pxRNw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ozuKx+cDafhlr/8h3wTJLto0yid/ifPxaFWhI2hEKXM=;
 b=vlJt5fx+QvykcbEaIDLHb8UAtpDj8s2myJYsEgTQkqV75lO/xotiDYevLXlj7uwZtrPgANh55GAbpV2qgfxCa0B/eM3VEGTOHTGHOVMVNbXBadY22KSkWPtuX7ZlR4ebJ4//ti+gcPthmpLwbG0c82h4rBdXVLatCWTsrQeEU58=
Authentication-Results: qlogic.com; dkim=none (message not signed)
 header.d=none;qlogic.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4758.namprd10.prod.outlook.com (2603:10b6:510:3c::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:54:57 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:54:57 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     anil.gurumurthy@qlogic.com,
        Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, sudarsana.kalluru@qlogic.com
Subject: Re: [PATCH] scsi: bfa: fix warning comparing pointer to 0
Date:   Mon, 29 Mar 2021 23:54:33 -0400
Message-Id: <161707636881.29267.1576763247353531442.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1615880930-120780-1-git-send-email-jiapeng.chong@linux.alibaba.com>
References: <1615880930-120780-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:54:56 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b193e565-cffd-4df5-13f6-08d8f32f959a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4758:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4758BAB91E08F32BEA627BE58E7D9@PH0PR10MB4758.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 7jC0NunYiHZk/Tayl6Q1ztLBnZr/mPQntDDR2RD7mXmvruUdpftU3Gn9HXwwydTIImd7luD0Mw8r26eCAKRvLT8cnWGHeRZW7VJwYKyyz+/SOu0M7MtyGgcIBV+aK8MuNwx9Yv1bYWnIrIIZ2AbYduL2XIsQtIsO2BRnCvSUjKtrNJsZKymEZ4YZH1Pe8WRI0blbXMNOVUr7A5QIn+MJ52w4o10S3hvTQLRbCdGje2vAnohYbna5lvv+5mAD6hgId2H81zPP0ZCffxY79Su8KDhNg8tRAmRNRnEuQ0aNH5zsbU0u/rtZJEwZl70KYe4O1TT8cCBBsUWgfJtr9FJ8CnwypEPME2Hso6MlppfIn7JV2cQjjpzUJeXWELesR0gKN78i0UJHp95BFMuyl2YkzgopJrXzETrcO0kF0f5adHwYnXuC74LJV7f/y/SpwAIn+zv7u1vHcVAjOow53MYszHtVjvtM6E/O0O0A5T0pzTK5dgI8zL9Tz8Y+8P3/eg5Nd6N9aIZy9R6lR9a2S9vGKiS3zuFy3ryqp1DQFeIDb+u9m7dE3e3pLLIcVEu6GubpKBEZ40Dbn5n70kpsoLiCKkysN9poUZGbfQkZHIvVtijTYCx/3Jolgp+hfuxLJdVSjx7SBsTxss7u3eChtKvColhI6zp75qv6mS09Goxhyk1TurFdQJVJXxOtuIrfawNT4YeuTsXcZtttF715g9p0Hw8lDhbwCSjwm4OszJSDzlI=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(376002)(136003)(39860400002)(2616005)(16526019)(6916009)(8936002)(4744005)(956004)(6486002)(8676002)(966005)(4326008)(66946007)(66476007)(36756003)(86362001)(2906002)(103116003)(66556008)(52116002)(7696005)(186003)(26005)(478600001)(38100700001)(5660300002)(6666004)(316002)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?NE5jSFE5NUxuZnBhcVBzdklmcjdUbXBsVkRpSHlYUFhEY1p6U2pmTTRQd0pw?=
 =?utf-8?B?NDIxRGEwcVJPSlJGbDNkMWxqSVNHUS9PYXdoM2ZUUldxTjRoV1BRMlJxLzhG?=
 =?utf-8?B?SG52V1BWMlo2RmdlUFUyUU5jNlBLZ0VMbWYvM1FtV2ZZWVc1YWJIcCtNMUc2?=
 =?utf-8?B?bSsxQnpLZ2lWN09KS3NLVGEwdG5IVkkrc0lKcDJBNGFFbG1MVkczYnhtNG8x?=
 =?utf-8?B?VzJGM2lnUXdsYlUvMWFHMFdza2xPYXVkUWZlMk9KWTFNUnZEYm9QT09NaHVS?=
 =?utf-8?B?WjBMeE52UC9GWkQ0Z2ozNzc3ZmxYTyt1eXVjTVBsanJoSXlLRTd2WlplZllx?=
 =?utf-8?B?WVN5QndpQ1VDOEZwbmgyUHluUGZlZGFmVVZzbHBQaWE5R2NRUWZQU09TMWpp?=
 =?utf-8?B?WmQ4cGM2RE8rRGJrbmRFN2xhdmZHZFlPL1dka0FVSGc2U1VGMGJXRWcvcXJG?=
 =?utf-8?B?YVdhSGh5K2F3emxjU0cyRlMwb21UVkpTWTBWK0dnM3JGTWMyd3pMM0h1aTNy?=
 =?utf-8?B?WHhVaTRzOW9OSnRBSm0rOUpWSGpranphOUovMGdRMk5aT2k3SGllckIxRml5?=
 =?utf-8?B?emVWbTI5MUhCQUhUa0JSZkU1T0tQajFyajdIZGk1TVVQcVNjc05VbUFuZnVS?=
 =?utf-8?B?TnFnaXFqQit4RHN5aCs3N2NLT2hsQTFQVkF2cnlTdDBTMGdUZnBETlNYN2Rr?=
 =?utf-8?B?VmJJL1BJMVdSSUF5S2RFRXJ4blZQQ2NKZjgxVFNkcjlzK3B2ZGJDUXdYUkti?=
 =?utf-8?B?ZXBLL3lMNFRkNktUY1JzdUxqWjlXYlY4a1U0S1REOWEwb0o1T0lqRHpMeGZN?=
 =?utf-8?B?aC9GaUljMzhXUkp5b3pLQnZ0d0JodTVPOVc5dUlZVGNacFlWYkJsMnZETnNo?=
 =?utf-8?B?cDdlbVFBeEFGcHFwSHROOFNPRjQwaFQrOFpXYWNwcGwzQi9adzUyT1B6NFA0?=
 =?utf-8?B?dytVZjBMNzJUTDQ1d0d4R1VYWjg3ZW9hdmhPSnlpVzEvbFozSWhBSnVMVlUv?=
 =?utf-8?B?Zmt6TU9zazNlZ0RTM1d1OGNwQXpDWVhvZDBOTXJVRWVFZVk3Nit6N0ZvSTNL?=
 =?utf-8?B?VXh3SURSakNOc3J5UXdrRGdFTXduQTRyTmtrcjNKall4M3kyQWJnWWtCNk04?=
 =?utf-8?B?aWE3bzB3Y052TUJSNGJ5Ujl1N3dRajM4TEQ3alIwMDdtTUhXNldmYkRhbHh6?=
 =?utf-8?B?V2VhS2l1OEhKeXdRdm43MWpJUUxQVEE5SDVYUE9UcnRKekdYMTI1R0syTGd5?=
 =?utf-8?B?bERyNVE3T2d0UWRsK2lkUDJJaWxxQU51UC9iR05nSlNhZktVM2Z1Q2lKRElW?=
 =?utf-8?B?SVVYc2V3bVd2V2FQN29jUkFSRkZhOFYwaEpSd3NuLzVkdFRER1A5d01wS0Vv?=
 =?utf-8?B?SFpjcUFmbDFNT0ExNmZ1OTJIbFdxL1FDY3d3TjhpQ2hGMVBLWDZrdlZ6S3Z4?=
 =?utf-8?B?cTB1clczcVVxa3E1SmRiaEUzMkpJZmtVL0VId1NPYmlCY3VjSFlWSXFpV3Nz?=
 =?utf-8?B?NnlXaVBxVVlremZUSkMwNjBKSkg1MzhsbzE5eGFXeWQ2a2FaSzNtQmxNMkR4?=
 =?utf-8?B?dGd0cmx3UFRUYVRWbmJrWGFacGpZWWdtcEFkTHYzN29xdTJscUJndjRiNHpC?=
 =?utf-8?B?NkhCSlNnR0hGdjVxangyRUdMYXBtc2IrZ1Rqbk9RUXNrd2lQRjQ4OTRuU2tP?=
 =?utf-8?B?QUtLRG4yeEU1R3haOXpoZ0ZRanMxcmZMeGYzdjRZMDBvSks5ZitVZkRtSElx?=
 =?utf-8?Q?zCjInJBvxXvgp9tDBdzLYI61h6orJlbqq9jnlLv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b193e565-cffd-4df5-13f6-08d8f32f959a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:54:57.4040
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: q2Ga0vERsstqZfj4+EoX1RCrjcU073n4sRez98Is6kM1dAQGc4yLXe/lbqr5lRmeu/yDXHJxgzk2iHvoPvDcA/RhmLDsGMlGe6AF2VlxXZQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4758
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 adultscore=0
 suspectscore=0 bulkscore=0 mlxlogscore=999 phishscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
X-Proofpoint-GUID: NTiZC7vsTXhumGI3vJeFflMSEs9aFZx8
X-Proofpoint-ORIG-GUID: NTiZC7vsTXhumGI3vJeFflMSEs9aFZx8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 clxscore=1015 mlxscore=0 bulkscore=0 priorityscore=1501 adultscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 16 Mar 2021 15:48:50 +0800, Jiapeng Chong wrote:

> Fix the following coccicheck warning:
> 
> ./drivers/scsi/bfa/bfad_bsg.c:3412:29-30: WARNING comparing pointer to
> 0.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: bfa: fix warning comparing pointer to 0
      https://git.kernel.org/mkp/scsi/c/1630e752fb83

-- 
Martin K. Petersen	Oracle Linux Engineering
