Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23A4DEB64D9
	for <linux-scsi@archiver.kernel.org>; Thu, 15 Jun 2023 17:02:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232502AbjFORCE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 15 Jun 2023 13:02:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58378 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229511AbjFORCC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jun 2023 13:02:02 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 046B4123
        for <linux-scsi@vger.kernel.org>; Thu, 15 Jun 2023 10:02:00 -0700 (PDT)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGJ4gY026580;
        Thu, 15 Jun 2023 17:01:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=KNfwuIscXeQDBtWw5n/0djVnNR6BUIJOTUZicVYVh8s=;
 b=mOAnDdBzttdQRUi1JTMVhUFJobqqsLfJ/xLqtUp8asnPDJFB7+9ZTftUog5l29IsxlYJ
 VV1M1gtBspZlRZ0qh0qRVgHxAh4g0UuBRObobYMjKSW1jvPFez6F3qJkx5IeiTLZhTn4
 6434HuW6oJ5azpf0ukMjbS8XonCUtRgB9ZTBQd0MZRfl1e2LxEabnLoOgD8wmFfBAXwe
 EZaOfFZCKJxnHogEMgIB4xUzl0hT3zhhCibdU/CbzT5nfVhzkr90FTl50nzRCfNrCess
 EuX+6M0ECIuvTU4gNd43nnAilJ7XjGLr/IDQtpoQEf0grCmqU93Kk9NuE25uU0Y/dqFv gA== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3r4h7dajfb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 17:01:48 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35FGV46H009515;
        Thu, 15 Jun 2023 17:01:48 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2172.outbound.protection.outlook.com [104.47.55.172])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3r4fm7g0ya-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 15 Jun 2023 17:01:47 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LqhHLa7iUM+HyeJB3mut5joKF7XFfDe2wNu4QSUSbs5PL2CDbqNerkK7JYAt3tdUqZznwk5/gNq26YFYshaKINqPohSuE8lvHvX1DhVz0Mxl3FBE0eTL4qvf5zJGHTH9mELb9iyEyj4p3+3VtE+6OKG+I4z7ELt0CSmJ/7aOPPgRFVVorACff86ElLkdJhPbOJ9don27eBfPM7kavcruGsOTF5s6AsIvSREJGDF/tjMiyOXgVlN1dEKR7/evv0mds7SbmR3krnC1AVA+bm8owqSAz44BvtlREqHr2h+g9kL+IBmThqca6l+451QGgmpmCnuCaxpiy20jA61HelQzoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=KNfwuIscXeQDBtWw5n/0djVnNR6BUIJOTUZicVYVh8s=;
 b=e9qiaYMrkN50y74oHIL4DAk9InzitxyZ29Suzsy9oGtXo30MXWmVoPt82INxTJhKijnDDCjvfgXANC4O4A91d7qtt0L2gImLnr2zi+sJmOLQa2P35+JNiMNE4TWsT5ObX6U5CjU3YxNqYfnZlz8ESiBtvCYv8RQgjV8UlbHc0YOHDQ1enEU8yIt+Uih5HxQd3/6QjLq8HasV2qwsNSZhfMJiKJjk6cDPoKF+ZBpaJCb7kkWKVjPzuDvmGFaLW+us1YmrVFSZjHAYbXq2SgMHcqpP4NtsGyrZdzHO1zHlbtJM8MpusEYsIwBCtyW1lyHZqbUgPamSnHeczEDxZ+28RQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=KNfwuIscXeQDBtWw5n/0djVnNR6BUIJOTUZicVYVh8s=;
 b=yoQzl8r4l5iri3bwc4itW0j7XKCURJr6lwSBn7Mu+/KV5slTzO5CYYBumDMkaK/I/6uxaGL37eOqIe2Vu4Vt9muSGyNUdYToSu0HyTH5YK1S/9AUEe6X9kHadTNwzol8ayeMF6On7VHNEEhMQ56ejHCDB7c3f9Qrb+OSoycfzs4=
Received: from CY8PR10MB7243.namprd10.prod.outlook.com (2603:10b6:930:7c::10)
 by CH0PR10MB7535.namprd10.prod.outlook.com (2603:10b6:610:187::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6455.33; Thu, 15 Jun
 2023 17:01:44 +0000
Received: from CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559]) by CY8PR10MB7243.namprd10.prod.outlook.com
 ([fe80::13d6:c3f3:2447:6559%5]) with mapi id 15.20.6455.045; Thu, 15 Jun 2023
 17:01:44 +0000
