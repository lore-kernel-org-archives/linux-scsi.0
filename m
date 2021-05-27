Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E46DDC47089
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 02:40:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C68B4613BE
	for <linux-scsi@archiver.kernel.org>; Thu, 27 May 2021 02:40:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233226AbhE0Cm1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 26 May 2021 22:42:27 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39070 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232673AbhE0Cm0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 May 2021 22:42:26 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14R2YB94024283;
        Thu, 27 May 2021 02:40:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=MUFz+CMpOKzQGkKnSiJgv5LKeuEzVhM5q2sgVeCHfmA=;
 b=aR3HabEOIykiqXsLFXis700EEvyFAAv1sP3znMDSkHBxyvkehq1x0bBABBA+OMAFWXNP
 ub/yOWdl/fUywmiQUmmexzAOAarz8c59FC5NAbGjicu4DV32PdLsSC/PXx1Vk+ceHF8V
 7+xaFpjhjJfETy51RID2Y3t/9/uYrJhiJ9/b9qIetJHBGJHa7SIv/Kj50sG61dXIQstp
 dZZRklM5H4Oiy+n40mCe7kE6LunS13BT0jBtQUsge6q+tbwX+PcKA8hHb6bj1fxC+kTg
 Xp50YkvkPEYFgzlos5Z1P89qTP1+RnsQa7KUw1vQFsgnYxwnwCfGNtppoJyCTSxYNtx7 XQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38q3q928ds-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 02:40:32 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14R2Z1NY095436;
        Thu, 27 May 2021 02:40:31 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2174.outbound.protection.outlook.com [104.47.55.174])
        by aserp3020.oracle.com with ESMTP id 38rehesbd5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 27 May 2021 02:40:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Oso8qMIUjjI4TMz6xaYPcJb9vYzoLdZB6QiQ+Nx07Qu0Ro81Us3B9n5CTpaqt38ZTYyMrFsdoKmNknTIepjJLDzWDaf12CqWUPw2zmchlPh7Ld4m195ZpRRoa81ud5IeN13oJcVXEb4UCFopU23F6Kpz0QSwBQI07GFy7ca7LLrOOsYrGbxxTf2q7w0GuKy1mEyOFcNUuIpFO8A/mwcCeFBle2Wb16+AtxVHf/2d+vjJoxkIQkxZxoMPhXxGbJc+HClRB1AqcmrPsMXK3KXBtejd+yAtEnUMwVXZiHzW5adFV/bDkusCZGjjfHJM3W4CFB+lKFauUGN5kRYLhc6Edg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUFz+CMpOKzQGkKnSiJgv5LKeuEzVhM5q2sgVeCHfmA=;
 b=eZYwphKbMZmBIMC/AXabM/JUekTW/85ghZHRQK5m/huyRrwfZosMqYpEEDvymidyu34NHGp5DWnPv2CWcLB8uKZlOrzcEW/Q7JujMKAmCRqlMQY+OsWs3khFfHiKC8TvLwMRYIjxTw9vTHPgx2JFBfkksUZ6iRT3sC6UIA6AN9mMIMtkWK8bnKlInDEQAJ02OvINq3J3zNjHFNmMCk4Fr8BnQlIdiVU5mDclwvN7VbbNO/Vw40IaCes6da46ieUPQCnWAUZb88kfz+g6JEg/yZU4DUvft/uFMIWIq8Go08pee3v8eRdLswR7/+3vGi3MRHboph8v7ZkK2+muxv30Vg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=MUFz+CMpOKzQGkKnSiJgv5LKeuEzVhM5q2sgVeCHfmA=;
 b=PmoWrjilke8oUxeTc8HRiLHx6Ai77mmDhR0W1pOLA1VvP9QKGekIalrBbeqiCg769OOgtsucu2X18xZtaimxIuFDRCXSS8w32ESrP7e5ZdEZoYaHgCTXBUbqatIY6Y01hmNgG4brGcqs26clmhJ1xF2kXcbUTUi22mJ/bRP7HzQ=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4438.namprd10.prod.outlook.com (2603:10b6:510:36::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.20; Thu, 27 May
 2021 02:40:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.027; Thu, 27 May 2021
 02:40:30 +0000
To:     "Leizhen (ThunderTown)" <thunder.leizhen@huawei.com>
Cc:     Ulrich Windl <Ulrich.Windl@rz.uni-regensburg.de>,
        <open-iscsi@googlegroups.com>, <dgilbert@interlog.com>,
        <jejb@linux.ibm.com>, <linux-scsi@vger.kernel.org>
Subject: Re: Aw: [EXT] Re: [PATCH 1/1] scsi: Fix spelling mistakes in header
 files
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2c0vs0t.fsf@ca-mkp.ca.oracle.com>
References: <20210517095945.7363-1-thunder.leizhen@huawei.com>
        <162200196243.11962.5629932935575912565.b4-ty@oracle.com>
        <60AE2272020000A100041478@gwsmtp.uni-regensburg.de>
        <215847b9-f64d-8cb2-e53b-13123770ca1a@huawei.com>
Date:   Wed, 26 May 2021 22:40:26 -0400
In-Reply-To: <215847b9-f64d-8cb2-e53b-13123770ca1a@huawei.com> (Leizhen's
        message of "Thu, 27 May 2021 10:11:41 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SN4PR0501CA0076.namprd05.prod.outlook.com
 (2603:10b6:803:22::14) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SN4PR0501CA0076.namprd05.prod.outlook.com (2603:10b6:803:22::14) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4173.12 via Frontend Transport; Thu, 27 May 2021 02:40:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a92226e6-f336-4af4-9c5f-08d920b8cae2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4438:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4438CA77041EA62D067C06888E239@PH0PR10MB4438.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: jYQeTUGhQPfqS7npIirN1Ah7CtV6of3SoxG9inZdOjKr/7mLLaKb2NTXaZH5/TtckI5Hanfcl3OiIM4j+ez7F/s3eSA6UiQKaMUmQ2xUeGCBsCpyPmfCiVAQvYN9q1yClfAJZANKUK/SzIwjyuVSxODBx9tnStl+DZHgkiprVE5H9ldRm2dV7kc8qnD4Gv2JBis6DnE0HGnZdxHuIYwTm9EO13P3Zllx/TWdS8p7fIpMdibQEv8+GtERyoWIzX7jTGBqxBnRlvyBS2BqH+fYzLYVmlbRDKpADBYSSfU1xYoDenIFpXyKL81spwNnoaJBLhD48bGVDiuPNdtwaGnMhfenlsEImP+m+MCG9KtKcABWL2IE9m72Pm/+wQJgBQ0HouPpwhXypU/zgev2Qb/KxF6axHxhG+OfCfHjLQ+Br6Pa40H2AbctjtZnuB7sG0O2fmjYVW/nfs0fyp3g4NNhFtItETbxalm4esr/jBvCyN1ORE+DeyhIDQ9iC0hetn7kyn8HhtMvArBg2Df5LfLiDqIXUPrswgSorH8OIcZ43WWFzwuMwSUckdPfU0onGRq4fbgzGwHHrN+78plnh8mVXNYqZQ7nIpLt47a9IBwJ9lP3cfTwaLPDmTCREpGejkM4tdHqXXNcCCLRndCED5zG92Cmtf9Uu8+czxa5r0zTofs=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(956004)(52116002)(86362001)(6666004)(66946007)(66556008)(4744005)(16526019)(36916002)(186003)(7696005)(54906003)(5660300002)(38350700002)(478600001)(6916009)(2906002)(55016002)(8936002)(8676002)(4326008)(316002)(26005)(38100700002)(83380400001)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?IVOQQXvwT3djKjV/aXQNyw2dplDzGavMdoZ+/xMu6CADqwg81Pvp6jsquO+v?=
 =?us-ascii?Q?N+pjn4xlnVHFDE1t2sDc/2YJ0CbtIZJKBYS2EGTBwtOCbAicwMYB7aOYJ/fQ?=
 =?us-ascii?Q?g/4T7n/eG79U/Omom6rIwbfQpjXvOCUqYnr+ZQmE00Q72FUYwi6tShxDHbBF?=
 =?us-ascii?Q?S5qGGXHQLJKSKRD+6wfw1fB5Cdxvka01cD0IzXuJ08dEKnegXM5Q3fRL8gia?=
 =?us-ascii?Q?YaFQI6CmIFEqBo4kyaAUBssTzuBrWOMN+MONZNnUXZkCJvxSWQaCq5FthYNH?=
 =?us-ascii?Q?HGypfqgCBpTirsRO4nY1ncgzZp8h+Z63w21QQnYygX/CVMdqzgqh2oskSOC7?=
 =?us-ascii?Q?UqfUWQEWoVDl9tIJ8j2YIsbQEk8D3EKArGNFyD3wdM5kC/m5vi7N+vFdICTj?=
 =?us-ascii?Q?oWOH+8G1Dx1eJ61bbG1D8xdAB1FgQDZLTqV/wXPfmgbetyex+COIl7kO21jA?=
 =?us-ascii?Q?ByOMdEvcoNO48mepLe3WqpTzY5WAQvrOc9SbyNi6BHjblpHBWCGnF5sCL36J?=
 =?us-ascii?Q?KJOvgNeI65SRZZaVFmD19ytWB6WgnyUzWQma7Nc1MQO2uDhNuVm7rqRtUwzV?=
 =?us-ascii?Q?caXnqwhXV21Qk0gl3rTZW371C6XTZzRtU2vthHDPEUbRlHbbwovDK9rS9NgI?=
 =?us-ascii?Q?QLNx9CkNyWgpCvbN8ePZA+t1r/dBH1SFSHol/ulBZmduEbWsBEoRBj07zFq0?=
 =?us-ascii?Q?wo+c+p8nX46EVqVnR2vxc6slc6Q5T3NaM7Hxs6oJs9AMdpn5+cM8azHvEfB9?=
 =?us-ascii?Q?sH8FK7XQf5X6TgyDMmPx5P/oSQpmwlQs0P5WqcXUyxC3a0WniyuvwDUfih5Z?=
 =?us-ascii?Q?0ijSKM+P3N3Bh6dYvCzkqHrorA/G6dhbmMe4nbQ7sTe39cxPtoZxgM/OiOoS?=
 =?us-ascii?Q?867xFPv6RbsNPE7DFP7Tx4PnWU8RTDDccklcw8OTxdVkQSg8SD/+jGLN+HfZ?=
 =?us-ascii?Q?0AnHUGfn4pDwcRy4aPabRiU5U4EVqRuGY/d010FV4TQf1pt5v8iKmdc739RN?=
 =?us-ascii?Q?omh2ccUq/r609B73r96lkQfY+mVIvUL4PMOcsUcFNCEIUW9YrmksAG8AT6tf?=
 =?us-ascii?Q?OCaFKnJmDkxIAqu/iX88TGXqRcMpLVFxLyVEP69zr047PKjlG8C2hjRiaMib?=
 =?us-ascii?Q?ZRlYuGT9dDZVoBfpXRwOj7nGwCKgvdjSfMo2/xooxYMqd8DLTttH+0bcnFoG?=
 =?us-ascii?Q?Os8KAJyg+iAqJGGt/6M/jQqii4Brq7JABMkm2KtbGxnsqzC9+KOQSdDMSX/S?=
 =?us-ascii?Q?2fxQcn5xHgp2By3SdH1s6P3Z6eihyFckJytlJAUldKEpF4gWYKxDmggrUFnL?=
 =?us-ascii?Q?cvJIsojPZJ/N96Bq0LQWfT9d?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a92226e6-f336-4af4-9c5f-08d920b8cae2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 May 2021 02:40:30.0451
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: qhaMvoOzwDxAybpfeeI6nZVOlXj86jkB+UrgB69Iy/CO8i+aDI/4BxcqLlAv0+qM03NFRiRjXx1/MJdbi9bulIwXkmLzYvVu6AEZQCt6PVo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4438
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 adultscore=0
 mlxscore=0 mlxlogscore=999 malwarescore=0 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270015
X-Proofpoint-GUID: r_XpG9CZD3Jehwz22xpW16ilfmIeSUww
X-Proofpoint-ORIG-GUID: r_XpG9CZD3Jehwz22xpW16ilfmIeSUww
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9996 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 clxscore=1011
 malwarescore=0 bulkscore=0 impostorscore=0 phishscore=0 spamscore=0
 adultscore=0 priorityscore=1501 mlxlogscore=999 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105270015
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


It's an unfortunate quirk of b4 that it quotes the description from the
original patch submission and not the message that ends up being
committed. As a result my commentary didn't make it to the list.

> Busses isn't a misspelling, it's just that few people use it these
> days.

In the context of electronics and computing "busses" still appears to be
widely in use. In any case, whether to use one or the other is up to the
author of the code in question. I only merged fixed for what was obvious
typos.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
