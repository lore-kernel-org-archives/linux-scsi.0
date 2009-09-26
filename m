From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH 2/2] be2iscsi: Moving to pci_pools v3
Date: Sat, 26 Sep 2009 09:30:22 -0700
Message-ID: <1253982622.27401.25.camel@mulgrave.site>
References: <20090922025217.GA19987@serverengines.com>
	 <4ABA550F.1000504@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:58694 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751363AbZIZTKH (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 26 Sep 2009 15:10:07 -0400
In-Reply-To: <4ABA550F.1000504@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Jayamohan Kalickal <jayamohank@serverengines.com>, linux-scsi@vger.kernel.org

On Wed, 2009-09-23 at 12:04 -0500, Mike Christie wrote:
> On 09/21/2009 09:52 PM, Jayamohan Kallickal wrote:
> >   This patch contains changes to use pci_pools for iscsi hdr
> > instead of pci_alloc_consistent. Here we alloc and free to pool
> > for every IO
> >
> > v3:
> > - Remove cleanup loop in beiscsi_session_destroy
> > - Fixup for allocation failure handling in beiscsi_alloc_pdu
> > - Removed unused variable in beiscsi_session_destroy.
> >
> > Signed-off-by: Jayamohan Kallickal<jayamohank@serverengines.com>
>=20
> Thanks for fixing those issues.
>=20
> Reviewed-by: Mike Christie <michaelc@cs.wisc.edu>

Actually, this isn't building correctly for me in my 32 bit environment=
:

drivers/scsi/be2iscsi/be_main.c: In function =E2=80=98beiscsi_alloc_pdu=
=E2=80=99:
drivers/scsi/be2iscsi/be_main.c:2885: warning: passing argument 3 of
=E2=80=98dma_pool_alloc=E2=80=99 from incompatible pointer type

The problem is this unsigned long long definition of a64: dma_addr_t is
only a long (32 bits) on this platform.

This patch fixes the problem for me ... I'll just fold it in if
everyone's OK with it.

James

---

diff --git a/drivers/scsi/be2iscsi/be_main.c b/drivers/scsi/be2iscsi/be=
_main.c
index 4299a46..4f1aca3 100644
--- a/drivers/scsi/be2iscsi/be_main.c
+++ b/drivers/scsi/be2iscsi/be_main.c
@@ -2881,13 +2881,15 @@ static int beiscsi_alloc_pdu(struct iscsi_task =
*task, uint8_t opcode)
 	struct hwi_controller *phwi_ctrlr;
 	itt_t itt;
 	struct beiscsi_session *beiscsi_sess =3D beiscsi_conn->beiscsi_sess;
+	dma_addr_t paddr;
=20
 	io_task->cmd_bhs =3D pci_pool_alloc(beiscsi_sess->bhs_pool,
-					  GFP_KERNEL,
-					  &io_task->bhs_pa.u.a64.address);
+					  GFP_KERNEL, &paddr);
+
 	if (!io_task->cmd_bhs)
 		return -ENOMEM;
=20
+	io_task->bhs_pa.u.a64.address =3D paddr;
 	io_task->pwrb_handle =3D alloc_wrb_handle(phba,
 						beiscsi_conn->beiscsi_conn_cid,
 						task->itt);


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