Message-ID: <bf457ee0-3900-e369-5966-d8451657f5fe@oracle.com>
Date:   Thu, 15 Jun 2023 12:01:42 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.12.0
Subject: Re: [PATCH v8 15/33] scsi: spi: Fix sshdr use
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>, mwilck@suse.com, hch@lst.de,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        james.bottomley@hansenpartnership.com
References: <20230614071719.6372-1-michael.christie@oracle.com>
 <20230614071719.6372-16-michael.christie@oracle.com>
 <e576431b-7196-fdf6-9dbd-cb7630d4c8ff@acm.org>
From:   Mike Christie <michael.christie@oracle.com>
In-Reply-To: <e576431b-7196-fdf6-9dbd-cb7630d4c8ff@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: DS7PR03CA0064.namprd03.prod.outlook.com
 (2603:10b6:5:3bb::9) To CY8PR10MB7243.namprd10.prod.outlook.com
 (2603:10b6:930:7c::10)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: CY8PR10MB7243:EE_|CH0PR10MB7535:EE_
X-MS-Office365-Filtering-Correlation-Id: 96040311-af57-41a1-a827-08db6dc23278
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: k1fwndyFZI9iTULH0lqzy0NmEfVhPlWeJy/CjAavMxnRidPTWZt5siu52Jg1fNNap/6AfaIKtdZzQQnU595stQaeDqj5h1RueEwvyoXurzPB6/A/9t4oxpyfbycUIqoRjQr21nNh2jV2+QNpTeRAU/+xpzOJ5kjPF+vmXjpKVK5VFJw3u5wcgsQmM0nqpSHppwrDrro2ZeUpdxEoB6AQEWUJeUAJpM2ZTrLXCHD8QMyGKar1B0pG9v/v8H+ECNjrpuMLS+7J6HyLifa/IrjsGmOZI6TX9EZCwrJPvnZa41gIIbXfCtULBSPO18ZvDXITR++8/IKWUZXw0QyLlF1CsqvQLW11QHUhOlWS9rDlkr1iRF9cB5f3672O42mVJzHo1EqHpMdnd+RJ87bUNLYNO8mVXyNAtDRje8q4gNtHcV3RMH6+loKwVhLi+nSOmdJVHpVjh6/D1Jlq5J1XcHyj2BjCU6wIzQTnC7Fji4X5ssklcZ5VXbJN2IlA/w+byRz85hhpdqCHE0Y8hCeqpqxMLknP+zjtY7ceNbqJwgYkRL6FK0JMKaJ0fkXNfBhs+8vFD+l0RwYfTyx40bHZw53A4cmyzEae2OMQ9GuCa/KgtbnFv3t/st1uhRABSbiO6WKII/Sz82yrquJr1+asUv0cmQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY8PR10MB7243.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(376002)(396003)(136003)(346002)(366004)(39860400002)(451199021)(478600001)(2906002)(36756003)(8936002)(8676002)(5660300002)(38100700002)(66946007)(66476007)(66556008)(316002)(41300700001)(31696002)(53546011)(6506007)(26005)(6512007)(86362001)(186003)(2616005)(31686004)(83380400001)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?bmk1R2lpSG1iektwZVhUY1pjVXc0LzN2K1psbElCU1lqNk5nUGpHNjBrcklY?=
 =?utf-8?B?b3BxYjNxYWZTYStXMTdFSUQyKytocnE4K21JWTExVFhSeUYxUy9rUW1OaFp2?=
 =?utf-8?B?c1VjY3BXeFVLVG56dGFFZTRDYTJ3eWhkWWRtVUZ1bnl2NTVpdW5lOGdVZW5F?=
 =?utf-8?B?LzQzUXkvR1RBeHpwZlVTNXMzZ201T3RORWRWZ1BSc29GQWl1alJvcnhocVI3?=
 =?utf-8?B?ZkhOYUJtTFRjUHV4alRTNTZCVzc1KzdUTUlrTEJQd25qaUV4REhocGhranlO?=
 =?utf-8?B?ZzhuWmRsSkpMdklJTXkrTU94Mm1nLzZUbmRxU1NLSFB3Um5KS1lYQjNVUmRv?=
 =?utf-8?B?UHl4NjVhNEdSdXNWM3l0bW9WWUJ2bE9Lbmt3LzhucDJubjVab0lqemVqcUtQ?=
 =?utf-8?B?N05JbUNWL1RVUFVGZzZyMTdvWHdQZDF2Q3NhdWJpZTVLb0owODJvT2wwdlpV?=
 =?utf-8?B?dlFJY0NpaGJ1c2h4ckZ6eHI0dytmV01CNkF2MWN1U1MzclV3NzhWK2RmdkIx?=
 =?utf-8?B?WlhsL0FZOGJwZ085ZndmQTh5SEVtZ3ZiOFJwWEFHM0hCNWJSc2dqNjk2Z3Ez?=
 =?utf-8?B?VUJIL1pBa1lPSE1ZdFI4aUsrdFpLRVRtSUFKNlgzdFRsSHV5TTQyU2dKSUc1?=
 =?utf-8?B?RXIveHJmbEFLNDR4QllhVnpIZ1Q2ZDJ6UmZFa0ZibGgrU0lnWEFvbVN1RFRF?=
 =?utf-8?B?Zm9tc0p2d0NMdHpld0U1ejdiSTR2YmtMNVZyODBtZTNQeUpLM3piMlk1cWRZ?=
 =?utf-8?B?aTFTTDJ3dDcxbldxWjVMTUFtUmVORGhKK1QraHpwWUtoSG1xSjhpaFhlcWhF?=
 =?utf-8?B?Q1E1UkNaWVBYd1Q3VUZ0MDRab0tmRkNQVVVDRjdpOHBaN2txalYzdDlZbEg1?=
 =?utf-8?B?WS9tQkNJck4zSWtMVDNGTkhxTG9aZ2FPNVpEWjd1d2pocWlsSHNwT3VQWmUy?=
 =?utf-8?B?MDNwQm81WStrSDdMVHBzQStRTEJmaWxrMGtyZmRLNTJMaVZPSzR6Sk9LbFA5?=
 =?utf-8?B?UXBsTHoyQTAyTlRIYU1RV0VqWUxQcTVCaEwzQkx4VWtQWkxNTkVRVGdKOHF5?=
 =?utf-8?B?NnViU2l1dWRUbTI1Q0ZOa3VFZ1l3N1JuSWJMTGZ4WEltdWVPTVNvcE1rRVFn?=
 =?utf-8?B?RGtWMlhXamFsdlBIUHlJZWNjTlNqQkpsNnFTc2RrTVVTOUwzSlJCcGd4MGlU?=
 =?utf-8?B?N055VjdaakJhOW1tV0x4V1ZnR0ViTXFrcGJXZUxCUUlUanY2Q0EzV3JvNHY2?=
 =?utf-8?B?bUZZL2hLUUFLcFJGaE9OVG9OL3k3TDVYWEV2YXdJYlcvM2IzKzNtcUV6R0NI?=
 =?utf-8?B?N3RGN3NMT240YTBlWG1YYVQ5bkhlTEhaSkVxUFpWd0NYTm01amkyRGhuN1E0?=
 =?utf-8?B?YzQ3M3hBWWs1Tk5RNDZnSjJpbTZpSU4xbERWcXFwQm5Dd2k0UGVVZnkyU3ZS?=
 =?utf-8?B?WmEwQzI2MnlrWVBBbFRSUUk2WllHbGdCZjRrNi9iQVlFdm5ValBkSndlb3p4?=
 =?utf-8?B?MmNQMkJ5Tll2RktSL2xxb1p1RVM3NDlUa0lVaHpwQnlnR0FqbDF5SW02MmxU?=
 =?utf-8?B?TjZPU0ZQam5rL1pISTVrZVJ1UHFJV3lTRG1BbVVvaVVvRFlLbFlkQTBlMjN2?=
 =?utf-8?B?YW4zOGdRZFVNNzIwT2pvK0ZJZGFtSU1JRFI4RTFXUnVFSDhieXJDUTVSTll1?=
 =?utf-8?B?c0VlMkxMdGNCUDhIRHduL2VzMlpvWXNFQVByaktabUdicEVhc2M3Zzg4Nk5p?=
 =?utf-8?B?RFdyUTBiU2tOeVN4TkUzcllMNENUaG5wT3R5T3Eya0JGeXozclFBOTVybTdp?=
 =?utf-8?B?aE9sN0YrYmRMbXdyNHV5WFlUaVgyNTZlanpnSkhEOFpqZWV4cmg2ZUNPOUUv?=
 =?utf-8?B?eHUrNEFnQXBuaWw3OFFSZS8wUGZUS2ZmWUtjN0JOVUwwUXF5b093Z0s4UHQ3?=
 =?utf-8?B?ZVR0bXpmS3AxR3E0US9wYkl4bnZuelBFNnZhdjhYYk91K2NyWnZ1bWtqeWpo?=
 =?utf-8?B?UzRZckN6N1lpL09tMTY1VFVjNHBianJ2d0lzVE5qbDZVNG5Iek9aQXp3R1dl?=
 =?utf-8?B?YnZERnJrc0sxOEUyNjg4bndaZDVvZ3JrMm00c1cwRllibEdkL0xDMUdCUWxK?=
 =?utf-8?B?WndNZFNtYksvV280T1AyUzhreGNkOG1LLzR6c2crWU1XMlFPcEVSVlpFRnhy?=
 =?utf-8?B?Ync9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: h0NR+Mlqy8LsB0mfXhwHjYzvvguS3SDDE9zwZgHQbmI8KTeCKYzcXeGyhJ+Io8g+K5/lp092/UyZBKdiNO2eOAvQDZCeni9UtxdERIL4Wk3AANOH+9D651d3JFUJ5/uKnHv3O3h0rOeZ8J0en0FoMGxBAcEe/cQzY0z+RYAX3HgNldYwMHE+ZXgikpwHNX7vqyJMXgeJW+LLqboRpX6vGfJCrtOv+MlMhXVJv01FwAS1qtR3uMpNfhlPtWq4TkAyqvc1Bx7zGNl51eeCSeID63ZEOTGB5rH73SLDvq1jYQcjOfoIzg7INTN7rR6PVhblM7l1LQhwNz9lCj5HDWlUjiVIz5LFlPskv38pKwxaAc4n5K5nerpCAjB9z8gMNDnRSGeUEFx5A8pabKUgoJVhZ2IKFgJha46QR+QG8vNABOAFVLPx3xfDoRzeV+QZrpcfOCYZMz+Vu6or7/Dfnm+9/zUKkWAa9UaJrC0p2yYI0TJ+WZndyBHzq+mcMJGk7LD/4pEQ1Ek0Ane15oqItdaSxRNwFBXGqdELONqWVljNPF2RthhwHh9t4Pibsa2TESl29XIx2Xe1TkujkwKQVWQb2Aj6IMTwRb3vI5Sb0G0ep2hazirp8DFo2NL+FWcaKcx+1HfVPgAnganQB5G2cwQOHXHwSaYJPUTKiJHCupfHJNX//3u52G7NdOtm3P4KoQyaEfmzGxIDiDmcVkkMBOCVTPc1Cd/0J0/pankyYetBUVBvnM9TSkfrBDBuaw5/1B8TlClswlxN5bkChjVhIUcPI3M1IAzqwzXLEdd3YzVbmjutsHQvS+GnFmoWE54hfs+mFLkeWN+jW1AQQ8wVBg8rpN67TrsiqNK3MzC83TAnIoeQ/ZixFfx8pCwGS6V1jdRt
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 96040311-af57-41a1-a827-08db6dc23278
X-MS-Exchange-CrossTenant-AuthSource: CY8PR10MB7243.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 Jun 2023 17:01:44.2342
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: gSY9X7Wb6egCHTTtfOWcoVSnfyRplb1bk18BCq2Ra6WZAajEscgaEqJpPkXNE7RabTWhRuS27orsPDONiEUQ6rW+gAtSQl62cHFhCLoTkjM=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB7535
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-15_13,2023-06-15_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 bulkscore=0 phishscore=0
 mlxscore=0 suspectscore=0 malwarescore=0 mlxlogscore=999 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2305260000
 definitions=main-2306150149
