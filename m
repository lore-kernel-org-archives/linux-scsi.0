Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD945C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:01:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A01E264F9E
	for <linux-scsi@archiver.kernel.org>; Wed, 17 Mar 2021 03:01:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229710AbhCQDAi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 16 Mar 2021 23:00:38 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:38540 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbhCQDAJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 16 Mar 2021 23:00:09 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H2x2QL138876;
        Wed, 17 Mar 2021 03:00:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XNLZyUARPxlqbcS53x+uYonQ+616tjWpLZym/g34MSY=;
 b=IgZtxuJziDyTuWYUD23Kq982lK4sbzgb5Z1uZASMG9dpi4brGYxgnLgS7bc/MqGjQev9
 ZO9jzVyf1QlJotvxSb/AeHv77mVCY5r3vNvWHCu9EQ9QM3t4LTtO/QqTbrUI8LqITsIm
 V0V9g8E85NCvRU3jeJxoupO/vQ9VTrrySvLlheheJhpWy+l5sZduNsH4jrF7mwJWfS2h
 ALPX5COUE2ora8g4x4/FWw6Zvvq9tx+gmkDH8vj2XBPwA3xouFNXTKhjMWhFHv9kg7zU
 qm4ILg7LNZN6WqSq/+skGH+IG0ovCI8doqp4dJzfI3b27bpS4BSZN+upXYBsA2wI3hZH mQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 378nbmamnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:00:02 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12H2tLaP113252;
        Wed, 17 Mar 2021 03:00:01 GMT
