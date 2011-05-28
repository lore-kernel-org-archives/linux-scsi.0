From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/4] libsas: flush initial device discovery before
 completing ->scan_finished()
Date: Fri, 27 May 2011 22:14:42 -0500
Message-ID: <1306552482.12244.23.camel@mulgrave.site>
References: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
	 <20110524201748.7351.48220.stgit@localhost6.localdomain6>
	 <BANLkTin8xQcyEiSa__+AfsV=T+NVRUwEhQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40680 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757818Ab1E1DOq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2011 23:14:46 -0400
In-Reply-To: <BANLkTin8xQcyEiSa__+AfsV=T+NVRUwEhQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, jack_wang@usish.com, lindar_liu@usish.com, linux-ide@vger.kernel.org, David Milburn <dmilburn@redhat.com>, edmund.nadolski@intel.com, Srinivas <satyasrinivasp@hcl.in>

On Fri, 2011-05-27 at 17:41 -0700, Dan Williams wrote:
> On Tue, May 24, 2011 at 1:17 PM, Dan Williams <dan.j.williams@intel.com> wrote:
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
> I notice that scsi-misc picked up all the patches from the series,
> save this one.
> 
> Oversight, or nak?

Neither ... as I've said several times before, I want to use tejun's
drain infrastructure for this.

James



