Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 97C63C433EF
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jun 2022 18:02:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346296AbiFCSC0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jun 2022 14:02:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346304AbiFCSAK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jun 2022 14:00:10 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8C2B54020;
        Fri,  3 Jun 2022 10:56:02 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.5/8.17.1.5) with ESMTP id 253FK45T017182;
        Fri, 3 Jun 2022 17:55:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=G5fTWwuqQPA20Hs0sE1Mxc+X9OukdmglMQktv32cWNQ=;
 b=guzRNRcJ0a/GkkVdAVkjrykjywW7qg/5T+TftyJ9rC1VBuzNCL9tO2R3kHUuIqCK0/0M
 f33U5RKktYodYPYwUnB+hBUnYK4gxbnsj5RdUpCiA/Nw34sBgQz7y0uW6DLwSLPL9vU7
 C0y7dFWmABArni4yG2M93X4TM43cOo0qxWY8OgwGAEV1Ov5tACFygzBIpqKGLEm/Vy9s
 cLiYG3i+dHm7MjRpao8SbAVYt8b1jwIplzJEAv0sK8UhodahKzxcEqJUzpfJ6rLXSu2F
 WkDFqHYQNyykhUWu41DAvXxrRg81kIrgYGcNl/1vrc09M78pJ92r43MmflpQ7P+2qK9n sA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3gfgmsgwd9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 17:55:39 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.16.1.2/8.16.1.2) with SMTP id 253Hiubf018458;
        Fri, 3 Jun 2022 17:55:39 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com with ESMTP id 3gc8knu86u-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 03 Jun 2022 17:55:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jeak/fVlUh7E6WsccPdBeKcq07j6in9pGKI9pUvbA2GWxsc8eC0nb3W0bqITYiVOk+JdPxrvRkNa50rcZanHX9JXhO9NuuS8mJle3OVPy5nU5Avl8Ry4oRv3aLdQcO73P13qefVXFlyW67gCPllcex3AeYpGYDii4u+p9QlFlosr7RR9hJphWFnT01r/fRY7r7vf5a+H5+f5u+j3UYh2QIJZtC+nFdSQjVkd6zbn4YDrAthInTsQ7KBEX1nvxZo6gcsDGm4p9Db3wTYliGTWdcwgTYF4b0mn/gN0hmTKNuIowRaiCO1AsHygh8ExuG0u9c2sGxHzdJVHQ0us9LAPJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G5fTWwuqQPA20Hs0sE1Mxc+X9OukdmglMQktv32cWNQ=;
 b=RzvOGfiWwVbL59dil23KNvo3J423ZFy7VkgS2f7OZaJWTridjm6JPm5wfnciLG5hAfeVNWP/dQI3fZyH1b1FuwSkFSy6NmHDGFVgHp5Qq+VcXPx+oycV09FXRsCxJaXaBkL6Uz0DI6/KQ9K49uVC76fdf+xy9IVYKPDJGJEKmKwNuuxXT1Kwfy8h9n7PPZhiKen+NtUQ9VTCDbGzQ1qBSttMNJ7R+sBcLo19dR7b1kEtfmXndsHYY8+I9/jh7IhZiwe+sw5FwuAMWMzHxlap+67vnS9Qet2Ub2o+JbuhVYS2ufOxoXTWOPXXgDPUURIgma7oqiEybtI1meZeg2LPrA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G5fTWwuqQPA20Hs0sE1Mxc+X9OukdmglMQktv32cWNQ=;
 b=M+vO6ILV7Nac3X2a0XtzT5C5+horC9oaKkEtxagEbM/fN5EEiunhEjjx74tLNBiMJi70xoWlFHNZXXBY/3TPcyoOqEc8kK/1YuOjQV0kWl8D6mt0v6vg1I4Igz2IftFc14jM+qrHDV+sMGA8jB+YcKLfU6ZULKNVxw4wcLtLNnc=
Received: from DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7) by
 BL3PR10MB5490.namprd10.prod.outlook.com (2603:10b6:208:33d::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.5314.12; Fri, 3 Jun 2022 17:55:36 +0000
Received: from DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b]) by DM5PR10MB1466.namprd10.prod.outlook.com
 ([fe80::f81d:b8ef:c5a4:9c9b%3]) with mapi id 15.20.5293.019; Fri, 3 Jun 2022
 17:55:35 +0000
