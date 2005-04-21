From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: fastfail operation and retries
Date: Thu, 21 Apr 2005 09:42:05 -0700
Message-ID: <20050421164205.GA20482@us.ibm.com>
References: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e3.ny.us.ibm.com ([32.97.182.143]:218 "EHLO e3.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261534AbVDUQmS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 21 Apr 2005 12:42:18 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e3.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j3LGgHEd029212
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 12:42:17 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j3LGgHax092762
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 12:42:17 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j3LGgH8P015102
	for <linux-scsi@vger.kernel.org>; Thu, 21 Apr 2005 11:42:17 -0500
Content-Disposition: inline
In-Reply-To: <20050419171953.GA8444@lion28.boeblingen.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andreas Herrmann <aherrman@de.ibm.com>
Cc: Linux SCSI <linux-scsi@vger.kernel.org>, dm-devel@redhat.com

On Tue, Apr 19, 2005 at 07:19:53PM +0200, Andreas Herrmann wrote:
> Hi,
> 
> I have question(s) regarding the fastfail operation of the SCSI stack.
> 
> Performing multipath-tests with an IBM ESS I encountered problems.
> During certain operations on an ESS (quiesce/resume and such) requests
> on all paths fail temporarily with an data underrun (resid is set in
> the FCP-response).  In another situation abort sequences happen (see
> FC-FS).
> 
> In both cases it is not a path failure but the device (ESS) reports
> error conditions temporarily (some seconds).
> 
> Now on error on the first path the multipath layer initiates failover
> to other available path(s) where requests will immediately fail.
> 
> Using linux-2.4 and LVM such problems did not occure. There were
> enough retries (5 for each path) to handle such situations.
> 
> Now if the FASTFAIL flag is set the SCSI stack prevents retries for
> failed SCSI commands.
> 
> Problem is that the multipath layer cannot distinguish between path
> and device failures (and won't do any retries for the failed request
> on the same path anyway).
> 
> How can an lld force the SCSI stack to retry a failed scsi-command
> (without using DID_REQUEUE or DID_IMM_RETRY, which both do not change
> the retry counter).
> 
> What about a DID_FORCE_RETRY ?  Or is there any outlook when there
> will be a better interface between the SCSI stack and the multipath
> layer to properly handle retries.

We need a patch like Mike Christie had, this:

http://marc.theaimsgroup.com/?l=linux-kernel&m=107961883914541&w=2

The scsi core should decode the sense data and pass up the result, then dm
need not decode sense data, and we don't need sense data passed around via
the block layer.

scsi core could be changed to handle device specific decoding via sense
tables that can be modified via sysfs, similar to devinfo code (well,
devinfo still lacks a sysfs interface).

For ESS, you probably also need the BLIST_RETRY_HWERROR that is in
current 2.6.12 rc.

-- Patrick Mansfield
