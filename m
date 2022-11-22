Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AB9ADC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Nov 2022 20:07:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234126AbiKVUHG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Nov 2022 15:07:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234030AbiKVUHE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Nov 2022 15:07:04 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78AA98A168
        for <linux-scsi@vger.kernel.org>; Tue, 22 Nov 2022 12:07:03 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2AMJtwtJ001554;
        Tue, 22 Nov 2022 20:06:52 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=43IDP7oVN8Rhe/4LEXePFaimUwFfNw9I00RViNBCbMI=;
 b=IFR1PUwCUqGBKlh+5HtPRgXN7xWbQlW3lAyLvNKjCNJCMMrbj4U21Httw2XzalGdUs3z
 I8Qhdl/fIFlDvaUKIl9rISzPcLi2ZY1CTLGtoYxcqLRYLYZc8siOucDzV2pFoaI4ZU5/
 ckAMfBUmmQz/Lssn1yv2kcCokg7RvRnZDyqBHDnNHn10KCHuZck8oj7fLq0xNEWWk7T4
 +hLY4oV5lxsExGnHlhZcYP0K4IFW5i8P+g/FBSR2pkKe86k6kEJIK2L/ALPtLkLlc95L
 cPmhZSySvISwLhp7MgF5vEMTiykjhAIstVA4/PPqEne2KBEYKB+vsDV8ezHSkCxdeC0N uw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3m13w8r85b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 20:06:50 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AMIFgof039517;
        Tue, 22 Nov 2022 20:06:49 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnkc6jxx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 22 Nov 2022 20:06:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BBJspm4fNDyHmB4aCwrf626Li82N8xXHcmgJAnv9rPa9RCbyfUl0/ygEEc91FnLIORV84SMgUr1yfVnH1H9aoo23Wd1VnxgTVheY1s80HXVJlYJ3m1nORlJWWhsU0ZKxunstGA7bg95WURMsJ/dKo008nmuO6h2jtCyXN6gdrAUTGAVplIQ+WWOnNm3AeiNHtZriAdBp4/fXg3rQnBm3gfWi+SRnQJjKH/tl2ASi3+CvbFExgcTOVLq4Pdviq0De5eUNQJZiBY/klaa5f0/p3vk+Ga4q5UuUWyhvFaMBHwUZ3/NPIOmS5DByJi9sIroLRkPZJAkDYpzjwsaQxAsaEg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=43IDP7oVN8Rhe/4LEXePFaimUwFfNw9I00RViNBCbMI=;
 b=PWyh7Ev37ccnZRctpMQ2FusmAcFB3jTqAol07ixYNYBYMhtUTlMKfX4SO0fRKR802aGY36LE/5KOPvGV6fBb3LTKtcXlEnsyATOhGt9lLxZItPrZrlCMXNQSpv9366ExANjFA2CmZ0GNMF0sRT82Bzfz9mirb+W80ly8NoQaxyxq/VnKCUNPO9EDDverxntpsb9dCKQYpLvxVpfTJdvQXpivQrh2va5USSFHo4mNqiCnWLhl5Y7Gd053kGoLFZVm9SXXK3cInKGQBwG+8M3qm9OBlEdxRkHyNXuUF9JfhoNWHfEUvYdfhe2tV1mdLi051hVGTyjCVEeywxpfLDPefg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=43IDP7oVN8Rhe/4LEXePFaimUwFfNw9I00RViNBCbMI=;
 b=sKiHAAKrVHgjja7hePbk5SiSyEcgjwTfre02u3ZIFB6s+/Ff60drJVknVgBR30h6VD03vnXu6yLKy4sEPjou6UXD8LR/7zWNR7flgItfMiCWZN0uAbzY5BvsPT7QhH5b5WzSGzu4fGldRU1tHeI2WdbhGfhrTM9G/eu5BINHZBk=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 MN0PR10MB6006.namprd10.prod.outlook.com (2603:10b6:208:3ca::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5834.15; Tue, 22 Nov 2022 20:06:47 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5834.015; Tue, 22 Nov 2022
 20:06:46 +0000
Message-ID: <1f2715fa-051a-191b-c3a0-433a78c5f3d9@oracle.com>
Date:   Tue, 22 Nov 2022 14:06:44 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 06/15] scsi: core: Convert to scsi_execute_cmd
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>
Cc:     mwilck@suse.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20221122033934.33797-1-michael.christie@oracle.com>
 <20221122033934.33797-7-michael.christie@oracle.com>
 <20221122063836.GB14514@lst.de>
 <33b7d1ca-4421-2f90-071b-0661f3893865@oracle.com>
 <92d8899c-7a73-ebde-87f6-8defab44d551@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <92d8899c-7a73-ebde-87f6-8defab44d551@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: CH0PR08CA0023.namprd08.prod.outlook.com
 (2603:10b6:610:33::28) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|MN0PR10MB6006:EE_
