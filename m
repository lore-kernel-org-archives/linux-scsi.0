Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6589CC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 19:39:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237785AbiCITkI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 14:40:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235404AbiCITkH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 14:40:07 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF6AB14012
        for <linux-scsi@vger.kernel.org>; Wed,  9 Mar 2022 11:39:07 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 229JObhb032285;
        Wed, 9 Mar 2022 19:38:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=zJVaYc/D13PhQRzIivjp2371XbMmuv5Fvf++lL3GGSM=;
 b=yWrFN8HijeXYWocK/+lva9IC6dNUalT2zblTCKdVkJlwjxHrQDlzzbp2gMl/KsrDx4V6
 y0/Vgv2lgjiHEnWSOF5f6rrhC/aKlY1E8facYadENcIfYSJ+nyFEQUG1atcLxIKinAt4
 EYt0IxxcKOuuW8d6khO2EW1zBPZR8ALtjXP4DXJ22ZQZrANcvbmXUlP+4qZJ+J3HKEWo
 0NWQvK/L6/wxw5db3uLqH8oQkVO2JnzLMTu8JfD7i/SPseqNVmS1tsZotWbWqSRK2SX5
 4QQRLMMlmw2LOdeiLZEPbv2ujurVhy3j0vTgNcIvSDviZj9tfcpzn89unAciNds6mJqR Tg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekxf0u67c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:38:55 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 229JPev4051974;
        Wed, 9 Mar 2022 19:38:54 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2177.outbound.protection.outlook.com [104.47.59.177])
        by aserp3030.oracle.com with ESMTP id 3ekwwd0bhx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 19:38:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=W5qmSxiE/6RdXgRoLb5CmhME2R1oI5FSEbPkJcNVe2cGCXYJu8TEhJdKWQyULY4SKmiDihOUbVlFdfuRvR4bHnfi0NFM5PGN0tbXcmZ8v7Oaay4mRJsLFs78/lqPBSMMradvtB8gifeFkF9DZxd0m+F1/g7/jVY3q0UsOZH/Fpm/6tlgwS9o5/q2/KjXPn0bWQBjpYrzFvLM7bgnBnzN3gDPHbvj5/Ik6tXr0Kh4LBxmticlK9LF//YqYEPrVO2JxN+7EGBPsorJYUEGiHiN0XQCSWyodj6XKRQmhdjx/2WS1N4q/Gz2hWkc9KY8+u1shRH5cnDE8b2sPSIgLdm41A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=zJVaYc/D13PhQRzIivjp2371XbMmuv5Fvf++lL3GGSM=;
 b=KDO1tRqMCBZbj1EMXeBMWYFPJbMqjz1PWgM9Nv2/GLBLgUoThVZt8KNyXu9GhUubajS1vx3pwDNGK1k7FNV1K24YrwwCX1Z43xBsGrj4toRqZ/mH+fCmaVEOa+8lC8jJIuS1VDkygNcNCSD0Iuds1UAoQFEAHmw5Ma1IlMJBbKm9kxT7jS5Ap8cxOmXuhZws/blgxziSS6L2RuAP0kPG2P161cnru0IxDdaTVLkUfpBM3mXPaCWwEhKH/kyjDOh5aSjK2yZ2ftxlb8/2dN86/A1iywGxy5jP8UuZqATeF/3piY9Z0X2TuhLRD6a+1pfYjidZYLYMwaeRB1XXynSlOw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=zJVaYc/D13PhQRzIivjp2371XbMmuv5Fvf++lL3GGSM=;
 b=zlFAfJMpunJaPqBWB5T1vt3WgPTytp71CV5SckaYWOwdLNd5OXoCzvefCP0WmiyNqk09q+t05f2JE4baWsst9owykhDTYs9IiAnTxgVjorAJEBDOaNAdfyWwMQEl9uP4AgYoAw1UrmVOyg/J7ZplvvHS0I+LP7fQqIbIpQSr1AU=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CO1PR10MB4787.namprd10.prod.outlook.com (2603:10b6:303:94::17) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.29; Wed, 9 Mar 2022 19:38:52 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 19:38:52 +0000
