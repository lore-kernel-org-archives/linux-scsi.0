Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 70329C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Mar 2022 01:21:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229968AbiCIBWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Mar 2022 20:22:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbiCIBWN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Mar 2022 20:22:13 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 22FDC23D
        for <linux-scsi@vger.kernel.org>; Tue,  8 Mar 2022 17:19:01 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 228M8uDp010008;
        Wed, 9 Mar 2022 01:17:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=XeeXPnnOS1pShcNUOYXz3RoUI1QcV4EkrN9LaNmqLDM=;
 b=LjfTYR5LREd9j4DJ87rZzvuCBvISgcCkLEP91OkRau/NaYtDwFuELloq1Y9xZ6YE7tHj
 5IFCagyScfni6kH/Wb/u7Sxgr6stGfyU+ZuuIXEzvBipCEsVW5rTGgsDWH5WdrCEsvlm
 VZoi0veDQU1pqLLdZDWkAI3rHf4uFmCTfztQR/EGYGA5OUC9Yu8CvKUE/risBCYnTd0T
 uHuvoyvfrWApD5dontgZEWZfoxUVOGQbKH9/722YWFWEh9AM/TY0EZXF7c6lD8sboh7o
 L9cmddSaenxc54Wyenh/cCzoZ7v2ZYYPvd0Zb1Dj/Jzmdk8g/Y04hpNyTLgRgK8+tosI vg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 3ekyrararf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 01:17:19 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.1.2/8.16.1.2) with SMTP id 2291FveY015800;
        Wed, 9 Mar 2022 01:17:18 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2174.outbound.protection.outlook.com [104.47.56.174])
        by aserp3030.oracle.com with ESMTP id 3ekwwch1gs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 09 Mar 2022 01:17:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=K3bSK0pzfwcFWddlInn35TwGnv7fSrlrGi7tu1xktTBntz7FRTASmTlU6OtuCzw61cwrwVs35jnwBta8cnO+uTWFqbb/uYXQgv0Vm3dcUcXSQzMPwVhyXlbK2GbRYjcA5kR7wla7spfGpqFuioCOn46xBcSH2Qmz+ckinxqDH0LFyeJYz1MG6t28tn+wocmXzTU5RCnnvMe9bNwf+QNy0+UuQofyTk2qssa4MRveW6fjcFoTs7VabMcd8uAhjiCtPPExfCntk1gGK9tHISWama65nOogVs/Gs6U1QzaG3Xc11O955AE0FrNFQwyQ8kArmVd4Kv8dVhoZEui+zFFUqQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=XeeXPnnOS1pShcNUOYXz3RoUI1QcV4EkrN9LaNmqLDM=;
 b=MnHJj6Wzt/by5kiK7UGeketmMnQzJT5OZyXjUMTyDFMbGboPwGI0PoDn5g9HcRlIkFQ7mAty+loXtk2ISOfwrSQtI2iOKGnX+BWElfKC6SoMRdz2e8+ZB8Qh9NoRkpsjrRIkkiLvFrGnmdBZHB86V4PXUFMZIbW4yizAf2UciVaZLkfqUk82x0/px5ynCUctxk2uz/yjMCV2kl/GCt3cR/wtziELtFA7U1Ea5/yzzQkHTxNI2mlaas4PxN8LQvypYtPfdFXXUuYYn+kNrorZX3oftORyjBJGOwi7Az1MdKu5iRz3X2sTeEQyuQ7X1lH+GexEmYKD8Eht1QCYCY5xDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=XeeXPnnOS1pShcNUOYXz3RoUI1QcV4EkrN9LaNmqLDM=;
 b=yvj8yp5aO1eZFrfWL2uXZMtT1vdQmI7lzKhleJvZHQdXAfdIl0PdYSbNbVmGwbw1WzjHz/8unhFl+VzruroHBuvLBXHt8FXB+YK2KTeppz0ymPiKfmb+1N76HUSMiNAn+cfIF1SNdoZHDHzDzyZmf8iiC+rTyvK/+mVD2gP5FWo=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH2PR10MB3990.namprd10.prod.outlook.com (2603:10b6:610:11::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5038.15; Wed, 9 Mar 2022 01:17:16 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::3dd8:6b8:e2e6:c3a2%12]) with mapi id 15.20.5038.027; Wed, 9 Mar 2022
 01:17:16 +0000
