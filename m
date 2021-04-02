Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8125C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5DB3610F7
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234458AbhDBDy6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:58 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:44704 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234038AbhDBDyu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:50 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pvwG147170;
        Fri, 2 Apr 2021 03:54:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=GLu/iMpBGQarHAwhMfXu2a76ET8quwgkOupCvOhaoqs=;
 b=QvWae75K/VZZsrvrPU0OaNwsZVtFUoZeyW+M2fwZhF9kpo6v3b9jD7hzbbFQM6e7k5lu
 EZQgwJxIa78kwvJI8M89B4dxZvO3h6UFl43oieH4QZay9HDS7QaQeiOBEPDM71oLfQ8Q
 4zPXQsJ4TVXjXsRZHMPVocYDqF2ICe97YlsTA6MQHG0YBWsLquNdUVIgidYvshqGA6EI
 LyEmwKl1LUC79xdXzip5oM09iqWKkpsPXTavIYDKxBXrZFV+UAoJc6qvECDwmRO6cgF0
 YqQ9BVwk+PSjPUWobtbgfxm1gZeOuQgSGaSC4Km8DDZrfgYK5/wbyM3ZYiDxI5iznOtZ Jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37n33dumsa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:33 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323owkS170973;
        Fri, 2 Apr 2021 03:54:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2176.outbound.protection.outlook.com [104.47.58.176])
        by aserp3020.oracle.com with ESMTP id 37n2ac2k8v-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:32 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=hVCkM5TDfyMcQC5EvM/Gkn3okzFD3NySXZgMNyssK07TZrprTC6OnQp6IBn49Wrz999A7YQG/UB+wwY4o/8RbQV5x9lRIe/S+4S8QQ7FWO21fbslKP/S43aI6Py6mdr8/baV5wICkFz7mVdOPPXgofSk1+0V8MG5Cc4So9lRbPNQdgGfx6vsCMI7V5uJJez4BFeq3cLKw5UW8jFRkV5xodzMsEA0Fup6rNrUkg/XcIAN/p+cOQn5ll1ZH5ABy92z+hiZTUNtJqpR4oWEXjo/sH5QQaQqWIrjnRtgx0hfpM18xFhq/Fu+Bvu+5djcZeIOWyu8ZFXKnTEuO9Og/i1AkA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLu/iMpBGQarHAwhMfXu2a76ET8quwgkOupCvOhaoqs=;
 b=mbRDXD+a3B7wsHazRuPMrPxjtysLHdwTeB6nROdiGwM4fBxeNvLtWMYI4w9VH3UO2UuwcAhWsJKMXn2W+dOCWg22eb25HAsdNJ+Y/c6iaeC9YXA49E/Jg4BTWWmdHQ0AsAbU72V+uYQDMHpTc3KDJmLrlDK4jI+jk4dVwk5TMypxtsYpKUP5d7sjXLfGvcQVAIQaFMG28eMtTOveut7WCrWhPu3Eybehs/IuVKGtVj37x1L8nIKsm4mv9VI+dItfVfKwWrOfmZFLftRMTHng9qkVoepDPdfgilGU1n1z1GVaHFqJM5r/7r4I9S519GpBV1vlJ8HeB7ixoKU0wqRDZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GLu/iMpBGQarHAwhMfXu2a76ET8quwgkOupCvOhaoqs=;
 b=nASc8LrZEerMI6JB2z+MYlsQIasfMdyeMmRH2GL33FsNEgdxPTfvnCbQS5d9Qgxl3M61ApUNUhEckVMXgIfu66XU498pUdEUTSx07Ed2eoVJqxaNjnP0aOrKwaD7iLHNT5Baug+Q1321i2zrW73BaichIxxV1s41UknUKdAaWzI=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, dudengke <pinganddu90@gmail.com>,
        bvanassche@acm.org, linux-scsi@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, dudengke <dengke.du@ucas.com.cn>
