Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D260EC433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 20 May 2022 19:08:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353173AbiETTIh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 May 2022 15:08:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236050AbiETTIg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 20 May 2022 15:08:36 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82446197F69
        for <linux-scsi@vger.kernel.org>; Fri, 20 May 2022 12:08:31 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 24KFnGil019283;
        Fri, 20 May 2022 19:08:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=qdaSPH385aKe4mNzmkjYe2xBJKTmB36y1+QqLDP7Jq8=;
 b=Zewjxo7R0UZ0pJyCn6WSk+IoHBzyEn+va4gjBLTs2mfVEDwEHlXnk8DIuAbBLSDE4NDW
 QVzTx3PHulnV+6yhny1HYAcrOjtCR0fQPC76++kIkxDhFlaHtFnag0e+oNAH5xyD9CI2
 8McPuYjbROsf0aPYH+bR3T58N789KYA9ZBcnq+hU+zJ2cEp7SldMIiTmUsPRAz1oXHTX
 hKeGLQNH15Qxd8MvhqpevaHHtjorGtMpoTyrFhT6Lbkv7VR+aV0/1I+rR1r2vuA7GiGA
 NDXJSXtbflOkbyJA3f7bfa3WjxbQi0VKKDs195UxAc3RWeCm5tDhwSoMy7LMtqdWl4zf Ow== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3g24aaqf1w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 19:08:21 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 24KIo7Fu017899;
        Fri, 20 May 2022 19:08:20 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2045.outbound.protection.outlook.com [104.47.56.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3g22vc3pja-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 20 May 2022 19:08:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nlhkr9xNepVGS15ay4+6SqR9OFnNKpXK0l6jCvLmkdQqZP5aKvsO7QTPHCFXkwpHT5ViVHHS3loh/+bMH4tLT/DWpzegpnvOTQp/trJSabrraue+JzGOV/nnlIGSMz6p92jFLaysR3GIksPfV8CM+5fLhjvTZMFxYjgqlm8BoaajUm6XTfow8jVOP7gOouWWnLtdV3NkcquY0gtAN8MKsIOMXh4p552ZLiRh38tMVjYC9bdAOKIHDB6r7O7I29EXalIuX/9oZDN5T7jub0Ut3qJdeRzBjvRcJPe/6aqM7FfIBhBXbXXG6IfBoI5cBsI37YT1u41SPEMpZscMaJCjLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=qdaSPH385aKe4mNzmkjYe2xBJKTmB36y1+QqLDP7Jq8=;
 b=J+U1yZy3dEu/R6MhK4Sidj39B9QaPY3s12YeFA+B97znspnCSHqmD58hw98lhiWCgmJDkZWUl1Jae3f/i4t5JZky5fXy0yb5XgClBHryf7yeDGgSNtqZG/GymknVewUhHNBGkxvgkKlspLTQWuuUvRIU8qejL26uSFM8Yl2k3FH6Qsnoj1aV07VZ3kGZxLLHMsD8e50BE505PxauHhbXj6cfJiTg9KkvkS3a92uefeY1H5qmmicXnvfvfDdlToxC/19zt/Ja8h6B8OOs5hq+aOkdEqEI/tXXXHSD9wWZFKHvffha3+ZINNgNHS05iyIb7bTxHgp6vhJTaiYCaM5qpg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qdaSPH385aKe4mNzmkjYe2xBJKTmB36y1+QqLDP7Jq8=;
 b=Z+z6IgYLx1NtwAlSglrhBZZX5xrjDzkDelEGx/nPUIO4aQrjMuytc09UpbTn7fSlg4Bf7msC+TZA5HilsCO+cscdrNzIsteXoPki/xM1VqegWPmSdkl8Kx0FQG3RxDV2c/cMSvPWbQgTfrl7B2I7bJwY6nnlYLWpqlXOnJbpZVo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 SJ0PR10MB4559.namprd10.prod.outlook.com (2603:10b6:a03:2d0::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5273.14; Fri, 20 May
 2022 19:08:18 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5273.017; Fri, 20 May 2022
 19:08:18 +0000
Message-ID: <7d0140a6-9ab7-9b88-9601-4204ab8a88ca@oracle.com>
Date:   Fri, 20 May 2022 14:08:16 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.0
Subject: Re: [PATCH 1/1] scsi_dh_alua: properly handling the ALUA
 transitioning state
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Brian Bunker <brian@purestorage.com>,
        linux-scsi@vger.kernel.org
Cc:     Benjamin Marzinski <bmarzins@redhat.com>
References: <CAHZQxy+4sTPz9+pY3=7VJH+CLUJsDct81KtnR2be8ycN5mhqTg@mail.gmail.com>
 <165153834205.24012.9775963085982195213.b4-ty@oracle.com>
 <c8e9451c521573b1774bd47f7a4dfe911fd80f8d.camel@suse.com>
 <32404e1c-bbd3-d3fb-c83f-394bc3765e7b@suse.de>
 <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <2f6d93fd90c3e78166a1803a989b4dc6064fcada.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH2PR18CA0004.namprd18.prod.outlook.com
 (2603:10b6:610:4f::14) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ead4290a-70e2-45ec-65d0-08da3a94195a
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4559:EE_
X-Microsoft-Antispam-PRVS: <SJ0PR10MB45599EE1B9F113AA172AA1B7F1D39@SJ0PR10MB4559.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HJG9k6hn/0UnINSH9QTQ5T8nUXhakbaESlKcvW99b1lFYHPqiyTdA1/QjDQnfefwdtP6V3mDaldtB4r3REQVsO0WE1k78+PmHhbJcabdXLfZlMeetrnit66R+pnB6HSq5t+Rd8ZHUgSit/k5UEHtHZHFEFr9pJvFvbeTpO5nCYOAlBVuO4YpC9UT0eE3GNyLMOm3O8jVjeUNhhytgLVO5EXAnuwV+ryOw2UPZGcxXojc8ZvLqJU/8NVwaJQ+fTZhi+2Cjjxc1IspPescWkkjKz84xTTP8VB7UR7XeGwEzKrZNefm0Zr4y5fEcO0L2AkX3vfZmbb3DvjERc643boOrMSXwg0MSoWcMI8gH26IIqcrjpNKAYfisaYeuotXlFQ7kMJrjUHMjBf1eIFH3Eeljbm1g6b4RrWTrZ0AsAXQ1QTXH7pQESL8519lu6Oo3TfbXvSMBk16/lpAiwu7ossc6yVi986fq2Dp93Fs4IfayQYnDnIgGWj8F/Qn6TpIJz8HqUrtFQ8JZU/Q1ATWYkaB9+9Ma5GQpvlxUXCWGlP4dZhphrWH3TvWhuQocdz5HXV7cOe3Kqa2TGvafu5aYsRbfzBjRYzV9Z09W3/4fN/Ivh+6qOhXqKdUeftZuNozaHd9Vp33cUSUfFV6vBM4JhD0AkZJfgYv0F21u9pv7wspq/XkcVuNxo4lAxacdGIfXu0aTqeuT3CBL9s4y+hCpccPnLNIcxJ+1sKcd/AqCUEVQHA=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(6486002)(5660300002)(83380400001)(2616005)(2906002)(8936002)(508600001)(31686004)(36756003)(38100700002)(110136005)(66476007)(66556008)(66946007)(31696002)(86362001)(6512007)(26005)(6506007)(53546011)(4326008)(8676002)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZU9BT285VVZpaEtWQjRhSUhBYWpvZHkwNUQ2RjZvWW45YUY5VllZUnM4c0RI?=
 =?utf-8?B?bk9VdmlxMDRMcjhsdWJMQ1hmaTJTSmJrdk1lc2t2M0tjZ3ZjL2ovR2o1SERB?=
 =?utf-8?B?UXUvUVR2V2MwdXpEZzd3clRyeUJiWE5QU3ZKNzMzajNJbU1QbXBydWhNN2Zh?=
 =?utf-8?B?RENINXVCOFk4WElHeWV5bFRFNDZCeTZlK3BYcDcrbGYvekFSbTMwcktyeEtq?=
 =?utf-8?B?QUoxRFFJQjhkcHpORFRWR3ZIRmRUOEFSSVBTa1R2Z2kzdHFQN3U1NmpzdFA5?=
 =?utf-8?B?ZTYxWFkzMVVLUDAzV3djQ3JOVkRibTNjZkJmWFJ4b2MyNUpVYTdDRTJvdjVa?=
 =?utf-8?B?THlybFhPR2h5OWd0Mk4xNkhweEhkZjdNYnp0ZHdaWTYyazJ6ZXJmL09wZzQz?=
 =?utf-8?B?ZUM2TUZaWGd2SVkvcnFndDVwbXE0SFFDMkRiaVBZRUV3YlB5S1pzQkJyejBQ?=
 =?utf-8?B?TjlFMTZ3MHlVMWd2MDdYZURnUDlTV3FaQm04KzV4a2R6VmxKY2MwUUJuSGts?=
 =?utf-8?B?Uks1OUxrYkVSN3Q4a1QwNnZJS1phbGFOeWFnRmh1bGFDOW1yek4xbitFUmJu?=
 =?utf-8?B?eGRFWEs2SEVQbkdLckhiaHUyUjY3WGZjeTVNWDVGeG5hUThSdm9mS1ZLRVMy?=
 =?utf-8?B?emxUZXh2YVl4VDg3TUFHY1BBUVM1MmdVRkJWeEE5REJOY3RZR00wWnNzVWhI?=
 =?utf-8?B?NC81cS8yV042a1BlQWIrSjBLVENkdnN1ZnM2eHhwdVd1U3lwOTZET0s4SUpn?=
 =?utf-8?B?UGY0N2duZUUvNmU0VldMVmZUWTVPQk9idVV3T0NHcmREZE1KQnZscmJPb2Fy?=
 =?utf-8?B?dm5CQkNNY1RVOGF6TGVHNjlCdDFxUjN1MEt5RVFEMitkSTIyNEVIQTl5Ym54?=
 =?utf-8?B?MklYUldFUEZJcjQzajJ3cjFkeVNGY01hZ1h2TGNuZXJLL1VkNEFOamNDTlJk?=
 =?utf-8?B?SGF6SkVaWUJUL25zSllGTzJnekJRTzlIVHJreTYveVFjN1lRZmloWmUvdmR4?=
 =?utf-8?B?SjNSYVJRU01VMTJXZFI0Y1p1UkROcFQwTHRtbWs3UEdDTERTT3Fyclg5Q1dB?=
 =?utf-8?B?RmJsWjRhc0ZNZ1o0L1RHeS9Ed3Q5TWpXM1dlWkJmLzF0c3NCWkgwYVAzWnR3?=
 =?utf-8?B?MXl2eUVXYUxKUVFtS3F0OU9LWGdxbWNhS3dWZTBuQ3pKeTdRa0tYS1hIMXRk?=
 =?utf-8?B?Ky9OWEUvalN5SVFPSzIzTVRlNmhYN2VJZkwvSVRuclYzUFJDY2FTY09qMmUx?=
 =?utf-8?B?TnJ3bnF6Q085Sld2ZytsUjdpZ1JUZzBMMDJybmo5THdpYk9hVXRDOUY0Ym53?=
 =?utf-8?B?bnFVT21YcGFjejkyQkE2NytmaFJWdEJNTk5sYStuQXRkdUQrbzRSWitocjhQ?=
 =?utf-8?B?SllpZFM3N3pSM1BidjZzMjlzcG9iS0RMeUlNcCszd21rbG56UUwwcVd6cWJJ?=
 =?utf-8?B?V3ZBS0ZqbCtUZ1BoeklZWXhWNTExNnUxU2hEZE5CWEQ1SnplWjBpblg0Wmlm?=
 =?utf-8?B?cVhNTlFLVVAxb3FnTW1NTjZYQUt4VGE3K3NTN2xZeU1ZU3N5Si9zQm44T2wr?=
 =?utf-8?B?aFF4b2MxdlUvYjF4eVAvRTVJT0V5Wm56czZDbXN2L3lNbUZaeEM1Zk8zNlhx?=
 =?utf-8?B?YWNsblhVbjZFcllFYkEwYk1BWFR1bWNFSUxXOVJQSE5ieVVJRjZMQkxLWWZ4?=
 =?utf-8?B?Ly8wMXJVWkFLVFR4YTkvak4xajhLd3VGZHNLWjZpMDM4VE44VkxuZTZqY3Mw?=
 =?utf-8?B?aTNkcjQ3blZ2enp3dy9CQUVQVGtHU01SdjREMTNQUmw2TFN4aWJsejlHS0tE?=
 =?utf-8?B?cjJQeHpjejRzMzJFMFB4WmZoems0YUloVFZhdWM5NUN1OTVJZElsbzJlL3pr?=
 =?utf-8?B?RG5IR1JrK2xxN0srQ0VUb2NFVmd2RTlvVlZHRWZnb0JndVhXckljN2ZwUkhq?=
 =?utf-8?B?VG92aTVJclhpV3hidEQvMk5Mbm5sSnhudXNLMy9VZzUwc3FvcFdKRHBGSTMr?=
 =?utf-8?B?UVBVU0NrTzVqSWZxNjdBTE5VdEVHekxFL2doRkd6dnVSWTZXeTh5RTlaUmcz?=
 =?utf-8?B?NGxHQzNyOWV1ZGxVbmVyTFNtcjFJanh2ZmZyN3Bsb0QvSmNFR1RKcitZMGZP?=
 =?utf-8?B?Wk5IMUkvamU1VFNzaVNiMVRBcTdsOVVNck9La2ZCTllRZXNqaXN2Rk9ybWlr?=
 =?utf-8?B?eVowRnV6RXlTVFV2ck5reThYZ0xIZXlZWWU0YmY3MVVPMDQ0Z0ZRcCtUTjkw?=
 =?utf-8?B?MUlaLy94UEUyOTNLbzEydFpxZG12QWtFN1cyMWxYQkx6MFIrSTRYS09iS050?=
 =?utf-8?B?OHBRWE9ZR2FBQ3hxS2JRTzIweVUrNmVxWGd0SThDaDVQUElDWmZwazY5Nitu?=
 =?utf-8?Q?iqOXtO4kTq3wY9qw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ead4290a-70e2-45ec-65d0-08da3a94195a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 May 2022 19:08:18.3146
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cRLe5OQ8KMfa1EFoSmyQPUBFP+3ErK9L91STJ5MTuFOYXMdfEZOlUx7a9r3HLumzwA835Q9iz9BOaZItF9fWOQqYdJoc1SNY2U48mPfvClY=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4559
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.486,18.0.874
 definitions=2022-05-20_06:2022-05-20,2022-05-20 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 spamscore=0 mlxscore=0
 phishscore=0 suspectscore=0 mlxlogscore=999 adultscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2202240000
 definitions=main-2205200119
X-Proofpoint-ORIG-GUID: Qn_krdRi56ZW3HQuHlz6tC7eHPxPTjSO
X-Proofpoint-GUID: Qn_krdRi56ZW3HQuHlz6tC7eHPxPTjSO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/22 9:03 AM, Martin Wilck wrote:
> On Fri, 2022-05-20 at 14:06 +0200, Hannes Reinecke wrote:
>> On 5/20/22 12:57, Martin Wilck wrote:
>>> Brian, Martin,
>>>
>>> sorry, I've overlooked this patch previously. I have to say I think
>>> it's wrong and shouldn't have been applied. At least I need more
>>> in-
>>> depth explanation.
>>>
>>> On Mon, 2022-05-02 at 20:50 -0400, Martin K. Petersen wrote:
>>>> On Mon, 2 May 2022 08:09:17 -0700, Brian Bunker wrote:
>>>>
>>>>> The handling of the ALUA transitioning state is currently
>>>>> broken.
>>>>> When
>>>>> a target goes into this state, it is expected that the target
>>>>> is
>>>>> allowed to stay in this state for the implicit transition
>>>>> timeout
>>>>> without a path failure.
>>>
>>> Can you please show me a quote from the specs on which this
>>> expectation
>>> ("without a path failure") is based? AFAIK the SCSI specs don't say
>>> anything about device-mapper multipath semantics.
>>>
>>>>> The handler has this logic, but it gets
>>>>> skipped currently.
>>>>>
>>>>> When the target transitions, there is in-flight I/O from the
>>>>> initiator. The first of these responses from the target will be
>>>>> a
>>>>> unit
>>>>> attention letting the initiator know that the ALUA state has
>>>>> changed.
>>>>> The remaining in-flight I/Os, before the initiator finds out
>>>>> that
>>>>> the
>>>>> portal state has changed, will return not ready, ALUA state is
>>>>> transitioning. The portal state will change to
>>>>> SCSI_ACCESS_STATE_TRANSITIONING. This will lead to all new I/O
>>>>> immediately failing the path unexpectedly. The path failure
>>>>> happens
>>>>> in
>>>>> less than a second instead of the expected successes until the
>>>>> transition timer is exceeded.
>>>
>>> dm multipath has no concept of "transitioning" state. Path state
>>> can be
>>> either active or inactive. As Brian wrote, commands sent to the
>>> transitioning device will return NOT READY, TRANSITIONING, and
>>> require
>>> retries on the SCSI layer. If we know this in advance, why should
>>> we
>>> continue sending I/O down this semi-broken path? If other, healthy
>>> paths are available, why it would it not be the right thing to
>>> switch
>>> I/O to them ASAP?
>>>
>> But we do, don't we?
>> Commands are being returned with the appropriate status, and 
>> dm-multipath should make the corresponding decisions here.
>> This patch just modifies the check when _sending_ commands; ie
>> multipath 
>> had decided that the path is still usable.
>> Question rather would be why multipath did that;
> 
> If alua_prep_fn() got called, the path was considered usable at the
> given point in time by dm-multipath. Most probably the reason was
> simply that no error condition had occured on this path before ALUA
> state switched to transitioning. I suppose this can happen if storage
> switches a PG consisting of multiple paths to TRANSITIONING. We get an
> error on one path (sda, say), issue an RTPG, and receive the new ALUA
> state for all paths of the PG. For all paths except sda, we'd just see
> a switch to TRANSITIONING without a previous SCSI error.
> 
> With this patch, we'll dispatch I/O (usually an entire bunch) to these
> paths despite seeing them in TRANSITIONING state. Eventually, when the
> SCSI responses are received, this leads to path failures. If I/O
> latencies are small, this happens after a few ms. In that case, the
> goal of Brian's patch is not reached, because the time until path
> failure would still be on the order of milliseconds. OTOH, if latencies
> are high, it takes substantially longer for the kernel to realize that
> the path is non-functional, while other, good paths may be idle. I fail
> to see the benefit.
> 

I'm not sure everyone agrees with you on the meaning of transitioning.

If we go from non-optimized to optimized or standby to non-opt/optimized
we don't want to try other paths because it can cause thrashing. We just
need to transition resources before we can fully use the path. It could
be a local cache operation or for distributed targets it could be a really
expensive operation.

For both though, it can take longer than the retries we get from scsi-ml.
For example this patch:

commit 2b35865e7a290d313c3d156c0c2074b4c4ffaf52
Author: Hannes Reinecke <hare@suse.de>
Date:   Fri Feb 19 09:17:13 2016 +0100

    scsi_dh_alua: Recheck state on unit attention


caused us issues because the retries were used up quickly. We just changed
the target to return BUSY status and we don't use the transitioning state.
The spec does mention using either return value in "5.15.2.5 Transitions
between target port asymmetric access states":

------
if during the transition the logical unit is inaccessible, then the transition
is performed as a single indivisible event and the device server shall respond
by either returning BUSY status, or returning CHECK CONDITION status, with the
sense key set to NOT READY, and the sense code set to LOGICAL UNIT NOT ACCESSIBLE,
ASYMMETRIC ACCESS STATE TRANSITION;

------

So Brian's patch works if you return BUSY instead of 02/04/0a and are setting
the state to transitioning during the time it's transitioning.

I do partially agree with you and it's kind of a messy mix and match. However,
I think we should change alua_check_sense to handle 02/04/0a the same way we
handle it in alua_prep_fn. And then we should add a new flag for devices that
have a bug and return transitioning forever.
