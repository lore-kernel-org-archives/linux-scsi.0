Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.5 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,PDS_BAD_THREAD_QP_64,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B35B4C433B4
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:04:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 7700B61464
	for <linux-scsi@archiver.kernel.org>; Tue, 11 May 2021 03:04:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230023AbhEKDFq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 10 May 2021 23:05:46 -0400
Received: from mail-dm6nam11on2044.outbound.protection.outlook.com ([40.107.223.44]:15968
        "EHLO NAM11-DM6-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229961AbhEKDFo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 May 2021 23:05:44 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=gcKP4nvPZ2jrmBJh6HAHVFBlExZQtopj+TXQWfoDSiZ7JP8rd/34LGjYSEEhVlteHDMlZirTKS0QfqVyjtJS0ZKx1ICM0zhHmOMCYpWI3uvK2shBNSOsblXtj3X/vszF8ZdLemOzAbnkrc32Hurbp4JQ48U03bOu6HLZfiaxRG0w0v5sYFH5zm4S2hzL0b1N5oUuDABp9KDfnmkhQA3Bb+hDhlmgyYEq8iBFN0z+cGjXOPQ3JoTzxnCGMhdZ5A8QBEw5hZGNIUgwggePtOgc62ya2kSBmVr1RQggRTOOL6MphuAvfZigiPmZvvNHeBBFC3wQgUMuXq0LMGdMyi0V5w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dB0FS9bs3zn8RkEzhgKUzQoYaYL86oVSz07s6Xd3OAw=;
 b=O6/T27FynlOAptRWAwyfjdZVSzUdgzyUR1plTihD3sApLU95of8n7IHlqTTxDmyA1uPAnDncfBx+pYTWA1EspfAMk85Fyue0QTtVKOzUQF1JyMUq8u8T/UxcVWTNwlLpJ23JW2f5YTWmzgBdCF/usGgmdDklGxeXQdwDcNyxi1xzCDzLgS+Xxdbkk5IDHsNdVl0cJx173IX6kWF+vfZhpD7lFovXTvucvQQB9QVkCq8VsAYRzDYt7LzceUq4S+m3USyGO8cpMiIgOAih+R5ln/7RmTeUdRom/YldZo8KmE78CxaGWod0+isGx25IMJK+XzSWDXw0B1Y4hlW5JuP9gw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=vmware.com; dmarc=pass action=none header.from=vmware.com;
 dkim=pass header.d=vmware.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=vmware.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=dB0FS9bs3zn8RkEzhgKUzQoYaYL86oVSz07s6Xd3OAw=;
 b=XdTKu5jZwR3Igxvj1gFVMZLPsiFQSo+7XaxeSWgPHKmtKSF1g7FpJcLqdcpeXUUs658znIPr44FhmIUTkWnwii51u0y/lI2lLqqIQqJlqZOvdd/5szY5pF9JfIQRY+ahBnV8YEcHCyh+1sunan+CmK8PBI6m72++H4O1SHDrgM8=
Received: from BN8PR05MB6388.namprd05.prod.outlook.com (2603:10b6:408:50::17)
 by BN6PR05MB2884.namprd05.prod.outlook.com (2603:10b6:404:2e::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4129.22; Tue, 11 May
 2021 03:04:37 +0000
Received: from BN8PR05MB6388.namprd05.prod.outlook.com
 ([fe80::8190:dcbb:ee9f:9ab7]) by BN8PR05MB6388.namprd05.prod.outlook.com
 ([fe80::8190:dcbb:ee9f:9ab7%6]) with mapi id 15.20.4129.024; Tue, 11 May 2021
 03:04:37 +0000
From:   Matt Wang <wwentao@vmware.com>
To:     "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: [PATCH v2] scsi: BusLogic: Fix 64-bit system enumeration error for
 Buslogic
Thread-Topic: [PATCH v2] scsi: BusLogic: Fix 64-bit system enumeration error
 for Buslogic
Thread-Index: AQHXRhJgpB7kWtyrOUiKzbaEd0ZPZw==
Date:   Tue, 11 May 2021 03:04:37 +0000
Message-ID: <C325637F-1166-4340-8F0F-3BCCD59D4D54@vmware.com>
Accept-Language: zh-CN, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: oracle.com; dkim=none (message not signed)
 header.d=none;oracle.com; dmarc=none action=none header.from=vmware.com;
x-originating-ip: [43.243.14.11]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 3f8d761d-3b4e-49e5-f858-08d9142982f0
x-ms-traffictypediagnostic: BN6PR05MB2884:
x-microsoft-antispam-prvs: <BN6PR05MB28845B4A6B19B4BAC4D71DE6DE539@BN6PR05MB2884.namprd05.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:639;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: O/CC953EnxiHuV7bl9BZw8viU8Ce2yDkectNon3WbviywrlmeG0dD4Fq/lwxyHfhxNbKntjEwnNzWuCVqHAD8+/y2KM87j18D0XskgqNNxv+ODCtNRHnLl0vQlKXf91q5eHAWJ5TVaBjIzm/k2alS0MyPtW9GlCTx/yAh2UBQFwPxVN5dH1GacoB1LP0QulaNgArGOooLGt+6ZHWJqk00N3YFZ8B4duyB1gnY40cfNRARXmQBL0cVI2ER372xEDmyAWRrwApCV0d2uXZ5CN73a2+0emI46XJap1s8VMYxCP0UG98OVAR6mevV9E/ZSXe30UxD+sFxRvJ/sFJCBS7FQ9fClVqvHgW92gmsm62dvESimIQEgRtTeO2xGGRZ2BlN9CQacGF5OvEfHFBFBKzAuYPqfwXCX7KrxJ+IC1GVBFLLaFCIUl9VjEhG6ubzTetFAtVRQjzQJcGWjR7iIIfPlSwaNasgdtVoQ0caJxVqMcs43GWIGafDpOz0fwuYHYP2a9rSg6Ahg0hls9VhrMuDxxjKH4u2IrWWK3GsDxu82/CeElHPZuZkVYZlp2g54Caajcw88tSqo+ta7zO+SRM9Yvz3gtVE/GdDO3/Elc+7EzP7Vcvwvj6K/bIAupozQdK11Q6qD0+eN8/84aSt1ZKbgq2Xj6oqZwaHJE0la0pRdk=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR05MB6388.namprd05.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(376002)(396003)(366004)(136003)(346002)(39860400002)(76116006)(2906002)(316002)(122000001)(64756008)(5660300002)(66556008)(66476007)(91956017)(6512007)(66446008)(66946007)(71200400001)(36756003)(86362001)(33656002)(83380400001)(186003)(26005)(478600001)(8936002)(6506007)(2616005)(8676002)(6486002)(38100700002)(110136005)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?y3WTyGbPrjLGkp1AQWRdK8MXLq2eRaT2f20RDNUN0vVBNrMBiqunud+EXs/v?=
 =?us-ascii?Q?9DX9XXniivb2Qn0p3+AU38uLcVLPNASvHe1i2AAf7yfC83SJ5aAaiDMkzjaa?=
 =?us-ascii?Q?18tMD+x/hytbnaPyh78CNSUrmts4zktmciQvitz81yrqg2qnvrFPpPLn+DgV?=
 =?us-ascii?Q?Od1HldeLuFNZ6pU2uBoduGOQprLkOFEH+ENdqD6yrrEVk3gvjfJ5q6w2pk8J?=
 =?us-ascii?Q?p+7X91oN2MMZriPqOlDlKk6rIfRArvzqN7V8CEREEQm0bd03++m+uZMnj3b0?=
 =?us-ascii?Q?OIhPQgAVvFMin0Q+FL5bGt4rnsNO03Yj9p1wa7pbGf2kCO4vLgKAJcd1nMiD?=
 =?us-ascii?Q?6mAIXZcffbT+j8B9w3Hf/7FKzGyLGaMKI+cjnPEm+fuqIscv6lGXbwmcoZ4T?=
 =?us-ascii?Q?+XLY/SRUjtSCEUBbyu0aiArFSNJSjWZJK8XiWjxOmvsHtpsy6AFMqFPAzKzO?=
 =?us-ascii?Q?IVJ1p+pm3kdpIbb1k3GIxT5pnb6joM8FwQ7JG5qOaOtMek2G663kiDM/QpGw?=
 =?us-ascii?Q?WFWQlZi0Iy6Og1iz+A1t9CquH/w7LOAyOfr0uxCqN7mD/V9GtY7CXEIKDY70?=
 =?us-ascii?Q?xB5miPVSaxedWxG7cx5cdaefG7hRXCbXsP5k0+nFZMcKTmLUO7zq85Ag6jgO?=
 =?us-ascii?Q?nAiQ9l8LevHn1/DA5TIT1orcNkIwt0WfwU9tSVgLmkckaXYU6+z2DIR0rjdU?=
 =?us-ascii?Q?sqr7ZAg4LQ0bfugWzeiIpB7rffSbAyQxeNrd5lL02lQkyGEOmZproA4c4wBd?=
 =?us-ascii?Q?dvlkvmE4Z7UfjhtbTMQmbY2RPVHXaf9gMioJGzgPLUH6Lo3AtvkhYh6Bi/E9?=
 =?us-ascii?Q?QxH5vtNSkHwab1kgll5rsgLZFodIKVbE09qOapcqV8fyPRE1JghAoAZeVP2P?=
 =?us-ascii?Q?AchmdwQBTJKWK/AkSrvghZw0ySC84DunZmvjhiY5Z2uOBdaY+p5gi1UzrGAG?=
 =?us-ascii?Q?jRFoGF+2re0zxVpzXaCc5sruE775Xjgal3j0h/M0dfZ0ClQY66fpSkO4IxNn?=
 =?us-ascii?Q?kJfH5gM826Sz5rA+pfTySghCPAo1/H6JERaftDqQNsNsLd0ZThJUO7mewq35?=
 =?us-ascii?Q?YN1nfzhbFhY2SOe5X2oiygeA6yEyVEWxFo6DwLJfDBq96hVolzgKIrvWQssH?=
 =?us-ascii?Q?JZFIdELSZI7Vi0km220FbGvA8Eig1nF+qeNdBeArR0AU8KB716f9ekBZFZ7P?=
 =?us-ascii?Q?sMnAUjxblJI8UMDbrLyWtFfbVMxQlOuVMUEefO0dF+lWh8+Zfvzr3aWTPZed?=
 =?us-ascii?Q?mtJZ7VURGstvKUfrSFpNEmuQ4fOMmcoGSeo0W7DBLXvP3Wg31a3MNaoDAvqC?=
 =?us-ascii?Q?34O+2koXcTeKt+BrNXFPIjAq?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <0B42D49545BB704B9BDCFCB1040AB995@namprd05.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: vmware.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: BN8PR05MB6388.namprd05.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 3f8d761d-3b4e-49e5-f858-08d9142982f0
X-MS-Exchange-CrossTenant-originalarrivaltime: 11 May 2021 03:04:37.2001
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: b39138ca-3cee-4b4a-a4d6-cd83d9dd62f0
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: M+SAMpGDgvo6sPBS4H5aScqhCu8pzj2tEZLERmhC36AzMHwAoZi7ngoAiy1yKRv+rMiGXJ/aa7plwwjlCEUaoQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN6PR05MB2884
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Commit 391e2f25601e ("BusLogic: Port driver to 64-bit") in Buslogic
driver introduced a serious issue for 64-bit systems. With this
commit, 64-bit kernel will enumerate 8*15 non-existing disks.  This
is caused by the broken CCB structure. The change from u32 data to
void *data increased CCB length on 64-bit system, which introduced
an extra 4 byte offset of the CDB. This leads to incorrect response
to INQUIRY commands during enumeration.

Fix disk enumeration failure by reverting the portion of commit=20
391e2f25601e which switched the data pointer from u32 to void

Signed-off-by: Matt Wang <wwentao@vmware.com>
Acked-by: Khalid Aziz <khalid@gonehiking.org>
---
drivers/scsi/BusLogic.c | 6 +++---
drivers/scsi/BusLogic.h | 2 +-
2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/scsi/BusLogic.c b/drivers/scsi/BusLogic.c
index ccb061ab0a0a..7231de2767a9 100644
--- a/drivers/scsi/BusLogic.c
+++ b/drivers/scsi/BusLogic.c
@@ -3078,11 +3078,11 @@ static int blogic_qcmd_lck(struct scsi_cmnd *comman=
d,
		ccb->opcode =3D BLOGIC_INITIATOR_CCB_SG;
		ccb->datalen =3D count * sizeof(struct blogic_sg_seg);
		if (blogic_multimaster_type(adapter))
-			ccb->data =3D (void *)((unsigned int) ccb->dma_handle +
+			ccb->data =3D (unsigned int) ccb->dma_handle +
					((unsigned long) &ccb->sglist -
-					(unsigned long) ccb));
+					(unsigned long) ccb);
		else
-			ccb->data =3D ccb->sglist;
+			ccb->data =3D virt_to_32bit_virt(ccb->sglist);

		scsi_for_each_sg(command, sg, count, i) {
			ccb->sglist[i].segbytes =3D sg_dma_len(sg);
diff --git a/drivers/scsi/BusLogic.h b/drivers/scsi/BusLogic.h
index 6182cc8a0344..e081ad47d1cf 100644
--- a/drivers/scsi/BusLogic.h
+++ b/drivers/scsi/BusLogic.h
@@ -814,7 +814,7 @@ struct blogic_ccb {
	unsigned char cdblen;				/* Byte 2 */
	unsigned char sense_datalen;			/* Byte 3 */
	u32 datalen;					/* Bytes 4-7 */
-	void *data;					/* Bytes 8-11 */
+	u32 data;					/* Bytes 8-11 */
	unsigned char:8;				/* Byte 12 */
	unsigned char:8;				/* Byte 13 */
	enum blogic_adapter_status adapter_status;	/* Byte 14 */
--=20
2.17.1
