From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] Fix eh_abort race condition
Date: Wed, 25 Feb 2004 09:55:14 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040225175514.GB2938@beaverton.ibm.com>
References: <403CC931.8080309@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e32.co.us.ibm.com ([32.97.110.130]:29660 "EHLO
	e32.co.us.ibm.com") by vger.kernel.org with ESMTP id S261502AbUBYRzi
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 Feb 2004 12:55:38 -0500
Received: from westrelay01.boulder.ibm.com (westrelay01.boulder.ibm.com [9.17.195.10])
	by e32.co.us.ibm.com (8.12.10/8.12.2) with ESMTP id i1PHtZXd500616
	for <linux-scsi@vger.kernel.org>; Wed, 25 Feb 2004 12:55:35 -0500
Content-Disposition: inline
In-Reply-To: <403CC931.8080309@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

Brian King [brking@us.ibm.com] wrote:
> 
> The following patch fixes a race condition in abort processing. With this
> patch, the mid-layer can now guarantee to LLDs that it will only call
> eh_abort for ops which returned 0 in queuecommand and have not yet had 
> their ->done function called.


How does this address the race of scsi_times_out has fired and the LLD
calls scsi_done. scsi_done will return prior to setting the serial
number to 0 if the timer has fired. The LLDD will believe scsi_done
added the command to the scsi_done_q, but it did not.

-andmike
--
Michael Anderson
andmike@us.ibm.com

