From: Jeremy Higdon <jeremy@sgi.com>
Subject: Re: PATCH [2/5]  qla2xxx: add remote port codes...
Date: Thu, 19 May 2005 23:17:37 -0700
Message-ID: <20050520061736.GA11551@sgi.com>
References: <20050413191548.GI9703@plap.qlogic.org> <20050413191824.GK9703@plap.qlogic.org> <20050413214023.GA18161@infradead.org> <20050419072751.GD5999@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from omx3-ext.sgi.com ([192.48.171.20]:10694 "EHLO omx3.sgi.com")
	by vger.kernel.org with ESMTP id S261359AbVETGRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 May 2005 02:17:53 -0400
Content-Disposition: inline
In-Reply-To: <20050419072751.GD5999@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: andrew.vasquez@qlogic.com, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, Apr 19, 2005 at 12:27:51AM -0700, Andrew Vasquez wrote:
> On Wed, 13 Apr 2005, Christoph Hellwig wrote:
> 
> > >  	atomic_set(&fcport->state, FCS_ONLINE);
> > > +	if (ha->flags.init_done)
> > > +		qla2x00_reg_remote_port(ha, fcport);
> > >  }
> > 
> > ...
> > 
> > > -		goto probe_failed;
> > > +		goto probe_alloc_failed;
> > >  	}
> > >  
> > > +	pci_set_drvdata(pdev, ha);
> > > +	host->this_id = 255;
> > > +	host->cmd_per_lun = 3;
> > > +	host->unique_id = ha->instance;
> > > +	host->max_cmd_len = MAX_CMDSZ;
> > > +	host->max_channel = ha->ports - 1;
> > > +	host->max_id = ha->max_targets;
> > > +	host->max_lun = ha->max_luns;
> > > +	host->transportt = qla2xxx_transport_template;
> > > +	if (scsi_add_host(host, &pdev->dev))
> > > +		goto probe_alloc_failed;
> > > +
> > > +	qla2x00_alloc_sysfs_attr(ha);
> > > +
> > >  	if (qla2x00_initialize_adapter(ha) &&
> > >  	    !(ha->device_flags & DFLG_NO_CABLE)) {
> > 
> > Now this I don't undersant.  You're moving the host registration earlier,
> > maybe too earlier but I haven't checked that yet,
> >
> 
> Yeah, that hunk is a residual of some other (trashy) changes I made
> during early fc_rport integration and really should be reverted back
> to the original...

In fact, it seems to break probing for luns other than zero.

You initialize ha->max_luns in qla2x00_nvram_config(), which is called form
qla2x00_initialize_adapter().  So we're currently seeing messages like
this during ISP2312 initialization:

<4>scsi: host 1 channel 0 id 0 lun1 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun2 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun3 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun4 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun5 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun6 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun7 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun8 has a LUN larger than allowed by the host adapter
<4>scsi: host 1 channel 0 id 0 lun9 has a LUN larger than allowed by the host adapter

jeremy