Message-ID: <2ffdb3b4-6c87-29f3-2638-e8ed5fef15fd@oracle.com>
Date:   Wed, 9 Mar 2022 13:38:50 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [RFC PATCH 1/4] scsi: Allow drivers to set BLK_MQ_F_BLOCKING
Content-Language: en-US
To:     Ming Lei <ming.lei@redhat.com>
Cc:     bvanassche@acm.org, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20220308003957.123312-1-michael.christie@oracle.com>
 <20220308003957.123312-2-michael.christie@oracle.com> <Yif6jjlpPTEYpcAT@T590>
 <b1b7fa2c-ade3-987d-e240-fb6acb421b99@oracle.com> <YigGPK3zLAN87mSS@T590>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <YigGPK3zLAN87mSS@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR06CA0073.namprd06.prod.outlook.com (2603:10b6:3:4::11)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 0093e2f3-a7cb-440b-33f7-08da020470ad
X-MS-TrafficTypeDiagnostic: CO1PR10MB4787:EE_
X-Microsoft-Antispam-PRVS: <CO1PR10MB4787D69DA539D68D2376DDEEF10A9@CO1PR10MB4787.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: n7eltIRERXLwjnUClgN7nYmu3L0KNA4D/mwRiL810evP4vO+6FRhFVvZPwXbCVwWEfjxWRmzN0+i2pcQYuNhHQgIhHtigB+NHs2/ubZgWGas0QQcnxsiBjjWA3ANlcx7CIRt7ZuxXaxMRwJAv6jB8rtAiUTI7dIRJHnJS+GKSfZLBHsSl4WfyNXKk8YmJ3Ev3Hbx5wMLQKPkrXqZtm/3aaEa2TxGXNZxdMyfMfDjGpsftO4Ty3iQ5LyP3xu6SA/omLxelcrSUqNjlftDW5VJaMoyhF/HJcmLSCDIwtp2oTkFE++3o1pRCgFyi3FFf/Eie6RruMaOGDwq6qW1Ea6ekfqoOe7bSDHRc9iOZ7p5CZwMW1IEXxHEz0u8MSmySPFiT/4ygnBK+0XQWeUAPw2aWfecmiB1erVffuaUbPgDNbJP4nkijvGgVQ+R8oq38oVy7FCgIb+EpdSbVpwHwwuUyzV6M2QAbx8kG+dR2zjdfy1aq3Y2wt/nP/v+oXphi8Dwu+2DcqpKG6WtP8SiTeRopI5jt/Ri8r/RiM3Lfl18gQr2bG7LhQXd+A1fYkxp1l8CuncF35Tsf4tAVJvnknQvxuEfTBXlZ8NVoCQX33CR2nH+tB9HfL8GHGWvApPBLoqTOPIVOoESdocOWQ+erLXW/ehSDXh7y5KKUuZPlwwHzehUy5/QPoTqtHWSKiiRy5LNZWoQWOyqsoaw+RrhB1o30XbRB2ZPBYVhJuRkjR10ZwnZX9R49biySh8+1V/q/PVO
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(4326008)(6512007)(31686004)(2906002)(31696002)(6486002)(6506007)(86362001)(53546011)(508600001)(26005)(36756003)(6916009)(186003)(316002)(8936002)(2616005)(38100700002)(5660300002)(66476007)(8676002)(66556008)(66946007)(83380400001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dUNPZVUydk5GZ1UzRmZkU0d3aW9MZVptdWJSeEFCeVpoeExyYXE5cy94cFZT?=
 =?utf-8?B?OEdEWlhhR0lKcVlEV3VhYTZwVExSaHp1N29QWnVMeUM1enQyT2owdmhCalNP?=
 =?utf-8?B?TWhRdU5ERWZXNTVsQ3pIcGVtcXdJaFJmNytDOS9RcVVNcGdGMzVFRjJmeDc2?=
 =?utf-8?B?NGdwaDFkNHJ2WUltUjkyTU04ZTdMZzFMdHhvUkxCR0dKNVdKYTF5SXNqVlZV?=
 =?utf-8?B?VFZubmpVelFlZncwZ1lONzJ4QWhTSTFFNThDN0h0Z1Z6NDNsOU1wWE5qNXpo?=
 =?utf-8?B?WGQrQnB3WExLbjIweE5PblpqSUo2enIrSEN2WEhKejlLOVM1NmVLV2Rhc3Q1?=
 =?utf-8?B?cHA3VklKVnUzbFRIWHlyenQ4S3piaWJpUjJxOXNOZmRQY2hWZFBZaHA3bFhs?=
 =?utf-8?B?SzVHQ05ucE1uYnZtb3c2K2pzYjEwdWZwY2lvTG1tdklTSjhUYi9WK2ljVnht?=
 =?utf-8?B?MlN1M2tMSlZuTmRNcFZmK2tIV1ZxZWczUlF5eDdKT2k3RWVydmYyUkhpMEtE?=
 =?utf-8?B?Mm1XclZ1c3V4K0tVOWY2ZXI0TWZaU29DL1JlbW5kQzlQZHBxM1BZcVBoZnFk?=
 =?utf-8?B?ZTcrdjg0WVlnZzVVMThuQkY5SWh6a3NwRFZZcWh6UmNBdDZacktrdmNRckxJ?=
 =?utf-8?B?bGQvOFkzNEJHMjUzN3ZxVElGTEEydUR4Vm11UkNKSU5WMVZlOEZGajRDSGpF?=
 =?utf-8?B?ZitvNEtKTzlnN2R6ZHpqd1JPVnZCN2RocWRXV1NCNDFjdnFwck5xcXJkakR3?=
 =?utf-8?B?MDJnVXdNVWRndENKUmk1VmhsU2RPM0RBek5CVUwzN2ZXUnZYRW5XL1h2MEVt?=
 =?utf-8?B?ODRyR1ZteUlmVVhTQnNhK2kyT3Y3ZGpxTWdqRWxkOEVLbUFDQmlyS2RrUXg5?=
 =?utf-8?B?RzhneDFZTmZXK3J0NlI2eVZ4eTlQL042NFBXbEtlSW5rOEpWSjBIdEtqWXdi?=
 =?utf-8?B?ZngrcndNWlQ1STFFZGpQeHRKU2Q3RzEzUW40bDVjWXVxbzJ6MnFvREhONHJS?=
 =?utf-8?B?OW1ZWHozSEphS2pTTnhvSjFLT0JJcFhnYWNzVi9kYUFkMmJQbzQ3Yko4NGdu?=
 =?utf-8?B?OU1kL282a1lkbm1RSmdJeTZueGFEbW1EOXJ1aStNTUVxVGthRmkxTDdiWEo3?=
 =?utf-8?B?KzhEditHKzZ0ZzFXVXJZZFJzNSsrbGZwakxSTDE2ZzB2TGh2VUsrdDRZb0JB?=
 =?utf-8?B?ZnZSTEpVUmdmOFpRSHV6aVBBbkZxcEdOMWVGU28vcTN2ajByUE9aTVFKb2h0?=
 =?utf-8?B?Rzl2MFB5Kzh3aFRDU0NZMGxMV0dTWlNKSGJyT0hsZXdsN2pVK2duYnpFdS9j?=
 =?utf-8?B?M1MxcFo4d1RxTnNPbU9nUWI0T1p3UTIybFptVWtNRU9neUVVN1VxZ2FsUWpr?=
 =?utf-8?B?S3FsSFVweGw4WC9tOC8yT2pRZ2dJenpNRlF0ekVnQkxPNjJGMllmYTdwdFRM?=
 =?utf-8?B?SmxVcjB2N0xsUzg3ZkIvMEhMVjNKdFM3WWd3YkN0NjRpRFBOMUZ4dncwcjln?=
 =?utf-8?B?aVlSRlVGVW1rSi9wWk9yS0o4b0xmRlNVZEZMSHJ1V0xsc05aMXM1aXNnRzJ5?=
 =?utf-8?B?Tlc1OHZHSjhsY0J2SFF3RlNaaGpoUTl2ODRQU0htZkdFSDFnVVR1d0h2bGUx?=
 =?utf-8?B?L3FyQXJ1bXRzcGhkeGl6RUZrZ1haRThhK2k3Yzk5TEFVVENNNXVldmd6a2ww?=
 =?utf-8?B?eWcrQUw3VFhieno3bHlSUjVjSlpJOXZrL3g1bjNncThob1AyNS9vQW9DeERj?=
 =?utf-8?B?amR0Z1JhYURRblBNS0R5RFNuejEzVkZPMmlZWkJyY216MnVUZ2o5MWFVRTVJ?=
 =?utf-8?B?am8xckJ6R0xqRXV5WTBsRFVidG1MWHhKYXlYRGpnWFloS25kQmtUWDhDdUpV?=
 =?utf-8?B?ckwveFhLN3kxT2RvN1RxN3ptZjJPNklaUm9RZllFMjIrTmJwaUlQU05Bdklu?=
 =?utf-8?B?eWo1S3M1SmhaTVZzUnpYYmp5LzlKb1JHSW40a1ZvMlhBbmFVdHBIOEhlTnVR?=
 =?utf-8?B?VEN3aFpvb2RzQTdweHB4ZFlDNGdVaGloR21YZjB4S1ZmTzhoOXJENDE4N2RW?=
 =?utf-8?B?K2ZTS1lLWGQ3dEhsTXNEMmZWV0RHUjd1TWN0RTJ2dkZMTUY3L2dZcm95V3ZQ?=
 =?utf-8?B?NHdpMTNjT3lQbW5jd3pSNG8ycTQ0dzJRZXFHYXFESVBPRUY1VFlLK2EyOGxt?=
 =?utf-8?B?VEowd2Nyd1JVVlR3dnZQOVhaNVFURlE5MlNiNmN0WVZteTRlTHRsUVNmWXhn?=
 =?utf-8?B?K0hHckcwUmg1UXk5a2tDRk1JQmVRPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0093e2f3-a7cb-440b-33f7-08da020470ad
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 19:38:52.0964
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5XJXV5mo+mbCeufDMYxsCCCZZSaKX9NsILgiIv5aE6ITXF1YCFkLqPCxUn7Wl3z57SGfHO75mCpsYG2izdJIDpd74SNMLkRHQVqLMy9T5Mg=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4787
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10281 signatures=692062
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=751 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090104
X-Proofpoint-ORIG-GUID: aohMH-qqiSpfVJC2cfn7mO6yKRFbOV-n
X-Proofpoint-GUID: aohMH-qqiSpfVJC2cfn7mO6yKRFbOV-n
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/22 7:43 PM, Ming Lei wrote:
> On Tue, Mar 08, 2022 at 07:17:13PM -0600, Mike Christie wrote:
>> On 3/8/22 6:53 PM, Ming Lei wrote:
>>> On Mon, Mar 07, 2022 at 06:39:54PM -0600, Mike Christie wrote:
>>>> The software iscsi driver's queuecommand can block and taking the extra
>>>> hop from kblockd to its workqueue results in a performance hit. Allowing
>>>> it to set BLK_MQ_F_BLOCKING and transmit from that context directly
>>>> results in a 20-30% improvement in IOPs for workloads like:
>>>>
>>>> fio --filename=/dev/sdb --direct=1 --rw=randrw --bs=4k --ioengine=libaio
>>>> --iodepth=128  --numjobs=1
>>>>
>>>> and for all write workloads.
>>>
>>> This single patch shouldn't make any difference for iscsi, so please
>>> make it as last one if performance improvement data is provided
>>> in commit log.
>>
>> Ok.
>>
>>>
>>> Also is there performance effect for other worloads? such as multiple
>>> jobs? iscsi is SQ hardware, so if driver is blocked in ->queuecommand()
>>> via BLK_MQ_F_BLOCKING, other contexts can't submit IO to scsi ML any more.
>>
>> If you mean multiple jobs running on the same connection/session then
>> they are all serialized now. A connection can only do 1 cmd at a time.
>> There's a big mutex around it in the network layer, so multiple jobs
>> just suck no matter what.
> 
> I guess one block device can only bind to one isci connection, given the
> 1 cmd per connection limit, so looks multiple jobs is fine.
> 
>>
>> If you mean multiple jobs from different connection/sessions, then the
>> iscsi code with this patchset blocks only because the network layer
>> takes a mutex for a short time. We configure it to not block for things
>> like socket space, memory allocations, we do zero copy IO normally, etc
>> so it's quick.
>>
>> We also can do up to workqueues max_active limit worth of calls so
>> other things can normally send IO. We haven't found a need to increase
>> it yet.
>  
> I meant that hctx->run_work is required for blk-mq to dispatch IO, iscsi is
> SQ HBA, so there is only single work_struct. If one context is blocked in
> ->queue_rq or ->queuecommand, other contexts can't submit IO to driver any
> more.

I see what you mean. With the current code, we have the same issue already.
We have 1 work_struct per connection/session and one connection/session
per scsi_host.

Basically, the iscsi protocol and socket layer only allow us to send the 1
command per connection at a time (you can't have 2 threads doing
sendmsg/sendpage). It's why nvme/tcp is a lot better. It makes N tcp
connections and each hwctx can use a different one.
