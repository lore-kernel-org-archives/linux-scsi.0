Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 45BE1C432BE
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 24E0960F35
	for <linux-scsi@archiver.kernel.org>; Tue, 10 Aug 2021 05:21:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237582AbhHJFVT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Aug 2021 01:21:19 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:14470 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236963AbhHJFVR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 10 Aug 2021 01:21:17 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17A5B2vk010430;
        Tue, 10 Aug 2021 05:20:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=BO3+Pw/Gy+u/KlzZzmY1FC8zzH+UQbFVHl2LrVt+tnw=;
 b=FgsDAgpPJhlO6MdEUl9kIvBVtdQXS96drcF1/CJO+d1C/lldZMuOX4l67eZskpDaqaf7
 +0Rk4L/1+pWbWI7MAj/RE/1qqeDZF9YUd6z54VqssiFa318Z1x+EMe7khwNlSinjC97R
 Kl5ORfc957o/rixO/v9aUEVjrdzekpKzSg/54G/Q6a4XC+oSw3MAY3+Ws/Vf2uLbqgfT
 IUrA+Sh9VyjwjEFTMjb6J3nnnEnfOvmqTNEKS+6yHiHL32m6w/45hOuPfDWrvSryoTXJ
 +P6HPSyBHCveHYbrUIklEGHnWMnCyruuHsC546+G8yuYuOs8xJ6204E2RRnftg6LHylA UA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=BO3+Pw/Gy+u/KlzZzmY1FC8zzH+UQbFVHl2LrVt+tnw=;
 b=hE4B/ItwEczJtM7RGsFlkcUQG8Ou+77bFlkgNtWoXVdnoJWdZFqnF047AtBs8OJACnkq
 ZWmsw2oud2bFrqlS75njaKc3TDNhH3kjbRuLZtQeewSljfqn78InQJIPww/XhERcHGaC
 4tXYpbVi+WP5zTQWcZbvmTmnGLHCfRNGbwMWi0WcnIwaZ5XOfindTibeVufCMWUw2sL1
 UM+o0vt51uE+5f5vG5GO2EKoF1jdiaHeQXaUEf4FvXb6cRXOmBNqyBsgivK5j39b3mwo
 xPxL5FrheSkfdi+JH0LMju8IwgvytuHlyNONFYor/aJJDrCkzs9MQG6YXRMyGbnYs8AY kg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aaqmuu08n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:53 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17A5AS6t192278;
        Tue, 10 Aug 2021 05:20:52 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by aserp3030.oracle.com with ESMTP id 3aa8qsfewt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 10 Aug 2021 05:20:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=MdRI/u8EsnrIP8NTfInrLcnXmTLjjH9PgjIl36piEVrzMmM7rCvy7zHu5zJr3e7ABW2tU+iC4A3WjiKUJH/iP+WtI9de59sqwUTfpLSk6yP2i2ZwhyPssOTDN2f9ryMYj9FNc0hfBEI6Ujv1VCHSzak+V5yJRVlWCinpmguBdTga1NTEOllTJtDXc8Hw+PYjhHsqvLywMG7BDE3ekJFZnd7gC5QRxBNFvzGmvN9cp2CFVbdtPAgWJbGC2mwlU+dzXeLr1JebxhEJxWVwDx4EqJwyLwG7/JFV1ZlWhRxSGdAbwFRdUNauBxQY9cMAyRTI/f3W2DZ8A8TYIpCMnrZQjw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BO3+Pw/Gy+u/KlzZzmY1FC8zzH+UQbFVHl2LrVt+tnw=;
 b=YvrDdzy/nwtewUqrwD1+McIOCcTB4AM+AAe/8iaA0XAPAwo0/qIMVYf4M9+BAPsOPvwml7Ip/XnAAafzBiNZb/IhrgM+Hd7yYi2gNQiHbIOkaWP0JJlOQkyt9UREVbDE9lQUtOVm8bg3iH6zLCrHyTRHnqccH9IT6UQ6oOMvHRuJpGF0qxQ3BWOBJQkfvb05P5M0ZtMij7eNNszb1G7exJOAnMn3cBs+34+Gfcf87OYSzxHIC/nvADOZC7NwyBYoR3BnM94joUeiYlmi5PzUBzM3aXSmAbRlCLWlOunmycDLhSZ90rRDFnL1X+OzCva/dS9ktaTebUTmSXmJirc3dw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BO3+Pw/Gy+u/KlzZzmY1FC8zzH+UQbFVHl2LrVt+tnw=;
 b=KPwQ8xMZmAQNf91SASJNQulIn6FHWBMnvH3cKEg/nsPks1Drfi7rWNfD8Y6dOB39vcXymZdn8YrtSnL7ph5yciHLYc15kl6bvben+0fokH4EhgKg9qB0GOKq7KnZxMOtlYuOTTWOGJDxBCgaOAgoybvzatKkQ7xld/Hskb9QMLU=
