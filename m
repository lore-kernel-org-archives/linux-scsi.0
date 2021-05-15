Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2C1AEC433B4
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 18:15:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F02806127A
	for <linux-scsi@archiver.kernel.org>; Sat, 15 May 2021 18:15:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234377AbhEOSQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 15 May 2021 14:16:16 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:37346 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234189AbhEOSQO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 15 May 2021 14:16:14 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FI9TvM135067;
        Sat, 15 May 2021 18:14:56 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=14F+NZxXHhzYECL2MNw8l/780IijK+TGVRUV4nQy224=;
 b=r4J2gJ84xYrjCDiAwaasmrrIQNgq7DieMRizrFvAk1f54doBFsTQ1EFRQpSaMbLxg5x+
 7tOftVeLa8yIZWhmMubyj0dTJ6vFPVvbh3NI7HLASvAG56NVT2JSlKf3LhD8gpw+lt3/
 34dnL16eGHlTtmWM4iUfL6cfiu9ULKykTX6ttREMSMuhN9Y87nLVZD8nQXDupL99OZTT
 nQd/mfeK2SCaHUNS5KaFK+rTmGmFVJBf8OvblZxKKS+WkVVU1wWGgRRUbUAjTQ7vQIfL
 9FJMtbyrrbFNBJGbg7H7b/WecPtConeNWBv3ab9rYoASs9hSnkxUHL0WVSskffTaHjfN Nw== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2120.oracle.com with ESMTP id 38j6xn8knv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 18:14:56 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 14FIAGSn128741;
        Sat, 15 May 2021 18:14:55 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2106.outbound.protection.outlook.com [104.47.58.106])
        by userp3020.oracle.com with ESMTP id 38j5mjjb3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 15 May 2021 18:14:55 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=XYe5cuBtxD4AS/8kc9Rq8nuvshmiue1e/nHp7PKLGiN/1oqzai6Ui2EFCr0gj7qP+SniL+piY1uI7rIMpnsTRqAb0Kahxvu9jLUIkiOOgQb8P9bEJFTVW9U5XVGLOiHfHKYSrlJ79UCeRxpTW1zWtj/GswLWEllGEB1VaCDQdvZDidyEFXqmjdKAS3nl13+wPuHwFLJ0AgmgTlfvrc9qnSrzXQXV5UTRu0HS21ChoowHXoSAdOj64DiDYRsFwTgIsw1poZJndYceRMfJCIXqPFbahj1IM6Jp4F7hd9XWp/nU/7GIEk34lJL+5VwKQZ8OipSpYraTe1wjJZNRgSF1mg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14F+NZxXHhzYECL2MNw8l/780IijK+TGVRUV4nQy224=;
 b=a7cPS+3sTgoHQ+AKvz9W0RMtSGMMMzvrNjRt+HntofM7Z9t/fNhlDtN4HUh/rDzZd6jurMOMrIZGSnxsv7x2Hh4bR3lNTUbf/d2i9UasmSDcFrN+SNrYHrJcp85W7ThdQ5kfBgv33pxpulNUPYLx8o9udYuhO5O0UJ11D84cnkJ7hmLczakJuOaeHpFrtGOcJcY8rllmUdXVCXMcJioQ3Fqz322dvkp+xm2XpPy8Qg5YGIXzo8r7DkSfld2ppzOqaCTjRKBVWtv61IpblPQqTPVvxEc8GF1JmKkEijgHbPvmCpy3SKUtEPES80oPJCZW4d2a7CwTas6yVRlLH+LEkw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=14F+NZxXHhzYECL2MNw8l/780IijK+TGVRUV4nQy224=;
 b=fZgM0EpqP/XZdYQeCBTAVd72y724VbK/OI5+SLNMcirrX1aJVW7eXmObEw6gSaH4ZMxP99MiSiScnIf162vGaxRGCdpralQ1VlpluT5naeVSPPUahhUWiwUxuHw8FXORu7aLuwOzWH/jy//0eI4vzYBCz50AwI08BV1ln2e9PoM=
Authentication-Results: yadro.com; dkim=none (message not signed)
 header.d=none;yadro.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4630.namprd10.prod.outlook.com (2603:10b6:510:33::23) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.25; Sat, 15 May
 2021 18:14:53 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4129.031; Sat, 15 May 2021
 18:14:53 +0000
