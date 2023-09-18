Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 64CCFCD37B0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 Sep 2023 18:45:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229790AbjIRSpu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 Sep 2023 14:45:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjIRSps (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 Sep 2023 14:45:48 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B70211A
        for <linux-scsi@vger.kernel.org>; Mon, 18 Sep 2023 11:45:40 -0700 (PDT)
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38IHth05010127;
        Mon, 18 Sep 2023 18:45:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=dV/ijhqvU5f6yMOndj2Erou81Y/YAAK/bu/wlRRi23M=;
 b=wUklk1NCmAo/z6mH1FDhG+qz14IIDQ5h52jERGFU/JNGcNIv4RyEXUF+O1khdC6tKNCc
 wb6VKJhMMbyiHIiGjmGSe4ah7layV/8fF1viSWKN6ZxNaadHi4vuT4tYo+n5/6TgN4X9
 lDMjDo9PBJtw1NFJ7ph2gimHimlWi/ec0fVh1gQ3ryq77uKTP+R7dTBl5KwSZQ7f4mc3
 vn2ZgEo/tROFurtm3uUNHvq/NSEUd3VDlnuvhdPvWtsWtCob1hUb3xEYkpGH/G+GwOKB
 ssTJWqf690U7mUxh/IoP+AQJR3kM+xUTneJP8SFq8MBSeIr0zWDhNwt91NFA2qHgblaK +Q== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t5352ua9r-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 18:45:32 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38IHdRh3030778;
        Mon, 18 Sep 2023 18:45:31 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2109.outbound.protection.outlook.com [104.47.70.109])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3t52t4nxem-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 18 Sep 2023 18:45:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=UjfanzJ/4i9DutWayuJfGmwQTpkx+aNItvOaz7I/tNPOOzFSx2xJkqJHBdIs6DboaZHdWtqM2sgECKhL9X6L+Zy+2fovR05Az+QuqfKiJkrWmUhQv8jdyxXbICxhe7ggzXqCGqbm41tgp114YAZ6gTVyOxLaMlZYngXI5vxG9Ff8raNKWO1TWTrMJZLjteUAjkEWHqTVHwKbkkkpMxREVRNVpAaWI1AQgJQ5GtR000HJb0+V/ZABkuqwszn0IdEmt+fs7fLw4gGLZmO5Yu8UfaqPCPMYhBihUr+JZ/F0qf1DGLVqMQ9aQ9O5e+tBDGveNRZM2wKo8CkQlQz5/sS0FQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=dV/ijhqvU5f6yMOndj2Erou81Y/YAAK/bu/wlRRi23M=;
 b=ZEOB4tyrUZgKw117d8+vqdTzjSFbivfIOs02ob3e8J8pevqzLFC+kfAGkEnvPqXeriuWPfixc/Sc2i6hEagpt8UyWVxaY1XJhE0fRZeqzRrH2Kk29GoISZdaRXazX4s63W50gsQ4ZC5L+ocsct6mHfKZqzifEWz2cFTrwjNWSc2H7Xp/2wKwLyZR348LUJejiJK6PEDpQsDevftHF0r8Hw1HZ7ZtmT8tsUZqV+SGwErkivHa8VseYlAuaxyZaFH1Qer4ywEoDE9XFjMTHgguimlVUY5ZcGdFZ77OiP6YgoG7ADjUHmfbY8gHAY8EX9wOTMjfQdTHBP/bVRfKJtaHZg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dV/ijhqvU5f6yMOndj2Erou81Y/YAAK/bu/wlRRi23M=;
 b=n48dpIgjqrOLKSyx8yjB7Jyp15I5WCROW1+ILitot/ORZ5u47I0yhX28nTpr6fO2SBDAOkryiV6q62W5fEQknayFJn1j0koPpxdvmel5zSCyTugFZZduX0ew1HvYpWzt1zoIIUaf+gluAq633fxam3IF10kqXj9b79Hc6asJX4M=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by BLAPR10MB4819.namprd10.prod.outlook.com (2603:10b6:208:307::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6792.27; Mon, 18 Sep
 2023 18:45:29 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::2a3e:cf81:52db:a66a%4]) with mapi id 15.20.6792.026; Mon, 18 Sep 2023
 18:45:28 +0000
