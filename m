Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0256C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C129161040
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jul 2021 03:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbhG2Dh2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jul 2021 23:37:28 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:53398 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233485AbhG2Dh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 28 Jul 2021 23:37:27 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16T3VbFR005062;
        Thu, 29 Jul 2021 03:37:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=/No0cRM+YQ++wDvAwvo4rzzwAwS5TYAPJvqxESRKgso=;
 b=Q64RWOOMVs/ZE2+3v6Pt5RBrVG7UWcoF/Ec9bGyeJa2WlP1a2Tqa3YDLhHcpCYXqzJBz
 fwRhRxqFCegUUV+juFWrbAhnQUFKTCTRfOs78bjJ6t8D5jY65eJD412rCAyITrW1DDsN
 YVHWBFJcYSWQFUpQ0kFQawtYfxHC07mPcq17sAf6mwCkJ63G3BhFejFHO2qP/mAKvor7
 fMWrs+EKmzru3eISEZwXa8cp2r3tD9LEU5BjlU4zctGw1v+ZnlNcz03G/FUqFdyJ1Fn5
 Wn2DpubbjBpT8evGi68yCxC5S/XexDfjpj5VFnC98qIp1Nzd22+0kyZ4GiSnPziYT6XL Jw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=/No0cRM+YQ++wDvAwvo4rzzwAwS5TYAPJvqxESRKgso=;
 b=p5htmEkIOd6/AUQNhslciuTf/yahPqdNY6sFm45GjQ+LXuqup32xRwaE8HV7Fhde0T7w
 2YHNJUKctonJqrPhXj629LTo2Z9LiDEsiLm+HKXONtKK3YToHT/80diSWho/mQlkqhYY
 B6jzBaHSntQ2Sx+emcgS64a3d5uQ28d5qo5v4GejcZGVfHrpti/ejgNBZSy2w455wO1H
 1PayP2xwMT27E6puO44nee64p0vYMrZovv+nzztSNhpzdky4D9rfwgwPtaXyPWwNF7uQ
 jdhhdq3mE32fY9lB+rQxmvFv5WOMpUZVYUEGiT0Dgpnzyb9kHgmKywIpmZGu7d6CIhcO zA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a234w67fj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:17 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16T3V0lK035553;
        Thu, 29 Jul 2021 03:37:15 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam08lp2042.outbound.protection.outlook.com [104.47.74.42])
        by userp3030.oracle.com with ESMTP id 3a2356hmxt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jul 2021 03:37:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lyw4kM0l9Qx8aN8HpiqOS+FwNxvhYZ8MZvlpj0rUvW3oJYd/BQVoYT4UkrUpiRNg/QZjzc2dOA9iL7JYick2i6CizOh6d7gyVzKAOjOaHevQHqNZlQwSzayjEjCOn6C+HQD25q6N1r7HHHbywNKhtdt/vr8o95VqckN1WMIpWQcjb3pTPEUlITRgLrRnrySeNc952PkCKwp+5Puyy72DsJC7WLSRoBTpMToAT4mP9ROAmEjiZVE2206zzGdIx8GfcZaXUV6wvFYMwZLPI7I4r8S6dUSDV5W6T8WSe+Rhd6kx+pWZpKiO3zP7+uH9zgcPl+7ErNP4U1bHvZWDbE2HAQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/No0cRM+YQ++wDvAwvo4rzzwAwS5TYAPJvqxESRKgso=;
 b=FWodyfnPzOenbysyzp+JdX6Jr6xf4L2iMEM+6ItPNhZpZWEXjJohv/nI/VBuRghgTcvdbUa3cjeUQbdnojr2KYl/QoYMJwHuGcTbb2iIgWLTMTPmsTRfCcrjMeJPK4bbNFKw3oTy02xlQ3NMJmhMBpxwJ+4H6SOyXZxFNxYoB8BeBFmS05RcA+QdLA6RFFwcDY1J+kuoZGyeEVP0R81LDVobYPljjWxYoefZaeZ5pVRuBdofqXC98FfbHRaNbzsOQkl33HnSvE23hZ9UGlGmveG8ibG49xNd3ll6aNBUVTxhqVuwiIDc7hoT+o7rBNj/IuFgb585fr1v0WXtu6jeYA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=/No0cRM+YQ++wDvAwvo4rzzwAwS5TYAPJvqxESRKgso=;
 b=EBVfIvhZVC7h8yYXjSwYoNFRcaVoLIp056aAQkNAqnWa2amMj270dGwAMRYUW735xq0D5TeGmar7fImmgkHHsJsoIirviWKTOQ8qMFkO7mOGOcn7zHPhTb0UdrbjV1AYm6HelinA8mHFfVZ6Fpsss0/18YDb1TigI4lsyPZTSpA=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from CO1PR10MB4754.namprd10.prod.outlook.com (2603:10b6:303:91::24)
 by MWHPR10MB1549.namprd10.prod.outlook.com (2603:10b6:300:26::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.19; Thu, 29 Jul
 2021 03:37:12 +0000
Received: from CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7]) by CO1PR10MB4754.namprd10.prod.outlook.com
 ([fe80::79e6:7162:c46f:35b7%5]) with mapi id 15.20.4373.021; Thu, 29 Jul 2021
 03:37:12 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>, Can Guo <cang@codeaurora.org>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
