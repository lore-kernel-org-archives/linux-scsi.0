Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,MSGID_FROM_MTA_HEADER,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7ECD4C433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 446A964E1D
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 18:27:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231317AbhA1S1V (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:27:21 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:38448 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232054AbhA1SYX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 13:24:23 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SI49w9062883;
        Thu, 28 Jan 2021 18:23:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=PXWwWMdqkxM+wbSNhavXBlOXrmYnJnESAw1Dp9NAD+Q=;
 b=P03ruJWFLo3uGud1yXwqmYBDhh+tgmH6mPP8bVhm+hfUWWSb57vXBx6+OqKdu/e2Bt8Z
 bwbCB4Zs+/y8p1LHLQSPIaJyCvLDmb1BSgI6EEcme+3uAnccuSs2YvmIZG/JTPwrLBNn
 s+xAhMHQWnok0xcNBEhqpSPPVjgYf27SVe6zSn+eCkbheMexSV111HAhrKqxDUKLk30G
 Cbkv8pdfUnwqSJVWoxHUgsXdqrqaf1J2tLsKPEWrplrIoQidq9HzxPqe0OPwd34l+NOC
 v5UibnVJOsVNtIgz/1bfJXUQa0UzzDSQGrxV5jdD8VgDzhEGIAwvlFw9YVZWsOBgyuNY jw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 368b7r5kk1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 18:23:29 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SI4eGA139815;
        Thu, 28 Jan 2021 18:21:28 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2101.outbound.protection.outlook.com [104.47.58.101])
        by aserp3020.oracle.com with ESMTP id 368wq22bta-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 18:21:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QV2o+tnwRTN/G7rHeHeM3CJvC8AER68j4DFATUSpHae1559l8H1a0axu0EVZ77r1lORlx3Hu21tc4876wIqxDa2EZS+JQgPJJCUqwLK5IjvPjHBxz2m884sMYUrxWIxn39MDQBzFGO84aV1FtpM1PIDJUiuviChy1u2FlsPNqIN3taXsFeVUoIuuM+rTK6AexHllNWNsractTa2ArEf4eUGvJMqdgS/R91HLNbp0tXgjW6VGbmX1GjUZ6bOaRv5erCDQiiK3/m3Arcs1zis5oPsxmLRUwtdsj4wEqebFNiuTiqodi6FygeAm//LhygfJZ763tF0wAcFEJWgr8xRzpQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXWwWMdqkxM+wbSNhavXBlOXrmYnJnESAw1Dp9NAD+Q=;
 b=Kqv+l3Tk8bC/UKFyeD3lxim3M2I3LMsv5ev/YYiwUh6VrkSbIRzvcyYvgoMZ+3TVR+VQCxvu8ohDNbv1pnFrpTn4eOrmZOQmg5UlVi8BXur3POAfSQv+lC7C9S/Ah4oad2IRGnBZfgIgfwCsrORrtyuYv7FniQOC7MhlV1E3CHM/TUZ+F0dYcsd8Q0wQQ2Y+5Wue+Ccbe8/ofEkKoCTaTzzN6RP4SX/T1iYftd5QX+1pjeC2m7xefcAM1TNMqDf8EHoGVxHH2dY7Dyn47SwVqc14YZSE3LPt3ckl87MKT6h0Ph6Dy8JLiq/eUnYlwoi0apYbSsNZo/gMhKbMeq+IXA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=PXWwWMdqkxM+wbSNhavXBlOXrmYnJnESAw1Dp9NAD+Q=;
 b=VOL61KOyU1PICrn0p0lrFxsP/S208ep3kJyuXha2+F/IDy0lgPb3EoBemafDidd6g1PqZ2B6Ewjg1EZRyUC984c7100QjSKjrnQLsxETifPb7z7rhh0kqDxMpwRXQPOw7k7ioQk4i+TmB12Tx1A2BxiuM7a0tTUl/XsyfRVR8qI=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN8PR10MB3570.namprd10.prod.outlook.com (2603:10b6:408:ae::12) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.13; Thu, 28 Jan
 2021 18:21:26 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 18:21:26 +0000
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
From:   Mike Christie <michael.christie@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
References: <20210126130212.47998-1-hare@suse.de>
 <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
 <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
 <5d954cc5-2f38-11f1-72e7-13ef358b4aaa@oracle.com>