To:     Sergey Samoylenko <s.samoylenko@yadro.com>
Cc:     Martin Petersen <martin.petersen@oracle.com>,
        Mike Christie <michael.christie@oracle.com>,
        <target-devel@vger.kernel.org>, David Disseldorp <ddiss@suse.de>,
        <linux-scsi@vger.kernel.org>, <linux@yadro.com>
Subject: Re: [PATCH RESEND 0/2] scsi: target: user configurable IEEE Company ID
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1wnrz984u.fsf@ca-mkp.ca.oracle.com>
References: <20210420185920.42431-1-s.samoylenko@yadro.com>
Date:   Sat, 15 May 2021 14:14:50 -0400
In-Reply-To: <20210420185920.42431-1-s.samoylenko@yadro.com> (Sergey
        Samoylenko's message of "Tue, 20 Apr 2021 21:59:18 +0300")
Content-Type: text/plain
X-Originating-IP: [138.3.200.58]
X-ClientProxiedBy: SJ0PR03CA0327.namprd03.prod.outlook.com
 (2603:10b6:a03:39d::32) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SJ0PR03CA0327.namprd03.prod.outlook.com (2603:10b6:a03:39d::32) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.32 via Frontend Transport; Sat, 15 May 2021 18:14:52 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: a5b02a5e-45c3-43cc-425f-08d917cd5647
X-MS-TrafficTypeDiagnostic: PH0PR10MB4630:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46301154200EB795950D76C48E2F9@PH0PR10MB4630.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: nXGPFz9FFcdSOCqJaO7DwKsvAbozyB93FsM/wm0esbVXMXhchgPlPGGAnzOcKHtyB2kWik3/u8465LCRko0ccLcyGjS+FjK/MMX1L98T6y7llH8iyfVsvMdKTCPHyKln8X0yj0vZswEbWBHN9r1w0tbr4TZsbM6TfOsoq/aOTObaYK+y9NXFUKiLBy1Afx2a1fO+Hpro9IdDtkYSYByeAhqJmalfll8Z5j6Xx33J6aAyKrOIz5Sw6XNyBYAsiw6IvN/K+s3j85bQDbNUIwCWDdMIBEiaZeHkeJKvWryu05kIieAgGX+mLfeEi+UT53NQb9kVx5Mxjqx4I2gr19/9UiHX41VBc8gwoI00C3NC1Hvyb95k0zjVttucXyxOViQ0+hEX72TV2/9cEZHBMabutYzMkNx+XojkAvKd+Cz9cVNux3jYIxPZy0wMGX/bwiRzlMbTdoGT2C4sk9StGeJUuTmGPTYNmjtcLZlr3I3rG5T2/KfOIIX37Xqy4lD9UhZxxFv0SO4PzMue6shSR8WBCe5WVcXnTLnw394J6T2NvXqiaOzOKNFcV4FurgtXfdj5xhjpjRhtXJYKEIe57lE6wfJZyDfp0w4+ofl+5URQFod1lVwI4E+1uaNmEYj8/gwuzHJ7M6NGwh91YSmnj6D3BQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(39860400002)(376002)(136003)(346002)(366004)(316002)(8676002)(55016002)(8936002)(186003)(54906003)(956004)(16526019)(2906002)(38100700002)(66476007)(38350700002)(6916009)(86362001)(66946007)(36916002)(5660300002)(26005)(478600001)(4744005)(4326008)(52116002)(7696005)(66556008);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?us-ascii?Q?kJFweInC3ab9dzRV22kwnM28x8LdE2bJjW5Ghdc+KLX4+o39jSnl4iCFqp90?=
 =?us-ascii?Q?Utn02MiNP6vUdyunlFtqTmqqnXICMT0mCV7YS17EFDaT9ZspLYOGQQjOLd4X?=
 =?us-ascii?Q?RiXCCGMWxThy2NayIje67HtZUC6O8gW8Mchz9g5qBxPpKuWRtgemUPa+KSuS?=
 =?us-ascii?Q?X67vpjp3CYHChlGqferjwVsX4oKq5EvrJw/JEtRPtBGWefCoiYVh3q0+p2ab?=
 =?us-ascii?Q?987Ra9TMax7RP+SrMmUq8/mUKD+gdna+8ksw2YHb10TShoHbJUBGQaDMPYTm?=
 =?us-ascii?Q?aio4E55AyMchloStnUL0CvpODzmv/2R6mAFPeNZy5nea2i+uzRIWKxJoXilw?=
 =?us-ascii?Q?yUu57/ZeMDHJdWccEyEXNgMMX64ofJoQwaHA7RaTN3ZjBMNw5nEZyERwf4aR?=
 =?us-ascii?Q?TJswY3but1kM2sAq+XB+V4eGgBOp27eJyu1en43SY5U/86KABdOMtzEU+dXu?=
 =?us-ascii?Q?0efw8DeTKutE4BxeSjG4cy5LFiWVK6R4AP0rz+C4tv8JgzzWc0CeuxQRNhpk?=
 =?us-ascii?Q?l4A5u5VER3r92kNwcY7xvMHtvZ2HyNukjVwsC5K0INUXiBd3tBbkkQtFvf+V?=
 =?us-ascii?Q?S9FiR/Lxf7OO26iUNivjsydLQOn3EGV/FTVAeHcprzoL8XpwpH6uC9ZFE0O7?=
 =?us-ascii?Q?EfmasO1eKQvyjC1kDySU8xBRCZKnXNdX+FHjzMMJoXPI2sT1IRridqlwH5fF?=
 =?us-ascii?Q?/V9D4pafjRn7aCGkUHC93T71iFyg8tFhEQLTTwRYFG2A8XDQU12MzFwGjJS4?=
 =?us-ascii?Q?LuCwlM5agGzzhJKB8XEJOSJ6y7BeWBpcYTZwPAcIX2cxOmrTSRYgd/m1sILs?=
 =?us-ascii?Q?KHUFUiBNK80YWMeOcH+DsP7p58ZsexNhC2Uh2UKRb6CnJXuDCxEi0uOyfBxH?=
 =?us-ascii?Q?YmcDSQUQtvFQYCleBrYsRasYJuhtJGXM9WX7J4dRhq3MebVY4EUeUtOeGEaM?=
 =?us-ascii?Q?FhLFdLOjpmfGval3q33g7RwV+aEd9uboE3xEXVJBPwpiUH08yi7ae9hLjiNY?=
 =?us-ascii?Q?hxinTdiDb+h0BUSfxcuMziOeBt1Ag1IuoTWmox2Owl7TDC7thGFJlpmkFcc6?=
 =?us-ascii?Q?WHgdgQYSAfQs1DIUAnKl3/tz4dau8qvXEJkRbBJPxQeOjCX3hcu1rK8Vp+zI?=
 =?us-ascii?Q?fbtDau3GBemZartCF3DDZTygunXSuQwW71lkbu5Xd/lQjbU03kzY/O2L4yf+?=
 =?us-ascii?Q?d4uiXz4+eXAvCMoNugGxG2bl3jwMKAYeIYBfRvXMd8KBDZutNJhTbuMmQY2P?=
 =?us-ascii?Q?8JMBvVRIStDSEu4tbjCMq24NwQNc7h6WAeLbektqCT4x9uaoAdZCwwqzRXqB?=
 =?us-ascii?Q?+ueQ4tVal75JA8P3V6OXosl+?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a5b02a5e-45c3-43cc-425f-08d917cd5647
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 15 May 2021 18:14:53.5907
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PQduSaVCft1SZyzZvFmdGOUku6MHIb7GE9zWfo7pWM6e3aqTgv85lCdMSCGuMuAgjiwzR0kjhS8TPvz+gIZvI6psDjelA3SN81bgiKjYsnQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4630
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=925
 malwarescore=0 phishscore=0 suspectscore=0 bulkscore=0 spamscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150139
X-Proofpoint-GUID: 9hqL9Kn1ssRMFaEepgA8MdOZGhRhCEl7
X-Proofpoint-ORIG-GUID: 9hqL9Kn1ssRMFaEepgA8MdOZGhRhCEl7
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9985 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 impostorscore=0 mlxscore=0
 mlxlogscore=999 adultscore=0 malwarescore=0 priorityscore=1501
 phishscore=0 suspectscore=0 lowpriorityscore=0 bulkscore=0 clxscore=1011
 spamscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105150139
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Sergey,

> The series allows to change IEEE Company ID component of NAA LUN
> identifier returned on the SCSI INQUIRY VPD page (aka WWID). Company
> ID can be changed via the target/core/$backstore/$name/wwn/company_id
> ConfigFS path.

Applied to 5.14/scsi-staging, thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
