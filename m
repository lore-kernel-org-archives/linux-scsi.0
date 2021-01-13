Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5A20BC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 04:19:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 15E3323133
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jan 2021 04:19:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725873AbhAMETI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 23:19:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:51938 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725372AbhAMETH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 23:19:07 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D4F9KW173471;
        Wed, 13 Jan 2021 04:18:21 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=jdeS9bf0fIOXOpMN0GjKI13DhMMSHiBgTiehOGsdYTw=;
 b=O6pB2Hm2ZBUqPkN+FaZu7dCFhVVIC/VUtR0Qf1j6Bzv8fMBauHKUMUoYd+IswQyztAMm
 U2+3eKX/81rvQR3pEPMrKdyiqq7uTewGklfJZptTZpVvOwNegEaSBk+wVEHdJ7IuMPyN
 H6GQwD1tAEVGx9clhdKBU0aD+4o5G9lzUmRgi/FHW3txms5aJxmrH60RA+LUeULi7iet
 GYeeosV0aNm8imqIXEKffwC2PBgD7sBCA5zkSNadbKBAvKaC/OnRkT1Hp9iOi5GVrXhW
 CG4N9a5ogJBgaQBM3UFAXSql9Gkga2HuhHZoa2RzkKFyzIsR+ccFUzpeQ9AFQSbDYY5l lg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvk1dns-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 04:18:21 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10D4FdSc176404;
        Wed, 13 Jan 2021 04:18:20 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2174.outbound.protection.outlook.com [104.47.59.174])
        by aserp3020.oracle.com with ESMTP id 360ke7n878-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 13 Jan 2021 04:18:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J8erhIv0fRSqizU7AJ1xOUH7gAjLby5yiawKb23csw4Wya8aCoIvyf4ESsykk3R1R1qhqyLpzrBOP9T2zTTKV+EXSFwViCbUmjbFoE/z99IGf4vACZNJR8lk5vpDJaPI6aNjFO572xPXloNyFFhEN0TsYtRBT8jfjhoKhiPzrX/ESblnzf39rmUVo8PLFUgopHVQXM1eOOXfAEWAPTsAbZFubhdWN9nzRmTWlpk1g4HwxDOaJaXf7NCN1YfpEkqsWpEHNwZHS8iywKMrY5F1ALw4r8GfYayf62DK4kBFnm6CMU5CbkjgRJ6QEMlg8nlMYS040UTm6XcVKcRop+LeLQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdeS9bf0fIOXOpMN0GjKI13DhMMSHiBgTiehOGsdYTw=;
 b=MPlscXj8rJeeIy+HmF09YDDWfL+2ch4x2XBrupIHwVZzU5NyADbjFFn2tt3t4COukHi3CirW8w8mpR/j+bGd9Ke0WDvMcvfwz5OlQwJYVbxmizrS/G8Sksw349hohvOkiXWTg1DA3rJ5nsYjpJCJW7mWWiLsKBU+hP+uTvEfkrvGs0ms/MFRHlYWCkLp0Ba+Tn/YDQQlooe4iyrH4EuDCbuYzKj4/1BAGR0DgO6hKi5YW0NTqKzRb8trXrN1xzjolABRkz5J7RcHqKlg2eclXH1ZfdWbiGFhTdZcR2m+BCZMUZaK526UxMYI17y6yKTTMva+mDp3lyzKaCVfIxPvrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jdeS9bf0fIOXOpMN0GjKI13DhMMSHiBgTiehOGsdYTw=;
 b=JIJbKqJCfGwPuUOmON5DJHoWHOliS38CsSWHG5atXnu/jDgX5tBWfEcGJE5YAfMbhZukc3jNLhFVJvxeE3wpoLXWLDnls67Dkwk2XgVuCa6zRPYNVugC8B7Frjq35aGOyFg2KnzMvV8eACm0Kv8cXyK50MKnqurD8Z9tecg/vxk=
