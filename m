Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-22.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0DF14C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 22:50:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E2ACD613C1
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 22:50:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234764AbhDPWvE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 18:51:04 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:37450 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234740AbhDPWvD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 16 Apr 2021 18:51:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GMoc7E010674;
        Fri, 16 Apr 2021 22:50:38 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=LdOcvkj6atrNH1dfm9x/yQYJBeHHHFVQszGNklu9eqc=;
 b=KkdMNqgb0tSN3siou5ArAzCDFr6qw2UPEoPHAfaddg9nUqwTXUPo/qRhmyOIzV1jBj7R
 2Ghf/vn35qxzIhALXwV7IcBYj+7OQhwTFR7EQQrqn0AFUU+SHGSg1R0wXSg+O8iZASh+
 rBIDR/5QpxPasW7C+HRQ7wOc2nb18gMTXvpOWXIb2xB1edyqnWgp9zTQVvh/hd/jUAtO
 yvHKDtMOsyiDRMiDDoWgZ6FxtVsCpsWuN4r+RV1rUdsC11HjFAgqy2pLeDf02zYtJR2r
 TYvpY5gmqkbc3uyacwHxT+rCDXZGfW+So/t8h7xdUVF3pRt1wjdzS6JnJtLbRDmssn+V PQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37u1hbtm7f-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 22:50:38 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13GMoZoZ196518;
        Fri, 16 Apr 2021 22:50:37 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2048.outbound.protection.outlook.com [104.47.66.48])
        by userp3030.oracle.com with ESMTP id 37uny3bcty-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 16 Apr 2021 22:50:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cXz4AR6P1DNW6OP45bUC9DBF3wJGd+k1z5FXBO25PawBXcBHVvaY8oPv8MU9b+Yv+uSbQSrfMKgUVFrn70EYgeVZSErhI17QiCf2RpnVq/f6P1GWexSk1Msnc0zI1lX2M1ciXWUUxi7xxoInLj5qfWZbQeM5evsyzjJgFhNOnfVi8E0jBXzHRAKlVSkS0ZTv0QE9FWnuaN9a8l9ztMNHVKCO0EdWM0dXRFmq7xlOj6qzybEE/1F+VrD+HBj0mtls1Gv9QIduGuWTK7z5R7aJyIwPO+zE0G9EdamwHggKyJg1VqkXng3Uwx8MmXUvmok9bM2uLwVI+MyeZrhC/r4IeQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdOcvkj6atrNH1dfm9x/yQYJBeHHHFVQszGNklu9eqc=;
 b=Wy3Tvk9kV2ZLO0wD0sIQoxJGeDfLicAVeEavNm4mo8zKUAmcm10cMO+eCBRV1yJuSrmWQ9UrzwalP69xZS1Rrw6xRt1Q8vu6DFH79aVyHMI8q6aB1RQxDK4sPxLXd+j4CAQJOwBha0OZfHk7HdYPCjnLUz7I1KPoGzWPHu0wED6dvrt81co7xz8mnyLnuZqTDCPbkvRxKVxg5OeT5oflGOq/Opry1JUa5kFOBG1L9gDUuN7KnAZzatBUmPDM69WPMJgYgWtudv1h1V2Wpxnv+dAVa1Yln10RwXLO5C0k8sW1q7eePbe9oHDgCHcuhbAblwqQyaMXzIKFassWmzcIwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LdOcvkj6atrNH1dfm9x/yQYJBeHHHFVQszGNklu9eqc=;
 b=oaXjGPuBZfacUR2cIf2nUF3HdBn39ibWlFRCbmi3sk54T8ph6cJZdGKyDLVyL4bjO4BQcuBkILfxLcL4x56JISMNCuAKwurcmEAJXAjSbD2/QJEt9wjdCnlDx0ypo7ayEb0bTvqnCB8abONMik85RBQGjIrUX3aIXZ8n86Dma5I=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4180.namprd10.prod.outlook.com (2603:10b6:a03:211::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Fri, 16 Apr
 2021 22:50:33 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4042.019; Fri, 16 Apr 2021
 22:50:32 +0000
Subject: Re: [PATCH v2] target: core: remove from tmr_list at lun unlink
From:   Mike Christie <michael.christie@oracle.com>
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210416092146.3201-1-d.bogdanov@yadro.com>
 <d4a19bc6-a89a-7572-b726-31df86fc84fd@oracle.com>
Message-ID: <a91500ce-5ff8-8f97-03dc-74ae097d22e2@oracle.com>
Date:   Fri, 16 Apr 2021 17:50:30 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.0
In-Reply-To: <d4a19bc6-a89a-7572-b726-31df86fc84fd@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM3PR12CA0052.namprd12.prod.outlook.com
 (2603:10b6:0:56::20) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM3PR12CA0052.namprd12.prod.outlook.com (2603:10b6:0:56::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Fri, 16 Apr 2021 22:50:32 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1dbe57d0-1db5-422e-7588-08d9012a0a7e
X-MS-TrafficTypeDiagnostic: BY5PR10MB4180:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB41807A2A80F8B76252DE1F7FF14C9@BY5PR10MB4180.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 0H+wyXDokePqUmJSS26dRUHlHtWHPM3DpsApccCJ+KNpJY9YHEDn7QKTnkf+c22DmiFDYwkL9ul/Z+3K/Y+CXAtLe5iGTmxfXh/mnQybBM/YFMwceXFmAq4oZKcG1lK1aNKm0888cbQ5O6ktXYUqLOijVOg7ynzBE0Wd1nSeneXt4ppoFahfmxCR6dB8/EQb30ivZvTtOkMwr/aH5498SlR0o5iyqjsybbPLSGLEhgW+wJfVDD2SnM9TpzMpNsqgfarpTyZP1z8LrXAAEXzp5bMCGMto9ahZyfJ4N4rl+kHeMppWh+hwNQM44QfKfkThAADlAfFcoX08gNJp8vy4BfdwCTp9ZN/KFpkl/L5P9craqqpFBOwFvYYAY+OyGMI/0Bk57NPnqxlm9d1dVqM4/TDisS8wSkvXfhlIrjW8aahRrMOjkGIkwo9EZ784RYmrkgEAVNfXYiiF5kQ8xKE+WIDneNZPaRCeS6bmUKemrDPoEWtll0KLQKpDv8yakE+Da8L3pv+PDxki60gznEsTEHvIaF02/gvyLC8NeMsd2kafcLcjVj9jUFpMalnxCvJRy9/yl7FxV/lQde2bBTmmBqJSv6vxyjWvGlRuzG0v2z/Mbb1alL4HayVcZR0p9eJY/9OF4Ilbq1I0nLBBZpoNAcsV8XxFavjwBcRSNEtyM7KZQGM99u1oeDEGcAR7nLATl8dGFFw6lNrRL0r1fbLfxeqddH8+IDxU3I8xnYKkzamtPFJHkyzl3hzlYsyVaKWsRwDisnndn5dTN94PV2JeXuTj6KJMeVqHKgiG98aKfYE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(39860400002)(136003)(396003)(366004)(346002)(5660300002)(8676002)(8936002)(53546011)(4326008)(2906002)(66476007)(2616005)(956004)(31696002)(186003)(38100700002)(26005)(16526019)(966005)(66946007)(6706004)(31686004)(83380400001)(36756003)(86362001)(316002)(16576012)(110136005)(508600001)(6486002)(66556008)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?dVJ2L3kzMTAvRGJCdUV4MmQ4UTR0eEZKQm4vUlJMak0xRTVnaXpDTklCdHBU?=
 =?utf-8?B?UzRuMEh2c0hqSjB3dmZLUG5lc3FrL0E4YkY0KzBoZmQ0RllEc1ZMd3BLQzZh?=
 =?utf-8?B?VzZuU1hDVUxSTFdqRk1WcXRSMUxyakJtNTNHR3BEbUxRem9pSGtpaXV1Wk5I?=
 =?utf-8?B?T1NnVDRpUGpXTGFLRys3UjVZMU4zaEpFK3Y3YUhvZmptdFZ6QU9YcW5LSUpW?=
 =?utf-8?B?K2xCTmREbUFRUDJNWTBtOE9Hc0M4NHlPRG92NEowYXhJZXU1VmlLMEVyN3NT?=
 =?utf-8?B?TXF1emZHY21KU05kUitwQ2hsNWhPcDZ6QkVld3pKM2czdGZHVFNiQ0poYTda?=
 =?utf-8?B?Y2RCTjVFTWVYZlhoMExqcERyTldLd2gxQ0QwT3dlZEZyZGFDeDNOYVYwdm8y?=
 =?utf-8?B?UGhHWXRNRjAyU3luK3VhWk91N2c5b1ppdnFtK0luVFhMT01YdEMwY1NZeHRk?=
 =?utf-8?B?WHNCOTc3K2R2cFBGc2RmVUNjdnc4UDhSVW9jcmdySmk5dFYvTnRzYzMvRmRa?=
 =?utf-8?B?bEFTbjQ4OHZ4SHpXRHlIUzNtdVFuR0lHNFpjdFBENHJDRnJaeWF5b2lUSlNx?=
 =?utf-8?B?MmtMaFlkZFROT2UvSWZuaEJMZzVKTy9RcmhTMG1udENZTHIxUTF0eXJtb2ha?=
 =?utf-8?B?VnljVC9PL1UxRk9mQUduQ2E4ZDRyWjI2eW95b21rRnh1ZDArMk01SnRKdHhX?=
 =?utf-8?B?OHBpdUdpNmNUVDM5S05IR2xHSEtQT3FUNGN5OS9lbk5XNDlFTW1zaEd1em4x?=
 =?utf-8?B?UUVTMVhzOVJ5RFZuQnJWZGd3T0diZ2Vhdjdrd0NvV1lFbGpOMzNPZ3NxMzV6?=
 =?utf-8?B?QVVUL0IzZFp4M1VOcktmVnZTVXJoZ0ViZy8zVGdHTzd0TXdqazc4eVUxOEdj?=
 =?utf-8?B?akNtam9JeWtXL0h3bVR2TG02RnZrNHgzRnJyK2srb0x5Y25DcVM2SzZVdHd4?=
 =?utf-8?B?ZHpjVC9LWUFYU2hUcnJIdFdPTmRqeTZ6dlZMNGVtRU5MN09ibG9hLzhpNlV2?=
 =?utf-8?B?dS9oakwxa2tBVjhhdllPRXNyL0d3REQxdk1qK3NCbExMeXBRT0h1VHA0elBn?=
 =?utf-8?B?YTcxWHd4MzlIVmE1cXpYU2RSeGFxQzAzQTFTbUNqNUd0cGYrd1ZqRDUzSCsy?=
 =?utf-8?B?a1RYbm9tYmF0LzRGcXFyWlZ5Q0JiWlVUcHlxeDB0bmZ5a0lDNzhCM0t2SEM5?=
 =?utf-8?B?S2pHOG1DZ2dhZ1E2c3RYeVhueFM3bjhYaW5NOTFiNWdzTE55VVhZMktOWEJk?=
 =?utf-8?B?VXFMTmtSOVlGYlpRY0FvSlN5dGRRdWJGMHI1cGVtRENwNjdFdCtpNWZlbVI3?=
 =?utf-8?B?QVlWYkpKQ2RmbWlsWk5LYlpFay8zY0F6UExidG1aZTZobllZTkEwTEVNOEEy?=
 =?utf-8?B?ZzhXUEc2WmZrZFFhcjllcDQ2UkQzTXhIOWI2SnYzRkpRSGtlcEo1V2Q4U2RG?=
 =?utf-8?B?OE9iMTBTeVZPaWZlWldidE9BdDdUVnhSL2RVUmVRYnl5M29XL1R2Y2hyZzJw?=
 =?utf-8?B?RlZzcFVBaktYWWQxRVpMT0J1RlFjZFBsMVo1TzJYTzNjZmlUY0JvSmxIWU1J?=
 =?utf-8?B?ZWNvY2YzdHp1bFFGQ0RiU3EzOXczZ0xyQlUrampKL0pmd1kwdlV5b0NpZitV?=
 =?utf-8?B?NC9TK0FZcXhub240NjhvcldESUY0SHhKZDBMZWgxZ0doZU9ERS93dG1DZE5D?=
 =?utf-8?B?MUk4dDYyUkVIa1hJUldpWCtmNnpEUVVvSFhHcElCUDFuR2lhTUxFK1QrMFhj?=
 =?utf-8?Q?WfMlu5AmJJObyADdRqTjPuwcvJO5E4hANJyxRHS?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1dbe57d0-1db5-422e-7588-08d9012a0a7e
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Apr 2021 22:50:32.6649
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fNjBinG6beqtfdUD+qNA9yMczRAIfnejjooP/SdFA+s7NCFVa3PvsifNmaKTElbWWAkm5MgLMJTqEpX9BNH/F8R9TPSalgEjZhs8ZjXwm6I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4180
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 bulkscore=0 malwarescore=0
 spamscore=0 adultscore=0 phishscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160160
X-Proofpoint-GUID: UbcFdkXMp5itesqNn1kv6jm-_37iwB4P
X-Proofpoint-ORIG-GUID: UbcFdkXMp5itesqNn1kv6jm-_37iwB4P
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9956 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 priorityscore=1501
 clxscore=1015 adultscore=0 mlxlogscore=999 impostorscore=0 malwarescore=0
 lowpriorityscore=0 spamscore=0 phishscore=0 bulkscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104160160
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/21 5:39 PM, Mike Christie wrote:
> On 4/16/21 4:21 AM, Dmitry Bogdanov wrote:
>> Currently TMF commands are removed from de_device.dev_tmf_list at
>> the very end of se_cmd lifecycle. But se_lun unlinks from se_cmd
>> up on a command status (response) is queued in transport layer.
>> It means that LUN and backend device can be deleted meantime and at
>> the moment of repsonse completion a panic is occured:
>>
>> target_tmr_work()
>> 	cmd->se_tfo->queue_tm_rsp(cmd); // send abort_rsp to a wire
>> 	transport_lun_remove_cmd(cmd) // unlink se_cmd from se_lun
>> - // - // - // -
>> <<<--- lun remove
>> <<<--- core backend device remove
>> - // - // - // -
>> qlt_handle_abts_completion()
>>   tfo->free_mcmd()
>>     transport_generic_free_cmd()
>>       target_put_sess_cmd()
>>         core_tmr_release_req() {
>>           if (dev) { // backend device, can not be null
>>             spin_lock_irqsave(&dev->se_tmr_lock, flags); //<<<--- CRASH
>>
>> Call Trace:
>> NIP [c000000000e1683c] _raw_spin_lock_irqsave+0x2c/0xc0
>> LR [c00800000e433338] core_tmr_release_req+0x40/0xa0 [target_core_mod]
>> Call Trace:
>> (unreliable)
>> 0x0
>> target_put_sess_cmd+0x2a0/0x370 [target_core_mod]
>> transport_generic_free_cmd+0x6c/0x1b0 [target_core_mod]
>> tcm_qla2xxx_complete_mcmd+0x28/0x50 [tcm_qla2xxx]
>> process_one_work+0x2c4/0x5c0
>> worker_thread+0x88/0x690
>>
>> For FC protocol it is a race condition, but for iSCSI protocol it is
>> easyly reproduced by manual sending iSCSI commands:
>> - Send some SCSI sommand
>> - Send Abort of that command over iSCSI
>> - Remove LUN on target
>> - Send next iSCSI command to acknowledge the Abort_Response
>> - target panics
>>
>> There is no sense to keep the command in tmr_list until response
>> completion, so move the removal from tmr_list from the response
>> completion to the response queueing when lun is unlinked.
>> Move the removal from state list too as it is a subject to the same
>> race condition.
>>
>> Fixes: c66ac9db8d4a ("[SCSI] target: Add LIO target core v4.0.0-rc6")
>> Reviewed-by: Roman Bolshakov <r.bolshakov@yadro.com>
>> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
>>
>> ---
>> v2:
>>  fix cmd stuck in tmr list in error case in iscsi
>>  move clearing cmd->se_lun to transport_lun_remove_cmd
>>
>> The issue exists from the very begining.
>> I uploaded a scapy script that helps to reproduce the issue at
>> https://urldefense.com/v3/__https://gist.github.com/logost/cb93df41dd2432454324449b390403c4__;!!GqivPVa7Brio!MjANCRIp5ZrtKYonxEKclROOwOe7s-adKHLiUd2Njis6m1774RMpLGNkHyapFf68BwFr$ 
>> ---
>>  drivers/target/iscsi/iscsi_target.c    |  2 +-
>>  drivers/target/target_core_tmr.c       |  9 --------
>>  drivers/target/target_core_transport.c | 29 +++++++++++++++++++-------
>>  3 files changed, 23 insertions(+), 17 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index d0e7ed8f28cc..3311b031a812 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -2142,7 +2142,7 @@ iscsit_handle_task_mgt_cmd(struct iscsi_conn *conn, struct iscsi_cmd *cmd,
>>  	 * TMR TASK_REASSIGN.
>>  	 */
>>  	iscsit_add_cmd_to_response_queue(cmd, conn, cmd->i_state);
>> -	target_put_sess_cmd(&cmd->se_cmd);
>> +	transport_generic_free_cmd(&cmd->se_cmd, false);
>>  	return 0;
>>  }
> 
> Doh. I see how I got all confused. I guess this path leaks the lun_ref
> taken by transport_lookup_tmr_lun. It looks like an old issue and nothing
> to do with your patch.
> 
> I'm not sure if we are supposed to be calling transport_generic_free_cmd
> twice. It looks like it works ok, because your patch added the "cmd->se_lun = NULL"
> in transport_lun_remove_cmd, so we won't do a double list deletion.
> It feels dirty though. I can feel Bart saying, "Mike did you see the comment
> at the top of the function". :)
> 
> Maybe it's best to more cleanly unwind what was setup in the rror path. I think we
> can fix lun_ref leak too.
> 
> So instead of doing transport_generic_free_cmd above do transport_lun_remove_cmd
> to match/undo the transport_lookup_tmr_lun call in iscsit_handle_task_mgt_cmd?

Shoot. I'm all over the place. I think the root issue is my original comment on the v1
patch was wrong.

On a failure we would still do:

iscsit_free_cmd -> transport_generic_free_cmd -> transport_lun_remove_cmd

right? So we don't need any change in the iscsi target. It should all
just work.


