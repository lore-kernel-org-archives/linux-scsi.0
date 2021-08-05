Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0AEC5C4320A
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:38:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DC36761152
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Aug 2021 15:38:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242131AbhHEPib (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Aug 2021 11:38:31 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:11662 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S242088AbhHEPiZ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Aug 2021 11:38:25 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 175FVl6N031442;
        Thu, 5 Aug 2021 15:38:09 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=3SEjHbJiI0n7ZZD75T+VCyO9O5mgnaH427zOsPe8P+c=;
 b=se3CX0Ll9f4H08P/KIClF0AXUJn7xSyJFVBNjmTczl3PIeQtQwf06JcO0de5SMlOZb+H
 pGblysyuem3/BuBdcFDN4Mlia57Y2RMEuLg9I9xoj4zmEvn+pN2WyHdhyN+bq5ZcQoFZ
 TaagsPG0PtkvmMwZn9BE5AltG85uv8yF0b7MtTX7naxcIG6p/OT/+eePfxekdsPEW60a
 rrJ8cNkTx800AWfnYC742/YgZen/8eJpX8PA/TvGySY+iP1Exoomp3TlUzQ79sN3E4F7
 EJsohsimeU76CzyBe/jiJfEsTRB+QmlwctD/GYQKxvdm6pwbpHHpmnQN5dOpQdaabePD Lg== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=3SEjHbJiI0n7ZZD75T+VCyO9O5mgnaH427zOsPe8P+c=;
 b=nh9d5yqM9LSCwYrouduTCuNKzIyGt2JWCZpwJkWaXaMOSXo/NJx60rOLf5rx5fVh1voF
 i+MQjfXpDBtHlPPdWuYIgLZL95ZCH/L/LjJdyMKvP+ERxp9+kJ/XwfgbVbZ6hcDpDVaz
 K7HKnX6tICZoEebH+mWtoj3Rt5wFAKkux9BvwtcOWxjHOJAHvlqfqrSofUi5uv3Jdl4C
 gkNOc6CABtY7pPTw+wc2tq5QYpUe3mNVFVixNQaiaYoUWnDvIR99zojCrltfF/T4T+Jx
 Z3Bfr+KQYBMHt5nu02Srap1QWsD+RbKYf3qfyRstDzrAU4whXaRNG5eVH7rqD+l8w/ps Fg== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7aq0d30e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:38:08 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 175FVWlx088696;
        Thu, 5 Aug 2021 15:38:07 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2043.outbound.protection.outlook.com [104.47.66.43])
        by userp3020.oracle.com with ESMTP id 3a5ga0enjg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 05 Aug 2021 15:38:07 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=NUrvn2neFvjUZuGILUiXoR0+VdqNklRQOD+CZR+lN1W/g8WsUiHdMaP2Uw/IKxUGq+xJ7NT5/F9cZ2KHL+6oa3eHGj0lYgQ0usPaqTX2EGxqPJTiNkywIxT3xn7M6wbft5aOdNuahsQRvfoPsmN+jkZLSc2enWZams53rXmQMIWyfjuAsv5HrQhUwmK0rcDvHBvaJ2NwrhJ1kSVVzOjGYQEwtOdpxTcNGJGe+Q1WvhsFXvr9S3J8Z6DQ+Baqr1xFjnvcJxwTm8zyMuKJailt/aLkCkk3mSPmG1IorBNMve3+bauo7kmvO1UhJ6fu5bpByzSoIgqCqk4/f6B1cedOhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SEjHbJiI0n7ZZD75T+VCyO9O5mgnaH427zOsPe8P+c=;
 b=CVCSBDiSu99RewznlvtSu0aCnLQPlnpPu9vMPKFSzjQhvpqt02aEOCP8hic/5LsLFn5YSSRDTIexz3COleMAPLRsJQ8WmOL6bEwr0BTCKsBbbLo7AOepijyJ7TJcnOhw7eJxAxMoNBL42bCNEzKlGLDwKCc+abio4E9MaNiWRfNxCOqfiy5LOTTOWV6jpV78QE/2B+oZsUOUt7u9r/Hkl+skMC534GSK+1UQ6Q3e6+nPGZxNiMNcdLcRS8PzKy+iznOCz/klKRk8o+QL7HocjLdJPwhWuXR6BVYQ8Bl2BKnCBQ76jI5+udKpmKlPEUfmrvJ7sU+FaJbBZs7taqD5Gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3SEjHbJiI0n7ZZD75T+VCyO9O5mgnaH427zOsPe8P+c=;
 b=KEleNkg8NZ7DBjgl+qCKEqZA+h9ch+/x5LKd61Mylhp5ADycELlopQMKfb4IJWIzardCkLGhchXhTfJFTvPUlO2RYcYLb5fnWbxsvSI312zdLj5Ot9LKTBkbunjS0dqufYRI9S4dwG0NW8YwGXOpmS4gLA6W/QFNUP7UVbrwuSE=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SA2PR10MB4426.namprd10.prod.outlook.com (2603:10b6:806:117::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17; Thu, 5 Aug
 2021 15:38:05 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::7c0c:7f1d:bbb2:b43%5]) with mapi id 15.20.4394.017; Thu, 5 Aug 2021
 15:38:05 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>
