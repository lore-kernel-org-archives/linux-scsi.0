Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D06D7C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 18:37:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiKJShY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 13:37:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229562AbiKJShW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 13:37:22 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0AB6B1583B
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 10:37:20 -0800 (PST)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAIQRJX014261;
        Thu, 10 Nov 2022 18:37:08 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=uGGy5S3Fw97hS/ZsLu1MGGGK0JqcQtPfumiK3MR5M+Y=;
 b=cPZUhJm8FmRkILSymOZioS4wWHJFGXXg85pU6U11pzLgOlb8qCQyyjCzukoiSK4jE8Lf
 smEJqfUSWGsXrjZb94LP+2q9f8gYLZJG+DvdSH1rrzdK71570MYgQfHA8P+EJ/lMJD7S
 ni2PtMEKxmZE1gROPeely7hXoIWztV+5SDq/p9VWxkEm/2F3JxAdVM644xkea9uSZp2U
 x3Qd3ajA0xhPgMsq77I+MYIu6xMasb2X0N27k4H9NzwbEMihLhJROgOv0j5S9GDzFQRe
 JxJ5Z3eOAOw5qLWIIeMouAg2NbVjCYhPVGD0MbM4PnBk89N0FkOigE+WyLDfD9Q2g7Ux +A== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3ks6jv00h8-91
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:37:04 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2AAHcqsc014968;
        Thu, 10 Nov 2022 18:11:33 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3kpctfh916-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 10 Nov 2022 18:11:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=l1nGZ0qRFe9thsLuwgFzLzeA3uPNtyOnaw5td/GP9mSAfxAfRoktQKxVa0eLh4HNYEjBVR3J5B1uap1yJpPYmKNIPjuzs5uw69ZUNfIbBZwQRq0UL6Z7Elk983UyJ5L5LJolW+g17XrObWav507NPls+rO7rMFNEu4KPXek1trkVeEAKTwKHUVG0Ti0yn6vHFgwA3hiIkuCF6qdJ9SQxVwlwvrna0rDm4tQmM/g/K00RcM3aK/Qjv4W1SuYYw+3LHwsiwUBjRRvpe98V8kfOo29A9+hZKDtIjxFoV7VzZEce8hmj595GU4xxLbo11OF9MbcLCPBzaS/3F05smOEQrQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=uGGy5S3Fw97hS/ZsLu1MGGGK0JqcQtPfumiK3MR5M+Y=;
 b=IGMIXusUj8BJtsIdEjHEJkDscZJkMjxgRWw21Z9lbG1cdEgKGC9Jvnw6qbZmeMRcEWvnfVGnX8ZFP+TLmNXqV6yDVrs+q7CkoBA72zZ7ZyR9xGHRWXX3UKRuifIUkuqrOMTfBWpj/GFsXIF6Qa8WPU8J8XgZlVOo1prKilJvm7qPwyEd7iYF/fljAN4+s7StSUqOxxhL7OTRutzglbbtbzhnQCCnUZgGL0LpXYByOkd3VJqgS3rAT7wOVvGE+wQzEuv11s0ACQKvxm4D0W8KB5EdHf6TVjWd2qaPARG0xty2p3FIsO3VfwTOw22rElfdbKU4HzxiLObqZXAMpFl8fA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=uGGy5S3Fw97hS/ZsLu1MGGGK0JqcQtPfumiK3MR5M+Y=;
 b=I7DByQMUaqmBqKsEjDFauyNhvH5JTXk+4Rl/hcnl+yNxDkhEIrmpIkgWPieImXLWEVQgNFGeQ+pfZVh99/D2weCLNC2NaqY57itLd95z73qfMv63rsRl22KpusRHrXmAKRKM/CceIUBCbvkx3YNwtG6roi8ANrci3OffpDqVxjY=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 CH0PR10MB5242.namprd10.prod.outlook.com (2603:10b6:610:c2::11) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5813.13; Thu, 10 Nov 2022 18:11:31 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::19f7:e081:85b4:c5df%7]) with mapi id 15.20.5813.013; Thu, 10 Nov 2022
 18:11:31 +0000
Message-ID: <f1a0a01b-e934-1ef8-bd23-821d855e976c@oracle.com>
Date:   Thu, 10 Nov 2022 12:11:30 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH v2] scsi: iscsi: fix possible memory leak when
 device_register failed
Content-Language: en-US
To:     Zhou Guanghui <zhouguanghui1@huawei.com>, lduncan@suse.com,
        cleech@redhat.com, jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org
