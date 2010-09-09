From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: scsi_cmnd data_buffer checksum
Date: Thu, 9 Sep 2010 10:00:28 +0200
Message-ID: <20100909080028.GA4880@schmichrtp.mainz.de.ibm.com>
References: <35352.83946.qm@web32402.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.17.163]:59323 "EHLO
	mtagate3.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751474Ab0IIIAa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Sep 2010 04:00:30 -0400
Content-Disposition: inline
In-Reply-To: <35352.83946.qm@web32402.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil kumar <anils_r@yahoo.com>
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 08, 2010 at 08:36:32PM -0700, Anil kumar wrote:
> 
> I am writing a checksum calculation of scsi_cmnd data buffer in the driver. 
> 
> I calculate the checksum of the scsi_cmd data buffer(request_buffer) in driver queuecommand.
> 
> Now when the command is completed from the hardware and before driver sends it back to mid-layer, I calculate the checksum again of the same scsi_cmd data_buffer again.
> 
> Sometimes the checksums don't match. I mean somehow looks like OS changed the scsi_cmd data_buffer(request_buffer) in the meantime when driver is working on the command.
> I print the address of the scsi_cmd data_buffer (virtual address) and its same and the contents of the buffer is also same during both the calculations.
> 
> Can this happen?

Yes. While a write I/O is being processed in Linux or in flight, the
data buffers can change. This causes problems for other checksums as
well; i ran into this when looking at the DIF/DIX checksums for SCSI
commands.

At the moment, this problem can be avoided e.g. by running only direct
I/O on the xfs filesystem. There have been discussions about this, a
short summary is here, look for "stable pages":
http://lwn.net/Articles/399148/

Christof
