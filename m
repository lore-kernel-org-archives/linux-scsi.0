Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B6944C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:34:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99EEE6113E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Sep 2021 03:34:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbhIODfr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Sep 2021 23:35:47 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12182 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229980AbhIODfk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Sep 2021 23:35:40 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18F2n4cl032058;
        Wed, 15 Sep 2021 03:34:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=chw92vNCKFBQ1nuWi5AcdTFCxQPY9XKt1MumdqVbZYo=;
 b=P+22T1wDtMqgpG8ACPsSHLqYP4Y2rk4rysaxDYzlKKfX830tmOCyISEfEmNb+e2VVDk2
 rOS5zaVv3FvZWkfHowsnd0e/aDS3WQ9sZClkXF/HiFcYVenMfsvjvTIVTectuGPe8wXa
 mf07dKDVtEUdc2d+gKnEn8SvZ5phGMorLxGHcVBhPPbW5vTRlhL7c3JpI0F8a7roYc7U
 mbgiYLcLwqxP/3OxACrVelPp7OyG1y2aU2X0zSzZmVFfIlX+ngsk3ZTLwp6aXA9BLhOk
 LMIQKKIbKLl4bbBpWDKsOTPp0xEk0QU2OSrTUXfITGgES1oQanwvqPaHMz+vLXEAaC9h pA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=chw92vNCKFBQ1nuWi5AcdTFCxQPY9XKt1MumdqVbZYo=;
 b=ZpR3IdUiL7SaL4QjSnAl3am3pRXr9HMutdzeLltAkq10UTcH6jW2sRjheeN7NzCX1kZ2
 x+GW6n6GaBpjfpKIrDJ8Si5s6kSj83wj7frMFSfzjzCdg2gp4WdvmsJzY/jOrY3xamOl
 r/q7YVWHDJsDXM9Zjj9cCoiEvlHGYS3GZc5ItFlcbAP58A0Hbj0B7/9STliMjB7vwWbR
 xCnMHqu/+OLyo40Sh2vcTJ6j14fwIvc9UA/A4DrQENGEKPo5q4VTjgI6eT7IZPvN29wQ
 Li6ww4P48OoRi6PbY7udVzOSJ2cyOB6PeMEdKfa1GSh6jzrXsutZSgVWlhTsbye5U7Ng vA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b2p3mkhx7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:34:13 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18F3VYWh161759;
        Wed, 15 Sep 2021 03:34:12 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 3b167t0av3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 15 Sep 2021 03:34:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=azYCYkbaxbaZyZrstTy3trmCmpjxaGoZDn7K3yMPumIUYeynQUifJZ+CvbhJ4ZV20sozijmFc2cEny2ZmZTSMlc3OyQYFaJaV5NUWvXawwnzlYhgbO3KGb+3VOwXcBPZl2Wl/mnqiFRyzG9g0CJKMzDU1LxrxeHpwwxSTpZTJWvaCxeXpMeASMoTeNLXeUDwFsCWCEHpZUbRR8r0su3tTRTjZd30qh2K/P3Ha5gUt9ovZkkMNeMnZt6kg+m6zeCFdQv0TM0MxSZ+C3giMFLWVS/q2iURQV/SxUMfbZYDzW0LGg+GhSBUoxy+wPPPM0SOIHoxY9Q+qZ/XJ2IB5iSYaw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=chw92vNCKFBQ1nuWi5AcdTFCxQPY9XKt1MumdqVbZYo=;
 b=nysBsPlBHlVdYcVfsigCJ30t/2jFn5dPTPnXWJMEbD+aG/UkA596a3HBO9dgZNhQaFKuTHuV/FvjJ4Gkct+8eOsNQB5WvN/X47Gna7vaSUQmIl/X16CKKSO8XLhhzc3U2DIqml+JKqpkJpGX1N0Nr/0WeZOcOMMkM/8zZsqT/SQnZVHk/wPTgiE2NzufZftYPkFMRHvdA1Y2P2zNaZZVAzcDhoKMn3zy3yGIoqQWbHONfvOz4ObV8iYZARJPofzH27uwkBjJMipG6yRY0COjXVI7oVMtkzEZn33CyjrirBj94DlXEU1Z7mzf4Qrj+g/sTr2+H9mhG5sSMeHsFRQraA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=chw92vNCKFBQ1nuWi5AcdTFCxQPY9XKt1MumdqVbZYo=;
 b=flED3Mu6vUaf9xDUDQaoMmoabtGiKKw8+n1N1JAiyGzxWP3UOIxWQHEm/T4xye4SAiLR5xL/KVrhkAiDFJwzGYpgyxPtEDQ37yk+m6flrqBcU/d+YKwC0l3DV7C+tMG52ECBKzZU1pgTjsUc5cSf557VQF5vWdwBxp/KTqSbFdg=
