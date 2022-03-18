Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA75EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 22:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241261AbiCRWM4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 18:12:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233782AbiCRWMz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 18:12:55 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A40330A89C
        for <linux-scsi@vger.kernel.org>; Fri, 18 Mar 2022 15:11:35 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 22IK2SGA032174;
        Fri, 18 Mar 2022 22:11:29 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=nMZaaJUsvh+nB2QZ+BQy71sZSP4JTR6OiiYgaaRobXY=;
 b=wRUMr+mv/nVpagbqQbFk9C6VwfM8ecnjAGviNNXrPK4er39aReuuySKjtDpz+wRIU4NL
 G7PrPYjN49TZSgfCs9Qw9Vu0AFtxnxyaLXI91w99WP495+YqpHeVW/mRFSsR2SSakeKy
 3eIXjQ/UbnbyxlYA3+EamF8vOxgLPS5jMYSyVaNFVpLdiqdcyalCja1Ko2BT1l+MgMZM
 piD/U6KnLLFkKzMj+IoJDVZbMg6njQDVY8ZDlzeh111Dto18US222DNOB8yFslQh2MrT
 v89aigg8huGD2+dMUoAGHPyA7aS9U6QFdOknMPlK3zvR6bJMvrUm+HTi71xb9d0UXCLL HA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80] (may be forged))
        by mx0b-00069f02.pphosted.com with ESMTP id 3et60rvykq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 22:11:29 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 22IMB2fW149778;
        Fri, 18 Mar 2022 22:11:28 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2170.outbound.protection.outlook.com [104.47.58.170])
        by userp3030.oracle.com with ESMTP id 3et65q6mrs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 18 Mar 2022 22:11:28 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=csa/v4eA6pGB/1qQYqVSPCDR5gRdbhK8+XwraIu/7+zff7xik0A+eQ8GbIJ36MbHXR2Toy0Yd5pE59NWj8feFm46bnzBgJ/hnKx+ikqbFaMOaEIEga46iekkcZwsIwpIjkzikQ8P+5oeVozrBToe0GWUAEJwWsPVMBHYQwsfkdni2dicJi2JoqQqEx4T0Vcwk9c3oh91HmSoHoDUKDLCillHQQLDgOwqKJydFGP4/8e2ntCKd79iOp8yYW5OFB+Ffz289JWLGJyDxfozgXIozKdUvp9Dq4l4vcWEDnXTh5ogpF5sXpL+uTCdQN8Ng5OIFuoZRVTI1HIHPdobg3Ghng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nMZaaJUsvh+nB2QZ+BQy71sZSP4JTR6OiiYgaaRobXY=;
 b=Z6VzMc7MTy1k/PIvSlGstshEdo+6hQ9mJPqcCz2UaL7XoVraJaq2AuNX+OspyrgzoCPMAXFb2ajeiNJg7bVWtxSD9C0rG3Z6eAPhZLKkR44n3jQtPVAbdhJx2ZN1e+QiU0QvxRNz341mFJTgOGxv/+OjaFY1dAEsxY95M2cjHDa7uln7gDdRdyCoaAd35ASZ5aXsJqfrPVnsm2bXpxRksJ0MYlnaBB5uiYWl0XZb0R3zjOGDXk843zz11j5SsguYCecuE0vgZMeXDmG2u3mG60FmqnjoIgd/l1nja2RxW2GETxXPa07vYop2UDD/D7Q6kZckVAfRMaVZCIDnR8xD/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nMZaaJUsvh+nB2QZ+BQy71sZSP4JTR6OiiYgaaRobXY=;
 b=r86z3a5iQpH9SgF7kvLe/XfXgfseLoVm3FfXSmz3QKNGASrBA8+1+lo84RECtt3sSbXGzHhBsYf6iiT2mWrERwmjnV042kieOklFUNhfa3T8tVsnZTmrvPGYUvw1ikybg4pQb//d+qJ5oV0qXGl3o2rh3BJ7Qyv7yPKBKqq1Na0=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3899.namprd10.prod.outlook.com (2603:10b6:5:1fb::30) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5081.14; Fri, 18 Mar 2022 22:11:26 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5081.017; Fri, 18 Mar 2022
 22:11:26 +0000
