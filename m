Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4E4E3C433B4
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1777E61103
	for <linux-scsi@archiver.kernel.org>; Fri,  2 Apr 2021 03:54:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbhDBDys (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 23:54:48 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:45482 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234161AbhDBDyl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 23:54:41 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323nvhp136711;
        Fri, 2 Apr 2021 03:54:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=t8oV8V56kaIfVcEaql06tNmJ08F0mwUdeVnEfS6KAZ4=;
 b=KJucUbQ2VYPVPu4XNB/2P2Rd1aCxn+tqi+32mfarL3fN1zsr1kImZWbS6210p5L5WZb3
 SJ7WpPryta+nNLN9rwm/9PH4FyjsL4tDrJ8suNPR/LP+B9fIs/y9Hdh7AZRZhGay91gw
 Qbz5DqxqgD33ogrzwPnF3Eu5gG+ZuGZAGIcwh2OIp6CW1kAJWDhWQrDlkwUOesOLLU5A
 O3yStmjT+t2g+ATkeGSm3lkV1VmFA7I7OUU7QIszyFpEfaoR+dG44u5WMgLM4xrpiQwV
 cy45JTk2NibhHybvHBlSMTOobqW9b98k2qYeqQLfR6nLYiMn36EKKqsOVlO4XGSZh92j dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2120.oracle.com with ESMTP id 37n2a03p5d-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1323pdIt101592;
        Fri, 2 Apr 2021 03:54:30 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3030.oracle.com with ESMTP id 37n2atmxdq-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 02 Apr 2021 03:54:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Vs71pcFXsUJm3mqwr3cEXn4E3SiETv01uZDzDSVbh9+H0ygJoWc/e+nItmhRm7yk0dDGpslJLBY5QTI/nUNKqssPch2gZRMy6BiktlXm01lcW7FGqwE8a9gNFqBnlx0FdZNS5s2OTcUwe/puVKk+on6OoOiyf7Ssxmkj6HCTeqGEiRC+SbIUnzH3YsJCa7nLHP2OsP/tNLYgW/nkcIXaxWImCwoPZ40Yium+AZxde+RlOn1wOZM8+JAciRGrdbKqVFStCbtG/bUBnVWolzHgZ/1datiJxuOcuZUR107hU+wLufTLJH4BFcnka4biBbe/YRLnxIMK0egiPt1ieVTwjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8oV8V56kaIfVcEaql06tNmJ08F0mwUdeVnEfS6KAZ4=;
 b=eKW6lfPzW1bHDxevTQVp9ZJDI+5tZCJXRF9dzLl0PSrtwau5RTz/woTzu7bzM44h0XKOqhQHIAX2E81FH/bKkjy/rC7rxG/Kxl+fBbq2Ixl5Io9WQmQ/KvSQNS4oafQ6UaSWnRDDD28dUA2GZczayjnRRuTjzzTddeXW/wNuwT2nBqYpy3gtzoECWb4RlvNp7QKGvvAcgwTh/Wl4TTtLcaqjK0iA8hARQ+Fa0OJ7CS2j6VIT5tpG3rB5xYdPlBYT88OeglT6t+tPLtmDI8GjE0U5M71+vdK/MPzq6JlUYux60PUoOPakgUL8Fjbu7UVzzyppGQglhIU/o6CJ0/D/bQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=t8oV8V56kaIfVcEaql06tNmJ08F0mwUdeVnEfS6KAZ4=;
 b=OzkFmxIYzMVr9nIAwWDudycIWksqZc1u231T1PrpezpKnzGcFKcMlLkvA8U94LNk6pC6J1gwecYWfg2cDoI5N0s33BtUqgS9RlExWUy+aYWrzJom3uRSzRecHjA08ndfX7yVwjScK6SxyOL/qcxWXRw3+/GTuYVNpQELWu+MDd8=
Authentication-Results: huawei.com; dkim=none (message not signed)
 header.d=none;huawei.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4711.namprd10.prod.outlook.com (2603:10b6:510:3c::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.29; Fri, 2 Apr
 2021 03:54:29 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::dc39:c9fa:7365:8c8e%5]) with mapi id 15.20.3999.029; Fri, 2 Apr 2021
 03:54:29 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Shixin Liu <liushixin2@huawei.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Hannes Reinecke <hare@kernel.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH -next 2/2] scsi: myrs: Make symbols DAC960_{GEM/BA/LP}_privdata static