Message-ID: <2634b3ae-f63d-c711-36cd-bf8f56ecc43b@oracle.com>
Date:   Fri, 3 Jun 2022 12:55:33 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/8] Use block pr_ops in LIO
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>
Cc:     linux-block@vger.kernel.org, dm-devel@redhat.com,
        snitzer@kernel.org, axboe@kernel.dk, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-nvme@lists.infradead.org
References: <20220603065536.5641-1-michael.christie@oracle.com>
 <20220603114645.GA14309@lst.de>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <20220603114645.GA14309@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM5PR12CA0001.namprd12.prod.outlook.com (2603:10b6:4:1::11)
 To DM5PR10MB1466.namprd10.prod.outlook.com (2603:10b6:3:b::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: d14f32c5-61cc-427b-f303-08da458a42d8
X-MS-TrafficTypeDiagnostic: BL3PR10MB5490:EE_
X-Microsoft-Antispam-PRVS: <BL3PR10MB5490F0924F0FF8CE7353B730F1A19@BL3PR10MB5490.namprd10.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: QcEa1ejL2OB3/itfohEt1AaRiFwTF9rDvJRbZVX/pt6eK+42xjvRZkOf0Rw/jpyYshfbrP/r9BKQY9AeqPeMtmDJVVPkgVfYxHnjm+Sgnpika67uD5lPMMiJlR4tpOH4bFxD3dXT+bp3YYP3BXFFJjqSHnWqtzKhztNTpT4uc8W7/Koc+JhnN91Jqf3KCcQssv8A0uquYbNgTz9hnk4koAwobtOJQHIWjXL/LQTzSBNpeGkVD3YPZDuP6zPsRnrJVeadk3xgbSX2aoydRX2lLiHGMO8H6OAtoWOKxUj8GE7UJmmwjQgkT1o2kHxI3W1ok3Z2M1J3TavW1+19VCYt9mJHHX+xcoF2H4CwJf+DpQfRWulmap29cTiP0hrXk8Ugee4zyJSmGW6FdSAopMZiQyXYSIEsCbZKBlC91NWCtgqMiF2EITdsrYv3covpwJxAkgENUywGIoOkcouoqtRnYtfNzi366HDs7WIvww3JsC4qqZvKko6YVbTSa19dtKVUuXnmhs3Ci2Rh4NrgCdSZ2cg9J/jTwmwqOcoKNoHziILyKOdZVs/V0NAeWEbwOG3jTimdzJgx1sPX6XLF+r8ndgCXW+bfZZvkydh7D4O0kxiMc8YMZ+J9K2CH8P5U3FvQgagHjjHBmL63+2BQoR1fOH7CiWsiAXJvVlttLHd2R6+ndWaiOhogsMWYiPgMlhBHI+aG+/Ff1/khKoJTbJk79dEBUgr+O/kVYAxRLMlDCO/il56MMA1/dWvfSi8qCqGYKfS2wJ+xqdCj7gNxu4kUlqTRSjYkEoPW5R8pRcnEdkuTsB3/+I6wGvtzHUYV3k+ZgXU+sCmhzqJPBaj/JkIm4g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1466.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(186003)(36756003)(31696002)(53546011)(2616005)(31686004)(26005)(316002)(6512007)(6916009)(6506007)(86362001)(508600001)(2906002)(5660300002)(66476007)(83380400001)(38100700002)(8936002)(6486002)(66946007)(66556008)(4326008)(8676002)(966005)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RDlScERqTkt4UWFHZFZZMDFGMkZlQ0lVYUxpWnVGNm9ZejlrZTRBa1hhNjFr?=
 =?utf-8?B?RmdiS1N0U3IyMHZ6WHBYaDRSNXNxUzVaWkNpRnR4eFBQYXVwMmV4NllwRmUz?=
 =?utf-8?B?WWMwczJNcmhQeVl1M3JsWHNMazl4YTFNWHlnbnlWZS9YY0s0Rm9ucU5FbzVH?=
 =?utf-8?B?V1NIRnlZR3B1ck14anpuS1B4V0Nucmp6ejNCL0N0cWU2N2NJNUNIRmFZL3hR?=
 =?utf-8?B?YS9Sek40d1c5RDgwekJPZzJHaXFUMnhHMXV6UXNTZHI2b3pZVmxiM1dZcWFY?=
 =?utf-8?B?ZUw2d1R5QjZxRzNqSS92Zm1FSGxzY1RXcFlncDdhR3U4dzU4V0oycHBKb0NG?=
 =?utf-8?B?dEJLM29HWGZVL2lpVHlKL2txeUNsRWtaTldkN2l2emxhL3M0OC9MTEg1cS96?=
 =?utf-8?B?dWtqWlZMYmg3U3pzRlRsdHBHeHNSd05nekZ2MWlLVEM4dk9iSXJoNEtkOGhN?=
 =?utf-8?B?aDJlTEFmdmxlZUorVXFpOWZnMVI0dXhkQ1poekw0UFZxTXhGaHF5V0V6WUwz?=
 =?utf-8?B?TlZqTmZFQUlCUzlpNStiM0lTV3B2akJiazFaOUFkeXArSkRHL0VyL0RsSndi?=
 =?utf-8?B?cVpicm1OZi9PZ3V5TERuV2Y5RXN6RGZpSENBNEpYRnVucmFMSzNpRFkxalJF?=
 =?utf-8?B?WmJNZ3hxWHBvS3pkN25xQ1JYRUlWd1ArR2ZoNjFEUTBQUFZEMWpYMS84RXh3?=
 =?utf-8?B?ZVhrVTlqRC9ZdUxuL2YwcWZlbEQwZklmdFVSWUt2alVjZWlxSUgvSEttSjd2?=
 =?utf-8?B?eE95TC9scG5CYkpqT0c0eVdVZVJocGtXb2VqSTBRRzlTdjBKNitVNGxMSWhw?=
 =?utf-8?B?VXgrVCt0WGJMUW9wZnJ0OUJ3TFYrM3A5KzdNeGhhZ2srdlRuUWV2RGRPbzJj?=
 =?utf-8?B?M09QT3RXVDdpNUZnZm5maG91ZlZVNFdnRnBYdTFnQXNBbjA5RXRyR2lwbGNq?=
 =?utf-8?B?SkQ2czdqRDZsNEJTbjkxa3MvUVR4Wjg4em04NWtxMGdsZ0k4VjBBS0pBa1VH?=
 =?utf-8?B?Vjd4RVp6VFhkMlZ4bXoyUHlYWkNsVG16Q3Ztb2N4dHNaQjlyOXRxd1FUYXRO?=
 =?utf-8?B?ajFhbm80N3BkaVlGcDB6REliajlybDBLUnNsU0ZWV2kzZ2JzQWR6NTNLZ3RP?=
 =?utf-8?B?Um01YVJLczRBeW42a2JFb3JRNTc2UjgyUHJYaXNHcWlmcWdjZTg3Tm00ZktV?=
 =?utf-8?B?b29PaEd4VEJueFYxTGE4R0JLMGIrSFZGaGw5OWtoZys3WlFWNFdyNlBQNjZa?=
 =?utf-8?B?Z3EvVDV2N2tibzl5aFZmL1kxQW1NNGt4Qi9pVm5rNXEwbVFMTjgxQVFWWFFa?=
 =?utf-8?B?OVM5OGZJaWRjeTQxMDl1MUVzbmVyQVJBWUNtakhIZFRkRXNVdjJXWTZZWGZ2?=
 =?utf-8?B?S3R4SlAxWTBjS3MycnBkaVNVeDhNL1dsQ1J0T3lwSXRRREZNNXZIK1ZSYnBP?=
 =?utf-8?B?WnVVWUp1VUlMelNGZldDaE0rRHV2a3NDcXVLQVR2d0lxY1g4MWgrNmNvMkgy?=
 =?utf-8?B?OFdhTE14QWQ5SnQ2ZHpkZkUxN2pVMTBTTXhDQkx4eHIzcktKVy9CQ1RRMGYx?=
 =?utf-8?B?RGIvOThRS2Y0cnQvRnlPeUtqTUNUazlyODdSUFhBeXBuUzZaV3FoL0JhM1hz?=
 =?utf-8?B?VHVIK3NkczlDYUpMQXdibHdzMERJQk9sNitmRHRGWm9VZEpZRzRuTENBY1lE?=
 =?utf-8?B?cGF3OW0ydldONG93WEdDTlRHZVlrYnkyNDYzV0RVYmJVWmF1UUlFK2NTSDUr?=
 =?utf-8?B?VlcvWnRlcXV6dnlxWjI2SkRsbTFOUDlMTmcyL0hYSnlNc0pTNlVJeUlnMndw?=
 =?utf-8?B?cFArY0lTT1BZdDFHdzlEZ0R3d2cvbmRnbFpOY1FsT1d0cXNJK2hwb1hJei9L?=
 =?utf-8?B?T09oWjQydlhnQXl2dXlsOVk2ZWo3RnBmbmF0ekZMMTZGZ2NzN0t1aDc5ZWt1?=
 =?utf-8?B?eHpsdEhhWkdPV0Joa25NYTVJa0R3MUt3WFJzcDh6OUh3eTlOWndBUUl1a2c2?=
 =?utf-8?B?UWJTaEFOZUlYUlBFa09RekNJZkMwdytQRW5mbFRmdUJPNk5MQ2poSi9qVklv?=
 =?utf-8?B?QTZUdTNZRWhXZE1pVnV2RTQxT2dIaUd2ZUJhazkrRVh2cW9MeWVVK29obDMv?=
 =?utf-8?B?RWdXK1JvdzNzVnBaSWg1TFVCR1o4RUdQeS9vVmtMRFZhb1R1V2NyNEk2WGV5?=
 =?utf-8?B?U2Z4VFdVU3RXUkR0VGFyeGI0T1Y3OWoxKzdtUVFMSGxuSDVNSDBSMmN5RThX?=
 =?utf-8?B?VzNDZDdvYzcyRzJZOXQveWlQNGhvZGwwZ2RsK1F6N3NQM25jSWNacEhlckRk?=
 =?utf-8?B?QXh1bzY0ZXFoQXZLWjB3c204UTNXbGZ4MGVPd3ZKN0IxVnZpS3pLN3YzR0VB?=
 =?utf-8?Q?oeIVt27bwrGWMoik=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d14f32c5-61cc-427b-f303-08da458a42d8
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1466.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jun 2022 17:55:35.7538
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cFCex/nFlwtOpqpCg1NsMK+MevmhGYKk6h9KNIbvP6FZmIeBt6yviPSzkp8yAPP0cUF0CwGhiwqcNlTjAL8h5NSFii88J5iV9Wndz+bcA+Q=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB5490
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:6.0.517,18.0.874
 definitions=2022-06-03_06:2022-06-02,2022-06-03 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0
 malwarescore=0 mlxscore=0 mlxlogscore=859 adultscore=0 bulkscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2204290000 definitions=main-2206030073
X-Proofpoint-GUID: U_Xu2kgsliFV8H7fMoU_iFeTrXnzGJ1e
X-Proofpoint-ORIG-GUID: U_Xu2kgsliFV8H7fMoU_iFeTrXnzGJ1e
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 6:46 AM, Christoph Hellwig wrote:
> From a highlevel POV this looks good.  I'll do a more detail review in
> the next days once I find a little time.  Any chance you could also
> wire up the new ops for nvme so that we know the abtractions work right
> even for exporting nvme as SCSI?  No need to wire up nvmet for now, but
> that would be the logical next step.

I forgot to cc nvme. Doing that now. For the nvme list developers here
the patchset discussed in this thread:

https://lore.kernel.org/linux-scsi/20220603114645.GA14309@lst.de/T/#t

For the patchset in this thread I only did the simple SCSI commands
READ_KEYS and READ_RESERVATION. For nvme-only people, those commands just
return the registered keys and the reservation info like the key and
type. There is no controller/host ID type of info like in nvme's
report reservation command.

I did the basic commands because the apps I need to support don't use the
more advanced SCSI command READ_FULL_STATUS which returns the equivalent of
nvme's controller and host ID. I also hit issues with SCSI targets not
implementing the command correctly. For example, the linux scsi target just
got fixed last year and it only works by accident in some cases where we have
2 bugs that cancel each other out :)

