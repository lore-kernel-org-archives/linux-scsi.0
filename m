Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B2F7C2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 67AE860E08
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:42:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231430AbhEVEn0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:43:26 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:58130 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231411AbhEVEnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:43:23 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Z4rn056349;
        Sat, 22 May 2021 04:41:44 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=o1fQ+hA1R/+EQqwSO3UpwGgztNLEGvobdd4c5WyC5kw=;
 b=LRqMksgvmg67PGlEECuWdzHSpeUIlp30Pz5Svl+TYZNhiLTElLVip3MbnkUgMHQjPNDL
 lLI7ijTPuJNkXxkRQ3OuCAxmExOCYfK3mn5EMcIkxIchEfZxYfwgxuftz1TG414pmU0O
 5wdq8vtYTfhdUylpM+f+VjBrmqBiL4YYcPz/V7ZWu6HsBt/CzhnkEVDEBzx74dHj9EiP
 gVRf6DhK8uYiR9tSKdP7txpVoQiu19Lkx1cgJuWadxGwZUZ5z2X/Y0JKEdz5ukXZluWa
 mCpuW7rUSjY7k3EylJiFdKO3eiWXm4y/mW6PJmOMLGq9c5PpvxFpOlbUlwxrEXKnnxG5 7A== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 38pswn818s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:44 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4Zjil168565;
        Sat, 22 May 2021 04:41:43 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2108.outbound.protection.outlook.com [104.47.55.108])
        by userp3020.oracle.com with ESMTP id 38ps9j33ty-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:41:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mb9X78nZyCznOxMS5RgdN1WzSQc3C2NJCLG8X7Pazg1428OId/5H5JXPZITMUPVmjH6UgX2G0NxAt83TlZtizrtoxejOL2reg2MhgZfM5jwjzDEWcnZH3SpTi+GxPAtOLB1juveAZm9JbeKA+2dOaqLysIssdMotaoQiNnMJvJYv+u099EkRGe0VruDkugkM7JBlAua8BcA9Sc2uu3vGUwWaxPJOWCrhnZUUsBJIQNp47HKh2Ri4AcFHSlk8m7hhFQ6rsfjbvt/44alf1VGUNQ5u7Gf4waV/++8/jli6PQI5Xc6nYND60E3M36yD6of7PIJMqPgitxLZpwdFvxnAKw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1fQ+hA1R/+EQqwSO3UpwGgztNLEGvobdd4c5WyC5kw=;
 b=X0Wv0y8LhguPJO1HyBJ83wkbbqqYxNEQPu0+g4QlhhTNyWghKUbbcstniw1LxetgwsqoGSCOX5etwuXU88dCiP9SlbEFI6ocROuCwaFinJGbLMyUecziN/Qf8K29Rvnu/iUj1SexkfXvMtQwLBlDRTmPZjocsHQk8YIWNx/TRaXDzAIlBTduQdu4rwFIzr3HmsuoWUp/dOjxOdFENq+CYFrlE3Lzyg8eRdhQq49MIWlB0v8OSLpaIPV72cmtRue1+PMAYyxhRqG6qtYV71vD15dG6iI+rEntN8kvf20+abx2xyCwE8MzLc6wRMMerz8LGybSB6zcZyPbzUtFgJsokw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=o1fQ+hA1R/+EQqwSO3UpwGgztNLEGvobdd4c5WyC5kw=;
 b=XuHcpeem+vi+HN6/pV2KH2JfTBuu/CIkPyvtePaOTn8rjzJGaVA3aueu51RRcUqHmuFyDo+ka0j/oYdZuJbOfzD+6FekCUxvawOYWbn3F340IMxyX35Z5L+GWtp7PCj1bHajPVkStoc6zgPvZzHrt1beb1xDF6sVLuSbS7B141U=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:41:42 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:41:42 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     avri.altman@wdc.com, linux-kernel@vger.kernel.org,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        stanley.chu@mediatek.com, beanhuo@micron.com,
        Keoseong Park <keosung.park@samsung.com>,
        asutoshd@codeaurora.org, cang@codeaurora.org,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com, jaegeuk@kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: ufs: sysfs: remove redundant parenthesis
