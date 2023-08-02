Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5F518C001E0
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Aug 2023 19:54:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231148AbjHBTyT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Aug 2023 15:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50554 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229771AbjHBTyS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Aug 2023 15:54:18 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4842B19BE
        for <linux-scsi@vger.kernel.org>; Wed,  2 Aug 2023 12:54:15 -0700 (PDT)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 372HJDoD005099;
        Wed, 2 Aug 2023 19:54:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=j5lHWA+tfxcMr8q6Zin8jj4ZGPxCz29enQ4CqxhnW3w=;
 b=qzj+yssXIhvdPjC548xU7xInx9xQo5Ebt+YFU62JByYPWAQuFq1NquybQx8VK9ENxE7z
 IETXbTCNCtDpM9XusJu4ceG4h+hgTECjYh4sRnJZyknv0URQs2XpzWswftFmI0Q0IRw5
 Bp6NHV+H6gWRmiAIVkaUqSS77SwyEbBfvUJ76Trskt5/HC2o7a149Cs/4eQCSvv6pZLt
 CxgJn9kbYT3561eLj/Ax9BXRWtmTboGNL0/RThrRfJ2bIM8Q9/u9gw4E9iQGDwMpT59N
 QVqDyT+/kRExUN6/G/wAC4YR1JAJs5FcO32Wqv9gMj0GCGEZeOmDlZw5AMQ8sRDYK6X8 mw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3s4tnbg5ge-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:54:13 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 372IWLav003907;
        Wed, 2 Aug 2023 19:54:12 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2040.outbound.protection.outlook.com [104.47.74.40])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3s4s7ee7g4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 02 Aug 2023 19:54:12 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WGWVHbUNh18uochYb5SZApwjGhT39n7Y+/z7CwzdWbpOmIUlFd73q7POsiMPpm4nC1ipyQIUsjwV/ebaI8JeT7uYW8l4SPpzPsRGupGMAkFFQVKwdmCNr63Vxs74TRhVBzNSHqPpsyK5aihUI1qgXQYiWsO6HoB1iseLrDpx7daPoXJ2u9hNC1+jG0sIeeiiuR+ZUgMYF/0GOlKITc/+LFPMEpTpj788W7DhJow14WrC8jUWJQTJrhCV+gZhBhJfoc1da6nnkzs8q8SNrAJNNqbP0s+BmcLNSnv2YgPq/E63mF87ZvMIF/JA830kywEMVfwfJ0HQAb3IcPLS1Mr0vQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=j5lHWA+tfxcMr8q6Zin8jj4ZGPxCz29enQ4CqxhnW3w=;
 b=XvQ4s9Jj7u0KdHJpQhHCNPC+BBo6vYfZeQYMyhZwbMV4FxOqQOypMNblhS5+Tq0yhHstYKEkbLmNm3E3oCr0E2GBzdtIBKiDhzPKP/SS36ZoH3fYdQpt9z23dcTSp2gOrfzpf8pU30pDuKyb3ZOrXdAJhwmaLbQuhxz59SDsffJqxL6eS+vd6yzc60Ux9X1nRPKDM/NHpwViUeOEGnFecewc6AFS7CzfKegsJkksvEgnSDwbEuMVokolOKJqP/oEozgeZ/2rmQf1P1lvkqnbgpGneBo3aJ+/q+nRaWfXSxX84WIKLpR8NRvh7I54thlCU1QH2T0pe6Bz9V1dl/ciSA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=j5lHWA+tfxcMr8q6Zin8jj4ZGPxCz29enQ4CqxhnW3w=;
 b=qGAwO44QK0I6mKWZmddqX+Fu1qJi1xOnBXrLtGqHdT5wHXnXj6HeHMgPon74x24Xi1URAFn0QjUBvouT1lKkhx8CbbxUy4o7pOBBrV7LRgiA4GbXidRlELIef8S32HBUDkIpIMuAbCrypopRDs+yW6+etGGZ+6kd0dsXzUxzC2U=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA1PR10MB7830.namprd10.prod.outlook.com (2603:10b6:806:3b1::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6631.45; Wed, 2 Aug
 2023 19:54:10 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::31b3:ba23:4678:9f5f%7]) with mapi id 15.20.6631.045; Wed, 2 Aug 2023
 19:54:10 +0000
