Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5DF7C001B0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Aug 2023 13:06:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233786AbjHGNGU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Aug 2023 09:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231940AbjHGNGT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Aug 2023 09:06:19 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CD9499
        for <linux-scsi@vger.kernel.org>; Mon,  7 Aug 2023 06:06:16 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 377BbPIP010860;
        Mon, 7 Aug 2023 13:06:15 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=FR+x9lzaPBrnGTQcWnyviHGEcR1UM/XjUk0DgNhVJxk=;
 b=Ocl9AW4gRupUSRsSZRFlcHTsjPTQa/2cLI20POyllw1D2Ikbx07styUQoJvoCkS57r//
 jv+wiDb75fRgzWubOg/FIbOOmqDBhPanoZzw/VMr7ZWC5q56RmXxKh+PPmnpwRNXj0hG
 A6qNvvX9/LB9cNDBRbfCyyoY018cEcnyD8IWD0x/4TgLMqLCcXh8fKOfzEgW1+NsAftW
 mvirHGkNFM+U9ELm5XCu9J0VB/KdAxwS+TYgr33AhwBl2L8IbncBQk2oZnVUofoNoS4T
 zepLH1ZDQ0xsGoF6x4f24j92oNjQbdAQg2QKLwH2VzJqUst2yOtd2/goMz8FGgUZRzY9 ZQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s9dbc2pvf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Aug 2023 13:06:15 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 377BP7bd033464;
        Mon, 7 Aug 2023 13:06:14 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2173.outbound.protection.outlook.com [104.47.56.173])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s9cvahqh1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 07 Aug 2023 13:06:13 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=B2yMLNIUo9Hj7liwgQEzxdlcXQw7QK6GcQUle569UU3d6Yk7MsGQdDCsFVp/EKdsPEvYJwRUBaXK3UuqGGa3GU8Y8nv/pLG2puGKaqpTglNJGKUNpf7COEfzyecbHluFtfe7OLYubnoFJHr9canSbbbn17WDGraQfQzhI7eeEp+Cn1ku1DVkLZoS6jAxNmeSsZZsEegTVb4Qfq8EdrjRTZ/FpGOCDf8Of8kzh0BvQDXp+i1tloZMBvzRa88sclHT5xTzZOHOPGo4e6aTDWmFHu5kYkeZOIUiO3QUIKay5j9+HCU4OKTU6XeajixTYHgB3l+sl5gJvfnTHaZ4swjjQg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=FR+x9lzaPBrnGTQcWnyviHGEcR1UM/XjUk0DgNhVJxk=;
 b=RVDGAeaz7rNwT7n8qKNDavD26AUh0SW2KyYu7EEKYiw4AWfpTZ+RmWafOVo2R9c5qrzzetfNDcTBVEE73hq0FVo+a+Pf7wLbbazQNKK49gHhgYIqHXYlA5wVUSDbDH5BYPYnWshn/4o6absZBJEH5k23A2nhzsPAbQZbj2nq7tZ3SHmxGieKqnLssv+0CfKyoR01uNy9p0rKQ4bhDkDYynC5JK00X/sLkkExUrxsGff6X71AJrCWEaI2ZjCFqw6QRN4KJL3hnwjuVr8Fk2sPeH6K0iilyiw6bSEhDmscgM+ARZRTHp0yq1b7DV5XaSL15axgUMjhSxml+h6RPHYDqQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=FR+x9lzaPBrnGTQcWnyviHGEcR1UM/XjUk0DgNhVJxk=;
 b=sE1gcO31bQncZuq31ckYyxgSr4QDSbwyGXA2N8it3UBS/Xvk/BqjGE22Vi77yX9e+7YF6iwj2qPvZFiG1r7LJRwcaR6U6JOGJi/VbvsFp59aruAEIIxHFm0y29vpbO6yG9GQ9YHfXc2DFHcGaylPLtpXuzzd5fHQpOxal7yyGWA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5355.namprd10.prod.outlook.com (2603:10b6:610:c8::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6652.27; Mon, 7 Aug
 2023 13:06:11 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%6]) with mapi id 15.20.6652.026; Mon, 7 Aug 2023
 13:06:11 +0000
