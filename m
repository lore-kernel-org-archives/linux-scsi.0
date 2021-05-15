Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95705C43460
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6D23D61428
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 03:14:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234219AbhEODPS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 May 2021 23:15:18 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:56044 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233798AbhEODPR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 14 May 2021 23:15:17 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F39vXs130255;
        Sat, 15 May 2021 03:14:05 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=AmvT1uxAu6/RK5qF+9Wl9UIqZv6Y63HS9mcJzeD11iI=;
 b=cRz5HDg0hV4MJlpptXPG/So1qSCw7CVqJ5eLY7pPD5o1lzIMt1eC0ltCx2h21ERXLOEd
 YkuQmtpn3t8h5IIKc7nMJwjKaOGRY/ICLjfM/Txn9qZZOlWxZ7p6YfRlLzlMMNLcxTNC
 GTgUlTvGpw42W5ht2ZKo4gri21+XfUV8Bm8sY36NsIECLrGuYE6N+7WXtahFLluE472e
 jrVHNyUAsap/maoWNgF5onkb6odPSt+hOeCcuH+lctOSJs511iRufZ6LXXDtHvVms2cu
 n6gCFephqz1kylE3Le2LwUcgdmaHFVk9nhKcBvHXvBpYx801R3pc9eiw3S6uW0EKRDNZ 3Q== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 38j5qr00gk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:05 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14F39nw2079663;
        Sat, 15 May 2021 03:14:04 GMT
Received: from nam11-co1-obe.outbound.protection.outlook.com (mail-co1nam11lp2172.outbound.protection.outlook.com [104.47.56.172])
        by userp3030.oracle.com with ESMTP id 38j3dray2u-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 03:14:04 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=A8EbadI+kr8UH9RKScn+yDk4ZNsIcOeWGyNGmUrwWPxTm19XPs8zEy7/7uVzdeDE9pKwtJQIh6MyWAmXVWE071oJCkQ359vEtq3ApGSYE8CeZIesJjD6fpbHndREyadEUAkuRhUYu4BUiqx5Np+yo7vt+sx9rXEcFEnl5ry+Lm0yB1RFDyoYTPiWmxVS5MxPfWwCLN8WfJoH5toebfq12cU4IbhP8tzomyAyaC2UPAam4PPiba36MOnAm3FhACDXnaAJTdzoOqYwqVdU67bB5OZStdqmhRSkR7cyjGN3+OuX8Xum62QOL4QmtLUmRMISapXiu+mWA+saMMoX+eQ7HA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmvT1uxAu6/RK5qF+9Wl9UIqZv6Y63HS9mcJzeD11iI=;
 b=SOrcq4qUqQ70cCdCdUTiL6th4Fm36MMXCf5sSu6DFc3pvhQflVmj+09pnnXjyeI92y2rVxfr27jm2YlxbmAARcQ/hpvuKMwpjwTP14HIMX5d4pI5MKyeuVHBGMSxPyYQKuuRfpn3nu21BgDtx0iz8+Zt9bAotARE4RvRtWQZAVZ35sNnpECXbsf6x7oBp996as09v676xouNgrqzds3Hs2VKagCH1uR/vcvS0rLYm4wX5u6QwtcO5o+9qOMgAO66RzIQZGkLpYT7B65IppDl1v+0HABzmwpGWrqMyKL2PLRamxaVejoaQZtL9LNb0F2ZVvan1nWtXSLwggzbMKJ9rQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=AmvT1uxAu6/RK5qF+9Wl9UIqZv6Y63HS9mcJzeD11iI=;
 b=D/fX/TnCUka1+ns/EQWo3OO/+et3WSP9IIQaI+dgBdA1z14ohQ+OI7ilWd0V90A9InfrLqxPu26q/ZfPRDz2N+Vf87uxrzBnwv3gnE4dS7/26vkJuEtVaAbOXW8n2CD4ujt9kmHiFAhxYCGTWTXW0nxGv2mNPQ+wP5gQX9Kn0Rc=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5452.namprd10.prod.outlook.com (2603:10b6:510:d4::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.26; Sat, 15 May
 2021 03:14:02 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.028; Sat, 15 May 2021
 03:14:02 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Matt Wang <wwentao@vmware.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH v2] scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic
Date:   Fri, 14 May 2021 23:13:54 -0400
Message-Id: <162104840194.20119.10224083609181565739.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <C325637F-1166-4340-8F0F-3BCCD59D4D54@vmware.com>
References: <C325637F-1166-4340-8F0F-3BCCD59D4D54@vmware.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR13CA0226.namprd13.prod.outlook.com
 (2603:10b6:a03:2c1::21) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR13CA0226.namprd13.prod.outlook.com (2603:10b6:a03:2c1::21) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.11 via Frontend Transport; Sat, 15 May 2021 03:14:01 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 4401540d-ca26-4ea4-849f-08d9174f7d71
