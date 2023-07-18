Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 114F8EB64DA
	for <linux-scsi@archiver.kernel.org>; Tue, 18 Jul 2023 13:15:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230457AbjGRNPP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 18 Jul 2023 09:15:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjGRNPO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 18 Jul 2023 09:15:14 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC2AEB0
        for <linux-scsi@vger.kernel.org>; Tue, 18 Jul 2023 06:15:12 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36ID7eTJ005656;
        Tue, 18 Jul 2023 13:15:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=Ip560PB7kqV6F/Wk9AiUn5V6DidGkxiNif7h6GCUOPY=;
 b=TV7MOWRHScq3m37K1vVdIeFaj0vVMX72EH/n48emvaA6mOxzW38PGyAO6sSeIPyXdtZn
 wAQ04iRg3hKbERbFgbfTIA251PK1EgatD3NlMr6q5PgB7+6D2f0NQqF///B/7LMOkklz
 vpdjq7AVJEA+WXrbUJ6sx+UkfcF29hwpy7rBo+qu1PJdeY6rgMrjenDuWKMQZpmeapm4
 FkBEgjrUV+j1UfPQt0Mnn5p3S6mCbSyWDpzdr3KoNrHXgndLGBORDnijAD1rQI1I/vgE
 eximutIpWb4yCuXxhpqX3M7lN3cbUIuBLmmTZsEh4gbmMyP6d3ate+XLmmDcpp9xfATY fQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3run76w2tx-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:15:03 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ICFnLR000794;
        Tue, 18 Jul 2023 13:15:02 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2045.outbound.protection.outlook.com [104.47.51.45])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3ruhw531r0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Jul 2023 13:15:02 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YlonWFyP2kNtFp2SVjU2CF0+Q28NPHvquDjrJP7x6UsN/TBgb8MYI1Cgt5HlIjE763nxHX8uYR7wEVkdFvRTGi9wLzDUdfERxFMp5HIdRsJ1uHxCIs98xXjvhGgWdb124yXMoxruvIvD+bHWJ+lOLPxAlmOTNGugsk1qvb9Zm4eVkSG8a4H/H6rppwFoZDiCZj7EkF2wINngPOKDRyeArD9JQOBCTIRIXVZ8xZ64xf7uZyTEpEXZWfWM9p89Q//om4fJj8NWnRPbFWuAf3dgKTVyHgVJJIjDNvdujmCUH9OSd7HwC6kQvmIsEa+s5VxqZeEcXhiPvJwEUUSn3pp3LA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Ip560PB7kqV6F/Wk9AiUn5V6DidGkxiNif7h6GCUOPY=;
 b=kpQN3BbK55/irffRUWkJNQKtcpt67Mf3PfEl6+F2DQVvktg6rWXGgYNTzdRv4lGQXsX5bcGLHUie8rqiZDT82UNftpGNKbHmo6nq0MTzLzLIQqgqXUC8n1vQDH5fYasoaie8NAMx71/lEOCg1qexYrl8FkN9ytNFt2nwtwMqa1RdcmyqjT2jxSsA5JEG/fiqIusBB/n83H1wKyp7qWNhRl5S5Fk6Ew2ec9aMsZNmTN81azRbYHgN89+ezClYaxtUWxR8KI5x/Rt+3rFsT23piVXyJgGt1FJBTpgk8YIaAX7K2yBzT9UcL3swv++Kq1d+ZE2pwT8GL+qHbDAN3cwcPw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Ip560PB7kqV6F/Wk9AiUn5V6DidGkxiNif7h6GCUOPY=;
 b=Z79AbpSq2o0fOU3kQDXvPGkH0cftJBDKCMBn0A6cMv6DU0IAerZBKIWMikxSw2vY+fRqXO2+X44FKvHHfGzzVEGWUawAdKYFEglYmnVAMb8WWbbet0a2exzOxyljGXnRzSY9v6e1zVHLqd0/xW/xARGa5PkwwiFX5ldUHHb3mbY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by BL3PR10MB6257.namprd10.prod.outlook.com (2603:10b6:208:38c::10) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6588.33; Tue, 18 Jul
 2023 13:14:59 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::e38:5b81:b87f:c1eb%7]) with mapi id 15.20.6588.031; Tue, 18 Jul 2023
 13:14:59 +0000
