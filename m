Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 05B8EC4332E
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 03:18:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C583B23B03
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 03:18:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732421AbhAODST (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 22:18:19 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:32982 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732388AbhAODSS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 22:18:18 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F2xPCC027703;
        Fri, 15 Jan 2021 03:17:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=F5WCYyVooGHKXhqBrJYpGTKFSevdcyW8T+G3dT4vPwM=;
 b=hXhdc0tz3gCJ0D+YJjNgt+epJSIErQWsnszdQm/ghCXvWKZkmXlw2H9W1aGLxiESW1OV
 hm1DmGeYA2EJlNUicrCnLJSsEK6SBZ9C/vUUdbA3po8Xg79pfsdYKoegzZVjHyj0v30M
 JX3v1ao51BsUP1X3fnRcfgoaVuXTp8YPItUzdBnivBhIP+reDEan4cU8pN4mmUYn9aT7
 XOqHCaFaY/Hxbh+xWjqdZctC4OT56VqE2IfyJQNo3arca17pSXb2/gp0qS/z3nj1X2EO
 zN8DD2tlMouNzQ2rNGjhUDl6JMkIE0T2sGREz/EWcejniqt1ZeIL0lGoeXCVlCWNfm0D qg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 360kvkb3jv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 03:17:32 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F30Gmi151658;
        Fri, 15 Jan 2021 03:17:31 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2170.outbound.protection.outlook.com [104.47.56.170])
        by aserp3030.oracle.com with ESMTP id 360kf2x4ug-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 03:17:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bw4MqbXRboy00AjQk43hAoGchK3BQicltlimIGFYbNfeoW5KUNkwZS1y2hEng7xxIJGdL7B+q2E5z6q96ElOg6+6eqfV/Cyg/ujeK/AaebnDmEbHCxuCov/DWKc9pQ/Aj9a/X979mFyE8jDqpvfNGD8wZ8voNZLw2gqpOKZt3nwCKL2XX98tBp1hBN/lXL+ChUPU8JK8kqcET6iylNXJ16U7B4FsazIolxBeyuch9CDYZ0nyb5qWaQAYK9ko7LDJPdXlxq6HhkJ457NYsXLd97aiwYHpMfNHKp1lmsBzF4sN92X3wsBh2KwEVU7oX8dduSn43eGuMjFhRuL8xlnDPw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5WCYyVooGHKXhqBrJYpGTKFSevdcyW8T+G3dT4vPwM=;
 b=NVrRSWjYWPAf9pkTK1NlAzIw545+Es/Rw6w8lLqxpAkV6/ACPwKJNL+LKtFORKMc+2SajPVqshJTnxFIQUAly46KFpDkifLf9KmUAOZDWomfWiUULicMKIjSUnzXWh9wfEjnWPLEWfT7Qcqwu5PMFCXZ4zONANL3wX/kV8A/p7Hp5ixMSrmtUenNnIzx12quAsMP2zPzt7Q/PuiSf7Qa8euvJ9AS7TFoeVnr3GImPzEBzczrNsLgABKsGCA91tzQCMAJZo7mnrvg860rGo2fDf1L0DjtBfrH3x+pEq5XfdWW0t+w5y/MoJZinBZDgngJhagTZSxI8mT6lCLXfDcU/Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=F5WCYyVooGHKXhqBrJYpGTKFSevdcyW8T+G3dT4vPwM=;
 b=bCkNLYnLFWluWIBVgAdf06dQrwcHIBA9QTUVgjbtBNEl48y4at7fuTxEdikwBnNRMD0grqGKxdXoENmX/KGPmIJh6cOIcsSheRtsXHlOzVKxc9b57nQNL2kCs8LdSDYoM1rIotEpTnfao5mnYwkMhJAqDlCjh5HFp0ZRGnPiGyI=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10; Fri, 15 Jan
 2021 03:17:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 03:17:28 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, rnayak@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v5 0/2] Synchronize user layer access with system PM ops
 and error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1czy6sxd4.fsf@ca-mkp.ca.oracle.com>
