Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5F5DC49EA3
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D316561042
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231344AbhFPDvo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:44 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:63130 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231250AbhFPDve (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:34 -0400
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3jde9005722;
        Wed, 16 Jun 2021 03:49:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=oX52HWnlu03dvxjs0Ra3veiOq8eQ+oLgiH6Dr//2FE4=;
 b=0ifhe3HJFnVlviWJgJpsy68V0fMqIHF+gfL1fXNOaxYfv4igdtFxTp9zHfM3Nn6E5T9G
 QlTNKMkiUSKEyLNnAb5n7cdeH7NIlpSFo3DSao9XJc8x0z2yiUnYLEbXZeMuJ8p3jarb
 HHwcIRpLgnsvssA22eANITiJyftrwKn2vcFM0LPcqOEZz38PL2/tQ5o4NJgXDDe9m5uK
 LU7AICaAQ6OGHsLobsTAx7nsnAWFXs1AVpyAX3PfdDvdTUu4mTn16qbdTw8q6E3ZVoB0
 /HB/RxZwA/8899srntz5284Qe8nyfDPOl0CNug4xI2KxNosjuHfTaljqWrPSDQDqnJFV Tg== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 395x9qstxv-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:19 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3j1aK033805;
        Wed, 16 Jun 2021 03:49:18 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2175.outbound.protection.outlook.com [104.47.59.175])
        by aserp3020.oracle.com with ESMTP id 396was6ymn-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:17 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=C3HVRMt+L3BVo1TiQHrijWCS0ooIHCxkpekI+0As6zDeA7FDg03z4g7j40f9xlZNE8NGXTzzA2N5XmQqvxEHBGfz37mrx6UNHsH0q7SD7fptQBK8zSet/ELFaPPzTx/UppGzJJ2fNYxUgm6V7ZLqjeLSCN344vs2MDo2UwEEC1Y+eeF9FDiRnBYIqWmAyvnhNM1CXeS01sB22S46WAelQ1imOMXocrdBR2/Mt7xIE4pisdm9Oi7xPNinspbroMDnVWigOmbuSBdeXdwW0Jf1KIDkcPyFPObeRSszFNxS5MZk7q3iYtvkHtFyippIxFjCmt9W3f9tPtZJbUda+8ncVw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX52HWnlu03dvxjs0Ra3veiOq8eQ+oLgiH6Dr//2FE4=;
 b=CvjUI1knmcYDnkEthe1elcME3/HiIWdp42Ct2QVTy4DjgnCn4ZFXId908zVKBMO+WPvIGMGuGdcJnuOJRvquQsQ4bPNujNq+/Nld665KHgR/b9PJkGHQQP4wEZVq5HvrINnbR/y8gTmCzStnSFPag1XhgnnEnPllZXYJcJGnyOvvnMSbLJF7rkEHJZ6ds3O+9axsMdFl5lhtcI9LZtWTvEAi5r2Y1oAWjUxTAsIOOJxNdCJpBgWQgOZ1iEWCjj7a3LSGTnzCqDe/TaolfMsLS54kt/UVon81fTcxCR32zJvwuma07x1kfU022txpPWDpCQwVYuY5HYXI6UzO7STT0g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=oX52HWnlu03dvxjs0Ra3veiOq8eQ+oLgiH6Dr//2FE4=;
 b=W9AqLJxoOKIg6zUnBQcCFnlfrT0q1UJaA+3gLaJJI1q5GS5FnV8XgzGTMXVTX5v1a6fbz4XmNBq94Vm7bRRlk79CjU0WUFgSSfKo591G3NzH53pd/01BcbijsAM5kS0IV+ufcX4V9HAj85tCvI9+IQ77X+3OxBxWAX5PJ7NlXEo=
Authentication-Results: suse.de; dkim=none (message not signed)
 header.d=none;suse.de; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:16 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:16 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     Hannes Reinecke <hare@suse.de>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Martin Wilck <mwilck@suse.com>,
        kernel-janitors@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Ewan D. Milne" <emilne@redhat.com>,
        John Pittman <jpittman@redhat.com>