Message-ID: <40822c43-08c6-9c7b-750e-5f0091420466@oracle.com>
Date:   Wed, 2 Aug 2023 12:54:08 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 06/10] qla2xxx: Remove unsupported ql2xenabledif option.
Content-Language: en-US
To:     Nilesh Javali <njavali@marvell.com>, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, GR-QLogic-Storage-Upstream@marvell.com,
        agurumurthy@marvell.com, sdeodhar@marvell.com
References: <20230801114057.27039-1-njavali@marvell.com>
 <20230801114057.27039-7-njavali@marvell.com>
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
Organization: Oracle America Inc
In-Reply-To: <20230801114057.27039-7-njavali@marvell.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: BYAPR11CA0041.namprd11.prod.outlook.com
 (2603:10b6:a03:80::18) To SN6PR10MB2943.namprd10.prod.outlook.com
 (2603:10b6:805:d4::19)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SN6PR10MB2943:EE_|SA1PR10MB7830:EE_
X-MS-Office365-Filtering-Correlation-Id: 66774e8d-d2da-478a-0e71-08db93923d59
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: J+qWDYqHaMkjboBk/vNHfnXvXux1DqrHLyUqAkwfasWM/aWT6xFahXkaYXYMo0pj9zxCxsZKMgeLbyOi0p0ALvGWt6ZW8MXi/cjUHeGNGWJTLSvNo+bbhayQJl+HUIA/m2tbk9lpp2iHhZTzSazbav2NxfYOeiskLS0rC6B9+jDBjQKIbRxRVV3PR4c8tzKe+7XnxJImzNOnme65M5p3akd2D781a1O792AkIzntxsEa0LTCnDLZHLOFGXcwRgUXIgpl7n/I2XTFEbZJjStyZKDezvlyLKawiO6QlWn6tV7sFCH0mZVh58moW6cJQ2Q0wGKeKZ4Zs/gSqqQsBlfJe/uM4L2HBckf/RBBPqWASH971Yq1hSBaIPDgKzp70Rr/imhXTLZnIj6Ark6ZwxbCK3QXYeuDd5MWo1grOaf3X4bYI2W9ETI/FVBi/P9bnz63tlnbN/wYqwysMBrLcFUNTMDxXmaZPAkAn09T9LLC/pfGb70iHF7J+JxlBIWrjyV0RV/8yCeFTo+cSvQ3JZC8S/pNd1pc7yWYGwPkykotMqbpb4ivp31mYNu+AuIPCZxEG7qYQuzv0gQegaPExMjPSiJbJobK89K4R+qPCNGKlU3b7rx0ew2Y7Jy45nuv7MJvIfJR/H/lbPjprrxyi9q9HQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(396003)(376002)(346002)(39860400002)(136003)(366004)(451199021)(36756003)(86362001)(31696002)(478600001)(6512007)(36916002)(6486002)(8676002)(8936002)(41300700001)(316002)(31686004)(5660300002)(6636002)(44832011)(4326008)(66476007)(66556008)(83380400001)(38100700002)(66946007)(2616005)(186003)(6506007)(2906002)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UjNRZHByUlhUdjdqZUpkeGJWZHNGVmdTcGhrZkRYRXNiSjZMekhlOXpENlRr?=
 =?utf-8?B?aitleU5RMnR6LzBXNnJXVUJ6VDJTTEhKdzhIcFZJejFydWw1MWV3MlZpYytM?=
 =?utf-8?B?bVE3QWJsa3JGdXVuNVc5ck1jcFNuL240TFJJSmtkaVVhK1BlRG1Wb054ZjJM?=
 =?utf-8?B?d01UVThxb2U4akJLSTNqR2x4dnBvMTJWa3U5V2VocWNvTGZ0N0dVaklqZ3M4?=
 =?utf-8?B?elhJN0N1cEtDQkVuZWw5K1E1eFdSbFJxcDRYUStRWm1pMUE2N2RoOTd1SGJa?=
 =?utf-8?B?QXBIWFp0bjh4RW9ESUtMdTVqZkd6cVU2MU82Z2xMQzZVK1FyTHZtSkpEVzBQ?=
 =?utf-8?B?c2ZzVUxJcjU3WmRVeGdDWENCcVE4c1RVMXZJWTc5a3ZuMEhlV1pNZzFFU3lw?=
 =?utf-8?B?bndiMkgvV0xncnZJSERTeGQybEJtWTJpOXV5MERxMUxZU1REdEhxRE9MNzdV?=
 =?utf-8?B?YWZBckN5NE9uamRqV0pvd0Yxblh2U3R1Ky9xejdrZUcvazhvRzRoREhxa1N3?=
 =?utf-8?B?ZWI1MldUaTVid0FMTkpwblVYY1J0MDJSWXZESmUya0JHRzc0eHRIWWVVbjBu?=
 =?utf-8?B?OWsxOHJyblpOUDNaWjJzRXpIaXQ5bEtFbmdXWTFHMW1kbCt4ejNBVDZ3WkFM?=
 =?utf-8?B?bXFVNlhHOG0yLzNpSmxNdkhOWTdNL1BKS0RvSFdUZUV6M0N2VDNiUkk1VnBF?=
 =?utf-8?B?SzM5WW1BL3ErZUtubG12TU5sT0twSElubHY3Y1NJd2VxeVNLVGlDZERUYlNq?=
 =?utf-8?B?cm11TGR4K0hOWVJyL1FZeDlEK01wTUdWdkMyakJpUlBaQzBKWkdQT3BBVXlr?=
 =?utf-8?B?bHhVKzhNSCtCM1JGM1FtNkdrSFhKbHFONlhMU1V5K2tqa2dPNG5GWFo1Y1Q2?=
 =?utf-8?B?ZmNLWEpLaWpMSU1mWEpHMldZR2NiQWJpT2NLQ2xvVmQzQWJ6a1ZJYStDME5M?=
 =?utf-8?B?NW9ra0ZSL2pTc0hjc1Z1UEtJR3lRSk5EVDlucGdFcjlPbXBGNGYrR3VORDVZ?=
 =?utf-8?B?MmFpOEE1bUtqcCtvYWNPOUM2ZmNWbS9ZVnloSkxHVElVa3NyRU96aFIzTjN3?=
 =?utf-8?B?R1ppL2ZVcDcwUXVYYTkvdCs4UmR6RVZzQUxXeGkvY1ZMVXZ0dkV5aUUvU3BH?=
 =?utf-8?B?L2lGcEUvSW5FL2ZlZnJrbHVOREl0dmx0Z1MvYWF4WHh1QTY0QVhMbUM1NWFC?=
 =?utf-8?B?NUU2UEpXSHNSY0RJT2ZHTnVBVStqa3FIQVdoMUxGSjhwamhrRy9ZRmxRZ0hC?=
 =?utf-8?B?emkzOVdCT2lEYXRiSlRlVkpqSzc3YlU1YndPRDByTjZrZXF0d2I1V3JDQ1p6?=
 =?utf-8?B?SUxrYWQ5dTRvUzQ4ZmlSZCtRaVdlWEZYdGtkTWxKSVBEWG9Qb3lmVTNVYm1D?=
 =?utf-8?B?bXQrcytDOHlPVTdORjhzVERCcU5hVzhVYk1ZMGUzak1SamFMY3hSZW9kR25l?=
 =?utf-8?B?anRnK0d3YTJ3R0l6Rngya1gyZEZkOFZtT2pQS21RUDlZUUtWYWVyc3dmN0Rx?=
 =?utf-8?B?enNUZ1hvK1hScVRDKzF2OUdocjFSTHRoZFRXdmt3WFh4Z2I4SkFMQklyVkRy?=
 =?utf-8?B?Z014TmFzV21YMS9qakhYdnQwTWlEMm92Zks0R0cwVXF2YXp6MjZRNW9sMUFn?=
 =?utf-8?B?UVVBOENCamZueTFLRlRGTXRGdlVxdXdzSFNiT3BoYjNkay9tVnBlblAzSGZ5?=
 =?utf-8?B?M2xWSmtKeGJJeHUvZTY4RTRMZUtkUlpvQ1pMZ1dpYXp0QmlkN1pRSHhIeVdr?=
 =?utf-8?B?Z1JQSnc4NW1EaVV4N1VSUll0Y0FTclh3SmFPT0Z6eVRuS3RzVk1FNkZPMitn?=
 =?utf-8?B?eStkMjh6dWcwM3VmVUMrYnorTEhoVEJ0SmZtQ0p5anZPcExpeEFHRlM4QVVn?=
 =?utf-8?B?RTVwdFJ1YkFLbHltc3ZLUWZvQ3B2Y1ZWaEx1T09FNEpPb3E2SzNUTWlFcTY2?=
 =?utf-8?B?V0M1QzZ6dmlwNkxxdXROaW1UZE9jclJDN3JHY1R3NHQzeGdZck8yanpaekph?=
 =?utf-8?B?QnJrSnlkM01qS3VJRk9MSTRHUlRQZk52dWVJV1Nlb29nQUJHRzNxa20xelFp?=
 =?utf-8?B?SHRUVGpPRUVoaE9pVWxHdjhXckdIQWk4RWNKVDBnaXJNM0wyTTBtS1JDZDJI?=
 =?utf-8?B?OTdIS3AxcmRsbi85c1BjR0YvbDYrYkhRa3RuVjlYeFNERmY3eW9KVTZpTG5G?=
 =?utf-8?Q?LnjQouYYlsN7t1umxc5fogU=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: mBiTJBFc42od2SG4oMgTUOKV3a0Bbk/whFQIghiMWIRSWFLzTXr1b+MgL6yMr6ms+S1lZDJgANY9L/dZZm4wsZcbvS+2+L8TV+r1JTZMhiO6GAASz80dywXzLF426YS2zlWs67jUnnErHfuSsBxTHln8K+6dclWQX++vVaiHud4+my69n/Fb4dnquZaP7hP/sFNkRKgGCEFhPsnxByxSC/PPNQNGqVLegoC4Ybuj9SyP4htd3yFE4WF1TdnRAohA0vw1klo9C8uR+Cnsb4hZ4lxnsJk4/JXvYpIVLbx1xP1y+ht9lGAklOGhMdPOSiTbJMI9+ZmIEQHs4r5JbhJzvfzvBvvhWSF6mYwt2qOo9/QKjQuNKFjItxEk8Sitt0uLIugwdyjUuXfb19e+pbbCKA49Ij+zFo4OL6oUdHhwE1m+9u3CE+sFWevwJ2mAGo83HhnkFiBnJIYhuDxyu0mLmsM+j6dLPODLwaxQZ1FEOXnfbaxFJ3wENytKU5C9LVebf66IzeZzzRgE2f8y5AvvWtyby9lCKtICE5jgJAahp1N1OYrg64XgSi1jLrfhjBCCK9TXmk9OZ47yxh4+f/4NMh2qmIl0R56tPlO5TnPBt6W1YubcDCuYFskQO0LxlqyOcYB5p+6wODfTNPDwhyQU+opq0tgG/YVxcgo75lR3C4WJ+Qt22+qdyGhtkUdeDVxrfhJjl7B33+EceRieEdGSZm5SwHf6TaxC8NekFsgNHipCfrgVzsGBErJDMThNW3hTAJA9q4qlyMVGOh5X/skfZqERYg2N2EpsozbIfEC8Ytc=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 66774e8d-d2da-478a-0e71-08db93923d59
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Aug 2023 19:54:10.8131
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: soPrdgsM8a6d55IQQ6+B912oGp0sdaKAEcvfWIJZYaFe7VuzPoHjjM/MwVjW2lswHnJ/6BJBIbNZV7TwjPBYqoCd6EMEyM3v+pG7WhWhEPs=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB7830
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-08-02_16,2023-08-01_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0 suspectscore=0
 adultscore=0 mlxlogscore=999 spamscore=0 malwarescore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2308020175
