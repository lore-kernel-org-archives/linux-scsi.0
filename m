Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E181C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E6EFA60C3E
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Apr 2021 02:29:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbhDTCaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 19 Apr 2021 22:30:03 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:38376 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229573AbhDTCaD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Apr 2021 22:30:03 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2O3K1092017;
        Tue, 20 Apr 2021 02:29:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=rL/am3NgNP9JvSYcXChHo2AP5u+C/TMmt67HE5aySMo=;
 b=WC4WHn3CAgvefZjPWdvi4kYT/ojpcgKcRINZTvFcQiypIWv2NcCEgK2XPfqj8LklpGLs
 Pm9F0QsqMZZhg3Z15OSvbcn+sCfay5dnhqxpquyVgxB1tr9b2R+6ffMof06WqKQjSc5y
 CpHqyqNZCGoB9tEtTJgz1z8n5e7IekR+KF83pt/Njv0GN+cgQiecjdIKuPfIAlXGAuKS
 L1iibo+SIOL5JT911TDvKTuig7pkcAzjistKAIKYH5l+39pwbO2qEmWHBrU6xRAGDTtM
 wbZdT73vjJs7XyYNSZgEgZeN3rxnTaf2lmrkWe/KVMAXRlsin0h2vPmhaNR4bSaGeVih jg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 37yn6c5nsw-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:20 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 13K2Q4Fo190210;
        Tue, 20 Apr 2021 02:29:20 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by aserp3020.oracle.com with ESMTP id 3809jyneu3-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 20 Apr 2021 02:29:19 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FXMxaA6sjKgWSacw/HND8Cq7ncE+FqyFqShphij3skHlS89cLwPcNAHzyjyYHFV0dVlavdvdLq70l/q7sVmd7FFpogqOylDXnNKA35QsRP8JAPhP0f/4p86OAtbEliV2pnQSpYW6l13daVD4iFwM288v+uWPzywI1Ff7AfkE/GTY/z10m1kCNPOPAK3KbgQXCLC05Ii4FMKtrSzJRotMYUnicCYQGw56rigsMcp3ISLg/B3y6sGx7qnlwJEd/Kzg6Dnbfg4OZjMc0NZuMKldSo93yqYfWGJNMjvwAOZD522bmsRt1MMi5UTX6HlNSCPMF3Hfpw2ulzFwbm5A0qw0/Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL/am3NgNP9JvSYcXChHo2AP5u+C/TMmt67HE5aySMo=;
 b=Gmn4x18aJ6Du7gCb3rbFQ9ocQ2TRKb8b+X3EYZtyPPHeOyb0SIdrmlze09l4Buo41kHRzL42Al58zuKvL8UrYJ6KDsaWO7K5+zCEhiGInRaJY4yGMOwUGe67LF/tkdpP29K26xz8gxFug7Wsj7TqHTpy8XVkYuAmOMLHVZuPfMToPNVKQDuALR2f4/vWgsygtlI8hswZAvv+B7MqgprM8W4Pfi47Q/C3csu6DK2fnS/Y3V3N1HqiZSUPQHmkA/iOmhZ8qLSNk8WGZh5TQuxVTt2BHciqv3lhO+6oWLes6QeVwduKh5k2zQr+CJiAH5KLG3g2RRJPi0QCS1+HuuXjwA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=rL/am3NgNP9JvSYcXChHo2AP5u+C/TMmt67HE5aySMo=;
 b=wdcVvQ4csLZ2EIY6jvQ74vioMf1hbLbIctHiDV4uRxpwiM15NSwaO3Ag+ya0rEreDspfyriSeUS/KYonqxTnsTycp5DqHvsj24updq3f0AjXH10Qq5OiQ0qTDTjH0H1h5IIrd5O3M73X9VZ7wWVrgNiMQ1rFr06GpKpymIPRj3g=
Authentication-Results: acm.org; dkim=none (message not signed)
 header.d=none;acm.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4775.namprd10.prod.outlook.com (2603:10b6:510:38::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.18; Tue, 20 Apr
 2021 02:29:18 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::9ce3:6a25:939f:c688%4]) with mapi id 15.20.4042.024; Tue, 20 Apr 2021
 02:29:18 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 00/20] SCSI patches for kernel v5.13
