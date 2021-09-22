Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1D4E2C433F5
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0688B6109F
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Sep 2021 04:46:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhIVEra (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Sep 2021 00:47:30 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:27018 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231733AbhIVErQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 22 Sep 2021 00:47:16 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 18M22UF9013621;
        Wed, 22 Sep 2021 04:45:40 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=bT+IW4ihir+iGiciMyDn6q0JUFtAlYavSL8wpPdEQnM=;
 b=V1qpib1AtmDKkJYGd5h7Uhlv+96oDMj+LPKTa82+uK3aEU3KDiOZLgLBXCAliWgd/e4J
 ezSW0lsfcz1LA8q9kkMS1UEHXUXzNAC6DtN8zH8TJwpBd0qM8ufpr6VLTS7NSVKdg+t5
 V1yJIc7E/9LgYSmeJ+bAK0NYDGmyAFM2WVfijIvPOImpLJCoNhzQO+wtu/HlDQnowdVX
 C/tG8ppDvVQM3mckd2zywMYY9C8LotIlCb8uCgflCRRhgZ/8tIzMSnYEKPodvXXkEG16
 zQF2EOuuUaRZNWGYbFfKkPSzvZ6EnXThmMKWj+OJHZv5Gp/ZuQTMCqxKYGJfPGXvWXco iw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3b7q4s1b68-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:40 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 18M4jZs7178811;
        Wed, 22 Sep 2021 04:45:39 GMT
Received: from nam12-bn8-obe.outbound.protection.outlook.com (mail-bn8nam12lp2177.outbound.protection.outlook.com [104.47.55.177])
        by userp3030.oracle.com with ESMTP id 3b7q5mc7nu-5
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 22 Sep 2021 04:45:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JVkEjoLhAuuhpQCuA0Lx1vc3tgU3T/IGvgihvZ7qwJS82e7XXXay08xILFZg6q6l62KWvlbamP2W36XpKbu+jGStesHfirPOiXcsRIZ+P5na1B09omIj70TYTpWNWtqcay+MgY4I839aWbWrqic2PYo+2Tz4sYxfumwCl3/mVG1kKdt+zymSnFtTrO+tptzKi/XC42coz7mLbPjr8qGNouxNIxAU38B1Xdcfcm2ynWYxfqUwcNpnsVbIdNhodCx5x6YVijWi1yHS5Ase1uaNWsnKTL+3VBJXu4XJ5O/Zfb0QLFVrYHrA91KFar2J10SNrRva0vpcjto4fNaTJCZPag==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=bT+IW4ihir+iGiciMyDn6q0JUFtAlYavSL8wpPdEQnM=;
 b=NsnWBq/mQ1oqsYHrRSmqh9O9TG/e9E/cZUWCT8akqFAshL6Fj+5E3fi42gHGfKmBLEJewB2a+KpWm2Ys9fhqrMtEVVpNdcCp51JDVyBfO9Iv5lZatk5I2YPXH0oafMJh/8l0XnYWKKt54GWZXuIO3soK7KYWjnTQYmvNaqoECasgGjWnRZMLPNOIo8oXVPMn1ZhYixMZnq1CFAs1bKM9lokZWfuGelwHAEXwNV8r6HfBJKpwRmmczRRNO8FQsFRPlIQpZvFJULAP1kIFw6uc9rrtQQ+hRpXSBHJnzItOye418NfPfbGVwyEchGdQlUlBrPb5v0vLYKK27n12XE0+3w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bT+IW4ihir+iGiciMyDn6q0JUFtAlYavSL8wpPdEQnM=;
 b=YcPfa5vbbAqOdzsHofY7YNNcAPq2ASjt10SkxfxuTfZeRxEue4U8XC8r1SMWkLl8u5OIhSDF5xi15l45Gv5wAWgWpbApUTYy2vzVW1YOOAqtQGATfC76BkyqjttT0IuNZIzPVxsChHDZIfMH/0uHdLQN43u07h/3h0BWwU1KBeM=
Authentication-Results: linux.ibm.com; dkim=none (message not signed)
 header.d=none;linux.ibm.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4456.namprd10.prod.outlook.com (2603:10b6:510:43::19) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4544.13; Wed, 22 Sep
 2021 04:45:34 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::c0ed:36a0:7bc8:f2dc%7]) with mapi id 15.20.4523.018; Wed, 22 Sep 2021
 04:45:34 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     jejb@linux.ibm.com, John Garry <john.garry@huawei.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 0/5] hisi_sas: Some misc patches for next
Date:   Wed, 22 Sep 2021 00:45:18 -0400
Message-Id: <163228527477.25516.9226260844988221578.b4-ty@oracle.com>
X-Mailer: git-send-email 2.32.0
In-Reply-To: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
References: <1629799260-120116-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SA0PR11CA0154.namprd11.prod.outlook.com
 (2603:10b6:806:1bb::9) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SA0PR11CA0154.namprd11.prod.outlook.com (2603:10b6:806:1bb::9) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4523.14 via Frontend Transport; Wed, 22 Sep 2021 04:45:33 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 91001b10-fbd3-4c87-5d39-08d97d83d04b
