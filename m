From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] scsi_host sysfs updates scsi-misc-2.5 [0/2]
Date: 11 May 2003 22:57:22 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1052711864.1768.7.camel@mulgrave>
References: <20030509063321.GA3259@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-pbMSBjSbkUFPUDN0MS92"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:16903 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261864AbTELDpH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 11 May 2003 23:45:07 -0400
In-Reply-To: <20030509063321.GA3259@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-pbMSBjSbkUFPUDN0MS92
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-05-09 at 01:33, Mike Anderson wrote:
> This series of patches is an update to the scsi_host sysfs / ref
> counting patches previously merged into the scsi-misc-2.5 tree. 

I'm still getting an oops in a scsi_register followed by a
scsi_unregister (because of an error in the driver setup).  The problem
occurs because the mid-layer is now dependent on the host_gendev.release
method.  Unfortunately, this isn't set until scsi_host_add, which may be
quite a while after scsi_register.

The quick "fix" is attached below, but I think we need all of this to be
symmetric (i.e. scsi_unregister can be called any time after
scsi_register) so probably the host_gendev.release method should be set
elsewhere.

James


--=-pbMSBjSbkUFPUDN0MS92
Content-Disposition: attachment; filename=tmp.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain; name=tmp.diff; charset=ISO-8859-1

=3D=3D=3D=3D=3D hosts.c 1.62 vs edited =3D=3D=3D=3D=3D
--- 1.62/drivers/scsi/hosts.c	Thu May  8 19:50:22 2003
+++ edited/hosts.c	Sun May 11 22:38:50 2003
@@ -258,7 +258,10 @@
  **/
 void scsi_unregister(struct Scsi_Host *shost)
 {
-	scsi_host_put(shost);
+	if(shost->host_gendev.release =3D=3D NULL)
+		scsi_free_shost(shost);
+	else
+		scsi_host_put(shost);
 }
=20
 /**

--=-pbMSBjSbkUFPUDN0MS92--