However, for nvme and for the interface we want to provide to userspace,
do we want to implement an interface like READ_FULL_STATUS and report
reservations where we report the host/controller/port info? If so, below
is a patch I started.

Notes:
1. I hit some issues with SCSI targets not reporting the IDs sometimes or
sometimes they report it incorrectly. For nvme, it seems easier. SCSI has 
to handle a hand full of ways to report the ID where nvme has 2 ways to
do the host ID.

2. I couldn't find a nvme device to test. Qemu and nvmet don't seem to
support reservations.

3. The patch is only compile tested. It's based on a different patch I
did. I'm just posting because you can see the pr_reservations_info data
struct we could use for nvme and scsi if we want to report the ID info
and keys/registrations in one command.


diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index ca544dfc3210..161a715ab70a 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -3156,6 +3156,28 @@ static int dm_pr_read_reservation(struct block_device *bdev,
 	return r;
 }
 
+static int dm_pr_report_reservation(struct block_device *bdev,
+				    struct pr_reservation_info *rsv_info,
+				    int rsv_regs_len)
+{
+	struct mapped_device *md = bdev->bd_disk->private_data;
+	const struct pr_ops *ops;
+	int r, srcu_idx;
+
+	r = dm_prepare_ioctl(md, &srcu_idx, &bdev);
+	if (r < 0)
+		goto out;
+
+	ops = bdev->bd_disk->fops->pr_ops;
+	if (ops && ops->pr_report_reservation)
+		r = ops->pr_report_reservation(bdev, rsv_info, rsv_regs_len);
+	else
+		r = -EOPNOTSUPP;
+out:
+	dm_unprepare_ioctl(md, srcu_idx);
+	return r;
+}
+
 static const struct pr_ops dm_pr_ops = {
 	.pr_register	= dm_pr_register,
 	.pr_reserve	= dm_pr_reserve,
@@ -3163,7 +3185,8 @@ static const struct pr_ops dm_pr_ops = {
 	.pr_preempt	= dm_pr_preempt,
 	.pr_clear	= dm_pr_clear,
 	.pr_read_keys	= dm_pr_read_keys,
-	.pr_read_reservation = dm_pr_read_reservation,
+	.pr_read_reservation	= dm_pr_read_reservation,
+	.pr_report_reservation	= dm_pr_report_reservation,
 };
 
 static const struct block_device_operations dm_blk_dops = {
diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index 71283aaf3e82..1f251b8f381d 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1770,6 +1770,101 @@ static int sd_pr_read_reservation(struct block_device *bdev,
 	return 0;
 }
 
+static int sd_pr_read_full_status(struct block_device *bdev,
+				  struct pr_reservation_info *rsv_info,
+				  int rsv_regs_len)
+{
+	int len, full_data_off, i, result, num_regs;
+	struct pr_registration_info *reg_info;
+	struct pr_keys keys_info;
+	u8 *full_data;
+
+retry:
+	result = sd_pr_read_keys(bdev, &keys_info, 0);
+	if (result)
+		return result;
+
+	if (!keys_info.num_keys)
+		return 0;
+
+	len = keys_info.num_keys * sizeof(*reg_info);
+	if (len >= rsv_regs_len)
+		return -EOVERFLOW;
+	len += 8;
+
+	full_data = kzalloc(len, GFP_KERNEL);
+	if (!full_data)
+		return -ENOMEM;
+
+	result = sd_pr_in_command(bdev, READ_FULL_STATUS, full_data, len);
+	if (result) {
+		/*
+		 * TODO? - If it's not supported do we want to drop down
+		 * to READ_KEYS/RESERVATION and just not fill out the port
+		 * and transport ID info.
+		 */
+		return result;
+	}
+
+	num_regs = get_unaligned_be32(&full_data[4]) / 8;
+	/*
+	 * We can have fewer registrations if the target did the ALL_TG_PT
+	 * format where it does not report every I_T nexus. If we now have
+	 * more registrations then someone is doing PR out commands so try
+	 * to get a bigger buffer.
+	 */
+	if (keys_info.num_keys < num_regs) {
+		kfree(full_data);
+		goto retry;
+	}
+
+	rsv_info->generation = get_unaligned_be32(&full_data[0]);
+	rsv_info->num_registrations = num_regs;
+
+	full_data_off = 8;
+
+	for (i = 0; i < num_regs; i++) {
+		/* every reg should have the same type? */
+		rsv_info->type = scsi_pr_type_to_block(full_data[13] & 0x0f);
+
+		reg_info = &rsv_info->registrations[i];
+		reg_info->key = get_unaligned_be64(&full_data[0]);
+
+		if (full_data[12] & 0x01)
+			reg_info->flags |= PR_REG_INFO_FL_HOLDER;
+		if (full_data[12] & 0x02)
+			reg_info->flags |= PR_REG_INFO_FL_ALL_TG_PT;
+
+		/* We use SCSI rel target port id for remote_id */
+		reg_info->remote_id = get_unaligned_be16(&full_data[18]);
+
+		/* We use SCSI transport ID as the local_id */
+		reg_info->local_id_len = get_unaligned_be32(&full_data[20]);
+		if (!reg_info->local_id_len)
+			continue;
+
+		/*
+		 * TODO. Do we fail or operate like the SCSI spec and return
+		 * what we have and user should know that they messed up
+		 * and need to send a bigger buffer to get the rest of the
+		 * data;
+		 */
+		full_data_off += 24;
+		if (full_data_off + reg_info->local_id_len >= rsv_regs_len)
+			return -EOVERFLOW;
+		/*
+		 * TODO - we should put this in a easier to use format for
+		 * users.
+		 */
+		memcpy(reg_info->local_id, &full_data[full_data_off],
+		       reg_info->local_id_len);
+		full_data_off += reg_info->local_id_len;
+	}
+
+	kfree(full_data);
+	return 0;
+}
+
 static int sd_pr_out_command(struct block_device *bdev, u8 sa,
 		u64 key, u64 sa_key, u8 type, u8 flags)
 {
@@ -1845,7 +1940,8 @@ static const struct pr_ops sd_pr_ops = {
 	.pr_preempt	= sd_pr_preempt,
 	.pr_clear	= sd_pr_clear,
 	.pr_read_keys	= sd_pr_read_keys,
-	.pr_read_reservation = sd_pr_read_reservation,
+	.pr_read_reservation	= sd_pr_read_reservation,
+	.pr_report_reservation	= sd_pr_read_full_status,
 };
 
 static void scsi_disk_free_disk(struct gendisk *disk)
diff --git a/include/linux/pr.h b/include/linux/pr.h
index 21a8eb8b34b5..ec325a0ed33c 100644
--- a/include/linux/pr.h
+++ b/include/linux/pr.h
@@ -30,6 +30,9 @@ struct pr_ops {
 			    struct pr_keys *keys_info, int keys_info_len);
 	int (*pr_read_reservation)(struct block_device *bdev,
 				   struct pr_held_reservation *rsv);
+	int (*pr_report_reservation)(struct block_device *bdev,
+				     struct pr_reservation_info *rsv_info,
+				     int rsv_regs_len);
 };
 
 #endif /* LINUX_PR_H */
diff --git a/include/uapi/linux/pr.h b/include/uapi/linux/pr.h
index ccc78cbf1221..66028d37ac5d 100644
--- a/include/uapi/linux/pr.h
+++ b/include/uapi/linux/pr.h
@@ -39,6 +39,35 @@ struct pr_clear {
 	__u32	__pad;
 };
 
+/* Is reservation holder */
+#define PR_REG_INFO_FL_HOLDER		(1 << 0)
+/*
+ * Registration applies to all SCSI target ports accesed through initiator port
+ * at local_id. remote_id is not set in this case.
+ */
+#define PR_REG_INFO_FL_ALL_TG_PT	(1 << 1)
+
+struct pr_registration_info {
+	__u64	key;
+	__u8	flags;
+	__u8	__pad;
+	/* NVMe Controler ID or SCSI relative target port id */
+	__u16	remote_id;
+	__u32	__pad2;
+	/* local_id size in bytes. */
+	__u32	local_id_len;
+	/* NVMe Host ID or SCSI Transport ID */
+	char	local_id[];
+};
+
+struct pr_reservation_info {
+	__u32	generation;
+	__u16	num_registrations;
+	__u8	type;
+	__u8	__pad;
+	struct pr_registration_info registrations[];
+};
+
 #define PR_FL_IGNORE_KEY	(1 << 0)	/* ignore existing key */
 
 #define IOC_PR_REGISTER		_IOW('p', 200, struct pr_registration)
