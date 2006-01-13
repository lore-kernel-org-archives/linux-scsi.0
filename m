From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 6/10] iscsi: seperate iscsi interface from setup functions
Date: Fri, 13 Jan 2006 18:17:55 +0000
Message-ID: <20060113181755.GO20718@infradead.org>
References: <1137128919.9508.39.camel@max>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:11482 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1422772AbWAMSR4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 13 Jan 2006 13:17:56 -0500
Content-Disposition: inline
In-Reply-To: <1137128919.9508.39.camel@max>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org

On Thu, Jan 12, 2006 at 11:08:39PM -0600, Mike Christie wrote:
> >From Mike Christie <michaelc@cs.wisc.edu>"
> 
> HW iscsi LLDs like qla4xxx cannot use the iscsi class becuase
> the scsi_host is tied to the interface and class code. This patch
> just seperates the session and connection creation code from
> the sysfs and netlink interface code so that HW iscsi can use
> the class.
> 
> This is also fixes a couple refcount bugs that can be triggered
> when users have a sysfs file open, close the session, then
> read or write to the file.
> 
> 
> Signed-off-by: Alex Aizman <itn780@yahoo.com>
> Signed-off-by: Dmitry Yusupov <dmitry_yus@yahoo.com>
> Signed-off-by: Mike Christie <michaelc@cs.wisc.edu>
> 
> 
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index b9d2bb8..1261a4f 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -164,6 +164,7 @@ CFLAGS_ncr53c8xx.o	:= $(ncr53c8xx-flags-
>  zalon7xx-objs	:= zalon.o ncr53c8xx.o
>  NCR_Q720_mod-objs	:= NCR_Q720.o ncr53c8xx.o
>  libata-objs	:= libata-core.o libata-scsi.o
> +scsi_transport_iscsi-objs := libiscsi.o iscsi_if.o

Please keep the interface file as scsi_transport_iscsi.c.  libiscsi should
become a separate module and/or be linked with with iscsi_tcp.ko

