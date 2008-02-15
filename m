From: Alan Stern <stern@rowland.harvard.edu>
Subject: Bad sector detection in sr.c and sd.c
Date: Fri, 15 Feb 2008 15:07:30 -0500 (EST)
Message-ID: <Pine.LNX.4.44L0.0802151459150.4668-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:50895 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754279AbYBOUHe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Feb 2008 15:07:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

James:

With regard to your commit 366c246de9cec909c5eba4f784c92d1e75b4dc38
(sd: handle bad lba in sense information)...

Shouldn't analogous changes be made in sr_done()?  The code there looks 
rather old and somewhat bogus.  It doesn't need to be quite as careful 
as the code in sd_done() because you can assume that sr.c will never 
handle devices with more than 2 billion sectors (an assumption already 
present in sr_prep_fn()).

Also, do you have any objection to a patch for sd_done() which would
use the scsi_cmnd's residue if bad_lba is outside the interval from
start_lba to end_lba?

Alan Stern

