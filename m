Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50215C04FF3
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:56:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 25FD5613E6
	for <linux-scsi@archiver.kernel.org>; Fri, 21 May 2021 20:56:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhEUU53 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 May 2021 16:57:29 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:40280 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhEUU53 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 May 2021 16:57:29 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKePWi156518;
        Fri, 21 May 2021 20:55:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=XtYppn5hYcWk4oXiEoJYUYJKke3EzUj3nb5Tbpboxwo=;
 b=i9tVeH8aoskeV/hCybOo+S3n8WPnXBaFc2PnNqj9LhXg9kJsJCspW7psqWoeHFiy8LgU
 GT+pT4QgvdYUj/ANNpheytCFWIDddoWF9S5tsOIAtPY6/bYwKjV5jqp8919/lZUpx+nU
 fpp1626hxGFIuw4MvEPyTev2NOaHiEwAcNvgR7I5J24cNwZt+tUUsvOGnaOBgKhOBpNF
 pNACICslXEGAkflOEtedQKe4RALe7Kbfrxb55tEyF62tptOUY37O/RqOztcyWiZ0A5wj
 VQnFj8nxa0U15ZtkDcQtD1P5QS6vPwh2y2JquHiOg4UgSVhKb6CtBsd3rhhX0NUO9QA5 jg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 38j3tbrtvy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:55:55 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14LKecCu042223;
        Fri, 21 May 2021 20:55:54 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by userp3030.oracle.com with ESMTP id 38megnwdrk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 21 May 2021 20:55:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GTil/h9un9V2y5kXek6H1AO4wXmlLf1hl2NL+oWLeQgqsx10zaoXvUZjrVFnJ9r8vSg1hFP30AU3BoCH7e2IEJ4TLv/nTsnUxKtXhVOcXxuKJr40jpEoK6eBrlynznKc3Po6aSzLaECwdGLhMeTCfDKyUBKbUzCot4r70jr76WbUen4QxFQPkX1vtJqhgcDFqKoGh7Whdefpjt3TQTCX3ezf7HLZgSFBS+/0vk2Xze5nMUbG69Ms8XYy5vZTabUXv5crUn1QMyZOvJLthBwlPmI0InhySLVp9aLKFnW8njFLbl8pQRA0qPB72xGEcnPTvBM1Z1HT3l/02O6YqA4puQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtYppn5hYcWk4oXiEoJYUYJKke3EzUj3nb5Tbpboxwo=;
 b=ioCqcIcwVcO7euFAaxNmNlsML3AuoFXMuXVnmMBXG/F4dHbfEYnmTfTTMBSdJJxPiyZRm0gRoDEf/SMsPEC6jPdhm5F0NlW01ovPeSjegZviC4Ep1UdR9F1Lc6JnNpch7pa3vQ7v+OuI3mV4Ls1SknJ47NMoyzcSVuZhYIzD+kkuWdX4RNPe1Lw/fCbCgEutBXPmiLy+Ra1Onq2oTJPmY5mFQCR1G/y9WPhdzdAaOq/qgQcFWWf3atyE366LJeTwVUr8dxxOvIjqQ8G0Mkw+hgiUFQy3TLP5bBuV7dSr6XjKiv7tdAjsdWMfcwH561kUg5HFEuskVYdovn6JQ2NcHw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XtYppn5hYcWk4oXiEoJYUYJKke3EzUj3nb5Tbpboxwo=;
 b=ycVTrZToCiF6kRsd743NHD+QXfmEcA00SozwH5IaE0BxcTjNTWXK8E5EHhdCPgN9hjBMxxVt5in/rNGMcoXZ4iQXKtnyXgomuub3wgCYcfxXmNyp0K18kxbyi8QsTIyZYj59wJfyCPkT1YF+8XxNO4igCRUqWeQXlwjl6UB7hSk=
