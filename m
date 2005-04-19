From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Tue, 19 Apr 2005 00:27:51 -0700
Message-ID: <20050419072751.GD5999@plap.qlogic.org>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch02.qlogic.com ([198.70.193.200]:6054 "EHLO
	avexch01.qlogic.com") by vger.kernel.org with ESMTP id S261368AbVDSH1w
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 19 Apr 2005 03:27:52 -0400
Content-Disposition: inline
In-Reply-To: <20050413214023.GA18161@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@SteelEye.com>

On Wed, 13 Apr 2005, Christoph Hellwig wrote:

> >  	atomic_set(&fcport->state, FCS_ONLINE);
> > +	if (ha->flags.init_done)
> > +		qla2x00_reg_remote_port(ha, fcport);
> >  }
> 
> ...
> 
> > -		goto probe_failed;
> > +		goto probe_alloc_failed;
> >  	}
> >  
> > +	pci_set_drvdata(pdev, ha);
> > +	host->this_id = 255;
> > +	host->cmd_per_lun = 3;
> > +	host->unique_id = ha->instance;
> > +	host->max_cmd_len = MAX_CMDSZ;
> > +	host->max_channel = ha->ports - 1;
> > +	host->max_id = ha->max_targets;
> > +	host->max_lun = ha->max_luns;
> > +	host->transportt = qla2xxx_transport_template;
> > +	if (scsi_add_host(host, &pdev->dev))
> > +		goto probe_alloc_failed;
> > +
> > +	qla2x00_alloc_sysfs_attr(ha);
> > +
> >  	if (qla2x00_initialize_adapter(ha) &&
> >  	    !(ha->device_flags & DFLG_NO_CABLE)) {
> 
> Now this I don't undersant.  You're moving the host registration earlier,
> maybe too earlier but I haven't checked that yet,
>

Yeah, that hunk is a residual of some other (trashy) changes I made
during early fc_rport integration and really should be reverted back
to the original...

> why do you still need
> the special case for delaying registration of the targets?
> 

Ok, this is actually a concern I have with the current fc_rport
implementation (and yes, I realize I'm a day late) -- the auto-scan
logic employed during the creation of the fc_rport (via
fc_remote_port_add()).

Before I get into that though, let me answer your question -- the
reason I post-register the ports is because the driver is not ready
(during init-time) to process I/O originating from queuecommand().

This topic was discussed briefly during the implementation of
fc_rport -- some suggestions, if I recall correctly, were to either
block the host or post-register the rport at an appropriate time.
Each options has its caveats -- issuing and fc_remote_port_add() while
the host is blocked of course forces the user to perform a manual
rescan at some later time.  Post-registration on the otherhand still
requires some 'external' port structure (fc_port in the case of
qla2xxx) to exist until fc_rport creation and thus negating the
benefits and purpose of fc_rport->dd_data.  And again, since scanning
occurs immediately for 'target-type' (roles) fc_rports, the
fc_rport->dd_data which one would like to use at slave_alloc() time is
unset (NULL).

Perhaps I'm missing something fundamental -- as I've glanced through
lpfc and see slave_alloc() doing linear scans through its known lists
of ports trying to determine the proper lpfc_nodelist, whereas a:

	rport = fc_remote_port_add() -- would create and fc_rport
					given the rport_identifiers.

	rport->dd_data = <internal port data> -- caller populates
						 rport->dd_data with
						 internal driver
						 structure  (i.e. fc_port)

	fc_remote_port_scan(rport) -- initiate scan.

	  qla2xxx_slave_alloc() implementation would be something like:

		struct fc_rport *rport = starget_to_rport(scsi_target(sdev));
		fc_port_t *fcport;

		if (!rport)
			return -ENXIO;
		fcport = (struct fc_port *) rport->dd_data;
		if (!fcport)
			return -ENXIO;
		...

One possibility (as to not break current functionality) is to add an
addition role modifier, say FC_RPORT_ROLE_NO_SCAN and | it into
rport_ids.roles prior to fc_remote_port_add() to indicate no scanning
should take place during the call.  Then once ready, the driver could
issue the corresponding fc_remote_port_scan() on the rport.

Looking ahead, this may also be useful in the case of port
authentication (i.e. FC-SP).

Does this sound like a reasonable extension?  I'll code up something
in the morning if others are interested?

> Also please propagate the full error that scsi_add_host returned.
> 

Sure, I post another set of patches to address this and the early
host-addition code.

Thanks,
AV
