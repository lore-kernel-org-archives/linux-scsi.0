From: Douglas Gilbert <dougg@torque.net>
Subject: Re: ide-scsi data transfer residuals
Date: Fri, 05 Jul 2002 22:10:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <ag5ji3$s5q$2@main.gmane.org>
References: <000301c2242d$596450f0$e0019d89@cybernetics.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: tonyb@cybernetics.com
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

Tony Battersby wrote:
> 
> Hello,
> 
> I am using the scsi-generic and ide-scsi drivers together for low-level
> access to an IDE tape drive (vanilla 2.4.17).  I noticed that the data
> transfer residual in sg_io_hdr_t { int resid; } is always zero.  I assume
> that the residual calculation is just a missing feature from the ide-scsi
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
  Scsi_Cmnd::resid = Scsi_Cmnd::bufflen - <actual_bytes_transferred>

Of the drivers that support "resid" most given a scatter
gather list will use the sum of the element lengths instead
of bufflen. Unfortunately that sum can be larger the bufflen 
due to padding and alignment requirements of the most backward
DMA engines out there (I was burnt by the aha1542 ISA card).
IOW HBA driver writers, please use bufflen. Perhaps the CAM
name of "dxfer_len" would be clearer for this field.

Doug Gilbert
