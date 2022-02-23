Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C54A4C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Feb 2022 15:52:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242367AbiBWPwm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Feb 2022 10:52:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236329AbiBWPwl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Feb 2022 10:52:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AD17BF977;
        Wed, 23 Feb 2022 07:52:11 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 21NFi69x028053;
        Wed, 23 Feb 2022 15:52:04 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ngVzawgdnzXOkFAoYYxuKqhKUGxg5Yp2iGML6I1hkCY=;
 b=PD6rGBAJPWHZvuIpwlZZaD9ykGsLwAi/MVC4BiTFeQExGQaMf2onUfi4KYZ1JeikYn3B
 zHsFfKI4NFLn7kMcqMlcc00EkOQKJVafWvxrORW9/C8eSMTMfRSfRNDJIY+e9V83e6pe
 byYpTz7M1VB1RYvCRVubXNyksO9UWmDOjxGgJRxkoeM2+YslKFlHJcvEKd3r/78qRa6h
 Fcxg9Bz58cnu0bdVzW0gz0OSf1GF7LloMZUuaKw9F2LL+ZnnJ1AlREFhw2gdZ5N9MPyf
 mAbMovpvGXHHKzRL16bDqri8NwHhZzQsAkL+q2cokbHWVoo5Rc3INY+JeoiC5xjmUHOZ PA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ect3cmh1c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:52:03 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 21NFouPw103586;
        Wed, 23 Feb 2022 15:52:02 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2173.outbound.protection.outlook.com [104.47.58.173])
        by aserp3030.oracle.com with ESMTP id 3eapkht9mx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 23 Feb 2022 15:52:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NwPddz5JAxXNBcv02neCvK8K3Z0atbxdvLKpS1NLi15YHo8CIsGi5uNBlK8JH3MDpNItF0TaGTaOef+d6ToKCP3dwhZuz8Wi+FvJTPhovDDYGGSEZ5uhAd9C1Fiv+1reK6gaTZkLd3TYYFCF2TLdpFLsH5bMKYoaJKYBmqOHHHtA5Zve1xhXdg8PRQU2ryaawSTMKGhl+YkPpt/NVI6vHA6qYFYq6+BxcgU2H3BIzzz7fe5lW7PCNVp/KXOL0qHWMTN0CYlXpblbC7EppT9GHgy2ZzJz5xtRGg7YZz5SX0JQan/qRgKjvrecYXAenNb9ZQ81P1/6YqONZ+LDrm4X8Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ngVzawgdnzXOkFAoYYxuKqhKUGxg5Yp2iGML6I1hkCY=;
 b=YnrJs5n36Yb0bHh71l6RgpjwkTMnNd75ba+yAMjmjChQ7w3A4jKkpcYezimiLLcVGH7TZuZw25k0DMegeLCfo1CZXrfIkqfKyydTqBC7ypaw6q6VaWghjMQunSFGmFLmHLRjn4Ib651LoDM6B4ibpi8cL6QJS2keZ/BIEiZ1DRlnLUBx+v4LEfIFLkEkaaYGomqH/3HQwvk2VvRWbRAjuqzQ6MafEXoWD0AaSm3BtytcZhc3o1N9PDqAfQUqJlE+hK4c9Nb7KVNjO9nlHN0H4oOgqg+qwJKlptga+VAaRxIHJH17iTMEj43MWOyScNRVQLL4JxaPKUU9YYMB+6/PBA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngVzawgdnzXOkFAoYYxuKqhKUGxg5Yp2iGML6I1hkCY=;
 b=laXuhcSkQrHHohlVdAUKt/9MTOmrfMBZ0QyPcCcQI9DmPsGTugWLB3bkGNNGEArCuAgEJEobTcq8G/8oMORAc5xq9E8K8OC+6wa3NbTDZkcIAVE0uf32rz7grF7U8K2AVqYdBr1w/Bv+tTpQworZ4kQZZ/NAPwjVYShVtJVfQcI=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 DM6PR10MB3706.namprd10.prod.outlook.com (2603:10b6:5:178::19) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4995.22; Wed, 23 Feb 2022 15:52:00 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.4995.027; Wed, 23 Feb 2022
 15:52:00 +0000
