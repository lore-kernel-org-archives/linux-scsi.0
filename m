Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B2434C433F5
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:33:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7C4B361154
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 14:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351917AbhIHOeJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Sep 2021 10:34:09 -0400
Received: from mx0b-00069f02.pphosted.com ([205.220.177.32]:50230 "EHLO
        mx0b-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233240AbhIHOeI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2021 10:34:08 -0400
Received: from pps.filterd (m0246631.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.1.2/8.16.1.2) with SMTP id 188DjKw9030428;
        Wed, 8 Sep 2021 14:32:55 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=fHUozu+BySUoMZOq1khk5Ph79RCcpn/6FVqr8tsYcMQ=;
 b=SUMTiKGu+90KRWhLPhcifn/RidiDIUeKT5Edm2Mnta+lYNhRlkcBC8/nS4HEPsAtU5vH
 G/AUN284Xa/e0HbWq0pS3SB1qKpA/6+nhs0a9Onct/vGHNPjW9N+0uq2gE/ks1cULgfR
 6MWOx1jRdTnZk2u4q4T6ProZp409awMJjAhN7UnJ+bLKFNfrrWeAqZkKk751ggSgbeZ1
 snG+tsWSOdz0Bltm4RPi6AuWXgV+FJNao/yYSYUFeXzugSSZXvdN0IBvE2VQRfjlypyq
 urCgt2JMwf8pI18v8NyfvSy1kH2UA6ncX7vMM+V72hGVM5P/bQh3QE2VEhm/yHaJ+Ni3 DQ== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=fHUozu+BySUoMZOq1khk5Ph79RCcpn/6FVqr8tsYcMQ=;
 b=QD2/JImvFhMv1cAeGUxX02b+ikzkQ2n9v/rXNNfJpDD6PipaLWiHyH82X2BN24agiQNE
 oKbXW7RdBWSPuXmxeTGdnbhSiWCBEZJDp631+O0tJcZ9x1VBJrfXjm5dvF1RufFaZjA4
 6VNBtxfFm52li4nV4gXXjQgkoX3erdEi9esMfEbIqhwO/KCG/XIKZFsQy7x0B+B9qcUA
 ec6APgFljZooW7H5ZUHzuvjceGZDPJ3D0EywYmEu2rLuSBJ0RKNLQBD8atbAck3IlQPJ
 7fe/Kyzv4WdjnVOT5kY62akeZXFcBB77l9ubzpqlbTWH90E39h7mzUWSzHswBm1Z0gfm ug== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by mx0b-00069f02.pphosted.com with ESMTP id 3axd44tvtj-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:32:55 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 188EAHAM009076;
        Wed, 8 Sep 2021 14:16:45 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2044.outbound.protection.outlook.com [104.47.66.44])
        by userp3020.oracle.com with ESMTP id 3axst3vnnk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Wed, 08 Sep 2021 14:16:45 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=d8loSrJC/dmd8PaEvTZGaPniajkMETefuO+vNDrCU5E122QpvwlWkBCK7PuFJ1Mu6MgdJ1b40H5/aQyHzZqjaVb+J+mYms05FPCP5EttRHBHBBYfTE+v2zBYOKF9VNlZPB07z6nYdWwAvpaPAKpXS09toIor81XpLVIFXWzTeVYq2puvTWYROrx5Ezy1ntwl6oosR8UHSJkZCIOfw7JULaqSJe3YVwWoBTr80QU82GHESR6pYfMfnImoLQOu1g63smsIUubkHrSOFbrYnTRczUlC83vZVjld7x88QVY1fO6Ue9UdU1T3/vPYPINpLu1NMkaY/e2rOqlNElILrBy1sg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901; h=From:Date:Subject:Message-ID:Content-Type:MIME-Version;
 bh=fHUozu+BySUoMZOq1khk5Ph79RCcpn/6FVqr8tsYcMQ=;
 b=EzuC6ers0RC27bmDIW4/If5sJw00FesUrau5xlJPusU/WOapcTfPcdu0EcTqaDAx2q7vJGl1buO22sVwu5KhZJ2H6D4EERoBLjv6HvFTi2g9VyerumFnNwj66xRBMw8oIYmJ9YwiKeNnTshtGvRZclwiTLjuTRdyoJFJRvdkH7x9PeJZYVge0za5Z8uoCABUee3PSgd9BEFBEWfGfLME5UlKyZsNPca4A4wrB4Tlqca+zHKU75pu7NV/VqRISrqb0TQekDGBOAylvlijtUsTCYRcM16Wp9gCMlFFz3X3efZ5LjeSisi5MYg95GNRRnMN9nwkJcmAz9+D3umhkikfzg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=fHUozu+BySUoMZOq1khk5Ph79RCcpn/6FVqr8tsYcMQ=;
 b=zfSg5Ep3laUVmQjCnloc1Bg+hJcTA7vSpQfSs4KYxYAI7owpA4fiNsHIGz9ZanJe5Xl7uNJh+qRLmY63lCCxvca682pZWxt5cJWuRe9IPgtCVLH2j2RsvGJ+bEZ2bsUhXWSZUTKUUj6fy9dZOXVwQOPF/zWMYVJBzr+0n9gNvZo=
