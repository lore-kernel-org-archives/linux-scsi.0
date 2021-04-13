Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 826BBC43460
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 5F248613AB
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Apr 2021 05:49:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344806AbhDMFte (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Apr 2021 01:49:34 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:51042 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344721AbhDMFtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Apr 2021 01:49:01 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5hoGs053568;
        Tue, 13 Apr 2021 05:48:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ceXWbCgk8FBVLejPYcXc4B/rTVoJb6fVk+hkIvdShK8=;
 b=OKEE9DjXqupCeDqHioRQ+6rRLQMfMQmODCX1npzKwFf7BbjsDv7T2IevKR3o/ITq0+QD
 zputJMVcdxd3G+bB6MAxO+hxG2OHEG7ahvYhzsAtL8+QQmi07zvkHwz2gn1Kx2IhoSVx
 WDA0eEcFR7I1n7hTPP+xYc/M7cs6f9lDACdqpP3MXc876xgbLUaylD0w0XdRLGgB7rPM
 grePJ0EsVBR/4LpwvEAMl6l5oZtEfBLQOADDGSzWqDWbg/MaN0DA7Fx13OogfJ6HBiVe
 JkNJmjX7+cQxk1N34c4l2gYgyIedOVqPdL/cRfDoJ5CurCkNF0gx5YMRemMnt9T0QWof mQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2130.oracle.com with ESMTP id 37u3erdusy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:36 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13D5kRHx137316;
        Tue, 13 Apr 2021 05:48:35 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by aserp3030.oracle.com with ESMTP id 37unkp3me5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Apr 2021 05:48:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XMCfX4Bvm+cSQc01LuimE87tByt+dOASHM1Zi2Hej0kcZIfz28hqBeMqmBSGsP4+OZ/0YpLXp32JXTtkwjMHSYEUL9YPe8rm5qx8fymbGaNdbApQRYggOam9hM/g4cA8MMKuk/qhujth4piYc1A2yiOAPtdSvUum/Fml7eUrpUqEuyDMudFR6eOraCqfvQVmOFd6VuNkZC8BFwv9IkMHT4Roaj08YOciXwWDl9k0JD5nUSx7Yw0lvczH5qS1xCzcZm/RuCTEybUgKBE8BSNzDjcMxChacBOhZudT1c8kHYchCgKl2vzS5v6dJKS/W9TUyQQx98gE7DKD8vByGN/aBQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceXWbCgk8FBVLejPYcXc4B/rTVoJb6fVk+hkIvdShK8=;
 b=EMGlZRMWe0SL0Mc2xmM3jO6xeSUdKb6Lec4MPBijumN32U1gI3DZod3vKy8kg5dY8ugxIsm9hCP5qCis+KTkp7umKgwrPGt6XBewpFXndNovoOI8EBW9/JOoIqbtU9OueXB204KhocZ/L5jReS+4FwJ6bmfK7YBGztT9MMYCgu2iv3e0072NWP0L266XzSPWvt7yMuUHFwhQ9Ki/C7tUT+5nYwIgGm76kDKUeLUB66kbRcv0jx19uxbRorGC7Sj1L2O673anu5rYx5pM+6pFe19kU0lUe+KaYQ1ISutv3UmQt2Pyrjz+Hx6AZ4rS3vv74rcl5NNySE8eIsXSn/kT8g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ceXWbCgk8FBVLejPYcXc4B/rTVoJb6fVk+hkIvdShK8=;
 b=GR5QvJp8eRfXAymuuBIS/ryHQz0uLUjcUht4ISwzeImZcRbnRJTox2ZBbSa5P9f4bKorXq5iRL+/seVG8g2+MnkKddF9R7nkfFjTBnOXQ7RauL1IGzEG2+L7g7BfMxwlz5hP6swsQMm8cpwZMVFsh5aGXeWQf203JZ8UPzJE3IM=
Authentication-Results: hisilicon.com; dkim=none (message not signed)
 header.d=none;hisilicon.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4727.namprd10.prod.outlook.com (2603:10b6:510:3f::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Tue, 13 Apr
 2021 05:48:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4020.022; Tue, 13 Apr 2021
 05:48:33 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tian Tao <tiantao6@hisilicon.com>, jejb@linux.ibm.com
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: qedf: remove unused including <linux/version.h>
Date:   Tue, 13 Apr 2021 01:48:18 -0400
Message-Id: <161828336219.27813.1308859938239686393.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <1617283618-19346-1-git-send-email-tiantao6@hisilicon.com>
References: <1617283618-19346-1-git-send-email-tiantao6@hisilicon.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: BY5PR03CA0008.namprd03.prod.outlook.com
 (2603:10b6:a03:1e0::18) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by BY5PR03CA0008.namprd03.prod.outlook.com (2603:10b6:a03:1e0::18) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.16 via Frontend Transport; Tue, 13 Apr 2021 05:48:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 22019a1c-02c8-4fcd-925c-08d8fe3fc609
X-MS-TrafficTypeDiagnostic: PH0PR10MB4727:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47278AF77483390003CF3D7D8E4F9@PH0PR10MB4727.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2958;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tiOVdzEb4NHC6CLktl5zkZbS9wPHNvSx5x/N3hGaSLX/mgSnvS/u7dwTV/vZvqwiB5rx+LPYJ6UoKtcgHS+g6LzswPWa7GaR2w2mBOTJsrdkzeKVxezCgy2/a4paVIkZCiMqyKIqpthhzC7YhPdUdbrhQ4/BKJbSuR8cKJCV7kNP8YRtLOk38fXqXLpNn8tRr+ubZap3MmTp0ugAcnXt1A9Z5OoEpyTFV3K0znwY0kpKOfsZbLDCpk3bjWRsvKOPKGqharTp3Vytv4fXfRXpkm1BQCS+30Wi/B6ohMXgTV1yMEZf6jfLlX2gZLkzTqBqCdLKsumb8itbLJ0EcZkqcBSFq7DkTuOH9prRDJhKO5qUo44kwhXOI7+V9K4HXaYe5LZAWza9awT2LiHVIWDTN6C6hlK0ap6ReZDCTecUda6dki5cmkhHe2CxXCt+5hupAnier6BPyhRyRh1bDCaZYzSqguYN2qQatshF9grXtfPW8EBv3ryJm0nVGsrmsngXKf3DLMcbam+cCBW+BAPbwISyPfhnJkGyONbRW2KQ2aYAY4yzYCS02KkSQMf9IHWDDuhQ0fec3/pkSSOQgRN030NKc8iLg58QEFqXLgXIogdCcZAYL7WZXAxYVfd7HyYnA2QNZnCfWseJBmZKjxk0xmejQ/ass0Q7U4J2uHP0PuVvVCd9c70DH7nd5avfTFWrjciLrzEhAolG2bL9+OyY9mTq3OKlXcBdqpei191u6GY=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(39860400002)(366004)(396003)(136003)(376002)(2906002)(26005)(2616005)(186003)(4326008)(36756003)(38100700002)(558084003)(66946007)(38350700002)(478600001)(6486002)(956004)(5660300002)(966005)(8676002)(86362001)(8936002)(66476007)(6666004)(316002)(66556008)(103116003)(52116002)(7696005)(16526019);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?QVdMbm1tUy9OZDlCWG13bnBseHFPMDFtUUFOZ0JmZlpPcGRtTVgrQzl1MUxV?=
 =?utf-8?B?Z3BTM3dwZnl2SUdxMUVmdDB0ZnZrNldZMkRQaGFCMWd3NXVuT3JBMG1xcE9F?=
 =?utf-8?B?Nkt2TEFyc3dxLytWRGFiQWhKTXhvd2M1QTJVS2ptTXpSVHZCQlY1Sjg2aTdU?=
 =?utf-8?B?WDJZWlBNSlhjblJadGNDU1NBSTVlWU13V3g2NzFvaXg1b1VtcitKYm5jNk8y?=
 =?utf-8?B?UXNBSG1BbDJnYndMRkJYZDRlNE1EelZLaUlCMzY1L2VJOXBCd3VsRXh2SklY?=
 =?utf-8?B?NUZaNmZXNjhvRkdkUmN3TDhUTkxabitlYWduUzFYbGIyT2JROTNEczUxWGdS?=
 =?utf-8?B?cU1nb3c0bzFaYXZGSEhIZ28wWFo2MzcrMldwQ0l2aEljQTlpemFqd0IzTTVo?=
 =?utf-8?B?a2lVVjl0ZWw4MURERDlQMkRBSmJZR2EzbFBnOGMwbTNNVFVEMmJTR2ZIQWl4?=
 =?utf-8?B?cmo3RzBnR3hQcEFaQk41d3F6NXNsdlFZV2MrSGVoSVRPY04reXBHeDhRMGhl?=
 =?utf-8?B?Z1NSd2NUSlZMeFNaS09KVmROTXZ3UWRmNTJ3djduTW54d3FKMnJldG1GZVdi?=
 =?utf-8?B?Sml1ejI0UzNZTTFEYkZ3aVlJczg3ZU5TT0RkMmViUk1vOW1pcVoxaGdzM0Ru?=
 =?utf-8?B?emdHYmxSU0k0SFNtNXBuZVMxUldaWVg4YVFQUHpFc1FDV2hGeWprM2t1Y1pP?=
 =?utf-8?B?c1AvdFlMV1l2d3loV20wM2xkcXArQkNYZTZoUmpQNmduMGs1bDAxckNCSHhw?=
 =?utf-8?B?ODJPK3E0WENPWGpTN0JBVmFUY2pzMHB4bzJFSjc1SGRxd3c2R2VRRUdyNEwv?=
 =?utf-8?B?WmFiRGZhMDladHVRTFJBdkVPbUZqZFZEYlhpQ3Z1RzdzaGI1TExHR3JsR1gw?=
 =?utf-8?B?bXVJVTh2MlEzcEE1aWZxU1VmN29uRFVxUTVHMTc1TUJ1ak8vQmY5SHFsU2Yx?=
 =?utf-8?B?U0R4OFRGNFZDckpXNUhTZnNCSmlncjdFZVJTa01USFBrZVltbEFXUmk5TTA5?=
 =?utf-8?B?M0tJSlhGS0VBS1RWZVZKOU81Q0xvaE5aa05QeWE5aHlnSTVhaWN0clFudk9w?=
 =?utf-8?B?Qm5kUVlDQjlkZGF3a2hWRThjTHMxWG44VEpMaUFBdjJyeFhnaXlwTmxhRVU1?=
 =?utf-8?B?b2t1SFpyYXowSUhpdFpKc051WTcvanpVSkdJTHFzQUxxYzRlQUJvMkkvVGcw?=
 =?utf-8?B?ODhQWFhuWm9EUUx6OEg0Y1lvcitFcEp0REVWWXcxN0lHbzNmekwyaDN2Rnlp?=
 =?utf-8?B?WFNRTHp0a1B5ZTcrWi83L0lxWVBCNCsrY2FHMHZsaEU5b28zeGp0S08wTFhN?=
 =?utf-8?B?U2t4RUZ5RzA4Q0RyeFExN1NpRkdBSlBib2IyRTlhN2FBcG0vdVN4bHppUXl1?=
 =?utf-8?B?UVJUNTR3c3VMdVlPOTNKQ0hiblZtN2Z3elRoNjF3UXNsUkpxZTQyYjRraE9G?=
 =?utf-8?B?aWtoQlg1ZU9wVVVhTGxlRnhnY2VuR2dleUF2aW00cTV6bTgzWmZMMjJRY05H?=
 =?utf-8?B?MDcraThDcFhXNXFXdTJNZ0tSb25pSjYzaDRmdzhXQllhbldEaVIwdFFscHo0?=
 =?utf-8?B?V3hITGFkZ1NpZjNnSFFnWHFwRHlYZ255YkZEd1F0YndRbmNaUGhqRDVBMWxs?=
 =?utf-8?B?WlRoMkpvaXI2V3hjZ0xMZXVXeXQ1dHFLSzNkemlpOWZONWJqaVYwRDNrQVUr?=
 =?utf-8?B?eGo1czgzSWFndEp2Q3g5VC9sRUg2MDBZVi9UWUp4Mkkvdm1FVFQzMGp0QUNh?=
 =?utf-8?Q?QqquX+oB57c+iyvERBM3d2tsk19oFSbls8583i2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 22019a1c-02c8-4fcd-925c-08d8fe3fc609
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Apr 2021 05:48:33.3628
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Cyw+Y0WW6ecy3xpAQZ6UUQEvIMjIfVkmUcmPZttgo7hyVlqbwY7jXapfHr7GNmkLw3x0MWaKVVqjkVvbW8pk51U4RETIKbxzCDL0DazO8v4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4727
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 malwarescore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104130039
X-Proofpoint-ORIG-GUID: 6l3eaQhTo5CIDAsdFaB1Sn9dqxcywZAw
X-Proofpoint-GUID: 6l3eaQhTo5CIDAsdFaB1Sn9dqxcywZAw
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9952 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 clxscore=1011
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 impostorscore=0 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104130039
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 1 Apr 2021 21:26:58 +0800, Tian Tao wrote:

> Remove including <linux/version.h> that don't need it.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: qedf: remove unused including <linux/version.h>
      https://git.kernel.org/mkp/scsi/c/a1e9981ba528

-- 
Martin K. Petersen	Oracle Linux Engineering