Date:   Wed, 28 Jul 2021 23:37:01 -0400
Message-Id: <162752979291.3014.727185988515749106.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210719231127.869088-1-bvanassche@acm.org>
References: <20210719231127.869088-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR05CA0121.namprd05.prod.outlook.com
 (2603:10b6:a03:33d::6) To CO1PR10MB4754.namprd10.prod.outlook.com
 (2603:10b6:303:91::24)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR05CA0121.namprd05.prod.outlook.com (2603:10b6:a03:33d::6) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.9 via Frontend Transport; Thu, 29 Jul 2021 03:37:10 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc7f31eb-d780-420e-dd19-08d952422697
X-MS-TrafficTypeDiagnostic: MWHPR10MB1549:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <MWHPR10MB15495911860573B4B36EA0798EEB9@MWHPR10MB1549.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nZLpbPC9GA+sO/81B4T4XQx//9+DnXX1rz/zHzg+zhQHxftAqRrRNUxhF9bLy+MGk4wd7DAGD7k5JfdSdBduYi6MVjIvJdjFg4WGULn/H18WxjtDgREz369nxMLGM4HgNtxc3usyFI59LUuqNqX3E5rX9m0fKpDmubaJPCBl9yC6FEnvGRXf2qZs/j25rs7ZgzDr0OxTZk4XWJPkCJooiL1ydnDta22L9UdwaZyl+IM7dCbSSBjY+oM513+vow3zwmiMsIL0Epc/Zq/21pHhSIR6Gn1aGbtYdv1rZNKLqw6my6OnCs2XAUzKprMvWhpG91CsjOUSN+cUzed/gLJFLD422uXqMeW4CYFSzmujSApm92i5J3yjNpY1Y52+KG0DI1RoYI0iJIJxGZxSq5yliR/7d0JaAf70iOqItj/KLk26CtgJClHzpBjdBlBKoRhBnJesdkY3qNDDjheMLlvScUx7BJIukI06EzatzwLq60u9lRWrAPF6FQaZnldVu3ndAA7NjAM6gMJ5AjG+6XQEiSGsEccdgFvziiShi33DCiAA6z70czjhd3MLxADKkvCw2qHVvMeM/ieoeRP1V5ssX7rRVNVw9Y4BxVWXX26nQCi6KP30Iu8UhVIx/6uBR4tPFkwjPfAmznODzWbAqR10hcepk/NJMCzrlugKAbF+kvAih/MhdD58TwyRZPvy07KsbdUX177ghnnv4IMtRnlQOv7gquUTCeuyarvXat6UrPTMY5ePke6gYSR1e5j8m22mSpwmYEJs79enQu+l9Kv16A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CO1PR10MB4754.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(66556008)(66476007)(66946007)(6486002)(26005)(2906002)(316002)(103116003)(6666004)(186003)(4744005)(4326008)(38100700002)(38350700002)(5660300002)(36756003)(966005)(8676002)(508600001)(52116002)(7696005)(6916009)(2616005)(956004)(54906003)(86362001)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bVpXQWpWUi9TSjgzQUdVWDdHWGVLSVIyNVhzWlUwTWh3OHlZMzNDZDA0OC9V?=
 =?utf-8?B?WldQQS9MenlmenFaZlpsbHQ4bWYvbmp6WE9TN2ZISGN3Q2h1K0FYY2NBUEdo?=
 =?utf-8?B?anJIWVJjQWNuWUlOYVNwZEFZNm92TDc0dmJrMkpBTHBKUWZ3dmtOVG8zZUZ5?=
 =?utf-8?B?VVJzMXpWanduQlB5V2hPYnZTV3Rja3NCWHdGa0NYUXQ1ZjAwTnh1T2dJYXVP?=
 =?utf-8?B?Q1puemlUUzFUTEdReHErNDM3SFhEY3J3WVVkamhlZUxPbHdhUGRCMUYzUzBr?=
 =?utf-8?B?OGxBb252dzZQRUl0SzdnL1R3YVNzb1plRFZROVZWdnRDdXJzMHZVMDhCSFlU?=
 =?utf-8?B?RndpbXRBeU5YOXBPRW92eGl5K2VOemJoanh5QkNOamw3RzhPRFFxdXhtdDJo?=
 =?utf-8?B?MEtta3FFSnQycmRPUlJ4ZG5tYTF4em9ycDBOb3BIRDlncjNYTjBWTGsyRkRa?=
 =?utf-8?B?cnRCVzA4WHRnUnJZTGpLenhLaTVTTWViamxSRG9SYmUyeEFXQW9FVU02a0pk?=
 =?utf-8?B?Rzk4N2VPWTRUM2hVdWlGWndnL0VXNFFFa01FMC9pMWhKeWRIZklFZ1Ryeklq?=
 =?utf-8?B?RC9IaGdhTko4WmQwamdsSWRSWW9jTFdVTExoaVVGVHBzSW9VdTdVWkJOSGJ3?=
 =?utf-8?B?Q1BCbnZ4TEw0SkNFQVVvNFhTUWNzTmQyNEcxSE5WbUdSY1NMUjgyTDR2N2RW?=
 =?utf-8?B?YU95KzVWSlF3RlplU1l4anU2eW9QVjBaWGpnVVUyNHZHQ2VsbHA0T256M295?=
 =?utf-8?B?VGFZaWRtc3FJOWxZZHRha3MvemRtbklHQmc0SWZoWDF2d1FpVEZJZFVGZmlK?=
 =?utf-8?B?aW5keGZxbFhSeXo5VGsxVnJZNnZGZDFJSWF5TWZqZUZJWHMxM3FleU1aWmRW?=
 =?utf-8?B?dk9CMmNvbGx2S0MwM3N1Zno5WGRDSUxnYm5IdG02NVUzWDB0elpDbG02eU80?=
 =?utf-8?B?aXBWbEU0QW1wVVgvRElYRUltQ05ZVkd0Sm9USDd1MEppNFFtM1B2QmhycSsx?=
 =?utf-8?B?U3ZFaE1XSmh5RWRaVGZUZ2p0Wjl1SjZzeVZZNnFZNWcvMFNoSFlzN0trV2NT?=
 =?utf-8?B?Qng1Y21tcnI4d01LWkZzU2pWMFhhOG42R0U5M01RK0lKQWRYWjNCOHRzMWpj?=
 =?utf-8?B?aDVGSlBEa3dzdE1kRDlUWElpOWVMdW5yS0EwMU1Ra2JmaUJwNHU0a0R0T2Vq?=
 =?utf-8?B?d1A5WUxHSlZiQW84dWlJRzI3Q0FkTmoyU2IvaHRmOGxjLzZzZ2YxaUhtNVhV?=
 =?utf-8?B?YitBU2RMbTJpaWc4WXZIRWhaakw3TGlmbm9JemprUThKUkJzTlR2a2piVEdL?=
 =?utf-8?B?K2lUdWJ0cW9CNjAvYlprcWZRYm1BdmRWRm5DRmp2ZktVdjAvdk9TS21weUhh?=
 =?utf-8?B?SFEwK3k1SzE3MDN1a3l6WVNCSzlHS21DVmZULzd6R0s5Z0xRVGxkOTFCYnp2?=
 =?utf-8?B?ME9BT2dDWWljdHlXOS9Vc1lhcGZLSnd4RzZ3VEgwOEpKblIreEF4aHI1OWk3?=
 =?utf-8?B?bkhUYkUxMGlQNVY5NHNBdjFKNFBrcHRRTi9FUWZCMHIyQjNHSmMxUDBkbmRm?=
 =?utf-8?B?UTIrZVgwSjViek9GUVB1bUlrOE9Oa240QUdxd1ozZUx0OUhPTUZFNEh3OXRO?=
 =?utf-8?B?dk5oVnRNN0dnRWpHMUswTERkRlFYbHBOWklwL0hQdGo0ZXBFd3BndEM1ODlQ?=
 =?utf-8?B?aGd5UStwZGE5K3dlV1FDQnpYZnoyQVE4OG5GVEhGUy9wemRLQjZORWNuMFpw?=
 =?utf-8?Q?IGo/9gtPbhs+NbzOBB3ETS9M5xDGZPMQajpFhvL?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc7f31eb-d780-420e-dd19-08d952422697
