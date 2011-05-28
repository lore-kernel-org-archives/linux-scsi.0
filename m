From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 1/4] libsas: flush initial device discovery before
 completing ->scan_finished()
Date: Fri, 27 May 2011 17:41:24 -0700
Message-ID: <BANLkTin8xQcyEiSa__+AfsV=T+NVRUwEhQ@mail.gmail.com>
References: <20110524201708.7351.76421.stgit@localhost6.localdomain6>
	<20110524201748.7351.48220.stgit@localhost6.localdomain6>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:56255 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552Ab1E1Al0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 May 2011 20:41:26 -0400
In-Reply-To: <20110524201748.7351.48220.stgit@localhost6.localdomain6>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: james.bottomley@hansenpartnership.com
Cc: dave.jiang@intel.com, linux-scsi@vger.kernel.org, jeffrey.d.skirvin@intel.com, jacek.danecki@intel.com, jack_wang@usish.com, lindar_liu@usish.com, linux-ide@vger.kernel.org, David Milburn <dmilburn@redhat.com>, edmund.nadolski@intel.com, Srinivas <satyasrinivasp@hcl.in>

On Tue, May 24, 2011 at 1:17 PM, Dan Williams <dan.j.williams@intel.com=
> wrote:
> During initial scan libsas drivers start their phys and notify libsas
> with PORTE_BYTES_DMAED events as port links are established. =A0This
> notification in turn causes libsas to post DISCE_DISCOVER_DOMAIN even=
ts
> to the queue. =A0Calling scsi_flush_work() at the end of scan_finishe=
d
> guarantees that all preceding PORTE_BYTES_DMAED events have been
> registered in the queue, but it does not guarantee that the resulting
> DISCE_DISCOVER_DOMAIN events have been processed because
> flush_workqueue() explicitly avoids live-locking with incoming work.
>
> Introduce sas_flush_discovery() to guarantee that all initial discove=
ry
> events have completed. =A0It is called after the driver determines al=
l
> initial PORTE_BYTES_DMAED events have had a chance to enter the queue=
=2E
> This does not cover BCNs that are generated during expander bring up,
> only the initial sas_discover_domain() event.

I notice that scsi-misc picked up all the patches from the series,
save this one.

Oversight, or nak?

Note that latest upstream still says the following for flush_workqueue(=
):

 * We sleep until all works which were queued on entry have been handle=
d,
 * but we are not livelocked by new incoming ones.

=2E..so isci will continue to open code this double flush.

--
Dan
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
