Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5D1DC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Nov 2022 09:35:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231440AbiKGJfs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Nov 2022 04:35:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231218AbiKGJfr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Nov 2022 04:35:47 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51715C10
        for <linux-scsi@vger.kernel.org>; Mon,  7 Nov 2022 01:35:46 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2A78ua6b012294;
        Mon, 7 Nov 2022 09:35:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=QRu0Fa9iYh9s78tNkLV6faWq383EH8LhNwL1bALhGeg=;
 b=ICLu0A4WOU2H0xTc2My4ZkCv4E3cSiei+SV6vcfu1WOPnkYosZ6nOHictfizwuZ8BjI8
 bfC2yNz4pkgDs11dWb4/R92t0vWQQno+YtRut/0tFsvOmazpGIO2FBxI9Wo+Cj3Jm4xm
 vWE51VNIpTfu1KLw8iENCeu8jLRTYW2I0DahmijmBVxYOp6pzVRHjeLu+WZ5mPSxyP6s
 fAO2kkE8DQN++4fYwOlCbavBBmj0obpgO10pVhFHTBrhHC7aw0ueLuPgM4rG4vFFzloY
 Wv1X/TrcqwNQkNurqkO+3DmfeNi2zGKDo7pv9Ey05UnzQwnwex96hccXVSFqfjvLeBDf Tg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kngkfuanw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 09:35:40 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2A77hh7R015075;
        Mon, 7 Nov 2022 09:35:39 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2169.outbound.protection.outlook.com [104.47.57.169])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctauh23-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Nov 2022 09:35:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=N+JMhsZWa7ixmPDnGySCWIwa5SPYNamoHycsfQ6mXbb66B49stDF3h4OaV0bRxa2gI9xG9kCBGMzQ8TziSPylO9fAZuw6VZTP0R2eOla89j6MNJlM6ik0SQG5aSIMKIeF3pWqX6dAAL7n8ZS4sqjJDt+48VfvZRDTSxstr2Hbbrh3YUpItNpVj6jr9L+ksHwiX/ZDHIjH3APDBa7jy1qSQbS8nq1c8s5b1VKXDa7wztzOnU8Mi8X4bt57IOLBNMGeDqALkkcTt9Npmsesqf+3jWoL/2sdyqSdvfAJmZhXODlSUSgt4FrYWew8b3bLB/iwYgwLz1L5OP7rzqK/nDOCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=QRu0Fa9iYh9s78tNkLV6faWq383EH8LhNwL1bALhGeg=;
 b=U2niOtpw77Po9QqBxiSBPEtHnEfbZR3kNbiYNZ7RZfhI66/HA67MTviRuyko68slb0nHLndkykpQlWe2IQfmpivAmp5VgeZ1OTqN+zZWoVKtyxJtVC/3qqvH45hj3yqX5Y0AZCUenmk8YNhUo8xDnZep/cRFsbmsvHHsb8QJQm7h0ztWDGjkbAp+BOqhm8x7bhy+M/vX/Zz+c0ZXPkX+NklOqtsh97f4lM7EkJyvVLabiP84mC5WYkxvvdwPVu3RFJGz5fQVJqvhEmfRqgdKpITHzYERCmWm+9DxW63EkDbhdKI6FyxKljuhARmtDrl8Iz9NfjiX3IA3UMvkQq339Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=QRu0Fa9iYh9s78tNkLV6faWq383EH8LhNwL1bALhGeg=;
 b=0QBCNror5aofxuM6Go8OzV3LsvgvXPLHuKNycOp3LEE8gjWPPDF1SVnACvLm2l4ADN1ZoNN2aHQW+GZkXbi8Ft48w6uyvVlP0FySyyDRmLErDi42TvDU5E4cgKtqoG7YEetJwTo/Qx9aCDuBVkMHBRydQLiKr6Wa5oipj+eOxF4=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6068.namprd10.prod.outlook.com (2603:10b6:208:3b7::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.22; Mon, 7 Nov
 2022 09:35:37 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::d0c4:8da4:2702:8b3b%4]) with mapi id 15.20.5791.026; Mon, 7 Nov 2022
 09:35:37 +0000