X-MS-TrafficTypeDiagnostic: PH0PR10MB5452:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5452D903A79273CA7A33386D8E2F9@PH0PR10MB5452.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1201;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: DrZVa8NkOwdQYKulVvHsmLxJYZ2tQN4K42ojlZ3ZTIoB+/Z/2hf7CtSctQl3yj6xcxIXTuz5oRE6b0H2iDHxSN7dh9IkNBhctwv+ivMHfsVXkuD5Kqfz21AIIOUTBCobStR+J91+E9nBeyz3znKihOpIFtM61NQwKjt1162PFEFQlaZvk3IFzpUedLa+bBZ9Jwng3tWIk0A39LTdRV6z0YB9Tguj1051TLMEn47lobU4Nm5G9/eOFfIoDtfIHfurjNWzYFK8n1EZyVLbKd47MoQ3KaZndo/J+vVF53tWXmw9oajz5rEE6cqtf0g/BZEiRv+8DP84blUerKiqGgq/AvtmUNLK8eF0nTPVw/SoYBz9jY4IQvuJf8Jsgdemcq6O29ClFo521GSyEqBODDuTjWl8yYrtwG1uBd4FCekBkYKV9LGgVJF4gWbDyF+wCc9ZkQIBLfsSStcEymL+IMkH0fWQJugMH2ta+9f8UfDHvkdtrFdVbEF1D72eoI8p6a2vaGhl5vzzYN0dwGKpimZYUD9Gf3wL+anlY4irWbT9q4yShLI4qXtvvs8FeLuO37cH2cZ367ZQOQSJLLPC9FtXEu9WRqo36AnFKlTwAkfsaeXXG+Q+hKNMtEMbDmzuZpOrY4oPeJAaN+81NwwI839vIZOikV8OYeYZGQqJPcJRKKa9BY886I/ScmqRhAM6NSz+SZPSww1UVpzt272oMa1iZA+wUeP8IeWGnJkWPwXbUjQ=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(376002)(136003)(39860400002)(346002)(7696005)(52116002)(8676002)(2616005)(26005)(4744005)(6666004)(107886003)(956004)(66476007)(66946007)(36756003)(2906002)(6486002)(16526019)(5660300002)(103116003)(6916009)(478600001)(316002)(38350700002)(4326008)(966005)(8936002)(86362001)(38100700002)(66556008)(186003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eGVjQ1kydjdRWVEzKzc0VkJLWDlTZVJ4dXh1T1lBNGJ3RUdqVjVnOGF0dXdi?=
 =?utf-8?B?dlVCYzlMeEg5Smx3bFI1S051ME1oS1R4a2laSUtENE1TTlBQY1RNdnhBWUxl?=
 =?utf-8?B?amZGbUxQSUZTcUdMMkZLMnc4ak5zeGI3RnZtNVZ6WnNDUmdaSVQwTGsyQW9u?=
 =?utf-8?B?dFpZVGRkbjYvUGlMUE9IVzdIWXB4a2RKMDVaWFRMaG93ZjhoL2tiYjUrL3Q1?=
 =?utf-8?B?aE5PWFlkeVJqSTZoTlNlU2ZEZis1V0lBL0hjNUlXUXlsWmdvYWl0ZStLU1Rs?=
 =?utf-8?B?L0xKa0tYb2t4TVVlNG1nU2xYNmZ2K1ltbXFaSzk0UXJNSXI2a3J3cHgySjhM?=
 =?utf-8?B?bFNOOFhjdGw4cHk0NUEyNFB1cFQxMm1DeVpOS2lmN0x1anIwUHI3SUlHMzg5?=
 =?utf-8?B?SW5rY0pmckFmTE1CanNzS0pYR1dRWlgxUzZNUkxza082OHFkUER6UmJXdml5?=
 =?utf-8?B?NkxEVi9HSWh3ZjAvY0hicUNybTA0VEZsRTlRVEVQSFFMWVZFK2IwS0xhZllr?=
 =?utf-8?B?U1h0RnNVd2xQMnZEcFR4L3VuRERkcGU1VUsrRHpJaTk2ZElJRVliMUlDUDFN?=
 =?utf-8?B?bmNFR3NMSENDeU44MnBna1B5dHNQT25MbCtUOCtTYW1jN3lLV09RYzFBUjND?=
 =?utf-8?B?aE9SaXl6ZjJzcXdNMWF1MUlYOHhoYkVQU0IyeVpMZVpNRWw4SjBTUXVORllL?=
 =?utf-8?B?VmVlb21qQXhnZVN0cTFzbVhJNnFVeHlYZ1NNSlp2UmZhUEdvWjc5SnNuQVQz?=
 =?utf-8?B?ZVF4VDZ0YkFZaWxiTWkyWnNyMmNKZy9uWGZDVEVoLzNUUlJxZDVrTWFrUyt4?=
 =?utf-8?B?SjhMOWpGbFE3Y1RKd2Y3ZnZ4Y3ZhakIrN1ZXOW9zamo0SHpmUU1yVVNSdHJz?=
 =?utf-8?B?NnFXL21qcmRFTUh1QjZBdmxndktxeHZOdEdscGFBdEF6S3QyVGpNOVdaYzVF?=
 =?utf-8?B?OHdCaGl0OVlpVTBSYW8rT3JYUEVTQU1iVkd0WmxXaS91Qll4SjNGSTlPd0Z5?=
 =?utf-8?B?ODlDcFNXNU9RVVlPM2NtYXhKVjhWbjZ1dDlSMThkNFBsZTJkNXB1Q1htZms5?=
 =?utf-8?B?Uy9pUVU2dkxvQjJsSG9USWRORTU0bXQ2S3FCeGx6c2lYWUhjQ0lOLzZlb0ZP?=
 =?utf-8?B?c2l4Z1VxczNTV1RXN01FTEF5QktjRCtLMHJIZWhyeVRJeVRsUmV0REg2cTND?=
 =?utf-8?B?cFBsRjFTUnRhY2Jnd2k1VFlRbEdub1J2dGFBSW5VSWYzZHV2MDZhL1ZnMVMr?=
 =?utf-8?B?UWRaZm9pelNtSlQzMDRrS0lKaTdZejlDOVZhdFltbmE3a0tjS0dWcENXbkUz?=
 =?utf-8?B?bGNPVkNDU0VhR1d5TUtOV25ySHdQOUtpYm1jN2lPenQ5VENRbXdPZ3haYjlI?=
 =?utf-8?B?SjhVa1Noa2pFT0Q0QlJHMi9zT2srWXljQS9XSTRZZjV6bFlRTnFOdGdnUkVj?=
 =?utf-8?B?YzZuRUVRZWdvZnZQekNTYW15SnpMT1Q0LzJ5TEZxTEpIS0VwVWdFaWhNUFVT?=
 =?utf-8?B?UVdTRFVCYTJXelZIV1FiRkhTdEJhMEY5T2lRWGhJazlXZ3BPV3lkeE9HOWRy?=
 =?utf-8?B?SndRUUVHeEhjTEVUMGNkV2ZiWWZXZGM1enl1S3ZCMGd1YXgxRjM4c2JJTGxN?=
 =?utf-8?B?SnhhY3lEekVoTndEZUFZSzlsQllRZk1WUTkwem1TbHBmeXZ4OGhWVWNFbzZD?=
 =?utf-8?B?WFBoc2R4NnJ0ZFJZN0VkRjJGdkpROTNXMGhOckM3ZCt0SWRZbk4zV21CaElo?=
 =?utf-8?Q?9qtyyLimzhHN8ks1hXnm+vLdfPOG99v2WtpeQ5c?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 4401540d-ca26-4ea4-849f-08d9174f7d71
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 03:14:02.6213
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: OTMdOTnZ/nYXnHxVN3HcQnnrPCFF42PinkE1ZcMb6tXV97Bqx7w6HatnzHGqBG4KU7v3rKSsp30ftzpNSgPaZ66pD8MswMQHJQ/T1ZxQccc=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5452
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 mlxscore=0 adultscore=0 malwarescore=0 suspectscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105150022
X-Proofpoint-GUID: Psl4JSABpMqwVCcvwOZNqx2RLVUZFqa_
X-Proofpoint-ORIG-GUID: Psl4JSABpMqwVCcvwOZNqx2RLVUZFqa_
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9984 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1015 impostorscore=0
 mlxscore=0 lowpriorityscore=0 malwarescore=0 mlxlogscore=999
 suspectscore=0 adultscore=0 priorityscore=1501 spamscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150021
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 11 May 2021 03:04:37 +0000, Matt Wang wrote:

> Commit 391e2f25601e ("BusLogic: Port driver to 64-bit") in Buslogic
> driver introduced a serious issue for 64-bit systems. With this
> commit, 64-bit kernel will enumerate 8*15 non-existing disks.  This
> is caused by the broken CCB structure. The change from u32 data to
> void *data increased CCB length on 64-bit system, which introduced
> an extra 4 byte offset of the CDB. This leads to incorrect response
> to INQUIRY commands during enumeration.
> 
> [...]

Applied to 5.13/scsi-fixes, thanks!

[1/1] scsi: BusLogic: Fix 64-bit system enumeration error for Buslogic
      https://git.kernel.org/mkp/scsi/c/56f396146af2

-- 
Martin K. Petersen	Oracle Linux Engineering
