Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5D829C433E0
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:05:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 28D7664EE1
	for <linux-scsi@archiver.kernel.org>; Fri, 26 Feb 2021 16:05:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229586AbhBZQFl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 26 Feb 2021 11:05:41 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:60702 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229566AbhBZQFh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 26 Feb 2021 11:05:37 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QFt5d2187185;
        Fri, 26 Feb 2021 16:04:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=6DL1HQxzxeqzso9Pkfw3fWuxfBFvv+uRUjRiN6M3A5w=;
 b=ruiXc31AurTC1OumkilVRGDB4X4QA2rbejgAoLxT/21Fvf9L1z66DNcNoIYGWmpnGg2o
 fHNf7yvWPGY5Bmw6AXmIuGOW2zJFcjifY6dEjleb3GIMprp/lgWW4BVCgTgT2pRCCZow
 l9JeXVhjKMfJzwj90XpjLMATi9pOfyEhR9NGHrppJMYx5Zd0auAN9NtbL0YuvbLklXoY
 AE4xH/PFfecWl3duBid5EcOKWFTJXMec2ckqFHlnOELD9jcA/CT8HE8tU+5dlEw9CBbQ
 nDlKLTwX1RUlkawRQ+Vbb1Qg2UKY1sV5UCRtqw/ch3qzcUr3CK07DOyl1qsTWt+L1b5o Aw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2130.oracle.com with ESMTP id 36vr62cudp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:04:49 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11QFuIvQ128673;
        Fri, 26 Feb 2021 16:04:48 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2175.outbound.protection.outlook.com [104.47.58.175])
        by userp3020.oracle.com with ESMTP id 36uc6w2ekb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 26 Feb 2021 16:04:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TapRZ7UsuCf2Pxasg0R4uVLce2qaggjUMt8bY1eMI81i7zPxI7g389Zs+Eprc2iA8L4xBGbU4MRwCa218gx4xsTseTF3naoBjRb+EKQF0kMP+1PGjRm6uD3FPEFhIdEqJJf6kYCePm8D/+u2src2QH+YPinUQKoCao5nKJFNHiBb4DLeVvtwr+4/KirpgSChOFc8x/hvaXm9WmI8ZtbOFMubEq8m7ZJmkD1Qo4N7v3XlNVte7xvNB7Y1Lv9416ird/nppTm8U+G1itPr2+s4Uo3zpg61cA2R3KaiW5R1H5LNL9PbSVrDrkgLW2YkNsVcU1vP58V5+h6leZ51rlEt/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DL1HQxzxeqzso9Pkfw3fWuxfBFvv+uRUjRiN6M3A5w=;
 b=Qq1QCEAQfUsoWcywGF5mEJrbuKtIgEqZzxKKSs7UTxkl7NXJJFZNbZl1Hu3h7U1gOQ7mJSoVvXTXaclC47iTjGMNbOij+xcKNBSQs6wR4FPBU1tW5T2UpYZbYYj/pUzXQz/kKEzO4oLILLu0Lk1qI07YcyCeWjZz4U+/4cSvsvGSLAE8NeP6wZ4T235vmQlue5+PAFkcqDcIEnymdRRAjS6oUGUuaQ18Z/NZS++Kds7B0veRTsKCdTjKggBUnn2MIA/8603o/WD78F/NeQpM1S8W8OpBmdhCQCFGzhxkPkB+6t+orMV4l7O7tgjuxehWLbYdQv8FMAQGrBn9kA42AQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6DL1HQxzxeqzso9Pkfw3fWuxfBFvv+uRUjRiN6M3A5w=;
 b=cjs3zRdnWo2Lj4jRMdYoPxgG4vP22r1Qp0G3WE3kCP9YFFBpRfO6yL7I/j9KLy3AzpY5d7fSB6c8ljJ6yfdAOEGwwAuFvo3WEebsO0R/FBGyUL522VorFGgmutLNeqVjrn0t3NYY3/7HdgLtc0gnzLFIf1l5Ypqz1wg3u4Og8nE=
Authentication-Results: infradead.org; dkim=none (message not signed)
 header.d=none;infradead.org; dmarc=none action=none header.from=oracle.com;
