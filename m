Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B829C433E6
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6143564F1B
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 03:47:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233656AbhCSDrQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 18 Mar 2021 23:47:16 -0400
Received: from aserp2120.oracle.com ([141.146.126.78]:56436 "EHLO
        aserp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233675AbhCSDqy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 18 Mar 2021 23:46:54 -0400
Received: from pps.filterd (aserp2120.oracle.com [127.0.0.1])
        by aserp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3VIpw076736;
        Fri, 19 Mar 2021 03:46:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=nT5Bakh8Y32ZSgeIUcXHue1ZpO9lZg4EPMX5eadTpdU=;
 b=ylyzqtDYgiO07wYS5EJ+jHNGGAd7hBAY0B0YB3Yp2Yk1rG00c/8lVCr8WW+iVYMZnb/M
 tPSPU2+coIZoQabOt6l4wiwtBQU/LUusXc0JfnCPJHTxvhmQWogarn2nGvaIv7TkvDQz
 GE8dJQIdFvpiDdLOu99t2OcDKIDjir88xqxh2Xu2SIMGfUaE9x50a+iOgrqkmMLFY0Ou
 lFLu3dsqXiE7wi6CAxbadVVTa0cb2T6nmbxKvW4NzynApccAPz4uKYw64NV41nPUhewR
 XqcLJLxjJ53APtxM6KnlBToetN9zzEU1GfcSCrtgM9ZuAJ/OPZg/W2/5FsMklTiHPlSZ Xg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2120.oracle.com with ESMTP id 378nbmhhdc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:53 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 12J3U9tl120047;
        Fri, 19 Mar 2021 03:46:52 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2044.outbound.protection.outlook.com [104.47.56.44])
        by userp3030.oracle.com with ESMTP id 3797b3rkue-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 19 Mar 2021 03:46:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=J0ylmryA07nt7EbNkimdIuOrjQkRLQMG1NmXiT4LxYnhN1l1KCZfVEspTHot9BDE52O2IMQw3N6B8rmMrF3xK9rdNaeE/21J5HAkSJa0s8ywYRh3w34PHnk+FOPUmg8PAIYcQWO/qVwBQhSI24c9j+rx1kZdHC6wJjQTUPj1H5ksNJk5VyfL7ARwZ2ocboh+jOxrqjwmC+z0dQtLGeSZob+yHbRTFThd8FOXGr277Dsq7ybVqxOWUYhzttBdbXMNPXh8U+3uBOjTlwBbSkXJVAXBbPVm44qvrVLQUeQUJhl3Xit+PKH/6ZvQAODSnDDum91pf4xwChoaMrN3aFzakw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nT5Bakh8Y32ZSgeIUcXHue1ZpO9lZg4EPMX5eadTpdU=;
 b=m4QfSm2DzVwewzveky8Z/l8Umc0SAq9iBab+1EBXUaFHCdSaDcxlHHMTNCM/IjR8s3YmzkdLAwBQhbsLQRb9fpSVG4go+XzNPFFhCadCikk/OWX1GwcCi3qJfjZapuaOTbgGEvOrE5LKgfiyRoOpNOZLtRWTRHkz7sZ8Wdq0zeLMitKkqnUfBPrJe2yFxaHX6DUiFY0cpKI+0Ql9ow7+cJkvs4sDVzjMIp7eGbX/KJTM8jcizfSf1Ph/hddbxzApoW8W/BjE3IWHOwgnJEU8YsrExb3UAv8YxvUpZF4WiDTJGJbKoi8sGTPb7xCudrTp+YunXxJot2v1nEgjRHcxQQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=nT5Bakh8Y32ZSgeIUcXHue1ZpO9lZg4EPMX5eadTpdU=;
 b=PjmeiaL9tQ7sblTYyoxwI/ra3rndTRMl7qR7e8iuHxZfwXH8Fb7JcDOUmR0gthUunSnM+tpHRSmXLXHAEVx9TTd+6q5KyIng0/AW5cKAsUCO2x2V4nH3g5yTmDJR/4Xi+UUEMZHQNhJa8h35p7Zbdepm+Lszrk2fyA54x5S+PwI=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4616.namprd10.prod.outlook.com (2603:10b6:510:34::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3955.18; Fri, 19 Mar
 2021 03:46:50 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3955.018; Fri, 19 Mar 2021
 03:46:50 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Bodo Stroesser <bostroesser@gmail.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: target: tcmu: Adjust parameter in call to tcmu_blocks_release
Date:   Thu, 18 Mar 2021 23:46:32 -0400
Message-Id: <161612513548.25210.12367203590674318098.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210310184458.10741-1-bostroesser@gmail.com>
References: <20210310184458.10741-1-bostroesser@gmail.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: SJ0PR05CA0182.namprd05.prod.outlook.com
 (2603:10b6:a03:330::7) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by SJ0PR05CA0182.namprd05.prod.outlook.com (2603:10b6:a03:330::7) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3977.9 via Frontend Transport; Fri, 19 Mar 2021 03:46:49 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b4cb10d-c792-47ca-20ee-08d8ea89a0f0
X-MS-TrafficTypeDiagnostic: PH0PR10MB4616:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46161856577272CADEE769268E689@PH0PR10MB4616.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: bcQZzavYId3xHdJ7oLA3yuBap+vpCs82qz8gPerd145iM/yvepZWtKAr6qsxE5d4pc5uAptfMl1AdEImNVJwtqbHTPHNcKOFJW+j4oFmq7TwhV6qEqU4/vtbcqRbeyju37fe+Hn4dQ540/EcpT82056+vY9Dc+YMqxJYnMlvLpqrDiCC56A5dp1WycKkd2DGGg4YPWinMIAs81lSb2VMzHDKv9OlUaz/B5/SOJULRqyzYTQLZ2bsvDMDLXweFCb1sBmYKnmFfZvaLUQjHi+glfmef/NT++C5660HadXx3Ol7mL5aiCW0+xUo41bFHOH484vlhaP/vQLJsMLSQ1efKgv+hXMnUMjeLaEWo/oyzAPOnKdj9DWHIVenEA1NQ2TFCTplB233jdqKWnxIftLaABXmUD0S0MWcVRk/ynRVwPGCbMXOGlb4BNKXKmE17RkHGkv3IZlzboI7GOdjEQapgsPwb0ZcwRlWxX4xXm/ekb6hdrZexlUWZe/qFo8CnspI4/I2HV1YE18SrlVWB3MpOBu+Sdtra67aGMQA4D54zRNt9ihD+GKoiDZVyT82hoB3L+BVlnJTkTK3QRIcxxim2omkXeSfMXb/gMy/7bE0XMQXW/d5bLVfK+VqpwTmpY20Lz149gGYEvZNgcvqzklb1l5rtqEG0cmMHEwQM2sxIH03CGtJfiuj1UkPc1gTREjsmnbdw1Uw4Q4Smno7ML0TjZyUUP7kZwbPn2F8nRPvjTM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(39860400002)(366004)(396003)(966005)(316002)(6636002)(4326008)(478600001)(4744005)(6666004)(66556008)(8676002)(103116003)(38100700001)(8936002)(83380400001)(186003)(110136005)(36756003)(6486002)(16526019)(26005)(86362001)(5660300002)(956004)(2616005)(66946007)(107886003)(52116002)(2906002)(66476007)(7696005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?Q3d4U0JEdHE2RmxEZnVCZndEVm80VEFvQTM4bUp1NWxLY1V1V3VZUFRlVVQw?=
 =?utf-8?B?RHlSSnFBQkZRZ0UvRE9hWWVKTGpLVXJoalpSanZuODROTXIwOG04ZzFwc3lR?=
 =?utf-8?B?bXh5SzZMTmc2YkpaZ012K0RiYUtTZHNZU1RJMFlYSElnUGFmaDZKdlFzY0lj?=
 =?utf-8?B?OStxaWpDTUdKY0c0MXhGRmFTcnpZZlhXSFhGWDQvbWlQQnNMOTdpbzNERVQx?=
 =?utf-8?B?aWdoUE1uUWFMZkpqU1dtTzRmUnZsZGdPNzdYVkhyRFpxVERLRFpLb3h2Q290?=
 =?utf-8?B?OE5NRmVrZkxWM0R1eTMzYmYxb0V0Mi90NXVlQzNUZE1WTCthQmZjRW5Fb0pr?=
 =?utf-8?B?N1lTejh1MVo1cWNpRE1vK1d3WjM0eTJBUUdpL29BY1BKZEQyM3daVW9xYVk1?=
 =?utf-8?B?Q25lWEN4VmhBMVJrdVZLZEdCVVVtd3FMaURqODhPd3FoNW1MQld5NWs3L3oz?=
 =?utf-8?B?d1hmQ1YvUk8vRSsxSjF4ck15SGtqSnVTeTkxenorVlY4VWlhaGtEVno0OFNq?=
 =?utf-8?B?UHN5MHNvczdwTFlteTg4Vm9rdHVCbnNXNEdrVjNyVTNNMk1SMkpEeUl2b1dV?=
 =?utf-8?B?QWpjSlN2cGpnQjIwYm1tSkd5UXZxZmpqZEhMQUlMM3pFWlltekFSYXA5U1pM?=
 =?utf-8?B?MnNxNHJlM2hTWmdNVmxkemlncDR6c2tPeEdrL01KQTA2dVBKN29TdTFVVC9R?=
 =?utf-8?B?M2Jkb1VUT0ViODFsL0dqVGFhMzZ3K1F3d3h6d3djend1S1gxN2FKMHlDcUVl?=
 =?utf-8?B?eC81YUFKRUpVOHhHV1NHZFM2OWduVDJ4RU1sdjAxTXFVWmdqa3E5YmpnYVNE?=
 =?utf-8?B?V0R3emlsUmVndFhzSHU4S3lWZDhoNnR0L3I2cFBhWXFZbFZyRUhZQzdPT2Nv?=
 =?utf-8?B?RUlncGswVDVBU1BmbGJhQzlzNzhxdE5LTzNKb0d3S2hDYzROSWJ5bnFQTzdz?=
 =?utf-8?B?dEVsQ3cwcXV5RlVmUnV2dUlqVmNvMGpPdFhZY2ZHcW5xbnJFeVUrSE44YU1h?=
 =?utf-8?B?WWQ5dVZXd1VoMlF1d0dTSmdIWDlVK1pTQ2xBUGViUmdaY1U1c0pGUUNHYlFQ?=
 =?utf-8?B?cnVLWklkVHR4eWpjNHRCTWM4bDRWamEwZHRucDNaSDZxUkdiZDZITjROenNj?=
 =?utf-8?B?REN0SHRJT2hnYUJOWDcxeEVyRFh5RFU0amVaQXMyN29KYW1wRzM2ZlV3WWNw?=
 =?utf-8?B?b3Rabzl6dFJWcXNmVWNTUSthVEp5Zit2WFo2eEVPSyt0ckdhZHdldEJvYlNt?=
 =?utf-8?B?ZjdLMGhFbXAvYUIxZE1vUldpRmlid1FBTGFodGJ4Vm83MWtrcGkwc3l4TU1w?=
 =?utf-8?B?WU9qWS9PeE50R2JEMWFMTUNMWmNrcFFDVmxpVVZUQ1A5aUJMMU1CTjlaME9U?=
 =?utf-8?B?ZWNDWXoxOVZ4R2pYN1BXd1MrSW9XQXdnb29VRVFJMW4vVmcvK0ZLUkdjVERi?=
 =?utf-8?B?MGZFUXhFZk92aU5Sd2wyT0RKVldmWFJTVDRRa1UyUUZEeDk5QmcyUDdOVmdw?=
 =?utf-8?B?VUZYVEZEL08wZFBKRlNFRzk1dEUycDdScGJwRlpDY3hGTWtPTlFwendWUmJL?=
 =?utf-8?B?Q3BCd3FTSmY2RUEzTkJrR1ZIbXkyOXhBV1h2Rk4yL1V3S0xDQVBsTkxORW9q?=
 =?utf-8?B?ZTYvUGlNSDZTVkI4Ti9DWTNuZlF3bUFRd0dGaUdTM2paM3pZMEVzbjZKR0lV?=
 =?utf-8?B?cVFmd213cFpRN3kwcnhVS2NPdW9rdjhxUUtWclJDdzhmbUtVUmJWWElhVDR0?=
 =?utf-8?Q?kne8+VLuzzduRY71viLQAF6aw93FKs5sGWvX2kq?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b4cb10d-c792-47ca-20ee-08d8ea89a0f0
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 19 Mar 2021 03:46:50.7910
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5p35L9IkV/Hi16NDjxq94uGJ50OgPXHJ24LGNepBT6WaIF38kbo1o83uWTEMw6YmQjSbiO7NIS/+TvoIq9HoOjBvuUtIbhh8qDS/Qxngbio=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4616
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 bulkscore=0
 malwarescore=0 adultscore=0 mlxscore=0 mlxlogscore=901 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2103190023
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9927 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 adultscore=0 mlxscore=0 mlxlogscore=999 lowpriorityscore=0 phishscore=0
 bulkscore=0 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103190023
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 10 Mar 2021 19:44:58 +0100, Bodo Stroesser wrote:

> In patch
>  "scsi: target: tcmu: Replace radix_tree with XArray"
> meaning of last parameter of tcmu_blocks_release was changed.
> So in the callers we should subtract 1 from the previous
> parameter.
> 
> Unfortunately that change got lost at one of the two places
> where tcmu_blocks_release is called. That does not lead to any
> problems, but we should adjust it anyway.

Applied to 5.13/scsi-queue, thanks!

[1/1] scsi: target: tcmu: Adjust parameter in call to tcmu_blocks_release
      https://git.kernel.org/mkp/scsi/c/471ee95ccca9

-- 
Martin K. Petersen	Oracle Linux Engineering
