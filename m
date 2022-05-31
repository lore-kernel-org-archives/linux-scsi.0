Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E30AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 20:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1347678AbiEaUJn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 16:09:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347676AbiEaUJl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 16:09:41 -0400
Received: from mout.gmx.net (mout.gmx.net [212.227.15.19])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 546679CCA3;
        Tue, 31 May 2022 13:09:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1654027769;
        bh=SpaW+K+iXwLlDtmUuEP79I+PnshkKLoJeYkgATnluzI=;
        h=X-UI-Sender-Class:Date:From:To:Cc:Subject;
        b=Rcl46lGUsY3cOtTl/3p6z5Kk+06cwO5P+zrEgTSTgdgHyDSY2SS/CG6nfHNhD2C+B
         JyUP8aIDBgVOb3c3qXO2oGo7FTI7ttkt7NUHEcGWL0rl4z/SS4jRcxA1AdOM+fqB8O
         OdKjdE5FwZCwUWH6fgmdtcHW2tNZsnxPM1ElDE5U=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from p100 ([92.116.178.167]) by mail.gmx.net (mrgmx004
 [212.227.17.190]) with ESMTPSA (Nemesis) id 1N3KPg-1nmoix2kTq-010LSU; Tue, 31
 May 2022 22:09:29 +0200
Date:   Tue, 31 May 2022 22:09:27 +0200
From:   Helge Deller <deller@gmx.de>
To:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     linux-parisc@vger.kernel.org
Subject: [PATCH] scsi: mpt3sas: Fix out-of-bounds compiler warning
Message-ID: <YpZ197iZdDZSCzrT@p100>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:tl3wFOlvGvIBnaXVvEBKKVCEVxNwBbTqWRdgstyaLZLjx5x2ox1
 O3h/SUsY9IQMwVnEDJ1pCUy3bMMi2011OF8tfpCdmm8jrZQRJORtIAxIZhPaAtP/Goq3o8e
 7tMI2i0BNnioDX8AED2pr2zKcXtbjI8zrkdl/mj6tcR09nWCzu0jB7/adVlv8h7DTLXBIeC
 bodKx6IAE/nIyRcQ2cSOQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:pqRogXhGNqA=:VjZzRByfFJRhNIvmuXXuQm
 NWVWq456BlODY9TybSBPaI3nXrK7tALoNHedVGqw14a1pBwWyndWbEIFWkpAem4W/1P/Zz/6+
 bsAV8BzryZx1Lq9o/sddpct0WlbNQaVU/ApTTWpfNC1RrSIBEr/+9WGvAAqSe96O9j5K2I5N+
 xRPj2DJfLQSbbrV0tvOBu88gvdWjrI48GzN61PhTBUvkxMDm/6vUfnKkbbKVIRsJ/BO/7N/Hq
 +vI8A9V4aUc8f2dmoTdunpfBNTs1bpMmqQo6rKhioR9NCsw6Gr8zm3Q52SFcolEVG/EyVuDjO
 qnqpDi/WyPdXl5KxYPQC7w6CeETnY6JS7i3VeAwLLlkboUAvJCIhG7Ky703asEi2/IOgZVMX4
 h+TAjVbtjgqD9F5/FIpxkF5y7Tka0JE4LAeSYgmSkah2kT2OCNq/FGNmqo0cb4wGxQ/cDkN4r
 V7jKHlPzdn9ovmdQ9woSXJrrnxZDDHGe5e68QhR/YwazMwJac2mv3seeCQZ9XB5of9akV2evV
 HwkAHuozhkUDlIxZlGOq2FkFVX566Sa7ORfoac2om8fXqam4LsY1xu96o28G0hKbendPoFSk1
 NTepjygp7iv/+KH+yoSMAtT6PTvqQOSalufZn5MFk2gj6se3vBb0N2UJaBHcoTdcUzvz5c1XM
 s8DAIw8G2jxYeRhK+a9fIzT7lIpylRGGZXF7nAKcgR2VEE1EojMrIcR3AgdqjOObB2AWDqDbC
 shxCyqvIzXMpJrhkP9i4JSciSAsu9ZVTFaDUkm/KorbWzJRerKW8bf983Lb5mARgujqDSwTIX
 zAZWICUonDQFp/s9IycMQzwWp2m+TSaO2hGuk8VlbbzlP6gjNfdlRMH+USt6h+GEv6OPCxGyc
 rSW5p0jV11BgL9Zq8M0aULzEfBrsdmw9q8fidKA5RALBhljnADO6WAmI6qYDpNwEXlC+co+jW
 82pmprFrWeEUeXIfxKZu1YtmFW28kU73rUo0EpL5VhvCIqc+PFzFFanwL1tsNrFlGABa6ogs9
 CFPQUYMUFS0oEIFzcT/FgBo9ZsemQTOMEJ6IFif6X1gMPiS4Nncd0/FdwxMM3w8ZnnSC7Jx9x
 KEW3iZ+lskNw+d2ha2YS3KZOLMaumbKNp4U4c3GXDk4/IFlMGDHDNrP+A==
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

