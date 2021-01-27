Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90FDAC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5A6892070A
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235428AbhA0Fia (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:30 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:52820 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238681AbhA0Ezg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:36 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4sbcL058138;
        Wed, 27 Jan 2021 04:54:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=+QOLkt1UXb1n7sjc2kdgckBmefVgsom4F6lS6yhfttY=;
 b=AIJqdE4qGMp06mFHs7Kz8n+gW0S2suYY/MgWw4bwiyS4dDQ1Af/zhYHnknlmxy10WiA9
 ahzpUf67UTybCyUXinMSzFObXSIEr2h6EdpPszZTtMbNrlM+BqGsvE3142m6GCPM3SeX
 X9911UajgFVZjK9dEIQ/6wU99bCuyUtFOI7n+9BhOCCJJz1MylwVhpsX/hUmqiKoctV/
 f8s4cdvoWMGnDDsoG/+2WkTBkWRemdqwwpe1skshBNNcb0M8ppw0RL709WrQ9zc9qC7X
 8E9cQC4gak3+EpTUj0Ak+mRcBfQxueJTE0aAFg6m4gtGO6/fQlK9C920ejdYvGywhBMs Pw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 368brkn3qw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4newg014991;
        Wed, 27 Jan 2021 04:54:42 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2103.outbound.protection.outlook.com [104.47.55.103])
        by userp3020.oracle.com with ESMTP id 368wjs2ayr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GNj3SRLX3DDGlUHFwc+MKKlAzYUqrB4jwhYZyNsWjM9I1pEcNnAzUUgInW1uroKXADhaKYk4k5OEd/0kzUrHuruaSpvM0u8vUNVWphvBbQFu41M+s/MyNatTL2F9a4oZU3D24qaZueaC+TNc1AEjV5wN5XvUJwJz1ZffGE8jIfVWwa0DU8VGiiQFDwXjA+VEJRKNutyYCPi3hVwktlKcau/mCEwdxLSEuRUs7sfAPHThg04KOY0eVewPuEBmbdHix1uQ7x2By8edfADNaFyhEo+FRDx+FyU4ZIDnLrbA8n4ulZxDMvz53iIGcQFl8pdNksGc8zd5We7Lv3O18lT56g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QOLkt1UXb1n7sjc2kdgckBmefVgsom4F6lS6yhfttY=;
 b=JkaenDbvexK4ljWMJitVNp3d7PnbMr+AHqQLEWuCI2kUlgZeE5nBdLk4jI7XDhfC4c6rYYprUoDyWsy8CLsw2PM/Y0gqwjtN0P3KxlvqZ143Lv8fmTB7LEoor+hYZfeAIY+jCI/uRxyPZOyDEWQsdalbK2RE5hdplSid5wSfjgDXjBdHWbKJlTxwKgUAvhtc5nvNmER2T8smROoLWqd5olsRTQW+4w4F3axEkZNciJMNPY40UNfy3CWhq1GJVWyANcncZrzGNyFlIsz0hNWDQilJbZbkGRE5f7/Blrqj6FdsCPvrsjgOdgUKDL3OcWQdmLoWvQEQAyvQtIKZPd0M+g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+QOLkt1UXb1n7sjc2kdgckBmefVgsom4F6lS6yhfttY=;
 b=zVwWe/9nx6Yh5dYsKbRPRIRUafc23AinLUsxrgKLHscqJs3qjUNC5HC6yaepfZoZs7FbSrRs3gucNRS3QysrnVLM+mSh4R0FzVVzUYlSF4JG3KBzJJ6qrCD4SltfBNV54D9r44Uv7zFZYeVrhQk+hGyStfWTEVAv9Vpaf0FepG8=
Authentication-Results: linutronix.de; dkim=none (message not signed)
 header.d=none;linutronix.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:39 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:39 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        target-devel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "Ahmed S . Darwish" <a.darwish@linutronix.de>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/6] scsi: target: Remove in_interrupt() usage.
