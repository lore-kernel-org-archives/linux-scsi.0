Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 432E1C678D5
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 15:15:24 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229577AbjCGPPX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Mar 2023 10:15:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230203AbjCGPOi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Mar 2023 10:14:38 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B8014200
        for <linux-scsi@vger.kernel.org>; Tue,  7 Mar 2023 07:09:22 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32783nst010526;
        Tue, 7 Mar 2023 15:08:58 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=tURs9cnU0j9W79j7Jdt2It/l/8sSlXC5j/z4cl8pa0A=;
 b=1nv2O6/BR6dFr3kqD3QS8EguaL9sFVDr7qvWRSdCtwJA9JkRBbqCxsI8K+DmDqkaM3rT
 PxR8msueHXVHSLwITUQ0UgvkeCC9iIBd6i3wi4NxFlAdcR2/eiGjWrkM4VTHcO0jh6CR
 pPItl1g5dO64p8PHiQdS0/LqR3S2IxqrJbdggiNlfcaNQ4cVDdbpcSg48enTdBehO1Ok
 GbuPTU/gKW2wkeosM/8PuiQx6a690JNOWqmACxoLRHGJaskC9x6OFig7jkw2eKuY+Hts
 pHKNsA7wKTQU7HBoTtbHVpbW/oBTCGvaS89w2DLzMhpwwXgSmQNGLnqvJvpgW+KrlEpv uA== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4180wnw5-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 15:08:58 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327E3bpP023428;
        Tue, 7 Mar 2023 15:08:57 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam02lp2045.outbound.protection.outlook.com [104.47.56.45])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4u06c3ng-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 15:08:57 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=oTDo79/qmi2lCCMZcQDE639ugOnVYHbR80LbRWhzcikD0jHvF4m0K8DELbqJKJLwgysUm/pr5Th6mJwylk4u3LK9A4XwiMfWj7B+0zSs0cKsUyS0tXBZqnTJCpH23eHdtuOC4yhjsbZTvIYHRDe+smgvct+8dFjZ/UemOPnjrZ/j7h1ZuYK+bUdCbbEphd2pF22vDVn0+rJXoOLlDjSV4dQB/IZb4NiauBpddqmL852NveYaM/Uf4Dk9a7rRYCr98VeZN8qJqFBJgKQ+V+fGy0b+7wp6zur2vpK4xUJUTZ7Z0L4WdTR/7ZRM3AasFAMyyuIt/GXc78PBHVzFcztSKA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=tURs9cnU0j9W79j7Jdt2It/l/8sSlXC5j/z4cl8pa0A=;
 b=PrYAIaNaKZr8m1LkYpHEYDPE/LqKHwtVzVdK4lB5qFidBp9DlShiCWwcNNRMKyD/E3Lo0cLYKmn9rLY9+gmcfTKQEheK9P6YKnptRt2C7pmkLqZwHPH8i9S97rZ7327eQ3kkgA0HxUkCvDl7h3z99dCY9Wl7x5t7OmehZXreurrLISPIBzGaAunIeOgMTJAppjXuuImIelBjjd2t38cyR5ybMbuCarXG7ib+VznwHpy5dUyh0g6mgA/IRm0d/OuJyz7Nn8gdZxsS7M0dzJll/UTZpD4aSlloV6hTWbFxnOpp3RqU6LtagXny6swuIbBvy6q1RE5H0i6CyLjji4D2pg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=tURs9cnU0j9W79j7Jdt2It/l/8sSlXC5j/z4cl8pa0A=;
 b=RyQerKIngD5VY3vg+d934T5AvX36uvs4UNQQGsdkEexnC/yWaoPV91g+GsfB7cM4Mxbzm2cJW26B4uw1Q6HX+W6mwzqf+WXpsarksvw+TFe3oW5ayE1AceB1pdQ2GT/ifOyd8PMSZnCEh1KxwTUEXSGcHm9EHAuQBU8gE9oLxtA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SA1PR10MB5734.namprd10.prod.outlook.com (2603:10b6:806:23f::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.29; Tue, 7 Mar
 2023 15:08:54 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::fff7:981:3ae6:92eb%4]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 15:08:54 +0000
