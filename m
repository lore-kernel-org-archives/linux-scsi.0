Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BCCE2CA0ECA
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Sep 2023 08:04:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232329AbjILIFA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 04:05:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232312AbjILIEp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 04:04:45 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7747B7A92
        for <linux-scsi@vger.kernel.org>; Tue, 12 Sep 2023 01:00:45 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7lfFB028465;
        Tue, 12 Sep 2023 08:00:42 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=54+2f4s/3E4Ly2F47UhFn7/nHk+5b4QsNZeqQjqx27M=;
 b=ageDz2h0vZbbK0QPkRmmmx5dtXOvLN2axg+jaGKAW/5ENqtM2vWMWCKrhfou2e09VcFg
 x3WjLDe+C9x5rNMALUi0DTgU7pkmSR8eDqCZr+QrptPZhMJJmPbenxzB5syWiQRlNRfC
 pBXlxjbz6kQgniJu7K0VvwBbQ3SImg6xb2QUCi9hTYjqDKjLJs8L0em5UOoGKA7Ze7qr
 3HQ5SUJU1OmQBtrqacilgiIJpF1yKyZK3mGh70aGwfWCuWv6qCgNiPPJXWtM+PVyRpWo
 LqX+cP3pRMTsteT/wPk9X/xBWUzNsYQMiniRQ7/eaGZgWoEEhhwxmSLiy8ysHI8DUveT 7g== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3t1jp7bbae-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:00:41 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 38C7Jt0F002682;
        Tue, 12 Sep 2023 08:00:41 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2168.outbound.protection.outlook.com [104.47.55.168])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3t0f5bn329-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 12 Sep 2023 08:00:41 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=M1j0yH2neN6Ggyl5nkG1J4Y1deJF7YY539llFEJVhrpRz4sKHOygOi16acOfpEvmgoK5zl2af2vmat0rEO/yXEhXc5Imm0lw6zwSMDZZLphNqu1jKqr3B5zi5a2Q2Xg94c0ITxICKpzvyTrHRTdkzE+LBD/8QFeqCgNq4nWtnZyNtl5T8N7JPj3SIUFNV65+/e1mNaZN+h5V22cNjPJj2zh3rcbDkJelpewV8Kv/uokaukBr8WNfWj112VVHEFH7Ht1Pmespx5PrAdxeoUFKozDQQJO8NLUDnmGn+DxGMveXQ+KbNA1LpDI+dOGVvwfDcwKEv2VLXlmyKiBri7BqjA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=54+2f4s/3E4Ly2F47UhFn7/nHk+5b4QsNZeqQjqx27M=;
 b=PgfBScPMhLBVktS3WQacBE6V+UXKdRWPa52ryc6qC19/tZ+tUsAM20qv+6ZmtX8XLHzGN+UcQb+Mi67WyvP8SKWPOt4s4anJ70LdFgnYnx+n2AZEzEtRqx2zrksXS1GRTXPQN9g4lpG9nJAhdCsHD6x8AmdfZmQVrnEx686qQQtey3P1EZqQl4qA7ThQnIHmKQ+PZCVYGGIfWMUrY8Hhe0Y0cA2N8DFJtpQo5vw6edMBGV/NtJDSKaK7YOmA8T0V4bmF7BcxNXtkTBJiJx8L3FQvdlq9EXHmbRkuj7qP82jJqve9hVKsD+EY8M0UJ/T4GPwVQFtW0TIG1K8wt0ZY8w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=54+2f4s/3E4Ly2F47UhFn7/nHk+5b4QsNZeqQjqx27M=;
 b=g12MZGsj+rP8NSZQMDhAhlAWOxDkzoDw4NoF4MHIZb4REzZahEzBxdXTkEGrqYnQv/NhNubyY0YtkIBhD9rdOmgYvuKrq2wCfjzkMUAs4bS6vXCGK1yOJsKA1bWj4ibZmKm8FNIOHvsapEj4KAPuiK01ifqV7ksShNSFTNOfuFA=
Received: from DM6PR10MB4313.namprd10.prod.outlook.com (2603:10b6:5:212::20)
 by MW4PR10MB6629.namprd10.prod.outlook.com (2603:10b6:303:22e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6768.31; Tue, 12 Sep
 2023 08:00:39 +0000
Received: from DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce]) by DM6PR10MB4313.namprd10.prod.outlook.com
 ([fe80::ebfd:c49c:6b8:6fce%7]) with mapi id 15.20.6768.036; Tue, 12 Sep 2023
 08:00:39 +0000
Message-ID: <f4c8a7c2-1bdc-d4c8-53b7-a0bdf3b3c75b@oracle.com>
Date:   Tue, 12 Sep 2023 09:00:35 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.15.0
Subject: Re: [PATCH 3/3] scsi: libsas: Declare sas_discover_end_dev() static
Content-Language: en-US
To:     Damien Le Moal <dlemoal@kernel.org>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20230912074715.424062-1-dlemoal@kernel.org>
 <20230912074715.424062-4-dlemoal@kernel.org>
From:   John Garry <john.g.garry@oracle.com>
Organization: Oracle Corporation
In-Reply-To: <20230912074715.424062-4-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: LO4P123CA0538.GBRP123.PROD.OUTLOOK.COM
 (2603:10a6:600:319::8) To DM6PR10MB4313.namprd10.prod.outlook.com
 (2603:10b6:5:212::20)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: DM6PR10MB4313:EE_|MW4PR10MB6629:EE_
X-MS-Office365-Filtering-Correlation-Id: d5f3345f-efb5-4b62-28e9-08dbb3665a5e
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: PArwn+UP6UmKWdwcJ4Icikyu+VMSZRs4wMaX8ZKutijyOrtldihJdw1OQhVdAKKB8K0CZBrtGwfsR6zlREEfv9hKg0ecns8++AOigIczZRioM8VItpvINkAdkzCMmKpG1941ExwQ3fr++ieAt7kaJNGI1wTYrbnCsy9198yaK15uR0w9YBNUCpnIEFCGLWiFQJMpQmnXRYJHSug/pl0e3xuCl/EX+dms1em4k5OznxCacVHYZ8h/sqQvjExTtvJOPawhlKknPbkaF53N5UohYQZfV0N6+KSCSBiP56MGStPQQhfqfyswfekXiepc3fIyMm3CbkGBkQuG55MZ0gqkWlyOyxHWSGiwr10RPLbqZrjIRQsfhH7si/hhdWXeby4S2yuriL/LNrzTiCqZQLbqe3MCpUufnfqFSOLuKBBKn9JP6/emm70BhPJ2rfLWpYAnZhvvxEosHvxTrHD2QFUG4Tpg+qc1rwJ2Vs3arG9fEFyJg55mPh7iGyrbQkitF3lWNFbOzMLsQjkW9sXQon5BKr2LQ3u793AyyMEPxOHqf11u1u4HrReQpnRmBta0qSUw2fZzK5/uuEWelr1AFgCMWXRBuI5KrVS6DWV0BZYPCY8U3XYrz5tJ/8HgF8qdbFCpUUiBF14xhU5LXkLb/oAxcA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR10MB4313.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230031)(136003)(39860400002)(396003)(346002)(376002)(366004)(1800799009)(186009)(451199024)(26005)(5660300002)(8936002)(8676002)(2616005)(2906002)(86362001)(31696002)(558084003)(36756003)(38100700002)(66476007)(110136005)(6486002)(316002)(6636002)(66556008)(66946007)(6506007)(478600001)(53546011)(41300700001)(36916002)(6666004)(6512007)(31686004)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?U1hXUnAxeVZtWjJyOWFQUy9VRm0ra3pBNEMyVDhiSldhTmdwbmJPaWdzbXY3?=
 =?utf-8?B?TmJ1YmNSWWExUE94Tml6NGlNNWFtRW84UXRiUlFHOTBOVXdmOFV5VVZObjJt?=
 =?utf-8?B?cE9DWXczakt6bzE4NWNxQWVEWVNINWJGQy9vWUdQLzA5VllkR29NcVNXYk94?=
 =?utf-8?B?b0lRR3JtdUU2NXZkdWcyS1RJdzRVMEF4K3MvQUNPS2V1ZmJxMlA1ZFlJOE9t?=
 =?utf-8?B?bjZoRGRTSHBEYlk4Z0c2ZnJtWDZGTk1OYmZ4WU5ubDdBREZhM2RsWkZQRWxW?=
 =?utf-8?B?dXZwR1RMWVRobldRbk5tSU1SaTZRYXBuS0xtelNRSXlRWUxycC9lNTNHM0J0?=
 =?utf-8?B?c3BFV0kvODFuNXV2OWkwN3ZON29GbnJNU0RsV3gwdkltNmhMVk9OYURiZmlL?=
 =?utf-8?B?N0dWRmxJaUJ3UHF3Q0xDRDVrVUZscnVSYzM1d05oL01WcGdxUkdJNHNhQjBw?=
 =?utf-8?B?eURCOWhreExVbzFsRzkzU1RseGRNZVlHcE9sUlV4MXE0NTBoTGJQazlrbnI2?=
 =?utf-8?B?dldhb1B3SzJRTnAwMmVIR2JQTklUYVBVd1RVYUpyTmNQN01uWXVkakhrc0kv?=
 =?utf-8?B?bGFrSnFUUzRCczFINkdZOGNUT0ZzV1d0R1VpZ01JVGQ3K0lmV2dSNUgrUzdS?=
 =?utf-8?B?VjZHOEFVNnU3ZjZ6b0t0YUxWYm5nbm8wRTAwbFhDYjIxMkYyNGI4L1pVR1Fz?=
 =?utf-8?B?K2wrdk9HWDZJelFVQUhLY3FhR3g2eFMwWEJ6aUlYdFIrdnNHdHl6Tjhka0dW?=
 =?utf-8?B?NUlYMUVVUUthbDBQSUFHTkhzOEJPSGVzai9LZ0YrWnRIbjNqM0NDZkp5OUpX?=
 =?utf-8?B?TmplT203RlZjNEVNYmtORXEwSWsrN1RaTlZ6MmVZS0llODZUek8wNHVBNDFi?=
 =?utf-8?B?OG5rSkpEbDRTT3dLM3A1KzAxblZmME9pdXBRSDh3ejJaSEJ6WVlkR1QreUww?=
 =?utf-8?B?d2dwYUFVOU9sZ3N6ZlVqTmdmbUZkTmFwRmF5WlVGNG81MXFEdWp3QUl2aFFY?=
 =?utf-8?B?VE9oYVhRamxLNmlydGMrYmhqV3lmbDVMSE14M25oQklNV3I4a2hGbEdtRDRD?=
 =?utf-8?B?UmtIS0dsQ0VhdjRBL0RpYnNDeDJPaSs2LzNsVDZHdndMVFdUOTFuNUhrZjFC?=
 =?utf-8?B?L1F0c1hFV2tJaVVDTlRGWG5pYzlhZDIra09qRmk4MnVKK1YvNlZaQnF4amxD?=
 =?utf-8?B?VURBN2FwMFRibit2S05vRlNrYmJGc2dyRnVIS3FWd1NrV0YyM2JwQVYrQWRL?=
 =?utf-8?B?Z3NFN2I5RWJkWFFpdFVMaUQ5REQrcmdiQldCWkM0Yk12Y1JycWYwemFvNnZk?=
 =?utf-8?B?ZVo4bXFsMTVUNmJUZzdTakNUK1NBYUtOMjA2Z2I5RElaOU53Q29xZnVCaUZw?=
 =?utf-8?B?b0QveWZZZ3BvN3RzSEprYXhxR2N3bzc3ZzNnakhicnZQelhkSzZ3Y0k0NU93?=
 =?utf-8?B?azE0RHlPNU44TFNyWkoyYUFSM2ZRTkJsTjJHeTNOSjAwTEwrTzJqby9RdmR0?=
 =?utf-8?B?V3Qzbmd4UURBa3ltQkUyUitqVDU5NVVHRmlKV0U3bGlSSEJXRVNYdEdLbWtO?=
 =?utf-8?B?dGwrTWI1QVZiUmhjcnJEY0t3aEZCWER5bk5nSFNaOFpiOC9Lcm4yd3FKL1hm?=
 =?utf-8?B?QytoeGpSanlOdXlqRnNZRnhCLytmSFNGWGhOdXpGR3M1YmkzMGI4c1lVZ2J1?=
 =?utf-8?B?WGQzRWxmWm9LRUk4V3RTV09lczhoK3grUVVZSnFEcTVHN2V5OCs5MHJNZnl1?=
 =?utf-8?B?Q0pONFcrUS84N0hyeThTZHpIR1pob3hmc2FWVDFBc3FrODZKT0Z4am8xMjlp?=
 =?utf-8?B?ODl0dEF5aGlVcDB0RTlQYUNYOENJWDNhSHU3NlVLaDRYMTMwc0dDcEpoekpZ?=
 =?utf-8?B?OTVWUDNMeStvUzEwUEhEbTdKR2haSXhiK0hVWlZtaHRocHlHcEd1aEd5QzFl?=
 =?utf-8?B?WHVyd2lPQU0zQ1JjODI3dFIrY3N4V3lwRVN3YWRsbVM1RVpIRCtqd1VJZ1Zo?=
 =?utf-8?B?RkQvcG9rbUtiSm9ZMER6MTRncG1mSThrWmNDZ2RFei84ZEN6bWZ0NEQwRzlp?=
 =?utf-8?B?UHhycjlvWXBKUW94R2tHZTZPSTJTRVhGSUxSRjdudklmRFVPTDFHWDMrZXkv?=
 =?utf-8?B?NWxjMzBucmkxbG9BSkh6ZVpiLy9ZQjQwdWo1enhDa0pWcWl4SnJlUmxZOXUr?=
 =?utf-8?B?YkE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: EH2SJ51Wenndzf3Hl5yQFeDX7l7oDYV+u3XmQFrabUvLq8ugN59+YLBGke5E1ExeQmp8BA2iFG0jsw0ycWJc4FizGjrZ+ktJIBE/xLukzP+BZU7Y31JuHF8L589TwoH+bw6+FKonKJWS5HUsbueCixFpA+ipEBMBiKv3ens0vJbgYB924wG+pkF7w+ZIAjoGzAl4O++juca8oKHyTUOhoOyOq5FLgHWR/5q9sJn/O3A9TInkSCjDDiHOH2L7UqdTKvEAweB64zRzFcEsfzxcBhw+EV1AEpKNSvE8bhVzs61mngB4q6zjBRBHw3UxVm8KkbIodOCtRqi+9zpL+4rMrCCtHbqDqvzrlS2QeTRNjzxXzLvjW2hS+8T7bIW2AyStorLikFPFc4FxFNQpR7f4Vv10OAtT6wUje4hKHg62e/lo3UcgWF0E/F5wnUiMmZnHoVo5K+yQXlDiHuJqEYOjV0qgU4p+kQOVlBJf+FtBFQEqxkrwAOQvtPTFCVzhwLnY9e1XghmrXny2C4bjrTrUf28VgdCoaYjY8hcCuzaJTReCDFR1VcH6AVXhRBU8LxfT5t3FksCYJnur2AgHOjWKkreU+RMOuxh1UgcKN4XD64YC7AgglPpjj999WYQkrcpxdtwowIFSxlLlxmWLDwpXQrPMu+GD9kSoAlv6mum7LKAWVaFP6rifNjm3KapJjFhsj1308l+qmjqdoj9GofiYAvPeeFN0YqNb/hhjJToP3S+RDjJImdKpyAcVZROr/IlRHh9FfvbU2p7OJl3Bm67Fr2mUEDSiV7oq4PYjISRYdGw=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d5f3345f-efb5-4b62-28e9-08dbb3665a5e
X-MS-Exchange-CrossTenant-AuthSource: DM6PR10MB4313.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 12 Sep 2023 08:00:38.9413
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TAg/1KAHUEwGqf1JzY+9R3XzJwqPV4JIlCNZ+yvldq2bbbcaQh5B9k8uWWQ3iCEPuwE4omRuuVwLuv5vL/UpwQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW4PR10MB6629
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.267,Aquarius:18.0.957,Hydra:6.0.601,FMLib:17.11.176.26
 definitions=2023-09-12_06,2023-09-05_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxscore=0 bulkscore=0
 adultscore=0 phishscore=0 spamscore=0 mlxlogscore=999 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2308100000
 definitions=main-2309120068
X-Proofpoint-GUID: f-b2pfTN5r413WjuK2YrUp_ScohcTIgs
X-Proofpoint-ORIG-GUID: f-b2pfTN5r413WjuK2YrUp_ScohcTIgs
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/09/2023 08:47, Damien Le Moal wrote:
> sas_discover_end_dev() is defined and used used only in sas_discover.c.
> Define this function as static.
> 
> Signed-off-by: Damien Le Moal<dlemoal@kernel.org>

Reviewed-by: John Garry <john.g.garry@oracle.com>
