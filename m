Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60C14EB64D7
	for <linux-scsi@archiver.kernel.org>; Thu, 29 Jun 2023 02:20:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229891AbjF2CUw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 28 Jun 2023 22:20:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53882 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231953AbjF2CU2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 28 Jun 2023 22:20:28 -0400
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 598493C22
        for <linux-scsi@vger.kernel.org>; Wed, 28 Jun 2023 19:19:46 -0700 (PDT)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 35T24LGd016701;
        Thu, 29 Jun 2023 02:19:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2023-03-30;
 bh=yZfwM4YnjS4jypka3+6Z8Ba73jeRTvJugtJVlWUrDsU=;
 b=dnxEsQiYqFgQ9GuC5QrwWkRm5RcTpHzAV7pKV77X5a0w/vkYWuV4B54QQPKIk+WEdmjr
 CQ7OrclISl7m0ZYA9yNLrKbkjUG1rK2C6hU5y97qbJJvZj3RgNu+GQKiPwzwYY7iME7m
 2/2BTWprCE/NMapnedLPsglREv0bSVAwGIcY2MqQgZRpArej/EbLmptWX3G7MepHAkT2
 OcMDKB/AETDo2jeJIRe+6CisL1BYf+YnbjT7QEDHKKuPQH5vfkvvWawVymus0+jhBi4x
 I3MR4cu6sue1nQdo200CTB5H/ClWnznS8ymCN5BVtNmCgE7ysj3mM5XSi2v5jppu9mVe Xg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3rf40e89w0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 02:19:39 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 35T04ahn008668;
        Thu, 29 Jun 2023 02:19:38 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2101.outbound.protection.outlook.com [104.47.55.101])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3rdpx6u1n7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 29 Jun 2023 02:19:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ZcwFgeDjEeNh2hvvDPIScxhkWJ2skngqdoAX2BhkepYaGlPkbaIYCQjD0RZe4phBIp7XBGet6j4OZNSUuYbNhxMHI9sr78CQZicrkB2tC1HjJmGtxBurxDY6EEcb9MOESny8LX4LF7LW3enoQLnpNqAzef6Mh6swMgaKO0ZAtQ+EoXolZ60Okx9WkFVmlBd2rgu1sa4GcjUT/8JEJ+IzHY1KrPL0g04cge97GQWIlag8PyK58kuXTvMUvsJ16Wwr3YkxaA0vTOs7oE3F5xAkXNbvzkEJgMwJfUhSKlq6Lz7D9MPl+Ta6Sz/EUtAYCXRZHsX1gvXr9bc6orUZP+ZSSw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=yZfwM4YnjS4jypka3+6Z8Ba73jeRTvJugtJVlWUrDsU=;
 b=OzqMjMOhG+Y1v7BAkGkc/suQ5Azcr0te/EtXeDOOLv0Gfx+4WOsVB7B9SpUjTbgSZDtAMyNCiI9qJGWbfQhOuZGnWZYiGgV+jVyGn+FrgBOX07CiRWMWL29ukyq4BobjiDYZeXBxeolxWSiA5KRD6+DnuhPQCSzy8VE8Fjfyr5O4AOuL/RwGxrTPTHLfEv9n5jFqd4/iMpCAd9Ks3VaABknoqo87RptK9XjOCyJTg3lhMoQr0Zujs9BANZiFU8aShpd2PJPHg4uzNNV+Dfu+li3uliNT++/L6azvdjCeIswt+Lwjvj/lGtCyUc6VhvKptM267rnv0ikQlW1oGOMLeQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=yZfwM4YnjS4jypka3+6Z8Ba73jeRTvJugtJVlWUrDsU=;
 b=Ce1+eOCYyhQ25H3JaGEZFFxj+2/gGxMZYulUEhzA/5mUAAq65dGCKLnfKq7zrbXQS3EbVjw0/nuubuqRAiUQVNZb65Mu0nwigrd/YNRjvabmEsSd5Ip9oCx3R1ibr88MN/mYf7Mv6Hr0SBxCTp1to87hYKs8cGXv/6nBB3PWD9c=
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by SJ2PR10MB7013.namprd10.prod.outlook.com (2603:10b6:a03:4c6::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6521.24; Thu, 29 Jun
 2023 02:19:36 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::b77c:5f48:7b34:39c0%7]) with mapi id 15.20.6521.026; Thu, 29 Jun 2023
 02:19:36 +0000
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     Daniel =?utf-8?Q?Rozsny=C3=B3?= <daniel@rozsnyo.com>,
        Bart Van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [RFC] Support for Write-and-Verify only drives
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq1mt0jnhnu.fsf@ca-mkp.ca.oracle.com>
References: <c6499ed7-d049-5714-f827-734cff3f6305@rozsnyo.com>
        <eca63b83-1cf4-40ac-114d-f23acc7cadea@acm.org>
        <97f19b02-045a-825c-6a30-18fc3dcb35cd@rozsnyo.com>
        <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org>