Subject: Re: [PATCH] scsi: scsi_dh_alua: signedness bug in alua_rtpg()
Date:   Tue, 15 Jun 2021 23:48:53 -0400
Message-Id: <162381524895.11966.12473231877626113597.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <YLjMEAFNxOas1mIp@mwanda>
References: <YLjMEAFNxOas1mIp@mwanda>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:14 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 3b9181e0-8d12-44f3-f9d4-08d93079b68a
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB46635E60294B9E3E3BE7E4728E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6108;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x50p3w6g22bxcEOK+8bTjoTR1ZjS3iLAakp54tuf/RbuAMQ/Ivd7eqPE/IdDCClJQooR7DVt7LXIS6yrx2YY/sZXBAal0ZqlDDR4i6ys2C+ygxfWGBWQF7k5YUoOX6djsnp3rYYxVSGVVtKecmSQrFDZnO0DGLNcOktNnRG5MjLqDKImqG6tSbOmJ6b57EGwLyGoGruFvuvIPPOcGLLHF+MdyaVHkhTpPIVYwp/PXQbeEY6ssE3LI0L2fta5+I/FiS2aduqR9tblhYuU7HdH59Rqxxbw/x655TTcQSdjLAbaMIc12M8eeziI4xSmZNiHrdT1mca8ZifTcuBOcmvHsl6nk9EW0SJ2WxojY2ChEe8Q/LKtfFRu9TWOQLDz0E60VB3+21d8hNvjAvWnSfzXuje8MyweckDj0IDnN0OOoUdSJ7uotDfYyHmk+B8RTHZi3GNZW2/xqV5isV+Voe9Cmiu5aP9r2W8pYcvLekERbpwbnz2g2M96n+07praqikaEvHQs41RX5bmy9xiklbkSPBJa6KVa/GNOqwNvcXMlsTuZ/i1JWjRBirIPXFMUEOT7MLK+urwhqxLGYqekN8/7vaf80g8iatXeGO+EOrmCT1D+etHuEdTXrF/LrAs2ZizLJ0/SbBgCrx27XorC9ZyFZnV6PPfSf/E1YYIuhxRaU3M5JCzkjjY1pDny8RsudzYeDYP5/IjLhBURYNwL8g3CktEacVVea/+Hj46YqHJvVqmarjcdGkyKBR5/s1/ww77LNwkm2H+BWbpUsskX0UMkCQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(2906002)(16526019)(186003)(478600001)(66476007)(6666004)(110136005)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(38100700002)(86362001)(54906003);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?NWZKTFFwa21JbnUzVCtoTVJubzhVblJqSUZDa1FQbVBGQTRub29JNGpJdDdT?=
 =?utf-8?B?eVJpdmZwRDJCSm9xN3F6OEkyRVFDK0h1aGhmMjFHUy9WRjVuYk5pVm9vNXFz?=
 =?utf-8?B?bXJ3V2RCMzJ3d0huamhweXFPUURkbmcrVWxkVkpwQkFZVWo4QmxJelJiTDJw?=
 =?utf-8?B?cXhQSG45N29PRGoxMWl0RGhkdE8vR1BXNVkzZmg5M0x6SzBoWml6VnZPVzgx?=
 =?utf-8?B?Q3NEM1cvbzVBM3FUbStIeGd6K0hUSVdTeFIzaXNHV0xWK28xL2tXeXlVUExE?=
 =?utf-8?B?RkljVi80N0Y0NG9OcTUrU2FuV0VNeXFaS2lGQklodzVrRHhoeXpDSC9FdDNH?=
 =?utf-8?B?WTY4a3RJNmFEenNZbWQ0OXd6WU05MWlSMy9Idm1XRi9TM051MlpCZnY0bUs5?=
 =?utf-8?B?VkRRKzVlamNDa0hqMXdudDVNMGZjRVZVUE1CQnBRamlxRWhLN1FxSW5rYjVM?=
 =?utf-8?B?b2JPeFRyaVJQWHJ5cEZSMGFxZDUrOVZGbzNCYlZaUndlQXFvNSt0S20rRm9C?=
 =?utf-8?B?UlAwbnJJbjByeFQ2QU5nY0pFT1d5S0dhL2dwakNKUUoxRm92c25qNExrU0Rj?=
 =?utf-8?B?UDdReWhiWkE0Q3lOdk9ZUnJ5a2szM0JkeW91R2ZBTjNZWHVhV3ZaMGFXcWJO?=
 =?utf-8?B?VGszWm9vRGZ6bnAvdUQxeDVNTlRSRUNmMXZuT3NCczBtaVVpY3FBaDFIZjN3?=
 =?utf-8?B?eEsvY2l1am9MTHFPQk15OEp0MU5DZ0RVL3k0dlAzdEJ3K1Q3U0FIWmVMWUtj?=
 =?utf-8?B?MG1QZlVtaTVqMkRWMzhpZnEwN3ozOENaTGVUQTBvbldrWURrMXZvNXYrM3Jr?=
 =?utf-8?B?V2J3YUhLYnlEdjUxbzZ4YTJxRFhsbW14Y1ZpamFGc0R3Tzh5VVBuVktrbDdk?=
 =?utf-8?B?dHR6anYrUnU0NU5EUExrNmZLYXVrVFhaYmVtM2hHcE9Td2JxR25KNVFDUGI3?=
 =?utf-8?B?OTNOOEpEZmdDMGI4QWVIM2ZTakhIZEQ2UkpqNFJuUnFkOHE2Tzh4Q3llOFdt?=
 =?utf-8?B?K1NBUTErR2lXOTRIRUxOT2UrQmVmSDZXYUpNUHYvb0dMRGpWRGJBYVFwSWQ3?=
 =?utf-8?B?alBjWmIyQ3pjUjc0VnFRWG1GRlkyblNGN1p1NXhlMnBrWHViNGlRdVZKcGxa?=
 =?utf-8?B?SUdaV3hhV1liQnNQWWEwWjdiTmMveTdKLzIrZEQ5eGd6M3lSdTMxczUxak5P?=
 =?utf-8?B?eENFSGNrS29sRTZYdU5BeXVYTGVWMXlyTDRNMnYzTCtqZGxjY01tNk5FcDh2?=
 =?utf-8?B?eVBPeEE4a1JtekpVOWgrV00xY3FVeXBjUHBTbWsvWmFIU2VnZlZic0lGc1o4?=
 =?utf-8?B?RjgzTzkxSjNCM3AxamZpUHZydW82Tk82VDFqRjY4Vi9HbGh5eUNZOFhudE92?=
 =?utf-8?B?VERQRzZzNi9lN1d2dFZ4a1lTZDhHT3VMOGhxNU9IcTZlR1J5dkNsNWVUNVdG?=
 =?utf-8?B?TXhDdmorWlZoemdhaCtMVFhEbGZjVG5LK3kyWCtob2JVbUg3N1lXRkFtb3pN?=
 =?utf-8?B?SmdqL1ZHcFdXTWZzRnFqQzRScWFMSDJrT1k5QTE4Zk1JcXl0TEMwR0ZNb1Y3?=
 =?utf-8?B?QnFrdE8xbENXakpYUzNLL2NmcEppMWw5eVBYamkreTNuYjNDa1hqc2tPNzly?=
 =?utf-8?B?YVhEVWF6MkpLWlk4Snl5dXVQcEl6WDZGQVgya1ExSFRvK2p6eUs0K25PVUNv?=
 =?utf-8?B?TzM3Um9LSExoNmVIampkL3MvNFRKVTR2ZUZydGlvL0xCTElaVmw4U3lRZFNs?=
 =?utf-8?Q?zbuZnBJUCtaf7IS5SGQyaDkA4s7UHgtW874N9iF?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3b9181e0-8d12-44f3-f9d4-08d93079b68a
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:16.4091
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: rbehlkVlFHflii1yS2k6IZZqlXTnSJtRLeXAhsk82insj8SIxOxEvE95xAFK90flWFhiUYdC6m6LwZM4Sk8Y6NeYczOhMy6sBRON9uUkJg8=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 adultscore=0
 malwarescore=0 phishscore=0 spamscore=0 bulkscore=0 mlxscore=0
 mlxlogscore=945 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: 6Pw-43LWx8-hQrNrJOK22I6QrMl1NcWA
X-Proofpoint-GUID: 6Pw-43LWx8-hQrNrJOK22I6QrMl1NcWA
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Jun 2021 15:33:20 +0300, Dan Carpenter wrote:

> The "retval" variable needs to be signed for the error handling to work.

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: scsi_dh_alua: signedness bug in alua_rtpg()
      https://git.kernel.org/mkp/scsi/c/80927822e8b6

-- 
Martin K. Petersen	Oracle Linux Engineering
