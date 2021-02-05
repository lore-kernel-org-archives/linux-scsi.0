Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18B9FC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 18:07:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C105564DD4
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Feb 2021 18:07:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233697AbhBEQZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Feb 2021 11:25:05 -0500
Received: from aserp2120.oracle.com ([141.146.126.78]:49950 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233102AbhBEQWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Feb 2021 11:22:52 -0500
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115HjxTg099877;
        Fri, 5 Feb 2021 18:04:24 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=8+VmL3A5Umn03RwHbXHZo2tFA8ZjlJ9bFZjbjQ6HgQ8=;
 b=E6E3Z4oeIrIGdahJpqoVkumvpA0sQEhIk5WFxuxWuUnLrjXxrSRMqSRY2A3Xg6FHrzan
 HfvA+6Z1IrOO24qb5zagAcDqR8AAiCCJNeCKQEB8cK4+ETwDFk0F/AbJQANA6CE3NWOn
 2eQzMZSHAU+sbAZtSnMTkAmJ3BoQjGtTzdK4H7jww+rfr00Q51bwR7dS0YF220sgzOJe
 /eLFoOJ0JTSKSt1a8VDs9aV4h7iaT1/8GjjdXGNiL9WF2B4FFzLCCNuehozJdwErVXFk
 27YLBHgtpZwfGeZhsNgqgBrCrVYQLxzCLSOd1vtWd2fa1V6B5tELHjiGV0nVIToBDKba oA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by aserp2120.oracle.com with ESMTP id 36cydmakyp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 18:04:24 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 115HkPZ1047515;
        Fri, 5 Feb 2021 18:04:23 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2172.outbound.protection.outlook.com [104.47.57.172])
        by userp3020.oracle.com with ESMTP id 36dh7x4a2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 05 Feb 2021 18:04:23 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=b0N+kbVukb1gxSVk2PVYX8vpZzkuATzCh4qTMjODmFwR/+w4+KdSnWq9oluntZfLMdgeIQiZJIvUXdkeyVeEC1Y/nlO/5N4BFkrqDNykzh8e/KETxDZWJ6bN0AVpbQZzpKiOSOmuE5LHIqc8hjW5lfh2ITJ32wahuM0KO0seibjKIeFQwIytC3oq6ykzRYErige3KAPYXxD20l1QNAHEaC3Tfz9WixBkdNIWHSdd3LrMx0/u03vg+DN3yZQaM+vKT8yHbxY/1nvm+BI2N3FuubK9QkmsLAJ/grVAtDHGsDhPzrTD6T1T+3hyCgdCkWyJDXWP/7JGalX7kKhdAGg7og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+VmL3A5Umn03RwHbXHZo2tFA8ZjlJ9bFZjbjQ6HgQ8=;
 b=NA6ZRHgBuy4yk16Mbt6fEFJsb9r5SK3gaXVVfzzLVkkdXRk44q0H8Fb/JB05832wAnOO/zhYWJPqIQX8BJnrsDeLw+poBP940da1Fj8jQaEytyLNwuYENSsxK2CnQn9Pt2JPi5cnRN+26BmKDgZmjx6OP7bnT4CC0sK5u+TOiie46hAzb64GGHVtm2SJUe+/tHYVasmjIXj+Lz0x2xmBhh7D0QgQQr0J67YP+91+nf0jixGvzj7KQqnZBWFPGT/j7jYQhw8X6CbvgfTebdRSzU3T6nVenN+TW4SxZzV0dYyoWOImB+YWrOvQRXJQFJbTVtEdGenvgSMO/kAVTOKCsA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8+VmL3A5Umn03RwHbXHZo2tFA8ZjlJ9bFZjbjQ6HgQ8=;
 b=ohWl3HuBPtz/jd9jJUtHEBfITvtkAwHAoJ5vpNe0E1hy/0K/umpLw5kzUzX/7Qum/NGUI+yMN7vbFvPY+F1PPIYIq+I8gdhZkSXaNzMREugnYPGD/vb7w58M0coLgNxESUzN8zX+PMmBmfrpa7yWSGr86j89RfAdlaOMt7dz0iw=
