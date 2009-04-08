From: Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: Re: [patch 2/2] zfcp: Add FC pass-through support
Date: Wed, 8 Apr 2009 13:29:45 +0200
Message-ID: <20090408132945.6c847b74@osiris.boeblingen.de.ibm.com>
References: <20090406163145.686874000@de.ibm.com>
	<20090406163534.659628000@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([194.196.100.161]:34282 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1764593AbZDHL3u (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Apr 2009 07:29:50 -0400
Received: from d06nrmr1407.portsmouth.uk.ibm.com (d06nrmr1407.portsmouth.uk.ibm.com [9.149.38.185])
	by mtagate1.uk.ibm.com (8.13.1/8.13.1) with ESMTP id n38BTliY023820
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 11:29:47 GMT
Received: from d06av01.portsmouth.uk.ibm.com (d06av01.portsmouth.uk.ibm.com [9.149.37.212])
	by d06nrmr1407.portsmouth.uk.ibm.com (8.13.8/8.13.8/NCO v9.2) with ESMTP id n38BTlcc3068020
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 12:29:47 +0100
Received: from d06av01.portsmouth.uk.ibm.com (loopback [127.0.0.1])
	by d06av01.portsmouth.uk.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n38BTlFZ009101
	for <linux-scsi@vger.kernel.org>; Wed, 8 Apr 2009 12:29:47 +0100
In-Reply-To: <20090406163534.659628000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, Sven Schuetz <sven@linux.vnet.ibm.com>, James.Smart@Emulex.Com, Christof Schmitt <christof.schmitt@de.ibm.com>

On Mon, 06 Apr 2009 18:31:47 +0200
Christof Schmitt <christof.schmitt@de.ibm.com> wrote:
> +	els_fc_job->els.adapter = adapter;
> +	if (rport) {
> +		read_lock_irq(&zfcp_data.config_lock);
> +		port = rport->dd_data;
> +		if (port)
> +			zfcp_port_get(port);
> +		read_unlock_irq(&zfcp_data.config_lock);
> +		if (!port) {
> +			kfree(els_fc_job);
> +			return -EINVAL;
> +		}
> +		els_fc_job->els.port = port;
> +		els_fc_job->els.d_id = port->d_id;
> +		zfcp_port_put(port);
> +	} else {

This piece looks a bit strange. Why is the reference count of the port
increased and afterwards decreased again? Still the pointer to the port
gets added to els_fc_job->els.port and therefore the structure will be
accessed later.

So either the reference count is decreased too early and this is a bug
or it's not needed at all.
