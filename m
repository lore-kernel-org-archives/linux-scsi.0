Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A2A4C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 16:24:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245003AbiHIQYk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 12:24:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244990AbiHIQYi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 12:24:38 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94DDA60EF;
        Tue,  9 Aug 2022 09:24:37 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 279EfbMC005389;
        Tue, 9 Aug 2022 16:24:22 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=AOqjrG/BbH38mQfFL4IOY72qmIsTagvDFiTOFmBW6Xk=;
 b=j1V/H31+7yYMsJsFUHhjk5/qP5TYLjSXcI9CVx1rCrf6aua7PWpg9Kl5jW9ppe6xzCND
 JPiE3ZiW9CCZZhBQyJSrx8/brbKjTfTitrXBEPQXoV546J4sLY8fFT572n0vP0Cj/qmq
 RV1K6nbwjEPOZERIYcDZJotbdBP41WAPhexJOeaRI34FfTpEqyJBvoUcMrif7DYvucqo
 RWjFSWvzSRBVu/GBkhKb9jLC4oD55mr7ZRR1t+8lT8DWIADlUfezpZdafecz+Tj0qDaN
 GCZfxaG4qB/PEkBfuXp31ooCRUkJdGd/llhdA1yqUuFj6OqiSz4PcgM2iywcSoFHx7+q 3A== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3hsf32f2r6-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 16:24:22 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 279Fseau034469;
        Tue, 9 Aug 2022 16:24:21 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2169.outbound.protection.outlook.com [104.47.56.169])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3hser31qbf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 09 Aug 2022 16:24:21 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=CPkinR6rYezfEi9JhCpM3XEvGKW4DLqtbe0zKHV6bG0+7gyi4HLHVKT5B73EIGyEmwONElMXDivOa1s7gZnOy7qaFGysfMVt7fFgEjKbmu74dmdE8vycJfYU+lOzfDdtBLWLikwKjWdY7De6XtQPz1RNkSn19Hk5Kf4gi2KsK65z1soEgZtk69YSw6pWDzpkAyROiiwBQANt8X5u8Zma4YowQ3BOq1RM0ins+ICw5jZo7D8iTqsf5Ad8/g3q86BtCAeJzR7WN02DXYUeUkRleaBJDj/OmBZP2aH56zDz2SH/+ZWp52AV6PZZjwoYDR/f2jLWuPUGtDQo0uqQXJIYBA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=AOqjrG/BbH38mQfFL4IOY72qmIsTagvDFiTOFmBW6Xk=;
 b=ZKtBxmLpilgvmkci7zXZ3hTYhIRodtJq6FpvP86a2AnZcPCBdvsgCqt4kXYxbiRiaeK+UYEA5Yl8/7g4JfnzI0gXriWMWsFQWOBQqzg1Tv5sv29ro+Gb82Y4X4CR7tCDe+dNtG4QvuAsAPQzkvUO2U1TmmLW8qEI/E0s0aut0/bdS8FvGebDcIoiwJZqui+w/UqRYmRYDSA/Gh9fTF8KfKEPH1ISScpp29/jb4rEXUrqjXpyGfQTKt6jXqZmzfD+MXquLWC7ASC4e7oZgAi1Qz0GQ16T0hjTrPvfBr+y9tPUlrcA+fOC8JPeU7r9eGWTX+7e0IgZm/RYF5Ld16jhLA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AOqjrG/BbH38mQfFL4IOY72qmIsTagvDFiTOFmBW6Xk=;
 b=KERkfPMC+xV9ywtN14Om51N2ON0WvjVM2pZfwxrBlFcThg3PsM+NPvswNZEcTe59N9fk5Oez5Icj9yKr92FyCV1xW1/OHNFKh0P0XhXuy+jWn9LLi1EHQd4/hFkhbOYHYw3Z7uOxD9HgR28yw9dQXPMhnLSHLoRZKHYxo7eOSxs=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 PH0PR10MB5417.namprd10.prod.outlook.com (2603:10b6:510:e4::18) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5504.14; Tue, 9 Aug 2022 16:24:14 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5504.020; Tue, 9 Aug 2022
 16:24:14 +0000