Authentication-Results: lists.linux-foundation.org; dkim=none (message not
 signed) header.d=none;lists.linux-foundation.org; dmarc=none action=none
 header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (2603:10b6:a03:11e::32)
 by BY5PR10MB4244.namprd10.prod.outlook.com (2603:10b6:a03:207::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.23; Fri, 5 Feb
 2021 18:04:21 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::1d86:b9d7:c9ef:ba20%7]) with mapi id 15.20.3805.028; Fri, 5 Feb 2021
 18:04:21 +0000
Subject: Re: [PATCH 05/11] vhost scsi: use lio wq cmd submission helper
From:   Mike Christie <michael.christie@oracle.com>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <20210204113513.93204-1-michael.christie@oracle.com>
 <20210204113513.93204-6-michael.christie@oracle.com>
 <20210205111638-mutt-send-email-mst@kernel.org>
 <26fe5be1-842d-d85b-c00a-69694bebf709@oracle.com>
Message-ID: <e1ffb7ce-42bc-c20a-45f3-a63e8f904d32@oracle.com>
Date:   Fri, 5 Feb 2021 12:04:18 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <26fe5be1-842d-d85b-c00a-69694bebf709@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR18CA0047.namprd18.prod.outlook.com
 (2603:10b6:610:55::27) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR18CA0047.namprd18.prod.outlook.com (2603:10b6:610:55::27) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.19 via Frontend Transport; Fri, 5 Feb 2021 18:04:20 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 8b4c626a-7c5c-4590-0da7-08d8ca0076e2