Message-ID: <c010df11-79e2-15d2-135f-71ffa6a6e8c8@oracle.com>
Date:   Mon, 7 Aug 2023 14:06:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.14.0
Subject: Re: [PATCH v2 07/10] qla2xxx: Observed call trace in
 smp_processor_id()
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230807120958.3730-1-njavali@marvell.com>
 <20230807120958.3730-8-njavali@marvell.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230807120958.3730-8-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0480.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a2::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5355:EE_
X-MS-Office365-Filtering-Correlation-Id: bfe9e48a-bec7-4c63-ec15-08db9747126a
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r+D7K1pj3MDRh6Ybh8re/U0udK82xM0HvuvaEGKZUFY5N5SbbyrHeTCoLE/sbpzt9g3xxBMRzq3oqXcX187e8S65/WAOL6Cg6iU2439t8buPIQwyHpJzIt2gizzAW89SJVEIYYLEyj8fpQE4JrS7djGrQrU7y/TrI0vejA2UqM5iMhjeKZsdoozql00NLeMgemCIr5evvXxQaKYVKMJM05iL/NA0QwXF3VjGS0GVGUk9lofSErVpKZBfjscJln4gjrQ+qmYkT6YnMBQhOAvZqeEZoDFE4X7EXHEESuIQayL4I0ilwYa/QdPXcYpYiR7bFUVqGXroKGnt1Z9CVRJkcassD2wr8SHrcyBj2PPKQfPZ7faWkEBsIMS8/YKbs90f3n7LXM15gaQ1sOtbKp82vD7fw7P446hhasGqdNcGUrp95oPFPjueB0iOfgGeXGYGrHoIhBdoCwyZFLD4tUIab2UZO7e55ifio2wCBarFaBdDGN7P7SxALvLcoZKc+R3+lxgJh9+5yw+yGr9PuXiyxwqmiLCUPC/Lepo8c9D0JrLJnm5J69TYJfiudfmZiqZFPL3GKsl2oo7zFifOOUy8raIAwyOipIQtewxY3k5OFLd8mJwfTWTgvMADcqh7XVU+DrD1DvW/uYCSM1lu6TQsXQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(366004)(136003)(346002)(376002)(39860400002)(451199021)(186006)(1800799003)(2616005)(36756003)(4326008)(6512007)(6636002)(316002)(86362001)(478600001)(38100700002)(66946007)(6666004)(36916002)(6486002)(66556008)(66476007)(31696002)(53546011)(6506007)(41300700001)(26005)(8676002)(8936002)(2906002)(83380400001)(5660300002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlM5VUQwaThkaXY1NUQ5SFF1OUczdjEzUkpSamJEczFrdTZpbmZNdm02UHJO?=
 =?utf-8?B?YzlRRmZGOGZ6SHhxd1dBeXNvSDNINWNLa0l5a25qWWhGNWhrd2J3b2oySE5C?=
 =?utf-8?B?OXY2emhGdmRWbkxJVjlNZ1dVbGtNU2E2MTlFY21DWDVTSTdmNVdQZHFTTXlE?=
 =?utf-8?B?bUl0QXFkRWljQlc1YjdjVnRZRURaelNMZkJxQjFrV2xzaVFwcis0NzUzdVJC?=
 =?utf-8?B?eVBPeU92ejdqTDJtckVBb3d4TzM3OHpkMlBEZnJxSFVRMmJRajBPdE93a1hy?=
 =?utf-8?B?N3VEOWNzbmNpRGtHSTYvSUtUUTlsc2hncm9rVWhpNFM4UktZaHFLMUtSc2Vn?=
 =?utf-8?B?U2JIMTkxaXhXK3FzV2p0Qml5eFVvK0ZFR2ZQM1B0ckdFWm0vOXN1UFVOcEw1?=
 =?utf-8?B?VVJ4VGl1aW1rV010TjZsRDVYR2xuZlpMRndYRkRPcDNFb3I3dXdXSE81U3FU?=
 =?utf-8?B?aU9aazZvdzBDc3RwL0g4b2lYSHl6clU2ajk4WmgyV3BRQkk3ZTZEaTIwWEpB?=
 =?utf-8?B?Q1JMUEgvenZlQjQwaE1uVWhNRXJYVVI0RHVNTFE0MS9rUFpoMlNtWUdhbGxw?=
 =?utf-8?B?YnlXVXRmajJ6bzVlTEMwVDRGcUlQaisrL3FjKzdVVm1GRG9yOVRnMVhHblZC?=
 =?utf-8?B?KzZDZ2pGR09PNXM4NjIwMVJsaWJtQ3RhZHIrNG9BM0pjMGhXQzBXUC9sd0Jx?=
 =?utf-8?B?NkVNUXp3NC92NjJDZUFpSkJvOVp6eUV2WExmUTVjRVRYN1RMWkllc3Z6UWJy?=
 =?utf-8?B?ZVNkVTdkcWxrZEhZQzZPK1psMG95d2V3NThmbzBubVB6SkwxZTVhMnczRFM0?=
 =?utf-8?B?Wmg3b0REY3JNOTQ2N1ExZlh4TjhMNm44VEFYSlhKakRSTjY3Uy9xLy93NnY5?=
 =?utf-8?B?TUxMMUNGRUFUNmVLV281b21FWHhzTFBoTEV0VjdzdHlPVUNqREU4amZmeTdJ?=
 =?utf-8?B?Mmd4eTltalVuSG1ydmxWVVYyVWhaRTNOL1lsYzNHeXU5U3YrUGYvVVBKQ2tG?=
 =?utf-8?B?RGRPc0lDRmhuVGJPRktpd0pWOW9TSVlFVUJaSW81TXg4aysxUFhtcW9TTXBn?=
 =?utf-8?B?WWQxZmcwM3lhdFVFdmkvNlZIRmJvSGRaYS9IdVA5b0d2c0dzNWdYMGVEVjdC?=
 =?utf-8?B?c2NKRVZuRkx3UVYyZGNSTmxsSXdaQjZ2eVRrek9SQkkwQWdXcHdvWnY2UGJo?=
 =?utf-8?B?SjBJR3B0WHJlYWN6MDFoTlJzM1A2MUFHY1NpVGJzcVNjSGN2S2k4WkJZMG1J?=
 =?utf-8?B?ZllZM3pHQ2pseitMNDNScU5RRVpXY3VocXZzbFUrOVM2MlUxWHRkNnMvSFhx?=
 =?utf-8?B?M1RaY3VBQVIzNWY0djJPc1gzS3NkWWJUVGN3VHluZUg1aFNIUXlGSzJ0dnF3?=
 =?utf-8?B?YzRWNDhpb0FhSFpJVjBPbEhIMmZSTng0YkRHMklRMEN3U3FWdUNzcDNaOXN1?=
 =?utf-8?B?SVpxZE54emFsZi96czFxR1U5b0RYQ3pKSlBiMUFQRmJwbTc4UytQN3dvQmZu?=
 =?utf-8?B?REY2NHdWejNMRG5JdnhiRFZpMG5LMk5EWDdlaHZPRW9rVW45Y2hYQlVVZUVx?=
 =?utf-8?B?RkQ0a3RsTks5bE9uTWxUY0ZGR2ZyMjcrcnZSZjJYVllJZUVXUGV6WjJKOVpS?=
 =?utf-8?B?Q2ZsVGw2eDEzZzJYb3ZyMzZ2MkNoaHhYbHEvV1ZnUTM1cXpSL1ZUNVBkTndS?=
 =?utf-8?B?eDZLWndPc1RxcWFSeUEwZmpXTzlRek1aZ2tkV0dnUzZOaG5PVlZwbWpjVlhD?=
 =?utf-8?B?czhEajVSWFpZVTBLYmdCLzZkVEpTRjlwb1JvUyt6MHlQb1gyNEI3MVlsM3dU?=
 =?utf-8?B?NUFMaFRYUTdhd0hlamc3QlZ2MGpEeG44aHZCQ2V0VEl3UnpFTGxIUjJJa21T?=
 =?utf-8?B?TktxbEVYYitYelU5djg5Nk1RQ3UxalFRSDVKRHNJY1NpOEttdDdvR1N2cHBm?=
 =?utf-8?B?OFEzdDBjL2VBYThWbmxPR3N3SHloNy9udUN5a29IQkVPdXlTMVdXRWlpYk5K?=
 =?utf-8?B?Uy9GWTljejdPZWFqeElSczNkRUhNZGl4UXo1S3I2M1lZaWw4NEt0dnpJRnFH?=
 =?utf-8?B?U0NVdU1BYmFGRWcyS29vcjQ2clhVQndSU1pQTHJycnF3Z0hhN2pSWlU5UUNN?=
 =?utf-8?B?SDgxRmFsZUg1VEpacFFIeWdpVS9wSGhpRUZMZ1B6SHR5eUNsYjRSb00wN211?=
 =?utf-8?B?QVE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: fWjY8YwfF6dw9CzNjToLbeXD9FVWuNHFLKIUZYWzJd/+OBGF6nbF0zKbuIHDFPIc3gLhXgEuVn9/nfMNEb5FSoMsHQt4/rA/3EcU0q/t+WQ4YSteCO9at6rZcJbKYz4JloT5P/osarRFkNPpFRYam7ZiEgxtnxIPqGq6oK99DQxbcpnua7LJnoPaOloM8apmPxguZlxUWXGYuTQCUG/dEl8rXtzhbKysMEdNgFsImyoG5VKT0jJlv7GpXEW4mvwF+siNDvPhW8vozwJ0HKb27TqaNQV3tGV9ImbjZUXcBaaWcqslcBuWZsNhzh0lYf073SOnRdcUUeyxshz+APBUUh/OggtjpIzSbCo6n35tHvv733oc9A8VuEbAw9BWVC+U2doVtLU4tSoN5tCddyNBgGqGR/Ges5XEd6pShv9eo3MBQrL/0ObljNJjzXtaxD7P+/Y6avjXR3D56m5xkp7hgQA/ukZv/OYyFfOtbs1fnyeM1YcsXCworVmmAc9DLhRTdq7aLGF4o3Q/OkVYHXlhI5Z92EYzi++7r7SoyjbRWrpsBbvbGd2km3+r/s5YyjCZEYigMn1tYw3FaBJo41gUVvA6ZOuPb7CCJwyl3etNWS0eQNfu9q+48aBdBcm3+uP0of5ISR3PnIVCBzYDX5+cf5kiDwroKxEfekAoDRLvpeLZ4qLRwBj/VWLv6G99l3bVd4kA6H2k+clcIOGXo6gTPVN8SHgnW24gLZOgtwf/LHsj03l66QgF/QFwtoHebntSD+0fB7NFkQpqKoRtcSMrHTCo1gSC7+KH9qyIkGOCZGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: bfe9e48a-bec7-4c63-ec15-08db9747126a
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Aug 2023 13:06:11.2971
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: K09MUzK39JFQj6cxW8xRaW6ka9sUb7FrhTiyhGTRVzROsKJJ65+0H6GrzKOc47iGnxegqFgvgVr3aCbMtxSmTQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5355
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-07_13,2023-08-03_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 phishscore=0 mlxscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308070122
X-Proofpoint-ORIG-GUID: Zr8ziOAKiXpA3qnFwIIwwUnjrkmzlJAO
X-Proofpoint-GUID: Zr8ziOAKiXpA3qnFwIIwwUnjrkmzlJAO
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/08/2023 13:09, Nilesh Javali wrote:
> From: Bikash Hazarika <bhazarika@marvell.com>
> 
> Following Call Trace was observed,
> 
> localhost kernel: nvme nvme0: NVME-FC{0}: controller connect complete
> localhost kernel: BUG: using smp_processor_id() in preemptible [00000000] code: kworker/u129:4/75092
> localhost kernel: nvme nvme0: NVME-FC{0}: new ctrl: NQN "nqn.1992-08.com.netapp:sn.b42d198afb4d11ecad6d00a098d6abfa:subsystem.PR_Channel2022_RH84_subsystem_291"
> localhost kernel: caller is qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> localhost kernel: CPU: 6 PID: 75092 Comm: kworker/u129:4 Kdump: loaded Tainted: G    B   W  OE    --------- ---  5.14.0-70.22.1.el9_0.x86_64+debug #1
> localhost kernel: Hardware name: HPE ProLiant XL420 Gen10/ProLiant XL420 Gen10, BIOS U39 01/13/2022
> localhost kernel: Workqueue: nvme-wq nvme_async_event_work [nvme_core]
> localhost kernel: Call Trace:
> localhost kernel: dump_stack_lvl+0x57/0x7d
> localhost kernel: check_preemption_disabled+0xc8/0xd0
> localhost kernel: qla_nvme_post_cmd+0x216/0x1380 [qla2xxx]
> 
> Use raw_smp_processor_id api instead of smp_processor_id

This patch changes 7x instances of when smp_processor_id() is used 
without reasonable justification for all of them.

Furthermore, for the instance where the calltrace is reported, above, 
there is no mention of why it is indeed safe to use 
raw_smp_processor_id() and why the warning from smp_processor_id() can 
be ignored.

> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Bikash Hazarika <bhazarika@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> ---
>   drivers/scsi/qla2xxx/qla_inline.h  | 2 +-
>   drivers/scsi/qla2xxx/qla_isr.c     | 6 +++---
>   drivers/scsi/qla2xxx/qla_target.c  | 2 +-
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c | 4 ++--
>   4 files changed, 7 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_inline.h b/drivers/scsi/qla2xxx/qla_inline.h
> index 0556969f6dc1..a4a56ab0ba74 100644
> --- a/drivers/scsi/qla2xxx/qla_inline.h
> +++ b/drivers/scsi/qla2xxx/qla_inline.h
> @@ -577,7 +577,7 @@ fcport_is_bigger(fc_port_t *fcport)
>   static inline struct qla_qpair *
>   qla_mapq_nvme_select_qpair(struct qla_hw_data *ha, struct qla_qpair *qpair)
>   {
> -	int cpuid = smp_processor_id();
> +	int cpuid = raw_smp_processor_id();
>   
>   	if (qpair->cpuid != cpuid &&
>   	    ha->qp_cpu_map[cpuid]) {
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_isr.c
> index e98788191897..01fc300d640f 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -3965,7 +3965,7 @@ void qla24xx_process_response_queue(struct scsi_qla_host *vha,
>   	if (!ha->flags.fw_started)
>   		return;
>   
> -	if (rsp->qpair->cpuid != smp_processor_id() || !rsp->qpair->rcv_intr) {
> +	if (rsp->qpair->cpuid != raw_smp_processor_id() || !rsp->qpair->rcv_intr) {
>   		rsp->qpair->rcv_intr = 1;
>   
>   		if (!rsp->qpair->cpu_mapped)
> @@ -4468,7 +4468,7 @@ qla2xxx_msix_rsp_q(int irq, void *dev_id)
>   	}
>   	ha = qpair->hw;
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> @@ -4494,7 +4494,7 @@ qla2xxx_msix_rsp_q_hs(int irq, void *dev_id)
>   	wrt_reg_dword(&reg->hccr, HCCRX_CLR_RISC_INT);
>   	spin_unlock_irqrestore(&ha->hardware_lock, flags);
>   
> -	queue_work_on(smp_processor_id(), ha->wq, &qpair->q_work);
> +	queue_work_on(raw_smp_processor_id(), ha->wq, &qpair->q_work);
>   
>   	return IRQ_HANDLED;
>   }
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 2b815a9928ea..9278713c3021 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -4425,7 +4425,7 @@ static int qlt_handle_cmd_for_atio(struct scsi_qla_host *vha,
>   		queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq, &cmd->work);
>   	} else if (ha->msix_count) {
>   		if (cmd->atio.u.isp24.fcp_cmnd.rddata)
> -			queue_work_on(smp_processor_id(), qla_tgt_wq,
> +			queue_work_on(raw_smp_processor_id(), qla_tgt_wq,
>   			    &cmd->work);
>   		else
>   			queue_work_on(cmd->se_cmd.cpuid, qla_tgt_wq,
> diff --git a/drivers/scsi/qla2xxx/tcm_qla2xxx.c b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> index 3b5ba4b47b3b..9566f0384353 100644
> --- a/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> +++ b/drivers/scsi/qla2xxx/tcm_qla2xxx.c
> @@ -310,7 +310,7 @@ static void tcm_qla2xxx_free_cmd(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_CMD_DONE;
>   
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_complete_free);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   /*
> @@ -547,7 +547,7 @@ static void tcm_qla2xxx_handle_data(struct qla_tgt_cmd *cmd)
>   	cmd->trc_flags |= TRC_DATA_IN;
>   	cmd->cmd_in_wq = 1;
>   	INIT_WORK(&cmd->work, tcm_qla2xxx_handle_data_work);
> -	queue_work_on(smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
> +	queue_work_on(raw_smp_processor_id(), tcm_qla2xxx_free_wq, &cmd->work);
>   }
>   
>   static int tcm_qla2xxx_chk_dif_tags(uint32_t tag)