Authentication-Results: areca.com.tw; dkim=none (message not signed)
 header.d=none;areca.com.tw; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4790.namprd10.prod.outlook.com (2603:10b6:510:3f::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.28; Fri, 21 May
 2021 20:55:52 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Fri, 21 May 2021
 20:55:52 +0000
To:     ching Huang <ching2048@areca.com.tw>
Cc:     martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
        linux-scsi@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/2] scsi: arcmsr: fix doorbell status may arrived late
 on ARC-1886
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1y2c73iyb.fsf@ca-mkp.ca.oracle.com>
References: <61f706e52872255ba4a59613fd6a8b59678ff1e0.camel@areca.com.tw>
Date:   Fri, 21 May 2021 16:55:49 -0400
In-Reply-To: <61f706e52872255ba4a59613fd6a8b59678ff1e0.camel@areca.com.tw>
        (ching Huang's message of "Thu, 20 May 2021 14:48:55 +0800")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: BYAPR01CA0030.prod.exchangelabs.com (2603:10b6:a02:80::43)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by BYAPR01CA0030.prod.exchangelabs.com (2603:10b6:a02:80::43) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.26 via Frontend Transport; Fri, 21 May 2021 20:55:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: f5524773-8e03-4336-ec36-08d91c9ad1fe
X-MS-TrafficTypeDiagnostic: PH0PR10MB4790:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47907BB2EC75C8F9EB50EF348E299@PH0PR10MB4790.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ewdTsm+d/tiBhNtJ6YWPvAy7R7CT1P2L+dlhLloZeyDGW5kc1lpP+x/RY9AoMVjG0RrNrpfciTT0tmAWluQeVTzSVn/hc8+hflMa7nVK0LsExljqN5LV0sCEOTC31k8/v1Ije6nMpOHkPRzHGAnyMMFX+jhoUsnXptJO5P0/ZkX+NtBtWbTpodU446HOM5lsbv5P1a2xD+4S63Rv0Je85vox2L0xMyPls9zekmVQEOXS8MsGAQhGYHCBHgVpAbOFtdz35W7XspJ5OW/iZtFzDhzUEHXkPiO6dp5ha6HFPVB116h1nMKaqcad3gNR/llk+MKMe3fcLt/X9SvplcKObE55EFd78SzrWXxN9ELXdLbQ0hQ0l5WQXc7x8hORfclQjcdG3JEljZk38sfNdvTzfsfFVrogQ7Eziu0rbckoQ8kqpO62aGxqoVk4VE2oe0fN/mI1DRcRU8IS8eX+89/1nXsDaJgw6C/3aRrSSD23VQJHh/TPNVZdIeGG2tSpJK/VDebTPxf+aoxZEPN1iPheX2LXhIsVmjHfWPcbmYaQskFbyZKW1blU2TupGxn307w3CCiTxfgzMB8uvGex77UNp/VmVpl/zIJviG9G1CU6LnNF0dWURw9EiAeUaLuN2auHtMz5oU7ienmJAMIPT9f/IX+ZT/fnM8oyvRP72RCAfKU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(376002)(366004)(136003)(396003)(36916002)(6916009)(38100700002)(38350700002)(956004)(16526019)(186003)(86362001)(55016002)(478600001)(66556008)(8936002)(5660300002)(8676002)(6666004)(316002)(66946007)(2906002)(4326008)(52116002)(558084003)(26005)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?h/N62iQq20sx076yQvyh+zE/jeHZ4nKQhhFyk0464V33axaJMv8vk+faLQhJ?=
 =?us-ascii?Q?5BHJPC7rqcYhIo2I5LUFg3LPgg3Hbsr1d+5XtpkYYkA/9gNHmYPq5RRszkWP?=
 =?us-ascii?Q?Sx+tJQywl1KsBZ0XcbsDoCydkwUv1OH64K3qlQCKds2Sx4odA/OrsVB2jI4r?=
 =?us-ascii?Q?pDFSwC6AVknZ0a3LmyHIgl7EsI5NUul8krghwbW0vTYOXafzAhjv0hYpv9Yo?=
 =?us-ascii?Q?h7pqhrmfNq7tnKe66nGGo4NjrhvhgmuR1hn/K1K45Njuq/PUvyuxHWEE9iUY?=
 =?us-ascii?Q?Usy59GSkygLFFaYZF8jgg+gWnoaal3NyfvKBcMULo15xtWXoV4uIiQOJJ5Mr?=
 =?us-ascii?Q?/uQd9zjEPNGeMYQtosnovXYfPKzNa3WIJjGpMInUYdhL10CZBjiYBtXG9Rms?=
 =?us-ascii?Q?DypCBFDFk4cncn+pvnGbMVuTNesmdy11/h4/b4WQY5MKJLrmh2qSR2y6HbF5?=
 =?us-ascii?Q?irxT5tlaVbra58nl3je3C/+0kgFQo6Np74ysI9zjCpzxCxWqH7l7mJmIw6H1?=
 =?us-ascii?Q?2iLnh8IhYiI60qZocgQ6TyH+vzSFrHIbWmM2r6GI6Eg8WrPeCaovJ+YzoKPR?=
 =?us-ascii?Q?dT2EnoZ39T8lo6u1EYBj2SxIgc0keD7mnHuNWv+HTO+fJyCQBV6Mp0TZqGAP?=
 =?us-ascii?Q?S/6hZhigdInPTb37xd8HRF19EgVpt4RoJdUDQlvAA68Z2lPwHjIHl0rG0ex8?=
 =?us-ascii?Q?776n3vfslpQSLX03StckJ7O3khZ/9DuJMsAEWKFM+WiZ4Ldprl/rJF5j1n3X?=
 =?us-ascii?Q?fHRWLXeXYv56W5X7sexpEDkNDk0pBeoOVaTokG5XcOcM4GvT5Fha3mSbl/eQ?=
 =?us-ascii?Q?TRQ0LKNW5rPv1l5EitNxowPmTNvJoNkuH62OKOHnvafIEv8J0hXw2KBtKWbs?=
 =?us-ascii?Q?JE+0LKzufyyt/jbwizdlRyW5Wl9KLL2CoxmT+BDMn8fW7eiGtqZY2G3dGBA6?=
 =?us-ascii?Q?3JJjbWkuUxOs6DQygSlbVyqflyiJgEXMWy6Pgya/X4x6TcurlJQ0oYTEMdt8?=
 =?us-ascii?Q?OCqvbEZZH10cQASR21PQUQMED4kHMQQXPbr1JrKKeHo53KiwX2jKSPwn2qx1?=
 =?us-ascii?Q?K257qwqlI0bLD5KpMyTZ5dz0M8m5Ve9891d9MEnyeqm772kKMkB+A/waxSyW?=
 =?us-ascii?Q?eyOuF0QfJH/6dja8fkO+/uPF0LxrvA3CMikfqmQgpTV2xCQpO5yvpRmlPIRz?=
 =?us-ascii?Q?gOQqYjQdicUxPY0futblQ1GpA/i+b7HyocHkOMsjrTLs3mqMlqddSX/H8sIp?=
 =?us-ascii?Q?RP9sN2/J0+rqtzc73E/7aVetxhrIUlCvWjAfS4/KON2zh5yV+JSlq6qjP6Wx?=
 =?us-ascii?Q?tXZ1f3bkmo/EEOEKkmbheWR8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f5524773-8e03-4336-ec36-08d91c9ad1fe
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 May 2021 20:55:52.4496
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nIoJmLwfQr+T9tO3GENBIA7od5A4aKL+0Qx99mQLUFL/JU7oIIWqrSAnPqY4UuxZg3T/+XHk1PXl38ak/XfIFt+NZdcvH4qDjnBbnaqmskY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4790
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 adultscore=0 malwarescore=0 bulkscore=0 mlxscore=0 spamscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105210113
X-Proofpoint-ORIG-GUID: 01c59qhEjrV5OqL4c5YFHJuhqbHgdhEi
X-Proofpoint-GUID: 01c59qhEjrV5OqL4c5YFHJuhqbHgdhEi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 malwarescore=0
 spamscore=0 priorityscore=1501 suspectscore=0 mlxlogscore=999 mlxscore=0
 impostorscore=0 adultscore=0 clxscore=1015 phishscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105210113
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


ching,

> This patch fix the doorbell status coming from IOP may late.
> The doorbell status value should not be 0.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