Date:   Mon, 19 Apr 2021 22:29:10 -0400
Message-Id: <161888563604.11594.8342699509539948309.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210415220826.29438-1-bvanassche@acm.org>
References: <20210415220826.29438-1-bvanassche@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SA9PR10CA0006.namprd10.prod.outlook.com
 (2603:10b6:806:a7::11) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA9PR10CA0006.namprd10.prod.outlook.com (2603:10b6:806:a7::11) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4042.16 via Frontend Transport; Tue, 20 Apr 2021 02:29:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: cc542bbd-8554-4a2d-1948-08d903a418f4
X-MS-TrafficTypeDiagnostic: PH0PR10MB4775:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4775FE0C2F53E509585FDDCB8E489@PH0PR10MB4775.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: 20aIcSueAddNitXS2Zzz5yQ7zI8N4QAl4INfuFpoDVNYSQ83vrVAWed0TKr1TYQWoFO45zPNMrS+iOUpSAQ7e5XIjtUFwELfDLP0gJp/xMECeP8DmeoTxCRW6G235vnturmi0dh2tBCsmgWQdgMu/uXsVNjskVf0w4uaXdMU5hCfu/RAVNOuY9jahDXGO8sxwiWmMMTKATzUwxtRq7ry+aUG7ADNUX+8v/6WKHGLk4k/JLkJwK2MWLW+3YybFwRNSuyhcipBzx3IP4jPrHbJPSlkE7o5Fry5e5Y0q8DdOv5vHjOgItqcQOSLW6qHZBFcQu8y5RRj0DNa6Gb/FLj6W0o8s/wHpmNrVBIT/jc7hyiCFU5oIpDKRRc3E04ieGeX2+8mLL/oXi8+UYR2N+IUZnKy3WosRolCXeq+4nPs58WZ9EBdK6uYKjI1XGUiRiZEaQj1khdqXOcqIDaDvMVoaVXBL85+RE7zra5I5mGGBAAeJFWHhxLgghL2MTxslFtg98xKvfhdt3wHXPiyEV2pv1TY/Ilvj59NgY39TbSk33t5JGawzDdAohrzGXY5BKo5gwxxR89LBq1NMUpTiPZdfGuDnEgZ6IbbU32U1wgTkNRlzNjoLzo8VtctW757yYExd5kxYp2dtPmhwOYQTIQcrCEPwUS7S+iNDPPo+NW4l+rmeYWeePwz92CMs/FtOLeYCAiISVn4M4FMUgCtc4OJALrKhuol/D58eIdMwYn65to=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(376002)(346002)(39860400002)(396003)(136003)(26005)(5660300002)(86362001)(186003)(36756003)(7696005)(66556008)(2906002)(966005)(478600001)(956004)(38350700002)(8676002)(52116002)(38100700002)(6486002)(2616005)(54906003)(83380400001)(8936002)(6666004)(316002)(16526019)(66946007)(110136005)(4326008)(103116003)(66476007);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?bUlGaGYyVjNabUJ3K0ZnOUYzbTg4QUJDZXQvWmhqZ2ExdWsya1Y2R2tqbVNk?=
 =?utf-8?B?eWpxOHM0QmhnTnY0cFJVR0g1MzFpLzNLN0g0bURjZnJ3V1NFU1pyOUVMa0Jv?=
 =?utf-8?B?SnpYbWZvTTc3WGhWUnRUVk00Tm5nZDZnYy9NalQxR1V5ZTN1YU1jajRKR3lL?=
 =?utf-8?B?eFNNMnAxVFBzWVN1TXZTSGIwRkorSXZqalNMVTV6M0pqZUhLQTlVNHh5eGQr?=
 =?utf-8?B?ZTI3TUtHVjFOK3Z4Vi9hOWNkRzdvOGVhMCtiWlk3Z1NkSTBZRFdwb2ZaZWtU?=
 =?utf-8?B?M3FBbFlxeEFXMGk2RWdNQ1FjUlBSZWcwZSsrZTVlVXN1V0NmK1k1YXc3UXJm?=
 =?utf-8?B?SlZWZG9xaTl6VndiNDZMUXJiTFVwcEhlbXpTayt6di9DbC9hUmxhZGl5b1Y0?=
 =?utf-8?B?V3EzME9NV1k3d1pmZFdmT1FReEsrUGgvdEkvd0tEdncwYU1JMzl0SGxubThB?=
 =?utf-8?B?NFQzbWMvUVczREdPWHlYaEw3aXVVVTBremduK05JNXg2NjB3QWYzN3pXTXV0?=
 =?utf-8?B?c3MzVGdnekJ5SSs5V2NxV3F0c0QvaHNtTUFDZGQydUxnM1lEVDNCRlJWdEw0?=
 =?utf-8?B?OUc0M3lyRnNVK3hmcmNiV0FFb1RjZ1VxUTFFY3NpUkw5djMybCtLUnJxSUtw?=
 =?utf-8?B?aC9sV3hkZ1dVT211RC9BYVVFS0pxbktwS05obVFITXJGQlpNdjA1MmJjUlNJ?=
 =?utf-8?B?Y2pPdngvbXdPNVVDTWtlNDBHNFN3OVJJeEF5TjNZUWxscmVXdDFGaU5pMXN3?=
 =?utf-8?B?cUF2Uk5RWWRlYU5pZXZIMGVtbnI4OE1vTlRWTzZtQXIyQ3Y0YXBLMzc3azBr?=
 =?utf-8?B?RFNjMGx3YjlJczlkMlh5Tk5QN01oc1VLZk5xa2tMalAvT0RSN0NDZTJuV3Z3?=
 =?utf-8?B?S3hRSVYwWWJyejZXS1MxTVQ5ajlISFoxeVNhWHd4S09RK2ZhT01nT1RST2s1?=
 =?utf-8?B?ZlYvdjQxZnY4UldIM3dFOE94YldVaFpUMDJ2QnNqWE1rMm5uYlozTEFiZEZI?=
 =?utf-8?B?eXpmWkJFNGtxMzMwR1JuZnJvaGNHTjIvUUNraEVqSFd3eGNRTmtLT2NBdG91?=
 =?utf-8?B?VkFkTFJXY3BtRUdQb2NvOCtTeUZXL1E2dnk4L2syQWZlZ1ZieTlJajlrS042?=
 =?utf-8?B?NmdFMFFMYWpEMnlCZ2tlUm9nVm5OV1BRSFJobFpYTGgrbGhSaTQ1MUh2ejVi?=
 =?utf-8?B?SVhMUzJCNThmM280d0dOUEQ3aWdRNlptd3lhUjlKeStZN2QzczI1TjlneVE1?=
 =?utf-8?B?RzlwYkgwVEEwcmR0MFhUZ05qQ2h6YkJBRUhGTm9yMkh6YWxFcWpKeEQ5Z3N5?=
 =?utf-8?B?NTU2U01DZ29DdHBqcGdWZmxqVDZhNEtFSis1Rkh6dm50WmhjRWZQS044WWZl?=
 =?utf-8?B?WUtlYUM2V05rWTlVS2hjMXBNbWk0aXlNSGRpWk95SG9rYW1la1lCYkdpVXRv?=
 =?utf-8?B?eDZUd2N0YnMwM2hEakg5NXgyNnJIa2tnZUh1WWJUR0NKaXZXWW9lb21CZ25S?=
 =?utf-8?B?N0diaGNaaEhtbWsvWnYrNjZkajNiVW5CalBOLzRBNmpVdVUxRHZDc2tjL2Vj?=
 =?utf-8?B?Y2JFaUFHcjBXaC9VUWhhR2Z6MTVlcXQyd0I3MFBpQlhSNUI5K1VCdytEYy9u?=
 =?utf-8?B?dmcyL2JJclBsL3dnWHM4dnVvODRTZXhCSUwzcjA2ZWxRSkV6OGZ6TStTQ1k3?=
 =?utf-8?B?emJrdldVZkRYVjUvUU44bTFmU2o2Q0ZUYzFRZmFPWWdEbVhDSElmRHUzajF4?=
 =?utf-8?Q?AANQllfy9YnzrSM6qqh21o/JEohosFdiT15FLoJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: cc542bbd-8554-4a2d-1948-08d903a418f4
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 20 Apr 2021 02:29:17.9339
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rD62Weu2kc5BY5wS4JUqLcBsZgf+t3cui/RTAEVVcJRkENHXoX69IKsVpKBTt220o1YLZcJD4Nw8/pL9woIMxU7zFDDT7LwbXBhJ8BgMn/s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4775
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 bulkscore=0 malwarescore=0
 suspectscore=0 phishscore=0 spamscore=0 mlxlogscore=999 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