Received: from DM6PR10MB3577.namprd10.prod.outlook.com (2603:10b6:5:152::16)
 by DM6PR10MB3818.namprd10.prod.outlook.com (2603:10b6:5:1ff::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Fri, 26 Feb
 2021 16:04:46 +0000
Received: from DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b]) by DM6PR10MB3577.namprd10.prod.outlook.com
 ([fe80::5120:8a97:3547:bc3b%7]) with mapi id 15.20.3868.034; Fri, 26 Feb 2021
 16:04:46 +0000
Subject: Re: [PATCH 0/2] scsi: target: tcmu: Replace IDR and radix_tree with
 XArray
To:     Bodo Stroesser <bostroesser@gmail.com>, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Matthew Wilcox <willy@infradead.org>
References: <20210224185335.13844-1-bostroesser@gmail.com>
 <b36fee7f-6fdc-b5de-3a7b-4396e5f9aab1@oracle.com>
 <4a1fece0-fc3e-9588-6494-aaf2270d6ccd@gmail.com>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <6aed57e4-5182-ab99-ad65-c7444db56527@oracle.com>
Date:   Fri, 26 Feb 2021 10:04:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
In-Reply-To: <4a1fece0-fc3e-9588-6494-aaf2270d6ccd@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR16CA0010.namprd16.prod.outlook.com
 (2603:10b6:610:50::20) To DM6PR10MB3577.namprd10.prod.outlook.com
 (2603:10b6:5:152::16)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR16CA0010.namprd16.prod.outlook.com (2603:10b6:610:50::20) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.19 via Frontend Transport; Fri, 26 Feb 2021 16:04:45 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7084ba88-bf9f-4600-bf9d-08d8da703c6d
