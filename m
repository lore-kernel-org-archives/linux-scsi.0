Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 50170C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:00:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3697B61168
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 16:00:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232376AbhIVQCR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 12:02:17 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:34594 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231712AbhIVQCQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 12:02:16 -0400
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18MFqULM010075;
        Wed, 22 Sep 2021 16:00:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=t+yj8dyTzlhPoATrmYYculOMYAn8SFtL+icX6Tl/5ks=;
 b=dVu3otJf6NkU1s51bBPfnrYIEPI1BiwCpaAuH+19e3kKHZGiqSfCnybZ/fgnP7pOkqEV
 wOoSIYLztMP3HH3NhSZ/1fkVI3m94uN6nxO5F+BIledhjXeiPB5b9ZxdYipIV2KZt9pE
 wQXmgKFG5FYYUU3aytLY7ZunD1ckuOlG0F+moKwIQQnx5NFBrfX7MnGP0tBFgl9HDjWf
 kFUMu1eIXHK9lUlVM7fFx/l2FZk7gosi6i7w9jYGcTVxcEb1CTLvqUKvI0xjQ+6ArC5t
 sj0Ka82guu9kq25nKmgx8HKuMadWX+f3BIMnI1uXhNOU+gpJDhyRMIQFlEwfA1Fwm0V6 DA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4pcnsq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 16:00:45 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18MFjrQB082728;
        Wed, 22 Sep 2021 16:00:43 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by userp3030.oracle.com with ESMTP id 3b7q5n60eq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 16:00:43 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RD/lS4udNQwfrtyv2DDMUkembVMv8Dbhff/2cUHCiMStqKfmtJZvvK2+eEvRlYYPfHyGxUiRwOCJXbLi7RFh1jznDX9VwWiQrlt9+HqFDrNijNoednF8L0hE0REFEmsqL8SqNLt6E4SvKO8QmbI46vye9gbRF8mDKR9wKhsrq+x9qvD86RSoLYi2IhPSoWxn8gH1O5n3IlEQU4wNBGEM8NOGPztUC03DxcW5TX616NnCA4vSccgmaQMp9zAx0YNcJRO1PymgniUUEK2pUbGAJP5Zi0EK6TmP3P+9smUSKFQtXiAVg/FpVQCuI+0/0OaV8oQB5Q4Vki1cLnoDzYpgzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=t+yj8dyTzlhPoATrmYYculOMYAn8SFtL+icX6Tl/5ks=;
 b=kTj2r7lthcTa/M1H7DA53xRVctw7GY2ZQb+g+bNjJ4ICndbZ5X3cgNvyJQmuaRwlupl6ONjMIVqkiwT/KcBJc0OySwZrPOv6VNYTJuqaUbK71nlAvORkRxPD2VpSl0qdrZGDnLTK9Ot/zSyMljIbCnr28kxGp70mmqW0QfxLkOeYMoYGuI+ZylPApwmG/JpIbsXdZnZDVZVE9Ix1az32A14FSrUwwkP6dYVfsuFh46vWdnT8nDjUp9pBRAD1vKi5QmhegM7IrBTA8qSP9Nc/LfMYZFziEECPcOzb1EU2kWp5RtRIuRLZ/EceCF8T8Rms6iDFvuTM06akPs6jhTMKrw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t+yj8dyTzlhPoATrmYYculOMYAn8SFtL+icX6Tl/5ks=;
 b=GKKFCOe2JIir7OUnk98izqrF6syqid5vq564+NPgmnf229dQGeL5gdouK5/Vr2t2vf+JgkQFlu/7GbJB8lwpUF2w+lsdbB1zraXjf5G0bnDt1J59eABDtpe4fNVcCCoFGthYhXyy73qjgANp3f/YhiOE8eoFq5qJU4ap7i9J+UM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BYAPR10MB3528.namprd10.prod.outlook.com (2603:10b6:a03:124::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14; Wed, 22 Sep
 2021 16:00:41 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::5881:380c:7098:5701%6]) with mapi id 15.20.4544.015; Wed, 22 Sep 2021
 16:00:41 +0000
