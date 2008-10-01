From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH 1/3] SCSI: rearrange code in scsi_io_completion
Date: Wed, 01 Oct 2008 16:08:37 +0200
Message-ID: <48E38465.1070101@interlog.com>
References: <Pine.LNX.4.44L0.0810010948580.2421-100000@iolanthe.rowland.org>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from elrond2.infotech.no ([82.134.31.41]:46463 "EHLO
	elrond2.infotech.no" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752675AbYJAOQZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Oct 2008 10:16:25 -0400
In-Reply-To: <Pine.LNX.4.44L0.0810010948580.2421-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Tue, 30 Sep 2008, Martin K. Petersen wrote:
> 
>>>>>>> "Alan" == Alan Stern <stern@rowland.harvard.edu> writes:
>> Alan> Are there types of failure for which we really don't want to
>> Alan> print anything?  For example, what about UNIT ATTENTION for
>> Alan> media changes or the DIX/DIF failures (should those both be
>> Alan> DIF?)?
>>
>> ILLEGAL REQUEST + 10/[123] indicates that the HBA rejected the request
>> (DIX).
>>
>> ABORTED COMMAND + 10/[123] indicates that the device found a
>> corruption error (DIF).
> 
> That answer the parenthetical question.  Do you know the answer to the 
> main question?  That is, when either of these events occurs do we want 
> to skip adding an error message to the system log?

I know that SAS maps certain types of transport errors to
"ABORTED COMMAND" (see
http://www.t10.org/ftp/t10/drafts/sas2/sas2r14e.pdf
section 10.2.3) and they should be retried, especially the
timeouts.

For example, if there are 20 disks hanging off a SAS expander
with a 4 wide link back to the host, then issuing big and
very frequent READs to those 20 disks should see some
"ABORTED COMMAND"s.

Doug Gilbert

