Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DABD4C2B9FB
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B94516135A
	for <linux-scsi@archiver.kernel.org>; Sat, 22 May 2021 04:40:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231362AbhEVEmU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 22 May 2021 00:42:20 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:52758 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231351AbhEVEmT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 22 May 2021 00:42:19 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4eliX054054;
        Sat, 22 May 2021 04:40:47 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=4kU19QZ5GfzoTdGzjoOwOByz1G9YJxAVU/0UsmQLbCQ=;
 b=NnY2/gCDEKgpmApVDKlLrPMY4CZgIFR+T581DogcR5NnneE5r4+OqoDJHD+uZQfItjdV
 IdPOSXcykSUBa11OiYkp+CwPs4x9LGIJdxpbXCmXcbKCfzBtexoe/XpmxW9vqvZiatZU
 471L+mfEqw8hQigdt9XNmJpOpzh6K58ro+ybVaOnMvKOdKPld10ZqOendVD84eBkbYfK
 lZzdykQKQ2AElv4p78l7yLS8UoJnmdtyGAQ9fpDncD6bgCLintz/YNME+47/6t60yoxs
 MxMRIDanN7QE08zOaik01267e0S73jKEM/JDoOxRDMoUZabOoaxqPERZCsv20u5jDhwB ag== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 38pscs81v8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:46 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14M4ZiRl168410;
        Sat, 22 May 2021 04:40:46 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by userp3020.oracle.com with ESMTP id 38ps9j32fa-3
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 22 May 2021 04:40:46 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YyzZvEKBcXkDBe4J7EDF26FlVi0aoUUUStrorLLoqN9BpOiuj35ey/0sdnDRXzIY0uFh3HcntxoGt3CslSv+nkIZt1oBTwiD1SFZA6AXCebuExoQnuRiQrth2ug9OTkFwXOy9GgA5DuCV9UgTrioOJyCYg64Z714d7tyy/msQ7fDFINzO8/xnSSSoo6clsY3KhXALmJhQgpn4lLgtpwWd81UYGUDGkkuYYzKyMka6r4ZU4HBlpdHvLiac28mBx3t4uZhLPRm42dhm6UQA8dBzIhq/WLtinyzI1J7M5AtekbfkurnbeAqSMpg6A3V7zp2AIDj4H+CiE5Gr1Dc97IkAA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kU19QZ5GfzoTdGzjoOwOByz1G9YJxAVU/0UsmQLbCQ=;
 b=g1FrKpHr5gFSazNlJjhg2AuX0lc9MbUEskDBwmiRxTbu61wR8B1okJNKT4A8F8Yex85okQe2XVLbsxJrxv5W/1wVkDXAllKGmZR0OkGKQ61lIBSWTlGBx0tGpr9E9z030IMWdmUdGiFuLi/jGEhko551zbkEwX0r8sPLlqVW4a3SoSY1/ntMkXUMobNLk8glRopOp0CtkNG0GB4YUJUIEa060dFSQ9dWDxgWk4xR0/YkRbB9n/3Imusm8vCD17swLGTWGIH6lJtaHBoVW9M71tsnPd/JzdiYFh2yREUFkMGhDjnL796NCkcj6hWhCfvcaygT1cVp9Lu/FZJViDaHhQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4kU19QZ5GfzoTdGzjoOwOByz1G9YJxAVU/0UsmQLbCQ=;
 b=FDhgsDctG5wdX2UPgIx074KLFgHYTAI1kToq86OoLfJPZcVi0nbesLW7Bf1FTTQOjyYP9Aemh2UVD/t62MdyIlGkvkpxwWteG1Lgcpz7QyCNSF311pdYw2+5vC5zjP5rl52ptQwvrZYgLNshI9RhQq2XaJTMW40bzAQbREKWBDk=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5481.namprd10.prod.outlook.com (2603:10b6:510:ea::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 22 May
 2021 04:40:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4150.023; Sat, 22 May 2021
 04:40:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dan Williams <dan.j.williams@intel.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        linux-scsi@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        James Bottomley <JBottomley@parallels.com>,
        Jacek Danecki <jacek.danecki@intel.com>
Subject: Re: [PATCH] scsi: libsas: use _safe() loop in sas_resume_port()
Date:   Sat, 22 May 2021 00:40:31 -0400
Message-Id: <162165838886.5676.17251463121034866403.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YKUeq6gwfGcvvhty@mwanda>
References: <YKUeq6gwfGcvvhty@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SN4PR0201CA0038.namprd02.prod.outlook.com
 (2603:10b6:803:2e::24) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN4PR0201CA0038.namprd02.prod.outlook.com (2603:10b6:803:2e::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.24 via Frontend Transport; Sat, 22 May 2021 04:40:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 177912c2-0d53-42ad-bc51-08d91cdbc2cf
X-MS-TrafficTypeDiagnostic: PH0PR10MB5481:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB548180701DB310EBC46E5D648E289@PH0PR10MB5481.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: z8rvNGCCT5FaAwdngll6XuwKzGQUBIpYosu7EE7spDRnsInnlKCs0Vy+iVIgDBcQzyLukxYoUmBwG9nVkmfkUbbWY0GnEekLdvahSSYzq1A9w6QaxnRxCvzFURkL7UnJ+PQGYB/LgUOavbfiDiITkEnA0V67YVQIdz9p/z6vd4CQgjK9MhveocmlQcvVkJNnoZDvs/8+VkrhmyHjmlqr7DkohFTPeddXMMj8a0OT8I8UDlolX0IoRcU4sK0d1RNlTQDykWMhEc1mUVvM/VNGQQirlE25ZcXSDbMo58ovd16bwgb2/JF3bjifIjzgsXa0FWNG/jZqDjR/c8NGhdLBy/r1dDCWz0DbwBGocSpn576JWmcj0TplZbLnqSKC/mkRxswZxxYYDWU6D216Q+I3UNkVRvelx3STVzcJdr++M2XcFoAWUK6DwK+d3ySk9OXzkVi/+i1JIkeof4rPVOeTO7yIBhlX0NiHjDNlvj0DolsYOKQW2MbMlMK6HHoqEvrPXqvTDubp8IsK7HgUH3LuDYw51mX9JDrs+0Gpfh0+B7C8fsCtWzQ/hsEMeHL2MiBzdS7bIy7+0vPRDlK+6r97p7mFWBlhG4AeZr+i27e7RhtiwKK4QWSWkHU/GJ0rtfraXAaZ61PSf4dYq/3V3npj7k2SQrxQUPOEbJN8XEGp728LU1fKYhgUYJa68yiw3BUJl9eZq2mTt5Vn2/iNUWgHsXKY/q/PBx7RYKxu/CEqHrC868yDq7Pt5t+SumtBjZE+lVTTq24g3jAm1Nhtqhp/YQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(366004)(346002)(136003)(396003)(6486002)(6666004)(52116002)(956004)(4744005)(7696005)(66476007)(16526019)(316002)(186003)(8676002)(38100700002)(38350700002)(66556008)(66946007)(8936002)(54906003)(110136005)(5660300002)(2906002)(26005)(103116003)(478600001)(966005)(2616005)(86362001)(36756003)(4326008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZHRRWTJsbjc2ZmdNcFpmdytXZmIyR1hoQjJ3OTE0eDlScGdNZ2dsRFBqRVR0?=
 =?utf-8?B?c0VpckZ1NmtVK2V1eG02aEtlM3BtQkNXU0Y2WHdHMEMwbkpWbGFpOW1pWHo2?=
 =?utf-8?B?cGFjNXhDVllBOElaRHJuV3UzSk9INjRMWG0vZEZvSFJ3NXR6NWJPMGFwZVNQ?=
 =?utf-8?B?YlJRRlRPeFVmM1J3dmVpeE5JRjNoM00wbGNlbGtrYWZBYjlZdkFKRUhra0sz?=
 =?utf-8?B?QkpCdGNYaUlOcFJ6NENxMmloVGE3OUJCdEVma1JkZXJPNEFsZk9hRmNpWUpT?=
 =?utf-8?B?NldPVmZOYlVORW1QN29TbVp1cFIweDJZcExtdmMydU1oeHByOXR3YnNkQ1I0?=
 =?utf-8?B?M0lEQlJoZm90Z0ZLdTZHeHVJVVRlVUNBL3B5ZHVDNTFudmY3TUhRWHFrbjI1?=
 =?utf-8?B?Z1EveW5lelZWZDlhTjBHMWd0Z1JNdXZ6bVV5VlhFL2psc3RZUEh1OHQ2Q2tu?=
 =?utf-8?B?bjROTG1PQlpYRnhsdzNJUTBqanpZeXRwVTM5cFc3RmlGakZtZkVLb0Q1MGNw?=
 =?utf-8?B?MWJWbG8zTVdkcW5nMkRXc21KUngyNHBObzRhOHlXYnkzUngwbnJLYTlLS1p4?=
 =?utf-8?B?REVGSHNVTWExMFZaNkwrOGpvQkFMY1hkYS9yQnpna2ltRCtGbmJ4amFnT2Vt?=
 =?utf-8?B?Y0pTdE9FUDVwRGhTa1o0b0x2dG9WQmRTM2FDQy9kZ0lEdk95RjRJOUg5Z2xp?=
 =?utf-8?B?RWgyMDlNeStGWTBTMTNzMGxjclIvamhDY1BnS21hQm5qQ0Z5ZHNwdW1sckxx?=
 =?utf-8?B?SGcrMUozSVNlME1zaWV0aG5uRzI2MXl4enlEVThBUFBLMkYxQndJcEQxOEZZ?=
 =?utf-8?B?dDR4WGpBR0JVUUl1bVhkQ0wvVWMxWkI4VmMyZGl4U1lrK0NJK0FGYVFEWGtZ?=
 =?utf-8?B?b0hmdHp4SkFabmkxenBOTmx6MjhhNVp4NlcvdHI1NVRQOG1jOEIrNnJ0K010?=
 =?utf-8?B?V0daOWlYbXo5d00ydzh6alFjRDlteVA3VkJGb0U2TVBSTGxTdC9LS1pNZUoy?=
 =?utf-8?B?NTNKb2NJb0lmSlhWczJVcWlTcGRmY0FuMHVnWTJlS21ibCtRcG1sNVpub0N5?=
 =?utf-8?B?dE9TbUY3WlpJWHV4bVdkTEFmK2d5UlFxL1B5U21vcFh6eHdiTWNybE9vaml1?=
 =?utf-8?B?NnlIeTJlK3lvTkpLaGkzR0pCUTY2ZExGanJmMGh6blZxbTlVSit0d1JnUmVZ?=
 =?utf-8?B?bktPbXE1Z1VqSFJWdnhCYVFtb1FYdmZEYld4a0RDa243ZWdWVHN0MEdxTUk0?=
 =?utf-8?B?bDhTR0x4UHJiQk9XUHpyUm1RUk03TGtlT0c3RjBab2YxY1A0eWJJWlhtZzlN?=
 =?utf-8?B?UVBONXphVitaSWtCNzgyV1ZwblpnWDRVUHZEMldhZmx4OHlra1ZJR1BvaWVG?=
 =?utf-8?B?LzdCUDdvTDVLV3dXU28xYnNwN2FiYmFud25VRXAvYmxiU3cyVWFERGJvclNF?=
 =?utf-8?B?bHkxaVk2M01lVWtZWWtianRoc1c5c2RkRko0aXRwQlNUNlFhamExZ25rRkhs?=
 =?utf-8?B?TTN6WDZCYmNOMnRleGFYTGVnWk1ta0taZkJWVzdyOFR0b3paMHZrRzdsZUZB?=
 =?utf-8?B?TCtjYXAxaWtSNDBIemMwQzhSZm44SXp5M1pKWSt5OEpiTWk3VGl3dTFIamh2?=
 =?utf-8?B?L0hzODllTFJKaDVUN2wya25SblFKMXhadzl2Sm9HTkRTc0J6VGdqZWZTTldV?=
 =?utf-8?B?R1pTU3MwR2xKSFB6SENQN1JhRnpkUktiUjJ3bk9aL1gyblRXcXVTNjk1U3JF?=
 =?utf-8?Q?K8zkBRBk79pLvcuuaQXJhz3Ry/Twww+M0vGe4R2?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 177912c2-0d53-42ad-bc51-08d91cdbc2cf
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 May 2021 04:40:44.3177
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OcGttrL7lbAhnJV1RnXhYVDowVOZnbGmqZpLGaX7iGMTmTUS6w+GgGT+cEkyotyotSM0pgcCeg1j5VThfR2k0BEDWJs4m3dd54Ydk5njomA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5481
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 adultscore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=938 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105220026
X-Proofpoint-ORIG-GUID: GvpI3JaAZt-TEJwjcEXGbBJgJAX67uDk
X-Proofpoint-GUID: GvpI3JaAZt-TEJwjcEXGbBJgJAX67uDk
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9991 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 suspectscore=0
 priorityscore=1501 bulkscore=0 spamscore=0 adultscore=0 mlxscore=0
 impostorscore=0 malwarescore=0 lowpriorityscore=0 mlxlogscore=999
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105220026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 19 May 2021 17:20:27 +0300, Dan Carpenter wrote:

> If sas_notify_lldd_dev_found() fails then this code calls:
> 
> 	sas_unregister_dev(port, dev);
> 
> which removes "dev", our list iterator, from the list.  This could
> lead to an endless loop.  We need to use list_for_each_entry_safe().

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: libsas: use _safe() loop in sas_resume_port()
      https://git.kernel.org/mkp/scsi/c/8c7e7b8486cd

-- 
Martin K. Petersen	Oracle Linux Engineering
