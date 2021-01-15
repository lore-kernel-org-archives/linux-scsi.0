Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9C400C433E9
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6A3E223A58
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Jan 2021 04:10:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729291AbhAOEJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Jan 2021 23:09:48 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:43640 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730419AbhAOEJq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2021 23:09:46 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F43c81144072;
        Fri, 15 Jan 2021 04:08:54 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Xz5CZGWwM/rUgGukERZhG9rNT4oB5b14xFcsMYIwOgU=;
 b=UJA9be2+Vz4JMKarRntFZ9SjoUwvQOAXLMjHGGHeW/OUh0m1vF5GH7vlCWQtk/AW3bRp
 rLLmyi4Pam89ptQgPrGWpqupgBRgwXjCNOno0VoSapkTF4zZUnID7nZ0B9GfylJ0TnnI
 8ZRrLWI7O/+fljleoD4y4tbQm9aRDIQfrELZxgkZRfz3B4e3IvlJ+zdnkHwFEUrop0n4
 M+5K1Hlt2VuHGmQzhNLo6yw/gVf8ZGL5p105sp2o6riN4IxBhs8ytgilUZdrR5itHXbe
 pgQvsAWMdkr4zrXtHRQcF9Y0ML7Pr2fLy5G0puwvPoBvLJ1Q2f35jc1nY9WJk0Kwc1Ha xw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 360kvkb6my-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:54 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10F45jPv018720;
        Fri, 15 Jan 2021 04:08:53 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2170.outbound.protection.outlook.com [104.47.59.170])
        by aserp3020.oracle.com with ESMTP id 360keaqqqp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 15 Jan 2021 04:08:53 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GvNXvwVNf2JKVGuCVAtcH+FzPZ1xjuTQNxABVBIuRrkJMgbo+Fz1T8hpTDUgs2pPoJmZnGU0Ca6vLRHFzvcUF/l8HHCNLXjBDd9iMHJIexQPLqm4jZMMurjRuM5NvfCIBevnC34fhfh/7XXPU0cPGgh56bGXAHJBz9q8O/xP3LlS/vHs2JsMzLUxNoe44Tm5urveW6fXnmqBV8diC/JR6IW3mVM55S11prKywyeYkn3z4Cn/UvC0cX1//Sy137yTAMP6hlX0ifDpL8QJzuyUn+vRYlTEoyQwc7xr6ySg8bmN0NeH43/vL2yERWZ7cAhB1UAFAKyqfvx4Gjwg4ay/gg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz5CZGWwM/rUgGukERZhG9rNT4oB5b14xFcsMYIwOgU=;
 b=EJ/XxZsu7G4L6QPrgeDCYJRHlJyHp8br9TCSNC6BiVuVKpo+DgrCKK8Irna77PirMCfdMR/hTCx3jy8R9Aqrh4AfDqyoMUVzBz8rp+Xh66H8BuXi3VReAQHBFqaEcxo/9Obzj+e4JeYEK4ENc6YY1tugaMCYD7t0TG6+y8MAEQvlH80DjKB9UG+uJnROLb/zyK3bOrC9r2Ql1F4JdmlV7No8wP+ZOiMlhFOA5RVZ4H3MrT6mdGkASal7d3+fALzXlX32YiG6dauPSX0lU/VXv9aqnI8NigPwvT6Yzb5RUS0V7xOX8ZVs4U1TKyLphxQhwm9dkjJcl3tVD97mDlwoeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Xz5CZGWwM/rUgGukERZhG9rNT4oB5b14xFcsMYIwOgU=;
 b=Hp9fkUUZFluJjC7cp1B4gc5bB4fUu5hdxOkHnwpfa39qnkZa3AMPcYxBKkQc08WnQADbb+t4PRU4x6hOhIyMJGlSvY8HdTfcFsuNP0HoERWE6/sVPoCcd/SuxMkEvPu3oNSh7NyX0oCQwpawsmUglzutB1vceUKBLLtSdn2SDYk=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4568.namprd10.prod.outlook.com (2603:10b6:510:41::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3763.11; Fri, 15 Jan
 2021 04:08:51 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3763.011; Fri, 15 Jan 2021
 04:08:51 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org,
        Sergey Shtylyov <s.shtylyov@omprussia.ru>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 0/3] Improve comments in Adaptec AHA-154x driver
