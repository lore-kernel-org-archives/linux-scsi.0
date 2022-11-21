Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5B6F4C433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Nov 2022 12:51:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiKUMvf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Nov 2022 07:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiKUMvd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Nov 2022 07:51:33 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 93F41B6B07
        for <linux-scsi@vger.kernel.org>; Mon, 21 Nov 2022 04:51:32 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 2ALCAp2j032156;
        Mon, 21 Nov 2022 12:51:26 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=sXT5rlV7lyG5BmA1RqE/mQeC6XDsmrQn4nylpNLPKLE=;
 b=PZKJyMOZjwzL73o9TeDL7pYLq897Gc5Nr1+udQIo3FaW3k21Dd9n6Db+KEh34ilbP3iS
 OkAL/LhuxXWY7idIbqHBkokVtLsmgrMyREWaYHh/8Ca8XjtJoiIpD1bMGB1HJaq90pM0
 m2LZVw+g47JaIyx+0uUiO0Fstft6/xTJjp/nacREUTmDK84kRpV6B/FRVaTCExI9ouZQ
 ZnGDsjmoIingIY7kdOGElJ1d7fQNmBzDFxi2bxKbvWhhC0sAtk7MTL/Pnu3dJ89iWqfc
 tFT2FVlFYDPPUhfCeMBFXdDEDDxih2ywa9lYLTnJbsJxWQjTIxX8oz5bzzp5GYuHvx9H eQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3kxrfav2yy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 12:51:26 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 2ALBjLcp039490;
        Mon, 21 Nov 2022 12:51:25 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2176.outbound.protection.outlook.com [104.47.59.176])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3kxnk9xpwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 21 Nov 2022 12:51:25 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cm6sNgyLEoz9WtkK9jUQfRwg25pEZ8K3OYxfG3M1jahC2OvwQUSivcUAGZSBs5Y9wYKc9L2xXEUBAi9nzQMAgYoF9FBkQgNlmBtLXFdHwNgcQFMY+9rR5yLJRR7M4Rr5GDr6xtR6jDPmhGPmqIcS6RdvSo3Q2rNtPc5i+BXryqNtyWFxvyQ+T+4XDs5eUMFmrVzPgyxFUOghUW6IqgZFgnuZJY+1xjWBrYKSD5laTA5kV6w/LTk7TpzM6bdk4ADbYn4ge4weNVemR+2u6oQg6ytasa/U6wBcZzve2rRWEzOIB26SYOzL3fbrRkMeJO32/KAXBgwqb9y+KkHiR8lU7Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=sXT5rlV7lyG5BmA1RqE/mQeC6XDsmrQn4nylpNLPKLE=;
 b=OYg0iz12TIIxMh2WOyWOubePkeHtDrsXfn7z8hs8XCJHfersE4E/114eGWbuKZX/04buODzVg4LJZJd4b+3xBzeUqFfF1BwGtqNTkYC7dyuvdnhPkqfDtDokPiP8GA5DCrSZ3N/6BQdz3t1Mq13cXEJfXLG6NNHHa9PQ3pE8RUvyJXDEQCoLOPtfn/abg10bFK62j06s6DJqbMLvapb4g8MbcWyMOHVZELFAH/ipB2vxqm/Wy8EPwXngcGlSjK7tBBaemI0A07168CMf4u+V8Or2n3/eai6WL3z9tIxaf7IIYfojnQ8GLkI9D59IoRuoZ52+LkpGocP6pimsDX493Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=sXT5rlV7lyG5BmA1RqE/mQeC6XDsmrQn4nylpNLPKLE=;
 b=EULcSxmPSfLS6ntUnGP0e7NdMFaXjN0q87hJNa2u56Ncd/IjMDKc0gdbbXH/iY9CInZZjHh8ouLDpwk+9xBt/vLbtgIaViOvS4sWzTQNwgD/E4y0xc/PM0MU9nOQ76JkMOCI9ei7bKDOKq/++xCU6RNrdmW6tdqGHgol1FcfT/0=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MN0PR10MB5957.namprd10.prod.outlook.com (2603:10b6:208:3cf::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5791.25; Mon, 21 Nov
 2022 12:51:24 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::5984:a376:6e91:ac0d%9]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 12:51:23 +0000
Message-ID: <74ae1b37-ddf6-219a-a5a9-9105871d0023@oracle.com>
Date:   Mon, 21 Nov 2022 12:51:18 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] scsi: scsi_transport_sas: fix error handling in
 sas_rphy_add()
