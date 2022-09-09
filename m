Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7C286ECAAD3
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 04:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230033AbiIIEwc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 00:52:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49482 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiIIEwb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 00:52:31 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C252A123ECC
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 21:52:29 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2893Xfef011681;
        Fri, 9 Sep 2022 04:52:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=3LFPEK2qrQu3mSSxIecIDnxryxKFjBgTzG8SJKNhmOk=;
 b=GykeV7uFL6JIPwupfTJ15UtFBNte1VZ0ch6Hzina/zMmom2Ds9uGsm77DRKnCyQ+m3Yd
 V9BmFV+cxolo3ymNp5aNDKeasV1+esmPtBOYJXqBn+24z5n1Hcu8xAC9K7Lolvhx3NEx
 blncaJ8pNpS8Gh9mididOcZ0BKEZZKnC/jkGNPppCyfvrbC1srHbAL7bMsfe52nHqFA+
 9e4iyaK5e8mIGWYOSk3WDF9UbHxvUm6jmQyea87H/QArdwUnapoNhEJHj9tHltFblE2C
 Yz7f1yi7UkbXZd7LSld43oENYmKp2M/6nuhNjooIZbkDjN53TKVu8+cFf6TqtXt+GCJn AA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq2pcwd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 04:52:25 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2894fwFh028374;
        Fri, 9 Sep 2022 04:52:25 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwcdvjmn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 04:52:24 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=PBEBdq0NsQUshfbKrUoASESx25mBIvAbTEUy53ojT8hy5nvVChXhc3TbnsCQT1GG0r2/UFjVed1ZHWhhi7yG3yauB75sbjWvJtV4hcYhDAwH12iemcwigp1Y/SrWQLnIhF3q/mZEMhE9yJIxAuzGVbQE0o7Vf9n586VE9NpMTcgxGQm9eUJIDTLj9nL0x+uLB/HxCWw862ZaUNC7NtcAUGNolJt9LDrFNl2vybiKJoLGrT9qxgy7okW0FZ5vb3BaSUocwFZJzZ5V7rlYDQpLllrtyc3BT7lpSih9MjZItht6VNKx0s1bNDF3e5skjKOGTdEaf5nm61DHUnGnwBKJog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3LFPEK2qrQu3mSSxIecIDnxryxKFjBgTzG8SJKNhmOk=;
 b=XOAo8J6DsunyR3rIn6ErQmZA768+svqMN0uw0/GwxNaD86zHZreA0AyjrxxfHQiqtAHtGXfdzL27NySOTACOW9ix0ya40MwU9GzDxeXsmfFQNuZkSF2Q2nfxF4EvpGeIRvhYO3kG9LnwhqeczAplhQToIju0lHBso0mzuPM/f/fRFYslBbyjDq90+xipg5DWGhXPvHIt/DF075s21zfutx4Wu7B9ygPdH6f4QW7qycVuMv9p3D4aTvUukQY6LwZOrUNMPKduvUYryryycbEKnk0kDTaBlbxpqb/NeGXZc6un1EkSajQYcShAD609iCA1tl2V+qq9I42fkjM7AHm8xA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3LFPEK2qrQu3mSSxIecIDnxryxKFjBgTzG8SJKNhmOk=;
 b=H4DdDBCDilqeZ/h/xXkl+jGHTIvB0I3ZDLemDd87IYYyIt27D6ep2g0PuZL8Z1ZGduQjlqhqE3twQ4oGppnqSjZyJ9L59czcsG8lEZfCcHnBT2WIhJVMK1RYsNBEl7LcqdTJIAULJZNRtktL+8v3nfP9y2NNCf84UYDic/+93v4=
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by SJ0PR10MB4718.namprd10.prod.outlook.com
 (2603:10b6:a03:2dd::14) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 04:52:23 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::a493:38d9:86ee:73d6%6]) with mapi id 15.20.5588.018; Fri, 9 Sep 2022
 04:52:23 +0000
Date:   Fri, 9 Sep 2022 07:52:10 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hdthky <hdthky0@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: PATCH] scsi: stex: properly zero out the passthrough command
 structure