Message-ID: <5ebc23f6-0043-4214-5b2b-43357f106fc7@oracle.com>
Date:   Mon, 7 Nov 2022 09:35:23 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.1
Subject: Re: [PATCH] scsi: libsas: fix error handling in sas_phy_add()
Content-Language: en-US
To:     Yang Yingliang <yangyingliang@huawei.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
References: <20221105071725.2313316-1-yangyingliang@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221105071725.2313316-1-yangyingliang@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI1PR02CA0049.apcprd02.prod.outlook.com
 (2603:1096:4:1f5::18) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6068:EE_
X-MS-Office365-Filtering-Correlation-Id: 43b713aa-3525-4124-48a1-08dac0a36d4c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: FvZpjjZCJdzFNQujI/SPzXWpMaDVcBVL+FwQskmkdm960e0bj/c9ocvm4Gl5U2hI1t+b08NdJoSIob+bO2y9XKlyYFAPdY0Cy3FxSbBzsfpq7sBVVseAMw8OxuFIvpBdLa60nKwSqAd7QZDJL/pWyBH7bOPATEQKwQ+ar3sWwZunC9Ttc7JOm69XSvewPd8fW4TrkRTCNsyTYWlp+5gui7OeM+US/8AfckGtfq4/t47I9F+ZICjTzdV/3O02wRHHbnVQGo3i0/G93j1P3QrefnHO+gVSz61Fm9r/imklLvEfks8eXU1KbuA8WffPdhGMXzVX1A00Z8abZ3Ts7VGVfeBPsTKHF/crOYJFCD1JSbmJfyNkdqzyT1xiwhxuVbRJsrORYc77LC7yZTpSwuuRFM0Zu9tEka3UfSv+1OQmVLjX9OTgJRJ0HF13RZACd3FYmIbWMwQSfhqKU2hK1FfrGLs+CZitirpssQQUnYZmO5AbDIsLmy7i6S4t1tqiTnVBafXqQAjzfZnjUqfxisVPFMRhkoOlwfur3q0nftAy1P6++WZBFl2PswKQmQIirnjQucEXFDxH/DFAb7N04CjE12EkEAemIYTpA0x9iIWx2p9mH/y0Y0ad71mDM9pV+HBngfVFexaIX7WJH5YuQAUeH6iQHUsTo2+euENky2fcExY4wOJEfoGg6MkOMgMdtv/Wn0AP17STfb5CVMzQj4SKjb/B5BA/8VfklZipzMe0SjgTsI/8+MePoFfkJr8ggpjD3FWKOVTXrR8GbkIMU8NvJDGtJE90zjLchPoFWZb4Yu7PUlgC6zUx5Mz+NFAOhNd/
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(396003)(346002)(366004)(39860400002)(136003)(451199015)(6506007)(31686004)(478600001)(316002)(966005)(6666004)(107886003)(36916002)(6486002)(8936002)(2616005)(8676002)(186003)(26005)(41300700001)(36756003)(4326008)(6512007)(5660300002)(2906002)(53546011)(66556008)(66946007)(66476007)(83380400001)(38100700002)(86362001)(31696002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ZjRZYU1XWVVDREhTYVd1VDZ2aUs3aXM2eVUyNmR0ejM0QnIyWW9OVHJZWStQ?=
 =?utf-8?B?QkxEWnNBb2x2UC9valNWRHA0WG0rZmFxNTlMUGdsY1VDemM5cFpEcGRPQ0Fo?=
 =?utf-8?B?ZVhTT3U2YklSUW5OdGVYalp4QTF0UXJlSnNwWFQ3Q2IvaDlIMHVsUXBuZ0x0?=
 =?utf-8?B?NVhNQWxIVDZvdDI4dzF0TlJyWTNYNVFWR3VCU2c1VUJiN0dvdjRTUFZpVEZw?=
 =?utf-8?B?NEJwOWZHQjF1cWYwNFRCTzdqajRzQ0ZBbTBYVHBya0UwZ3hoK3NZMko1a0hn?=
 =?utf-8?B?dmZwYjUzZk5xbVcxcGpNcjA3OVF3VjEyV0d1cHEvWFYxMERYYW9WRnE1ZHFk?=
 =?utf-8?B?RXZSYlhaRkNyWkdsV0hRcnJ1UHc0TTFibEE0eUs5K25Mbk5NVitxRTVqcEFL?=
 =?utf-8?B?elhGeGVhZlNmbk1WT1h3amdOOGE3bGkrd281ODRVWWlEM2VYaEVjNzBRRzR3?=
 =?utf-8?B?cWI3Y0lrY1ZqVTdoN29rbjIybURNR0NJelN4WXdid3JvK29OSWI3Si9URi9I?=
 =?utf-8?B?WkpTcTJRTEFDSlJDUjZ6c1RuUFRHcUluc0xEODZrdnZLUFg5Z0tYL3YzZU8v?=
 =?utf-8?B?KzVsYi95ay9qaElCVWkyQUFlSEFWbXpaSlVrV2ZvMlJUWWw4ZWdWdFVqTVJx?=
 =?utf-8?B?TkVRMTFIdUhPSytFR3lkUEVMYm9HOTNJN1d2NGtmYkRkOHZFRk5EUTlHdnhk?=
 =?utf-8?B?Uno1NlJDdTRvbE0wdmh6N2RHRG1IWk9VR2dTenluRzdER1o0dEVpY3N0U3F6?=
 =?utf-8?B?eUR4TEt2STFSRUtBWWFHYzZSQU0vaWdTZ1BrTUNId3M0emtVNm5wbGVZbmVk?=
 =?utf-8?B?K29FcGQzRlBMUE9GemlCTm4yaDllWWVKa0hYeSsyTDN1N0MyMGgrOHY2MEVj?=
 =?utf-8?B?dTQvS1ZaWDJrUzZDYzR6ZmxkSmRPZ0Z5ZVNKNTU4dmhsQk5waDVKYm1TbmYr?=
 =?utf-8?B?NWFlbmdUZEd4SnE3dEFjTW0rTGprWG5BdmhTSWtLeGxibGQ4TzZIWE9EbWxl?=
 =?utf-8?B?U0RkYkh2T1ExMjlsZjJDcG1TaTV5VHo4REZQdThMbkFaZDFlS05TOHgzTGdV?=
 =?utf-8?B?SVlYZUlMTkFIdGZkenBUSFRNN0VVOTFPWVppTndYSld6dlpyblBqNzBNSTJ1?=
 =?utf-8?B?MGYrMXdPS1dodStXL3pzVUlqRUppdFhzdGhjMFc1NytwbWw5R0xRM01kMVIw?=
 =?utf-8?B?dE9XMnA1bTUwV1ZGK1lQTWR6Wm45aXlWRU1yTGRuVHZHNXlvWkt0R3hsVjha?=
 =?utf-8?B?ZFNNM3dpMWYyUTZ5VVBxWEdaSTZldVVRWWpPdUhteHpvaUJQSGdkTlZWNFRG?=
 =?utf-8?B?UFdZWkRENndXa0tCRGgzMzdGY1ZRbXVJbmxiUENSZkNMeGFZcjlnckc0dmYz?=
 =?utf-8?B?SHRVVTNGazV0a3NEN0JkMUhweEMvT1ViRVFDVVhaLzVCTUE3TTI4UlYxRU9U?=
 =?utf-8?B?ZjhQMnlZVmtIcytTTE5qSjBIeXhzMGZpL0xhNWZGb2JoRU1PdGYzcFVCZnBU?=
 =?utf-8?B?ZlpvNmFzKzhtcy93OHE1VFVLaHArbDhDVlBGM3hIT2hac2kvZVJOSGdycE1L?=
 =?utf-8?B?RnVIT2d2dnNGdVNtc29QNlNreVFDSWd4bDR2RDlGajdZZ1FXNTZIb1I3bk5w?=
 =?utf-8?B?WFc0aDAyR052VVhsODdMRXFCVVBmOHNpTkxVVm5Lb0d2bmRBK0ovTUtscDRy?=
 =?utf-8?B?OUNOTFVVRTNjUDhIMlZlVi9wK0tKU1RjQzIzRGVKTHdzL1lFMWRuaWFUTy8y?=
 =?utf-8?B?aVkydkFiK1hwM2o0UUl6eHdOUm1pa1pTbUg0THB2S0pWWVlGZnpHRmxNbkUx?=
 =?utf-8?B?TGtiK2JKbmpiY05weWhJbFVqM0ZMSXhWa01COXVMODJWMjRUbHdubG5Ka3Vs?=
 =?utf-8?B?WG5GRDUxS21yL2FwazFHVjJvN3p4U0RqT3YwNVRERTFBN2d3MzRqODFRSk55?=
 =?utf-8?B?anQxZmhYN0k4Snh5RU5GSHVTNUVJRUM4VW8vL2xTbFk3VkV0TWJkZ01FMjQx?=
 =?utf-8?B?QndhOCs4WTY2Y3llU2xMZ2puSm1wd1g2REdabzQxNmhSZ3JJUGgxb2plVlFT?=
 =?utf-8?B?dzYzbHljb3B4cmN0SEU4T2F6cE1VQnRuVHpGdVJvSWNxRTdUOFBBQjNHMlhJ?=
 =?utf-8?Q?S7EuZWELiqNjCyVsh1HbOQTtK?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 43b713aa-3525-4124-48a1-08dac0a36d4c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Nov 2022 09:35:37.5546
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: CeCu/yWeG3zctcvgaByJAiOFrCpn2u65DCgqWjabPLPcmfGuclcBGAMdvbzpNkG66JkqP2vWBSL5OOGkkI2Gbg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6068
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-07_02,2022-11-03_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211070080
X-Proofpoint-ORIG-GUID: EoYzkhdqgbedKAx4QR2RzGkrE4x-eGVa
X-Proofpoint-GUID: EoYzkhdqgbedKAx4QR2RzGkrE4x-eGVa
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 05/11/2022 07:17, Yang Yingliang wrote:

This is not libsas.

BTW, before I go further, note this:
https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/Documentation/process/submitting-patches.rst#n312

> If transport_add_device() fails in sas_phy_add(), but it's not handled,
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
> in sas_phy_add(). transport_destroy_device() has been called in sas_phy_free()
> in the error path, so it's no need to call it here.

"there's no need", rather than "it's no need". And I don't know why you 
bother even mentioning about transport_destroy_device().

> 
> Fixes: c7ebbbce366c ("[SCSI] SAS transport class")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>   drivers/scsi/scsi_transport_sas.c | 7 +++++--
>   1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/scsi_transport_sas.c b/drivers/scsi/scsi_transport_sas.c
> index 2f88c61216ee..cb364a7c6097 100644
> --- a/drivers/scsi/scsi_transport_sas.c
> +++ b/drivers/scsi/scsi_transport_sas.c
> @@ -723,8 +723,11 @@ int sas_phy_add(struct sas_phy *phy)
>   
>   	error = device_add(&phy->dev);
>   	if (!error) {

personally I think that the following looks better:

int sas_phy_add(struct sas_phy *phy)
{
	int error;

	error = device_add(&phy->dev);
	if (error)
		return error;

	error = transport_add_device(&phy->dev);
	if (error) {
		device_del(&phy->dev);
		return error;
	}
	transport_configure_device(&phy->dev);

	return 0;
}
EXPORT_SYMBOL(sas_phy_add);

> -		transport_add_device(&phy->dev);
> -		transport_configure_device(&phy->dev);
> +		error = transport_add_device(&phy->dev);
> +		if (!error)
> +			transport_configure_device(&phy->dev);
> +		else
> +			device_del(&phy->dev);
>   	}
>   
>   	return error;

