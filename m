Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2EBCFC43600
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11C43613C0
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 02:51:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238017AbhDPCwN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Apr 2021 22:52:13 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:53114 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237735AbhDPCwK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Apr 2021 22:52:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2nwt4164675;
        Fri, 16 Apr 2021 02:51:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=uPsr8HL1gT/5kpYxlQJ0ZR41iEHhsLoO7ph1j1VU+cs=;
 b=H5t/0Dugc2YpT9jaWizFwucvhIXp8buK+vMIcBZRyvZoqmYJ1b9x6imkkR/JoM/g6V4j
 xsR25XLX22RYd/II2fHcPSxvvmU0v+3ykRIj8xdWUx6aS4kORm5Udv4Y0kq0Fa54mDFD
 ibFB8lgx7teRja4ByohatACgrUxg9YOjE8+9zKmOFdAcdmR6g7nWLJ6f2JBPwIFktRZW
 IKgYUQ8vubUtkphVNq99Sbqukxhw50ww8RPkbsAqGMmYpLq430sF0nvDYZhroY8c6m1+
 SvKkxA7m26AD8Ka+x0KrivAO1fAK4dXnFh3MPghv5ejLUsawc6k+gLCQ+NeCmHbG5dkx dg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erqr1g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:41 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13G2oeFj162577;
        Fri, 16 Apr 2021 02:51:40 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2109.outbound.protection.outlook.com [104.47.58.109])
        by aserp3030.oracle.com with ESMTP id 37unktgk4m-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 02:51:40 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=k2fNphi8brIXqqZtyEGCkhQ/iIxcWLu6FXhIxtjDKxR9dz3Ck1KZP+5vw2Ytj+Nf+/sbU/2moWk7+Y5ntErOhY3kYsGruFIjbnoG2eqbP02teFAHuyGl02EFW2dpUB+2VHH/FQnD2by/s0xAZulNGQ/+VhqVs4qI6+AxSCzJxSLt37yVuGaPCz5ikTskP8psQPB6yK0QnBgiOBiyh6FfRmo82/Nj1x2dCt+NdPUGRjtkrvYYaq5F0h5qQtCRE9AJktfAikdLqwVxrYzxaWbaPsk4fxiDsOErsOMdZAVJfdChoySUDFoM74gW41XEiZmpu9i85pBftuEYWFrGGjFJGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPsr8HL1gT/5kpYxlQJ0ZR41iEHhsLoO7ph1j1VU+cs=;
 b=gUjrYo70hYyHsIyh/du9lRzaGntuq6+KcMCsgMCyDaFScetrAhQ7Js+X8nYqiChGb5d/vWiJzKuR9wdo/E7xWZUvQDhIoBAvRosBszTc8b0ZD2yROpkUcq84Wga8mHgKrwVNw16IsOeopaxdTG/wDsLGu6rJLNNxiXMoyrsI0R82tGinjn+njA+Ra8X+cxi+Oj1CkdzWpP5ZC3RlFY+0qRErzCmaj+8iBVqizlNdUWBtOWCZOTjWw6w8QZuVwIMVEfOV1KH2OcHPsP0ez/CZuFjjPvxhtxEFFuSBYk/aDARjtdXykjDYZ8jZJ1jn80obDzSTyamJtykJVMgH1D+A1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uPsr8HL1gT/5kpYxlQJ0ZR41iEHhsLoO7ph1j1VU+cs=;
 b=LXUk+yv2WmjEm+xulXvdlY8NGOwbiNsWVdZ4aS5rbO9BOJ56l3bE9pQGb3nlmLgCEY06+3pxwLck5FWym/YYSIXXz4d4OvS8RNqiB7ix1v6lK1ETCBfEldkpf6vGWLTQF1gIm1fJL6pxHY8kWAeJ05eua+DL3yALSzPLvSoia/w=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16; Fri, 16 Apr
 2021 02:51:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.018; Fri, 16 Apr 2021
 02:51:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com,
        linux-scsi@vger.kernel.org, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: mpt3sas: Fix out-of-bounds warnings in _ctl_addnl_diag_query