X-MS-Office365-Filtering-Correlation-Id: 6b96ac53-04e3-4986-2c52-08daccc51573
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F8Jp3Nal0JPGOWDPAk+uhVSgXbKp8MHvZan1uVIREfqqRJoeD6XL+5PR82dUtuuXpVglv+JAQAqTmfkOFfoE4VXldIk7wpikYjv8JXRGbOcMbEE6JH482D754O6hLh0406b0IWNA8QZk/r6otdmzOG1VuQ9dPNWiu6wjCCS1ulEXLgMxyQdSheUj2rn2xCXzfxuTNmRYWfSh0/uLqXxy4Gzgifu0AWRUKi9AsMY6bhcjpfn0eSaSeTTd1ZEdHcLtzSdagdlBY4/DGznaG6Etazv8iw/+dXUwH8XJ3ALGkdSV6TqzC9Y2NKdkt1OJmdqibwHcWl9b9vX8oApPE5n6QWEszzXrGC7CSyywYuieAfIVZFM7g8CiDFjrnE9mr1b5tiD4vnsfWFRoopV5SarXgvg9UMeV/6lAZ7v3qfn9w1992Ekgy1BZwD8I1sNYpw3vQKMhxv0UnB7KOA+dAa+SP9462M2zLkX/vWA3SHomzBbeIKP+Wj7YzZETQWFzYGVSafxxHPlWrLi0eV7hGDSoGXhyqZM57RFhOyKhEY1711EWhM3rQH3icePm2/4GBNerQ93PzUnPhEDvOV6FIpECtSBZUQVoycLxGAeJ279kmxxPnN4oyneJlQws0bh9ZFLDcQOXP+zg5NIr5ma7eh/yn0XoL/mjG8IS5o7dBk9MGHYmk6MDkgk0ZbJv5XadqctVFmXPZkWQJlUd7NNL1vZJb8WgLWPPkrDZ7HWXEYo5X/Y=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(136003)(366004)(39860400002)(396003)(346002)(376002)(451199015)(6506007)(6486002)(53546011)(6512007)(26005)(186003)(110136005)(36756003)(2906002)(478600001)(38100700002)(31696002)(86362001)(83380400001)(2616005)(31686004)(8936002)(41300700001)(66556008)(66946007)(66476007)(8676002)(5660300002)(4326008)(316002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TCtzQVRkeXJJOFlZSDFjTXVrOVc4Q2JhYjdqRjR2N3RvckVLOGNmdlJUUUd3?=
 =?utf-8?B?cUFuNmpnVXV0cG4wUU9TRnZuSFlrVXltSTEvT0tpeFVQeUhZYi9KNndaM3JT?=
 =?utf-8?B?VGpGbWFpOEdXRUxwY3lqM1JoeFpsNWtyZVZuQUIvNk5SQXRIU0lBQ2xkOXlo?=
 =?utf-8?B?U0FyUWN1SjJBSWtxQTd5MWZMMjVVTHNZdDFvMVAzeUVTbWtnYzAzcUhLaEV3?=
 =?utf-8?B?NzVFb1dIN1QwYTB3ZjhOZThTTnVzZTF6QjRKN1Z5dmw4enpHa0o0SS9ZZlVU?=
 =?utf-8?B?UWpFSmxQTU5zS21hTDZpamxYWjQ3bTJjbTZacEhDY0trQ1hxVkRiTWl2eldq?=
 =?utf-8?B?cWdlRFErYmhHTGRVcGRtTk9TbUs4WjlUWVZWVlpDbGlaOVhEOVZzb1FGdTdB?=
 =?utf-8?B?SnA3c282MEx1cnMyaFlDaGdRMGhrWW5PeDltc01rMzhCU0dEQWcwTklFWHdE?=
 =?utf-8?B?Mk5FVjVaQVdXY0g2YlZoQ2FIOWFGd2YzNXFTVzd3STlhNzloSmdYVUJlb3Nh?=
 =?utf-8?B?MGVxR1daNHdVUkNpYjNNTHFMVlFBUlkxVkVCU2ExeHkvYVpXSHQ0eUh5RnJJ?=
 =?utf-8?B?c3B4QzhLZGJKbzFkVWF5amJIRysyVVM5S2RMNElYL1lIZTd3NEg4VEFNTTRX?=
 =?utf-8?B?clVGU1dtSDlYYTJGbGVhbHplNDByMmNQTU1iWWNsNDJ4bFNqeHlnMHFMdmdv?=
 =?utf-8?B?dlpuL29uR0IrbHl2T0cxenFTYkNPZktUZ1d0ajgzSVhTSUhGaXl0M3c5ZGM3?=
 =?utf-8?B?c2JVc2x1aWowSE9rREhkTUx0WU5MN2pGSjNxNUxkelppQVU0aWRldjFnV2ty?=
 =?utf-8?B?RHBGK0FMdC9qemhjYzZ5MWMvNjE0TTJLUnYwUEJGYmRGbEI4NmRnVm1naXhm?=
 =?utf-8?B?Sko5dUpnWjJRL1B3UHFHRHB3VEFPUlRGeXJKcFdzcUl3UWpEK1pmVU40bHgr?=
 =?utf-8?B?MGsvQ2JnMEpkcENYOUwzaVozdUd4VkM0anlNeitCYTZGeVFhNFZsVm1FemM3?=
 =?utf-8?B?aEc3YXRERnl5K0YzamVSM1U1SHVDVnVjbHgzdVpaaFgyVVFlLzUyTGRHMWVm?=
 =?utf-8?B?U0JwYW53bFAwRWwvMmwvZGxQSkZVUVBBZ3N2cXA1d0ozbktLbVM1Z2FCbFh4?=
 =?utf-8?B?NC9MVGFuQ1JjeUlKVUNtUUdoY0FNbXI0YkdPbjBrSkx6VEo0SGZpcWRrWlFJ?=
 =?utf-8?B?VnBNVjMxZlY3L3hOZVp4R0hsVTdNdkxQL05yeTNTcHl6OTFXbjBpMk1JS0p0?=
 =?utf-8?B?K0ZJenhHMnBKQk5sd1JRaDR6ZmlsRy9UM1IyMG13NUgvWmJ1V3p3NlpNSmFx?=
 =?utf-8?B?SjJQMDFIZEpVVEx0VEdLNFlmMDA5WkZxRElrTlg4Ny9BQWtNeEpNTldKMkNa?=
 =?utf-8?B?c0VNelJ2bjNkK1NEc3Q3MWhjQ0xvNUV1NUpWOGdPWDlXeWVoT3dLZm9TV05y?=
 =?utf-8?B?eUxHbVVuMmgrY1hCQi93R0dUTkcycXdkYWh4b292cUY1ME9JQ0t3Ujhmcmhq?=
 =?utf-8?B?anlvN01JcnAxSTVxejg2VjB3RUlFcEVJYXArTkdQQ1o5Mk1xMDR0Uzc1dGZw?=
 =?utf-8?B?QXFZc3BvdU1Qd3JvR3B1blM1R1daaGVzYlZFcGRDMTAzZEFGV1pLTVB1UWVr?=
 =?utf-8?B?cTgyRXl5MWU4WlBjNndXVGJRQno5QUYwZmJYdEhSZjh3M2lBNFdhaWo4OXRm?=
 =?utf-8?B?UnZQUmV2b09uaklLaDhJQ1lucVp6N0c1c1puOUhCck1nbE1QcFd5M1RKN3Vx?=
 =?utf-8?B?RFMxVklVbXExSEYyeEphQXA1bG9WQTZETGRBM3pFQUlBQ2xveUJwOExoTG0z?=
 =?utf-8?B?dUZ3MzlmQW56a3huZElkOWpNcGVOenpUaTZkYTdLTTRCNlNQTHJOWkx3cUdW?=
 =?utf-8?B?Ung0SDlaTjBlcUxaSS9JOVRadTdCZDNYWEE4YTdqQjhuVXQyejhocitSbkZZ?=
 =?utf-8?B?bjZVVmJoN1NZdjlTTVFiQWcrdStLWmgvd2xPL1BTWFByRU84Y21ZM0Zpc1hh?=
 =?utf-8?B?UFlpcWZ3eldDRGlXMXFzNnJYaFI4eXh6RHZpcjNGZ3Y2N1kvRE1mTWdCTDA5?=
 =?utf-8?B?NXMzVXlaOHhGbjJySEl4ZTJSRGhmUm5JM2tRT3JpWUZoY0hNTVVReGV1L285?=
 =?utf-8?B?ZjAwYlo4bVY5d1FWT0hLMmJ1RWdlK0hZUG5CdEg0TThRbWtCcXFBbFhoODVr?=
 =?utf-8?B?d0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: Nv/Br7Q6AdVCy5+hq2TM/dcl7yg9uQEQIpeR3hNQNCiGlMz6PTKX1zv2/3O7oFal/7Wnmuk57wDYP1NdiggGpckd3tvM74y/NSleWhaZc0QUcn946wCjjf6tmvQT8qmPR2ZZn027b/27mp8I8le6E3bCL9HQOtX7yMXbUn3Yn5aKvs+3xHp0CFUpJ+2jKyhqAo6cpHCMEzEYeCt5BbYP/ccxq8GPAVQph5uAC2fih8Gh/Zofg6gEXD29EZ23+uI8mk3JSQVWjdNw3l8hhvXJM1/jQuF6KUPOSlLKXjtpHSdb+IdGAX/+U36/n1pW6MEcer+rKJZgTzruHF+Ik0y+pitrNaWZkdmg4Upc7MugrPN0pZCeVz2KV4WFjTk9+SXmrbSKHVPce43utb7ttjcdL5+PjAuVS3AIxXiwt6xjwU7RtvJmfscVE3b8hY7GWsw0pCGiK8a3nU5WNmEGD2AEuIhxnl1Ag7D78FzMFWLOykjJC5NuY2dbFRt6RKnqxJC/Bw4iE9kMa47b9pXvgYO34OBHS1jnKSEgk6lMktJvKnV7jhNCx4aFRw3g/Z1ZgGCC/tmbNF6Z8PYGmmAaSIG8fXeUv1qttJHXwM8oCy03Yg0NNfWMs8B3CjZR5MaWSlJ+PEoESrMLVXD2vPk9tY1SAKg/7RMfK+AsuEZV25PbpuKRhoJr8drv51qMHri/gQFVpCin+4D3qQtyJqr3fKV0k2lqhB/tdt0IAJAZgafEIGUcDP43FfdiPZ//8RhedAeki35hZtfbyLnXEx9picOaPF66bG/TLRFL0iYAr5Ihz7C48VuGdWi6sF4Ix/onskgOATMF99XvkutVLddAXLqzrTiKu5hxAR58+n7IixGR3Nbxqux5xWGMjUWV9Nq6y8LU
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6b96ac53-04e3-4986-2c52-08daccc51573
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Nov 2022 20:06:46.8870
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WQRB9KyLMKv/cQa7n1l9CpYpvNKNeIPMmHZuaud0BoysqNY4+e0vN+0hllY7436Yqx9jOJyAszmCYuSN0/wXjz1YoGVcB3WeaCQGipTj5uc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB6006
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-22_11,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211220156
X-Proofpoint-ORIG-GUID: arhpf7y0PjrhQJbPVNx_PgOWvr8rmnH4
X-Proofpoint-GUID: arhpf7y0PjrhQJbPVNx_PgOWvr8rmnH4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/22/22 12:46 PM, Bart Van Assche wrote:
> On 11/22/22 08:13, Mike Christie wrote:
>> On 11/22/22 12:38 AM, Christoph Hellwig wrote:
>>> On Mon, Nov 21, 2022 at 09:39:25PM -0600, Mike Christie wrote:
>>>> +    result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
>>>> +                  request_len, 30 * HZ, 3,
>>>> +                  ((struct scsi_exec_args) { .sshdr = &sshdr }));
>>>
>>> Maybe it's me, but I hate the syntax to declare structs inside argument
>>
>> I'll change it to setup the scsi_exec_args struct like normal. I've got this
>> comment several times now.
>>
>> With the current design we know all the args when we declare the variables so
>> I can do it then like normal.
> 
> Will struct scsi_exec_args be retained? I'm asking this because I'd like to add another argument to the (already too large) argument list of scsi_execute().

Yes. I just meant for the above chunk I would move the struct setup like this:

@@ -509,6 +509,9 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 {
 	unsigned char cmd[16];
 	struct scsi_sense_hdr sshdr;
+	struct scsi_exec_args exec_args = {
+		.sshdr = &sshdr,
+	};
 	int result, request_len;
 
 	if (sdev->no_report_opcodes || sdev->scsi_level < SCSI_SPC_3)
@@ -532,8 +535,7 @@ int scsi_report_opcode(struct scsi_device *sdev, unsigned char *buffer,
 	memset(buffer, 0, len);
 
 	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buffer,
-				  request_len, 30 * HZ, 3,
-				  ((struct scsi_exec_args) { .sshdr = &sshdr }));
+				  request_len, 30 * HZ, 3, exec_args);
 
 	if (result < 0)
 		return result;


