Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3674C433E3
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C8CB61A38
	for <linux-scsi@archiver.kernel.org>; Thu, 25 Mar 2021 03:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbhCYDyv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Mar 2021 23:54:51 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:50304 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230070AbhCYDyf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Mar 2021 23:54:35 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3pX1T194468;
        Thu, 25 Mar 2021 03:54:25 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=e8ugYPa0c0ts4Uitbl4QJiWWkqr3o5BXB23sjRVryQY=;
 b=Gxotzhj58IR5wp0svGWCzf0mGki4DN8zFZU2y1HLhdNejriZj/8KrpWsoan+Rv4O0rpA
 zBd6Ag4ifoBAag1Rf8hJEZs+aJqJcNDrxLrZ3rMmNrsvWMCUz0eK8H/eeb4xOmKtZdK1
 nkYLCcsS/r5ssxBvtKtFE+IC5D1qomsmDkwo4/ngFLGJbKYOLWvYwZHQ9MQhsCq+NPlN
 VgmKQbB7Q5rKqRsTJTcGmMUvWDg21pWXnj9UE+gb9fekMwwbJhdWPRWN5IRhYcD+iywo
 NSP9qOg17WtKpNrtuklJ0OoPa6bRaNC3YuWtlABj++V3JeuYoXFnAEBmf+l895vYppLx RA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 37d8frcwfj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:25 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12P3oEhg041048;
        Thu, 25 Mar 2021 03:54:25 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2177.outbound.protection.outlook.com [104.47.56.177])
        by userp3020.oracle.com with ESMTP id 37dttu5j7v-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Mar 2021 03:54:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oWEPZfj5/DwASMBVjoeABo7JfwaebdDZWGF6mDhv8/LSb9a5cIiXnflD0AxLwjBNVm5UzkS69F7iPICj/JJSYrqs4ZZA1iikIIShqXEJfY6BHfgnRgUtHKEO6mLPa6Cdy+w59IWXct0w1n4qJ0syx4yF/ZMMjsaxtlwYliJUSU8sqOg4IfZdrmhLK/3ZJmbAMS3CTvqtBCoUIMCUb94utokIZVTTn9d3G3iVnOoUTksbTnPUEWemVz6+uG/MKpSIzFde5AoPCgCk1kLB7P4QS9z9y+znX6Y7ZrUdvPTbN8lSnG/+wl4M0hbaXW0e8Etfw8m2kJQk0O+nZjl/9EgIlg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8ugYPa0c0ts4Uitbl4QJiWWkqr3o5BXB23sjRVryQY=;
 b=kFHEWEbv0WUUwVFvj3OPkXmFr3O/O5d99mPvUQmo7+FXUb9te8vOAguUJRER+aRN/F5B+qoORFz0UIkLsA4UYz6aTXsf0kNRGhGlB9sAfiQoD5QlTgPRVuxiqj8bqqPOGzU8I2QicqOQkuTI/Rs3xzUlwW9hDPFY6cSzsThEKuWZdVj34/EAFIlWctdcDg4dA9//zT1YzK4ECEyYL9zVGLItnfZl/Jwi9ZggTIQmk+HD8+RFOPyPz3b1aZn3g6EHiaZCCojJVQfRyCuDWxn4NcafGwMQquy+Rk2W+8ATCFzyLcI4xzxP1IYp9f/r+w7q8IukrDyn29oyKQKmdQ9T4w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=e8ugYPa0c0ts4Uitbl4QJiWWkqr3o5BXB23sjRVryQY=;
 b=QxxFqnlxvC0FBdCDmEUwZEbOQ49A+Ub2v3lRMlxpcRqM4GSELMCfae0y2GVP+U22oW7VKd/ZhydZiBUyAZQdTGPe7BfJCA4i8DtKC5PwTn6druglsNq1hA4psbVjKO7Ktvp/76PMHvyQ1IS86FG1wHPUir0+s1O2pErcg0JNvf0=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4774.namprd10.prod.outlook.com (2603:10b6:510:3b::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.24; Thu, 25 Mar
 2021 03:54:23 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3977.025; Thu, 25 Mar 2021
 03:54:23 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        Yue Hu <zbestahu@gmail.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        huyue2@yulong.com, linux-kernel@vger.kernel.org, zbestahu@163.com
Subject: Re: [PATCH v3] scsi: ufs: Tidy up WB configuration code
Date:   Wed, 24 Mar 2021 23:54:03 -0400
Message-Id: <161664421197.21435.7853990592929626701.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210318095536.2048-1-zbestahu@gmail.com>
References: <20210318095536.2048-1-zbestahu@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: MW3PR05CA0029.namprd05.prod.outlook.com
 (2603:10b6:303:2b::34) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by MW3PR05CA0029.namprd05.prod.outlook.com (2603:10b6:303:2b::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.14 via Frontend Transport; Thu, 25 Mar 2021 03:54:21 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d7c80ca4-ced7-438c-48b4-08d8ef41ad47
X-MS-TrafficTypeDiagnostic: PH0PR10MB4774:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4774CD7918F2D5233E397A5C8E629@PH0PR10MB4774.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:3968;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: pBxYa/R+yD4HwCI0fdHQIdH9wzA71/qJFpYowiqoGUVD604kVXWzvok3eNEfeZcmJYrHt9D1Dd2HPvPF+M1HVp7ZDNZ0kq8FfST1kwGd8l8RoncrN3GUNuGsuPFWAVHGatobipApOXuRmeY7L1cSkSP+kNtj1evooBIV12FBIhGU5aIVC98GUESRdZMR4D5jMRbTUcO25ZfoYjciMlSb8/RMSCiRSxBZxo9/X/UPC1RPjYLEzDT9CzsfuMDPbt0JSddX9ijOjPkv93OBY1ktvty3YyemqVuRRRrlOijxB6R6w0o8DQnW8WVkLzE0KmWaCXIhNADc32Dv5kDTiCOf3dh7wrbyQkddTuDkeuL9U74Xf2LlOM8lbutYAPjjxX5PMfHreRtOZ4XzM/4ZEqHb2hzUgGB9/fQq1LNdAvjJVdPExJh1Jj0Kx3lQvDH20q/fvDEtwW1+EHMdajskHNdhNCPamkTGJYejqtcyGGOUsu0AKtGcYGgKK93IlzD5Lfa/zn7Pm3qh1E+R2ohOrNF/qD3bk/P3+QiMIyXYUDxHSNgMZdBrhA24FYJk2nFjT1UTHSJuNCEdpBWY2nXj5CipZ0upJhbfTEwlDKeQLQS7MFy92S7OiNHzDzkJD4xzhvUEAUGoj8OYUeEV4lvF//7bCcuzasrFCMsYAOfEDia96djCItADg2LuJhIX5UiOww6o75+HuH9+O9sznPxx4urBvICzIwCOc2mjcPoiChxPWj4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(8676002)(4326008)(86362001)(103116003)(6666004)(36756003)(966005)(4744005)(38100700001)(6916009)(8936002)(2616005)(2906002)(16526019)(186003)(66946007)(956004)(66556008)(26005)(316002)(52116002)(7696005)(66476007)(478600001)(5660300002)(6486002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?ZlVWUjlFeHdUSmFjRzU1aHk4UUtEWGhrYVJqNGhRdmkvMjJ4aUo1VTRlK2x3?=
 =?utf-8?B?aEJNVFYyUGZiTmRzVmljTE1qMzRyaFIyeXYzc0JSbEJjdGRodXJZNzZqUXhQ?=
 =?utf-8?B?dUVDS3ZvWGoyTUxFNTJpNStndXNHSHpsNE1wVk84MzZwS1VUcnJpRUl3YXBS?=
 =?utf-8?B?MXNjVmF5MlF2bCs3QlRieGhuVFo5SnR1NDhRaC9aVVNHUXl3cUZqYWtIVSsw?=
 =?utf-8?B?MzFLVHVHZjR5R3lqM2NSR2tWa2w1MmtIVkgwZlErSW8zUlFIVXBSUGRYWG9X?=
 =?utf-8?B?Rmh1Qll5emNKYzU5Zy9Bc3NrMy9ZWG5hamNNMjc0cjl6dDZ1N3h3YVBSalAr?=
 =?utf-8?B?MWJ3cVFuaVZ0d2VtTkVlSmhsWUlES1ZydG5xZmhoNjVDS2lHMGZabDRKbk9U?=
 =?utf-8?B?VzFncjVjTWZudUpUUHc4bE55MjIvUGl2OVU5QitMN3o2MzBFRWcrR0o3S01w?=
 =?utf-8?B?K2w0WUdPQnBjNmtDYmJEcHZPUzUyUzZBbTBvMituM0g4UStORlB3TGc5K2M3?=
 =?utf-8?B?TnFVTzFXNGt6YUNlSzNzdEtXK0hQK0I5dnB6WDVHWjN1UWc3NVkvNS9FbTVP?=
 =?utf-8?B?ZUhSRUdFd09Ra2NHVkZ2eHp1QWZabVoxUzg2L2VIc3hSZ3hCRVZUTW1XTzZZ?=
 =?utf-8?B?aTFXaWY3N3NtUFJ6eWdXMzRLQzVLSWZMZ29iUHAvTEFsajM2TGFRd2VMaDE5?=
 =?utf-8?B?d0diMnZGQXBRNTkwUzVSeFc5UW1wOEdoRmVZMkhVU0RZMXphN2NJQXNNY3B4?=
 =?utf-8?B?eko1Z3Baa21VSXFnTTBUSFpUN0xrampKN0t4UERpeFJBdVpNMkNPeTk5MjFK?=
 =?utf-8?B?OVNtRm9xMEErMlFYejArNDlGVkc5S1BZRm5adStxeExRQVBjL0VQN2hjbDAr?=
 =?utf-8?B?WFJlTjhBMStkMlpVcS9iUWR3SVQySHAyVjJPaWQ4U0JUaG5sMWVycENoS3hD?=
 =?utf-8?B?dE91c1lvRTUyZ1VCWWxSdk9YN3NxNzRPZG5QM1hHbmxYSUdnNmhrZDBSYzEv?=
 =?utf-8?B?dTd0eXFlaDA4WW1HU1RrK3BpRnUvZnhhWjhPWVdaUElKa0F2ZHVRbndqOTJI?=
 =?utf-8?B?cWdQbEFpUzhUeXVsK2hwSHJRR0RKTENrZ1ludjg5ck9zZVAycFdzNUJiandG?=
 =?utf-8?B?SnFsSlIzbFladlk4d3BMQ1FTZFM3cXlyRUk1UGNNbHlKdDNvU3drWFB6TE5q?=
 =?utf-8?B?WHQ4RDZ0cUZ0aFZ3ZUVuN0hONXV2eXh2UGE1SlZZZy9wTW1LN1IxaXNoNUhs?=
 =?utf-8?B?L2RQNTlZcjMxc3dnRFRMTEtTcnNQQlovNjFxNkpOK2o2UEdOMTBMOW9PQUlM?=
 =?utf-8?B?ZjhmdmZhUFV3dTh3Yzd4UjJla2JnbGQzL004Sk0rb1FCZGVRVTVRQkVxNk1V?=
 =?utf-8?B?Ny8xQ1V6N3lqN3hyTmI2VFNtb1oxekQ5RFlBWnVoUDhmQWludlBRWFB4enFz?=
 =?utf-8?B?eHdJZFl3QXhuOFFJOUJ2c1U0aHcyVlBib1JlSDhjNzdlSWl0NnFoSnZvQysz?=
 =?utf-8?B?Rm03OFJJeGdGL1o5UVpWSkZFUTdqSmlteUZkZCtFL1NJN1k2STdnR0ZhWkxy?=
 =?utf-8?B?elB1dEFtdDUvbVY3bk5aM3psYk9VOHBweXQzN21Ib05kdWI2amxVcEFCVVlx?=
 =?utf-8?B?TGRCNmRBZTczUFN1c2xGakUxdmFBbDdMVHh2ZTFtSklVRXVRWFZYMGxlVVlX?=
 =?utf-8?B?NklOVmFNRXpZTkVYVkdxWUFFRGorY2JNWVBDa3h2bmpxZVdBSVo3Wmx5WjVy?=
 =?utf-8?Q?XmVSTyZd3pWIX59H9nTDTNPj/YfHYsRvRBtvI7v?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d7c80ca4-ced7-438c-48b4-08d8ef41ad47
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Mar 2021 03:54:23.4218
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5/Pojik7jiA4B14fXhzeUdpQRSQMoHUHPizQE+T7GxrxR5mXWM3+J52k9L8Ky09roNd9Idsz9dOMKIYMJOa7YAPPw24h6DRkXmMZysQOBIQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4774
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0 spamscore=0
 mlxscore=0 phishscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9933 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 impostorscore=0 spamscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 clxscore=1015
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103250026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Mar 2021 17:55:36 +0800, Yue Hu wrote:

> There are similar code implementations for WB configuration in
> ufshcd_wb_{ctrl, toggle_flush_during_h8, toggle_flush}. We can
> extract the part to create a new helper with a flag parameter to
> reduce code duplication.
> 
> Meanwhile, rename ufshcd_wb_ctrl() to ufshcd_wb_toggle() for better
> readability.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: ufs: Tidy up WB configuration code
      https://git.kernel.org/mkp/scsi/c/3b5f3c0d0548

-- 
Martin K. Petersen	Oracle Linux Engineering
