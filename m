Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED1F4C433E0
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A60722376F
	for <linux-scsi@archiver.kernel.org>; Sat, 23 Jan 2021 04:23:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726535AbhAWEXI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Jan 2021 23:23:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:41328 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726013AbhAWEXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Jan 2021 23:23:04 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4Dwam162088;
        Sat, 23 Jan 2021 04:22:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ebp6azgMGXyzj4bz4q4Y135zUSFUotRZKsxSPQbKUDw=;
 b=uCH+dBvzjU2l/q+ILXH1yWsG4sUGjxbH956G/RpKJoK+Io3e/zwb0CLGhIoJlauZmfMK
 atDguXeH0B8Za07/jCmGvt3CoBX2nFavep6BhV0rD8MEVSQqvFHS4n5JqIFkZLtFLn7c
 bqcWNqjkQquI1/V+wV3bikYCuqizCS3MhRiZggEDq8wshNF8mdl7qY5KoG5tK0uYHlDZ
 H3A731hYEZANas2jaP7lAm+NCi1T7Lp+vahYP/rCqhOLyLUbCA61PsVWrLYKWPTSPXoA
 dssoItxKZ8L0Gc2PxaDm4yjQZhzDMY6hBW8hX7XNlmG+Au5Gu1ohibEo3zTsc+oAFPor sQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7qg4vv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:18 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10N4L2Ya192996;
        Sat, 23 Jan 2021 04:22:18 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by userp3020.oracle.com with ESMTP id 368b4gswys-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 23 Jan 2021 04:22:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=AeXCtvW5GKiwWWGOdAXb/CxsvHs00UoppMsxyQPQwJPCAfGE58U4xbz0kHSnG3QqrG2GfMKJAQ4LUsO8+GFTC1NAW4V9nAkeqP6Fl160ZtP51gDrT6ihRl/Sac0C4g8Ki0MFcuxM7NcbWY2XpdAjUl3ew61JaUFe9mTrLEvCiT/7HPEaszgKMOLSRBFmrWwF6ngIu3KTTZN4WcqL+47xDeg4PcqXv6xdoxbt5vKJNRkEXV6yWCyHjkyh9+Up9Npto84OrI9syeZNxSn5GvAEJYQOK5E5LJPCi88TyrpLtJM4DNyy4AYqkvHJmTePmPdccePFmLZvhVerTHCB5z3xTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebp6azgMGXyzj4bz4q4Y135zUSFUotRZKsxSPQbKUDw=;
 b=PBjXRLjaUFUPmsdBBamdcJWJcrLE1cc5GnXiGSLImJTHawvaZO/upQD4mrAGKCQY0M8FCybcq98og8rqpLlHXYLVHqitGSgW5diCyNPmTruW9R3mGw6vdNhx3X56tTsRfK9wpMPRGqeIwg5l4HweGdV47eYUbPE4Lhj4D5tUcgvn8ayzGT7P+RyeR11nuEWJLIyNg2HNH+AXoVgNJceJUUvO9Wxmje5y/WoFiv8F7xRCLzOZbKlovlAGG/XZC+zOqhH/jjEhj8TyeXxzjv7HEvMb3gESmSIYwlsD/A87nMpB/MklMD+HwmfSJDvTlgQUFohzhpj4puFnqBzxlvJ+Kg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ebp6azgMGXyzj4bz4q4Y135zUSFUotRZKsxSPQbKUDw=;
 b=hInVnaZnX0Xv/vs3CXWLCqd+R8U/c+phXT1HjNURaFLOefVv22NrBjyzUVRNjNrIGd2tQbAr6XUOdcWfoTgFJe6QrEK3TwgAf/ZLwkbIO1KQwhvXauWuQUBeoLlpxPBKPugZswfhYcExj2JgC9Yw4PUyRRanMgyiUIpYUUYp0hI=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Sat, 23 Jan
 2021 04:22:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.016; Sat, 23 Jan 2021
 04:22:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        hongwus@codeaurora.org, nguyenb@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v11 0/3] Three changes related with UFS clock scaling