Message-ID: <98fd0945-af6b-1e90-9dc4-f64c6fa1ba68@oracle.com>
Date:   Wed, 23 Feb 2022 09:51:57 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH v2] target: add iscsi/cpus_allowed_list in configfs
Content-Language: en-US
To:     Zou Mingzhe <mingzhe.zou@easystack.cn>
Cc:     zoumingzhe@qq.com, target-devel@vger.kernel.org,
        linux-scsi@vger.kernel.org, Maurizio Lombardi <mlombard@redhat.com>
References: <20220125083821.18225-1-mingzhe.zou@easystack.cn>
 <20220217074511.9696-1-mingzhe.zou@easystack.cn>
 <b097fd3c-35fa-2e76-7f6e-14ce13be47ef@easystack.cn>
From:   michael.christie@oracle.com
In-Reply-To: <b097fd3c-35fa-2e76-7f6e-14ce13be47ef@easystack.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR14CA0052.namprd14.prod.outlook.com
 (2603:10b6:5:18f::29) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 9be17d85-7365-4821-b44b-08d9f6e46d6a
X-MS-TrafficTypeDiagnostic: DM6PR10MB3706:EE_
X-Microsoft-Antispam-PRVS: <DM6PR10MB37060C79E575FDF838691CE1F13C9@DM6PR10MB3706.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: CpCgjgCfRhVvRHnJJa1Chlz0tq4HiMhCkLvDH2bLwznYqm8mxkiSXPshSO0r+3Z6kY/t4VfFdVZ4JNWuvKh9N25qH9h5VApU8CYFyEhf6vLQBga2ClD92VSUQwsfYNq3bh7VJXJk9EnAhAX3fqMtt6oDSdtD8d73MCh7qbxjn1QUO4TMNTyQibW2PpXqIOmvErFDaPl1TEDYbSQ5vuS8PjzUF/MlroL6GXrqwx6GdI0DefS8onyuJhAWIzJZ4R+3AdDz03ukAB+sF5mFI8hBRJsbYuaBnhMQnL2GjMdWjo5LYn1WZHta/5xBdD/mDyX5N44lNKPUuLkrRRRPlewhtniVG1leASDJS5vLUyBPH3nlCShDScCrW9DrSoGFHWwYfMJxo9njkGbKenqOUvH2+AguY4LeJtmj4ciY7elJ7cd+sDlEYvaGYx4eFUJ1HS+O3FA8a3guFmeu9ly+tTtWohdh3ocKmUkPceBVbxdjB4h17oj1qf5maN9hIOSG2ah6Ql6GbxjFtw9VafexkwPMSIDkTUBaeBVbeMfkpbhGplK0wUGdT8V/2XOdP8KkTj2l1WxgMaQxRpXq9Zluue2BEq+Q9SIP8jbXB4Q6wGK3QGRCvHAtmWwPISQPjvA2tfzUFEhNbl1cd77MG2mjhgDtuc/4DydnN4NBbUbrvuDZ8o1AmtPG0gTUeSj3H4lwi5CXsbvjowd0vCV8IgCHszt+tA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(84040400005)(4326008)(38100700002)(83380400001)(36756003)(5660300002)(31686004)(2906002)(8936002)(26005)(53546011)(6486002)(6666004)(186003)(66556008)(6512007)(66946007)(9686003)(66476007)(8676002)(316002)(6916009)(31696002)(2616005)(6506007)(86362001)(508600001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RXdWMWRwSFFJcnc4QXprVS81Y0NDejZqclBkOW5ST0NkaVZqR1BOR3FJK3FI?=
 =?utf-8?B?RlMzdEFGcGpCUWZwZTFvK3dielZtTTE1NFRrRk9WdldSR1RqYTBUVjEzOEpK?=
 =?utf-8?B?Nkc1cTc2Y3V6UjA1NjRicmRORkMzbHVEQ0hOYlp6dzg2eGI5UEpaZHJSb3hV?=
 =?utf-8?B?QXRhRTRBTlNxL2VUN2h5aXhTbzRLRDNIVUVLNGFuSVB1RURLVm9YTkQxSytD?=
 =?utf-8?B?N3Q5NEpjN2lPOG5kcHN3YmZEcHpZeE51NERqTFo5K3hIYnZvWEZhVDFDZUdz?=
 =?utf-8?B?czk0VkFXWDhrTnZDSk0yaUF0aEV3VjRzcFJxSVZQOHJJY01Vek1tYmkzSVdQ?=
 =?utf-8?B?eVNIYzRuUzhNaFdOZ2dCTGFDaFdWTFRNcEppd3Y5VFBlL3ZrV00rMis4Z3Ni?=
 =?utf-8?B?SmNrT3I1eWM4aDEyZE91c1I2c1EzRjRDRmhvVGx3ZStBRm50TnAwejd5aEZJ?=
 =?utf-8?B?ditkenFZV0FVSDI2MFdXN3RlQTN2T0x3b2lsczlBcEFBanZkZ0xreU54L1Y5?=
 =?utf-8?B?RFZHdUlBaFhTaExmOElRK2xMQ2lwc2s2dUsrajBsUHFzS3UvaDcyNTJtRXBi?=
 =?utf-8?B?Q25PWHYyVUl0SVNGc2JtaElmWTVuM01RemJIYS82akV5Q043N2JDQjZ5c2pJ?=
 =?utf-8?B?NXk0RkdDWmtNMjhVeTN5WFcvMDdERjZ2MzRKVFR5ZnFRbDAxTTh1L05SUndZ?=
 =?utf-8?B?K3AvRTUzZTdoc1dERTRzS1k5cVgwVW5TK2pmK053Y0hPYVJTbDIreEJLdGdH?=
 =?utf-8?B?TExBbDZtVlZnWStZeXpNaFFlYy9OcENFVzdUOU8yWW5uQzhpemw3WGFVNTE0?=
 =?utf-8?B?RE9ReXFXclIxYVV6ckJDMzBQNm9GVGFIYTVoeHFOUjJDWjJLS2VYdFZRSlpV?=
 =?utf-8?B?MnJzM3VRbTFtNVhLWVFTcktCQi9oVmNGNVlTa1kyWUZPVEd6dlpIb1J2Tmt3?=
 =?utf-8?B?Y2dmbFc2bHNzQlpPZXRGUmxSd2ptNUxNTXJHV0pwc20xbnNYNVZidzk5NnRG?=
 =?utf-8?B?NlZSbFpUeDE1T05oKzEwWVRSbklCTUJTUGh3WGcwZXhWYkV6QmV2dWo0amp2?=
 =?utf-8?B?Ulk3TEo3Syt5bGpCNWdUc29Bd3RwbE9uVGFrS2tFTHlnbzl6bE9ZWHZpMTht?=
 =?utf-8?B?QXc0SHlnWHl6L1dRdEFUUGhQMmRSWi9GL2NGWittdGlJV2VjdDBtT01EVVZE?=
 =?utf-8?B?R2tES2ZtaFFkRVBQOTg4MXcvaVJKRmZFaXhpWlZzV0ZCU3pzUkJ1MVlFVzlD?=
 =?utf-8?B?TmcvRm1Ra085UmZCelV3cWlzR2tHeTFZL2FUSlJ6TTJ1QkhISVVkb01zRFN5?=
 =?utf-8?B?TXpVQUJ6Zi9kdE5qRW5vZjBhR1FwMWpMYXFGc3hyVUo3MmRMOHZoclZjaEtv?=
 =?utf-8?B?b1liYkpPR2tmL21SQlRobjV1OElVK28vYjR4Z1ZGUUxhOHBFSkZjMDlpcGU3?=
 =?utf-8?B?N0x5YVo3NW1GMCt6VjZHMU5nYXBOdUZNU2pUSXJuSXVVK3dBQmx0TlpuQkt6?=
 =?utf-8?B?WDJuTTZuQ2lBUk9DdkhGL2NBM2RUOElyRUFlVlpkQUREc1RTbnQ3RitaaDJi?=
 =?utf-8?B?Nm5UZE5FUklzdFZlVkJ1dVNDcEp0Q1FVUVRJeW55TE5aUHVITEdHSlNLZ29G?=
 =?utf-8?B?SWFsaFNJMlFRZDl2TytqblZPM29uWi81d1dHa0dpUGFFeGRxT2liUEFXakpa?=
 =?utf-8?B?bkhvakk4UVhua2ZNUVpmWkhmY2IrMXNoS0xqM3FXTVltdXJYTkY5V0FxbmVB?=
 =?utf-8?B?QmVGTldJanZLUXpnR0NYSkdHSUtRWjk2Q3JaM21oaDdwNVJOclFyLzNRREdm?=
 =?utf-8?B?WHNJZGpSMzkraExIRmJPaVpZb1hsdjJvZDdBbkhPSjRPdmRHbEVheTNpeWpO?=
 =?utf-8?B?UFpiSUlvK2ZWenJMZVNraXdaYnp4d05Vdmk0ZlBnZ0xDandMQ2w1ODYzREdI?=
 =?utf-8?B?c3Q5TTZ1S0tjeXVSVUtWa1B6T1FvMi9mY3Q3NDZJemZBekFjYkliYTg1VStk?=
 =?utf-8?B?aW1sdFIxekJOWElGMmloTURHOHJPRW1WVC8yT2lzWGZET01vN1ZybE5qNUxp?=
 =?utf-8?B?Kzl5eFlhWWxzRmN0VTdxUExOcitGcVQyMDFZejJ4SElLU3d4R3RoejNrWnBv?=
 =?utf-8?B?VWhXeFhxOVdGdVl3d3ZLVDY1R0RCV00ySS8yYnp3VFlLckFhWis0bS94Z2Jx?=
 =?utf-8?B?THRIbFhjMStBSTF5WldDVk1XNUR5Q3dMM2M1TXVuZlQzSWZmRnF0TGRqcW1I?=
 =?utf-8?B?SHR5cnRDZVVENWV1Z2RrSW8rc2FBPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9be17d85-7365-4821-b44b-08d9f6e46d6a
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2022 15:52:00.0665
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OUb+2iXP7TzDX/Shi4emxkfnggUyfe/mE+nJgEF2WSnrxB9yszxlXNlF9LeLPmoZ8jLPcaDxeCC0ijrNBqyIT1m1NKdYRLs23w3W9r4ZpVc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM6PR10MB3706
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10267 signatures=681306
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 mlxscore=0
 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2201110000
 definitions=main-2202230089
X-Proofpoint-ORIG-GUID: Qz3kX7x_QaNZxpu-nDC7Xdw8CKOIgIHM
X-Proofpoint-GUID: Qz3kX7x_QaNZxpu-nDC7Xdw8CKOIgIHM
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/23/22 12:24 AM, Zou Mingzhe wrote:
> Hi, christie
> 
> Can you help me review v2
> 

I'm working on it.

It looks like is a window where we can have the recv and xmit thread
on different CPUs. I thought there might be some iscsi target code that
relied on them being on the same CPU so I'm just trying to review the
iscsi target code paths related to that to make sure.


> Thanks
> 
> 在 2022/2/17 15:45, mingzhe.zou@easystack.cn 写道:
>> From: Mingzhe Zou <mingzhe.zou@easystack.cn>
>>
>> The RX/TX threads for iSCSI connection can be scheduled to
>> any online cpus, and will not be rescheduled.
>>
>> If bind other heavy load threads with iSCSI connection
>> RX/TX thread to the same cpu, the iSCSI performance will
>> be worse.
>>
>> This patch add iscsi/cpus_allowed_list in configfs. The
>> available cpus set of iSCSI connection RX/TX threads is
>> allowed_cpus & online_cpus. If it is modified, all RX/TX
>> threads will be rescheduled.
>>
>> Signed-off-by: Mingzhe Zou <mingzhe.zou@easystack.cn>
>> ---
>>   drivers/target/iscsi/iscsi_target.c          | 66 +++++++++++++++++++-
>>   drivers/target/iscsi/iscsi_target_configfs.c | 32 ++++++++++
>>   drivers/target/iscsi/iscsi_target_login.c    |  8 +++
>>   include/target/iscsi/iscsi_target_core.h     | 31 ++-------
>>   4 files changed, 109 insertions(+), 28 deletions(-)
>>
>> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/iscsi_target.c
>> index 2c54c5d8412d..82f54b59996d 100644
>> --- a/drivers/target/iscsi/iscsi_target.c
>> +++ b/drivers/target/iscsi/iscsi_target.c
>> @@ -702,13 +702,19 @@ static int __init iscsi_target_init_module(void)
>>       if (!iscsit_global->ts_bitmap)
>>           goto configfs_out;
>>   +    if (!zalloc_cpumask_var(&iscsit_global->allowed_cpumask, GFP_KERNEL)) {
>> +        pr_err("Unable to allocate iscsit_global->allowed_cpumask\n");
>> +        goto bitmap_out;
>> +    }
>> +    cpumask_setall(iscsit_global->allowed_cpumask);
>> +
>>       lio_qr_cache = kmem_cache_create("lio_qr_cache",
>>               sizeof(struct iscsi_queue_req),
>>               __alignof__(struct iscsi_queue_req), 0, NULL);
>>       if (!lio_qr_cache) {
>>           pr_err("Unable to kmem_cache_create() for"
>>                   " lio_qr_cache\n");
>> -        goto bitmap_out;
>> +        goto cpumask_out;
>>       }
>>         lio_dr_cache = kmem_cache_create("lio_dr_cache",
>> @@ -753,6 +759,8 @@ static int __init iscsi_target_init_module(void)
>>       kmem_cache_destroy(lio_dr_cache);
>>   qr_out:
>>       kmem_cache_destroy(lio_qr_cache);
>> +cpumask_out:
>> +    free_cpumask_var(iscsit_global->allowed_cpumask);
>>   bitmap_out:
>>       vfree(iscsit_global->ts_bitmap);
>>   configfs_out:
>> @@ -782,6 +790,7 @@ static void __exit iscsi_target_cleanup_module(void)
>>         target_unregister_template(&iscsi_ops);
>>   +    free_cpumask_var(iscsit_global->allowed_cpumask);
>>       vfree(iscsit_global->ts_bitmap);
>>       kfree(iscsit_global);
>>   }
>> @@ -3587,6 +3596,11 @@ static int iscsit_send_reject(
>>   void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>   {
>>       int ord, cpu;
>> +    cpumask_t conn_allowed_cpumask;
>> +
>> +    cpumask_and(&conn_allowed_cpumask, iscsit_global->allowed_cpumask,
>> +            cpu_online_mask);
>> +
>>       /*
>>        * bitmap_id is assigned from iscsit_global->ts_bitmap from
>>        * within iscsit_start_kthreads()
>> @@ -3595,8 +3609,9 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>        * iSCSI connection's RX/TX threads will be scheduled to
>>        * execute upon.
>>        */
>> -    ord = conn->bitmap_id % cpumask_weight(cpu_online_mask);
>> -    for_each_online_cpu(cpu) {
>> +    cpumask_clear(conn->conn_cpumask);
>> +    ord = conn->bitmap_id % cpumask_weight(&conn_allowed_cpumask);
>> +    for_each_cpu(cpu, &conn_allowed_cpumask) {
>>           if (ord-- == 0) {
>>               cpumask_set_cpu(cpu, conn->conn_cpumask);
>>               return;
>> @@ -3609,6 +3624,51 @@ void iscsit_thread_get_cpumask(struct iscsi_conn *conn)
>>       cpumask_setall(conn->conn_cpumask);
>>   }
>>   +static void iscsit_thread_reschedule(struct iscsi_conn *conn)
>> +{
>> +    /*
>> +     * If iscsit_global->allowed_cpumask modified, reschedule iSCSI
>> +     * connection's RX/TX threads update conn->allowed_cpumask.
>> +     */
>> +    if (!cpumask_equal(iscsit_global->allowed_cpumask,
>> +               conn->allowed_cpumask)) {
>> +        iscsit_thread_get_cpumask(conn);
>> +        conn->conn_tx_reset_cpumask = 1;
>> +        conn->conn_rx_reset_cpumask = 1;
>> +        cpumask_copy(conn->allowed_cpumask,
>> +                 iscsit_global->allowed_cpumask);
>> +    }
>> +}
>> +
>> +void iscsit_thread_check_cpumask(
>> +    struct iscsi_conn *conn,
>> +    struct task_struct *p,
>> +    int mode)
>> +{
>> +    iscsit_thread_reschedule(conn);
>> +
>> +    /*
>> +     * mode == 1 signals iscsi_target_tx_thread() usage.
>> +     * mode == 0 signals iscsi_target_rx_thread() usage.
>> +     */
>> +    if (mode == 1) {
>> +        if (!conn->conn_tx_reset_cpumask)
>> +            return;
>> +        conn->conn_tx_reset_cpumask = 0;
>> +    } else {
>> +        if (!conn->conn_rx_reset_cpumask)
>> +            return;
>> +        conn->conn_rx_reset_cpumask = 0;
>> +    }
>> +    /*
>> +     * Update the CPU mask for this single kthread so that
>> +     * both TX and RX kthreads are scheduled to run on the
>> +     * same CPU.
>> +     */
>> +    set_cpus_allowed_ptr(p, conn->conn_cpumask);
>> +}
>> +EXPORT_SYMBOL(iscsit_thread_check_cpumask);
>> +
>>   int
>>   iscsit_immediate_queue(struct iscsi_conn *conn, struct iscsi_cmd *cmd, int state)
>>   {
>> diff --git a/drivers/target/iscsi/iscsi_target_configfs.c b/drivers/target/iscsi/iscsi_target_configfs.c
>> index 2a9de24a8bbe..0cedcfe207b5 100644
>> --- a/drivers/target/iscsi/iscsi_target_configfs.c
>> +++ b/drivers/target/iscsi/iscsi_target_configfs.c
>> @@ -1127,8 +1127,40 @@ static ssize_t lio_target_wwn_lio_version_show(struct config_item *item,
>>     CONFIGFS_ATTR_RO(lio_target_wwn_, lio_version);
>>   +static ssize_t lio_target_wwn_cpus_allowed_list_show(
>> +        struct config_item *item, char *page)
>> +{
>> +    return sprintf(page, "%*pbl\n",
>> +               cpumask_pr_args(iscsit_global->allowed_cpumask));
>> +}
>> +
>> +static ssize_t lio_target_wwn_cpus_allowed_list_store(
>> +        struct config_item *item, const char *page, size_t count)
>> +{
>> +    int ret;
>> +    char *orig;
>> +    cpumask_t new_allowed_cpumask;
>> +
>> +    orig = kstrdup(page, GFP_KERNEL);
>> +    if (!orig)
>> +        return -ENOMEM;
>> +
>> +    cpumask_clear(&new_allowed_cpumask);
>> +    ret = cpulist_parse(orig, &new_allowed_cpumask);
>> +
>> +    kfree(orig);
>> +    if (ret != 0)
>> +        return ret;
>> +
>> +    cpumask_copy(iscsit_global->allowed_cpumask, &new_allowed_cpumask);
>> +    return count;
>> +}
>> +
>> +CONFIGFS_ATTR(lio_target_wwn_, cpus_allowed_list);
>> +
>>   static struct configfs_attribute *lio_target_wwn_attrs[] = {
>>       &lio_target_wwn_attr_lio_version,
>> +    &lio_target_wwn_attr_cpus_allowed_list,
>>       NULL,
>>   };
>>   diff --git a/drivers/target/iscsi/iscsi_target_login.c b/drivers/target/iscsi/iscsi_target_login.c
>> index 1a9c50401bdb..9c01fb864585 100644
>> --- a/drivers/target/iscsi/iscsi_target_login.c
>> +++ b/drivers/target/iscsi/iscsi_target_login.c
>> @@ -1129,8 +1129,15 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>>           goto free_conn_ops;
>>       }
>>   +    if (!zalloc_cpumask_var(&conn->allowed_cpumask, GFP_KERNEL)) {
>> +        pr_err("Unable to allocate conn->allowed_cpumask\n");
>> +        goto free_conn_cpumask;
>> +    }
>> +
>>       return conn;
>>   +free_conn_cpumask:
>> +    free_cpumask_var(conn->conn_cpumask);
>>   free_conn_ops:
>>       kfree(conn->conn_ops);
>>   put_transport:
>> @@ -1142,6 +1149,7 @@ static struct iscsi_conn *iscsit_alloc_conn(struct iscsi_np *np)
>>     void iscsit_free_conn(struct iscsi_conn *conn)
>>   {
>> +    free_cpumask_var(conn->allowed_cpumask);
>>       free_cpumask_var(conn->conn_cpumask);
>>       kfree(conn->conn_ops);
>>       iscsit_put_transport(conn->conn_transport);
>> diff --git a/include/target/iscsi/iscsi_target_core.h b/include/target/iscsi/iscsi_target_core.h
>> index 1eccb2ac7d02..adc87de0362b 100644
>> --- a/include/target/iscsi/iscsi_target_core.h
>> +++ b/include/target/iscsi/iscsi_target_core.h
>> @@ -580,6 +580,7 @@ struct iscsi_conn {
>>       struct ahash_request    *conn_tx_hash;
>>       /* Used for scheduling TX and RX connection kthreads */
>>       cpumask_var_t        conn_cpumask;
>> +    cpumask_var_t        allowed_cpumask;
>>       unsigned int        conn_rx_reset_cpumask:1;
>>       unsigned int        conn_tx_reset_cpumask:1;
>>       /* list_head of struct iscsi_cmd for this connection */
>> @@ -878,6 +879,7 @@ struct iscsit_global {
>>       /* Thread Set bitmap pointer */
>>       unsigned long        *ts_bitmap;
>>       spinlock_t        ts_bitmap_lock;
>> +    cpumask_var_t        allowed_cpumask;
>>       /* Used for iSCSI discovery session authentication */
>>       struct iscsi_node_acl    discovery_acl;
>>       struct iscsi_portal_group    *discovery_tpg;
>> @@ -898,29 +900,8 @@ static inline u32 session_get_next_ttt(struct iscsi_session *session)
>>     extern struct iscsi_cmd *iscsit_find_cmd_from_itt(struct iscsi_conn *, itt_t);
>>   -static inline void iscsit_thread_check_cpumask(
>> -    struct iscsi_conn *conn,
>> -    struct task_struct *p,
>> -    int mode)
>> -{
>> -    /*
>> -     * mode == 1 signals iscsi_target_tx_thread() usage.
>> -     * mode == 0 signals iscsi_target_rx_thread() usage.
>> -     */
>> -    if (mode == 1) {
>> -        if (!conn->conn_tx_reset_cpumask)
>> -            return;
>> -        conn->conn_tx_reset_cpumask = 0;
>> -    } else {
>> -        if (!conn->conn_rx_reset_cpumask)
>> -            return;
>> -        conn->conn_rx_reset_cpumask = 0;
>> -    }
>> -    /*
>> -     * Update the CPU mask for this single kthread so that
>> -     * both TX and RX kthreads are scheduled to run on the
>> -     * same CPU.
>> -     */
>> -    set_cpus_allowed_ptr(p, conn->conn_cpumask);
>> -}
>> +extern void iscsit_thread_check_cpumask(struct iscsi_conn *conn,
>> +                    struct task_struct *p,
>> +                    int mode);
>> +
>>   #endif /* ISCSI_TARGET_CORE_H */

