Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8DB8DC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 24 Nov 2021 17:41:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242750AbhKXRon (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 24 Nov 2021 12:44:43 -0500
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:13588 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242903AbhKXRon (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 24 Nov 2021 12:44:43 -0500
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 1AOGrLhf000726;
        Wed, 24 Nov 2021 17:41:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=vxYdQzvFfXv/ph46/KFgkygR17UhjrbAuB7xNgqQPgM=;
 b=0JT4K6uWGtzfCg98HMnbyTxrxv4WPKwy2XiEQdks6D0mfKgoyLfrpXuAClv7vjLEDS3u
 l3fgeekHscms+VzJ8Huzv86QT0CJG+aXDsDIUShkV0lZ02G0s0ZGRoFVwLuzPOQQPto8
 OYRrHLV79BcYOk0DuCv3yne7Gnl+7gcoZicsQBRh+3KenSg3Z0Uvfa0D4NM/KhEIaGZ5
 KZDFHgpx197uE08nKFjBsLwW588msUWsKXnGve6I8pFLqjN4T6HWS8nzB5ssJq5j0lY5
 KLzKkgWkDEEhQsflgJBiVJZ3PfypYHUPS3SrC+Knm0h0HNB0/kyaOkFBZTB//lWH7Zio Hw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3chkfkaj3u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 17:41:27 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 1AOHUsbi095734;
        Wed, 24 Nov 2021 17:41:23 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2108.outbound.protection.outlook.com [104.47.58.108])
        by userp3030.oracle.com with ESMTP id 3cep52246g-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 24 Nov 2021 17:41:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TVaU1evYoNbd0ActmRVAjCSHVOEHmQ0hqtd355B5rg62YxS2ZO4/Ftd3vA9UdH+hdlIS5MnQOaHlmB2W0fH8VVyeIfmjCZlwKWE9XnGbRgezFo1HMhyAM1yWnM0xJxFxnoLRi1HwXUQad3SdcoZQJut+zSRtT4Rz7clt7fTdkbpTNbeEKnd1Zm7DyVmBJkqX2cf6EPSkUjAk0yudzhYLRBzGlBZqxXsMJx7s/Qw0ZulECd3zW79ilw0DR6gNsxs7//zf+PaS26Xs2uLEOE+Qhn6ypKOQPEBWzyyd56Shm0hkCXBIlvQC2gJWPy41376Kx1/GbyaMdbBAtsDb2z8Ccg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=vxYdQzvFfXv/ph46/KFgkygR17UhjrbAuB7xNgqQPgM=;
 b=cYgUs/rA5NLXXAJeeLxlxz7icW6n3eZm648O0dd+rIXXiyqE8PfmsTCIEADiYM/L0859MYM4C/Ikhb2cYqiQgaQUbApb1Tb7p7z2DyD6p5GuyAKojsFiYaN9gJynHmN+ttX4bjQZIhCSUqOOgODPsnaQiAkfPIJAXZDit1acHweUEfwbpA6FyspLhTzho/FIH0TrsIoRgYlh33ioJ7lRuv/MT15CnvMWO0HYsnd6X/HUHAD2CKF8vx+6LkcXAKLo13B3ZxaEM8fMP+zTbQPCstJ3H+85e0Rrwn94ElWEx0BQnskouNqsECVsyw3A6TWo5xUF5XKt6keTD5SaEIvq+Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=vxYdQzvFfXv/ph46/KFgkygR17UhjrbAuB7xNgqQPgM=;
 b=Jyl6T5X8txXIpLpFDPLpX7EmhAGQo+lw0dBm+0/rZTmV8ztY3cFR9uYMzU62hhjEGORo7+cvpZ5+2BNuoI+UwyID97J2R53qq7IZFkADzILA9fv753fFnJ/df20aFIyeyAM9JiSvZrLvHTtF7gOO9iHr9LB5zq6JogAP7iWVCOc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM5PR10MB1962.namprd10.prod.outlook.com (2603:10b6:3:110::13) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4734.22; Wed, 24 Nov 2021 17:41:08 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::601a:d0f6:b9db:f041%11]) with mapi id 15.20.4713.026; Wed, 24 Nov
 2021 17:41:07 +0000
Message-ID: <3edefd05-333f-7879-7ce7-ecb758fa0ec9@oracle.com>
Date:   Wed, 24 Nov 2021 11:41:06 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.2
Subject: Re: [EXT] Re: [PATCH] qedi: Fix cmd_cleanup_cmpl counter mismatch
 issue.
Content-Language: en-US
To:     Manish Rangankar <mrangankar@marvell.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "lduncan@suse.com" <lduncan@suse.com>,
        "cleech@redhat.com" <cleech@redhat.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>
