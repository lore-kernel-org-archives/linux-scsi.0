Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E896C4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 10 Dec 2022 18:49:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229722AbiLJSs6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 10 Dec 2022 13:48:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229721AbiLJSs5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 10 Dec 2022 13:48:57 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6C9C11827;
        Sat, 10 Dec 2022 10:48:54 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2BAFwOOE020026;
        Sat, 10 Dec 2022 18:48:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 from : subject : to : cc : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=4f5NRJrXYCrMNeMJ6lpPJNR39zJqGqzDvpskBfMHJT4=;
 b=UC/+017RyEMiql1v1RUt32ohHBrUgz2R/qBBP0o8090uOrv7IpJqy0v/x1KOGIgrEjrb
 7AaGOexjsp5PG3exKLSmxzEULgWRPrj9yyLXRcasddtPK7g5eWboTS6wl07sewtpRDGc
 KMeKteLzdF5sap/eWNbAbDQgeADa9RffOLCwN0ZD+/5g8NGPOdIeQp6b7cgpG0V3DGZQ
 KjeFj1CuKezOJdjcYTeWG9pObsA4+EmBeS6tCYtTA/JfN8u80HK3LcTHg5gTaqobsAUB
 U8AbSP1AH5BTuM0DVZWUqmSdMasfAlaLZwyVmjeKnuT7uB8Pi1bzc5nPC7D7fLNjpqE0 xw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3mcghcgmr4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Dec 2022 18:48:52 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2BAG81LI005897;
        Sat, 10 Dec 2022 18:48:51 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3mcgj1xyet-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 10 Dec 2022 18:48:51 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cIQwVv+M4nDDwtfvqeOxRa2zbQd6XI9zzOibm1BQB7RqEAqHzV8y3mFQRbEaorUp+XA2McWJgGxzsgnLgamsYEEHidKh8Hu/91U4buNJg+8iQQMkfVyGFPXC27ZoBHc/P0mlC/y6TuFg6bmR0lkFhuRcW8hsAlLxFBQVdATGbhcjwuTCj+paJdDQmxQzZPYvDZlc8cQFtr//uEKF7/7V3RwLHOm4kkn9BChHMjpLSWZ5Ya4Evw5kDHWWfyUNMzb7HHsNwcRUsZh5rORcJgaIt8jTuVj+B6cyPusCn8m1ohu+UoukmsCfDTyYCNA3hWotd5vEMztJqx8lRIfxvQSWQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=4f5NRJrXYCrMNeMJ6lpPJNR39zJqGqzDvpskBfMHJT4=;
 b=UzKgCw4zhhh6rn0jzrLtvZSpzEYASzugpEdhZZMNYSPwzgnHGJYnm/CsqF7iKCaaNEH7ygTLRQnfMFxvgU3+CrEMeea7ejCwXjdHRIPJpP2ZCSiDiWi6B/7LfQ4hMvZsfvGFGgfVx5VF3+FL3ZIG3vvUsYqnuO2bZ0MBvGHLiODP9DUWs3IB9IIMBKyjarWPMD5hzfQ0HMYMgFm/eSn2LFA2wT4oMoIR/Jbw8Ry77SbTP6q9yctsVrlAQ6+3KQ7IeA7UiJAb91Mb52mssdT2w4Q+wqBKSAyKAa8WFKzpF/98ncSoC4lsb1YvuGk1bihD74KnABJspK3uZKFW0/IXxw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=4f5NRJrXYCrMNeMJ6lpPJNR39zJqGqzDvpskBfMHJT4=;
 b=Rpmzpl2m70CQLrcqRjK04z9zXXPgB1Hu9gQQZ1Gm5MxVuxeme0RiNVhTuuiUpY/V9TtjLR8mqFmHnsg9bi/dh8RufXK6947i2pstJmth+0qlVqXO4MCArD+KKDX0sfOrVYLTkLmW0YW9gobQFEYcsxe+cmJZt24ppWLFNhO8B+c=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB4647.namprd10.prod.outlook.com (2603:10b6:510:43::22) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5880.19; Sat, 10 Dec 2022 18:48:49 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::2dbb:4791:5a67:4372%7]) with mapi id 15.20.5880.019; Sat, 10 Dec 2022
 18:48:49 +0000
Message-ID: <5282eea8-6648-4573-057b-7350955b2368@oracle.com>
Date:   Sat, 10 Dec 2022 12:48:47 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
From:   Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH 5/7] scsi: target: iscsit/isert: stop/wait on cmds during
 conn close
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     mlombard@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-6-michael.christie@oracle.com>
 <20221209123202.GD15327@yadro.com>
