Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C0CF7C433F7
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 99D066195D
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 03:56:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231544AbhC3Dz7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Mar 2021 23:55:59 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:43550 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231150AbhC3DzY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Mar 2021 23:55:24 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iIUi103485;
        Tue, 30 Mar 2021 03:55:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=2zw7hNJindbosgrUHpdwrSR16eR6Lf0csoWVw4q6wOE=;
 b=tBEDuF1kSRTOGzGREzLY0t9QSybst3HwiNC9tCXCQeJMV5XToyr+1YEFwYZW5ZfmRX+1
 Bv9OR5dbT/ehp7XgRy4aWcqXG9MGu+TGH0ZNnBLLkrfJQYHAsmLSKYU/8jMDPU4YTwEO
 4bO5iWXTWS3vrMmKbpbFJLx4CAVISJk2dd0+jvgWRvq/oEtL/MY3MHqgOsxNaRIe8KDY
 h/p92fawVp+CaiXo1QzJujyKxRqAupBZwyn3tGXNGpa+wX8SYYeSR6R2CWPkFcSjGlmP
 lETW1ynvpT6c3OtAjif/aOyKXTBTbT/bFxskSYLBeIlOtpCx//KlhLccDjw0o2ZTCC98 kw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 37hvnm5kbq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:16 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12U3iXhr039516;
        Tue, 30 Mar 2021 03:55:16 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by userp3020.oracle.com with ESMTP id 37jefrktfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 30 Mar 2021 03:55:15 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d3SKNMtgK0li3m/un/b8kbL+dVYwklAkYpRS7HCnRFMOPz+fw/0FrrqiB9YFVuaBxihI2UjSYQHXfL6rqiwX2qkK5qlDvXK+bU0GIiN6nNIPukEeFSfn4TxwhdoU7XOwKxBMow+mpmXw3G5wYn4yG9A3AQVqsPV+WHVS9R1sNT5ZNyVSaHsZiWq0YYnvwdw/sADSGlU71+Nljy2HNVbdvK9mCFqiKiXG/RU3/iEbXsEwNn4lUD3ex+8VVy2+nW9f6Tl3P1rPonXDtwEpLWA9qFE3Q21KDNWN6TXFYdGjXkA7rCTdh3fZi6U9Bk4jg6IlxsjiUV5j01OCdjYbWOaK1Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zw7hNJindbosgrUHpdwrSR16eR6Lf0csoWVw4q6wOE=;
 b=KtAVN9ZqJdHrqUwc4QyD45QSMvSAXvuiT4AElid4cNaLsfBNzDSaLRkQFemBk7qN7/HYxlUVDLpw5EWlth3Ub/2wxSt3IO1AmjuQl+fWdW02zOybzChZO+kEUAjj6GWM49uXNjDMx3CPVE7KJNOGJLNVSFUYqufKxIvCc5hY5mLIawP9wfPh4ZCCZmsSjzPmYNhm4JMIQ7+Pjw1UbLEYDvQMw6UpzwAGRHTP1Fe80gW1OpB9Ke4yq2uOv+Jx3SuV5OdbEACJTSHc2jR2CrBijETzBbY2A6Z73igjUXMW5f9xeE4rGL7eoYLGgoKBwdL4/MyChLkeIrKv0a7w0ZqBYw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2zw7hNJindbosgrUHpdwrSR16eR6Lf0csoWVw4q6wOE=;
 b=i4PHIKOhoN9BqpHZG+2x143GAT8EmvzVf+08nwAkX4jzzq6jr65rEON6DdaYw1KIHhHXUWf9rwEQzZBUG1vzEkPLPRv4kKbqMTHDq3YKk6Jc6S6PLuDLpxIYW0T69ebPeGmmF03ID0PaynZfRBEptuuYTr6zONsAxPhz+E+q4yw=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4760.namprd10.prod.outlook.com (2603:10b6:510:3b::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.25; Tue, 30 Mar
 2021 03:55:14 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.033; Tue, 30 Mar 2021
 03:55:14 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Bhaskar Chowdhury <unixbhaskar@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        rdunlap@infradead.org
Subject: Re: [PATCH] scsi: scsi_dh: Fix a typo
Date:   Mon, 29 Mar 2021 23:54:45 -0400
Message-Id: <161707636882.29267.3269389495134683629.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210322064724.4108343-1-unixbhaskar@gmail.com>
References: <20210322064724.4108343-1-unixbhaskar@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0231.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::26) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0231.namprd03.prod.outlook.com (2603:10b6:a03:39f::26) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24 via Frontend Transport; Tue, 30 Mar 2021 03:55:13 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: eb86113d-db9d-4c7e-752b-08d8f32f9f81
X-MS-TrafficTypeDiagnostic: PH0PR10MB4760:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4760993DB5BCF72C2C212D2C8E7D9@PH0PR10MB4760.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1332;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: sd+bj9VNPf6pKKRvq3HHFNOqe4hoy52LScV1sSPHLvA6wbAsqTkx8YKnHb1+Qcf7/Pk4vKZgI7H9e+Hw3QcZRhG0x2c7eoQXruQEx6FP/yXOG8ukwg64rjpUYYf1O8kQA2QUNdhSRDygs6AP8IXtjXLTmLFW1nkqF01e0WmpH/qgHJ50ML+DCpO5pEaXBfARQJSdt7MUgWaHp/48tn3L+9xKjMgiwhbaJausX8HbVJYsmWdXCTmu+UJHr93DTH7UOtJ1Jp+GNEa5YMiL9gY+IU+ng0efvxjnuiGo+IddDMuEv7OI5HqcEQ5BL9DUBhjWMdlSMyi9GoGs559QZ4wLz/AGSO9ct+1BO2+OEukSVmjaRei6ULVgFa8K0aajV+BfJLfZ/RoNKCKn4WRc4xlhAvCjJlBlnFa8z2Rpv2rfJ35Dpi+DmKnh86LXOmMeLAPcGBQwRQZcmyoixDHWQv4P1DRBu5b02guCbU2lbIOsFDJ+ax3cRPY2YrCkcuPj7hVcHSNWZsNpmPr9LcNhFFMigYqqG82gear+ZZxti0reGPBBs5mJla5Pzh+1+bRFrjF6RyLZV5mSQTHuZAC6t2mI9zM0qTBjAxH4/2a1yjvY/SSJjdOPGGqfC2AJClwlapPbaoLCoiFCZMsxmnQFECK5tM40SKTj/eR8CGYt+oSW+kLNkU5MHWC1IqAdv3akwiTsyVABj8GcT/l5A06jOHe6kY/wPQdtOLviK8jILST6oDo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(136003)(396003)(366004)(346002)(376002)(66476007)(52116002)(86362001)(66946007)(66556008)(6486002)(26005)(8676002)(478600001)(7696005)(186003)(36756003)(956004)(316002)(966005)(103116003)(16526019)(2906002)(5660300002)(6666004)(2616005)(38100700001)(8936002)(6916009)(4326008)(558084003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?VHRVQ2U0L3I2SXNEWjZWZi9ZUE5ZSnA3ZzNyOGlNc3VJNUxPK01LRHlLSEVV?=
 =?utf-8?B?d1JGZm9BaFdHTUNDZE1kcWp0VkxibFdjVk8wb0VNZ3B2MGVERWUxc2lybytk?=
 =?utf-8?B?WktCS2hoekZMUzZlenpPSHlrS2QzNnNIMTVVc2hkRzVhcERXOSt0YlBmQ3Iw?=
 =?utf-8?B?aW1hMUFQWnVIWDJMUmRZOUh1S0lsSmg3QTNSdWt0VlhZN293dlVNNUE5RHpW?=
 =?utf-8?B?WFIycjVseVBzUzRITDRUOVhydFVpQS9Pa3ZaeFFuMCtrOHEzVUZqRllZMXNm?=
 =?utf-8?B?OEtSOWpERHRrVTNnbnQ4VU8wY0l0V0FzdnFCQ3BHS05tVkNCeDFEQVUwYmlQ?=
 =?utf-8?B?UU9YT096NGw0OEJtMFhpWmRjbTk4MFp6Q0phTC91YUVvc2ZMSG1Ddld6VVRE?=
 =?utf-8?B?NUtRUExOT0JUdzlCbkszZlZwY0dDTlpMZHJFRDZQZnVwek5lNWpRd0h3R3lR?=
 =?utf-8?B?ZUxVcm5vSmRqbWRnUkc4Ni9QdSt5MUNXV0pONThXeGtRamRJdjhyWmlvMUNK?=
 =?utf-8?B?MElhMm84ZWh1QzBDREI4aUMyZFZHTndIV3drN0xCNWxoNllWQ3ZPandJRGho?=
 =?utf-8?B?Nmdzaklya3BrZE4xWWJKQkpFbEIzaFJTWXBzN3c5S05MVmtVcnhWTVFOd05W?=
 =?utf-8?B?OERRYmFHRUZ3UkhyMnhRSTNVVmJIMTZITFNjMVR5VU9jNGdmOGxHYkQ3YmhP?=
 =?utf-8?B?N0RPVGZ5WDUwdkpjelY5RGtyaHR5U2s4VUk0am5rcEsvMFBrU3R1QkoyNS9p?=
 =?utf-8?B?WFNHL3NDelRJblpSN1dueWFNZEhCSytwWStheFJrK1Y0TUQvU3RaaVpEUVRm?=
 =?utf-8?B?RWcvdTdrL3lVRFZRNUlNc3o2MW54ajl1VkdWMWZENnB5ei9KN1NNdGVkT2xQ?=
 =?utf-8?B?M0lBZitHWkl2a0tpVThtN3FOZDRpOGtXWlJtdnc2czhremEwYWZDZFNPZWtt?=
 =?utf-8?B?N01BeDFaL1p2U2JZOHNwMXl6R3dKaWIzeGl3OXUyMnl4MFJBQ3VZa0t3WnJS?=
 =?utf-8?B?N05sLzREaW5KNmJRcnNMYWxMK2Z5UWkveERQZmVPTEx3dGVTSVMrS0gycUNu?=
 =?utf-8?B?Rk1Fb2xTZU1PeHcvWE5KZnpzZkxkTmFyWC82UUpzaW4zcW9GbVVrTFNWaVo3?=
 =?utf-8?B?YmdrMlRrdkM4RXdQc2JaV3hBc2RRWm00N1U3MHVnZElhaXdyV1FlR2Nua3Y0?=
 =?utf-8?B?dVZJbXAzTG4zdFJhVmtmQzg4bmRLUjRDUzE0Z05qSFhMZlRMaDAzN04wVm1P?=
 =?utf-8?B?Y0VZVGdMcFdnRmhjczBoTG9CaXlvYzdmU29vVU5WS3EzSjB3aEN5cExRMk9p?=
 =?utf-8?B?aWh4RFQ4bHJxQnRaYkUwMTBpNEtkdndXTzk5YlZ4VEwwWnBsYWg5bldtOFlC?=
 =?utf-8?B?eDJYeEloK01Ed2Q4VXF2NFZFUitYbS9tbXlGRDhsRlNDVHdoR0JnNVphTmZX?=
 =?utf-8?B?ZnRONWxXTDB5Rm51WnpjU2h5V0luQ0IySTZXTTQ1WWNOUEszd2NkTXlFSzVx?=
 =?utf-8?B?YmR5cnh3Y2tJeWNqTUlVcVhVSG91Qkl4ak1xUnRQR1kxM2pScjRMWXVyMzNS?=
 =?utf-8?B?enluODk5ZGlvN0xoZUpXU1ZnVStIQ2I5QlJqUkloZmxrTEc1bndVbGloRFRm?=
 =?utf-8?B?dzEybWZRdEJ6UE1teUIwN25SVkRqekJoQUhDaGVudWJGTWlMUFhVVmZtVmlL?=
 =?utf-8?B?UkltZVhRWURJOWxtZ1Q4U1ZvWDBjd1paMTJ4TWhPcFRyNFdYNXk4b1hEN1J3?=
 =?utf-8?Q?orgMFntWEjYeH+9gOBAjJxPok87iSSp1o8Ni4rU?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: eb86113d-db9d-4c7e-752b-08d8f32f9f81
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 30 Mar 2021 03:55:14.0289
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Y03MUKkhhNzW9wfI0Ui8vBMsOomsBAL1muNRSsR3irE9+E/7NaGUt695gd8w9LfYvPXqFGTQiCXETnX2BryI8sOldrNiCGqChTMIM46aVOY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4760
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 malwarescore=0 bulkscore=0 phishscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2103250000 definitions=main-2103300023
X-Proofpoint-GUID: tvUG6OvgBVsv2Dk4ZUpjboBSY55CaT5Z
X-Proofpoint-ORIG-GUID: tvUG6OvgBVsv2Dk4ZUpjboBSY55CaT5Z
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9938 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxlogscore=999
 clxscore=1015 priorityscore=1501 phishscore=0 spamscore=0 bulkscore=0
 lowpriorityscore=0 suspectscore=0 mlxscore=0 malwarescore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103250000
 definitions=main-2103300023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 22 Mar 2021 12:17:24 +0530, Bhaskar Chowdhury wrote:

> s/infrastruture/infrastructure/

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: scsi_dh: Fix a typo
      https://git.kernel.org/mkp/scsi/c/ae98ddf05fdb

-- 
Martin K. Petersen	Oracle Linux Engineering
