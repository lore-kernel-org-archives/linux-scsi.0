Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CEC6C2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0D40560E08
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:41:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbhEVEnO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:14 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45952 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231334AbhEVEnN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:43:13 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4aWIq004809;
        Sat, 22 May 2021 04:41:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=Nz1UmYeJ1+gKMUMXxRqm4Eu8ZXgUMeqZTFyywFvdqbE=;
 b=TuI3Lf81e3pA40eMJunfmjIJ8F8jVwBuOinbNzkBbGG9GTIk00DT5OG6aKxYMaCc8uFG
 K8ddtmtdkUe27QRPC9TBN3GyoZw4iIB9i30aSd3h4E//hvWVL1YBVS2xnrLQZCjLhASf
 ZxCyucqDVY7m8pbNkkC0MPBFPynKBwlH7YQGp3cnCISDgNbsEVY1FXU9AWmBgun/Hq9T
 uK6p6fZtTUwxZ9iiryAYtCLTXO7SJrHaa4wZY/si75kFGruKCQIZQWupgIoAiUfFG33z
 emo9qlZAmTglbF3BFp8RIin0OQ9ixz3bL0zHkRZ8Z06rFg1EnlkqM1gbJ5plVavs3oph CQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38ptkp00j2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Zjij168565;
        Sat, 22 May 2021 04:41:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 38ps9j33ty-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hzeYpUGrdcSGKvQZ3ZWEWcirK6W/1655/n5DHZZPGJSl4cnytsYFi6n9E5907W1XtjQo1wylE6NqKPA1FMLPLF+9UA4+FaV8N1KLaaQgq7qI+p0jXwnocNFkNTOaSy++FJtZP0eXxpu6CxS0XNEW20hdlOVQKqjcsG6zxMPQN1buw2EOP9IlgcMapHBpz+hVFWx4GOYywzz/EAwOdqozaydx9BueeoGuZi6delKtDDYozdov8cKulL4C9DqbHM7W0j/6311suNgaWA4+KYRpvoeYQH6qhy8mv6171eNGfNCT6Bq9Bv3BQKq+ZFe5RFcyb1yncKq/TDi119rd7Sn7SA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nz1UmYeJ1+gKMUMXxRqm4Eu8ZXgUMeqZTFyywFvdqbE=;
 b=B4QWT/40KZhQtgI/ILdU2yPmI2+LnC7sS62A/3sVwQg3EDR5I9ZIWdBVhY23b2DXUIhPfxGL4e98ZQgGFaUOJaFPlZhL2bb0Y4vrxdWQDVKEGV56FcpIYuRzXRPh9WfG4uWT3IHrO2mYchd5RQrvIw0ZBd00iRhzEMQSLR5PFEb4Rh584srfVrB3zbcD0g2DGKxJUXsYsqck+hGIvUyG8YE1t0zwsnE5fkRCU18g87mH46noejboxi7kY5uzkeafFjpFGDOAa+Mw0kttIpPqJIoHwIwqX1ARx6Hyug6WOMFO/qGzVBtmlSVaFY8ATPRbwX4YOUZtKTV+s8k1aEPRoQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Nz1UmYeJ1+gKMUMXxRqm4Eu8ZXgUMeqZTFyywFvdqbE=;
 b=kIOXaIX1lKSHiqeCzV989lGEhgO9++9X86ViXD6ou6Icjl3UPW3LsnGTnVtdJvCJ+FcWlIT1O0+ohzO/4h1pO7QXZxsMi48r2gUVuIBP9uucVwg7LmUHWA3Vo8IGG2BCAr/Pu8kQJVOtZJ/5XoU/5dPbHHYXqDy7wFSr5sBr59Q=
Authentication-Results: wanadoo.fr; dkim=none (message not signed)
 header.d=none;wanadoo.fr; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:41:40 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:40 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
        anil.gurumurthy@qlogic.com, sudarsana.kalluru@qlogic.com,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] scsi: bfa: Remove some unused variables
