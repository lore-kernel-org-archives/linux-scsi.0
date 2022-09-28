Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 799F6C32771
	for <linux-scsi@archiver.kernel.org>; Wed, 28 Sep 2022 19:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233820AbiI1TO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Sep 2022 15:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233748AbiI1TOY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Sep 2022 15:14:24 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7522B6D66;
        Wed, 28 Sep 2022 12:14:22 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 28SGxBdA010154;
        Wed, 28 Sep 2022 19:14:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=ydGWIkLBzL07/XU6KbOqrvPb1dDiJlW3CCbn1DQFz3Q=;
 b=Qsgh111/hBtlgp3Juc95G4gQOioHGeDpfqBaQKNIO5MNj/pSDhnJueHR62wSRumztrDv
 od0RxvzljG6FY6n5+/a0qOpnBjlBu+/pTtKF2snasZJo9e/USHnawA4kd3hW3uuqotwQ
 vCZ6jv7MT3dpLTnO3aNcJYUj6gZfrWUnAxjLGlCxxvVVrWnVUPjXY37/Y6ykv4+nHG1f
 6T06YMyAOOxuVW8OyM01uI8itMNd1KK3SF7ZKQ3QombRtobblU6pQKN5TWZwVB3sKV38
 y3YH5DmEjMG9pDYGrzvSEbN+l3NNuyIwQtQvoPAAqhgsS9rV/hcl1w4uudLYvmlQ92vW 1g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3jst0ktmqa-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 19:14:19 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 28SIh1D9037126;
        Wed, 28 Sep 2022 19:14:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3jtpvfktvs-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 28 Sep 2022 19:14:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=g5M6mvUG2s3YHmwuLy2VrrnLBpwFOVuQR2xn+XbopAhqBQLtHkEr2MgzQiUx/hQ9ZOTnkh4/HjtSgSF3E8qXcw2Z6MDvgBHDTMeIPM70aJUw8qF7wd1x/WHtDb3lAzf7JJdnJdWjOgYSOYHICQK9XklGUh1WdxJzw1t24C/XHGl9it6U7/ryvIiIcmb/goM2o07Yk6ijyPfAg7B4g/jOfpV8xoiKpYb1phhw6KXQAMox/X8R2iYCUtQA/tyT3/ymIeZiHoJXORQt3XzIs2g7AghkFEiU5Mnx891fuzymnZz56RZUjR+eZU4YEy1EXlLGNmLKQLbno+QIqoZC+M+JgQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=ydGWIkLBzL07/XU6KbOqrvPb1dDiJlW3CCbn1DQFz3Q=;
 b=VVTfBso5M4a6jy60xxwur0FngCvgaJtBddokEd04nNXj1chaP04ooFq+CApmg/lJthY79sAfeuB/FR3tNTL7+BwdB2g0VUjF/u63jWZqMnJPfyYoHMiLStkQnCk5hRun+8lNsDrnRW6G5Ur6cJ0+vo1rarO7GJEFbeL5o0wyOp8M/uc8BrJqZH8HwD7HGzdoNhB9gHoYiHyn7y3n/PZcgz+rTl25eOLDtM7tQDBb3kU5jbUjk3nsv4DkQ0M2ycIcjljcGQgrgyyaNXC5TdJYyB+o0FGx9/PnsKEACTXbzvbSXQXH3TBQRiJkObON5CdkLQtJn+/YV6I/C1b7gB7BfQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ydGWIkLBzL07/XU6KbOqrvPb1dDiJlW3CCbn1DQFz3Q=;
 b=L5ixu+Yq81giPbdXgYKJjB86mgHWgyrsn73WqP+pGlZiceJ11FuzrZyW75r5J5b7KDWZAI/DN1m5kFRQnrW4HS+FYdfL1O+6ZwGtJbcWJEXsNrinhZETUQsTUhSOWHyduiuT8GlZNfgLnRXKc42fdYQjCJLkt5UoGQyb2qaHpLQ=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 IA0PR10MB6746.namprd10.prod.outlook.com (2603:10b6:208:43e::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5654.24; Wed, 28 Sep
 2022 19:14:15 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::5503:f2f0:f101:9a22%8]) with mapi id 15.20.5654.025; Wed, 28 Sep 2022
 19:14:15 +0000
Message-ID: <5ef92950-1ab0-73c1-edf2-6f16edb5e079@oracle.com>
Date:   Wed, 28 Sep 2022 14:14:14 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] target/iblock: fold
 iblock_emulate_read_cap_with_block_size into iblock_get_blocks
To:     Christoph Hellwig <hch@lst.de>, martin.petersen@oracle.com
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20220927082225.271975-1-hch@lst.de>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220927082225.271975-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH0PR07CA0010.namprd07.prod.outlook.com
 (2603:10b6:610:32::15) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|IA0PR10MB6746:EE_
