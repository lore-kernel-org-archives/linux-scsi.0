Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6BA69C433DB
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1A85A20709
	for <linux-scsi@archiver.kernel.org>; Wed, 27 Jan 2021 05:41:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235419AbhA0FiX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 27 Jan 2021 00:38:23 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:36220 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238722AbhA0Eze (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 26 Jan 2021 23:55:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4jT9W092786;
        Wed, 27 Jan 2021 04:54:45 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=dgMRgpgO4aBHnvMSHkZWfnimJ2ZNGyh0G5I+Cuji9DY=;
 b=PhPhv81vmGNhAsMEIJbV1X+Nh1mnj+o1BbQkkoiH2Ib4djS2jn37HD4c8D0povE/UyJ6
 lepBWPeXwTrixAKhVsqUiOYLOjV5iO/pmXCt1z4WemtZOUKGaRyYZr9/KJcaHiDzQuiT
 +zsDCCf4VFuH8RUnC9jB79261L1ox5o8tS3u2bmlHa85eZXfmkVYj9yLlETVbjDQlgpX
 AzT+sApD08e7mPS2HAEuPxLCwFEQqMwwlqst5/nqbLfZ0xGBPqRgSUTjkMTC6WNW7xnZ
 u+J9WtkWYapliJAT7sbUjHUiXL8GUPLOhou6ppZW2YCgop7q7+A6cbzB3Lzn+2ARUB3o ZQ== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689aanbb0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:45 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10R4p56X188801;
        Wed, 27 Jan 2021 04:54:45 GMT
Received: from nam10-mw2-obe.outbound.protection.outlook.com (mail-mw2nam10lp2106.outbound.protection.outlook.com [104.47.55.106])
        by aserp3030.oracle.com with ESMTP id 368wcnsk5h-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 27 Jan 2021 04:54:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gxIzlmTuHj7RCS6hsU1DarIEbYqeMzeNnhVviGsZD5QtuhOW0oV2MfOCOTrp5T1scrEmcPAstOAzoRqoiqmYDZInq3Dp6F6r8E+mZkCyzfnp2sOKd+tGkjRzhq4qom62GJeW2Y7YYfczIOW5leNhLzAogCcBByy7kHXk5CzoFTmTu7Vf3N9I3seteV9pR8tX7wqRVnsLQrO8nT+v/655kv3ujFsssGDB66RvKp7+dTOCF0C89ZHDVDkqBNpB62rEvu7epaljXStnJVvVv+7KdHBs5oYbusU8c9/tzSExQGQqB5+SSwJ4/yJMhlsY5LENqkOLOqUbeNM3HEMcrN75Dg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgMRgpgO4aBHnvMSHkZWfnimJ2ZNGyh0G5I+Cuji9DY=;
 b=Tp+2baEs4p9zfjMHA4Fhzh4Smge3oUmm3x1ckQHElYzHhjBUn+5akEIF3sL4pFeJuEZH9ZCjy6DZjBwjd+os6X7K/brP6vJTWMU3mYNLN32HPB4HyLIPpnGeJ3QCbYgHyqSLecf6IKAQLitiOsDKMIxPVKd0yH4o5Y0bqn3AKIv+oSJYkli5fvvRebgvluKy8pgd5x+Aa3i9CfMjy651JSm4PO//cKFl8PFTb6ldIyXQluvmnz5sJK/RSFASRPQtDcoQLLkZPY+QwLHSUxX7G1DDPbaP5yrUpKt/jfr+9ksPekOZwQlq8osgi3leQTjQ4Dz3UYhhWd9lw07qgMQR1A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dgMRgpgO4aBHnvMSHkZWfnimJ2ZNGyh0G5I+Cuji9DY=;
 b=VNYnmy6sw3PY5a4kEqooxEYPaC9cpDTU8G9Q0Y+9wCG6P8z1mSUg4VGAzypAfUP+flQu03Tm2asn03ufQ929GpmluPfypQlY2X0Q8OB5y2tzB0dJC3m2ZTvGqZHpo9j6FgpZh8uAqqMnCzc2mtedhVqTx8dS6BiT4cIEIYLr9xQ=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4584.namprd10.prod.outlook.com (2603:10b6:510:37::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.12; Wed, 27 Jan
 2021 04:54:44 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::54f3:a8aa:a2cd:a3a4%5]) with mapi id 15.20.3784.019; Wed, 27 Jan 2021
 04:54:44 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCHv3 00/35] SCSI result handling cleanup, part 1