Date:   Thu,  1 Apr 2021 23:54:17 -0400
Message-Id: <161733541352.7418.15540292629349015282.b4-ty@oracle.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210327073157.1786772-1-liushixin2@huawei.com>
References: <20210327073157.1786772-1-liushixin2@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0007.namprd10.prod.outlook.com
 (2603:10b6:806:a7::12) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0007.namprd10.prod.outlook.com (2603:10b6:806:a7::12) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3999.27 via Frontend Transport; Fri, 2 Apr 2021 03:54:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 08b8cf61-0ab6-43ee-b35d-08d8f58b046b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4711:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB47119F8E97832EEFDB32B6A28E7A9@PH0PR10MB4711.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:4502;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: gpQCAvDHk/PX55DRWN9vF+sMEymt4hGmYb5LQmrUUCZMjmYrOTj0ODOwJoYkFATvuDpZu9HirioVU8lfimic1T8+goLl4iHwjbo9I1meQZ0OwzuerzWBcDzZ7kGmutBaJYrZQAKWalj4PjrHu3KBaMZQA7nUlkuFmFxGhTPjiUeWZhG8hEapBOSNzbXzDSaJhXhkWyMHmDImutI51QvD/zaMUVAk+oBc00Tmq7W1aibxT4nYdSzozkQZXDuVv8ItaSdBdoJgGZFRP04DSzDh9YznXx09s4KgU2V64+YDvZtBQ0QxPkosMvfQEQmBX1v0cMaTB20f3VmrJv2yCn614rsdIQtbdjP+AGzZq3On7Kjw/I6oo4wfp3wTRVbdW155yW1CMgsqkI2DONgNQKarWIAnQVTWL+03tqgM07cmUiluKfdtgFnTQwTVlK1QM0ThQfNVDnQmkWdFhZqbO/ibZyPG4CWY7QLmUKyvVu3mgJsnCXAZrBvT2GxmcrKFXLr9zkN79mbrwgYjk53IWN9FVlzBOME8jJ1HF4p6ES6yA2dA8UFFvXJ8IzW+cnZnmIcqcKdAYKToSog9s2KSMaPV52Y6f9XqX+r62V+xdkciIGxOwCBr3DMwlB88skn2tGB6qKHMECOroWi0XYGEgjJA1pENUUfa05rIOLSPuiYDj3LVVKFx04/+8szKOKG8X99PhwxAaonxDYn1xn44WmMPpEoMtMXZYmtRtpgqSc1zjh4=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(39860400002)(396003)(376002)(136003)(38100700001)(4326008)(316002)(5660300002)(478600001)(966005)(86362001)(66946007)(66556008)(66476007)(186003)(956004)(110136005)(103116003)(8676002)(6666004)(8936002)(6486002)(36756003)(2906002)(4744005)(7696005)(52116002)(2616005)(16526019)(26005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?MzA2UFhJZW5TNzJPRDduQnkzRjA3dC9lcVFkSTNseUdUeVExcnJoNm9EbVVQ?=
 =?utf-8?B?WkxwcFpoSmw3a3NCTkxFZUdmelRTVmRVbzlneHl6bGRLeW5FRWRwemxNOG1n?=
 =?utf-8?B?Rmw3WXZ2NVg1ejZ3Y1NVckZvNStNekpUL0s0M2h5ZjFudVFUQm16aWlvb3NU?=
 =?utf-8?B?elpObTcyZW5OSFg2UGRWM0VuNGdGS0xVY1hkYU12ZmdnSWY2L29IQ2xCbUZK?=
 =?utf-8?B?V1JuQjI3ZURPVDdNenJjQ2hsbHl1Y01kSXF6bFNFRUJndUM0ZDV4U0VLdm5U?=
 =?utf-8?B?TUdCWDkyemRHNjlocC9aeklsbWhRaVpac0w3S1FEZXFQWmJzWHdTVVhlSjNi?=
 =?utf-8?B?eHlVcTc0bjNYNFhOb05YQ3FzNFBMeUVBNktuMjBMYU5nMzBndDBjVjVHemV6?=
 =?utf-8?B?YjhYRi8zUUtnZXFmUnVHNEEwU2piTzlVRUQ0UFladFFmTXV1SHd0Zk9oUlVu?=
 =?utf-8?B?WFlWaitwUEY5alEwUitlU09SV1FvSXVwZlBFaXdVSjI4TmVXMnFlSlFNUEJP?=
 =?utf-8?B?SjZjamVjYWEzMnFaaTVPUnZqNXE5cEVHOHZMMm1qQnRTTTlVeDBnY0ovWGhs?=
 =?utf-8?B?a2QyL1ZTdTFETU1laHA1a3BNVncyVk9PckgzYU9sTGpzdGZkdDZyZTZ1VWNF?=
 =?utf-8?B?Z2trZU9uNVd4Z2dCNktmRCtBeTg5UFJjOEJVcGN4MmVldzdSMWxVNVdhQi92?=
 =?utf-8?B?L2hjMHVLUXorZk5iOVd0VHQxOHBVc3FJM0MxeUFGcEhDSS9tMWNEbk5CV21u?=
 =?utf-8?B?b2hPYm42U3lXa1pRZ1hjekwzZ0REZWdNTjBSeFJOdnFJdkdhVDVPaCtLY3l1?=
 =?utf-8?B?WDdpWFN5UHpjUzNvYUNpd0hJSk14U0tUd3pxT3hvbWhMa2lHOWtWUnNvd2lp?=
 =?utf-8?B?c25TQVdIUzMyQ3RTTjRjSU5TYU5ieWQxUllkbjBpemtVdmV0cEhwME9rUXUw?=
 =?utf-8?B?VHJNNEtvWk54ZDBlNDBheHpmSTJnWFA1TEVSc3Q4bUh6NHplMVZPUkZxNm4v?=
 =?utf-8?B?RTllWXdvRHZOeWxXT0RUMTJEcmxDVUcrM1d0TUJXb2RSWTJXZGE3TGdNUWZQ?=
 =?utf-8?B?bnlrUUFMRlozeXdiYnFnZTdmRUQzbnJMZDd6aUlRZ05jUStkREhKSHU0OEFW?=
 =?utf-8?B?VTVibW8rb0ZjT01ZbXYzcTRzNEZlVjRVVTRWVTQwOExpVnNrMEZycGhLWEph?=
 =?utf-8?B?Qk9oUEM0Ny8za2RkSFlCZXkzdHVISVZhWEd1YzlhT3lSUUZIYWZsemEzMXIx?=
 =?utf-8?B?UnZnZEZ3QTNTMnloSXpyYk9NU2MwL2FNNUhITkM1Y0RMT2tOeExmbHdtVzJy?=
 =?utf-8?B?QW0rTlV3cER5SlNFWXdrUnhkeUUySTdteW51WXNVRWV3WnJhazRRaFhlZ2Jq?=
 =?utf-8?B?djZXOWlPQmlObVRtdmxwRUY3WjdFc1oreDBrMVhadG9lZHM0bXV6NTdHWklZ?=
 =?utf-8?B?eXU3MmcrTGdJK0FuT3AzK0RrOS9ZRStTMEt1YXdmRmtlRXhJdUwyVDdNdTgy?=
 =?utf-8?B?WXZFUkxOVTVjbUpDNUJqUGhGUzhlWGxkcFZHVFJ0dmw5Ny9mUEJHaGZRQmF5?=
 =?utf-8?B?V0dkNTlFRlRGM05xVUVabmhPZnMwakIvejc0Q1dCM1hxUUJxOEVuSG94WjdX?=
 =?utf-8?B?ak1XWUJ2eWhOK0FucitBbnp3cVRYb2R0eDdXYm9yUlhKYk5zZXhKWGJzcGcx?=
 =?utf-8?B?RTdkRWtNQWVXVjhaSE4zb1BKWVlTM1YvemJaQmNDeHBSc1Bsa2wzb2hyMUUv?=
 =?utf-8?Q?YQVzKNjX99sEOe7YOA4b8/z9dbFZVWHT6ZtGP8c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 08b8cf61-0ab6-43ee-b35d-08d8f58b046b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Apr 2021 03:54:29.7894
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: E4Ja1zWqSap+8xAkmg9EK5UfQLoNBkznkGaA3HUHqQ5Ac8CUSTZvxaJg1El7dKkKKxd3eLECD4cd+WDgXlRvmccQImCJLMHjrtXHDQBftbE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4711
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 phishscore=0 spamscore=0
 mlxscore=0 mlxlogscore=999 bulkscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
X-Proofpoint-GUID: qQrqMw1b4tJanGvanROkQez3xVEhoTSC
X-Proofpoint-ORIG-GUID: qQrqMw1b4tJanGvanROkQez3xVEhoTSC
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9941 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 adultscore=0
 clxscore=1015 mlxlogscore=999 phishscore=0 bulkscore=0 priorityscore=1501
 spamscore=0 malwarescore=0 mlxscore=0 lowpriorityscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2103310000
 definitions=main-2104020026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 27 Mar 2021 15:31:57 +0800, Shixin Liu wrote:

> This symbol is not used outside of myrs.c, so we can marks it static.

Applied to 5.13/scsi-queue, thanks!

[2/2] scsi: myrs: Make symbols DAC960_{GEM/BA/LP}_privdata static
      https://git.kernel.org/mkp/scsi/c/e27f3c88e250

-- 
Martin K. Petersen	Oracle Linux Engineering