X-Proofpoint-GUID: XcmRqBCYrFDn43mSV2ypdqqaqhWMEQJ8
X-Proofpoint-ORIG-GUID: XcmRqBCYrFDn43mSV2ypdqqaqhWMEQJ8
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9959 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 priorityscore=1501
 bulkscore=0 suspectscore=0 impostorscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1015 spamscore=0 mlxlogscore=999 adultscore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104200014
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 15 Apr 2021 15:08:06 -0700, Bart Van Assche wrote:

> This patch series includes the following changes:
> - Modify several source code comments.
> - Rename scsi_softirq_done().
> - Introduce enum scsi_disposition.
> - Address CC=clang W=1 warnings.
> 
> Please consider these patches for Linux kernel v5.13.
> 
> [...]

Applied to 5.13/scsi-queue, thanks!

[01/20] Make the scsi_alloc_sgtables() documentation more accurate
        https://git.kernel.org/mkp/scsi/c/76fc0df9a0e7
[02/20] Remove an incorrect comment
        https://git.kernel.org/mkp/scsi/c/886874af9439
[03/20] Rename scsi_softirq_done() into scsi_complete()
        https://git.kernel.org/mkp/scsi/c/0d2810cd62d9
[04/20] Modify the scsi_send_eh_cmnd() return value for the SDEV_BLOCK case
        https://git.kernel.org/mkp/scsi/c/280e91b02665