Message-ID: <b1b7fa2c-ade3-987d-e240-fb6acb421b99@oracle.com>
Date:   Tue, 8 Mar 2022 19:17:13 -0600
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
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <Yif6jjlpPTEYpcAT@T590>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR19CA0050.namprd19.prod.outlook.com
 (2603:10b6:3:116::12) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: aaaadc8c-5c10-446c-7a82-08da016a8c58
X-MS-TrafficTypeDiagnostic: CH2PR10MB3990:EE_
X-Microsoft-Antispam-PRVS: <CH2PR10MB399033BF88B297686A3E28A6F10A9@CH2PR10MB3990.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ChRb3YqZnrCQj6o2iZBVOLg2OBbK5+uuDfdcd7KY2JfIxx025oRnObOH8gaIQJsdiv/W/NajGsHtYesrcxrL1GgTFFR0pxyjJDRRyerAQKgpypJWiswQW50edvT/oQzH7XywzzQz6om5ytVN3HHnu7DbC2hIucQpUzVMYTEE64C2mVR5knOEfIQ2qKcOi126zNk+ac3xQDQrQDgM7eHBoeeGM2d+ltZomBT5bhv/eeCrsq+dnn7Ufiex8/TJT1IgchbrZ8mFRDedK8U6BeGCE+Jg31a8XcgxkZ3/X2egaUqiByT0QNboi1YlrQoROZiIHgk/NnzKNQb8oG7hRfC4wu+eLJ6YYHv3KaRC/mas5fO+yIlDKviFgqsI9aiwsZYqswafV202+kXhkh/qtUz7opkutbgi5QBbg5rSbOCwFlMeaysJ9krgtIDaBIAB/1tCBeFXm3wYCN3erKCR/rssh5uop5+1P+DAiOhXtTo9KoxNpWdb2qlfTFcSSvwiJNJKDqc5dA3UK8GRjhYgmXR371M2HVF9RiF4Z/G3hUuzlNNW5TZWLorDVPxiiVY3VfEmsa1J05wBzVlCot2zjpBDlav8yWAQiKldVWN2SApVeczTKqCLPHxSUEay9viHik7t77pty9uMnAot9MXpmQV3w7GZ2uGEUm0flt4SARahWQYldJH9vbtMP0y4a8Urjch07jYSZ/DLh+XRvfC2wZdTy56J0SbHd/FJNUa3SGbfqj1eyVo0La/BJpRemH3tcBGm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(6512007)(53546011)(86362001)(508600001)(6666004)(2616005)(186003)(31696002)(26005)(6486002)(38100700002)(83380400001)(31686004)(6506007)(8936002)(5660300002)(8676002)(66556008)(66476007)(66946007)(4326008)(36756003)(2906002)(6916009)(316002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?MU1uSDB5YWtpVHlZcEVYMGVxUnlYS1pUNU9GRlV6Tm0ycFhoN0ZNdjRXY1cz?=
 =?utf-8?B?bURleTc3UHpNS25QcVVabjBibUd5ek5NcFdneWhUYUtoMVR3NmY1aHVKQnJm?=
 =?utf-8?B?VzhUclJIWUFDODU0YWhRdDc4cmxuYTlCeWFEZHU0YjhtMzNyblpnSHlEMjZ6?=
 =?utf-8?B?ODZzUnRLSllBN2pLMUhNVjBjY2U0bmJBVFVQTUxveGVGM1BYYVVOa3c4NEEx?=
 =?utf-8?B?Y3p5ODVQY2twZlpRNUdhZTNodDVPODk1VTlUd1ZCMUpkdFJlMEtCdmYwTlh0?=
 =?utf-8?B?eVd5SU9pSHRFNHR6TC92bDZWMklzSzZ2RjVHNmtrRUtsMXZBeVp6dkl2Mktk?=
 =?utf-8?B?TUp4clZ1NmcvYXFyODJvUnAxcmUxSXp6L05HTzdBM09WbVZBdnFjK01USGo2?=
 =?utf-8?B?SEVXN2g4Wmt6YVE5bDVSdWx4QWJDYStRc3J6VnJrdmNDVUZXc2loeXh5a240?=
 =?utf-8?B?UWt1b0kxaWRCaUxzRmR0SEwwUFpPdUdwOURRUGg1UTJhY2oxWitlZW00VVJM?=
 =?utf-8?B?UkpQbTIzWTVaTmpXMWV2OEthNml4VW96Tjdrcm5zZE1wTHdESnk5K3lDTU1H?=
 =?utf-8?B?MWRzNE5uWlV0eFN5OGJhb1c3bUlSRW1kVUFUSU5yUzUwc2N3QzV0d0FrdzNl?=
 =?utf-8?B?M3pXK3lyd2xRMVp4TVZ4am0vZFJKZ2t2TEtsQ3RqQWFXTnZhMGxUR3prYStl?=
 =?utf-8?B?bjQvU1p3T3p3QjdwUWgwRjd0NkpVdnJRMU9ydWdmOGxIbVZyVUMvb1haSTla?=
 =?utf-8?B?QXZta1pnK0N3bEtmTUJtYjk2dUdWYXNpTUdJeWF5TzdOWEtVNUhoOWQ2WWM4?=
 =?utf-8?B?cjc5dWszTlc0Ymk1VXFwWGhSaHdVMUNOekpwUmdtd2tjMEZ1NGRMK24yYmox?=
 =?utf-8?B?NHJOcnZPZXRraFR0cjlDZVpzVFZjSFcwSXNHQlNSaXUxb0o4eEVWdTZRY294?=
 =?utf-8?B?bThORE9tSUt1b01kb3pFR25ySU9jY3E2THBRTk1LUEtUM2wweDlIalFxTTRa?=
 =?utf-8?B?TzFRbEdSbmxSYzNKeGlUUEs3SjdWTE1yOTdBL3BBd1pkT2R5dmRpMzFSOUtT?=
 =?utf-8?B?Wm01M3pNS3BEcXNwb3RmbVB4VzNUdllZeEhFbXJnLzdkeWtVUnNUTVRnd0xS?=
 =?utf-8?B?dXdrbGpkOTQxOUxDditXY2FqYWxTU0VuQjN5bzVETDVadVA2aUtvRFV3dUJw?=
 =?utf-8?B?VjdDRU5nWnk3cHJYKzczY0RHTHBDUVVmemNVM2lzNWw0Um1WL2xNSTFsdHBp?=
 =?utf-8?B?azRvVVN5Y2wzb2ovYkVnSGRqSVdVcStiVW92cXBST0U0ejJOdU9SUGswOWFn?=
 =?utf-8?B?a1JFNUE5K0NOUitCeDRuU0l2RWw4ZHpWd2hsdHBhZHhLVWxHTElWbExHNTFJ?=
 =?utf-8?B?NHRqRElsZ0RXb2xJQndkbXRYSnp3RU1WejVMUFBUQ1paaVRSNGdROW92UkV1?=
 =?utf-8?B?SHhnOTFLZEJHTTE3MlIyN084L2MzbEhQMnNVRThwYm84NjEwMGljTE5RQkUy?=
 =?utf-8?B?RE4vbUhpWndpWlRaekIxTUpBVW93cFV6L1VRTVdBUVhBVFZCdmU1VlVQZ0hW?=
 =?utf-8?B?TGVRMHZDeFVYS0dVU3ZDZUR0NVJRYXA4TDE4NVFiUGFlaTdJRHM2Y2JnWnlB?=
 =?utf-8?B?Z1hBSlphVE9WeW1aM2V3K2UwZEN1SEQyRWhqSk5CeFpHOG1rblFua1hBaE14?=
 =?utf-8?B?SnZjdzBScTFOMlBCd2E2QXdBV1pHaVJGTFFPWTZvUW9ZaC9Fb1ljSUlhRU9N?=
 =?utf-8?B?RFczUmluc1ZUdjA4V3R4WmxXZ1VzSHgxejgzVyt5ZVc0S0NhcGZUWGRwTHM4?=
 =?utf-8?B?eVJCbEE5cVlJZ1ZVNE1valFZNTNRSFJhNzJaSzdkcGNJckQzY3NxRUE4NUtY?=
 =?utf-8?B?cEVKcnVRUmNaME1MZElObkdEaXUvYmRwM2Mzb1V6eHVmblo5cGlPZFFZUmgr?=
 =?utf-8?B?WHZpekJ1cXVBSGZ0RGY3by96NWR4aXRPQ2F0UnZ5L1ZFczBiSWc2OXV4KzVC?=
 =?utf-8?B?MFQyaVNyRmFhYjlZSllnM1lyRmZIK3Y3N0tzeWVVTXo2endSWUVTKzA4Q1pv?=
 =?utf-8?B?d3RNeVVNczFqV1JldC9BbDJXbC8wWEh6K1VwbHN1NnhLelBnaUhqSkpCcG1N?=
 =?utf-8?B?VnBhOUVpUzlvYXpHdmNMVGNvVmF6MDVwSnI5NzV0SHh6alhScTZLSW9JNmN6?=
 =?utf-8?B?SEk5SEhYeW10SGhERndYUHc4ZVlYSU9zZUoyQldTTmZTV2ZqTUUwb0lYdmRB?=
 =?utf-8?B?MW5ldi9HU2hWaFB2SFY3SVBMZUJ3PT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: aaaadc8c-5c10-446c-7a82-08da016a8c58
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Mar 2022 01:17:16.0210
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vrq0nqTRtts08JBeHTqrd3XzC0lONFIqUEkXpvOm9ml6pbHkQGN48x86y2dbmi6NRy4pxlszph6CWtLTtkIXKIXK5pOF3UuQrN7oCwrzeA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB3990
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10280 signatures=690848
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=468 spamscore=0
 phishscore=0 bulkscore=0 adultscore=0 malwarescore=0 suspectscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2202240000 definitions=main-2203090004
X-Proofpoint-GUID: 5eY9v-WEXfZfwY4E5f1xCqV8rwZbSk8f
X-Proofpoint-ORIG-GUID: 5eY9v-WEXfZfwY4E5f1xCqV8rwZbSk8f
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/8/22 6:53 PM, Ming Lei wrote:
> On Mon, Mar 07, 2022 at 06:39:54PM -0600, Mike Christie wrote:
>> The software iscsi driver's queuecommand can block and taking the extra
>> hop from kblockd to its workqueue results in a performance hit. Allowing
>> it to set BLK_MQ_F_BLOCKING and transmit from that context directly
>> results in a 20-30% improvement in IOPs for workloads like:
>>
>> fio --filename=/dev/sdb --direct=1 --rw=randrw --bs=4k --ioengine=libaio
>> --iodepth=128  --numjobs=1
>>
>> and for all write workloads.
> 
> This single patch shouldn't make any difference for iscsi, so please
> make it as last one if performance improvement data is provided
> in commit log.

Ok.

> 
> Also is there performance effect for other worloads? such as multiple
> jobs? iscsi is SQ hardware, so if driver is blocked in ->queuecommand()
> via BLK_MQ_F_BLOCKING, other contexts can't submit IO to scsi ML any more.

If you mean multiple jobs running on the same connection/session then
they are all serialized now. A connection can only do 1 cmd at a time.
There's a big mutex around it in the network layer, so multiple jobs
just suck no matter what.

If you mean multiple jobs from different connection/sessions, then the
iscsi code with this patchset blocks only because the network layer
takes a mutex for a short time. We configure it to not block for things
like socket space, memory allocations, we do zero copy IO normally, etc
so it's quick.

We also can do up to workqueues max_active limit worth of calls so
other things can normally send IO. We haven't found a need to increase
it yet.
