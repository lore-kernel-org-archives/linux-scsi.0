From: Brian King <brking@us.ibm.com>
Subject: Re: How to make sd retry a command?
Date: Fri, 22 Sep 2006 16:34:48 -0500
Message-ID: <451456F8.2000800@us.ibm.com>
References: <Pine.LNX.4.44L0.0609221711240.8511-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.152]:2281 "EHLO e34.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S932194AbWIVVey (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Sep 2006 17:34:54 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e34.co.us.ibm.com (8.13.8/8.12.11) with ESMTP id k8MLYswK028438
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 17:34:54 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by d03relay04.boulder.ibm.com (8.13.6/8.13.6/NCO v8.1.1) with ESMTP id k8MLYr2C245084
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 15:34:53 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id k8MLYr3Y011928
	for <linux-scsi@vger.kernel.org>; Fri, 22 Sep 2006 15:34:53 -0600
In-Reply-To: <Pine.LNX.4.44L0.0609221711240.8511-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> I've seen a few examples of USB storage devices that return clearly bogus 
> error information on occasion.  For instance, the device might return 
> CHECK CONDITION status with SK=5 (Illegal request) and ASC=20 (Invalid 
> command) for a WRITE_10, even though it has accepted many other READ_10 
> and WRITE_10 commands previously.  I don't know why the device does this.
> 
> When this happens, rather than failing the transfer entirely it makes 
> sense to retry it.  Right now sd will switch over from WRITE_10 to 
> WRITE_6, which is definitely the wrong thing to do.  I can prevent that 
> easily enough.  The question is how to force a retry.
> 
> What information should sd_rw_intr() pass to scsi_io_completion() to
> request a retry?  Or is there some other way of doing it?
> 
> And how can the number of retries be limited, say to 3?

scsi_decide_disposition in scsi_error.c is what controls whether or not
a failed command gets retried. If you know that you might want a failed
command retried, you can set DID_ERROR, which may force a retry,
depending on if the retry counter has been exceeded yet or not.

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