Authentication-Results: mediatek.com; dkim=none (message not signed)
 header.d=none;mediatek.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4439.namprd10.prod.outlook.com (2603:10b6:510:41::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.16; Wed, 15 Sep
 2021 03:34:10 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4500.019; Wed, 15 Sep 2021
 03:34:10 +0000
To:     <peter.wang@mediatek.com>
Cc:     <stanley.chu@mediatek.com>, <linux-scsi@vger.kernel.org>,
        <martin.petersen@oracle.com>, <avri.altman@wdc.com>,
        <alim.akhtar@samsung.com>, <jejb@linux.ibm.com>,
        <wsd_upstream@mediatek.com>, <linux-mediatek@lists.infradead.org>,
        <chun-hung.wu@mediatek.com>, <alice.chao@mediatek.com>,
        <cc.chou@mediatek.com>, <chaotian.jing@mediatek.com>,
        <jiajie.hao@mediatek.com>, <powen.kao@mediatek.com>,
        <jonathan.hsu@mediatek.com>, <qilin.tan@mediatek.com>,
        <lin.gui@mediatek.com>
Subject: Re: [PATCH v5] scsi: ufs: ufs-mediatek: Change dbg select by check
 IP version
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1v932v7fl.fsf@ca-mkp.ca.oracle.com>
References: <1630918387-8333-1-git-send-email-peter.wang@mediatek.com>
Date:   Tue, 14 Sep 2021 23:34:08 -0400
In-Reply-To: <1630918387-8333-1-git-send-email-peter.wang@mediatek.com> (peter
        wang's message of "Mon, 6 Sep 2021 16:53:07 +0800")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR11CA0150.namprd11.prod.outlook.com
 (2603:10b6:806:131::35) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.ca.oracle.com (138.3.201.50) by SA0PR11CA0150.namprd11.prod.outlook.com (2603:10b6:806:131::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 15 Sep 2021 03:34:09 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 20885d1d-b2bd-4019-e869-08d977f9adf2
X-MS-TrafficTypeDiagnostic: PH0PR10MB4439:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB44393410126384578846F8288EDB9@PH0PR10MB4439.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4303;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hsUk9cYeWvtdEuPls0GHpqJbU2YR9hWDR9JwGFzX/UkXjZzZ7DMKIz6+QL4roAtGbYEmZ/yYeULudEI0Ql6BVwa/wHiqzLEWqxntsdfO9rTo1xt4M4jNHaB5QsyWkqnLDYlvt+nZWAq+kRawA6cZd6u3wSR9ZHpF8icmQnQZ81/yospKe2R9r0RGKu7fNFCLF5KP1iYJcISeNpM8lFBfZ4hHbWz221HAvpKJZ3sYnyjVrtIh2mFLYz7+ZeRLdXjqEESO73kdHv0nb7yge0Di0/qqNg2lKAUf5fYmIXcG1VqBQ/pXJWHmKIJ8cQS2r2eKMKUhRjEdA0+slCwFTIVuhRH+tb/KK1/YnvWLwNhnA1sw5xSGE6Ox0sNok/uquvzUBOjBo+4P7m6bhnoz8kTklJTVRab4wUz8NZ9gyK9rxTkaU0Vi02UtREqpYIV4WThDDlpQGS+7yIOVhfB8eLw08lEAfVlE7O2SybgmdgsNdcfinNrQmHhl/8YzgaMhJwXoQorXcfXhjKssKVahV4M4MmtDGdXOXo7kB9ZCezG2m+qAYt3P1cTd8JK2WST0jakcmZ72zOakk+1mKQBbqKgGm117c/p9EalVQG55m+leXUoAw9ExXiu5kubjZ7v7gE78upOVgyVL2d4uynYBi3WRTs90OFIkt2t2uRM+n56LQaeE07mP6XO+S5aeyCGvygBHIWewOpvj+ph8lwovhW8ZQg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(396003)(346002)(39860400002)(136003)(38350700002)(38100700002)(4326008)(8676002)(26005)(36916002)(86362001)(7696005)(6916009)(2906002)(54906003)(66946007)(316002)(478600001)(55016002)(5660300002)(8936002)(558084003)(186003)(956004)(66556008)(66476007)(52116002)(7416002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?miPk8Bl/6g1WbnYgB4eMZ54lPCNXl7gUlRnv2nXTYuSROx90TaUA0ZRAbc2X?=
 =?us-ascii?Q?yMLUCrAR85GmiFo9AS67WKjFT9hvx60cUp3/P29Q4HtpV433dsdi/f+2dHgQ?=
 =?us-ascii?Q?COPH4R0xy4MXG3neT7XZ2LQvOZaUXkHgsv4wzoIUezz+HyYTTmYSCcKiBzJx?=
 =?us-ascii?Q?MqvY8QlwgPfRUBvtCrmgNT5iH+SZINw6IxPcN+7ctmlyECmJdOC9325JRtpp?=
 =?us-ascii?Q?pr542oivwalaChiUh07W+ysRHmkjSm2/lvU6dgRZJkIJ3xjpAHlMLGHIlwUw?=
 =?us-ascii?Q?adzUtXPnQ2dDuiE/V//H3+UooEUX11uR/sgiMwmdQAMo5SFTczrbpl6RJEox?=
 =?us-ascii?Q?HChpchq+vWREkc9JjlqHZ6wfijkFXq5Ol2iTKhCMhtiLCQzSJXtKssfY725I?=
 =?us-ascii?Q?j7c50d/QqPQY2I6KMFH00CmkDYCWtjkeXNwNlzNUvZDxm8d63WlYMzlKvQfH?=
 =?us-ascii?Q?nPq6zlbHi1o0kj8gmgmbbvLMEF610SFLoTAFSuPzF16yAL+ze9hz/0IASj4w?=
 =?us-ascii?Q?R8VVoF07gH3L4jdtj4EqG6x5hThLmfPbILWadrRfcDMwC/Z4LuqTx/z4jlCb?=
 =?us-ascii?Q?hJiKHwVZrM7FxOA8tbjCOJ9gq94w/gbDbI81w61WuJFLhAHyvSONZD1qLjk3?=
 =?us-ascii?Q?6j3XtDr6poiAmldZvttG+wyOzD4d23Bbthy2VkdlWdGAuH3AmO3r/tJh77tv?=
 =?us-ascii?Q?9xZMTcFIPtF9MB/CgyybwaD7yVFGWg5pWIz+qBkTKm83iyTrmEjoe8xnHRiN?=
 =?us-ascii?Q?2eGfcUhD4qFEfhMY8R23mPdblXww8Nu2/MB5d6Jts3vhwmCEIw7dcGb6h00w?=
 =?us-ascii?Q?nA+R8EG6aIT0cfSbP0BTptfbcY3vhc78tbdit68m71HTSZmPAvsyaWZ5TpOY?=
 =?us-ascii?Q?sA0tOs6zrlqvwDp0YaNizSqrxqei6S7MnRXRkTRoIlOM5sm8lEky17JcNdl9?=
 =?us-ascii?Q?3m2PgAgmISTPpqUHHDhIWocD2sZveFfDXySWXYLhAVwOCB2MwOTb4igSJpX+?=
 =?us-ascii?Q?C/BixdL6BRsDAyygMWYfcV9+BfwFDs93epdwaxQ3G53On3njzBhyIkbAy/EG?=
 =?us-ascii?Q?+sy3y8CMsPCpQRkbQ+74QVbMcN63o9k0PajWUqkgTLaWRGXn95nBEx8B94Jj?=
 =?us-ascii?Q?VETmnqUOaIhvMChaXAhgLelKJ0PCFENzz0SCeZN3cCg/QjJNlT0KjqlnD+EZ?=
 =?us-ascii?Q?5wAoL9SNE9bd5R9Wxvm0EOZiB26iHD74q7Xxs4aSLacCASSc7wL6Dn0eBh3a?=
 =?us-ascii?Q?D7qZjO+M+cuemUxDzuve2fyYVuoqVgzhr6r4sHoyRUbTtKoeAQV8kUz43bFV?=
 =?us-ascii?Q?aDXayJn4bovF7KCNsxuA+2g7?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 20885d1d-b2bd-4019-e869-08d977f9adf2
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Sep 2021 03:34:09.9581
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 23l/hKkE6TVscy/HgAzNA57TEqT8b/1Wnf1/njD7O9RQQoSB4KLdh7o/g/BN4mzjqbJbcHlYA/vFvpHvO1jdj9hcGrTV8v9U43xqQgahJdE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4439
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10107 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 malwarescore=0 mlxscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2109030001
 definitions=main-2109150020
X-Proofpoint-GUID: TC4WoZ7NLQ4wbUm-90f5TfEpuzPCeG0x
X-Proofpoint-ORIG-GUID: TC4WoZ7NLQ4wbUm-90f5TfEpuzPCeG0x
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Peter,

> Mediatek UFS dbg select setting is changed in new IP version.  This
> patch check the IP version before set dbg select.

Applied to 5.16/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