Received: from nam04-sn1-obe.outbound.protection.outlook.com (mail-sn1nam04lp2051.outbound.protection.outlook.com [104.47.44.51])
        by userp3020.oracle.com with ESMTP id 37a4etsmnu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 17 Mar 2021 03:00:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TQ3gUAHA/FQg7wgFSylVEcwI9M1sVeRlVu1SIvFMEh/KDUq67pWTRu7J7qRpn7Dw6nH5b3T/eufQkbIHyQDpAfml6n7n21qhM+6pyE080dQ56q69V1ktmriVcKtr/IIKUx5UzZtNbu7GLDkjAS+2XUC4UIv7CxMG8hee0vXOhErgPz9GNk2o0eW+9tlQjwiCPmaIGC6niXbQVgXGP+35UDpLjfhMU0uKRkv0oZFke8Bdj+XiDVMlhY9o6OfrpHXePtG1vQt9n0o+pcLtrFEU2vseaSm6sXJuPxcJLWc89KnLJ6S1KIDwgmCvYZ4uoFhEKJ7a/pHK+sn8wEpryB4F2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNLZyUARPxlqbcS53x+uYonQ+616tjWpLZym/g34MSY=;
 b=X6oymCoM3L0tgHBftvSsjizXe7fI2muI+cUi1pszcK6mRSecZ2OL85geK9oCfc5EL7VT1KGOGV5rVNgLXTKsxMZvb6xSqv0vHzmq4JqCjdBsAKcQfsSsKHH3plJYOF8eFdPEgz9hw6VwwsWGy4X+PO0F8ZEhGw+hMTieZ6QZaDTsrNEFl9KzE6ixt+RzqHTLWvnlHpdy1hyoAKlzpO8c0vDNZm3wA7exeUo1sguho7+jG/x6RGipEo21NaonEXeaSZrQJsYulOlB2g0Ds4HUIprmGpltMsX3G2Jnbmewe9iIfIvU6ysCA4fk/mu+CHCYH+0BpEWk3cbgm9BAtoDOrQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XNLZyUARPxlqbcS53x+uYonQ+616tjWpLZym/g34MSY=;
 b=PCVRweYghCnMn7cYiUtXZBkfVRbPGXPdNBpZA3rf0og5I0zMCh4dfdyedDGWn/2bv5nph4XQF3qChf9WM8WqJu/wr1BSQKTBGByNkq0JJiK/y6cjIegS0uX7tdvH59OvbU+pjyCQLc1yCajNmsthFccUl3aqTnX8iTAywAp/b2w=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4677.namprd10.prod.outlook.com (2603:10b6:510:3d::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.31; Wed, 17 Mar
 2021 02:59:59 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Wed, 17 Mar 2021
 02:59:59 +0000
To:     Arthur Simchaev <Arthur.Simchaev@wdc.com>
Cc:     "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "alim.akhtar@samsung.com" <alim.akhtar@samsung.com>,
        Bean Huo <beanhuo@micron.com>
Subject: Re: [PATCH v2] scsi: ufs: sysfs: Print string descriptors as raw data
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1pmzy1o5v.fsf@ca-mkp.ca.oracle.com>
References: <1613410846-16883-1-git-send-email-Arthur.Simchaev@wdc.com>
        <BY5PR04MB6327DEDB1CB9EEBC8365E848ED6B9@BY5PR04MB6327.namprd04.prod.outlook.com>
Date:   Tue, 16 Mar 2021 22:59:54 -0400
In-Reply-To: <BY5PR04MB6327DEDB1CB9EEBC8365E848ED6B9@BY5PR04MB6327.namprd04.prod.outlook.com>
        (Arthur Simchaev's message of "Tue, 16 Mar 2021 11:27:16 +0000")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: CH2PR08CA0013.namprd08.prod.outlook.com
 (2603:10b6:610:5a::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by CH2PR08CA0013.namprd08.prod.outlook.com (2603:10b6:610:5a::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18 via Frontend Transport; Wed, 17 Mar 2021 02:59:58 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8e515b61-6c8d-4718-656a-08d8e8f0c0ac
X-MS-TrafficTypeDiagnostic: PH0PR10MB4677:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4677262085CC4F38DAC61D978E6A9@PH0PR10MB4677.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4714;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /p+rzViCp5/J/MWOk5s2xYAlX4wh31MYXJblsQm6+kkA0stisRU60JH9n1TAHOJZuF+b9YapGdYs9egc5Pc+1hSOR5tZ3To4FITxnBlRpq8dWu5Gaq2uAMt+Ffn49h2FZqWyvHXWtbr0XIisLC8tDHnBZFcOIq3xHJM8su5ThG9T7mhOFkDU9ZWDtrY9c/UiobI0Sze8DMTIRHWsBtw9A7dFmkBIDkPQpomngnnGkhwSjaV+fRPeZGuV7rYmFzqng0kvers13rVXmn7pK5s7Rm+FDKywos8FoK+n32qn8QxXlxL6E5o/TxJerMPv+28Gt2yb5gPDPlZuGjrRekULK6YLDETDs7c5ahOBZ34lNqRzKuf8vGRpiNmpN7yUnOK+dKBeu3+ZqRn8OFXYY5zPyCX3jJIwQvR2rFErSBEfVWWbe9V7GjYjd04gef0lBFJGRcElxM+oyl4iCf0mhigb6RPUfOFp7NsvEJHiZvSL3UYDYAk1ZGPEsXQ3HDhcgHfxd1NUaHf7wsSvvTX0raS1+SPsLu+X5yZZylqxGpADA4UIRLdcrEzSYlfMDIY/cYlj
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(346002)(366004)(376002)(396003)(316002)(478600001)(6916009)(5660300002)(54906003)(2906002)(26005)(8936002)(8676002)(4326008)(66476007)(186003)(55016002)(66556008)(16526019)(558084003)(66946007)(6666004)(7696005)(36916002)(956004)(52116002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?VNHfRhaas+GNKKI8NXkoqs6sKzS73J7bnOvG7Jb0WE3g5azyma2tBRDI+zKv?=
 =?us-ascii?Q?EpyJoPSEmm851HmxeSMiO2FaT/ogsaAXZoiaVS8DOxMYjO57N4Oop7Ou7S01?=
 =?us-ascii?Q?jADe3jeKCruxX7wTqGbC3K2VJNjsTjXBZyJCfm2tLwFN2ZJB+LRNj9ejC+wH?=
 =?us-ascii?Q?qn8JZMQLXeGwZ+zaDWXauEDlKfcc8Dz2lWVPl12BbCyd9sXmCpRLVqW6P0u/?=
 =?us-ascii?Q?V5Y8Iw9yi1+drKhciMy017XOw+bIWXfmHeYMkQ+GNqA9z4PSlz/W2jo96XsC?=
 =?us-ascii?Q?8VmG34hssjiaZTgYQ7Vh03boD2eS6HnAKDjKOaghbmWB5wsCcJIrWLcu/hoS?=
 =?us-ascii?Q?Vqd1VU49mgzE+0l3n50i8hVIIbMD5nK7DDjieZvkoVk8j+SYkVqVnVcL41+J?=
 =?us-ascii?Q?th2ktRDI/MDmufrnZ8HGo05N6SusOS8RElZXjP0mJVjSxkXbiqxwhMms9tZw?=
 =?us-ascii?Q?EIvNN+IgQfvYo5/5LGl9mS2quEz6NX59wvxoY/Kd5F/JIoxRCPSJZazSTx1b?=
 =?us-ascii?Q?DC+SRme/RPTfwqnKLBYtp46YImUetwr5KSW0PYFCPP5qDCWyj1K5Oez/bN6q?=
 =?us-ascii?Q?HM9FNcO6PtbTx9CnOzqDglJmqRCMVukmVyFp/9WZeWhScsO07CfJn2EuOdcH?=
 =?us-ascii?Q?q2hd64rwBEEScrcOtkS/odEAbdyEDEiSrY2A1Pj1fiBvi3YggXalL7NUKhyv?=
 =?us-ascii?Q?vheRItSKwUGWnDCQzYr32wzH7d0CxAJrHTeolf0H5iHNfSrYaasbQ/OyAtxU?=
 =?us-ascii?Q?tlZ+xL8wovFlfvWqj+9wkKHdHJN6ig/JxlfkNMVIg0Sh5sNaAxVu4C+MNQ4E?=
 =?us-ascii?Q?hF1TioAPepGIyECYbh9wGvriPHtXsavcuLOWEdMQvJzaeFq/l3I4kdaj1YdS?=
 =?us-ascii?Q?pe4lMsRStMZXHRJnJ2k5uzuOQOqRcg2sSOe/8ejkokSaCuBU23MjhDnGSIvt?=
 =?us-ascii?Q?mRK7dsLdsfPfUvuOwdpHqg22TpPdYSUDAcdKur+JMmauyTngbWTboWg/oOgo?=
 =?us-ascii?Q?YbIC+73yCuLHIkeldjq4uhYhEqvPO/3UeLqeaCx7WPQ0QqRiMhCGOMoR7Lk1?=
 =?us-ascii?Q?1jp71cu3blUGMCfWc48q8ynm/gD+j4DkfvrnIqr9c08zHdlP6V1ZT7Ek4Yh2?=
 =?us-ascii?Q?p4oKo87tHkWDyGtlAtME+slfYYnaWAoebXhq3lE75STv5BEGRH0VelaeCDTJ?=
 =?us-ascii?Q?+8yPXk/VIkeHVWfsS3HRmz10mhPFtf7GzbEPWVZF4j9Yp/S42FczSU4jZaJT?=
 =?us-ascii?Q?fCkTMlrCIhFjwZBwoYqZb1Akw+pGoTwbyJcYVBgLacto/DIe3OHCFjrWxGVV?=
 =?us-ascii?Q?IqVDqkXiioVtb227Z5quAuc4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8e515b61-6c8d-4718-656a-08d8e8f0c0ac
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Mar 2021 02:59:59.6169
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cso2xk/Mk+2pSoabCIbGe9NPs34X9CUFiI4j5ye2LwO02S3ZcwPXaYGxM79FUE4pCijcArxzAVHgaVd9iefkMnDx//M6u4SOmHlgo1BkJCY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4677
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 phishscore=0 bulkscore=0 mlxscore=0 mlxlogscore=999
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103170022
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9925 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 impostorscore=0
 malwarescore=0 adultscore=0 mlxscore=0 clxscore=1011 mlxlogscore=999
 lowpriorityscore=0 phishscore=0 priorityscore=1501 spamscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103170023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Hi Arthur!

> Could you please consider to take this patch?

The patch needs some reviews. I suggest you repost.

-- 
Martin K. Petersen	Oracle Linux Engineering
