Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D8FFFC4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AA79061262
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229665AbhHXED6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:03:58 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:9118 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229618AbhHXED5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:03:57 -0400
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0x6Nt014800;
        Tue, 24 Aug 2021 04:03:10 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=NmBqsbzfFLxmQjZ8n4tq/Im1a9lQ9Io62xYGTlI2ZKQ=;
 b=0lQub72sVUIjmfquDAEHfN1DU3dtIbAcgMEzo7m8ehg0+/gu5VYBsxWR6ZUH59ovtTjO
 YJmWAU+afNGF4Y83j65j3ktkD0yjJuBVzN7OyCX1UckOwboSejh2qa3+6YIdNgDWioLG
 U2snfm/dIJJ6QUsvjRdbzUc8BaLYyxJyj1xqCXezABo5aZ59eYFyq4dAo26ykfLXSTBi
 7QrZ7QSP5lp4CUoxD9nEAx51xoeF9YWsRKtcKIJgmOCGNTQC13xvCau3fUWfrWhSzUT0
 9YVVBcyHa6/Nqf/IRjcHeuWrjrsSihTvgAPWnrcYDY3DAdnN9O4YK1UZgEW3F++jeV/j AQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NmBqsbzfFLxmQjZ8n4tq/Im1a9lQ9Io62xYGTlI2ZKQ=;
 b=GuTgY24d2cnIbAOfZS/mYhlW4kwB92QH6JWpkX6zrUFMGevNJQu9c05Ua31JnAlbVGtM
 /hVZxpF3i+6rNqe7zxcUP/8yk0+eTzh3n2h4DZPQ/vZZtu3Mt08RbJ81gsA7/3v8BnxG
 8jFKhfbGEMZILhPISexd0vWgxRjs1nLbPeXdcvIgcbPLMq4cP0ceuAvpfnMXJSNlH387
 B8osgEtjz42fIa4GsKDtpXvtkA+jnecbmL4x0iUpR79gSyc2xGjo3Nc0mnyUBl7MQAqd
 4ifAGhOUw36VvwQzkd+7rRSaOhXNom+rQkEJU9+J8HwiKiwxcKW/DfsFvrHAJdLVU820 XQ== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akuswk9j0-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:10 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41N3n082500;
        Tue, 24 Aug 2021 04:03:09 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3020.oracle.com with ESMTP id 3akb8tya34-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:09 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gpuLemDnw5X7mMsd6KnKkkY+8Kabduxd3JC6KOzm4EKaYiAjr3HgeT8Mq3kAZ6jzk8vKpQKh/UxyTaS3vxmv9TiLdzWMkSM9U56ZfT5y7ZoyMcMKX2U6W8+uBqsaVOUAeU56o6YOEyZdU+2Vd5ZY0Mwq+zAfNYgDZ8ykE37bEBfTmz+AtwEYih+uf8sGasE5NtCBHUK8a9nugprBTDMfx8ooOPOxP8i435JFuPwSRuEniE0brEvuLRl1X0+b7rzQwbhzBMj4rvEHenNbBTF6Z7KKjVjZFj1rRApkpTkivn/TEiJC2mqYn6IHOLCbe8gCMmsuvcuEvRTZ0gtmJPXS1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmBqsbzfFLxmQjZ8n4tq/Im1a9lQ9Io62xYGTlI2ZKQ=;
 b=WzlocCfOLYLPuAHuCBKg+JzZxKYwfmfvS2M+NYrcRAc+oHkIf2SRrf08l+KK/4uMERmbtrmyGwLgSSBmptBq8hO7g3ZMn1PiKEphZrt9z3ji3nTw+hYN0wMYFrTMRk8TsvKuL96dOxeH2Qay7bJvhuAnYoJtQnliThb4IX3gnFVTdWvrMoycnVZztGaVvtXsVO6I3aU+/HElKJI/X9maaVcrjg+aOo3ztuDv+WrD0OPKEfM/Igw5rNYjnQjY+04wt4ow87+O5t6gYZBja8El27JOCHeBnxSoaSNyZUvE6xz4UzzWiim6QBduwOgqhGUfVDE45fn1/ve74hnxUKrO5w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NmBqsbzfFLxmQjZ8n4tq/Im1a9lQ9Io62xYGTlI2ZKQ=;
 b=KWclBVL4NVkw3s2C2DHRY4kfLHzEa1bDjLX8TiiqRFVLZO1nqFx4cxgpOcWTBvLJ19FQMr8VzO6Sle4Nj+HN9fR41cu9tgyUEpL4pkKa63K+zpjWeRvG0YpU47wnRkIFaCRuCPr4doywunwPDwWszfOgjQzMGQflLGcQa0Rx7Ig=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:07 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:07 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com,
        =?UTF-8?q?Christian=20L=C3=B6hle?= <CLoehle@hyperstone.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Do not exit sd_spinup_disk quietly