Received: from SN6PR10MB2943.namprd10.prod.outlook.com (2603:10b6:805:d4::19)
 by SN6PR10MB2573.namprd10.prod.outlook.com (2603:10b6:805:48::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4500.14; Wed, 8 Sep
 2021 14:16:43 +0000
Received: from SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe]) by SN6PR10MB2943.namprd10.prod.outlook.com
 ([fe80::38df:8fa2:1602:2dfe%3]) with mapi id 15.20.4500.015; Wed, 8 Sep 2021
 14:16:43 +0000
From:   Himanshu Madhani <himanshu.madhani@oracle.com>
To:     Nilesh Javali <njavali@marvell.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "GR-QLogic-Storage-Upstream@marvell.com" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "djeffery@redhat.com" <djeffery@redhat.com>,
        "loberman@redhat.com" <loberman@redhat.com>
Subject: Re: [PATCH 09/10] qla2xxx: Fix use after free in eh_abort path
Thread-Topic: [PATCH 09/10] qla2xxx: Fix use after free in eh_abort path
Thread-Index: AQHXpIN0eHS2UzVqBEiosXYVxVLJ2KuaL0QA
Date:   Wed, 8 Sep 2021 14:16:42 +0000
Message-ID: <4E3ED2A4-5E94-4202-9B74-569DA0C820F9@oracle.com>
References: <20210908072846.10011-1-njavali@marvell.com>
 <20210908072846.10011-10-njavali@marvell.com>