X-MS-Office365-Filtering-Correlation-Id: a9545fbd-f01b-42f2-c5ee-08daa185a278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 322/M+gw4hbaGEEm0SOd68znRGlOCvYCEWZ2xrvJqapqMl//abCTWBiZ6x3WNxlA3Bnuw4t75mUHjGuf0omUOd8UQzhSnoq9PJ3V7HJ+d11NVEFQC6P+sbchLCN9/jFXWPn+kFmlP3F69ykCJ3nfDGW3Ik/sFjo4a3P1PRZQ1TsApioDi9EtIa2K5ki1upvr7ENRXxhZJhwrqN8tCTKcg0lu9oDoMP1/pu11n/U4S4XqGP6IloRXzE9EjZxFR82WfBAxk7jl60IwKmY0pw7N042i7R2ff50Nqfwm28ZO0ZC1OFaYWOAfGxcKEUQiKwsRa1HQeALsYWk03nfiiUSQRxI5kje4ThNoAkFSKD03YSO4onzDXQcU8dCq4uvp44TzADFupB7JwbyGNvJnAPA3X2doSbNWV+2zbVwdQVbsfVrHWGeNMk8UYizAxzdx0bKXk0CY/xU/oHeWQJGeDvC06j9igrUPnZihwP44VSGITMX/86gsLuhYVKgIgmxXeYEJI5jNkcoS2CcelMwtDmIlrEobkVnJgAk/TTCK+WplFzOH0duVBVqDt5syu06gAEjeRMlFKvGe2FWcxGu5IkGVu4oaezw9V0KvXhoT0QZMq+kP1d1wCCzgcF/o9du2PDMi8DGTg6GzODp0GwMggW0kJ7bA0pT4XfdSYU/0o7b0kvZd7tMIIBpkv5Bz3PdWMv6HkBzDdD6XaWJmKocRC8DpQrtBBZ2HFe60PNBbDp52ieEYMG9aubJ7j4ZMcvQDEVKqu+mOZIBW9KJ4zOy4IQxjeIi/VzufVhsmN+qgWcVPdCE=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(366004)(396003)(136003)(376002)(346002)(39860400002)(451199015)(186003)(2616005)(6512007)(38100700002)(86362001)(31696002)(83380400001)(66476007)(8936002)(5660300002)(2906002)(66556008)(41300700001)(4744005)(316002)(478600001)(66946007)(8676002)(6506007)(36756003)(26005)(4326008)(6636002)(31686004)(53546011)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?cC9XQ0U2clNQVFoweEhkcUQvWWQ5SHNPQ0Z2dlo2Y3djVlRTVTRnNmYwL21J?=
 =?utf-8?B?KzZORVhNQlpaQjhST3htc3lTRGEyNm1Gb0RIQlFjUTR4Rks2eUZ5c1BDYTQy?=
 =?utf-8?B?WHFneStyZERNVUVhSkVkQk1aMGw0WTRUV2EwQUlzaS9DQ1VGMEtJb3dIcHNZ?=
 =?utf-8?B?VHRmMGdrbUUyenluR3drSlhybDRpb3ZPb0k1ZGVPenFXT25yWXR6UUQ3VDZ2?=
 =?utf-8?B?OGtUMzNJRjZnTkx3U1VWZUR2REMxOHQ4d1NnRC81WFJrTHBiTFEyaTZZUm9F?=
 =?utf-8?B?NWgvaWdIb0V2M1AyZzhUWENQeWV3K0Z3YktzdDZKRmtmWmlwUzJqaTR4M0Ey?=
 =?utf-8?B?VW04OGptVnZuTHVyQWJ3TllKOUVIUldUWCsxbXljY3dVczh6RWdwVFI5dFJY?=
 =?utf-8?B?YTk0MzkwT0tGUUdTVCtLYnNjOHFPdGVsMW5adHNBb3JiY1VKRVNhaVkzd3pG?=
 =?utf-8?B?QVhLcUwrckxLdjRreWNJTUlqT1JRdmJoc0hnQjRQRXlCVkdXci9jVVN5clZu?=
 =?utf-8?B?UG00c21FVmp1NlE4dWdyK2NuMzlkQmJKZmt2aS9iM2VnWGUrbnVzTkZMbHdX?=
 =?utf-8?B?a0Z0TVVHdW9ZTWlSV3RyN0M5RXp4WFA2NTc5ZWJPaVg3QVEzQmlaazM2OVA4?=
 =?utf-8?B?ZGNTVEh6Z001VVlvWkY3RE1kaFhEMXB2emdqaUJDVU5uOFJwaEpFVkVoRUFF?=
 =?utf-8?B?T0Q5bndVM3dPaXIvdk0yYUpNK3hQWkRyZEttMWxlT1BxeDF4eHVIVGZTMHZx?=
 =?utf-8?B?KzlpcEJ6NHM1VFQ5OFVyUGJNbldHRitWVTZXYWRWeU5kNHhZcWlhUkdOUTgv?=
 =?utf-8?B?YWRNbmN1YkN1VTBmNWMveVFaTGNPNEEvbVJBWFhGQ0F2TlVMMktwaFdYSFlY?=
 =?utf-8?B?aklOS0hWSENiY2FzbUlHRVZrckJvVHRxTjVIeHdWbHFoaCtmU3hxUm03NnJL?=
 =?utf-8?B?ck81bFdHcktXVFdLenlLbU5DQzVMVmhBVUpxVG9tQUdBWTdSSnFRUUFyTGpr?=
 =?utf-8?B?ZWlCZUZxWGQyNk9iYjFVNG14Mjd0ODFDU0lzOC83QVg0VWdsZERGVVJmMEVU?=
 =?utf-8?B?TkdFUCsweVBVQ0NTZ2tPRFh5dmRCbm1ZOGt1RjFxRm9PeHBRcmJUSXA1WGpG?=
 =?utf-8?B?TCtqZi9nUGYvazVCMWFBQ1lFd0F0bXU5d014QkJrRHh0U2NrOCtiU2g3c1FZ?=
 =?utf-8?B?OVJiZlpEaEVxZm9pZkN3Qjk0L1Y1SUpQczdaZjJ0dEIybGtyc0lBcU1yRTc2?=
 =?utf-8?B?amNPTDJ3M3hTV1Z4ci8xcFpCeVN0RTlYYlQ0UGZqNEtPL0RtZ2R6MTJSTVk4?=
 =?utf-8?B?V0ZXZldoTHBnRnBiWGdKMDFWU0FoakhNMXc0d1ZTWVdxQnQxUVhOSVhoUERR?=
 =?utf-8?B?Wm1iNnY0STg1cTBOaFIwcFJjSVRabUpudXpxanVIeStBMU5TdkZEK2o5UTR3?=
 =?utf-8?B?OHhwRHlMN3VBQ1lzQXRFWUNRenUzVFdmN2hsdVVKWWlZUER0UHBQZU1Dc3dJ?=
 =?utf-8?B?dDFtY09sV040SUwxclZWZTVBckFNMEF1bGE1bHVtZ0hQSGtXUm1DNkwxN0sy?=
 =?utf-8?B?TjJsdVdpTllRTGdTcE5CUzl1NW5Va1pUTkordURWWDFNem5OV00zU0lzMUFT?=
 =?utf-8?B?bTVKakhXT0tpWW1FbzRJZ20xWjg0SVAwTHBTS0g4akorV3hNWk5LeFJaT2c3?=
 =?utf-8?B?THp2alZMY3RyZGNUbVVXR095L2xjcVJyUkp0M2N3Y2xUcTZHanh5ZWJrNEg3?=
 =?utf-8?B?eitxT2M5Nm9ZZlU0bGxhT2ZZMUJCR3U0NzBVSWt3R2hoOXU5bWdrZ3RqMWVK?=
 =?utf-8?B?Q2lVcXZpUDNva0VScmdiSFBNTlI5MXlmZy9RQTIrTmQzODQ5elpZTVdCdjYx?=
 =?utf-8?B?cllWSjVzT2VFSUJCQmltMHQxdmE5UmtyOXhpY3BUMTRHVkJ5blBQdDQxNnV6?=
 =?utf-8?B?aWxjMndRKzVUdTMzZDI1amtXVzczMloya29PZkgyY005WkNyVjU2YUhaUVl4?=
 =?utf-8?B?UFBsU0JlNzFjN0ZPdjVMcFduMHpDbTVEdkp1VVZrdFcvdEczRkFuZEtjOFVv?=
 =?utf-8?B?alhQazBNR3R4dStyb0U4R0Z3bmRXZHVzUjZ1T0k5TTk0bC9idUNiY2tQYUJl?=
 =?utf-8?B?WTNmQzg0NGNlWkJPQW81akZZTm5vSkhJL2NHMkF6U3lRVGorcW1zeXNTcmI2?=
 =?utf-8?B?RUE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a9545fbd-f01b-42f2-c5ee-08daa185a278
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 28 Sep 2022 19:14:15.7080
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: n65Ki25wKBLiXmnloy3qHVr8jLq7DHU/lv336NtfLJbcW0uGDqIt3ImEBPOReCnRRaYUJIOAcwa51TRqanPyPGx+07ckQUprXzlgxeMZS2U=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: IA0PR10MB6746
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.205,Aquarius:18.0.895,Hydra:6.0.528,FMLib:17.11.122.1
 definitions=2022-09-28_09,2022-09-28_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 malwarescore=0
 suspectscore=0 adultscore=0 mlxscore=0 spamscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2209130000 definitions=main-2209280115
X-Proofpoint-GUID: h1nNklXQb0mvicBvsvA1tfXACWPeodCf
X-Proofpoint-ORIG-GUID: h1nNklXQb0mvicBvsvA1tfXACWPeodCf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 3:22 AM, Christoph Hellwig wrote:
> Fold iblock_emulate_read_cap_with_block_size into its only caller.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> ---
>  drivers/target/target_core_iblock.c | 19 ++++---------------
>  1 file changed, 4 insertions(+), 15 deletions(-)
>

Reviewed-by: Mike Christie <michael.christie@oracle.com>

