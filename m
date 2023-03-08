Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29E60C64EC4
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Mar 2023 11:27:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230022AbjCHL1d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Mar 2023 06:27:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229830AbjCHL1Y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Mar 2023 06:27:24 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53BA931E29
        for <linux-scsi@vger.kernel.org>; Wed,  8 Mar 2023 03:27:21 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 3288E1I5001239;
        Wed, 8 Mar 2023 11:27:14 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=6GZeUY2K8XQ4lMKr2gvaDufttwQ1E7fRlgd57sJx9zE=;
 b=ohjwRcMQwZ1cfKRF75HgOs/+HDgduIVvErq4JLNBAfkTzAePXNqyaZGbRnvp9+mb2l9V
 GM8W4K1uCeeX835LfkaNko8Z6SxNgq8EvMvkt284zpvNMHTurJTHyh3XOoalUxPbJLgE
 XYVXzmFLfET1RJtlauU9YSBJ3nzQy5VYvjOZkq/FrvFXdTj7WfUCMdqhXA5U3AAPh2LN
 y4XGEgLdhIeDSx+Sbi6mSzfMg6YWcgRGf7NjCrT6KKyPxVpCCcDLLdhFNTtr56UJO+mW
 QDNInOw6JENYFsAQP99hAeWmvi1LxSaXa3LGhO58w9VXO00Vl2lEAWEm0Yw7xhGu5c0y ww== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p4180ystg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 11:27:14 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 328BMuYx007166;
        Wed, 8 Mar 2023 11:27:14 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2168.outbound.protection.outlook.com [104.47.58.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3p6g4fk72w-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Mar 2023 11:27:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XrZuDoyBBaZlMAJ1sefxferxtY+hFOOCZkrUG7nzEBvj4ynISWsKqnU7ll6KDjhFf7xk912uHGTtViurQAwBm/9BM5cM2uoyuCsQIgYEc0wxdl+Bww9Rvy0prFF+STnujRTs0jwlBsKBxP41JfLRx8HgAaFyQzw+U+HFmGyyaByzuICtkurbnMTYkSk8yRLXMXAhpWX8hU1XhdMFjAo5cdmuHLflTSJ7J3Bny7B97yGE6ZM1rDwfTr/MySTSgltww4f7eKiVnCvcHpX/emUMBrpABTQAyyfgtCgeqPzZuQyauiLAhl3r1ivpQS6r4j2WckaDTkDLzA+fgTpNUEvMDw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6GZeUY2K8XQ4lMKr2gvaDufttwQ1E7fRlgd57sJx9zE=;
 b=B9WJE6Zd4ITkSHjahsMQWJL2t2Z4JbnDoTvALUfW7ffpvnrxynT5+H+dUahTg2uZonCkZ99GDswqq5mGohb1/dw62NZn4tEuc32mK5F+BUPmtzdrbUiX24VI3QGKb/+2wDK0UoClK1Sd+bnquJ3WUxm1TDILGg2Wz8Zvr7UH3M6zoDNSyheZ1Xq4C8eLtmvcRRvAnS8VxglSasYtNOfehcEJwWNFTpyg7zNbgAcGA/Y0uAlJB20EML2cQOX2Z6FWbEMfABAso+umPhUP0sZW03wFnoy9GEVAdS7RJqpFYDF7t0e4BzRVcsfODv+5hAoyQbld1b1dURPAr1GHLyTIJw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6GZeUY2K8XQ4lMKr2gvaDufttwQ1E7fRlgd57sJx9zE=;
 b=ewceWgdpk3LVaB/rkDP2CGlEFugxWiFxabV+X4WFVdyVjs0KAZqKMR7ak02St7il3xPkBHf4+p8rwHov5ZQQkZW0sFv+UL+ksHTZJPSz4bWU5A3phZkbGmzZ1SgxRzANNCCXL+6xRHDAwgiQpsFEn4AU1Zk7woqz4xbTRBKHDbY=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by SJ0PR10MB5566.namprd10.prod.outlook.com (2603:10b6:a03:3d0::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6178.16; Wed, 8 Mar
 2023 11:27:12 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::7276:bc4c:17a0:7267%4]) with mapi id 15.20.6178.017; Wed, 8 Mar 2023
 11:27:12 +0000
