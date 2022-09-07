Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E205C38145
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Sep 2022 20:01:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229593AbiIGUBQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Sep 2022 16:01:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbiIGUBJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Sep 2022 16:01:09 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81E2A9E12C;
        Wed,  7 Sep 2022 13:01:06 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 287ISVud017305;
        Wed, 7 Sep 2022 20:01:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=2bmhDwIgNSPV25/shPGKRfY5z+ZIlwI/JpK5bjv0mKM=;
 b=oGlvLAr3gSebQWuWjL7kjI3YC/DAUU9vD0f1XIvhS3CWJ71X3udjEAIX/u2USkBcJ+Gb
 U7wDcaAQhpwbjf5wyjGdQW5cC6OXCgh4/Yh6eeJjI96QuLQXCYBcx4bBM/wtJGBsDJPX
 NOqamjarDcLgR9tngVZh19YdEu4UFlnXPW58tvSHHarF32gZsY63u0FNISIEK7MhN79W
 snEqTXS+u9pXLGx7WVjrK9GHhUzedVgnIbw4je9K+ztg4/VF9VR88xHMmCeBPIwfgMiQ
 vrgkBG6syxolOSj29Kcvs0eAhsbofGdmiQMbbS9to9zgytSU2MsipY1mpdRaidnxHoMM pQ== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jbwq2hyw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 20:01:05 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 287J25rR033189;
        Wed, 7 Sep 2022 20:01:04 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2108.outbound.protection.outlook.com [104.47.70.108])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3jbwc49wy5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 07 Sep 2022 20:01:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gXJ7bWhUIGKnmLv9oxMvyAonTlxDUcrfp39PA9kxk1vNbo6F44U/zz7l9hZa0Wxl+B2nwOb2fit4pFjw3Y16nYRkqy2y6TnlClY5xI8hY2SQW5Y+bLR5jw6F+8F6ammLGh2UNDpWYc4sRF8f9/rHIGF5j8gxj3xXQgzmCxg/+oObrb674r4Ysx0K3DW/OgK/tlPz9oEoyztAApF5VXcVpm+Ekj7tXOPiyhomBGLes92/mlU4FGD9kYMuVyNn+v5x9SnKr7GaeicP+mREyP86twLMJI5QWEGgJSXTspHvc2zUp+5Gfc0rQ91Lhdi0buWH0j2td0+XX61qfgwsV6FHDg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=2bmhDwIgNSPV25/shPGKRfY5z+ZIlwI/JpK5bjv0mKM=;
 b=dZOAYCITyBQlJFpl9XCyNKb2kSULEceTaNWENhNBggalgCpFkHeko9XIFTU3E+J+Chk26V9fEMetEb5lio1AvTiQpHiGj/xvjiQOgBk64qk0+nXAi7acUNPf2WLKoYyol3e7DmH5NbTyqAJGtju3ukzQyub5iGufcJzU6cL0NZreRd2kPnCnCM2NrwheFZpYuOqQtfEgpnfeFU/Y0kymp19TdElYulESUskdHXZTUTpWmuaJxQAqpIxbM5tNqZBiw3p+Z2tNLWm9v7JT/WZ/t3c0CmJu5OsGrAI7ZhDcUUq5/B+1RNAHxmjk2DYMW11jg5ZUyJieHTsMJ5SWXcIvHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=2bmhDwIgNSPV25/shPGKRfY5z+ZIlwI/JpK5bjv0mKM=;
 b=kA/LBDGyGEwu02rIJgS8CNIySJJY34jp5/jB7Af1wnDj0nBRTOERsZPFMYvs/aCPm+iMVp5kUK7g56ntMaBdr+L5Dq2iRiTpgRNWBLc00c/7FWYKzDOChMs/X3lsf5ISicg1yupXmo70A5QSRNxcg8hQDDvt6CtgHQDpEDEYueg=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5067.namprd10.prod.outlook.com (2603:10b6:610:da::16) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5588.10; Wed, 7 Sep 2022 20:01:02 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::8dee:d667:f326:1d50%6]) with mapi id 15.20.5612.014; Wed, 7 Sep 2022
 20:01:02 +0000
Message-ID: <f85ec171-f3c6-cc14-daa1-84ef1b20898a@oracle.com>
Date:   Wed, 7 Sep 2022 15:01:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.2.1
Subject: Re: [PATCH] scsi: target: core: Add a way to hide a port group
To:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        target-devel@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org, linux@yadro.com,
        Roman Bolshakov <r.bolshakov@yadro.com>
References: <20220906074903.18755-1-d.bogdanov@yadro.com>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220906074903.18755-1-d.bogdanov@yadro.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR04CA0044.namprd04.prod.outlook.com
 (2603:10b6:610:77::19) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5067:EE_
