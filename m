From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: [PATCH] drivers/scsi/qla1280.c; was Re: Buffered I/O to block device very slow and other SCSI issues...
Date: Tue, 13 May 2008 01:58:04 -0700
Message-ID: <20080513085804.GL41683@sgi.com>
References: <20080319231654.GA103321673@sgi.com> <20080320010807.GA27620@sgi.com> <20080320032010.e640c52a.akpm@linux-foundation.org> <20080512061703.GC41683@sgi.com> <20080512171849.21d3508f.akpm@linux-foundation.org> <48294022.2070002@sgi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from netops-testserver-3-out.sgi.com ([192.48.171.28]:32983 "EHLO
	relay.sgi.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756369AbYEMI6G (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 May 2008 04:58:06 -0400
Content-Disposition: inline
In-Reply-To: <48294022.2070002@sgi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@sgi.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, dgc@sgi.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, jens.axboe@oracle.com, stable@kernel.org

On Tue, May 13, 2008 at 09:15:46AM +0200, Jes Sorensen wrote:
> Andrew Morton wrote:
> >>--- a/drivers/scsi/qla1280.c	2008-05-03 11:59:44.000000000 -0700
> >>+++ b/drivers/scsi/qla1280.c	2008-05-10 21:32:23.451341969 -0700
> >>@@ -2007,7 +2007,7 @@ qla1280_set_defaults(struct scsi_qla_hos
> >> 		nv->bus[bus].config_2.req_ack_active_negation = 1;
> >> 		nv->bus[bus].config_2.data_line_active_negation = 1;
> >> 		nv->bus[bus].selection_timeout = 250;
> >>-		nv->bus[bus].max_queue_depth = 256;
> >>+		nv->bus[bus].max_queue_depth = 32;
> >> 
> >> 		if (IS_ISP1040(ha)) {
> >> 			nv->bus[bus].bus_reset_delay = 3;
> >>@@ -2051,7 +2051,7 @@ qla1280_config_target(struct scsi_qla_ho
> >> 	status = qla1280_mailbox_command(ha, 0x0f, mb);
> >> 
> >> 	/* Save Tag queuing enable flag. */
> >>-	flag = (BIT_0 << target) & mb[0];
> >>+	flag = (BIT_0 << target);
> >> 	if (nv->bus[bus].target[target].parameter.tag_queuing)
> >> 		ha->bus_settings[bus].qtag_enables |= flag;
> >
> >Thanks.  I tagged this for a -stable backport (assuming that is
> >appropriate?)
> >
> 
> Sounds good, given the nature of this it should go into stable as well
> as current.

I agree.

> Acked-by: Jes Sorensen <jes@sgi.com>


jeremy
