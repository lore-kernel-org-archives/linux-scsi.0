From: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 1/14] bfa: Brocade BFA FC SCSI driver (bfad)
Date: Wed, 2 Sep 2009 12:41:35 -0700
Message-ID: <20090902124135.aa55f0be.akpm@linux-foundation.org>
References: <200908280754.n7S7sUMB030191@blc-10-6.brocade.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:52431 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752442AbZIBTmD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Sep 2009 15:42:03 -0400
In-Reply-To: <200908280754.n7S7sUMB030191@blc-10-6.brocade.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jing Huang <huangj@brocade.com>
Cc: James.Bottomley@HansenPartnership.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, rvadivel@brocade.com, vravindr@brocade.com

On Fri, 28 Aug 2009 00:54:30 -0700
Jing Huang <huangj@brocade.com> wrote:

> From: Jing Huang <huangj@brocade.com>
> 
> This patch contains code that interfaces to upper layer linux kernel, such as
> PCI, SCSI mid-layer and sysfs etc.
> 

These patches seem to have been posted a lot of times.  Is anyone
paying attention?

> +BFA_TRC_FILE(LDRV, BFAD);
> +
> +static DEFINE_MUTEX(bfad_mutex);
> +int bfad_scan_done;
> +
> +LIST_HEAD(bfad_list);
> +
> +static int      bfad_inst;
> +int             supported_fc4s;
> +
> +char           *host_name;
> +char           *os_name;
> +char           *os_patch;
> +int             num_rports;
> +int             num_ios;
> +int             num_tms;
> +int             num_fcxps;
> +int             num_ufbufs;
> +int             reqq_size;
> +int             rspq_size;
> +int             num_sgpgs;
> +int             rport_del_timeout = BFA_FCS_RPORT_DEF_DEL_TIMEOUT;
> +int             bfa_lun_queue_depth = BFAD_LUN_QUEUE_DEPTH;
> +int             bfa_io_max_sge = BFAD_IO_MAX_SGE;
> +int             log_level = BFA_LOG_WARNING;
> +int             ioc_auto_recover = BFA_TRUE;
> +int             ipfc_enable = BFA_FALSE;
> +int             ipfc_mtu = -1;
> +int             linkup_delay = -1;

eek.  These are all kernel-wide global symbols and many of them are
very inappropriately named.  They should either be made static or given
a subsystem-specific prefix such as "bfad_".