Subject: Re: [PATCH] __scsi_remove_device: fix comments minor error
Date:   Thu,  1 Apr 2021 23:54:19 -0400
Message-Id: <161733541350.7418.9333226450206013919.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210326060902.1851811-1-pinganddu90@gmail.com>
References: <20210326060902.1851811-1-pinganddu90@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 36bd31f6-1028-4d14-44c2-08d8f58b057a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47111CF7D6CC206758DEE3468E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2276;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: eMmkjA4sy/6KVtgBmFHAudzWwGg88QCiT1y5RHjOz+947HyVToZlPlJD+GByRApxPR7zmulubn0NvobCnY3FmwdkPy/wXd7zIIR/TI1Yip4WztQfzb40J3SBYAABS1ufyLru5yhH849vc1QE38QYemSM85XKkR8KCjsc7d8/C2hJaVpK2ukMzGW8AmamA5G5YaKFVz6yuiHwmJGae4AggqUOrIPj4ZwpO+9FG2LpfmwgGpdWQX8NIS16q/1R3jUJOAxQQXN1hUgJ8Dlx/57znGwjNGFt0UZrIfkJbQdnL08RJAHBOvXh7EzryA5blwuhbuu7FLPCWW1MDgWLm1FnqqDYaet4vKyUGUiYdTYCqo7skZP2/PiGPORyjuE3z/LORtp5+jQk+pAhwFilPxiuGseP6PhSvRUbSgJqJHPT4rDz/7Fqz/sw6qonhYwVIdoJjIJRzNBNAKe/kviKA/6ZT+JpnKy+ulDtBH9TViL6fy3cDIW8FDS9YEE7+PhSmw3L4TCybUI7QKFR6WP1tBz8XgcUZUaQdXE3i9mbRMGugNO8kE95aXA9niABKVwqsXxKS9b5vkB2FF8JV1nEc7EtQB4A6LLQmmEY0+G9rPRad3ty1tIwEyLACrzq7z1mFsa2r5OzLTG4jelb9O+JG5XBu21FWKh5vJM14k/SIDERvOkba7L0Uajec0BxdzX2WLZeLaPXSkhnHLgnnV/xOldRV1xHKMEtCPJJ/EvvbBlkDkU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(558084003)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(54906003)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(7696005)(52116002)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?UlU2RHczUGdocVlkazcvN0RKU213R1dkZWJETVljNWFoZGtOSVBueWw3MG9G?=
 =?utf-8?B?Z0RTQzZHdlhMejdrT3A3OWUwaGdsYTc3M2F4NXdZVFROcEZtZ0JuMFF5NVAz?=
 =?utf-8?B?eEtkOGNSZGZMbnhjbjI0TGpqeXhlekdKQjVHaTloMk9xRGRJcFpLUGdHazZP?=
 =?utf-8?B?UVpoeWgxYkxCanpXeWtvUVlkVE5HclZMV2QyNkdNTVprdVppY1loWDNrblhz?=
 =?utf-8?B?SnkvWGhJTyt3UzdzMUxWVzl2dTV5dnBNcUVvVFRlM0VPK0N5RUFncVpBdFhC?=
 =?utf-8?B?RkNwc1ZkVTdsRXFEblJhdVRjM3pJYW04a0t0MVorU2MxWDFxSnlwYmVERHh1?=
 =?utf-8?B?RTVzRnRnakpDRE5YYkVzUnoxU0l4QUpPVnlLS0phT3NGbHRDem5wZGhWaHlR?=
 =?utf-8?B?N1drK1U2TEhjdThLVjV3eWg3aU5QZkVkOEZ1L2tTRER2WExwNkYxNzhqb1dw?=
 =?utf-8?B?OE5mTUt1R21HYjZ6emhGek05M1Noa2txL2pvanR6cjBzSXFlNkcyaVVIUGNn?=
 =?utf-8?B?ZS9naVl0UWRzbzFVYmtYMWdTclM1QWFEa0MwNlhlYzh3Q0pDbFRvRWE3VDdm?=
 =?utf-8?B?WXNXakg2MVhqeWVxODdyKzI4c1NwZVg2cmdlWmJSaVV1eGJBMTd0bzJKR0RZ?=
 =?utf-8?B?b1Vwb2dFZENxMTFtU3VlWXdvYnc0Qm5BcUo2am8vdjEwWUx0WUpjaTBLcU9P?=
 =?utf-8?B?bmRZaVF4QjFscVkyVmYwYUZSMUFLT0xJTWwvTXIzT2NGMlhaQXNVSUllcWlj?=
 =?utf-8?B?NzhhTW9JQUVJN2RtY3lzWWU4aVBSa084SFJ2V20reFZacERWZlRzanlXZ3JU?=
 =?utf-8?B?SlhnTjhEVmlOWlBMQ1lOL1FrTzFyMWc5NjRieDZOWCsxVHNwajIwdkFkbElL?=
 =?utf-8?B?cTFGSXNlak8vK0NJdEk5Y1RUcmVzTVpaYmtWSUtSMjgrMlZ5Q0VDTVVyUGNG?=
 =?utf-8?B?QzU0M1IyeEY2VU5uWXFoU1ZsRWxyNVQ2S1NVOHovd3laUWV2L1BqMFJlVVhm?=
 =?utf-8?B?YXlzdEpqUFVDZ05yMDRGVlk3NWlqOHp3ZjF2NmlkcjdaQ2pvLzBpNGg2QWJ2?=
 =?utf-8?B?Z0RWVlZubE8zUlJvWk1ZYlowdGVKU2o5aExWaVRxTzlTNGNONmozYmRsZHVi?=
 =?utf-8?B?c05WZll5Ukg4TDRVYldXTkhQbmpQNkRhOGNBTktCQ054NnZ3YUFMVm5OVVR5?=
 =?utf-8?B?YXBDU1V1RG9XNUprYUo2WFVrbEtxMUFQRjlPRjFWdk94N0JuTmdsZnVKaDVT?=
 =?utf-8?B?TTJBcGVWU2dzTHgzR1JqZkFQTGZYbTFVYU9RQlQ3N240RmtsVFI3b3dLYXd6?=
 =?utf-8?B?SDRDNG1pRXVyYlZ3dVVsdldLSi9lTVRadUJCNzdQREcyYVF2K2QxMnh0WE10?=
 =?utf-8?B?Y3RTWklMQUprckRXWUZOQ0JJYVhaN1oxY3dSN3hwQ0tBWDh0ZWlJR1J3VnBx?=
 =?utf-8?B?T1U5VDYwTi8yY1VXOGVXNVI1bXFjVG1Pdm12UWx5bW40d2JvMkVhK1lkaDhq?=
 =?utf-8?B?NTlNWkp0ZnVZN0lBOEpmdDlzSlpON1BFK2hSSmQvUXVmejJyVkVrOTFoeDQ1?=
 =?utf-8?B?TmwvRHVDcE1ZY0ZlT0RES0dzaFUzWTlseTliTjI1YVZLL09PTjc2czI3Si85?=
 =?utf-8?B?NjFOcHRxMUROQXExMGhLNlRGYTBQS1doS2Q1R3Arbk11YjJrOEtxL2ZwTFRV?=
 =?utf-8?B?OWlxRzR0ZXN0ZUVWNXNITitLc3JlVTl3SzU3MDNzUDNuazVxL1VCYWdqWTkv?=
 =?utf-8?Q?c52K/k7h3vWTjyvOiGhSPSYhLaapuZOp7Ar0S6m?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 36bd31f6-1028-4d14-44c2-08d8f58b057a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:31.5626
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nZ/xtcE4irFuMxLnwr5GPHKt+mw8zWTQ78ieIIZ4D3O/A/wfHnlouGfD1fIakIYVApCU1Ly5NtSDPT8tGUj7XyzQJKkOi2O+eSB8SjAC47E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxlogscore=999 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: bM-5yw65JOqxddIZsgPPBSh54osk6e_F
X-Proofpoint-ORIG-GUID: bM-5yw65JOqxddIZsgPPBSh54osk6e_F
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999 mlxscore=0
 lowpriorityscore=0 suspectscore=0 priorityscore=1501 phishscore=0
 clxscore=1011 impostorscore=0 malwarescore=0 bulkscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 26 Mar 2021 14:09:02 +0800, dudengke wrote:

> 

Applied to 5.13/scsi-queue, thanks!

[1/1] __scsi_remove_device: fix comments minor error
      https://git.kernel.org/mkp/scsi/c/eee8910fe0b5

-- 
Martin K. Petersen	Oracle Linux Engineering
