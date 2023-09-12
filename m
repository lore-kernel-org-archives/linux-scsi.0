Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0A09FCA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:19:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231894AbjILITg (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:19:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231868AbjILITf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:19:35 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E493D98
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:19:31 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7f8Kp028374;
        Tue, 12 Sep 2023 08:19:28 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=joU8gBC4b/KtW53DQa8zhu+7TLY+hf0kAAmwgwgppzg=;
 b=acxT5CntEre59V53APozVah/NOq2sxysCWxQO82qnxRvu/4bwyrBA/ktN/SGX/ikpyCQ
 8P47R6v3tja60pscgK0Ac8934+x8lRxjVVg/MZOw1ugKcExdoQkkufOnU7zKXrrMT/Ue
 67Y00IrmB8j+7+4FzwxdBh6It2gqJGck16K1wTU7K39zc4/I6s+kM1TVukrBYzRUlx0+
 gc4c/5YBBrl/ZS7AYaW3PccBvhbrfP31u5NkYwvmJVu5du341ktdecSu8KudTNWmQRnp
 1/mh/d+tLrTtsikBQx6c50UmQ9+EGRf8peqcC6gxhg4o9r4nn1kx4Q3aZRkwui8Ideam pg== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1jp7bcjf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:19:28 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C6CNvq004559;
        Tue, 12 Sep 2023 08:19:27 GMT
Received: from nam04-mw2-obe.outbound.protection.outlook.com (mail-mw2nam04lp2174.outbound.protection.outlook.com [104.47.73.174])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f565js7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:19:27 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cJ7U66gUK/QJk2dl8a5C7tOcSmqy3xpcNvL0/OXiTfCLlXoW7BZcsShFwVT+5DDCgB/F50yub5GC/OueoDoHWCtbaCEw2WHO4vhqs5RM+imvoEkfFHm78ODaO5QzAI21g/1lufJJrO5HaD6HNdTDZ2t+LOMzgmbrT66Qhk19TOxiMCQGpoMq5wcJlUIfj4VoyipCqQL4ZukVbbRGUoifmcZbH8js7u9q/1fJKiH/MfuZHZkZtQjnFVmrkRL5bRSuP64S5q6xFOA+NsgR4l61F1to0zKhYZFs8RaQecg0T2a4wgvUPyXtviai5M4z1ABJ5WVC8a7WzApj+GMs3NKIYg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=joU8gBC4b/KtW53DQa8zhu+7TLY+hf0kAAmwgwgppzg=;
 b=mL7bWBphv4Str0+mAeYVsxYa9BecNfT7We43EzfseTyLRxm2/KVpD9kYR8imq0m73IsSzCwF8CUqgGqufjkcyHGhK1paWbjxZCxTIKcYJLAu3NbC8PLq+4rVFVD8IsHROBbrKnKOGrnH5V6I50oAY0brB0TiZ7M4jCLhdVVcKHkvuny6CrrJ3Nvqx844TSDY7aH/cyntk5PpMoitoaniuIzRaoWLhb/NjDit6AN3/zy1rX/cPD+Gtv7W4NYtJM/64ia5xdirOft0KpZ0ePlkxSxUatDhL8WtF8cqCr4uU4b31VdLRugiDjXVHvcTmqjKKhLer/1WTHh0ieOu6iL8KA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=joU8gBC4b/KtW53DQa8zhu+7TLY+hf0kAAmwgwgppzg=;
 b=Gd3wUSUZVf40pgqbrkfHoUjj1yybZuQpdhzvTpoUTLW52BQ042MturJ18QwQq6S+wBUCgMK2nWqohdZ3EnhrOxda7fC0ooWy/pWm3Og7Vtglk9LhBsBo0qV23ilgu1YHfd2n/jFaapYmt54aNw8tvrMTJs0W+56R2OVGjhciQsc=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by DM4PR10MB6085.namprd10.prod.outlook.com (2603:10b6:8:bd::7) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6745.34; Tue, 12 Sep 2023 08:19:25 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 08:19:25 +0000
Message-ID: <ced3c45a-047a-58d2-31e3-0b0de9ea0af4@oracle.com>
Date:   Tue, 12 Sep 2023 09:19:20 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 1/3] scsi: libsas: Move local functions declarations to
 sas_internal.h
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230912074715.424062-1-dlemoal@kernel.org>
 <20230912074715.424062-2-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230912074715.424062-2-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: AM0PR03CA0056.eurprd03.prod.outlook.com (2603:10a6:208::33)
 To DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|DM4PR10MB6085:EE_
