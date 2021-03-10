Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0C273C433E6
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:27:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA4E864FEE
	for <linux-scsi@archiver.kernel.org>; Wed, 10 Mar 2021 04:27:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230183AbhCJE0U (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Mar 2021 23:26:20 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:60618 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229570AbhCJE0B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Mar 2021 23:26:01 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4PYZU078800;
        Wed, 10 Mar 2021 04:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=G+5gX8TJPEDlOJROQwU+Wrw4ZM2aUOL3S5Z6+RtNP5s=;
 b=vko2bdc+jU/OsJfOW8+ny1H+OIKdQM9DxwFlZJMJq+YgC9+Mbghy6SBmlAfXw+uvMayp
 Bg0pqmP/aETNLSyiFpx0SgSHKShQCgclpwKDkEmWKImQkT6gP6NQLmPTDu880XsXEkD9
 oH+ewunWNZAUguVCKGwRdCZin9ntYXb1FbaMfLtKt9kojIUF0ldg3k6uOW5uDjgUtGW6
 G+Ae2CbYvd4r1emtV/Cb3ypOGXFPrNGq77W2GC97qaxtMOzzYy8I3XSyn83yiTThqw2m
 JbyhgYZb9jS1WFsl49gARKOz5XuZtAmfTjj8PklLFWdzvBRZVEk10+e9USO08Zn9eo+h Og== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 3742cn9k7h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:25:49 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12A4PRhE125641;
        Wed, 10 Mar 2021 04:25:48 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2175.outbound.protection.outlook.com [104.47.57.175])
        by userp3030.oracle.com with ESMTP id 374knxst4r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 10 Mar 2021 04:25:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BHSPJnKNVPO3U32jIJF+s9dXy0ech1dP9GDYGL1jo6o8C2bewGGheMNxXopL/YWbQvKeMzu4lxxnanzgIGG81ZovfpdOOTHcwhFXZgjsdFNXlbem/eXgT4qJYJjlxCOqHbbmILqXmQp0FHRC+evVH8Lz19SMle1iMSQsLsobYcUT3w7rHCJ24ypD/FhEfllKXkpYpvw9GAftfvNTblRUgDdnQRmI+iC19BhL4yfI7BczspWRlZR30LlVEiDHLxNMnyMJ70JDlTlIF4pllJrXtU/t+RAnIJKP9advDoq3fsnOsFP+w24ykdzAngEiAC+fAqR+ce942JfPbhyZjz/RtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+5gX8TJPEDlOJROQwU+Wrw4ZM2aUOL3S5Z6+RtNP5s=;
 b=jh8Du6rg/EphWUjY5trR+x+rEOsMNEm5YnLtyAgRPnd38LY6Bn3Zpp3YQJ/xFgvQkmgL8im37Qwyi3rnMXaLzPFUi0YOLgsuKAbAt1I5W2TR7bggAB5s3UO30GoHgHH04RJs6fILukwXeAlfCOArPT2gXU9mQe7u3bx2Z6PaHbtl8eV7UU+ecO8is0dpQOK37ShPz/B8F8xa315hGXMpqzqI+yUuukrBjTE4g1KHdTeR16vJS4IHZxH6IOHJJJrxFsY+UXNerK5F9G+FHQH3sJyO5MkpPoj+ybkqeLzXCVtkL2QDyzgdQWKtdx5ygrVPnsaS3O69sOTzq0dN7MKQbA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G+5gX8TJPEDlOJROQwU+Wrw4ZM2aUOL3S5Z6+RtNP5s=;
 b=vr203xst8kHf6aOBTWrFxUWaVf6kgDWm3nS0mUxqNjMZc2mIqk3jOlbUmlZiNcR7IHbvsGPhbaeTHi+F1fidlqYSDCjr73UAGOBa4BKX3tBNm2fJinKYQGKvaHWJL3F+YZ6unMwQZNEwU1xh9x0IY+JkF+cOqzW9OKsinsLhtEk=
