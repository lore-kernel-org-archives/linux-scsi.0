Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,MSGID_FROM_MTA_HEADER,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_GIT autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BF6AEC48BE5
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A86D461042
	for <linux-scsi@archiver.kernel.org>; Wed, 16 Jun 2021 03:49:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbhFPDvz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Jun 2021 23:51:55 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:2216 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231293AbhFPDvj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 15 Jun 2021 23:51:39 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 15G3lIhq018299;
        Wed, 16 Jun 2021 03:49:33 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=USwE+ZLURCmu/jCu33nP3w75T7/BWnt1g9QUtKb7/mU=;
 b=wUb9Xzdff6svh+PqNHPA4lbLVna9ENxsvV4bn9PYRkpjKQVXQyx9v2fr1EOuUL3a4tZr
 gMOq1B/YZ5ClQ1BwkxsdBCf3ws4JsO3YK3nTVhMYpFmuIBUdXxmhnXccz3hRrTqcX4PO
 el7tQmUA5F7HkRiplbBznHiJUEPBzyyiIb2TqErpampafM4MxqIrpdZOx/EnsodO01P/
 qULWpQSfpd7wRVoCeL8YDsStc0eXJVmAV8/y796U0h7fKPyUSSP711I7yN+jfZWbMWJ1
 Y4MnM6VxDnCjnaCHwRRaGSFt+5EXvpA3NDdjjtro3KeOATwYtxdqggqpzEqU7gjTyDCj QQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 395y1ksuc7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:32 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 15G3ir64064725;
        Wed, 16 Jun 2021 03:49:31 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2171.outbound.protection.outlook.com [104.47.57.171])
        by userp3030.oracle.com with ESMTP id 396wanat0x-2
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 16 Jun 2021 03:49:31 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Lq0aeJHMZrbBlYc+FreLgacHcxZ0QtuLwat0D3Uj0Rrt38uH3wSOKpymTntZ9sD8Pj/Hl+ucmDxHnGp7kq7CcrIzaqv72VsnGeZRjMHwbY9i7XJb1Pp2KfWQNjmXxkZeNEdEOZUOer1+QWkKZzLIqd0qHOLMVYm/ietf7mDY5MvjyHfpYa0RJsxgYZ4O6Ij8KWvxuruAbFfrPWdNDMbv25CEyIVaMZTv3WweUqd85XYlp8gY3liPkAaViXYmjCzrjF9nx5syl4Z/tV8vRpzdV8LPqb2fTDV+xWNQZomO7Y5Wjl41NPirwYJuGLpYGMxLezSiDgn6FPRBVllFm8cgLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USwE+ZLURCmu/jCu33nP3w75T7/BWnt1g9QUtKb7/mU=;
 b=TI0GHyP4p5PXuytY6t10o4cIv18wJ+dQa8g/H100Zb2QFXTeUk5VLlCeBJov6gKKFhKOHUBsbe0I1lE6fECS7l/YnIxnW4vAbejHhOgMz7aQ3YzVVmkjkrmMapqJF7doNcvS9Wb5CZDR30z2ghjKvnns/4t0+fv4xlNvbjIHWfKX8wFugFX5nCsJunsrHVsUHkHnU8ICXH/q5Mfy/9scw3mOvTg5g9Msfsz4/rWVoCkOW8x8Wl478eFmAZdsqtGg5Zs1sCvZgokKKxf3czjjMJ4GqVE4bG1I3TKlM4SwE1A5xxqjgxGhLu/6w/tk4552t/hvJWi5yAiH39TsVTlv5Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=USwE+ZLURCmu/jCu33nP3w75T7/BWnt1g9QUtKb7/mU=;
 b=NMBdQeDvMOuoEL1Hgq6Rva16l7wJTVhllckFHNjROPIyIJFXihQBPBPB0Nv3oivi1NhJBBomxpQwQcqRWXrvc8W7aiLrlmjMI/UvBAvcNF6JRXMI/3l3Lb/1c9c4sMBBh6yvUkx5rrl01VF7Ef9Bqz5j7ezl6XkhczAjF76Np5I=
Authentication-Results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4663.namprd10.prod.outlook.com (2603:10b6:510:34::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4219.25; Wed, 16 Jun
 2021 03:49:30 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::4c61:9532:4af0:8796%7]) with mapi id 15.20.4242.016; Wed, 16 Jun 2021
 03:49:30 +0000
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
To:     linux-scsi@vger.kernel.org, mrangankar@marvell.com,
        Mike Christie <michael.christie@oracle.com>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 1/1] scsi: qedi: Fix host removal with running sessions