Message-ID: <YxrGeriePxA+JJ5l@kadam>
References: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
X-ClientProxiedBy: JN2P275CA0014.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::26)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e9909685-0611-4a7c-30b7-08da921f15a7
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4718:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /6Nh5xYPXflcwLTHF12C+q2HTwouAS1x/0AK2zlVeW9g2uTwiI2QH00rB2LgXvaHm9o419ElwnImLp7FUHWTxTT29hITQQoi7CuiJrZX8DU86bAS13OBNMblbz+pi/ZZffAQS3x1t1jzmyObYE+1AkS9BHGBy63M0/zm6YCe1cnArE2YhGOLYskGNAL4GIa41oCCysihh67Qft1SkizQNF3j4Z4bbvyi3EmRmc7ZPUabFPYeDgaD6Gb3WHSzqR//K1B896qjAOsrpqyJw7y/V5d7FADHP0onrMseOV71X6KrUX4V8Bxi0bAUyn4xWMw8829NHfXsGR7TzeEIjQ4ac23c3Smzo3KjoyfmAU1/IB8pPw8brE/mfjO4ve6QUqgb80ScOVauOm78l6N+KOHpJCMd9fYYUdpSU36y5LigDMTEa5eDbkeSVHTK5eIuxUoV/JStfL5Zo7HllgakssPEkS3VlVvlAJkJPVbckn8Z2a/QlsS9k1z6tlZDrRQkokEdoXJ5MjD4qLhjijpJesNeYH9bGqpVWW7HGxjxYD954db40D2DVA8yWeJpHv4iGf1KLHaLT+gTjjQV/2OtJXnOamwdhmnvvs37PCcYLQkWDt7bTJEWE9G+pEXALySSiVMClf/TAIoH5HQDBIM6Yaw6p0+oQUofp2bomyL0cNovroRbkAMU6Go5PjXWigMKdlItn1rlfaxvoAgdG90ZqXuSsGs9s5Ian01XI4UzkdxqYKKUoprvosmFYXK7EPiLGKIo
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(7916004)(346002)(366004)(136003)(376002)(39860400002)(396003)(38100700002)(8936002)(6916009)(186003)(83380400001)(44832011)(2906002)(316002)(4744005)(8676002)(4326008)(5660300002)(33716001)(66476007)(66556008)(66946007)(54906003)(86362001)(6666004)(6506007)(26005)(9686003)(6512007)(6486002)(41300700001)(478600001)(67856001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?MIxdyvyK57r8EtMiqkl4F369SkJZC0Zy1ugW7a1Pxq9AvCoureZlfDL3xXc9?=
 =?us-ascii?Q?5BBzDupvTXEJnVfhhPY/b4eDJ2ZSjeT2AIf0wqhsL4Y6OPD5JetsYkAaCa+8?=
 =?us-ascii?Q?7UI5PbaGT6Lknptsqz7QsJaAz6zwfa5dxnim65hb8pTYX442JfhNGZZQnqNQ?=
 =?us-ascii?Q?oWIB0EsKJF94GUkvJgb1CvENhWqKcgPy1B33lN9A/J+e9mE1IsjQ45HVP6a/?=
 =?us-ascii?Q?9Kit/NYsA4oy/cqq/hZhcMaA5aru2d9MF3vwTdDxx/O9/m4a/M9ZXouP/IJ2?=
 =?us-ascii?Q?q1RPiykzib2F5Be9/520jE2yK4eCLQTMhBVmb1qFYiUQWTHfSl/tQL/ab0SL?=
 =?us-ascii?Q?BRIzzKT8dFbIohHPOMI8ojMcLFlgCoNBtPJub/fwgGXb7TErxHlJZz+67arZ?=
 =?us-ascii?Q?AvMYCPT1YqKaaxSje+sdfE3kgJ5uUcjiFifAXWeEWx8RCnPoxk7V0oqi0Dc8?=
 =?us-ascii?Q?dcwsEDNpF/t2U9aR3dT+jCgH/rveBHrQrZFsN0MFc6Q+2p+O1QsIP1B7Iy6m?=
 =?us-ascii?Q?XzdVcgfYy9fmA1nIKCRiXao6fNJTbh7ZOiIS3thKIMyrSsCO8R2ILiVtmC/3?=
 =?us-ascii?Q?HakpOfeAiUjAzT3C1FCc9Emdg2ekbKg/askwzr07wm2iCFcDaHtO7fnpkJ/d?=
 =?us-ascii?Q?vOPhyd0qr5xZ9JB5LmYyv8vceZcNA+SdXD5NBhHdfFlThR1GxA5kpNsHnIwk?=
 =?us-ascii?Q?Wyt9GLJ8srKsvNyoMb8BlkScqbU/mZGkQUjO6teCbz87R2hcqcmYXax3m3rR?=
 =?us-ascii?Q?S5SPBetxFsfGVbgcknMS4AOERXVYSE61uTyiySp+Y18q9vxJXQrUCQK++flN?=
 =?us-ascii?Q?GfESyCIZWpsnNF+O9Enl6rI2/qgelpUkDR68AznsAvrU/Txiaasx4DIKpVwj?=
 =?us-ascii?Q?Ufv0XDm4tverrZ5VwGY/lP0ctYT2Soa4W100LkOan/Q0yMVQpGRz4ucWwYpX?=
 =?us-ascii?Q?178G6xWy0CRH+EGdAnQ+Gs2LwfhvShnypJEHksObxATKlgHRwGKkedThBhTC?=
 =?us-ascii?Q?odwrQpTPH9KcTyEjP9L4WUDJ0h05Y7UDYgpHLlHNjb7T2kzP89qI4BXjZ/X0?=
 =?us-ascii?Q?t8Mc6QnyrNYCoef+DHuMsxrtFt9f+La8igNfEhESRFIWLrxFaSFA/i9tTwcM?=
 =?us-ascii?Q?dUqiE4j0W8zTgk3IpUYgjCFDhMfRetb6tO4XmGrvK9+jb/dfBbzcJ4DV/ocP?=
 =?us-ascii?Q?WmXIn7yQqJR2psBAaAFnnHcEPp/UwVelkzTz5NsB+3i7qabmpoe8m4t8a9aA?=
 =?us-ascii?Q?JsqVwM4P7ESKY86f8ToKtK5VxkRr4o7nwihwfSOC8kh92hbPxchYL5ML8qna?=
 =?us-ascii?Q?yHPmuW0x7zkgwJHeijKf2kEua6eknwzfHeEiGJGqoKf6bWx2CsHSdeJtx3zA?=
 =?us-ascii?Q?p3QM13ivuhkYT4GQYd3ULrcKxPxWOHIhERrMmJv7GSb3blQHT0D3cAN7gz+F?=
 =?us-ascii?Q?dICbPKYZoD3PkEAVOpHRtu+x/geR3Y4GLhsP22XFdMw0i3LBbKOD1OO1DR3X?=
 =?us-ascii?Q?2zAItw2rWeXgJT9SVbzzZ5psLQPhEJpoUzF/v7hE1xOiq92Y2KG9URVspCJA?=
 =?us-ascii?Q?XRFfr/SL6QheYW+VE5o0YHOZMVFzFy8dIOZMFvFqpndSTN6lJsd1zg2ydksF?=
 =?us-ascii?Q?cQ=3D=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e9909685-0611-4a7c-30b7-08da921f15a7
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 04:52:23.2985
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: k8Sk1Yqrf1RLKLY0/AN9FysPXTq5zzdEVq/W40cMLKgTN1+4DSnPgxaDuew41OIlXqHHVJbzE/gRYVAx0VmPicJwK3M+sAmVaYT3FJxFAYs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4718
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_02,2022-09-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 spamscore=0
 mlxlogscore=999 mlxscore=0 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209090016
X-Proofpoint-GUID: Ex6Yox6nLd22mkSaYgbwzU0i-1rWvMcC
X-Proofpoint-ORIG-GUID: Ex6Yox6nLd22mkSaYgbwzU0i-1rWvMcC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 08, 2022 at 02:16:33PM -0400, Linus Torvalds wrote:
> Sorry for bad message ID threading, but I don't have the original
> email from Greg in my email, just a link to it on lore..
> 
> I'd suggest perhaps a slightly bigger patch than just adding the memset().
> 
> Something like the attached?
> 
> Entirely untested, but it would seem to be the cleaner way to go about this. No?
> 
>             Linus

That also works.  There are no struct holes. And even if there were they
would be zeroed because the reserved members are not set.

Reviewed-by: Dan Carpenter <dan.carpenter@oracle.com>

regards,
dan carpenter

