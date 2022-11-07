Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC706C43217
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 12:24:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232176AbiKGMYR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 07:24:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232163AbiKGMYL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 07:24:11 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CFF531B1C9
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 04:24:08 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7AmvFc023182;
        Mon, 7 Nov 2022 12:23:59 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=nS6aoZmsA2i5gfZCojHQ3fogf8AJGJCP2+671BeUdyE=;
 b=I8jhurscSWgAFFwUmNMQKay0hzOqLvBHjvz09Ex55jljZvn4CtdiBiXzIavceScrCEu3
 pcqZ7OCs5qJ4xgiBN7MYW+Tmh9rnZqa+P76xPIIp7nnQ1misAz9wIZiL7k0FNE1+a8D1
 cVU1vHXVGxe/946HtnGvuUAquncs6ejA97cuLoiHs3jzF17eLsFsfsSvqFQIrt5JQaao
 6pfdrb+x+8r8o7IfIwWbmkB0TDy8uiNo8ifHtuVFVGFaECyCrLm0ccIZV5YDsQazsQfT
 1LZpAc4bnVEBbhL4EkDdLbAPvpv2krHe8KVZmKcQFqhq0RVOFsIssvSDb3bNPqSeuiYY jQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkw3k19-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 12:23:59 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A7AekBU007995;
        Mon, 7 Nov 2022 12:23:58 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2105.outbound.protection.outlook.com [104.47.70.105])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctj7u2h-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 12:23:58 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UaR3H2A5H+fsVpalvVZQWVJeyUHh+UMy9hMUw1BasglJUwh043GTixBv/hO/VbiqXlZAayOFRK2xjhTvmW6ONT+g4BE8gXU4aov+utEL702WrbGo4MYBEkOPZSJF6m/uo1cFtQe7P+VD2nNrRqgAq72EsuhTLLu36l7wBLYeGNSsSJZ+Z2NPjCFyEm/8htcuhS4quBjRT5Vty76z7uI9Tutj59OMvjndVECRIpAjzR38rz1NepJzOc7tgEP0Qfj7RMLs/TIP2ZAHWjMl5YGBFMLn4BH50Gex7JXH0GLlAe6GfI6MZXpJO/hlMPB724O2XTU+QxdJE85Q0YICsa+Wbg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=nS6aoZmsA2i5gfZCojHQ3fogf8AJGJCP2+671BeUdyE=;
 b=oCLKaGDEjWbPyPJYu/dZCyzcVLMAuPA4kNV9fYWnE+V5cubM+8sF+rAKwa/8o1YSsB2ytVQVkj80TbT9MQNhgzz9ytz+IbidtpA4s0bICxhSkqo5pLRxDzT6pxtcZFFwbtYpuofjb/yFJGchhTVGXIeh74vK8Jat8M3eRVHL0v80v3dtuo2+DoDeaEuR4pTqqyJjUc0KeN79IX1ezer1kAQ8STvgm/m8KxnyLT37pSxXnzS0ui+9bqRJvZo1TO4jPPjvYplTsgfY1g0omGd1ntsiFhWPTF7FCLevESZpJaQ9D2eoRzmpwIxe40BeO9pjftMD2AL3rXJOHsA9y+fuLQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nS6aoZmsA2i5gfZCojHQ3fogf8AJGJCP2+671BeUdyE=;
 b=EW01xTnTPLz3xZuj90TwmZAwnb9uVs4MD7jrkKXioYkRJItXw4PWEIcGlsUGlKeW9RxIAQGpT5jWoefcMoqClv3QKjSX7QFVvPo+j5E5ZFxmlANzYfe0sIV4lRgsWNif0D/RDEJcSkqGCwgkWFm+eW/Ys1DhWdp5A5PXzTR3Njc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ2PR10MB7059.namprd10.prod.outlook.com (2603:10b6:a03:4d2::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.26; Mon, 7 Nov
 2022 12:23:55 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 12:23:55 +0000
Message-ID: <b09f6c0c-72ab-de9c-d127-2b95816db379@oracle.com>
Date:   Mon, 7 Nov 2022 12:23:52 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [External] : [PATCH v2] scsi: scsi_transport_sas: fix error
 handling in sas_phy_add()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20221107115401.3399891-1-yangyingliang@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221107115401.3399891-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0490.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:1ab::9) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ2PR10MB7059:EE_