X-MS-Office365-Filtering-Correlation-Id: f84e4968-7344-47a9-d7cc-08da910bb0a8
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oGDnj7CbIFSlHW7bkrrDxSx6pMFYZO1f2pDfasZwBXuMNYnGO1UtWKdZvblCBC4o2g05uiZ2cEFLOOBikyT/zntXqsQ2Av3Qud0lPvbuTNPzgMN+VFTzLWZ7p11mrNKDsUBEZT++G9icMPcOY6r2oQP8e0VWwvWt3AIKm3oquWU79z3kcz4aXbVdxxuxJub6nTCqQV9JQFhrrIOmgRaXICECaB55q8roeluWMxf9u1K8oZl784qWLpvcQHOxOOwHFF/cDPyUl3Woq6WgUVTnvrpcqRPJ+FCFcjcmpB0d7Rw68eF9OVJhR1LcpI+3SHpHCBZP7reLDmtlBeAxjTduAgSZEW5xmfJyGZHazNFABiR0booHAmQ/RpMf0fQfiYtBa9wHAg16AfZVFByjsltzrt9dr+H9lfKtO3mpfpTMcnquOy/s373T3LRE3ckDAITT2zpxFvbGPtMPZ43rkx60xSjEHfi72zAjcL50ff40Z8C2//AZpU3FJLTF/ff1d6z6VkYZRcbBNOWWqzvUIoBFe+Me/aKkdCtZpoBCFJ8zjoS7rnLJrmZmzP12Hjw/cOLWmcjEERJ4212RQb5vgQ5sUDKGa0OXI9jCKX5qKWvlczVi0BU52WAYOu0UZu+4bMMSNqIJKCi9+GAJXhYyxvCTgjI3RF9MHaNR4rmFVk2vToqr+PVsjQSu+AuQdxdZiwUr9Uz8hdCUu3u90/kbLn3LVV1uXaHA+W9ZPzYVZz3V20XLYly4p4WSPFHIGLfyTZlWxAuJLV8ytpqmtM8TDIzZ5rl2XeEBrUnJkxtco9rzx5WPTxH9uIHE4KDSryZtYi49
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(376002)(346002)(136003)(39860400002)(366004)(396003)(31696002)(86362001)(110136005)(316002)(38100700002)(2906002)(8936002)(4744005)(5660300002)(478600001)(66946007)(66476007)(4326008)(66556008)(83380400001)(8676002)(186003)(2616005)(41300700001)(53546011)(26005)(6512007)(6486002)(6506007)(31686004)(36756003)(43043002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?THN1T0RwZVVNNm1XdnIxSCtSa1U1TDR2alMydU9pYkhMRGtvMHJmcW1QWS9U?=
 =?utf-8?B?WmUzYnA0eU85bmQ2R1hQbWVxb1NtLzlvdGxTazkwTFAramdRYnFuZUlsMTcv?=
 =?utf-8?B?NjZ4dUdNUFowWmxZQWk1ZkpFa3ZwY1R3TlFmN1lwSzRVT2xsTkNJMGc1MmVM?=
 =?utf-8?B?YWVEMzVJWG0xMjJBSUNqR05xVGRieTNOeFhXRzFjMXNmaXdlTjRENjJqdnZk?=
 =?utf-8?B?elo0OFlaeTVxSUc3dDIyZG00bjNNYnoya1k4ak9MQzliekQ1dWoydmJTTkdq?=
 =?utf-8?B?K1lSRVVkcExiRHI5S3NkcEl1bjFMU0ovaHdFZWxqMURFeUtseER2VENoR0xr?=
 =?utf-8?B?aWVOM3pISERzNEpndUsrR0M5dG5ZL1A0NWxwZUZDM0VUQkJNczRIaXFjdytX?=
 =?utf-8?B?SEJva2ZnQThNREc4ZlI1R05kQjZ2dDFybFJ5WlUzNGtPSndOZVQwYzhlN3Zy?=
 =?utf-8?B?eHRkSU1Ba2x4bUZ1b2lYTTd4M3Y1Si8xRFVicnF2eEtGQ1QyanBCRXYxMlVa?=
 =?utf-8?B?b0tEYThNTXNIWHF3VjVYRytBVTRwclBEelFHYk1MTjFicEo0a1NRV2l2bjRW?=
 =?utf-8?B?K0ZFS3Z1dTZpalNXcUQ3SHpLY21CSEZqcVFSZWpSb3BGQTEwK09zVHJkd2g0?=
 =?utf-8?B?a0pudzV3RWludU01ZWtCWXVmcTd6SWtvVzcvTnA4b3Z3ajduNERidXNPa3Yz?=
 =?utf-8?B?ZXVYc2ZYL1o2T0t6ZnF0OElYRVhxa2ZGcHpULzVNVDkwdFcrTnYzUDRCVUhm?=
 =?utf-8?B?TmRtNllSdC9QeDhtdzl4SzFNenRFNmMvUjRkdGVWRTI1Zzc4OXFmUDNPaFBw?=
 =?utf-8?B?Qyt0RksrV2l5T282RWdzalBTZm91TkVEOGhON2h5ZFpXYWhhbjZhQ2pERSt5?=
 =?utf-8?B?SkxUZTFMSjhrdDhyZGlIS2xYaGI0SGxTYTRxRjVLMVN1UzZ2YnJJU3JHM0hR?=
 =?utf-8?B?N1VHZFdMTzdodkRPcStEN21RNFJLUUpUeElDdkxZMU9DSWp1WFdkY2hBakhZ?=
 =?utf-8?B?MFdrb1RvNDNQTzhrNE00cFc5V1lWeE9TbjR4UlFZMERKdjB2N0V2NTh4UWRT?=
 =?utf-8?B?dmlQbWNuNHNXZU1Pdk1DZGxUZVJIZ1JYZ0l3azduN1IxYzF1eUpGcTFtV3JP?=
 =?utf-8?B?R2E5NkxqdURnQysvczRTUjJUZldpUDlxcjlFYVhZdkN5bys5dUF0YUVoamxT?=
 =?utf-8?B?TXN2K2Z5RDQ0OXFqUUYrclVlbmFSTk5teTVMVzMrR0JzMERybUZBUkE2amk3?=
 =?utf-8?B?K2tFZDFhb2RGUTdBK0ozY2R0M0RLcTNtczZoWUExbmhSOXFyRkVMdWpCQy96?=
 =?utf-8?B?VS9qK1AwWTViTnZIaUt3TWxyZGhqUjlHMmZ6U1h5M2RVQ1VWbTFMSHRqMFpF?=
 =?utf-8?B?aGM4Uk1LMUlxK0Y4UVF4TTVzWDA1L1loYm9zUkw5bCtnU2hGTjJCbUdRWUkx?=
 =?utf-8?B?NElhSzlEWVpQZXZPYkpaTmxiN1ZIbGs1b0E0YnZPZFl1WmdxRGQ4VVBWc1Vt?=
 =?utf-8?B?a01zdUY4SE42WHlCbElaRTRhalBCRFRDMVNQYjNVZW9ORk9kNlV1bjRTZmJm?=
 =?utf-8?B?THA4NzNhSmF1eXB1b0RyblU5T2JEdDF3MUc2dnphVEtVb1V0MnYwcDJBZzM0?=
 =?utf-8?B?VnpTQ3JBamdjY3YwL2xOK1BlN2J2c0xudGtub25zZzFWc3ZyMmQrN0FzSzFR?=
 =?utf-8?B?WEJBUlZrYzFwaDZxZVVvVDV0ZEorY2dIdXJPOVFwdEZMZk45dU9LUmJ6VXNx?=
 =?utf-8?B?aVdpdS9sTzRVTGlxWFFSVUxYblFtWW5LWnExMHZhaXFDTXUxUSs3RVVBMmVM?=
 =?utf-8?B?QjNMZEpNNzdjam9kTUk2cjhWSGtGL3JFOFVFZWh6bCtSeFVQd0FMekxPWklo?=
 =?utf-8?B?TmNtSlVqYmtlOTBQN0ozMlVMY2Mvc0o4N3NLQ0FqT1p6czdKZ3o1ZktDMVls?=
 =?utf-8?B?UGJIc3dDMkFOUTR0cDVOR1hHTnY3cU5ucGF1eFhVSWM5cTc1bWZySVJ1SUNw?=
 =?utf-8?B?Nk9BUWk5cWFPdnpDNUdlMWs5bW1nZFYrM0o4VExVRiszUWljb1R4ek9MVndx?=
 =?utf-8?B?cHAyTmFJZnJXQlU1YXNTYXRvcEFwU1RiaGphLzdZZUEyckxsMitnTUFKS0pC?=
 =?utf-8?B?WG9wRGhDN3ZwYmNDYVk3d3UrRGJVd2NFUU9rUlM5SUFrc3lrbHZ5MjlGNkQ5?=
 =?utf-8?B?Umc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f84e4968-7344-47a9-d7cc-08da910bb0a8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Sep 2022 20:01:02.2744
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: d+jtbPMApxI64L6ZOuzfDriBptiwwltwDncDNVQL81BaloFs9wdbRfXgOfVo5V8e3AMPWu5qY/iDH+Ts6Nx2tToxjShdHq4KD/cfoASme0g=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5067
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-07_10,2022-09-07_02,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 phishscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 mlxscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2207270000
 definitions=main-2209070075
X-Proofpoint-GUID: maQ1nRtrUZlyCOJGi0tEJsJPnfe6m2YG
X-Proofpoint-ORIG-GUID: maQ1nRtrUZlyCOJGi0tEJsJPnfe6m2YG
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/6/22 2:49 AM, Dmitry Bogdanov wrote:
> From: Roman Bolshakov <r.bolshakov@yadro.com>
> 
> Default target port group is always returned in the list of port groups,
> even if the behaviour is unwanted, i.e. it has no members and
> non-default port groups are primary port groups.
> 
> A new port group attribute - "hidden" can be used to hide empty port
> groups with no ports in REPORT TARGET PORT GROUPS, including default
> target port group:
> 
>   echo 1 > $DEVICE/alua/default_tg_pt_gp/hidden
> 

How about "enable"? I think that fits how we handle other objects like
targets that are setup automatically but are not yet usable (can't login
or reported in discovery commands) and devices we have setup but are not
reported in commands like REPORT_LUNs (technically you need to enable and
map them but you get the idea I'm going for).

