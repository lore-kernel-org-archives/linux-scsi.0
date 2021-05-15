Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1824C433ED
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:56:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6AD361155
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:56:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233069AbhEOC6C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:58:02 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:55680 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232860AbhEOC6B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:58:01 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2t5Mr127384;
        Sat, 15 May 2021 02:56:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=wjF8g+5SbeAWQsjS/0Ne3Z31ihfmiGmoTaw+1K45KmY=;
 b=puYoHxJcScMm/zPE3T56KtyWslD6sz40Pw546JaRMDzJXJ7zoWXV/dG4UbMGDmA2ZYbi
 mSZNkun1Kh9khJACHw6mG0Rw8mTMnuzUh8hCxetHcc8XujaJdW0snGNeMHlQluccP9mF
 OCenHhC9Wf8NbdwZmHkz2Jnu94xMTG4RXeZl60e/CJ/t42VoPJtP7QzZp8O/IeH1JPxS
 N1WCcuFKDLQmM38JOG0BYMz17PQir6JfnnbbP1SYc1s7GZsrffgfxg+lFa+89HIE7fYL
 AkKydZXrWf5KaypBKxN6U+9hs9oVjXrADsK5hSjO/UmushzwyfjmxpvAHf6/2LiSwzF3 aQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 38j3tb82r2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:56:47 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2uBOk148704;
        Sat, 15 May 2021 02:56:46 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2048.outbound.protection.outlook.com [104.47.56.48])
        by userp3020.oracle.com with ESMTP id 38j5mj0fhp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:56:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WDX7K+96vtKpsWDauMwPN49UVRd1UFYq+a+neTv4ZtqTZVK4XnEFxqMQlSO3tDwfN7iXjephlDMhg7RzaVd+zk0wAeodRRPRbw1UmSkE5QKQw3PZu9Ugjs6ue8pxXwmXojSvPES9jdsiQOU4ng+Ek1DX1Fck0hjVb/aSgBR/BxSVEiwSVj0eSxq3EiXmLQQHfMHBguAJEKSsSevlobDdOpxQKojPvIWCqLYCEgbX3MDxgyyoPxSYdik2plCikz8Tc+UQkhngfW/Sv4yJszXjoI7loJaT9IRhPNTX8gdPQe5enUa1HFuXUZITCZM0q2nYhmr3iE2BQ040YZ+xiK7hrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjF8g+5SbeAWQsjS/0Ne3Z31ihfmiGmoTaw+1K45KmY=;
 b=Vf2F1CZg5bYNMd9Z6eVJnXjii+2j5SdpGwPqVGi6ncXX4nm09uyPTezYCY69GTL40sRl+EjghHYLUt268Ze/ymzRWf2culg6xqKSkorKumflfey90ird/ObxabtMItswZBpTeTvUUhTHbjF5B7twqJF+/GeZMw7KMao4Lg37XmTeZ9jnPJ32vOdu3LffmmTB/OFiM0VFkpXOvDlc3rnM9VqKE7UYjvcuHpG9rPBP1g9Im/TIECiix9updKp06m8S4Y6MJ9NS/9kj4J/M8RO4I9wCdkFHzJxS5t7VpeRu56dBzbQPy8lP+qnYv7ryZY5BjxQAISS5GBp6QnkUGcoh9w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=wjF8g+5SbeAWQsjS/0Ne3Z31ihfmiGmoTaw+1K45KmY=;
 b=qlkTEbQCml6iEx4NrSeAzQXdPWmichRrDeI07OFlndsSKg0ntrWQd5ML5f2zO2oEPMz3yUK6Iv/nvPomzFqIkDwffB8h6aSX8sL4DZrawBlawS4LZemKl8w9qHs5lumWUKd84AnS6GjxVL4RCAVnFvzg99NKBCj/21iFIFUKSqs=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4806.namprd10.prod.outlook.com (2603:10b6:510:3a::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 02:56:43 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:56:43 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Subject: Re: [PATCH v5 0/2] Introduce hba performance monitoring sysfs nodes
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmxsaen4.fsf@ca-mkp.ca.oracle.com>
References: <1619058521-35307-1-git-send-email-cang@codeaurora.org>
Date:   Fri, 14 May 2021 22:56:40 -0400
In-Reply-To: <1619058521-35307-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 21 Apr 2021 19:28:38 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA9PR13CA0135.namprd13.prod.outlook.com
 (2603:10b6:806:27::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA9PR13CA0135.namprd13.prod.outlook.com (2603:10b6:806:27::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 02:56:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 58b5b441-1c74-4801-af35-08d9174d1246
X-MS-TrafficTypeDiagnostic: PH0PR10MB4806:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4806564FC6EC653778BF5EFC8E2F9@PH0PR10MB4806.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2582;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bgNEj8XqEa/DXqTvTAyB8JwEfjtLacqfIszHWD2gBNhO6Vm0mW5Wcl/3v8QybIxVf+zJSD+ITGx1piz/vozc5c5spe6p42gthV4WnJgKQblmlYskuz7l5r1RUbREQM2g0hGpIePiz85eznCY/I/ms3sCIskAwEMa4vH7bzJKv+7bzvrt4bPNftQYO2B2aUpfwHK+ngA5JpQ90JlgWGVN49DBK0FyU7QEakmewHPdvRg66PjeH8C1i8L7Yfga4yvtDkwzFNOZHxP1VqGMAuH/HZ5hwZLUvaZPHxlrTWay1VR0bDusSf0331tUy1BburQGGSCwZUaY7LLl+odpMrSMSgfMFDTQEtLYhlFk2/SzgrS025ifROxM5CZAxFYsDeM9RWtkQNyk9Fg4BPWO0uWsS6WJ0GyeE/jwSH44UQc4nobpUgG0SdZ5BuTkxaLlTaBkQFqdeLYLrdSbxavZyxB9UVxfdGtGv4ySYZ424pQrxwbv+OauxDAE8OU+NNCD0q/eE2SIck86woChb/Q6ifAVwJItDtPIqMVkwsbWzMgQf9azJnXnkYlfGJmxgg4H66cLqaXu/Cxaw2zWelk0ne5oAmVcx2F2bDy7514LqDcUz7OtnVtBWYZxglGA6snCE/oQ9bOsQfbFYYPunwwcz9iTfFhHVWJOtbqIixqodHKyRkY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(136003)(376002)(39860400002)(366004)(52116002)(36916002)(478600001)(4326008)(6916009)(8936002)(26005)(8676002)(86362001)(38350700002)(38100700002)(956004)(55016002)(2906002)(4744005)(316002)(16526019)(83380400001)(186003)(66476007)(66946007)(66556008)(7696005)(5660300002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?PmZ+ypp7L9QiPNZRQJmMklfYxlQR9N6ARw2KLkEPOOi63VuAgYCAPTXyMcqJ?=
 =?us-ascii?Q?DCDkczm6Bee1uhg7jANeoNx94KvFZ4tB1C3GO2wxBN0FKaVsCywsI/tLiIPg?=
 =?us-ascii?Q?nDE3/yvzdmw9CFMBT4xPl1Wq+1rIXEzjG79aN5j8Ov14FY8V8hnflJOnZD99?=
 =?us-ascii?Q?PBajBNfzORCjjo4E3erNYTqxvnLaLDtu8AvlJfL3NyTXa8mqAgXLOVXIS7fP?=
 =?us-ascii?Q?yM3/8QVWJXjeh0zkvxob1HTBka6ZmCgA62bhlZh9Gxj/qYaWP+A36pvfcfUO?=
 =?us-ascii?Q?1GDMLmD1Inj+Hd1Q1z0/UUmGWGZAit2RGv1ja7z/sDfQi3v0b6ZtJjaDoZ5T?=
 =?us-ascii?Q?reT+aXWRL6tYmDUFuTeZgZrkX0znQXGmlSsC7Eppbg06nM14hZ3MnuFNY/TP?=
 =?us-ascii?Q?/w98ksTORbvG+OXX77Sx26AckUot8BYkTC6InJmvCG3iJLsh9La9oVh5fYjJ?=
 =?us-ascii?Q?nOpNFr1QlY0tMZ1O6ODKlTrr1YVyd2F925AmtOAW9J7zEahXvH8bMo4Vs7Zv?=
 =?us-ascii?Q?2MH1ZMw2mAaWOurNHmSFUJ82Cw3iCnxRJoQ2j323eAlOnqDKs8wGfpO04Moq?=
 =?us-ascii?Q?o0QnBg31y8S7AGc5OQWTfjTbUBX1rP3qqne+dsSrb4Gr/pg5otH6fOHAhz2p?=
 =?us-ascii?Q?gR8jaaJgDasC/qUE4/m1qBLaiKFH6YWTyX3iwduJa4yQz0DhikooNBR488+o?=
 =?us-ascii?Q?7EBpIOfO0J4Nsj5R2llCSspTBu4eDZXwzgwyzfNWkBhcXS2W10OgHywnD+uc?=
 =?us-ascii?Q?SEJoJiC0tjFfAMOV3tVZwCLpUMg0sZSyU8QZyckIJHu1ld+nShfZyRYRsOpI?=
 =?us-ascii?Q?US+JXbUFgnXVYdboRgfZiVE2G6Vl4HqaeHag1l17OCjMnwf8oD2dmANeAO/M?=
 =?us-ascii?Q?EVm7wAq05323KHXFIp+BQSY3Beh606driliJ3IUPXb0iTJy68v6ewTOkWKhE?=
 =?us-ascii?Q?oyEEuuk/qs7c7MaHS5H5Oo0+cMBh53Ky/yWWBg9jO+fA9cDAS8/+BTMQwPJl?=
 =?us-ascii?Q?1lR3MwXB7BhLM+cQLcSycIzFgpkytJ00vDDZK6Su1qPTLbsdDnyzGH0DYLfk?=
 =?us-ascii?Q?YLK0PEVEdCcuSRqnbTPz/MGgSG6Hm5hpL+SYrmzcY+8BQgagMcrO1FAabIJF?=
 =?us-ascii?Q?6S2wWmGlnK0xZ/TMeprWUDhrpxnrz1gEyhazYlfBb3RFkfdlYWZkrVIacAKi?=
 =?us-ascii?Q?6OTn3GNnQ/M/JlM/R3bY6D0ML0Z0o2T/pvcBJ6UneB+SGsuzbixkXPdA/k8f?=
 =?us-ascii?Q?FsQ19WoMer3A9yCAhSSLGd7OFznqH9CgUJTPX9e/mG9UTdt5P3nd4YkLRDRK?=
 =?us-ascii?Q?DbYmJFQr7ePbnbxvzGCeUrTv?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 58b5b441-1c74-4801-af35-08d9174d1246
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:56:43.7990
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: DwEII5I8/L6G7fJKsX5XqL90NzjEJuOsyIVJJWuDndOmzGa6VFQmM4Xs3hISs24Sgq1WJ2pBzxYoMqdTXhAy2R3FKhvA5HSIIfkqMLVpN/Y=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4806
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=864
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150019
X-Proofpoint-ORIG-GUID: C-EjTzh_3DsEprbQvdAMM50jLcLNFf9c
X-Proofpoint-GUID: C-EjTzh_3DsEprbQvdAMM50jLcLNFf9c
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> Add a new sysfs group which has nodes to monitor data/request transfer
> performance. This sysfs group has nodes showing total sectors/requests
> transferred, total busy time spent and max/min/avg/sum latencies. This
> group can be enhanced later to show more UFS driver layer performance
> data during runtime.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
