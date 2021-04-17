Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9CFC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 17:27:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 506F06109F
	for <linux-scsi@archiver.kernel.org>; Sat, 17 Apr 2021 17:27:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236820AbhDQR11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 17 Apr 2021 13:27:27 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:43396 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236777AbhDQR10 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Apr 2021 13:27:26 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13HHQ6YQ025236;
        Sat, 17 Apr 2021 17:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=eaaIR2e7YJT3u3dhhcr2FLZROleh1RCrhi9mVAU5BWY=;
 b=BpCoZUssByea3V7omUkFPN+n6vPCLcH/fjJAPzTex+NljwABckI203yvsfDvW0jbzHw8
 F2a2vvIrdn97jdUxgsyCVAgSDgm8wNhzCeURKW9+Smin/G99ZZ1i8W3XSiCiEz9harpQ
 sa35b8KYi/syEK0+bbJNv+4cEM1EzhAV2IubeMCVgeYUcLV6kqDyy5unsGALmIwFs3de
 Lc0qysU/8i6s/2IWLLY+BrA6ZKfV6MQUdZZd1WkbL5V9ixkzWoZmy+Mf61SDAbEwMTh6
 MaHU9W4OCA1ohHZ1uHvPyG/tUiZmFQ0F8Ed/Rt1XfWF7dF7pvPie6jwgzrHuUX6ghXVW JA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38022xr3eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 17:26:50 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13HHPun5152066;
        Sat, 17 Apr 2021 17:26:50 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2171.outbound.protection.outlook.com [104.47.55.171])
        by userp3020.oracle.com with ESMTP id 37yq0kda69-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 17 Apr 2021 17:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=EY02G84KNtFZHoqpWxf4FOqkmhI6gYLaKkDnJr6pGDaDurLDVLBU1vKqDfXlAhjyXyZwc3q1XCIwB89Mgi9GLTDLKKS3Zd2DD3bi5q3FWlpZjdQ7MzFio7uD4AYD4z/OIwIc1DK3sbgnk8TYKViueLdeO4NYLkJMieuDJzoRlsx+7ybH7gX0MJY5DQI8dHRZlHsGquglDzF0jMjgblYJrPBpTuB8Z7CAFdDevHPukK09dwhfMaZKyVP2hrZJyyDKjjpyR1bgRqPBwQh6Lwk1EuxlB10iXv34yRp03RKk6u2Fj78ojAhufZAEaHhl+z6vWdADTGD14gfdFYpYVze8wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaaIR2e7YJT3u3dhhcr2FLZROleh1RCrhi9mVAU5BWY=;
 b=MQkLATsPTzE+MD++ueJmOzwUq0exAQy/JHW6TgVpDnrsqxWTdJThH2JhkedwihW+o8F7fUlXWGcsRK8gLrXoyg8rtbYWEbmf96O8VQOaE5NAF7IBPN51AoActp2jHZ+KWVHv2aabJm/kdSEXQzY8bgHIch54Kh+fhHlgLQ8RmVc/RLEFgInXMcCKV4wSz2YAAnoJjnLxRm64SyE1Na1g7NlM7GqhLusOFVJf1MT/07QvZPsB9N1F4bTTLxVENW32/YyOSEG+lZkDMxavrdri1ylAd7DiHN6AQsCwRGQGFHMUWOAaWNGErjsXsRf0QlnLBIjD7lA1Xsi9zXggkVCl+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=eaaIR2e7YJT3u3dhhcr2FLZROleh1RCrhi9mVAU5BWY=;
 b=gbyiFGZ7PpunulBMeePKVVeNAzmzE4yj4ik1AOfMfpagbSZBfnISmBzAm1TURYGz0/mx/eUjEq+bhAbMwkKO5/ErBkqQsKW4agzt7cDnXsoEZnFqzIuxNqDtKgWxqo6Nb40hCVf9LLKCmjQGL83B2Kowit6SVcOgbeRG3qLYWiY=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB2583.namprd10.prod.outlook.com (2603:10b6:a02:b2::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.19; Sat, 17 Apr
 2021 17:26:46 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.023; Sat, 17 Apr 2021
 17:26:46 +0000
Subject: Re: [PATCH v3 02/17] scsi: iscsi: sync libiscsi and driver reset
 cleanup
To:     Lee Duncan <lduncan@suse.com>, martin.petersen@oracle.com,
        mrangankar@marvell.com, svernekar@marvell.com,
        linux-scsi@vger.kernel.org, jejb@linux.ibm.com
References: <20210416020440.259271-1-michael.christie@oracle.com>
 <20210416020440.259271-3-michael.christie@oracle.com>
 <8c917865-72f1-fbd6-5b0b-9cea4630e594@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <21edb3ae-3947-4f6c-4d3f-0377a753927d@oracle.com>
Date:   Sat, 17 Apr 2021 12:26:44 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <8c917865-72f1-fbd6-5b0b-9cea4630e594@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM6PR11CA0014.namprd11.prod.outlook.com
 (2603:10b6:5:190::27) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM6PR11CA0014.namprd11.prod.outlook.com (2603:10b6:5:190::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Sat, 17 Apr 2021 17:26:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2ba2eff9-669b-4d0a-7d48-08d901c5f9d9
X-MS-TrafficTypeDiagnostic: BYAPR10MB2583:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB25836ACEE2E33ADA8503BA20F14B9@BYAPR10MB2583.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UEAkRBVhfTz800HXqsz+4YvoU9beqbrWwq9Lnk7FoK5su9YUx4ZIUhVo2KmYucr4fR5c/sZnVFfqoU5817vCTpI6NQitKzyJFIWluXUz6aLXJkM0d+1LktLXlly+Quq2CEciEiCCP5opqY6bsV2EU66j6NPODoZ1j6wZ9tWomSBa7w/SqgKU+SHdPjGsXMnIHfW/FG0EilynOfYjgYkOKTYXAVu8qUsv0lojYwPFrUgdSYHj9HD9I8AD+qaX1c2n+rgOdozXfSe4tdou+0iFh43/MBdJJGhGr08ogFI3bhxoZLBcICWE+gfhskjDpm34/yfihYldeZafASWdveqfLdvq5wyc49LX0dvDNTcEVn8cwEAfN6aPWA69jAuN55eQ9JxaJ7F29dCCRnD56PhSUN6RmiuwsXzMgeHKEho5cvUizsgT7X0xc5qDiAbcl4GfdpsARMNHXrz1RygvUNXa8rYtP46TcD3Ivaj2J/ND4lfjtjlE3c4Jw/VIa42e64UfStOFJzWiJDykWejG/N1DcA5YVopZ9vlScekEv025akO243V+3t35TDIkJyVgGG8Bt0UVBWnaYXiN+d68fPmOTFvboPloId3SqP+3Y5isMinf2tnXTNYQEfttF0U5yUvtFpsHbxR4e5vyG8wwYZuVgh1Y2pHyopIm+ZE4ZRlNew834p7iDu3OA31+yDr9SSJyanr48qQWUkdCoqWzNZP8ow==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(396003)(39860400002)(136003)(376002)(186003)(38100700002)(66556008)(31686004)(956004)(66946007)(26005)(16526019)(2616005)(478600001)(86362001)(6706004)(8936002)(8676002)(66476007)(53546011)(36756003)(6486002)(31696002)(83380400001)(5660300002)(16576012)(2906002)(316002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WWJ0ZlF1M3RYa3FqZEd2TjJrZHB0bmR6ODVxbjVGUHQ2cW1FeXAvT3hkcTFo?=
 =?utf-8?B?VDM5VTV3dlNUeEw1TkdjUUlHWkxOeThiNzVvOTdsVytxR1JGVGQzMjJ2cnJu?=
 =?utf-8?B?cmMvcnlvN1JVR3ZtRzJxQUxTOStDaFZGeUJDK3hVdVNwaWhhT3FmVWlubmg3?=
 =?utf-8?B?SWZmTU9YVTRPeEtCSGU5Rnp2K0hrb1hmT1hyWjJia1h0R256QWduRkhMNUtx?=
 =?utf-8?B?QlVMcGhRUUJjdFlFWUtDclBpRUozWFBSWmp2NlNqMFVqOWZsblhRYlkxVnM2?=
 =?utf-8?B?MnIxV0hyeUZqcVN2bEFYQlU1eVZWYTRpTkwwUTFhV2dWVVJMVWxDMG9ZMTIr?=
 =?utf-8?B?cFlGVkRySFFYNExPTWZ1U2RndTFWS3J2cTJ4akYwcUJQdjBmeGR1ZDhLajJ0?=
 =?utf-8?B?elMrM3g1d3V4c1hyOFVvYkZBRG1sR0xCNUcrNFVIalBKdTdJeWdZUUswVTgy?=
 =?utf-8?B?L1pmZlFQbEs0UkR5ZXVnL253QUMxSU5BVTBHRSs3N3JudnIzZkZFSUFBZlFp?=
 =?utf-8?B?cUJnelkxbzFPRld6cGRIU2tLOGN6SWRCeUYyT3hUR3JwdlVWdVczNVR2VjNW?=
 =?utf-8?B?K0pGVXpSeVpVRkJOSEVGTm9lR2d6SVM0RHhlNnN4bTZ1UWIzdkgwOFBZcWYv?=
 =?utf-8?B?YlFOUXowTjFkQVV4V0pjbVBLMDB1bWk5M1ZFNlJMS2poVHUvcEw3TFBwdTFp?=
 =?utf-8?B?QjB0dkVKNm93QkFXMENLai9UMzRjZW01YXdXajAyU0Q2dU5IM3VBNEorNXVY?=
 =?utf-8?B?RzI5RklJMGxob0hWZzhXdjVGbmo3MUQ4NFdJMkd2eUU5Q0doOTVYSHR3dEMy?=
 =?utf-8?B?NTNHQXVjR2ROdXU4Q3AybEYreUZGT2ZaNXAyWDM3cVMyWC9FS1NRa3BFOVB3?=
 =?utf-8?B?M3k2Q3RJM0JQdDFwMVdpSFU1c2xPWk9lMTJZY0RUYzhHNHo3WTk5OHNuKzlX?=
 =?utf-8?B?QWluTmFCbzIwdE9XNm5XU0pTMFl0eWNNTktPdnN3RHNpYkdHaVlva1FXYzI3?=
 =?utf-8?B?cWNYOGFuSmJ4ai9wdUhMWHJyRjZtU3RKWkRTZk9Uc1pGOGRuK1pxNTB2RkxC?=
 =?utf-8?B?b2Y5dU5oZlZyK1R5VUtHQUwzUWRIam82eTFNZHQzOTJIb05zbHhGazdqdDNQ?=
 =?utf-8?B?UlJiY2pTcXZRVXppZ1N4cHRGTmZqalRpbkptTjBwSWFDdHRCVWtmYmxxTkhl?=
 =?utf-8?B?bEtFWkZ5cWJKc2pDR1g0UTJObU1CTHBvSHA1N0dGcTk5c1h0dTJRYVVnRTFN?=
 =?utf-8?B?bmVNaXJCb09UYStQQUJQbXE0UTR1UnZSaWMxc052aVliekxYN0ZMSU1XT0xT?=
 =?utf-8?B?ZWFKQXo2OVFtaWM1UEY0WE5OUi8wbHJHUmZnYVNJQmxFSmVzYUQ2TEt1Ym5o?=
 =?utf-8?B?UXJhYURBSnRVTzJkVVJzL1BHK2V2N2dEdXdBSlpJTkp4a2g1Zkx2VWxpOU41?=
 =?utf-8?B?anhsWmkzN3graUlkcVJPMFcrdlRvVlBvTFBYOXJiZStuRE5RWXhSZHFZbXdR?=
 =?utf-8?B?RElmR1dIZ1VBckpqVG5qUUNkemRrVnV0N2dVWCtMVHp3S0tYeFNWUkU2bzVI?=
 =?utf-8?B?MDhmWmhBbUpUc1gwODNzS0h0VC9rM0ZWazVNeGhhVUp0RFlKcG8xN1d4MjJs?=
 =?utf-8?B?eHpock9sM0Uwc3UxUGthSWJzb1REeHRYZ09DVE1HbkZ4Z3VQd1E0dVp1Ymdq?=
 =?utf-8?B?V01vc3AwQ3lZNGg4azJaMDlleHVHb2dnMnJ1d2YwNDVZQmtPNTZuQ2x3bDBq?=
 =?utf-8?Q?Sc4k23sIkY3rEQ5RiLe48klNeIImZjzMUOR0qo8?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 2ba2eff9-669b-4d0a-7d48-08d901c5f9d9
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Apr 2021 17:26:46.3569
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ZV0dGrrfTtMlkqHPQ9mdjjuRBC4O3Vkb/aTe7JTzhi7m58xSUBN/o3MpNDWawL617iA+PNrzPoPZDqtXwVDjCbML0V7xOOm0J367H2WohfM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2583
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9957 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 malwarescore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104170125
X-Proofpoint-ORIG-GUID: yUmOYCYTFbvy-Zpc-QxnQ-UWVtGQTp4j
X-Proofpoint-GUID: yUmOYCYTFbvy-Zpc-QxnQ-UWVtGQTp4j
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9957 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 priorityscore=1501 lowpriorityscore=0
 spamscore=0 bulkscore=0 phishscore=0 clxscore=1015 impostorscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 mlxscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104170125
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/17/21 12:22 PM, Lee Duncan wrote:
> On 4/15/21 7:04 PM, Mike Christie wrote:
>> If we are handling a sg io reset there is a small window where cmds can
>> sneak into iscsi_queuecommand even though libiscsi has sent a TMF to the
>> driver. This does seems to not be a problem for normal drivers because they
>                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> "doesn't seem to be a problem"?

Yeah.

> 
>> know exactly what was sent to the FW. For libiscsi this is a problem
>> because it knows what it has sent to the driver but not what the driver
>> sent to the FW. When we go to cleanup the running tasks, libiscsi might
>> cleanup the sneaky cmd but the driver/FQ may not have seen the sneaky cmd
> 
> FO?
> 

FW.

>> and it's left running in FW.
>>
>> This has libiscsi just stop queueing cmds when it sends the TMF down to the
>> driver. Both then know they see the same set of cmds.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>  drivers/scsi/libiscsi.c | 104 +++++++++++++++++++++++++++-------------
>>  1 file changed, 72 insertions(+), 32 deletions(-)
>>
>> diff --git a/drivers/scsi/libiscsi.c b/drivers/scsi/libiscsi.c
>> index 4834219497ee..aa5ceaffc697 100644
>> --- a/drivers/scsi/libiscsi.c
>> +++ b/drivers/scsi/libiscsi.c
>> @@ -1669,29 +1669,11 @@ enum {
>>  	FAILURE_SESSION_NOT_READY,
>>  };
>>  
>> -int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>> +static bool iscsi_eh_running(struct iscsi_conn *conn, struct scsi_cmnd *sc,
>> +			     int *reason)
>>  {
>> -	struct iscsi_cls_session *cls_session;
>> -	struct iscsi_host *ihost;
>> -	int reason = 0;
>> -	struct iscsi_session *session;
>> -	struct iscsi_conn *conn;
>> -	struct iscsi_task *task = NULL;
>> -
>> -	sc->result = 0;
>> -	sc->SCp.ptr = NULL;
>> -
>> -	ihost = shost_priv(host);
>> -
>> -	cls_session = starget_to_session(scsi_target(sc->device));
>> -	session = cls_session->dd_data;
>> -	spin_lock_bh(&session->frwd_lock);
>> -
>> -	reason = iscsi_session_chkready(cls_session);
>> -	if (reason) {
>> -		sc->result = reason;
>> -		goto fault;
>> -	}
>> +	struct iscsi_session *session = conn->session;
>> +	struct iscsi_tm *tmf;
>>  
>>  	if (session->state != ISCSI_STATE_LOGGED_IN) {
>>  		/*
>> @@ -1707,31 +1689,92 @@ int iscsi_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *sc)
>>  			 * state is bad, allowing completion to happen
>>  			 */
>>  			if (unlikely(system_state != SYSTEM_RUNNING)) {
>> -				reason = FAILURE_SESSION_FAILED;
>> +				*reason = FAILURE_SESSION_FAILED;
>>  				sc->result = DID_NO_CONNECT << 16;
>>  				break;
>>  			}
>>  			fallthrough;
>>  		case ISCSI_STATE_IN_RECOVERY:
>> -			reason = FAILURE_SESSION_IN_RECOVERY;
>> +			*reason = FAILURE_SESSION_IN_RECOVERY;
>>  			sc->result = DID_IMM_RETRY << 16;
>>  			break;
>>  		case ISCSI_STATE_LOGGING_OUT:
>> -			reason = FAILURE_SESSION_LOGGING_OUT;
>> +			*reason = FAILURE_SESSION_LOGGING_OUT;
>>  			sc->result = DID_IMM_RETRY << 16;
>>  			break;
>>  		case ISCSI_STATE_RECOVERY_FAILED:
>> -			reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
>> +			*reason = FAILURE_SESSION_RECOVERY_TIMEOUT;
>>  			sc->result = DID_TRANSPORT_FAILFAST << 16;
>>  			break;
>>  		case ISCSI_STATE_TERMINATE:
>> -			reason = FAILURE_SESSION_TERMINATE;
>> +			*reason = FAILURE_SESSION_TERMINATE;
>>  			sc->result = DID_NO_CONNECT << 16;
>>  			break;
>>  		default:
>> -			reason = FAILURE_SESSION_FREED;
>> +			*reason = FAILURE_SESSION_FREED;
>>  			sc->result = DID_NO_CONNECT << 16;
>>  		}
>> +		goto eh_running;
>> +	}
>> +
>> +	if (test_bit(ISCSI_SUSPEND_BIT, &conn->suspend_tx)) {
>> +		*reason = FAILURE_SESSION_IN_RECOVERY;
>> +		sc->result = DID_REQUEUE << 16;
>> +		goto eh_running;
>> +	}
>> +
>> +	/*
>> +	 * For sg resets make sure libiscsi, the drivers and their fw see the
>> +	 * same cmds. Once we get a TMF that can affect multiple cmds stop
>> +	 * queueing.
>> +	 */
>> +	if (conn->tmf_state != TMF_INITIAL) {
>> +		tmf = &conn->tmhdr;
>> +
>> +		switch (ISCSI_TM_FUNC_VALUE(tmf)) {
>> +		case ISCSI_TM_FUNC_LOGICAL_UNIT_RESET:
>> +			if (sc->device->lun != scsilun_to_int(&tmf->lun))
>> +				break;
>> +
>> +			ISCSI_DBG_EH(conn->session,
>> +				     "Requeue cmd sent during LU RESET processing.\n");
>> +			sc->result = DID_REQUEUE << 16;
>> +			goto eh_running;
>> +		case ISCSI_TM_FUNC_TARGET_WARM_RESET:
>> +			ISCSI_DBG_EH(conn->session,
>> +				     "Requeue cmd sent during TARGET RESET processing.\n");
>> +			sc->result = DID_REQUEUE << 16;
>> +			goto eh_running;
>> +		}
> 
> Is it common to have no default case? I thought the compiler disliked
> that. If the compiler and convention are fine with this, I'm fine with
> it too.
> 

There is no compiler warnings or errors.