References: <20211123122115.8599-1-mrangankar@marvell.com>
 <9c21c019-d6ff-a908-80e5-51b9c765d118@oracle.com>
 <PH0PR18MB4425F4F08057B89453C2222ED8619@PH0PR18MB4425.namprd18.prod.outlook.com>
From:   michael.christie@oracle.com
In-Reply-To: <PH0PR18MB4425F4F08057B89453C2222ED8619@PH0PR18MB4425.namprd18.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0344.namprd03.prod.outlook.com
 (2603:10b6:610:11a::35) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
Received: from [20.15.0.19] (73.88.28.6) by CH0PR03CA0344.namprd03.prod.outlook.com (2603:10b6:610:11a::35) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4713.22 via Frontend Transport; Wed, 24 Nov 2021 17:41:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 70ed1024-7060-4179-00f0-08d9af71989e
X-MS-TrafficTypeDiagnostic: DM5PR10MB1962:
X-Microsoft-Antispam-PRVS: <DM5PR10MB1962FC57A40C10B6C118C3D8F1619@DM5PR10MB1962.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J5Aju+EVbhudBZn5UbNGFrIu8Co2ZnoYT+srnj4s0SRYCpdN8OVPwcM8j1jMKYrCNSX7VAj8ivngGjzW8uPVTH/fpU/H0w7wFSiRXaoxJcppTmpEfQTpiohZWqo23Jj4hauAyvZuz5m6VekE9JCewmeZo2mOAi/lTJ6YMX++Q/M666Y2akKan3GhtL1QUKn/Z2kYXx/sFiW89xBfxtxhUXpIBr4SBRdJ5gjrnPsH3W2Q6zWFJ9eMcHMmDYcwnAXUR9ZXfPG3ge1NRpNkMncYg6Wg3bcW6odPKN04wURaijkM98clwNw31cvHpAzlAy+sJsLGMjq/9NmDJl9eKtSm9ipNc25kwowWkjHCX8oQGlzHHWZOIMNM7XYJeMzGY+V8KddsYdK74jsLWpYhAa9+Lv1m6DL95Q5JcTYtPB2B7zecuF8pXFkG5Hyz/ndqDwzfWmEv15AjeO2bHe/35A7LrbOi3T0Hnr1B/iisBOoT7ezsKJl8ivYvwbvYX6jEwjezH4a8Gy4gtpx8pAmDvhdFnPlAO0rr+qYv9gYdqpn+gsRfds8iVqeDrkKm4hEL3GLdqS07+tChwfhnMADCogAZ4HKHN5p03a10idKw50ZLwWaGtiuSEaHgLiaWYdAGAqCqmGQhEbMfrghrKZJm1OZMbaSqMiWpUVPOMqMiGpwZH8lMWr7opV2LJf5fO9n36DvLVAguogp/Put73PROkSjzi+w+iyxr8qwRxhCrvAAVjr8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(2616005)(8676002)(66946007)(6706004)(508600001)(66556008)(66476007)(9686003)(8936002)(86362001)(31686004)(54906003)(956004)(4326008)(83380400001)(16576012)(316002)(110136005)(38100700002)(26005)(31696002)(36756003)(2906002)(186003)(6486002)(53546011)(5660300002)(78286007)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cWNYUzJpS3IxcGh1WlZFZG8rRTlhbWIwNWFOUlRYZWF3Wi9MS21HUTJwQ09C?=
 =?utf-8?B?YXRIbElTam4zQ2ZsM20yNWpzV2Q3N2plcW0xaFJQVkdGNkREVzFXMHZnOWNG?=
 =?utf-8?B?VXBvdkRwZzZlMFBNSnQ5V0wxWUNMeCtENTRFdjI5elI5c0s5dlU5VGZTM0F0?=
 =?utf-8?B?YnFTcFB3Q2syR1BQZkxxd2pKYlliOXRRZGxhNU1uaktJNFRBc1YxWTQ3a1Fn?=
 =?utf-8?B?d0t6TXp0N2tUcjFHdFIwcHVFMC9OR202M1ZjRkQ3Y1k2QnU0R3RsMG83bThI?=
 =?utf-8?B?VVdzaVduQkwvckRGL3ovTHViLzlrT08veUdyM081RXBCclhkYmR1OU0yWHhx?=
 =?utf-8?B?aC9aSytRRUNtM2Y3TDNaQ21WT0xqVlBoR0xKRVVPT0w1NnoxbWRUb0ZVRTNV?=
 =?utf-8?B?dUJnZC9MVC9oTEZPZXBBTysvZndhRUhkM29tanJRaFVSWnRaRGdlT1lwU29i?=
 =?utf-8?B?ZHJWQzNXV3FhOVlvcjROdEtnU3dVNTkxMXpEL2FoSzM2b3pXUUo3WmpSWTA4?=
 =?utf-8?B?d0E4NHd2NGtoMVAwMHZmOU9jT3NUZG8yTDhBS0Z3TUJ5Y05TZlM4b0NJQTJ2?=
 =?utf-8?B?VlZYYVJBSmU3QXpWVE9oM1d5UnhVY1ZWUGsrV3BHZ0U1N1NZVHIyTjFOdjU1?=
 =?utf-8?B?aXcwWkI1aUttVVR6Q3BSUXNpalRzTnoxbEFoNE5YeVduUHkwUGdtS042VXF4?=
 =?utf-8?B?UGdXdjZzbHZoRnNuZTdJUzZxM1dYNXVGUlhjNWNweTV4QUV4NWtzK0lwaDU1?=
 =?utf-8?B?NVpGek5IUWoyOGxPUGpERlZRL1JQZ3NUeWRnR2hlZGxPdi9rVlgvMmtDT2tD?=
 =?utf-8?B?YzZ4TUZsaVJGS2x3Z3F4VVV2V0lZNERkazZGdGJpbGNHUDRMVVJqZkN0Vnkz?=
 =?utf-8?B?a3BXc2REVDdHL3pVVllnWFVNdm1CWEQyYXlPeHU0R1VwejdmT3NVWm92WGlr?=
 =?utf-8?B?Z3dSM2Y4N2VXY3Z4RFVsL09CRkZZUHFHMnZJa0NhbUhUNjNIMWFwcUE3ZHp1?=
 =?utf-8?B?SGhmUFBTZm1zdEdOT2FOODVQN2hYc3Myd28yRXh4NjZFWVExdG54RGIvaWo5?=
 =?utf-8?B?U2pwN09Ec3E3aXA1M290dTBGMzJRQWZMOUlvcEo3Ymc1RUNOSlRmdm1SR1kz?=
 =?utf-8?B?VEZRaGhQcElCaWFzV0dMN3MrTmpwbTY0ZEdhWFZYdkFaYVlFOUlYbC9XQUhY?=
 =?utf-8?B?OVRUQ0xmK0c0TFZMR29halRQZ1ZrbFY3Z25zVXRuSEd6OVBWb0t1aFpXTWVZ?=
 =?utf-8?B?ZUhKcnZGREZJL2JYS3ZaNmY4SHMxWS9wWlR2N0dIc2JZa1lnT2ZOSU1xLzRK?=
 =?utf-8?B?Nmw5aGVaVVR5Z09mU1RTcVBjZTFtWThOc3pvN1lFeExOZlEraGNyM2g4UG44?=
 =?utf-8?B?aE8yZzdkSGlQWGF6WWpXU1hiaGxBbXd4VlN0bGJNWGo3WXJ5SWh1MHl6aFNz?=
 =?utf-8?B?YldpMFBZdXVuSTliOWo1dFFONXVKVGFpR2RzcmZuclBqQ0JVMFNmWnhldlIw?=
 =?utf-8?B?SXFHcGxwUy80VXd0U1lRZnZWQVcyMUN3NUdGa1FyNkIwR2hkMEVWTDVFUy9R?=
 =?utf-8?B?WjJzVWp5MTBhdTEzd1hoZ05Yem5IbW1qZ2J0cDRRVTl2YThCaENhUTgrVm8r?=
 =?utf-8?B?VUVGTGhIWWxFcTA1S0c2MWNWM1AvaUhkTnZjaUh5UHhVSEx2aUtXZ3pKVXI2?=
 =?utf-8?B?TjYyZndicGc2N0V5VDl6bENEdkFMRVphWGYxUnFSTWdxV2NJUmhuTTdrTWZG?=
 =?utf-8?B?cXh0OXJHY0xzS0ZsK1VnajN6bjdLZU03TkxuWUxybDdMcGNzMTRwMmtwaUtU?=
 =?utf-8?B?MFpuWTFnalQ1bUNLbXRqRUExUkVJODM3VmtsT3FCYVQzSU80VVFOSmgxNmY1?=
 =?utf-8?B?K3dQUjV1S3o3aDZ2VytISmhrS0FPOGJRWGJqV3k3d0l0Y1FMZHh1VjJWMlRo?=
 =?utf-8?B?R1Z1MnpwWGY0ZXgzc0FiS1ZBbS9NZ0NBWnVtUm8wdXVFWCtGc3dvdW5lMGhB?=
 =?utf-8?B?NFZUWDFMaTJiblRwTlJlQUlOalZLcEJuT2NITkJjSFV2S3YvV3I5UzYxZVRI?=
 =?utf-8?B?eTBSYWt3UXA5MVRwR2psZFAyQUlBeHZDZjZPbWx5bkVQQS81aVAyS0tBWGMy?=
 =?utf-8?B?dEVDWk9HWm5lajIyL1FRWmZJRTdNcWx2TW5ZQ2FCMUZqVmYyK1RLcXd3K3pZ?=
 =?utf-8?B?Rm1aZTRPWnZnN2EvZGJrMW5NNS9Mb3RaTWxxSHd6TU1LajBMTElYOThxenNn?=
 =?utf-8?B?b2FIRUVNMURoWnlCcXRLSFJNaXFBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 70ed1024-7060-4179-00f0-08d9af71989e
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Nov 2021 17:41:07.7392
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: ix/lyl+N/xOx3FRUEMHiId2y8EIY/Zvp1eAwYFDCTnXUY2CncQkr8fs0GF23Q0JlQEP27TnO0r5msziqyFGpT3sdEDiqLkA21UbIN0V3xhs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM5PR10MB1962
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10178 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2110150000
 definitions=main-2111240094
