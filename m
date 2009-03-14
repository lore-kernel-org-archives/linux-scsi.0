From: Sam Ravnborg <sam@ravnborg.org>
Subject: Re: [PATCH 4/5] bfa: Brocade BFA FC SCSI driver (makefile)
Date: Sat, 14 Mar 2009 22:02:51 +0100
Message-ID: <20090314210251.GA3353@uranus.ravnborg.org>
References: <200903141958.n2EJwffd030299@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pfepb.post.tele.dk ([195.41.46.236]:42795 "EHLO
	pfepb.post.tele.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751242AbZCNVAy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 14 Mar 2009 17:00:54 -0400
Content-Disposition: inline
In-Reply-To: <200903141958.n2EJwffd030299@blc-10-6.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, kgudipat@brocade.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Sat, Mar 14, 2009 at 12:58:41PM -0700, Jing Huang wrote:
> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains Makefile and Kconfig file for scsi and bfa. It is created
> using 2.6.29-rc8 kernel.
> 
> Signed-off-by: Jing Huang <huangj@brocade.com>
> ---
>  Kconfig      |    9 +++++++++
>  Makefile     |    1 +
>  bfa/Makefile |   28 ++++++++++++++++++++++++++++
>  3 files changed, 38 insertions(+)
> 
> diff -urpN orig/drivers/scsi/bfa/Makefile patch/drivers/scsi/bfa/Makefile
> --- orig/drivers/scsi/bfa/Makefile	1969-12-31 16:00:00.000000000 -0800
> +++ patch/drivers/scsi/bfa/Makefile	2009-03-14 11:44:59.337712000 -0700
> @@ -0,0 +1,28 @@
> +#
> +# Copyright (c) 2005-2008 Brocade Communications Systems, Inc.
> +# All rights reserved
> +# www.brocade.com
> +# 
> +# Linux driver for Brocade Fibre Channel Host Bus Adapter.
> +#
> +# This program is free software; you can redistribute it and/or modify it
> +# under the terms of the GNU General Public License (GPL) Version 2 as
> +# published by the Free Software Foundation
> +#
> +# This program is distributed in the hope that it will be useful, but
> +# WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
> +# General Public License for more details.
> +#

No one else needs this boiler plate - please remove it.

> +obj-$(CONFIG_SCSI_BFA_FC) := bfa.o

OK

> +
> +bfa-objs := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o \
> +	    bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_diag.o \
> +	    bfa_fcdiag.o bfa_lps.o bfa_hw_cb.o bfa_hw_ct.o bfa_drv.o  \
> +            bfa_intr.o bfa_timer.o bfa_rport.o bfa_port.o bfa_uf.o \
> +            bfa_sgpg.o  bfa_module.o bfa_ioim.o bfa_itnim.o bfa_fcpim.o \
> +	    bfa_tskim.o bfa_port.o bfa_vport.o bfa_lport.o bfa_fabric.o   \
> +            bfa_auth.o  bfa_vfapi.o bfa_log.o bfa_log_module.o bfa_csdebug.o \
> +            bfa_sm.o plog.o

a) use of -objs is deprecated.
Please use:
bfa-y := bfad.o ...

b) As a style thing the following is preferred (by me at least):
bfa-y := bfad.o bfad_intr.o bfad_os.o bfad_im.o bfad_attr.o bfad_fwimg.o

# core stuff 
bfa-y += bfa_core.o bfa_ioc.o bfa_iocfc.o bfa_fcxp.o bfa_diag.o

# interrup hander
bfa-y += bfa_intr.o 

No longer any need for escaping the newline with a backslahs
And you can add descriptive comments too.

> +EXTRA_CFLAGS += -I$(obj) -I$(obj)/include

Neither of the above is needed.
If you really need to specify addtional options to gcc use:
ccflags-y := ...

	Sam