Message-ID: <44c2c232-baf2-f415-b7c0-efbe27bbbd89@oracle.com>
Date:   Fri, 18 Mar 2022 17:11:24 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 05/12] scsi: iscsi: Run recv path from workqueue
Content-Language: en-US
To:     Lee Duncan <lduncan@suse.com>, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
References: <20220308002747.122682-1-michael.christie@oracle.com>
 <20220308002747.122682-6-michael.christie@oracle.com>
 <b10127f9-9818-e595-5e12-1052e9478978@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <b10127f9-9818-e595-5e12-1052e9478978@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:5:134::25) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: c06ec5b9-f29b-4c76-00a4-08da092c3eb9
X-MS-TrafficTypeDiagnostic: DM6PR10MB3899:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB389915FEBA856052A0B41FCCF1139@DM6PR10MB3899.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 6/5IjlYxdQ4euqsafF5CS3czaY6UoZ7NW2vgBIhsiHQiLmcvrOP3SltvgAkiZnSMARKNku6AKIXiZ3eTyrWNchZF1xiYagsgjYKULnF3TScz50FEDecfNRzEpBPuvk5ZKjLmCprFMngBkNwmDVTUNAyu0K6Tpa8i9TvYC7euwgv+9rw9BAV77x59OjNRJjU+8dsAWMss6P6m0Nx+iArW/9KNnbSiuZGLify0Kol0924asdL7jwByEi4/Scnm6G1Jxa49/abnA0FfX4ccnafGXdRVywWwdtK38qudt4EcJs6ck0YnS+ivj4GGupjAchAKvlzXP35510dHoIQsSOPFgUVPYOzD+6sMuavbOPKP9IOTZcAqfpATDA/IreeYPRz59GyE2kb39EsDpDkyBRiLiS0jUiOPWBmwCG7O6w5sxFNYGtOeGjCEmAto6vRNn2Z7YNhfMRuE/EnUz6OhfAfJ0LXFBrp/jATYMAVBL5UjJRhRXZjajaaD7DDnw4dwXgGdVdkXBpZtwWbiaDf9HceHdttpyLhWG2ymQXLQPyLXjk65o5XGhVjejad+Ymrx+tdaV6lVd/rKp5XjV/vi3KGFykdO7+50f0TaL5d2J2x5qhmkF/B7WHf6ZFORgCKcmvz1BWN/TIK8j73Wz5A68JqPM9R1d44tuBavQxEXs5gxCgzsJZJR5mIW5EJ9HGEgg1vqhhC9159jjRQxP1zKDyCh/cx/16g/57hrDYkWfp0zU70=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(36756003)(2906002)(6486002)(508600001)(2616005)(53546011)(38100700002)(31686004)(5660300002)(186003)(8936002)(6506007)(26005)(316002)(6512007)(31696002)(66946007)(66476007)(66556008)(8676002)(86362001)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZEt0VHlET2dMNGE0c29SdlRBaDlxTDhHK1lDdVpScW12TjVuNnExN0FueHVY?=
 =?utf-8?B?eU9xTi96UFNmY09OcHJUN0xJeGw0TU9pZGcvUFpyU3dLTEU2d2RXcmpvN0xY?=
 =?utf-8?B?L1VzN0hlMENsNEV1YjNJZ1c5cmpCUVE4TWkxdFhqSldXaEU4NG56Nm1hNUUr?=
 =?utf-8?B?Q050UjdpYm43TnVoRDA0L3dDcmVRcFdJSWxwZGptN3U4Y0hWMzRaakxCd2JB?=
 =?utf-8?B?TTloN3lKVjZWZ3ZwZktSYklyQy9JcFR2UmQ4U2hzWFdweURldmlHU2FnZzl2?=
 =?utf-8?B?K1paZW5Uc0hkWUduK1VlM2FHNHA1TEtQZjBYYW1NQ1ZBTHhLMFBTQk5Pbm1t?=
 =?utf-8?B?amVqaUhkQTZCL1VqTkROSVpzRXpWWTN2MnJ3ZkcveGVVUHRzYnhNSzMxMFV6?=
 =?utf-8?B?R0FWOTF2NkhRSW9FT0VJS240ak1xbVJMYTQxRVRpdHdtUi8yRnVpOHloWmJh?=
 =?utf-8?B?U0Vremx4NXM4cWRBbzBGS0RVQ01IKy9TOFpGMlc4YUZZT0FqdXFSU0xNZ3hE?=
 =?utf-8?B?ektZNnd5alB0dDMvWnk2NzNzN3FwSlZ0eFFHeEhTSmVvSXlhLzJUTHB5bU10?=
 =?utf-8?B?cEVnS3dPYVQyVkNydVJuTVppSTh1Wno5ZjFWSGVYYTZYMWdzTk9YYkJRYnlv?=
 =?utf-8?B?allTZEVheWR4clNicGFMZ1hrVWlaR2dWeDVPQVZ4NmozdFJGcW9pblNWc2l0?=
 =?utf-8?B?aXZIZDVTcEpRdjc5ZENRUlp1a05mN1BUN2lEMmN4dVF4MEh5V3VNdm1BNW1m?=
 =?utf-8?B?a1hucThmSkw4dFYwSTZYdDEvdkkyUXV4SmxwcllSRHF3bXBUSnNnYU4yQ0FV?=
 =?utf-8?B?Y2NINXRtOEJqcWVaQmdLL1BCMnlvMGtDem1xUGk5ODVLdGJpcUhlMEp1RURp?=
 =?utf-8?B?dnQ3MHErN29vMmR2ekhTdENJL1NFdHhBZUxtUGFFZnh3S2NkVmNWS29PWjdK?=
 =?utf-8?B?clBQNjVUZHBiNXRIUSs4NEQrVkFSbDhvZzVRVUk5aFViazdVVUU5a0NhclBv?=
 =?utf-8?B?M1ZMSGQzSFAxK0prNWNJWmVUNGtTSnFkREgrZElOV201cFVNVW5JZTAyQXNP?=
 =?utf-8?B?VDF6eDA0Q1NDUHdkK1JlaU1vUzdzMHk4ZjFmcTFmeWNkVnlkV20xVFlGMEtB?=
 =?utf-8?B?aVFzKzBRbEMxTythNVNyYVhTTFJkUEFtbm9kNFc0MTIxcXZGUTBUd2g3S2hw?=
 =?utf-8?B?K3hJWjc0UkRHRk9Sb3NqUENGejJEU0F0am1uSHFiVmc2RmZtdEdMcVc0OEht?=
 =?utf-8?B?N2UxaDlWTFNJT1o3S2QxWlBxN2t1WXZ2MGx0SVJCd2E4ZTZCYWRtQUNtVDFv?=
 =?utf-8?B?bmhqQmZycUpCMDd4YVFNSUpEaE4yZWhrY2hKaFJNSkoxWEhzc1NaelJtUGNz?=
 =?utf-8?B?bk5UMEYydmNHd0Y5Y0VmRTV2N3VaTGUxUy9sNG9obTh0emVFWXRmUUZ1WjNQ?=
 =?utf-8?B?MDdXZFFSWDNkaG94OTFoUEc5NThMMTFYU2hBUmkzV0tnUkMxc2xMUHlyWHN2?=
 =?utf-8?B?S3YxZUdJZ1J0bG1XbWJ4SndreGJFeDRhWEJZQno2VkF0YzFzV3k1Rm5NNmFt?=
 =?utf-8?B?aGhqTUYyV3lsUEFXQzlrS3hHL2JmRkJiRVVjVEZIaUd2U0NwSzNaY281RE5E?=
 =?utf-8?B?dzQvdnVNOHJTTWFZbjQ2VGdaVjl4Q3B6cFVYL3VaTW5sbXF5Ny9kZ1RWOE9a?=
 =?utf-8?B?bEJCUlBLNGRJL2YzMHJYUkJnMVJSaGJKUk4zN04reSsrTlVleVVIdWw0VzVh?=
 =?utf-8?B?RjVnWDl1d1BiQmU5TFczWE4yWktlK05Obmxqa0lZWVRkR0U3MlowaGdmV2ky?=
 =?utf-8?B?cTUzNGRqV1hJbFo3V1piWHNTc0o1clhwTDQyNklxSzlqSGpRMnlzUFN3dHRG?=
 =?utf-8?B?QzF6QUwxZDNyVzdGa1pXbkpGMGtGMVNmM0paQWpmdlUydG5LVHBIdVFmSWhL?=
 =?utf-8?B?aDZidVBzVVhnbE9yVFpjQzVPd2FkUEcvckhaZXExbHh4Lzl3ZFNTM1lRSzUv?=
 =?utf-8?B?elFtdVJoc2xBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: c06ec5b9-f29b-4c76-00a4-08da092c3eb9
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Mar 2022 22:11:26.3900
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3AAmptmWQmsf39euly+3uT0sYXln4PXDMwA7wWjpdhkN0xngHm98s44dSYn8aIHEFAFPPNQRqrQIFqjZYjeyHyuMzjREgCjStXP3WdSSQ9E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3899
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10290 signatures=694221
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 phishscore=0
 suspectscore=0 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203180120