X-MS-TrafficTypeDiagnostic: DM6PR10MB3818:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <DM6PR10MB38182684BB7AC201E707F7C7F19D9@DM6PR10MB3818.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kX9zNw9CKM7/LiZij91Ozb1pPPir6giR7d7Tz7TIBJZpQCmrtt0dZBmzgvasyR8KnL4v4hK1BKS4MiX7nLjINXgpIooxAGRfnnElG2a87155eaDQACaBsjBPPmeHFxOzNC7prSG8ctaw+jLc/fWLDK+KRW4jF4yOLAMDhd6RzFtzBzFHPD3Ql2GReqOxSmenp7q+dqQoGOrkcawvJVKoQAr/FaXlSv+r7Ql1vxhx33KRfY6PZUuaSL+STtosq66upm/ZrLTdc+UTVDUdA7TgG6F7WLSfA2SN5rxlPP3HxtzEkwwREKje1tvd5GDfEauffI+V2mqbU3WaDP0myxhzqFFfIq1MzygxVQppfFZbtoqQdEJAuJodYUGDLtl2rJgu4MZ3f/tvTRSm+7AQ/pUlj/PcotYwPo0VLO5v0QlT3S53HQshuTh5uVCEYKxn+ySJmo+BIstJdnWPSrvRmy8QfQFUT7bjP8xnKVfU3S8QhZH9LHvzG0usnilY3JcwP9XStE7QKL8PmKIM4/6fGWzISbzSf6S5cTPb6QafZpvcerDo4jLezgpqJ1UBZfz1pRdGusc9i5xkbnNN6tTPTKLIfnH9dzESrvDIex2uEdXUhFyYdB6NdPLaXstH4uiEh9J5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB3577.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(346002)(396003)(366004)(39860400002)(136003)(53546011)(16526019)(6486002)(16576012)(110136005)(31686004)(66476007)(66946007)(2906002)(478600001)(31696002)(86362001)(8676002)(36756003)(5660300002)(8936002)(26005)(316002)(66556008)(186003)(956004)(2616005)(6706004)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?azFQaDEwR2hLUGpVRWVaRnlRQ3RDQXU4NUdrR2FJcE5QeCtRTi9TWXFBTjNa?=
 =?utf-8?B?VmlISlU5Z3FSUkx1Y0hpU3hmWjN2aHYzOURsN3ZYN3hjMDRkSzgxRTFKVWZ2?=
 =?utf-8?B?VkliVWI2cmJBUFRXTFpINU9aYzBzZVk0SW9nTUw2QTZSOXFsVmMxa3Ara1Fv?=
 =?utf-8?B?OVZGWW82QTFsNmZQeXF1SWpHOXhqTzBleDVQODBIcGxSWHdZd3EvUFNMYXN4?=
 =?utf-8?B?Y09XSEIvSysyL2hodUVkVnBoKzZidml1NTFEMitpQm9qSGZzVURtZEZsT05L?=
 =?utf-8?B?SDl2MVRUc1AxRFhZQVNvb0RqWEhZNUE0WXJqZ29CZG1oVzc1Z1RMa1U3bllu?=
 =?utf-8?B?WmVrUWN0UEJUbDRoQ25PcUNYUWxCRVlSeC9WY21oMlkvQ3VkenYvblV1cWZh?=
 =?utf-8?B?akFzVkdZZ24yZm84YUF1TDBrQzNmZktQVUtmdy9sUGdOSS9pUFpsdlVvS01o?=
 =?utf-8?B?VWo5V29hLzJFSjFLK05wWlJ1d0ZVR2w0WExFVTNKc0Uwc3psMWQyWit5aWs1?=
 =?utf-8?B?SFhZM2F3YmdJME5JOEpJU3FQOGQ0enBweVlRVCs5SzQrT3VsSVdHN2phZEhj?=
 =?utf-8?B?dkx2RWhoeVJtZFhlTEN1YVBLaHA2Tyt5allBOERaSU9OYjhTby9CNThRalo5?=
 =?utf-8?B?eXVHdlNrMUMzZ0t6UVlKbCswc2pZZjBQWjZZMXdHL216VGlPN1hwQWtFbkxR?=
 =?utf-8?B?YnIzUzJhR0dUMWR5cXJSTFkrRGtWSkxoWUV6KzNPWEIxKzNTaitRSlNzbGdU?=
 =?utf-8?B?NWw3TFJ0N2R6VWNhSDVydWdoWHJHUHNsRkkzUFdhOTBoMlRzV3o2a0pGOXZp?=
 =?utf-8?B?OXRrTEZVdklJWUVpY2t0RXozb0JQK2xTSENGNE1naE1HSm1xTnJ1Vm96eEJG?=
 =?utf-8?B?blN6SE1kc2FKaU5DSS9iWjFCMng0RTc4bW9KRW1QNUlRbFN1Z1hLb2pSVENI?=
 =?utf-8?B?ejJIUkk0K01LcjJqTU5TWUU4cUhvOE9MMzZwSmtyTkcrYlJ4ZC9MK0ZkNDBx?=
 =?utf-8?B?bFVjMTlmdVVjTHZWNklkaUQ5dXZMamY3amt1NVM0bUV3RDlLeXdiTHVyTUp3?=
 =?utf-8?B?dnYvdjFPM1FoZUM5RWxJNkRZdzRJb2dpdUVFc0dRQ3VEWklxWU16Mm8vVDJC?=
 =?utf-8?B?bW9uVjJEeG1yOGUveXFWWlRSRXJGVWhwODRhQTZsN0srUjNDemVtWjR6YnZN?=
 =?utf-8?B?ME1IZnNyZ2plSDBMVXNMQ09oYXlIU2NhVThRZHJ5UXFPWkRhRUx1R2tnbnNx?=
 =?utf-8?B?NG52OHl4SmE4b2h0SFJZWk04WWlqUUpNM1FPKzEwcnkxVnAwWXJOdDlibU9W?=
 =?utf-8?B?ODBlYS9kZmhJWmZSUFVPdkN5SXl4eTB5Tk9ERHRIMytGQ094cGhGU0dITTlO?=
 =?utf-8?B?SG5TVzZpYUVRUjJ2T3FIZEkyZS9FNnlWMkdlZ2hJQWNWK1Vtck8wendYWUcv?=
 =?utf-8?B?RWp1QUJBT2t6cnZ2dktOOGVHeENXM2tXVDRmMDZmRzBhVnJ5cWpCTVMwdGVC?=
 =?utf-8?B?bG11QXVmcXYrR3RrSVA0M280OXlsdTF3V0hQeHBXMmp5VlVTWGxoQS9Zc2Zv?=
 =?utf-8?B?c3M1YldQQllzVkN3bTFvb2F6UTIwOWUxZ29zYjJKUDI1ZjNzOWdwR0ozbUdQ?=
 =?utf-8?B?KzJ5d3lXOVVjY3gxWm1yOW4yV0toTUU0NERsMGtSRXBRclkyNmVtakQ1UVV5?=
 =?utf-8?B?Z2lFR3pqWnNqLzh2K0JjRjgxYVhMa1FxOVgzd0FNNHJoRDQ0OUZzU1dtOEY1?=
 =?utf-8?Q?X3Sq4AKYX9cLKwdJTCDFdvFNMxriMVPQELfknoB?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7084ba88-bf9f-4600-bf9d-08d8da703c6d
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB3577.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Feb 2021 16:04:46.3090
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: kqV/mLZh3sY6xp+V+hel3RPxZGU5rKXuR53dbAZeBHjm4GIGIRWr4a0EfGyfyGYul3eW7lG1Ekwx7VgYg/Hfc8SCntIg6rBBjZ3MTWoJOnw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3818
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102260121
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9907 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 bulkscore=0
 clxscore=1015 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 impostorscore=0 adultscore=0 mlxscore=0 priorityscore=1501 malwarescore=0
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102260121
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/26/21 2:41 AM, Bodo Stroesser wrote:
> On 26.02.21 04:59, michael.christie@oracle.com wrote:
>> On 2/24/21 12:53 PM, Bodo Stroesser wrote:
>>> This small series is based on Martin's for-next.
>>>
>>> Future patches will need something like the - meanwhile removed -
>>> radix_tree_for_each_contig macro.
>>> Since general direction is to use xarray as replacement for
>>> radix_tree and IDR, instead of re-introducing or open coding the
>>> removed macro, with this series we switch over to xarray API.
>>> Based on xarray a future patch easily can implement an analog
>>> to radix_tree_for_each_contig.
>>>
>>> Bodo Stroesser (2):
>>>    scsi: target: tcmu: Replace IDR by XArray
>>>    scsi: target: tcmu: Replace radix_tree with XArray
>>>
>>>   drivers/target/target_core_user.c | 64 +++++++++++++++++++--------------------
>>>   1 file changed, 31 insertions(+), 33 deletions(-)
>>>
>>
>> Looks ok to me.
>>
>> Reviewed-by: Mike Christie <michael.christie@oracle.com>
>>
>> I think in a separate patch we need to change:
>>
>> +        if (xa_store(&udev->data_blocks, dbi, page, GFP_KERNEL))
>>               goto err_insert;
>>
>> to GFP_NOIO. There were some users doing tcm loop  + tcmu and
>> were hitting issues when GFP_KERNEL lead to write backs back on
>> to the same tcmu device. We tried to change all the gfp flags but
>> we missed that one, because it was hidden in the radix tree's
>> xa_flags.
>>
> 
> But then, for consistency reasons, shouldn't we change
> 
> +    if (xa_alloc(&udev->commands, &cmd_id, tcmu_cmd, XA_LIMIT(1, 0xffff),
> +             GFP_NOWAIT) < 0) {
> 
> to GFP_NOIO also?

I think so, but am not sure. I've always wondered why we used
GFP_NOWAIT and meant to test with different gfp values but didn't
have time. It wouldn't hit the same issue I mentioned though.

> 
> Additionally I have to change memory allocation in tcmu_tmr_notify from
> GFP_KERNEL to GFP_NOIO, since it happens while holding cmdr_lock mutex,
> which could also cause the problems you desribed.
> 
> Shouldn't we better change to new API memalloc_noio_save and
> memalloc_noio_restore in that new patch?

I think it's your preference. I like to use the correct gfp
when I can, so you can just look at that chunk of code and
know it's right. If you put memalloc_noio_save in tcmu_queue_cmd
then a couple functions down you have a GFP_KERNEL it's
confusing when you are just searching the code.

I think memalloc_noio_save is handy in other places like the
iscsi/nbd code since when calling into the network stack you can't
control all the allocations sometimes.



