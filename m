Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43BDCC7EE25
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Jun 2023 18:55:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234532AbjFHSzU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Jun 2023 14:55:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53026 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbjFHSzT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2023 14:55:19 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2C461FDF;
        Thu,  8 Jun 2023 11:55:17 -0700 (PDT)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 358IoWG9008527;
        Thu, 8 Jun 2023 18:55:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=3htXtlnOtXrLNtMYS/+SvLFg3I/1tYhmMlE6Ekcgf4A=;
 b=FSvXyHg89mGuuHo3KCAbRqG1VXrNCz/YsTLHf+pXfJTLqytioOlA+IVM3oXp8OnKAjfN
 F2CXBbdsSOIuzKzGCUAFrTT5pUBgNNf8n9YTzOHmXXg+hMc30DY/kgmRxeC13YFZdZ5o
 lZBm5iJHE1sn3S16WDcbCD/ThujZd2V4Z321xkFIUMZzhHr8DX0e5iZ/lc0fMRlVaP+0
 KVlue2pm67Tx2Tua2rRuZKeF1k0RW072/EeWPRyjj0h82NmnWKIqvRV8sXNYxJ1QcBxk
 X5/8n4lpm9kFiUDTPo1nK2jCQTW/dgou9rrJtpk+BsKrgKqi/oPH3cxfUd81o8vAAO+q lA== 
