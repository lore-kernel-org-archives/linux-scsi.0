Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B998AC433ED
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 13:53:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 77D3E613CB
	for <linux-scsi@archiver.kernel.org>; Thu, 13 May 2021 13:53:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234162AbhEMNyj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 May 2021 09:54:39 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:35564 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbhEMNyK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 13 May 2021 09:54:10 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DDoEwq025115;
        Thu, 13 May 2021 13:52:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6D6KjdYWin8CccphBpLkLpAg6dVQ2yCiI/qHK3f/ETE=;
 b=BlYklCbIE8GO9SvcwcD48ted+J9beYBlw2dkX3qq1h6l6ZotAZg6/IKNHqJVuZMC4mo5
 zQsj9sxhCIYaSJggdaHVRlpMKl4o60Y8dE0m8jrFkra2SsNQn0Czbm7qYQfRpvuloFxA
 2s04qsB25/f3ribG0GFSLjVwuB2JUSUOe+Vkfib/TMSN2VMgd5PSJQWILMup5PcX5Acu
 GzYGnU8EMirKQVCLUX52Mef9sP5O2jnVi4ZIq8+ewA/uAKP5/d8dyDNkbA2L0OkQ+MxM
 JqqyjmjO7RGZLPPavy2tLJxtl8D9YUcbo5ZXV38MXN6jC2fvIFT9QGBp9H6wclfhhxep rA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38gpnd9qxs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 13:52:58 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14DDonda070308;
        Thu, 13 May 2021 13:52:57 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2177.outbound.protection.outlook.com [104.47.57.177])
        by aserp3020.oracle.com with ESMTP id 38gppb723w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 13 May 2021 13:52:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XqfLMJr4y8tZlTPlpy4Xy/AJ9YaCWgIlYcVRmbDDGK0BsziwUI0aI4ATNBAiKavxz8azCi6xnqak8goZnR8X3NvssaV8q52VwbjkdtGp0uyHhPvmd5q1G4xf686vS7oMc/mi/2maLvXDKkkQE5GsOvJxrBITSOywoEW39o+9JmuGLzVjWfYLAjVMz0ZwZCNf9eQJ1MYZ7u1MCXQsQAUsaX2c3XpjOLN55SVlGGZ3XU0WGciy+cnInxrhRdspT8KBal809mgnG8dpbA8Md/m4nagkjk8+uFgFtLPkQAF8i+077C0QBQ6QiozMtkjlSnaIE+Rz5Bf/S42pBWEL/vAwRA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D6KjdYWin8CccphBpLkLpAg6dVQ2yCiI/qHK3f/ETE=;
 b=Z+0Gt8Yd0M9Fuowl0WkEiIJ1HXNV+0zdMv/gmq4dEsZmmWQxqo4pZJFSCaLbOBddfLY7AlfeMI0ik1czptli8AIxqM/WyrsWzvpoEQ/ycO/1pwZGy1qZjjDmI+lTBSHHj7kGZ85B5CngbgnaPk1BZJMkDAcHJHwxtcaDWA/fUK+COwdyMpyDZYJl1tMMRArpwQXdgezRbw1Lut2pk3crAiFYy+2Towsj3wxDudzIp6Sps7T3HzrbjZH02kYBwbCEChjTXDjNo9pAFPYgy3nqkxwaFhLykDvlonmoei4FbAbgl45kAYbALtrR8nqnpFSGQK/0O+jMrKeLGZLm32anqw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6D6KjdYWin8CccphBpLkLpAg6dVQ2yCiI/qHK3f/ETE=;
 b=t0iGLIkJuCPQuWoPUE0zYM+8qR99WQ+/VKtBbNqfTOLzm+MuYrkYEsr+7QDrs75n77uIOrGo6lNRAbm1tcSfpKhl8gL65Mk7Q2R2Metb34WhJS00UuTBvfX/2VD0Jx1jB9ZJfbR4x6D+b1y0m5/GnR3/qNz6rJQUCuRFuMtzwQg=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4682.namprd10.prod.outlook.com (2603:10b6:806:110::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Thu, 13 May
 2021 13:52:55 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::168:1a9:228:46f3%6]) with mapi id 15.20.4129.025; Thu, 13 May 2021
 13:52:55 +0000