Date:   Thu, 14 Jan 2021 23:08:28 -0500
Message-Id: <161068333184.18181.6634024957301346107.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
References: <2726d35a-ac66-fae9-51e7-ea4f13e89fd7@omprussia.ru>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SN4PR0501CA0139.namprd05.prod.outlook.com
 (2603:10b6:803:2c::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SN4PR0501CA0139.namprd05.prod.outlook.com (2603:10b6:803:2c::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.7 via Frontend Transport; Fri, 15 Jan 2021 04:08:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 049e268d-b1d9-40b2-81fe-08d8b90b43d3
X-MS-TrafficTypeDiagnostic: PH0PR10MB4568:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4568427C734CF43D29717FC78EA70@PH0PR10MB4568.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3826;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 1RPtxFOgPaRvhRe7qcix+pGU/+ohydoHDiMHODkyWKW+EEwkVhYKWPOoDHsC4vcyDNN4X4r4DfN+MPqPXAhzFXpZzA4Y8Bu3iVO8cfhyDsrkT1VeeUYihitFxmDcuLLP4eFSlMSq9NMjz749zEehGiorJFBl9nVLf7DR+gLi3+pIx3OjzVlOZ11d3RyBSExvI+IIcJtjTMlGgPkUGgUyC4wOJmfzSgh0GEE/ofubOpTRlyFSC64kAJdr5kW/XnkKJdXIHCw1tje6KoLYOpQ75Z41jsDfLJwENpXI742lVRkD+QZVS4p+X7RY2XaVtfB2uymQd9ax23dOuJVQbiD8dxxLJCZK51hw40LHZeEBqRGo816JwSjRV8otN47nbDq7DfTr0svBK/Y4r5vGPEZPM+SeF9zesIj7UhLiE+XpZY6hwgvTqkDAWqFrHt2EmjBkEhUTXl2hIFNYtmfSki6AHQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(136003)(396003)(39850400004)(36756003)(6666004)(316002)(4326008)(107886003)(6486002)(8936002)(2906002)(86362001)(110136005)(7696005)(52116002)(8676002)(103116003)(966005)(26005)(66946007)(4744005)(66556008)(478600001)(66476007)(186003)(5660300002)(16526019)(956004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?YldvaUhQb1JESmRablA5cXN5VWEyNUkvdnJ6K1F4Yi9sbTU3SktTLzdYdk80?=
 =?utf-8?B?MGx6YXphN1cwUngzekdzWkNaVURVYjk0djRiNjUrdHBsWXhiMWhpdEF0Zldq?=
 =?utf-8?B?d3FjTCszZlBSZTBJZWZ5Q1dVT2xKYzlqSjVPbjV5OXhITCt6YUJCWWhKZ05s?=
 =?utf-8?B?SXJuQy9aaDBUSGhZMEZSdi92VDUvZ3NXd3pUMzg0OHhqVFUxZlRqMmptZm1Z?=
 =?utf-8?B?Y1NqOHQ0d1dFVlg3U1pBSzdhSTlRZTZKYjd4dmZ5cWxFdUltN0VDYlJ2eUF0?=
 =?utf-8?B?ZzhoNmdtdE1HbFVVN0FZbjVEeWdnZHR3aTFPSU5NQUU2dGJWbElpWStGYVh4?=
 =?utf-8?B?Sm9ob3lrSldEbmEwNExZU1FRcFNtMllXQXR6UC9xVGVPYmwyQzZJVGV6UFRN?=
 =?utf-8?B?NnNDa1o5Nk1KZGIyeUVvZzdUeFo1bUJtMnVNOGt4MkpLR3RaZnJ3TTBubzhk?=
 =?utf-8?B?c1QyMno5b2hOS2Z5Vjd2YUpSdnYxY3drTDJ1bkJnM0pkSE9rTVkxWVR1SCsw?=
 =?utf-8?B?SmNGdlo4MVNqc2pnNVhZTlQrZmcrUXM0NnVSYU9seS96eTVlcDBjeWowekhK?=
 =?utf-8?B?WTllZG9ucnQzTVJtZHFSTWV6ZW5SR2drdnZibjJVY052Z0RjdG5GSDBtQWJy?=
 =?utf-8?B?Y3hUaG5zRWJwaEozYkpWc1JubS9VbktpWjM4U0hVZjBIZ1MyQ1Zwb3BnMmEy?=
 =?utf-8?B?bzNkVFd5SGE2MVYzWTVqTFlBSHlQYS9ES1NZSmVVcUpQWDFUd05Jckc4dld5?=
 =?utf-8?B?UzFtRFlNbmJCS3BFc1lvdDcrNFkrVmlTTTZEaUNxYjd2WVhtTWQ5SC9WZVJO?=
 =?utf-8?B?WjlZS1hnZDMzR1Vtb1BnVlN6TzhBeks4RWdlTVEyYjkvaVN0anU5MGs1N3A0?=
 =?utf-8?B?c2E5TE5sSUo1UXZQaVNRSGRCS1c2K1lmd09HYjZsQlR1MytaTGtBN3YraUZz?=
 =?utf-8?B?cSs3WFI4MktnYnhOVURHRW9kcXJHalhyUFM1akZxcTQvaHh0UnVnOFI0aVZk?=
 =?utf-8?B?aUlNWmxOWlJtOUg4WVRiZXFHbUdxMmpIb1oxT2F6bzdQYkhwNHVHbXpHZjZ2?=
 =?utf-8?B?ZW5sSXhYZy9VdVh2alNLZDB4NVJsWHowL2UxT0VsSVRKRXplZU94Zk0vclp2?=
 =?utf-8?B?WGhyd2ZMWTJLakNuTndidGNxblRYZjlNTWRsZHA4bDB1c0VqZVc1bDYyRFVP?=
 =?utf-8?B?bk0vVE1USWdvK205Z0Q5NmZoSmErUHEyZVlpbHVXVXYrbmF1YzhsQ3dhSVlF?=
 =?utf-8?B?M2xpK3ZmTjdIajQ3anptNFpya0g5Z2Q2OC9GZjNyZHRld0ZMNkluWFFYbFFX?=
 =?utf-8?Q?qEGrxj0EXeLAU=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 049e268d-b1d9-40b2-81fe-08d8b90b43d3
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jan 2021 04:08:50.8888
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Kq+VmkNvPHxO4917y2gwvSdg8lroZGPq65BlI13eJwERn07CJqs2Q/uHmBOkYP4ft4fSwgN5zb8U4wh18RemYPvVJlhgcu77hgGUPAQ+9SU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4568
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 suspectscore=0 spamscore=0
 mlxlogscore=999 malwarescore=0 bulkscore=0 mlxscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101150019
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9864 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 lowpriorityscore=0 bulkscore=0 priorityscore=1501 malwarescore=0
 clxscore=1015 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101150019
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 10 Jan 2021 19:45:34 +0300, Sergey Shtylyov wrote:

> Here are 3 patches against the 'for-next' branch of Martin Petersen's 'scsi.git' repo.
> I'm trying to clean up and improve the driver comments...
> 
> [1/3] aha1542: clarify 'struct ccb' comments
> [2/3] aha1542: kill trailing whitespace
> [3/3] aha1542: fix multi-line comment style

Applied to 5.12/scsi-queue, thanks!

[1/3] aha1542: clarify 'struct ccb' comments
      https://git.kernel.org/mkp/scsi/c/5637d5b769ab
[2/3] aha1542: kill trailing whitespace
      https://git.kernel.org/mkp/scsi/c/6075416cc412
[3/3] aha1542: fix multi-line comment style
      https://git.kernel.org/mkp/scsi/c/e4da5feb094c

-- 
Martin K. Petersen	Oracle Linux Engineering