X-Proofpoint-ORIG-GUID: Bn2r9Rds33D-qoW0cDRcqQYeAfCnlunf
X-Proofpoint-GUID: Bn2r9Rds33D-qoW0cDRcqQYeAfCnlunf
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/1/23 04:40, Nilesh Javali wrote:
> From: Manish Rangankar <mrangankar@marvell.com>
> 
> User accidently pass module param ql2xenabledif=1, which is unsupported
> in driver, but driver still progress and lead to guard tag error during
> device discovery.
> 
> Remove unsupported ql2xenabledif=1 option and validate the user input.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Manish Rangankar <mrangankar@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_attr.c | 2 --
>   drivers/scsi/qla2xxx/qla_dbg.c  | 2 +-
>   drivers/scsi/qla2xxx/qla_os.c   | 9 +++++++--
>   3 files changed, 8 insertions(+), 5 deletions(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_attr.c
> index b00222459607..44449c70a375 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -3093,8 +3093,6 @@ qla24xx_vport_create(struct fc_vport *fc_vport, bool disable)
>   			vha->flags.difdix_supported = 1;
>   			ql_dbg(ql_dbg_user, vha, 0x7082,
>   			    "Registered for DIF/DIX type 1 and 3 protection.\n");
> -			if (ql2xenabledif == 1)
> -				prot = SHOST_DIX_TYPE0_PROTECTION;
>   			scsi_host_set_prot(vha->host,
>   			    prot | SHOST_DIF_TYPE1_PROTECTION
>   			    | SHOST_DIF_TYPE2_PROTECTION
> diff --git a/drivers/scsi/qla2xxx/qla_dbg.c b/drivers/scsi/qla2xxx/qla_dbg.c
> index 4d104425146b..691ef827a5ab 100644
> --- a/drivers/scsi/qla2xxx/qla_dbg.c
> +++ b/drivers/scsi/qla2xxx/qla_dbg.c
> @@ -17,7 +17,7 @@
>    * | Queue Command and IO tracing |       0x3074       | 0x300b         |
>    * |                              |                    | 0x3027-0x3028  |
>    * |                              |                    | 0x303d-0x3041  |
> - * |                              |                    | 0x302d,0x3033  |
> + * |                              |                    | 0x302e,0x3033  |
>    * |                              |                    | 0x3036,0x3038  |
>    * |                              |                    | 0x303a		|
>    * | DPC Thread                   |       0x4023       | 0x4002,0x4013  |
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.c
> index 7da13607e239..b9f9d1bb2634 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -3288,6 +3288,13 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   	host->max_id = ha->max_fibre_devices;
>   	host->cmd_per_lun = 3;
>   	host->unique_id = host->host_no;
> +
> +	if (ql2xenabledif && ql2xenabledif != 2) {
> +		ql_log(ql_log_warn, base_vha, 0x302d,
> +		       "Invalid value for ql2xenabledif, resetting it to default (2)\n");
> +		ql2xenabledif = 2;
> +	}
> +
>   	if (IS_T10_PI_CAPABLE(ha) && ql2xenabledif)
>   		host->max_cmd_len = 32;
>   	else
> @@ -3524,8 +3531,6 @@ qla2x00_probe_one(struct pci_dev *pdev, const struct pci_device_id *id)
>   			base_vha->flags.difdix_supported = 1;
>   			ql_dbg(ql_dbg_init, base_vha, 0x00f1,
>   			    "Registering for DIF/DIX type 1 and 3 protection.\n");
> -			if (ql2xenabledif == 1)
> -				prot = SHOST_DIX_TYPE0_PROTECTION;
>   			if (ql2xprotmask)
>   				scsi_host_set_prot(host, ql2xprotmask);
>   			else

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

-- 
Himanshu Madhani                                Oracle Linux Engineering