Date:   Tue, 15 Jun 2021 23:49:03 -0400
Message-Id: <162381524896.11966.6936244479457144199.b4-ty@oracle.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20210609192709.5094-1-michael.christie@oracle.com>
References: <20210609192709.5094-1-michael.christie@oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [138.3.201.9]
X-ClientProxiedBy: SJ0PR03CA0268.namprd03.prod.outlook.com
 (2603:10b6:a03:3a0::33) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.mkp.ca.oracle.com (138.3.201.9) by SJ0PR03CA0268.namprd03.prod.outlook.com (2603:10b6:a03:3a0::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4242.15 via Frontend Transport; Wed, 16 Jun 2021 03:49:29 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ce1a9f67-383c-4e83-328e-08d93079beca
X-MS-TrafficTypeDiagnostic: PH0PR10MB4663:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4663F3015D4CDD95F2113AE78E0F9@PH0PR10MB4663.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: hryEHRi6A4e/GiJqaL1IsrwnwiebqMghcWE8SN/CjCvMSswnC/jB9FdRec8jBY+JG3Hqt7vukfwdHljRksO2JlpkLJiihsOVxS8miBczJo/vJ8Ahz/ht0Q5MTqZPWVhNjBGy6XfYlT9zbcLD0o7WbVFGyPbRErWyxpGeNtGuM+Ec0wyPiHN3HGDdeLJj75rSqO33BgYUDPyo7M1dztG9AhJiGyMH1NBBnIlgbpZuaia+AsIjMCskdqaXd7PsoZRJVWZj1RKeh990TzxUQa+8+yf7AnpcbQqZEd/NkcNJwo7l73L+i31Y3YWXjL49wJ++waxHwOxLEXr3PmnseeaTuOZC9bjueMO7rDljS73sxfi8DEPdYQb7zE++g5jA87tyh4TKDPEwkW56wnofvcCBVdLwJtalKBMy8/aJBGBZe7Z5Vt/gKifo9MwU2JVmdeimKUgYI1Y0zLLuBiXGxOGQFa0BltvAM41+WF5JM1f6aFs2llw8lvlUMCYrfrDWTfVyR9TwESgX0bSlkUyNyN3An0NP3+tKVeyL8LzjS9eG7I/S3kzekM214eZiJG9Qw8LiiE1rUXZnlVSqhzc6KRWdD3Nz/2OSfUS7Pxo27Xx+gHZpsrMIVLPnA2EsF80kqUHtXDwbNLzkcRx1j53733oVsw/5i+SjJqvIbTzjlmg4RJH8QfOWtBD59Jaf61UYsZpMcdDYo3ceLvRNdz5Q6IwJm6tMXP/ZGl9pUL6Qa9uI2Lcb6cmrHPC00EjxO5gVOEhLksyPKb2hmhuwkhjGv//JYA==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(376002)(346002)(396003)(366004)(136003)(4744005)(66556008)(8676002)(4326008)(26005)(66946007)(6862004)(2906002)(16526019)(6636002)(186003)(478600001)(66476007)(107886003)(6666004)(5660300002)(8936002)(966005)(316002)(956004)(2616005)(83380400001)(7696005)(38350700002)(6486002)(36756003)(52116002)(103116003)(37006003)(38100700002)(86362001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?dk1ZbTFKVHlyeU9kQzdXdHJoVVpWcnRDazU0RHlzUHpkYXlEeWxyTVJwSWhs?=
 =?utf-8?B?VDg3OFVWMWo0eDUvUG9qQXc2QncyN1BGQ20vcklwUWJvMnRSSkRqd1prbmt6?=
 =?utf-8?B?N0tzUGRIUldLZnQ4QWw2N1FqSHJRMEtWZCtUUHJzNEp4RDZiUXhjNmVVY2pQ?=
 =?utf-8?B?WDhTbzJEM2tOM213RCt2Y0h1ZkpVVW5sc016bmdOc0xHSHBjOVNvaG1SQ1Uy?=
 =?utf-8?B?dUt3bDZOUzZ4THlORURseG91VWp1a3NEbFNEeGlUY2VGcHgxWUlaanAwY2Y1?=
 =?utf-8?B?UXFGeG5KazI0QkRUZGFoNnpkYjJzWXowMzJ5QzU3SWI2aFhOSHJVR1Z4b053?=
 =?utf-8?B?MkYxOEkva2R3V2tUQXNOdkpYQTZrWW0rMUpXRjRVUTU3ZkVCVXMyYXhPWEFX?=
 =?utf-8?B?YTUyRUdyT1F2emFzQ0oyYmw4Snc1RXRycjRzTTJwMWpyQ3RwYUFJZU9NMjBl?=
 =?utf-8?B?OG0wSGpUWW9TVzFSRkhBQ3ZNMUlaR1dqbUVyMFVzc2d2NjdMZFJZS1k5cHZj?=
 =?utf-8?B?MVQzUlA5RkI1S082NzU3SjVITEVmd3E0eFZ5RFNrOW11TjBtOU9LTXR5RkJ6?=
 =?utf-8?B?bmVmQ0dldDdkVVJhaUEzb0Q0NERvbDhhL01Lak95b2IrRXFZRFBaQ0c1K2Uv?=
 =?utf-8?B?STJQNVhBWDJITm5PeUpJcVdPbGNjQkFXODAvZHd2ZVZOWnRWYXlUdjhqM2pH?=
 =?utf-8?B?NzRxcCtKUzA4QXJFVkRlSzM2bmNZQ25pSkJ0YVRrMlJIcWw4V0E3Z2pnUWRE?=
 =?utf-8?B?c1NBN1hmUHhaODFKU0QzdXd4WkMrbjA3eEttWUU3cFVEYyszSlFqQjFsbVJX?=
 =?utf-8?B?Qm1mR0xjcENCQnlBZFR5S3k2QXJkUE45RURpRFRLKzBUeTZzUUlDTklwQU8x?=
 =?utf-8?B?cHdrMVV6bG54MTZPYmJtdzVxZ1NjenduUkg0V3h0RnhPV1lxbXRzd2J2RzMw?=
 =?utf-8?B?UlNhQXBGYUMxaHBBZUtFeVQyN01HTHdlcU95ZHBXb05Ib3RuQXpINmZEYm5J?=
 =?utf-8?B?Rzg1VjdvbFVjYzZuKzNUd01icG1haUdkQm9MNWEyc2NzakY3YU1HQXZSSzdG?=
 =?utf-8?B?L1VrSnd0YXZmT05zblRCRzFPWDllQ0J5OGxMVjlQZllncU41clNZRURTb2p4?=
 =?utf-8?B?QU8wNlJGdmNiUHZqOHRDeDVwKzUrMzhPRVFxSHJCNzBmOHNHM2RkMG1RZnVw?=
 =?utf-8?B?Znd3cGR6b05oV0lpSEtsZ09GM2Y1dGJ2V0pFaVRWRHhtYXdyUm00UC9RVE9Z?=
 =?utf-8?B?dSt6RUN6b0JNUzN3K0JxMkU2YURFZmdSMXZPVEIxcnFZSjlIeW9jVWwzM2Fn?=
 =?utf-8?B?NTJ1ejg0YnFVLzF4U1dEeWl0VWpGcktMOUowYUh0MkVoQkxuTDdoQUpvUDZI?=
 =?utf-8?B?SGM5cG5SYVdKblB6Y1dxTnQrMWpWTlg5OE5XRFZ1M3JydWptWFlIOXpJUm9t?=
 =?utf-8?B?bzdXQzNCaVNTUVBtakxXOEFHQXpacTgxSjYzVThvSnl2YXc3eHNBR3ljRVkw?=
 =?utf-8?B?RmZ5VFlwNTZmVDZkdHcrN1BKaVhPd05rOHZWUFhmbWFFTWkwTHRoSkFPbTFX?=
 =?utf-8?B?YTFoZWxkUk4xVUNFVGN4VWFmMExJaktEdy9jUlFGN2Zvam1YbjZwM1ltSzl5?=
 =?utf-8?B?eER5VHBSWTNTWDVhekswb2VRTHNwbmN3K2Jia1FtdlpXM2lDcFJwRytjV3pY?=
 =?utf-8?B?NEFmSTE1ZFI2UTlHSTU4N29pU1BUN1ZXam9lSm91RGdDbjdxZTYxWUJUdHhF?=
 =?utf-8?Q?0mjAno5lhSBFP4dTdz0qZnydCBKCFw6c2+0ngPt?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ce1a9f67-383c-4e83-328e-08d93079beca
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 16 Jun 2021 03:49:30.1745
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: pLKVWQ+6yc6qbTon0IaiHnzdR8oAE5Rc5yqnEgCO1By4PgOmP9jUqqKDPfu6fOjYkRUrgrpTteukPzn3lmVpE8AKNm5IcCF5TrQFs1hv59s=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4663
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10016 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 suspectscore=0
 mlxlogscore=999 spamscore=0 adultscore=0 bulkscore=0 mlxscore=0
 phishscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2106160022
X-Proofpoint-ORIG-GUID: MNBB2Hngv35i_T2lQuSge8nBBZ5QUHBP
X-Proofpoint-GUID: MNBB2Hngv35i_T2lQuSge8nBBZ5QUHBP
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 9 Jun 2021 14:27:09 -0500, Mike Christie wrote:

> qedi_clear_session_ctx could race with the in-kernel or userspace driven
> recovery/removal and we could access a NULL conn or do a double free.
> 
> We should be using iscsi_host_remove to start the removal process from the
> driver. It will start the in-kernel recovery and notify userspace that the
> driver's scsi_hosts are being removed. iscsid will then drive the session
> removal like is done when the logout command is run. When the sessions are
> removed, iscsi_host_remove will return so qedi can finish knowing there
> are no running sessions and no new sessions will be allowed.
> 
> [...]

Applied to 5.14/scsi-queue, thanks!

[1/1] scsi: qedi: Fix host removal with running sessions
      https://git.kernel.org/mkp/scsi/c/d1f2ce77638d

-- 
Martin K. Petersen	Oracle Linux Engineering