Date:   Tue, 26 Jan 2021 23:54:21 -0500
Message-Id: <161172309259.28139.2920333021302735318.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20201220203638.43615-1-bigeasy@linutronix.de>
References: <20201220203638.43615-1-bigeasy@linutronix.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 25cf3597-ad18-4c8e-5138-08d8c27fa71e
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4584CECB9347BFA604B120DA8EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4941;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bQPBX1FrWEDuclueCihG0PVzuG846FBM0euWY/CGiq3fL7NMhRuDShiabZpYb1RUfOt12sd2Yfee5ANVm3C9fDxZf1aor1cvcmQYB7TxYWjwGvRdbN3GctsA3LOZr6yyQe+dMrqcnoS/eCQ4VT/anMJtNo8VHCtf69yGCSMQ/ahVTKyVCrHACztitTIgFUlM4u0T4BV0t28OGIQy/hBBkTofHxMllgyAYS0cTt6LeNxn8UHuyQlGq2ijL5SF1VESRSVkh89F10xDsxNmRLm8+l30cnLejLrDipHGcAjQJKHnObfQA//JtS9QkY0Bk9d4GSJLqSNtOh9bIAPFbBgQFBh/mnThSDaK9Dxa5SrRctlRRoeCuqeDP7wMF5b9fudg5w8oOlm9krLT6H0aTxJhlssn9o1YVfAS7B0pnP7qQooLJGHZrulaVQp3EPT7+lSD9h2l9L30MCP3aLKEv+bcqA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(2616005)(8936002)(5660300002)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QkhFakxaVTFTVmpvYVpLUHN3QWtSRG1Dc3hUaUd0ODVUQWMwRDgyM3ZPRUVx?=
 =?utf-8?B?MGJHUDc4dmVCRHVTRWZINy9ncHdtcEloNytpSGtJVW5CNXN0VGF3Vkhhbk9O?=
 =?utf-8?B?YXBYQ0w3V3padWpsd2xQREcyOXUxT1ZaamFkWXZHcXYyczJRekNpTUNkZVVX?=
 =?utf-8?B?RjUxMjZpUHlkNEhKSFkyQVdQWDE0aGhqYkRwaTRDNzY2WG92NmxmWGxITE1N?=
 =?utf-8?B?YS9yMHYzYVdUeTN0NXNPYmUzVnJPc2RLZEkxbVZIOW1lb1ZLZzk5aGZlNkgv?=
 =?utf-8?B?U0wxZXlzY0xPTGgwQno5eXllK1NwYnBlVHhpb2VvL2xFYUNwcXdacXJJeDFK?=
 =?utf-8?B?d0lOUzRyWEZsNS8xV0REOWhVU1Y2UHgveXhCekZ3ZmYxT0Niby90c0hQWWJS?=
 =?utf-8?B?SUVaaEg3dWsycmxiSkU4NUZoS0ZIOFgwWkJDSUlmb3A3YkxacFJYbFRvdmJy?=
 =?utf-8?B?SzFFY3p1aG5xV1A0YWdmMU5zZlVkOTRhQ2cyMnhXS29CQmNURnJ2RDdHSThG?=
 =?utf-8?B?VEhtR0pTMkhxYmZWN1RDOEZ3VDRvYUNKM210QTdoTDFta0xtNVBhZkhzbzZM?=
 =?utf-8?B?RkxoRGkycWt5R2hGaTZvV3NWU3VRdUVpMkQrUkYrLzJpcVBmc214NnFZN2Mv?=
 =?utf-8?B?SFpkZS9sVEQyVUJyYVdiWFZPSzAzS0JVUUF2RlFmcUFXNkM2YXY3TG5mN2Qw?=
 =?utf-8?B?S3prcGJqYUdBM205ZUFyQTc4WHIrTnNzaHFtTkVFY2UvK2hUR1RjTDY2NHRG?=
 =?utf-8?B?OTFjNDM3TjlRRGNTK0tXYktkQVFtNmxuYjh0UmJaY1RGVDREcjNRdTBmZHor?=
 =?utf-8?B?OHJJNU5nNHhGN0hQUXk2c1JDWG9MZDZtb0x3c2hOVkp1T293S2VDeGVhRGo1?=
 =?utf-8?B?NXo4NzBYUDhuWTNvK2dSNzYzcVdVS2tmUUtuQ1JCT2xNZW41UjExV3owRHJv?=
 =?utf-8?B?SnM4NnpFdWdqTHhseng1b0NJN0dFcDI3eGQ0c3FmWHkxK1FFelpZT3lFYXlv?=
 =?utf-8?B?ZHVPRW5ieW5FQmhHb08wL1lrU2dkU2VhZld4QVpoRUJaUVk2cEttdVkrZFpU?=
 =?utf-8?B?VmNHV2VGTHZGVE01MmZBY1lCVjdhMFY5dnV5cE1QY0s4WEE2SFRaeGozZ2Rx?=
 =?utf-8?B?VFNUQU8zZ2FLWENRdTJjK3FhVU1HSmZyZWRkZkMwU0MvWkVXanZUUVBsUmo2?=
 =?utf-8?B?d0xzbCtqc3pJb1hqWTc1RVJRdVI2SmpMSGpJZ0dTNFQ2VGtXVlpoSnBGaTlS?=
 =?utf-8?B?UHFVTmtMd1JIM2VRY0w4T1B4aldQUWxkKytWbFROZWVBL3B5U285TytRdWRm?=
 =?utf-8?B?TzhoaFRZT2ZDMHYwRUJML2IyNWtuZUd5TjF0NnZXUmNmWDh3eVlYMkRHMVEr?=
 =?utf-8?B?TTJUSUtBQm05RVZ6VlQ3UmRKbDQ1aStnUzVjNDhjQUsxRVc3TDVCWktTdE9i?=
 =?utf-8?Q?iodVub/c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 25cf3597-ad18-4c8e-5138-08d8c27fa71e
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:39.5502
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 6WMDPjQTd2nAJh4e1h/PlYxv8mEK8AgCippJyBWBRtWTa4AmhYkXfw/e+4smUJTE8QLqJNJBhQal0QbAxUo96T1mBEy3QNoqsKBWh7C0LR8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 impostorscore=0
 phishscore=0 bulkscore=0 priorityscore=1501 mlxlogscore=999
 lowpriorityscore=0 spamscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 clxscore=1015 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101270027
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, 20 Dec 2020 21:36:32 +0100, Sebastian Andrzej Siewior wrote:

> Folks,
> 
> in the discussion about preempt count consistency across kernel
> configurations:
> 
>  https://lore.kernel.org/r/20200914204209.256266093@linutronix.de/
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[1/6] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_close_session().
      https://git.kernel.org/mkp/scsi/c/433675486af4
[2/6] scsi: target: iscsi: Avoid in_interrupt() usage in iscsit_check_session_usage_count().
      https://git.kernel.org/mkp/scsi/c/efc9d73063c1
[3/6] scsi: target: iscsi: Redo iscsit_check_session_usage_count() return code.
      https://git.kernel.org/mkp/scsi/c/f88a10f80da9
[4/6] scsi: target: Remove in_interrupt() usage in core_alua_check_nonop_delay()
      https://git.kernel.org/mkp/scsi/c/a97451ac1e34
[5/6] scsi: target: Replace in_interrupt() usage in target_submit_cmd_map_sgls()
      https://git.kernel.org/mkp/scsi/c/513e29946ab2
[6/6] scsi: target: Remove in_interrupt() check in transport_handle_cdb_direct()
      https://git.kernel.org/mkp/scsi/c/bbb087679d5f

-- 
Martin K. Petersen	Oracle Linux Engineering
