Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 414DBC433E0
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 21:38:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D3364E31
	for <linux-scsi@archiver.kernel.org>; Sun,  7 Feb 2021 21:38:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229570AbhBGVih (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 7 Feb 2021 16:38:37 -0500
Received: from userp2120.oracle.com ([156.151.31.85]:39040 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbhBGVif (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 7 Feb 2021 16:38:35 -0500
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 117LYp18172832;
        Sun, 7 Feb 2021 21:37:48 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=joIo9W2aZjI8g7o4MA3N+vIKXbU9r1WsDqUyzF8KXB0=;
 b=UTp2W34Fr0g1GOweBGUGZKLlbARPcvW7lYJfmSnoreoMZo+FpUcaAiEMmqJOkoJ4kgHn
 jC4tCmzItJxwUqvKjPjF0xUnv+gjAxgIfgbQ3Dq7xJPG/hTsOq6vX+LSCAdTTMcPYx7i
 uTbaVhSl2wyuK7Ct84UmOPMQYCfaOJGmBfr6OMegCINgt3UxhPHg5samKcPF7NXWDemR
 Pw4UZA6x0oHUhs+1p/X7WE7FiU4BZup6ITZkGMVa5NDEuI+4kuV5DH0f7to/zOMeDmUn
 3DlIMAhNLL87see8C12DhhXp92zYWJEXxnkLzteUYlMznWnSCMPn4RhLWuTD+AHcnpwk UQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 36hkrmt88s-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 21:37:48 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 117LQWWw073213;
        Sun, 7 Feb 2021 21:37:47 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by userp3020.oracle.com with ESMTP id 36j4vp49pa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sun, 07 Feb 2021 21:37:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YAz7bN5bfukrKjxAuU/leuvz7EagpozZknq5cH0EiAALYllkH/ad77tgVfHJNDS1dfaKiz7DNAYWajcWceT/3UjfHnA9Bp1eNNZNfMMcu+I0lt7xcTYDL1hVa/tdAgfVqZeCPLFt72i1HuJ63dFQ1nuTDg/lcgMRMmfM7IYKvQckI/wd9uJD1TLsaOsdP7h4qB4Ndqfn6kdsvlTu5BhT36lOY6LMms1aM8v+73PcINLSJZ8HPfhGD+uRw5omuxM6/BSOweY7nf2e1N2GJlbWo0Dz+kL5YCai8FxamD1eTqIdN+8Dr9jNQaeENFOZHwbRUH4vPMR3TK4nz7wanY2bSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joIo9W2aZjI8g7o4MA3N+vIKXbU9r1WsDqUyzF8KXB0=;
 b=hlNE0EDArVXshq/vuzRjFPh+FMUOrX+hAdJSkrXvxwck1TOVgBnIEOy/e0CXVkjRd+DvX8BY0wsBeFnTsj5e21dfiwyGV/3t+B48A1wfjSf3jj3GFcHu1/+xeaXbhbgiPhZgiH03HWepTsdncAFNEF6ZleqD3KtYXwtLI7yx8UZQHV3NFT3A2qQgHdktBYsfOrfjoWV9n7ZG4gOn2s11ODRJl9G+lPDcKzEIEh7RrrACHdx0wphraUFpiWsGh6vJCnFgtBlizifSZxclaKQtGLtfuNyGjoQIkGqMA1STZiOFuBSSUvs7+/v0mXIvHLffYuz2KYqox8h3JbiBhvsGow==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joIo9W2aZjI8g7o4MA3N+vIKXbU9r1WsDqUyzF8KXB0=;
 b=JPF0cSUhDXGsR7MFN3gDLMkeBC9pCnvuOuz2jLwI1tT4ZfI9fu6GdicBrYrUfn4eqMMFpbZ8X9qxvJCs+A2fPDsOkeJXReQP1ItJyI5w4vZEIRimvPQZfJ8Tn9sfxidekqFWN6JiTd/KZwxuX2InRxLoJeebSCctaDCl2+1yVHw=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by SJ0PR10MB4621.namprd10.prod.outlook.com (2603:10b6:a03:2d1::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20; Sun, 7 Feb
 2021 21:37:45 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3825.030; Sun, 7 Feb 2021
 21:37:44 +0000
Subject: Re: [PATCH 09/11] target_core_user: add backend plug/unplug callouts
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>,
        "mst@redhat.com" <mst@redhat.com>,
        "jasowang@redhat.com" <jasowang@redhat.com>,
        "stefanha@redhat.com" <stefanha@redhat.com>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-10-michael.christie@oracle.com>
 <BYAPR04MB4965AEA5583DFC889C8D5E9D86B39@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <172937c0-2724-5a71-8905-4934a197eed7@oracle.com>
Date:   Sun, 7 Feb 2021 15:37:41 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <BYAPR04MB4965AEA5583DFC889C8D5E9D86B39@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR16CA0015.namprd16.prod.outlook.com
 (2603:10b6:610:50::25) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR16CA0015.namprd16.prod.outlook.com (2603:10b6:610:50::25) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.20 via Frontend Transport; Sun, 7 Feb 2021 21:37:43 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1489c469-3ffd-4eaa-06ee-08d8cbb09aae
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4621:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <SJ0PR10MB462131651FEAC46F185363BCF1B09@SJ0PR10MB4621.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2cZgtbQwlvF4wqEKwFavM6yz4YZA2XO1FZowsaMX8tq3hMFG3f3dwqbsD2LMj+DbbGbJpX06uXwebJkSNF8cr5f8zhj9lajOQ17K6d9IwRPYsUSb4HxGV0OGwqFAy47MqkkFdUcJXck0/xLnbD8C5dL3rREgs/yGY873UrTcHbOcvQk0iihHBe/aFMZ909TmMdbNs86Zf+2cqDannSppXHKKQuhw1bfF0wiXPSJhiTqfTfSjLf7HjlDuJMBSFcL1MjZPKrIJyeSHKwfgzO93Zeq5h90OxHhZ+okSohAwJ5oWjRElIPIK3iW8rjayBxroQqw3pEbqUHhHeZoZUr2we8MqlWTVQt4GbB9cTZqvOIp2Do06H1NHZIWjrN+Gu5mDAcDzxo8OSxbnF5oa0mPPwbYVEaKc6HE2PPwqukBOEvSgucQaFpyyU7yl2ZaQ/WcYkSiuBNAwKoNAJmol5AESC984evXmL8XBDWHWlHbMeD0Nc9cANNp9oXHRl7HN7sajrrZxMNxf34zOZuVauXvHmMlQ5GbZiyv/v5lLLltI8+d1ylC9iItyFvKPCag+HcCsmj1HEpx7ISmCsZRvkbQDeSz5M923GbIYio/ZMPOXbrk92pPdJ7Fya13yXKPkW6MO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(346002)(376002)(366004)(136003)(16526019)(36756003)(316002)(186003)(83380400001)(66556008)(26005)(66476007)(86362001)(53546011)(6486002)(8936002)(16576012)(6706004)(31696002)(5660300002)(110136005)(31686004)(8676002)(2616005)(478600001)(4744005)(2906002)(956004)(66946007)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?K1FieWY3dXVHY3V1akREeW1Oajc3QzkrMDBYZDh1VTdxTzlLYTRaaFpralpl?=
 =?utf-8?B?N0pSNnh5V3R6MEtYR3BWcTR6aUozTDRmRGRyV0tDUktHaER1d1lOMFQvWTlI?=
 =?utf-8?B?WVlUckpwZm9hRzVWYkxZN0U5QTNmODMwRlNTQ3lBTTg4YXBJaHVNTjc5QnJZ?=
 =?utf-8?B?Q1Y4WEtSeEhCSytWUVMrclhSSFlzWlV0TEZaV3laVE1PSFBjSDZiRDNlVjIv?=
 =?utf-8?B?L2FyeU9udnBDVTFiYnJiN3ZacUU4NmNHcVRpVFZxcmZISzVrRWh3aWpEUURv?=
 =?utf-8?B?WkNtWFJoTlhKT3dwbElnSUhjS2ozR05pRDMxQUE4OUJpVzZ3UnJ5UGxEYlpo?=
 =?utf-8?B?MEpyZ3lDUXMxb0U5QnRMaytpS0hSMmZrU1N5eEZSNC8xV0JLZ0RYazB0VW9G?=
 =?utf-8?B?R256WWxtWW9CYWlEMFQ1WXg3TXlLMmxMdHVxc3d3Y1kzUUxLZVhqcS9mSWFv?=
 =?utf-8?B?OStMY0thcExTczdrSlI0VDNqOEgwTC9FMmZTdHcrczFtUkM1UytWY1gxTGQ3?=
 =?utf-8?B?Q05GMkpyZ09uc2ExYkpFb3A5bW5oYjI1SzlWYkEzT2RJQnYvYWR4NEtLS2Rn?=
 =?utf-8?B?aHZENlBjcnFLb01mVjdWakdVcjR5dXdvWWhyL0c5cHBkNktIbnNWMFArZlJJ?=
 =?utf-8?B?VmhuYXhjNWlkMjhhVkFoK1NIcnBhUVNNcjltYXlWRWdtc29ISGZ3OWxJN2ZH?=
 =?utf-8?B?eXM5SXRvbTRGVHlUMWcrT2pqSGprRzlXWDZvMjR6MWt6Q1pRY0xuc2NhOGZC?=
 =?utf-8?B?NDNwdUZidDFBeFFiM25xeXFheWFqeFhYdTJHNEh1clIzRVBHZ05zY2lKWU83?=
 =?utf-8?B?blRhNEt4UXM0MUJtODdyVklmMHp0eFc0NnhVUm9iYU11NDFxQjZ0K0xUTEZX?=
 =?utf-8?B?L2MrK1dHTG9WSGdjaGZtWHpneENDTHZkV3lJRy84ekNqVmwzMEhrZStuM2NL?=
 =?utf-8?B?Mk9SVlBGMWh6MC90U2VUWm1MKzRoeXR0dHNMZlMxQVQ5MEZVbVlnYWZwN2VH?=
 =?utf-8?B?TkVWOWt1RFlLRjVQc2xuWllsSUtMeFVlcU9yaHRSdGVRS2Jad2IrdC9Lb25y?=
 =?utf-8?B?TGJ3TzVyUEcreHZXQXlFbVVGQXQwZTRERmQrbzgyQUFPaDlUNmszamJrM0Ux?=
 =?utf-8?B?ak9BMnZ2c0h6d2hSV3VyMzlnN3g2empQUlVyZmt2ZGNpZEFnZ1FFMERnZHVJ?=
 =?utf-8?B?ZzFSUm5qSEVoNDM2ZHBhSlM2TGp0V3VFMTQwNDV1Nm9mdUhvMXVORS9CYk56?=
 =?utf-8?B?Q21TbE5TcktvZHVWcHp1R3V3MjJmNzc4dXZqQUkvSzN5dlJSTGxhVCtaOTV5?=
 =?utf-8?B?RUpPcWJTWDc0c2RDblRINktGQ1hKb0ZKbjlaeGxoaXNTVG9YdjNLTytUamFH?=
 =?utf-8?B?dnJMeVZTNXRZMzc2QjVKWTkvbW1Md1l4N1NWOTFjaEI1M0RPQlFhV3huTVlr?=
 =?utf-8?B?Ym9oT2M0V1JybWdQZTc2L0NmNDM0NERrY3hUYjBoNEhISUVPSHVnY09mWFV1?=
 =?utf-8?B?UVMwVGNTRlRPdWtJcWtvVlk3bkV3NEwvbTVtMHhmbm93RTNqcXJRVzcvbmlG?=
 =?utf-8?B?bHc1ZlBKMG95RE9wbUtuZ3h1aElDSE1qV3RGc09DamgwZFZEUlBjUzVqTURL?=
 =?utf-8?B?dWlNQ1ZiRU1ZSTZkTDVMMm11UDE2M2tqODFJMWp5bjBOamJpT09Yci95b1E3?=
 =?utf-8?B?UDhkRVorWWcwb1JMSFNCbEFIOUxiK0JtRHkyWkdLS2IreGVBTy9EaFpzcFh1?=
 =?utf-8?Q?JRvNCd7A28QPA+q8+c4eUvnByO5b3aKd2FEh9xD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1489c469-3ffd-4eaa-06ee-08d8cbb09aae
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Feb 2021 21:37:44.5802
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pexqjUZrENUhr9beRnM62TDwX/nhH6t4DeTXOgZSXrfOfyA1dHZbbnmia0JX0ZPIa8EqO+pT9fwqczbVIn/O1Nr/4QRxAI0mzLcI5kMDCPA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4621
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 mlxlogscore=999 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102070155
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9888 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 priorityscore=1501 bulkscore=0 spamscore=0 impostorscore=0 mlxscore=0
 suspectscore=0 mlxlogscore=999 adultscore=0 clxscore=1015
 lowpriorityscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102070155
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/4/21 5:25 PM, Chaitanya Kulkarni wrote:
>>   * queue_cmd_ring - queue cmd to ring or internally
>>   * @tcmu_cmd: cmd to queue
>> @@ -1086,8 +1108,8 @@ static int queue_cmd_ring(struct tcmu_cmd *tcmu_cmd, sense_reason_t *scsi_err)
>>  
>>  	list_add_tail(&tcmu_cmd->queue_entry, &udev->inflight_queue);
>>  
>> -	/* TODO: only if FLUSH and FUA? */
>> -	uio_event_notify(&udev->uio_info);
>> +	if (!test_bit(TCM_DEV_BIT_PLUGGED, &udev->flags))
>> +		uio_event_notify(&udev->uio_info);
>>  
> Do we need to keep the TODO ?
I think it's not helpful.

The reason for the TODO was to avoid calling uio_event_notify for
every command. I think we had thought we could just key of a FLUSH
but then later figured out we might not always get one so that wouldn't
work. The comment should have been removed or if we like to keep TODOs
like that in code it should have been updated to better reflect what the
issue was and the idea to fix it.
