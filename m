Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9BC8C25B48
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Oct 2023 09:28:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234199AbjJXJ2D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Oct 2023 05:28:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234195AbjJXJ1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Oct 2023 05:27:45 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 314AC10F5;
        Tue, 24 Oct 2023 02:27:17 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 39O5lPbO028836;
        Tue, 24 Oct 2023 09:27:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=LZWk+vpS+2/n2lNVlD0HL9NrtdlQiGDnLyZ1FdjOA+w=;
 b=dEKUix65jeXTHSiVn4tBNNwy2i1wZkO1CmXNCG3+jrc1dHEmvhzTHdA4/rbML/T9Mc4r
 7yw6IqHJ8wkwuGDOAMQki7OK/6Vgo6jlHTQTSHhhmRCwsqV8245gi1GGTWK5h23z3++r
 InlR5jo5n8G/F4AG6XCpbxW567IJN6tqUGJMu6iha7gSwQqiQftCfDDKzCUonDvEGOJi
 upkCbNIgx/GFHYD3HWCe5D5p+fCGzF4Kq8Lwm7JYJlWIPWIJzKIeBG73BVO3tCcRXVv0
 HY5/T5Rqo5QeyFgi0Wjju28R0YPYBuAlhC6miUrBZBClRQ/v9tOeZRPh7HSNNNUHxer+ vQ== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3tv581n3uw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 09:27:02 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 39O96NPE034523;
        Tue, 24 Oct 2023 09:27:01 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3tv535223j-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Oct 2023 09:27:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=RNYyr/J5UZPNmUVy4ydq6A0ltiW3x50+W5hEUxbBsRsI2rpnMyxRA7HPoY+e8s+Bbg2k78DXuFvMlLIoknQMeQd8rbrtslJXxTxt1hDPkvMwDQhQj/urjrVH7csHUIPIxO+h0OBa+8OfmehGVIwbMoloXD6cX9PTRe8LE6d3SltmSBkiBmra/ym6XrX/P4Hzcwu5uIui2pwGywZQSKAEVBbgUFHuLiIeTnfHhu16jB3AeQrtFvAEGQTwLcJoT7929uZRN5NLo4JfMnRgB4Z4ZeBZU59NPLa8nI2SmMB9rFyqSTpnyz2LeXq0mPotdxxGyprW0XCv2oyT7FWS1LLmPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=LZWk+vpS+2/n2lNVlD0HL9NrtdlQiGDnLyZ1FdjOA+w=;
 b=UH0GxjGphM0oHcSwHsThhWg7tNwu/C+6F6S4HaMz2sXInVOJS42AGSf7EbMn7vSrZMCPGQ4uCmSwYd7x7zOkYqeCa12SCGjl84vTbnerKKvl2bpx2/wMue4pvh7hKLEzNxeOAHsFurXZv9gefuXaU617ScDbQI88C4p3IY5VHDF/FFXnfBHMZhWuSEi96zLmSjyGMbWOmBtmiKZvcRy8Z/5/IbNBgIXAq6aMqlY7qc+zA3REIj+3H6ys3c2JvNhnNqjN6cTzaZvz4nGOe2js1scYjGsXvlCOqTjH9+yyFqqrdyQDFuJTuPcxQPxzat59dx47+u//qFffuE0eTz7x+A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=LZWk+vpS+2/n2lNVlD0HL9NrtdlQiGDnLyZ1FdjOA+w=;
 b=jM05BCTW7m+oSNYH6ZMuxspOieFkOnudKN36CuIpebpvyIZjCUVcgfLC8/INXywKNTHIEaDhztXK/dkOGD+3FNqFyXmRpYmUBWS6e6CRT8ZaW7UbdZRvZNSX/BHHZxhWmd8pz5kSUDvjsa9p4Bcawm8IeqEj3tqvKVnhch+16uw=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by PH8PR10MB6358.namprd10.prod.outlook.com (2603:10b6:510:1bd::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6907.21; Tue, 24 Oct
 2023 09:26:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::2c06:9358:c246:b366%2]) with mapi id 15.20.6907.032; Tue, 24 Oct 2023
 09:26:59 +0000