Message-ID: <84b3a3b2-d0b8-ac01-47ce-cca757c5c59a@oracle.com>
Date:   Thu, 28 Jan 2021 12:21:23 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <5d954cc5-2f38-11f1-72e7-13ef358b4aaa@oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH0PR13CA0027.namprd13.prod.outlook.com
 (2603:10b6:610:b1::32) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH0PR13CA0027.namprd13.prod.outlook.com (2603:10b6:610:b1::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3825.8 via Frontend Transport; Thu, 28 Jan 2021 18:21:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 6fba3ad8-d24f-4f9c-11ef-08d8c3b98622
X-MS-TrafficTypeDiagnostic: BN8PR10MB3570:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN8PR10MB35708E173A9C7675191351A8F1BA9@BN8PR10MB3570.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QvTrJdF//crReZbt7y/YliGqWEl7u9VuE7haqCNDsExkHB6yvmICRLdQ1PixavwSxL4SLTcA1m7u7/TU+YvJ+TTp8cIBW3Q60vUaqY9U35XeIQwImI72ER0sCsv7wcdbWCcfRIEQYsER3Hau7+s4afaWJzT/XGJxoauNLOIyIFegGFwQSQvs4i0Jn9zmbTAlIteHA4g/b6e2HfmaMsojHCsZMpYbmDkhNVjyYQfnc4KWM9aRs44zlr2RY444mliFgU0+B5EWZOlxgqWBEB05rhbzbSRPsl9EEfAQ2Qe0zKOPELLTZIDfFzRJoeYpY4WFkG8XfNVOHX2Ht+0VCP6nW/gmKh3+MylcJgSz7woFZSc1yg8R2xI+XdHVibABuFKL86kS0aoMEoxSXHSx/3bZaqjzrHWvlsA+tiqnyLBXzRNiOk0uLmiLqUuDw7VA6SPSnXFjSJvnlqkGSVuWBHqidrXiJ8lF9EOVWLs/JU5SR17UbKMEizifAK6kG6vHnCmF7Uhk1Emlmv/RSi2U998a+N1jBNArvR3GxCQd6uk1QhMHEQ+CF4GfHInqQMoTBF/+Mybon5pvRPx2I4aCpoBPrF7IuRzoH3nMHB77/XH7xJyGewaz4IFZwEUlU7jnxnhI
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(136003)(346002)(66946007)(4326008)(31686004)(6486002)(54906003)(26005)(6706004)(6636002)(66556008)(316002)(110136005)(66476007)(8676002)(478600001)(16576012)(31696002)(36756003)(8936002)(53546011)(83380400001)(956004)(2616005)(5660300002)(186003)(16526019)(86362001)(2906002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?am1Ocysyd0hVcml2VHBUY0RkbzhQOU9hL1hNeWg2WE5DZGVUV2NXYjZySnk4?=
 =?utf-8?B?ajl6c3p4VWhDNVVIREFjOVd5V1MxOGRtZXVnd1g2b0RzY1FZNDgvU1phK1RS?=
 =?utf-8?B?U29vM3lpbG56ejlIeC8xdVZmSzd3MTJuSXlwNStCQTlnR21uaGY0M0NBRzdn?=
 =?utf-8?B?dFgrVkJhRnp5S3VTWEVVOU43Mmd1U2kyNktNSjhRTllLaTZYdkJNVndRTy9i?=
 =?utf-8?B?MWQzcWVQUk1XL2gyaTNDUzBxT1VXa0xBQkhoTkpGNWMzeVovczdFNHVvdEJJ?=
 =?utf-8?B?blhlT3QzZ2I3U2xwMGtOVTlFdW1WeDlyQ3VROFJsSTg5Y202eVNGMFVkMWRs?=
 =?utf-8?B?cDBleWFJNHJ2K2c0UW9NdjlQNGIrYXhDNzIxN2VkZ1Bya251akVDbXBoNTB0?=
 =?utf-8?B?RWxzNm85bWdsaXBuN0VWdkhIYjcwbVFkS1ViMGtFY0Q4UXk2RGlIcFQ0b2JX?=
 =?utf-8?B?cW00N0g1a1BubWg3SWtkcTdIVjlCV29SQjFDZnB1OXBORG1iZ0pyc0taNEJG?=
 =?utf-8?B?L1RNU2NySXZPUlY1Vzk2bDR3M0NUT2IwdSsxYjdjbE5OVVVZd2R6WTMxMTFK?=
 =?utf-8?B?cmRzSk1CLzBQYUdTbFBEUWl4OWJEMjFuaUZZMGF1VURvRzdLcXM3TFlZV3Fl?=
 =?utf-8?B?a1JPVjI4VDR5ZWpldmMvdTJJVER5UnVvU2Nud3dXTUpVZUVOSWhnTXZUWmdL?=
 =?utf-8?B?YmNXc1Z5bWp3RTNkbFJ0VE9DSVM2M0puWmI3Yk9rcVJIbEpnS0ZJM2ZoUytY?=
 =?utf-8?B?ZGVzQnRKeVk2RjNSSVVhTDNiYXloM25RckpJRFF2c2hDK3ZUWXNSYjlKdmJ4?=
 =?utf-8?B?T05aTTJ0SUVkaVZBK3gxN1F5YTgwcUZkajdaS0tsamNIMHVXcnB1WXJKclFo?=
 =?utf-8?B?azFtbzh5cDFjRlVkaW9WM2NBMVhOYTRwK203bUtrR3A2YmVFR3RkVE5vcTFz?=
 =?utf-8?B?MGlLYkF3Ky9sMU5nWVcvOEdieVI4SituWFlzTlZWaWdRZ3lwY053OEp0YmF6?=
 =?utf-8?B?SzUzTFpnYm5WTE5wMXVReWNwMEpQOU9kck1KTmRSTVJHMGhvRTBUYVpGTk14?=
 =?utf-8?B?YURDZUpQS2N5K284NG83S1FSLzlMVWdWOVFGbExpNVg4WmpGcE9wVGsrbmNz?=
 =?utf-8?B?QTRVQll5Umk1ZVlwZE0vTWNIOGFyU3dwRmJQTDhON1l6SlhSR2FQQnk1M2ZT?=
 =?utf-8?B?aldBVGJPVWpoWFZUTTYrL2VhM2d1RElrblpTWU9wT0lWdUJnYWEwTjIwb2x3?=
 =?utf-8?B?clhZQ2RCMUZ1eFZwZ2R0UHJaMzA0TlF0Q0RWZThiU3ZxcmMwQTZmVkIrTlU3?=
 =?utf-8?B?YmxwVGdjM29aK0hnMnNkaDBlVlloak9iaHFId3N4c0NOdEtXd1FnV0hXUC8r?=
 =?utf-8?B?UDFhRExQRnFoNVV3Q3d2OHJiUE9janZBZC9CaExodEV4YUcyUHpBWktXTnRS?=
 =?utf-8?Q?YE3a6zXj?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6fba3ad8-d24f-4f9c-11ef-08d8c3b98622
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 18:21:26.2389
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Zgu++Wu7s7kBGBuhUCCgKMRsPtFqud0P7Hq07FIEGU2/WYDMQCm0MoxJ6oG5sAknrcmvITR2xkyIdHYQfVVAVqhgyfHbLPmGRSdAklK8F/4=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN8PR10MB3570
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 mlxscore=0 spamscore=0
 adultscore=0 bulkscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280087
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280087
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 12:01 PM, Mike Christie wrote:
> On 1/28/21 12:57 AM, Hannes Reinecke wrote:
>> On 1/28/21 1:51 AM, michael.christie@oracle.com wrote:
>>> On 1/26/21 7:02 AM, Hannes Reinecke wrote:
>>>> When a command is return with DID_TRANSPORT_DISRUPTED we should
>>>> be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
>>>> the command if set.
>>>> Otherwise multipath will be requeuing a command on the failed
>>>> path and not fail it over to one of the working paths.
>>>>
>>>> Cc: Martin Wilck <martin.wilck@suse.com>
>>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>>> ---
>>>>   drivers/scsi/scsi_error.c | 1 +
>>>>   1 file changed, 1 insertion(+)
>>>>
>>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>>> index a52665eaf288..005118385b70 100644
>>>> --- a/drivers/scsi/scsi_error.c
>>>> +++ b/drivers/scsi/scsi_error.c
>>>> @@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>>>       case DID_TIME_OUT:
>>>>           goto check_type;
>>>>       case DID_BUS_BUSY:
>>>> +    case DID_TRANSPORT_DISRUPTED:
>>>>           return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
>>>>       case DID_PARITY:
>>>>           return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
>>>
>>> We don't fast fail for that error code to avoid churn for transient transport problems. The FC and iscsi drivers block the rport/session, return that code and then it's up the fast_io_fail/replacement timeout.
>>>
>> _But_ if prevents that command to be failed over to another path, so essentially we're blocking execution until fast_io_fail tmo.
>>
>> For no good reason as we have other paths available.
> 
> It is for a good reason. Causing a failover to another path can lead
> to other resources being shifted and putting the system out of
> balance. For active/active it's most likely fine, but for active
> passive targets and it might be better to wait a second or two to see
> if we can recover the optimal/preferred path.
> 
> For iscsi if the user has set fast_io_fail tmo > 0 then they want the
> delayed behavior. If the user wants it failed immediately they set
> fast_io_tmo (iscsi replacement timeout) to zero. Note for fc you would
> need to add code to do the same since zero means off.
>  
> The other issue is that your patch only solves part of the problem.
> It would prevent the IO that went through the above code path and new IO
> from waiting for fast_io_fail. It does not handle the other IO that would
> be caught between dm-multipath and the driver when the rport/session block
> completes/starts. In the end the app is probably going to get stuck waiting
> for fast io fail tmo to fire.
> 
> I think for both reasons, you want to just make it so the user can set
> fast io fail tmo in a way that some value means fail immediately or do
> something completely new.

For that last part, I think in the short term we could just fix up 
csi_transport_fc to work like iscsi, but for the longer term to handle
cases like you have N>1 paths in a multipath group and are doing
active/active across them but then have another group where you have to do
active/passive over, then we could do something new.

I think we have what we have now, because back when it was made we couldn't
tell dm-multipath what the error was, so we had to handle it in both layers
like this.

Now, we could fail immediately, not block the queues so IO would not get stuck
in there, and then dm-multipath and multipathd could do something smart with
the error since they know the reason it was failed, and the path and path group
layout, and have more info on the device like if it is active passive. For compat
and to support what both of us need, we could have a timeout/setting for paths
within a path group and one for switching path groups. We could also do different
behaviors of the error was DID_TRANSPORT_DISRUPTED vs DID_TRANSPORT_FAILFAST
since for the latter the transport timers have fired.