I'm facing this warning when building for the parisc64 architecture:

drivers/scsi/mpt3sas/mpt3sas_base.c: In function =E2=80=98_base_make_ioc_o=
perational=E2=80=99:
drivers/scsi/mpt3sas/mpt3sas_base.c:5396:40: warning: array subscript =E2=
=80=98Mpi2SasIOUnitPage1_t {aka struct _MPI2_CONFIG_PAGE_SASIOUNIT_1}[0]=
=E2=80=99 is partly outside array bounds of =E2=80=98unsigned char[20]=E2=
=80=99 [-Warray-bounds]
 5396 |             (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
drivers/scsi/mpt3sas/mpt3sas_base.c:5382:26: note: referencing an object o=
f size 20 allocated by =E2=80=98kzalloc=E2=80=99
 5382 |         sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
      |                          ^~~~~~~~~~~~~~~~~~~~~~~

The problem is, that only 20 bytes are allocated with kmalloc(), which
is sufficient to hold the bytes which are needed.
Nevertheless, gcc complains because the whole Mpi2SasIOUnitPage1_t
struct is 32 bytes in size and thus doesn't fit into those 20 bytes.

This patch simply allocates all 32 bytes (instead of 20) and thus avoids t=
he
warning. There is no functional change introduced by this patch.

While touching the code I cleaned up to calculation of max_wideport_qd,
max_narrowport_qd and max_sata_qd to make it easier readable.

Test sucessfully tested on a HP C8000 PA-RISC workstation with 64-bit
kernel.

Signed-off-by: Helge Deller <deller@gmx.de>

diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mp=
t3sas_base.c
index 538d2c0cd971..aa142052ebe4 100644
=2D-- a/drivers/scsi/mpt3sas/mpt3sas_base.c
+++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
@@ -5368,6 +5368,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SA=
S_ADAPTER *ioc)
 	Mpi2ConfigReply_t mpi_reply;
 	Mpi2SasIOUnitPage1_t *sas_iounit_pg1 =3D NULL;
 	Mpi26PCIeIOUnitPage1_t pcie_iounit_pg1;
+	u16 depth;
 	int sz;
 	int rc =3D 0;

@@ -5379,7 +5380,7 @@ static int _base_assign_fw_reported_qd(struct MPT3SA=
S_ADAPTER *ioc)
 		goto out;
 	/* sas iounit page 1 */
 	sz =3D offsetof(Mpi2SasIOUnitPage1_t, PhyData);
-	sas_iounit_pg1 =3D kzalloc(sz, GFP_KERNEL);
+	sas_iounit_pg1 =3D kzalloc(sizeof(Mpi2SasIOUnitPage1_t), GFP_KERNEL);
 	if (!sas_iounit_pg1) {
 		pr_err("%s: failure at %s:%d/%s()!\n",
 		    ioc->name, __FILE__, __LINE__, __func__);
@@ -5392,16 +5393,16 @@ static int _base_assign_fw_reported_qd(struct MPT3=
SAS_ADAPTER *ioc)
 		    ioc->name, __FILE__, __LINE__, __func__);
 		goto out;
 	}
-	ioc->max_wideport_qd =3D
-	    (le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_narrowport_qd =3D
-	    (le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth)) ?
-	    le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth) :
-	    MPT3SAS_SAS_QUEUE_DEPTH;
-	ioc->max_sata_qd =3D (sas_iounit_pg1->SATAMaxQDepth) ?
-	    sas_iounit_pg1->SATAMaxQDepth : MPT3SAS_SATA_QUEUE_DEPTH;
+
+	depth =3D le16_to_cpu(sas_iounit_pg1->SASWideMaxQueueDepth);
+	ioc->max_wideport_qd =3D (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth =3D le16_to_cpu(sas_iounit_pg1->SASNarrowMaxQueueDepth);
+	ioc->max_narrowport_qd =3D (depth ? depth : MPT3SAS_SAS_QUEUE_DEPTH);
+
+	depth =3D sas_iounit_pg1->SATAMaxQDepth;
+	ioc->max_sata_qd =3D (depth ? depth : MPT3SAS_SATA_QUEUE_DEPTH);
+
 	/* pcie iounit page 1 */
 	rc =3D mpt3sas_config_get_pcie_iounit_pg1(ioc, &mpi_reply,
 	    &pcie_iounit_pg1, sizeof(Mpi26PCIeIOUnitPage1_t));
