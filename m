From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH 3/12]  qla2xxx: Collapse ISP2xxx queuecommand implementations.
Date: Fri, 14 Oct 2005 15:43:48 -0700
Message-ID: <20051014224348.GC28524@plap.qlogic.org>
References: <20051013231534.27191.19815.sendpatchset@plap.qlogic.com> <20051013231604.27191.9981.sendpatchset@plap.qlogic.com> <20051014102434.GA23600@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:21326 "EHLO avexch01.qlogic.com")
	by vger.kernel.org with ESMTP id S1750995AbVJNWnt (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Oct 2005 18:43:49 -0400
Content-Disposition: inline
In-Reply-To: <20051014102434.GA23600@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 14 Oct 2005, Christoph Hellwig wrote:

> On Thu, Oct 13, 2005 at 04:16:04PM -0700, Andrew Vasquez wrote:
> > Signed-off-by: Andrew Vasquez <andrew.vasquez@qlogic.com>
> 
> I don't like this at all.  Even the first variant with the indirect
> function call seems better than this.

The indirect function call is still there -- the resultant code hasn't
changed with this patch.  This patch simply insures that common
queueing code gets updated in one spot rather than two
(qla2x00_queuecommand() qla24xx_queuecommand()).  The *only*
difference between the two was the call to
[qla2x00|qla24xx]_start_scsi().  So, beyond style, are there any other
objections.

> > +#define QLA_QUEUE_COMMAND(isp)  \
> > +static int \
> > +isp##_queuecommand(struct scsi_cmnd *cmd, void (*done)(struct scsi_cmnd *)) \
> > +{ \
> > +	scsi_qla_host_t *ha = to_qla_host(cmd->device->host); \
> > +	fc_port_t *fcport = (struct fc_port *) cmd->device->hostdata; \
> > +	srb_t *sp; \
> > +	int rval; \
> > +	if (!fcport) { \
> > +		cmd->result = DID_NO_CONNECT << 16; \
> > +		goto fail_command; \
> > +	} \
> 
> While we're at it, I don't think cmd->device->hostdata could ever be
> NULL.

Yes, with the target_parent checks in scsi_alloc_target():

        if (shost->transportt->target_parent) {
                spin_lock_irqsave(shost->host_lock, flags);
                parent = shost->transportt->target_parent(shost, channel, id);
                spin_unlock_irqrestore(shost->host_lock, flags);
                if (!parent)
                        return NULL;
        }

you are correct.  Yet another reason to collapse both -- change the
code in one place.

-- 
Andrew Vasquez
