From: Alan Stern <stern@rowland.harvard.edu>
Subject: Add time delay in sd_spinup_disk() and get_capabilities()
Date: Tue, 29 Jun 2004 16:55:23 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0406291621060.6286-100000@ida.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:27652 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S266025AbUF2UzY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jun 2004 16:55:24 -0400
List-Id: linux-scsi@vger.kernel.org
To: SCSI development list <linux-scsi@vger.kernel.org>

I've seen a few USB mass-storage devices that take a few seconds to 
initialize when they are first plugged in to the computer.  During that 
warm-up period they respond to TEST UNIT READY with either

	SK=2 (Not ready);  ASC,ASCQ=4,1 (Logical unit in process of
	becoming ready)

or

	SK=2;  ASC=3a (Medium not present)

The sd_spinup_disk() routine in sd.c and the get_capabilities() routine in
sr.c both retry the TUR, up to 3 and 5 times respectively (why not the
same number for both drivers?).  But only when SK=6 (Unit Attention), and
they don't insert a time delay between retries.

I should think that the "in process of becoming ready" response calls for 
some extra time, and maybe it's not such a big stretch for "medium not 
present" as well.

Is there any reason not to add a delay, on the order of 1 second, between 
retries and to allow retries when either of the two responses above is 
received?  And to allow up to 5 retries in sd_spinup_disk()?

Alan Stern


