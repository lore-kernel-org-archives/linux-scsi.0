From: James Bottomley <James.Bottomley@suse.de>
Subject: Re: [PATCH] libsas: flush initial device discovery before
 completing ->scan_finished()
Date: Fri, 18 Feb 2011 18:02:39 -0600
Message-ID: <1298073759.3007.216.camel@mulgrave.site>
References: <20110217030633.4303.61603.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor.suse.de ([195.135.220.2]:33300 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758679Ab1BSACw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2011 19:02:52 -0500
In-Reply-To: <20110217030633.4303.61603.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, David Milburn <dmilburn@redhat.com>, jacek.danecki@intel.com, jack_wang@usish.com, lindar_liu@usish.com, jeffrey.d.skirvin@intel.com, edmund.nadolski@intel.com, Srinivas <satyasrinivasp@hcl.in>

On Wed, 2011-02-16 at 19:06 -0800, Dan Williams wrote:
> During initial scan libsas drivers start their phys and notify libsas
> with PORTE_BYTES_DMAED events as port links are established.  This
> notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN events
> to the queue.  Calling scsi_flush_work() at the end of scan_finished
> guarantees that all preceding PORTE_BYTES_DMAED events have been
> registered in the queue, but it does not guarantee that the resulting
> DISCE_DISCOVER_DOMAIN events have been processed because
> flush_workqueue() explicitly avoids live-locking with incoming work.
> 
> Introduce sas_flush_discovery() to guarantee that all initial discovery
> events have completed.  It is called after the driver determines all
> initial PORTE_BYTES_DMAED events have had a chance to enter the queue.
> This does not cover BCNs that are generated during expander bring up,
> only the initial sas_discover_domain() event.

I think this is a workaround for an old bug in workqueue flushing (the
flush doesn't clean work it causes) ... I thought that's been fixed for
ages (well, months at least) ... have you verified that this is still a
problem?

James