Date:   Sat, 22 May 2021 00:41:33 -0400
Message-Id: <162165846772.5888.14815551645710711642.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <1891546521.01620896402035.JavaMail.epsvc@epcpadp3>
References: <CGME20210513085320epcms2p87452b605eb1353caaf1add0b5488c88b@epcms2p8> <1891546521.01620896402035.JavaMail.epsvc@epcpadp3>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA0PR11CA0019.namprd11.prod.outlook.com
 (2603:10b6:806:d3::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0019.namprd11.prod.outlook.com (2603:10b6:806:d3::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.33 via Frontend Transport; Sat, 22 May 2021 04:41:41 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 293bd2a9-4379-4011-a535-08d91cdbe58a
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB54815D66B82C28A2654116448E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2657;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cs6W5nTmw8jojxLVP57mVLotHLbZB8G1QrMwr9jJt9j6pzRfL/1OjaWarvbYINxDIqnFLetJSstwcqgZ7RoR+6WBwu3QpwDWDGpKClEsumTCiito/0bh48FPxunt+6M5BYQxagvvjO6/MkI7pA6Bmk9fuIXa84UPza4ZSLr9DxPhqljSP3tIvocEgCb/99cj8hJMUsuNWK6UtXH2UgOkoyOMSoRvFn5vQR7IGxrQVar1NOC2BajFTLpskZ0Y1pPKaltGtbItlZDyLrN9zyvSIWRz8I+8E/ez8hp2SW/EhqIRIpYqj+37Mk+K0eEyjalYQR7gqUAERSj41ZKdvJzmT2QuQH0aZsnQgvn00QZBQZNHHPUNrqmMK3oRZE9xZ/NLpYCXwJXuyVtxO5my37oPH6JYGQIU289QcpJdwWoPxiTUnQ96xfWtD+80aKc8uq4Hy3wZLsCRfEGQ/FkMEyppjt5XCeigUjisCeh+oV+6sxqnXvRiGQfda3yySXOnM6dAF0CThYSldFolmKoPiYgG4d42pv5aO84YURGAwFwURivdoCGp18mw3mVhYwjnXh5QvCqtdutedwdqqlAEC31kAxuzPxC7bDq5n1KtnAs/0URFfzGlAogOVI1OnaRimUg4Oc90rPNWL15Tu/6xbJF5UNuoRyVn0lXcpIeqf5AEHAXA7qO4C3ZwycLRPZ/a7AFdhq4Ty9z+M/kXmiH2B0wVbjwhcyXTEX7lzKRANYZi7CMN+ml3Fa+tfvGgXci6dxqJ6y2OSUPRVeW6bE9p4Twzij+Me+jPCssJc6Ii6qzd8fA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(921005)(38350700002)(66556008)(66946007)(8936002)(107886003)(110136005)(5660300002)(2906002)(7416002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?SUpXbUl0c0g2SE16QytxaWxkbUptcHovaWVTNVRGU0owbWdkT2FvV28xVW9w?=
 =?utf-8?B?aDVDU1lVbDlzYU5xY0xGTStkN2dzWW1ITFp4MjdwT2hHSCs5QkF4ZlN5YWx1?=
 =?utf-8?B?cERncXJqVk04ek1LWHQ0N2FWaGM3NlZHQmhvVEJwOXc1VlU4ZUJWaVRicXN2?=
 =?utf-8?B?emNhNUZRbVFNWkIyKytIb2ZvUVJBSFlTSk44U1VkcnRkMmNjejR4bGkvM3Mz?=
 =?utf-8?B?NmRDRlB2YTM3T0Q1R2JrTjdYWjBxRnMzc2k5NzhzTWk3UFpkb3I1encrK245?=
 =?utf-8?B?Q2s0N0dDVGlkZEZBSFA2WGRCbS8yVmZlcmxVTUlHL2x5dlNtU1VWMG9OcVZB?=
 =?utf-8?B?RElWRHV3WDk1dDVielVaQ2ZvRVhPamdFNUFiUnVZaTFnSXRhYVJqcGxRVGZs?=
 =?utf-8?B?d1ZaZnUrWmQ4TkdnTmh5V3g3YmlRRWkvcGtGc2oxUUJvelBnQjZnSFdTVXVX?=
 =?utf-8?B?emRCc2VPTGhKVkFWT0FqU3FTZzZJQ1BzZjJZRDJoV1BWRzJnWFNhL0h6NUlJ?=
 =?utf-8?B?RDFGdDZVbHVMN0ZPY09lLzJka3kwdmI5L2VDcWZSZFgzQW5TSm5SN1VSV1ND?=
 =?utf-8?B?c0dFbWw4VE8rY2ZQWmt0UHI4UTVTK0Z4M1FaQ3Fsbzk2TitRMlJqdFRKQll6?=
 =?utf-8?B?QzRFcHhKTWtaeE5xS3pVNEYrOFZKWlpRTFFNQ1NDZkN0a3pRMHdEdG1NaDdn?=
 =?utf-8?B?ZFpiR2xzTWRUbEV5c3hrWlRIc0F6WnJiRGxTcnJvL0RBSE9JMmFySzRwL1lp?=
 =?utf-8?B?Z2plclhmbnh0OE5JM0ZXN2xNNkZYc1JGdTRpYXJVUSt5dzVub1Vac1NqN21P?=
 =?utf-8?B?am5wcTZZbU5aQmtmTXJka2lZNjdCQXh6TllLcTFtWGQ0dUcrYTlpaEE0Z0gv?=
 =?utf-8?B?N1hYSUZpTk5jUXJYWkRMd3h5eHNTUmszc01EVXVVZlZIbmV4Snp5dW14eVF1?=
 =?utf-8?B?OHZYOENndWpyNGZjOGl1QUJURkU2eWJLVXAxbGVLa1pvZ3BqT3FrVXFubGFC?=
 =?utf-8?B?dlFWbXY2UFArdTdwR3dvQzc0SzQ1ZHBjSjRpdHVGR0V5eThWTG1LMTRwNkpP?=
 =?utf-8?B?WCtkaGwzY3hray9QK1laRXR3cVJiRHdSL1RMeEZGYTcraFFXQ0swc2lNL3l1?=
 =?utf-8?B?L2U3VXkrRUE5TW8yY3U1Umc4UW1TT2FyM3M3aUE1bjZJYlZFLzk3MlRaSVBN?=
 =?utf-8?B?Z01hcjBrRXpMbTZIc1ptSDBmVUN3cFNNUUlmbDV3TjBCMXo2bitPRWtFL1FQ?=
 =?utf-8?B?MjF1QS9VVGZPVzBGZFVnQTVZRkR5VDNsVmtBb0dPc2hkS1dwS0liT25VRWJQ?=
 =?utf-8?B?YjhyUEhSWWpJYXlYSDRPS3R1QytKS1M2ZWZ0WFRTRmFmdGlmUGpDTW5QNHdV?=
 =?utf-8?B?ZmFLcG5hT2JNRHREUHVrZGRQUE1mbk1ncmN2emkwNWFhVVRxTjN1bE5UQ01V?=
 =?utf-8?B?VDdKaks5anY1UVpzR2k5dXdWbDltNnI2WGhDUi9nMkJPdkNZUS9OVXd3ZjZq?=
 =?utf-8?B?S0dXVDJ4UUx1ZnR0Y1F4Sk1keWlTU3JLRTBmVVJ1N1pZWFRBRFlHQmhwUzNY?=
 =?utf-8?B?dFIvcXpDamsyeHQ3alpkN2x4aU9UQWwvQllNTjE4UDY1UEpVa29JM1ljSkUw?=
 =?utf-8?B?N3VwbERCMFFMQTFkaG12RnZQcGhVZXM0YlFTZ1A3Q0pVVUlPMEJIZUtMdVpx?=
 =?utf-8?B?b09lY2VZdSthUms2TmkzRGtXZ2V2Q0xrSjMvUytxMVNKdDdTOWpsMER4RUJk?=
 =?utf-8?Q?+XVDxTdXrRszf+sDvjGckuQ11u6ia9dpJG6leOw?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 293bd2a9-4379-4011-a535-08d91cdbe58a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:41:42.5882
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: aBmM8CaI8Ym1hqwLjDZi1jhTUjh08dVJQrWdxJ+OZDvaf7pMCkJuj6ZgskhyRsUPMP3UXRAkbZod7p/I7OlqzJqSCVWg4jdfUU40QHgf1tY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=997 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-GUID: 4vxtByY5fAg4bQfHnVrDBYKmG7x5YhHi
X-Proofpoint-ORIG-GUID: 4vxtByY5fAg4bQfHnVrDBYKmG7x5YhHi
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 suspectscore=0
 spamscore=0 adultscore=0 mlxlogscore=999 lowpriorityscore=0 bulkscore=0
 malwarescore=0 phishscore=0 mlxscore=0 impostorscore=0 priorityscore=1501
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 13 May 2021 17:53:20 +0900, Keoseong Park wrote:

> This patch removes unnecessary parenthesis in ufshcd_is_wb_flags/attrs()

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: ufs: sysfs: remove redundant parenthesis
      https://git.kernel.org/mkp/scsi/c/7f2b3c8bcb7f

-- 
Martin K. Petersen	Oracle Linux Engineering
