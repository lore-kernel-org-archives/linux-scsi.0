From: Rolf Eike Beer <eike-kernel@sf-tec.de>
Subject: Re: [PATCH 15/16] gdth: Move members from SCp to gdth_cmndinfo, stage 2
Date: Tue, 2 Oct 2007 20:02:45 +0200
Message-ID: <200710022002.46919.eike-kernel@sf-tec.de>
References: <46FFFC8C.6080804@panasas.com> <4700040E.2000007@panasas.com>
Mime-Version: 1.0
Content-Type: multipart/signed;
  boundary="nextPart1288624.17e0N9kAJf";
  protocol="application/pgp-signature";
  micalg=pgp-sha1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.sf-mail.de ([62.27.20.61]:51118 "EHLO mail.sf-mail.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753705AbXJCPpr (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Oct 2007 11:45:47 -0400
In-Reply-To: <4700040E.2000007@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@steeleye.com>, Matthew Wilcox <willy@linux.intel.com>, achim_leubner@adaptec.com, linux-scsi <linux-scsi@vger.kernel.org>

--nextPart1288624.17e0N9kAJf
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline

Boaz Harrosh wrote:
>   - Cleanup the rest of the scsi_cmnd-SCp members and move them
>     to gdth_cmndinfo:

>     SCp.have_data_in 	 =3D> volatile wait_for_completion

> Signed-off-by Boaz Harrosh <bharrosh@panasas.com>

volatile here is probably nonsense. Either you need proper locking on this=
=20
struct in case there may be side-effects between different callers or it's=
=20
unneeded at all. This looks really suspicious:

=2D-- a/drivers/scsi/gdth_proc.c
+++ b/drivers/scsi/gdth_proc.c
@@ -728,20 +728,22 @@ static void gdth_wait_completion(gdth_ha_str *ha, int=
=20
busnum, int id)
     ulong flags;
     int i;
     Scsi_Cmnd *scp;
+    struct gdth_cmndinfo *cmndinfo;
     unchar b, t;
=20
     spin_lock_irqsave(&ha->smp_lock, flags);
=20
     for (i =3D 0; i < GDTH_MAXCMDS; ++i) {
         scp =3D ha->cmd_tab[i].cmnd;
+        cmndinfo =3D gdth_cmnd_priv(scp);
=20
         b =3D scp->device->channel;
         t =3D scp->device->id;
         if (!SPECIAL_SCP(scp) && t =3D=3D (unchar)id &&=20
             b =3D=3D (unchar)busnum) {
=2D            scp->SCp.have_data_in =3D 0;
+            cmndinfo->wait_for_completion =3D 0;
             spin_unlock_irqrestore(&ha->smp_lock, flags);
=2D            while (!scp->SCp.have_data_in)
+            while (!cmndinfo->wait_for_completion)
                 barrier();

I haven't checked for locking around the other accesses, but they look racy=
=2E=20
This looks like wasting CPU cycles by busy-looping for a change. And for=20
things like these

@@ -3511,8 +3514,8 @@ static int gdth_sync_event(gdth_ha_str *ha, int servi=
ce,=20
unchar index,
                 }
             }
         }
=2D        if (!scp->SCp.have_data_in)
=2D            scp->SCp.have_data_in++;
+        if (!cmndinfo->wait_for_completion)
+            cmndinfo->wait_for_completion++;

probably atomic_inc_not_zero() should be used if it is really needed at all.

Greetings,

Eike

--nextPart1288624.17e0N9kAJf
Content-Type: application/pgp-signature; name=signature.asc 
Content-Description: This is a digitally signed message part.

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v1.4.5 (GNU/Linux)

iD8DBQBHAofGXKSJPmm5/E4RAjQvAJ4gZcoXCXUikUYbIMVIqgeZeIODsACdFpxe
PzJjE3pUD5wptEZ1VFLyKVY=
=lxvl
-----END PGP SIGNATURE-----

--nextPart1288624.17e0N9kAJf--