X-MS-Office365-Filtering-Correlation-Id: 4bf15109-90e3-4960-fa66-08dac0baf06e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: TgW8urAHkHaJ+O4MYG3duE6E6fsgj10wq0N38O1X8f5WN/pFtkDqQ7PwbXuj3btl+jwPSeg2qL4Tdq1HhSHSrdkTYkkP78JfQl9ZTA+RaDtRFBQXoU6cDVJ8nkQzA0pYWLXAFV+7TVYvJtpq4nJeV00ou5mHmmLCHRIHgeMYL9Pk7OPAoxPjYUT7KNtwkGjk8m+PnUGjiZTK+eX0ncaz0fqVYC8aWIIjPV00jc8rw5oVWoPi/J4+XXiV3OcUHg8Jeo9q2zLX68zC65gN9QIWjLdx+mDhNj/D07+hLD17AMHlmBj/H/ErOdYGCrW5z5R7aRuuAv5h2E5okJqYNkqDCt1NqgbBOZO01FuwlCsIK9ONlGljkbsZP4G34Wpc8naBdvbICPLR36NjXFmzRVXnYg8R6Ced13bRgwS4RYt5swoS/dVUfaGSlSilbjpKsk2YK4QLVLHiTP4aREo9GNXo9z8jAUSQr0NXA52xXFEXXaNAVBAIVNiHJpdkkHRUq+SeKm9TKEAFC4DCyrXUyqqkpQfDH0mIASIvz/WFjXfFZ1XeSprOjpdAVYlPtCzUcQEg0ffMgLExfju4qt5huLOkEgLS5eKLx6pROcpSg/cdoxPQBl5suu6DdaHvKmvlGYv7ROAuc8G6CogpFruZb7TS6Wf/llfvzcdOCugBtyTlyJ6H9EEPI69FkL+FPGjPYZOOkt7tlkfx4hU8TzFAPYVN5odiHww6fPbXREt1DNFPviT/INzZr8iPKXIWHoEKaBOCLf8g1VxaVApIzxMNPXt6lyC/Wn/8aHj3I2vPvBOGXyU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(376002)(396003)(39860400002)(366004)(451199015)(36756003)(31686004)(31696002)(86362001)(2906002)(107886003)(2616005)(186003)(6512007)(53546011)(26005)(83380400001)(36916002)(6666004)(6506007)(8676002)(66556008)(66946007)(66476007)(478600001)(8936002)(4326008)(316002)(6486002)(38100700002)(41300700001)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?V1lZai8rb05jU2laWUtYNkk2b00wTG5KRjduYlU5QWNFTkR1VmUyNFA1Z3dL?=
 =?utf-8?B?MWFtOUtja01OQ20xaU5Fa2o4Nmt5TFNERUVLK2IyS0F2S3RCRFdyd2E1WWVN?=
 =?utf-8?B?S1RXbWRFb05TOG40VXhwWE8rMFJWRlhkNm5KYTc1TVh6aWw2VHo4MnJKWW4r?=
 =?utf-8?B?YndWcjJVVU9Wd3daYjVPcHd5WTZHbGlwamlWdVd1QjBKNzNiem5PVVJmc1h4?=
 =?utf-8?B?Ynp3bldpbzV6ajZJWnhIalc4dFRoYXlBbHJkcmFVbFdiS210WCtWZy91azVi?=
 =?utf-8?B?Y1J6NVRsSHdEd0s0VndIRlZ4NnY4SjdHUE9aM2kyT3dVNi85NUdwUE1BQkRG?=
 =?utf-8?B?M1hPU1RGYUkzOUVXWStXT3NiN3Mzbk5UTmlubjBzV0pvdHFoYWhsQVdyRG5q?=
 =?utf-8?B?Slk3bk13bG1adlBMS3h2ZGpTOGNSWmlXUVdTMFA3UEdsZldIbWIyUFVwWTNO?=
 =?utf-8?B?SFhZZ1Q1Z05yblFEWFpXbzZkY3JQQ0xBcmZSR3ZvOUpXakFCY1d6VFpMcTA1?=
 =?utf-8?B?cTg2OFkweGpmVnRPL2xmTXIyVXBMOUk3MkdYbTFsUC9tYVpmOFNHOHJZM0o5?=
 =?utf-8?B?WWR1RWNPRmRBODh1SUVRQkVTZ091aFpkMUx2K0hPZFJUMXhpZlNxVjMxTHVI?=
 =?utf-8?B?ZnJnd3FhdHRtZVVZTUZDVC9PT3F0UVZEdnd5aHlWMDlHaU00V3Q4UWJTQUY0?=
 =?utf-8?B?OGFPNDNhcWFET2RNV3pFWkdHQU4rRXYxbVZtSXZtY0NOKy9Ddzc0K3pBcjRW?=
 =?utf-8?B?SkNvZzRYOGwvNy9Pa0wzMFBhS0pzZmRmcm9zQXlKWXZLRnBrdHpZd0h0RWwx?=
 =?utf-8?B?cDFETlRiSEdWK0w1cG01VWZEd0IxQ1N0QWVneDB5ckdpL3RxSzRWUkJmY3Uv?=
 =?utf-8?B?cmxGaGNsTFVsaVVrMktYMUxhZDdSSVFWTW5ONWxUR2UvUXhmb0xLeW1MNG43?=
 =?utf-8?B?eWhHSWRwWEtOYmN5OGx5d0VBOWtXQ2g1Njg4Njl2SGs1YUlHQThLdVhCTnNX?=
 =?utf-8?B?Q0RhYThqNkJNL09uQnR5YkpPaTBjanRGSWgvUW82aUhJek8zbnNxNWMxU0tP?=
 =?utf-8?B?Zk1wZDFJNnFYK2pOTDhzcWk4eThUMEdBVnMzRUY1alE4Y2p2MjdmOUhManVj?=
 =?utf-8?B?YnRkWVhrVzVWOGFJZ0NPbXJNRCthU1V4dSswRW1wSGcyNlFsYjZLQTlYUmJz?=
 =?utf-8?B?ekJaMU92V25XMEZlZER0WE8vcHF0UktmN1RuQUVMUUNiQzVSNmJmd2R0NENt?=
 =?utf-8?B?b2dTYUIxK29qR2dGb0NWV0FLNVFNUDhCZSt2Znd1SjlndFdoWlRzbzdjaHJ6?=
 =?utf-8?B?Q0xiOHAxbGFuNE5KVGxXcHhmbS85TE1SM2NUcTFWWG1aSE1mMmtsSWplZE14?=
 =?utf-8?B?bnluVVFwUjIrR2x1dXRSZ1N0MStqNndKOE90dnlONU5kdUxkZVdlRVJIWkhp?=
 =?utf-8?B?RjRpZTdWKzVOUnFabUlXdTJTWktTRUZEN0lZT04vdGlRakpFTmJaQlA1Q2pH?=
 =?utf-8?B?MzZwdkNCUFZhc0Vndk84ZXBUVC9VTE5xYWlFRS81UnpOeTJvSjlHTmVDaWNL?=
 =?utf-8?B?THJLQmJkbEdwSHl3cytlL2FKdGhscWdZUHByUXNOaHIvMmJzNXN0b3o3RkV5?=
 =?utf-8?B?VFk5bzhNLzRBTUtjUGV4Z1FjY1QvTTM0WVdRaTR0MG56NjdQVmZNYy94Ym9G?=
 =?utf-8?B?VlY5bS9UQjIwbnFFTnVZYWIwQWY5REtpdm9qM3owazNHM0F1ZGVxQUJ2Ry9E?=
 =?utf-8?B?cEZidGlJSG9la25QL2gveHlvSTFnckJrWlJadFNxRU1UaSs2OWRrOWVMQkwz?=
 =?utf-8?B?Q3pIeC85ZHRYd1ptaGdjOEx2emw4dXAyL28xalA5QU5BK3IzQ0VUMmFvSFlM?=
 =?utf-8?B?Skg5YXFMcnlxS0VLMUdnM0hiZENHNUoxd1ovc3ZhMjZhMC9jeGFJby9IRFZo?=
 =?utf-8?B?T05WZ3NIY1paQmpoRVlkUEhGSHRsbDZCZzhhNHNxcUZBSmhCaS9tSXNnOVlW?=
 =?utf-8?B?WW1XYlhiWjlaSFh1amt0dkFwK09YRWlCMzh3QndvR21nak53OGw1OE1HbXla?=
 =?utf-8?B?S1RwWUNYVGdIQTd0aG5xRjd6aitJL3hlckJPQUdDeWdqeXRIYktQc2I0MTNU?=
 =?utf-8?Q?YzsFFw69G0hwIvfswDC4Sgmww?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4bf15109-90e3-4960-fa66-08dac0baf06e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 12:23:55.8164
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jEhgRE13cvJrZmNhoNJjQFwbb9hiV3nYgfR9bndgq6mY+77fJg0SsF82iVTt7WNBcKnFuZwFmY5Jdd8fqRBe+w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7059
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_04,2022-11-07_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 spamscore=0 bulkscore=0
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070101
X-Proofpoint-GUID: Z-zJRsyW6zmDl7frvy1rl5jJu9UwwPR8
X-Proofpoint-ORIG-GUID: Z-zJRsyW6zmDl7frvy1rl5jJu9UwwPR8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/11/2022 11:54, Yang Yingliang wrote:
> If transport_add_device() fails in sas_phy_add(), but it's not handled,