In-Reply-To: <20210908072846.10011-10-njavali@marvell.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3608.120.23.2.7)
authentication-results: marvell.com; dkim=none (message not signed)
 header.d=none;marvell.com; dmarc=none action=none header.from=oracle.com;
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: a1b6e465-9085-4a54-1646-08d972d3488f
x-ms-traffictypediagnostic: SN6PR10MB2573:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <SN6PR10MB257381F850822DDFBF1C2177E6D49@SN6PR10MB2573.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2331;
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 07wuj5WVFEjE65qXnP/n+HoO+r692t//vO1vG40NTOE61tC8rN7ftBN0Gwr5P6JUQKeEvLwUaHiQr00j8uYAap60YeFDmlaUwgmM5ghb+r7vqX/GOXgsyPNnYUCN6tsyzIhP0EhaGz9+WPPT1zcwRYIONWpsYRj/K4mzGgaB0xGT5ZsbqKb64qI8YNdYcnGAuH6MySwSsau+4LWQFNtZvyzK8dVhj1lTykYdg4UvbDfvVjWSI2Dbg5ou2agJMSalbPLlhi4u0TNgKpj+c5kmmD4Nf9fEW3BxdLAhrou1c5CN7GgZfHOMlgy8nCk721uEx2QZYRcnuJH6CpcWRhyUpNksuoaY2xkNkz3/hvARu0UOqv1zeD7ptb6laPNynnmoxM14E4jwlFK95nJQYQA3qqJ2+ZEfuQkEnXmNni9mrFWmG0mryBKkv3gw8RvJowK9D7sewIYW5XRlrulz4iJHn/Ep3fxXEqXyvuBXMpOwD5O0aoBrwwUFaN9QKkBPvXYe2QMPTwPoXQAWxMNgonpx5petf9NLVwCLrAgAwhk0CbTFLG4ivBE0Ji0QzyFu2MHJhKxCqYKxsh9hn3kyutOg6eduoy/sHBMlPM4yAH8wwT37B6pWu3lY2SG5vxqbn5ik0MSemBv5VpHWZ0iJBL9l7iPLy94Uw3ah0GdRQfulKa5MR9PLebsFhYDFt7uqulATWn8OgJ+fVyVJ4+0seKIzxfyC47MnVo/aAbF4ERv4sF9wavB9AY9tHJCW2xEc0RcG
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SN6PR10MB2943.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(346002)(376002)(136003)(39860400002)(366004)(86362001)(6916009)(316002)(186003)(66446008)(6486002)(5660300002)(8936002)(33656002)(4326008)(64756008)(478600001)(36756003)(71200400001)(44832011)(38070700005)(8676002)(38100700002)(6506007)(2906002)(53546011)(76116006)(26005)(122000001)(6512007)(54906003)(66556008)(66946007)(66476007)(2616005)(83380400001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?FaoZq88znLLDo3oNjGCCFQ9/rosR1093QjoLJVQUlmrJDeZqgXwc7oleqdNd?=
 =?us-ascii?Q?TsEUW8eplJ+PHLiVtNdxTzJfFyjV0+38SlS/p2ZmDpPYKKx5uDGXIJM9VxrV?=
 =?us-ascii?Q?Oa4aKHKBDA4fgI79Q+Uv8xhIplZJLRSqfedWU32qgd1ZNJmkiCmIRN5m1Nkp?=
 =?us-ascii?Q?n4YFxu6OPiAUxXPdRpNNu0wjzrCtO0gpOEPzuH4p32CXbDvLboE194s0SBjm?=
 =?us-ascii?Q?myFmR0593tmWvxLbv/h1lHLjgqmq0E7nDr/CMS4FOpVU98KCoyt0xy3KWDsT?=
 =?us-ascii?Q?XhL/rAmE/pF2Mqw0uAY4umJeyZDDrWyklYrRQ29hKYhdMR8A4XMK/X7xT3JT?=
 =?us-ascii?Q?c/RDBpStR/oSORKjVgTpbGF579dKzcd64Wlp+2JoTjfPjlhyFoWU2VPY+1PI?=
 =?us-ascii?Q?/r4TYpPmUtGpnobUOelqrEjUle172zrAK6Gyf6c+k9g2RhQ9+7lW/vr/KSz8?=
 =?us-ascii?Q?5sc0u90ykAFyDWh8IRq/lcxxQFQxIwMjZqIB0ct7iLeD9AW0a4YL0R9Ohhn4?=
 =?us-ascii?Q?Cb03cW1HbiZdmaAvLo92eOjnrVh9qOJWAYiMxR6JKeLTMP54ET1jopT3zosJ?=
 =?us-ascii?Q?Tum5JiY4KenARnxCcGLMoNAJhcH54Xw/JlbYsNlsp/iskjWmNpu+05GPwo82?=
 =?us-ascii?Q?7bBB8mjqYCy5CYlQnYoW255k4HFW5T2Wb3YJgECS4NlQ2vZqkDnZgcxqTMW7?=
 =?us-ascii?Q?5bI/2fp7nGkgunVqEADQUz5X2pJTh5Vua1Ur/IFhad5bqA+zxVf5XRtOUosf?=
 =?us-ascii?Q?fYacU9psOfydlfjJYI5D9eYwdhbczr1pA7WV1vHHEHZLq8iNfWqoztOV4nwa?=
 =?us-ascii?Q?66LAo/81szOY/DCZFUqarUTHbWH+dI4snoBafA+70GJK9v9faMtarlFB4xSs?=
 =?us-ascii?Q?NMcqYwAge1Q+Fh5Pkfj1EsvxiAhTVUAeICrattbVz1ydIiBIIYF36zWyeaT+?=
 =?us-ascii?Q?970niZlAG/TU8ZJujS02X/XM0QX86+G4ixp11Y92ggKqwCGW4A2nlDACKYUa?=
 =?us-ascii?Q?BLzyvkBPTVvCTrbBUNswhejgh0EDu1RCqAocXQN5nKuwWPdkOqfjFAA62obk?=
 =?us-ascii?Q?YKM/bmwmT4tgGLNM23yYKyzIBg0BHTQbUKbeHgiVS1YnUSgHXBhXKLyWatlE?=
 =?us-ascii?Q?1VsttphsBB7ASYG/RFJedpj0vSvwc+2AfAkHGglFDAZ3JYpE88Z1u/u6mSgO?=
 =?us-ascii?Q?xwcSe6+qriaSkovFf7JE/q1Uw4HQZWB2wkOsQi9+QxOnIeCz/Eq4FArW3K/Y?=
 =?us-ascii?Q?Jmiil4qzVWHWCZDSXhFJsNDKDxvMnXx4SbSV0FSs7WnWZw8P9+bcHAD3RkQ3?=
 =?us-ascii?Q?K3D6If5+dnxapm9QozrTodU5bXW3m2TeG5YaBAernllL7Q=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-ID: <74258D92F35D214EBD2050F132712FE3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SN6PR10MB2943.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a1b6e465-9085-4a54-1646-08d972d3488f
X-MS-Exchange-CrossTenant-originalarrivaltime: 08 Sep 2021 14:16:42.9509
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iahcvdF3GDyJNt1aybeMFMSbPLK6YS+qeTMFq+6ONKlzDoGz9DlXJLvmosRh1i9mU3/kt98Wti30ZmdwPECkZG4lfAj+6P8KcRm2h6r9g24=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR10MB2573
X-Proofpoint-Virus-Version: vendor=nai engine=6300 definitions=10100 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 phishscore=0 bulkscore=0
 mlxlogscore=999 malwarescore=0 spamscore=0 mlxscore=0 suspectscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2109030001 definitions=main-2109080091
X-Proofpoint-GUID: wYK9MZnICAgZi59we3U4NIL5keaLCsh6
X-Proofpoint-ORIG-GUID: wYK9MZnICAgZi59we3U4NIL5keaLCsh6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Sep 8, 2021, at 2:28 AM, Nilesh Javali <njavali@marvell.com> wrote:
>=20
> From: Quinn Tran <qutran@marvell.com>
>=20
> In eh_abort path, driver prematurely exit the call to upper layer.
> This patch would check for command is aborted / completed by FW
> before exiting the call.
>=20
> 9 [ffff8b1ebf803c00] page_fault at ffffffffb0389778
>  [exception RIP: qla2x00_status_entry+0x48d]
>  RIP: ffffffffc04fa62d  RSP: ffff8b1ebf803cb0  RFLAGS: 00010082
>  RAX: 00000000ffffffff  RBX: 00000000000e0000  RCX: 0000000000000000
>  RDX: 0000000000000000  RSI: 00000000000013d8  RDI: fffff3253db78440
>  RBP: ffff8b1ebf803dd0   R8: ffff8b1ebcd9b0c0   R9: 0000000000000000
>  R10: ffff8b1e38a30808  R11: 0000000000001000  R12: 00000000000003e9
>  R13: 0000000000000000  R14: ffff8b1ebcd9d740  R15: 0000000000000028
>  ORIG_RAX: ffffffffffffffff  CS: 0010  SS: 0018
> 10 [ffff8b1ebf803cb0] enqueue_entity at ffffffffafce708f
> 11 [ffff8b1ebf803d00] enqueue_task_fair at ffffffffafce7b88
> 12 [ffff8b1ebf803dd8] qla24xx_process_response_queue at ffffffffc04fc9a6
> [qla2xxx]
> 13 [ffff8b1ebf803e78] qla24xx_msix_rsp_q at ffffffffc04ff01b [qla2xxx]
> 14 [ffff8b1ebf803eb0] __handle_irq_event_percpu at ffffffffafd50714
>=20
> Fixes: f45bca8c5052 ("scsi: qla2xxx: Fix double scsi_done for abort path"=
)

Cc: stable@vger.kernel.org

> Signed-off-by: David Jeffery <djeffery@redhat.com>
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Nilesh Javali <njavali@marvell.com>
> ---
> drivers/scsi/qla2xxx/qla_os.c | 8 +++++---
> 1 file changed, 5 insertions(+), 3 deletions(-)
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_os.c b/drivers/scsi/qla2xxx/qla_os.=
c
> index 0454f79a8047..0f3048723965 100644
> --- a/drivers/scsi/qla2xxx/qla_os.c
> +++ b/drivers/scsi/qla2xxx/qla_os.c
> @@ -1258,6 +1258,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 	uint32_t ratov_j;
> 	struct qla_qpair *qpair;
> 	unsigned long flags;
> +	int fast_fail_status =3D SUCCESS;
>=20
> 	if (qla2x00_isp_reg_stat(ha)) {
> 		ql_log(ql_log_info, vha, 0x8042,
> @@ -1266,9 +1267,10 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 		return FAILED;
> 	}
>=20
> +	/* Save any FAST_IO_FAIL value to return later if abort succeeds */
> 	ret =3D fc_block_scsi_eh(cmd);
> 	if (ret !=3D 0)
> -		return ret;
> +		fast_fail_status =3D ret;
>=20
> 	sp =3D scsi_cmd_priv(cmd);
> 	qpair =3D sp->qpair;
> @@ -1276,7 +1278,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 	vha->cmd_timeout_cnt++;
>=20
> 	if ((sp->fcport && sp->fcport->deleted) || !qpair)
> -		return SUCCESS;
> +		return fast_fail_status !=3D SUCCESS ? fast_fail_status : FAILED;
>=20
> 	spin_lock_irqsave(qpair->qp_lock_ptr, flags);
> 	sp->comp =3D &comp;
> @@ -1311,7 +1313,7 @@ qla2xxx_eh_abort(struct scsi_cmnd *cmd)
> 			    __func__, ha->r_a_tov/10);
> 			ret =3D FAILED;
> 		} else {
> -			ret =3D SUCCESS;
> +			ret =3D fast_fail_status;
> 		}
> 		break;
> 	default:
> --=20
> 2.19.0.rc0
>=20

Looks good.

Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>

--
Himanshu Madhani	 Oracle Linux Engineering

