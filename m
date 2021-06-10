Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7E888C48BCF
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:57:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 57B466141E
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Jun 2021 02:57:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229659AbhFJC7R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Jun 2021 22:59:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:16378 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229634AbhFJC7R (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Jun 2021 22:59:17 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15A2n45i018032;
        Thu, 10 Jun 2021 02:57:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=xpM8ioMP3EUNpJBEE/NiVC7hKJH6a8CUzoW2z/+KN5U=;
 b=W+GYe/jqJjqHkRqi5PN/6nreo6U77EUBaRChSSrWzOg4I82TOVODqXXpwd7VgX3GszBE
 7J7D+61M3zSP3ZMg4wQsfi2xCiK+sLddTkz00LJBwUVi7vE9MKRKnjgfg12588aK156J
 04xlMWBqheH6/TdtVTEz+DnQYkskF53fDUFyXBKWT5NjqorCk4Az2WNNJljIM92GzMBh
 M5K/EfTySYMeaURT2gPUEiLNqRPBcYT5mC4v393zLqAXeHQS9bSbhfeJk/ZVBRHlwaxK
 kU7ikT8OjsTkVT8goQ0xHWsbucChNGcM3LDh3BITQDin3RaIY7HmA4LcAmGH98tqRW3/ 4w== 
Received: from oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 392jmw0gfw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:57:04 +0000
Received: from aserp3020.oracle.com (aserp3020.oracle.com [127.0.0.1])
        by pps.podrdrct (8.16.0.36/8.16.0.36) with SMTP id 15A2v4Je009633;
        Thu, 10 Jun 2021 02:57:04 GMT
Received: from nam02-sn1-obe.outbound.protection.outlook.com (mail-sn1anam02lp2042.outbound.protection.outlook.com [104.47.57.42])
        by aserp3020.oracle.com with ESMTP id 3922wwumkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Jun 2021 02:57:03 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KbwId64jPcjvK/LFPXj33I6ZLxPqNPo5TaLCWykr3Y+NxJoj0DQw2rraE5EdT8NeQMa+jE1l567P+QhnS4PYORgnrIB3W8fJ8Kw6CUcxAQLNHJryac4MdxT7auTpHY44VTSJJgLkTtbSSN4lgIMTqKK9UQOkp1BMrhEMTN0MMj3in8D39clny+Neu6yrMJPVtA03o9JOTC6YO0IZMPYEukDFiKfPxCJ887ZZkcZEAadtp8q3nhTsr6LpGYSPGdO3PA7ySAEP5fVH8xnJE61vAdsKlAEt4NZGz69lvyGX+dsyOSR+RKeZwx989T0PMGl4e3zVGNidnqQBUmKWGF3F5A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpM8ioMP3EUNpJBEE/NiVC7hKJH6a8CUzoW2z/+KN5U=;
 b=js0yUto6CG7AM/0C/IhK/93OwopbULB0tF7VQMzBBBHzB1BQfym/LtGkg7ZcNmIKagDyuwXYsD6/wDNfNEYegVz9OgJsZWi5ivz+Uk1AA3NJL5y0S+hNuqIiPI11z7vgHZfQjuRx3ndtvPLdnP7GsIx3Kbe/gXgzVNN/Ob7esNUoJn9XP0/yP+12ipcWdLuJHtpLbElqjSStOJmTUgOnaBB8Xxiz0VuE2TyLML8W4jR2x/h0V2MYt1HYHlCrjlmM/zhCGv+jS3iCUDEiNN3WlH7i+C7xlqD7eESw5vmKI9Nt9JDGI8cCadVIlPxJFkq0LF1oZXn3lnxfNLcmCsS9Bw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xpM8ioMP3EUNpJBEE/NiVC7hKJH6a8CUzoW2z/+KN5U=;
 b=lJZr/XgxBA/MZRMVKIZ2B39RFAFEo7I/yJG4gmmJde13s92U2TLPIW/PnoHJj5focWpfmmY2JozmLnZAHhQbkvtIOlHKk5j894IXrmsYmkfarfWVh36TRZmta5F9NNwLx1r06hGli25CztrkXopt5F8c301nJ81ODSVYR2akglg=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5483.namprd10.prod.outlook.com (2603:10b6:510:ee::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21; Thu, 10 Jun
 2021 02:57:01 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4219.022; Thu, 10 Jun 2021
 02:57:01 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-kernel@vger.kernel.org (open list),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support),
        linux-mediatek@lists.infradead.org (moderated list:ARM/Mediatek SoC
        support)
Subject: Re: [PATCH v3] scsi: ufs: Fix a possible use before initialization
 case
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mtryh1fx.fsf@ca-mkp.ca.oracle.com>
References: <1623227044-22635-1-git-send-email-cang@codeaurora.org>
Date:   Wed, 09 Jun 2021 22:56:57 -0400
In-Reply-To: <1623227044-22635-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Wed, 9 Jun 2021 01:24:00 -0700")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SA0PR11CA0113.namprd11.prod.outlook.com
 (2603:10b6:806:d1::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR11CA0113.namprd11.prod.outlook.com (2603:10b6:806:d1::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.21 via Frontend Transport; Thu, 10 Jun 2021 02:57:00 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5434db3d-58d4-46f7-a236-08d92bbb6b9a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5483:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548349424EABFF28D545B39B8E359@PH0PR10MB5483.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5516;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +jdQ3lflKydJx/R1kEzToclXJSkL5UdSDHyiG+R7Lr3l9oUK3M7SBbRnrAzcEeuZe1e0pnSlmxeHN8ECjpqOKgzepX3DgE2b1a0+OHdIKtbPQJfrTVSmcezmRo+m7ad12KcC/5i56IKTgTzRiIBNY5ocGI5qs+UsT1PKftwYVvaeKScLgXcmN38OC4PKMc48SSfhnnLA21vVkwMfVppkP8Y5kfw6CMJ/Eyt0Io9o/0wCif5LCMjK/Em9GYrLIN1mqi1ah83Hg1aLUIPYlkLHSeipaK+Q8mfuHUxbZe8uiPdT+lWo9TDf0sVnsS7Y6OHmCNqe+N5/ajgpI8mcaAxJ2jo09wgurd5dsqasdJX08m+OL7OsjnkzI/n3Pcb5UiP10Mh+6c9890kmbzMJ8m9vKhgkExdHjTkzvnb7/TkxG6t95F3tlJArEzyT9G9XvXjugDHvhqewMu1Un203GbK5lTssazCA7IINYdx7luzuGK1E35yBw7kmcp9tDbuOyaCdRz1/czLFnZwwLUi5L/A8KRjkPKCQNS/PO1cWBX4uKL7hfhLKSBy9SuGcN0hCowsXp/4VoRpWpwp1z+f6q2JCUUyhLRtzyPdJOuNl5cePV3FiAK3vqJ//q1+ggc1f5V6uALXTII/jbWd8jCANYGsfkiuMJPt4uFYcIkf7KOlYAaA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(366004)(376002)(39860400002)(346002)(26005)(7696005)(8936002)(52116002)(55016002)(38100700002)(2906002)(558084003)(36916002)(5660300002)(66556008)(66946007)(186003)(38350700002)(16526019)(66476007)(4326008)(54906003)(6916009)(7416002)(6666004)(316002)(956004)(86362001)(478600001)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?utEwYoaVhGx57JrBpMhDNwaBU2y3T/0hTxY0vwcg6aHPkOrM7Z/7qyPsH0SL?=
 =?us-ascii?Q?S0zAuQHmcGA0oniy1YUylUjrr+T5CZ0UNopw1ElCHp+GsOsGA4Es6tKTzmTC?=
 =?us-ascii?Q?SMGaHXFZSDrIufJtpIpuKKtYyq44eFvUqCMbjkzmj02oL1V8PXz22kMigtnG?=
 =?us-ascii?Q?xAREmOIPZXKPLtMWL2X4AurTMh+RTzqrX3uHIVJBV1X3mgKeGquPkf0nTfPz?=
 =?us-ascii?Q?l7N/WwHLQFQ7mRNUz+uV4QcrhiOVkZLMDlkWAOZojRSxkN6wCUyqThsCunma?=
 =?us-ascii?Q?jxZcYHy+socCVg/weYdSOhS4WCaxJgpwF3hc3GdVUO/Z+Wu6+wDMfIQy2tUH?=
 =?us-ascii?Q?7d3BUSqTbR5PSocgIv8TFyBzX/tB+9O8MZznuFSz5jtcdls1tfpeUWKaYJ8R?=
 =?us-ascii?Q?yWrylBEabsUZQZcnUUUzJ++iSrnD2BUlj7M9O7iuc7xhUhQ+Q2bEtJ9Qn2Kc?=
 =?us-ascii?Q?rWETEuX6g2ysR3l2QnWtT5BG1jGffJd0S3OC2t1nRnIj90B1NABGigqMVQtL?=
 =?us-ascii?Q?VwmzF+v+3mEMSii6TgkfpTETGA8FcagRyAnWLKbISvL8vhzWmAjJvhXF15dg?=
 =?us-ascii?Q?8Qn+6SRQW6e/syGk0ItKo6Y9hdJLLHK5H03wDwvqMm9oJ0MqLp+a+GZcSfAB?=
 =?us-ascii?Q?xEHGMpp84+OhCCzrICrIPiHPAtkdU4LwSRkNWva2uavpOwbMqZ2s8KddvjOa?=
 =?us-ascii?Q?lkW8hVDJS8GpwXnzKTlp0QlltJoAUZn2jid5hqXZipkQhSBAnv51kLb1iHBy?=
 =?us-ascii?Q?8WeV7w8eehcxwaP6eLnVE9pG8MzgLy0A11rbz7nMKV03RWPgRokoYYrpxHPj?=
 =?us-ascii?Q?meydeUeTVCkuL8FcyUxqh5qshrxipAs1wAMGMqRcSYVHejch3Ulov9kcPuM7?=
 =?us-ascii?Q?1wQXeSc07ULxerF9Jqbyjw4/By8z37oTt9I5K9w3Q5Mm9+9j3M5J14OYgrt6?=
 =?us-ascii?Q?dV2xrVsV0d8q4YJABTQieZIlKXfqZwAorf7hby2Zuup5Ll7dIH6Cj8ajeeH/?=
 =?us-ascii?Q?0kLXM4C5V8IuZx9l3Jf6WSofQEz0J45/DDMjdCqr+2giI49hKgANgnScToYx?=
 =?us-ascii?Q?/aKhyD/2sNTqAz82YoVgxXHbN8D8XUt4z2XO6V2nFnW3vXxek4jmnoB9W3oi?=
 =?us-ascii?Q?AvseEDNDYEikn40ThSNP9+h8r68gPsegNc5MJ2JE+KyGVoIFnv0l0vIaHiks?=
 =?us-ascii?Q?ma04wsFy+UiAkpCyGZ4NG18FFeUn+jZo7gLnxowdg6Mlwv7gQW2bVrjTskoU?=
 =?us-ascii?Q?1/6NS0zNBp8ZPt0RSBnBI58KrsgKAKAY0p+GBEf0a944B0HIBS6j32Bmhn7p?=
 =?us-ascii?Q?EzeST7giboEeJlRNXtyjEc13?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5434db3d-58d4-46f7-a236-08d92bbb6b9a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Jun 2021 02:57:01.4975
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XxXnMsmp/jqMBlklC3t/02YbrYcBEkNCtuzlqH5dLij+pR3MXcgCazR3oKYQkMKIdvxk6QjpRLuFEQX+jXttNCoQxLKf/q+wn/JqJHXl0Y8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5483
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10010 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 phishscore=0 bulkscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106100017
X-Proofpoint-GUID: ndAjZLwdL_DBtSluRa2R_uPpWD3RlkOo
X-Proofpoint-ORIG-GUID: ndAjZLwdL_DBtSluRa2R_uPpWD3RlkOo
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> In ufshcd_exec_dev_cmd(), if error happens before lrpb is initialized,
> then we should bail out instead of letting trace record the error.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
