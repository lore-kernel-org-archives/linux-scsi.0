Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2D44BECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 17:17:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbiIIRRX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 13:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229748AbiIIRRU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 13:17:20 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C5AD1269F8;
        Fri,  9 Sep 2022 10:17:15 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 289G9bCO011093;
        Fri, 9 Sep 2022 17:17:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=mr4K326uD7wI5kM6IJ61Vnyxjr0NOMhCG78YZMlzsm8=;
 b=uX4hTCuk6RG5YD8DfzNVoATyPkX7AcXJEUI9ylG4UGBhLin0l/VnpQU/ICSr7MxgmB5l
 7Qf9RTKirNLJ68ZJV0XzYZv9Ybs7hcdA9gcmr3hcUz+6X9gIKoKK9nFqCJ9E7XI7Eu3n
 pkMPhjddEY/yWAdTxtg+YDNWnxJac9KSrxYWX9ouytao0pi9104M1IhtNa5NNlQfhHDl
 xrFz3DjSdUOGsB0JhY1A57ioob06CPursJsvO3JjoWIxXiUbabgnizSy8YsT/szulQ9u
 a8bjtZLJfRuP7dH3z3slqkpY3EErTdDOxLgjhDcVoqpgRvJ1CWU5joXfiYICUtFZlJ1B ew== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbxhsyvwu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 17:17:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 289G96J0024572;
        Fri, 9 Sep 2022 17:17:13 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2168.outbound.protection.outlook.com [104.47.56.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jf7v9g7yt-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Sep 2022 17:17:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=D+akBu/CumCc7wokpc/z07NYYYaMgQ2oCvMGaiIf9m8UaJWWU90+QB+lOhTgo7N/f1px12r2iYJdu2MifpI7De60akkHiXVjbqVGTkt0vv4tnXhaCpUK2RiDLtOASluhvlUjG2PKQjLJH3q/9r3dezwbPhgQPbjHaabFzFeNnn4yIhhPfmLjoEJQo7V3t3YftTuuiuHp4trb/xFXDzeon7hQN8Wfol4BGWqAeBW5YOT9pQoqBuh8s4zwskMuhCYhEI2NZ68SaQFps3hd2BxYe2F+5F1TZa4czSTgGaaIMXBHZohh2dXqefoZ4qfovUrtKZmnb5IGw2lmlBzHNuXkfQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mr4K326uD7wI5kM6IJ61Vnyxjr0NOMhCG78YZMlzsm8=;
 b=QjlzZYlFGd/0Zl8wDsApYIVeH+8vUudIlGxGG+fDBTjC0ufKdXk4BWRYPRfSmmv2htXJWoUHrJkbgR5aa4LeOZ1PPTxXRrk0hSp43FoK8YTZBYnBukWIwnTkBxataP70OwP1+mKi4+4GOrqrmzIa0YKe7A8Mbh2+mn/Rr3QpBvRpmaWvf62hqsLvaOmDwHUzZuWtDK9hwEsawiHlyMbMZJjB8RMCI1H93OzuseqlxgDoyU+d0Ma3I1XT7p1tKIT36dfBzTfO70e0jrO7aUy9nkJPnyHn3D6tnJdfOA3TgGBZtyxt+L5qHSe55JoWoaunfFRoPCdgKuCGa+r8j1znXg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mr4K326uD7wI5kM6IJ61Vnyxjr0NOMhCG78YZMlzsm8=;
 b=gzHbITY6OeiFcEBj0SSyxKZYMIB92zyKWDM3AiEBVKiwWoNCL6xI9CLAGYTA0E3VmKUfi3uvzsfph2hqo9Z9Jm44fbUbTqoaaMx6hTER11tB3meNdnikUNAAp+aYrBGkRLzrsUBbf2e1dTfQMM5JBN5LdHQXdf3HcsW4MXYkYR8=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH7PR10MB6380.namprd10.prod.outlook.com (2603:10b6:510:1aa::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5612.14; Fri, 9 Sep
 2022 17:17:11 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.021; Fri, 9 Sep 2022
 17:17:11 +0000
Message-ID: <67d0d0ae-3cd5-6b0c-7a88-373807142ddf@oracle.com>
Date:   Fri, 9 Sep 2022 12:17:09 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
Content-Language: en-US
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux@yadro.com, Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
 <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
 <20220909112235.GD9218@yadro.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220909112235.GD9218@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR03CA0278.namprd03.prod.outlook.com
 (2603:10b6:610:e6::13) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|PH7PR10MB6380:EE_
X-MS-Office365-Filtering-Correlation-Id: 6554b14c-42ae-460a-4788-08da928721ba
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 2RcPXSvEqsV3DBs1h45ICwAHa/5k3Snta511n0Ne3+TJjdhr/wg7ix6oShikshl4X59tT1IR+SKx+cQrsT4igxj3ziJq0eu44OKIKf/l7DHfSmHYz5ZOuevrmj/7Mz8pWr7VinEJild9+LFAy/0A4gfooUDNhdCC83NUz3S9Osx3N4pF5vJpZViICS5AvdEh4VX+nPaKLpZv2mcM8wkSCsRICdXouiyB+aKBsH18zkAAvDj+Ndm831+L7SQtmuO8yRK6jnGRO7xWi9IYA7uBdX9FkVB5JAIG1ltl626NXwD6arokgJzp9avYAVJWn8NE4uZqDHSNfn2T+W4lrru9cl7WruqoP40ssUP9vxRk1dy2z0jBjxDTAlK3Xy/bMQzGRqLYHQL8Bhv1FXjUPNHEkpAPS3CZur52JWNj6Yusw0LpQlbbCkw2pdbV6MJDiDxkGPqcFyfP5tBOX/XvYtxs4y8DjRDBK+iXCKXWy1ed31Y9zL5PatmNuhgbBlxTK3NqKCNG08cQnSmJ/f3wm7DphgjTpc3HACy6+9EKZQ+68K18ClWWFADFnG409TKXObRwF0Ja4F4vIhaZ8cjN8kKs1K57arPFrA+Ivph7WuL/0NMWniweMtxefVdfl9FMOfPv+eckwF29aX9BHCeiK2MtSDNTePiGhSJDRpQ0og1eHnZiIHQF96B7QDfl9e/k7gLV87Se6duTRr+jXT9e49j/SlKvrbkepgsoGkBgEtOOLmvzgP/5Qrq3pwvtIwi7+G/QM9uEUtqN6QdZub/Vdt9LqvIj6Gui66NBx/xxC8Rx/Bl3WwSrv5hUfABzIN8/sg6S
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(366004)(346002)(136003)(376002)(396003)(39860400002)(83380400001)(31686004)(86362001)(316002)(186003)(36756003)(6916009)(2616005)(54906003)(8676002)(6486002)(66556008)(5660300002)(66946007)(66476007)(41300700001)(8936002)(4326008)(478600001)(38100700002)(6512007)(26005)(31696002)(2906002)(53546011)(6506007)(43043002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WU02dXc3bkJ3ODlxNTYvQ3kxS0x2RERyTS82ekgyTFU4K0JnbEprbVR2UFdN?=
 =?utf-8?B?WG1pWFg4aWl4YkhUUDEzSFR1SndiWklleDZjNUxGRjlKNmtWN29PbVI0TFF0?=
 =?utf-8?B?MTdWcm1KMy9SSVRkdktZcXI3Tm5GakVqZkZwZFo0OE4vMmc2ZEZrV1VONndy?=
 =?utf-8?B?RWFxR2wzTzRxVDFlczAzWDVOZG95WVhlbGdsNjVrOTYrdUVxTlJLeDE4TUh5?=
 =?utf-8?B?Q1dRc3F5Z1lKYlRPcHpReDJBVFM5WnM1K1FxdVVGakZqNXQxbDU3VUdvNFJn?=
 =?utf-8?B?ejdML1BVZEZTcHA5YkNVT3dJMUtZV08rQUp4NnkvM0hEeFVtYjFrSUxJSWxt?=
 =?utf-8?B?MTdnR1Z3RVRiUjJITnZQY2V0NVFlUzVsOGNxNXNCUlJSaWdiV2wzMWdzK0oy?=
 =?utf-8?B?cnozQ0ZpRXUxZE5nOFB6blBwQ3F1N3lhS2E1YWhNb0M3UURiZ0g1elR6aXlJ?=
 =?utf-8?B?OXBmS0tpQkM4ME9VcUlRcjRoQlZEd2c4TllQRm1vSGxWc3R4RnRLakFEaHRJ?=
 =?utf-8?B?QXVCV3pFTVk1M1NKMjEvU1BjNkVESElUL3N3NlpxNHRDdXh6SmxFWWdGTDBW?=
 =?utf-8?B?MW9rY1VDNlRlZjA1aEZSbmFJS2R3K29qZDZnTnFjeTVIU0t0Z0JaLzFlcFBH?=
 =?utf-8?B?ZGhLSXVQYzR6NDlUZjR1SEpPWFVuSzdjOEZ3alE4SjdUcGQzQUZ3NFAwVndS?=
 =?utf-8?B?TkpzQTlFWUNJbGlCNTdqSDBXZlhRUW9PTE9kdDNqZUpOSFFjbDJtVEtNTllj?=
 =?utf-8?B?dndxc08xTDFsMG5MeFNsOE54YUMyQjNHejRab1I4VStBRHUyMjJwVXM2OFZn?=
 =?utf-8?B?SEc3K3dIUFE3b0lISmVBYmZsZnNqek1mcGNWUHNvankrL1J6Rmd5dGIzdkMv?=
 =?utf-8?B?VVMvd0tYcnNOSDBzdC82cG5SOGhrNlJ0ZkY4SDR0SEdrTXg0aStDWXpYcFNN?=
 =?utf-8?B?WjUvYnpMWnhyVG5xN0RoRW1oRmlqZVFwQnUrWm9Dcm5MdlJDTWEzMjlUOTJI?=
 =?utf-8?B?WE92U0NlZloycGJtNER1YXNzblE3SjZpWjFOU0xyWTdiYVN1TUM5ckx0RS9s?=
 =?utf-8?B?MDVDOGJGNTFoNzBzSnI5V0pJQ0JEN3VxTDFKVUF2NDlBVzNWZSs0UzNsa0xh?=
 =?utf-8?B?S2pTdG1rdEE2M2kreENFVmV6SXdGZnBrMVM0ZmtFcnNwUGpuOGxtUERxTUpv?=
 =?utf-8?B?REVacjB1bE9vQndkVnVpVEpIM0VsajlTN3FvWnBQRGMwZXBQM3RMZ3ZPRnpy?=
 =?utf-8?B?NjlXNXhoSnZwY1ByRVRic1VNL3FLRTVmRXMzWS9oMldZb2hpbXBncjAyazh2?=
 =?utf-8?B?K0xqbzVpWHh2dzkvV3FVbXQ2ZGhKbnhrWExqRGpSb1JJL0FLbUphVzQ4UFlV?=
 =?utf-8?B?Q2p2cGtmVjFNWVJ2STJURnprV2VlbitsWTF3ZXIyK3c1RlNWaUVNUm4rQ2Zx?=
 =?utf-8?B?c3JKdUl2SDVlRW5jaU9rRm52SWNrSFpoOWhveEh3a2ZPRHM0cU82bStjTzlp?=
 =?utf-8?B?VDRLQkxQV2E4cnBkWE9seTNKZ1UrV1NodWNVR1dWbkpJSTBGVllzREIvZzRj?=
 =?utf-8?B?K1V1eDRPLzc3cHFnZWNRUlVLZUsrbjM1MmdaOWlvZmZPWmpmTjVwRTZvV1U2?=
 =?utf-8?B?Zm10M3djZ0hhTHFKL1k1dytCazV2dzg5MTBOQTlpSXRLQU13T2FYdHlBNXRh?=
 =?utf-8?B?NmNSRlE5OEpwSEVTcTZ3T25XbDlpMjZwVTJ2WWdCZG5XVEVpYzZpSnZaNzhH?=
 =?utf-8?B?Q3l5WHFmVEtMdzFrTVluZVdJTnc2dFlTU1Fyc1RzR1lIcDM3NmkzdC82S1Q4?=
 =?utf-8?B?VURDM2o2Q1BVREtuSE1qMUxkbGczTVpOY25CcC93RWd0b1hMdFhYZEEvTFFV?=
 =?utf-8?B?aTFRLytER2RLRkdCL3dzVDF6M2pqWHN2SnMwSFpiU0RNb1BVVDA5RXFiQ2dS?=
 =?utf-8?B?Mzd5bWluOG92VjR5YkdIcUdta3A1Q1dPdzBxN3JYZkUrMVpGaHZtWTA5aUFG?=
 =?utf-8?B?bVUvOEIySTNJWXRhWTBGSm1oSlgrNVVCajRoVk00em9POFdjWE5CdjZ4UUU3?=
 =?utf-8?B?dGs1UzVOYUpDY096Z2lPQUgvc1hKM1UzMC9hdEtQWGJQUUJNSUJHQjNMRUZK?=
 =?utf-8?B?b3N1Y0ljSzNwM0ZxRWtScXJoTEhuWTlUUzdTOGp1Smswa3l3RnQ1R2t6TmVL?=
 =?utf-8?B?cVE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6554b14c-42ae-460a-4788-08da928721ba
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Sep 2022 17:17:11.2161
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pUa4eyqFkmR4kmSWG6xZXxRGGZ1tQ5ZkZ1Ul2ejQJk284OMSRcui7e1a6NRnoki8b02uFo5oCwjbqSzfcYMV8h6+S7SQijDNdc2JduqkrXk=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB6380
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-09_08,2022-09-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 mlxlogscore=999 bulkscore=0 spamscore=0 malwarescore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2207270000 definitions=main-2209090061
X-Proofpoint-GUID: YglNaO9U70HVVepLnzViohjrP1yW3Z1E
X-Proofpoint-ORIG-GUID: YglNaO9U70HVVepLnzViohjrP1yW3Z1E
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/9/22 6:22 AM, Dmitry Bogdanov wrote:
> On Wed, Sep 07, 2022 at 03:01:00PM -0500, Mike Christie wrote:
>>
>> On 9/6/22 2:49 AM, Dmitry Bogdanov wrote:
>>> From: Roman Bolshakov <r.bolshakov@yadro.com>
>>>
>>> Default target port group is always returned in the list of port groups,
>>> even if the behaviour is unwanted, i.e. it has no members and
>>> non-default port groups are primary port groups.
>>>
>>> A new port group attribute - "hidden" can be used to hide empty port
>>> groups with no ports in REPORT TARGET PORT GROUPS, including default
>>> target port group:
>>>
>>>   echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden
>>>
>>
>> How about "enable"? I think that fits how we handle other objects like
>> targets that are setup automatically but are not yet usable (can't login
>> or reported in discovery commands) and devices we have setup but are not
>> reported in commands like REPORT_LUNs (technically you need to enable and
>> map them but you get the idea I'm going for).
> There is already an enable semantic. It is pg_pt_gp_id field. Until it
> (id) is not set the port group is treated as disabled and it is not

Can we just make it so userspace can set tg_pt_gp_id to a magic value and
that disables it by clearing tg_pt_gp_valid_id?