Date:   Thu, 15 Apr 2021 22:51:08 -0400
Message-Id: <161853823945.16006.9888995402418799588.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210401162054.GA397186@embeddedor>
References: <20210401162054.GA397186@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR11CA0023.namprd11.prod.outlook.com
 (2603:10b6:806:6e::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR11CA0023.namprd11.prod.outlook.com (2603:10b6:806:6e::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 02:51:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8f0ba2a9-a337-45ab-9fa3-08d90082897d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45684325E3F7B28399D9F4AF8E4C9@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dokwBsS8Dnqxs5Z3e7n7SV04ZDvEHdiGkrfZkLRuofi4skDJwp1Trk+idWYiB6ykBWPpzvH2opKHNk+P9vKrkGJXUEuiqqSvnHiyGVA4NG51bWQXDAZdnb4dBtlQv11vq8iXSMtOPpOvXRFlMF9E6bBcmq3h2t7huvBBZyKIp5Vl+Yy5ioxi5HWE50wUoE5m8d5mrEbk1TG7y4G8gpmdpyusW3oHdNGm92cGUFN8znbBPxNgcQlg0+yqbwCuJbvVQX8O4okAvxx0O0XpsjNM1PalAJTFQSKu0SB8k7ymHHb6IwcnFNfWZb22HpGV/vWf+LEEu/0JwH7bJC/USu6rWqyAYVirZ7sTf1WyZSPv/7VUK9E7zfvjOGxRjF4Natc//q5NWw4TgeteOxL5cwUMEAO9i4Gs9lZhdh0A0mPrVslMgmhUFgR+ZLkQeXxMDRqFCQN5gSFs0wS5hBcptq6xJf2EzZMwaFNqoT4k2Vdzm2YRQccygjSjHvVEGBG6hKd8nq7lCpSV/mpkYEPJFW1gEsoM21QsQocXm6bvd9RB8z+OUGZvG0GnTzkmZAxqI//MNjb+OIAm1QekYMCvpOPsMWxcDbpnP215hxM5+9+6YO+PBOwONnlnoS8gUWKyka4CpQGdt1eAijNPUfwnPDPhtG1MIPxHCJ5R6YzE4KSYo5F4HEduVdRE1jBCysFAXPenF3eUauHLAdPB/+HoG5tTICM66wPEe1VMfuuk325uqxWMnrBajwsnaHGuniOGNhYS
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(346002)(136003)(316002)(103116003)(6486002)(5660300002)(478600001)(26005)(2616005)(956004)(8936002)(83380400001)(16526019)(66946007)(66556008)(66476007)(86362001)(4326008)(8676002)(186003)(110136005)(38100700002)(38350700002)(2906002)(36756003)(966005)(7696005)(6666004)(52116002)(4744005)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TjVxb1VWQVZQY2pHWFBqYTdJMXoxUnBrT1ByZUZXaVhpczM3eE5jSjZTUHFy?=
 =?utf-8?B?T0N6S05rdWpVc2JwVjdVUTlybGhsZnZQRWxmZWVkOUk5WFNyUEN0L0NKU0Fa?=
 =?utf-8?B?MU9VbksweHVtcmJJeHk1anJURUt4Qm5SLzVKbjRDV1MxM2NGYWZPOUJVMS96?=
 =?utf-8?B?SUpzbERoTTdqVzJmdnYvN3NIZyt4T1VxK2FQT3ZnOG8rL2NyM3hDSmllQ3kx?=
 =?utf-8?B?MnM4NUtWcmZOWmZWd1RCYU95TGlkZVZHQnU1NUxhV2VqMDZiemkvSXh5OXIv?=
 =?utf-8?B?R09HMlFXT1JwN1RhNXIzeGdST2p2YnlNVUhDbzJwbC9qSFh6aHFKZHVZNFk4?=
 =?utf-8?B?bTVCdE91bGdDU3B3d3ZmS1E0RWRmQm9NdmJUL3FGN2ZHbGxrRXJqb3RyeWdS?=
 =?utf-8?B?SWY4MEZNSitxVjVLSG81NlBWU0M2YW9VNVI4RlRQYW9HSVIxakRmL3JhN2lV?=
 =?utf-8?B?M1B1TFcyY0YyOEtIZE9vZThXWWo4SGZiSVp3MTFhcEdNSDVXMjFzbWIwQ0sx?=
 =?utf-8?B?SFBQWnl6OGp1UDRmb0JNd0VuVFdiQ1Q2QUZ1T2ZheHVkUnhpUnBDQk95OUJv?=
 =?utf-8?B?WCtqclhuYWJPdTFJaGpUOEdyWmhZUXpQTE5yTm1saGRjVUs5blNRSWFMd3Y3?=
 =?utf-8?B?VFN5bWNVZ0hLbjhlT2FWZTdyZlRseEdpMXR6YmFtRkJQWHBuazJtSFV4cVBn?=
 =?utf-8?B?bUpxbTBnaUxhMkhxdnN5RndaZlZiakJyZWNNWTdIV0Q2MWtWYWg5aG5yRFY3?=
 =?utf-8?B?alJCSlhmWkc3OGxJd1NkZE5wZGphdkxjWEVWSkJOKzFyRHNQdkxhSGZkQmUv?=
 =?utf-8?B?d3JKMzNPZ010a3BKWTRmU3Nzc1JjUStjb0tEbVFQOXRqVWU5M0Q4YW42M1ox?=
 =?utf-8?B?OE9kMEk2VUhKcEsrSFlub1JBS3cvd3lxSkR5aHhGVmlXendqNm5XZWU2eUZp?=
 =?utf-8?B?RHcxUnZVcDRuUVpBTnNLNDcxcGk2ZnlzKzNEaUhGemdXZFhxNW5wLzE5SkVy?=
 =?utf-8?B?KzhQS3JsTlBvUmJ4ZlYwb1FlNzhIcVN6OEFkVU5mbUE0MDYxcHNZcDg3QTli?=
 =?utf-8?B?RnUyL1lUaGNuZ0UvWmZSV0ZFNFQ0aGNKY1QyZWJKamU1WkxDdnhHRzRRckFz?=
 =?utf-8?B?a1NMSU1ORFcyVTN2alY1ZmtjcFhoQWdGUm5PVkZlVkZQclAxaTRkMnd1Vlc2?=
 =?utf-8?B?NllDN0RFd2QvR2hrSXV0SkZaRnhEUGxmaWg3aWZFSi9Tem55SEF2cVlDdVRY?=
 =?utf-8?B?bzl6bE83Y0hzMEVPSllQQ2FIZ3EzODA0eERra1B4d21CNWhyN0c0ZUVyL21k?=
 =?utf-8?B?aVNMY3RENUVaYWZFVnU0U1ZXa1YvZW1Va08wTWkwdkV0ZWN1Q1k4V3VLQWp0?=
 =?utf-8?B?cWZyUk04RTF5VERlcHF4ME5HTVZKTVBYMk1Oc1kzenlUNGNNNkUxSXB3RHZs?=
 =?utf-8?B?VVEwMS8rU2x1VVBJWEhoanJ6aTA4WjcvcHFtS0dJUTV4SzhQQWVzREtDVktY?=
 =?utf-8?B?elBjeFlyMXVQT3VkNldueTg4UFoyeHI1SmRHdU1hbzNzZldFWmc3WXlLTURI?=
 =?utf-8?B?NDJORThvZ3lIaTR2NU94bFQxK1hpR3ZkTGNkbXNlZWtXM0ZDSklVNWVsTjNC?=
 =?utf-8?B?ckYveUsyL0diZVNCaENCZjhEZUlJYkx2cVVGaEVjdWxKYXlEcDZicHpEUFFk?=
 =?utf-8?B?c1VaRnk5alVQMnNTa2JCODJTUkVJbndpWGtjeXVlVXI0VGw1WHdNVFdoWis2?=
 =?utf-8?Q?Fl52KxXs0vJKkHk0l49ZzDxePv1XcMpYZ1nD3EZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8f0ba2a9-a337-45ab-9fa3-08d90082897d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 02:51:30.4037
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: GHzAVavdQ1LtE5JnzIh73ClDJByQU/jwygdYdQFa4viPQZHRkVXaEwOoKxwJpAzh1V+A/HFRBo2WfnetptDvdkEAmlAiFZjHRIoCTlJ2fTc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104160022
X-Proofpoint-ORIG-GUID: k1AwhG6jw7msxB8OLjWFYC6BTvjqNg0e
X-Proofpoint-GUID: k1AwhG6jw7msxB8OLjWFYC6BTvjqNg0e
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9955 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1015
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160022
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Apr 2021 11:20:54 -0500, Gustavo A. R. Silva wrote:

> Fix the following out-of-bounds warnings by embedding existing
> struct htb_rel_query into struct mpt3_addnl_diag_query, instead
> of duplicating its members:
> 
> include/linux/fortify-string.h:20:29: warning: '__builtin_memcpy' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]
> include/linux/fortify-string.h:22:29: warning: '__builtin_memset' offset [19, 32] from the object at 'karg' is out of the bounds of referenced subobject 'buffer_rel_condition' with type 'short unsigned int' at offset 16 [-Warray-bounds]
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: mpt3sas: Fix out-of-bounds warnings in _ctl_addnl_diag_query
      https://git.kernel.org/mkp/scsi/c/16660db3fc2a

-- 
Martin K. Petersen	Oracle Linux Engineering