The wording is hard to understand here. Omit "but" and it's becomes a 
bit more readable...

> it will lead kernel crash because of trying to delete not added device
> in transport_remove_device() called from sas_remove_host().
> 
> Unable to handle kernel NULL pointer dereference at virtual address 0000000000000108
> CPU: 61 PID: 42829 Comm: rmmod Kdump: loaded Tainted: G        W          6.1.0-rc1+ #173
> pstate: 60000005 (nZCv daif -PAN -UAO -TCO -DIT -SSBS BTYPE=--)
> pc : device_del+0x54/0x3d0
> lr : device_del+0x37c/0x3d0
> Call trace:
>   device_del+0x54/0x3d0
>   attribute_container_class_device_del+0x28/0x38
>   transport_remove_classdev+0x6c/0x80
>   attribute_container_device_trigger+0x108/0x110
>   transport_remove_device+0x28/0x38
>   sas_phy_delete+0x30/0x60 [scsi_transport_sas]
>   do_sas_phy_delete+0x6c/0x80 [scsi_transport_sas]
>   device_for_each_child+0x68/0xb0
>   sas_remove_children+0x40/0x50 [scsi_transport_sas]
>   sas_remove_host+0x20/0x38 [scsi_transport_sas]
>   hisi_sas_remove+0x40/0x68 [hisi_sas_main]
>   hisi_sas_v2_remove+0x20/0x30 [hisi_sas_v2_hw]
>   platform_remove+0x2c/0x60
> 
> Fix this by checking and handling return value of transport_add_device()
> in sas_phy_add().
> 
> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
> Suggested-by: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>

Apart from comment about commit message:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
> v1 -> v2:
>    Update title and refactor the error handling suggested by John.
> ---
>   drivers/scsi/scsi_transport_sas.c | 13 +++++++++----
>   1 file changed, 9 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 2f88c61216ee..74b99f2b0b74 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -722,12 +722,17 @@ int sas_phy_add(struct sas_phy *phy)
>   	int error;
>   
>   	error = device_add(&phy->dev);
> -	if (!error) {
> -		transport_add_device(&phy->dev);
> -		transport_configure_device(&phy->dev);
> +	if (error)
> +		return error;
> +
> +	error = transport_add_device(&phy->dev);
> +	if (error) {
> +		device_del(&phy->dev);
> +		return error;
>   	}
> +	transport_configure_device(&phy->dev);
>   
> -	return error;
> +	return 0;
>   }
>   EXPORT_SYMBOL(sas_phy_add);
>   

