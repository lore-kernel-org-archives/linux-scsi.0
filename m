Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 015EDC001DF
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 20:17:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231867AbjHBURb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 16:17:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231402AbjHBUR3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 16:17:29 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D3B22685
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 13:17:28 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJ1f8020872;
        Wed, 2 Aug 2023 20:17:27 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=xCVOV3kx3WY6yo7T30KAI8EA0TWNqS4B8KWbH2VnXx0=;
 b=TvfcbD6CcTCD6zWwc4Va2zAp4bkLTN9oALtEqxbSt8ABg337lzzu5JKUEvWI4cJ5m9NC
 87asuel8ClxuEqyXas1NS7SixCOs8UKoojgdZmXSYJ+RZTHKCpCZg53hCO4kA8yILw79
 Oh865t1TLz55x164Gy7yw1vbxuamikwBTuaDvDRAJJXQqfelkNAfI/g5Ru0iDWLGAvE6
 7CoifnmDycgp2hjHmYdS/3+k9VgQhskQNU6smgDXa8OtB2Zw+a4nvFyuk55OPgqsYEql
 l2UVw90OUuDBZ/J5iQO/dWoWDPlw3uqKZw8f5Y+G4vsHr3+mfmbfLT4+u2cWCI3oQc5S 4g== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4ttd88mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:17:26 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IYjOs025203;
        Wed, 2 Aug 2023 20:17:26 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2175.outbound.protection.outlook.com [104.47.55.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ey966-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 20:17:26 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ehlqlBtj3mIVVfBSjuTlrnyCHyBtey0GdVc5znTy9VHzrqNUgKetUj/iOCni0b+6KWhPYGMZY66jN54TTGoQrk9z1X+rZfxGwOrEe4XT3jJMM1cP+95Qa6PaOB98/miOS0Gx/usRe5c0+0c25O4CXAIJbLKIjeneFzXKz8G+K9RrsIBLqxx/YriaNQ5KR+V+3NDfJe0RpG6kGxPnJ++UT4sWJCHchifkLTt64vVZv2JcabmDLlaIgCwgp9FLk4Uj2CrUxEhklhKgIzlmXPAOIQBqTTqkphAI0ca4GnzPe4MVkJ+GMi91ERG6g7OwlwAbwGmMnxh/sadqNPhsN+Ccnw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=xCVOV3kx3WY6yo7T30KAI8EA0TWNqS4B8KWbH2VnXx0=;
 b=Y0CWj01nhCIIQLfqxZ6SxG2CtGw35RrBcWtH8ExlCuRxvimaIe+7bny42jxWp2CXfex5aTOwv2HJ6FASkli9UYVuOmBVsUijCwvS+Czg62ATt5k9i9G8Bc3YxK2v0X/2j4ZUxP/8kzhsAhiZ6ub0SXTgExfLbQK83oG6IQabLLq1+IkqkBdnssBbeLfz60l1Xp660pz8XFYs5gXSdMSyeqYzZgOIo70rMR/szzM02+90MhBt9yn5O7UaX8M4WrUHP1auG0il6m8F7yxzveoFUvN6s5/gyJJknFsmB6iWuCIjU9hpjUkzESqW034JMsFOdLhNJcU6rtGpag/16tBF5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xCVOV3kx3WY6yo7T30KAI8EA0TWNqS4B8KWbH2VnXx0=;
 b=mgaHOmwFPL+aoLmukCB6jB6d6nrAuksFGC/edCap+/kf5LpzXzhpDhocvlZcpx7PHGrjd6atLLsjuyqzbvk1yY/nLKr6d0n/1+02xI02gzsGxuHqVcvsboIQztbnRQrJtN9zBnkbmSK+VCdIy2uoQX5e2eVUt5UfEuvhFA3+Syk=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by MN2PR10MB4174.namprd10.prod.outlook.com (2603:10b6:208:1dd::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 20:17:24 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 20:17:24 +0000
Message-ID: <4086c4d0-7ca2-5fc1-64cc-bf426d2bc90d@oracle.com>
Date:   Wed, 2 Aug 2023 13:17:19 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 09/10] Revert "scsi: qla2xxx: Fix buffer overrun"
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-10-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-10-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SA0PR11CA0066.namprd11.prod.outlook.com
 (2603:10b6:806:d2::11) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|MN2PR10MB4174:EE_
X-MS-Office365-Filtering-Correlation-Id: cce2c9f8-0f1b-4e1a-45f2-08db93957c0a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: j22dpZjjuS5+vzYzx1fGzr715kBWoflDSEEZDfBkMU2Sk9zML95+Oen8cNvWDiMxSmqXv7+YNIZDswrUBUtlk4OllbaVU0Ut50bRz8JiaPvKBQjRAg30HifuFEQ5HFlZtaXKhJRsJL9HnRZxWThtjJejr0Z4Erke6y+WDmJ9Khzr7Kjyfh1rrWQJoNfYmetl9fyZQrwRMyrmnUtmlxPgEB8TTTXzHH5OLlEPsUxmMJydnAn+R1fE7F8iEO2qmgdvLzd3OtSoWXFfrWBkf76yJw12ofUMQsCBuZM+Ib+Dmb7zPLsUv7E5OtbYEP6jion3zj3Thlai+30qcckTbvVwnUFklLqZbyp+VChdKYyLrvXQSSDtAZpmeIkhE7spc3iA5sG8/h1aLF2EEokPSQMRjyVaKoSttz6eIqvGFMNUXwInjErkGxAsktTguNv9PHkrkRmHqqeP40y+TqXXWmKVHNAh3o1yYXpvO/KsuxEBLx2f7QR7+tksQ3xxtTJWpeuwbWakbZ1gz/HKJhG+vjHC2e0tyMHORHVj/W9O+zPWMFQSJzRy15BcWpFwb10rvE6ER5vRJ/rq7Gc6ALtfLHv/llJA3TRHCpN3bReCIsPjaL7Uf4XWuU+APdIzfm71NdrZBxn/6m0UP3KCxL3iyYIGTQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(136003)(366004)(39860400002)(346002)(451199021)(8676002)(8936002)(31686004)(41300700001)(5660300002)(2906002)(44832011)(83380400001)(2616005)(186003)(86362001)(478600001)(66946007)(316002)(53546011)(6506007)(36916002)(38100700002)(6666004)(66476007)(66556008)(31696002)(6486002)(4326008)(6636002)(6512007)(36756003)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NDBwNjNHL0JySEhEbFJJemtoT244TmFwVm5DZXYyRmlXOG1wbGFkNzVTRUp5?=
 =?utf-8?B?Q1cvOXNzblJmUktXL3p2ZUhQbW5RNVhyZ2xJMXpmUjNoUWlvUnVDS2RDSVlv?=
 =?utf-8?B?MURSRkFDVUZwa2VLaDJjeWxVbVEyZlRscUpLUm41cmVuL1hPVERsVjJKMGw2?=
 =?utf-8?B?NXhxVG5xWlIrOUUxMWlzaGx5dm1xNGptalBvYTZQUmkrT29aRXRKRkYyRnlv?=
 =?utf-8?B?bE5VQm9rQmZReGVsbjN6bU10WWRDRlMrTE5kVUVrZ3hoOTdkWHVmSXh1L0lZ?=
 =?utf-8?B?QnhrcSt5ci8zQ0tQbS9FUG1Ja2ZtdnlWSUdmTFM2NUQ5S1RQSEh2R2h0WU0r?=
 =?utf-8?B?aUcwZGtsRWlOV0NYTjlrdno4dzZjc3dBbUt6WEk3WWUwdXhEbTJOYytXMWp4?=
 =?utf-8?B?bU1ic01jTEhxMmxCVUlRTjQydy9vdS9GMUppUDQyaTh2a3F5bFJ3U2NMYzVT?=
 =?utf-8?B?T1hDK0dxdUR1djh2OVhMSHBqYXV2RWYyeThzTTZGNEJFYUVWYml1NWZ5d3B0?=
 =?utf-8?B?Sm9RdXo3a1lQbUJZNW1xSnRVVXlOSWJITjFra3k0VlR3Mms3WS8wY05rVUJy?=
 =?utf-8?B?ck1MSlR5T29vcysraEgzaXN5dmZjSm9XN3RYaUo3c1A3cVFtVUVwY0pOaDl0?=
 =?utf-8?B?RnUvZHMvZW5lcStiSlcvNmJhczhneHNJcGJ2TStmZ2dwYjBQUXhKK3BkeHVz?=
 =?utf-8?B?RjQ4eG5sY0RTYjFJdHBzSjFXdVZGdWVJc3FpMGd3N1FkNVcwZ1AwU3h2U0Mv?=
 =?utf-8?B?NmI0aGtxM2d3bEYvSFZkSFk4Qi81c3dUUGlaOHg3QytHTXhpalA3QWloSkQ3?=
 =?utf-8?B?ZHNlSXNvOUpCcW53N04yeVFjQjREbkJ0YWdUb3JQbEVpWXA5c29VT2hwL2RI?=
 =?utf-8?B?dHNsUnJVTC82dWRHdkRrZzdvd1NqdmRlYmkxdCtXRFc3WUVmS2pIc2dDM0x0?=
 =?utf-8?B?RXpDaE5GYkFKejU5UlIySlpGRXRQTlVTcmszWkpRajJSSFdIaTJkM3JSeVg4?=
 =?utf-8?B?WVhDWG5FZi81Q0hqVlNDNHI3bGpCMS9ZOUUzOTlNeGZTS1NsNnlYTTNPUnE1?=
 =?utf-8?B?alI2VG9GeisveW1YcGU1MFRwMkFxV1JMWjhnM2xhazRsVG5UaFUvOHZENm8y?=
 =?utf-8?B?RDNDMzcvRXFYTVBJZ2FLR2o2Ukd4UmlUZ0pwdkhQT0JQSDZJMVN6WjJKVi9n?=
 =?utf-8?B?TWJjOWhPVU1NN0kxenBDOHVVZk5VSjNoMG9PUHFvOVp1V3pkdE5vRjd4bW1P?=
 =?utf-8?B?MTIyY09EblU5ZFZkWVBUV2RkdEozU0d5L0VtSVNGR3RNcWVNZUIrQ01zUVoy?=
 =?utf-8?B?Y2RDN0ZhUWczUTFBMHUrQUFpT2dEbDRZYXFKckw2d1I4d0pLeWtkc1p4bUlS?=
 =?utf-8?B?WXdkNG15L25wYUo1ekh6dUFmOEs4bDNRRHFNdkdURGRSUUxpU1NYMXRYbi8v?=
 =?utf-8?B?b3ZoaTRGQkJBVDNYcVVYdzcyaWlleFpmc1FYYytjaEl2dUYzOStvUHNRME5B?=
 =?utf-8?B?YytXOHpyYVN1aGJLOU1haWhKV2QyWjUwa2k3UkszMWJFMnlHaEo5ZTdra2Va?=
 =?utf-8?B?TjJUbUJ2UlkyZnZLelh5Q0Z3REtSN3pBL1lrOGVlTndBOTdrL0hUd1VVdXJQ?=
 =?utf-8?B?L3NMdzQyOU5ocmF0YjVQYzBDekRUeHZVSHo1TFMrK1dtNXF0WFo0NStsQWIy?=
 =?utf-8?B?UjVCZUp2NVBhQUFXeUhWVCtIL0tsV1JSZ0NVSFRmZW50TGpGK0poU1k5eXhP?=
 =?utf-8?B?VHpNV0tGQUZKUk1LVS81SEFOdm93YSsxWGIraFROaUpYcE9xS3RZNmRkNGhC?=
 =?utf-8?B?T3RuRVBrRzhlS1l3V1dOU1V4TlN1d1ZtTTlJa3dqa0ZRcDR2YmFBSFUxY2Rz?=
 =?utf-8?B?UFgrakVVNmFrVFBZTHNIbExmVUFyVGVQVTVPb25TZEV6U0VFanN6MWhXdGpi?=
 =?utf-8?B?cFpZS1VlZzA2SE1YZURNSThndXA3MER1ZHVxMEdydGZmcUNYbXFzVDkxblJw?=
 =?utf-8?B?Lzd3NS9HVENpSUkvWFd2Smc3ZU5BLzFlbGsyRXpMMUdHUG5nM0I4V1BCN2Nv?=
 =?utf-8?B?Z0pvU0xhMTkzR2tCczVLWjhjOW5HeStKVG5uaXFwVVpNdEtCWnJBUkw2VllN?=
 =?utf-8?B?V1BJcmVyQzZmUmtLZ3dKNEVqWFVuMDlZTXNyeWR3VlFNUDBVRitZQTZ1OTNJ?=
 =?utf-8?Q?e0ECpmkh6+xwr8KNJ3Dwis4=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: FoOa84Pd16xAmMpjd67amz+mQl1c3hgNP6pP2hEFPqOLQTY64K5UbLlpbpSZ7TqlOAXL0Ml0XlO3jaYhA/8k6gYe8EVWh/Tz6twwbUT4k1NrXtDNVg+SmKmSyq6LspI8RXDdF1EHCf175VI3t4eZ9YUtn9zMgzTXOXkCE1roOkdqGrvaCGYGqaAKAKIR6UbYcQYiOpdGU7PQo4KgjX2DN+ZVIxfO0RFqVAC8P8S9TMbEBh4K/VkSY7BgX+9WdwruEK9IVnNauL2CKaCq+h8gzLv858evfirAoXLsKsqeRABnLua3yG9tT9VIip/c63mO/m801RHKcsTRxnFtfyHPF4NJkgQkzcbC4AQFjZH1Ts1XQWpDhtipYWJnNwN25uo+dF40ToLdGZcArCJUwTNZXeapnnnnsTupZIQv/1DiR/l7eyN6V3YfgsvIFdwg454eKlTAX6r0zMvvQ9fS4/d9RXdqqx2Jqov89YnXVEfd4PM662i6Bu/JMFZvFaNfph6sWAG2kI9H4GJ6ChpJsUOGYPouIcLud+uUFn2IiQx/y6d23ttVCkl19wfbp20kI1V6nKCbUCGsjqvQO7PXinVOz9QBS6qCMTlNc56MuiyqcORAC6LvMM/r0Cdouajy5T4TcSxJy0GyHC+s0AoROilj3cTyyevSi9G+VNKo/K5/kv9qTEFd0J0sBFX6r6p8xBP+xF2BeYc9uMreVij6expjKsBuNIAF+1/HBpYibGaBs7AOCzeu/bvj5tQ0xyG+/WsGKXpBZh0cLqjOezojsuywVO07S7QlWZMwha1Zi/S1Igg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cce2c9f8-0f1b-4e1a-45f2-08db93957c0a
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 20:17:24.5815
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fWUdLG0nSpMuq9MqZo5HkRSvcVe6yVqPOIwcWhLD2C0UAMtF4fC0hBpEyobN/Hn1/urDZh+IF5LZ+kiRogjjZHqe63plumjGnbyH36Y3gLw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN2PR10MB4174
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_17,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 adultscore=0 mlxscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020178
X-Proofpoint-GUID: I1C97PDX7ePt0KaYgxpimshHNdurJsw4
X-Proofpoint-ORIG-GUID: I1C97PDX7ePt0KaYgxpimshHNdurJsw4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> Revert due to Get PLOGI Template failed.
> This reverts commit b68710a8094fdffe8dd4f7a82c82649f479bb453.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_init.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_init.c
> index 62087ce51b3f..d4df07aaa0ab 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -5607,7 +5607,7 @@ static void qla_get_login_template(scsi_qla_host_t *vha)
>   	__be32 *q;
>   
>   	memset(ha->init_cb, 0, ha->init_cb_size);
> -	sz = min_t(int, sizeof(struct fc_els_csp), ha->init_cb_size);
> +	sz = min_t(int, sizeof(struct fc_els_flogi), ha->init_cb_size);
>   	rval = qla24xx_get_port_login_templ(vha, ha->init_cb_dma,
>   					    ha->init_cb, sz);
>   	if (rval != QLA_SUCCESS) {

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

