Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2336AC7618A
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Mar 2023 17:10:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230518AbjCNRKP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Mar 2023 13:10:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230484AbjCNRKK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Mar 2023 13:10:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 606CB746DB;
        Tue, 14 Mar 2023 10:10:01 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32EFNoAb017784;
        Tue, 14 Mar 2023 17:09:36 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=GMcVQQZ++z/S1j/gKjaD0jIsiLF66cY5hxV08Z7MlxQ=;
 b=QFPVOsMThKFVXVS1VaaFhYu0m9tu+4//89Mu7agQE7N6uwpo4N6X0B01m6RPnoasN/Ri
 XObTNwxOqGbkR5oOSXpNgDhpIBNkedlrp/Ohh2OA1bCxvoZjid41P1kScdV5rXjsTv35
 8+ebBaw9yMEzbaBT8bRWQzLbOv1JrIs2bC0rVt+nCHfdUHG7hSrhg/cvY6k1rc6vYKtH
 4FI2zjpNtjHHS4YcFuhiN5yUQPmV8GyLLXX1LXVfPq2eH4OoCHobwfTAc6dmkn3w5dh6
 TIXtMr+7Vo0//G9dwZ+DgzV+wUhtMy+vkV9zwffklXgHSSb+eI4CLlNjudX+tFvGgHxE Uw== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p8hpcy197-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 17:09:36 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32EG1muk018456;
        Tue, 14 Mar 2023 17:09:35 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2047.outbound.protection.outlook.com [104.47.56.47])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p8g36dvp4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 14 Mar 2023 17:09:35 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NY/KxkwBXo70N6ZGx/FGoYhMCQ6SIKUXC3u/mC0qXINrxWE7R6q7WSuhh6bCbgygT6Y136LEdl7EhcuadpbLnv7bDknVJ7/91e/Ytlw5gJml1p/zVPMF0hmL67YQHjMWwl9N336RDSOFT4bx/ArgslkMF7LR61ZKw7iB5iJbIbB06jH88x1yOluG4kXntwHF9jYNwVJrnXh90a2gFriDscNUjzgLenbGoPruXJ9imIzVPExmXTtzAaAh8N0JRw6zNMUX1F2zjKH0SWeeU5H4yLmYcyP2S6W5K+9d7hTGuakYz4ko08eeP/v5LtXC2kNRxB6CNXUVA7FrWp2uCtOlog==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=GMcVQQZ++z/S1j/gKjaD0jIsiLF66cY5hxV08Z7MlxQ=;
 b=cakoc1fF8ylorJ2qpPfnj/Z+9y00hbaCZgLifaOm9QA4knfKg/ouceYhtnQ6upQLPawQSzIKa+GKDhYzQ1E4VCt2PXH7DYE2VAelAsxb324584ofjinSd0TKnTrTlm47LWEuD7j7pccszSa0YIRX1pH2b+eBPO3pNcUrEqWQ7QsCOqFXMP3NQ0Ne8EIlmYeiE3nJRSjLMNhHqgyUVsdWYz8KBugA77u57yncXzwitixcpFDOgGEOs4vtU1I5tbEb4iiQOsmqDl35qt86Qz4aJZLtP2h/jn/0LjCx2fIPzfb66B8RIZBuxkcx5eot4L0KO2R9UprQqFOQInvL/+1jUw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=GMcVQQZ++z/S1j/gKjaD0jIsiLF66cY5hxV08Z7MlxQ=;
 b=J3mX+LGB/JDBQzNHU0vWC2Jv9HTUD7HyY4dOtp5tjS73SPpQ39M3T+uD8ImbOOymx2F1kyHS3Lz6ZSSDbgqZITtJT0iBu6lnR5NtDyrDASKWILd1rh1icZOgjNg2/MbS1GbbloCsWYWch8fvnElqucteJpTiEJHG3CvXqXy6szI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA1PR10MB6050.namprd10.prod.outlook.com (2603:10b6:208:38a::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.19; Tue, 14 Mar
 2023 17:09:33 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::7dd7:8d22:104:8d64%7]) with mapi id 15.20.6178.026; Tue, 14 Mar 2023
 17:09:33 +0000
