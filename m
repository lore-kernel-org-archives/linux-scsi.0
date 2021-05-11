Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 30588C43462
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 152566161C
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:26:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbhEKD1I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:27:08 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:41698 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230295AbhEKD1C (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 May 2021 23:27:02 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3Ehub073688;
        Tue, 11 May 2021 03:25:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AstDQsD6yzTPhzT3zsbp9hvx75/Zdanc1Cwpt+hD2Io=;
 b=RGbBwgcdwaim0NDojs4kWWf0raHykloh9vPTlIy1XF1vFa25oH1ODqvt9XIQY2nSPoFA
 t/88r6qkQZpG7Jhro84f1AduwXtHWCBaVTxZBLg/bsFpVUbrHQsgEroI9QM/zDZgV7Jr
 /mKj2CRpM7nJeYtiKRdokaSN8JUCBcHRG//PyGnlgvzkI95WWdIib1dGxhlRe5pH+xyQ
 596iHf1lWNbsGcAwfN4snYkK/71IcQl4Rs0IMVc8iLDmWECLb5BKeA1FWipiyFGJSrQl
 kScbo6TAf9Xx2fedCHEJqY6zwZOUBSK6GZ8ShYcVV8HBDLvmhAlG7bvnwInMrRn70U9r pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38djkmd7vn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:52 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14B3FvE9152680;
        Tue, 11 May 2021 03:25:51 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by userp3020.oracle.com with ESMTP id 38fh3w1u2k-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 May 2021 03:25:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IQ9CgpEg4Y1fyLO1GhWARlcVQG3qDR8nTub4IO0+DuQvBGJeQ7meXIdRm0lrORjB5zu0b5Lb+Ts6TtLja4wirE/ta5sCrD/rE4tqvqhsnbQSKDh39S9DwVu8S9HHaIm6lqgB6MlVOutZ/ITEatNJRdQZiCS4lGs+7groHY2wMsVdsA4dnhtOD+a4yOseXfmtoCtedcodA3z6/jJxnlF5TvtO4vk29rn1EiUp5Jnu1coZAvrkMkJwcVHE99gjElsMdQOBEOIsOOqryarJwId3bjFLYiMRtGpwphG8rippVd2FVo1xEmBDsnQ5UckqL2Gdj/FWMLBYnI6pZJHbGL+RGA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AstDQsD6yzTPhzT3zsbp9hvx75/Zdanc1Cwpt+hD2Io=;
 b=P6EudFL/sIKootz4g9Ht5R0bgvlbNmDRC68GW+gxwTT7cRXFmC8dQBeD28MQKJ2grlFnkKmY082lDk1ptL0EsFZ4CX/IVCwtx9UoJEirbEIpaehPu2cR6z8X1gN43iFl4HcOsiUzNdcQ1l+20khbhexYOVqe3dixDow2r3UD3xG1+/r+uthxpXZC3MEjQX+/LVm7Odz4390R5/gEggHKPiFl7hdcRYtY5tCZC0+jFg2wYfenlTDevImhpDBXngZu8Yn0yVmXhHS0/Y2e8ouS3JHCYIgIt5TbydxOiR8UAUagHAybipX6wAkIdeHva2PNefCC5AieJUocnwO8Et2p8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AstDQsD6yzTPhzT3zsbp9hvx75/Zdanc1Cwpt+hD2Io=;
 b=jRLrsEqi70nFj7MHomVyute+PbLdds5WP6gFopzFbca/9PtN50NyRcc+t3CGpzghZeji06Gyj1pOwX4hyHiQUTsr2zkJNoE3ZAFL9BLksN6xHdN/qcwke7Qo9yc1NzhLc1qjihXqPqWFfoOGVZvfg5dNMs1v0J3Z2CZax4dcWlc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4408.namprd10.prod.outlook.com (2603:10b6:510:39::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.27; Tue, 11 May
 2021 03:25:49 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4108.031; Tue, 11 May 2021
 03:25:49 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Jason Yan <yanaijie@huawei.com>,
        jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: consider status is not good for offline devices
Date:   Mon, 10 May 2021 23:25:33 -0400
Message-Id: <162070348781.27567.6809288134478378911.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210330114727.234467-1-yanaijie@huawei.com>
References: <20210330114727.234467-1-yanaijie@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0501CA0144.namprd05.prod.outlook.com
 (2603:10b6:803:2c::22) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0501CA0144.namprd05.prod.outlook.com (2603:10b6:803:2c::22) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.20 via Frontend Transport; Tue, 11 May 2021 03:25:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3cfa9573-0336-496a-e645-08d9142c7933
X-MS-TrafficTypeDiagnostic: PH0PR10MB4408:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB440831DAFA62EB4701A60DFF8E539@PH0PR10MB4408.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z+4EaiakZK7hh0TqaZvoP0bYdosb3gpOqIuuLemlV57EUe2L9oGfXTpjSgyu4wxaF8qF2h6coUeuzL/O+6042LIHPHOts86aD3NDVgDKF9Eol878IlTl1zpbj1V/efGuVzbad4UZdGCrqS2fvNJ6D7T7P2F3/OyignR7CCoM/vtqMy7pSjdg5YFYZsfXPtLU2kaxfgkMAapM07PdxIysfiXFlQjVWjqdkTwQNM2U+m9lkoG9wQZLWfnTE9xS3jILDYVilbtL3tlRGmNqWQ9HSDmPxEf4CBbii2LGtSfff5My3wrfayUgbhJ79FweVAqFeiEK0iUjwPUR3dewg2PUjFimI8nii0tkknzoQPyO+6eDXwiT46u34aruqvFfPHQgRJvNorZJ+r4bQLSKwFzSCIPCYMlvufNKJ7lBmDJox30p4M8IWMfwuyV/DDZQAZRyBO52vYdV1as5grLWAW6+5PbyRHEohM936sq/fEqrZuRegAEEIXGTZdYqSrcuXN+1ZVtNXIMJJVV8gG3Z2eYu1sVDqkobcvF688j0NJPn1O/c9fqwxI/rThCFA9npU00xWLkA/BYpYZGYz1PSKwj5QNmGYJ5yvrDf6t6/1WK5FO4Gcw7b0kJAFIYHprzz2cNo6FpK/8YvrXQKUs1bT/wgUsW6GVEeP/Y6rGob6zaXnbCQDui9VRvzElZ5yC4oOQAG3tWyYrg4nxLfTfq86xAUJsnyvAOwOcvv1w2rKvQxBAQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(396003)(346002)(366004)(39860400002)(66556008)(6486002)(107886003)(5660300002)(66476007)(16526019)(2616005)(38350700002)(38100700002)(6666004)(478600001)(186003)(66946007)(36756003)(2906002)(4744005)(956004)(103116003)(26005)(4326008)(316002)(966005)(8936002)(8676002)(86362001)(52116002)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dUc4UktLR0FOd2VsWVNFRE1vMXBzZTVqS3FqTmVZZHlNUm9yN011ZzV5LzNV?=
 =?utf-8?B?eEk5QnZDWHRaV3FObU0yMWRhNnE4WDBYWXduS2xWK1pNNW1PWGlMaXJ0NTA1?=
 =?utf-8?B?STFFTHB2OFJXWmlDSTRqRk5hNUJGQ2N4YzhOZ2pFT2paL2YyMG81L05ZcGRB?=
 =?utf-8?B?QkFQekNPMXVKNWxSQ0dsbWpCa201VHFWS3VzaHNSVmd0V3RlRm11UUpYU1Y2?=
 =?utf-8?B?dHVlZXF0ZWNIbisrSXJuLzhGY2kyRnlFU3hsS1pjVThmK0tJTWJFZzh6dlpE?=
 =?utf-8?B?Y3J2K2dYbzM1eCtZMDRyUWJsNGc2Y1N1Q3RqT3pUWEJCK2R2ZVBMeGlxZ21o?=
 =?utf-8?B?dmc3RmhSL2F6MlJESzRDLzRZY0dEN3FTNEVVVkJNaXVYbTl2c21DVTYwa3lO?=
 =?utf-8?B?R3lWQnE2YlBWRHhEdm1KblBDUzRTa0FRbDJrR0Z5UUJoMHhPOGJlRGJlbTl2?=
 =?utf-8?B?a1BWcS81bjhBN2dVTkZTbjdWTHZnQU9VY0JNZGRSTVR3WFpKdldLK05nc0hr?=
 =?utf-8?B?VzNxNk1Kc1V5SmRDUFRlZVpET3NLaWVsNHVCU2MzcXlFWVZMK3ZiSkxmWDRJ?=
 =?utf-8?B?dXlZbXAxNkxXUVJEdW5tY1E2VUVzemNCQTRQbnprc2FpUDNCdk5mWEtXMWJV?=
 =?utf-8?B?WStTRHQyUzdUbUZiM256UU9uL1pEWTU4UHk1dmxmZGp3b0RDSjMrK0liVTZs?=
 =?utf-8?B?b1VWWk9HTjJidjdmblJjZCtaZ0dkcGJDREgvd0x2RXFMSTdTVjVUN1BhbllL?=
 =?utf-8?B?NS9BNzYzKzVSd0ZRU2ZITnZudTYya0N5Q0NhTkJOSnFRaVRRVVdEZ0xIcGJ3?=
 =?utf-8?B?ek9VR2VWQ01NZVFyYi94SjQ1L3V0WG5Dd0g3VVlZazdRejBqalgxZnJHT3pi?=
 =?utf-8?B?YlVDUkdLaHVwd3ZRbS91OXg0a0hWWXpla1MyYkQyWTNlRWFlc1NDWE5IdVds?=
 =?utf-8?B?L3VPUlZzZ0V4cXZZWFY0U01KVWlJdm93U2NtSzRzNnN6UVNyTXI1WXNsVEw5?=
 =?utf-8?B?TU9uckRvTnJqcDZ2SlVNWnlsUFZjd3ZQbEtQbERrTlp0cE1rLzVmZkdycU9B?=
 =?utf-8?B?Lzh5WDBYNVZDMjlGTHMxdzBkQndXUzJhVE41a1BQTUZOaTQrZlRpNzNUc2l4?=
 =?utf-8?B?dkwzblZ2Mmc5NFM5aGtiOGhxcGNrTjVuV1ZweEpURGRKbE5UN0x5SUxtdy9q?=
 =?utf-8?B?cno4VCtqVzVTSi91Q3hZdmwzd2tFc0RmYVkya0hmNDYveWxtYnFpa1JydnVt?=
 =?utf-8?B?SkswNTlOdGViUGxqaG5EcGE5ZXFObkJsQ2hUR0I5ODNKZDhka25FWFRDU2Jy?=
 =?utf-8?B?dUI3aGR0OFFKWmhzS2ZrcCtBT0wza1k2ekQzODBZL1BlMzhFYUZHa2Y3SFQ5?=
 =?utf-8?B?cVkxZ1d2YmdiQlRpYlYwQ2NOMDR6WEdzZHQ3SUs1QTBHRFFmVzY1Y2p5aUds?=
 =?utf-8?B?SVJScEJnY2tlQkVrK2xVeW95dVFUS2VSaTBjUXcxRmFLeW9VbmVSbjArU0pD?=
 =?utf-8?B?NHNPMlcvR054cmxTSHorOVZJLzRwOWpRdEpSdEJWdnFoMTBlK1VPeURpaE4y?=
 =?utf-8?B?YzFodVhJRThnaVNWcG1JVnhuTTF2clBWYnJKYzV1RWxDcW12Y05zdnYvT0Fq?=
 =?utf-8?B?bGVCcmZYdk9ySDAwdVd6YWpCeHNtZHk4clVmVjJZN2c2UGdYd1hpSXM3VEdJ?=
 =?utf-8?B?Uk9MampqazRKS1kwSDE0VlYvcUZVOG5JM2FZeHBXUzM5MWNnbWdhNG5JSUpJ?=
 =?utf-8?Q?QJSoAGomZu5l76tZBsEOH+PEfsllmc6ureOpEae?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3cfa9573-0336-496a-e645-08d9142c7933
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 May 2021 03:25:49.5929
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8gpRtCt4LWsqijoclhtyu4+KZQAVT7JqvyyvmHGYzDgSzNI8Lm8O01eXNuXrCM2rQSHuieU6A5ZPsC1DIrMpvgYdScwVF8kXXZjn8FjscWg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4408
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 suspectscore=0
 malwarescore=0 adultscore=0 bulkscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
X-Proofpoint-GUID: lQFYuEyZg6Vei2w4UWJ5aL-PCezrPIGe
X-Proofpoint-ORIG-GUID: lQFYuEyZg6Vei2w4UWJ5aL-PCezrPIGe
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9980 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 suspectscore=0 clxscore=1015 bulkscore=0 adultscore=0 impostorscore=0
 spamscore=0 phishscore=0 mlxlogscore=999 mlxscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105110024
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 30 Mar 2021 19:47:27 +0800, Jason Yan wrote:

> When the scsi device status is offline, mode sense command will return a
> result with only DID_NO_CONNECT set. Then in sd_read_write_protect_flag(),
> only status byte of the result is checked, we still consider the command
> returned good, and read sdkp->write_prot from the buffer. And because of
> bug [1], garbage data is copied to the buffer, the disk sometimes
> be set readonly. When the scsi device is set running again, users cannot
> write data to the disk.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: consider status is not good for offline devices
      https://git.kernel.org/mkp/scsi/c/1ee275342234

-- 
Martin K. Petersen	Oracle Linux Engineering
