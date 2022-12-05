Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00DF1C4321E
	for <linux-scsi@archiver.kernel.org>; Mon,  5 Dec 2022 09:31:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231230AbiLEJbu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 5 Dec 2022 04:31:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231223AbiLEJbl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 5 Dec 2022 04:31:41 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2167F15738
        for <linux-scsi@vger.kernel.org>; Mon,  5 Dec 2022 01:31:41 -0800 (PST)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2B57XER4002327;
        Mon, 5 Dec 2022 09:31:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=0+yPpslKFAtj1irv+hpwrYA7xw0bDeLjAj+qLbhiqB8=;
 b=dpJaMH72SSLOmp5xfCNg9OPaXBDLCOF4VWY5XdcAZOBnKgbibxDrJDhub8ZhQnl5tfwR
 tgJvYT2Vek2fGsJr8jP9tpKAVQT5s0Lxhvdrlh/o99Xue7RTJEshChkpv1+DUCmU1eu0
 RSAsLKhZX0Nc5oFW7oskYSDYPg7WFLHUwgCRCAiR0BAQFkUsmPtOVcJIjU8QROAr6yCT
 r+6hb1zKNK1FeZPmCZhE2WJgJtvwRvUZAmc0xvrlb+kCN/0l/pfGnHr3BrMPTwBpNgcM
 0QTt1ib+Xi9isUyH1MSEY6mG9tFYq9rH9LJ5l5CgBuAaUbyMpwQy9GAVMXPtP94pLqnD mA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m7ya43617-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:31:26 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2B58wk2f029515;
        Mon, 5 Dec 2022 09:31:25 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3m8u91m1q4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 05 Dec 2022 09:31:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jEE9ZSj5IbelgsMXU00nT0FqBUHjpmsYE0Bmfn1sFiDornIabfV9wY7Ck8V2sN6TZkelwD2dp0eJiEBzA9EDJ2wpZYzxAqigqAdpXW1tBWXknQYxgvE07HCOcFYRkxQN8Z+d/bTYmOiwZZGDpBn8Nx/WwpiRXaZsKl9KMYCGS0oF8Vgs33u0aDRhI1tj47JNPJs5x7+9IvTKWctWjJXJjvrkULwmztXcmzuDQAW432Kx7pvrvOl7mlXGdCq4dXpKKU1mPV9FsKJtbgUpIRpjCOTVi6Yw+XP9LLqmgkZSLeWB7o3vVyonfuQu5LpikwnFzW1J8L9CDy7ueIQ1KYwHJA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=0+yPpslKFAtj1irv+hpwrYA7xw0bDeLjAj+qLbhiqB8=;
 b=nPodyfUaLIUDjSosEfnUc1Hi/wYhB/HvCM9aEd62bI7nmuQqk5onfW/2hz3QKSI53MEACNx+tgxA+lCtzp/5+a7um/1kOjhKN/bgJ+CDndS5+YkVVZmN80dsPvHKWk9QDJNwzsLWgQLSabOW4fI8voxcKSNCG4LvPh0tns8ANj4TgLfJxa65jPe2qcHVP+u/xKzh9XHjfTKsm1IbVSTZiPzKAwqD/jtVL50j0FmxuShV54ePh4A82CQVTIJwrWKsO2d4Fahvy/f71NVrbwc5X2wtQ6tZHZMMhoTuyNuXAIbK6yzx9ATtbsNRmLTXdgBdCtWLwk9CVFjLJeDVW17e1w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=0+yPpslKFAtj1irv+hpwrYA7xw0bDeLjAj+qLbhiqB8=;
 b=BHMwplQ6wkT7Fj6ZXBy/8KLR7GXptUT/SzRL+39lfCBE/XKCv1/7WBtuE42KcDOfmUWXhOUceCCjW7QfuIZ2wvtEvoCyEnfNsHmUXgbDSC9nc0kmBLZ1VXR88CZfQD9YQyh52a6IPsyCYrbZNN1a1lvkdzPw+mzzpz5ReiH1z/k=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW5PR10MB5737.namprd10.prod.outlook.com (2603:10b6:303:190::7) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.13; Mon, 5 Dec
 2022 09:31:23 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%8]) with mapi id 15.20.5880.014; Mon, 5 Dec 2022
 09:31:23 +0000
Message-ID: <22aca8ae-56df-4589-dc4e-82fbb00d0b1d@oracle.com>
Date:   Mon, 5 Dec 2022 09:31:17 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 6/6] scsi: libsas: factor out sas_ex_add_dev()
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, hare@suse.com, hch@lst.de,
        bvanassche@acm.org, jinpu.wang@cloud.ionos.com,
        damien.lemoal@opensource.wdc.com
