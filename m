Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B83CFC04FF3
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 02:59:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8DA91613C8
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 02:59:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231255AbhEVDAo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 23:00:44 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:54082 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230527AbhEVDAm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 23:00:42 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M2x9IG131572;
        Sat, 22 May 2021 02:59:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=iG26CwsvQPCN2VIsog3h0lhnDONEvgfwuNVQ9qDJry0=;
 b=SKNCnzXsohYgRyjb45LVm6XMlf0b39db4REr4ujR8uooh0av0R/f7tG3WnJTw2QCRkqM
 ky+lDFZHhOVdSvOfXHDNVgBl+fNPMI+3gGKmhM4y8SKGHOYLrVSSMHALpnQ1eNq+GT/V
 BfhK2L0NrEbOXc4tZxvOtLHWrgAp78Y60+61a6iMafe711lz9JjgTDUE7rWJPFv0Vjt4
 WT5GAo+jckS2gv3nNLQzpa41HSU8kH/w7XgbGAgPc5JH9h6GuOoZCHBuU1Lccc2amM1U
 TdLAjRScz6VVkJ9+epslKn2EXuO2JCNHmfUqzjCBzoQ56EV6Cyn4Iz/e1AloWbB5kAxX AA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38j68ms0fs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 02:59:09 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M2o19W005564;
        Sat, 22 May 2021 02:59:08 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by userp3020.oracle.com with ESMTP id 38ps9j0egs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 02:59:08 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Xt/uBjyRZ45L20is/6iDNVdtL/NeE0KA+yTdHykaWJHj4d4FfZm7VJq/B2CtGJzavvDV1RdDznQ5XM1DpFCNkDV1jA5MkodXT5NGfecK1WOJ/iXQQkq65n4QuewKOvAzq4lYh/BZM6H2LRgGPpvLCesFyO/OWzdu11MsNJITWhRLSvTK0MfMSQ75GXdezBMC5YBATIJrPpZCVbkeLDpop9AuNNxsHhLl60DgZ4nR8JyatZtYqTsHCuZYfX+fiEGvO+U0ZT77PPjV/vaqZgXWzSFPCIJn8vV4EIDFj5v3eW3ZFoRYKOzfAtZSqfvpK+RA90hDE5EOXfyusQb0qFGEig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iG26CwsvQPCN2VIsog3h0lhnDONEvgfwuNVQ9qDJry0=;
 b=PwKcvMDRfsV4QlvbpbihfX5x5MrnDNbMFpbdYKRpidJBX7oUGEY2I5gkeVutt+nW1FjoddzkY5s4HcRlBS9FOQQZKxsIp7wvnA5cN1EC5dsIF39XQUaaA6X6g+9T372+Vlr/f64Qhh/qavymO5mo41AGu6sbmhQh3rB4+hah9ul490ToWj9E/TztYuNixCGpMg1c+EAgwolVTX47LTc5aepkj/Xap68pEIRhiluZvdexN0rpcw1traN/x8mJxwCO+KP9L6ZRldKLyiKtLkx/uxJaNjvg5WtnqcsbkBlEufXtEGdliPYTgwNLEHBVikeBaSOnLmgy6W5Y+PLD+BYPIw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iG26CwsvQPCN2VIsog3h0lhnDONEvgfwuNVQ9qDJry0=;
 b=gP+yboEvd4aG+NfDkM5uSZiLjmm/K8bagheNC/6eGOKn/mabK/PPblidTf0cLmgpECrI5KXaj9KO5JXSnPsejsPU0hKzkj6Jc9Ro0wODk55Sq9XR5HWOil8vNBZVz/bwoVqJXP1iipgczimmvXAzi9Nn0yx6ktQv4TEDsbnXAmE=
Authentication-Results: linux.alibaba.com; dkim=none (message not signed)
 header.d=none;linux.alibaba.com; dmarc=none action=none
 header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4487.namprd10.prod.outlook.com (2603:10b6:510:40::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23; Sat, 22 May
 2021 02:59:06 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 02:59:06 +0000
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla2xxx: Remove redundant assignment to rval
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r9z1nke.fsf@ca-mkp.ca.oracle.com>
References: <1620643206-127930-1-git-send-email-jiapeng.chong@linux.alibaba.com>
Date:   Fri, 21 May 2021 22:59:03 -0400
In-Reply-To: <1620643206-127930-1-git-send-email-jiapeng.chong@linux.alibaba.com>
        (Jiapeng Chong's message of "Mon, 10 May 2021 18:40:06 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR04CA0010.namprd04.prod.outlook.com
 (2603:10b6:a03:217::15) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR04CA0010.namprd04.prod.outlook.com (2603:10b6:a03:217::15) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.23 via Frontend Transport; Sat, 22 May 2021 02:59:05 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8d99205b-8784-4a2a-42b2-08d91ccd9024
X-MS-TrafficTypeDiagnostic: PH0PR10MB4487:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB448725E9B0B9B67D95EF02DB8E289@PH0PR10MB4487.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gzKLy1YYXdbWl/2VC6u3Jin0p7dK7bP2tGroOJv57Q5f+McSzYpleKtMV2hy1IlO+1erM1pexqUmjCwjhEeAieL5VnwgUoIjRob/eHFAcI1OAZoPaX8BH6VhcqCeTI1KIB9EQCW1zAa3YsPnsf5aub3hyPwQrl44Z5taRLT8W24v2ZtQh4Wpi7AjQCnf800IY803iZcAkEYfKzFGJlOZbCaPoSIw31hwSYyAb1TKHZfwyQWrAx3tWErXfXSjTFP8tBjCRPFewGh9d4RzVq09VWDkBQyhlvrI/RqBp8kIrkHuzNgfF+HtrFpH7uck7y2xRzUdiMnr8KSaz4pNuxJld0hIN9GtJirV34rfbrWzhn4NH9Dye8sLjWSC+t0mIc5HmbZxKffkOUV3swjn8hxnuZ8kuGv1ZX0PS7nK/o8YviMfZlA5Nl9tGi3mrx4fWNK3G7GcMm4q/+AerScKgZTzwqnHh831eE5Wgon00wct0WOeghEGvOzORPliXb17W4oNHyB5QegF4tQBftCyz/qegS0NdM/SZUdCtesIu9vOkdMkT25/pfRCi0uODnZOi9Q2uBB0uV9PtjhLXmzm4RpzK5sSxqN+JuH1n+CXXjGCy7tpDlPnGd+laTz5tp+c0qyOV1HMAvK9M4kO0SGKTehlzMMrsU7IzexQjzXCbkVsZV4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(39860400002)(396003)(376002)(136003)(346002)(52116002)(7696005)(8676002)(956004)(86362001)(4326008)(8936002)(5660300002)(26005)(316002)(558084003)(16526019)(6916009)(55016002)(38350700002)(2906002)(38100700002)(66476007)(66946007)(186003)(36916002)(478600001)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?GgfAoE8WAWq2bVUYigbQxnW1BoUAU8MVJYtfhyJKBZmGErYO7cJ82vqTPNAd?=
 =?us-ascii?Q?Q5zDm81AjTQtoR7Zfy1Mz1FazjwXk6HHERzBw60zI4mFdw4182bTv5lYjpi2?=
 =?us-ascii?Q?p8TH1j7olFag/8xebeWFh8nYmX0NxwP+yJ+sjAkRCxzD26YwMU82nTViEvlh?=
 =?us-ascii?Q?2qR+0iEh44NQb+SMCaAWHXY6EaFdGk9BL55u1/SGsrmEPI3Rl7+HU5oDGZ0W?=
 =?us-ascii?Q?+d0T8pekwC9GANY+53DWlg1cPNelpbfDYi43py7vvGx3SqKeSE9QANl0yXAr?=
 =?us-ascii?Q?FnWPmoc1HS/9JWK1lFbTKRhUIZm9uMJcPMc94cnlL1b7rfmJEBWM4cNMn6GD?=
 =?us-ascii?Q?qXp//SztjSnKCnsOxDHk6fJW8Ipj4zTxGSFmx5faBNBcPicGLEwCD7dhOc+6?=
 =?us-ascii?Q?SqDXo4V59gSF92x9OMD0ybg7+F+tGfmyBf1q198Dpge6gv8vHqcEpaz5KDun?=
 =?us-ascii?Q?LMh0qyL7tUs8eLu9jsuG17t2IwkpLmtnXTNbNnVIAzGFcZJCYvR4/NTvEEoD?=
 =?us-ascii?Q?sr7j1ZPhHxMGgio5wjRNI/4shLGepjWNjkmAxkFNqdEathagJVh3WB/YdH6m?=
 =?us-ascii?Q?hIeS9RXJG+b+Mf6HL2G9vJquBbnym2Zq1inOOSDUgbClpGTOxpxOGAiQ0QOm?=
 =?us-ascii?Q?frToZ/LzTY+3uWVW/72VDjCUB43znBvUC0SvTqeAve0Z9XcCB73P4Ek/FW5v?=
 =?us-ascii?Q?iDAcl0yvgT56TmgI/+vDnvTSQ4mMiqQ3Im0EmzWFP28psfuGortrvtcgNR4G?=
 =?us-ascii?Q?XownBamdCMNOApz1uIhsLJsIGUfYq4oEwF0dcnGAS/8VPML4ISw26ZN61Ly5?=
 =?us-ascii?Q?WINWWDfOjmzsTezkpQuTBuxSKqu9h5lkrWqFufWWSAADORkkP39Js+L6+Hbo?=
 =?us-ascii?Q?nLtwnbWmsriLKER2829PKapS+EaiRjHKE+U7f8Xclo2+AAJnpSFNEoY+QTy1?=
 =?us-ascii?Q?LZyhN8f51Aw9mitpdcvcCtqfNPfm2FBPU+0cdKYR5JdA9uoYI12lv/FIvfIJ?=
 =?us-ascii?Q?QgQesqDu+L77T+hA3ezLqIjogIx8YVVqToy0xGnU+Rrli4nfZ1c95KEmwQdH?=
 =?us-ascii?Q?MmCBsp4cQqwoYoOKnHAr/nWGUyBK3TFth3vnsNsfMHwxFl3QTVUzbDyu9fYZ?=
 =?us-ascii?Q?tVV89WXUaKLinajV+m/r6jlgSikfV+uwuIbN5C+QXTkLfe9vMt4zMqnKM4nl?=
 =?us-ascii?Q?F12fU6R+eufyzf1LqKsIrfJXdpGx93Nwks+KYI8gGQtDbhGbRFI5XoksSs0D?=
 =?us-ascii?Q?Lr/vhMvBG7Mpa/z3AyL3bTkhWmRW8J1BpxsvastM/oFGDQRLFu0QH6MC5F80?=
 =?us-ascii?Q?6gmTk41emGQW4L0KLeXBExVp?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8d99205b-8784-4a2a-42b2-08d91ccd9024
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 02:59:06.2999
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zrrw9+OZn55xpwulqtnc1dEZGBxf6HC4y8YhigT2lujee9/rr0Q9btDhxvv1NTwLEE5iPilyqM36xio6Z5twtKpveZvq/X9Pd87a/4osXNA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4487
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220016
X-Proofpoint-ORIG-GUID: B5FvfUvDQb0NerzBwYmu7uyv6-1TIti1
X-Proofpoint-GUID: B5FvfUvDQb0NerzBwYmu7uyv6-1TIti1
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 priorityscore=1501 impostorscore=0 suspectscore=0 clxscore=1015
 adultscore=0 bulkscore=0 phishscore=0 spamscore=0 malwarescore=0
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220017
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Jiapeng,

> Variable rval is set to QLA_SUCCESS, but this value is never read as
> it is overwritten later on, hence it is a redundant assignment and
> can be removed.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
