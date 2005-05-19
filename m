From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Connection to SAN times out after a few days
Date: Thu, 19 May 2005 12:39:40 -0700
Message-ID: <20050519193940.GA12400@us.ibm.com>
References: <a728f9f90505191226655f26a1@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:15337 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261232AbVESTkB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 19 May 2005 15:40:01 -0400
Received: from d01relay02.pok.ibm.com (d01relay02.pok.ibm.com [9.56.227.234])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j4JJe1KU008876
	for <linux-scsi@vger.kernel.org>; Thu, 19 May 2005 15:40:01 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay02.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j4JJe1x6146640
	for <linux-scsi@vger.kernel.org>; Thu, 19 May 2005 15:40:01 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.13.3) with ESMTP id j4JJe0Ht015805
	for <linux-scsi@vger.kernel.org>; Thu, 19 May 2005 15:40:00 -0400
Content-Disposition: inline
In-Reply-To: <a728f9f90505191226655f26a1@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alex Deucher <alexdeucher@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Thu, May 19, 2005 at 03:26:11PM -0400, Alex Deucher wrote:
> I have Nexsan ATAbeast SAN connected to an AMD64 (sun v20z) and
> SPARC64 (sun 220R) server using lpfc HBAs (using the in kernel lpfc
> driver, kernel 2.6.12-rc4).  About once every 4-5 days, the server
> loses its connection to the SAN and I get these messages in my log:
> May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
> May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
> May 19 09:01:08 nutcracker scsi1 (0:0): rejecting I/O to offline device
> May 19 09:01:08 nutcracker metapage_read_end_io: I/O error
> May 19 09:01:08 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt
> May 19 09:01:09 nutcracker scsi1 (0:0): rejecting I/O to offline device
> May 19 09:01:09 nutcracker metapage_read_end_io: I/O error
> May 19 09:01:09 nutcracker ERROR: (device dm-4): DT_GETPAGE: dtree page corrupt
> 
> Nothing unusual shows up in the SAN logs.  I've already adjusted the
> cache flushing on the SAN and changed the scsi timeouts to 45 seconds.
>  I asked emulex about it, but I'm wondering if this is something in
> the scsi layer.  Has anyone else had similar problems or know what the
> problem may be?

Yes, could be a timeout, but the device would not go offline unless we
could not talk to it at all after the timeout (TUR failed, or of course
some bug).

There should be earlier errors about the device being offline, look for
and post those.