X-MS-TrafficTypeDiagnostic: BY5PR10MB4244:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB424441A8108B4F1D50F19CCEF1B29@BY5PR10MB4244.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: NhBEJzWojziX108F+21Ev4hvKwnM5CovbawuWdyLo5CPH4VRfxHyKtKW7U7HlmVTH9QDrCl8lchE4FVSseQ+fEiVNUbc3QnzIQzxuR12mgmzqFuJ8dDLf5636kv/f0pRO+UIP2NNyitI+ApNT5dvZXVuFCa6SkrAwdVMxVMDxId6K1FVOYjSuVtJiw1r52R4seajY0cQ42mXl3bfhoI8bmY694XinO1delQq1F23U9ccwo0NiGNdDRrScdcE/vc/+XBQ/321w3oiICR0EgIgFHUgfV5kuckhi6gGqFDulTD6AUp99ZeshcWt/3PTOBKKNYFox1wKZWu+lhSbwp0rUZA00hcRrSCL+RHTXPVEZK/SjYkvseL/VD1U6CddH5nmpI6Aj/6UVC8Df9o9yAXrzeNudnqj3P4dae7nFoUIneB7yLw3WLP9mzUU/B8e8e4qYq23FOhlnoOprXxQUjBTiIZIJZ4r5XCV8D/NeR5Jy11cR4+xUBvLwFapqpKmHIf/V3mnaL6yTTA48wUycHFIeWd04lS1rK63fC8CSyFd05OZP2eAY/BGu9LBIkfgcDk5w891GzLfFAGK5oWU/sNzpjhThqfKSBg5M7nvY+eajlWRJ2VoMOovEeL+GFVqHc6C
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(346002)(396003)(136003)(39860400002)(4326008)(186003)(8936002)(8676002)(86362001)(53546011)(6706004)(6916009)(31686004)(83380400001)(66476007)(66556008)(5660300002)(6486002)(16576012)(316002)(31696002)(36756003)(2906002)(956004)(26005)(478600001)(2616005)(16526019)(66946007)(78286007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?WUw4Z0hxRlFwT213OEZ0NkxEUTNacmU4bnVyMWNMdFpub3JwVmhTNExWRUtn?=
 =?utf-8?B?SCtoV1Mzd1BsR3ZRa1lLUmplQUMrVytITkM2VXZsVEpNWmZINEJOVjB4N1Zq?=
 =?utf-8?B?dEdhcnhqN3p1bHpqWXNUMTh6TXpvWE1tdURWdnFZZjMrK05UaEY0aWtSZE10?=
 =?utf-8?B?elE0MVJyNUdQR0FJQ2ozMEU2eEdOMngwTXExVGhvaUlOelZwbWppN25xdWRM?=
 =?utf-8?B?UDRYYnJrT1FkK0x0ZERTaUp1TlRGUFpkMU43eGdhUnoxNHlVTHd2S1Zad2wy?=
 =?utf-8?B?dVZEYytCd0tJR29GL2RvZ0RiZEFGU3Y4T3ErbS9Yc1J0ZUdUMXJsYTVsOWFn?=
 =?utf-8?B?dUcvRVRTakhKTmNRanI1MzJnSDhleHozaWZKMVB5T3pRM1hkbmEzTmVPSkhx?=
 =?utf-8?B?ZFJWUi9wMG5veE1YNm5yK2xlSnpQREY2TFpwNlg4azYraEZCOU1Jc0JXb0gz?=
 =?utf-8?B?RE45anhEL1RFVlBBQWQvUkpBOXpzMnhJZXF2V01hVURDVXRMYW44enJRZEFn?=
 =?utf-8?B?cXEvSjNwbUp5a0RseGtKMzlhdlgvbEpxcGFhWHNXWXhBbXNxR3R5ZGZEODZ5?=
 =?utf-8?B?eEdFRmpSWjVyZDNIdzB0TzRMcExXRmJ0OVN6anNFMnRoNUpjREJ4bTRuZmJ5?=
 =?utf-8?B?dC91eGU1ajdURnZmU0tOZ3gyQ1BlWFY1R1FOL3BGdXFzcVNsVXR6eitBQSsz?=
 =?utf-8?B?UTlBaDMvMDRXekNLWU1sTm5WL2kxMit5RXR6YWlhQnRTQzMwb0tvV0FPSS80?=
 =?utf-8?B?NmNKNE45YU4yOEk3N2FLS2NWSE53d2Q5MS8rdTZLeGlIMUJOdHN3c2xBaXZ2?=
 =?utf-8?B?VjM1b25Gb085T3AzYXJmTmNLdk1haURieDE1NjJEc2kzVGlUYXNxS2IydlRk?=
 =?utf-8?B?QXQ1N2grckRGOGhWQXNuL1FqT2h5bXRnam50Z3FaKzFGNlArR1ByRTYyWjlL?=
 =?utf-8?B?LzJDcURtTllHT0NVRkp5TEdaaGJzMnladlRxaGp1c2t5LzB2QXErU0x0djF1?=
 =?utf-8?B?d3hnZE1NSXpjTm5GRHpCaVpHYStManBWaE1pV3VoYXhqK2dUdlBRNGJPcm8r?=
 =?utf-8?B?dTFxRTFrbFhqZ3NwWmlIb3l1Y0k2enc2TGFlbCtSNERBVXJIYU42OVc5cnkx?=
 =?utf-8?B?TTYxTXlaMjBvL3Eyazhad3J3Qk1pcm9KNUtaZmM4N2ZqQ09IazgyOXhzQ2NL?=
 =?utf-8?B?bFM5dnloeHZQWkRUaEdSYWFZUUxkMUJxc29uL0RXR3pUVTlvL1JqOEFaUmZ3?=
 =?utf-8?B?UTNEU0hBNEpJMVVEYVlEWlpzNjVsVDZIbndCNzhEVXkrWlFCVFNsOVVxQUVK?=
 =?utf-8?B?bXptTkNIVzRCUStnWXV1RFZuYndCbjhGbllRVk0vNXI4b2FrTHJmOTNybW9L?=
 =?utf-8?B?eWdXMFA0SVVyNlk1aUdoSWhEWk4weEdtUWowVE5uSUJNWTZtWW03Z242M1h1?=
 =?utf-8?B?bFJPbjFxZFMwQzQ5cUZodUc4RDA0SmdHNEpVUzFza2FJQkRxQ0haWjA3UjZX?=
 =?utf-8?B?SjFDamdzRGxROWVCTklaV0VhT3Q3Um5sdkpnN2ZuYW15STN1dnpHTG9yMzVQ?=
 =?utf-8?B?MU95b0E3TlZJaTB3Y0c2eWl3Um9VbGNVTHVabWJ6OWxEYlpTbTE5N0h5UXJm?=
 =?utf-8?B?NWc4WENhd2pmOTlRTnlmbTVIcjRxK08yd1p3dmt2SUpXUC9BK1B2LzdHdzJp?=
 =?utf-8?B?enl6cFFoRnBSR3JhNmdFaFYxTFhickVvbmx2UnptdndpekFubmxKM1JVRGxw?=
 =?utf-8?Q?5vGMQ+qGfMkjPYrnn1Smvk47kMfC2aRH5Xb2SHf?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b4c626a-7c5c-4590-0da7-08d8ca0076e2
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Feb 2021 18:04:21.7651
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: D2qkkR7HrYacasTx1gV0w2xiZgjkgmTnOHeO4Yz/AaRwt+0sKlYuCY5tNVBHyjt2qeIQ7EMoc8RwmDpnEQ5lVvFHQH3lPzV4zx3ZDHXjrUs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4244
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0
 suspectscore=0 spamscore=0 mlxlogscore=999 phishscore=0 adultscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050112
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9885 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0
 priorityscore=1501 impostorscore=0 malwarescore=0 clxscore=1015
 spamscore=0 lowpriorityscore=0 phishscore=0 mlxlogscore=999 mlxscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2102050112
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/5/21 11:38 AM, Mike Christie wrote:
> On 2/5/21 10:17 AM, Michael S. Tsirkin wrote:
>> On Thu, Feb 04, 2021 at 05:35:07AM -0600, Mike Christie wrote:
>>> @@ -1132,14 +1127,8 @@ vhost_scsi_handle_vq(struct vhost_scsi *vs, struct vhost_virtqueue *vq)
>>>  		 * vhost_scsi_queue_data_in() and vhost_scsi_queue_status()
>>>  		 */
>>>  		cmd->tvc_vq_desc = vc.head;
>>> -		/*
>>> -		 * Dispatch cmd descriptor for cmwq execution in process
>>> -		 * context provided by vhost_scsi_workqueue.  This also ensures
>>> -		 * cmd is executed on the same kworker CPU as this vhost
>>> -		 * thread to gain positive L2 cache locality effects.
>>> -		 */
>>> -		INIT_WORK(&cmd->work, vhost_scsi_submission_work);
>>> -		queue_work(vhost_scsi_workqueue, &cmd->work);
>>> +		target_queue_cmd_submit(tpg->tpg_nexus->tvn_se_sess,
>>> +					&cmd->tvc_se_cmd);
>>>  		ret = 0;
>>>  err:
>>>  		/*
>>
>> What about this aspect? Will things still stay on the same CPU
> Yes, if that is what it's configured to do.

Oh yeah, I wasn't sure if you were only asking about the code in this
patch or the combined patchset. The above chunk modifies the submission
code. Like I wrote below, there are no changes CPU use wise in that path.

Patch:

[PATCH 11/11] target, vhost-scsi: don't switch cpus on completion

modifies the completion path in LIO so we can complete the cmd on the
CPU that the layers below LIO were configured to complete on. The user
can then configure those layers to complete on the specific CPU it was
submitted on, just one that shares a cache, or what the layer below the
block layer completed it on.


> 
> On the submission path there is no change in behavior. target_queue_cmd_submit
> does queue_work_on so it executes the cmd on the same CPU in LIO. Once
> LIO passes it to the block layer then that layer does whatever is setup.
> 
> On the completion path the low level works the same. The low level
> driver goes by its ISRs/softirq/completion-thread settings, the block layer
> then goes by the queue settings like rq_affinity.
> 
> The change in behavior is that in LIO we will do what was configured
> in the layer below us instead of always trying to complete on the same
> CPU it was submitted on.
> 

