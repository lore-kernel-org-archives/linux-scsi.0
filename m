From: "Martin Peschke3" <MPESCHKE@de.ibm.com>
Subject: Re: ide-scsi data transfer residuals
Date: Mon, 8 Jul 2002 18:17:26 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <OF8F8BE74E.CB60B794-ONC1256BF0.0059093D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: tonyb@cybernetics.com, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org


Hi,

unfortunately the residual count is not used by high level
SCSI drivers like sd and sr to recover partial data transfers,
as far as I can see. That's dangerous.

Mit freundlichen Gr=FC=DFen / with kind regards

Martin Peschke

IBM Deutschland Entwicklung GmbH
Linux for eServer Development
Phone: +49-(0)7031-16-2349


Douglas Gilbert <dougg@torque.net>@vger.kernel.org on 07/06/2002 04:10:=
01
AM

Please respond to Douglas Gilbert <dougg@torque.net>

Sent by:    linux-scsi-owner@vger.kernel.org


To:    tonyb@cybernetics.com
cc:    linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Subject:    Re: ide-scsi data transfer residuals



Tony Battersby wrote:
>
> Hello,
>
> I am using the scsi-generic and ide-scsi drivers together for low-lev=
el
> access to an IDE tape drive (vanilla 2.4.17).  I noticed that the dat=
a
> transfer residual in sg_io_hdr_t { int resid; } is always zero.  I as=
sume
> that the residual calculation is just a missing feature from the ide-=
scsi
> driver.  Does anyone know how hard it is to add it?

Tony,
Support for the residual count is optional. A inaccurate
survey shows these adapter drivers support it:
  advansys
  aha152x
  aic7xxx_old  (but not the newer aic7xxx)
  dc395x_trm
  scsiiom
  sym53c8xx
  sym53c8xx_2

I do not know how the ide-scsi driver would get the information.
However here is the calculation it should do:
  Scsi_Cmnd::resid =3D Scsi_Cmnd::bufflen - <actual_bytes_transferred>

Of the drivers that support "resid" most given a scatter
gather list will use the sum of the element lengths instead
of bufflen. Unfortunately that sum can be larger the bufflen
due to padding and alignment requirements of the most backward
DMA engines out there (I was burnt by the aha1542 ISA card).
IOW HBA driver writers, please use bufflen. Perhaps the CAM
name of "dxfer_len" would be clearer for this field.

Doug Gilbert
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html



-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
