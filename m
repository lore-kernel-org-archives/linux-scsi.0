From: Andreas Herrmann <aherrman@de.ibm.com>
Subject: Re: [dm-devel] Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 23:33:57 +0200
Message-ID: <OF8721F851.2661040F-ONC1256FEA.0076595E-C1256FEA.00768C46@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate4.de.ibm.com ([195.212.29.153]:43441 "EHLO
	mtagate4.de.ibm.com") by vger.kernel.org with ESMTP id S261157AbVDUVeA
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 17:34:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Lars Marowsky-Bree <lmb@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, Linux SCSI <linux-scsi@vger.kernel.org>, linux-scsi-owner@vger.kernel.org

        Lars Marowsky-Bree <lmb@suse.de>
        21.04.2005 21:54
 
> On 2005-04-21T09:42:05, Patrick Mansfield <patmans@us.ibm.com> wrote:

> > On Tue, Apr 19, 2005 at 07:19:53PM +0200, Andreas Herrmann wrote:

  <snip>

> > 
> > We need a patch like Mike Christie had, this:
> > 
> > http://marc.theaimsgroup.com/?l=linux-kernel&m=107961883914541&w=2
> > 
> > The scsi core should decode the sense data and pass up the result, 
then dm
> > need not decode sense data, and we don't need sense data passed around 
via
> > the block layer.

> The most recent udm patchset has a patch by Jens Axboe and myself to
> pass up sense data / error codes in the bio so the dm mpath module can
> deal with it. 

> Only issue still is that the SCSI midlayer does only generate a single
> "EIO" code also for timeouts; however, that pretty much means it's a
> transport error, because if it was a media error, we'd be getting sense
> data ;-)

Well, there are various situations when all paths to the ESS are
"temporarily unavailable". In some cases TASK_SET_FULL/BUSY is
reported as it should be. In other cases we just encounter data
underruns or exchange sequences are aborted and finally it might be
that requests just time out. BTW, it is not only ESS where I have seen
such (broken) behaviour.

> Together with the "queue_if_no_path" feature flag for dm-mpath that
> should do what you need to handle this (arguably broken) array
> behaviour: It'll queue until the error goes away and multipathd retests
> and reactivates the paths. That ought to work, but given that I don't
> have an IBM ESS accessible, please confirm that.

Sounds good. Will make some tests using the "queue_if_no_path" feature.

> It is possible that to fully support them a dm mpath hardware handler
> (like for the EMC CX family) might be required, too.

For the time being I hope "queue_if_no_path" feature is sufficient
to succesfully pass our tests ;-)

> (For easier testing, you'll find that all this functionality is
> available in the latest SLES9 SP2 betas, to which you ought to have
> access at IBM, and the kernels are also available via
> ftp://ftp.suse.com/pub/projects/kernel/kotd/.)

> > scsi core could be changed to handle device specific decoding via 
sense
> > tables that can be modified via sysfs, similar to devinfo code (well,
> > devinfo still lacks a sysfs interface).

> dm-path's capabilities go a bit beyond just the error decoding (which
> for generic devices is also provided for in a generic
> dm_scsi_err_handler()); for example you can code special initialization
> commands and behaviour an array might need.

> Maybe this could indeed be abstracted further to download the command
> and/or specific decoding tables from user-space via sysfs or configfs by
> a generic user-space customizable dm-hw-handler-generic.[ch] plugin; I
> think patches are being accepted ;-)

Thanks for the information.


Regards,

Andreas