Message-ID: <3d2c5983-a638-a7a1-c1ae-891cbbdd70a0@oracle.com>
Date:   Wed, 8 Mar 2023 11:27:08 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH] scsi: core: Fix a procfs host directory removal
 regression
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20230307214428.3703498-1-bvanassche@acm.org>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230307214428.3703498-1-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0541.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::12) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|SJ0PR10MB5566:EE_
X-MS-Office365-Filtering-Correlation-Id: 816de66b-dbc2-4653-d769-08db1fc80fc4
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gwN5hBfVnytiKvlQ3gVXtqevYzkVVMNBl3IsYr9u1xypCAOuf32xfMEEGKMi5mYhK4tNLgiseE3i2ir93T1uoOfVmhNSS+F2onJXnO7ItMIKiai4UtvNCAf0TmA7qenENu4yEEGU4voAEodbrXV6tBK9Exr/nZcOH4ogABYpkdG4EX1M/e3BMbDVx+KKq+cOVmFG6g0QCn5bHkMCBzniyEpAm3GTCcmJu6g83c1GS/ZL1xxKWRY110RP+hVk7XDjxss/+3saJU9S0zD8uztLmO7nDZ3J5sBl4jpRN1kUZ35va1wtkM9z7sIxAznXyHmCgwCocF3py3mlgvq2dRznd087crYI/pMRXeqvqIlreiEyphv6Ye6jMFBUcZOH90FQRSB2Jf8KD5sEMv9VieRdd4+7tVRRdTL082Z9Im1AId0gwwB6LIStpmvwGDC0QKy5EJpOZwR+KEngGr89VuPr47tqOCcQUazz6YfSGmdG0TCTE95WEvrqGkVP3snaVXZX7D35KCEEkltK5TqSp/fs2BRl4AHujr73vsPFGf06qO61JWm+HLXdj4qhRWy1nk8lUpR5IUQUTyKNPhHpgm0aSoB/NaR4k03CC9H+cDWej/ehUSzDC0V8V0M+jXrmfgK5VYYwxEJ7Neh/VHO5S7hzWP4K9Kc69NwZrz0QChpdKA+SLWX8u5qirV8WyrQ6Yrs9L6aZA3hkfGiS9bEpPEfKUxMpGZ8tzx48DAT42PgNLLM=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(136003)(346002)(396003)(376002)(39860400002)(366004)(451199018)(5660300002)(83380400001)(41300700001)(8936002)(38100700002)(36756003)(31696002)(86362001)(2906002)(6636002)(110136005)(36916002)(2616005)(316002)(478600001)(53546011)(6666004)(6506007)(6512007)(26005)(31686004)(66556008)(186003)(6486002)(66946007)(66476007)(8676002)(4326008)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?R1hrS2h2ZFNCMnQwNHA3NzlaV1FnYTErSW1DaDArMGNJZXZvRUp6YnBqVlcv?=
 =?utf-8?B?R0JzVkI3SlhVVUdMOVI1TE9XZDVjZHRQUjU2T0dXbFU5QUZiTkZ1UjJ5ZDFn?=
 =?utf-8?B?UitsSHBYd0FuczVRUVdQMTZoSFRiVVVwUDNmRmdSRWd6WDhZRG44UXd6Ulov?=
 =?utf-8?B?K2I2QXdITkdkUXRZWEZ2cHJnVzlLRVNLWHRNalNvNFVXSTBBdzJVYVJScm10?=
 =?utf-8?B?bVZqUmwzRXlUTVdPRUdwZGRqZEc0dDhDcVFFTm0xK2xJWWt1emVOOUQzbE9I?=
 =?utf-8?B?MTFYR0RpYTBFeHEzblllZkhrN1RBbU9sV3BieTNQMWllSGFrNnZ1VTQ5WTls?=
 =?utf-8?B?YndWSDJsbTdmcUgwQVh6YThQR0xEVU9LenR3MCtLSUhtTGNWdGhpT2I4SCtt?=
 =?utf-8?B?eVJXaUxuNS96UWdNbktZQnJ3YkVROVRwLzROL0xHajFFMzMxcmNXZlJJUStR?=
 =?utf-8?B?WUpDV3pQNmwwYXkxQWlSd1U0clJ6UGdPQUtLcXR4dHNrYWVWOWpGQ1FQbGJz?=
 =?utf-8?B?a2hEczBpSWhoQml1RUxOU2hDNzkxdlVtRzFNVWxNMngzQlhialJ2Nks5YzlV?=
 =?utf-8?B?bkpvUkZaTXhybU43L1JhR2lPL1BjNm5HbHovT3pmc2VKZE5WN2Vna3FPQjQ2?=
 =?utf-8?B?Y1VOeGhzT0RETkExcnBZNkRWZ3puZmxIcDFvZnZOY2VmbWVXSXFTRW82cldC?=
 =?utf-8?B?L2xwb2RTNFU5RkYybHVDbVRRS3pvWE1HT210L2NkMHZHUmRLbHpkQ3V4OElT?=
 =?utf-8?B?TUY1QkFWaDBod0k5QzFoWmh6V1pGNWJwOE1nem1HUTVzNU81VU1zbVE2QmFH?=
 =?utf-8?B?TmU1blI1OU5jaVBUcjd4bnNtdmV4aDJSbjVEWk5VWEFOUTJ6VEV0R1YxRHRZ?=
 =?utf-8?B?Q2dzKzVOUXdLOUlzOHk4ZkdjOXVPdzlJVHZDQzF2dlBiVGJXKzZNS0RWZDdZ?=
 =?utf-8?B?ZkFaT0VKMEpBQzAxR3NhTGJjUjViNlZUTU1oejJrWXBzdXM4dnNGblFDcmhv?=
 =?utf-8?B?RktyRjRobTlBY01xcEd6aWI0eFlrTFdRYitjTjArOTJaTXN6cnFRdmZoeWRo?=
 =?utf-8?B?VlpTWGxRajFxMlBWVVdES3oyU01DR1g0Q0tVVlFMYy8wUHRaY2NTK29Za095?=
 =?utf-8?B?NGtpL0xOWTdCNU81ZnRqK0hRM0o5UXhNeHl3RW9YbDR1aC9WUWxFeHBXUkow?=
 =?utf-8?B?WE1QWEJtMC9iWnBtN2JHN3Y2OTdMQnVmMjlnRSt4ZUxrcDlza3pNcGZxNWVO?=
 =?utf-8?B?eUZPWG1uYzdXWEVsVzVtdThhMmEwc1JyOWh1eTFWYk9jWlpURzN4YmhZaTJu?=
 =?utf-8?B?MStjdE9Zb1h4d1hvUXgwalpadXhSQitHNm1KcjRmR3l0Tk5FYVZUTFdkZnR1?=
 =?utf-8?B?OWp1SjZ6VW5xWDB4REkxd3k5LzBnY3daTFh4dFp6RUZXa21CdDVKNmJVOE1h?=
 =?utf-8?B?LzdtSUJVY0R6VUpGRm1PS3daVWdoS29manZnUVBnRFF5ZmlMMG1QOXJhZkpR?=
 =?utf-8?B?VlQyeSsveHFuUWl2Zm1RRnFqUVVuZGtwTGpGazJIbk5paU1FVVlhRWwxdnZW?=
 =?utf-8?B?bGg4cm9laGozU2lYOHUrV1J3MTMrZzdTVUtqU3lMVDJNbmFHYi9CS0ZZSEpV?=
 =?utf-8?B?UjduQVp3N0pRS2ZkREFtUkp6OWJyeXRYMkZVN3NmK09pRVJ4NVd4M01Zb1pK?=
 =?utf-8?B?cGo4emdBSGxTNzN0ODNucFJkdUtUWk1PMktlY09LQmVUWGgrd1lKbTRYRzZT?=
 =?utf-8?B?ZldoRlBZKzNLL0RoWU1DWDRlc0NVUGg4UklpYkJkdGQvYU9STDB0UWlna3BU?=
 =?utf-8?B?Z0pRMTZDZEZqSW40dWpNcHdKa1p4TllBdnorVEhSM1ZKeDVid2h0OXNyYnpp?=
 =?utf-8?B?VjZjUENtSXJ1NXVxamRmOWxYeG1WbzUvQmFzai9hY0JPVXMrQVN6cjZjazBs?=
 =?utf-8?B?QUZrSzdpMHE3SzFXbkRONWlhUDR3RUVtWXAxdThCL1BucEtMd0dTcXY2N2hr?=
 =?utf-8?B?OUIvQ0JSZDNaMWM4aFVXQUZuM09MNERac0ZnQ0F4R1NFczByRHFzRzhoSWIx?=
 =?utf-8?B?bnhldUNzWXowaE5TZklpT3pmWWpTQ0swS3RUVkk3REtXLzk5ZDJZOGd2dVBC?=
 =?utf-8?B?VldPZnJuNzVPSHdUd2FLRUVteUpwT0MrVWlaNWdHWWk1azV3b0VtOGl1T0cy?=
 =?utf-8?B?M2c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 8xCD+76i1NP8DcS4fQXpkA4DZ/E6gCDRZbk+zF71sVP0sHPlaH7VT1slEckVMtvlsIhsXFAfWbUyMEkRydRikHbKOCWWd5dFYInMvkfx5sA3K7j4FVX8bp7d6A3q9DlOFRXWZhB5kHG9yKa1Tr7IaNE2BxT7DZlqCpzKtj+8rxGGDmcNJF7fcqxW9OzYGfSA9tVijvN+9gaZIk4DqMVK3ncxOGd/qgP1YnOKtL0FHZVvGX9b0mjlOUMhauEbKkCGGCwXx0B71f4UfyKqfmUOdPErSOx3WNHYffs9mrHoh65vLot61hRHEGQ0emVvrtwgb0Ubnh4GJfleXbFf1B+F0v9Rxvkuur8Sq1XTAq/cioWmaGo7pUiK9s2jg4IAOQdr35FSfa2pQbhlzmkM7SIDhU2FPEiKnmo+/W1MvlAqxcNRX9YzKhhRGI0lM3CuSNsDXURK2wXG2M5CSFxRYFpAD71YAqU8OvZupkRoI7a/lOrMIfyNdB/aeS2DiqRF5PlVupNNqjfg0b9UkniyqvX3klTJPwmkwZpXjU2Eg/m+FXTd3VTICoRONPp5X2T6M2+yxJb9M7FRu/L6T5N8uq6zbZP9Vbe17syOCjA++PCBa5qBD0Y0S2shKm1eZKZ/3vcy0ZgEIMFCv8yNsBKJ3GpxFQguQnW+aDEcZhL4pOkYmkZ/ypzKGSHM2sinnnAcqGwIoJz+/kldMZfyx+GyvNt9wlS1BUMDNwGG3rBoNCe16VQwR/aq1nBuqDPiyr6NZxFsxAIfzyTOmtZeFfpuWnH5TI59AViIKiDlDQkawJHxanLIXmnxeACA2WMCFIySs5ruK0oQ4KC/pn3KUdGtaIuRfNNSojRIUVagv4Dnhhv/WdQtSfWnNUmWRs3uEGlDqh2gcYiNpW0GWqfsscmbE/hX5Q==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 816de66b-dbc2-4653-d769-08db1fc80fc4
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Mar 2023 11:27:12.3410
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E1hmRlCmwYenZee6KLxmBTyRxrcCxw8MDmxzzA/bXl/LXA1aZW9NAgj0Y5pQaWp5WTNijEO+vJhjbgkLaHk90w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB5566
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-08_06,2023-03-08_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303080100
X-Proofpoint-ORIG-GUID: AwSGo2A7nLQjIBgp1mPvVUYnXHOXLqha
X-Proofpoint-GUID: AwSGo2A7nLQjIBgp1mPvVUYnXHOXLqha
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 07/03/2023 21:44, Bart Van Assche wrote:
> scsi_proc_hostdir_rm() decreases a reference counter and hence must
> only be called once per host that is removed. This change does not
> require a scsi_add_host_with_dma() change since scsi_add_host_with_dma()
> will return 0 (success) if scsi_proc_host_add() is called.
> 
> Cc: John Garry <john.g.garry@oracle.com>
> Reported-by: John Garry <john.g.garry@oracle.com>
> Reported-by: syzbot+645a4616b87a2f10e398@syzkaller.appspotmail.com
> Fixes: fc663711b944 ("scsi: core: Remove the /proc/scsi/${proc_name} directory earlier")
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Well that seemed to fix my issue, so:

Tested-by: John Garry <john.g.garry@oracle.com>

I don't really know why we ever had this call in scsi_host_dev_release() 
or what races which fc663711b944 was trying to fix.

BTW, maybe later we combine the calls to scsi_proc_host_rm() and 
scsi_proc_hostdir_rm() - they're only ever called together AFAICS.

Thanks,
John

> ---
>   drivers/scsi/hosts.c | 3 ---
>   1 file changed, 3 deletions(-)
> 
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index f7f62e56afca..9b6fbbe15d92 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -341,9 +341,6 @@ static void scsi_host_dev_release(struct device *dev)
>   	struct Scsi_Host *shost = dev_to_shost(dev);
>   	struct device *parent = dev->parent;
>   
> -	/* In case scsi_remove_host() has not been called. */
> -	scsi_proc_hostdir_rm(shost->hostt);
> -
>   	/* Wait for functions invoked through call_rcu(&scmd->rcu, ...) */
>   	rcu_barrier();
>   

