From: =?iso-8859-1?q?Joilnen=20Leite?= <knl_joi@yahoo.com.br>
Subject: cciss_scsi
Date: Sat, 2 Aug 2003 04:59:39 -0300 (ART)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030802075939.99830.qmail@web40305.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web40305.mail.yahoo.com ([66.218.78.84]:46780 "HELO
	web40305.mail.yahoo.com") by vger.kernel.org with SMTP
	id S272466AbTHBH7k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 2 Aug 2003 03:59:40 -0400
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Excuse me but in
cciss_scsi_do_inquiry(drivers/block/cciss_scsi.c)
function, cp pointer can to be NULL, cus
scsi_cmd_alloc can NULL return, maybe it is better :)

--- linux-2.6.0-test2/drivers/block/cciss_scsi.c     =20
 2003-07-27 13:58:51.000000000 -0300
+++ linux-2.6.0-test2_bk/drivers/block/cciss_scsi.c  =20
 2003-08-02 04:42:35.000000000 -0300
@@ -896,12 +896,12 @@
        spin_lock_irqsave(CCISS_LOCK(c->ctlr), flags);
        cp =3D scsi_cmd_alloc(c);
        spin_unlock_irqrestore(CCISS_LOCK(c->ctlr),
flags);
-       ei =3D cp->err_info;

        if (cp =3D=3D NULL) {                       /*
trouble... */
                printk("cmd_alloc returned NULL!\n");
                return -1;
        }
+       ei =3D cp->err_info;

        cdb[0] =3D CISS_INQUIRY;
        cdb[1] =3D 0;


thanks !

_______________________________________________________________________
Conhe=E7a o novo Cad=EA? - Mais r=E1pido, mais f=E1cil e mais preciso.
Toda a web, 42 milh=F5es de p=E1ginas brasileiras e nova busca por imag=
ens!
http://www.cade.com.br
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
