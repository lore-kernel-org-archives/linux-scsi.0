Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 487FBC43333
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 321DB65082
	for <linux-scsi@archiver.kernel.org>; Tue, 16 Mar 2021 03:16:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234773AbhCPDPv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 15 Mar 2021 23:15:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:39020 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234791AbhCPDPc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 15 Mar 2021 23:15:32 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AI3j074865;
        Tue, 16 Mar 2021 03:15:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=s2tELctQPaFYdrD1Q/WrxFY1IdHUK5ReQx5Ha5B8GGI=;
 b=L69ter8VnYMEoEFIzKP5ffixrD+z+37gVqKpMf04QvTvWm7+5jRF8Xm40oJ/WVJ11QrV
 nCmi7lbSO0kr7iwpJcY6En6+j5qt5Yit+g+Uk5wBrT7cK/ascam31ZgMe7c5eoARi2A5
 u6wwsYh3WWV8QUrB1oQxEY++YB1Jgz4frbbq1v8i/5tMAhIUnEeKIWOAdShYdAx9v6DK
 jz0px+nWJ8miShBUL2d/8mRwqHc55oyk/ozdVpuHEsSj3JH36LJEqyuUW4mWO0FywtQN
 wE8rxTL6TjVr6bkgzWpdvC3r4EbTSE7IqwX0yFUDt3YVW5PaIsnwDb7KlCM2fpqpZRGT tA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37a4ekk3a0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:24 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12G3AZMa193642;
        Tue, 16 Mar 2021 03:15:23 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 3796yswbhx-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 16 Mar 2021 03:15:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TcM26kU5LrwCikjltxJm4XCVYUtcylRl6HIQeXO4SmgV5sqI7l6xGKaPXHo0ScK0JttVVSnfVS08oov0ryUbtxwxhWKF6Cop33yYvqsLS67un9wELLbRj37GpcUU2s3G5/xtqr5eofp5+cGPQ/t40dPbdE1MEfGZkixKn7xV+3mqJa+/aVMDCUpDIH3GXizQ5QqTRsgSU7od9TK/O6FQLSbPCPM6Wy7wOrvJy19pxqGjKqvmq4/TADfC8wRrJP66UtIKDY+ir5Ljalq7z4Qg4dksbKHz7UIjIYfyfn6M4KVng1IlC+T3+JiQEPLzOoEOt52RuixKNCvgDjedjW55Dw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2tELctQPaFYdrD1Q/WrxFY1IdHUK5ReQx5Ha5B8GGI=;
 b=LqwoHr3oC6c8z2SoghENj2B71coMkgItcvWB5LDQ0dKTMc8nEgdXpctH/6Ee+11sZdp/Lw6DBSSrj7CYcxVcXM3PLdpsXBZ6Qvb1kBi/E/o+//kzANfFaB4rMnPitbmoATjm1V/sBDW9ydmFI+nnNLmZwl2AoaSOGrUUYLzxd4XkSrgaAW0g4/fyhFaZu4HPmklKIpWvvr20+ZgQD0jI/qJTJqzi6GKVHS+2AdgZ45aAKG/uZBTfGcAovyvc04lu4YV5b5tk5kvJo126JdAnYfAmfFqoAxZ6VpGp5ue6a3qYS2AY+5jh1SnMhOqDQDfYhcigiQLO69zatBweH6SFcg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=s2tELctQPaFYdrD1Q/WrxFY1IdHUK5ReQx5Ha5B8GGI=;
 b=nzMRRKQy6NIXrhOZjgMCSnfGGYoe4eArK56DVy/shcREvaWL9nboFr6GXWjKqHPoWHnpLjnY02GczPmI59JbcTffnTHRGNnqrJvNk3ffkGSuRlH5zQ8Esbs9HR3iXxaU1/E4Nviobizd0arrEVTfV18XLOOMUS2bXeXgsrYqFTQ=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4805.namprd10.prod.outlook.com (2603:10b6:510:3b::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32; Tue, 16 Mar
 2021 03:15:22 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3933.032; Tue, 16 Mar 2021
 03:15:22 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, khalid@gonehiking.org, zuoqilin1@163.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        zuoqilin <zuoqilin@yulong.com>
Subject: Re: [PATCH] scsi: FlashPoint: Fix typo issue
Date:   Mon, 15 Mar 2021 23:15:01 -0400
Message-Id: <161586054343.25014.4238350777923784502.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210304055120.2221-1-zuoqilin1@163.com>
References: <20210304055120.2221-1-zuoqilin1@163.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: CY4PR02CA0012.namprd02.prod.outlook.com
 (2603:10b6:903:18::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by CY4PR02CA0012.namprd02.prod.outlook.com (2603:10b6:903:18::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3933.32 via Frontend Transport; Tue, 16 Mar 2021 03:15:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 03d768f7-e885-41eb-b3eb-08d8e829bc2f
X-MS-TrafficTypeDiagnostic: PH0PR10MB4805:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4805E94EC858B9C626F57E6D8E6B9@PH0PR10MB4805.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2399;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: iJDo+q+rNe9oEkySnuhDpbGTH5ipkCH1gRkLxyJX9wbL9uBNHbW1TQ6mn55nsn3/XW7yRuGqpCeRgtqi4lUHNUiFczVhUc9Wv1UOIS9U0rhNEChHEsqhXCKQBXM+lCLRZdbprvRdWbFL+y20Vj6tjOHOLeBngp4LR0w3aQumQDD+jWGLmHsU9dmwYK3I+N0xZi/Kgd9VWKe9dULQqoZJcGIfh9wEdoY3ZSej7MzfK9d3UUN1YjGtzqsRWlZVV83A/2dPHu9bP0eBB4Y39ktt0SunwUd6E5ZUrkKScDlsnBKYHZ2hXZsVkAgK73ZZQ+ET0lKLPQCrvD+ka5fK9NSSqlyipYxwDV7DVaTZBeLO1QHzVwPIvdUECBk1S2gVLX90iAWwAgawEyokor6uoFYYiwotY2+0WmjSzF/86TX4PdIU1cuQel9ZtjbvR+i1p9rCpVmtJL06X7ywESHCkfXc5Q+WSWQXIPZbksLucmHpbN4XizrRgzIyUoj/y96hoBmoWueU7qxnXSSllTXVufCwHps3IpaX5RjSEHx3OwYjctbM0ehjQ8yOOS/4MKosoHU53rB5dhFN3d8AYW/F+Bdi0z2jL4gMPTEnHGE7LpBeaaDJi4Z5nQEQVJIpBj5vPmKUgWLEIgIQ0wb5pKz5QlJmpw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(346002)(136003)(396003)(2906002)(103116003)(4326008)(86362001)(5660300002)(36756003)(6666004)(558084003)(54906003)(6486002)(66476007)(2616005)(26005)(316002)(956004)(478600001)(66946007)(66556008)(186003)(966005)(7696005)(52116002)(8676002)(8936002)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?TFc2MWZTVXZ6eGVMOG1sZnA3R0FvTTE0c1ZocnZMSjVXQlJVUmtMQkc0dmMy?=
 =?utf-8?B?YmpiSE42Zm54SlNYNUJxWXEybG1vR3N2bmhIY0NGcXptUEkyMHpJTUF3QXlY?=
 =?utf-8?B?ZHRKTno1SGZKKzRIMEViY2FWUHpVU0dFdjVnSlhZdzNsRi9CdHVJVmVwcm80?=
 =?utf-8?B?NGlseldodnVndmxMaHpzYzlCclROQmNodHZTaVRLTXRzczlFU3loYTVsa1VM?=
 =?utf-8?B?bnlyd2RrdjkrdUZuTFhyU1ptTDVMQW9vaWR2SGl2UllEZHdQTWNacytsMU1I?=
 =?utf-8?B?U2cvcU12cjhxRVFFYjhBNlVLYkdsdGcyWUtvZ2t6cTJKdjZldllNZzJnTlBV?=
 =?utf-8?B?MHBzNTRzWmt5MXpnd05LSG9oaEFsZHR4TkdEczBZalFuV010S1U3eWFLeEN5?=
 =?utf-8?B?V1JCRW1yNG4wRWxyU2NPU3NBQ3liSGo1R3lJcWZWczRzaDM5a0NiZXNsRnpP?=
 =?utf-8?B?QUJhVzA3LzM4Q2l1Y3BpRHpNOHBxUEdLZ21UdWZxMGs4NTZjeXZyWTIvbElS?=
 =?utf-8?B?UE1mZlFQcHhSQnFJdXRKUDdmMEdLeEErajZmYmk3VS93c20yMWE0bDA3NHV4?=
 =?utf-8?B?QzJRSHRMV3ppeW0zNnhmVWdWU0s1UWxzMGcyY1ZXNU1HNDZSWnlKUy9kNFdF?=
 =?utf-8?B?c1ltNVVIUHEycHFxb3hvVnZXbm92ekNpVmZQR05qQTg5dGlmUEFMelc4SGhs?=
 =?utf-8?B?Z1lXZGlGaGtPQ1hMRXByd2l5aHgwSERkNWlNUERzRjMvUWlTMzF1b2VkMjk4?=
 =?utf-8?B?aVY2bTRMK0VqRVVpblArdHMzK2YxYmFjcWU1eEdvYW5SbU9ES3RkTXdRa3Fy?=
 =?utf-8?B?VWVHKytlT3JNRk11akViYUpSMlVaTDlhQmtHTDFCS1ZOSmkzYWVkQ2RTLzdk?=
 =?utf-8?B?dW1zQU1EcEQ4Rm8xN3BUck1oT2pkRGFQYmZ1OVNUL1ZUQjJEREdtYk9BeDBl?=
 =?utf-8?B?Q2RQNk91VU1QYngzNDhRSHRydjh2YzV4a09KVFI2OExQMHRyU3hrUjJMSmpE?=
 =?utf-8?B?aXFVQTBhbm5mUDBxdDN1U3d2THFMRHZxMDI0NENvUUFnS2NaS0crNVF6eEZr?=
 =?utf-8?B?dnArcjMzTmdoN3Z5N1FwZmY5M2hXWk9WV2IybmwyeFFNSlpYYy9NaGNFblc5?=
 =?utf-8?B?cHMraDJkSHR4cVlmb1lHWno3WTNvYWFxcXRscGg3YVJrQXVWSlNYZzY5TWJp?=
 =?utf-8?B?NkhwUnlOTEdtSE5DMkdLTU0ySDMzdy9DLzlqRTlCYlluUHQ5TDMvSkpDYUty?=
 =?utf-8?B?N0RZWk1vUTdLS0N3VmJpQVVPekNGRWdZQ0VWanVJY0prT1VteWNROHdKNDBB?=
 =?utf-8?B?MEtCaFJkNmo0Z253b283eWloTXBsUjZ0WlErbVpLMjNMbk1kanpkQ3VUbnlW?=
 =?utf-8?B?K1RUc0IvU1I5dGI5OEJFNTJWcGRxalYyVVlGT1FtN2ZoUlRxZmE2U1JKNFdO?=
 =?utf-8?B?VjBoV2VpWWVKd3lhTGFMT042M0tCRjN6QkZYSWlPdXd2Yk5SRHJoOXlrVUwv?=
 =?utf-8?B?S0dDOWpRTG5CcmhrMk5tUTFjTVkrcWhINyt6aUdrZVdtdUtMR09QbUxta3JH?=
 =?utf-8?B?dWpXKzk4bTZEL0owQkRYc1dkaVhMSHZyR2N1dmJRZng1ZDVCSnRUc2hBaUNl?=
 =?utf-8?B?U0QvTHRxdW45MDZFU2xwcUZ4d0RrT3BUWjJhWEZ4Y09VUHUrNXo3SWk4SmVB?=
 =?utf-8?B?YkduSDlsaTNiTy9pcTJCc1JoWUtsZFk4ZTdsNlgwRjFEUFFmWHRyQVgyU1Nr?=
 =?utf-8?Q?DwNmJ2JVX99LOm93eyym1UN7ejGTiqtJNbvwJ6k?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 03d768f7-e885-41eb-b3eb-08d8e829bc2f
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Mar 2021 03:15:22.3601
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IRNp5Y64n8OAveBnNNzTMSa3MLvoMVZLANW6zh1YBBSQuxlwMyURex2rVK0LUheK7GSNIwz/oJxiQACKSo/6hlL3kIibRwEhnUrPCiDqcE4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4805
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9924 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 bulkscore=0
 impostorscore=0 lowpriorityscore=0 mlxlogscore=999 spamscore=0
 priorityscore=1501 adultscore=0 phishscore=0 suspectscore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103160021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 4 Mar 2021 13:51:20 +0800, zuoqilin1@163.com wrote:

> Change 'defualt' to 'default'.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: FlashPoint: Fix typo issue
      https://git.kernel.org/mkp/scsi/c/083d248b2d44

-- 
Martin K. Petersen	Oracle Linux Engineering