References: <1610594010-7254-1-git-send-email-cang@codeaurora.org>
Date:   Thu, 14 Jan 2021 22:17:25 -0500
In-Reply-To: <1610594010-7254-1-git-send-email-cang@codeaurora.org> (Can Guo's
        message of "Wed, 13 Jan 2021 19:13:26 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0601CA0018.namprd06.prod.outlook.com
 (2603:10b6:803:2f::28) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0601CA0018.namprd06.prod.outlook.com (2603:10b6:803:2f::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.10 via Frontend Transport; Fri, 15 Jan 2021 03:17:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c9e30c77-5520-49be-6d9e-08d8b9041690
X-MS-TrafficTypeDiagnostic: PH0PR10MB4630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4630970DC59B158934EFB1798EA70@PH0PR10MB4630.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cNwWTKFKs1vrtHlUCwwSKJlYQvD+aSfxo66CRiXfRy/gcG2MXUEowGLZxlnf82KKux0XSEprtJbnFRaq1pg64oqk5AfOBkZKdX7IaWnH58UGXNkEHuMVwuNVVP2nUigGPVNtCFenbdvUO51/xOwcDqcVMN3bA+vqGTBTHvqU8A64ZOKHtnNK2o0KJIxdWYXwWeME9pbtqLWYHadiuh25AS6GxdgxXNDXknVKV8khvyLPvX+46klcj+9bBdYNHMBlsUMtbqAsKTZYubVO2ygdIKWhy5l5Y0j03V23N5OAS9yTwVUBEYUV9+2tp990AkbiDe5f3rZwriIbn7H4zKkbWLyYpKD2wix2e5hxVq02gAIWoEuZJQeO7iQlUVOTEQGWOuAcmt582GpeFDmhK8E3Mg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39850400004)(366004)(136003)(55016002)(16526019)(478600001)(186003)(66556008)(83380400001)(66476007)(7696005)(52116002)(36916002)(66946007)(5660300002)(26005)(4744005)(6916009)(8936002)(316002)(956004)(8676002)(2906002)(86362001)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?bAQoVQjMwQyfq6tHk21fb/zj0WiWoxrkR4rCT8Y0LyHCTvzmhMUUT0zR7TIW?=
 =?us-ascii?Q?dhQYfbHWoC2YpBFprl7Sg6hSY0uMNASIj21+l7FF5MKIdgvjs3mT+oGD2SSs?=
 =?us-ascii?Q?JxCacttkUopbDixpq2mhHInvKmFV7KJEWxx9jQ11+Y7xYgm5dekAQSRdcm3J?=
 =?us-ascii?Q?FyQgjQPKnwss8mgtH8b9sZJg8kRn6cVTp/r4yYbSko3gRTq3MkhTao7w8dJc?=
 =?us-ascii?Q?NTfFI2d6iEB+aSonD9WapGb0jlw4V297e6FrCG+zo+Zp4oA7oHNobMOXfNcc?=
 =?us-ascii?Q?ZKIzPdKlAqN2S+SGcHPHiK/HJnW4HfNVxTYio11szKSiWwh7cIonvR7RmJZ/?=
 =?us-ascii?Q?nj+zCFWqcQnzxPffY/TQ7GI4nk3OiabqOgV5nyrNwUn7/X1hhSWoruzK2/AM?=
 =?us-ascii?Q?eStItvt1sBqpaiie2nG0qOinxIFo1FSUImSiy/mvlTHfkYDYc5dqTBIW30Sw?=
 =?us-ascii?Q?NE1w517ZQuMyh/Rv5HvrkdI+SWtY+A8nkKDulApBR3039ICNTlEvlQwnZZq4?=
 =?us-ascii?Q?YtfthGV0jIWDOZHmaLsA5AnQs4n5r90NEeNx7nhfAZvVYbyKcPtIEZ2njXyP?=
 =?us-ascii?Q?AQiNW+M803XJb0afgwYxBh3ZAQxvxP17terkibJhA/P7mQL+AfbSSrxTphEL?=
 =?us-ascii?Q?eUqf0TKVyMt9VEcCSRrjeNEjX3qUgIbXehRlSv9zWfThh6eGlWeZaz8BO9bW?=
 =?us-ascii?Q?32xYhKt53pomGJGXBoa1AgcTApQCOqnwErZXilpF4uiZ78TBjq8vD03XPqrI?=
 =?us-ascii?Q?FH1Hiyruit7hCEjQ8+bg1S7u1gx7kXb+dWlKsgnFe9wzLay4rVjmBMrn6rDa?=
 =?us-ascii?Q?dpLZRH8WF5lAKiFbKtJqJtjV/8Ivj3OVfQALpgJFj5Qy/KucgdmoaRcZCeqz?=
 =?us-ascii?Q?4ds5oORL9xxTx9/trAEg3GI0uo3xsosH+6y/5e3tsQ3iAXRbRSQXHw8XWjd2?=
 =?us-ascii?Q?FU0fdQtm5XM9LFV0c0Tmc/Z8HGFnXu4uNJFtJS7h/aE=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c9e30c77-5520-49be-6d9e-08d8b9041690
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 03:17:28.3831
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pqh0ItkMdxTbY1/ldAWWfeZRXMXyw015HgIJJexffPITMGt834wbcsV73iDzvp5tNclwuQqSUpGvQG73tDM5YYCMbxPqgK5YNASjNMro0HM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 adultscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150014
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> The 1st change is just a minor fix.

> The 2nd change is to synchronize user layer access through UFS sysfs
> nodes, so that system PM ops (suspend, resume and shutdown), error
> handling and async probe won't be disturbed by user layer access. The
> protection is only added to some sysfs nodes, not all of them.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