X-Proofpoint-ORIG-GUID: fSWdHp6GCUrDBXDwpvnJCs1E_XEwbY9j
X-Proofpoint-GUID: fSWdHp6GCUrDBXDwpvnJCs1E_XEwbY9j
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/23 4:46 PM, Bart Van Assche wrote:
> On 6/14/23 00:17, Mike Christie wrote:
>> If scsi_execute_cmd returns < 0 it will not have set the sshdr, so we
>> can't access it.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
>> ---
>>   drivers/scsi/scsi_transport_spi.c | 6 +++---
>>   1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/scsi/scsi_transport_spi.c b/drivers/scsi/scsi_transport_spi.c
>> index 2442d4d2e3f3..2100c3adb456 100644
>> --- a/drivers/scsi/scsi_transport_spi.c
>> +++ b/drivers/scsi/scsi_transport_spi.c
>> @@ -126,7 +126,7 @@ static int spi_execute(struct scsi_device *sdev, const void *cmd,
>>            */
>>           result = scsi_execute_cmd(sdev, cmd, opf, buffer, bufflen,
>>                         DV_TIMEOUT, 1, &exec_args);
>> -        if (result < 0 || !scsi_sense_valid(sshdr) ||
>> +        if (result <= 0 || !scsi_sense_valid(sshdr) ||
>>               sshdr->sense_key != UNIT_ATTENTION)
>>               break;
>>       }
> 
> Hmm ... why is this change necessary?

It's not needed. Will drop.

I think when reviewing sshdr code I thought it was a waste to check for sense
when result was zero. When I broke up the set, it got caught in the sshdr fixes.
Will drop since not related.