Message-ID: <e35f738c-b6d6-4e86-aa29-875b3629a0b7@oracle.com>
Date:   Mon, 18 Sep 2023 13:45:27 -0500
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v11 07/34] scsi: sd: Have scsi-ml retry read_capacity_16
 errors
Content-Language: en-US
To:     Martin Wilck <mwilck@suse.com>, john.g.garry@oracle.com,
        bvanassche@acm.org, hch@lst.de, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, james.bottomley@hansenpartnership.com
References: <20230905231547.83945-1-michael.christie@oracle.com>
 <20230905231547.83945-8-michael.christie@oracle.com>
 <d3d8bc89e45708cde24912b497348f12c662f45f.camel@suse.com>
 <8d8cdaefa944afd3c478ffb77570cce53f7041c6.camel@suse.com>
 <64399d0e-dacb-4789-b37b-938a5e98eeee@oracle.com>
 <25a0b3bace532c5340196466f8a4194c9b8da473.camel@suse.com>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <25a0b3bace532c5340196466f8a4194c9b8da473.camel@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DM6PR08CA0055.namprd08.prod.outlook.com
 (2603:10b6:5:1e0::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|BLAPR10MB4819:EE_
X-MS-Office365-Filtering-Correlation-Id: 443320fd-ef21-474d-11ec-08dbb8776def
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kiJnkw63yjQ/SpqmNGTx7XcAH7TsKZFAf1Z7bu/ytjIZHTsNFyKlugr4W8yDEnVND4lOzou1iU/wLITJxzPWI5Mkq3mpHaCyrYpUzfu5IZvaDYTXBFl/6EH1pFZwKNL3uao1oU9/NQjiBaRlIlRVKmMUIiX4Tzi17bQjFdI7lZFUG2oU4sg/jlmaNT8ULOE5tVSXNULfAzx7enEgEV1U8v83fuhcpbF3Mcdn33n+LqjyZ1jCdPJGJFaeGNXig7Nm3Hno+bipd0+sFY+s1QxM2WLw25kQYsngIp1+dho1MuQUJ6AmeXDSkLrFCrNUCEpKPiCcL07Kf9QAWKKWNUNkG2V0Yy5fa0QCF9ifobEusr6yPMrD1sI8P+ga6AKOEwGo9iLrAG/TAT+SI0zl8U0Zz46cN4X2VKBp/T/G35CUoI0IXL735V4v/5bru67mGuWkrUd7CJ7pgYsiTumVPN43ahsFuzKe4nY5YfsJbQXEQZ0U2+soBXfJaEqbid4eGZ8za8katsd0ObNsOl2cGbk4bB30ThzRQYNkLdWvVVylYWKEa6bHTYrbCqS7TG+6Bg2bGV3FGqo10m+PPT3+mpnBgb+Np4s58xX/7T+f0wIv0AUNeNj0QLS5Vsg2XfZxXka7nD9/JPB8fYBPGHxvvXYVAg==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(396003)(366004)(136003)(376002)(39860400002)(346002)(186009)(1800799009)(451199024)(26005)(8936002)(2616005)(8676002)(83380400001)(2906002)(36756003)(31696002)(86362001)(53546011)(6506007)(6486002)(478600001)(5660300002)(31686004)(316002)(6512007)(66946007)(66476007)(38100700002)(66556008)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?UmdmNVNXK1RoNmsvUUo4QndjaXd2ekpZWEMrUGlBZjdsZHBUdElBL3h4MDFw?=
 =?utf-8?B?R1RUbTJiaElONHg5MW00dWhBcnRraW1ZMlhlOEVkdE5vYjVrS0JOZGo3REtm?=
 =?utf-8?B?U1ZuNFRDQjAwZm9IRTVnN0IwVFN5OVc5SG9hRHMvVitTUkxmcTFJVHNVUFUx?=
 =?utf-8?B?TWx0N2djWkZiSnN4Qk5GK1dxNGZTTncxM0tVUzM2UWZTMzd4VitGc1oxNWFy?=
 =?utf-8?B?cG51a21mUkpjclZBNDc1OUdZNkc2aktUcXQ0b2VCTG5KRDZqOC9EdjA2NG96?=
 =?utf-8?B?aTByQTZTOWtOMlp1VzkwZm5WS1FiUTUwcnpWc3VjNWhjT3ZhSHd1YWFFV3d3?=
 =?utf-8?B?WXlLbURFR1B5Rk9GSGdidU5FbjIvZmxUVUhRQnJ3NW9IMkxSdVVSQWkvQ0NR?=
 =?utf-8?B?dGh3SHhsaVVzRE5KbDZLNVVmejk0Qm1HZEd5TTVSVHpTQjNpai9lbTlIbDVn?=
 =?utf-8?B?OHliUlQ2N2hHdURtSWpXRklqOGh3WmVaRm5iRDhNTEp4MzVVdElLWng1UXBa?=
 =?utf-8?B?L3ZoT2JFdEtvbk1oUmlqS2wvdzhJc1RBbWIvOEE1SjVYSGNXblQ4VThtbkJu?=
 =?utf-8?B?SnpPZXFUSEQ0NG1GRnNzUXhMTXY3c25jUkRNdU5sV3dRMU0wSlFLaVlEUFlx?=
 =?utf-8?B?SzNPck9DdWR3Skt2Z2IwT2FMOEpzbEk3ek5hckRPTkI0bVdIQ2RHYTFPQkJR?=
 =?utf-8?B?L0dNeC9ZbWtROThRemNiUnkvVjR2OW5QRWpidUFhY2FQaWFXVDhYWjNCR0l4?=
 =?utf-8?B?QnJXL3Z0L0ovcEhaTWFDTU85SmxIYngvSjBmdHVaNnYyNnF5QWVKNk5DaWpy?=
 =?utf-8?B?ZmZXWVRmdXV6UWlyVTBSaHJ4VlMrWjIxU24wekFlU3NscjNCcEtudUcrSHdp?=
 =?utf-8?B?U0NQOHl1TEFvVVpXSVZ5Z2wwN1J0cUZiU2Ryb1A1TVpUVUxpYS9NaS9KRmNC?=
 =?utf-8?B?R1dIN1hjZnVYQ3g0YUFZTjlUYzdBOSs2c00rK0VIVmwrNlpNWGVseXBoQlE3?=
 =?utf-8?B?NVZxTE4zVmpvb0NIcDRpQ1h3Wk1MS0lNenpaSi9PM2ZObGRQeThacUxZUFNN?=
 =?utf-8?B?aUhmWFJ2akphbnVtZ1dRQnVBcXo1cUZGY2tjQjFQMU1zZy9jTmwrYmRCQ3Br?=
 =?utf-8?B?dzFJUXlTZG96UUFlTm9LYUcxeDNBWC81eU1aS012RHNvUEZZMjlQNEp1WE41?=
 =?utf-8?B?d3JqcTk4YTlEN09pWTl4YnZoNitzOW1ZWThHWFlsejArZFJPK3JpeUNLLzE2?=
 =?utf-8?B?bHFQNThVQjZxMkcxT1Z3cVhVbUdvYVhLYTJQTmVaalJWQzc3Qlo3cnJKcUY3?=
 =?utf-8?B?ZU16T1FiQVY3NnFOeUFXRjNxSjlrSmRxNHYyYklpdFlHTE14TkpJeDB6dHRu?=
 =?utf-8?B?ZWdsMWYzVkVrZDUxNytVdkxPa1dLWTdaOGl3d0FtUG55UXhxWGQxcHRMQ2xh?=
 =?utf-8?B?d3VNVSsvRlExZnZ4S3JxalVtTkZqTUlIT0NpTjZ6ZmpCNVlzNENvVDhzQnRP?=
 =?utf-8?B?Szd3WFNUS0dqa2dqeDNIbjlQUlE1Z3B1T1ROZTc1UlZ4WnNYRXpTMjd1ODM2?=
 =?utf-8?B?R0x4OWc5OVdManFMdkE0cCs5WGNFWkhrbDloQTlIOWVhK29CK3RkVlBRZ3dR?=
 =?utf-8?B?NUdUbW1oeWF4MVpGYnZXZVRtbVJxZVJlWVNmUkdVdHdmM280cG1VYzVxZXk1?=
 =?utf-8?B?OUtJMEQ0aCt2VklUZ2NjZ1lCNjRncm5EZjhHazZ6cnRVWDZ3L3pOK3p2V2dj?=
 =?utf-8?B?Vm83ZXpZdkVVVmY4WjZYOExPNFhSRUo2ZU1OUnZYZVAwZHhMYm52R1hld2Vr?=
 =?utf-8?B?SGM0QzUzbDZoNUJLSnE2WFlUSEJUZzQwR2lhRkZsNmlzakFrSmkrMUxXTnll?=
 =?utf-8?B?bVVCMy84MkxLcTF2WFNyVkJ6OW13V0VSSTZXK2hOYm9TRkdSdmt5TFYybXh1?=
 =?utf-8?B?UTZhbEdKWG56MGRpc3JvanNkOHhGNEowZDJuTUJRUDRlVmhTRzRUQWNCdDdH?=
 =?utf-8?B?Q3lQeUt5QUw5OWY0VHNnR2s0TkdPK3NFWHpvV0RrTktzZUR3VHJCem0vdGsr?=
 =?utf-8?B?dXRMcjcrVUUwb1hoajJuN1ZGTFpXSEhKYUtIOXNyNWxXRHpEK2Z0RVI0Unh4?=
 =?utf-8?B?L2FtdXZ1a0dLTmlJSVlWWnBnM2NQVzZicml0cDM3b1J3eXRYWGwzVk1CbXF5?=
 =?utf-8?B?WXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: HxobFmedDy3hW3AV0LS0fjcQFYli+a6j3TNGmd566UdTVsH1qZKIgjCZq40TPHnQUakrcftig7CU20nJ5aPPlljn1072WD4WzVBYck6RuTZTejG4/tSpE0ccJQGTeh1PYNamrEWdPrkdyAN2rJPTcwOTTEBdispwkaVL0spf5Tl23SeTaHzj9jBZlWb/f9l8kvD0z2jjrm+9Yob5FXKPOysi2Hl3QoYQX8nFmxjsKkY4DmQibYgTujLPZCzhz08EIKGQejRarAo1b49RLTSQspNid6Hto8DgEjqGHLnQYp7J0Sy/GQXirepLszlIj3I3xHvc319zTxE0I8KK7QjHDq7Bglq6kZbuDBjzD/Z3k6zVvh+URonbDUu6sw//ywLY2JLg2OFjKnxYPUBlHEbfrW1twIj6CBcIb+66HOF3Aj0ZV6E4GhgMIKI9YV1UAfTr2XGYj2tlKgkVkEQko0izRzkiwhQnjETTPUuHbA+3rRvCpSRtQTgupMz7biOAcQg6e2b5OkSSWFrVRr/f0FQhpx6HvlnyTf4WETBL+aL0BuWBUX9XfQQSW/Thw0s4WUzO62iFWWRYs5FS5oeOwwmvCxdg1+6NEasRzE6U2HKjVlbgyXePy9hBRbxY2VFtOLgygJHjb4BN0GOUjDHTf+5EH5iZTsDe1JueyshrkhQvg8osJlvmMzOTmGn3HKxEj+PFnXReNNV8Bh/bNb1AH8UluBaykx/piharWdqzGwxKdsOHJEW5btgqfyTDXZdJiLuzYbDDzNNVz35Y9Ubj66nMhyHC2nLSzEy+Gilr4gZHtxJYU0SP6Wj+r6zpWjgZZctlpO7Dc4bRTzFE6m3DE4y/waCr/kqbj8z4dIq7RP5ezn4WW/i8hMWof6/hz8SC9biB
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 443320fd-ef21-474d-11ec-08dbb8776def
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Sep 2023 18:45:28.9202
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: un1eFK2lqUkowHX55fiwUC0NkH1UidtDrbHQ/BWAksfpYyBLDVt5eOHuFQW9VbrwShsHNzGY6EM2q/ZdhNVoaBm7C6I7x1iJCJNzn5gq8Io=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4819
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.980,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-18_08,2023-09-18_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 phishscore=0 mlxscore=0
 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309180164
X-Proofpoint-ORIG-GUID: Sc58egiuA-lFcdSI9QmOazLb4jJrJXuz
X-Proofpoint-GUID: Sc58egiuA-lFcdSI9QmOazLb4jJrJXuz
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/18/23 11:48 AM, Martin Wilck wrote:
> On Sun, 2023-09-17 at 19:35 -0500, Mike Christie wrote:
>> On 9/15/23 4:34 PM, Martin Wilck wrote:
>>> On Fri, 2023-09-15 at 22:21 +0200, Martin Wilck wrote:
>>>> On Tue, 2023-09-05 at 18:15 -0500, Mike Christie wrote:
>>>>> This has read_capacity_16 have scsi-ml retry errors instead of
>>>>> driving
>>>>> them itself.
>>>>>
>>>>> There are 2 behavior changes with this patch:
>>>>> 1. There is one behavior change where we no longer retry when
>>>>> scsi_execute_cmd returns < 0, but we should be ok. We don't
>>>>> need to
>>>>> retry
>>>>> for failures like the queue being removed, and for the case
>>>>> where
>>>>> there
>>>>> are no tags/reqs since the block layer waits/retries for us.
>>>>> For
>>>>> possible
>>>>> memory allocation failures from blk_rq_map_kern we use
>>>>> GFP_NOIO, so
>>>>> retrying will probably not help.
>>>>> 2. For the specific UAs we checked for and retried, we would
>>>>> get
>>>>> READ_CAPACITY_RETRIES_ON_RESET retries plus whatever retries
>>>>> were
>>>>> left
>>>>> from the loop's retries. Each UA now gets
>>>>> READ_CAPACITY_RETRIES_ON_RESET
>>>>> reties, and the other errors (not including medium not present)
>>>>> get
>>>>> up
>>>>> to 3 retries.
>>>>
>>>> This is ok, but - just a thought - would it make sense to add a
>>>> field
>>>> for maximum total retry count (summed over all failures)? That
>>>> would
>>>> allow us to minimize behavior changes also in other cases.
>>>
>>> Could we perhaps use scmd->allowed for this purpose?
>>>
>>> I noted that several callers of scsi_execute_cmd() in your patch
>>> set
>>> set the allowed parameter, e.g. to sdkp->max_retries in 07/34.
>>> But allowed doesn't seem to be used at all in the passthrough case,
>>
>> I think scmd->allowed is still used for errors that don't hit the
>> check_type goto in scsi_no_retry_cmd.
>>
>> If the user sets up scsi failures for only UAs, and we got a
>> DID_TRANSPORT_DISRUPTED then we we do scsi_cmd_retry_allowed which
>> checks scmd->allowed.
>>
>> In scsi_noretry_cmd we then hit the:
>>
>>         if (!scsi_status_is_check_condition(scmd->result))
>>                 return false;
>>
>> and will retry.
> 
> Right. But that's pretty confusing. Actually, I am confused about some
> other things as well. 
> 
> I apologize for taking a step back and asking some more questions and
> presenting some more thoughts about your patch set as a whole.
> 
> For passthrough commands, the simplified logic is now:
> 
> scsi_decide_disposition() 
> {
>          if (!scsi_device_online)
>                 return SUCCESS;
>          if ((rtn = scsi_check_passthrough(scmd)) != SCSI_RETURN_NOT_HANDLED)
>                 return rtn;
> 
>          /* handle host byte for regular commands, 
>             may return SUCESS, NEEDS_RETRY/ADD_TO_MLQUEUE, 
>             FAILED, fall through, or jump to maybe_retry */
> 
>          /* handle status byte for regular commands, likewise */
>           
>  maybe_retry: /* [2] */
>          if (scsi_cmd_retry_allowed(scmd) && !scsi_noretry_cmd(scmd))
>                 return NEEDS_RETRY;
>          else
>                 return SUCCESS;
> }
> 
> where scsi_noretry_cmd() has special treatment for passthrough commands
> in certain cases (DID_TIME_OUT and CHECK_CONDITION).
> 
> Because you put the call to scsi_check_passthrough() before the
> standard checks, some retries that the mid layer used to do will now
> not be done if scsi_check_passthrough() returns SUCCESS. Also,

Yeah, I did that on purpose to give scsi_execute_cmd more control over
whether to retry or not. I think you are looking at this more like
we want to be able to retry when scsi-ml decided not to.

For example, I was thinking multipath related code like the scsi_dh handlers
would want to fail for cases scsi-ml was currently retrying. Right now they
are setting REQ_FAILFAST_TRANSPORT but for most drivers that's not doing what
they think it does. Only DID_BUS_BUSY fast fails and I think the scsi_dh
failover code wants other errors like DID_TRANSPORT_DISRUPTED to fail so the
caller can decide based on something like the dm-multipath pg retries.


> depending on the list of failures passed with the command, we might
> miss the clauses in scsi_decide_disposition() where we previously
> returned FAILED (I haven't reviewed the current callers, but at least
> in theory it can happen). This will obviously change the runtime
> behavior, in ways I wouldn't bet can't be detrimental.


I think it's reverse of what you are thinking for the FAILED case
but I agree it's wrong (wrong but for different reasons).

If scsi_decide_disposition returns FAILED then runtime is bad, because
the scsi eh will start and then we have to wait for that.

The scsi_execute_cmd user can now actually bypass the EH for FAILED
so runtime will be shorter. However, I agree that it's wrong we can
bypass the EH because in some cases we need to kick the device or
cleanup cmds. So that should be fixed for sure and we should always
start the EH and go through that code path.


> 
> Before your patch set, the checks we now do in scsi_check_passthrough()
> were only performed in the case where the "regular command checks"
> returned SUCCESS. If we want as little behavior change as possible, the
> SUCCESS case is where we should plug in the call to
> scsi_check_passthrough(). Or am I missing something? [1]
> 
> This way we'd preserve the current semantics of "retries" and "allowed"
> which used to relate only to what were the "mid-layer retries" before
> your patch set.

It looks like we had different priorities. I was trying to allow
scsi_execute_cmd to be able to override scsi-ml retries, and not just allow
us to retry if scsi-ml decided not to.

Given I messed up on the FAILED case above, I agree doing the less
risky approach is better now. We can change it for multipath some other
day.


> 
>>> so we might as well use it as an upper limit for the total number of
>>> retries.
>>>
>>
>> If you really want an overall retry count let me know. I can just add
>> a total limit to the scsi_failures struct. You have been the only person
>> to ask about it and it didn't sound like you were sure if you wanted it
>> or not, so I haven't done it.
> 
> The question whether we want an additional limit for the total "failure
> retry" count is orthogonal to the above. My personal opinion is that we
> do, as almost all call sites that I've seen in your set currently use
> just a single retry count for all failures they handle.
> 
> I'm not sure whether the separate total retry count would have
> practical relevance. I think that in most practical cases we won't have
> a mix of standard "ML" retries and multiple different failure cases. I
> suppose that in any given situation, it's more likely that there's a
> single error condition which repeats.

I'm not sure what you are saying in the 2 paragraphs above.

We have:

1. scsi_execute_cmd users like read_capacity_10 which will retry the
device reset UA 10 times. Then it can retry that error 3 more time
(this was probably not intentional so can be ignored) and it can retry
any error other error except medium not present 3 times.

And then it calls scsi_execute_cmd with sdkp->max_retries so the scsi-ml
retried are whatever the user requested and 5 by default.

I think we wanted to keep this behavior.

2.  Then, for the initial device setup/discovery tests where the transport is
flakey during device discovery/setup, we can hit the DID_TRANSPORT_DISRUPTED
that multiple times, then we will get UAs after we relogin/reset the
transport/device. So I think we want to keep the behavior where a user
does

+       struct scsi_failure failures[] = {
+               {
+                       .sense = UNIT_ATTENTION,
+                       .asc = SCMD_FAILURE_ASC_ANY,
+                       .ascq = SCMD_FAILURE_ASCQ_ANY,
+                       .allowed = UA_RETRY_COUNT,
+                       .result = SAM_STAT_CHECK_CONDITION,
+               },
+               {}
+       };


scsi_execute_cmd(.... $NORMAL_CMD_RETRIES)

then we can retry transport errors NORMAL_CMD_RETRIES then once those
settle still retry UAs UA_RETRY_COUNT times.

3. Then we have the cases where the scsi_execute_cmd user retried
multiple errors and in this patchset we used to retry a total of N
times, but now can retry each error up to N times. For this it sounds
like you want to code it so we only do a total of N times so the
behavior is the same as before.

To handle all these I think I need the extra allowed field on the
scsi_failures.

