Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4FC0EB64D9
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Jul 2023 01:37:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229890AbjGKBhJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 Jul 2023 21:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229917AbjGKBhI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Jul 2023 21:37:08 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59663DB;
        Mon, 10 Jul 2023 18:37:07 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 36AHuVZ4027999;
        Tue, 11 Jul 2023 01:37:03 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=azBHPKJSBz9ql/Khqhdibt+dSxDdQuCabvSyXavKKYo=;
 b=R7pZVy3ZlKc13svVjxv7hxsX+hLJ5taEMH6Z3uMN8w9t0WLKqtgpmDGDmFIYmY8mz43Z
 KfOEAt/3gR1NRfXazyvz8yjgLM17wEJPPfH34FToqcClqekk94p4jgjOZt4axR0AGF6Y
 B8I7HAslEzzOWdNpKjNYrS88yIv1V5ORUQUnI74RFay4x8mMoCtFySoT+8l6j8yhKEnU
 i7QIBC2MmusjKFtkHlrbLVPEKwP1lsxzbzjVhF7CR7zIvc6UpC18mgh20VKFibjwTLk/
 nIT+GvEj3X+KfPC3ZpkXwYN8qwT6A3urALqXAdudxNl0Jb3/GqnC71hJHbyPpu42UNzh 6A== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rrfj61qeq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 01:37:03 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 36ANoGWr030851;
        Tue, 11 Jul 2023 01:37:01 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2105.outbound.protection.outlook.com [104.47.55.105])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3rqd28f61t-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 11 Jul 2023 01:37:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gdkvBX1NTs1A0gkuoI9I/p+EVr2fn855xsCRT1gn3PltjUa2EwZzNiOGdap7ey/P3oMqs1HgWXgJ0IGPkaOQjt2z6S9xUOqJ8WlKueoUmRgrtqNB8M50+GOdnQLfmgaYiHWZy88kqIJS0GSNdr6CvO9eUK1YhsCw23ue3SlQ4XLXZTbai5QrMlUpUSVKdTjQQ6nZYddeG+qXkCsWjatL73j4lqhBfRCRekFS+C5ZMHm1Hb2L2mxVwVHuJTnivr89kmKPnNO2t43VHqo4j3bjmjupYU6sB/PoENEyyt7fxZK/MABDAEtFSPWo7EfT7KJQwlZ1ih9gKs8QFZpV/l+mYQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=azBHPKJSBz9ql/Khqhdibt+dSxDdQuCabvSyXavKKYo=;
 b=LVGD4sEtjadXmL2GY7nny3g0sCJnSGP02urz9a4JeoGSnllE0P5GmY1w8ambP4Y8LZNL36+CKwv0t9nlg9uEQm6U4Zpma5xJ0KlaX11GyJ0cA6H5JZTdo1w+AEhpt7lABWlHFnM1Kv4gEeqrhJsjpHmmMS8G6P3XIdG8LgKkPZU6jJEW4YbRKO0hS69uf/5e8p7+CHnUpn6Cex1uhNhNtViMHjSPnS5sc9wUpOLttZ9I3tQYfZBuv9WHXeV5yy9prdCH2Tq3KsQqlZH0P7kVdhHf3RyrP8HmQfTogrweVdzr78SLJ8ZSVJCP8zVtkr3jNOWI5w7Gp9MhpY4DyFF+bg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=azBHPKJSBz9ql/Khqhdibt+dSxDdQuCabvSyXavKKYo=;
 b=dB2rm7VILJIfOApZF0v7i6Ous37m8952HVNpGSXpCalalRo5tmox77cQ2TmgNAqsHdDuHp+xPaVSyJ7seunyHFaEI8hW/YihsgxmYCqDiG2Ig3eFQ3apQqAxVWjgqewznlGXxx7Cd5kkEpd+GwTFM8RYe2ztKmTx+S9ZpP1wMcM=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CY8PR10MB6491.namprd10.prod.outlook.com (2603:10b6:930:5d::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6565.26; Tue, 11 Jul
 2023 01:36:59 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::f5ac:d576:d989:34fa%4]) with mapi id 15.20.6565.028; Tue, 11 Jul 2023
 01:36:59 +0000
