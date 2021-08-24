Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB8D5C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AD7226126A
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:29 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229871AbhHXEEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:04:10 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:10754 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229713AbhHXED7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:03:59 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xBfE014822;
        Tue, 24 Aug 2021 04:03:11 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ngkIN2tuh+af+sxSkkrn8inzufgjGoJK/rSUGJTouec=;
 b=LrCl78hd8wG8hO1rk+gWjkAsgeAxWRE5jLsnl9UfDUNteXL8K5yoLi3FUUYA4Elx0rvn
 +TOdGIcMKN5cwOAWe1J8lgdWOnu04Hn1/HxyNQ9aWi9w936nhMpn6vStU1OEjZHpvSNe
 MKZTja6kUBXsx9TT7gCjmQ4cbC/zMArNXw3UG8BlQvZttwi1hZwmANeN4kzbOZ3DTgO+
 c6YodK6RCgr3DMBdtri1zKviYWKoylklKWUSE5kyLsBl2Bw2dBmi/VuV+xVIWRm7WJFJ
 /kJuGfDRdZXOopRXYsg7piJqAQOSl7hYRAV1f1ChQnqteXRGQJd7G9OrIbqgu9dgLazO Qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ngkIN2tuh+af+sxSkkrn8inzufgjGoJK/rSUGJTouec=;
 b=bEV+x/uq2tIRIXy4Qpadp0qBlnV679yA3/UWuVZMZAoBQrUhv16Z0LRtR12a4+hhbbBs
 1pLmrXatbJipTuco8Nu4e+8IFmcH8bseWpbMmNB7AS70oaAS3G77H97sgb2wxp0z+yTs
 ntPxFiv9chjA1k4hu7JiYoETOatWjVygnFB+K7Thj65tkziYPJLs9xwAOW67jEabcw5E
 1iTVSLaXPNxexNMzwLrOqtrd9ctLpCt9MpGA22Dhz/Gq4PtbzL1TkQJMEX4zevp2tdj9
 bebNgUdJiMCBojPF8kwqHDFvGdO03PPpxGdNNOv7rU1ehihvdER3NcRJ+D0WySV2R7ml 2Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akuswk9j1-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:11 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41N3p082500;
        Tue, 24 Aug 2021 04:03:10 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3akb8tya34-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:10 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NiqVsO+yHEHmFJIztw0USzFhHkC44wmTRpuTL8YCXhjwwfOQpAuLgjXeCWh7ftFybCngz769GtlHHr1GXn2dGc4blon0XDBqDCsUC++orZ/zL+FQ3NZV9ZQ8Ba567UHevv25OKNmtisTa1ZJ3fZw/d2nAssQ22wSbxUmSbffm9miXrBpzxRTrLMx77RZRnDU+C5yqHY7qIIoxx5bEH5mMza2f0btjrp+xqJE/5CgGHOL2mESV6S+0f31ZoEXYuPEfOMvhCLyuCVU+G+RzAmSoCAR9hzvqiM8iOeku2cNIoJBLQ+naINu2B2qHe2P0La9MsO0CX9tF7g2EmXyiF9Shg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngkIN2tuh+af+sxSkkrn8inzufgjGoJK/rSUGJTouec=;
 b=XbdFLL08XC0KUYv659uak+r1nMmidAM11anKLS0crsd4h4pw/HGnHJJJQsidqt7bVCvGKe6HuDCsa2gs6ZvqbPKKsKGcf/TrWbMjeN0Ukv3hmYZYfz7eZoSPNO7F59tkpn3S4jO3NyXOrc5TXlPNPpA90Y74q0XrfGEM7NEOwX3Y8aJrM2JL0z2ifOktokKP0jGaS1f3kdBbuHfaQDL5VUjaW51w6bm2SQiy9yOo06jA0SdJAffH/2LoA9MkPlNFNIFVQjhaMXR2qDK70ZfYN4BuNOx+2xJfByKwd98t/JscVaM6vWEtgqdSUn+xMTOzIg2jfhiaHzLodlX3etl37w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ngkIN2tuh+af+sxSkkrn8inzufgjGoJK/rSUGJTouec=;
 b=yQa5fhzzFseTbdJIKp3MPJcC6yfnJC+v6tV5jxApUIkGVm9dEb2NOufTNd8z//dLDMyVVJgMil8E84KykeGdhvWlCL9blNscDOT2yQBm04hGmL7I+YgdVJd2SQzpAVOXHgBOk4kAoOkhKd+fcNAKw5wsi4hVrXXwpgyer6TTKbA=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:09 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:08 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Don Brace <don.brace@microchip.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        storagedev@microchip.com, linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: smartpqi: Replace one-element array with flexible-array member
