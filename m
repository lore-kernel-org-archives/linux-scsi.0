From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC][PATCH 2/6] fnic: add fnic_scsi.c and fnic_io.h.
Date: Mon, 25 Aug 2008 13:41:20 -0500
Message-ID: <48B2FCD0.5050504@cs.wisc.edu>
References: <20080823024949.13569.94133.stgit@feynman.nuovasystems.com> <20080823025222.13569.37765.stgit@feynman.nuovasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:54855 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756557AbYHYSl3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Aug 2008 14:41:29 -0400
In-Reply-To: <20080823025222.13569.37765.stgit@feynman.nuovasystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jeykholt@cisco.com
Cc: linux-scsi@vger.kernel.org, jre@nuovasystems.com, ajoglekar@nuovasystems.com

jeykholt@cisco.com wrote:
> + * fnic_queuecommand
> + * Routine to send a scsi cdb
> + * Called with host_lock held and interrupts disabled.
> + */
> +int fnic_queuecommand(struct scsi_cmnd *sc, void (*done)(struct scsi_cmnd *))
> +{
> +	struct fc_lport *lp;
> +	struct fc_rport *rport;
> +	struct fnic_io_req *io_req;
> +	struct fnic *fnic;
> +	struct vnic_wq_copy *wq;
> +	int ret;
> +	u32 sg_count;
> +	unsigned long flags;
> +
> +	rport = starget_to_rport(scsi_target(sc->device));
> +	ret = fc_remote_port_chkready(rport);
> +	if (ret) {
> +		sc->result = ret;
> +		done(sc);
> +		return 0;
> +	}
> +
> +	lp = shost_priv(sc->device->host);
> +	if (lp->state != LPORT_ST_READY || !(lp->link_status & FC_LINK_UP)) {
> +		sc->result = DID_NO_CONNECT << 16;

You should use SCSI_MLQUEUE_HOST_BUSY here, becuase we set the link 
status/state and then will block rports, if a io has passed the rport 
check then sees the updated state we will fail it when it should be 
requeued until the fc class decides what to do.
