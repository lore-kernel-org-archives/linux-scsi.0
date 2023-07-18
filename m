Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 135DEEB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 13:14:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232660AbjGRNO2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51656 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232628AbjGRNOR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 09:14:17 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E5119A1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 06:14:03 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ID7nDm027484;
        Tue, 18 Jul 2023 13:13:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=k8eAEV76LOz2CGy3TuTVfdCZR4w1zlkikGa95kfe5Pw=;
 b=stAy+CqPDB19wHeLz78Svp6K5Uj5jgnTc+D6DxZNC14zgpF4H7j/UbObQYXFChcccz7Y
 So2lfYPfUQb37xce/Xnxi3+8T4N9I307FHi6TNwfBU+SpEsKjZmWCgm3T4DKfW6uWEOu
 j2XSJN3ObbH71+CkYVIgEegKOHOG8IGYtnVP4Vi25LO+y7Rx9jKh9zShMY7twuiylH7i
 hcP/3fi6012sRfcIVB+aJCyq5PQgFK9SvbMMoffmZVZ65kYFo2gxosuaXVTieFjrh2tY
 ZPr505Qzw3HdLqnbX6W0Xi/ZD+eojauD03c2icu+EIAsbnFbZFKcxz2LchZvZAVRgSGp dA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run78501t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:13:56 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICBbWI038207;
        Tue, 18 Jul 2023 13:13:55 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2043.outbound.protection.outlook.com [104.47.56.43])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw52syh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:13:54 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ccY5A6UcpuzZ6uQuQKjR0ALDqYXLEHKqg/FgMHo9QAXWyvrERLIHYojAwjA64kGbcoIsVaIypTDKiqbklzkpywkXJcyKcuzO3N74VXCvVPi8S/HUVQETiE1dV2bdkom0xf0p2IfW1DbIQbRKA8H68PR/9hd3O+y5MgIXnHIcGnXh8LKvEPrI9/ra9LOznHWiaXWyTR45C0VsMcLC49mNnL+reB0kuv1puXdTK6XM4YTppOok6kxaU+Cd3AWVUTRFim0Iv4OjuXPoMKVHKepEsxNKYIA4bLEkYrJW/DzHx3HEDdHxJTxPUrULnfKUJqrXntLmKycHf5ckPUJ6gOHNTw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=k8eAEV76LOz2CGy3TuTVfdCZR4w1zlkikGa95kfe5Pw=;
 b=JoRUlhoZuMF8O0hRKd6bimbtjW8Lq5QOYIIdhmzFMQ9TcNaGWsA2LJhGLbfC/SZX97EKFeTwBt4cNOJ3rBwcK7cyM/vKf3W6TsHKsbesP1BoXRwY5hNcMF1noqlwguLXEKWGNa7K1ICu6m7NrF0h62l+oe3SjESB2WV2U8bBij+btZGseiFNztJHDvY4RG43Xbbs6TnLrB0016hHZgnAllaQ4ZSYnLWrXilfsnZvTev7VXaVTgwB93hYCYUtwP7Aqm0lpZgRiP/mPAyexaP51Lc83L5ofCWVlsU3+W0oOOa8yWmnjFnoqC0Nec9f92Qs+a1wLiwdQ6Wu/XHrKLqGng==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=k8eAEV76LOz2CGy3TuTVfdCZR4w1zlkikGa95kfe5Pw=;
 b=ODAJTYSibkAY7vI6wo/VT0se9uEdXMJFscXNsWPrHVDru0xRvpROIgiXv2AFSyZZzc5mcCP4zLT6JQ4Ed4qCWUDb6Q9FG8Fiw6eLisS6yeylYy+SSkzTquqQ02AmqxFKUBW5hn2d49DcL2BCwMcqsJRCk5pyo4m9TouiYPmGguo=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by CH0PR10MB5337.namprd10.prod.outlook.com (2603:10b6:610:d8::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 13:13:52 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:13:50 +0000
Message-ID: <56ee2aac-9cdd-fe92-380c-1c154396ecc3@oracle.com>
Date:   Tue, 18 Jul 2023 14:13:45 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 11/33] scsi: hp_sw: Only access sshdr if res > 0
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-12-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-12-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0375.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::27) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|CH0PR10MB5337:EE_
X-MS-Office365-Filtering-Correlation-Id: 9dc8ca76-f4d4-4c91-a892-08db8790d40c
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: GBGRFk3/mcQu/qXWBh4Nr8McMgfS0CiEtDYGj42GBX0cBuEPvWJIiZvSqlmsnSejqmLiM5UywIBoz2/K45mMALYuxdPtC8q7r9OeEfyHe/kwJ6LYsMWMoVFGXDSpFDLWP2jDxctK0kV5jZC4w4CmX3fWqs4WlnkA6SX+Ng1dWtp6jRYJWv6jUSHv6Z7bmIbkMv3agsQra9pEUdsXgJ6TDBFs6gfhabLATyl47ThD7Rg82mF9W583yHShUhz/9bWFr1hfE1jIX/scjhl8BJKfDg+ripEriFC34LLkM6mAsvuWe0iThR9vwHSiKyoJoya3tmxqbdFaun7ANkxo7Tpl1ycycG7IdiJz+TDIvBRgePbMKxO/T6U3Nn7WLF1RO4VdJiJfLkI35iAqiK+Ss4DdF1EeC8JyYQXP+9JGTQcpmBwtroTEfljYuQbGkHhwiJIifFPBcfGAEV7PGklrk+LJgr9bLz5YACEBYURj5hpz85iInnAZOeEfG19q3IpB/ehLYg9kx30bwQmaze9w7urrSwJ+SH3E1mz/AlNk3T4dyStFXcppVcIFe4h2VBYE7d7hEbTuOSjMbvJGyB0GTrb5bZQYlW/e2kIavkNWVFhL9MkVrax4BnYvo1mSOHjZenOzIjUSOAsnP3qkgVw3T2L7vw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(376002)(39860400002)(136003)(396003)(346002)(451199021)(6666004)(36916002)(6486002)(478600001)(41300700001)(5660300002)(8676002)(8936002)(66946007)(66556008)(66476007)(316002)(2616005)(38100700002)(83380400001)(186003)(6512007)(6506007)(53546011)(26005)(86362001)(31696002)(36756003)(2906002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UTdZUGtheWg3Q3NLLzZHSmkwMFlmbTJ1TCtkV0pMRmFtRngwK29VVG5QbE1T?=
 =?utf-8?B?ZzlERVFEUHVrbDlZeFhCWk5LYmxmVHZqRWNWaDVKN25qY2hZYTlLMmljdzNn?=
 =?utf-8?B?ekhIemI2NjRpQlB1aDdjWVdtVDliZGJLUDdFZ3VsSFZTRysxS3RpenBrV2d4?=
 =?utf-8?B?RTJFVDBXS2lCVm9TNThhS1FyUU84NUxqOXBiYzVsYnRlL3FyTWdscy80UzIr?=
 =?utf-8?B?RXBQM3NlWm1YL3M3T3h6enllUGlSZHV4bzNTbk00bnZYK3ZPQjF4Q1NJdzVB?=
 =?utf-8?B?bzRuRmJXSHlTd3BuaGpTU3hzMHluOVd1Q2dnZGRkemtEd2NxK1dTd2F4dmsz?=
 =?utf-8?B?dDRRd2MxdTBpbGI1dkRXT3Yxc252UldUZFNNczBSUkNxZC9VV2g0a2gxSnQ0?=
 =?utf-8?B?MllXWUdJczZSZ2g4OHV2by9CaVJUYzk4aGFEWWgrSXhIUTN6Q04ySVRHOURO?=
 =?utf-8?B?RVVmZk9pNGhPWEFWcWkybjdLQjZ1UUN4NHNtaWNNdEFuVHcvOXEvc0h2QVFP?=
 =?utf-8?B?R3BhdjBGRlUyVmN2bmdCM2VJald4djdqaGNEbTRPRlgvVUQzdm9tRllSb293?=
 =?utf-8?B?LzAzcURVSHh4R01PbHc2cU00RDRWMHg1ZjE4ODVORC9QSEFyOUlxUDZvdDli?=
 =?utf-8?B?VHF4dDRvUzRyYkdmYWNNeDlCb3RTc2I4bHhFNXBCTU5CakE5NFJSRVA5OWFY?=
 =?utf-8?B?VjZ3dC9hMXlFTkFvUS9nRkhtUmdWYmVveGJjSjNzeStDQ1ZwekFHZm5FbFQ5?=
 =?utf-8?B?M2R1ZHBYRmZHMTRwWXdjMWN2dFpzTS9rOXI0RlplbFc2YkFyZEdTV3dlbzFz?=
 =?utf-8?B?bUsyelVMZWZlT0JuYzJWeDRTeXlGQ0R2cEQyWUhXQXVpVjhvRW42R2VPblJt?=
 =?utf-8?B?emNjcWlLMStzYVlyQmNybVh2SmhmSTBrWmFuc3JXL3JCdWtUVWlmYVhHbnVR?=
 =?utf-8?B?d29YNGNVcG13VGROS1BUQkl1dzRZSUdIdlQ2T2FBMTZ6M3FVUHhvS3BOVngv?=
 =?utf-8?B?NVVkbWFCS2U1RUtQUm1iUjNieGdLaVo2c1h5TFpvVzBVeE5na2xaUVVMdDRy?=
 =?utf-8?B?SkZlVCt4dkFjSWljSzdTY2hNUmlMdGNTaE4rQ29XQjVWWk43K1VjRWFnRVZp?=
 =?utf-8?B?V2xLdS9sQ1Y0QytvT2xIbnBRRjl0QWJPTFZ4QXNITXpOUTd3WFc1VU1QMWdB?=
 =?utf-8?B?cTBqWk5yZFg0M2RwbmFkb2dSV3lRdndyTkZlUlcwdkx1SzdBaUZSRXZ3Lzkv?=
 =?utf-8?B?RFZNcHBXdUo5MDNycEtpek11SnVCNUtQa0haQzFGY2pnd0xnTWZOZEttNWZH?=
 =?utf-8?B?RTIxK1VRQmtndVMveE0vNHQ0anZicGNONm56Y01UWElabnVOV201dEpFYVY1?=
 =?utf-8?B?bWwxdGZrdFlaUXZrNUJoYVBhbjNWSHZIY0Q3czltUjdHbEI5SkJkMVprMzN4?=
 =?utf-8?B?Q2VzVTJkMkdOaFUxOGsrUTczcnZXa0dqaWxxaC9ETHFvMXlFcGVqazQ0Y0wr?=
 =?utf-8?B?SVJxRWkyUjduMytCTUVKemNJbFlGZ1NQaVVGZkhiUHA0SW9BcS9WT2ZPaGZY?=
 =?utf-8?B?bEF2NnIwMWYyQW1weHg4SmVsZ0xxSU51d0JOSVhYWUQ1b1h6Y3o5aHNNdW80?=
 =?utf-8?B?ZFJ5WlpRc3FHQ3JYQ2x5OG4vRFFRRzM4TkpMZGtWSDBXVTJWQmQxaHAvZEp1?=
 =?utf-8?B?TENwaFh6NUpsS3daeGt1QWl3QktFdTVxMWpmMEJyUUgyVFBoTGJNSzQwWmVJ?=
 =?utf-8?B?WDJHSFk5VS9tUitRMXU3N01hckh6VXEweDBYdFE3RC9kQU54VVdJeFpGa0NS?=
 =?utf-8?B?eHZ0cFVtQjNNRmVrRkpJSTFyVTA4MFVIQkVBT05sdk9HWUxGZHhKTlRnd1kz?=
 =?utf-8?B?ZXRxU1RUbzFkc2thRHlhb1BMMis5bkg1TzV1L0d0bzdybnFYNDJqUVRUK3Q0?=
 =?utf-8?B?MC9TOWNvaFVscmxuS1lLVGdFa3lCTGI5MDQ1NklHYUgzeGROMDJMb2dncnhQ?=
 =?utf-8?B?aFFpTEpCSHp0V0RVQ2xvZ3Fka0Y4Wk1GM1NVZjVjK2NEYzBMZitOelYvV05Y?=
 =?utf-8?B?RlpaQVowMnFPSFRFYldrSFRkRXNuaG14czJDMnRybERWVEF0R2JDdEVrRldo?=
 =?utf-8?Q?j0SjBUDRcAgz2KoC+ilvj9LRu?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: lwaDlyjfaWAPYZose7zS35pCtVra0DK1Pp3utt17zLTxvQ1fMcG9zgXCVvBIi6Shhi2Eoe3dzzwl6uof/UkDNHf9QKOfYDKSZaExETH/Eyeo28k6kZAk9mi+6irNFo0auK8lILzCl0XdkRXDXLRUS6b7W6tmX/IsKx3F+2mqX63a+GsrdiKJxF19WulYz0ytElmRLrM4SRpajF5awMA3UrL9s33hn4W9yZiBaqbRZ6JkFqtrMmgEhW+tsX68igFIaQPmnuTemlLyb+GGdPQ+zw8orHDOxDmu4yZEMeccNOlkitHY8n3TsLLXKoIkvZ5TSI4CdAEqKJqmoo2O7oIxEObf+n0GdNQiN04yv+ZpMJs0PQQZRVVzG/mWHI+Ugf+3mZRInYFuPyhmHCcTjdgZn58cT51hIUFuLfoh0pHQb4y6TMNOsosZgxAYl1oKFdXgIHI66It1uoMFMhTVkB0KfbE6XJLlT6YyfD55yeJPcZ40UcNoy7UUR/oGHVMfcah/jlS+RQbJdqD3UotpXzjtDFG4vLmtvOFQ+o9CSGdr8CyNKUgJJuldl67MXYF0D7FFVTL/HbwoWRKQH3T4xwyeNN/KaFA7Mo4EL8HWVzrW2BSJFPuvfAIjKVtXkTMj8PmGLpbwOKIySVSasnx+Rqhf36kycFsm2Qq4+N8nEoSddwpwQKmVYZ/MniUPME0dTI5O6RK78dACYwpXwIzN2bmrPwOKFMqdR3uWfR/e5EoLy6r9lyWTLucLTPHEjwyqVT89LJBKM8QKIS4pg6hCAalxLs3gtwk33gQCdVBZb5vgFIz3kq2yVIjthYJRA6w/k5OikrF30EIJV8mke/sv4AY3CAvwxz+MlP9hri7V1xNBodQNih9Ckx6z6ghBq6h4/NIV
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9dc8ca76-f4d4-4c91-a892-08db8790d40c
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 13:13:50.8133
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: IbdNe1X31axc+8LvXjlUMsbLc7gIvq1kPj5Rg9PTRApkbUvzWjqOTHypHSnhN40KPZaeTxEbprW+MuIA/ae3TQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB5337
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 phishscore=0
 adultscore=0 spamscore=0 bulkscore=0 malwarescore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2306200000
 definitions=main-2307180121
X-Proofpoint-ORIG-GUID: i7Hql9YD3uoPXtb0iLY9Ou9-ROfTS3GU
X-Proofpoint-GUID: i7Hql9YD3uoPXtb0iLY9Ou9-ROfTS3GU
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> If scsi_execute_cmd returns < 0, it doesn't initialize the sshdr, so we
> shouldn't access the sshdr. If it returns 0, then the cmd executed
> successfully, so there is no need to check the sshdr. This has us access
> the sshdr when get a return value > 0.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig <hch@lst.de>

Regardless of a couple of coding style comments, below:
Reviewed-by: John Garry <john.g.garry@oracle.com>

> ---
>   drivers/scsi/device_handler/scsi_dh_hp_sw.c | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_hp_sw.c b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> index 5f2f943d926c..785ab2c5391f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> +++ b/drivers/scsi/device_handler/scsi_dh_hp_sw.c
> @@ -93,7 +93,7 @@ static int hp_sw_tur(struct scsi_device *sdev, struct hp_sw_dh_data *h)
>   	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
>   			       HP_SW_RETRIES, &exec_args);
>   	if (res) {
> -		if (scsi_sense_valid(&sshdr))
> +		if (res > 0 && scsi_sense_valid(&sshdr))
>   			ret = tur_done(sdev, h, &sshdr);
>   		else {
>   			sdev_printk(KERN_WARNING, sdev,

maybe this is better:

	if (res > 0 && scsi_sense_valid())
		ret = tur_done(sdev, h, &sshdr);
	else if (res == 0) {
		h->path_state ...
	} else {
		sdev_printk(KERN_WARNING, sdev, ...
		ret = SCSI_DH_OK;
	}

But I am not sure about the == 0 in the middle...

> @@ -134,7 +134,7 @@ static int hp_sw_start_stop(struct hp_sw_dh_data *h)
>   	res = scsi_execute_cmd(sdev, cmd, opf, NULL, 0, HP_SW_TIMEOUT,
>   			       HP_SW_RETRIES, &exec_args);
>   	if (res) {
> -		if (!scsi_sense_valid(&sshdr)) {
> +		if (res < 0 || !scsi_sense_valid(&sshdr)) {
>   			sdev_printk(KERN_WARNING, sdev,
>   				    "%s: sending start_stop_unit failed, "
>   				    "no sense available\n", HP_SW_NAME);

I think that you could do something similar to above suggestion here.

Thanks,
John

