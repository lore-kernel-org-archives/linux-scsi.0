Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C455C43381
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:37:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DDD6E64DE8
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Feb 2021 02:37:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230226AbhBIChi (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 21:37:38 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:58582 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbhBIChP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 21:37:15 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191Ixkg014590;
        Tue, 9 Feb 2021 02:36:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=NRL2hvwkKlkdmJ1vP1Dk+f76tc/dzf+8asYZ3Wag/vQ=;
 b=IdJGd6sfiyYKBVWgDUfQBHeWWk8hEqSqG+bDEfSC/UXr2WKcDhGyTe9qQRJ6q+KYpx2k
 uz0cuOy5khAFH08xPuzJhBWvKbl5k9THYJfhmagHVJ7Av4+VhKhmzSpXUU1QTv2EzyOa
 3VhvoA0qG7TOoP3wYBzMrgfaNC/Al+8hM7Bym1wfdgFcgE/Oc8uOjCAZC2B5PlGaA3vO
 O/KOIeXLHNvRAOydY5MQG/RKPfJqseim78VEB4qf/XAqR09FO/Jx90dvFUMGqLRLGvjo
 ToCaFS8XgFBf1tnEkfOpB29VjNB+bIoh6+Cx40PlEn5mabi8Ie6kmHIxqW8JLn6VR07Q JQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36hjhqp1u8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:36:30 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1191KpLN089674;
        Tue, 9 Feb 2021 02:36:30 GMT
Received: from nam04-co1-obe.outbound.protection.outlook.com (mail-co1nam04lp2057.outbound.protection.outlook.com [104.47.45.57])
        by userp3020.oracle.com with ESMTP id 36j4vqp7cy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Feb 2021 02:36:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Nf3GRqCTsnp6nY9K9JRh0uVxvc/SAuj94WSDoBJuCfbpf7xzmaQ4pZ+USOWQc9Sh/dpze+82x86GYfEftVn3X3UQroYMAr5MPVxrH5J1/2Ru7KHS5E9zi53lpFaBSuQ4BupEA52/srR2EtEAtb0BFSFhv7WY9oKUsMk8/UNGaOIHbfvTSKU7tMqJpl8JzIRnibt6vvAakYdGtLa5SW/y12u5w9c4GN16YA7YOCbKGeUdXw/OrJkW0fs6GnRiWg60nCwi6tj4qjoZgwxkjdjNav5GHRG3LQ+yUenA8WSyBTyUpOqgrKJxMLSW3M6tOFmxxqaABUsaWdvH8BRruNeByA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRL2hvwkKlkdmJ1vP1Dk+f76tc/dzf+8asYZ3Wag/vQ=;
 b=XTKCF1Q/ne8FRIH0LNDYRikkRVlv6YEfvRkOryWfFff1wqu28PL5HJXEbikXwfresPBhaPWevzYFAmP5gLxWASiNf5r009lgo+T2gB0aBzP/x9foEgG6iKC7wR8t5faySnchLjY+sbFAUfa6PCVLXSmRQuXaICXiefWyNXuTGgjZTZDGQZC+JxdckB6gB2vLgxrV1qpuOvA7fO0vBBxZ3mrrl0qitHOyjn7VMinC3o69bBDG4piRopNUw1qmI9I7ZqT20PUV+tWx6lp1/Y7/CdManJIbYOFc9f7vxlP6QQ1RHn6V4AtoDjgdI/pO3oblhKptLpQxhQaSLcuquVgsqA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NRL2hvwkKlkdmJ1vP1Dk+f76tc/dzf+8asYZ3Wag/vQ=;
 b=LhNKiOiphdAy3FE+w8wzi9M1wc5FGS3V4+58/zm2pcR+pLpTjDJyH5O2D6Jg8StYWQyjoXNWxyUKTv/VfZbFSW82dZoHh6FB2H8Rrwjhx1WYhqGxcuypXQgxIhqq/PQ/Q/gRm5s5CYDewP/b2u4wyRj4Foy2P7PJZerhE+RcWcw=
Authentication-Results: broadcom.com; dkim=none (message not signed)
 header.d=none;broadcom.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4597.namprd10.prod.outlook.com (2603:10b6:510:43::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.24; Tue, 9 Feb
 2021 02:36:28 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3825.030; Tue, 9 Feb 2021
 02:36:28 +0000
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        sathya.prakash@broadcom.com, suganath-prabu.subramani@broadcom.com,
        kashyap.desai@broadcom.com, kernel test robot <lkp@intel.com>
Subject: Re: [PATCH v2] mpt3sas: Added support for shared host tagset for
 cpuhotplug
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1lfbyrmqp.fsf@ca-mkp.ca.oracle.com>
References: <20210202095832.23072-1-sreekanth.reddy@broadcom.com>
Date:   Mon, 08 Feb 2021 21:36:26 -0500
In-Reply-To: <20210202095832.23072-1-sreekanth.reddy@broadcom.com> (Sreekanth
        Reddy's message of "Tue, 2 Feb 2021 15:28:32 +0530")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BY3PR05CA0014.namprd05.prod.outlook.com
 (2603:10b6:a03:254::19) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BY3PR05CA0014.namprd05.prod.outlook.com (2603:10b6:a03:254::19) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3846.11 via Frontend Transport; Tue, 9 Feb 2021 02:36:28 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1fbf80d5-b1e8-4b55-245a-08d8cca380df
X-MS-TrafficTypeDiagnostic: PH0PR10MB4597:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4597064F52130E601F1FDC538E8E9@PH0PR10MB4597.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: uDDT7Z9v3gqjZT+rPgMo83IyTV4MRne8NqHscMbr3u/BlTLhkuyUdSmzNZcZ0NPnZwK2nYbvvcgveD4RE2bVNt4HwxtBX992HsYZf1ExkDM/hOjfsVgJb6jMFRjYxKtFHoq/0+//9zg94U8xjRCperTz0EM20V3IXQjMyE1EYZx9oEfaP52W4DOxEk1I91tUi9eUs5eKkHeemtrLFj5GWnrJu3iru128qoFJ97+BDFSor1IvQb3XfqlCjf/MTyAQHheY84H2c/MNZ8oWSR07SllxfrVYk/iwr97piCnPBdBF4Lp8Vu/+udO842yWnLokbUkGaGT6aK3fvnlF3EGTVPlUCsCHwJ31T/246BBqf9ncoJ8MKUhD0u8xgrxp7Rla6fX43ei/AR5Y4i315fWb32tvGACarXwGlCebhg9kTWopadws3PHHGyNVypjy0hLEl+TS9HC5FQyZhanC+puiizwnstmniS/3poC+uc7p27oYPuLywSZnjwN6Ujsc5h/PDpNeBcUIsbpz+P+y2abEDJyoFT/5lPGQKwK9ykImpz3c+qUeMeru8BSH5vZ/6yC3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(366004)(396003)(39860400002)(136003)(316002)(4326008)(5660300002)(2906002)(956004)(8936002)(558084003)(66476007)(36916002)(52116002)(26005)(7696005)(66556008)(66946007)(86362001)(55016002)(8676002)(16526019)(6916009)(478600001)(186003)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?zQd87QmwXTCr1vimzWNDGRwo9dkUhhHLdGhfRTxw36PBqVEbJI5PS/3ulVPY?=
 =?us-ascii?Q?jfg8ll0CQL/ChmLm2Js8tZAq9ASghf8eTQl2gcUu/GabXBy0ymhMJQFUTLFP?=
 =?us-ascii?Q?WTfaTRGccADkxUID/7IfMj4D5+upgyhSLSu5X3Ls1BPDpkFGuvgTOnQHzZKE?=
 =?us-ascii?Q?kgQwybyX0e/SkR2Z3ntdNQqJubcjWa0F3uDzBH6J3VNH9kbcaEDSlF3NqZE/?=
 =?us-ascii?Q?6ZYx29KmyKN9jja2S/uIrnlxSWwjuNFQ8Snk7Po4T0Z7LQM67XlLrpEsYkl9?=
 =?us-ascii?Q?UJAMjGJW4sJbJX4nqFUZ/r2oR5wE+5yHQEYtT3xn357/nPT99ov75KJhughs?=
 =?us-ascii?Q?FV79jMXCppxK76CApVRjWcEw5ocXCbMV9J2V1U631tcKnaUrYnyACclySPWC?=
 =?us-ascii?Q?J8a5gc2A7RrE7bqaLY4rTVRbfWpDTCsEu5D1jJ8ukbod/zobHswoeP6nIYW9?=
 =?us-ascii?Q?OmZGhga3x64lI6tn2b6zC9fnqYoDmxqNK0/c4bMZOGnJEoX94NIP4XXPJtrO?=
 =?us-ascii?Q?mbCETSjMlT71kxLe+r+wIuhB3Vau355U/pbVkdq2dJuS8dfIBf5biRX8w/sp?=
 =?us-ascii?Q?fCb1n/tJ68YbK1J8qtRpfP2ttEski7CM/grdYEbN3CsQpjz1m6O1y8x1tNYX?=
 =?us-ascii?Q?y7l+VHbN+8fY5MVAruslvxrATXawxlE80gS6ETCgbgEFQScn9fb+G/ft8q0E?=
 =?us-ascii?Q?iU4PYCC/vUxqaAB1elJRW/CyjD2DSiwhEySJE91/qKORSPjeJ+PqNWR9WqSX?=
 =?us-ascii?Q?/99o2PfCh3AXuo7FNYw9E8ARaJsBRDx8m/bA/f8FGAIARnZ2dJXC0+y9Cw6O?=
 =?us-ascii?Q?HRlQLmCZ1qIZUGGp7ahWJ7XyqngjxhkvdQp3kWSbtog0xdLJl/NvwH/fd7Ia?=
 =?us-ascii?Q?x3qIqRCsAi/84k992vzOD9ovlzGooM4DcfqgnWmvIhcW4KGV/pGFPsJnusNC?=
 =?us-ascii?Q?+V6U711cvktEoKoz8YHSY9unR1z6H/t2ne6dwF0jY5GszxCInIWoIJl0GEIE?=
 =?us-ascii?Q?03LXvDqVz467OGDtgL3MPDBT7FRVswVG3by5/l/Q82MMWIkhUgGN7V3ROc3T?=
 =?us-ascii?Q?0pt9i+b+Q38WuJNQzLNNZTj30sL2Fq0ipvLoYoTYCZhEazvt9PciMN61veXz?=
 =?us-ascii?Q?t/BbFuOy78OZ2qdylAcjrcRhqvv0OXYdtSi9eaEttxBvHwrNfKYflsLeUaea?=
 =?us-ascii?Q?R1v47O2F9vfU8gYvMqz6dRr6EOsr/icy21/ibS5iAGG2hTt32zKr1+N1PjSV?=
 =?us-ascii?Q?rKJnD4A1hTC4wlaKZiHQdj8v/icNpMPfSDNkzNIYFJGXTuCCUzFi+4Ao+Ulo?=
 =?us-ascii?Q?TcflBN8Yx5FhohTZ2IQsEDP4?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1fbf80d5-b1e8-4b55-245a-08d8cca380df
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Feb 2021 02:36:28.7694
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xvEIf8NrnINn1qpZdx8KwaY6ZzGvRSjXMeYWwucEnC0jsEiJ2qlVRPmhabkqXcjlR0iWlNtDzEynPfqI+CE4zGbspv94R5Ic9d+t7L5Xp9Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4597
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102090002
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9889 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 impostorscore=0
 priorityscore=1501 bulkscore=0 suspectscore=0 mlxscore=0 phishscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 spamscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102090002
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sreekanth,

> MPT Fusion adapters can steer completions to individual queues, and we
> now have support for shared host-wide tags.  So we can enable
> multiqueue support for MPT fusion adapters.

Applied to 5.12/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