Subject: Re: [PATCH v3] target: core: remove from tmr_list at lun unlink
To:     Dmitriy Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux@yadro.com" <linux@yadro.com>,
        Konstantin Shelekhin <k.shelekhin@yadro.com>,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20210915141719.1484-1-d.bogdanov@yadro.com>
 <40b321b4-76bd-8eb4-84bd-c7378ad2bbc7@oracle.com>
 <8f81906545014a768a7f775d1dcf51cf@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <9ca9ec9f-bc6b-9aea-3b5a-43ce5fd09b5c@oracle.com>
Date:   Wed, 22 Sep 2021 11:00:37 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
In-Reply-To: <8f81906545014a768a7f775d1dcf51cf@yadro.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR03CA0075.namprd03.prod.outlook.com
 (2603:10b6:5:333::8) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
Received: from [20.15.0.204] (73.88.28.6) by DM6PR03CA0075.namprd03.prod.outlook.com (2603:10b6:5:333::8) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.15 via Frontend Transport; Wed, 22 Sep 2021 16:00:40 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 69065f31-498c-40fe-7931-08d97de22028
X-MS-TrafficTypeDiagnostic: BYAPR10MB3528:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BYAPR10MB3528031F846AAF4E1A66E47BF1A29@BYAPR10MB3528.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SUT0gXBOg/o3baJLYLMHfvnzEO2j4iGXvsoXSP+oixn2H41J4FhaRj4Z4CRi3ORt1sR6XNyHsmLHTgdn7F50XODRrxiNDAk4VMY+M5A0gSuOudBODTo72W2bib6vyWKFJvkJHt/iJmPEqxY0Er3IUrsWbbZdWMP0c8CUklpu+jk521x6wGf5MuhYrOlacSIPFA3mhn5VZl8GKASs6CChW6JnADE9oeq1LXW5xcHBTHyVJq9IkonrYBupKBrFLvAwCho4tmoiZyZ8qfjBf3ka5Z7HMzx6ci1VDJWMQGeaK/9xpx4bjPZEAxpRX7C3/tqaVFKOI/88cisraDGJ31PSTZtCwwmmAqx32qmcaE1mgN6/w4T8R3wmyPWRZ7cUcE68iks/ci0VMLf2BXmB2llyC6H8fcHikqpCwmCVSXqIKyfFY3ncjH3vzQ94bgEHUu1/2STUVepmUVeWsn90qFwfI/PpHUxze/wZtVZrDsY+w/d7/gzw82UU4PvDXjTw6Wr5RXtFLkwXZXeX74o5qH+oGiZKhuQhorwU8xwl8GMVAu9ISuaB3rfmyIRCh2oxhftfQkhOkVZXVc1nCH1VlqSWkQLLkonTOM9VWT2QBLt9ZEXqAbOjaqIm9CDvAobUl49SSX/DQwhHmwW8sRuAcol2w4YZFz1DrytSEDlZmxj9q9UTQ2L73vkhzlPs0aGRZp/2bF599LWXtjLjFwabcdVDpv+J24DFm1F0hO9qaX+pwXYNLB9EAfuJ77EZhf6v7L9I
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(316002)(31686004)(31696002)(53546011)(86362001)(508600001)(4326008)(26005)(6486002)(36756003)(8676002)(8936002)(38100700002)(2906002)(110136005)(5660300002)(66556008)(66946007)(16576012)(54906003)(2616005)(956004)(186003)(6706004)(6666004)(66476007)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVFXYXdabDFxOXZWM3hLdkhBeCs3UURodVRpNlJ5RFZpWk5mTWJ0MUpGeEs0?=
 =?utf-8?B?QTZKUUxITGxUdXlpQkFZY1ZlOVJDbGovaDZqZkREVFVvbG8yU3JVNm9CL2Nj?=
 =?utf-8?B?Q2hhWUptcGZ1eWt1SDd5QzJUSzVDcUNSK0J5cmFCWGU1bEFMd2hUSitGQ1ZC?=
 =?utf-8?B?ZUZTZjZIUmM1Q3hza0pEa0dHTC9yMzM1NGkxK3lEcXVpaXUzZU44aEkzOFVE?=
 =?utf-8?B?L1hNKzV6ZlAxcVhpWm1qTmFQWVkzWGpKVDdFUno4cnV2Z3VML2d1b1Q2Umlz?=
 =?utf-8?B?Vm1pL0VZRk9MTlNSUFVWdzJVVUFRWEVUdFdHMWUzUGtvdUVLcEM5djJtMTk3?=
 =?utf-8?B?TUs1R0VwRklpNVhlV0dpTXlYZFU5MTJFZ3kxS3oxMWo4Ty8ySDhtMWFaV0pp?=
 =?utf-8?B?UC90eWVNOEdhNGEvTUFpUnlvVVIvb2VlR1p3Mm9hMkE0UmkvendjTEIzZXNw?=
 =?utf-8?B?Z0FmcVJkZGNvanFKRFUyYkw1SjRwY0dvazl6M1NNbDIzejREbXdhWmFKY0kw?=
 =?utf-8?B?b3lCcG10aWhIZSsydVNnQnF5TGF5aTB6RC82TzlwdXhzaXZJdXh6SHVMUXhV?=
 =?utf-8?B?NUpIdVhwVUtNeXZ3eUlKTUZYS3FlMXNVNGYvd011NXNuM3owTEUxbnRMcHdD?=
 =?utf-8?B?QythaENITmZsayt4Qk1mLzVCYWxhUW9TU2YwWDdVc1poTHdhRUhFTE81bmpJ?=
 =?utf-8?B?M0VMSC9ra1pZSlFJbFhVVmd6SDZGdVNXTGwvOGFPRGg0cTBrZFZKaklPRCsz?=
 =?utf-8?B?SHFUUHJqc2NINUppTUE5MGVDUVhDd0dTdUxENFhZZFN6b0Z6TEprcW5BeXBR?=
 =?utf-8?B?QkZQLzNiTUtneVJnWjhlcUpqbVQxbXBTdXJlS1QwdGFhVWxXY29hUmUvR2gx?=
 =?utf-8?B?Q2l4K2ZxUk5naVc3WTRTamlTRzNFYXNlMUd1ODhvOVBPVUNyMUI0NHFqUG53?=
 =?utf-8?B?WWZzMkNPaWhoWk9tMnpFajJRSWpleG1nYkdUU290OXlyRUc3UlJtbWszdVhE?=
 =?utf-8?B?ZmxDd2YzWTdqVXBWV0FYS0I4UmZrUkdJWVVPMklJYjVNTWM0VXNtTzF0dHN6?=
 =?utf-8?B?YkNHUzhiUjc4eDNMckVqbWtuVERSVVFwMy9pZFRRMG1HVkRTU2hwMVlhWXM0?=
 =?utf-8?B?K3J4dkM2NmJnRVlERXgyampqN0RQeFVOZWlOOXZ0ZmVtVXlPQW1HY2s0NzBy?=
 =?utf-8?B?aHJZMFJXK1lQQmtiZE1xK0t0MmQ4OC9CTVQvdWtVU3kvVlFZKzNxV2l1QkVt?=
 =?utf-8?B?eTF6bi9WSnBHWVc2NmFONy83WWJ0bkdWVGtySjJsbndjUVRudDdsaWxIaW01?=
 =?utf-8?B?Z0JUL2p3RnlLakVhYjRpUlVTOVIzRWdKRDg3cUlyUURQaVZpNkR6WXYxM1N4?=
 =?utf-8?B?MmIwcUZKR0hBbXc3U3V5ZGV5Y3lNb1ZSRE04c1ZOZXlud1Z3L0lxWDBERHg3?=
 =?utf-8?B?OFcvNUY2Yjc5NEdLa3FVNmJvMDRQdzMyb1J4akRFeDRLSWZLczZnTWdKRHlx?=
 =?utf-8?B?ZVhZc3RRaFZCZXRRVVJhdmwrWC9jc0RwMnJ5UzRuNk9XZ0lFTTg2NDV4TTB6?=
 =?utf-8?B?MTFoK0N5c3BvMzBUU2tXY1BZa2w2eTkwZU4yZThaQlZqdDc4N3Zuc2xRZlFS?=
 =?utf-8?B?WVFmelNVc1FiZ1V2YVdEQ2tmYTdZSEViNFNod05UUzNmanhsRFIwSFJUd05U?=
 =?utf-8?B?eFlmZUZVZGc0dDBTeG1VUHc4RlJQY3k1VlF6RWVVS29HcU1ndSs3SUlDYVNh?=
 =?utf-8?Q?sRng8O98sT3UuvrNIHQ9DfR5pv6HAsRb5bvgnvY?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 69065f31-498c-40fe-7931-08d97de22028
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 16:00:40.9337
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 66ZfhDbB1JUT/LjOUZgN9Tq9PU4bQhywxh77Pk59YjgBsC7op3KfNE8ZLLaTqluBcXm3qbv8f8RubIdwMoQtf1DshhFrrGvan55keozXk3E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3528
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10115 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220110
X-Proofpoint-ORIG-GUID: QmV929VvqLo9ZOTaBj3-S_v4VjLFOobt
X-Proofpoint-GUID: QmV929VvqLo9ZOTaBj3-S_v4VjLFOobt
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/20/21 11:40 AM, Dmitriy Bogdanov wrote:
> Hi Mike,
> 
>>> @@ -234,6 +225,7 @@ static void core_tmr_drain_tmr_list(
>>>  		}
>>>  
>>>  		list_move_tail(&tmr_p->tmr_list, &drain_tmr_list);
>>> +		tmr_p->tmr_dev = NULL;
>>
>> Is this patch now adding a way to hit:
>>
>> if (!tmr->tmr_dev)
>> 	WARN_ON_ONCE(transport_lookup_tmr_lun(tmr->task_cmd) < 0);                      
>>
>> in core_tmr_abort_task?
>>
>> You have the abort and lun reset works running on different CPUs.
>> The lun reset hits the above code first and clears tmr_dev.
>> The abort then hits the tmr->tmr_dev check and tries to do
>> transport_lookup_tmr_lun.
>>
>> For the case where the lun is not removed, it looks like
>> transport_lookup_tmr_lun will add the tmr to the dev_tmr_list
>> but it would also be on the drain_tmr_list above so we would
>> hit list corruption.
> 
> Yes, there is a such race. I think,  I can solve it by changing the order of
> draining the tmr_list and state_list at LUN Reset to make the raced lines 
> be under the same lock.
> 
> Especially SAM-5 describes(but does not require) aborting commands
> before tmfs:
> | When responding to a logical unit reset condition, the logical unit shall:
> |	a) abort all commands as described in 5.6;
> |	b) abort all copy operations (see SPC-4);
> |	c) terminate all task management functions;
> 
> 
>> For the case where the lun is getting removed, percpu_ref_tryget_live
>> would fail in transport_lookup_tmr_lun and we hit the WARN_ON_ONCE.
>> I think though with your patch, we would be ok and don't want
>> the WARN_ON_ONCE, right? The lun reset would just wait for the
>> abort. When it completes the abort and reset complete as expected.
> 
> I don’t understand the meaning of that transport_lookup_tmr_lun there.
> Every TMF Abort has already executed transport_lookup_tmr_lun at the very
> beginning of its handling. 

Yeah, I think it's not needed. It came in with:

commit 2c9fa49e100f962af988f1c0529231bf14905cda
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Tue Nov 27 15:52:03 2018 -0800

    scsi: target/core: Make ABORT and LUN RESET handling synchronous
gree. It looks like it was added in:

and in that patch I can't see it ever happening. We have 2 ways to submit
an abort tmr:

1. target_submit_tmr - Calls transport_lookup_tmr_lun then
transport_generic_handle_tmr.

2. iscsit_handle_task_mgt_cmd - Will call transport_lookup_tmr_lun
for every tmr except the iscsi specific TASK REASSIGN. TASK REASSING
is not passed to transport_generic_handle_tmr.

I don't see any places where tmr_dev is NULL after transport_lookup_tmr_lun
has set it and added it to the list.

So I think you can just kill it.