Message-ID: <de7a2f47-04bb-4fa6-9887-3ac170a4bd9c@oracle.com>
Date:   Tue, 18 Jul 2023 14:14:44 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH v10 12/33] scsi: hp_sw: Have scsi-ml retry scsi_exec_req
 errors
Content-Language: en-US
To:     Mike Christie <michael.christie@oracle.com>, bvanassche@acm.org,
        mwilck@suse.com, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230714213419.95492-1-michael.christie@oracle.com>
 <20230714213419.95492-13-michael.christie@oracle.com>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230714213419.95492-13-michael.christie@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0384.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:a3::36) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|BL3PR10MB6257:EE_
X-MS-Office365-Filtering-Correlation-Id: 9e15864b-aee0-45b3-6435-08db8790fd1f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 3YjUpTjX8gnxaUUNf5Y91pK0KVfi7LJ20XStQOcHXHGRd/jlkeJIlgMiQh9YhS9n2A4DruhEuoN3fnAPtSAABH8YOhYbj9j81Kq1NOI/O19GhEJHUwASmBBKfErfAX9yxTo8ui8fnknp4FJ/uIoH41z+n+Vk3fYdAz1JjH0V6KmRnqFuGlgj5/fwjs1f2i4DqbrYUINdbnvGnLtztWSxHOmT5KDI0FiAn2m2Eceqs0Nlg4u/LSFwzwIdOsfS0Qg8nypKVEm/mGiioOTXXsFwelfm1ogDmQa3g8Q6xUk71Xd1UqDp6RYRzGmp5wEODsBpP18iypDEIJZCnohzTGnwXJt2hL0P6nQvfbcK33/BNH5KKOIDiTkQYGlB8VFDPmFUxZ8WhFn2mtewqmDix4BjGI5P6JOR51mFSfPrDBMMBNB0AEms4T/kYKZY3s0dZc8TuhwhNTW0+Ar/3KG3Yam99kx+/4ghb517ToiXcDAJ5rZDc23K/m+Go1gg/bwEmp/IzUrdS8y4wRsd4sRf9N4UFP78SUTTdTngiepWNWleeIsQoY21PtE4PYJq+KGX3jyUndzvrk0hsxiDKHBMX8BNf1elOh6/Qz3FuayXfmfsO1XxB5QBXBkMDpTepZuhixJsDPZH72kS4SZpeGe3rvda8w==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(31686004)(66556008)(2616005)(41300700001)(5660300002)(558084003)(36756003)(86362001)(31696002)(8676002)(8936002)(38100700002)(6666004)(6512007)(316002)(36916002)(6486002)(66946007)(66476007)(2906002)(478600001)(186003)(6506007)(26005)(53546011)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?b1JaL2xFZkNGNE4zZTVwbm4wVzhXTTVDQmxLbDIxMlJjMDJKY0FxY1UxOTZn?=
 =?utf-8?B?SzJiYWhyQjUzSTJwd2FtOWU5Sm0wMGVWeWVLNklsUjROWDAydEt5M1ZkWDl6?=
 =?utf-8?B?OVE3Q0N5ZXZXS0F4SURmZHFKUjNza0lGaUtRYzh6OGNkWUZqVVJLeU1ndExt?=
 =?utf-8?B?UXJaaGg1VllJS2lIVWY2Tkt3RWZWTGU4bzl4dmw3WHBuNjZBcDB5OGVsVGFJ?=
 =?utf-8?B?VmdQdVdQbndwVnpFUkhhMFNYa2ZBTktiSytHZDA0WEluaXRYYnF5by9oVTdi?=
 =?utf-8?B?bmtwRExEWXh5dm81c3dpRjFuT2EwMTFla2Ercm1OWGZqQmdpa0FQaUhuYTJl?=
 =?utf-8?B?bXJDK3h3ZFI4UkpmV1BRYVBITXJsdERtZTVPWmRlZ0t4dmZXMDh5RGltTk9Y?=
 =?utf-8?B?Q1I0dG1Ta040K0ppNk5DaktjUkxYRGxzeEpFZUgzN3BjL05nMGFGaFNuS1kv?=
 =?utf-8?B?Tk5PTGNydGhYY0pJdFd5dU1tTTlLYVR4NzRaYVJXTzYyQzJxaklvQUpob1pI?=
 =?utf-8?B?blV3SlltRTZaWm9qZWRLcUhHaWhhTkN1cThsWWdoYm5jNUlsWU9jNHhkNzBj?=
 =?utf-8?B?L3JJdE5BU001U3IzcmFPZGk3c1N0OVNjZHBrQnlPb2I5U2hBeVdiSDZVaGpW?=
 =?utf-8?B?RkYyWkIwRGVhUnlKbE15MzluODhLZHBPdFdOeU04WWYyS0FHOHk5WUZKbzZQ?=
 =?utf-8?B?Nkg5aUF1eEszL2VZVjduWnJWSHNpSlVSRmorb3NUZS9UdlNSTGZISEtNVVVG?=
 =?utf-8?B?SkpxRWJOTTFhSW0zV2dWZkhwV1NGYzZBaVNTang1RWNhTXQ3WDhqNENodThK?=
 =?utf-8?B?bC96SXZWRGdZUHpXMm5ieXhmTnYwcEhEMEI5b3JTTUVobHh3ZUtCVU04dGln?=
 =?utf-8?B?cS9yU08zMm5weVhNSGZaeWpsb0hiN3JmOHQ5d0o1Mi85RjBYbWhGUHdNZklW?=
 =?utf-8?B?NFJpekMzYmxLRHFHTXRBRG0vWW9yMWNyTEFvZUEzRmdnSnZJYk9JSVYrb3Z3?=
 =?utf-8?B?VEpScjI4Um9PdjNJZWRaZVRSV2twVms0d05mMUp6MjhwZUhxU0p2MmczUlBn?=
 =?utf-8?B?V0R6YTlOSXUreUQ3WFNMYnloWmFyL0FwWmU0eWFKMzExZlZ4cmNXb1p2SW1K?=
 =?utf-8?B?aGVxanlUZXc1V1RWcGxMVEorMVNwak9URmEzc2NaN2gvdmRydVdnOHhGK1lG?=
 =?utf-8?B?YkFMRFRmRWh0dTAzYWR6UFVlWkxIYklKNzgvYW11bG5XV2xWNkloUjdRd0pM?=
 =?utf-8?B?RjllZUl0ZWpDd1Jncll1TWVCeklvTmp0dnpKWE1DbGhidGRhM0tnZmhqaFBB?=
 =?utf-8?B?RGljdkFpK3VJVGYzRzJHK2MyM2xjVTZhTkNIbE5MWlZ0TURQUGFnaFlyVXA1?=
 =?utf-8?B?VDN5ek9aZGxVc3UvOFpNUDFkUEhUQ1VtVWhzazR0a2ZVdHZ0QlpDMHIvSE9p?=
 =?utf-8?B?V3loQmNZSGJJZGwxVGZ5WTIxUUVvK0Q5OGphWWx4RzIzQnBvbkdwK1VGMzdP?=
 =?utf-8?B?MzJtVzhmUkxGT2VrWWp3L2lObDlHTjhaT1dOSzhaWDZKeUMrUE1DNGR5QSt5?=
 =?utf-8?B?QzduSE9kZW1MWUlneWw5N0dsV1I2ek1jZGN0ZjRrbFJqV0ZVTHN3WTdJenlB?=
 =?utf-8?B?MitIcEZQc0dBUXhUS0k2RjRiZ2lTNi9vcnowdkFZaUJTM2ZBbEZzSzFtaklT?=
 =?utf-8?B?OE00ODEzdkx4ZGw1a2RQZzh6OCtNSkM1ZWZOZFRrcjZUSFBQd1NuTitXWElQ?=
 =?utf-8?B?WTI4WnY2MElkd0lCZU82aUVPZFhTUkNjcVZ4ZzliWWJacEdNK0QwL3B5OU9q?=
 =?utf-8?B?YVJyM3Yrb2dKcXg4dUtZYVVvclNkTlBZOWxKNDhIVmZtZGQwUWJVMWl3WUMz?=
 =?utf-8?B?eFFDWFhWdGJCYkRKNmd4SUo2UkIwcnB2RUEvankwSHQ0T0xuZlZiQ3lHVE96?=
 =?utf-8?B?d3p0UnZOeHBBb005bktOYVNrdDh0d0tnUWdnMXVpajcwdEpnNit4c1hCZUNz?=
 =?utf-8?B?NUJSM29NazNWNnlteFlsUnB1VTlKbWVpWitzU2RjNWdBNXMyUnJrQWJtT1ha?=
 =?utf-8?B?THJuQTNhb3RIZml6anRQQnZUbEltelJvRXVYWTcvc1U1eFJhWHN3VjlMWnEr?=
 =?utf-8?Q?w1YVfUMrm24VMa1vkAz6JA8Sp?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: YQ7FGwrlBmo0kZc0Kw/y49+0VqRuv+PfLvy3lvR1eFp/wF4vi2EuthGIMK1mCBV48MyoneapgH/AhZfyuD2r9QxP8JGk6y0i8/Ccg9i5DfoZxs99QMrXlj3o5XFfR3V7oc8wqI6vngK/xF1fkVO3TDDlgZ//b1pi+MQ2QjByLQ/rrNJeplbkEMRlAV7UdvoqxAHpXm0puzTmVn1ig/ibHVmQLYEPsNohpkBlMfH+j81B1gp2UiZW6sKVTBrULXTCFwEUyXSf8IeAfmjotCJzbM+vsST1PJymdQJHf5RemY02CJInSXTGPNHrcGqn7YWVok0xTGLqpndrcMu9ADqQgm1tjfY3cwLiP4waHopoSyr11IjupucEk6QE/1OR9NoE1LFX+gkT8g3btBuqUQTrUYgbb4vV77DzkPknlEPzRR5N/6Hyw3FfB88qfvKmBAhujwVTPW1CUR2A57No5OxJNnsq5tCRSJPasOxwFs+r3RTm/jIDNPjvftyMZkeprB6MMKxhG6i2+xJUFWV31CAe9lv61ie1DJ+UK3lramW0tBLrbGYqrJTpKiWLjthGVxhRBxSDXAOgT1wqosG1Mf3ijB+wS+FTjB7rNvdgpJHRkjroGRmPWv6ITFZKx93xre0YeMNc5jLO6z5is3cjKYlm1yu2QQi2s+f/XC3xCDV1xNTQuVyqn0wi2Kq+9id1+3ZIGQEasKUQYf1laCjQTRq2s+avMAeijYI+pubKiJ5cD6WHfHJVYLVnzulyKcc13Nwpfz0+klQM/F3nS8574akYx0TuPQ7tOQIjlmuFoVF/5T1k4DYc24p15+6Hkyw8ZTzSIfDzeXuLn6BCWnsnHAb2ofRDD6Qbtr+FdVjvzov3tsLeeyedtY4a4U0vzE9Yv/Yn
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9e15864b-aee0-45b3-6435-08db8790fd1f
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Jul 2023 13:14:59.7490
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3Imeh/j/IjGJcjrGZxNKDfwK6QX7Es/P8quvO8jW+41Z7hkZxCq6DRQDSKEG4kdnGFMJncPOE8SCdvwbhBBWhA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL3PR10MB6257
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-18_09,2023-07-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2306200000 definitions=main-2307180121
X-Proofpoint-GUID: 6-XC0hvLP9-xWM2phV8su_mSJ4XCwkxh
X-Proofpoint-ORIG-GUID: 6-XC0hvLP9-xWM2phV8su_mSJ4XCwkxh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 14/07/2023 22:33, Mike Christie wrote:
> This has hp_sw have scsi-ml retry scsi_exec_req errors instead of driving
> them itself.
> 
> Signed-off-by: Mike Christie<michael.christie@oracle.com>
> Reviewed-by: Christoph Hellwig<hch@lst.de>

Reviewed-by: John Garry <john.g.garry@oracle.com>
