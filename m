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
	by smtp.lore.kernel.org (Postfix) with ESMTP id 55BECC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 00F3B64E21
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 18:03:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231149AbhA1SDu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 13:03:50 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:35578 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231530AbhA1SCe (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Jan 2021 13:02:34 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SHs3ca036936;
        Thu, 28 Jan 2021 18:01:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fDfvztcsOQHuUyeBuTsUBPiKZzkFZBidOTf2oUzf3lE=;
 b=OzvS10ASb99dSxKOSmbwdoSgIlF2LhKF920E1rBNdpobPwaIbCe3OnJ4PHYotjPQYUMW
 a/P2XxNztLH38uIJDI+x3lkJBJDCCtt7Kot0pdZy/RDJQ5QErKUWtal+tgDleHimHfv8
 3y0hr7PemVn22C+E3sDy0I5bXWd7Dd0MsEEkYdO+e0J9j3L8xujkDD3obx0Hk+YzHkNh
 czCv2/5vsQOCClQ2qG1q8mu20geWyfrpujVYwgWBCPSsMSvAI6P7wjOMB3AbBtdPD0PZ
 bMpzd/SSa9SducjbE7VmQ3bG0rDWM1OHN3chhP48vo6rypM5mWMPr3LRgN7RL9blwjII LQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 368b7r5gkd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 18:01:42 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10SHtqS2018978;
        Thu, 28 Jan 2021 18:01:42 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2104.outbound.protection.outlook.com [104.47.58.104])
        by userp3020.oracle.com with ESMTP id 368wjue14a-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 28 Jan 2021 18:01:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Q9HURPcxWiQw6BQOiBsnfMItiNDoNBwiEkFTOEWBh0AAoMZj1cgVOlz6EmCNMJ0+AdlebVj0J4JjKNrSATgJqHQ7nsgzdHDwP4nYVxtSAK4EEUhRkSQT2ZI1Oc8WDCe3kAXqk2gy0IEj7z/FiTuZeFufOkmQe7/gA+0nq7+2xmT1fVnH40e2yyflstspxWJrRT9O83zSi26ECIJ3g9Uz8xZXFl82cSa6WjkVbc6gnWdR1N21yWUeoIk4aX8qH1Uw5Db+uU9XpK0C9HVKYG767x5hp6I8qt2UH23Wp47M0id8LdS6/BnmBvJKzJgU0iMYHn8Y7P46qJl51njO0KrZdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDfvztcsOQHuUyeBuTsUBPiKZzkFZBidOTf2oUzf3lE=;
 b=QQvFHE06U6xiB4lfrjd5YhPuo+ySzmjz0oA2pQdLh1aQUXWxpvySXVmlrT/WutEDrn/Rc2aSpaToHitEj+0j+CutcM/SY/lwYXdPkTVKbTtcZM964zRs13bvzbC44/Whr2dxprrniqrBKXFpO1aS3wztV3OlASGA3p58F3j6lSoc107fy3zKzpDQkEgCYJpaBoa++xoACRhv0IrEFC8zShp0pUvkU7HUfPRa0O7u12Go7xXJHGYt3AfSoqeXV2meH9Yc8AORhdFVknRYY/pw0ukLMb1Ik+y9rfCohRSk26TiTZind9fCqmExzmwOnBPwFNHAbqP12o3QBEFYIBoOgg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fDfvztcsOQHuUyeBuTsUBPiKZzkFZBidOTf2oUzf3lE=;
 b=phmI7THflY2YRmTicR2ltcpeKD9LofdSlV+o2Fyn/y4evRtO95tk9LRW4O4uuefZMu3H4uOAZVPOIDL8l5wBNBg9oT1pUSXqcv4rbIT5PJa9Rw/N5EgL3s+h+3z+SfQRVQVFrnIqqmAnSCkr9XRPXfvSXlDCCnHWEqZbbNfN1Mc=