X-MS-Office365-Filtering-Correlation-Id: 1458687b-720c-41c5-da68-08dbb368f9bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Mgp9DyNFWslXxUeX/deEkmBq5P2kX9gWhPYgz8x4S7H7r5yw63FUGqeANr0XdQwptaH1xZWUVTkuJSFduSx9ndH4PilBAvJpu6+fP1hPinOi4M9e/D+cC4iD3/zT/jTatiVAnFLR2erXlFSUDEwigWhD/zdJKr7hNn1Z1LT1z52GEJP4wS/DJ8WteAjo8+bHW7Jgd3fXhXKdeVVGJSvQkUxeLeYVpCU50BoxwXJRnVuNm+b8gRmiEScLFtg5clRAFeUDdcNpzqBjbrOnvf+0W7lYmPaHWh+ZMH5m//tMHIrSQlJ5tCg/e4IlohMRQn6yXwoHHXC4PaPkdsqFFAqVG1P2/TOrPaxLgLyC76tx79m9B622c5n8el20sCHLzf0OVHTLQ2yltlmu5X/ebS9OU0vJ5j3WrJbSK0AP3EGf/5KbnuUr1EUxA+HJbR6F/UHUbZUrikpDKKxDuJBtyvKkjtbyhICHzC27TS1VpYQ9s9CmmQPXfbLbc764IZ8sXwDQAaLhlqcrK0jnxtZ5O1T6Df89aWE4pz6jfnADDmE0KmUYnVKu1bDe7JRtBtTkl1JJrAE/wiFsvHm1laQtOz40xUy0X7p4Y1tsIVf30EtNPh1QzVVZlgmjYZuyYr3yLyhroM5Im5+lgLI66c57jaOCGA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(376002)(396003)(366004)(136003)(39860400002)(346002)(451199024)(186009)(1800799009)(66946007)(478600001)(8936002)(66476007)(110136005)(66556008)(4744005)(5660300002)(31686004)(31696002)(41300700001)(2906002)(8676002)(6666004)(6636002)(86362001)(316002)(6486002)(53546011)(6506007)(6512007)(2616005)(36756003)(38100700002)(26005)(36916002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bEFFclF6T2Nrc3pEK3VVdDFMaWJzOWhaeFh6T3RybHBFUmVSZHJUbWxnNmFL?=
 =?utf-8?B?NWxOY1hXTHExWll0L0sxSUFJbmZJZG5jWm4zSDJZZitrbjZaSnkrWWFiQk1k?=
 =?utf-8?B?SDBYUUI5SGpDRzNTWG56SldwcXB4cmk4bGw4czAzMUpZMk9VdTE0SFh6cTcx?=
 =?utf-8?B?dkU5bllhbTM3VmEwRS9CekM5TkU0MHh0VzBHbkZ6UVRIdy9ETEdhbWVPUHBn?=
 =?utf-8?B?R2ordFhnYWFWL3lCbUZFbzhPeWZHODR1S3ppQTl4WTAwNlJna1p0dGV2RnZh?=
 =?utf-8?B?MGJsTlA1M1U4empEK0JQN1MxcEl4SlQ3STVqV004YUtiZDNGZXovS3pvYUVW?=
 =?utf-8?B?QjVSNGlOanA2ZWt2UWJ4TkpOTXFuUWZZYTIvR2NTSEk1N240UlpMaDlTOFBo?=
 =?utf-8?B?cTF5eW4zY042MTMvZWluSDBBaThhV2xqSGF2MmhzaVUzRGNpWVZiQytHbUNP?=
 =?utf-8?B?VXpNUkE2bWoycGlYQ09yTE5zT0tGTkJsNU1OVnV2eDJwcmtHTXVyRjJvRWlX?=
 =?utf-8?B?OThiUGhuTjh2aG5BckFWa3Z5NTRTdVJpVWV0U1dkQ3Bpa0ZlSG5NdDV5Nko3?=
 =?utf-8?B?MzBxamV6Z3Zja2NmV1hHT3k4RkZFNHNPbTJZOW1Xcm1wbVZaTWdzUTNYTmVG?=
 =?utf-8?B?ck1PUE5PY0xBa2dScTVva1oyRCtXUEZydkxyWlBEZGhyTjltNC9Qem0vN2VX?=
 =?utf-8?B?bXlQZVR6UzZXY2JyeURLRm90bVd5UHpCRXFSaTVRa1ZqUHBpY0JQR0RkcDB3?=
 =?utf-8?B?bldoZHJjemFuMzcrbmRndEVDejY2ektyYTk5UVNPTHFjV2RWT3AvWXpnTWRm?=
 =?utf-8?B?S1craUZkbWQ3Rm5vVG00TDFMSlBOMVRiLzByWndEOXBhcDVzdllKWXpxTFJO?=
 =?utf-8?B?Y3o1SERudGdmVWpKaTBvT0FoZEh3aUVxMDMzQkVhUXZhWkpSZGZLaTRYa0lC?=
 =?utf-8?B?THRKYzJZdlE0emFCbFRyaFpKUTd2YVFQaFdISUZKUFI5TEdqa2NFdW9HY1Rz?=
 =?utf-8?B?VXVpc0NBWXZKb1NJSUdTSWd5NmZaQWpIRWhBS09XWHU0cXlJSXZFZVU2TVVF?=
 =?utf-8?B?U1hBSjBEbUJlL0JRT1dlTko5TXFzeWZIWHdpTmFyTVEvc01OZEM3RmVaNEts?=
 =?utf-8?B?dDM0dUVKNkZBOEtTdVZoNUNKOXpFSkR6TTkwZHdpREpQRTcrZjA1dVgwTTFX?=
 =?utf-8?B?Y2praU5icGFUL0U1UGwxdFR5WEFxWURXMU1kdGRGRWtheElpQmswS0NVOW8r?=
 =?utf-8?B?cW40cXZ5UkdKZ0tXbGpwZmVhNVNwMXdadW15Z0xtOFVtVVcwMEhzYnhyZlFn?=
 =?utf-8?B?d3RFYnVzbUJwSXNOQ0h2QmRnSVdNVms4Y0dDMEhrdzkveEdXZElsNVNwQzNF?=
 =?utf-8?B?RVFKQUtqc244NHF4MTB1RTU3TVp0NTYrQXljNW9LeXJ1SURtQ2lrOUkxd2Ji?=
 =?utf-8?B?Zjk1ZXdUaFFYNFFqSWhZTHJGd3gxa2pKWWY4MitLQUZsUHRxMU12aWQ3TWs4?=
 =?utf-8?B?OW51Mjd0cXpMSlc5NmU5YzBzMVdkVHoxYnc5MjFzNzNzRm9DenF0LzgzOGJP?=
 =?utf-8?B?NVB6dWJPU0ltMjBDcUlPQzVaeHVlOG1sODVES0E3U0dwQTA5dHcxTEpmUW5R?=
 =?utf-8?B?R0JSb29KZFhTaWM3Y2RsRDNXVzhMdGRvLzdYbnRCNWJwUnpyMnZyVkF5Q2hs?=
 =?utf-8?B?Y3UyUE1pR1k4WXJ4bUdDWGxkR0kwVExxVVd4ZVlnT1k1ZjlqMmtMb2hDZ0Nj?=
 =?utf-8?B?bEJCemRXWnRtZUt3NnkxcUt3QWFZT29DZGdOQ3BzVVArZDhJMkdIaURzWDla?=
 =?utf-8?B?ZmVKa0E1T2xzek01Tkc4QmtDbEFZVG5yMEJzdzYzeTJXRkJmc1ZNUzY5S2FY?=
 =?utf-8?B?UkM5WVY4ZjM0MUxKZzBUbnRObC9JcTNad0pHOG5WU3hoalptVnJxekpNcmhB?=
 =?utf-8?B?OTUrMGEvOUZFU2xWeVlmUkRuYXVtWDRla0ZXaVF5U2NQMi9PV2hVTGZSLy96?=
 =?utf-8?B?em04QlE5VnBRamcxTXhQd0lvT1hpQ2JLaEJkTDlzZmE3emdiRW4rL3kxckZm?=
 =?utf-8?B?L3hPZjFtTVZzN3pCUlR3TFVsN3NoVTZOdXA0QndDTGZXcENvekUrWWhCTklx?=
 =?utf-8?B?dHhKcXEyaU9zT0dtTW5GU0cxc0YxVkNBTUNSMGNtUHpmdW1mcDJ4Z2hyeFg3?=
 =?utf-8?B?aGc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: JDf3LF7lg+kPmBznBDsgoOj1Scx1fbFoaGwgDWHeg72Th7+1R+QyFqaqb+kEZAbXmDlFn3VkMEosEq7A2ttgvNdFiwf1n0JTmbPBxFqu5UMm3jpf6pqzPCTp4cW0IjSIfQH6Uc0AQDZY7zCcQ+ElSCIl9g7EO4KeqO2W4BehAY0CeifQXQahmPJMfyQ+jRcAObwGujOONZAXHNBoxU0GsUCOZclwKslaMkbkQyNdpjm1sCz2JXDhJyGM9YhzdFpXxGN8KxtEDpMkkElY6DS389ojEfDNtG/JVbGbEkx1t7g022NsorjGAIWqsj948jAyt2SWJgZJBwR9C5g+pegcjUQP59djOFzW21scqrIP699DoyftM/4z/ELFv+KFR2OEAnnP2Lz0anSDNscORDuLy+d8bHO2RVilMXvzl9LNsrJfBbsePeFAPAMvLyKO17Efqfm9Y8p3ITXUbF6m+v1en3l9pOg2YWaTEj4ezjNxM99uMQNmRVOBuODxvIP3ULFoAt2tXn5y2XQ9SLJ5FOOhHEiTVasz03ywCzIP5zrd6X0L2Clby4mLnVD9X4QGk1pjJvJdzApC5wkClgEgM6sIv5sKRHLHeuj25wPM/TNVnRH1rynvdvMWUVvHvvFXb4BJbn31mneaq+zU+ulcOTUFL9wbxjtD0dbzRPHxfXaSoKRiPIjHI7i57ujRiq7gy1GBm9s4jvKf7V8d+l5gJSJcein7z7ZK8xvVPPgPtjF5mwRmNeWfxURaMtQ62j91ZXDmNr7u2mloMsv2N2BHGDPITXu636YlglRPJdgPXs+yGsE=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 1458687b-720c-41c5-da68-08dbb368f9bc
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 08:19:25.3721
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gOkZqHdvA9WJx1RCL4KrrhJQUuMfoGhds9wivlQZROewAtc33iNYsEb+e+G94ad503B6WKeGSfBOcpRMS27Vxw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DM4PR10MB6085
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=896 mlxscore=0 adultscore=0
 phishscore=0 spamscore=0 suspectscore=0 malwarescore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309120071
X-Proofpoint-GUID: hEVB539aZts1QHm7YzlTSIGPW7Bnr8vl
X-Proofpoint-ORIG-GUID: hEVB539aZts1QHm7YzlTSIGPW7Bnr8vl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/09/2023 08:47, Damien Le Moal wrote:
> Move the declarations of functions used only within libsas from
> include/scsi/libsas.h to drivers/scsi/libsas/sas_internal.h
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>

>   
> -void sas_unregister_dev(struct asd_sas_port *port, struct domain_device *);
> -
>   void sas_init_dev(struct domain_device *);

I think that this guy can also be relocated

>   
>   void sas_task_abort(struct sas_task *);