Content-Language: en-US
In-Reply-To: <20221209123202.GD15327@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR20CA0017.namprd20.prod.outlook.com
 (2603:10b6:610:58::27) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH0PR10MB4647:EE_
X-MS-Office365-Filtering-Correlation-Id: a78f863b-7404-4f30-dcb6-08dadadf2c99
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nbe6V/PThtP4Ncy+OG9YiLPIrJKG+VpCHZLkd5wxlOO0NekNrkVzqWBZx7GUU+xKMatHpngAQ0MaXyupeTEpHAEqWOrson21Tga53iJZXMhQRegMKedyhD/m5MvTjQmc5CrW2rnUOdUoICzIKBudwDJRop9ukAT2uqbwpT4TMLzWPlHE35ptImjomC0kLlkujAOu9Mfn2h2U49niy/LFgXvp4In4ofANBc2B1WMFbMoOfQ+kFV3dMaLkWCYTwb9n76tF0Ih5BlOCHJWrDCzz3JzT72Msi1RmpUi+Vma/qpmvuNuGKa/mbGjbWN6tNuuHsM7zBHyQMRMiIvdd9f5oUXYdlctJH1fenvZYFYOi3TPUjlZsXAuKfPoHvwbpoMJMyCVz8T4KRRjDXj+i9b+/M4LXmMtfRXCd682titI/q+ydCc7oGSNMsQYuFs0OtugHmf8KAns0K0H3bb2zTAStLEio7/Vn2fzF75cAmndXGn4WGnhMnJoiAw3jNBYAATnA6EvGmZOWWTOdNERx5fLO1kqQiSq5iX5DroMNlK/GFsDyc84gjg0LA+gpoJSy/xQNCtseB70CRtbQo4Ysn6LQkeOqZjaCVfhE9itEwbsGLvKGsP0iPtVaneaLWOTQyzGdMOH6IFsdd3lT3HxBv4kxoAQ4bwTbyiC1Z0mZD/iWEMlr87XDywkkUDvATxykI+SZa2gALtJ65GmovxyTEE/YVRrJquNAVCwWsysqDM5iyxdfIm7+jho1HepL9guYhhSy
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(346002)(39860400002)(136003)(396003)(376002)(451199015)(45080400002)(6486002)(478600001)(966005)(31686004)(66556008)(66476007)(8676002)(4326008)(316002)(26005)(6512007)(41300700001)(6916009)(8936002)(53546011)(6506007)(36756003)(5660300002)(2906002)(38100700002)(86362001)(83380400001)(31696002)(186003)(2616005)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a2UzVlhPWW92Zm0yRVhaemdPVzJRT0luVDBvOS8xRkNCcFVkV21ZL3RlSXlZ?=
 =?utf-8?B?TTdlclZOdnRQTVpzRzNTWThOQ29CY2NrQW1ZVHZ4L1RTK2ZGbXVKMFVWVHlR?=
 =?utf-8?B?SERZUUs4YThWT3BraGpvZGhtKzVaS1NqTjZvcncvLzFkTHFNMVJBYlM2UFZC?=
 =?utf-8?B?Nlh6dUlZSzVIMUkybkZhNHN3dTlTOXRHM20zTkYwWkxOaE1FRG1Oc3VBNGJx?=
 =?utf-8?B?TlcwSGdOMVcwUVAzRm13SVRpKy96dHhLeElNZHM4QUN1Wk5QUm9adEhCb0xY?=
 =?utf-8?B?dUdkY2UwL1FkR2w5d0lNK3FLU3hZMFEya3hLbGhEVjE5eElGSEliQlJpWXFj?=
 =?utf-8?B?dTlUYmdlNEw1blBUUEJvbHp1dlZPRVJ0UEUwWkxjd0tMWEg2MFFIYXpHcFJD?=
 =?utf-8?B?Nm5Ma1Y4cDdEZWttdHBRK1VqT3g5Tyt3SDZHdDNuWVU3L3BvSnZzb1NZcjBG?=
 =?utf-8?B?b0pIblZlQ3prVm5ZVlF6SE5maDM4UzFwRVdLcXIxWStzclRRN21BUzBFR0d2?=
 =?utf-8?B?QUdHaVdGOU5vcmNkVDhPOTVyaWpnclhkY0xPN3AxeFZHcVBwNmd3bzhBeFFI?=
 =?utf-8?B?ZC94alFLaFM2cFdnbkdsSkZQcDZKWldvcmVIc1U2d2p5TlpxTEJQaVlJTE9k?=
 =?utf-8?B?N095Kzg1NXJjTnV6WHZKb1lDS3VBR3dxY3krWkt4WUQyZk95NkdwMjUzL0Vn?=
 =?utf-8?B?SVZtTjlwSjhUMXV3aThLaCtzUjhMZmlhWERKY3NyKzV5RnVxY0xxSy9EVVB1?=
 =?utf-8?B?V1VudjdGQ2ZLVWpiOTlaQUlXWGZGdDhibE9tNHFJeTZIbE1RVnFtME9nZGgz?=
 =?utf-8?B?cDJOVytIZXBWMWdMT3dMSDlpQVFlY0VBUHhjNG5aNVkvRkc2ZW9aWDhraGRS?=
 =?utf-8?B?WU1PNVlOWjJTQWZMa09pYk5VM1Z3UWRicjdncWhtT2V4bjhEYVI4NVVEN0E3?=
 =?utf-8?B?QmtHU05NWUE3dWc1V3hrM0xuamhHcnQrWm5mQzh5Y1lIOG13QnBXTFErTHh4?=
 =?utf-8?B?OG1ZRVFGamZtVlBGY3hjcDdhK2lOOFNUVHJTVEowVkZqL25EWXU3S2J3U2Vt?=
 =?utf-8?B?OWt1WGRlQWZVclpGT0pvZ1FNZVdPWThUL0ptS0xUUjlvb2EyRk5JREZiUWJm?=
 =?utf-8?B?V2w4MDlNSEltdmxTZUU2WnliWmxCNWk3eE1xTEY0a1hEYUdqeG1BekVxS2lk?=
 =?utf-8?B?WHR6VCtLUXRzVFlvbDV6dVZ2SDBmQ1BxSEdabG9Xbkp6bVlCUFVsb1o0UTM5?=
 =?utf-8?B?Ny9qZjlDenhpOTVwUExCdVdleXAxVzl1UzRYYTZlRVlHOUF2ZVNjSFdTalMx?=
 =?utf-8?B?VmR0WXJkMTlXVC84cnpJNTV4dkFKVFlJdHNCM1hYYUdtOUJnWlNOcmcvNW9Q?=
 =?utf-8?B?aUFBUjBVeFZmUSszeEVETEs0dW9LY2p6U3ZWRnFtMHE0Z2w2YjNDSGNGRUk5?=
 =?utf-8?B?Z2FaalhKSlBFdkRhc3UyRGQwTXJ4eVl2Mnp3MHFXWnpZWjVicURDbW9mK0Zj?=
 =?utf-8?B?NXBQSDdwSHhwVHhsaEsyZC9vZkhIdDhHdWlCeDF3YUd3ZThtdTMwYTAzYUFI?=
 =?utf-8?B?Vm9OUVk3YTRURWIrcGpGYmhVY0RZcUR3Yy91cFc1SVhsczJwaTdRakRBRDlx?=
 =?utf-8?B?N1ZJL0p5VUF5V2o1WGVDRVJsVFZwUG5NVDAvSjVNMWRnWWRDQ0xpY1NTMWFZ?=
 =?utf-8?B?RHpCSXhhbm1lUVJoSXJQK1F3UFJlVTdISzRlRjFzODhTQkV0R3lrWUJySlhW?=
 =?utf-8?B?NlNxaWtzaEUyNWNramtUNExzY09VQUY1ZXpnMWE3djRuNWR2U2tIRi9ySUVB?=
 =?utf-8?B?bzBibmtMYkU0WFZ0NVg0Znh3ZXZiSFJYTml5MWczcXlpQTNEZlVNU2luRTVk?=
 =?utf-8?B?aS9rL3BCV2NKUmQzc2NWMmZ6b2JhaHVmdVB2Yk4vcVRaM3lid2pZMHYvaDdH?=
 =?utf-8?B?aUo5N3gxSTBYNzRlb2RxanJ0UDdzSWs4dE14MU9pVHV0UjY2SWd5ZGlJTnUz?=
 =?utf-8?B?d2NoLzI1VE1ZdDd4RVI4aVU3SlVsYWtaRnVMTk9ESXhZeXFJRSthclM1QTMz?=
 =?utf-8?B?c0FJZnRodDRNc0l5dStxUXFYc0Zua09NZDRQNHpXN0tiZjc3VVhNdGp1RjRB?=
 =?utf-8?B?YjAxWTIwTHdjQzAyekxZc3YzMkVBcHpjOFh6UmxWMUFIdi9FenphdVZ6RTZh?=
 =?utf-8?B?Z0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a78f863b-7404-4f30-dcb6-08dadadf2c99
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Dec 2022 18:48:49.0001
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: YBWcfK2gTgISYAkzAblwP1rztREdAcnM5GsvGtQrsdV1QRxqNFDqbM49OwdhPgqBFgKcsAjwPHtDOS9Qv6jtBokctNTDmq/08V5Mcpa0xq0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4647
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-10_06,2022-12-08_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 suspectscore=0 mlxlogscore=999
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2210170000 definitions=main-2212100172
X-Proofpoint-ORIG-GUID: V3VG9k8Qzg3F_t7M3oCfgnStBFnbVNRP
X-Proofpoint-GUID: V3VG9k8Qzg3F_t7M3oCfgnStBFnbVNRP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 6:32 AM, Dmitry Bogdanov wrote:
> On Wed, Dec 07, 2022 at 09:10:00PM -0600, Mike Christie wrote:
>>
>> This fixes 2 bugs added in:
>>
>> commit f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop
>> race")
>>
>> If we have multiple sessions to the same se_device we can hit a race where
>> a LUN_RESET on one session cleans up the se_cmds from under another
>> session which is being closed. This results in the closing session freeing
>> its conn/session structs while they are still in use.
>>
>> The bug is:
>>
>> 1. Session1 has IO se_cmd1.
>> 2. Session2 can also have se_cmds for IO and optionally TMRs for ABORTS
>> but then gets a LUN_RESET.
>> 3. The LUN_RESET on session2 sees the se_cmds on session1 and during
>> the drain stages marks them all with CMD_T_ABORTED.
>> 4. session1 is now closed so iscsit_release_commands_from_conn only sees
>> se_cmds with the CMD_T_ABORTED bit set and returns immediately even
>> though we have outstanding commands.
>> 5. session1's connection and session are freed.
>> 6. The backend request for se_cmd1 completes and it accesses the freed
>> connection/session.
>>
>> If session1 was executing only IO se_cmds and TAS is set on the se_cmd,
>> then we need to do a iscsit_free_cmd on those commands, so we wait on
>> their completion from LIO core and the backend.
>>
>> If session1 was waiting on tmr se_cmds or TAS is not set then we need to
>> wait for those outstanding se_cmds to have their last put done so we
>> know no user is still accessing them when we free the session/conn.
>>
>> This fixes the TAS set case, by adding a check so if we hit it we now call
>> iscsit_free_cmd. To handle the tmr se_cd and non TAS case, it hooks the
>> iscsit layer into the cmd counter code, so we can wait for all outstanding
>> commands before freeing the connection and possibly the session.
>>
>> Fixes: f36199355c64 ("scsi: target: iscsi: Fix cmd abort fabric stop race")
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/infiniband/ulp/isert/ib_isert.c | 13 +------------
>>  drivers/target/iscsi/iscsi_target.c     | 13 ++++++++++++-
>>  drivers/target/target_core_transport.c  |  6 ++++--
>>  include/target/target_core_fabric.h     |  2 ++
>>  4 files changed, 19 insertions(+), 15 deletions(-)
>>
>> diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
>> index b360a1527cd1..600059d8a3a7 100644
>> --- a/drivers/infiniband/ulp/isert/ib_isert.c
>> +++ b/drivers/infiniband/ulp/isert/ib_isert.c
>> @@ -2501,17 +2501,6 @@ isert_wait4logout(struct isert_conn *isert_conn)
>>         }
>>  }
>>
>> -static void
>> -isert_wait4cmds(struct iscsit_conn *conn)
>> -{
>> -       isert_info("iscsit_conn %p\n", conn);
>> -
>> -       if (conn->sess) {
>> -               target_stop_session(conn->sess->se_sess);
>> -               target_wait_for_sess_cmds(conn->sess->se_sess);
>> -       }
>> -}
>> -
>>  /**
>>   * isert_put_unsol_pending_cmds() - Drop commands waiting for
>>   *     unsolicitate dataout
>> @@ -2559,7 +2548,7 @@ static void isert_wait_conn(struct iscsit_conn *conn)
>>
>>         ib_drain_qp(isert_conn->qp);
>>         isert_put_unsol_pending_cmds(conn);
>> -       isert_wait4cmds(conn);
>> +       target_wait_for_cmds(conn->cmd_cnt);
>>         isert_wait4logout(isert_conn);
>>
>>         queue_work(isert_release_wq, &isert_conn->release_work);
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 7a8ffdf33bee..1c3470e4b50c 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -4221,7 +4221,8 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>
>>                 if (se_cmd->se_tfo != NULL) {
>>                         spin_lock_irq(&se_cmd->t_state_lock);
>> -                       if (se_cmd->transport_state & CMD_T_ABORTED) {
>> +                       if (se_cmd->transport_state & CMD_T_ABORTED &&
>> +                           !(se_cmd->transport_state & CMD_T_TAS)) {
>>                                 /*
>>                                  * LIO's abort path owns the cleanup for this,
>>                                  * so put it back on the list and let
> 
> Could you please extract ths snippet (fix of the hanged commands with
> TAS) to a separate patch? It looks good.

Yeah.

> 
>> @@ -4244,6 +4245,14 @@ static void iscsit_release_commands_from_conn(struct iscsit_conn *conn)
>>                 iscsit_free_cmd(cmd, true);
>>
>>         }
>> +
>> +       /*
>> +        * Wait on commands that were cleaned up via the aborted_task path.
>> +        * LLDs that implement iscsit_wait_conn will already have waited for
>> +        * commands.
>> +        */
>> +       if (!conn->conn_transport->iscsit_wait_conn)
>> +               target_wait_for_cmds(conn->cmd_cnt);
>>  }
>>
>>  static void iscsit_stop_timers_for_cmds(
>> @@ -4304,6 +4313,8 @@ int iscsit_close_connection(
>>         iscsit_stop_nopin_response_timer(conn);
>>         iscsit_stop_nopin_timer(conn);
>>
>> +       target_stop_cmd_counter(conn->cmd_cnt);
>> +
>>         if (conn->conn_transport->iscsit_wait_conn)
>>                 conn->conn_transport->iscsit_wait_conn(conn);
> 
> I strongly believe that waiting for commands complete before decreasing
> the command refcounter is useless and leads to hangings.
> There was a several tries to wait for the commands complete in the
> session. But all of them were eventually reverted due to iSER [1].
> [1] https://lore.kernel.org/all/CH2PR12MB4005D671F3D274C4D5FA0BAEDD1C0@CH2PR12MB4005.namprd12.prod.outlook.com/
> 

Yeah, I saw those. It's why we have the stop+wait split and why I left
the isert target_wait_session where it was.


> Let's try it one more time - move conn->conn_transport->iscsit_wait_conn(conn)
> to the end of iscsit_release_commands_from_conn() to align iser with other
> iscsi transports.
> 
> Probably, to have target_wait_for_cmds as a default .iscsit_wait_conn
> implementation would be the best way.
> 

I think we have to do that in another patchset because this was meant
to just fix the 2 regressions (that cleanup patch does not have conflicts
so no need to backport it). What you want to do is not going to be as
simple as just moving that call around so we can't sneak it in.

The iscsit_wait_conn is where it is because it does 2 things:

1. The issue with Bart's patches was isert doesn't submit commands to lio
from the iscsi rx thread so killing it or running iscsit_close_connection
from it doesn't prevent new commands from coming in like it does for iscsi.
For isert you have to disconnect the connection before cleaning up so we
don't get new commands while/after cleaning up.

2. Because isert submits from the ib context we have to do a flush like call
to make sure it's not still running similar to how for iscsi we kill the
rx thread then do the cleanup from the tx thread (or the reverse depending
on which thread starts the recovery). So the target_stop/wait_session did
that for the driver.

The current code works for iscsit because we send/recv from the tx/rx threads.
If we recvd from the sk_data_ready callback then we would have a similar
problem as isert.

So we have to do:

1. Add a new callout close_connection which for isert does this
initial disconnect cleanup and is called before iscsit_release_commands_from_conn.
Bart's patch added a close callout but called it was called too late.

2. The target_stop_session calls acts as flush right now. When it returns
we know the ib layer is not calling into the iscsi/lio layers anymore. We need
something to replace this.

3. We can then do target_wait_for_cmds after iscsit_release_commands_from_conn
for both drivers, but, we might need some more changes. See below.

When we do iscsit iscsit_release_commands_from_conn we are:

1. Waiting on commands in the backend and LIO core.
2. Doing the last put on commands that have had queue_status called but
we haven't freed the cmd because they haven't been ackd.

Are we hitting an issue with #2? We need a proper bug and analysis or we are
just guessing and am going to mess up.

For example, for isert is the bug you are worried about that we have a missing
isert_send_done/isert_completion_put call because we disconnected before the
send callbacks could be done or because the ib layer won't call isert_send_done
when it detects a failure? If so then yeah, the current code is going to hang
since nothing is going to do the last put on the session since that's done later.
To handle that we will have to move code around so we do isert_unmap_tx_desc from
iscsit_unmap_cmd or do something so we don't leak those resources.