Authentication-Results: suse.com; dkim=none (message not signed)
 header.d=none;suse.com; dmarc=none action=none header.from=oracle.com;
Received: from BN6PR10MB1236.namprd10.prod.outlook.com (2603:10b6:405:11::21)
 by BN6PR1001MB2148.namprd10.prod.outlook.com (2603:10b6:405:2f::37) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17; Thu, 28 Jan
 2021 18:01:39 +0000
Received: from BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86]) by BN6PR10MB1236.namprd10.prod.outlook.com
 ([fe80::f5ff:ea98:43fe:3d86%4]) with mapi id 15.20.3784.019; Thu, 28 Jan 2021
 18:01:39 +0000
Subject: Re: [PATCH] scsi: do not retry FAILFAST commands on
 DID_TRANSPORT_DISRUPTED
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Martin Wilck <martin.wilck@suse.com>,
        Hannes Reinecke <hare@suse.com>
References: <20210126130212.47998-1-hare@suse.de>
 <e5c71e73-f36b-8ff8-ef4e-d424304431a6@oracle.com>
 <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <5d954cc5-2f38-11f1-72e7-13ef358b4aaa@oracle.com>
Date:   Thu, 28 Jan 2021 12:01:37 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
In-Reply-To: <fa31a242-bed7-6466-2ac5-e69a5d71b8ef@suse.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: CH2PR15CA0029.namprd15.prod.outlook.com
 (2603:10b6:610:51::39) To BN6PR10MB1236.namprd10.prod.outlook.com
 (2603:10b6:405:11::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by CH2PR15CA0029.namprd15.prod.outlook.com (2603:10b6:610:51::39) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Thu, 28 Jan 2021 18:01:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 40e334b1-68b1-4209-4a07-08d8c3b6c2c6
X-MS-TrafficTypeDiagnostic: BN6PR1001MB2148:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BN6PR1001MB214818B0212092F71C213D61F1BA9@BN6PR1001MB2148.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8273;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: t8DLHcqy+jgcSMdN0sBCXxMKM8Kv4nJjpd032J/t0kr9DV6Q/DltTPpAxyRFQxuYkBFmVqcahm2t6dKG0SAfijMScJLJIrMkrJeWd1Vu/asW3n9aXPNoOklSNLcPB7gnDX0LsyIPmdv6O4n8nP8AS6cBNE9EUBf/xzVeYTUTQfPnk9V1sWGmOTAm2s0LZSoBMhE4/acLwLDlRXndf9NRD3OPvTcbLYSylCJmU4jXm2YRBsZtr9v2OkmPCkAxGBP8E1UBynpLB0uwgmJPkuH+Tto94NqPc9arEojCoHdnuUxy1E/QYGuUGAFMHJjE2LvZfBllyHoM2UEPjpWXZ3ZauLusOpPM6V0bJxMqOQs6tNiUZLUs92e8jpd6tAI7OCUw3NYL7zLjQJ/tpy0DAKW+7OzVfFLN0z1KtP/f7+OKGPU3jXH2mIU4fJUgmjFrsIuMoKgLEVpm1y3syF/XFph78JDrJ6EEiq17X0T1FnADZDMg7+IDsn2lgT7jDnndqvhxYpqu/rTj1DZwPy0ksrVZmIWv//r3Khj8vu4e2VQVgDvbiwncrlXIvOOUbx9cmhI3AtmYrdIN1K/ndwqGOy0bpSdZZwevNnmizh52PvMXC9EwQYQexR1Q7mGcTcmLOUH8
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN6PR10MB1236.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(346002)(376002)(136003)(39860400002)(66946007)(31686004)(66556008)(6486002)(66476007)(478600001)(8676002)(186003)(86362001)(16526019)(26005)(316002)(16576012)(53546011)(8936002)(5660300002)(31696002)(2616005)(956004)(110136005)(6706004)(4326008)(2906002)(6636002)(36756003)(54906003)(83380400001)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?RndKWDhwQVRzcml2c1FiY2lzR0p2a3dwYVArQ2ZQNWl3a0FzUDZpMEdsVStM?=
 =?utf-8?B?V2tmUEh6U09qbUgyUUNLT0ZUazZneUc2VCsvQ3JLSDlSb0djQUdzdEdpTHZW?=
 =?utf-8?B?RVp0cGhGZEcvdm1MWXhhNGVMY1owMjB2dEpSbmxsZ3g2bElrdENxaXFvY3RI?=
 =?utf-8?B?V1VJakZZcGFVVXVabzF6V2ZLc21OVTBMdGYxWC9kN1h5em00QnA1RFJSODNa?=
 =?utf-8?B?MkJIVkRsWU91YjVqMlcvNytxdFZDOXhUUVJ0ZHc5Z2NCb3JpOVBKV0tydlpq?=
 =?utf-8?B?TzVObmR6am9hQmVyQzFSZlNPSk5aNEFvcjcrNTN1bUVTc1Z3RWdqWkMyNGln?=
 =?utf-8?B?OVBrTnlrU24vY09oYm5tZ05taldTUjBBZ29OYVNpZ0puSW9takNKNE85dDcr?=
 =?utf-8?B?UEx0VHhUWUJoL2N2R3dNRkNpZ0FSOVg2c0oxK3JvZWxBZ1hWUS9qZE40U3lN?=
 =?utf-8?B?c2pKTzVQNjF6T09HZ0xXTkRZREozZXc2Z3hYK1BiUVhXbTdWKzRHME42ZEZB?=
 =?utf-8?B?d3FxYXNFcDArVmx4cVlFKzBWbHI2ZHdsTlpKMkd5RGd5MmtkeWFUR0pKTU1l?=
 =?utf-8?B?bGVEOEppaFBCak1zZTZ1c1MrdmZWZEFhbk96UHdLNkExajU3QmZCTGNVMjhp?=
 =?utf-8?B?bDBoTXo2Z0NXVjFIY0YxY25pbm5Wb2hCOHcxZkVzeVpXOU8wbHo2R1BQR3Vs?=
 =?utf-8?B?MnZoQVM1WHhXQUhRREh6clZxS3g2Nlc1akU2RElGQ083RTNOQ09xWDcwZGtE?=
 =?utf-8?B?b0t4WmtaUy9IVlpIUEpkRk9nMy9xSlVWMGdYRjRUaXdFOFBoNEdGNjM0Tzd4?=
 =?utf-8?B?bDdSaVphd0J5cDVKaVJaejNubUVJbHNtOVRMYXFEY2d4KzhmTndmd2hwcHRR?=
 =?utf-8?B?T3c4b2ljS2ZEaXNNaDFJNmJtOUpJZk5ITDAvTU1sNjFBR0RTelNDY09icDJW?=
 =?utf-8?B?VmpsV0RZdWhvNy9KVlo0MFVIVlhQZFRDeU45WUlpamNmV3hBcFkzYXVzRWdx?=
 =?utf-8?B?WGxoQ25WU2N4NTRGbEtKTEdub1A4dE1rSC9VZlVlVE9HWXd4bVV1RjhhckV3?=
 =?utf-8?B?VkJSaGYwL3Ryanlib3BvVHNzRk9FQXYzTTdVNWhzL3Q0eFVPc0pnSmx2NGVo?=
 =?utf-8?B?MGdKaTRTSFBPKzdSV3VxQ3BiSnluSFd1amppM080WVgwTnVtUzVqOHFYTzJH?=
 =?utf-8?B?b0VXWXJJNHh3SjlnenFCQ201ZkYvaC9QTk82MDJhczUyYmdTUzdOam82ejVl?=
 =?utf-8?B?azdrQmhmQ3c0bWZDWk10Y0xodXhRRlU3UUtNcXBPdHp5WVdUcHpBK0Q1bFJv?=
 =?utf-8?B?dUwvTFBFTmJTRTN4SVNzZk9kVWxLOC9NQlF5SVNNWlE0M3NIMUcxWUk2eWVE?=
 =?utf-8?B?UkNaWFNSOXJWZGJudWYvVTlvZEh6ajlRYkhHZmFJR2JmNkpkVnBjU2h1cTQ5?=
 =?utf-8?Q?Qpp5/LOo?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 40e334b1-68b1-4209-4a07-08d8c3b6c2c6
X-MS-Exchange-CrossTenant-AuthSource: BN6PR10MB1236.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Jan 2021 18:01:39.5322
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +iZ5j0VPPUP6uFN483yNX1ljLqtPcDi+DoPFWfQrXpR5Cy0RSqsYN3FLDOClP0IjgXoHoHALwwMsFn1K5EV583GJTQvB0pnXLXLbfOVJHdY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR1001MB2148
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 adultscore=0 mlxscore=0 malwarescore=0 spamscore=0 mlxlogscore=999
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2101280086
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9878 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 phishscore=0
 adultscore=0 impostorscore=0 malwarescore=0 lowpriorityscore=0 bulkscore=0
 priorityscore=1501 mlxscore=0 clxscore=1015 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101280086
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/28/21 12:57 AM, Hannes Reinecke wrote:
> On 1/28/21 1:51 AM, michael.christie@oracle.com wrote:
>> On 1/26/21 7:02 AM, Hannes Reinecke wrote:
>>> When a command is return with DID_TRANSPORT_DISRUPTED we should
>>> be looking at the REQ_FAILFAST_TRANSPORT flag and do not retry
>>> the command if set.
>>> Otherwise multipath will be requeuing a command on the failed
>>> path and not fail it over to one of the working paths.
>>>
>>> Cc: Martin Wilck <martin.wilck@suse.com>
>>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>>> ---
>>>   drivers/scsi/scsi_error.c | 1 +
>>>   1 file changed, 1 insertion(+)
>>>
>>> diff --git a/drivers/scsi/scsi_error.c b/drivers/scsi/scsi_error.c
>>> index a52665eaf288..005118385b70 100644
>>> --- a/drivers/scsi/scsi_error.c
>>> +++ b/drivers/scsi/scsi_error.c
>>> @@ -1753,6 +1753,7 @@ int scsi_noretry_cmd(struct scsi_cmnd *scmd)
>>>       case DID_TIME_OUT:
>>>           goto check_type;
>>>       case DID_BUS_BUSY:
>>> +    case DID_TRANSPORT_DISRUPTED:
>>>           return (scmd->request->cmd_flags & REQ_FAILFAST_TRANSPORT);
>>>       case DID_PARITY:
>>>           return (scmd->request->cmd_flags & REQ_FAILFAST_DEV);
>>
>> We don't fast fail for that error code to avoid churn for transient transport problems. The FC and iscsi drivers block the rport/session, return that code and then it's up the fast_io_fail/replacement timeout.
>>
> _But_ if prevents that command to be failed over to another path, so essentially we're blocking execution until fast_io_fail tmo.
> 
> For no good reason as we have other paths available.

It is for a good reason. Causing a failover to another path can lead
to other resources being shifted and putting the system out of
balance. For active/active it's most likely fine, but for active
passive targets and it might be better to wait a second or two to see
if we can recover the optimal/preferred path.

For iscsi if the user has set fast_io_fail tmo > 0 then they want the
delayed behavior. If the user wants it failed immediately they set
fast_io_tmo (iscsi replacement timeout) to zero. Note for fc you would
need to add code to do the same since zero means off.
 
The other issue is that your patch only solves part of the problem.
It would prevent the IO that went through the above code path and new IO
from waiting for fast_io_fail. It does not handle the other IO that would
be caught between dm-multipath and the driver when the rport/session block
completes/starts. In the end the app is probably going to get stuck waiting
for fast io fail tmo to fire.

I think for both reasons, you want to just make it so the user can set
fast io fail tmo in a way that some value means fail immediately or do
something completely new.