References: <20221110033729.1555-1-zhouguanghui1@huawei.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20221110033729.1555-1-zhouguanghui1@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: CH2PR07CA0048.namprd07.prod.outlook.com
 (2603:10b6:610:5b::22) To DM5PR10MB1466.namprd10.prod.outlook.com
 (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM5PR10MB1466:EE_|CH0PR10MB5242:EE_
X-MS-Office365-Filtering-Correlation-Id: 15144344-e7c5-49de-52f0-08dac346fea3
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: r912TIrXI9sw0DYKm+09Xl0Ee5rthVyd9NQhXxB2Realq9SAB8XaYCN89o6Yr0U32PBDk2zyocfMtQlRC8petynBRvFZ97P290+Yl4dbQ9FoeLz1+oEUOijAYsaW7gWD8NrFboVISiLQ00g5U0imsrWa0gZYIAKMzsiVLMAzuN48C1sBFg2YYWVw+D4PoQ2sYqLifBwl8Wmu1YskFE55YrBI8zXD/WHUfrwfjlYG+V5+i2oSrpRUY/Mt6RrpY2qNZnvYqnZd1kuv5OPguaQkQeZLaBptI/VLAtUi6d/Z00Hrzg4dVSES+GIVKLWjSnx6Gg0fYnby5y6r7FwJMUFNvBmLt02jkA3jfg2nS1z+OAP8OkbzS96okVlDGEH8HI0GbnhOBnOZZ6zCfJs4uWNgZGSCPNSb/HOocAlPKLt2GfKnvyeoUTEEVPyh8ziNyvyJS4CBn61Azmn7AZrbYlA0rAT3weXYjIjKX9GR3NGsk3y6J5+LCepBk2tCuwaNDzR/SNO8liQV69NQRgjo7qnDpoN475PtpUh9MgHjwuvGQfoWd0yMolDAswiRfZbafaNT8f1W/sR6mLDEcvsFbC8TYxMlEkJb4p9nSzmmkenKPdpgbq+CVTX96MLAfoaS4KpTW6h3XbcO37sU4mtUUIISM8mncaVM/Ayt6/9nFyWtsGOMPLISmPXDk1hJKO+RRMxKLCsaFBPsktRaNXaVPqCaahQtxb7v3mdrjWouuZqqZ6cIgp0iLf/Ktes4K+FkhB6kLuxtao/nk0RYZlUTYZWVhOzaM5UNVMEsZvElZBNuJIU=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(366004)(39860400002)(396003)(376002)(136003)(451199015)(31686004)(6506007)(4326008)(2906002)(4744005)(38100700002)(86362001)(31696002)(41300700001)(5660300002)(8936002)(186003)(36756003)(478600001)(316002)(66476007)(66556008)(6636002)(66946007)(2616005)(26005)(53546011)(6512007)(8676002)(6486002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?OHJ6YXFzaVpvRE5NbXg5dmdEVitsUU53LzNBMEdQZExDbWd3dmNuYWVHdjRz?=
 =?utf-8?B?VU1TODRNMFZNaTlON2RLY3RoU2VnQVRhcEcwam9nM0hCejl1ZmNrem9iSkpF?=
 =?utf-8?B?YU5TZCtudkJHNDYrT3VOeGozdzhBcitwV25ubU5EcWo3Nmo5SThTK1dGVlpG?=
 =?utf-8?B?cE03M25ZaXBnUjlweENjRGJYNXFzQjlwVEJKS2ptcDIyeEVGTmthWUZBTDNU?=
 =?utf-8?B?dVB3YUNDZldhVmZMajRaN25ReGpoYkw2dlAvRkx4SEVOeHUwcFZPc0NDM2dK?=
 =?utf-8?B?OERieDQxcEpHKzZCb0pTZm9ERTZQMENpM0djTXVGdnY1Y2ZLRGpJRzlaRTJy?=
 =?utf-8?B?dkpvYmt4TVJnUmVMODZVMnZrZEZZQmY1SlBObFFEb1VFS20zcURXcWYvZmhF?=
 =?utf-8?B?K0tHaklKdmJjSFQ3aTZHa2V0YWJFRk1EenJUc2lYUzd1SnBBaGdOWUljWWpI?=
 =?utf-8?B?NEFNVUVCdzN5dFpWK0hhbWNlUmdqRnhWK2xtdGkrMjdJQkQ3UkdQYWZWejhF?=
 =?utf-8?B?d2lwaUJlME41NHdBZ2IvWmlkcFBHeXZTblUzbFkzZXZGallIaThuRnBJU3pH?=
 =?utf-8?B?aThrT054NkFvZ0VRTVYvRnFtbVZMbzN3Qng4dlJqVisvTlNzRHJucXNtWFpE?=
 =?utf-8?B?dWc0U1NHWVQyOHk4NTFvUFFCQ2FFc01tQTM0T2I2ZnJlcDRxN2VqSHdWUHhX?=
 =?utf-8?B?YTVEa0t1Y3BndXNrYTB4aEdNdXRNY2NVV0ZnUWVKZXRhSTR6bG84dmQ5b1Vu?=
 =?utf-8?B?TnlCUTVnanpVTzBuVE1GbU9ZRXBWT0xaSW5wY0dzVHNubTBpNGhqa0hzckNP?=
 =?utf-8?B?UnFnUEdrVFJha3B0SUpBbjRPU1NjRnRlMmVvM01yc0ZRbFErRml1K0RKdHBV?=
 =?utf-8?B?NzJwRzRwSDZzS1BaaWxSK25YTjlpZjBYVFRoRytiVFBncjcwalE2TGpWNm94?=
 =?utf-8?B?V0lyZURVdExtZ2k5OEo5NlI3bTZ4VGxrbVpLbVVxSVB5VjhwdDV3TE9NSGZX?=
 =?utf-8?B?UEZXcGd1dlhaZDllaGZhMGxudGZKN2pRK3dWdE5VQ1MxZXJ3UCtyelhIZDY0?=
 =?utf-8?B?OTBpbm80UElYMmh2TUd2aUJubXZjc0Jod3FKL0VHSmxlT3FwTFgwV1JQaHZw?=
 =?utf-8?B?YnppUTJUUmpTMXdpT014a2RYRUxZcVVUUGdVYndVU1IxT0lycnZKYkdhSFkw?=
 =?utf-8?B?Rk9JYXdnRlBPR0xrdTdpTUU2cThMR29MRlErZUpaeHNNT2ovcXovTzNVY0Jh?=
 =?utf-8?B?dzI3bENrbkRGeUo0ZDdXOFhnZDhEZnNsb1hvOVY5THdKdDZIdEszK0JEdlhB?=
 =?utf-8?B?T0kwTmorWnVQQU5JOW9kbVF2NGhVR014MWpKVlNERzBPdVppZWEvTEZmMXo0?=
 =?utf-8?B?emorUkVKVjdkeWZKVlJtTUt3TUtzcnh0U2xTbE82QW5RUzBCSit3VTA0bEF3?=
 =?utf-8?B?RUV4V09BZUVobmlhNTNuSUFMK3pxTEZub0FJRG9ZdG9HK2dZazJURVZJNkVm?=
 =?utf-8?B?Z2x0enhYNWpFNEtsdTFXaVBjeW1sRG9lM1ZpN0xieFRJMDFRTnM0cmoyU1NB?=
 =?utf-8?B?UTI5Qmx3QUJCNCt3ZzhyK2YyUkR0VFM1a0VKUC9OZW5JUjRCWEJVVWR4Rk4x?=
 =?utf-8?B?NVlKaFdrUWdndWhJTlAxcVdxa3Qwci9YR3lUVTd4VDMybmN5bldNMmxYNk5i?=
 =?utf-8?B?WlFZNVV2c0tNZnA2WUZYVkJNbGJsazlaS1NBSm9sTUlJWWVEWFM5Q3ZiV1ZB?=
 =?utf-8?B?dU9USzFVdmlMd0l4clFZNk42ZGRNcWZxcWVDNmFWekE0ZU9YSnlTT2U5NGNm?=
 =?utf-8?B?TVRNUEd2Yy9UeE02aTc5ejhRcW1pcm9lcXZnTXJWR3RZRlEydXFaUlJkeWR4?=
 =?utf-8?B?V3YvTVJhbU9rMEpZREd1TlRIbUNiSVpKQ0Vsdk55RG5VeEQ5MG55YU4zbjVB?=
 =?utf-8?B?T1ppdW02cnJFQUllQ2dJUFhnT09wR1ovQnBrdzg0TTJKNEFBNEl1VUZiV0w2?=
 =?utf-8?B?YkZrdXgyUEwyaHpyU3BYNGNWNkczbUZuNmllTmhiMnJ3cHpFTGl4NkRPWW9J?=
 =?utf-8?B?dkYzK0ttS2R4RnAvdERxd05GUVRhRXU0WGhCc1pselBvdlgyUE5CTEtxbFlo?=
 =?utf-8?B?WlMrenoyeWdVdld6T2p6Rk02WW10eExNRHVxUDJtU2tsK3MySHpURGxJaUM1?=
 =?utf-8?B?SEE9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 15144344-e7c5-49de-52f0-08dac346fea3
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Nov 2022 18:11:31.4996
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 5QEMv4ej5IfUineVACn76MAteEubWVGC6kebwaEC/HPBZbuZU4lzc/ryMVnUjm7EmRZbUJqnZxyAdzjXZo2S6Jq7dzEkOLMn9qgkgV+P8Rw=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5242
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-10_12,2022-11-09_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxscore=0 spamscore=0
 bulkscore=0 suspectscore=0 adultscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211100127
X-Proofpoint-ORIG-GUID: gOSLZyG7DT98zJb2PLnv-5CvLK_yTy85
X-Proofpoint-GUID: gOSLZyG7DT98zJb2PLnv-5CvLK_yTy85
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/9/22 9:37 PM, Zhou Guanghui wrote:
> If device_register() returns error, the name allocated by the
> dev_set_name() need be freed. As described in the comment of
> device_register(), we should use put_device() to give up the
> reference in the error path.
> 
> Fix this by calling put_device(), the name will be freed in the
> kobject_cleanup(), and this patch modified resources will be
> released by calling the corresponding callback function in the
> device_release().
> 
> Signed-off-by: Zhou Guanghui <zhouguanghui1@huawei.com>
> 

Thanks.

Reviewed-by: Mike Christie <michael.christie@oracle.com>