Message-ID: <c004e7a8-8478-cc75-e174-5c0bbd22f4fc@oracle.com>
Date:   Tue, 14 Mar 2023 12:09:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH v3 12/12] target: add virtual remote target
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Jason Gunthorpe <jgg@ziepe.ca>,
        Leon Romanovsky <leon@kernel.org>,
        James Smart <james.smart@broadcom.com>,
        Ram Vegesna <ram.vegesna@broadcom.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com,
        Chris Boot <bootc@bootc.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Juergen Gross <jgross@suse.com>, linux-scsi@vger.kernel.org,
        linux@yadro.com, Konstantin Shelekhin <k.shelekhin@yadro.com>
References: <20230313181110.20566-1-d.bogdanov@yadro.com>
 <20230313181110.20566-13-d.bogdanov@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20230313181110.20566-13-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0115.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::17) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA1PR10MB6050:EE_
X-MS-Office365-Filtering-Correlation-Id: e3cfb8ca-7a39-4923-8618-08db24aee18c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: VdF3x6E2CVcUXszZlkkAyI1RB+vqkZYocV7oaAGtu/6tnhFW23Tm7PqU8HCJbOxQkm3ykgPe/tBcHVSGpemryZkLTya/JL5SfBSL1SWsDK6/NuRY1msNQJ8forCI6HMEWalKwwMhUDIQ98sNSErsnfg/kIa/yf3B1t7spIP/VvhULc2anH2ZAfSmWvAUMGsJtoCEx8YjRxE+YL4zC6lyhTi8hfwjXnQQqGHmOyMS7PIi/4zNILstOYFB8Us8kUlg8Ap5alEd8Nx8T3jWHFcfFZLqa6z5tvdRx1oxK8xldDiuBouwyFgL3LvCc6xIz7pvJfbNNzIT1gXf4SmzswM4ca0L9vvH2j4+edK1MinHF2CEtgA3E2MBfS8RMmalJ51hNzwFU4X3MWFSJUSVm41WA9bElu6WHJSQfCNtU/B7LIHFm2I1oFpZI6ppQd1OUrCnDP2KojC6XkqQzfaeU5GSkBDhW4scecpvFBaKxaX8cJsdCaRpMe6ma1tD3Gt2heLVXIHojaKpFhV2MeqpTYarYVpVzDd734DPDxgLIqawlGApxMKUmlr6jwoCqpF4BPDqi3UvaLJYyvjFhX2D3OCBWI+UxThko3kPJNfZxgy/XYTDQ1JOWCanxMoTPyaR8mAkTOaYWIKYiN30yQF5N0/KcOGzJjGRt6KWIHEZkn1F6lOXPPZtfsPLVXsEOt4mgRUITid3eicqDbOp1LrmGnkdAbbPmayWRW60X7pxI5rNcHQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199018)(36756003)(6486002)(478600001)(186003)(53546011)(7416002)(2616005)(26005)(5660300002)(110136005)(66946007)(8676002)(6512007)(2906002)(8936002)(66476007)(66556008)(4326008)(6506007)(316002)(31696002)(38100700002)(54906003)(86362001)(4744005)(41300700001)(31686004)(66899018)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?enBOdGNySjRHQ3RONHdrRWFYVklobmUzTXdPbUxOUFlOZzB5RHZsRm9ieEFM?=
 =?utf-8?B?RC9DZzE5Vlo0bi9iRW04SEtTNkNNWU9TdlpzdjJqZ3BvOFVSd1c5UXVTUmUy?=
 =?utf-8?B?T2xOVzl6eFlQNDh3eC8vVHpTQUJ5UjlYNGZqak5sRkh6d2xuZDhwVDlrcGY3?=
 =?utf-8?B?MHkraDlpazYwYnZOdmZKL3FPM2E5NERIdWFsNVVrckJRMkdQYkowUzlGb2Zx?=
 =?utf-8?B?dWp2R1pjNmI1WEYyS2h2VGpERlE0Z3JJb1NNVHdaVDk3cnFNSVBHYUtxRU8r?=
 =?utf-8?B?emF2aDZ2QlRKOE5YTDY2K1BTcWdhL0paNm1qai9TRFpiRmVOUzN5WnEwZzNo?=
 =?utf-8?B?UXQ1TGkrQlNYL25Yd3VKQXZLb1NVOTVMemdqTEpvZEtHd25BQTVYbDhrRG90?=
 =?utf-8?B?eTUrVE5Yc09nWDF1aHJSTnJXSHNUUTcrK1MwL25wVXhjZFpzQjM5R1ZrMzlO?=
 =?utf-8?B?WEZKRDI3N295YktKWHIramk5WmRBR0x6ZFpqM2RrSnZIZTFmclhqeG5OVXlt?=
 =?utf-8?B?WWV1RHBjSFV2NlNsRGZ2VEtOQURBMGNxaG5nYkcvQ3BDRm0rVk95d0dzZS9P?=
 =?utf-8?B?UmRRL0xZNzZxY0Z6TmNab09Cc1duYzkvYjBSSEhkYlpIcDdueXBMankvbjVY?=
 =?utf-8?B?RHRtenhGRGt5djF6ZFZWVExWVzRGYktjckh6YlpSTVBBbG0xK2t5UVdrZmtD?=
 =?utf-8?B?ejUwLytwQS9rN0k0VmFZM3BHajFRY1JYNThTZ2oyZFdTdnFETnh0R0F0SkMx?=
 =?utf-8?B?cUwxZ2RHckE0R2QwU0liaXhwRHpHdXRKemw1L2YyazJYRFBQNVFyRUdYK2pB?=
 =?utf-8?B?QWU4YmpTV1hHS3hyNzE4dlc3TkllVTNuU2EwaXV6S25vN1RESjZFSlRrMGdG?=
 =?utf-8?B?Z1FrekplOWJGUytHdkdnRml5c2J4UWkyMUFRN0F6M0czR3VCWERwMHVMSTZV?=
 =?utf-8?B?MTNPak1uMWVtR3FuK0Q0V3BHVEM2WUtZTk9kbWVsQVo0Y1ZUNHJEM1pBalU3?=
 =?utf-8?B?YVY5ci93eUZVa2tvVGx6WkJwNisvODU0RCtJNlZpRnlsTzRaRS95THArTDRU?=
 =?utf-8?B?ZEVFR2NOcnpHUVY1Z0tJdHVtQlJ3UUgySFprMFZuL0lsV0pSS1JxQUxDbk53?=
 =?utf-8?B?eTJtS2lKUWVSNVJqMEphK3VSa2xJa0lnY2JSM1BDYzJKMk9yUnZrb0poVHdo?=
 =?utf-8?B?TDFkM3N0ajNRNnNYOVlDUlVpUmtlL2tSVzVyT2Y5MkxscnpoTTZiMDUrTFhR?=
 =?utf-8?B?a3RtMmNzWURkM2l6QmhpS0hWVFFPMFYzVFoxNDFXNjF0TEZGMzN6WUNQMzcy?=
 =?utf-8?B?emdzN2VlNEVhdDFqcTh3MVRpSGg0eVdkcDRtYXgycGZSc0RLMkJzWk5FNXA3?=
 =?utf-8?B?REJRUmRTTllLNTJ2TVZsa3pjTEZsTG52NE5RUDhJdUdQWVQ3TFMxUkdKZVBO?=
 =?utf-8?B?RVZYTWRNZGI4NVdhSUFOYTNCeENWdmxNVW55L0dqdWpMOHpEelU0WnhUbU8w?=
 =?utf-8?B?YmpDV0RKQnViRFhsUjNIM2dCd2hxaUVOMHJEb0VyK1BCeWpURCs1bWRVNnVM?=
 =?utf-8?B?blIwK2s2dlZjTVpwZlViaWxvZkxVSFBib3dyTmlHczRDWkFqdktrZVRmVnVh?=
 =?utf-8?B?TW51NC9GbGhTbjJTWHNucmtNa1gvRkdIK0ZQZkduYWpjRU9vTUN1dDUzZUY1?=
 =?utf-8?B?ek5xYnVxMXFLRTIwNmE3NjBmL0l3SmpOS3lScGVBWmw3Rm5UVTZOK2xHVWpy?=
 =?utf-8?B?LzRXRlRkK0VhZFhCSTVjRXNSWkduZ3ordlZsQnpkbU8ybHQ4R0VwejlmRWFr?=
 =?utf-8?B?Ym54U0xhcTQ1WWpGUjNHS3BIZk94a1N6NmV1RlhXcGJFTW1KVWxDcjJYNjJ0?=
 =?utf-8?B?Qko3cFkwK1FmVXNtRXJNMVRSU1BidzY1aWZLRmZnR2xSVDlvdGdpMmltQWJO?=
 =?utf-8?B?bFZQTFByanFDdG1abVhXUjhJT3pab1U3MUgrQ2NVRXBycUFwYmUyTDVPYlNv?=
 =?utf-8?B?WFRFTEpMTnpSbTlBN1BjWUw2NFJuWENjeFJENXdvcFNGWGdTNURCV1V3NWhH?=
 =?utf-8?B?SVdGS0ZCMld6bGVPZU1UZWEycGtVQ3NqTzNFSTdYcm9KZnhlb0kxM3hMMTAw?=
 =?utf-8?B?dHNLZ0lXQW14akQxNUh2eW9CeEUvZUNHNE84VDNqdi9EdUJ0WW1SYVFYSG9t?=
 =?utf-8?B?YWc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?eTAyUDgvcTZnOHJOakMyNW9rZWNoQkYyTFd6TkJPbUJTQkpaWWwyZ1F0ekR2?=
 =?utf-8?B?WnJGZ0JVVHBUbFA3eGs3bWdhTGQvb1FMNXFvdjE1Ni83RTh3SERLWmhmcURC?=
 =?utf-8?B?T0JmazZtZW1FSy9FVEovUVY5amdjL0ErL2xXY1E4MllKMU1xeXhaOHEvei9m?=
 =?utf-8?B?VFdYMjEzc0JFYkwydjZQdWNhdUpsWkVDbDRwRDh0T2d1OGlDOVRoVm40MW9E?=
 =?utf-8?B?NUxNZFNQb0xlaTJVbEt3cGwyZ01ma2VKQ29UUWpIV0U0d3BGQmh2R3ZnUk0x?=
 =?utf-8?B?dm1aeW1leWpXRnFkS01OMDhuNGkvV2FmYkR0eGJvWFI3Zmd5UC94NXJ5U2c5?=
 =?utf-8?B?cjNKYmozZ0ZrUVFmWUwwdmFVVU5jcWRyaU9tK3ZVOVBoRVZxNUFrU09uOWhS?=
 =?utf-8?B?RGtDbDhRN3VmZWp1WXdXRHhzZkZBZ2ZiTGIrdDl2ZnNTdTE3L0RtVk1oMDhN?=
 =?utf-8?B?ZEl4YXlxTUxyMGc4N2xvQVorZDRSVHJVZDVadlk3cWRiZnlQcTNlc3RuN2RK?=
 =?utf-8?B?Z3BUdlFlT1ZHWlBpbm9wQ0t4M1lsRHJxZzNCako3bEZOcmVmVmJyeGo2eTBt?=
 =?utf-8?B?M1R5L1oxK21ibnc2emZ3LzFzdm5iM2JEUjBvNDQrTHlhYmo5clp0S1hJTzVo?=
 =?utf-8?B?NFVqMXhVZitUU0dZa2pTYytnTXZjeG1IUnYyWGIrak9vdUdyZUo2VkJrcWJG?=
 =?utf-8?B?MGh2bWNHWFhCQzNOdndOUTBHbStMd2orK2pUUUNwLzM1ekpTejlsRTNBL1BF?=
 =?utf-8?B?eCtpVXpobFd2RmdleXdaTG1tY2h4WDVYdG9pVFlWTlBrcWh2K0xITHg1Unpa?=
 =?utf-8?B?VjFSdUFseTFYK096RE5nMW9qRGNZZ3IrRGJsZ1ZVNjJPbFhPQVd1eFMyUVJM?=
 =?utf-8?B?WUQxL2UxdGNnN2ZRSWdJM0plKzloUnJpOFQrWFVhYTNCakJ3anNwZ29UaDBJ?=
 =?utf-8?B?Ukh3WXpVMUFvSnh5L2FLRjFkSkh0RmcyNmVZcTU4UC84Mkh3MmFKK0FzNjRZ?=
 =?utf-8?B?SlRVRTlOZXNuMndha000N0tjd3pqQTRsN0c3RVNHV2c4OWZaY0VVUzgxa29V?=
 =?utf-8?B?STlWNUEwaXJVYnNqa0E4TlNZWEVQOVlRdU5Da2Jhek91enl6V2FVMm5Rd25r?=
 =?utf-8?B?OXBUZUd3TXpxTERDWXRFOFBZR0hTbG4xVWhLN2t1TkljVHhGWmFETmdEYk13?=
 =?utf-8?B?Q3J2TVEwYW1pUlNwZVVySENhSzVlM05nZVM5TTVQc2E1Qmo5bnRZd0NQeklp?=
 =?utf-8?B?VXU4cDlQZEl2blQrdnY4ODdPYUFtZUVLTkFHanJBU3dPQ1l3b29YNWd5WGZx?=
 =?utf-8?B?UE5LcEgvb3llYzNEdmhNZlI4YkRwVzdpTHhYRUpnSE5zVGlob0JRenJxTktH?=
 =?utf-8?B?VXJXVTlUZmlOQmZlNjM0NXliSVh3cUVjWUpVMkQ3QmNKNVVOYm9sbk4zVDZu?=
 =?utf-8?B?SUtDQUhLYzNQUHBySTdqTUN3bXFMSzZmV0k4ZThuSy9COFFERFlsRFowLzNu?=
 =?utf-8?Q?F7VtOw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e3cfb8ca-7a39-4923-8618-08db24aee18c
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 14 Mar 2023 17:09:33.2236
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 8SXdDaPX9A216XF1YLWvcTjy+r6kt5EqYixIxBIFoiVtIR+W0vY/rOAq5ftre68F40KErcn9xpvQ8CsvCp6dWFWGsgeU0buoQXva4FxgZLc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA1PR10MB6050
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-14_10,2023-03-14_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 bulkscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303140140
X-Proofpoint-ORIG-GUID: fDgb5p504L24bB2kr1vvhzW6CiGEhHeD
X-Proofpoint-GUID: fDgb5p504L24bB2kr1vvhzW6CiGEhHeD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/13/23 1:11 PM, Dmitry Bogdanov wrote:
> +
> +static int tcm_remote_port_link(
> +	struct se_portal_group *se_tpg,
> +	struct se_lun *lun)
> +{

Oh no, what happened. Something probably got messed up in your patch
management because I saw the 0/12 patch said the coding style was
fixed up. 

If Martin will take a follow up patch or it's not a big deal to him,
I'm ok.

Reviewed-by: Mike Christie <michael.christie@oracle.com>