Date:   Fri, 22 Jan 2021 23:22:03 -0500
Message-Id: <161136635067.28733.8679703986850725313.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <1611137065-14266-1-git-send-email-cang@codeaurora.org>
References: <1611137065-14266-1-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by DM5PR12CA0019.namprd12.prod.outlook.com (2603:10b6:4:1::29) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.14 via Frontend Transport; Sat, 23 Jan 2021 04:22:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 53c7feaa-f075-470c-daad-08d8bf5676c8
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44393FE2E61BF787C9F9D2DA8EBF9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0BaYu+V0mzLTsePlg9u2Od6T2P3waslWyste+tRfcGJLrqO9TQyFPvOPuyyfRodL8qP5emyq+9bV5bILpegMM+UZuLrdCAwkkal/orjVyRheklPjeZMgTalMWLmVqyIGEPFgt165uacEKGEPi7mrAMQ/vu3w9JlJ2/lO2z86bq5eob4XkHDNAvi57rH0/dA5JfFwXIzV/p2SHxCq7kdHNjzCqn0rO8DCzHdkSBaOTkGJ5sXWgNk+qPcsylHSxS4j3+h1eLi/MzEwbKGfgnNZtrdBBjR8ADNbTiU8/tCTxtBezvRw7nVd8JcuBTaqveDKChNiaPzkW3vxiy7PKnlvW/Dy9Bw6Ux4w8ceVQ5J09knK8yaXCN0rAYBKZ8qtKNkd/YRLTzLNXe0Y37jq5NdejX9WZzoQELxs9XHJrbw1RgTREpkb8gtFHWIYcJq3BWRpNSPKqaBDgYczGAwZYPp+fg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(136003)(376002)(346002)(52116002)(107886003)(6486002)(7696005)(2616005)(186003)(316002)(4326008)(5660300002)(8676002)(478600001)(956004)(16526019)(86362001)(103116003)(966005)(83380400001)(66946007)(2906002)(66556008)(26005)(8936002)(66476007)(36756003)(6666004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?R1hjRTRzT1drR2FDK24zV24rQURIZUhvaklZWkJzRjN2MXNiOFdVMXUrTm9B?=
 =?utf-8?B?bWpONUFlVG16ZEtpbjBYcDlDNGZtUTVyUG9CQjgzREhhTExsazN6YXVicnVy?=
 =?utf-8?B?VTJGampmaTlDWnByTy9YRmkzSGZ3dldFWTdWU3oyUHRtejh4dlVoZHYyNHJv?=
 =?utf-8?B?RkcwOGx5N1hiam83dWJzMnF2UmM1eXlSYVJucW96alJUOEdid2lCMDBhR1Vl?=
 =?utf-8?B?ckxCUk5XV2hhcDRHMjkwUzNBYlFUOUhnajlhbE82VGQ3S28zNTFQVnJLdW8y?=
 =?utf-8?B?R3hDYytKbDYwNFM3N2dtc2lIb0NqMGdYRzRpRVA1UzZ2M3doU3ZMUG40Zmxm?=
 =?utf-8?B?S2wvWXpTeFBXU2huL3MyRTlxS1F2QjVtUloxUDYxVkpwOWZzMm1KVU8zYUxa?=
 =?utf-8?B?YnppYThFMUFkVXk3L0ZFYW5HL1JXNWpKM2NwQ09pL0ZScis4b2FPR1ZMS3Nz?=
 =?utf-8?B?RkswRStsc0poU29LQnhaVy95TnNmTVU5UVJWaGVWNWxtUmJxamhFeGtjSEc1?=
 =?utf-8?B?dFRyVUI5d0txdEZzOGhuUEJIUU9MUFJPcGdCZEVGNy9UTjRXVVRYTkhFSjB3?=
 =?utf-8?B?M250MFhLa1BpalVDcTluVTlHRFMxQlB6WlJVOEVBR21CUW1WekRrSVN2dXNS?=
 =?utf-8?B?WG1QQlk3dFRnNXFFUTFzMHl0ZUdvMUdMYUg2TTVlUnhOSytxU0JWVXZhTWFP?=
 =?utf-8?B?MGlLbmlGMGEwNFRpYlZNL2V2QUplR1JBMm5yU0dvYVlaanN0SStuTi9CTjRa?=
 =?utf-8?B?Z1hMcXJrdDIrVUhOV0hSUkFLVlJLQmNmeHZaN2ZZTnN5Wnk5T01wZkRoVzNp?=
 =?utf-8?B?bW5TTmNSTnYxWjQ5VS9FRFJrelM5NFBVenlNY2V3a0F5NXVNU2V4M0J0NEd3?=
 =?utf-8?B?N0ZScnlBdUZ1Q2JXYzZLNDhWYTcwRTFYS2Rxa25SL2lpd0s0NDJIMXNKd1Br?=
 =?utf-8?B?TXlUcGNqV1pvczU4bTVxS1RTYmFhZjZoMUZaTUNFd1JxUk1VSWZWWDhaMDlL?=
 =?utf-8?B?Y01rd3F3VjZ1d0hocVFxUk5wRkFjMWRSY3MyUEJ4eEduNm9QazRVbE93ODlu?=
 =?utf-8?B?SjZXU2VET1lHb2VheWZFZnVUazZOYkVvbkc3TkRWell4bkFwblNFQS91RWxO?=
 =?utf-8?B?WjNiVHRGUTJNYWNjMkhTLzdlMVI3L1pmeEJNRUsyV3JjVkNhY0E4cEpCeldu?=
 =?utf-8?B?dm8vY2IwNDdPUEkydzAxQ3dzaGxkRmNZbUx6WUNYRXlLSytLbmJLRTROdTRQ?=
 =?utf-8?B?eGFDNE1maDhCeTl1dTF2ZFZLemtmZk5ReWxDN21nYmdQSXRFZVFwSHp0U2Rk?=
 =?utf-8?B?aWdUOVBuR3hQNEtKd0R1UEN2emtlM05nU0c2ZmVSZVJicG8xckUwMTNpSnYy?=
 =?utf-8?B?QiswU29CaS9DMFp6ZzlPVi94YlZwbGpDVXhWQW5MRDdXYVpkWktqaXpOMHMz?=
 =?utf-8?Q?FC+kDJ3J?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 53c7feaa-f075-470c-daad-08d8bf5676c8
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jan 2021 04:22:15.6272
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: li+bmblSnEQlQ+7niVF1AXCZ8L+KADj9s0emB6i+LcJm5DCaREbHjPMizbvbYSHsev4F6nc3cKVLkjq8N2AuCwvx+32SQEo+hWB6MZQzxzo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 adultscore=0
 mlxscore=0 phishscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9872 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101230021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 20 Jan 2021 02:04:20 -0800, Can Guo wrote:

> This series is made based on 5.12/scsi-queue branch.
> 
> Current devfreq framework allows sysfs nodes like governor, min_freq and max_freq to be changed even after devfreq device is suspended.
> Meanwhile, devfreq_suspend_device() cannot/wouldn't synchronize clock scaling which has already been invoked through devfreq sysfs nodes menitioned above.
> It means that clock scaling invoked through these devfreq sysfs nodes can happen at any time regardless of the state of UFS host and/or device.
> We need to control and synchronize clock scaling in this scenario.
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/3] scsi: ufs: Protect some contexts from unexpected clock scaling
      https://git.kernel.org/mkp/scsi/c/0e9d4ca43ba8
[2/3] scsi: ufs: Refactor ufshcd_init/exit_clk_scaling/gating()
      https://git.kernel.org/mkp/scsi/c/4543d9d78227
[3/3] scsi: ufs: Revert "Make sure clk scaling happens only when HBA is runtime ACTIVE"
      https://git.kernel.org/mkp/scsi/c/b02d51afca00

-- 
Martin K. Petersen	Oracle Linux Engineering