References: <20221204081643.3835966-1-yanaijie@huawei.com>
 <20221204081643.3835966-7-yanaijie@huawei.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20221204081643.3835966-7-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LNXP123CA0021.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:d2::33) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW5PR10MB5737:EE_
X-MS-Office365-Filtering-Correlation-Id: 395a6593-0945-401f-5355-08dad6a379a3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 9L8KeQB4hs7XBFweL2nLVEfXR8KVCG2EQUpq8IC23B5puHoY4kx+4wvGbzXa69WpIelp/s56zlGVgIio29WFlshObH7He+87pBxRvNA4qs30ut/uq1fiqV/1uhhhHjweaazPULIp7QgvNDXYPtFKaDCIpm7iRZ9Q/OtmawfWePdzhxw1BzozhhHz7fiZsA76wurTzA8a3Fy47zRqMePCKBHgAcp4tVEgtfLr2REcJotMcZulOEhqbJs11cDP/xaCOv3JSBcb6lNq2fInFRMz7SQq6aIVcV92A12AjvFmU83BB+6MyTfayD9K/LoNgfINI1PQxf1hq+p7RY/j+8UqZxB55MYMahGjGHVK6cxjKHx1GRAPoFTdT8dorXN8s3x3eafQkgi4ofwhFLZbWdc2uZxG1LViq2xOvT9RuaJi18qkipC40BnJEmniWAHMqplAK3VawORVCXbBNxP7iyKR0DeWhTVnkmNo2+5YDyWc4hIIe3+J5EjYoiEzt3ybvj1McYUdNvvubaAsiCJIxxmDg9r0+wOjxXfHDAfAKgjixymMbwwce/pWadY7BHQecqD3KhhOMkrmbFBlwALbizS5i6jnns1CA2wMNkTl9qrLkuEFwqke6TjQU3GyjZVeYj9SOcmWwn0lnSW+w8YI6Wmghs3/3JTbKl7951Q4NZiTUxyhQrP53SYU67IGYt9pajCdLWPdjrtK6pqnh3D2Lcw2m/LvmHZ3YgYBtKlfVA57P7s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(346002)(366004)(39860400002)(136003)(396003)(451199015)(38100700002)(5660300002)(8936002)(4326008)(8676002)(41300700001)(31686004)(26005)(6506007)(31696002)(53546011)(316002)(36756003)(2906002)(66476007)(83380400001)(6486002)(66946007)(66556008)(6666004)(6512007)(186003)(36916002)(478600001)(86362001)(2616005)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SjB5cmZBd3VHdTIreUJLR1VnQmxyUmkxZ2QvUU1VNWZ2REZNTURhb3VBS0s4?=
 =?utf-8?B?bzVQOEVoT2w3Mm9RRHZtU2JaYnFOaURXUjE1azY1ZE5CWjZjTGY5eVphS0Rz?=
 =?utf-8?B?RC9Ya0MxdkRRalNtV0QzUnNXZnBCVDg5ZzcxZE5MM1QrN2lMcGtlalVhdjdB?=
 =?utf-8?B?OHhtMi9GZ1lhQUdPQ20vdDZ6UEpJdXJBR3hNZy9FY0dMay9JZ0RWd2l6azRI?=
 =?utf-8?B?WXZtK3NoeGlNMnF3ODFQYzR6cGJVWlJ5VlJPZEtZYm5mR05LUUdsOU1YeXZP?=
 =?utf-8?B?ZFJQQTVGeUVWbVZxQm9oVTh5NWRCK1ZmU3lZSzZESjdUT2N6NkdtSHl6Qlhj?=
 =?utf-8?B?ZkRzRk0rZVhyeEc2SWFJVWs2MkhRWEVPRzk1ekV5ZzRLMm14TjR1MTJYaENy?=
 =?utf-8?B?Zy9xU0dCTnFmUHJESUd4bldNZUNwcU5IYy83Z01wY2h6YU50WFJVVjBSN0sz?=
 =?utf-8?B?L1NOVURsYks2UUFYNGtaeEZnd0VRck5Kd3J4cVNNSDUwQ0JvZFFXQ09uWUpz?=
 =?utf-8?B?MHVLclhtNmtIMktmbmdBd2VNR2p3YnNWTXJCRk9PaE9JaFltN2FsWXZzWUxz?=
 =?utf-8?B?Wmd2RXRUeXI4Q2RwemdSYmRsa0lqZkZmTC9RT21renF5QjZySnFxenZoN1JO?=
 =?utf-8?B?OUxwUEJrSlhDOU9XMytlaVY4R3hHeUtPczdUMmdHWjRmT3pUd2plQlRlUFB3?=
 =?utf-8?B?aUN4WlNGT1c5cjVjOHpxbjJGTmhKZjlsR0o5aXEyWUtNWXhENUFBeGZiZ1Mx?=
 =?utf-8?B?ODZIditCRVZwS0NKbkN5NVJybUkyZlgvNzltR2dqNFdhaDI2K2pHS01EZDNY?=
 =?utf-8?B?aGlCMUx0eGQzYUlnQnhHZHVYSkxWb2ZRdGpUS0JlRXM1cjVDMzJ5SXFzK29M?=
 =?utf-8?B?YVgyTVJNbmJDYmpnakhESUc0VlAyRmtRVVVGZGszMHFDTkVXVVFCbXlTRSs5?=
 =?utf-8?B?M1V2R3BWQlFvQmNoK3VPWmJpa2tyMm9sNW8vK2VZSTJpdTllWDZRc3NNTGYy?=
 =?utf-8?B?MFJ2VjcrL1kyYjJSaitwR2FFUzRVQzY5eEhMUUd4bVYxWThWU25BSnA2SUVZ?=
 =?utf-8?B?T2F5ek1xTHRoNTFubFJXMXhQR3YybG1HWGpEZXJzS0lrREF2NXN1VVIwZVVJ?=
 =?utf-8?B?NFdJSkZZR0xnSklFbTB4M3R5UmQ4c1VESzVxZHhzd0NNRnlQYVd3VEVjZER6?=
 =?utf-8?B?b0xjVDlwWGdFSmV5VjNheC9oRGdCbUVHZlM0cUtEcWIwWjJFWjMxUVVzeEx4?=
 =?utf-8?B?czJCd29PSzlRcXcxQkk0Y3lGbmpoRDlUYXk5RnlxZ3lzRkVHZ1pwalZ2ckVz?=
 =?utf-8?B?eUJZWHl2ZFdDZ1dhQWFQZGdTak8rc0JGTi9SMU9oTk5ER2FOQ0t0c2ZMaTla?=
 =?utf-8?B?QjJQQlFqT0I1T2F5azNUSERBT0RhcTBFQ1JHUkZBMVJBRWpnemg4SmhmNDZ2?=
 =?utf-8?B?emlXZENsVW5WdzdQdWV1ZlZYZ0xtUzh0TFg5UENqYXM1N1Bsc1Nra3kwZlhp?=
 =?utf-8?B?akVnYjZvSGcwdHJRT25KZUpScDZxMXZ6TzVuWGZYcDJ6enJpeFpUb3RCck5Y?=
 =?utf-8?B?N0ZjVzJsNFYxRHlIVkRwakpMWXZsSVlBNW1TSHY2aG0vQWZKVGVUQmNkdWU5?=
 =?utf-8?B?a1g5a1FOOGQ5VitqUmhIOTlRZ2U1TDNHYmxBNklTNDQzZ2J5MmdXMDNYNEIw?=
 =?utf-8?B?ZGNFYnFpVDdYNUwvWjBxR2E0SEw0NGcralFWTnhpMEQyY282d1BETnFOS3Bl?=
 =?utf-8?B?eDg1a2piVVdxUGFDRjQ4Q1JSYmJqejl0VHJsVUhMYnhzSEs2ZzFtUTdxSmw5?=
 =?utf-8?B?dGx6M3dmMkVzS1B6eC9xOE05d21GSnlneEhpMDh2VytScXlYRzZtU0RPK2tC?=
 =?utf-8?B?RUw3RysyWC93R21ndmY5SlprbjllN3dNci9wUHVyamVIYzVMQ2N1NEVSUThl?=
 =?utf-8?B?RUpISTMvSWNDTC94bFdTbnlDYVAzSmE3TXU2ak9ET3lZUFBZTjZqVEExRTZs?=
 =?utf-8?B?TjFuaFVHZ0hMaGZiYzF3WXJWZVV2eGttRERDb0g2Q3ZibzBuUDQ3YVJ2dFN6?=
 =?utf-8?B?L0NNTW56N2tIdHlXNjdFQU5ENEsrV2VrallJeEord0FmR0hoMW9oSEdUVFdM?=
 =?utf-8?B?MncxR3ppY1l1ZXNQcFVhdTBBUkZIKzI4QWtIa2FZaWFPU3k2VkVCWm5LdHl5?=
 =?utf-8?B?blE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?UjdEVHZwcVZoUzhyTGM1VW1qUWJXTkpURDF0UVpvUlp6UHRUMWRzVlpNRVJY?=
 =?utf-8?B?azVSZEkvSU9SbjJVREk3Yk5jT2RaU0FTYko5RkpDNC9zUUp4UXVyUlJ2dlpN?=
 =?utf-8?B?YktyV2c5VzFidTVqOXF2cXFEMnZURkFFQ3R6aHQ0cGlweTZhaVZYTms4Q1E2?=
 =?utf-8?B?TzVZTlg2QW1rVkNOTngxNFVOdUFnT1JGaEJWcG15czJLSHZHb0d1c0IzWlBy?=
 =?utf-8?B?dU1HZXVuUmJrSldmZEEvK09pU3BrbUFIcVQ1SFozR3dRZm1EM1cyM0k1d3JX?=
 =?utf-8?B?c1JoMDcwTCtlcGJueGtLelp4ekR6d085RnUwcjZISk9sSzR2cURXQjJwSzJH?=
 =?utf-8?B?Q29pR2ZFNGlSS0Rjb2RsaE1ZWDg5SStmM216bEJUNmJjajRCMmR0R0NRNzVI?=
 =?utf-8?B?bXJRckRqN1U4eGJyTWQwS3RUR0VpNWxveHdyZnNCc1B1UXBLSjd6YlBzYkJa?=
 =?utf-8?B?V3JnVC9qOVowTHFTUVp4QTJTOTlpSnpjVDg0UG44c1IwOTIvMDRGbndrazlH?=
 =?utf-8?B?VGlQU3hNMWprK045V3p1WEc4dll5RlFpUzdBU1liNHNyMjB1bXQ5TTdwN0NR?=
 =?utf-8?B?WmNQeUZOcDNlUkxTbXNSbWhjeXFmd0Q0cWpPUkwyRjI1Qks2aVVReFYxK1Y3?=
 =?utf-8?B?M21wQS8xZVZhWHVmT0FNY1o0OFNMbWhkcURwVVpJbENseXZURHBKTE5zUklD?=
 =?utf-8?B?aVFaRXg4dXAycjVSREN1Uk14ZEZoVVlqQ3c5VEI4NW1RTHhaTlB6MjZCeEx2?=
 =?utf-8?B?cVR3NFVUUklRNmEwWjdCd2R1U3N0M24vYUZyVmp5OEw5Vm1EaXFJdktzMGJM?=
 =?utf-8?B?Z2dSNXhrRGJFMmpvaUd4M0ZiQXVKRHlEcmJFNHlOQWtCYlI4dkV2YU05ZWsz?=
 =?utf-8?B?aXVPaHlVOHByVHBxYnBPbUtsTGZTMWxzeStqUWVVMnljTFYzc0EzT1ptMmFi?=
 =?utf-8?B?QUdYUktSN2ZKSWlPMWxMdmJsSk9rRVZqWVd6N2s2cHJJWUFOcHFlR2RHZllB?=
 =?utf-8?B?aTQ2c2o4TzlTajQ1d2VSMzM4Y2haK05nTXRuaDYzZ0ZTN2FxRnlodkl4d2p5?=
 =?utf-8?B?cUl1QmgwbTJaOGxOTi9Ob0FWbUFjQjRvM05pRDNkV29Zdmd6NHkyWFZGbmhO?=
 =?utf-8?B?ZUVVZm1hZnBZTExFdzh2YWpxZWR2d2xRTkxIcnBWd1doeTdtVjJBYUtxRURk?=
 =?utf-8?B?b0NwaTlGRDRSZUZ4VEJaWlUzTERqTndEOWVkYmw3bWprMFpEclQvNTJaYndE?=
 =?utf-8?B?MkJDcjVsSzQycy9JQXo2VDQ3dmhzOEFlUWxVSXNLQUFFd1ZkVVRmVWFseURx?=
 =?utf-8?Q?i+OM0ASGqBNj8=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 395a6593-0945-401f-5355-08dad6a379a3
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 05 Dec 2022 09:31:23.7137
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +4+TtF+pKFQG897cHgZhswLJU//S2ufNsrdduwk8V7/2EUnqBYCMck41J1+GG6xYoJGzrerp6stoPT7zvYvyjg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW5PR10MB5737
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.923,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-12-05_01,2022-12-01_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=999 spamscore=0 phishscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2212050075
X-Proofpoint-GUID: DiR62i8Cb1bmSQaayeDztlCqJgi2ipUl
X-Proofpoint-ORIG-GUID: DiR62i8Cb1bmSQaayeDztlCqJgi2ipUl
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/12/2022 08:16, Jason Yan wrote:
> Factor out sas_ex_add_dev() to be consistent with sas_ata_add_dev() and
> unify the error handling.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>   drivers/scsi/libsas/sas_expander.c | 68 +++++++++++++++++-------------
>   1 file changed, 39 insertions(+), 29 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index 747f4fc795f4..3c72b167d43a 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -751,13 +751,46 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>   	child->pathways = min(child->pathways, parent->pathways);
>   }
>   
> +static int sas_ex_add_dev(struct domain_device *parent, struct ex_phy *phy,
> +			  struct domain_device *child, int phy_id)
> +{
> +	struct sas_rphy *rphy;
> +	int res;
> +
> +	child->dev_type = SAS_END_DEVICE;
> +	rphy = sas_end_device_alloc(phy->port);
> +	if (unlikely(!rphy))

nit: this is not fastpath so unlikely can be avoided

> +		return -ENOMEM;
> +
> +	child->tproto = phy->attached_tproto;
> +	sas_init_dev(child);
> +
> +	child->rphy = rphy;
> +	get_device(&rphy->dev);
> +	rphy->identify.phy_identifier = phy_id;
> +	sas_fill_in_rphy(child, rphy);
> +
> +	list_add_tail(&child->disco_list_node, &parent->port->disco_list);
> +
> +	res = sas_notify_lldd_dev_found(child);
> +	if (res) {
> +		pr_notice("notify lldd for device %016llx at %016llx:%02d returned 0x%x\n",
> +				SAS_ADDR(child->sas_addr),
> +				SAS_ADDR(parent->sas_addr), phy_id, res);

nit: these lines could be aligned with (, as it was before

> +		sas_rphy_free(child->rphy);
> +		list_del(&child->disco_list_node);
> +		return res;
> +	}
> +
> +	return 0;
> +}
> +
>   static struct domain_device *sas_ex_discover_end_dev(
>   	struct domain_device *parent, int phy_id)
>   {
>   	struct expander_device *parent_ex = &parent->ex_dev;
>   	struct ex_phy *phy = &parent_ex->ex_phy[phy_id];
>   	struct domain_device *child = NULL;
> -	struct sas_rphy *rphy;
>   	int res;
>   
>   	if (phy->attached_sata_host || phy->attached_sata_ps)
> @@ -787,44 +820,21 @@ static struct domain_device *sas_ex_discover_end_dev(
>   
>   	if ((phy->attached_tproto & SAS_PROTOCOL_STP) || phy->attached_sata_dev) {
>   		res = sas_ata_add_dev(parent, phy, child, phy_id);
> -		if (res)
> -			goto out_free;
>   	} else if (phy->attached_tproto & SAS_PROTOCOL_SSP) {
> -		child->dev_type = SAS_END_DEVICE;
> -		rphy = sas_end_device_alloc(phy->port);
> -		/* FIXME: error handling */

so has the error handling been fixed now?

> -		if (unlikely(!rphy))
> -			goto out_free;
> -		child->tproto = phy->attached_tproto;
> -		sas_init_dev(child);
> -
> -		child->rphy = rphy;
> -		get_device(&rphy->dev);
> -		rphy->identify.phy_identifier = phy_id;
> -		sas_fill_in_rphy(child, rphy);
> -
> -		list_add_tail(&child->disco_list_node, &parent->port->disco_list);
> -
> -		res = sas_notify_lldd_dev_found(child);
> -		if (res) {
> -			pr_notice("notify lldd for device %016llx at %016llx:%02d returned 0x%x\n",
> -				  SAS_ADDR(child->sas_addr),
> -				  SAS_ADDR(parent->sas_addr), phy_id, res);
> -			goto out_list_del;
> -		}
> +		res = sas_ex_add_dev(parent, phy, child, phy_id);
>   	} else {
>   		pr_notice("target proto 0x%x at %016llx:0x%x not handled\n",
>   			  phy->attached_tproto, SAS_ADDR(parent->sas_addr),
>   			  phy_id);
> -		goto out_free;
> +		res = -ENODEV;
>   	}
>   
> +	if (res)
> +		goto out_free;
> +
>   	list_add_tail(&child->siblings, &parent_ex->children);
>   	return child;
>   
> - out_list_del:
> -	sas_rphy_free(child->rphy);
> -	list_del(&child->disco_list_node);
>    out_free:
>   	sas_port_delete(phy->port);
>    out_err:

