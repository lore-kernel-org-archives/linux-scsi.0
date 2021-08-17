Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 58873C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 329CD60FD8
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Aug 2021 03:18:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237019AbhHQDSb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Aug 2021 23:18:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35686 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S236783AbhHQDS3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Aug 2021 23:18:29 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 17H3Bvo6024636;
        Tue, 17 Aug 2021 03:17:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=ZQtgeWRszkkpieUdTE1rndV8tzP0wuE1DxSW45APCDo=;
 b=ni9YxK9Mzcgtend3LaKDUbDoWmkid/5+04cHI0H8vpx5K7bsVCaer4sCZp0fpxDJssHd
 XH3GVHZ6pxQ446Nrm9NwQyhD1biqftNvFlPqs7y2W/Sd0FeffvJvImTJ10O+m2ZTLeHw
 SgCJLBEwnZmMZEHDn6aRD/8ERTp8cAnLEGDfAIH5vXN1lM1iKsTvPrA512O8f+SWtLCf
 Jo1Sv0gHMZiP5Eu7kj5dkY3kkqb/lGK8RSKMUp2tco5jenw0olgU2DCDgeAa0gvFjoKN
 kPSWD2XDExpFORJp3X36+p+UAv6QICU1Z8Nx//VbRAep/tTx5PMtCQXCVdZ9gA4Q+k3Z OQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=ZQtgeWRszkkpieUdTE1rndV8tzP0wuE1DxSW45APCDo=;
 b=F3XiI6zWyVZwI4Q/41c5TEZaI0jlU7+qFZo8KQT08exJ+XQXsvgHr80p5bYekCb2vRZJ
 +fUJJdThwBvlMuIczd2iJN8xbUpMGKn6olZ571LXbGq6xGz69aQiuNIloAUOhg7HwMfI
 var29pJr4TMl5G7SOStJPfb/L/IAhzF0eN9P9kc3zifR6mxJPYqLo1u8AQgOGR10gXBf
 WeaapRCzG3HQhb5pMdpUimE9DhRqOhgg9pIfWF4nlUqZyDOTXzsQqi512mof+sp+jkzu
 +1jYXQYhzRrFSYiR/uZ4Gbx79lnnACukICdyodMzimea+4QZ03z8FxiSxk95MbxlxiNB 8Q== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3afdbd2y3c-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:51 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17H3Axqb038849;
        Tue, 17 Aug 2021 03:17:49 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2174.outbound.protection.outlook.com [104.47.58.174])
        by userp3020.oracle.com with ESMTP id 3aeqktadm0-4
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 17 Aug 2021 03:17:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=GlkC/k+DME5smXYr3u2CgGwWDkttAhGivMeWoXsSTrA8Wm4dGMUr8NHYX+RgzOjPCrvgOR8D6RHtTLeCD6J1biakfcVQG+2gDGbsR7i/H6Qeff9sF6pPDHyIaAYRXCoyrkgZozNru+KFdNDi+j+HoGQSqXHtl6bzHD35zrwfMjTs8N33hxMWdvy0eFTbK7NMAyP3W2J9uEeAbIWE7kNE5YRyVCQjh7LL1o5RBQg/z1eFxjIuZA7Oxpp2bMcx+qheYldCmSdoAKZYWia0go8nyc1wKWUnx27I1xIWLobZzD80dgV+ahNe0snC0K1R/O4xKRX/FUY8CopM49dw67MPew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQtgeWRszkkpieUdTE1rndV8tzP0wuE1DxSW45APCDo=;
 b=hnN7m1val0NYwM06pYbBFCAciJLcU6XohnN+WTSVKcazlfwgQJtopoTrqMtl9Pv1KCdVIbi80yheUU3guRSSIMyXRI61NYbLN09ZM5fpidm9RpNLpDyFj87w7bNq99Qlj+x5O7dXmmid5xzgyXCP+Z6SuE+JXKYobvxuvvLhRasmV65aQ5ffeYseJRmRDZQI0tAErYpIfBtLgRWFqkQ+GaF/KMyzlhq1P9L4NA5j9azAJLKrNXzorxvKiLdY3Q2gQNprUiXoUlMOURydF3esVVWXxwMMgUdenDInwGOpJIfAzqp2i2AF7UAD2GFg4LAQ8Zk76413bnjziXgBllxEdQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=ZQtgeWRszkkpieUdTE1rndV8tzP0wuE1DxSW45APCDo=;
 b=uqa5ubo0xFecjq007Y9ShYe+o5cj9wwSGBWUwBXVFydpSqLWDrcnXD61mAhHBtS8qXwaThYrysGZgja5I3B6Tt1SYlS8+GOZlizGh68hPmjYtiykAU0dDakG3JzRxH8tLMfJFsC0g2JOrxts3yHonu9U/yQpn5VTmkS5Skt6H20=
Authentication-Results: wdc.com; dkim=none (message not signed)
 header.d=none;wdc.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4566.namprd10.prod.outlook.com (2603:10b6:510:36::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16; Tue, 17 Aug
 2021 03:17:48 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%6]) with mapi id 15.20.4415.023; Tue, 17 Aug 2021
 03:17:48 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Avri Altman <avri.altman@wdc.com>,
        Colin King <colin.king@canonical.com>,
        Daejun Park <daejun7.park@samsung.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        linux-scsi@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH][next] scsi: ufs: Fix unsigned int compared with less than zero
Date:   Mon, 16 Aug 2021 23:17:34 -0400
Message-Id: <162916990041.4875.3103855897095795361.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210806144301.19864-1-colin.king@canonical.com>
References: <20210806144301.19864-1-colin.king@canonical.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SN7PR04CA0178.namprd04.prod.outlook.com
 (2603:10b6:806:125::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SN7PR04CA0178.namprd04.prod.outlook.com (2603:10b6:806:125::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4415.16 via Frontend Transport; Tue, 17 Aug 2021 03:17:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 5176010f-7885-4f9c-3ca3-08d9612d971d
X-MS-TrafficTypeDiagnostic: PH0PR10MB4566:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4566FC5BE4605A03617E29118EFE9@PH0PR10MB4566.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2733;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +/WjLATX1psfevkGew7OiU5wdDY8CJn3AwE6hvNEMI//XDpyPZS+a6/5opzInD1GLiPEntfIVpF8LUyiFpJxrr18K34xS40taf66Ayq1BfUEFf8ChP0eewhP0wJJKgBpauJi7CK3lpGw17zHEyCSfh/Q4sr8eHs6dcx+Gr0aqaVFPR52aYbDxu9QMuMWXpCvZYmXIs62oRYVW0HmzBid64JVAD2tR1DTq1XarEIW2CBhulo5V1N88yV2gr5HKrrVlHcx/rn/C8rJBoCbrUKTbceFcT0HXbYDZzbPqcw/ftmxW+8lZr3NiPH5LtgCT4COB/VelwBGiQ8V++JXUrM1zQH/A6S32mtUvDgBsI3sBUnu7+G2BO98leE2LxT8i5k4BOIiv7mVB8FCu2C6baQFgNTW7p0P1kynPFaW/NwvUs/0czNvJmpWxivEKN6jGI3clUc3QbsTRw6qfXcrgJtmqZNk57Wxuvx0nGtU/dg+xyLoRv2HlY0Ji3ZMnEfuTj7hPM60AuqShxYFI9TRVmoMjc2D4I+axknKP11DnmHW9qsrB1grCgWx9zNxpvBY9MGOg8XXJNvYF2aK3SahWlatrd6YA4slIUDhndJV5aHTf0l8rOXcw1XrjQ7VU39Gj6QCtIZFRJExaia9/+aLf4Xi2mx8NuGZrpCzJTNaJDtZMj+pqyp9QiMtANWVe/NdJ6SEH0X5Yn2EB/Ky9yux4D+zz5BuQYEa73j8xXSPecCsgJOFLAN9A5V7ZpNY2lVXQOcz0op4Q5rUvEwzwkbWOyOhrQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(136003)(39860400002)(366004)(396003)(376002)(6486002)(52116002)(7696005)(4326008)(66556008)(66476007)(66946007)(6666004)(5660300002)(2906002)(86362001)(186003)(38350700002)(8676002)(4744005)(26005)(36756003)(2616005)(316002)(956004)(38100700002)(110136005)(103116003)(966005)(8936002)(478600001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WXYrZ2JCWFFZOXJ3VlRrRmpFOU9pMGVyUi9HQWxtUENIRmkrajFidDNIUU82?=
 =?utf-8?B?YWRDSUlEUnFzdE1KUlJ6WFdZakMwc1hIYjlFcUMzRzlGbUY1Vlg0UFM1ZmZI?=
 =?utf-8?B?SWtaYzBQWlRZbnI0VElMVVU5QVNyY0MrZVJmdXlrZ3hVRVVVMG8wdHNCajhE?=
 =?utf-8?B?ZlN0M3dZKzZPekUxVTEwVnBHRGU0ZFc3cG9UMk5wMUQ1M1ZRRjYzYW9jR1lN?=
 =?utf-8?B?WnN6V3EvWHkwL0JGdTNLVUhDc3d3WEt3b1J1TFR3TzRWaVZwc2F0dmZDSjRp?=
 =?utf-8?B?SUVacjVxMWV3eHdJSXJjQXVCR0JoL1orTVV0aWFocUtweTRPUjBEajkvdncz?=
 =?utf-8?B?a0hjbHVNUGc5MXNtbFBkMzNpZjBnQll5dlFqZGhqWFBSN3NRdzhGNzFpUm1H?=
 =?utf-8?B?ZnlIdUhQaWh6MU8wbitKdjUyb25uM3B3TFZFYWxubFUrYXpWQU1JcDlieUJL?=
 =?utf-8?B?M05CZWl4RHVvZC9ydmlsdXBvT0RWejNKbmRtN3Y4RExGMmd3UE5qZklVTG11?=
 =?utf-8?B?TzR1VmZnN0N2ODRVRjE1bldyVmVGVDl0dk13SGRFVXJZZVUxY0FZNWdEQk00?=
 =?utf-8?B?b2lrUDFxT3dCUy8rZVpOd3U0Y0pycmNqN2RaWlVCQmtUb2Q5eXMyU1JXVyt4?=
 =?utf-8?B?NDM1Rk5kYlV4Z0lLODZnVmlFWXVKc3h4MEdyRUVmQUwyT0hFQVBLSG5nYjNM?=
 =?utf-8?B?aUNuYTVEcHhHekgvOGs5MjJFVCtqYkRMWTJUNnh6QUhWUXhUZmxyWWxzK0lz?=
 =?utf-8?B?NEt5dS9nTGVvRGtNVExocS9hNkthMng2SmJKQXNsc3pWSWs1dFpSY1F5dmpq?=
 =?utf-8?B?eWZtK21qYUJrclRTMEt2TG1tVXplK2RkS2NsTjNyT1hCbk5YUWNHTVA2WGJn?=
 =?utf-8?B?K09aa2lwSmlaa1orWU9FOENkenlVZis0MGtrdVJSNDNiWjVMNlpEWU1rNkhB?=
 =?utf-8?B?LzNjYWY2R2s4bVJTYWpNcmhDQ2xtWTYxUER2RmNjNEVVejJMMCtsdWMyczlj?=
 =?utf-8?B?N2JsZTloSDVtV0JVTlcwdjFYaVRDS0hka0dFRW1rK1RTSG9zK0V5c0RxYmJR?=
 =?utf-8?B?WU4vY2FpQTJjNWNWMUZ3SVMyQWY5V2lrcnNUdVlNeW51ZnRyM3dpbkJNRjdV?=
 =?utf-8?B?eWtDNlNZbWtKMVhmSU5aZFhKM1hDNmg5SVMvMmYrd2F5azJvWGNVRDI0WEM3?=
 =?utf-8?B?LzRmTnZKcEdrNTBRekJnSXUrRGNYODlIVXZYNmZTVmlkOEFoc1dpWG45YXhN?=
 =?utf-8?B?NmRKSkVmbXFuTTlBTFMwSWJqazFTaDBZTkM4ajRYQitYcXdWSGV5ZXo2NUVD?=
 =?utf-8?B?WEE1UnJPN2tqek5hWEY1cEdEZkZZazVrQkZwd3JFRW1TY2dLMmpKNEVHdFZ2?=
 =?utf-8?B?Y0VCYWlhSDBZNmRVU1JORGtCVTZ4WllTcHF2UktpakROaHFwb1FNTHBlNzl1?=
 =?utf-8?B?T3ZQUVpMcS9zRDNLZVlEWm9ENHVERHVrc1NzelVtVzZaNHpnQWdyVUI0SnBR?=
 =?utf-8?B?dFlSaFhIRW5SS2l3VUF4Y3JUUUJYUDJoenMrU1lCMVZ5bWQ2RHpzUnRZbFNz?=
 =?utf-8?B?alRWV3dDK3YwTkhucEdHd3dIRS9kR0hIQ0JRUWhUcExaa2gyVDFlNTRjUjhW?=
 =?utf-8?B?SlNNT1kwejRUaUZsQzlTSEtkR0xQUGNUSnhCTUdXNFRuUmFSY3BOellzT2Nh?=
 =?utf-8?B?RkdKWExCenQ4dmhCdENQc2ppNkJFazlLM3NId24xQzBQdlhqRVlDN1hKRGJ0?=
 =?utf-8?Q?rGX7NpQtY4dWZSkvVHWBIY59GUhkj4spgirApxC?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5176010f-7885-4f9c-3ca3-08d9612d971d
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 17 Aug 2021 03:17:48.8663
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9sNvzUc7qc34iriL/d8Px4RGnpHEZvkKFtWb21ndEpB0WP0m0EeBM/8hMzQDxXwBcwb3J84qCFmEDShjEkkVFBQlHklthsVRW149cU40J5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4566
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10078 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 mlxscore=0 spamscore=0 suspectscore=0 mlxlogscore=983 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108170019
X-Proofpoint-ORIG-GUID: 895600IqzCIoubAaHot0oBq74m286ymn
X-Proofpoint-GUID: 895600IqzCIoubAaHot0oBq74m286ymn
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 6 Aug 2021 15:43:01 +0100, Colin King wrote:

> From: Colin Ian King <colin.king@canonical.com>
> 
> Variable tag is currently and unsigned int and is being compared to
> less than zero, this check is always false. Fix this by making tag
> an int.
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: ufs: Fix unsigned int compared with less than zero
      https://git.kernel.org/mkp/scsi/c/a5402cdcc2a9

-- 
Martin K. Petersen	Oracle Linux Engineering