To:     Yang Yingliang <yangyingliang@huawei.com>, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Cc:     martin.petersen@oracle.com
References: <20221111144433.2421680-1-yangyingliang@huawei.com>
 <4f1992b1a90aa9e5d143ac47eadae508a20b9f9c.camel@linux.ibm.com>
 <45fb08d9-ebda-4c8e-23cc-49f79e5ffde8@huawei.com>
 <9ff2a73c-bd45-c19e-3624-8816c5bac9ab@oracle.com>
 <d6640c5d-c08c-407a-3e32-8a5bd37bd01b@huawei.com>
Content-Language: en-US
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <d6640c5d-c08c-407a-3e32-8a5bd37bd01b@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: LO2P265CA0195.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:9e::15) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MN0PR10MB5957:EE_
X-MS-Office365-Filtering-Correlation-Id: 86a3e375-89f9-4c09-3d8a-08dacbbf1875
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kFylWjgMYrN5xXUGJZHCnVJr/HvoBlztPTJ3DlBvqS8u47GS+w1O2Tti2bMODf3u/+FVWwGUsZTc046NpI7MxOI0fojdMxho8TvUa5Xt9xS5XVaDH8yb0QDOWmG26EMEB3AVLCeA/AGqLhc5m/g03DS4j+IsUBDe06Hh1vOunazFRETimJPlzq6Fk5mumV0msT6pWkXrcZ8d68iWhX15PLAAC/PaaMZy5IXJNDt9bHv5OuUBTzrQ7IaDYpdRJ1OzhsbAWAvSFEq3t5bNyAwe5xnk0HO6nII6uSNL6gbCmb3V6wS3420cggJtqPSiO0z2qEXTimt+VX277Y0vy52RI4tXxV5JU9KomUSVgoc2R7xAzH3YAwk3OXVVM+I1ATCYRFA4YCGk5EpJU6Z/H6EWSV+smuY31jOFh4E++OUysnAdfl1pim1XUi7kddZHy2yuLkFv/BY3ycyHpK5SjscKujds11fOPsV5zQyr5smTfHbBucXFLk88H07vLFuM8pG4g5NVT/tX/DmTmk5lkW4MiUkfZi0A23mr4V1yGQiXCbB5rh2JLedmOe8yHPUkw4M1TtmdnFWOpiDv4MqGHIv3uYQYgVoWUXghiVIk56APfoKaGRgl+EAOWXEeT2u6SHEhV7Wh7UyipsGfZiuJFNa6hYs7deYsThd+dqKnIWhgGOJYnomXlQhC8YOYRsm3z6wz+/LzeAF26BYxb/ZOUbT06EgJcVCyf1gOLVTp9DGbw8s=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(346002)(136003)(396003)(366004)(39860400002)(376002)(451199015)(31686004)(31696002)(186003)(107886003)(2906002)(6486002)(36916002)(38100700002)(6512007)(6666004)(41300700001)(8936002)(2616005)(53546011)(36756003)(6506007)(66556008)(86362001)(5660300002)(26005)(4326008)(478600001)(316002)(66476007)(110136005)(8676002)(66946007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?alRHOHcwRVV5Y1Q5TlpWUUxRNTRNclpSSWM4S3JCNTVldlNJcjNjS1VaWUpJ?=
 =?utf-8?B?MXE2d0I4bVBzWTV5SzlKdlVDUFRZVU9TTmFVRDdWa3RDSkdpSnBCUTBqY3ZD?=
 =?utf-8?B?ZUpucElNZEpsWW9KSytEaUNsN1huU3N5N1NUWFNsSFNDQkZ5SG1ZK3IrdEpE?=
 =?utf-8?B?d0FZdDNOT3E4RkY1M3ozQ1FwSnpvL0xGMWZOSG14aXBUblg4TUxweWtGQ3dz?=
 =?utf-8?B?TTF1RnR2VmlwNVJ1dXdsYW5OZlFPTTlBRXlZMUp2MGdMSmdwVGNLWk9sUVVi?=
 =?utf-8?B?dEt4UHZSRGJIRlpRUUg5eEJMSHpJTGwxYlAraVNHTHVzOG53Y0ZKTmdPRENi?=
 =?utf-8?B?WVBBUGRia0lWVzEzcmdIM1FESkIwS0tnOUNmY2hya3d3RXdCWHkyQVQzejBx?=
 =?utf-8?B?eFRLM1R4Z0hyU2h2WVF2VEpmanlKVlJLZE1iNC9SaUhpdXhaOHNPRXoveStR?=
 =?utf-8?B?ZHZ1anIvbkZ6WnpZb05POGxvdmUvUHdmRFdSbElHMUZpdXM5ZXM5di94RFp5?=
 =?utf-8?B?aXB3bjhLdXNMQkJkTGVEaDBpeXg1QTNFWUVzb2JGUGRLVlkxRWFBWUdmdWww?=
 =?utf-8?B?ZDFLQklwZ1RWYlRGMzFxemlMemtqeTFoMUhZbFo3TVVFdjYvV2NZTi9xd1NZ?=
 =?utf-8?B?bVNtVkxQSW1lcXBybmdWNjZjc2ZSRlBDYktoZHdFSzY1L0JYVTdZaFZFRjJm?=
 =?utf-8?B?d2JzbDFTZjRueUtGbnVYOHkxSnV0MW5FSE1NWENyazczMmFyeThHNWRYN2Z1?=
 =?utf-8?B?Ynhxamt4KytXVVY0cmZwaFZvSms5bHduUzlwT1dUSFV1TkY3LzN5QTR3RENS?=
 =?utf-8?B?QXZiYURBY3l1bll6NHVOMi92TFJxeWdOek5FcHlOOUdXSWpLSlNMVng4RmNi?=
 =?utf-8?B?OGtTYUtpbFFzdWZCa0x5MEZCNDQvQ1R3NGhQMmlwL2NPampHSFFxNGRWbWJ6?=
 =?utf-8?B?QjhzVXNRaXU4M3pyeWxzNDVTUmEwS0JzS2loOGMwQVpPc0R3R0x0SENYZmk4?=
 =?utf-8?B?aVF5V2w4VVJlTDEyK2d0azNlelVHSE0yQUZ5NGw4UVVTcU5STWVweEtRTjdN?=
 =?utf-8?B?QkM5d1BhN1gxb0t4K2d1RGJIT0JTY2NQQ2kzU09rT2JjZjY3d0djS3g0R3BH?=
 =?utf-8?B?YUhwckdrVmZhKzdUWGVBb2ZyYjlUeUxUUUxGZzBzNEpkZFdicHNFLzRJWks4?=
 =?utf-8?B?VGh1SDRoMHRRaDhudUVvQUFMOXZlSWI1eHBFWDhWYUVITC9HQjRmNThYYXFl?=
 =?utf-8?B?WmxNS2l0QmtnSTdMWWpnVjlReWtwMzJxU05HSmw3REN1OTdZekxsT213eGxw?=
 =?utf-8?B?NzVzZFlHak0rc2loRlNvZ1lmZU80WDNOb1V2Z2RvUmN5N0s0dHlTZGMxbTlH?=
 =?utf-8?B?b3V4Wm5xZnk2cGdJMUxLdmNIU0RqaEJjSWdtbUh5ZjRPaFFQU29zRHRvQU9H?=
 =?utf-8?B?aUh2NS9nU0Q5cnpiaTN3K3pNUWNsRzNMT1ZFc2g3QzZGMWFjYVU1MnNPam1F?=
 =?utf-8?B?R1M5YTJSQXowSXpqa281MFBaTUVMblNlZm9GWkhrUk1vdU5yQ2doZmZ1UWE1?=
 =?utf-8?B?VEtSSGovQVNuQWtZY2l1VHVCdUE2UUgrbGs2eFdTMGMyZlY3RjBlelc4c21x?=
 =?utf-8?B?dVVIOGtrUThObHZ1VHlLMWlHWWx2MlVFVmVGNEUxMEp2a3BoOWJuWTZKSWlW?=
 =?utf-8?B?WHJKdVRUTnBKbzJsMlU2eFpxQlNyRFFtbERkOVZDTlJPRGx4VkxYeDEvaitR?=
 =?utf-8?B?SEV6d2VvTUFhNTdZdll5S0M4b1FURDFGUWptZHU4K1ZCWkplWjcza1g5ZHBm?=
 =?utf-8?B?YlE3OEdvc082YVBoczVsYUpOcTFlYjA4Z0RIM1BmeEg3S3JvUzlCd3FsYkRV?=
 =?utf-8?B?SnJZWUlXNklhNFpkcmQ3ZEZkWHl4b1dEZTdsZlNPOVVxcTNuYTFKZVAzYXRU?=
 =?utf-8?B?aFBkbEtJSTl1RUJuTjM2enNWdGx1TVhxb29IL21SYTFJT0hLMDU3bXpHK2M0?=
 =?utf-8?B?K2FYaWpwbFArcTdEQ09pc0FiSThLdVRDTEFrSXhxbjliUEZCZ1AyRWV3UUJr?=
 =?utf-8?B?VVVpWHk2elZnVUF5dVFlK2pCZ0pCcjkyVWRWU2pmRmdMOExkbEZOZFZNMGIz?=
 =?utf-8?B?T3gySTRzUmZMUFVpQkYvNTdtdTlhL3pIYWM1ME16YVRHdXVZaFhpVmZVcG1o?=
 =?utf-8?B?RXc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: 7NqXsc4Ftf8+WFMtoYOIyHdXBuRPR9TcRmgrKIZ9S1GvWy8I9dCXuD0UUMeaVALQ5VOVCIR1gd9ycRCMDN5Ew/vQUgbBXknb/foAO95m2krojBc3d//mJgdwJeXPQF7NGs+8VFYhnLS7+9up3f7kP1SwNoq8VayTpmFZF4Wpbkxzc6lfouUBkEMBtliHgVWtm6g6Hn0zOoXcVCehCDja7VbWJXn7yQgb2t8Y7Y/xtfDNJG0iA400KWUqM6zu89RgO0uVxDbyDTot0DHT0a3gPF4qNSYoZNGc5L07NuOajjFAM8PPs+S6Zp7I8JImMWeqc2bRWib9MMAB+OlA9CNxyxxwDFqLIjWX6MVEWj9gyPOqu6NMjTGm+DrWgjes/ZCj+TwXqJeH8zcYcucJ3yz56f9wCbNYvngmkpnNUn/BaqTIAl1Ldefsux9QJjIBa1CL7wapaSCBSAMuWJolnpP1dz9ZHIfvlKTMh/Y6xOiYFT8yvbjuFXoEPaJYqPSeYeqnHkmupz1434LoCP9KJ3oIN5CAu+6gwCFNnf8L4cea+JEBaaef5UqtwSTO66t3kqGjaT9XtQedrpJatJilEEquG8GZ74zpTGxksghq2p0kwi8YnZAG602sWGwTzS+PuzWJh1mcjv90Jq8EvUDnyUHkEgxiF0njE4iF2k1RkzbAzJ71+Y/gq+tH+Wuh2nUmwgI+9mrHs+RfpOb086fnX+NPw1b2C18xl+NzposTCX6GrVQ7UBBJaWUHEwup761+4TVe76jjG9cTIv10Pzn3ZpXeAzDq4jefyqNMjhLi2qkMm6tNNgjWwMRdGUwUOrjB7TQy/QUJIC6lcMQDyn7Tpb7+GJ/L1dvQe0o3U9Z64WP7AXSifGnmxNmC1djoqf6l5oG8
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 86a3e375-89f9-4c09-3d8a-08dacbbf1875
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 12:51:23.7749
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: nvoaj6zPI4LrTLEuSnm6Fy9JjA+KjlzLIqJZRDlruwl6ZhYNzmJvFYrmmilD6adA17CKQCEohXDHm5JjBvhp9g==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MN0PR10MB5957
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.895,Hydra:6.0.545,FMLib:17.11.122.1
 definitions=2022-11-21_13,2022-11-18_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 adultscore=0 suspectscore=0 mlxscore=0 mlxlogscore=999 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2210170000
 definitions=main-2211210100
X-Proofpoint-GUID: pjh3nYNoD5gMEbKvJqQFOrVlXdoC4WxD
X-Proofpoint-ORIG-GUID: pjh3nYNoD5gMEbKvJqQFOrVlXdoC4WxD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 19/11/2022 08:58, Yang Yingliang wrote:
>> Personally I prefer 1. However did you develop a prototype patch for 
>> how 2. would look? And how many changes are still required for 1.?
> For 1, in total, there are 8 places need be checked
> in drivers/scsi/scsi_transport_sas.c, 2 places
> in drivers/scsi/scsi_sysfs.c, 3 places
> in drivers/scsi/scsi_transport_fc.c, 2 places
> in drivers/scsi/scsi_transport_srp.c, 1 place

and in linux-next there are 4x places which do already check the return 
code...

Not sure what's best to do. I'll leave it to James' wisdom.

However, we do seem to have a common pattern:

error = device_add(dev);
if (error)
	return error;
transport_add_device(dev);
transport_configure_device(dev);

Could we make an "add" (which does as above pattern) and "remove" 
helper? It might simplify things such that we not only fixing the 
possible crash but also reducing code.

Thanks,
John

> 
> For 2, I think we can use device_is_registered() to check if add 
> operation is successful, may be like this (not test yet):
> 
> diff --git a/drivers/base/transport_class.c 
> b/drivers/base/transport_class.c
> index ccc86206e508..ac41be7b724e 100644
> --- a/drivers/base/transport_class.c
> +++ b/drivers/base/transport_class.c
> @@ -227,9 +227,11 @@ static int transport_remove_classdev(struct 
> attribute_container *cont,
>           tclass->remove(tcont, dev, classdev);
> 
>       if (tclass->remove != anon_transport_dummy_function) {
> -        if (tcont->statistics)
> -            sysfs_remove_group(&classdev->kobj, tcont->statistics);
> -        attribute_container_class_device_del(classdev);
> +        if (device_is_registered(classdev)) {
> +            if (tcont->statistics)
> +                sysfs_remove_group(&classdev->kobj, tcont->statistics);
> +            attribute_container_class_device_del(classdev);
> +        }
>       }
> 
>       return 0;

