From: Bjorn Helgaas <bjorn_helgaas@hp.com>
Subject: sym53c8xx_2 fix
Date: Thu, 19 Dec 2002 13:14:45 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200212191314.45778.bjorn_helgaas@hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: groudier@free.fr
Cc: linux-scsi@vger.kernel.org, gibbs@scsiguy.com

We run the sym53c8xx_2 driver on a simulator.  Because the
simulator's disk model is somewhat simplified compared to real
hardware, it exercises some code paths that are not exercised
on the hardware.

Our simulator guru found what appears to be an error in
one such path.  Here's his description and patch (against
2.4.20).  Let me know if you need more information.

Justin, I copied you because the comment immediately preceding
this code says it's part of an optimization you suggested
(negotiating for SYNC immediately after a WIDE response).

> ... There is also a bug in the driver that keeps us from
> booting.  This code path is not executed on hardware but is on the sim with
> our simple disk model.  The current driver assembles an SDTR request but
> then calls the SDTR response script.  Here is the fix:

> --- orig/linux-ia64-2.4/drivers/scsi/sym53c8xx_2/sym_hipd.c     Fri Sep 27 17:27:41 2002
> +++ fixed/linux-ia64-2.4/drivers/scsi/sym53c8xx_2/sym_hipd.c    Wed Dec 18 21:26:25 2002
> @@ -4363,7 +4363,7 @@
> 
>                         cp->nego_status = NS_SYNC;
>                         OUTB (HS_PRT, HS_NEGOTIATE);
> -                       OUTL_DSP (SCRIPTB_BA (np, sdtr_resp));
> +                       OUTL_DSP (SCRIPTB_BA (np, send_sdtr));
>                         return;
>                 }

-- 
Bjorn Helgaas - bjorn_helgaas at hp.com
Linux and Open Source Lab
Hewlett-Packard Company