X-MS-TrafficTypeDiagnostic: PH0PR10MB4456:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4456FBDCDD55A32C72F944288EA29@PH0PR10MB4456.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:972;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UXKV9v1OLlhNtP+6RzqgVY94Evqn5LAlKmISd7RlzbWFQJHpgV9fhT6MmTxdPl9PBFEkmagymBW5QXXRvzOCqvCXtL5lXS27jfOSGb5GjLccBHztc1uu6rD7Th8f45aNIDbqysXcZ08eSbsNdTppD0tdm9/8CN3YqzXGNSrn1VzASJ+Qgjaxp6zT37ytg8CHdpgudXrJG+FrwPA4uEPYJ+e04KZRG4C/ec+2ioGZhaaaSM91ccmY1a/Srt9WlNvEtA70bUdqJWbgDoxir1h8l7OyvF0kWyHJ7MLdONZwhViRRdTyeVbp3vostJmrfplmQ6uwK3zoZIpCL9xWfX05P9ijVHsVZQ+yMGk395wj9AmIempL63R9q9k0KFLP2NgA7l9IJCmtlHfpVPGc9X5s2LjUk3nMh0bIBy4WMnDSdyeMJd0UG5OyDbKicSKN8ni5T0oCpTrPtutKRJAk8r7HUL1dRj3z7HLIBC9egW9oNbVC6fFkMty57nid9r1b+TkN9CZLisy5eg9mq9AhzJNZbBpb07aTvlnBNSbVHI3WgiotUA2OE2s8tpIplCVepYg1e+Ei3hZR1sX0hbXO9kqeOYRcJI5vETUv7+j9mEyBB8WSKjWcplVFlattjyGz3lT4wWTLa83jKonxPG1G0/5FSv1xcEShK2ZmftWmNznchd3z2SGZc3oTVi7ZJRRS/Eg2GdR9Cf7jp3UFBRCs3thna9D3gp/pWw4WEmMwbqh63d6zDks+QgmFVTFtFn7o4wut1qGvLOXHNWNpPtK5UlVzMzlyC7JKyxfjSQzaVr6xkoWOkf0gZOdJUeCMun/PLTC660zc7Rlcfgcfqkzuo1Jj3A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(966005)(36756003)(6916009)(86362001)(2616005)(4326008)(508600001)(2906002)(8676002)(6666004)(66476007)(38100700002)(26005)(52116002)(103116003)(66556008)(5660300002)(66946007)(7696005)(6486002)(4744005)(186003)(38350700002)(8936002)(316002)(956004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aG54eUNFS25nQjNhWktHT2hvdU9XTnhBKy9tUFhZRTFUa1BHd00vSXNiU213?=
 =?utf-8?B?SnN1aVNkZXFOOE9nd0hKRnA1dTBOeXl0OHFzemtIUHMzQWVzTG1KMkgrdHdn?=
 =?utf-8?B?a01kaXZzdWlJSlNjVG9mYk1aejRnZmc1QWtiZEtIZ2c0ejNLWHJMb25SbDZV?=
 =?utf-8?B?aDQ5clN5aUNpRG5FaXIvOVVGQ2VVK0dBZHBVanM3TkNTUE4zVTJKaU9kMnRs?=
 =?utf-8?B?elFqZWR3RDY3N0phZWh1dzZ5ZC9HU1FvaG1ERW1YcCs1ckhheUh0QWwweDlG?=
 =?utf-8?B?QzB3b2d2blFjSDU4eUdrSnVick11QkxOWWFFUTRlZkEwZm5pT2JhK1AyeDZW?=
 =?utf-8?B?S210c0VvMTlvUEh3cmkwQXBpNlFtTXJMSnF2UC8vZ3gxT2VFTjV1MEtBZWJw?=
 =?utf-8?B?b1ExSDBTV09WbmhrazJNblR3U0NtZkNpcWVQM2JRM09DRmFOMlRpUmVrekxx?=
 =?utf-8?B?TkhzREN3RXFJUUJMUHV0eElLSXE2Q1UzaGNMZnFCb3JxbTE5R3VzVlN2Ym9B?=
 =?utf-8?B?SGU0N3E2NjZCTUxxUS9xcTRTd3pDU1NTOHM5NmhYQ0FSN3hCSEtXbTZId3dn?=
 =?utf-8?B?SHNFVWFsTmxWa1BYcW01VU1yZi81Y25KVm4wTmIwTXVLL3QrWGtXUFNITFJE?=
 =?utf-8?B?YUpTNW9yVjRpQzgvbVNlcVovTDdnV3Z5dDlxODhYK3hnSmlrUTlxWnhMRnMy?=
 =?utf-8?B?YitjU0N0WkRkOTFPRUZ5L0l1cUJhdC9KUitQNXdRVHdBdnpMOUdpczdQOENi?=
 =?utf-8?B?aExBTDY2bHJkUzhqUkYwTThJYTA4T1RGNnpaQVhGLzZ1Nk4vTjRVQnVGR2Iz?=
 =?utf-8?B?UDdGb2R1MklYd3h4b0sxUVRZODVhYmYvdDhvWDNVU0U0eENBcFphR1d5ZHlY?=
 =?utf-8?B?TzhFYlNCTWRROGo4alJ2WVBRaGF4Qk5ZT2lJQytRY1A4WEViYThEVWYwRUxy?=
 =?utf-8?B?T1JRM3ZuS0QvMEpwZ0p6Q1VGL25DYk13TWwzbXdqUlk1QTdZMFFCUUJ4b1hJ?=
 =?utf-8?B?azdMYldXVkdtamNSYnh5enZpK1JEcTR3djF2UVhVYjZjamQvMnVZVG1iOVlp?=
 =?utf-8?B?Yzd3Z1UzQVJUSEtIQzNmR0lBYk90Y1JTd0JDK3MySUhtWThtL1dRWU04NkVt?=
 =?utf-8?B?UXRCOU1NYkFRUlpQU3Bsb0JnSEtFMW51MTFuK2xLOEROcXhMMytPT3E2anhM?=
 =?utf-8?B?ZlZvZTY1N3ZGRjBMNWNaWmpGTXAyS1lTYWhvdFZwTmdFN2g2ZU5EWkc3ZEhn?=
 =?utf-8?B?TWdrVzdNc3FGVGp2ZjVpVzRqRGxKQlp5dDJidjVsTzBxQTVtUHlyR094RlBH?=
 =?utf-8?B?b2VSWHJmNm91QUN0c2Y4QzZJQ3M2SkJZcXpMV2tsQnBZcVNWT2pqUHlqUzhY?=
 =?utf-8?B?b1hIVXFZT3ZRZHQ3anluei9SZGI2ZXpTendiSklaMDdJUzVOTXFicHhwNkh0?=
 =?utf-8?B?OFIzekRtY1NHSnArVGZBUEtZdmljb2JEOG54bmpVOVVPSVUzMFV2dDV2bmlH?=
 =?utf-8?B?RmlSNFR2V3N0ZXVUbWZMQzg3c2VXUmZZck1FSnZKVDRsWG0rU1VZSWMyakFp?=
 =?utf-8?B?cVBwaTNGK0pnbUEwSmZsb0dWWXE1QmU0a0daNHZjdmNSTGdDV01JcFdyU3Nv?=
 =?utf-8?B?RUlBVWFGMytkMXZ5WTZhUnpNWERtODhmOFViZG9idmw2UElGUERHUXNxeVlG?=
 =?utf-8?B?ZFk0TS9NZ1lVaVBaYkZJWno2aEtkZTVQOGZGZytYN200OUdydUZ1STU4K0hL?=
 =?utf-8?Q?6cgPjc9cSeJCvBWMDxXuvDKP7JIFIyzFxNp+ytJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 91001b10-fbd3-4c87-5d39-08d97d83d04b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 22 Sep 2021 04:45:34.0066
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 3wCo3a5l2TFdoI1yiIgCYg6R2qehuGuhlVdl4LdPwFJx9sDmvhdve+AiQcHhtIllmkjGfgdtp8MtPfuQ/5BtGyDqvIHXx5MBWIPAdGwQ5Ds=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4456
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10114 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 mlxlogscore=999
 spamscore=0 malwarescore=0 adultscore=0 mlxscore=0 bulkscore=0
 suspectscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109200000 definitions=main-2109220030
X-Proofpoint-GUID: CJPzHbjxvkMgfs0kLgFO5fE94BpEPGIx
X-Proofpoint-ORIG-GUID: CJPzHbjxvkMgfs0kLgFO5fE94BpEPGIx
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 24 Aug 2021 18:00:55 +0800, John Garry wrote:

> This series contains some minor misc patches, including:
> - Fix debugfs dump index
> - Stop printing #hw queues
> - Use PCI managed functions
> - Some timer changes
> 
> Thanks in advance!
> 
> [...]

Applied to 5.16/scsi-queue, thanks!

[1/5] scsi: hisi_sas: Use managed PCI functions
      https://git.kernel.org/mkp/scsi/c/4f6094f1663e
[2/5] scsi: hisi_sas: Remove print in v3 hw probe about #hw queues
      https://git.kernel.org/mkp/scsi/c/089226ef6a08
[3/5] scsi: hisi_sas: Rename HISI_SAS_{RESET -> RESETTING}_BIT
      https://git.kernel.org/mkp/scsi/c/b5a9fa20e3bf
[4/5] scsi: hisi_sas: Replace some del_timer() calls with del_timer_sync()
      https://git.kernel.org/mkp/scsi/c/080b4f976bf7
[5/5] scsi: hisi_sas: Increase debugfs_dump_index after dump is completed
      https://git.kernel.org/mkp/scsi/c/9aec5ffa6e39

-- 
Martin K. Petersen	Oracle Linux Engineering