[05/20] Introduce enum scsi_disposition
        https://git.kernel.org/mkp/scsi/c/b8e162f9e7e2
[06/20] aacraid: Remove an unused function
        https://git.kernel.org/mkp/scsi/c/56853f0e615b
[07/20] libfc: Fix a format specifier
        https://git.kernel.org/mkp/scsi/c/90d6697810f0
[08/20] fcoe: Suppress a compiler warning
        https://git.kernel.org/mkp/scsi/c/be5aeee30e45
[09/20] mpt3sas: Fix two kernel-doc headers
        https://git.kernel.org/mkp/scsi/c/3ad0b1da0da2
[10/20] myrb: Remove unused functions
        https://git.kernel.org/mkp/scsi/c/3690ad6708c5
[11/20] myrs: Remove unused functions
        https://git.kernel.org/mkp/scsi/c/40d1373b6047
[12/20] qla4xxx: Remove an unused function
        https://git.kernel.org/mkp/scsi/c/11417cd5e2ec
[13/20] smartpqi: Remove unused functions
        https://git.kernel.org/mkp/scsi/c/c64aab41c5e1
[14/20] 53c700: Open-code status_byte(u8) calls
        https://git.kernel.org/mkp/scsi/c/3940ebf7ba52
[15/20] dc395x: Open-code status_byte(u8) calls
        https://git.kernel.org/mkp/scsi/c/22dc227e8f0e
[16/20] sd: Introduce a new local variable in sd_check_events()
        https://git.kernel.org/mkp/scsi/c/41e70e3006f6
[17/20] target: Compare explicitly with SAM_STAT_GOOD
        https://git.kernel.org/mkp/scsi/c/15df85e0d63d
[18/20] target: Fix two format specifiers
        https://git.kernel.org/mkp/scsi/c/e15c745295a2
[19/20] target: Shorten ALUA error messages
        https://git.kernel.org/mkp/scsi/c/baa75afde8cb
[20/20] target/tcm_fc: Fix a kernel-doc header
        https://git.kernel.org/mkp/scsi/c/7a3beeae2893

-- 
Martin K. Petersen	Oracle Linux Engineering
