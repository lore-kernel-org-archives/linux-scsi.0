Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6132BC001DD
	for <linux-scsi@archiver.kernel.org>; Sun,  9 Jul 2023 20:29:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229917AbjGIU3P (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 9 Jul 2023 16:29:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjGIU3O (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jul 2023 16:29:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70D6F100;
        Sun,  9 Jul 2023 13:29:13 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 369JZpNJ019696;
        Sun, 9 Jul 2023 20:29:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : subject :
 date : message-id : content-transfer-encoding : content-type :
 mime-version; s=corp-2023-03-30;
 bh=lb8WzS3Jj4noAkyFAujeTrgMzXJG+PAOW7+Z/fymLyc=;
 b=qdOQ9ypoOwMoBMiqAsJelA0Qj0MkhpIoJTQML0RnEsSc9GYcEsAFtqyd4YDvc0z9tXK1
 N71bXpvzZrmBLml6l1OGNTk3AY4UwF2CCLRTLiB+HQ4eXHQlqDjP00tZoe6Uz9/P6F0n
 WvdwYTbFMXCUNUQG5U2QzBhKlJlkuKcTuCKQozXVchp32xBktmGrTfNonqVYZ+wwnRqb
 gTVcR+7kuKZ08GtPHtN/AlI9jg08LAPVukfTVKCh0I+GUCLGVt6yjMNori4p5PgTdg8Y
 WooSAjF1Bf9QkOcWlE0yG0rY3+KlSftwuiiOuE1tJXaeNLxwdInfXA+8Xg1cJQ430d9T /g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rq0bu1dfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:07 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 369Gepg5023181;
        Sun, 9 Jul 2023 20:29:06 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rpx88xpd0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 09 Jul 2023 20:29:06 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A9zp+wszhIRGP2AsB2OMZx7zkdo1+o8yebtlBOVjpWyXpNFOBg7SF/HLUFwmFP/SDBBXHi6yKu5AZi5QroFOo0XUR2xhGbkNvDrMbgPcgasawLS60KHxPY7lWQsVqspIHpzyXpRA9o8xQ8d3kMGwsK1UyGhOpzUn/WJ10+ByQs+wPcvijz4CFWbkeC5n1JdwPx2KZl/Bzp5R5byIVn3Pp2oe+gIc16Ck3FhRIhhWy3HW4fvyjraE/LKceAfjohTdPeRPFPKQmcj/CtDRlTfZ4bGxL6XaYlsZwtlAXsjcQz9axMWbE0EmJA90wjkZrolvdCYrrkz3J8WBKwcHaPW2iw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=lb8WzS3Jj4noAkyFAujeTrgMzXJG+PAOW7+Z/fymLyc=;
 b=AuVCQWpbgDV2bvFz1TWugKbBV5R9TY85E7G6VED6nyaoL/ywdXUbZXQWAFCdbbH2nLIgQmZL/p/N5m9zggAjWEiCNtGX9T67KG7k68Gl4VphOVBb4tXUfmLk9qw3LHf54rhYpq+/CzeCx96jUbs7qG5efgScBOr4Oq9DYCMhnW5oBoM2Fur0415TixAyuycvTOQiG9hqYS8CzaHSFSf2ERRVWxSb+5KhCcr94BFHjVdDRGOZKPKU1+07VWStxfqxagBZs/i6FrAicX+u1nzedltoOiKlqd4IpjGTzgrh9GDu02uWBQUTAXueb3x+ZmFds6u22vaw9vYki/P0T8C03A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=lb8WzS3Jj4noAkyFAujeTrgMzXJG+PAOW7+Z/fymLyc=;
 b=BEBNbrI2XHEu6IsvfNl+gSJ4r/r6lTpeSoDjjJPxdZkv9fcnSk2N0BM7THH9ViVe8Qzbm8iDu760ddQE5SH6ebc79DO30T1jW9b+1YQryzAhuv2Wof7AOzWu3gqi9G9vS1We9yp/ZmRJOSlho+yp5Ir5WZTcKki0GiDlq9Y3fto=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by IA1PR10MB5994.namprd10.prod.outlook.com (2603:10b6:208:3ee::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.30; Sun, 9 Jul
 2023 20:29:03 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Sun, 9 Jul 2023
 20:29:03 +0000
From:   Mike Christie <michael.christie@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        mst@redhat.com, sgarzare@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
Date:   Sun,  9 Jul 2023 15:28:57 -0500
Message-Id: <20230709202859.138387-1-michael.christie@oracle.com>
X-Mailer: git-send-email 2.34.1
Content-Transfer-Encoding: 8bit
Content-Type: text/plain
X-ClientProxiedBy: DM6PR17CA0030.namprd17.prod.outlook.com
 (2603:10b6:5:1b3::43) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|IA1PR10MB5994:EE_
X-MS-Office365-Filtering-Correlation-Id: 2b7b8244-67c1-4b90-d5ef-08db80bb2293
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IbFl3wF31ONe0mMzGX1cDQtblSFufjlUaXWszrZSg+ASP/4z16csuzQoeYXabsHbbR0rdY+ELn6Cc3hAmgY9Aqz2OH3Z1prCvZi7cPNoEx+zKagHr2xB5c4UgzvX3jNU9+BjGzik47faA2brKGRkWNsOPyn0926fceNDrnLs4dkaCvSA5UPTgJfCHSWvUs78ZQuIufgzsX3QOMXRXeRmRC+QhOY2R0/xsuK3Bh0wMinBkKVGNckULHWP/Nu5ZOVAf/B6hb+Sf2DUndH1KaVelxOhvcRhugFA04E+p6mNQKRbg3FsE/47YAO89LlexdyGyQEPol+vCquOyH3dNGX37bRi93lHauxtUKXFeCDvHS9BG3LUf1BQjK5i6N/yPYRVr5ABwx8AGnVRQNIQG1+0Ss52C6jV/MoKpjzHdAu8s/YB5OWMnBuIzKabJEGsI3OR95Gyav6+Smz7ymc56Kcy+S/H/4BbAddyA/yMAJKAFaCb51/rySDjqsYUrEUnhn+uxbaGxciN7Wdv60RBRRre5Lm5KbW/wYQu238VxAdRU2gYH91Ry0YWP1F02OQdyKos
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(136003)(346002)(39860400002)(396003)(376002)(366004)(451199021)(86362001)(38100700002)(36756003)(6666004)(6486002)(26005)(1076003)(6506007)(186003)(6512007)(2616005)(5660300002)(316002)(2906002)(66556008)(66946007)(478600001)(8676002)(8936002)(66476007)(83380400001)(4744005)(41300700001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?X3BIZsoXo4nYEWz9MoCStAmQABcLkiNw1RyfLdq73bjxvyakeeirKlq6ObL5?=
 =?us-ascii?Q?FdeZTuGr1PNprLKCq2bcF73zGniAAPiQIkoNw0KOWC/33rmFX2gAheAS+tBT?=
 =?us-ascii?Q?w5BnbHi2RJDIGkaNffZOnxpxfnVBBQ7jMWdTZMShORRs/tir3AeTYwWXpK6c?=
 =?us-ascii?Q?sHD11lEpadPJfuwZoAzpnejsC/BUpxWKnHYNNYkP/2KBCM196zg/5TOwVEeQ?=
 =?us-ascii?Q?2/31wzV0NIEhmPfWktuZLxZ2QR7+jaqkshsGIqJ1yfb22ZgRl+dtzZN+pcx6?=
 =?us-ascii?Q?S7mH4zXzJuJC+uS+T/Q2e1uSJ/34T8LnypmmUrNdNrfgMz5AixirzQKB7klv?=
 =?us-ascii?Q?P0zZ6Xj1qQvdiiD++srJ8lH/SfOwAWSSt9vM84PnbBWx+QlBh0Y+9orlrb+B?=
 =?us-ascii?Q?j/TA7ghVZ7piIuGe7W2DOD/1k+Zz6ALdL3OZ6pq9Lj10k7nVU8gKVNnx+RB7?=
 =?us-ascii?Q?ytrxDTrLXtZd/5zCVudQj+io8F1l25hDEtsPVdWuT0wYJaCfz7tMJlDZnBaR?=
 =?us-ascii?Q?zwxTp+wjwDVlohA+4E1ngUXjETOJ4hheFNouM6cXu5zXK0fkr+GYqMx7PEWm?=
 =?us-ascii?Q?rVGUdYh1OItgTydkU+3BV0BqgFvT/+oEEfj3dPm+Ln5FmKNkPX6fQ40RT+oZ?=
 =?us-ascii?Q?X1Jo81M7n53su9MYbdqZzsmbG70KwYQcEvsevTkyQpsMPg+1mhTWqL4mAjKi?=
 =?us-ascii?Q?/Nf6i6vrGUzTPspOKjxeuqZD7+TFEQXprnH07AT2RqX7fUncch3v5XfThlLn?=
 =?us-ascii?Q?hfmoY3NjjgFf5wHC3l9Q5JgKfNVturF6CGeYkLV8KxZ9MvwvRgb1PRP6U7Xk?=
 =?us-ascii?Q?e1nKE9R5R+pTDWl3tkjGjQlXgMnkIMSk5ZdhGzV2eCK+qt+7lM5lB7q5njI6?=
 =?us-ascii?Q?rJBn3y8FI8J/O8yqEw/iAE65MGN2iC7d2219HPD6Pe61PZul4e2A2r0qNebE?=
 =?us-ascii?Q?URXMNIh29NFLJ/mvqq91K+hltFUM9xOPzpbAJDSC+6ew9Tgwv/yE/5iZxqyt?=
 =?us-ascii?Q?FntliVQduDipZNlGkmxt/h3nomG86urbXyAW7k4lAvbYtrEbhFyfq+bouusy?=
 =?us-ascii?Q?xGS4bJCOFgstRUWfUiPkM5RLrsFwFQFlRa4keN1dvO+RxoP8hBSn2mUJQDYC?=
 =?us-ascii?Q?+y+UnZK4EeDje4TFliRy/2kEntSIhJun0YP1C/S7Ud1ByS2c03pk6ZuYZbTr?=
 =?us-ascii?Q?KS3bQGCa7944QiNH7BHeBpf/6MWEcV7wc2Jr0WI4zj2SI8s8Dm31knXUsFHF?=
 =?us-ascii?Q?D8ZFyHwpAXINTo+3GX5jyW2v7vpGSxenrSJnfkoifAF4q7C6RiTP2M+P/mwC?=
 =?us-ascii?Q?m8g8w1w6iuf9EXhNRgnWtvJ1hw861A93hr6MhUDsxCDpBHoifJQ3gfivcFiF?=
 =?us-ascii?Q?AdBtx8dzbq52H/BdOrlCPUOiy9ATcKrD8nCjCGi39kpCto7T9/ZbPYwRVhp6?=
 =?us-ascii?Q?DACZgo0/g8jzRgZzNMEsgPeXwUjvdi3QatakzEya8Emi9FM7bxaOmo4/fhOr?=
 =?us-ascii?Q?Y4x8emUKL9tLiRxVc2u2TOl+gXSfCkodnOIMFTE80KHZznWIv+oKYer+0Bur?=
 =?us-ascii?Q?pA2+436kXXMe0W8JB0dPe7/v86xGXu5zEQmkGf8AO988s9kFKQseJMu/ASYv?=
 =?us-ascii?Q?rg=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: vIutymIJe+U0v6vTuOJNRBlO1fKGLO7cS9348kgbP54oOFd/O3ysMDZqJlwltEDeWmkhd9iCSn9uUHBEKOQe45pA3hoZB1OCB+iNqjqoTtUGNT3cLei5sMK/La8nS7ZJG/jmW4SmiZv5FPhai+7cfkGQFyQyAqgEQ7UFBvTDc9eIhBEa9xte4i8QQyGtcFX7grtZZwYJMfQZxZiU8NnpPT7APflxgclis80Trmm9d0V+awf0bQ7WvFguIdRbYF1+3HqCdbFbBP142eCX2+GCPscyNgqJ0wLxWHhV5k3Z5qJd1F7s3Dd2pvx5Z+HlB8U3JfhFH15eFCar2SqTECr0/OMypYvwm573F20Wg0NpO5eKiLAseF8ML+XJMbmvBVnfnmA20uw1xnQHbb8xs6OnMC3zUnx+ZekyCs0oT5k0lKqt01COY9QQ1Dsyhf2g8trrF0fxValRBpG3kpyJJk3apBmlMyPfHtyqimj0I5RNG2F96sf5kBb/hfdTKVBfMHasSnNgkvlwniKmjdv65jpeRfm5A9oycZlm02G2Rrtp1Bk4HbexQztN51QWyZvjOF2LeBX4Bddx/tv8NbL5SAB+oelwqvKk91Ee4bby1rHFUnTDqF8ymSN/wtt1OgDQwPVBLJIQrt6Eps7euZW9UUt8RKNavYLG9+54o8cmPuKnPyFcwL/ircICnjdwNW5WvgF8PVPSX6zdVOdrcsBCmjdjv1ZqfkjlG5CB8yGqdvoehkdyo9qXAhIEpoV1cx4nN/5fc6ZlbQc7s4ScKaxD5N9HyGoTaT39yrPI+qy+pkVwf2M/+DkZBIMZVVJzVpQ/p5b7FtM5+/HGK7ISFO/i+C2IBJFZjKc4g4can05UD1nrc9E=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2b7b8244-67c1-4b90-d5ef-08db80bb2293
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Jul 2023 20:29:03.2572
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ARisl6/VmWmbq7BYZG2eKijVyzKq312zBGYitdFLgHoOw8DmTB9uuXoQMMwVg1QK2/nWYSJGnXEDYnt+aQ5aQNwkBmUEWowflA3KKNRSw10=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB5994
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-09_14,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=650
 adultscore=0 suspectscore=0 mlxscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2307090193
X-Proofpoint-ORIG-GUID: 6NOsMsaVxq0gk9GDINUI20hUELNmkOBT
X-Proofpoint-GUID: 6NOsMsaVxq0gk9GDINUI20hUELNmkOBT
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The following patches were made over Linus's tree and fix an issue
where windows guests will send iovecs with offset/lengths that result
in IOs that are not aligned to 512. The LIO layer will then send them
to Linux's FS/block layer but it requires 512 byte alignment, so
depending on the FS/block driver being used we will get IO errors or
hung IO.

The following patches have vhost-scsi detect when windows sends these
IOs and copy them to a bounce buffer. It then does some cleanup in
the related code.