Date:   Tue, 24 Aug 2021 00:02:58 -0400
Message-Id: <162977310550.31461.13461113082507282975.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210810210741.GA58765@embeddedor>
References: <20210810210741.GA58765@embeddedor>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:07 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 21c4c3f4-1497-4241-2290-08d966b41515
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB552962E3C0A30B5ABE73B8488EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: d8/OikqhGfiRpT+IRttUD/oQrwrCtcRR8GEXqKk0WKQs3MrjmspgI3yEoROfbwjZBoHrziR7zOAxTIGuXPFFpwP/UTrVdCz8QG8zjyGjQHjxOaBY7cT9Hxn/TVkO5MLvQoj6EpsU/NuUAD1WGUwk7rlbC7BqknJxODmnqKReIDB917RKBBddUXOX6dWgZq/cCU0w5DGvijZq3Nf1Ij0qTytjlDFA7SS4Py/gy2sr6FUNXtxvUi5Ln1THVYJSm/wnqiMCKuIOJWNsdx0ToYD/MZHu/P0MIYOJr/58Rlq+ALz6dCSULPIFfP1SGPcy6tDykefafM17iLpYNUjxjHwdo1oaW82WqlZSWbpytQczJSbc76R28jHc786Xg6/TMstBlskM8befvu2drfu9iPbd4fGPjDjkPjfrHM6ApPkbgPO8mFr0BfwS9mVppf7m3jAWB8utac/FxGr+zdmn8r3q09M6A0dcnWgJv0uBzh+ULSqmp1Wrdra6/hvVfl8Y/rDNCntyzZesnz+6OV88B/l2Ub5ocKQZkvQi7wNxypHjqSIOmz/9/KdAz1GwJHWskIzXNI04Y6tpUZDi2e7iacHvAAVhm3yOdI7wkLEJRY0bVbEzzNETacI2p0btELb4C18IRxYt0zGcLPoKDqbHM/orMAj2JuuLl9s3w7mDduwXRJp5QHWND2JzI2w4X9Db37/lzgOijrcS2y+H41X7W91wnL+5ErQIxyoh33WChg0y97fedkg4LI1vZYEdUCE47EbuKTkPbGtnoCfFNHXUzoj5tw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(8936002)(966005)(38100700002)(6666004)(6486002)(110136005)(7696005)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(36756003)(86362001)(8676002)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VzFNY3RZVlR4NzJuMXIwZUI0R0dFaDBuTHIzUUFRU1NZeURCa3RYOEFBVmRP?=
 =?utf-8?B?Mnk1cFF0aDVZUjBjMU5Yd0xqNURDMURYeVVneUIyN09FN0NkWG1ETUgwNHlW?=
 =?utf-8?B?RnduelM0M09KQ3QxcWhEcFZIRkp1dnlqcjBnMklkMFdxOFVKQituMnVudXZK?=
 =?utf-8?B?eWRwUzVwWndkTXpBc2ZDNmN1ejFOUGMveDJyYUY1Y1RhRW0xWXQ4aTJVNnNw?=
 =?utf-8?B?WDdGbXJpV3pqbHF4SVhFSGZxWDlFN05ON3FnK1I4blo1ZGpKYkc0eEIrcVBp?=
 =?utf-8?B?ZmJ6ZXFBdy95UWlWSTVHN0hFLytJY3Z1VDNldWxDUHBvZDV3UGxhdHhvcllp?=
 =?utf-8?B?bnBqeU1rcFpqTFRINHIwV3VTd0tsV3JDQnNKTFBmaGFaVURqaUhPVHNmcnFr?=
 =?utf-8?B?MGxhNEF4aHBYVnhMWnFzUnlla1dlaVBxS015QmkyaE9jSWJKTk0zT3BQcDlK?=
 =?utf-8?B?OExSWHZxdklhU1VmMlFVdGpiMk1UL3l0WkZMZ3kxZzFnL2JQYm5SeTZNMjFM?=
 =?utf-8?B?bmdTRmI3NlNtU3VtZjB1UGRNa1hnQXllMEN5SkhIaVNhamN5ZmxKK05RYWJ1?=
 =?utf-8?B?MkVDN3E2NzNvdkJRaGNNZHpQODZaK3VWc0o1WHk1Wm5KT1YyWUJKZVBMWnNw?=
 =?utf-8?B?aS93SGpPWFdnazI2UXBwRnRyYUl0dXNvb3FZTXdNeGM1L2dsVTlDQ3hsL0R5?=
 =?utf-8?B?dWE3YWJPTXM1bmhFTkpBUlUxdkdTYWZuaUFmOWpjMXdyajJkMVMrdmppRE9P?=
 =?utf-8?B?ZXdYWGxCY3ViUkN0OU9hcGRkMHNRdlQzaWNRK0F5cFdzK2lBUm9CajhiMHFH?=
 =?utf-8?B?cTl6RmFZSHhSY0htakFxaUxQc3AwY3FvZlFpZklYcERoMWI1YjdscEVDSy9W?=
 =?utf-8?B?ZW1xeEtQcUN3bzFyVnAwWXY2enl5TjdQSURPTWhGQU92bnFjKy9tb1JaTmQr?=
 =?utf-8?B?MmYyY0ZMUm5GSEc3R3J5K1hhb1Y5eHhzL0k5WlFoTWpkTjJmNFhwVndqdmlS?=
 =?utf-8?B?NW5HNGxQOHRUT0hsMTh0Tzd2Zno5NjViUlh0L2NlUm1MakRWYUJoZ1NiMWxq?=
 =?utf-8?B?Q0JTaEQyeVA4N0VGMVNSVVlyNHo1UElwZmRESFRXRjJHa3BxbEYzSXRDMW5N?=
 =?utf-8?B?emtnUHl1a0F0RnlURWpjWnEyejFCRzFYaFByZVNDQkEwOU0yZGZ5dW9nTnFX?=
 =?utf-8?B?ZzdrcG0yd0t3Q21zdEJ4NUFIVnlja3dqb1lyc05oZ1dXOFpRNDlTSktUWFBu?=
 =?utf-8?B?eTdSZU5tbllDdWs5OG1zdGh2K3ppNys1ZENpSGkrTWRnNjE5R0p0eHZJb09y?=
 =?utf-8?B?SU80cVRGTm5iZ20wQWxQQ0JKZUdSTWFzZi9VNEVFYmd0YXk1aEszVmF1WHd4?=
 =?utf-8?B?ZkRUU2xLMWVnYnNvMG10Vm9iRDJNSUpnQ2VaNWRsSkxUZGV2bXlLaWFYQmtY?=
 =?utf-8?B?Y1ZCYm5Kdm9MODlJeVVEdmhCb1VESzdRa2NYM0RrWnlIb3pSSzVXSEhuTzVv?=
 =?utf-8?B?SUZOem5Zdndsd0wwbitoMXlEMjVveS92Q3Vlby8xbWlZbEFkRTk4UDRzTE9X?=
 =?utf-8?B?L2owZkJ3TU5QQUcvMDE1WkFRRzVlYVQ5Zmo2aVdxd1NkUzVwRFBqeFVaTG5J?=
 =?utf-8?B?M2MxVkhzV0NlN29wVllhQSt1MDlwRDFNVyt4dlJQdVpNcjNTSWpmVzNoTU8x?=
 =?utf-8?B?YkhUYkdNVmZkeXdBV2xWZE1EMW1VblZYdGZyQW1QcGhVUE8rQ011L1VFeVhn?=
 =?utf-8?Q?11T+4QHOdWhqQhapF6/bIn8Cbm2527ycuVob7hE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 21c4c3f4-1497-4241-2290-08d966b41515
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:08.8058
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I+wKbdWUY3h/aMhLpD7WuVcvm/GqNXhqZgsP9QTcWUWiILwQgp0YTmY/+Gj4XCN4iOQRHrg1qXohcdv+lM72oeqB/EBJSJwpw5TCv4oexTQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=855 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-ORIG-GUID: ZaA3PATrf78J6JjiqVj9cUeH39qWZ5TF
X-Proofpoint-GUID: ZaA3PATrf78J6JjiqVj9cUeH39qWZ5TF
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 10 Aug 2021 16:07:41 -0500, Gustavo A. R. Silva wrote:

> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code a bit according to the use of a flexible-array member
> in struct pqi_event_config instead of a one-element array, and use the
> struct_size() helper.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: smartpqi: Replace one-element array with flexible-array member
      https://git.kernel.org/mkp/scsi/c/5f492a7aa13b

-- 
Martin K. Petersen	Oracle Linux Engineering
