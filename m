Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CEBC7C433EF
	for <linux-scsi@archiver.kernel.org>; Sat,  4 Jun 2022 17:14:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239037AbiFDROQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 4 Jun 2022 13:14:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239000AbiFDROP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Jun 2022 13:14:15 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5B21286D1;
        Sat,  4 Jun 2022 10:14:14 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 254EdH6H018560;
        Sat, 4 Jun 2022 17:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=8Efahz1Q501VZrwTzJYo6SMqWFuOS3sduaI8Pi1rGVc=;
 b=ij924iQTOl5nhdFb5JCL4JiQeG3aDs/yEiUgPnG/h08J63wkhpG4/GuW9PUznthNrVB4
 TYsKe2a1dQ+SKXJpmnNNdy6FLTvrxiyvU23J2W9MNmn+7EJ5GfNjLu7HBQlo3Lj4HtTr
 T3TDL5ywAt2d7/LC3VKVdUsdHSS9RtLgoL8xnP+NgqyznCGpL5+Jyw9AYeROLyrLu5Z7
 90qC4tBFKt4qJaJZjYFOL0/GJ3gs7TzzFNCXZksofYAzdx2MJwedRnbzNf6z4GlbGqME
 HtUTdx1a0pIkTGd8HvTwIZ9JsbqkEY+tyxCSt0Ae1ow3RQzx/cIRSQERHfMCNd0Ri7/1 rA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gg91102w3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Jun 2022 17:13:56 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 254H5mr1003190;
        Sat, 4 Jun 2022 17:13:54 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam07lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gfwu0a7p3-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 04 Jun 2022 17:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WenjUhsCi8LpKWYxgDhjlxhzd0o/0aJst6zThgjr7EuDYJQLedlF5ac7N/E9GMff/kusJxXAVxHlrsc3BVxQnJ1uYAnXP9t4MSpx/G6c1vdg6RXzjIbzf/OrJygH3BT3M7reKH6kporTbBv8cZKmM8TfNehCHg3PnhG09F9/WlB4Sj5hzjtD+ln2Dmmd3fUPb/S1XpY4ppem083ZdqO8S0Z4MGrAgyRALonCUB04kqsqgikDJ1/HxqMzgpcW9veWGTCgs0KVyoeh+EvNQvbRvOywPQ7jYTNDqpRnArAPAvyLj72c2kq33wjTgpHSvLbFcSu1n7EXPCjSDEznRCH5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8Efahz1Q501VZrwTzJYo6SMqWFuOS3sduaI8Pi1rGVc=;
 b=Zg2V3Tibg2dO13WW0IHczgiTFteMXmT3WvSG5By4vOmGq/gZFuMV8k95wnsqlj4irZtujqQ9vMIqxksP4vjtECEhoqjPUgiv9LKf/8gfAVKxJEvD++T0WPQilozwheMaJrZxDCNRrOstv0YKzU904+EKkE+RwTROx8iAGhvqT8GtSXL62Q0t5H50A2MUFq6A82udfX9DmyPk5DJ+vZl6BUAmGciyz31mEuoIfEbd4dEei3gCIGeX5LgqslGzXA2wyEzlYtVb6dfGM/rSj+2cVr1dKLMBNkJED8ZmLWAW6E5kBkECtz3fAUroGdU/Zwd9QnlhVWH+ppPNHYBv3PpjLw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8Efahz1Q501VZrwTzJYo6SMqWFuOS3sduaI8Pi1rGVc=;
 b=zLXNZeCDGAxhsA5qv6EHkoNBYUM4+2H3c3rfP66cwnGm4MTU2F7SJLiVaYXw3IfYTWq3FF4q6f2SAVbRfeztADD9wrJcBxH6Uwg55dF9bhZFnlgK+GL1ygoRmCwxBSZ7h3IRqteoVxm1pwOE2DL2YkvT7NFnSPsIpsX8GTH7OnU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BN6PR10MB1490.namprd10.prod.outlook.com (2603:10b6:404:45::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Sat, 4 Jun 2022 17:13:53 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5314.017; Sat, 4 Jun 2022
 17:13:53 +0000
Message-ID: <6cc818cf-fac4-d485-ea9d-0b8597f24a33@oracle.com>
Date:   Sat, 4 Jun 2022 12:13:50 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.10.0
Subject: Re: [PATCH 09/11] block, nvme: Add error for reservation conflicts.
Content-Language: en-US
To:     Hannes Reinecke <hare@suse.de>, Keith Busch <kbusch@kernel.org>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, hch@lst.de, axboe@kernel.dk,
        martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603065536.5641-10-michael.christie@oracle.com>
 <Yppkz4HIPVxr54hn@kbusch-mbp.dhcp.thefacebook.com>
 <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
From:   michael.christie@oracle.com
In-Reply-To: <fdd77f3b-691a-a9bf-b31f-0aa845e68e59@suse.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM5PR15CA0032.namprd15.prod.outlook.com
 (2603:10b6:4:4b::18) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8ea4fbd-c255-442e-eeaf-08da464d9980
X-MS-TrafficTypeDiagnostic: BN6PR10MB1490:EE_
X-Microsoft-Antispam-PRVS: <BN6PR10MB149049E44CA82546832C5356F1A09@BN6PR10MB1490.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: fXBdX0IdrhHM7Gl9k8/vz3cXQbKAtZgzw+tBuL7s8PgcVnNPwrA/7M2Gply20ZcJx5j49eFdoMiBejiarzHwLhaQ3/NxxS/8L7wI1tg06DrdN34W7v0YB3o7doijXxYq3T4LMce89RGijjk7rzMc0AB7KXHt20minInQjhbWXGk01qW4nX29K+VoIPez3Vf7ZBGVpQXQExs78ah99VqXX9Of+8vPqKT9iro8AmyDVl37qtBo+FchNOpkEqDxQ5/jCfKF8ySLuvSePFighGP9dkN28DQ5/OuIEG6TFiNPh8VGmlzpnvToeQ8uIsXYprwJAV9Tx9ww5bxBRQmD7U+VOGhvYvLwCUd1mi7/nhHv8td8InjQm00M+2C0kiH8vo/pPTXiH2xiEzplYaIbjyg+lSWev0J9LT9R1D62KSfUSp46VlzZAPcbJQW4fmWCWceWXhskm5GjamhyG4oSywekL7MHgNK394Uj/Rc5X/JFVtfO48AXFINNxr+HGY5bCtsetki/0l3H4cEHYKbId8n+OyoqMulEZKqsSut4nwk7nsWjSN2bA4YJGzVIhBngFQ8br8d9svl++YnwZYh0ugtnBoucLGV/Efv4imfOpglQYTlS122bH4+/JxM9vGgi/PaY6LAJ3toVGAbcGZsf/m4NtuTImrGU7K5flT1opJvbMldp7k0bSLuQAllig+4wu2sDySe+XrNVQPMvETjX9WZkEw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(316002)(31686004)(110136005)(508600001)(6506007)(38100700002)(6486002)(8936002)(53546011)(86362001)(31696002)(186003)(66476007)(66946007)(66556008)(2616005)(7416002)(9686003)(6512007)(26005)(36756003)(2906002)(8676002)(4326008)(83380400001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?a0hjUHJHRm9RL2dESVRwK1ZQRlh0RExqT0JiYXhzd1RCSHdlaTJrVXNxYy95?=
 =?utf-8?B?cFFzdGVmUDBkdThuUW84aFJCWTNjZVFZYmJBU2JKYUh3bDVIbVdZbXh0N09s?=
 =?utf-8?B?Vi9TTnYwVzJ1SFF6M1UrNSsvbjRVVkZKazFOUytCVS8wdkpXZXBjYVcyNnZ3?=
 =?utf-8?B?ZFF1Uk5Da3R2dkQva3J5NWNxdEtPUXpCcTNWRHN1Wk0rdlkxU3hkR3RCUVVv?=
 =?utf-8?B?ZWtSRmhKOUZvb2JHeVQ5N3QzY0FLOElkak1Sc215em5wRlZLdktJVXdQTW9R?=
 =?utf-8?B?ZG94Tyt2eVdRK3pqZDgwQjdjRFBUaWVQVzVZNVI4YlhNRGFrcjF0OGxXRWNt?=
 =?utf-8?B?YUpzVHQrTVZIVHBSazc1MnpaMlJ0aFhEd0ZJcXZJQjJVVEVnTExhUStkeVJo?=
 =?utf-8?B?OHB6RkNQd2R1ckRIRnFYK1Y5eUhUb1BIdG9ERHdIUTVVMzhsVDl3K3BieE95?=
 =?utf-8?B?clh3SVFKQnB5TmpSQXEzcmlPLzFHUkVldk5ISkZMeVlJV1FPeDRrVWM1eHJH?=
 =?utf-8?B?WERPWUlic2Y1LzFTbmZJZlIwaFBjZGhrSGVlRU5uL2xuWEEvK0JhVEMvcU4y?=
 =?utf-8?B?R1p2VnBCT3NXZXJDQ3ZucGo0eElQUzJibzFDc2JobTVXaU0wTGw0eWt6Z3p5?=
 =?utf-8?B?ckgyQ1RadEp1bWh3ZG1kYW1Rd3l1RFBSdU5Fa3BkOG9WeEErMDJVby9Ndkh5?=
 =?utf-8?B?WXRxZWthZlZKdTU2UmllRU5Cd1BqNVkvMnVuYVhjcy81N2lQTUtxR2d3N09p?=
 =?utf-8?B?Y0wvbGhBQzIvMHdINithZTBpdUhMQVZiUzRhdjJWQUVpV1MrcER2M20vNDlk?=
 =?utf-8?B?TE1uZDd1c0JiVkROZ3lTMFdmUUdFSm5rNmpHN0ZhUWVsdGdmRi9SV1BTanhS?=
 =?utf-8?B?WndhU3dwTzdENXNyV2JNMVBUNWdjczVkbGFza2grT2lMa1pVTXRMKzFMZ2kz?=
 =?utf-8?B?bkVOanBsUVBzYTRObmtWTzkxQkhNMFR6K09xK1JlZ0FWb1IxUUdvT0QrSkRi?=
 =?utf-8?B?L1NjYkY5azV5ZlZ4OTZUYzF4M3J4djhRMlU4cnB3UStlMFdwSEZ6WWVnbEc1?=
 =?utf-8?B?a1VQd2dqck43UE50aVkrbkZDN2NDSDFvVEpTMkxEaHI3eWlyeU95enk0TS9K?=
 =?utf-8?B?dkpiY05WREkrUFU5Mks1bTB6WFgzdlp2b3VNQUtNZHRzTnpCcHo3UE5GNGlW?=
 =?utf-8?B?M2ZReis4eTNpQ29SR2UvakJrVEc0T2NkbG4vZmRqMXVoRjI4TGJNUVJTUElS?=
 =?utf-8?B?cEpIcmpCaGMyTFZQZlVGNFNEbHVESS95YnFCS0ZLelVoVS9GZ1k4V05jK1dN?=
 =?utf-8?B?SnVYQ0lvZ29pUkNEL2dKMmI0ZG1qVndLZE1BUmFmZnJLNVZnZTlJN2hLR3o2?=
 =?utf-8?B?S3hQbVI5VFYwMmI0ZzdTZCsyeUp2Kzk4OGNyOENTNC9HUG9PZHg1Z3RJOFMx?=
 =?utf-8?B?NmZwemg2ait1NE4ycVlqTUxnTXQxb21pa2dMVnV5aTAyZ0RmWXI2NzJHOWJq?=
 =?utf-8?B?SlkwSW50eEdMV2paelN1YWdwUDRNS1JiNUZxQXV0b1d4N2tLZVV0TXpEZGhx?=
 =?utf-8?B?akU4b0s3SVFudDc0N1NrSzFjMnNCcW02Q1dCREMzeTRSR1VzelpjZ3UyZ29w?=
 =?utf-8?B?VzR5Mmp0NTZGc0lOU01GWm4wYUNncGdveHJWMTJmYkJrajJ4MjlqNnlIMmpt?=
 =?utf-8?B?WFRCK0tZSXF5bVFBWndjcFZtY1BvZnFyZElrcnRrSFRJbkR6OTZ3eU9OMEtX?=
 =?utf-8?B?NEZqTzMzU0w0Y0Q3Q21jKzkvQlk5RllPb2tqRVJIbHVtZkdkb3dyVzBSWXMy?=
 =?utf-8?B?ZitsOUhVZ2wydzNnejVqZG9tbG85dERPdGZBOVRVZ3htdjJDS1V4QUdIZDJC?=
 =?utf-8?B?empKV3l3VHN2YkJuK3FhQnJxZm1PaHdCMUFoK1VjY2ZyZlExc0JralI1QVIz?=
 =?utf-8?B?RkxBMlJVQis5dDF4N2NzM1FnWFhwVy90SEcvQ01GMUNsb0lNeGtJQlE3bnoz?=
 =?utf-8?B?RWdNMGRkcktWTlFrMEpNTCtLVTR2RVhRRWpVVDlXZ0Q0ajQxSWQ1SDRmcjlO?=
 =?utf-8?B?cEJWRTlNbXZDdzZ1OWF1bVNGR0pESFdOaUNGSjQvQThtWmVPTXBpOE95eUtv?=
 =?utf-8?B?N2R6dUFDOVJtL1N1QlVFOXJ0NXRSVGFUbXo5OEFNOGFvQnRuaUZsODJJcDNO?=
 =?utf-8?B?L0xJay9kWVdEZ25vbXlWK1hMZEU0SVNSWnpGSzI4Wm9aaUtwd09DM0VISUFM?=
 =?utf-8?B?OXRxTzRKZ2kwcGdIU0VsRitUMkNVejUzbjBpRC9TZW9yNkhYMlUzYkhZSWdv?=
 =?utf-8?B?a1RhME9zcmRITTE5K0ZXdEpLRkFjMTVJZXlBNHRubDRuUUVxeklXcDlmRGRk?=
 =?utf-8?Q?SDLkDqruHthegFis=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8ea4fbd-c255-442e-eeaf-08da464d9980
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Jun 2022 17:13:53.0636
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: xENnlroWGAjOlGhBsIllWyUApEOYd+5eojd3SPy+CzpUmazKO1QENX0P539l+puf4QxARViFChNTdkxwVwX2ArWoyswshTnl+NhXflDMXjw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR10MB1490
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-04_05:2022-06-02,2022-06-04 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 adultscore=0
 spamscore=0 suspectscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2204290000
 definitions=main-2206040079
X-Proofpoint-GUID: tn1Uek3G3aCdUTW-p35R3ezy-c2VKsG9
X-Proofpoint-ORIG-GUID: tn1Uek3G3aCdUTW-p35R3ezy-c2VKsG9
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/4/22 2:38 AM, Hannes Reinecke wrote:
> On 6/3/22 21:45, Keith Busch wrote:
>> On Fri, Jun 03, 2022 at 01:55:34AM -0500, Mike Christie wrote:
>>> @@ -171,6 +171,7 @@ static const struct {
>>>       /* zone device specific errors */
>>>       [BLK_STS_ZONE_OPEN_RESOURCE]    = { -ETOOMANYREFS, "open zones exceeded" },
>>>       [BLK_STS_ZONE_ACTIVE_RESOURCE]    = { -EOVERFLOW, "active zones exceeded" },
>>> +    [BLK_STS_RSV_CONFLICT]    = { -EBADE,    "resevation conflict" },
>>
>> You misspelled "reservation". :)
>>
>> And since you want a different error, why reuse EBADE for the errno? That is
>> already used for BLK_STS_NEXUS that you're trying to differentiate from, right?
>> At least for nvme, this error code is returned when the host lacks sufficient
>> rights, so something like EACCESS might make sense.
>>
>> Looks good otherwise.
> 
> Welll ... BLK_STS_NEXUS _is_ the reservation error.

I was not sure of xen/virtio scsi uses of BLK_STS_NEXUS/DID_NEXUS_FAILURE.
The virtio spec's description for VIRTIO_SCSI_S_NEXUS_FAILURE:

    if the nexus is suffering a failure but retrying on other paths might
    yield a different result. 

looks like the description for DID_NEXUS_FAILURE in scsi_status.h.
To me the the description sounded generic where it could used for
other errors like the endpoint/port for the I_T is removed.

However, the qemu code only uses VIRTIO_SCSI_S_NEXUS_FAILURE for
reservation conflicts. If we are saying that is always the case in
other virt implementations, I don't even need this patch :) and we
can do what you requested and do more of a rename.
