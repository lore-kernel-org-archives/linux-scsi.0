Return-Path: <SRS0=3eE7=C6=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CF208C43464
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 11:23:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89690207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Sep 2020 11:23:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726801AbgIULXp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Sep 2020 07:23:45 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:34760 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726367AbgIULXo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Sep 2020 07:23:44 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 358D81C0B7A; Mon, 21 Sep 2020 13:23:41 +0200 (CEST)
Date:   Mon, 21 Sep 2020 13:23:40 +0200
From:   Pavel Machek <pavel@denx.de>
To:     njavali@marvell.com, GR-QLogic-Storage-Upstream@marvell.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH] qla2xxx: Use constant when it is known.
Message-ID: <20200921112340.GA19336@duo.ucw.cz>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha1;
        protocol="application/pgp-signature"; boundary="Q68bSM7Ycu6FN28Q"
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--Q68bSM7Ycu6FN28Q
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Directly return constant when it is known, to make code easier to
understand.

Signed-off-by: Pavel Machek (CIP) <pavel@denx.de>

diff --git a/drivers/scsi/qla2xxx/qla_nvme.c b/drivers/scsi/qla2xxx/qla_nvm=
e.c
index 90bbc61f361b..248197e9e8ea 100644
--- a/drivers/scsi/qla2xxx/qla_nvme.c
+++ b/drivers/scsi/qla2xxx/qla_nvme.c
@@ -530,7 +530,7 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_port =
*lport,
 	fc_port_t *fcport;
 	struct srb_iocb *nvme;
 	struct scsi_qla_host *vha;
-	int rval =3D -ENODEV;
+	int rval;
 	srb_t *sp;
 	struct qla_qpair *qpair =3D hw_queue_handle;
 	struct nvme_private *priv =3D fd->private;
@@ -538,14 +538,14 @@ static int qla_nvme_post_cmd(struct nvme_fc_local_por=
t *lport,
=20
 	if (!priv) {
 		/* nvme association has been torn down */
-		return rval;
+		return -ENODEV;
 	}
=20
 	fcport =3D qla_rport->fcport;
=20
 	if (!qpair || !fcport || (qpair && !qpair->fw_started) ||
 	    (fcport && fcport->deleted))
-		return rval;
+		return -ENODEV;
=20
 	vha =3D fcport->vha;
 	/*

--=20
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blo=
g.html

--Q68bSM7Ycu6FN28Q
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iF0EABECAB0WIQRPfPO7r0eAhk010v0w5/Bqldv68gUCX2iNPAAKCRAw5/Bqldv6
8nvDAJ9qoT4VQBrHNtrCgCv/0bloB/Ku9gCfalBr9fm63M1ZyIoQC1wOICLHLyw=
=pVnS
-----END PGP SIGNATURE-----

--Q68bSM7Ycu6FN28Q--