X-MS-Exchange-CrossTenant-AuthSource: CO1PR10MB4754.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jul 2021 03:37:12.2961
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6CnDBi0YlXWVhFtxy3n21BxGqEsv1QCuBzOXpviEuTLDjF+VEWtSb+DsdaDXYjbd2hj/V92IhwT3AiMCvtMlTqVx4AB9mKgeKvkAoYtGR4U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR10MB1549
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10059 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0
 suspectscore=0 phishscore=0 mlxscore=0 bulkscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2107290020
X-Proofpoint-ORIG-GUID: dj7041QSqv2v7D6foEd5xXU26OrvnPiN
X-Proofpoint-GUID: dj7041QSqv2v7D6foEd5xXU26OrvnPiN
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 19 Jul 2021 16:11:22 -0700, Bart Van Assche wrote:

> If param_offset > buff_len then the memcpy() statement in
> ufshcd_read_desc_param() corrupts memory since it copies
> 256 + buff_len - param_offset bytes into a buffer with size buff_len.
> Since param_offset < 256 this results in writing past the bound of the
> output buffer.

Applied to 5.14/scsi-fixes, thanks!

[1/1] scsi: ufs: Fix memory corruption by ufshcd_read_desc_param()
      https://git.kernel.org/mkp/scsi/c/b1d5de8c6ea2

-- 
Martin K. Petersen	Oracle Linux Engineering