X-Proofpoint-ORIG-GUID: rPp7tXclneUHiwosWnY6OoKIZN-miLRU
X-Proofpoint-GUID: rPp7tXclneUHiwosWnY6OoKIZN-miLRU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/18/22 11:45 AM, Lee Duncan wrote:
> On 3/7/22 16:27, Mike Christie wrote:
>> We don't always want to run the recv path from the network softirq
>> because when we have to have multiple sessions sharing the same CPUs some
>> sessions can eat up the napi softirq budget and affect other sessions or
>> users. This patch allows us to queue the recv handling to the iscsi
>> workqueue so we can have the scheduler/wq code try to balance the work and
>> CPU use across all sessions's  worker threads.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/iscsi_tcp.c | 62 +++++++++++++++++++++++++++++++---------
>>   drivers/scsi/iscsi_tcp.h |  2 ++
>>   2 files changed, 51 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/iscsi_tcp.c b/drivers/scsi/iscsi_tcp.c
>> index f274a86d2ec0..261599938fc9 100644
>> --- a/drivers/scsi/iscsi_tcp.c
>> +++ b/drivers/scsi/iscsi_tcp.c
>> @@ -52,6 +52,10 @@ static struct iscsi_transport iscsi_sw_tcp_transport;
>>   static unsigned int iscsi_max_lun = ~0;
>>   module_param_named(max_lun, iscsi_max_lun, uint, S_IRUGO);
>>   +static bool iscsi_use_recv_wq;
>> +module_param_named(use_recv_wq, iscsi_use_recv_wq, bool, 0644);
>> +MODULE_PARM_DESC(use_recv_wq, "Set to true to read iSCSI data/headers from the iscsi_q workqueue. The default is false which will perform reads from the network softirq context.");
> 
> I'm just curious why you chose to make this a module parameter, leaving the current default.

If you only have a couple sessions, running from the softirq can
be better can give you better perf sometimes. Users might have
pinned things where the xmit and recv paths are on different CPUs.
If we switch the default then it could cause a regression for those
users.

The modparam use is because users typically know how heavily they
will use iscsi beforehand. Like they know if they are only going
to be using a couple or 10 or 20 sessions for one or 2 apps vs 50+
for heavier storage use.