Authentication-Results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15; Tue, 10 Aug
 2021 05:20:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4394.023; Tue, 10 Aug 2021
 05:20:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        Nilesh Javali <njavali@marvell.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Larry Wisneski <Larry.Wisneski@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        kernel-janitors@vger.kernel.org, Quinn Tran <qutran@marvell.com>
Subject: Re: [PATCH] scsi: qla2xxx: Fix use after free in debug code
Date:   Tue, 10 Aug 2021 01:20:42 -0400
Message-Id: <162857263915.15955.14547471805478023338.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210803155625.GA22735@kili>
References: <20210803155625.GA22735@kili>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN4PR0601CA0001.namprd06.prod.outlook.com
 (2603:10b6:803:2f::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0601CA0001.namprd06.prod.outlook.com (2603:10b6:803:2f::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.15 via Frontend Transport; Tue, 10 Aug 2021 05:20:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3eadf9de-fc7f-4ca1-86ab-08d95bbe9e38
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45978990B919D5A072B983578EF79@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: u+rfaVPFgj2ms/coNzitNnXPvc2Wo/3BV5WB3cvtr+8PGocwfUMhCIlkVwCiKoJvX/dY3DVJtnlWLQX5WqHlG0SUHsEj3kObAOfkGjdM2Lt5EFwJLenTwn2R0rc9480AxUrHzMU/0NWgsqb2SXM8Y7VxXPOcjwdCuBMqmwTgmcMxC8tTIh27Gcoe98LfMmGEWgtbGeT1OBVtVGXyjFXBYr53B1+nbXp08DvvDRmJsa9S+9LXnTlfol71pr4RMTxu6CnWFe//EOLSc7jcc1czdEE3q6zq5l6LVzjEk7M0H41x6dv2j60KrqOOt8mWJ/alJ0FcjAqsD2r8xhoQ7MpQG6PF99O+ncVRiQcJzq5oo9fl4HwjvJQUCJoX9Wa9mcNMNJJP+WvbrQBh9GN2bt7bPBd+S0AJFZ/TB+U1inxdIlGd4NtciuCoXjFvVvWutBXwvBoUh55SXgcS2/stFnGNHY19nj7O8N95OJMLYvyIKLipTlY//kf7ov8p1DNlmn8fJNlfSg1WK2nCW6jWpD8Mk1wGGKpAMX0HQso33dpNgCCvT1HM5aEL2geD+cFrG1KZX8ISD3t98uRFeZlkon+fMzj05rVhyJYgZuS6ktOuSPqK/0llIaXKktowvu4Sn7Lmq4RMWs0lOyx53iMnnDZcR4m06ecOirUzYjUhnAFGwHdl157Cj+/OGovfz/8yd+sQIkLNsI9J1OhTHgl+/DuxIIUeIyNr9GhjV9CM9tXQZl5kgUuCo72EMtQbJYJ8bIsoZJzvSYC9YrXXO8ODMNaN8sR0M5NGbspmyudBgzZMMTE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(54906003)(2616005)(38350700002)(38100700002)(103116003)(110136005)(316002)(966005)(508600001)(52116002)(7696005)(8936002)(6666004)(6486002)(8676002)(5660300002)(956004)(66556008)(26005)(66476007)(186003)(2906002)(86362001)(36756003)(4326008)(66946007)(4744005)(83380400001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UEpvQmRCRzZURW9FRXNvQ1ZuamNYRVZGWjNibjNwdlVLbjFlRmdLbGMxaWVu?=
 =?utf-8?B?Z1pJcjdyVGZBRmNsdUVaMnlnQlhUVmtadDBwN2I1UGJTZGltSWxHT0RXVEVT?=
 =?utf-8?B?UnBwMmhXNU12VjVYdFZUZXdTdWdvOG5PNWFMN3FDaXFWbHhDMDBRV2dKM1VC?=
 =?utf-8?B?cDc0dlF4NzVZQS9lbXZNYXRyalF0dFlDQnV6MDJHak1RTE8vUDZMQWJYTWlz?=
 =?utf-8?B?SEZuUjErUHZqRVZLWG4zQUwrYjREWDdPT1d1aFBUQUxiNVlCcm94U2I3TG9F?=
 =?utf-8?B?S0kzS3J2M2x6YjZaa1A4ODNrU1B6ZFpiSitRQXZYeG10c1Evd1Bra1poQ25C?=
 =?utf-8?B?MmlmeWNEQ3FaYURmcnFrNGoxbmw5QmdGQVM4a0h1dldIYXpVZHNzQTJvMC9v?=
 =?utf-8?B?WUxYYXFPN1RLSDJqZGQzZnlTSGhPSzFqaVltVStEd0NyTjgwZDhDeFVIbTBT?=
 =?utf-8?B?Yk1VM2cwUVpybkJpRVVJL2lJNlBNaS9sMXd5ZWwzeDhwQmpPdlBQU3BHQ09Q?=
 =?utf-8?B?RW5hVTB4am5MWHZjR2FycytWalpLTm5MaFUxS2U4aU1HUGpLcCtoM2ppQTBP?=
 =?utf-8?B?V1NPTUdaK1ZWSUE2ZkNsVG9ZQTdCa3Y4cVVtVHQwaytiaU5LeDVWTXQvUElM?=
 =?utf-8?B?Mkx2SDZiOXlXTTVaNXZjK3A3bEp6K3ZlOVdGQnZ3Qm8vemdLYkxxTlVLMWdY?=
 =?utf-8?B?bTRNbWNzeXo3YzJLZ2pWY0NnRlhhODNtOGc5cFdKZHVkYWxkS0hqRDBZcTc4?=
 =?utf-8?B?NUxNZTVMRVNvWXFOaEVsRE9hNzhzendLMDJrd1BTcmp0ZE0veS9vc3dTQXdU?=
 =?utf-8?B?MXdRMnpMYllrQWRROUozZFlLL09uWExPT1U0VElibXRKdkRiMHpHamNQeW4w?=
 =?utf-8?B?bUIyMG1PbXpacGhaRzhhVnJkNFlXKzhFRCtNUjZ4Slp1eWRWRGlsTDIxRzhF?=
 =?utf-8?B?a09FNzNpS3BCL1pMbnhuNXpQS0pXRXNuaHFsejgyUDU0ZTlaa2dzaWxvMXZz?=
 =?utf-8?B?NFFobEFuZ1FEOC9vUFlqYWhJM3kyeFYwL3hHalFiRWFGS0JjV1JSSW5QK0Jr?=
 =?utf-8?B?emVyM3hlb3NHYU1PQnNZSXZQUWJ6RTB3ZXF5ZEd1RG9GNVRjYTdJMDNBb1lw?=
 =?utf-8?B?MDdHbnBUZVl2cXF3V3NlcmVtUm0xRXVmMkxEMittNnQ1ZWUvSlVSdURjaWF4?=
 =?utf-8?B?M1Z5Ykd1UTVlblBLdzNUY0Q1bHhjUUpZZHVFUFMveTIwVlNCZk8xMkhTMmRw?=
 =?utf-8?B?ai9SM21lVVlRRmREVEpLWjhNak1hYjNZVXZyMEZhUzRoMDZ6NGNxSzM5bmhx?=
 =?utf-8?B?bjhPUDRSZmFneVdXbmt4NnpiMmowdy9SaXBaUHJvQjhNU2Iyc0txUTQrVFlq?=
 =?utf-8?B?VldmSDVVM3ViQ3huVkVGRXZVekE0QTJPT0NQL1BWSVF5VE1tOXlVdFNNZmhC?=
 =?utf-8?B?bDFQeFlHbytOeGVPeTJJQmprcUxqclVjT3lYY2R0TDM3SklmMFZ3bEhNZ0wr?=
 =?utf-8?B?Y1VZY3BScFJON293UlIrRUNpZG4zNUJNVE5YR29najBOektKTytYWkpZd0dU?=
 =?utf-8?B?QjJEZ3pWcDhUMDErU0RRV2txYmMvbzZwNHRhZHo0NTVaSG1BSWpSeXZuNVpY?=
 =?utf-8?B?MnJOQ096alY1SjNrelJ3dElDODVvY3VHd3NUS013QXZGRDJIUHg4NXJHdUpR?=
 =?utf-8?B?eGFaREp2bEFQNFdicktxQm54YXRLL1NzWHE5MzNpaGtaQWJFNzRMWVRaWFRx?=
 =?utf-8?Q?fH/+xYs1afNi7TfONm0nI504H0TvtWubP1kItuq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3eadf9de-fc7f-4ca1-86ab-08d95bbe9e38
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Aug 2021 05:20:50.8174
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 78pomanuAsYZkJdO2d1nrDgVIb+djKYXDKysX6sx936j5EuTe8Iqdwd16T32A68qrvBb6UEzuwGj53EBnarCjGWEIJyEfcQcsQtTxljMqUw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 mlxscore=0
 spamscore=0 adultscore=0 bulkscore=0 malwarescore=0 mlxlogscore=895
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108100033
X-Proofpoint-GUID: F7mhFT1AAEDWjAnKXm5WRTjfUtbTlmKD
X-Proofpoint-ORIG-GUID: F7mhFT1AAEDWjAnKXm5WRTjfUtbTlmKD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 3 Aug 2021 18:56:25 +0300, Dan Carpenter wrote:

> The sp->free(sp); call frees "sp" and then the debug code dereferences
> it on the next line.  Swap the order.
> 
> 
> 
> 

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: qla2xxx: Fix use after free in debug code
      https://git.kernel.org/mkp/scsi/c/e3d2612f583b

-- 
Martin K. Petersen	Oracle Linux Engineering
