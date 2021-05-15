Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5C25EC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:41:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 21860610C9
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 02:41:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233986AbhEOCmt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 22:42:49 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:50710 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230330AbhEOCms (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 22:42:48 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2ZQXV106458;
        Sat, 15 May 2021 02:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=G6JuVrpMTjVs0YwgUSjdITj4OqHutiFA2novKTbRmfQ=;
 b=bF9V/43Q2or4lIt9FzbRLnrlmx5Gnv6/IKdQCOwMBWQ3ra78xHk0+wciDFJU/frLNe0P
 rLwNC+Zs3lzpr2c2Fl8+TZLHgAlbWzyKrb5JbvxQU4ZOmK5FiQDnOqlWfalTDN+Qu5y3
 Us01VHGcGTH9Hc98KKv77/InJ/i6EsepDMAzNxHHpiPsj10/GWSk9uDgT0ysN0xO2eA8
 pkTV4jCI2qdGR9YBrzpbnk+b3RJlEpMEOvZJ9itRnbR3i5MTB5MvWVtKwubnMHJC5Mdk
 aiQ3rdUvzzYOsAwIv0nKN7aGoOFrmoqe5DfbDpOkTPRjhO5Vtmt5NbRM3q9cLsb9H+9r Ug== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 38j3tb82gw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:41:26 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F2e0Db184741;
        Sat, 15 May 2021 02:41:26 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2172.outbound.protection.outlook.com [104.47.58.172])
        by aserp3030.oracle.com with ESMTP id 38j4b9h9sy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 02:41:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LDByJH0w/dZiJEkZqerqfI3BBastF6G+220TQUu64iGFh+uKc/CDvMEVCTIfyDGPPs3Qp+QBQaT6zDHEyxnnWCxVQ/tMtJc/++viUW1RIqfLyeYqlZQD0wNLcEwT17yaZ7sRIYelGe/HJrNXwmEwxRSdtJ1KbhJSNhztP+iC9fWs9eLP2rpsRZ9d7xhdxFRS2BfQYhIV0ZV8BsE77CcbTRjqjF2KJ1ghqh2qpEaAy5Qs2gfbn6FgL/d4MJHrboCVeJZ1I1dBxCfHk/VRXz2Zx5gFYgLpXq/AbY+dwZnr2HK8/FtR3nl8srCdbZVd7bU73i7BG/vGuObG3ZhPMwYiZw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6JuVrpMTjVs0YwgUSjdITj4OqHutiFA2novKTbRmfQ=;
 b=Z94fkXHllV80FVL7fULFkDEKkz86Z67m/KkwPPCAtcoiX1N4HsXOuTT1zkGNmleIQG8ha5NyFCa8U0ZPlrH9RztfvGCnror9YNWJxoEtM7ZyXWmTbhAaAgHmxOO6gUi5KqsyWD0WJ7Blj9vgfKOrGZNur3ARAOACF6YqPfN+fnHi/4xIP9Npf8GpRXzhV1BDXlkQ6PAxXKILxajvHjc6fB2n5hJmtQTbW7SdZfCRw4gR11GO5M0G3/MEKQiImJdK4f4tad/li6ofy9J3DqQt2ebQFFQ/soU3NYxXLhl5VbQC1MnZT2GqP5mvYocJSa4/xUtC9y+ZohcDee7NWWgH2A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G6JuVrpMTjVs0YwgUSjdITj4OqHutiFA2novKTbRmfQ=;
 b=PR4kbowbNchC0zZfeaAGRwucbSf79MAKCiWRo1RQdrUzxVgMFVt+yoVcr7490NVP8ZRrE654ttMuyIv7JrvKDtunmesFmjqrRXFjS+Wj0eragdDfQ+BNsK0xq4Cl6nMG1WL5uXk0W7ALh08qZJTULScngHWQqUmx+MbFkf1JT2o=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5419.namprd10.prod.outlook.com (2603:10b6:510:d6::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.27; Sat, 15 May
 2021 02:41:24 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 02:41:24 +0000
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     kartilak@cisco.com, sebaddel@cisco.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, JBottomley@Odin.com, hare@suse.de,
        nmusini@cisco.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: snic: Fix an error message
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1im3kbtx1.fsf@ca-mkp.ca.oracle.com>
References: <3b9d5d767e09d03a07bede293a6ba32e3735cd1a.1620326191.git.christophe.jaillet@wanadoo.fr>
Date:   Fri, 14 May 2021 22:41:20 -0400
In-Reply-To: <3b9d5d767e09d03a07bede293a6ba32e3735cd1a.1620326191.git.christophe.jaillet@wanadoo.fr>
        (Christophe JAILLET's message of "Thu, 6 May 2021 20:38:20 +0200")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN6PR05CA0007.namprd05.prod.outlook.com
 (2603:10b6:805:de::20) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN6PR05CA0007.namprd05.prod.outlook.com (2603:10b6:805:de::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 02:41:24 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4e9e5242-d65e-4ecf-25f3-08d9174aee69
X-MS-TrafficTypeDiagnostic: PH0PR10MB5419:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54198F34D1077A0C416789A58E2F9@PH0PR10MB5419.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5236;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CIacC1XwMgVZTKrFAlmTY/n1aqn1Sw5NXOIKW0dKppa84ke10eFB6DjuezxYXTE5jaDnJMo0zV793+EBxhaiy3g+i7MbBg7LCXKNfBmF85jCVca3GbtVx4hYvpeqTbwytmyYzJ8ytF70aqiqwN7SD1+qXDaDia9HjNWuxrpPDPp3nqBSOneKY7aoqt39Bm7MJTx6oYv7Dtz//56lYt3jtMI7zC4MFAIRl345t+mOjnRKYvgmM0b01gLsg2dYvLtQBsshQUGaxByFm2fJ4QwlTPfw6VxnCxgj+VlBKdEKet741bthUf2J3AZNFrbj18RoDF5hN53giJu4u3Yhe42iKqAdOOPr0pFBlLIQN5SmBffv6LVcJjuqRy7CGzafDd++SM7Z3J5E8P9C0FRd/kfaj/+ORGHS0+Ib9cbdovyxjSTi+F0zouhMoTXMN2CWvmuwPonDd3YgVpKIR4Rerb4P5WIibci0KPTREA8EL/YA6+s5fnNHLqCU+LL/ciNvcjHDdIYq0e1kQYKtAQmFVu8Nen+8ER/ctcDXjDNYFP9LfwwVEU8ssjbTM4x9eN2llfoIho2fYg66MHwS0PIYYHuwAfVPUn3FgZgMIqNvGGbhFJRCGsd1pWxkDMVUXij0117ljOu22WyJEJS7xqyZGFTGPA06pU9URfDtYr8Bl/xC7Kw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(346002)(366004)(39860400002)(396003)(376002)(16526019)(83380400001)(186003)(6666004)(66556008)(66946007)(66476007)(55016002)(956004)(2906002)(558084003)(316002)(15650500001)(5660300002)(7696005)(8936002)(6916009)(26005)(478600001)(4326008)(7416002)(52116002)(36916002)(86362001)(38350700002)(38100700002)(8676002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?3le9rgT07ipe5GvVcepe6pUEbxOKTixC1pAkTihj8DC+OgnFvVER3uZkTxMf?=
 =?us-ascii?Q?BMmD5thNh69T1L0ugGytWqld5gSa33y8tL11p3rCg69IMhsSoi4yJZqi/I2L?=
 =?us-ascii?Q?PmCSvLiDzRJ516g1dDdlahsGJ6msOwpxo330KHuI5k60p1e1XtoYxqnqfe+L?=
 =?us-ascii?Q?HXGjPED0QbneSdxEu7KwHXFoan8T/5joDNo1POnUOPY3LD8Chv7UV6uVtfgr?=
 =?us-ascii?Q?yoMwBWoO8x4xcoHhi/iqb01SvoriRMHNR+2BpFzSu1ONjdG96SvH+BCAgvIX?=
 =?us-ascii?Q?Ib5vV1QESzpfTwU5g3+q0tfIPfYP2yJ+wNs0I0GTt+tC96Y+sFyEwCV/G8zG?=
 =?us-ascii?Q?zGhA1n6rUnjaJFGebGYNBl1wALS6Y7zOPsPcbB4VvNcDX0ypUCY9KqIjcEBe?=
 =?us-ascii?Q?+9G5frymXl87FJmqjIIZfznwGF49LPYGQmfRPjxcQQHtv1TH5naPui2KXgnf?=
 =?us-ascii?Q?hYMNCLh6uMlY/UYzTdfyQIbt8O2dKmMs0T2ihMnGRWQhNzpK79HZDTMtBFdM?=
 =?us-ascii?Q?g/1OP8aSiTIT4v/FTk6pMi5SPp34iO1Zh/psIhjtCGz+KJLuIq/Fjl1eVI6T?=
 =?us-ascii?Q?TqmZWGXgEuXo8Eg17/seS5Mfvj5bn8xK/f1e6uzVOnV8+bGesnoZNxlfhNHy?=
 =?us-ascii?Q?JzLxgvIUDVomuKjfbXCoeQn3pfrUOCMIZ2/rncg7Lrqrx/MoeZjzENX9noFB?=
 =?us-ascii?Q?kpl4kzBgDwMjwVRV2q1aW8UXbqsjEcoKdYMjljqn4B7dKICFEfOlFalPoFGO?=
 =?us-ascii?Q?KdZKtFCDS8QxCQZ65dmfVasUzA0BRiGQyR7ufTHB/hzP2BMQCxDGZ0N6hDdk?=
 =?us-ascii?Q?br+kMRM484iMRLGyjB8lQQgLJTkQk0vjNb7jJxvLsiDE+dCBbJpssPqFh4o2?=
 =?us-ascii?Q?+p5g/modPyul2b6lPjUwyq9vnzRt0RD2d5leHsDsQhQaOobspQbOMmNhc2is?=
 =?us-ascii?Q?rOKK1zEPuI1CSgc37cx/2+jRIdNS/X2xB1bjCOSjfeJ1RNLCKujrVLHbpFxN?=
 =?us-ascii?Q?+Y1UQM6tqUqP59FhxhmJBY4kJ5Y4rNoVfMssjh6vBM92IuD7uh0p7m//uxbp?=
 =?us-ascii?Q?62cpFgBigM0q5U+6GpKM8WFuaG9z4+oPcb9THTDmY9sjhx7/bDKtF0gVsfS9?=
 =?us-ascii?Q?yCfErSuuugewnDeS8ghIIRRB+48u7P/448lNedxID9k0tLJ1cOfTM9IJGXAl?=
 =?us-ascii?Q?Z7GI0elFCFQLB/qmNdfIHPAnwJdw90B3SxtoYtO07qCv7H4MTh8SS8UHMKTn?=
 =?us-ascii?Q?ydhmqHnU4L1Bm/5O5pC3coWU0FsJYQQiynR7czFbaObhYgjl0jNggw8G3N8n?=
 =?us-ascii?Q?Z+OfRAYnTW4KlLZW+07+XSEQ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4e9e5242-d65e-4ecf-25f3-08d9174aee69
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 02:41:24.5777
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CpFVErvJZnyVNYXLm5mtwmNW19vnrk/D22H4iJb7NafVasHP3085tm3OFkzKQInPaaHLd2KzBf+lYHnDKLsuTJU9eVa65PkYOgbRoWX0W5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5419
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 spamscore=0
 phishscore=0 bulkscore=0 suspectscore=0 mlxlogscore=982 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150017
X-Proofpoint-ORIG-GUID: PdoilRFx5b5sSQT9b5d3An0eyWW76Z8j
X-Proofpoint-GUID: PdoilRFx5b5sSQT9b5d3An0eyWW76Z8j
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1011 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150016
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Christophe,

> 'ret' is known to be 0 here.
> No error code is available, so just remove it from the error message.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