Received: from iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta02.appoci.oracle.com [147.154.18.20])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r2a6ucwf2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 18:55:02 +0000
Received: from pps.filterd (iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 358H0wvj010487;
        Thu, 8 Jun 2023 18:55:01 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by iadpaimrmta02.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r2a6s9j63-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 08 Jun 2023 18:55:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GPnx2PlJcFr3h2MfZCtsG9Y6WBwZ1Q1+6TtrZuOQoO1wssW5ztQg1qACw2pyWcEsLuPujaGrIW1L+IEpcOXuFHO5mioZMTdQxEJxl6+Oag2ZogfgZeaVgTwswe/uS9r0uzplLKWcVdxTXoaC3RHu+kA8EUPWfDtiG0kSfhLUFKZSQMEDHNq64LYA5uGZnfggDxOQmUpEZBVKazLZxllgSo/6SIBCWpWZKQuq7xrefIOL6KexPFfKjZsTcu1RN834g+52ZGF9SVyVWIX6h2HvMujF4FQHmDU48QUK6IG5WD+lvNlnykVH3YH0kp7sgWlnUi7yFf/2iTtNHVg1VsHY5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3htXtlnOtXrLNtMYS/+SvLFg3I/1tYhmMlE6Ekcgf4A=;
 b=E7uom9ykiHx6Szf2JBCmS3hixgst1KZaojxMDhC9FP5ql5yIH/FxCqpqbZegBV6jcKvBFgNSBeU7ZsvTPx6yQzRFEbPOlUqv+Pt7ckmewmUWI3Mk8HrYfz0UsKCIpx7eR9nMgNnvlV+wr+9yt99+HRxQS7QciNuTU4ylio+vvnkkub3nQK67W9zhkvVLc8VZUog8SXWoVC9OegLa2TeWIhX9tS2Vz6JKBEz+XcJmGMmfZAt5FQJuYuq7Sp8YsvCuqo6BOi0WXNlOVfYUpttZiMFalZCdVu08REzdfy+TE33vAEUBgEz0u1fLTJVhcw3WxG/U4x6Y8iuJpukrB/sZ3g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3htXtlnOtXrLNtMYS/+SvLFg3I/1tYhmMlE6Ekcgf4A=;
 b=cCPaJMHtq2ppQj2fINGZdGv0UGfjt8dyJgqEWOgAHgiyNqsXDG8nllVc0uTxiWP8LIf74+O+HM5cTU1UtbydpUiDM/VFuoxPwtSOWJvT4hu4/+9iZJZzLlz9BnLFJDs+ejJGXWVcYOvTg/ftnsm9TVx+omu/5LzXBKilSOn/jz4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH2PR10MB4229.namprd10.prod.outlook.com (2603:10b6:610:7a::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 8 Jun
 2023 18:54:59 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.030; Thu, 8 Jun 2023
 18:54:59 +0000
Message-ID: <dcef340d-0b43-42d3-0e1c-a96cd90283d3@oracle.com>
Date:   Thu, 8 Jun 2023 13:54:57 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v3 4/8] scsi: call scsi_stop_queue() without state_mutex
 held
To:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>, Martin Wilck <mwilck@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Ming Lei <ming.lei@redhat.com>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
References: <20230607182249.22623-1-mwilck@suse.com>
 <20230607182249.22623-5-mwilck@suse.com>
 <3b8b13bf-a458-827a-b916-07d7eee8ae00@acm.org>
 <50cb1a5bd501721d7c816b1ca8bf560daa8e3cc9.camel@suse.com>
 <ff669f59e3c42e5dec4920d705e2b8748ad600d5.camel@suse.com>
 <20230608054444.GB11554@lst.de>
 <5be7eebb-f734-1a0a-9f97-1b3534bc26ac@acm.org>
Content-Language: en-US
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <5be7eebb-f734-1a0a-9f97-1b3534bc26ac@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0130.namprd02.prod.outlook.com
 (2603:10b6:5:1b4::32) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH2PR10MB4229:EE_
X-MS-Office365-Filtering-Correlation-Id: 0f83c91a-32cf-4d63-3750-08db6851dbd0
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: LnW6inMlbYkp9ztYKymAgtSo6uVdWXtYp/y0U9qOaKzs6kLBL9v4NACjpPE5e8xRP6w7xFzQlUhWqkpSGtwsa6Dr+96zhX0W9qmwHNPyGO+A7Ae9l7n5RltQUUDHrev7hKE5hGJibl5I0bbkt2VKEEAhAgqKoFFsYk7Bp4Vh/LMtRczQkMWGpMTVDonwL3EcfG5boriiyJe1IjC5rqaj8I29xGUCWCAz/bIW6rtn+vMFI0Kl9ELBtRP7RTPX/p7RqtC03ApVkuRXvjfENYotOkhwyDxZZSHh9T9u7Hjke9hx58fxdIydFueTeft/VYVOIdnundaAJEXRgXRtZJae79Z5mj9OckCoCQtrcuVks42rB/5q4Kd2OZaBUQofpIZ8X/14bdpQx0EsUNgmusvGfXw4at8P+P3QMPgFv/cNB/uWtv4oDqcTHavgyh2RZ1+hLvKlfUQgf5goQX1hAlOeNspplgA7xGS2dz3no+YJddunYGv/M/AgympSSBtx4+l2FoLxssQDsUsR0ERL2Wk5LCvjfPdIcuZfI/6Aj8znGSgBko6GaoeDEpvUrR2UW/zxZ7vNwQsOFFCwUhkY7OaGjwov/IbDKGZB8lYxT5qUFslQXr67HVt7tiU7bWFMyblilr5IX6b9gt39DxJGZ68eAw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(346002)(396003)(376002)(39860400002)(451199021)(54906003)(110136005)(478600001)(8936002)(8676002)(66556008)(36756003)(31696002)(5660300002)(2906002)(86362001)(4326008)(66476007)(66946007)(316002)(6506007)(2616005)(38100700002)(41300700001)(6512007)(53546011)(26005)(83380400001)(186003)(6486002)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?elh1ZzUxOXVEMkhseCtxTHhZK0Jzc1gxUUFwbkdWWWFqYzdBUEMxMHVFK2dk?=
 =?utf-8?B?UDJ1K1VzMDFZSE9McXdiaXlVa3NzSmxSYVN5ZDc1dkxKUkM1UmtFLzdPcjVC?=
 =?utf-8?B?aXIwbDA2aTZqd3E2QmlaMnhkRmsrYWh4SHE1bkQ1KzB1MVpPK1crWXpJSWF5?=
 =?utf-8?B?b09oTitpcUdETVVmLzRhY2MzVmVKNzBaa1VGSVI5bUt4QWlYWStjN0FQR0FS?=
 =?utf-8?B?Zm5CMHdsOXRYeEJIVFpTY2FhaUhNa3RZZDl5S0Q5ZXMzdHB3bzZMU3hleS9x?=
 =?utf-8?B?Vm5uanpXaGw2dlNUR2tCeEd3UWgzdDA1M0xEamZ1MGs5UFp3MDYxVW1qc09O?=
 =?utf-8?B?NHhFUHJOdEUxb3Fxam9xRWE2TC9UcmgzS0pzSEkyWVRrMUNRd3BYMk0zRFUx?=
 =?utf-8?B?MjdWbGtNd3hkaWI5MURxOHJmanYrR0dadGFFc0p0WDJ0cThSb1VhNHJPZnhX?=
 =?utf-8?B?a3IwT294SXJDMEkraDhFK1pMeWNvNmFLbGQ5dHU4b21BeTBqR1hpZGptbGxz?=
 =?utf-8?B?cDhmRW9FSkRyM0tYdldDakVSakdkbEZKRUhGY0kvanZrb3hMbXc2UVUwdnJE?=
 =?utf-8?B?dGlUdXBza21ub3pvbXFId3Y2cThMNzFLSmJpdS9YTnVWeTZtUkttQWkwTVR0?=
 =?utf-8?B?M0MzVGp4U2cyaFRFbW9VSmVNZ1UrelZvd0ZJWldOZkVCRFhvYWRnTVB6bjRU?=
 =?utf-8?B?NjlzWU5JQkRoR1ZMd2ZONVFvNWpFRVVDcy9HdXBMTFl3OGsxWU9JVnFqbGwz?=
 =?utf-8?B?WW5XOFJTeE1Ec1hGN0luQkhuZ2dWN3d2cnM1VXNzNm5BTllaeVF1Q1c3L1M3?=
 =?utf-8?B?bHhONG11RTU5UUdFeElPN1NTa1FIUC9RUUZVZHAyUnF2Y09wR0JYYmY2czhw?=
 =?utf-8?B?ZGFJZzRJNkh2K1lCa1ZZbzl2MDN1RytqaUl2L0pDMUYwZ2NEcGR1TDF3K0dR?=
 =?utf-8?B?RWtGVjlQZlNFMldicGRELzRIL1Y5Ly9wblJiM2xIRHhrWS9FSHlrTVhrK2pT?=
 =?utf-8?B?SEN2dlI0R3pkRUpoQStlTXpmc2pDeHM3Q1ZhSndQT0FpYjFvUCtNT2JTTkxY?=
 =?utf-8?B?Q3BVZm1rTkFXZDVESzIreUx2WTRQZHZkMU9mdVljcnJpbXRCZjQ5c2s1NTJW?=
 =?utf-8?B?RzhCakpDWWd4OGhIcGwva0hLZllBaHpDODExaFFOS1QxMTVhMCs5UzNOTitK?=
 =?utf-8?B?ZmFaYnNqRjhoaXZGekpwZVpOY2NaaXdPZlNMWjkxNUY0TFNMTk85ZGVDMW16?=
 =?utf-8?B?d2lyZTlHaDEyUit6MmpDcjNLNHovR1NpcU1weGRKVUh2WkdIL1FTeFdNeG9r?=
 =?utf-8?B?OEZpekRhdzJQaEQxbXZmT1JuTTlGNDFuOXdnVzRqRU01blhtRXJXVmE4QTVB?=
 =?utf-8?B?NnZBOVZJbGJjMWZOaVVwM2F1OTJIUDk5Um5TUnV6ekZKcGk1eFpTVGxVU2hr?=
 =?utf-8?B?d25MYTJuZm9TRnVlTktNcTBPQTVHYjJyZXZqWGxRMU5TUEwxN0RFWTBJZFpW?=
 =?utf-8?B?bERxcCtzdTZ0elV2cHRsWTNIdi9XRStiZEZHK2pzZUVDdmx3QU5mSGd1M0VW?=
 =?utf-8?B?Qm5XYUpxT0owVUFRSjhEejlFTVUxV1E2Kzc1MkRsN0Z1UklIRUdieEwzK3BE?=
 =?utf-8?B?NHl6SVlHRGxKaCtycDZOZzVTRGlZNU5IY0FsaGdJczQ3ZUhuWmtoUjZjMDA1?=
 =?utf-8?B?anJxS0Z4Nzh3dTlzUXpSdzNocXhQNm05TVUzVXVGcXhqNnZJZkk0dEVQREM1?=
 =?utf-8?B?T1FHOHZleWlia0I1NThsUmd5dGF2MHBmTmV1c2ZnOStQZDZzNWhqZng5d0tY?=
 =?utf-8?B?c05GVkQxQlpGa2ptcG9tb0JBL1EyM3p6aWNBRXh5Q3l4bXBGOW5qaDZMUGdL?=
 =?utf-8?B?WjNaQ0J6M21FWnJ6ck5CL2luMXl3ODVFb1QyQ0RCQWdDT0NmMjl6YXA4S2h0?=
 =?utf-8?B?bWZ2MHFoU3gweVhjVzZLL29lck5TVDh5ekN6SmZtR043d0tKajE2eFZYUGhp?=
 =?utf-8?B?SUFuYjVVaUx6S0NReG4xQXlGYzhVV0ZFT1RpNnpHamlWdDNFazRUNU9JcHI1?=
 =?utf-8?B?WXZNeWg0ZEpoZkYyMUU4TktsVE8yaFdTY1pGZVU1WUFzRnJQVWt3UmdCb2wz?=
 =?utf-8?B?NUg4NG1lZnFSWVdUUWtHbFYraTZGRlRDS2Q3MFlSWThoMFpveEE1aHVjUSta?=
 =?utf-8?B?a3c9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?SnlRZEkvVXJJaVE3YWNsckM5cXhzQWpkd0hwUWV2YmUrSTNBRUc3aTVPOWhv?=
 =?utf-8?B?YXR6K0d4MzIrdTJodllOb2ZTSEVYcFNQVHBWdmNRTlFhVEdNRStPMXFuTmZx?=
 =?utf-8?B?RHRHUTVrRWtOcDQ3aitvQ2VYL0VMS0txOWU1czZrMWU1VjkwT0o5QjB4VlMr?=
 =?utf-8?B?d2VIa3pXcHV6L29IVlBQOHhnclIvdm44YjF2TFhHekpxTTNMTnBKL1p1R0tZ?=
 =?utf-8?B?clpjUmwrZlgwSlRzNldYc0RGSWhmSkdxMERiTTlwUEwzMzByT2twUzlWb1p1?=
 =?utf-8?B?cndBekpxSVo5blhyZjZQclpFYkZZZUxnRjEvTzNtVWhXK05jbHNoYnoxUUNi?=
 =?utf-8?B?OGJDSlZaQmttM01Td3pEUUpiNWZlVEVFTHpMWmFwMk1ETERCNDBmd0p0K1FD?=
 =?utf-8?B?UWVPaUdLS1IzVW1rUHBUMGdTTVhxZXZsdnpiamdmSzJOZ2tWRVZKV1p4b2dE?=
 =?utf-8?B?cnRabG00UE50MTE0NWJ5Rys5YmoyUWhZSmZoUWIzVWY3NTBDS1pUdWtoVGpk?=
 =?utf-8?B?Sy9HZmFaVUNhTVVKVy82cHFyUmUwR0xiMW1ib0NzdkFtdkphbnNuUzFqZUxz?=
 =?utf-8?B?ZVJtOXZTYmRFanA4eFRXQ3dqY3NCaU5HVHdCWmxFWTdTcFU0YXphbG1ZKzNF?=
 =?utf-8?B?VzYzM3JVTytXaEU3dmhEOFZTQVNtMGIyTWVkWTBzTXNHdDl1ODdoM1hubFNQ?=
 =?utf-8?B?eTBsYWoyR3dEMmNzYTZ1VE5vaFRJS3B1bDV2K0dJdXlsMHBOeUhFSVR4bE05?=
 =?utf-8?B?bFJCTHU3UXNaek1ZTGZwUlF3dm1jZ2FLRDBDSCtCMEExNEtpOCtQR0pXZ1pB?=
 =?utf-8?B?TStLSFU4TFhkWmxiamR5dTRlYmsrb0U3dVpCZ0lZalQ3bnMzMTJ0TGF5dDIw?=
 =?utf-8?B?ckVHWDhFR1dBWHMweE5mdEtYenhPYldKcEEwdGdPN2U4YWZiSnNnL3lQZ1lO?=
 =?utf-8?B?aGtnWEJKd09PN241cjg0M2JXckNpNEN4Nkd4K3hTNkVaTStTV0JuTG5RMVl4?=
 =?utf-8?B?MHB1R1RQaTQ3SzlKWllMQ1lCTHhWUVhtTVRIT2JlNWlrbG1qRnRhZWxXSEw3?=
 =?utf-8?B?WXp4ZlZvTFBveWtvcjNadkxDOTh1V05ma1VueDE0L21lLzdsdTdTK1h5c0Rv?=
 =?utf-8?B?V0hHbG1UbnJiSFVlRzVoUjU2cStIaEI3NGFJRjJMcUpoUjlLSzV5OEpXZkVV?=
 =?utf-8?B?NFlBVGdxMUZ1aUZqeFVCQmNFK0ZJVlNGQzNjeERlM0dSYlBTdk9HZmlSQUMw?=
 =?utf-8?B?UnNwNlM2RHlCQ1A1cUV1bmNFZ1Rld2UrM0hCc3VpSTlPam1wZz09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0f83c91a-32cf-4d63-3750-08db6851dbd0
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 Jun 2023 18:54:59.4998
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: KyHiiNev2OPMvbPOD1p0YnuC6wnVLVNWTEudJVtY3j7Q7ixxJ3awhD/BNompjF6zUZH8uxfF94Ila6lis2TxpjMKac/9PcuCV8ihOwQi1lM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR10MB4229
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.573,FMLib:17.11.176.26
 definitions=2023-06-08_14,2023-06-08_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 phishscore=0 mlxlogscore=846 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306080163
X-Proofpoint-GUID: upyv-U22E3FlmvB1AiWNcf_cNfqyYwNw
X-Proofpoint-ORIG-GUID: upyv-U22E3FlmvB1AiWNcf_cNfqyYwNw
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/23 9:12 AM, Bart Van Assche wrote:
> On 6/7/23 22:44, Christoph Hellwig wrote:
>>>> Thanks. This wasn't obvious to me from the current code. I'll add a
>>>> comment in the next version.
>>>
>>> The crucial question is now, is it sufficient to call
>>> blk_mq_quiesce_queue_nowait() under the mutex, or does the call to
>>> blk_mq_wait_quiesce_done() have to be under the mutex, too?
>>> The latter would actually kill off our attempt to fix the delay
>>> in fc_remote_port_delete() that was caused by repeated
>>> synchronize_rcu() calls.
>>>
>>> But if I understand you correctly, moving the wait out of the mutex
>>> should be ok. I'll update the series accordingly.
>>
>> I can't think of a reason we'd want to lock over the wait, but Bart
>> knows this code way better than I do.
> 
> Unless deep changes would be made in the block layer blk_mq_quiesce_queue_nowait() and/or blk_mq_wait_quiesce_done() functions, moving blk_mq_wait_quiesce_done() outside the critical section seems fine to me.

If it helps, I tested with iscsi and the mutex changes discussed above
and it worked ok for me.

Also thanks for fixing this Martin.