Message-ID: <dcd4019f-93ae-5843-b10d-af912013b3fd@oracle.com>
Date:   Tue, 24 Oct 2023 10:26:55 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.1
Subject: Re: [PATCH v14 05/19] scsi: Add an argument to scsi_eh_flush_done_q()
To:     Bart Van Assche <bvanassche@acm.org>, Jens Axboe <axboe@kernel.dk>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Damien Le Moal <dlemoal@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jason Yan <yanaijie@huawei.com>,
        Wenchao Hao <haowenchao2@huawei.com>
References: <20231023215638.3405959-1-bvanassche@acm.org>
 <20231023215638.3405959-6-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20231023215638.3405959-6-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0057.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:2af::14) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|PH8PR10MB6358:EE_
X-MS-Office365-Filtering-Correlation-Id: 15fcf96a-2b0d-4473-f978-08dbd4735f5b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UaKtGXlBx492WQp7Z7Drt9HnZoPm68ztCGTFPciaiQ3qeAIy0SYZdIMVUrEde1eD/jqn5T2OlxbNStAQDGVAyGi19+TmwL4o5YaPozvDErl922It4hZF2DqowfdpfsJpQ/HtfYWf4ZkU1rj+UZq69UlJ13mUeSJE5LVCifSZENdrdgfGc9qd0hq4IXf9jIrkWRuPwVsZaWZNpmsUqtASA1JKzURVgqXaOTmzxCci6iaS00oDBM+e+04BKws30qtYmIrINC0tkLWkaEDu+8RoUdiPZms32ZHSqNuSDmR0NUp5JAGoPY5ixeBnJ3vOEbUxdN2B9OIrXuVM+Gwqmv34J43eos+vBWQEg3O1G0gHIwAybJfy1YRG79/IaLBCT7wJbYPjrcaKYnc8M8FQPtwZKMTZFOA/pkx9SmIftuQZw4bslwc2Gu3LlFdleXg5AhlDe66jM2iCLtmJpXvfAeWz6xxN54o43ofMdGLwduaWYoeHJJ2xWboMsnwqcnYuxvZOtV5wsDujdF6Skdmw/4uOM1aqnugbHZCuKaHSoYxw5/3pAuCAQMQZUtMj2PYXi/Gwo/FW7OokxnGrPs0A6lOw64G37lBV4BX8UkBavhWoRWaHqekTY+gJAM2v0lZYH5S5d36s5GHp1NEyBd7HV7aRhw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(376002)(136003)(346002)(366004)(39860400002)(230922051799003)(64100799003)(186009)(451199024)(1800799009)(36756003)(53546011)(6506007)(6486002)(6512007)(36916002)(478600001)(66476007)(66946007)(110136005)(31686004)(316002)(54906003)(26005)(6666004)(2616005)(66556008)(41300700001)(5660300002)(38100700002)(8676002)(8936002)(4326008)(31696002)(558084003)(2906002)(86362001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QjlUUEluSzhDeWRlTm4veWZaQWpMTVdjOHVxRjg0a2E5UmE2bHNPVVdtVUhR?=
 =?utf-8?B?dzZtRUVPcWUwMmg3bHpsTUlJb1lWaXNRMnFPdFpJcjRFOGdmQ0l4cllReFNI?=
 =?utf-8?B?TGJHYktNdEFNOEplbUVmNnE3UjB3YlZXZmtWNzFKSzR5UWFyTDI3QzJaSkxo?=
 =?utf-8?B?YUhGUnlSQlJvdlM4VVBGL29PbHZ2aFpYNDg4cWxhenBDcWNuMFZwU1lCVUpH?=
 =?utf-8?B?Y0V0Tm01QUhISmJ4dndGTDc4bWRDbGNqc05pYWVrOU9KQUF6Njd4MHJmUEdC?=
 =?utf-8?B?dnhmMUsybkdrdWhKVGMrWjgwWGxFMTdmSFNrcG1MWWFxUzhENXQ1eXNwNGlh?=
 =?utf-8?B?dytPOS94Q0dNVFZxc2ovNnBEM3RXN1NGNXNKZU5nLzZ0OGpwZEI0WnpzMGdL?=
 =?utf-8?B?dDJ1WFduNG1CUVROdy9QUzE4OFhSUnU4ZllZTExVWUQvaGxvLzZqQWlVMHhY?=
 =?utf-8?B?bGJiVWYwK3N3UUdLQnB1NzlUUGlaZHJNaDdLaXV1MndCMjBxNFV4RHJTb0x4?=
 =?utf-8?B?N0Y3a2R5UTZkNFMzM0VqY0lDcWNWeXlkVm8vemFpNklpRWt2L0ppWlpSbDd5?=
 =?utf-8?B?MXRmUDFuYkZvd2F3M3BpbWNkSVQxNGZEZ3NBNHZmdkRiRWs2RStZWXozWlFJ?=
 =?utf-8?B?QVFPOGhkYXpSeTNWeXVSZWcrU3M1T0lVQ00zVjA2UG1tVVFvdWNhRURhcDVT?=
 =?utf-8?B?UlN1MHlRK1FJdi9uQmljZWNkbXpYcmJReElvbHJ5L2VoVmNxYWhveU11TEJO?=
 =?utf-8?B?TzhwVldZMzlReUVwdnhnUUZFdnNKRzVRRjNjUDZQNVZhMTZMSjFwbEJHNVZQ?=
 =?utf-8?B?eVByYzVZbWI5aWc1UTZtTDZRbW4xeTc2RnRabmhkL1RwSE02Sytlc295N24v?=
 =?utf-8?B?bnN4N2g3blpla3lqSnVLMU95U0lQRVE1TzhwNTMrVnlFU1p0S3FVRDFtWnJj?=
 =?utf-8?B?SGFMSllETGxERDNzbjNxR3FGSW5qZkdzcWkycHNGREl6VWQyWC82WkVxandG?=
 =?utf-8?B?K0VFbWM4d1RtWEM4QWlzWnZHeE02YVFFaDRldEJROGRNQStpK3dzUGFaMkQ0?=
 =?utf-8?B?RGUxV1R2U2NHYmIvbGhLa2VTdHlxdVpLNXBuSC9seUIzY0tWUnhpVmhtTGFq?=
 =?utf-8?B?VTVCT2g4SW9paWh0SzZjREtqNmhXZjcrRzVveW8vSXR6dkhNZktQRmtydzl2?=
 =?utf-8?B?VjUwUVEyb3dENFNSK2hhOTUyUGFRR2dCMVJmVWkxNVZXdWtOeXp1cTh2WEEw?=
 =?utf-8?B?VE9GUTNPUzB6eG9VRkd6TjVHOEpPb3RxczBqK0hMYlg1aCtrbDlBQjJieFhN?=
 =?utf-8?B?UCt0OXdRNUdCQSt0a1lOdWg4S2ZHUnErNUg3ZHBqaWtmbG5jVHNnckp4Y1lj?=
 =?utf-8?B?N2YwbXAwL3lDc2p2WVczemk2a1NrVGJ2b0tKaStuc3M1YmVIWTNUTUZiSFgw?=
 =?utf-8?B?NXpmSVN5OEZzbTBmeVlBWmlkNFU4bkRTWVkxZ1hxMlY4b3I0MzREdkhXMUJB?=
 =?utf-8?B?VEJqY0d2SGFVUkJOcVJRNk1iRlkzeHkyREEyU3Y1ZkZpc0JpMUViQW8wWG4x?=
 =?utf-8?B?bGhxQyt6aHNIUHNnZW9YV0crNDJPTEF0OG1yUUhiOHZuQWY4R3dJQnpSOThF?=
 =?utf-8?B?TE5ZSmxTa0pzV3JCd1VmOVZDSUlRbkQ1UWpVYmlZNlpEMldvQkovWUliYU1W?=
 =?utf-8?B?NkNqc1doS2FaUUtWWTMydnM5MEtJZThrQ0ppL3RDNWdnaitjdTExbTV4eGhH?=
 =?utf-8?B?MXVzdzRPVzNxV3RDaFpzUjBJcHlmRGo4a1NPZEdKY2FyNmlHa2VCSGV4SnAw?=
 =?utf-8?B?QUMvdXU2Vk04ZHY3YzFsT1pkckhaTnNZWFdCWGMvYVAyQUp2Unc2NFd2d1Yv?=
 =?utf-8?B?SUZrRHJMVzZ4WHBRaFFWQm03NFNDa2RBOGw1bDZCdlhMcUlpWnRrNGQycW4z?=
 =?utf-8?B?ZGRaR2xyZXUzeUdSdVBid24zYWFSWUE4NkVRTXArbkN3RnBhMmlVL2Y5SmVB?=
 =?utf-8?B?ZlNXd093Q2wwU1VmMlV5WkhrdnBySVBEVUxlQjBFeFpDb1FMdVQ0YlZydzNK?=
 =?utf-8?B?ME1QNUV4YmRoaHd2RkpVNUxDdGFiWnpjUG04ZTFMd1FGc3pDMlY4c3l0dG1x?=
 =?utf-8?Q?68H+IBnOMaG26/laG+0OH5knc?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: jbtsoBkMsh1pEZwnUdRkyWPVXvlgUWZ1w9Dfq8avEdhhmpT9RtLTKyvq5ldjC0JtBkpQafVb/OtCcLnMF/5ifjPRIs8ASxYyPO84T1Wajf6majQyqM/ImmPxDN2n7pQNKwRcq+Lpj/YoNk10xkmnZDXqUgkB1SKR6M2lDV9GBYbNJtph8unMXGYI44cloTlyXjjVll8OWDmLK+pRyGzrUmqV0nPDumfpog4ZoJZnU9UGTT/NW+uv5ayhyjiRalSa/1a9S4P75OtGqAgGyfDMyTZfzfc5zE6bt1TpYZjhmyXr9g33/jvrm+f9huWl5si9Oxp9WqrFNo4dqcwd3KebIQz2xgxtziNcL5sKf6myei3LpVPKONPRPQbakREI5V84cQe7noEFkZGnjAiGQfAjvorEutr1nt+VtXnZSjIXpiIpJyCTut5p0uQD4DasVacU9F6oWIMri+K9vIIvlgM8KIiixKiE60J1D1YvyMKeSXA1JADippPqu+Gn2lG7PPUEBQmYW8IkallPq9GFs82U3nJ5gVy5DK/2qbC4d3bQpZt8dIwdM/zdBL7m5DWAMOS6h4BAArrv/c/2s1nj6i0l14UwOtxvKEivRL+y1c86Q5IR7++I3nMealEs23FZ25ECcFlTM1Ga6yO212hGqsvj7fHGoJmKqo1YZV2Am/cBSOFGAT2xruO9O5t90zMesVghu0RuZBGjbkjBWuGV6SxykvcArHBIRYtpd3WAaIm6MvB5bNfWe3SROJL2/+YDagW0wmbmOm63LFd9ko1l6F0A5tyct/07mUBvCdJZekNSMoiLPFiASAKDmD16kKtbHlxVNs6gy/W+6gvk0IcYWk8fva+EJ8uoO/DMcB96Sx649UP5Lrz3MjX9eqv21rSgJ3aXn1FixHPnclSVjaXSZP8iGloglYxpEXAX8UUttDdlpiU=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15fcf96a-2b0d-4473-f978-08dbd4735f5b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Oct 2023 09:26:59.1953
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Qr/TOUMNiWbSAv6lMHi/dDR/ApjNfu84GWIfC/4ypm3Pv9OJpf1YzW5qhBlHPd/AAJT/NA6COdNE+ZIKlN41nw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH8PR10MB6358
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.272,Aquarius:18.0.980,Hydra:6.0.619,FMLib:17.11.176.26
 definitions=2023-10-24_07,2023-10-19_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 adultscore=0 phishscore=0
 mlxlogscore=708 mlxscore=0 bulkscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2310170001
 definitions=main-2310240079
X-Proofpoint-GUID: Su_0CrMQJPSOCOmPZGDeaxe2Dg26ee7y
X-Proofpoint-ORIG-GUID: Su_0CrMQJPSOCOmPZGDeaxe2Dg26ee7y
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 23/10/2023 22:53, Bart Van Assche wrote:

"Add an argument to scsi_eh_flush_done_q()" - that's too vague. I'd have 
"Pass shost pointer to scsi_eh_flush_done_q()".

And I have to admit that it is painful to help review when only cc'ed 
explicitly on a single patch.

Thanks,
John
