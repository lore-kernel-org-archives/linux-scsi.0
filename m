From: Kilian CAVALOTTI <kilian.cavalotti@lip6.fr>
Subject: Re: aic7xxx support for >2TB volumes?
Date: Mon, 21 Nov 2005 16:09:47 +0100
Message-ID: <200511211609.47828.kilian.cavalotti@lip6.fr>
References: <200511161208.02374.kilian.cavalotti@lip6.fr> <200511211109.19490.kilian.cavalotti@lip6.fr> <4381DE2B.8060509@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from isis.lip6.fr ([132.227.60.2]:53418 "EHLO isis.lip6.fr")
	by vger.kernel.org with ESMTP id S932324AbVKUPJy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 21 Nov 2005 10:09:54 -0500
In-Reply-To: <4381DE2B.8060509@us.ibm.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: linux-scsi@vger.kernel.org

On Monday 21 November 2005 15:48, Brian King wrote:
> Quite possibly. Looking at ahc_linux_run_command in aic7xxx_osm.c it
> appears that commands with a cdb length of > 12 are sent to the adapt=
er in
> a different way.=20

Do you mean: ?
        hscb->cdb_len =3D cmd->cmd_len;
        if (hscb->cdb_len <=3D 12) {
                memcpy(hscb->shared_data.cdb, cmd->cmnd, hscb->cdb_len)=
;
        } else {
                memcpy(hscb->cdb32, cmd->cmnd, hscb->cdb_len);
                scb->flags |=3D SCB_CDB32_PTR;
        }

> Perhaps this method does not work on the card you have.=20

Isn't there a way to determine if the HBA has an hardware limitation, o=
r the=20
size of the max command length it accepts?

Regards,

--=20
Kilian CAVALOTTI                      Administrateur r=E9seaux et syst=E8=
mes
UPMC / CNRS - LIP6 (C870)
8, rue du Capitaine Scott                          Tel. : 01 44 27 88 5=
4
75015 Paris - France                               Fax. : 01 44 27 70 0=
0
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
