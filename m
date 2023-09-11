Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8BBC6EE3F2F
	for <linux-scsi@archiver.kernel.org>; Mon, 11 Sep 2023 20:52:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237739AbjIKUvm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Sep 2023 16:51:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236248AbjIKKDy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Sep 2023 06:03:54 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D43D8E68;
        Mon, 11 Sep 2023 03:03:48 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38ALFS3i026936;
        Mon, 11 Sep 2023 10:03:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=hhjmYyK9di0RehQs7ZLN9XXddexC0VNbUATp+fxE1ZI=;
 b=tlBPO958QErjT7WdrixzlCOlcb0mFk2eFGvAG8xT0D+u3K85aOqAq2+RbdLNfGXNi6um
 zZI4E0bFsjpwyZQ0tr8ilr6+iIqY+p2Sx3iQkD/g48fZGsXq1mBpbACoSGKgi74Ply+C
 pKBFjyFEfsNgdgQ+JXBXg9FaV3DH0VFREB8ggjhIv0cir5nYvGmG8dqNTvobQTnqQDkj
 9mvT0bUX3ox42SotnQZp9BlrjvBbA9FXI55wW4qyIFBI3JwCmotaenzmpBwWKosq57pS
 fiNVhqPL8+rnL2xknqWx0Prw6mSn6hmj2Rlzd1rdjbf2MkPJiESosDhh4cscSrE9xmjY VA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1k4c931m-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 10:03:27 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38B8oWm0014731;
        Mon, 11 Sep 2023 10:03:27 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2103.outbound.protection.outlook.com [104.47.70.103])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5a8805-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 11 Sep 2023 10:03:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Gh2jI8W2PmXWGGXptHK3appiquGsqzwW8qeyvgYbpCJPXG7ishZz/7S+2sDAIO5nJ+foanvfNIp2NoR31SyUVKMqaj/lpYCMaZnFKBtm1OxG6O+0Fh20Do1kVIs7okbdQ/fqxfp1Csa0R6hbuIl6w7QkccKTjmzjFl0zSQIWpR7NL2lhasB7pWmomvQDwc/SQVJsdHQC7XLCOeR/cJZloZrq082q5HnN6y0lEgzR9VnhaUjL+5n6zzX8LLg8zTuPoovmzpK5EH26lzJgGW8Xi7fWrZFEmgsBq6UVi1PFFAWp+evLp6AJDkBdQDCtfH1itShicShpBFzLae24bPEZrA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=hhjmYyK9di0RehQs7ZLN9XXddexC0VNbUATp+fxE1ZI=;
 b=aUcL5WxBm/IHpAkF5AElosXYzprkAjdeZpbbEvHwnaS+1wbhWkPsuxYPCGmQQgpXEQbw4KpT+NYAdQoDgeeool2/USUcyzDh1tiimUe+8/s2IRDBVN0PJwc8DxGGO3kD/RR+9liGgX2DjOa4dU+6l5o7u6BJMXb5kghWH8mEBEU2HQMTqcHVqvm3L+VF+6yLP437gjPVVRBL9y2IykgoPe55vWGj+ti6z8KfdDaQvzsYlbhfsc2qSD3b5+qF1LfMDjEb9zbKE2+lNd8a/uzwR8Uc8jZ0SKCN4VXUNDKvGczLonF6Cxmh1qmTZ92cgCpyLd8fNVQJNeuqyITnZmo1gQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=hhjmYyK9di0RehQs7ZLN9XXddexC0VNbUATp+fxE1ZI=;
 b=iRQyJiAcldB8CMnJvf63b6qMbu2X7M8Ro3q8vCIffHjCfyB/z7cPID4lvASLdNlyktdqYGnPEdS6lBw39+3TCUPWIoNFSKDdU0p/vfQw2AviIFtyiqOGF9gddHk6qS1bChyRZDkeY51YGXN56WCOvr2KEQh0QdAjE2FfscWhvHs=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DS0PR10MB6846.namprd10.prod.outlook.com (2603:10b6:8:11d::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6745.36; Mon, 11 Sep
 2023 10:03:14 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.029; Mon, 11 Sep 2023
 10:03:14 +0000
Message-ID: <3dfb72e7-97b7-7366-778c-d53b6441c553@oracle.com>
Date:   Mon, 11 Sep 2023 11:03:09 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH 17/19] ata: libata-eh: Improve reset error messages
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-18-dlemoal@kernel.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230911040217.253905-18-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P265CA0304.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:391::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DS0PR10MB6846:EE_
X-MS-Office365-Filtering-Correlation-Id: 3ddbbbb1-1ed5-4c94-43d8-08dbb2ae5029
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: dEdC80F/Z06BbV6EZ50Q3DGpfiWegEXap3RjJTHUcwRBgCLr0F14wMkowCCmy00zdjbkQcc8PZXCh8m9QzDtY131qJXy5Nai7KXpWGe88st5N+b7Xof+QaVXQH/u7Pu9JxFPJRLH/BSg9pfL1q+erIEpGLH/zESvZsQCDvpaW3MtEW+ICPZVIFsVFJ7AhCvNbWboBwj2oyNizojlM842B1vATvvpbSYC4QeraJRtwgZwtJJ89SRFbqn3CLXawbJAZ+ha8aOceimNZutjH7MjyfE5kEIAGGr5YH5F9N3DRsWObwzaXJzLONzkGGfikj8jUjrl8AQsDV60p93ggLcUIiX6GPFO/8OjWScHqj28mxAiNBPPRxCwLvvPcA3ZX9m2tZ11sEu1ywkdOfRsojo5kqC1kOGRwpr3cU6AIKATtNUjV0uEy1Uq3pD8C39CiZjgcFGSdRoTcKJHfwSjkzn/tbhw55moLcXK4lfG8kBtCF3UC9rucW3oUWVMNR1Po73CjMJcbRvB3mEvbK8T66ZwJUW/A84kWWotIFOigJUAmxtsnffxn9qTBUe5Q99PBbGzBPvhEmqyPxrKangN7U5G2E4PVr2cW2pIxkaPDKqPMbN+uJqv7H7pvezHkWKVmDJNdI7tTkSog5XL5fRK8oAvBg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(39860400002)(136003)(346002)(376002)(186009)(451199024)(1800799009)(38100700002)(478600001)(36756003)(83380400001)(53546011)(6506007)(36916002)(26005)(6486002)(6512007)(2616005)(6666004)(31696002)(31686004)(316002)(54906003)(66476007)(5660300002)(8936002)(41300700001)(8676002)(2906002)(4326008)(15650500001)(86362001)(66946007)(66556008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?QmxtUTJ4eUZMUG5IM1NhODc1UjZpSVJwcTFSTExyWlRIbGlkaHA4TVVNTnI1?=
 =?utf-8?B?OGtOYzVDSFEwQXV4dEIrMTJPZzhzdytOYjVnNGhhQlAraEJJSlR0UGk4cW1E?=
 =?utf-8?B?aEU3bjZqdFVoQVZ5T1FxeXo2Zk9zOVl3Y2M4NjczalVXTWw2TjNWVDlGMjlw?=
 =?utf-8?B?d1hhaWNoYWh3NWw3ZTZRRG1yWmhRSmpIc1EyMWkrcEZUcVVJZmFQVjNDb20z?=
 =?utf-8?B?Y08zdktJblV1R1JKQVJDbEVyblFacU8wM0h3NHRiNGRtTEhHVXR1TFJlZWZ1?=
 =?utf-8?B?R2o4bEFlL01mRUZZbWFUbmVObHo0R2MvUlVJeVFOMlVZL01ISitYQzQyL2c5?=
 =?utf-8?B?OGJjTTdpdHNEQVVvWDR1VlVOaTVZck00UXZRdU5zTTlWRjBBZlRvbUg1WTJG?=
 =?utf-8?B?Mmt3NXJhUFFWWUNUVVkxK2U4a015RGhMekNwYWlNNVkvUG5wMStWZkVPS29Y?=
 =?utf-8?B?VkMwZG5nVkFJS2JzQTR5OUdaUFBxWW9uTHRTRHZtQnRPYU92bVpYVjhDd2Rp?=
 =?utf-8?B?ekFIajYzWmdUTDFNWDUyVEtDT2hLQXVKTlhNLzk2ZUxuUTdXa0pKdStWUWpj?=
 =?utf-8?B?Y2ZTY2ZMTFZCazlsUWFaK1FuS2VkMG5SRWNYcWNmSG9IQ3MxOFByV2c0cXE1?=
 =?utf-8?B?eXhRWnpSVkhiME9vWXN4SjkrY0dVOFZ6dnBoUnNNNzVtQjE2MTZMNHFRTUUz?=
 =?utf-8?B?c0NYaUlMcFRqRUNBd095VHdTTjNYdjludzNyc2I2bkJNMDNqUnI5ZUpvSVF3?=
 =?utf-8?B?Q2kwS0pQaExueG0vaUNvakoxQTB3WWVPVE1PZlBQL09rbjl4ZHd2MDhBanhV?=
 =?utf-8?B?TjhodzdxWWt6a1lielNDaG1LQ2J3VUxvTHNpN3dQUWJEN0Y0WmhOVWF3RjRW?=
 =?utf-8?B?cW85Ri94MTZMTEptaDFQcHVLSkwzeUFsSmR0VVRicFBOSFNCQ3dDNmZ1UnMv?=
 =?utf-8?B?Vm9aSDhKZGp5Sy8zazN2Y1o4c3dwZWVKTjJvTnMwYy9OTDVsL0JPVkZiNWZh?=
 =?utf-8?B?QTFkMUZKNEZyWVFvMDlsb2sxZUVNT1BkcmlmWC9VOWpBdjgyV1JxUkloRENC?=
 =?utf-8?B?bUZjU0Z3MVB6c014UTVHaUZwblRROXRLTFdnYy9CT3E3ZUhvemE3RHFZb2R1?=
 =?utf-8?B?dFpMSWJTdkszWTZNTmcrRG45ZFdJdDNsd0lKaVV5RFF2Qm1SWm96THZ5VTVh?=
 =?utf-8?B?WlFkeFQrOEE5RWNiaU5xN3h3NEplL29lWTkwK0prdWpaTW52Qm5aRjd2cUgv?=
 =?utf-8?B?aitIOThsYk1obUhmU2gzSmkzTURoYlQ3b1lVcituWmUzVkV5bStUcTVlOXRG?=
 =?utf-8?B?MG5oZmRaejNjY3hPY0R0TXVlK2o3cjVuZmxVa0VmcnEzSDBGRHludUl2RmhR?=
 =?utf-8?B?ek1kejVNWWR6aUJvNVVUQWR5WEoweExtaTA1Sjl6M1hFbU9BaEdoaEdSUWpD?=
 =?utf-8?B?MkNvQXRKaUhsQitRYXp3ZDNDVkUzdmFOeTk2VTlaTUErTjROZTNkdjg3M2wy?=
 =?utf-8?B?UDc5eDdMSklvYUtESzgyUzdjZzJJN3RYanhnSWpvNk1QbVdlcmtQeEd4VUlU?=
 =?utf-8?B?cnorclNpMFdEUHpva3FuaVc3OGhLRTlHNHBldGdJcjRyZUtCcTExb0VOcDJ3?=
 =?utf-8?B?OGFTYnR6S0RjYTUrVyttTXJ1TUlOdkdOZ016MkxTYktmbW1SRmdyUkdSMVkx?=
 =?utf-8?B?d3Q4VVdYaTRCZmhDYnZwZlRYR1RVNzZYc2piVWs2WkVIU0Y2M3V4WDhoOEVw?=
 =?utf-8?B?ZEFKZmJGbDlZYUhJSENGbDBFaVBPQk1wckJZLzV2UXI4RXJWRFo1dUV5bW1C?=
 =?utf-8?B?ZENFcHEyWGExL3RFRmpHUWxmdERteVFwTTRFUFdHK0pmNFNVQ2s4bXdBYVJI?=
 =?utf-8?B?TmJKRmpFV2pBWjB6WEQ1NXBhYTdabUNkWEtmQnYzZTcyaVFBQmFFZlRlSWNt?=
 =?utf-8?B?bWgvb0lKODc5cWV4c2tRbENocnlraHVwM1Z4TTU4NEp6S0lvWDI0VHJyQUpm?=
 =?utf-8?B?THNvOHNrVXNaZnNpZXY3cWErTyszZTNiRmtTRS9TZGd2UEVNSCtBTVh1Wjht?=
 =?utf-8?B?d0p4d3Vtc2cwTWpVOVFzNHZSczVMWjlsYklFenIwZXNRUDd5bktnTlZremdh?=
 =?utf-8?B?Rk9MYUtRZ0lRZDhxeE94dGY1Y3VHbUZ2N0tkY0Z1by9CbWh2WFA3WWlVWEZ2?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: s7R+mjICRnb6bW+d0mm07aCz8q/pLwOex6nBVyvomM+lX96Dh7mLeMTMX7aZ53lvbdP4bn/TES1Lh605Eeu6zjO7aP9KRTRvGXbRqmSqkeUkiKmIJO115p3Yeeu9dNnQz7IhIEVFoLbELBoehFuxG7hcRL5eRi7h2d1Jh1oqeV/wOYk/M2TWU2XM+Za8SHvOlj8dWdkQeptYsNKEYG+mk/uk3zDYQcC5A8rZa72u1OYzuP9q8CQdP1TIVcL15uKpghtaONNavohWrrkxFZn1Y5hM4lkGVnzZ1Y74ZRhbAQ9uhVSvfkq3fVRSiWjjX+MXicahY6vP31L7JbzG1D8Fuk0SIAYqCjDSghpRAArtn6MJLyBWAirrdRTdfC4QgMlMjoxUDc1VtBKybkk/JTYFKsh7tSkBl3FYTIJuFR3GxtHcoSfg7ms8FzQJK0KKbGM0Y0OXMk76PwTC9aLlzklh+w01BRaL1nc0l6g0crQm7Qcw1PqwGbWl/iA4Ala6ViGWHBH0SDNW3dfstCVNmyHj3BGUT1E5pmhtEZmt9DvGF0B6zry2mn5FYs14Sap14hiIsOs9n/jhLwj5+7rfdkwXwwwmuXYJxZRkqhYRJkzUBwSUGpcXsODlOc28UksoZ+Ai32zXw4+luP9HmWUb8y6nVtwSBxl7PN144AwrBSRFXrf/VXGZgoDu1MXe9EODctjNhScxfRAmujvzXakNaiP4VzqveQNj0wibxrxYexnqacDE06/pDtU919/HqQN74pJ4RT6HBmJ93LCtyOXSNEwRCQ/Ma3yv2G938zTvX4IjZhGUR2cU6YAY6PQljfcN7In4/Xv5/dOPp4M7D2s1QDzH4b5me9NFgsnD0hb0B2W36190Y8CJusbzRhleop5B8qkvoGDC1BM/VNu1vQP4FitvIXTqulua3R+QD68gxJ1flt4=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3ddbbbb1-1ed5-4c94-43d8-08dbb2ae5029
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Sep 2023 10:03:14.4843
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XwU3lP8ZbHtORH7+PdfRNBE4TopHG740ijt0oIgLVe5z90tX8kqxCGhBpSyXlYlauRWZ6DItsJ6XNZKjn/K3cg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-11_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 malwarescore=0
 mlxlogscore=999 mlxscore=0 spamscore=0 adultscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2308100000 definitions=main-2309110092
X-Proofpoint-GUID: foUJ0-XiowzhAeT9nPoIrpUxzgHf5-Ef
X-Proofpoint-ORIG-GUID: foUJ0-XiowzhAeT9nPoIrpUxzgHf5-Ef
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/09/2023 05:02, Damien Le Moal wrote:
> Some drives are really slow to spinup on resume, resulting is a very
> slow response to COMRESET and to error messages such as:
> 
> ata1: COMRESET failed (errno=-16)
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata1.00: configured for UDMA/133
> 
> Given that the slowness of the response is indicated with the message
> "link is slow to respond..." and that resets are retried until the
> device is detected as online after up to 1min (ata_eh_reset_timeouts),
> there is no point in printing the "COMRESET failed" error message. Let's
> not scare the user with non fatal errors and only warn about reset
> failures in ata_eh_reset() when all reset retries have been exhausted.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
> ---
>   drivers/ata/libata-eh.c   | 2 ++
>   drivers/ata/libata-sata.c | 1 -
>   2 files changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
> index 43b0a1509548..bbc522d16f44 100644
> --- a/drivers/ata/libata-eh.c
> +++ b/drivers/ata/libata-eh.c
> @@ -2919,6 +2919,8 @@ int ata_eh_reset(struct ata_link *link, int classify,
>   		 */
>   		if (ata_is_host_link(link))
>   			ata_eh_thaw_port(ap);
> +		ata_link_warn(link, "%sreset failed\n",
> +			      reset == hardreset ? "hard" : "soft");

nit: how about spell out the full reset type string

ata_link_warn(link, "%s failed\n",
 > +			      reset == hardreset ? "hardreset" : "softreset");

which may make grep'ing slightly easier.

>   		goto out;
>   	}
>   
> diff --git a/drivers/ata/libata-sata.c b/drivers/ata/libata-sata.c
> index 0748e9ea4f5f..00674aae1696 100644
> --- a/drivers/ata/libata-sata.c
> +++ b/drivers/ata/libata-sata.c
> @@ -608,7 +608,6 @@ int sata_link_hardreset(struct ata_link *link, const unsigned int *timing,
>   		/* online is set iff link is online && reset succeeded */
>   		if (online)
>   			*online = false;
> -		ata_link_err(link, "COMRESET failed (errno=%d)\n", rc);
>   	}
>   	return rc;
>   }