Date:   Sat, 22 May 2021 00:41:31 -0400
Message-Id: <162165846771.5888.9369352223082544923.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <d10ccee35e35bf33d651f2e0163034d7c451520b.1618944442.git.christophe.jaillet@wanadoo.fr>
References: <d10ccee35e35bf33d651f2e0163034d7c451520b.1618944442.git.christophe.jaillet@wanadoo.fr>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:39 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1408b7c5-fd1d-4cc1-affa-08d91cdbe42d
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5481527CB3573C27FB8E47B28E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3044;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: B3rGL56R5AKh2mKPW7VfxASJHxaxdNuc6PDDkvp/JZdZToDEIGlAj/qq5N0QGJRwX8H2eZPXiUKSbQn4KoC7lycxk5mTyz2k+iINM3AG7VMyVoezJQY6HvRLkYp7JSdZcBMMSIlzOCrKn9Og7jpYFnPrW+rHwa13JNaNBSHLuf5oDH2uGuzKQULSUsGM1lpgjKAnKDaOx/7X7T1V7JTfs9j/GaBQSH27z67UYi2tYZh35Nf7OBGpYpzJ3BPAqX3ttNrkBJv/LtvIxLmAKONRV9gYNsi6ql1b6d2zsLTng4mMJXUvJiThB6bh2eO5y/8GDFWsjrcjgrzRlf/jpR9UIyRxLTP3sg7Q9T/9WD+qqpPqmBHEd2qObPtR+Bv2rCim0NhKR+appyjSH4hpdp2xjOT8pN2HUQ9QtCNNGaF5peuiT5hC4TFTc2IJiXAEeuEYQhv/HOb2R+kMU/A4WC0mFUdypjMn3+LednULN9is+vbidoAa2WjKpUYXYzYJxOmjiGOevckeMfyUTO7n8dh7aprHHWTHb7q3wHSHawYS6qyV6zVwwXRc+af38nT1fjaf76ZWfTNWVAbbqCYlJ8Apd+o4FeekzOiJnmHy4Ai0OH+13jI99PBW3kXqRxoZfVJSAUHXnF5CzDAlpEUQGI7yXGEscs9MLpEpW3Uu2usniZRkfMJpJLebKuQJsu2MlE9ELWVKvdv35opTOiTsIKd4PrPOxdQQi2Y75A9Pd6q7VaHFv1VPj5wwspOjqSDvZn3G+UiJ/UB8Ofuah0KHeRlhmg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?L3NDZit0eDI2RWkyZWtKZDN6eEJVT1ZaU2ZVTTI5VFB5My8rRndLV052SjBQ?=
 =?utf-8?B?TnBmRUpHS1hEVWZIQzFFOXhkZjhlMEJUY0N6ektiQ0hRV1YrQkFTSGE0NFky?=
 =?utf-8?B?L2F6cktSOUtOTWZZcmdpb2xpTGFKdldJUzRXNWIvQmxKbXpFd3RXLzVDN1px?=
 =?utf-8?B?Y3QzdXlCODBpM2s2aGRWdmNtci9qbWtFNDBZeGlqcjhqUmVWYUlCS1ZVVEFz?=
 =?utf-8?B?bWYrNHdMT1VtSnpSakVkVnlBNXlIdUFycndGbTFWWlJIZjJIalk1SU1peEFa?=
 =?utf-8?B?dTRjZ29mRWMrQWpTYjNxWEkxQ05iODB5ZVhlVGlDa2haU0JlTmZDTDhBOEEv?=
 =?utf-8?B?bjdsL0lZMFlkWUlmeFdPcC9QV3ljVzlHRFJPNzlveC9WLzhPclhYTHpLS09q?=
 =?utf-8?B?S1ZJS2syT0Fod250STlTYTkwa0llYSt6bFJZcmlKOXhzQTB4VDc3b2k1ZTFJ?=
 =?utf-8?B?dzQyc2pkcUwyWkFxcmNtdGdkbnU5Y1Q5UjM2ZzEvM2NtZTVrbDNTdjdSaXMy?=
 =?utf-8?B?ZDFUUXd5c2NwSUY5b3hIa1VDM2hWa1RtaEY4eDczWlFMU2pZVHpSMmgwUkRU?=
 =?utf-8?B?Q0E2OXltQmFCL2RZaUlwL3k0QUVZQXZNZVBQQjAxcDAvNVNpZzNLTTdpMWdJ?=
 =?utf-8?B?ZkgxcGxlY1gwQkxDK25Rd05XSFROOWNTK3ZEc0pOUXpRajJuZ09wRVVub3lK?=
 =?utf-8?B?SDBNcGV1NmRIcDg0MTRtckFTQVF5akhTM3dRMm5Wc0VhNDdJdWkzQURRV1Nk?=
 =?utf-8?B?L2tzYWF2VGhyYTBVdmdkay83REx4T2NpcVVZVUFsMHlIdkhzVXlaY29IYmdQ?=
 =?utf-8?B?QldDbVMvQ25YbkdRdDdvOEJRemxwN2FrU1ptUWdhdWNzK25YQTE2Qkh5MTk2?=
 =?utf-8?B?U2VSa2pUN1NFMDYxZHU1cWxrZVhrZjM1NTRyazlzOHV4L3lDd2FGQUV5Sys1?=
 =?utf-8?B?am9KdXk4QXByOWYySWdoSFlBQjRvNldJdUV1RmVQYVZRc2l5ZlJFZkFEU3ZR?=
 =?utf-8?B?cFV2b3B2UnB2WDY2UkVxTklNdUZWMHZ3cEpWS20zVmdRd1RoZjllMHVCQmNG?=
 =?utf-8?B?UzhCQ1E5U0ppVkxiaU0wVGpjTGtDUWZyazEwcmlLT3Y2R2VEL245ZG9jRnAz?=
 =?utf-8?B?UzZCZUhpWTZIMXExZ0hMUUFHWkRJOWI3aWNhbW04cEkzci96UFdIYXZrNG1E?=
 =?utf-8?B?QmtXSXpyUStVOGswL2F2OUdGUDM0b2dvWDVqbjhIeURDZkhPc21hNnpicHgx?=
 =?utf-8?B?SkJQVkJHZ3FVcjk1Q01NVlBPVFBVaHlCZmw0OWFsWWJmZ0VFYVNnNFlKbTNW?=
 =?utf-8?B?dEtRd2hPMUdTcDRDbGNxeElYaEdvejAwdEVucDVXdmIvK0xwTStqWnRtZXV6?=
 =?utf-8?B?RWp4MFpWUFJlRXpCT3ozc0Z1VENQZFBablJMaEw4SnFWTG5TYnNGNzJSREJP?=
 =?utf-8?B?L1hFQXNZNks3K2J6S3YrOFg0RUhpWXhlL0JmRlJCU24zejlGNkJhblpjemdi?=
 =?utf-8?B?YmpudVJpb2o1aFJ4Z0w1bk5sTFpOMFFmZGdhZ2s1dGN1ZGN1VlBPYU40NTlW?=
 =?utf-8?B?RThQWTFxQVIzWnRadFBrMVV3eGtaVEY3WHp5d0VHb2FEQVphanJTSjd2WWFq?=
 =?utf-8?B?T2xXbGwrZWwxWFZPdXUxdE9kV29HNTgzdlI2YnN2YW5oV0RUNlg5Q3p5NFlB?=
 =?utf-8?B?ZVQ2RWxYbHZWQXNpcUFkcThXUU9vR2taT2htb0FyNkJnazFsMFFjRFdxbHEw?=
 =?utf-8?Q?vVL1VmKT2yxCDr+ZVH6MjALMQ2EXkEmrm5O/w/b?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1408b7c5-fd1d-4cc1-affa-08d91cdbe42d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:40.3122
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sunsFqNHzHBio8cRPCM38L1IBtjn7MMb4b1tMLdgnyaDtXAv36NqZ6Tx7givOPwfaCS0vhiVNje3HtBlFRQXFwC5U7D/Ox6v58jYye8Je5o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: 2V9FZDThNaHJRNP8pyaoocq4d5Bsf9_O
X-Proofpoint-ORIG-GUID: 2V9FZDThNaHJRNP8pyaoocq4d5Bsf9_O
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 suspectscore=0 bulkscore=0 adultscore=0 mlxlogscore=999 phishscore=0
 malwarescore=0 clxscore=1015 lowpriorityscore=0 spamscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 20 Apr 2021 20:48:41 +0200, Christophe JAILLET wrote:

> 'lp' is unused. It is just declared and memset'ed.
> It can be removed.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: bfa: Remove some unused variables
      https://git.kernel.org/mkp/scsi/c/4803bd066cb9

-- 
Martin K. Petersen	Oracle Linux Engineering
