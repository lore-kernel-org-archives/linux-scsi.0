Return-Path: <SRS0=wj+1=BI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 31C3AC433E0
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:05:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 16DA3207F5
	for <linux-scsi@archiver.kernel.org>; Wed, 29 Jul 2020 18:05:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="E5dcDswT"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgG2SFn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 29 Jul 2020 14:05:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726336AbgG2SFn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Jul 2020 14:05:43 -0400
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F09A9C061794;
        Wed, 29 Jul 2020 11:05:42 -0700 (PDT)
Received: by mail-pf1-x444.google.com with SMTP id w126so13165633pfw.8;
        Wed, 29 Jul 2020 11:05:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mime-version:content-disposition
         :user-agent;
        bh=o4rHFcSX18taIt22ICNbpXYlTpfl8WXy430SyBBEUAM=;
        b=E5dcDswTV0bghO/zuaUaa+n4pmPDRrS+T8PGxl0a+f0/jTptmvCZU0D771HXDXsIJ3
         VyRQvKsc0WpS0ECJruR89RbMsdAneUM7D+QpNx+NjZBF7QIwR2ENKBNuuh8atw/Pxscp
         hHQRJ1/+9WDb75HnKnCtBNU6lmeFrRYPHCE3tRDgijlQVTnkS/MJHnrirfEFiXw3GMhs
         idt/Y6zTbS2T8stdWNrubVRtimexORKSQtjMJtchUdxHJnHmJDUDIU9y2ogW7pgbr7cV
         lxFqD7UxsHmVKDSysSEDTjwsiUUVfmqdCSDpUBq3/qpdUPJWZNLVUhOrnYKPbKLirO2Q
         bpRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition:user-agent;
        bh=o4rHFcSX18taIt22ICNbpXYlTpfl8WXy430SyBBEUAM=;
        b=eVpoFj9OUa6mJPM8bkkr/vEKBObVsxbIppMptd82AUESo0TDRGbzEn2/GGUwIDE+FO
         kpcKGkljDZLTVSil5IE0Ghx8PPEZ1RshocVwFCYGuZHQyMhUuh9/H4bZmllCeTXVb1Q/
         RrCZBAvd2xO4XKfBjaWrAZ0T0vkKFTlvW9WEvJcTAUtWgLOThJlnV5UdKpv9UzcDosWV
         gq3s5Tk6/qoG3RSIK4mWdpdRH2IFG+T/im9TUuQYG75IYt7PTLNgiXuLv6XN+muCV+rU
         rLv6k1ePWLhGLf6jX1gkbm75HOf80JJs0reQ/7RCwfVlmkM1VD3IGyAp22Sp2EFfyGWx
         W2Bw==
X-Gm-Message-State: AOAM532c1wQJO/eBlvw4Yx33cnQMnoDBMtjn1XId8EgrSzZqH5HrX5rU
        hEWZTVukepvghC/I8aAsYJc=
X-Google-Smtp-Source: ABdhPJyP7hgMODXN5GM7qlOwF3ltPEqxc6RD0cHdnqEcvogvzbLG7VXgfylJKoEdbBzKyVlK2oAvqg==
X-Received: by 2002:a63:db46:: with SMTP id x6mr29413959pgi.265.1596045942478;
        Wed, 29 Jul 2020 11:05:42 -0700 (PDT)
Received: from blackclown ([103.88.82.91])
        by smtp.gmail.com with ESMTPSA id d9sm3089514pgv.45.2020.07.29.11.05.39
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 29 Jul 2020 11:05:41 -0700 (PDT)
Date:   Wed, 29 Jul 2020 23:35:29 +0530
From:   Suraj Upadhyay <usuraj35@gmail.com>
To:     jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/7] scsi: Remove pci-dma-compat wrapper APIs.
Message-ID: <cover.1596045683.git.usuraj35@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha512;
        protocol="application/pgp-signature"; boundary="oyUTqETQ0mS9luUI"