Message-ID: <bf55356d-24fe-7a8e-c766-cdf33e7304c2@oracle.com>
Date:   Tue, 9 Aug 2022 11:24:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.1.0
Subject: Re: [PATCH v2 14/20] scsi: Retry pr_ops commands if a UA is returned.
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     bvanassche@acm.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, snitzer@kernel.org, axboe@kernel.dk,
        linux-nvme@lists.infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com,
        Martin Wilck <mwilck@suse.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-15-michael.christie@oracle.com>
 <20220809071632.GA11161@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220809071632.GA11161@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0016.namprd04.prod.outlook.com
 (2603:10b6:610:76::21) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5e54efd-4e21-4f83-d21d-08da7a239932
X-MS-TrafficTypeDiagnostic: PH0PR10MB5417:EE_
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: cn+lyILx0hmXZ7sVMVdsj2bAbfUjaooDV5JN4AWBChZVvYjLGN91l26xuVDHYwC756Mbpqs5gqJssEnMcWrvKskvHonRyY6bNcQgzr7LObnjPdE9t/lnl7+LiOIkhzZP2XQsGL6uApDPPSSvkVrtu9uAgM6fAmBpxy0sbNvGNijWs7e7r4SvBI7ZExahmKMgVlaYXHumciXUWoN+EWdmSi8AOVxr0W3VwdYv/KxxOryo5OtESVpwyZahs7j7YdKaDFExgeMuWHukYiYf7tUjvB7vUXMxy7jOlf9lNYtstn1Yn12ciidg/ngiLEvKgv5D5AqljXgwCidBXCkLatx7HBi81uhQfW5S+2mQFLF3Mvh8FvvKW9Yn19QrbGCuWFQkMx4Qvf2R6wDkly6umbgbv4UyU5fHuYjDlwLKCDiNxeDzzX6ZUG+Nlx6IbgJS5lXCG3AYaaR+jkj4JgoOcOcDcGll1ZMdJXUgzSOiXF6o+WuEAAfXqK2KjmE2oA8zBHxi7qjn3H5Ne4E83YtxIJ3T75c4rl4yn2A0AzwpJU4pp2kR+vTLMlx1/q1KyV0G5GVLPiXcQxCGbGISfmtc+JYvGEWd2cKOrrsTJeLVOAr9eo575Wht8jUxEqsvFLy7RAtJQYgC6Q03VQOuh3rv5UIU/mCtUC6V300JrHCySM1retPoi3tFegO2cjWAA7jPQhjZKXuAk20YaARNQWAR4NqCyWBqiEH6MI1TyAZkjVBIvu9NaUV5fgKDtsoOUjRQRk9DvfqU3XGqHOl4KwCgkNPFirS2W9m7u5iXh4mIEtzmajGV40XMXvdBOKouNJJwapbZsEyIHQPQHe2sCu/9Zgg+6g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(136003)(366004)(396003)(376002)(346002)(39860400002)(6512007)(31696002)(41300700001)(86362001)(53546011)(6506007)(26005)(2616005)(38100700002)(83380400001)(186003)(31686004)(8936002)(5660300002)(7416002)(2906002)(66556008)(66476007)(4326008)(4744005)(8676002)(66946007)(36756003)(478600001)(6916009)(316002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dVZEcmxkYndTTUU2aDBFd0o4N3lKdVRRSXBWOS83WU5ibFFMcWFtR3FxTHR5?=
 =?utf-8?B?UG5oV3YrSURHYksyWjBzQVo3YU1Tejh3TzZLbnM0SmdpMVY4akx2Wi9DNzJy?=
 =?utf-8?B?aFdyYkZjYkNlQk9HeGxqMVdyWEYyR05zMEtucmZGODhtckMvUFdOcWdLOVNr?=
 =?utf-8?B?Q1R0bERSWS9jczM5ek5ZZCtiUTFpVVA5UkNsS1BleTVvSWpCZUhrRXFpTGpR?=
 =?utf-8?B?czU1UG5OSWN1a0VRUWNBMWtjMjNoSTVvdi9sVmhiTmVEcnNVQzhTUGlMQlpi?=
 =?utf-8?B?NE11b2luSHltN1crcjNFclpqdXFJQWEvYlZvMVdNZXJRdi94VWsrUC83SG94?=
 =?utf-8?B?UVlzZVRpdlNXUEg2QmtBZ0QvMW43ay9ZSll3dFA5YmFWeUI0RUpzRFQxRkw1?=
 =?utf-8?B?TVhoMTFlQVdGS21ZMnk0bFhNc3BEZXlTMmt1TjU5aW5yTGN6azZVR2g0M2Ju?=
 =?utf-8?B?RGhpMStNK3BlYzdqVkJyUm1obzdtZFBqVVF4cGpzVGdmNE1ORG81dzNNVXM2?=
 =?utf-8?B?dVVtY3Brd2dHNkEvcEZrUTBTcCtoRzNzMWZjTEVGa2s5VU4rWXFQdWZ1dkR3?=
 =?utf-8?B?bHJ3UDJXWHRTcksrUVljYkhXZjNaNmQwQ3EyQjl1TkRNL1hHZmdTdWxONy82?=
 =?utf-8?B?dWNhVmR3emRJc1BjWkZRNGIrR3NVTFQ5aC9WWXRzNERaa3Ixc3Eyd2RmUEdS?=
 =?utf-8?B?R1ptNmVzSnRLNGJKVXJhcTdXVG9kVUdLd1FBQ3h3RnR6K1l2MUVaTXhwN2xv?=
 =?utf-8?B?aG5YOE5zNFg3N2JVZUQ0T1Rva3N3U3dncko3dzdDS0YrSm9qR2tOTGJXSSsv?=
 =?utf-8?B?TFBEUjQvODRQbE14M1Q2OGtwdWlYQ2puTnd3Ty9BcmpXeGwxUE1RMXY5MGRQ?=
 =?utf-8?B?RG1TZ1hGdFg2dmUrdE9ERGFaemRHcFNrZ295Y0puVjBpUkRza1Z2cmxVOUJ6?=
 =?utf-8?B?aFhFNUppZjVSQ1Z4MEEwUmtiUlFaeTZnYzdubUl0UWFaQlFtR205ZGJ1M3gv?=
 =?utf-8?B?eDh4TFZPNWtuV0NoNWRQU1lXSXk0cFVXMTRMN1hqa0lJWlp0UjBBNlRWWnRD?=
 =?utf-8?B?b05YQ3Y4UnFodkRBVFJHZHU1bFBkaEVxU0NUbjg0VmFBWEF0OURWV2ZiU2pZ?=
 =?utf-8?B?a2Q1VXlOM0phRCtpNjRxeVFVb0ZGZGwvamd1QzZzTDV6RjZVdVdrZk1mYUNF?=
 =?utf-8?B?R2xrM084L1pDNng1SWsydmZHcmdMRlZjUEovMTYwbWxveFkvZHFPOUNrUGwr?=
 =?utf-8?B?Wk53MVNweFpUOUowS2l1MXFaRUFCZmV6eExPY0ZMN3FOREFhNGw2RHVWU2NZ?=
 =?utf-8?B?akZRT2NGMzUyVkdxM3o0RDFDNmNEK0UvV3Rzd1lNY25lRkdPOUVaM1YzM3Bq?=
 =?utf-8?B?MlZUODFWYXcyajhRRW5LeDNVWUx3OXBWTDh0ZnY1SmorOE56Q3ZZdzdBUFpR?=
 =?utf-8?B?MUh5M3JVdng1QlZSU2FaNVFHTUx4MmJyUjN6T2RRRDRadkQzSFNUQWw1Q3d1?=
 =?utf-8?B?ZVZpMWZKTjRoeENsM0RldWJjbjB3eldOUmtLYXh1UkllNXJnZXRlUk1PeWxX?=
 =?utf-8?B?ZUdzYkIxRVNaaTF6eGdYUlU2RElYUTJWRjVHd2lYVzhUNERhd3F5V2NBdCs1?=
 =?utf-8?B?VThWTHRwM0F5Q1ZxYnB2d3hwdnJDaDBTQ1BqSm9waWdpangzSEN1dVdhUXZ4?=
 =?utf-8?B?Y05iZHpoMk55QmFjRXZZU056djVOb2dlRzh2ZkJ2RldoVU0yMWlBa3NJMUJX?=
 =?utf-8?B?d0hsZmVBcUR6dk16dkJhY0VWbVNGREJjVm9hNlUycmNYcHZIL0dQNHFVQ0cy?=
 =?utf-8?B?MU9jeEVYMEo0UERsRVVVYXRkWCtoSjJIaW9jcDZrTGxkYTNmOTZPQWFaeW1k?=
 =?utf-8?B?bXBlUnhRT00rbjFBdVRaWnlPdnpxZkdqYkg2SDNrU012WDR1YmYzU2hIcGRE?=
 =?utf-8?B?NUJZdS9mRjZ0WVFRalhYM2ZnMkdwajI5OWVzZ0RMbmVxMVkwYTRBNnVrRWJu?=
 =?utf-8?B?MEE0czQwVENYME55b0tGQ2ZRK2dzMXpRanFnNzI4N1VDVmx0RG1aZ0tiM0Yz?=
 =?utf-8?B?UFMvejQzcnFIbG5YUW9rVno0MzNQeGxXVW9MN0dWaXA3VWV2MGJTQVVoVW9u?=
 =?utf-8?B?VThMdVdZUHYxa0NJa1prMmNPTG5HcXBNcU5mRm80ZkdrbEt5Vk0vN3REdjlu?=
 =?utf-8?B?U0E9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5e54efd-4e21-4f83-d21d-08da7a239932
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2022 16:24:14.0597
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q53TyaBAqkImNitloSe0k8qnT7iMK0cmCxExy5U4ltcaz6ECz4Ax94Mf/h6YhqqRWGZwDMcmZ6ApH0I6YpVRWuUZGRBLb6N27TEyIQKVlng=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5417
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.883,Hydra:6.0.517,FMLib:17.11.122.1
 definitions=2022-08-09_05,2022-08-09_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999 adultscore=0
 bulkscore=0 phishscore=0 suspectscore=0 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2206140000
 definitions=main-2208090067
X-Proofpoint-GUID: hYkuC9xdU3YYh-Lx8EeINk51NuiZVqOp
X-Proofpoint-ORIG-GUID: hYkuC9xdU3YYh-Lx8EeINk51NuiZVqOp
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/9/22 2:16 AM, Christoph Hellwig wrote:
> On Mon, Aug 08, 2022 at 07:04:13PM -0500, Mike Christie wrote:
>> It's common to get a UA when doing PR commands. It could be due to a
>> target restarting, transport level relogin or other PR commands like a
>> release causing it. The upper layers don't get the sense and in some cases
>> have no idea if it's a SCSI device, so this has the sd layer retry.
> 
> This seems like another case for the generic in-kernel passthrugh
> command retry discussed in the other thread.

It is.

> 
> Can you split out two series with just bug fixes for nvme and scsi
> as I think we should probably get those into 6.0, and then we can
> do the actual feature on top of those?

Ok.

Martin W, I'll submit a patch with a new SCMD flag that will fix
both our problems.
