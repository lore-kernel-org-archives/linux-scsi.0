From: malahal@us.ibm.com
Subject: AIC94XX discovery timeout problem details...
Date: Fri, 15 Sep 2006 00:20:30 -0700
Message-ID: <20060915072030.GA25595@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:24966 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750974AbWIOHUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Sep 2006 03:20:33 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8F7KWko006713
	for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 03:20:32 -0400
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8F7KWGT291030
	for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 03:20:32 -0400
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8F7KWLu002796
	for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 03:20:32 -0400
Received: from malahal.beaverton.ibm.com (malahal.beaverton.ibm.com [9.47.17.93])
	by d01av04.pok.ibm.com (8.12.11.20060308/8.12.11) with ESMTP id k8F7KW6g002793
	for <linux-scsi@vger.kernel.org>; Fri, 15 Sep 2006 03:20:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I chased the time out problem and found that the PORTE_BYTES_DMAED port
event must be responded with a call to lldd_port_formed() which will
update PHY_IS_UP and port-links fields in DDB 0. As there is a single
thread handling PHY/port events as well as discovery, we really can't
handle PORTE_BYTES_DMAED event until the discovery is complete. This
results in SCSI commands timing out in the discovery thread no matter
what I do!  This problem may be unique to Vitesse expander, read the PS
section for details.

Tried using two threads, one for events and the other for discovery.
That avoided the timeout problems, but the discovery thread would die
after few iterations due to the event thread and the discovery thread
racing each other for setting up and tearing down of sysfs objects.

I tried calling lldd_port_formed() with appropriate phy_mask from the
notify_port_event() itself. That worked fine. It is just a hack for now!

Any comments, suggestions?

Thanks, Malahal.
PS: I instrumented the code to use only a single PHY out of 4-phy wide
port by prematurely returning from sas_form_port() for all PHYs except
one. In other words, I ignored the PORTE_BYTES_DMAED event for all PHYs
but one.  There were SCSI timeouts every time I did that except if the
PHY I was using is phy3.  When I swapped cables, the PHY that worked
changed too. I believe, it goes with a specific Vitesse expander PHY. Is
it possible that the Vitesse expander uses a specific PHY to respond to
some SCSI requests even though the adapter uses a different PHY while
sending the request?  Is this behavior of communicating on two different
PHYs for a single SCSI command is allowed in the spec? Also note that
the discovery commands (SMP) just work fine.