Subject: Re: [PATCH 08/14] qla2xxx: fix unsafe removal from link list
Thread-Topic: [PATCH 08/14] qla2xxx: fix unsafe removal from link list
Thread-Index: AQHXieP8NCcPYkuu5U6DG8FIiXYATKtlC/oA
Date:   Thu, 5 Aug 2021 15:38:05 +0000
Message-ID: <10A6D81C-7379-4D70-A71C-185874CC4984@oracle.com>
References: <20210805102005.20183-1-njavali@marvell.com>
 <20210805102005.20183-9-njavali@marvell.com>
In-Reply-To: <20210805102005.20183-9-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 38ea6880-e35c-49ac-326b-08d958270476
x-ms-traffictypediagnostic: SA2PR10MB4426:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SA2PR10MB44263D5CF086FBD09E168E95E6F29@SA2PR10MB4426.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:155;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: CZtWQtCsbB+rB4PXQZP0MKrVYA3sXbQUtkXbqadMc9FhNh4/E636mn6shTO1GFEeTOnP47rJ+A8hMpZRikZul71WfJzNGPwzf6SOIjkT2+q+avKCBKDKQeIt5V8+NhIcvYrzr9v6c4iUtN4NRC1Oe4AlRsh8Yyog7rSlhqSe7oIoahT1hoSDIvZipgHASJ5EeWoPXaoISAfegTxgq9pEFOkP1gimMK7M2lDxL01/+wXFToKeFpq5kwaV1cL4w67P8zhYQ1s6Pc73iqA5Ri7ApOWgwLVjLeyMsZuStA/4deisNgBBqRrVYhsoCPFZCacYAQs7Hh4maGYM/xqdPuAP0chNGYQUNDzX48hOG9nKYLciBFMpDD0XqvLpCeFhwS/59/Hp/wUjMvMso+OYfenm5JbTWp6JmomskkpdFAEWHbC4y8+pX3cXORnamiPklR0BcBEpnZdV/1qe5wWsCENWjls9Glwk/m6F8yVrzLT/fHICw4Wu6PN3CULptySzRYGMK5/XhjdvPtUR/yCdp6ZWN1V8n8UGzRXeufqac66tqEXEo5qZ608jo9GMRow1OzRp4A0V71LuVNWqmo5TlEscdMB/F5aEAsxDC0PYtCdFvNGXR+eFOztqYVNuwmnqb+sMdSEiULRpeHCNopUF91v3GRHq6mFLZaE1PhhsipPu7hjAXp4TpFEK2WCJyId5SqCfn8id9dyFiJMD2n2xXq4404ctIdxvER+82okXSBMoAQBDdNxPnH6lnKM6zmA/1dg6
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(366004)(39860400002)(136003)(64756008)(2616005)(66476007)(2906002)(186003)(26005)(66556008)(66946007)(76116006)(5660300002)(53546011)(6506007)(86362001)(478600001)(4326008)(54906003)(66446008)(316002)(36756003)(44832011)(83380400001)(6512007)(6486002)(8676002)(8936002)(38070700005)(71200400001)(6916009)(30864003)(33656002)(122000001)(38100700002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?t4IDdr7evpJgRyNE1neCpWuOThNiy0WHdQdznfQXwHyPe7LKPJMB2PTYndgO?=
 =?us-ascii?Q?UbtX186qHxXR8uIMZXJr6oylIpdHz9RNQOl6qYj7Wzxi/VWxmjSzGXqTSxDY?=
 =?us-ascii?Q?VXLPOZXXG0SvOcjC/5kaenfo5xCsskz5LuENenP/ASwKFWGGWLUgQUU2wVnY?=
 =?us-ascii?Q?q2VfjlUCNILUQRL5nj3SqOFpCJgSeFxXm0axmmjKPkV3hz3D9jWNbZOR+pkE?=
 =?us-ascii?Q?pGuLs7pt651/RMFBTL5069pisP+5BQk0LSLEm7SK+1j+vAbHEFrO15U5uw6y?=
 =?us-ascii?Q?B3zICtnrdGuSCgmLCmgaHmbJd/RgYLA1m6k1T/Ck/MUTnMzZ0rG/7iq7PqEq?=
 =?us-ascii?Q?IS6tHYvC64z7YXP+Xt4Gmucxo5NbeRb5yUtb2OmtaiPJ7kYJBD6jrSPFqPWc?=
 =?us-ascii?Q?klhtVJ0eG9Saclvn3/SKNEGszJptX60CalSqJjerVTQAHVrXZe6rIr0LFCzf?=
 =?us-ascii?Q?PxF8vqMroRlzspRa3aO4DS5FQQTzLMwqG9x70A0NbvL5xWCIlRU2kVmCJulU?=
 =?us-ascii?Q?5/Y1CXcjl5m5CvPDi6QDJEpOqEHlIPsXKoPuzYQQkv9B9wzeEmSqfF8NTyuU?=
 =?us-ascii?Q?uw21mQT7lSZOCMY308BHhkn5NjAiHGcswfl2S7CYE+lFsShTnNeCPo8m+j8g?=
 =?us-ascii?Q?ayzlmUgMWhAY+ci1TsoVq7jlre1YZN+O/kNKoBPHb9AG1GDS0FNzCkU08SjB?=
 =?us-ascii?Q?I4TDyONvCLx+zifa2NyQBAFuw0Nl0/f7NQk5qPDwfKJ3I4IQf+6eqW9QqVsI?=
 =?us-ascii?Q?aFCJ6/mzSRBQbNa2w2RDix3BL2TP4Lg0LN87Pl5Zau1P2K4ycHmwy0tp4FsK?=
 =?us-ascii?Q?ZtfZdAQAHYmUQ+deU8UP+FdUuevTPP/gUzrmXZ7d40ZgyqsSMXnq47c1rQA/?=
 =?us-ascii?Q?FHQ2HcMWDPqOWOFHHSWJeAEO4JQ40t2FeofHsv7f/YMwyoFxss5kZ796WZmn?=
 =?us-ascii?Q?CPM4YlA9Qj2aNQTxgrAUDGR87vDeyegGTk1nzF/5B+dKOq6L8sieSxRJjhqQ?=
 =?us-ascii?Q?I1JThOpu3R+aly3vALn0npg/0Bbry8yNlWoqlo7VXZygrbJbonS70L2GY7DW?=
 =?us-ascii?Q?tJ1Jb27lDvXBo0r7GVGj2P3OMo46gK0TXabAv/1c1KwOEopn0nMCZw/EB7XJ?=
 =?us-ascii?Q?zns+94sYDiOlMZPGO7k2KrW99zD6fneBgZgCjVszUqncepp/19vU7Dmp/a4B?=
 =?us-ascii?Q?3Yx2KlzaEFGnoKWK7FFMXtoVVdQbEqEhfnDWt3XUJLNUXAbEETiRPNiFxw+e?=
 =?us-ascii?Q?KvokbHaG3sSBqDNFZDsBHcwhF1zvUf2FuaX9O1q89zzJXuo41Eh7Ra0kDmNl?=
 =?us-ascii?Q?1Q/25rPEOEuG7YTFFZo74f1n?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <20C019E3F1D74442984FD9EC41B80A36@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 38ea6880-e35c-49ac-326b-08d958270476
X-MS-Exchange-CrossTenant-originalarrivaltime: 05 Aug 2021 15:38:05.0860
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 0bWM8wUkiJql4woZ0WC5+eC+3DQJw9zw9BQP9NzhPo3L8iLKxAUiPuIaXx930dNuOHXIhgXIk3tj+v1MrN/6D+FihYz0PI0tb2t0NII6u6o=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR10MB4426
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 malwarescore=0 phishscore=0
 spamscore=0 adultscore=0 suspectscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108050094
X-Proofpoint-ORIG-GUID: AVYVX_roL3qVLL9B_OZq8qPW8pMus4S6
X-Proofpoint-GUID: AVYVX_roL3qVLL9B_OZq8qPW8pMus4S6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Aug 5, 2021, at 5:19 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> On NPIV delete, the VPort is taken off a link list in an unsafe manner.
> The check for VPort refcount should be done behind lock before taking
> off the element.
>=20
> [ 2733.016907] general protection fault: 0000 [#1] SMP NOPTI
> [ 2733.016908] qla2xxx [0000:22:00.1]-7088:27: VP[4] deleted.
> [ 2733.016912] CPU: 22 PID: 23481 Comm: qla2xxx_15_dpc Kdump: loaded Tain=
ted:
> G           OE KX    5.3.18-47-default #1 SLE15-SP3
> [ 2733.016914] Hardware name: Dell Inc. PowerEdge R7525/0PYVT1, BIOS 2.1.=
4 02/17/2021
> [ 2733.016929] RIP: 0010:qla2x00_abort_isp+0x90/0x850 [qla2xxx]
> [ 2733.016933] RSP: 0018:ffffb9cfc91efe98 EFLAGS: 00010087
> [ 2733.016935] RAX: 0000000000000292 RBX: dead000000000100 RCX: 000000000=
0000000
> [ 2733.016936] RDX: 0000000000000001 RSI: ffff944bfeb99558 RDI: ffff944bf=
c4b4488
> [ 2733.016937] RBP: ffff944bfc4b2868 R08: 00000000000187a2 R09: 000000000=
0000001
> [ 2733.016937] R10: ffffb9cfc91efcc8 R11: 0000000000000001 R12: ffff944bf=
c4b4000
> [ 2733.016938] R13: ffff944bfc4b4870 R14: ffff944bfc4b4488 R15: ffff944bd=
a895c80
> [ 2733.016939] FS:  0000000000000000(0000) GS:ffff944bfeb80000(0000) knlG=
S:0000000000000000
> [ 2733.016940] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [ 2733.016940] CR2: 00007fc173e74458 CR3: 0000001ff57de000 CR4: 000000000=
0350ee0
> [ 2733.016941] Call Trace:
> [ 2733.016951]   qla2xxx_pci_error_detected+0x190/0x190 [qla2xxx]
> [ 2733.016957]   qla2x00_do_dpc+0x560/0xa10 [qla2xxx]
> [ 2733.016962]   kthread+0x10d/0x130
> [ 2733.016963]   kthread_park+0xa0/0xa0
> [ 2733.016966]   ret_from_fork+0x22/0x40
>=20
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_init.c | 33 +++++++++++++++++---------
> drivers/scsi/qla2xxx/qla_mid.c  | 42 ++++++++++++++++++++-------------
> drivers/scsi/qla2xxx/qla_os.c   |  6 ++---
> 3 files changed, 50 insertions(+), 31 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_i=
nit.c
> index be09dc4b3bf2..c427ef7e7c72 100644
> --- a/drivers/scsi/qla2xxx/qla_init.c
> +++ b/drivers/scsi/qla2xxx/qla_init.c
> @@ -6573,13 +6573,13 @@ void
> qla2x00_update_fcports(scsi_qla_host_t *base_vha)
> {
> 	fc_port_t *fcport;
> -	struct scsi_qla_host *vha;
> +	struct scsi_qla_host *vha, *tvp;
> 	struct qla_hw_data *ha =3D base_vha->hw;
> 	unsigned long flags;
>=20
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> 	/* Go with deferred removal of rport references. */
> -	list_for_each_entry(vha, &base_vha->hw->vp_list, list) {
> +	list_for_each_entry_safe(vha, tvp, &base_vha->hw->vp_list, list) {
> 		atomic_inc(&vha->vref_count);
> 		list_for_each_entry(fcport, &vha->vp_fcports, list) {
> 			if (fcport->drport &&
> @@ -6924,7 +6924,8 @@ void
> qla2x00_quiesce_io(scsi_qla_host_t *vha)
> {
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct scsi_qla_host *vp;
> +	struct scsi_qla_host *vp, *tvp;
> +	unsigned long flags;
>=20
> 	ql_dbg(ql_dbg_dpc, vha, 0x401d,
> 	    "Quiescing I/O - ha=3D%px.\n", ha);
> @@ -6933,8 +6934,18 @@ qla2x00_quiesce_io(scsi_qla_host_t *vha)
> 	if (atomic_read(&vha->loop_state) !=3D LOOP_DOWN) {
> 		atomic_set(&vha->loop_state, LOOP_DOWN);
> 		qla2x00_mark_all_devices_lost(vha);
> -		list_for_each_entry(vp, &ha->vp_list, list)
> +
> +		spin_lock_irqsave(&ha->vport_slock, flags);
> +		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> +			atomic_inc(&vp->vref_count);
> +			spin_unlock_irqrestore(&ha->vport_slock, flags);
> +
> 			qla2x00_mark_all_devices_lost(vp);
> +
> +			spin_lock_irqsave(&ha->vport_slock, flags);
> +			atomic_dec(&vp->vref_count);
> +		}
> +		spin_unlock_irqrestore(&ha->vport_slock, flags);
> 	} else {
> 		if (!atomic_read(&vha->loop_down_timer))
> 			atomic_set(&vha->loop_down_timer,
> @@ -6949,7 +6960,7 @@ void
> qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
> {
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct scsi_qla_host *vp;
> +	struct scsi_qla_host *vp, *tvp;
> 	unsigned long flags;
> 	fc_port_t *fcport;
> 	u16 i;
> @@ -7017,7 +7028,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
> 		qla2x00_mark_all_devices_lost(vha);
>=20
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> -		list_for_each_entry(vp, &ha->vp_list, list) {
> +		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 			atomic_inc(&vp->vref_count);
> 			spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> @@ -7039,7 +7050,7 @@ qla2x00_abort_isp_cleanup(scsi_qla_host_t *vha)
> 		fcport->scan_state =3D 0;
> 	}
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> -	list_for_each_entry(vp, &ha->vp_list, list) {
> +	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 		atomic_inc(&vp->vref_count);
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> @@ -7083,7 +7094,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
> 	int rval;
> 	uint8_t        status =3D 0;
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct scsi_qla_host *vp;
> +	struct scsi_qla_host *vp, *tvp;
> 	struct req_que *req =3D ha->req_q_map[0];
> 	unsigned long flags;
>=20
> @@ -7239,7 +7250,7 @@ qla2x00_abort_isp(scsi_qla_host_t *vha)
> 		ql_dbg(ql_dbg_taskm, vha, 0x8022, "%s succeeded.\n", __func__);
> 		qla2x00_configure_hba(vha);
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> -		list_for_each_entry(vp, &ha->vp_list, list) {
> +		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 			if (vp->vp_idx) {
> 				atomic_inc(&vp->vref_count);
> 				spin_unlock_irqrestore(&ha->vport_slock, flags);
> @@ -8924,7 +8935,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
> {
> 	int status, rval;
> 	struct qla_hw_data *ha =3D vha->hw;
> -	struct scsi_qla_host *vp;
> +	struct scsi_qla_host *vp, *tvp;
> 	unsigned long flags;
>=20
> 	status =3D qla2x00_init_rings(vha);
> @@ -8996,7 +9007,7 @@ qla82xx_restart_isp(scsi_qla_host_t *vha)
> 		    "qla82xx_restart_isp succeeded.\n");
>=20
> 		spin_lock_irqsave(&ha->vport_slock, flags);
> -		list_for_each_entry(vp, &ha->vp_list, list) {
> +		list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 			if (vp->vp_idx) {
> 				atomic_inc(&vp->vref_count);
> 				spin_unlock_irqrestore(&ha->vport_slock, flags);
> diff --git a/drivers/scsi/qla2xxx/qla_mid.c b/drivers/scsi/qla2xxx/qla_mi=
d.c
> index 98333f5b0807..3fa70750ce25 100644
> --- a/drivers/scsi/qla2xxx/qla_mid.c
> +++ b/drivers/scsi/qla2xxx/qla_mid.c
> @@ -65,7 +65,7 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
> 	uint16_t vp_id;
> 	struct qla_hw_data *ha =3D vha->hw;
> 	unsigned long flags =3D 0;
> -	u8 i;
> +	u32 i, bailout;
>=20
> 	mutex_lock(&ha->vport_lock);
> 	/*
> @@ -75,21 +75,29 @@ qla24xx_deallocate_vp_id(scsi_qla_host_t *vha)
> 	 * ensures no active vp_list traversal while the vport is removed
> 	 * from the queue)
> 	 */
> -	for (i =3D 0; i < 10; i++) {
> -		if (wait_event_timeout(vha->vref_waitq,
> -		    !atomic_read(&vha->vref_count), HZ) > 0)
> +	bailout =3D 0;
> +	for (i =3D 0; i < 500; i++) {
> +		spin_lock_irqsave(&ha->vport_slock, flags);
> +		if (atomic_read(&vha->vref_count) =3D=3D 0) {
> +			list_del(&vha->list);
> +			qlt_update_vp_map(vha, RESET_VP_IDX);
> +			bailout =3D 1;
> +		}
> +		spin_unlock_irqrestore(&ha->vport_slock, flags);
> +
> +		if (bailout)
> 			break;
> +		else
> +			msleep(20);
> 	}
> -
> -	spin_lock_irqsave(&ha->vport_slock, flags);
> -	if (atomic_read(&vha->vref_count)) {
> -		ql_dbg(ql_dbg_vport, vha, 0xfffa,
> -		    "vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
> -		vha->vref_count =3D (atomic_t)ATOMIC_INIT(0);
> +	if (!bailout) {
> +		ql_log(ql_log_info, vha, 0xfffa,
> +			"vha->vref_count=3D%u timeout\n", vha->vref_count.counter);
> +		spin_lock_irqsave(&ha->vport_slock, flags);
> +		list_del(&vha->list);
> +		qlt_update_vp_map(vha, RESET_VP_IDX);
> +		spin_unlock_irqrestore(&ha->vport_slock, flags);
> 	}
> -	list_del(&vha->list);
> -	qlt_update_vp_map(vha, RESET_VP_IDX);
> -	spin_unlock_irqrestore(&ha->vport_slock, flags);
>=20
> 	vp_id =3D vha->vp_idx;
> 	ha->num_vhosts--;
> @@ -262,13 +270,13 @@ qla24xx_configure_vp(scsi_qla_host_t *vha)
> void
> qla2x00_alert_all_vps(struct rsp_que *rsp, uint16_t *mb)
> {
> -	scsi_qla_host_t *vha;
> +	scsi_qla_host_t *vha, *tvp;
> 	struct qla_hw_data *ha =3D rsp->hw;
> 	int i =3D 0;
> 	unsigned long flags;
>=20
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> -	list_for_each_entry(vha, &ha->vp_list, list) {
> +	list_for_each_entry_safe(vha, tvp, &ha->vp_list, list) {
> 		if (vha->vp_idx) {
> 			if (test_bit(VPORT_DELETE, &vha->dpc_flags))
> 				continue;
> @@ -421,7 +429,7 @@ void
> qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
> {
> 	struct qla_hw_data *ha =3D vha->hw;
> -	scsi_qla_host_t *vp;
> +	scsi_qla_host_t *vp, *tvp;
> 	unsigned long flags =3D 0;
>=20
> 	if (vha->vp_idx)
> @@ -435,7 +443,7 @@ qla2x00_do_dpc_all_vps(scsi_qla_host_t *vha)
> 		return;
>=20
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> -	list_for_each_entry(vp, &ha->vp_list, list) {
> +	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 		if (vp->vp_idx) {
> 			atomic_inc(&vp->vref_count);
> 			spin_unlock_irqrestore(&ha->vport_slock, flags);
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index a1ccd9f32a98..df42849e7ccc 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -7534,7 +7534,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *=
vha)
> 	struct qla_hw_data *ha =3D vha->hw;
> 	scsi_qla_host_t *base_vha =3D pci_get_drvdata(ha->pdev);
> 	struct qla_qpair *qpair =3D NULL;
> -	struct scsi_qla_host *vp;
> +	struct scsi_qla_host *vp, *tvp;
> 	fc_port_t *fcport;
> 	int i;
> 	unsigned long flags;
> @@ -7565,7 +7565,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *=
vha)
> 	qla2x00_mark_all_devices_lost(vha);
>=20
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> -	list_for_each_entry(vp, &ha->vp_list, list) {
> +	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 		atomic_inc(&vp->vref_count);
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
> 		qla2x00_mark_all_devices_lost(vp);
> @@ -7579,7 +7579,7 @@ static void qla_pci_error_cleanup(scsi_qla_host_t *=
vha)
> 		fcport->flags &=3D ~(FCF_LOGIN_NEEDED | FCF_ASYNC_SENT);
>=20
> 	spin_lock_irqsave(&ha->vport_slock, flags);
> -	list_for_each_entry(vp, &ha->vp_list, list) {
> +	list_for_each_entry_safe(vp, tvp, &ha->vp_list, list) {
> 		atomic_inc(&vp->vref_count);
> 		spin_unlock_irqrestore(&ha->vport_slock, flags);
> 		list_for_each_entry(fcport, &vp->vp_fcports, list)
> --=20
> 2.19.0.rc0
>=20

Looks Good

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com

--
Himanshu Madhani	 Oracle Linux Engineering