Subject: Re: [PATCH] scsi: target: Avoid smp_processor_id() in preemptible
 code
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>
References: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle
Message-ID: <d3b4500b-f61a-bf89-f2c0-2b1239c57755@oracle.com>
Date:   Thu, 13 May 2021 08:52:53 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.10.1
In-Reply-To: <20210513044944.1572404-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [70.114.128.235]
X-ClientProxiedBy: SN6PR2101CA0030.namprd21.prod.outlook.com
 (2603:10b6:805:106::40) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [192.168.1.12] (70.114.128.235) by SN6PR2101CA0030.namprd21.prod.outlook.com (2603:10b6:805:106::40) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.3 via Frontend Transport; Thu, 13 May 2021 13:52:54 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8fcd0ba6-d281-4d52-eb55-08d91616688c
X-MS-TrafficTypeDiagnostic: SA2PR10MB4682:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SA2PR10MB46821C844B5898E7C14C8B49E6519@SA2PR10MB4682.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qtbunh3UbsQlOt+PvwXkGSEJQEXKbPr2QipI3H1wIqjBHLStPIjPsJQHMFjFzqmTaT54KymVUhZhwBMRsm2k1BGvdvC72dgWDNsdMbez0oQaMpdCSfxWl3FnU8TIlV/uHmsl09fWqhg0pa4UdcgzKH52qJJndEOkVv2d8IMzUwLWwlflOTfVyUexUIo/fHGlg8e9UxzlX66bENAlZaS+9cp3A1yUdY+YxZAaE28kimfaeP3mbSvl7NHY+UKbfTKAS0DVxmhfu297jKwE3XB9hQwWQ2fK9eWjbnEvtk2VnxEhWNhaEDHYpCcJUDX294NRvc9vnggQRCN/nZ4fzlKjIUhwIEDIq/HYjNdG3Dcl+pihrSbTTG9qRuNQ45b4koXOQE6rCgMSjSjG2mDOMMqmOCaEck6RJQFjhc8cGItrU/6WduFbf2yiJyThI5haKEHv2GOAvCmvPvIb7kUStTWB4eajROjOzF7Vj67MIc6WeV1o8NmOKbBTBX0Qf21ihWN9iuDbN24xZHKVjbk/S34FNpRVmmjVj31mDd9Vxkhux1dRg0W7wuhCYb0ceScK618h5w07QI3j4IZKUqV3KN62gNJVGWw+vntsu0z421GP/mTyIl5nVby2k+uSGpoDFWuWBtAkf+roHbvNRtVDMFSaJK/4mga0ClrNivu41a7AE0Q+3X1cCL05oniHoyRoP/gs
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(136003)(396003)(366004)(346002)(478600001)(66476007)(8676002)(36916002)(36756003)(83380400001)(6486002)(8936002)(86362001)(66556008)(54906003)(4326008)(16576012)(38100700002)(956004)(6636002)(5660300002)(2906002)(26005)(53546011)(66946007)(31696002)(44832011)(16526019)(316002)(110136005)(186003)(31686004)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?cnpyazBlYjh3N01jK0JaTkkxQm85c3EvSWNvSmpCdG1YY0RRWlEwQ2kwNzVO?=
 =?utf-8?B?QndoT200cXhTTmsyN0doaWhjNTVQVW9RYnpLZ1JmbUVOL09LNzJUSVkrOVZv?=
 =?utf-8?B?V2lCcU00V05pTUJ4STRudnIwYlhIeFJOOTBnZkRaUE5ScGczZFJSU0hrLzB3?=
 =?utf-8?B?UXUrek5XdGtwdkxvV2lmR283YXA5amdJY1RhVmsyRlQ3cUJyYWVva0NVdWZl?=
 =?utf-8?B?bVgyek0yLzdVa1Npa1UzRmxqNU5zcDRTeDBUZ3FjK1A4UmEzd1JUMTY0d3Fa?=
 =?utf-8?B?bmlZejlNRFJKdDdRaklwYlcrc204dWhuTTFBZGt4UVN3VTZrNUhoTTkyUm53?=
 =?utf-8?B?WTUxNTFWOUhoaTJJb0ZycXBkK1lZWHljYXNpUVFLbGxrRm4vdS8vWTFGSVB3?=
 =?utf-8?B?aW8vaHdIZU5HcEVydmZuV1k4K0NiVXdGQ1J4ZjBhbEQxaUl6emxkNklnZElp?=
 =?utf-8?B?K0lpTGF0TVVWKzdaS0RxbmVvQmdUN0srVnM1eGlVaVA0dFVkN2UwVHBnaUxz?=
 =?utf-8?B?WFNBdkxjWjJJN2Vvck45NWt5VXhOK2RHeXFxRFBaamNKS0IxelZTNDltUUZT?=
 =?utf-8?B?MnJZUkI1eEdXU040d25WZkErbGR0QWxMOERxY1dzdTlLMTlGZFQrSVRuaG5O?=
 =?utf-8?B?TmJxSDRuYmpMaDNGYk4zS0xoT0plcm9CS3ozNVlxQnQ2dURBOVZINEEwUUN2?=
 =?utf-8?B?bkpaYWtnMzZ6U1Y5Q1JVNWhUZEFVcjN5N21KREwreklvZFdqRHdvYTBjR1Mw?=
 =?utf-8?B?OVpGcVFkcTRFWXVNL3ZmMTdacTBHbFdYVGwzOU53WTE1N09XUGNoYVRqbThv?=
 =?utf-8?B?MTVwSHRyVTVEY2hjUTlxNExLbFMzYUIvbUo3M1NLRUd6OFFEUVg5MXVQR0p3?=
 =?utf-8?B?bStCOHo4ZitXQm9BRkxhOE44SVp6WWFTTmJSYTJzK1R4azU2NnpEd2dmQVM1?=
 =?utf-8?B?NG1obkM1OEhua2NvczZURDlIMDBIeUFYTWduTkdhVzR6emFKTXdnSHpsdDhN?=
 =?utf-8?B?blQ0US8rSGNTR3BmdWgySWEwZnRMcUh4bzlMbXZGYTI3bko5MmVQaWRMM2h6?=
 =?utf-8?B?NnlGc2lRMHl6L3J5S1NmQmRoc1p0cC9WSlFtbnB1dFg2T05JRG9Ld1BLUHRu?=
 =?utf-8?B?a3ZDK1FPT0gzaXFCZFpOWUp3cFR6MzVlekhiNW9IOFMvY0tzVTJEdGF1dTZy?=
 =?utf-8?B?TUFyNG9Wdjl5Ry9JMm9TN2FNR3EyMzFQVC9TdGxESUoxajIwWUlnZmNiUmds?=
 =?utf-8?B?bGhRbDF1cGVOYXJ5bzhscEllMVFOZ09mRTVjZmFZc3BaTE9WZThhSnhWUi9B?=
 =?utf-8?B?eHFQTEtqMnZjSGhzRi94bmFuc2o2U0RyeER5VFpHQ0F3VUw1N0VQdVB4K3p5?=
 =?utf-8?B?UEVSVGpPMExRbjAyOFdzeFFjTDFmajhtL3BLRFRpbjBJTTg0Z200aS91UUJX?=
 =?utf-8?B?ajBJcHdxUVRaV1UycWhMZEpvTitRckMydGs5Ujd5c0owSWw4ZkJKWkxtMGVu?=
 =?utf-8?B?Qlk4SEJHYWI3SStqTlpoMk5aUlBLOGRrTW5aZGRMZHhVaENOZHpiVForeG11?=
 =?utf-8?B?VnlTck85Qm5odzFzZWc3M1NKT3ZTUm1SSHFZZjVxZXF5NjVvRXkxb3JRcmNC?=
 =?utf-8?B?UmJBdzBEUk0zdDNoc3hzMUQ3WmdkVHo5dUUwQkl4RVJqODRTSGNvdmEvYmFk?=
 =?utf-8?B?MGhSWjhONTRmUS9lZFhocE81MGc4NFJ3OTdVeFBMRWJPZWtMdzI5SGJWZlNK?=
 =?utf-8?Q?E47m9Wk/AUZf4tPWquhKXj8NsWWS1j+OZYhoUEg?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8fcd0ba6-d281-4d52-eb55-08d91616688c
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 May 2021 13:52:54.9842
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Gxyyfcz34HUz1qy4tis9iyotFwiUkso9HLuNE3y4kftWH5h6k+bazKDC6kP7TPfsgjxavIZ8rIo2fEC9jECMNiirOI7501yIvhG6tAdMtaA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4682
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 malwarescore=0 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105130103
X-Proofpoint-ORIG-GUID: pDnjrYeCmk-aZ3Jl2G6HhtUvcgQNE3D2
X-Proofpoint-GUID: pDnjrYeCmk-aZ3Jl2G6HhtUvcgQNE3D2
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9982 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 phishscore=0
 priorityscore=1501 suspectscore=0 spamscore=0 lowpriorityscore=0
 adultscore=0 clxscore=1011 mlxscore=0 bulkscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105130103
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/12/21 11:49 PM, Shin'ichiro Kawasaki wrote:
> The BUG message "BUG: using smp_processor_id() in preemptible [00000000]
> code" was observed for TCMU devices with kernel config DEBUG_PREEMPT.
> 
> The message was observed when blktests block/005 was run on TCMU devices
> with fileio backend or user:zbc backend [1]. The commit 1130b499b4a7
> ("scsi: target: tcm_loop: Use LIO wq cmd submission helper") triggered
> the symptom. The commit modified work queue to handle commands and
> changed 'current->nr_cpu_allowed' at smp_processor_id() call.
> 
> The message was also observed at system shutdown when TCMU devices were
> not cleaned up [2]. The function smp_processor_id() was called in SCSI
> host work queue for abort handling, and triggered the BUG message. This
> symptom was observed regardless of the commit 1130b499b4a7 ("scsi:
> target: tcm_loop: Use LIO wq cmd submission helper").
> 
> To avoid the BUG message at smp_processor_id(), use get_cpu() and
> put_cpu() instead which disable preemption.
> 
> [1]
> 
> [   56.468103] run blktests block/005 at 2021-05-12 14:16:38
> [   57.369473] check_preemption_disabled: 85 callbacks suppressed
> [   57.369480] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1511
> [   57.369506] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1510
> [   57.369512] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1506
> [   57.369552] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369606] CPU: 4 PID: 1506 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.369613] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.369617] Call Trace:
> [   57.369621] BUG: using smp_processor_id() in preemptible [00000000] code: fio/1507
> [   57.369628]  dump_stack+0x6d/0x89
> [   57.369642]  check_preemption_disabled+0xc8/0xd0
> [   57.369628] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369655]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.369695]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.369732]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.369744]  scsi_queue_rq+0x38e/0xc40
> [   57.369761]  __blk_mq_try_issue_directly+0x109/0x1c0
> [   57.369779]  blk_mq_try_issue_directly+0x43/0x90
> [   57.369790]  blk_mq_submit_bio+0x4e5/0x5d0
> [   57.369812]  submit_bio_noacct+0x46e/0x4e0
> [   57.369830]  __blkdev_direct_IO_simple+0x1a3/0x2d0
> [   57.369859]  ? set_init_blocksize.isra.0+0x60/0x60
> [   57.369880]  generic_file_read_iter+0x89/0x160
> [   57.369898]  blkdev_read_iter+0x44/0x60
> [   57.369906]  new_sync_read+0x102/0x170
> [   57.369929]  vfs_read+0xd4/0x160
> [   57.369941]  __x64_sys_pread64+0x6e/0xa0
> [   57.369946]  ? lockdep_hardirqs_on+0x79/0x100
> [   57.369958]  do_syscall_64+0x3a/0x70
> [   57.369965]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [   57.369973] RIP: 0033:0x7f7ed4c1399f
> [   57.369979] Code: 08 89 3c 24 48 89 4c 24 18 e8 7d f3 ff ff 4c 8b 54 24 18 48 8b 54 24 10 41 89 c0 48 8b 74 24 08 8b 3c 24 b8 11 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 31 44 89 c7 48 89 04 24 e8 cd f3 ff ff 48 8b
> [   57.369983] RSP: 002b:00007ffd7918c580 EFLAGS: 00000293 ORIG_RAX: 0000000000000011
> [   57.369990] RAX: ffffffffffffffda RBX: 00000000015b4540 RCX: 00007f7ed4c1399f
> [   57.369993] RDX: 0000000000001000 RSI: 00000000015de000 RDI: 0000000000000009
> [   57.369996] RBP: 00000000015b4540 R08: 0000000000000000 R09: 0000000000000001
> [   57.369999] R10: 0000000000e5c000 R11: 0000000000000293 R12: 00007f7eb5269a70
> [   57.370002] R13: 0000000000000000 R14: 0000000000001000 R15: 00000000015b4568
> [   57.370031] CPU: 7 PID: 1507 Comm: fio Not tainted 5.13.0-rc1+ #34
> [   57.370036] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 1302 03/15/2018
> [   57.370039] Call Trace:
> [   57.370045]  dump_stack+0x6d/0x89
> [   57.370056]  check_preemption_disabled+0xc8/0xd0
> [   57.370068]  __target_init_cmd+0x157/0x170 [target_core_mod]
> [   57.370121]  target_init_cmd+0x76/0x90 [target_core_mod]
> [   57.370178]  tcm_loop_queuecommand+0x109/0x210 [tcm_loop]
> [   57.370197]  scsi_queue_rq+0x38e/0xc40
> [   57.370224]  __blk_mq_try_issue_directly+0x109/0x1c0
> ...
> 
> [2]
> 
> [  117.458597] BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u16:8
> [  117.467279] caller is __target_init_cmd+0x157/0x170 [target_core_mod]
> [  117.473893] CPU: 1 PID: 418 Comm: kworker/u16:6 Not tainted 5.13.0-rc1+ #34
> [  117.481150] Hardware name: System manufacturer System Product Name/PRIME Z270-A, BIOS 8
> [  117.481153] Workqueue: scsi_tmf_7 scmd_eh_abort_handler
> [  117.481156] Call Trace:
> [  117.481158]  dump_stack+0x6d/0x89
> [  117.481162]  check_preemption_disabled+0xc8/0xd0
> [  117.512575]  target_submit_tmr+0x41/0x150 [target_core_mod]
> [  117.519705]  tcm_loop_issue_tmr+0xa7/0x100 [tcm_loop]
> [  117.524913]  tcm_loop_abort_task+0x43/0x60 [tcm_loop]
> [  117.530137]  scmd_eh_abort_handler+0x7b/0x230
> [  117.534681]  process_one_work+0x268/0x580
> [  117.538862]  worker_thread+0x55/0x3b0
> [  117.542652]  ? process_one_work+0x580/0x580
> [  117.548351]  kthread+0x143/0x160
> [  117.551675]  ? kthread_create_worker_on_cpu+0x40/0x40
> [  117.556873]  ret_from_fork+0x1f/0x30
> 
> Fixes: 1526d9f10c61 ("scsi: target: Make state_list per CPU")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> Cc: stable@vger.kernel.org # v5.11+
> ---
>   drivers/target/target_core_transport.c | 6 ++++--
>   1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 8fbfe75c5744..9ed5d234acd8 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -1415,8 +1415,10 @@ void __target_init_cmd(
>   	cmd->sense_buffer = sense_buffer;
>   	cmd->orig_fe_lun = unpacked_lun;
>   
> -	if (!(cmd->se_cmd_flags & SCF_USE_CPUID))
> -		cmd->cpuid = smp_processor_id();
> +	if (!(cmd->se_cmd_flags & SCF_USE_CPUID)) {
> +		cmd->cpuid = get_cpu();
> +		put_cpu();
> +	}
>   
>   	cmd->state_active = false;
>   }
> 

Looks Good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                               Oracle Linux Engineering