Date:   Tue, 26 Jan 2021 23:54:24 -0500
Message-Id: <161172309260.28139.11700069971770056781.b4-ty@oracle.com>
X-Mailer: git-send-email 2.29.2
In-Reply-To: <20210113090500.129644-1-hare@suse.de>
References: <20210113090500.129644-1-hare@suse.de>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.200.9]
X-ClientProxiedBy: MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28)
 To PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.200.9) by MWHPR10CA0018.namprd10.prod.outlook.com (2603:10b6:301::28) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Wed, 27 Jan 2021 04:54:42 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7680c0c4-7cf7-4e20-bd30-08d8c27fa9d4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4584:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB45842DCECB1421E58EDD16108EBB9@PH0PR10MB4584.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6790;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: tynKef5YF5TPYlVh9I9QtRRD9xievnR1ZoXuL27hD1L4pAKO4ePb6EyCUdLnKpw8KzZaJpRO+iqcxGXPVjIvjL8GID/R0o9zWKmsNySBh1s0LDSRrR/gd9vfSyqFdCaDJNxif085Vb58uhfAabYRImlAN30rAGXYRXZXKWdScJc5eA80FVlAqrP173rym4GPjXEkYO6gsOjndYHcWsWN2YbWWl1trRtluAOq7VGZYoxUwsrtBCB5i8b5B4sAskZoPDdDsS8nWNKyO+DfCtj6QB06xqw3Hr50Ze8LdjzVvkYcndRnh6J94pl6XHY1ewab8yLBkdEkYJf3SLAvZne3uKDkUk1BljghFYP5FfU2H0xAi7z1TO1sBxGIJ5pKtFiAh/ZyBGFjpksEOmeXewx2VNVqglDCNX5rPZOEqO98K4XwKNMz7C+eP0258TEmXvIndZNKy04XdoxGWP+XnZ4sUw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(396003)(136003)(39860400002)(376002)(8676002)(66946007)(103116003)(6666004)(16526019)(26005)(86362001)(186003)(36756003)(83380400001)(2906002)(6916009)(2616005)(8936002)(5660300002)(4326008)(66556008)(54906003)(66476007)(52116002)(7696005)(478600001)(956004)(966005)(6486002)(316002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?c0pkMk4xQWJWM3BuaTdVbUhFTk5NYTAzdW8wd1VMeWpNcXRHL0hFTnQvTS9o?=
 =?utf-8?B?Zjh2Z0xRRWxadGI2K1BJMjZ1OHZXT2hCNGM3TERDd0ttOHF3Q1JTcUlNZUNX?=
 =?utf-8?B?cGFERTRWSzNCaW5SR2dNcTREbDkwL09ueERUL21XQk9USUppaVVPeGlKRGdu?=
 =?utf-8?B?ZENyZVZRbnZiN3BWZEdnb3ViMGNmNVZKdFJESUMvSjJKaDFIdFFkWFI4VkdS?=
 =?utf-8?B?c0dCTU9mb3ZpWUl1azVpdGJaUExyZTZpNmcxSERYUGozaG5CRUEwU1FSOVl0?=
 =?utf-8?B?aWx0eU0wNnFSUWhaSUVGVmd0aUR1N24xcVB1bFBjWDlPdTdPdTNScEN0dmJn?=
 =?utf-8?B?TWpIV3hOcCsyQTh6ZUJjK2txNytyWVBFL2lLY1IxU2xCeDdEb1Z6REV3d2o5?=
 =?utf-8?B?Sm5EUGQvUGNXaktOMXptOEJyd3FiRGx1NmlOdWtpQ0VGVzNXZ0pKbEZQc0t2?=
 =?utf-8?B?VkUvRko3Y2JGQ2NsUFFmanlqT3BvNzlpYjBadUtOQnVld2J3TFZDVVFOYXBJ?=
 =?utf-8?B?NU1BeEczTVFvMU5iMzY4WnNnNlFUekhkemFJQmtYTEdhRXBiSkFZVURWaDMw?=
 =?utf-8?B?dW9mNWJSVUpNc0g0VzRZeDBka2c5ZWJVU0pGMGpkTlhld1BZY0ZXeDJtRnJt?=
 =?utf-8?B?U1hCRy9pWDlwQmt3cHdnSlhUKzRoL3RXVEc2ZGFMVTBoUU9SNGpQTEtjZkJj?=
 =?utf-8?B?U3NhUkpPYittTlJkUXFrZmJvOHBuaUZLZFVLNVVLSVdIeDNsNWVSU0ppOFBn?=
 =?utf-8?B?NEhEQllybzNyMVNIOG9LMlNienV0bHl2Qm90UjV1bE9QZGZVcmEra255Znp2?=
 =?utf-8?B?V2M0QlRoTnhFU3JmM0k1ZVZud1I4TnIvLzdsanFIZlpMZlJzWG10NHdVR1cy?=
 =?utf-8?B?ZUYwU1ZieHBDOUVzV2gzditnaER3OTk5TFA4N3VaNmI2L2c2TUFhVmNJbnNN?=
 =?utf-8?B?WnVXWDBXSm8xd3phZ3dESWtXaXpCdnJBaEwrVnZzMzk0SjFzUUM1MUR0NFlG?=
 =?utf-8?B?bmRTNXg5aU9XREIyYnA2SGp1NnZYRGVZaHdnUC9tb3ZGK2w0RzF3bGw4R3Rh?=
 =?utf-8?B?NGhxT1cyY2xEdHQ5ZjdFMXo1Wi8yQlhGRXRMR3FnamZ1MXNmdjRjc2ZZR2dW?=
 =?utf-8?B?aU43WWpmNndRYk4zK2lIVHNhQWkvSWI0YWtIcWx6N1lGZVVFcW1jM2hQZUxa?=
 =?utf-8?B?QW1lVEVsR2JMNDZJUHFpeEVxYTVNazFGYUg4dDhHRkYxbEZ6M1huUUViQTJv?=
 =?utf-8?B?dE5BWVBxcEYwZVUwRHJtbzd6ZWwyeWNBWDNyL2FTSDV5QkxCZnJzYmdteDZZ?=
 =?utf-8?B?Z0RsRVZBeUFiMDRWdFFQMy91VWN5SG84Yjd6Z3pJTE5iQjVZRzAzVStLL0U5?=
 =?utf-8?B?djI1NkM5aTFwdlJpdEZqNkgxMWxzaGpNWFNMaU5nR2w4VHZHZlJyY0NXZHZq?=
 =?utf-8?Q?bHNTfu+T?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7680c0c4-7cf7-4e20-bd30-08d8c27fa9d4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2021 04:54:44.1052
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3mvtUqaH6gEFtGwtH8Zf8wlgRVhhIBgZkkuGFxo25b+t6fKRU435p4NPwoXHdOccNSnLwC2BfOimFc+O6WTETcNb59KLojMwCg4rGX9n13o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4584
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270027
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9876 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101270026
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 13 Jan 2021 10:04:25 +0100, Hannes Reinecke wrote:

> this is the first part of an attempt to clean up SCSI result handling.
> The patchset primarily cleans up various drivers by fixing up
> whitespaces or move to standard definitions.
> It also fixes some minor issues in some drivers which set the
> wrong result values.
> And, of course, another attempt to kill the gdth driver
> 
> [...]

Applied to 5.12/scsi-queue, thanks!

[01/35] scsi: drop gdth driver
        https://git.kernel.org/mkp/scsi/c/0653c358d2dc
[02/35] 3w-xxxx: Whitespace cleanup
        https://git.kernel.org/mkp/scsi/c/8148dfba29e7
[03/35] 3w-9xxx: Whitespace cleanup
        https://git.kernel.org/mkp/scsi/c/bf4eebbf53c9
[04/35] 3w-sas: Whitespace cleanup
        https://git.kernel.org/mkp/scsi/c/1789671ded39
[05/35] atp870u: Whitespace cleanup
        https://git.kernel.org/mkp/scsi/c/bcd5c59f21e3
[06/35] aic7xxx,aic79xx: Whitespace cleanup
        https://git.kernel.org/mkp/scsi/c/7662d92374df
[07/35] aic7xxx,aic79xx: kill pointless forward declarations
        https://git.kernel.org/mkp/scsi/c/c23435dbc747
[08/35] aic7xxx,aic79xxx: remove driver-defined SAM status definitions
        https://git.kernel.org/mkp/scsi/c/54c9f6fdefcc
[09/35] bfa: drop driver-defined SCSI status codes
        https://git.kernel.org/mkp/scsi/c/eb74b9322bce
[10/35] acornscsi: use standard defines
        https://git.kernel.org/mkp/scsi/c/0eb198d2c35f
[11/35] nsp32: fixup status handling
        https://git.kernel.org/mkp/scsi/c/23d339f08fac
[12/35] dc395: drop private SAM status code definitions
        https://git.kernel.org/mkp/scsi/c/f55475891edb
[13/35] qla4xxx: use standard SAM status definitions
        https://git.kernel.org/mkp/scsi/c/35f1cad1f928
[14/35] zfcp: do not set COMMAND_COMPLETE
        https://git.kernel.org/mkp/scsi/c/3273c91bbd01
[15/35] aacraid: avoid setting message byte on completion
        https://git.kernel.org/mkp/scsi/c/cdec16c1177a
[16/35] hpsa: do not set COMMAND_COMPLETE
        https://git.kernel.org/mkp/scsi/c/0e310ac4ef0d
[17/35] stex: do not set COMMAND_COMPLETE
        https://git.kernel.org/mkp/scsi/c/8959e81cf44a
[18/35] nsp_cs: drop internal SCSI message definition
        https://git.kernel.org/mkp/scsi/c/1c9eb798d566
[19/35] aic7xxx,aic79xx: drop internal SCSI message definition
        https://git.kernel.org/mkp/scsi/c/d8cd784ff7b3
[20/35] dc395x: drop internal SCSI message definitions
        https://git.kernel.org/mkp/scsi/c/9c2d26707351
[21/35] initio: drop internal SCSI message definition
        https://git.kernel.org/mkp/scsi/c/9df17f4679b7
[22/35] scsi_debug: do not set COMMAND_COMPLETE
        https://git.kernel.org/mkp/scsi/c/7a64c81448b2
[23/35] ufshcd: do not set COMMAND_COMPLETE
        https://git.kernel.org/mkp/scsi/c/db83d8a5c862
[24/35] atp870u: use standard definitions
        https://git.kernel.org/mkp/scsi/c/f3272258d79a
[25/35] mac53c94: Do not set invalid command result
        https://git.kernel.org/mkp/scsi/c/ddb99b1d1d4a
[26/35] dpt_i2o: use DID_ERROR instead of INITIATOR_ERROR message
        https://git.kernel.org/mkp/scsi/c/78c9efdd8dbf
[27/35] scsi: add 'set_status_byte()' accessor
        https://git.kernel.org/mkp/scsi/c/d37932a91600
[28/35] esp_scsi: use host byte as last argument to esp_cmd_is_done()
        https://git.kernel.org/mkp/scsi/c/6b50529e2f6f
[29/35] esp_scsi: do not set SCSI message byte
        https://git.kernel.org/mkp/scsi/c/809dadb15a91
[30/35] wd33c93: use SCSI status
        https://git.kernel.org/mkp/scsi/c/fc8e006c38e2
[31/35] ips: use correct command completion on error
        https://git.kernel.org/mkp/scsi/c/88188179f36c
[32/35] storvsc: Return DID_ERROR for invalid commands
        https://git.kernel.org/mkp/scsi/c/ecc751b27a57
[33/35] qla2xxx: fc_remote_port_chkready() returns a SCSI result value
        https://git.kernel.org/mkp/scsi/c/6098c3005d5a
[34/35] advansys: kill driver_defined status byte accessors
        https://git.kernel.org/mkp/scsi/c/aced5500ec82
[35/35] ncr53c8xx: Use SAM status values
        https://git.kernel.org/mkp/scsi/c/491152c7c3b5

-- 
Martin K. Petersen	Oracle Linux Engineering
