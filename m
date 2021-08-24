Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BE83C4338F
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33750610A3
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Aug 2021 04:03:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230302AbhHXEEb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Aug 2021 00:04:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:28808 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230093AbhHXEEN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 24 Aug 2021 00:04:13 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.0.43) with SMTP id 17O0xG3X011540;
        Tue, 24 Aug 2021 04:03:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=xy6fqN+OU8Ji3y3JI5EK68IOWE0xLnp1XZoq39CH5/E=;
 b=X22TVCXC7PZCbCpYTKGglSCO+3/Sn/iIajbQYKiL9Yuw/ZyBp3Wxtbub/+UH26hsfbCn
 jHNGD4PwYg2dt2KbTm1DIx6O6csVfenqnT/bGAssotiwyVfMLT45KAliNzhofps+v85S
 d0jD5g5wD/DUJ2TexpbhGAPt4j9W9hNJWu1ypyraom/Ls+Q3goBeqt2v64ODlVIKOAJq
 b3DwXvxyHjkoqO2Mhxeq0QEUTpDp4sRuER/4K6jA6Cjq1NVj9oxoGGBmJ6nF0O7YqCnN
 +t4IEtLZuXhhmKh3JT+7Eocm1dGWMGEgQFjNNXr5Yv1S8CHaNGcP5thnr0OB+v/d8b2a yQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=xy6fqN+OU8Ji3y3JI5EK68IOWE0xLnp1XZoq39CH5/E=;
 b=tGCxWxeAslMaVA3QDJ1HQkvrrnkxV1I+tLTm7xvltTaCYJ/02nkCKXs40UoY/SGr8cHq
 PR100ibsEy+hysJhvwptz6tFyIpfF8o0m9+FB5JGqpOrJFuEVlDiVj1Ro8k9modbr9FU
 iys7mBAabw5vhNCvxHsnFcW+g+5dVvrmPQWp+446uEOES09z4vMniAh5EnWmTh4RNNda
 ZQZJStTEv41M/2+Jmig3fXAJRB65AbIaUfOChOUwFt72JzhAVHEwjENVOsnhpRhMMHOy
 q5uSlJUR3rNInvHmE6538Js7/6VnrXDVYa1/or/TfA8mVLcph2aMrUywsqwRgTPhQ+sD dA== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3akwfm3743-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:18 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 17O41X5V070148;
        Tue, 24 Aug 2021 04:03:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2046.outbound.protection.outlook.com [104.47.66.46])
        by userp3030.oracle.com with ESMTP id 3ajpkwge4s-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 24 Aug 2021 04:03:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=TN6SGijIXYgGYRK3RV5yc7hJkAw1q47hwoWI+J04UXrXw6VH/vIHxXP+zdbVj3SeaoUJDyJoH6ClL4bPg9JD0Etjjae/Rhdc3MFhbVWkkMUeOUD6fS8WndFskamvA/CHpM3t5kt0NTBC4mq3lWDK3mzjnhSonMxIA333Ib22rUKCqXul4SkTQYFsj8mnWTldLilr5vGZ6NbmGbD2eMb0giL2gOkxVPN2xJiSwPN71YgkXtjuQ8X5EotP0zZWPkk4dTI0lIeA3o1zHTD45EmmYXT7cVVttz68YApVuhDMmbbZ7le7U6YXOa2/SOpb9CxiWtevozK2gY0ETWpOhdKkug==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xy6fqN+OU8Ji3y3JI5EK68IOWE0xLnp1XZoq39CH5/E=;
 b=KobesFbzc17NbdUbwLftD23lgUQ2BFvphGkc607ClYgEbD4m7xcSjSa8fnpSl3FOhBoD3QSarX6XNYCkXAUWKOioeDdJ+GbIeXvL8KDRtyg5CCred9dMapLPvOFeqjkvdxY8vmTS+R4hIuTdo9OEundKAuNx8j63jMRtFkWtwP1DQTVUjvXFdfizWv/KRF6hFcdF+cvnltIEYj2CeYdNYQbpfsAxetVZPBZLIV8hRUci3U5Jlr38OgrT/sLWZfgCz2IA7NmmdwfaimCDX5NtLqSrctWmpyJB8yOndnjxxJmUqDu0ZakKFpKcrjE+zzvNyjVZQHEdnHqFkxPb56MmaA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=xy6fqN+OU8Ji3y3JI5EK68IOWE0xLnp1XZoq39CH5/E=;
 b=NQGkhXVDM92EuPfjY+CblqhU5tIuRdSvX54z6eRibgdlUJ4WZWIT85ONjZXX5D94woCLRdP4O1heJZcyLan/stpEx28nHIyyID1D/bH0uMFTLSo5I7f/hRaswytsNlw0ECrnylC/IFxlH1Ta3OxexzKEkLd9PQY+bBVY/KinuJg=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB5529.namprd10.prod.outlook.com (2603:10b6:510:106::8) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19; Tue, 24 Aug
 2021 04:03:15 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4436.024; Tue, 24 Aug 2021
 04:03:15 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>, mwilck@suse.com,
        Hannes Reinecke <hare@suse.de>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH RESEND] ibmvfc: do not wait for initial device scan