Message-ID: <ed6b8027-a9d9-1b45-be8e-df4e8c6c4605@oracle.com>
Date:   Tue, 7 Mar 2023 15:08:50 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 0/2] Remove the /proc/scsi/${proc_name} directory earlier
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
References: <20230210205200.36973-1-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230210205200.36973-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO2P265CA0055.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:60::19) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SA1PR10MB5734:EE_
X-MS-Office365-Filtering-Correlation-Id: 13ee3128-9f83-408c-8b8e-08db1f1dde3b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: X55PeUFRLfwrtDuGu0UGEcRIOxxBJw20yMDyqB4iFKOyQvbvuSoPS7z9cNHDkXcfD5RWeajEvcWEXkwRPJMda2xdEDzEJjLCn88USzyf9E/BlOA9LjOKimdfAvDTPciunsKdM/LgFMz+9nUWahP+ZMfwph5anWxEplVuOAIlYo+4h9IUSGFj8hVtVigOOaP3/HublZEnZwp4SHq9OAaQh52USB5KXJVXqcqyNJXifHGWCHMQCP5Bbe5CjoEPKfGoUULiSlg55lxpxCTdm7A3amYSzwP3jxjkpYxJXFoZ9HvZLkpEExuY3L8HT5VYlw3Ej7IV3HNXtWjYZx2A3Azm8caECTPZK4DO2Qtbu/8kWU8q7S31fL08SrAI0B5CGTRwX4qTZBFyMaBva9hamYD/OQScQ7Q0oQxh655nvChxcDCdUZ/YuUbi2MFsBj4wg7GalAVavcvXFozJK8S+fC8epRjx+dYnSIlMmO67Vz9XMBdvirZWazPfBDnif7LAdplqv6yZWpfVWyU4phL3nzS/2MFLw6dI0N8tfhnwRmXfXjHr0IKxjAFy3wqqo06Eygud1CZ6I311pqhC9xKzpjcZkX4hqblHFxktrcsvvoTt+jIhwWgnGH4Mx2gqBHAyn+MMVrOwM+FEGXP3pVijYNTZr8hATdCijD3v1aN3Ag5aHVf4ne25kXUkcyiGNlpiO198oBUOzFEnaXLc8gQJFprDmA21nXkQnbNPwQ8vA5TtE4WK+lOEmbEjZSUuqN7fiIXm
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(396003)(39860400002)(346002)(376002)(136003)(366004)(451199018)(31696002)(36756003)(38100700002)(8936002)(2906002)(66556008)(41300700001)(66476007)(8676002)(66946007)(4326008)(5660300002)(2616005)(316002)(86362001)(6486002)(83380400001)(36916002)(45080400002)(6636002)(110136005)(6666004)(54906003)(26005)(6512007)(478600001)(53546011)(6506007)(186003)(31686004)(228453006)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RU9wSjdobUlEMkpiOVAzM1RNUC83UExQeUlmdVNpWkV5OWczOUVBV05ucVA4?=
 =?utf-8?B?RlcwR0tyczVWVEUwclJGbzd6Wm1aWWI3MDBZSTZsb2FIYlh2Q3l6VDluU1BL?=
 =?utf-8?B?cngwdGlyNENHbm11MExGbG5PNFo2ekJPVWJxdTY2Q2YxbWRZRHRMeTQ0bmhV?=
 =?utf-8?B?YU1OMHlJR09LbUhZS3FSYlFMbVBvSUhQQVhEWlBEUERpTmYvcURXMEltVzA3?=
 =?utf-8?B?NkZrZmErV2RtSnVrZWFCd29TT2NhRlY4TEJFWW9YaGtNTUJXVVNZdm10N3E5?=
 =?utf-8?B?N3NEaHNiNmhHQWRSZ3plMjk2SzlVL2Y3WjFCclh0M2x5V2VRcS9ONDRBd3Z6?=
 =?utf-8?B?MlBGdGpPQ2dGWlJ5T25KcndTYVh6Qjd6UUJSUmNlWmZjUXRGZ0hxSGs1R2NC?=
 =?utf-8?B?NWRScnVSaU5KTXNRV2ZJaWNJTlNkc1M1eDlmdk5HWWVMSHB4TTBYTUFUYitr?=
 =?utf-8?B?d1ZJenBBR3Vpak1GRTNiWGVKa3g2YmlwVlcwcm11TjJsR1JEczNNTGRIV1M5?=
 =?utf-8?B?NENDQmRwVlQ1YXltVFhBblBQVllnVHVhdGRxZ1dMVkhEZzJvNVNadTRkbHZl?=
 =?utf-8?B?RkFOZit3eFRzdGpKcVVVNHZ2V29MTktZNWdFTi9CVHVnQlFjMENHMEZRSVo5?=
 =?utf-8?B?eHpHQW84OEVaRXZoZFVIbGtUUFRna0VRTWRQSVF1akt4bWIxY0RuN2xIdkVr?=
 =?utf-8?B?eW5CMFZrbmgxZG1DczIzUTFVS2tMUlRGNU1aTE4xbTBtMm9jVXhYUjBpOVZD?=
 =?utf-8?B?S2d2Skx6YkFmemNPQkU0TUVCVFh1NlVnL29iYlVRNDRqTzA1NjFpb2FlUCtk?=
 =?utf-8?B?TjR1SmQ5RDcydjJYSlBDOTEwME00MXpJbzV6R1F2WU0wd2crbFRDYjVKRlBR?=
 =?utf-8?B?OXROa3duNjNqZFJxMHNBVklFenlpMG96NVFGdXNWaEFEdXg2cXNSR290ZitT?=
 =?utf-8?B?RnVzM1hPNlJBNTVBSCtWTnpyQzhpU291UzdZc05FSGtWMGhKRjN3cjJwUCtu?=
 =?utf-8?B?WHJGTXdjeUZLaFJ3VHowZkh6aU1sbmxZUTdkTFBqTkZjcU9aNXV4bWNUZk5x?=
 =?utf-8?B?N0dpTFI1R3ZkSHk4dzRPS3NnSzJEN1JSbzM1eVFkdEJ4Y0x4RlZtdlB6d09R?=
 =?utf-8?B?djBvWkQzYXJYWU9OOGx0U3NTQW1tVUpQTzNHRk1FcFFWS1ZtdU1SdEZkNE5V?=
 =?utf-8?B?TkJWTlFsNldwY3dFZWYvUWw5T0lYQVhoR2s4ZGphamh3UmI5NXVxaE80c1Z2?=
 =?utf-8?B?MGUvb3gwb3ZXQlR4bEdMTlgvUUFxajlHeEw5MzJuVGZYcnM1UEg3Z2xQakEy?=
 =?utf-8?B?bFY0UCtNYkRTclpnSkFlSFBocDlEa3luREUvbDdnMFROTEh3VEpRbFBPRFdy?=
 =?utf-8?B?ZVFIb1AwdjJIdTRVMFBRQUhrVkZscEZObzJCV2I0MlZjYXFjbkxkT09WTGhD?=
 =?utf-8?B?cjEzV3BGRlpkWW9IS09RVUVaQ2hrbzcyekZqZ1FoVFlBQ1ZiTnYrQ2NLWWtq?=
 =?utf-8?B?eEdlemdhRW5SMlRYS1JCc0p1ZnNXRGRlQUJQd1d0VHNLUlRxSGQxbzhmS3Iw?=
 =?utf-8?B?bUtKYldYbzVray84cHFWdHJjS1lMS1VrUEcwdVFHRnZOMitLeTZqQ2lwS2JK?=
 =?utf-8?B?bjVUT0lGaTJrbHc3MVY5WGNSL1hWNTFuK0hzaG5zS0JrUHpRVjRMU1FjbTk0?=
 =?utf-8?B?aTJlRGtlWXlwYzdHUG5yYkZsZFd3eFdUZnV6eDUyN1Z0bHhlVnJJOFcrbFJ5?=
 =?utf-8?B?YkpzNkZuYjVWeUtvZEF1UGUrRFlEeDZXdkc0Ulg0Skp6blZTSGdVTFB1RVNJ?=
 =?utf-8?B?a1dRWUFJZDIxV2pzSWQ5R254dVg1SlVuTUdHaVg2VGJRUHJkNG9uTUt6NXJl?=
 =?utf-8?B?VnB6VkQrSk9xV2lHT1RiWnA2d2pQWTBLUTdWaS9sKzNnMElldW85UUNVcExz?=
 =?utf-8?B?UFF0RFBabFYyOVp1aTMyd1FuelJ0ZWtnaVdhQjZjaUZTVjZVK3Y4TUdzd2lY?=
 =?utf-8?B?R2FJNndjdnNVRkp6a2IvWEk3VzM4VFZ3YkgxTXlzS29wbDFOZE85djNGNWd2?=
 =?utf-8?B?VENqL0lKdEZMT01lbVNhZmxxL0ZCZE93T2pOalVDODF1WllOMTFET0JaZ3pt?=
 =?utf-8?B?UndxTlNLVllMOGNTNm1GQ0M5Q243TlZRUkYwWWtVaG1qcWpEMWk5VnNHYk5N?=
 =?utf-8?B?R0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: WpFmSvoTpaKSkcN95OgZ3OrcSQd6GGD6t2qXDAzhlOLKi3FGEkjXNU6rhINZak0yNk0G4Na2ijFyMEOL/pSly0EGnMSh9dGJ2z3ROHgU4AqOmFfqgAsoXttbRzHWkoyxUhGrRXlr9SJyqtTv562n69DabHQBgZLJ7QfJZXvWrYwti545k77+XQasGreKjBhklWz3ZQ/K6YBFNsB9RARWm+16XKpG0Bc6qfUnyqFasWmiRva7FC/W95Kftkv7Gmt1zQ5zSzpbcHV8FsYynyzoDszWXm/kG2g+rIWAYZZlX23cPnDWK3MbnMOIUb8BHTfKaVl+sw8URCjg6hkFr3JUysvNGpV0OEkOP3UX5x3JZCY6yNdYu0JGPNZuKZGI8g6eoBOplGBLCZb3aEK3KuYDGx2ROJkcqdbOcD8xq5Hg3zouCV7CodtZD2Sh7Bh+1M/UA/QS/QXOpajqp5Lwbb9dlmdL8hWTq96rR0E4uftNM8vWC4PePpaXTBlOERbkFXqw4weVwxhf9tpo7kH/U3OGTe/UQ+7Ut55t1kjo2MY/i0SmkbBs+3DtfZZ0FcEsMKjdJwnvhJH+8CetHDDta7KTfA2LKslC74T44Yl8xU988dn0hmRlm1XZhimInBIAYKdSx4I7bu6WRG/v57uxs9dWTzcCfvl7UX3AO5ODAlbVBWVEoE4HOyKWMARQToIoIsvoaLi0vNVVVDMW58vzHrykgVuT4FyzBMm9sQQjtiYYGOijiC708CD2H2MKJkNUDMWHr02g7VThx5YDqDjg2feZInmxK8DORCb0/pqegkK5WscgtXj5Gul7dmpvbsovaDKQOKwTdF3gUXVyFXHVMh4MBB66tPGCBeE8bO4Q9KkW2dg=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 13ee3128-9f83-408c-8b8e-08db1f1dde3b
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 15:08:54.8513
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: eFjjIK28XHBzlWmZKhSNgySvO9QxpS7vsxynWm6tiW5HrSCHyNa12k+C+MwWahTHH3GDGpoJXTvj9Alzbpo0TA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB5734
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_09,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=641
 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0 malwarescore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303070136