Date:   Wed, 28 Jun 2023 22:19:33 -0400
In-Reply-To: <f6e5e9d2-3446-ef52-a090-4eef1bd2daa3@kernel.org> (Damien Le
        Moal's message of "Thu, 29 Jun 2023 09:02:09 +0900")
Content-Type: text/plain
X-ClientProxiedBy: SJ0PR13CA0048.namprd13.prod.outlook.com
 (2603:10b6:a03:2c2::23) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB4759:EE_|SJ2PR10MB7013:EE_
X-MS-Office365-Filtering-Correlation-Id: 0614eb65-8bed-4adc-f7c8-08db784748bc
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: irEsQ680inbkwRGrvpTIWcs5JP/NYFTQa7wTG4ng+ZKxphGfo9yEGAFwKiF1LAxZIKWM7yh/j8PcS1Q0BYiNaNXsv758yUAn1zNFlaZTIS9CEl7bpNCtWcBs13mIGvG3+UW5tFvia794J79oD1Ly0sDvgOq2QUqG2cCWSbMCMyQ3IN+p5vs/m34iNEKG9IHgQHokr/rrZRcx9vt1VNN9XemDaiOhUC0XnJ3MH7tLAP2B7gWAsYq+K0O3gwH4ZJ1ekMZMUriur5sLPBqAbZu47WPN+jrwJ1dsiGlguhR0bsKCXYNFsnUDG6jctqzGm/HJhU+qBY/tg4AKmha/p9xP7Pv5s6EN5dx6eQBquH3oyBLe6LKlexm7uwpJqy7O0n9ydniq0AxbidhXbE8Vx6YeUOrG+S5JZY5l8x6LS81dZk1wiPsMee4F0EGObhAtr0GhxtVMLedP30BqVyOpTI3PK99DKQ5P0b3LpLiicKXlRELSNzObFxT5tFXcQDiWytX3fg0hIDC/+ARpzgYgdxuQuDEDGLl1SyBpFjYPFj0cRsvi9psHPvF7yPYjWVGAlCO3
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(39860400002)(136003)(346002)(396003)(376002)(451199021)(186003)(2906002)(4744005)(36916002)(6486002)(107886003)(6666004)(38100700002)(6512007)(6506007)(26005)(54906003)(41300700001)(86362001)(6916009)(478600001)(316002)(66946007)(66556008)(66476007)(4326008)(5660300002)(8676002)(8936002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?v2N6BwTDThDCXK9US+eQwC0SriW+uOHjMnVkL3emZCZldXsfXpZubFH7uUgC?=
 =?us-ascii?Q?GalgFCFPhN5j0MPNnuAGqehsUNF9/ENhcLWhYjncwFxpASE6IMhcpb8HEMrg?=
 =?us-ascii?Q?OFW7H27Iq7DR2IIHXBg1jjhSy8RCL012S40oRFH5Mx0++/Y6S05xw0LY9zXX?=
 =?us-ascii?Q?rS7XqvA0hKwoEXIPi3spostdFj5UM5rqqW5WzlJo6Ne0I8CSq4hsyPwKB3MO?=
 =?us-ascii?Q?1HwPE7/V+0es9hdhLmLlPVjopjLB8PXc6/LbxhL9xGfgtViVmXtb90gEkKTo?=
 =?us-ascii?Q?3TlvwM6He1ERfjAT2iAvB02SwmUxhD5zZ2FYgemdKlSXlEJNxAXfl+iBSSCP?=
 =?us-ascii?Q?gJhFAhogpZduiZH9RSQqo4W4NuujyYEXVZzAoAxgXr++/dT5IsXOAE+W/FHD?=
 =?us-ascii?Q?Mc7yBvsH4Njla58sywj7cKrfFC0itpN/EefW37UsOIFQiISKknNaFKGefI5O?=
 =?us-ascii?Q?EcDdTIVpuEPoPoBk1ri4e2zEPViqjG1bVqnfa7Hh01I3LSZUfdUcnFEmh3cL?=
 =?us-ascii?Q?/Y/n5cxggsE7mIjSj1wqGz8seKbZ0GoffB+oQH9UReUdWWXqFFCwpELjuNgq?=
 =?us-ascii?Q?tfAueA8aqEnbVxAe++8cN6hpkcwXCURWTkI5D2Y8sWzcgW2YR1qSE9pL1p2v?=
 =?us-ascii?Q?qTwrFcktIc9PSc9QCeBXVVbsRJR+tsdp8ixJXZ9O9+/QahGWAtsyCooArKJ9?=
 =?us-ascii?Q?QhTUsNdXCyvkVmKDcWe29Rfogz54V7bhH4ZxHBCykfYJxGRp244Lnnhbk/Dq?=
 =?us-ascii?Q?n6dviahf75cM8VpSsv1jXOayXZzA1dePtTrDoZRKuz5dbNIcHODoTSDVWLAD?=
 =?us-ascii?Q?gjMTeYcRQ9JlwfZOhOxQUhBCQaBRHppgEH8sv/FM5VQu6lygc9K7hwjQ8X9A?=
 =?us-ascii?Q?FNTG6KoBf900CZ6pkbGc4FA3hz+Z0so77UIsl3CDtGn/5jFcAkOMU6f8Qa1J?=
 =?us-ascii?Q?DhKsv9QvCmNdlX/EklkrbtlyHgrKegz6u9bA5cBKexbpWT897gGWUH6T7Ioj?=
 =?us-ascii?Q?KCWQ8ypeznD6ZLJVVrkoqXADTNlkrPqqX9QbMV//tCW4Uo+3YmFOEkIoHvqI?=
 =?us-ascii?Q?Ncieq0DeafrAzzZOe5waQZAASSfygy/gWmOLnrAJfefqKpHsTpbbYcv15I8W?=
 =?us-ascii?Q?r4bU1Wyq5ddBEw2R/43y3n4HKdKbMthlz4sSy9Rk/wn3w0kxwtq6heqEt3d4?=
 =?us-ascii?Q?kB1TqlmWVnNjXUKpHIuj8NOBSSZsAZo9bEEYv3x65y+o6f8CeiYcscuPLKeC?=
 =?us-ascii?Q?tS2YO/rnAikImt/lQhJStO8MPdrpiq0uZYkAlJVApi/peyogc0Uynu9h+iV1?=
 =?us-ascii?Q?LGaNDzthUYlb7851qBbC6hUVh/yIq1iabeFeZmn6ofBdiqj4D65QwKNNbxeS?=
 =?us-ascii?Q?DBCPxwr2baZRVHUD3H37KuUe56Gw2T137CUXusk5889YMkXDPr1ZluuLOKWt?=
 =?us-ascii?Q?7G0S9wYYL95gtXJMUYl8aNp/kzcDrK9zCU0XszhHCD1NoikosV1dP8/q9Iqd?=
 =?us-ascii?Q?h2R8J8NAK7W60Z3FlYbWlGYP9gFSKGNJLiC9Ax3V0uW4oIenY+qDzsP6khe1?=
 =?us-ascii?Q?mId+SOl9Mm4ej9QQUgaC83WUahRLortH7ASuK51aYl8W6WcQUQh0+bBGxyfg?=
 =?us-ascii?Q?7w=3D=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: AfDds0G5KAYYGkdJcuURpuraTfzQ4bjggSIt7mh3Qq5WB2Vdw9bJiPqp8vFr36F62DPeebtpvhuuzjqLhcf08iP6q68k9hZy15f54+HADoeZP+bMLbBq2k111DS8gfaU36XQmrSNyb4VhQYhHNtYtWpneSu2DU56S5M91yx3UO1vgizJpTz7FxkETxByn1hL6teiKolMlquvjwPVdOWetdkO3qxOVaGiQ/X+L58qy44e+YOlOQuHvUqxstF75bXAnQW/PhfhKzQPaNmSSLj8OCCMIgdWhdc/MKfJhU0G3uZz3J78lOHnMB9hnNbH9h54QFu9OsYHlP5SsWerKAoukQLYJp+OZ6qMx9tTzjcR2ci1umYVph5VhJG272qF6Nf6qQT9IdBIsIeNCeTffDDfVFX0eissOPIUZ+Vl1edug/Wd/aHtVVRu2jPOhbOXpAlH+blhmixRuNaiMR+OTWjK06/YBrftDdGrnVrtt2gHT7t+gkBBTDmH/H5tu3U02DOJyQELlgrvrxdgfTYsoq7wIYdpSIXUWFRo2Je0fZgDplY5RVOVS9qRrltkKEGqoaG2TpcEOzflfsMPtbJTi3R/fUgqmJRUWv2YEp9RmDwoIIN0meTKMoSL/uOo035K89ywMWP2XbV3Wl230oR79j1xKm2p+0YwsKB6IyNay75KnPOi6A7pOlDlZUjV9EFJV5GXfjeMVcjm9r0jm8IEMYUIKPV35RMvgCqSzbtegazsmjeXzfc4hzPnPaH7nlmHHLvxDH8rNPaY27k9AhDfqZdle3VSVN5wns4U8sCn0xCESv7azuTy56IWTxjG5t6ukrHl1oEx9d0o2DCSF/l4E9Kjog==
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 0614eb65-8bed-4adc-f7c8-08db784748bc
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jun 2023 02:19:36.2524
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: sX5n6WUeeakg6MbArKscUCcNwOGgmjgYtLophLgs0O0Zc0HEElKYi3oQ+GJ65AEB/AH3PRScQZtNVowFSECCtvUlMqFAtVzF0RfKUa/YkXo=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ2PR10MB7013
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.957,Hydra:6.0.591,FMLib:17.11.176.26
 definitions=2023-06-28_14,2023-06-27_01,2023-05-22_02
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 adultscore=0
 malwarescore=0 suspectscore=0 spamscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2305260000 definitions=main-2306290018
X-Proofpoint-GUID: LiL0JJrdrd5YwKutFcEGuN_qRZV1ddvC
X-Proofpoint-ORIG-GUID: LiL0JJrdrd5YwKutFcEGuN_qRZV1ddvC
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Damien,

> When scanning the drive, you need to poke it using
> scsi_report_opcode() to determine which write operation is supported.
> Then sd.c need to be modified to generate the proper write command if
> the regular WRITE 10/16/32 are not supported. You will also need to
> make sure that this does not break ATA drives managed with libata, so
> check libata-scsi translation.
>
> Not saying this can all be accepted though. But that is what is
> needed.
>
> Martin ?

This is clearly a rare and special case, I have never come across a
drive that couldn't handle a regular WRITE command.

I don't see any reason to burden our stack with workarounds for drives
that use custom firmware.

-- 
Martin K. Petersen	Oracle Linux Engineering