Date:   Tue, 24 Aug 2021 00:03:02 -0400
Message-Id: <162977310551.31461.10046137885573822324.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <20210817075306.11315-1-mwilck@suse.com>
References: <20210817075306.11315-1-mwilck@suse.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0295.namprd03.prod.outlook.com
 (2603:10b6:a03:39e::30) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0295.namprd03.prod.outlook.com (2603:10b6:a03:39e::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4436.19 via Frontend Transport; Tue, 24 Aug 2021 04:03:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: fa544668-898e-4a1c-9754-08d966b41922
X-MS-TrafficTypeDiagnostic: PH0PR10MB5529:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB55299C56A9A741985C8F93CE8EC59@PH0PR10MB5529.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:7219;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: oe10+9PgcelnAdy2PSJ7Kexiz0VcgS70MUjK95AhxuqdKasvCBjIYkGji/67G2YilVMw2xVGyBYbg8fMZVwBSIopjyPN/wm9eG3vCmIDaBsh0bJWNRqz549ixjw8D5oxDYbziv8OL9g/yeH8PYMqUkGoxDMrsvXbTQ0PYDjDhDeghHlUQVkSqr/FDY5xoWg3aNtdENcTmIWHaAnw44hYFpEO4+26M4rPDoJr5VVT1xbvg2NZSSkKIbpKgjzw+Nd9pg29sXKP0gFeQ8RNyUZl4gYKOHN+2Hfkh3js3EbK5WZ+ztbvGqov2gsb5VUwKREReh1TlTtFcz3fH9Yy5TR78lNIMBDunjpFfpyQxQK73Ln/gmGU4agcTdA0H+3/74d/4n9qpI7Ity6OaoKe+UMyA5h9widEacmqSxdxp+o/fk6lESksybJn0+wNNzegaXfxG1KadbhHJYmUZG6kImEYNwB/54gcNOD9WwGI632EOWfq4RYmJbD3EbrduWZ2doMzSDOMHTMvynnOX6eGrDBChgUQUqmf5XlUn1VJHmGp1jXpHTi0tW54CT9MUdPwOmRr6Esj1MuR4w3IPfV5pAwPdAnTVuFruW8AxdkeNxZ6QmW3rbjHLL4h5JycsdNJIZN2otJCLdoQ6hDXijr3F6QV88uRsv2Ozq5zVLkW8fu3faqIkPCAx0AzkW0xynhDQklMMLO9BFiuBoXJ844No+wdfUnOIiABg+j7IySEbTfx2nNQgMX3u4O7poBVlLmbeOOiZg39PIU4Jpsc3JirdhqINw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(396003)(39860400002)(376002)(136003)(366004)(26005)(5660300002)(4744005)(186003)(8936002)(966005)(38100700002)(6666004)(6486002)(110136005)(7696005)(83380400001)(478600001)(4326008)(2616005)(956004)(66476007)(66946007)(52116002)(2906002)(66556008)(38350700002)(36756003)(86362001)(8676002)(316002)(103116003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Mi9aRGoyRmlLU1Axc3oyQlYvdEtrQVozMGpUUVNueFBkTzBLWEFFaHkrdGpX?=
 =?utf-8?B?YkNqU01SMnF1amEvOGE0dnlUMnJ6d1ZRY1g4S0NocDZrWkNNSjJUcm55b0tH?=
 =?utf-8?B?L1BSQytINnpUTnV1a1h3cDVkMSt2cFZXRHNHS3ZNMXQwS1UvTDBWeGE5Ti94?=
 =?utf-8?B?NnJmb3NtVUJMV1J5Y0ZnMkk4SC80Mm9NOC9JZjNWSmUraUE1OHFCM3pVbVVr?=
 =?utf-8?B?b3BaTVZ4cCtNUnZtTkZtcnE1Z2IrNmNnNWtjZ0RvTSthVzBEanBmdE45YnNr?=
 =?utf-8?B?Zno0dHovYW82VStqZndOVG56SXVJQnhHWW1kSXdydEhlc2FMcExUWHpJWUdU?=
 =?utf-8?B?LzUvZHBKZnRZMFFZR1FreDhxbnZScnlCZFk1Zm1qZDBDZHQxSDQ3YW1TSmpP?=
 =?utf-8?B?MjE1V0VGZ2JRUEtjZncvQnEyckRpUjRTNGZDZVg4TkE2UWJIUjJMd2dueHZq?=
 =?utf-8?B?K0lINFM1bW9zWXRPM2xpZFVua2l5d05VQ3UybzZzelFraTZjUkgySEVmTFM0?=
 =?utf-8?B?ZEpHdnB4QzF5M1VhNFRUTWE4MUZEK1FVcDgxVDcyNUtkUmI5NEV4UUlCSVJL?=
 =?utf-8?B?WTRBQzUyNGlMQ0pwdnJ0cEtvWmJ3d2FFd0p6VWVUd1VjYllDVzRwbnprcmtM?=
 =?utf-8?B?WlUzcG43bnZyeGl3OUo1bWY0Y0RFT3hxRlpLS0lGWUQvRkdVMk0zclk4ekRW?=
 =?utf-8?B?NXVMeXVtRDNPejkwQ3BYMXNOdTVadWFwVGFSam9JMkNwVklMK3c1VmhRNWFn?=
 =?utf-8?B?TmJSSVNha0ZkWFFFMkcwUEN1NFpESXBqSzdwYk8wK2JzNmhzSzhQT015anhr?=
 =?utf-8?B?MGdVWDNkTjhsTmxxeDFkekhNS0VOTEJWRzNWclBPVEExN3RiS2x5R3VPQnBs?=
 =?utf-8?B?SzRoRWp3RE1yQjZZZXRKeVhhaDVpQkg1dFNzd0NCM3JWdDREaFhPSUJNcDhT?=
 =?utf-8?B?TkNrcll2bHVuQkZqVHJ0azRwUmViRWZQYXp6b1JyanVEVGprRm5TeGNoclB4?=
 =?utf-8?B?RUxxRXVGQ1d1ZUhyc0hrZVFUU0xDSEpuSUVQbi9tWHJpcVQrNXI2MDR1WWRH?=
 =?utf-8?B?bEdNempVNlhqU0JsNU1HOVFUT3RTY0ZuaXBWclJMNUJLVGt4YjlFMW42ck4r?=
 =?utf-8?B?WjVCUlhBMXRweFMvcVUzU25GdWVoallOSkt4R0JrNE9qc2kyWUx4R3c1OHVq?=
 =?utf-8?B?eDNTVDdkQ1ZqcG1aOUlUTk5FREQ3V01hdG9ELzdMK0lLd0xkMGJVSjB4VUYr?=
 =?utf-8?B?Q0FVck9RUXdXMTNxMk1wTXhSNi84S1BuZjFnM0xaK0NxTnNJSndFdUhKdllZ?=
 =?utf-8?B?NzUrMDRrb1NOYm1DM2hzUkJGcXBPeTR3Z0ZVcVh1WDkzekhyUVVvRmV0aTAy?=
 =?utf-8?B?T1A4anl1WDNPS0NBMzBDd0N3ZjZQSDh0VTU3alBvV2htTVpPOXYwc3dGMkpk?=
 =?utf-8?B?RFQwQ0pCalFJY1A3bW9MNDJFZVJOd3pSemM5V0RXZVZidXV2UTNPQ0RxL3Bl?=
 =?utf-8?B?b2o2cWtWQnlBSVlNZVFCOHhSUUxaalRoQSs1MkFtUHFUd2dqLzhzbkdOWGlu?=
 =?utf-8?B?LzRUalAyWXp2b3FLUVlHRGtTTk1FV0puSCtqK3pJbVY5V1NYSnBoUUhaeTF6?=
 =?utf-8?B?WEMxaTdVYTVFejd6YmMvWnhPRDRWajFTeVcxWjJ0VjJvOHd3S1NwVkNnOU1x?=
 =?utf-8?B?SlVkajlKOElmZDNEOEVscWRRVFA5dmdWWEozeWlueEpIdUZPL1N6RXBsYWVu?=
 =?utf-8?Q?tUtQUNWDWR9bzpvcW7xvWB9de5Ki6SAMldU+CnD?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: fa544668-898e-4a1c-9754-08d966b41922
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Aug 2021 04:03:15.3182
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: PJg1vAAS5OxhIJqdLA0Rcvl5LF3l6SKscrdxXXX/d7oCGUAZvIRjZn+vZ+hX/FVlRIyHzJ8uPU1+9ffXnA7/O/YJGvjQ6dQmxj3ZFXNf46E=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5529
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10085 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 mlxlogscore=999 suspectscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108240024
X-Proofpoint-ORIG-GUID: -JCPme-rA9ZNa_ZaBmz1JR_57u2RZ4Rh
X-Proofpoint-GUID: -JCPme-rA9ZNa_ZaBmz1JR_57u2RZ4Rh
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 17 Aug 2021 09:53:06 +0200, mwilck@suse.com wrote:

> From: Hannes Reinecke <hare@suse.de>
> 
> The initial device scan might take some time, and there really is
> no need to wait for it during probe().
> So return immediately from scsi_scan_host() during probe() and avoid
> any udev stalls during booting.
> 
> [...]

Applied to 5.15/scsi-queue, thanks!

[1/1] ibmvfc: do not wait for initial device scan
      https://git.kernel.org/mkp/scsi/c/7a3795f28795

-- 
Martin K. Petersen	Oracle Linux Engineering