X-Proofpoint-ORIG-GUID: xxfA5A0u7nNHAy1p08tBw82CkXlWtZPY
X-Proofpoint-GUID: xxfA5A0u7nNHAy1p08tBw82CkXlWtZPY
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/02/2023 20:51, Bart Van Assche wrote:
> Hi Martin,
> 
> This patch series fixes a race condition in the SCSI core. Please consider
> this patch series for the next merge window.
> 
> Thanks,
> 
> Bart.
> 
> Bart Van Assche (2):
>    scsi: core: Fix a source code comment
>    scsi: core: Remove the /proc/scsi/${proc_name} directory earlier
> 
>   drivers/scsi/hosts.c | 4 +++-
>   1 file changed, 3 insertions(+), 1 deletion(-)
> 

Hi Bart,

I notice this following issue with v6.3-rc1 for scsi_debug when I turn 
on CONFIG_DEBUG_TEST_DRIVER_REMOVE and set DEF_NUM_HOST as 2 in that driver:

[    1.330849] ------------[ cut here ]------------
[    1.333027] remove_proc_entry: removing non-empty directory 
'scsi/scsi_debug', leaking at least '0'
[    1.335280] sd 0:0:0:0: [sda] Attached SCSI disk
[    1.337231] WARNING: CPU: 3 PID: 1 at fs/proc/generic.c:718 
remove_proc_entry+0x180/0x190
[    1.342979] Modules linked in:
[    1.344389] CPU: 3 PID: 1 Comm: swapper/0 Not tainted 6.3.0-rc1-dirty 
#414
[    1.346760] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 
1.15.0-1 04/01/2014
[    1.349493] RIP: 0010:remove_proc_entry+0x180/0x190
[    1.351162] Code: c7 80 e8 6e aa 48 85 c0 48 8d 90 78 ff ff ff 48 0f 
45 c2 48 8b 55 78 4c 8b 80 a0 00 00 00 48 8b 92 a0 00 00 00 e8 10 0a d8 
ff <0f> 0b0
[    1.356712] RSP: 0000:ff7ad00780017c00 EFLAGS: 00010286
[    1.357991] RAX: 0000000000000000 RBX: ff4af384c146f440 RCX: 
0000000000000000
[    1.359716] RDX: 0000000000000001 RSI: 0000000000000001 RDI: 
0000000000000001
[    1.361439] RBP: ff4af384c1bc0300 R08: 6f6d6572203a7972 R09: 
746e655f636f7270
[    1.363145] R10: 72746e655f636f72 R11: 705f65766f6d6572 R12: 
ff4af384c1bc0380
[    1.364881] R13: ffffffffaa2ccd00 R14: ff4af384c1b47128 R15: 
ff4af384c1b4c420
[    1.366152] FS:  0000000000000000(0000) GS:ff4af3853aec0000(0000) 
knlGS:0000000000000000
[    1.367500] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[    1.368463] CR2: 0000000000000000 CR3: 0000000030c2e001 CR4: 
0000000000771ee0
[    1.369639] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[    1.370815] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 
0000000000000400
[    1.372040] PKRU: 55555554
[    1.372491] Call Trace:
[    1.372915]  <TASK>
[    1.373280]  scsi_proc_hostdir_rm+0x75/0xb0
[    1.373998]  scsi_host_dev_release+0x36/0xe0
[    1.374723]  device_release+0x30/0x90
[    1.375345]  kobject_put+0x68/0xd0
[    1.375923]  really_probe+0x24b/0x330
[    1.376451]  ? __pfx___device_attach_driver+0x10/0x10
[    1.377177]  __driver_probe_device+0x6d/0xd0
[    1.377794]  driver_probe_device+0x19/0xe0
[    1.378382]  __device_attach_driver+0x7e/0x110
[    1.379026]  bus_for_each_drv+0x7f/0xe0
[    1.379571]  __device_attach+0xb7/0x1d0
[    1.380126]  bus_probe_device+0x88/0xa0
[    1.380681]  device_add+0x612/0x800
[    1.381190]  sdebug_add_host_helper+0x1ce/0x260
[    1.381839]  scsi_debug_init+0x391/0x870
[    1.382431]  ? __pfx_scsi_debug_init+0x10/0x10
[    1.383081]  do_one_initcall+0x40/0x220
[    1.383637]  kernel_init_freeable+0x19a/0x2d0
[    1.384270]  ? __pfx_kernel_init+0x10/0x10
[    1.384862]  kernel_init+0x15/0x1b0
[    1.385368]  ret_from_fork+0x29/0x50
[    1.385891]  </TASK>
[    1.386203] ---[ end trace 0000000000000000 ]---
[    1.389637] scsi_debug:sdebug_driver_probe: scsi_debug: trim 
poll_queues to 0. poll_q/nr_hw = (0/1)
[    1.390954] scsi host1: scsi_debug: version 0191 [20210520]
                  dev_size_mb=8, opts=0x0, submit_queues=1, statistics=0

Is it related to this series, do you think?

Thanks,
John


