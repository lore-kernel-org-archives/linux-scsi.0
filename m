From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: [patch 2/2] zfcp: Add FC pass-through support
Date: Wed, 8 Apr 2009 13:38:48 +0200
Message-ID: <20090408113847.GA12089@schmichrtp.de.ibm.com>
References: <20090406163145.686874000@de.ibm.com> <20090406163534.659628000@de.ibm.com> <20090408132945.6c847b74@osiris.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.de.ibm.com ([195.212.29.157]:44068 "EHLO
	mtagate8.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764895AbZDHLjW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 07:39:22 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate8.de.ibm.com (8.14.3/8.13.8) with ESMTP id n38Bcnkv664856
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 11:38:49 GMT
Received: from d12av04.megacenter.de.ibm.com (d12av04.megacenter.de.ibm.com [9.149.165.229])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n38Bcm8m3502126
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 13:38:48 +0200
Received: from d12av04.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av04.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n38Bcm9H011759
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 13:38:48 +0200
Content-Disposition: inline
In-Reply-To: <20090408132945.6c847b74@osiris.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: linux-scsi@vger.kernel.org, Sven Schuetz <sven@linux.vnet.ibm.com>, James.Smart@Emulex.Com

On Wed, Apr 08, 2009 at 01:29:45PM +0200, Heiko Carstens wrote:
> On Mon, 06 Apr 2009 18:31:47 +0200
> Christof Schmitt <christof.schmitt@de.ibm.com> wrote:
> > +	els_fc_job->els.adapter = adapter;
> > +	if (rport) {
> > +		read_lock_irq(&zfcp_data.config_lock);
> > +		port = rport->dd_data;
> > +		if (port)
> > +			zfcp_port_get(port);
> > +		read_unlock_irq(&zfcp_data.config_lock);
> > +		if (!port) {
> > +			kfree(els_fc_job);
> > +			return -EINVAL;
> > +		}
> > +		els_fc_job->els.port = port;
> > +		els_fc_job->els.d_id = port->d_id;
> > +		zfcp_port_put(port);
> > +	} else {
> 
> This piece looks a bit strange. Why is the reference count of the port
> increased and afterwards decreased again? Still the pointer to the port
> gets added to els_fc_job->els.port and therefore the structure will be
> accessed later.
> 
> So either the reference count is decreased too early and this is a bug
> or it's not needed at all.

Only the d_id is needed from the port, after this we don't access the
port anymore. The assignment of the pointer to els.port is not
required. We might do without the reference count and try to get the
d_id while holding the config_lock.

Christof
