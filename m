From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] libsas: flush initial device discovery before
 completing ->scan_finished()
Date: Fri, 18 Feb 2011 17:32:42 -0800
Message-ID: <1298079162.19161.84.camel@dwillia2-linux>
References: <20110217030633.4303.61603.stgit@localhost6.localdomain6>
	 <1298073759.3007.216.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:62523 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751374Ab1BSBLa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 18 Feb 2011 20:11:30 -0500
In-Reply-To: <1298073759.3007.216.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Jiang, Dave" <dave.jiang@intel.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, David Milburn <dmilburn@redhat.com>, "Danecki, Jacek" <jacek.danecki@intel.com>, "jack_wang@usish.com" <jack_wang@usish.com>, "lindar_liu@usish.com" <lindar_liu@usish.com>, "Skirvin, Jeffrey D" <jeffrey.d.skirvin@intel.com>, "Nadolski, Edmund" <edmund.nadolski@intel.com>, Srinivas <satyasrinivasp@hcl.in>

On Fri, 2011-02-18 at 16:02 -0800, James Bottomley wrote:
> On Wed, 2011-02-16 at 19:06 -0800, Dan Williams wrote:
> > During initial scan libsas drivers start their phys and notify libsas
> > with PORTE_BYTES_DMAED events as port links are established.  This
> > notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN events
> > to the queue.  Calling scsi_flush_work() at the end of scan_finished
> > guarantees that all preceding PORTE_BYTES_DMAED events have been
> > registered in the queue, but it does not guarantee that the resulting
> > DISCE_DISCOVER_DOMAIN events have been processed because
> > flush_workqueue() explicitly avoids live-locking with incoming work.
> > 
> > Introduce sas_flush_discovery() to guarantee that all initial discovery
> > events have completed.  It is called after the driver determines all
> > initial PORTE_BYTES_DMAED events have had a chance to enter the queue.
> > This does not cover BCNs that are generated during expander bring up,
> > only the initial sas_discover_domain() event.
> 
> I think this is a workaround for an old bug in workqueue flushing (the
> flush doesn't clean work it causes) ... I thought that's been fixed for
> ages (well, months at least) ... have you verified that this is still a
> problem?
> 

Hmm... I saw this initially on 2.6.36.

Latest git still has the "livelock" comment [1], and I was the able to
capture the following trace with two disks connected on a 2.6.38-rc5
build.  The second "sas_discover_domain" completion occurs after the
"first flush done".

# tracer: nop
#
#           TASK-PID    CPU#    TIMESTAMP  FUNCTION
#              | |       |          |         |
           <...>-5     [007]    93.849947: sas_porte_bytes_dmaed: sas_porte_bytes_dmaed: done
           <...>-5     [007]    94.444643: sas_discover_domain: sas_discover_domain: complete
           <...>-5     [007]    94.451993: sas_porte_bytes_dmaed: sas_porte_bytes_dmaed: done
           <...>-1792  [006]    94.452011: isci_host_scan_finished: isci_host_scan_finished: first flush done
           <...>-5     [007]    94.773256: sas_discover_domain: sas_discover_domain: complete
           <...>-1792  [006]    94.773270: isci_host_scan_finished: isci_host_scan_finished: second flush done

--
Dan


[1]: http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=blob;f=kernel/workqueue.c;h=11869faa;hb=HEAD#l2201