Authentication-Results: codeaurora.org; dkim=none (message not signed)
 header.d=none;codeaurora.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4662.namprd10.prod.outlook.com (2603:10b6:510:38::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.9; Wed, 13 Jan
 2021 04:18:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.009; Wed, 13 Jan 2021
 04:18:18 +0000
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com
Subject: Re: [PATCH v3 0/2] Synchronize user layer access with system PM ops
 and error handling
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1bldt4gis.fsf@ca-mkp.ca.oracle.com>
References: <1609595975-12219-1-git-send-email-cang@codeaurora.org>
Date:   Tue, 12 Jan 2021 23:18:14 -0500
In-Reply-To: <1609595975-12219-1-git-send-email-cang@codeaurora.org> (Can
        Guo's message of "Sat, 2 Jan 2021 05:59:32 -0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0801CA0007.namprd08.prod.outlook.com
 (2603:10b6:803:29::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0801CA0007.namprd08.prod.outlook.com (2603:10b6:803:29::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3742.6 via Frontend Transport; Wed, 13 Jan 2021 04:18:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce98a286-ff0b-4878-36cb-08d8b77a4168
X-MS-TrafficTypeDiagnostic: PH0PR10MB4662:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46626F1C6373A2DA06BDCF558EA90@PH0PR10MB4662.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: q+XMUSQsFIYta+frmUqvhP6PTO7kE55vwlSq6Fj92VPWkfb5b4RbhKIh3P13GUjYIRAIE4Pwepp7xOY42j/RW4lZOyfhGqg0dyBy+CoWTPugofMlXzxxkXJdDILNPhrOaHlDMMsYrj8WJ6Qx83Xu2Y/vBoTX65ZoTSMAO4Q1GCYFta8EGMMa7wNH6bJb/jNZRRJXA/shQAkMRTgl+CsppfPeK0g6v3e8PERt1QJ+hhDawcQFy2XBBupB7YalbFWsppnlrjYTky8LvQ3tphtNNps1lsw5e3Fwqff86eL/+sjP5h19R87KCkLbdxc4wHMgj/T7QUZcaXCH2ShGLTHB82+Auo2kVvgOreF4oI9lpJyijFTI1U5fNU2By+fZ6p4kQA9nMP8ui6LiYPYJj2X9lA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39850400004)(396003)(366004)(376002)(136003)(558084003)(8936002)(36916002)(6666004)(2906002)(4326008)(55016002)(956004)(478600001)(66946007)(66476007)(7416002)(7696005)(16526019)(186003)(26005)(8676002)(6916009)(316002)(5660300002)(52116002)(86362001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?m1DCxQ9KTv3HYTVkv6p9mt77UaLpvFwwygB6a9viFj76VpZ0sGf4CmhLYbhQ?=
 =?us-ascii?Q?oTX48dOFqdrKuw1z2LaLBoXGl15WTk4J31wi4Gzdl37huYpMNjRs2VmuNrKW?=
 =?us-ascii?Q?FDfThRwEaPLAvTA5HYlIgDe66V+vD9u+ooSzDexYsCumcZAqzC1IgdymEIXq?=
 =?us-ascii?Q?OuFB4GgCHTMEFdsCpKNJkmzmFXS3bNXvCUqb8uO+aHL7yApP0JnZQGWtaAs1?=
 =?us-ascii?Q?iHvX1R902LgruRGb8LwGcfBzJNiZZaOU9fLEXFFz4hs+gjv6SLjj1ccX2iG5?=
 =?us-ascii?Q?LUELKwoxklbwLbYp6psegvWo8Tqn5OuBCC04TIEnszgWBiUbDsHE3QL/1X/h?=
 =?us-ascii?Q?XYh6GfYzgqW5p+9TysebJ01cQpEoltN8/uEzvnv81sT5YNjdR3sITwoKx5M5?=
 =?us-ascii?Q?MFaextKIm9rXJN20owQHAaR/X2ZEDffEUeaUcs2r82Nwddg/DvNtv0rhpKBH?=
 =?us-ascii?Q?F6OGMPFfJe++2RULBfNPxrgRVj9Xvlao8GWZH2Deheyke0C3oZNDPQ/qHS7V?=
 =?us-ascii?Q?isAxcAbJVi0OAOQ0p4wOOWQ/e76pyhmYp8k6G1F3REac0AmJK91aG7wnYAXS?=
 =?us-ascii?Q?wj7fQtnXlcfFmqn4ZCViU8ZYh3Dny7LOpp6xr/9MfSWpTZfobmwGnioU5Taw?=
 =?us-ascii?Q?FWwI7DC1m7wOBj8crBbywYBb2TTxdetRB3jX63M4QULh3thKhQn7oG8DTlvG?=
 =?us-ascii?Q?/hxk81+dNgJW0krDG4MEU6spyHtUAGri3uU+RcNezImItb2qMtSDQHJIPnhz?=
 =?us-ascii?Q?1MQCP+HxWtLyGjl60H3UWw66eq1MnKj3X2X7Jj14vFwhETkHoju2FwGC+OXm?=
 =?us-ascii?Q?MO1ww5PcY+p0VxVNiapakinT15a82mNWUGvM2ZoCEThHDaHrGNOdl6XgyjuU?=
 =?us-ascii?Q?FOJDLwRJPey+43TPkcr/yv6Ch18cbVgrW4GZqLWSD7VBFea14VWpeZEOKGIn?=
 =?us-ascii?Q?oNFfgqItsaf5rVRlx/YTXfwfu/SeDMFYfufxYH/iA3FKoTSTbaVU4jMq9rLV?=
 =?us-ascii?Q?rE4e?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jan 2021 04:18:18.3131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-Network-Message-Id: ce98a286-ff0b-4878-36cb-08d8b77a4168
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ev5DKxb5hBWSjLvi+QyughRwqKhaz7pkNW6bZdj7hypBpv+JsrHpceIsNmZR8B3re1YtAA6jjQkQqTSO9Pk31wCjRD0RiqO+YsoV+dKIA70=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4662
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=975 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101130023
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9862 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101130023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Can,

> This series contains two changes and it is based on 5.11/scsi-queue

Please rebase against 5.12/scsi-queue.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