Message-ID: <fcb079f0-6da9-0819-ec9a-706f5aaff818@oracle.com>
Date:   Mon, 10 Jul 2023 20:36:56 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.13.0
Subject: Re: [PATCH v2 0/2] vhost-scsi: Fix IO hangs when using windows
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        stefanha@redhat.com, pbonzini@redhat.com, jasowang@redhat.com,
        sgarzare@redhat.com, virtualization@lists.linux-foundation.org
References: <20230709202859.138387-1-michael.christie@oracle.com>
 <20230710015042-mutt-send-email-mst@kernel.org>
Content-Language: en-US
From:   michael.christie@oracle.com
In-Reply-To: <20230710015042-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: DM6PR02CA0088.namprd02.prod.outlook.com
 (2603:10b6:5:1f4::29) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CY8PR10MB6491:EE_
X-MS-Office365-Filtering-Correlation-Id: 272dd030-e8b2-477b-a956-08db81af514e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: JQT/CV0yil3GgOQ4R06IPHumV3PcUwnR/+fhDswEgsW9eb+ddGvRwg8haw9Co3Mhy1QdAHZTmb4saIetfn34bmcQN18QjT9EDOFRuo0ZGgloxybXpM35K+9/K26wHkMCizVKT6K1pEcMr3Kts7/p8sMIuMWfJYFzUWKB9GviUHK9DB9gyG1PA2nsp8VuUM4NyAZE+5ilxF/2YrRZIrfMtfc2xcxhqZfGfU0wXW6kVOVgLN2kw3baoLrMVQ81Mk8Y0Iv95muDfvFBAupri7Vn5ybNvw+MYHXjMtg8JmvlRzIkJVLxAnFTzxFOnEdLJCDC5edljFno5BaRkx2JITgjwSe/ruabgntqVeeW0Fvhn1UExBuMx3/GTL0fhfNydf43us5HGkUYFK9rngDcgXrMGdDuvxNRqccxq1K+Zu5+bI900skmVWff7soPoGJmO06bbZ+6kl/WPkATrhJmpS/Y7YujaSPyTQDxDIWC+8wXzN5p8wqL7McbECaoa+PzOFp9Iyo1JeFosvVd39IWJ+uFWWQ00/zo4E6ll33/jyb8NBmHEne21zPWYWPQAyoz6EyJxZcgDN22412wddoFlv3V8q/sL8dVMUYTE2tHFnIQrBe5GxSasfdTmKtYhwDiYY3qTmjN3Te5v0EnCW/5BCZoEULMDFplpolVZxxZjPAKX34=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(39860400002)(376002)(366004)(396003)(346002)(136003)(451199021)(86362001)(83380400001)(31696002)(478600001)(6486002)(4744005)(9686003)(53546011)(186003)(31686004)(2616005)(26005)(6506007)(6512007)(66556008)(38100700002)(36756003)(6916009)(4326008)(66946007)(66476007)(2906002)(6666004)(8676002)(8936002)(316002)(41300700001)(5660300002)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bHlaeVJCcHoybTFIME43a0JqMHJZYk92NW1aVlRSYWRCRjFvZStXTkJqbFF4?=
 =?utf-8?B?OEY3Q3BtMjlCOUVjN2RsL1RWaVM3WWdIRjI3UWdIZWNXR2RxbDJnOGVpL3pU?=
 =?utf-8?B?NHROcHkrOVZYbWJvQkhWUUJEWVMvNEVEa2F0TnFLSzF6UFg4RU1RN2tQWUhT?=
 =?utf-8?B?NVlrMk1nNXk4amFVUjVuK2hvaTZ6bEh6YlBCMmtyLzJ4a092T0xQcVlXNmtT?=
 =?utf-8?B?VkEwUXJjVHJwcG1Da21Sbmd6NmdKMEdRdkoweHIwRUk4b3NndVpZcEVyUmda?=
 =?utf-8?B?T3BzTXdOQ0pqSTh1UXRVdVltM1dyYnNhSUt2citOTFpSRm1YOTg4UHdpbGIr?=
 =?utf-8?B?YmYyKzJzYjRVMUpsWG9yeEUyWlZ5ZWdpcGZLeXZqOU9yVmJDVThWcVVUMTV2?=
 =?utf-8?B?RnBKeExDeWtmTncxM0VlMC9JdnAxcml1ejNwSlBEZ3d6RjlXR0h4UG02WjJZ?=
 =?utf-8?B?QjEwT0lmcHE0SWNjWkM0TU5tYUthdjh5UVJQMTZrYTRRK3lVc3FYc1pzRFVS?=
 =?utf-8?B?SXhZNmNOeEk5b0hXdjgwYk1xU3hGQ21yMkszVU0yclM3L0g2T0pYZzhBbzRL?=
 =?utf-8?B?ZnhrL3FVRHNZMzZtb2U2UGM4VjdJRUpYemVCeE5oaHB3K3lhYlg4TGlYdy9u?=
 =?utf-8?B?cHJVUmdSYnhRUWhudm04dTRoZHlYdnY4WHVmKzZjaGo4aXFtQkFhWDdMeVJ0?=
 =?utf-8?B?blcrMGV5UlF3bjc3ak1PTW44WGxneUMzQzhzR0VxNVBrYUVlMzkvWnVmV2dB?=
 =?utf-8?B?TE5YSENXcXZVR0Z4RytmMm9aN3B0dFFWUS9KT2tNdDF3V3BoVklJZFpzT1d2?=
 =?utf-8?B?NHlqWFcyaUlTbUJtbGVkaXBoeVVWU0w1T1VQSldOdWdPY2R2d2VqZnkveFhI?=
 =?utf-8?B?THBGWFVidW8vNHJLNFhsS3JEd3Q1Zmx3MXVaWk8vaUl3aU4yeXA3SDRNdUNk?=
 =?utf-8?B?cWZtc0pQblp2YzA3ZUVsZTlseE5XekdkV2xNWnIvN0JMZzhmd3NrR2llZFNT?=
 =?utf-8?B?dFYvNVg4SVg5TlNjdXBkTVlCbkh5MWRjalV6dks3Q1BPSTBsSVNFMGNZSlRo?=
 =?utf-8?B?MERDTHYvbmRsbXl3aGV1d2lhNUVrZnRyU2Q5YjJ2S20weVQ0K2hLZXBQbW1W?=
 =?utf-8?B?RW8vcGVOQ1JhS3F5R1AvajZoV25WUTQ3QU1hREpobW8rb2JsdyszUEROL2ZG?=
 =?utf-8?B?cllpTGpUZjc1TmVGL05lMWordWZ5LzJvT0ppRHNvb0tTM3pTVXhVZmZ2UW8w?=
 =?utf-8?B?cGhvV21BUEp3TGNDbG9BTjlyeXpHcGZlS1IyVlR5bHdhNU1WclZsellXRjhh?=
 =?utf-8?B?a3BGSW5OR1h4K3EwSUpaUm5lL2tvOThxUnorbUZtYXBFeU9YUENrcmp1U0c0?=
 =?utf-8?B?MDhKazlUL1RNMnU0VTVVdGpHcGhhT1BlYldZeUcvN3FYczgvQWh3Qmt0c3pv?=
 =?utf-8?B?TXp2YTBqdy8vS1Rvc2QwMVk3cUJ4alNISS9IU3E1RVJ1UytiT1lSdkhSRVhH?=
 =?utf-8?B?SmN3NDRDZzYzcVlad0ZaVnIwNWxIR3AzNGtrcnN6TU51R3NkcE9kcjE5UmZl?=
 =?utf-8?B?N2loWStqQWllSkQ3MUZnQ1ZjMUp0Z3VPaU5aTDdmaTU1T3dnQ1FRQnhQZEhE?=
 =?utf-8?B?SGRsQ2FLSktKQzZ6QXA1djl2TFJreXNkYU9qakxTSGg3ZWhJak0vN0VZUkpk?=
 =?utf-8?B?LzZ1Sko4bVd3YVhKVk9IZlpwSHZScXQrZEN5YU8ybDZNTXNEQUp0aTEyZGdL?=
 =?utf-8?B?aUx2K0pHL3hPQW1xcjAyT1NzcGprQTVJYnpVKzdlc3gwSytrc1M1Si9GenJG?=
 =?utf-8?B?LzBiL3JmSTZObHJ5b2ljeExiVnVJQzZENWxUN3VBOFI5LytQMkViY1lJMGJk?=
 =?utf-8?B?ZUp5QVVERm91ZDNhMFJGMzEybWpqblE3NnhCTUl6YVNSS2dpZktGQnhxdFNz?=
 =?utf-8?B?ZlZZVUF4YVZyN1RSYUNjcWhkeTFEanM0SUEzNENZZndMd2JiSkYzY21ic2xM?=
 =?utf-8?B?SWZRUXNaeGdqRmRuMXBuaXNhaUg2NGtWZ09OZlh3cUM0bE10Ti9UTlduUndP?=
 =?utf-8?B?SUhKd3ZzN0tXTjRleXhxdVZueUFCNWVQRTUzVjNnMzZsL1VBU09yajdMRUE4?=
 =?utf-8?B?anhRREJlbklYM0QvTUh1Y0dQNWNpb2VoSzJ4MWJTV2lhYnFENHRxdysyam9G?=
 =?utf-8?B?Wmc9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: qZ6vTegobQsS3YiMl7+Ut7IlRySvnSpv7OvDTenDZ0NT+TkeFhcUKSwdhtoWgHimI01Q9h5dMLknmPLINMF8DCluxMf8BUVktg2SHlE5Uyw9Yk5VGYEwjn7++6N1fGolzbkUQfxuylWgeZJExyizCai23IP9F9l8voYPMIAQn8gDyzfS9RvBH6a6WSOl+ekfLyKCq+G2F+1xh4s1uBEapXePViy5auGm14GJSS6lqHbp6sKadcEggxYETwsf1r6fu/xclrvjWumWGArrRpJDlZRHcRuAsWzlXtnduMDOB7XYUGzeGOBml31wSRGzXO8SCekrtCPmNGIyDmrAdMnHBOTLrlUCFL8g1RhOiLq+ZTHco8NnLehpkIv/ZHEi1fTRFsU5G7iehXh82LHpbfxs2KnvdgVzXnL2jNloyKLoN3eHpVmkDxmOVJX6CXtbnsdvwDJ003KDGxv2UnzIKeeN82MPfwJbJTrd/2IT9SLlpEqFz8A1t8KvP/kFlMZdW66ZDXmKEW0JbvamTg1Gyf3FEW98lbvBkRc1Rb7duEIRzCFnekYIJKTx53sZm//v3pGc5qj0ob6+egCJZVzDC26Qxa/0naZiz9x87S+nbIorCVtf/aLaRui03DroVt8gzJThJw6km0Ln3CqefCpFwoRyTVlbvpRM3dWObht05cxPXOOP+hIEp2bJFl15sMH0ILsJLYZSCBY+d41RE0aiaayawM1dpj5fTuEVWqdCU2qWJ5SC+nuGdjWCoq50ULMfgJyVmuMGIN/L2R/NctShlPl6JEIQKFPKDTOTEEzLq5UNwQOMMXvjy57oQAODIsQ3sifAgwyn4SbpwAg5+FQKlqrHhBw0Nj3a2/JZd9VOlpn3gyo=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 272dd030-e8b2-477b-a956-08db81af514e
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Jul 2023 01:36:58.8387
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Q/ArzpWt0J8RqqYx4jTZBemaUJFp43YlXbt9dg6IyvS5d5+CGRKO1uR5ZNJe6Z4hsZgVYiVyIcZTbC1JUcBwcWTvxLF1J/KXaSA/2ew9vrE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY8PR10MB6491
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-07-10_18,2023-07-06_02,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=923
 adultscore=0 mlxscore=0 suspectscore=0 phishscore=0 bulkscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2307110012
X-Proofpoint-GUID: YJ3uFUFPtI00koPKcLU_vY1qhIchq_W5
X-Proofpoint-ORIG-GUID: YJ3uFUFPtI00koPKcLU_vY1qhIchq_W5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/10/23 12:52 AM, Michael S. Tsirkin wrote:
> On Sun, Jul 09, 2023 at 03:28:57PM -0500, Mike Christie wrote:
>> The following patches were made over Linus's tree and fix an issue
>> where windows guests will send iovecs with offset/lengths that result
>> in IOs that are not aligned to 512. The LIO layer will then send them
>> to Linux's FS/block layer but it requires 512 byte alignment, so
>> depending on the FS/block driver being used we will get IO errors or
>> hung IO.
>>
>> The following patches have vhost-scsi detect when windows sends these
>> IOs and copy them to a bounce buffer. It then does some cleanup in
>> the related code.
> 
> 
> Thanks, tagged!
> Mike, you are the main developer on vhost/scsi recently.
> Do you want to be listed in MAINTAINERS too?
> This implies you will be expected to review patches/bug reports
> though.

That sounds good. Thanks.