Date:   Tue, 24 Aug 2021 00:02:57 -0400
Message-Id: <162977310551.31461.5276731585018803167.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
References: <CWXP265MB26803209FD08A64222EEEA02C4FD9@CWXP265MB2680.GBRP265.PROD.OUTLOOK.COM>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:06 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 768db93c-cba3-4ef3-a5a2-08d966b41424
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB5529046A0C0EAC466863DC1E8EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7691;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: /JHqsFUD5an6u+dip1N57BUuA6drQnXVEOkupPsqVdmO1Y24OilpJP8yp/TW0KlCJXu7YK5mkfz1tCutAel+viFm/vkr7yMARiCQ5yzAM8VuT/Kez40rWzPXae2ai4d1TDG2+8eKx+qECZLYnRLyirFHfN8SP/RUkaaxCGlOhDcJfMLKc6vthX+eOQ6Rm+/XRGb6jD/7nGBzFQDXdtazHJzNAW0nAzhjFBjwXvgWpmhouGzQLBgDXZDv/jnjy7SJ2WyG90PRQ+th7eiEUj06Uces8ufxAOOUJKzdIeIQ4LJ7aLyQMtx0YQAevQOwDk2SlziRr2wjGZ0x0M3CduWusI9UMVoh9YSepCQCX1m7UQoQkSk7dcSXma3lhr861daCw7UYdLKEn4nm7WadR10LnbT4TmbGLAOuoj2b0MTtiU7l9mC9j1BxXXFNgMGpGbzClmert8A0FKjirYYdClEIpa26LtB0NxeZ83GH2IblGJtSPjlKGt0arvi0aOKp6lHkRHbL3LsTA5Nz/CBhL5UBRL0+DOLJNQVyTz/EbQ0tvyN+yCr7NYxUc4WaGn3cu+axASLX4RLU411ywwCROstSTGAQhV4vZfLJRHemHJr2foodVMrlG1S+yI0lWgJTIVAU63/Ti88X5N3pw46zYVv1pa6G+PEbg+7Tz14nFLJ9fNyxtzzQ1MYZn4zDKUWDkXwoXBwEZFGVp2ML+T1fTkMTZNerySkzZdcSJ/SI7RZjHwV8lJ5sSM8QJ4w49Q3/UFTLTercf2ESA513RGm5xHCVrA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(107886003)(8936002)(966005)(38100700002)(6666004)(6486002)(7696005)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(36756003)(86362001)(8676002)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eGZ5TTVxaE9mQ0VWUThiMzlBNmIyeGVQMVJ5VVNLK0lJc3BoZmdrNUcvMnNk?=
 =?utf-8?B?R205RGl6eTJSUlJ5MUZnMFZJaTFoMzkyeHM3R2xCMHdTWXRJem1JdGtwWWRB?=
 =?utf-8?B?TlZrZFZmc0t0VXp0MnRBRXZuYmxmbzlZTzJXckZJejhrUHg5UHBYN0VwdGta?=
 =?utf-8?B?dm1FbHJWbjdwaUNrT2hnUzN6Y3FtS0FCZ3RWR0xNYytlUllXanphR29pNlNZ?=
 =?utf-8?B?Y2RMUDdXVS92SXRMQmxHNHBCaWEyWHh1eU11NFhpdFlUSUVLekVLV3R5ZjZl?=
 =?utf-8?B?REhlNHhBL3hFT21WdnUreUsybCt3R1VlMWJnYVlVMmxoZlcrNjRDQWxmVHVa?=
 =?utf-8?B?K256cXBZeFRDL1lFTElYcGpYOFNHQjJ6a004WGFkMXNVNEs5NzllRWkvVjMy?=
 =?utf-8?B?cEl2MG4zOFk0dGs3enN1RWxDM3RwYSszZWpoWGt5anVibWFRZ0Ivd1RZWjhU?=
 =?utf-8?B?aUQxLzd0RGRRUktQdTAyNVRxeHl1ZFRiZVp5d2l3czRJYmpsd2NyVDlKQmFn?=
 =?utf-8?B?WitUbjhzZXBxZGNDWndjN2Y2VFEwMGdkTXZ3T0ttQW40dUlWTlpMSjBzK2tX?=
 =?utf-8?B?eGJ2YjlMZkdQUG83T2ZxMUY4M0FOWWpTOGI1Tk1UUUNBcHVyWmprNlNINzl3?=
 =?utf-8?B?TnRQcllHLzdOYk5JU3ltTXZhSm45cmtHdEZadmlEUHpyOHhHeG01NTNISjFp?=
 =?utf-8?B?YUdsM0FjMFpEVVFuSHVKdXB4SXlVL2hhcHA1TG9nYjhEOTM1RHBuaWkvVCsr?=
 =?utf-8?B?TTdCNmF6V255R2xoWVZzQks5QXJJR0h5ckt0ck10MW8vWnBtM3l1UWIrcWUw?=
 =?utf-8?B?bWtENmI2bXhSTi96dklEQ253SjJKb09tMlNXbzFMK0VzTGs3b1N4ZVVQRndp?=
 =?utf-8?B?Zk9UVnJCRGhEekZjT094bmluZDY0S252a3BvZTY1T3VXNTczQ0NVd2Jxd2xV?=
 =?utf-8?B?V3lOWWN1UWRTUUM4SDMxVVBPUHNDZ2ZyTmpOMCszL3RHbFRmb1ZvaU9qc1dV?=
 =?utf-8?B?eHlNZWhkU3ZwM0R1ZTUyRGNwSUlieFQ3NDZkelZER1dRREgvVnRQUitHZ2w0?=
 =?utf-8?B?RTVESnJUM0xXam9hL1hYdVI4VTNXQmEwRmV1U3JHNkxpeVlrQjJ6UnRmamFI?=
 =?utf-8?B?eHFPcjZRakViS2dwN0szOTk5aC8vTEJYQmZoSTdJQ1pJV3JSb0NZU1MvVXVV?=
 =?utf-8?B?SWpCdUhvM251UTlMd3JJMU56RFl1clk5TDQxWHB5dDlBWHRZWm9CRjUrOFZp?=
 =?utf-8?B?VFZHVDYrZll0RGxmUlhUdDc4NElONnk3TE9oVVo2Wkk3Z3p4OW1ERG56UTdT?=
 =?utf-8?B?Y0FpSUU4MWtPRWV6M2QyU2ZzU2hFSk50ZlRQNTU0Z29NMjhqNHBweEZvSVdV?=
 =?utf-8?B?R0dtS3d4SytoUmcwN0IwZU0wUkxQNytKSHBTSEh5NGdvNzZ0eUhVZ3hJOXMv?=
 =?utf-8?B?QXZaZUpxTUYwT3VadU9xZm4yNzNoZm5IRGtLalhKbUUrWmNwVGhvUXdwRk12?=
 =?utf-8?B?Y0pMM1o0UllkRW1Xb0xPZ0h6YmtoclIwVkpOekJ5TzFGOUMzQW5sa1lkSmdE?=
 =?utf-8?B?eVdlOFNueWRmZGVDUWtsVC9GeWNqczMvR3FjMklFL2tNZHJaVkh6bGM0WUZM?=
 =?utf-8?B?c0FFQjlaeTNrUVB1Q1ZWWk1EMUJ4bC9NRjBVZE0xRVJaci9pUU9Pc1h5R1ND?=
 =?utf-8?B?enJ0dUNFLzZvcnpLeFo1dzdwSmY3cUE1MGR2RjNKbDBGdUZmbHhRUXFuQVN1?=
 =?utf-8?Q?SZ5eNH+0Ep9j5aCibasLZSNYlnlRP95w0yXwUfl?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 768db93c-cba3-4ef3-a5a2-08d966b41424
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:07.1889
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Ahe8b9g3UCsv9XQnrqyRssRwISF1ub/Aea7DSdYXBv1zPg2mkYU3CkyYdMpmq9nL9fckiUV1OJWPPIkSQj21p4T2AOHUMQc/SM+lO6V895M=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0 spamscore=0
 bulkscore=0 mlxlogscore=999 malwarescore=0 adultscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-ORIG-GUID: ocMYJmQFwS-sRrye_b5LswWJbdATiNe1
X-Proofpoint-GUID: ocMYJmQFwS-sRrye_b5LswWJbdATiNe1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 16 Aug 2021 09:37:51 +0000, Christian Löhle wrote:

> The sd_spinup_disk function logs what is happening nicely.
> Unfortunately this output stops if the media was marked removed
> in the meantime. To prevent a puzzling output, add a print
> for this case, too.
> 
> 
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] scsi: sd: Do not exit sd_spinup_disk quietly
      https://git.kernel.org/mkp/scsi/c/848ade90ba9c

-- 
Martin K. Petersen	Oracle Linux Engineering