X-Proofpoint-GUID: 8_dmml7wpdEIGALXm58P1ohexfPVTt21
X-Proofpoint-ORIG-GUID: 8_dmml7wpdEIGALXm58P1ohexfPVTt21
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/24/21 12:05 AM, Manish Rangankar wrote:
>>>
>>>  check_cleanup_reqs:
>>>  	if (qedi_conn->cmd_cleanup_req > 0) {
>>> -		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
>>> -			  "Freeing tid=0x%x for cid=0x%x\n",
>>> -			  cqe->itid, qedi_conn->iscsi_conn_id);
>>> -		qedi_conn->cmd_cleanup_cmpl++;
>>> +		++qedi_conn->cmd_cleanup_cmpl;
>>> +		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
>>> +			  "Freeing tid=0x%x for cid=0x%x cleanup count=%d\n",
>>> +			  cqe->itid, qedi_conn->iscsi_conn_id,
>>> +			  qedi_conn->cmd_cleanup_cmpl);
>>
>> Is the issue that cmd_cleanup_cmpl's increment is not seen by
>> qedi_cleanup_all_io's wait_event_interruptible_timeout call when it wakes up,
>> and your patch fixes this by doing a pre increment?
>>
> 
> Yes, cmd_cleanup_cmpl's increment is not seen by qedi_cleanup_all_io's 
> wait_event_interruptible_timeout call when it wakes up, even after firmware 
> post all the ISCSI_CQE_TYPE_TASK_CLEANUP events for requested cmd_cleanup_req.
> Yes, pre increment did addressed this issue. Do you feel otherwise ?
> 
>> Does doing a pre increment give you barrier like behavior and is that why this
>> works? I thought if wake_up ends up waking up the other thread it does a barrier
>> already, so it's not clear to me how changing to a pre-increment helps.
>>
>> Is doing a pre-increment a common way to handle this? It looks like we do a
>> post increment and wake_up* in other places. However, like in the scsi layer we
>> do wake_up_process and memory-barriers.txt says that always does a general
>> barrier, so is that why we can do a post increment there?
>>
>> Does pre-increment give you barrier like behavior, and is the wake_up call not
>> waking up the process so we didn't get a barrier from that, and so that's why this
>> works?
>>
> 
> Issue happen before calling wake_up. When we gets a ISCSI_CQE_TYPE_TASK_CLEANUP surge on
> multiple Rx threads, cmd_cleanup_cmpl tend to miss the increment. The scenario is more similar to
> multiple threads access cmd_cleanup_cmpl causing race during postfix increment. This could be because of 
> thread reading the same value at a time.
> 
> Now that I am explaining it, it felt instead of pre-incrementing cmd_cleanup_cmpl, 
> it should be atomic variable. Do see any issue ? 
> 

Yeah, atomic.

And then I guess for this:

        if (qedi_conn->cmd_cleanup_req > 0) {
                QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
                          "Freeing tid=0x%x for cid=0x%x\n",
                          cqe->itid, qedi_conn->iscsi_conn_id);
                qedi_conn->cmd_cleanup_cmpl++;
                wake_up(&qedi_conn->wait_queue);


we might only want to do the wake_up once:

if (atomic_inc_return(&qedi_conn->cmd_cleanup_cmpl) ==
    qedi_conn->cmd_cleanup_req) {

?
