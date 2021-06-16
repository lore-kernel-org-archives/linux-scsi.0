Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE57EC48BE8
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C770761042
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:50:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231461AbhFPDwI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:52:08 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:4180 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhFPDvm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:42 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3ktsM018355;
        Wed, 16 Jun 2021 03:49:34 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fmLraF5qTSqW25wsPlysxz1roI6KOUudrvc6pNDRzyM=;
 b=BpQZtvHPPT7fY2l9EugGzHYrG/KjaB3w5G43a9B6YQeSxxuNHphxNPGPD0vgT8t/pNQu
 Pr5Gh2KBBpHJ+OUWFG97qmBT9mcqZrRo/v3jQtz5h3dxsXEVu+4CKWcbrv6Lhkiix+Kz
 t7D8aCNZNx3IKzHPIN8YWazgz1AyLdisQ0XqlyY6QVGGuzQ/keDxc6JQvgWcvuPQJ1dT
 7v93NaEVoD/iOur8SgFEOMoZGjU7MUmULnZJmPDdTzYQDzAXvQZk/XVYnP7Wgb5FEopB
 Gyr/DSgeWd974hcZUhLJRtvqMdi7XKG7nTF37CchQyfAmNLgDvfZiuFk+BqJG18mqtNv MA== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x06ht11-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3jGKU147463;
        Wed, 16 Jun 2021 03:49:33 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2177.outbound.protection.outlook.com [104.47.58.177])
        by aserp3030.oracle.com with ESMTP id 396watxnu2-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:33 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=YmeQzwVf5iFGgf/CHI/GNZmJZkz0WA+7+U9IM3wEqtRJWuzxunnySDakUvEenxTL/F4ToAQV4B+hfmCZeBCA5gawCZ1LTGP7ZXZgYp2Pjbovpce0bVcZ3GJJsY7iftjCaUVcU58scPzqpE/C6IqK1rvjiSsa2zLmNxWdhHTRk0h+atyuZe9e7wdAkijUR01cLdBhMdmHG32DS7kpvTHfGuU8fWo1RjEZJITK3U4IHnujtqyZI6Ss32ZLdu/DV5lT7oglQPxxUeI9N5F8zV+7e7+OoIa0klVHkFZwKKllxGlJGIGkRMKhk4RxzWeWHbIAPsxcq2w7R+wKm1HTbbh9ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmLraF5qTSqW25wsPlysxz1roI6KOUudrvc6pNDRzyM=;
 b=eltsIryfycORvHYhn8wDBNEP63lkJxbDvAgq8BJoNDa3/nuUe1yENC5LVsRNl4MYIntsw5NyTSVxqCB1+An7oEBJ19fJOza+r0k0NQjX2pC6k0XUEdY2ZIKGJ3CQ2OaZfffpEUSJfV8qA/4lUiMSUUspx4go0YcNlrFESkbXdbTxKHvBA5HR4SFUHU/lqFT8VR+yRgwOmzsMr+hnTy3a3XIrn2czTzcSEXMnu2ZmIlgfqUf3ON8nu2Wa5HFAdrClE5/cxe+VBjX9yIOWDItqauTfHX5I7hiHrj6drqqpxyNoxm5hcTAmjFrbMCzzrN4+WPN7u2+e2uZ5OS0Q6Yamhg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fmLraF5qTSqW25wsPlysxz1roI6KOUudrvc6pNDRzyM=;
 b=EE91D2ISHNd/TkB6cWYcMdwaCGRxAQvBH2LHwwrqw1+Y7AB68QEM76w8myySQ+glgOLNwGqgbInifAVhbhCw4DICegh0Nj1sfhIQslifGv0qGKIjmt3+bSOoKXpA76Ol5Ezi/7Ny5FH9MYPLvkG9l1oUW8WCq+vC0tTJ/LYZ84o=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4725.namprd10.prod.outlook.com (2603:10b6:510:3e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15; Wed, 16 Jun
 2021 03:49:31 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:31 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, Tomas Henzl <thenzl@redhat.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        kashyap.desai@broadcom.com, sathya.prakash@broadcom.com
Subject: Re: [PATCH V2] mpi3mr: fix a double free
Date:   Tue, 15 Jun 2021 23:49:04 -0400
Message-Id: <162381524896.11966.7071705174552880319.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210608145712.16386-1-thenzl@redhat.com>
References: <20210608145712.16386-1-thenzl@redhat.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:30 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 704a1373-84f3-4c1c-c4e7-08d93079bf95
X-MS-TrafficTypeDiagnostic: PH0PR10MB4725:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB472521943A44406AA430C40E8E0F9@PH0PR10MB4725.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:2150;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YKNuRD4ddRHvyBQGGG2c1wpWZCRxTG3gWqNAqXJ13ozJs4Qv6vL4e/nvFgf45mEmxHF6/kU2LyOz1I0nO80XQ0brex03KNjqKewIEhH2dMTTE2zlQv9ZNhCqMY/laNEoomaqovzRYYSnI7oam1BEThUASdQTdXrZqQAucxn8IKY5KpJc28xrMY0df1CRGl+4f0eRDhKVfeOMfVmjXXrB+ouQ6+eTzExIKXA8M3ZOYjaH1O9mvIdO82JiAfh2BqJyczdixiVLxI3wGSTkrvST2n+MLlA0uHQmHwubjFuRkQIlGniFyzUIpaGwzq5l5IRhuo0jq4FJye2qO42C+XM9DBNcef8OYQYS7SSy/cRdFZWr7ODEElvFsipZI5m9ANb5zF85aqTqdXam4MkJ5EMuEaGaNyuExbOgSHR4zN02N4Dh7g7uu0t2gM8plJYVTmrCE47qwrtkVNe/0ZHhMYo41+3adsa7n/xOTbAn8TG1V83Fs9pZ3+PMj6Nnxj72hKY+9xcN37oOE7OC6c8pnGcHtuUXAYajRUty8cpqGAVKvsmQPCZBACTTz2j1uAbps4Tj6voCL12sYRNqklxbWNG2sH+SO/FGBq272Jo4l3maPSd6HsCVkBgyBhlcAgIe48ohVQN212A3C8BQRMzYQ1SnDYu/tBSqoc/GSVsocn6wwuokDwhujSIz29asWq/JT0lJquJY6znJPdrWD7SXS0qg2qAYKu2mzCRjJeBeJJd7n/UChldrpbSnhmUHynXrGZZoRqTHyrEi93qN/Q/Rge9V8Hu4P4VMEiWEcyA9In9cdAg=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(376002)(346002)(366004)(396003)(39860400002)(2616005)(956004)(36756003)(316002)(6666004)(7696005)(52116002)(6486002)(478600001)(26005)(186003)(16526019)(966005)(4744005)(6916009)(8936002)(2906002)(86362001)(66476007)(66556008)(66946007)(103116003)(4326008)(8676002)(38350700002)(5660300002)(38100700002)(32563001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?RkM1T3Q2cnN2aVRjNDZBMkE5M1h1V250elVEa1hSbjNpUnNoOGZvQW1wNG1W?=
 =?utf-8?B?SkJoRk1GZkhpZXBQby9hbmZmSTh4MTJwNXdKS0tEdm9GSzNteWpNTm52OUJQ?=
 =?utf-8?B?S2dVOGlraGNVNExtVUorVE4zNFZLK3Vib2Z6ZmJqL3NXc2Y1ZENNU1hvdHFK?=
 =?utf-8?B?VFhVODA3MXVsaHlHOEw4NXhwcjNrWUNGRENhWE5zc2FOVU1OTDF3a1cwUlRX?=
 =?utf-8?B?NE9QK0gzaGMwU3JyTnNQRDdrSGxrdHZkZTdybk1BcDlnVmUzZThtN2FUYXUz?=
 =?utf-8?B?WlNTVTBvVUZuL1NzOEpwUkt3OGVidGZLZ2xsQU1jWEcrQVJ6RmQwVFRYSU1m?=
 =?utf-8?B?dHk3UkhqdlhTYmptWkdsMW5NZXFYb1FheGx6S2JMUXJzanp2SHl2aFlGaHFo?=
 =?utf-8?B?ZDUvY2hOQ2h0Tm1TWHo5U1RvbytFRXRSZFBmKzMrbUdGVGVIRVRiWEI4Y3Nz?=
 =?utf-8?B?RUNxdWpRbjZSc0Zkc2JiQmliRnZrUlk1L0t5QkFFZW9aNEpkUjJwVlRWbmox?=
 =?utf-8?B?SXRCYnNqZlh0NGliQlhFclpFMXdWMVFmZWNSTlREcUhVd2FuTHNlcnFtUmNm?=
 =?utf-8?B?dVRxOStOOHI3QVdIMlE0TnZqNCtWQkJ3MjBtK0d5Vyt1T0M5a0RhZkZBUjZP?=
 =?utf-8?B?VmRBOHY1dWpPRk1iYWUrcS9jRGFZZlUwS0gyQjA4QnhpZ2pkUjg3RElibVQ1?=
 =?utf-8?B?aXd3VlhURXBwelJUeGk3bWUxNVlOWWRFRyt1NEQ2Z0d6NkMxQUZlUkQwNDk5?=
 =?utf-8?B?dnFac0J0Tk5VckJRRHlzYUhVVHcwM0o0RmNyRWFTWldsTGhUeGtpNkJ4VG9Q?=
 =?utf-8?B?akpjdzBURXJOcmR4aWJFcVFjTU9ra1QzL3RzdjZQek5SWWVrQ2FTN1VNMmQ0?=
 =?utf-8?B?aHpGRXRMQ21UaXlMZS9wRDY3T0ZsTklYM05sNWFIaDhEbXpCb3JTYk91SnNl?=
 =?utf-8?B?UDRqUmJOODVBRHpzU0daTktBMFJtVTZVcUM1SXkvNkh4MzRiOFlMQmpIV0FU?=
 =?utf-8?B?Sk1XcDlSMEgxbTlVVFF0ZWJqSXM5a2IxY1dVaVJCK1YyMklqelNZRnVYWHFj?=
 =?utf-8?B?Witobk8vY2NMekF6NzVTdG5IbktpMytGejJFSVBFbjhjYzdSY0xEbDVzZk9N?=
 =?utf-8?B?dzJHRlRvUVoxalJ1TGpzdUEzMW5NeURIdFNHQUxjM0xHRWRJV1dicitweDd0?=
 =?utf-8?B?OUFSclM2anZoTU9DVkNDYXh5Q0Vxbk1URUhnbDgzRTUzZ2VQdUg2S0hLUU5Y?=
 =?utf-8?B?bkwyVlFjZUNrRVlqc2N2V1lzM0F2WFE5OHhVM2JpL3dsNG84TnQ4QjF0bENp?=
 =?utf-8?B?MTZUL3NIZTcxOGtrbU4xVnhhRXpxK2lxclZCdnhBMC9LTDNZY3R3N3F1VFFu?=
 =?utf-8?B?TDJ1KytTQ2NWdm5TU3NXQVphZFl3QWtsd2svZ0NFMG5aOFJQcy95bWRFcW1K?=
 =?utf-8?B?NWVaOGxESXFaek82VjMxMVM4Rzh1Z0xVMXlZTnZaUkFsUXhUWWZ5aWJwUEZG?=
 =?utf-8?B?VmRFcnRIZm9TNmxxaktiRVI2RWIweFh2bmhrZE0rOVJ6SDdOYjZxZEVZK0lG?=
 =?utf-8?B?dXVvUGQ1aFZkQ3JPNjRtcmxkdEZzMVNYakduSzRSRXU0NHlENEFCR3hUL25V?=
 =?utf-8?B?TTVGVHhWay9PZlpCTHdINXFNcmZzT2U5TStWMVRMM2lDOU1uQUZZdGl0YzM0?=
 =?utf-8?B?ZHVGL212eVBQV3dlcWR1M0NRemNkMzJ2ZTNqWmQyam5wVXg2aTZ3eFliQmxr?=
 =?utf-8?Q?wwoBSTEHqPwfugS6OykAFJx9SXU5thuLkCS9sdy?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 704a1373-84f3-4c1c-c4e7-08d93079bf95
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:31.5216
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: WUp5oT3jCIHjHYn4UDiqRpJ6K6uiglpYdc1iwvD+NUZwEuxASuOkomyjKzRi08HQLycgaOjwWRIhmbKLYWc//R1ndQ2Q9gS3o4XkewWYtGE=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4725
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 suspectscore=0
 mlxlogscore=951 bulkscore=0 mlxscore=0 spamscore=0 adultscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: srsX6jwHLLaBWkM1j7RLiBG9xoUAlDFD
X-Proofpoint-GUID: srsX6jwHLLaBWkM1j7RLiBG9xoUAlDFD
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 8 Jun 2021 16:57:12 +0200, Tomas Henzl wrote:

> Fix a double free, scsi_tgt_priv_data will be freed
> in mpi3mr_target_destroy so remove the kfree from
> mpi3mr_target_alloc.
> I've also removed few unneeded initialisations.

Applied to 5.14/scsi-queue, thanks!

[1/1] mpi3mr: fix a double free
      https://git.kernel.org/mkp/scsi/c/d3d61f9c8c2d

-- 
Martin K. Petersen	Oracle Linux Engineering