Authentication-Results: 163.com; dkim=none (message not signed)
 header.d=none;163.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4661.namprd10.prod.outlook.com (2603:10b6:510:42::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.19; Wed, 10 Mar
 2021 04:25:46 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3912.029; Wed, 10 Mar 2021
 04:25:46 +0000
To:     zuoqilin1@163.com
Cc:     khalid@gonehiking.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] scsi: FlashPoint: Fix typo issue
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq15z1zbpoh.fsf@ca-mkp.ca.oracle.com>
References: <20210304055120.2221-1-zuoqilin1@163.com>
Date:   Tue, 09 Mar 2021 23:25:42 -0500
In-Reply-To: <20210304055120.2221-1-zuoqilin1@163.com> (zuoqilin1@163.com's
        message of "Thu, 4 Mar 2021 13:51:20 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH0PR03CA0112.namprd03.prod.outlook.com
 (2603:10b6:610:cd::27) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH0PR03CA0112.namprd03.prod.outlook.com (2603:10b6:610:cd::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3912.17 via Frontend Transport; Wed, 10 Mar 2021 04:25:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 64c2dadc-51bf-4160-bba2-08d8e37c938f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4661:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4661DD3905FC56C162D9368B8E919@PH0PR10MB4661.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2ewuFyOGGJMZ1hNsRsMDGjoOxwberVaf9tzSilmoql2vqUenKKxfLaxBwcwFgz8WtcM4CaIhUE4MSmYlqHlroz6Kfo/s9u5MrVRv7BQOXLLqjV6EG8e6icZrNG6ZLftB38g8p12ZeyPpE2Z/BkFeq/o/HKnK/BYYdxsomH53I/pjxXG14UW22YjtjziChUsuaWbt7oXHS978sdwVUZevbdLt1cxO+Ki/5+gOL5E0l/N4AxBaPm1cVs1uJRTbgwriWoQUF7pisdcp2R6ftUAPSoN1TmDSEKe5BH71A+uJBMcpVFOlo0ElQIrXYQzxd0JQQuIq5IsDD3lysbYcLe1gdfUh0wpWn8RpiNCqnHkXovq0+EbCwcOosRQEPGYPgPv1KtzuPosC7v/tkfAXh744ci9ALZ6AFQUAN6cDVViyhokGPV/LY6s9XtBHBeONGo+j6J2q70j1IdkLjqawf9sSAlt3Ln26xw1548vxPDtN5NDc7Cy0XAyXvaivJlcyK+bHHzkapKENfUaOhd1QxIok4lIdp50QvYZX4wAcpq47x/pZd/XtmW79ECrnTuCcho6f
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(346002)(39860400002)(366004)(136003)(66556008)(66476007)(16526019)(956004)(55016002)(5660300002)(478600001)(86362001)(36916002)(52116002)(6666004)(66946007)(8676002)(186003)(7696005)(8936002)(558084003)(2906002)(316002)(26005)(4326008)(6916009)(1491003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?1PV6Yhwat04BfZ5zD8OeBK+yKhHJf6rwCXFKSWLaqbTM/CLUhze9fgsCg9e0?=
 =?us-ascii?Q?YHsuk7flh1wtQs1hBMNx84+l0H83kuGVOwRDh6wzZmJIuQQj7vIswgPdWxW4?=
 =?us-ascii?Q?Emz9cwO7/w0hltDR9MzlU24sQ33RMyvJQHRvCG6qkbjwEqxSLktHnfTxP9Ht?=
 =?us-ascii?Q?SFcUC4CXk3hE9BNBjcz5J9NYCDDb+jpgVYEv2TEYt3qPZ/TxzfnDZ8gaWRUP?=
 =?us-ascii?Q?Saort7Mcx1xbcLpm5stRRLYYwElZmGgA+yqSfMNjrYf+3PsiI7HUcqbEovJ+?=
 =?us-ascii?Q?mWSDcCIZDyWog9iaT+P5m1+66crFIDVLuTdkz2NMcqH+SW6lvcE5H8dAj5T4?=
 =?us-ascii?Q?dqKNRg9p4PJmFtlEkbR+tCvQ2hMtlOzFTOFB6oWUhE1q0rOZp6pROnnrQ+/J?=
 =?us-ascii?Q?4+oFUoTbcysYbUWc0JajdCjqk+OsqGotbriVVbJzD10ycF8P1xJXtXCyfB8X?=
 =?us-ascii?Q?9+hfs18eMD1iEmb3zYGhXuJHrwMPn++nGLq9fNaP8eIBFpy/T4DMqn5WDb5m?=
 =?us-ascii?Q?MuZ5G2FTRhky+8cdbhKj7GdjLdNq9op0oIHNhVtUFRTdbMm5RKLC2sNL8YhZ?=
 =?us-ascii?Q?mqt71GSB6EQ/oSv7y0YhkvLoLMHx1Dr7z0jTR7eSkDmP54aAtUNZDPnfOG49?=
 =?us-ascii?Q?Zoy8SYiIS2ux61A0LSnukVFphgt4TCVCs5pnP0B4rT/EkIcLw840Bqfg23fc?=
 =?us-ascii?Q?80H7DuRRqqmWFMeDdbtZhcGgrTvMSbvVNT1IxRa79x78hJcQCfaOaAINSa7b?=
 =?us-ascii?Q?1veGEvt+fN3Y6uW5j+kO3HVKBx3gGLA5pFAAqJhRjmWd3rNL2JBa6JcfSQtN?=
 =?us-ascii?Q?R5QfJ6vvCYE/R4/Zfu6oWdPhzstLn8fzj2DCcsWWeIQNWzu+NZ1+wE7N0B5H?=
 =?us-ascii?Q?NTlW++UwCvXtedbn0YrmFrEzaEMvhkQ27IOkJ2qQ8cGnANuifWJePPCAxSP3?=
 =?us-ascii?Q?5N4gIXTW0YaU4kUrVXV0WbgF5t33JWvO2z3CXSyhW1oCA4HZBAc53ZKK8aJG?=
 =?us-ascii?Q?okmjf1hFIQaWvaPs3jT0eiQrTBAdv9n7cE2fPqf6dJSR4CsaG4v/l5SK6CeT?=
 =?us-ascii?Q?1ZlZ+akOzS6R6D9AXZaqzvBEDVTKCjhj/z/NGklOlPccqzkJD7To+HYWnZFM?=
 =?us-ascii?Q?gOw+Fo//WuU/lfSe7KNSjI7cCNogzgsU4N3qT3GW5IG7yhVrtObzZMfDImZy?=
 =?us-ascii?Q?1so7iyoMCgEyZmTDiTBgZD+VLTY/g9uNyPZwFfwLiC0x432ebs4Hdd1dHEXl?=
 =?us-ascii?Q?KcqBif28T4k8q/a+u/bcFnqtHvmEYR4mWClkuzBmpbb8XV+lUoz5wSGUnh3k?=
 =?us-ascii?Q?7HIME5MKAx8JXpwoNYSM5Qz0?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 64c2dadc-51bf-4160-bba2-08d8e37c938f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Mar 2021 04:25:46.5230
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sYA69uLozfRG2P5rijWdN8+aAG5miV8AKtthIVqI2UfyY5D8duMA46ypAXl8dLLHaGkXOGSYO2F4RqkmjF3cEC7XP7U89bFgWsHFpoSGPEM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4661
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 adultscore=0
 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0 mlxlogscore=852
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100020
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9918 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 clxscore=1011 phishscore=0 adultscore=0 mlxlogscore=999 priorityscore=1501
 lowpriorityscore=0 bulkscore=0 mlxscore=0 impostorscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103100020
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> Change 'defualt' to 'default'.

Applied to 5.13/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