Content-Disposition: inline
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--oyUTqETQ0mS9luUI
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

Hii Maintainers,
        This patchset replaces the pci-dma-compat wrappers with their
dma-mapping counterparts. Thus, removing possible midlayering and
unnecessary legacy code and API.

Most of the task is fairly trivially scriptable and done with
coccinelle. But the handling of pci_z/alloc_consistent needed
some hand modification in replacing the flag GFP_ATOMIC with
a proper flag depending upon the context.

I would be glad to receive any feedbacks.

Thanks,

Suraj Upadhyay.

Suraj Upadhyay (7):
  scsi: aacraid: Remove pci-dma-compat wrapper APIs
  scsi: aic7xxx: Remove pci-dma-compat wrapper APIs.
  scsi: dc395x: Remove pci-dma-compat wrapper APIs.
  scsi: mpt3sas: Remove pci-dma-compat wrapper APIs.
  scsi: hpsa: Remove pci-dma-compat wrapper APIs.
  scsi: qla2xxx: Remove pci-dma-compat wrapper APIs.
  scsi: megaraid: Remove pci-dma-compat wrapper APIs

 drivers/scsi/aacraid/aachba.c      |   4 +-
 drivers/scsi/aacraid/commctrl.c    |  20 +--
 drivers/scsi/aacraid/commsup.c     |   8 +-
 drivers/scsi/aacraid/linit.c       |   4 +-
 drivers/scsi/aic7xxx/aic79xx_osm.c |   7 +-
 drivers/scsi/dc395x.c              |   6 +-
 drivers/scsi/hpsa.c                |  16 +--
 drivers/scsi/megaraid.c            | 192 +++++++++++++++--------------
 drivers/scsi/mpt3sas/mpt3sas_ctl.c |  10 +-
 drivers/scsi/qla2xxx/qla_os.c      |   4 +-
 10 files changed, 141 insertions(+), 130 deletions(-)

--=20
2.17.1


--oyUTqETQ0mS9luUI
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQIzBAABCgAdFiEE7AbCa0kOsMJ4cx0j+gRsbIfe744FAl8hul8ACgkQ+gRsbIfe
745yWg/8CeOWFmcv9+wzPrfH02Fq11gXeVjZLQryrC0ks9fqo7DFuGSNZ1KI34Tu
7paRWyZNFU/LPSd9TmqnTUKDafICDEXSzsAEC14wgDqFojS/VR9F5iY069SabcUO
AWaFJBZ9Oe3qDQ3cD52vtWm3I2nwGP1njiOjQB3tc3qCEC4aIkEYNXY3S3bfe91X
8yK+r44sf6CIBNj5HXBqMlNVdrNUThzWGmBDVfwL6GK57rqgVUzCUVic///TbEiS
2AGk1DSUvzuJ46iqUU6VPodV/OiZlUZKBhdBa7LHGe5GE8jHBtMmWKgOzwTHpUZi
WOxaYbBuTPGHWzlX/XOdcbqB6t/N28eBMxxFZ4MSv04U0Bpg7A1wH/QJmJnKmHIO
FxwcRmCjbY8d4mdQeUjQjL4Oefevg4t4dziI1Zk7XwatgNnzL4+8iBYtOxzdEZEI
YKzw2ncN0cuuB/nxKdoKaCV3L87JbRPYp3JKXh288v16czfOYzlPVkzNduTKvN6i
j5ZGUg4nb4wtXUxyZ8VU3skGrK+8Pik85Gwt+ZlLlyKMHn101lE4M2izsPM+8lNP
MNjCwQUk7/W3ZhfePaAxsD0LDkvNRDoFt4FVRDCcyhrHAHbrk1qx/G1ETAv1cmSi
D6nE89UniN/XjP2SZWWHhatR0LnSbsRxbOKtgvYdflIvogGkMpY=
=1Cx6
-----END PGP SIGNATURE-----

--oyUTqETQ0mS9luUI--
