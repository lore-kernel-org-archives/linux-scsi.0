From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] 2.5.31 scsi_error.c cleanup
Date: Thu, 22 Aug 2002 13:11:15 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200208221711.g7MHBFU03459@localhost.localdomain>
References: <andmike@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id KAA27442
	for <linux-scsi@vger.kernel.org>; Thu, 22 Aug 2002 10:11:17 -0700
In-Reply-To: Message from Mike Anderson <andmike@us.ibm.com>
   of "Thu, 22 Aug 2002 09:34:39 PDT." <20020822163439.GA1336@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org

andmike@us.ibm.com said:
> Thanks for the feedback my intent was not to panic on failed recovery.
> I will re-verify an offline case.

> All sdev's that fail to recover in scsi_eh_bus_host_reset through a
> bus and/or host reset should be offlined at the bottom of the channel
> for loop before we go on to the next channel. The BUG_ON(shost->
> host_failed) in scsi_unjam host is a carryover from the old scsi_error
> panic that I believe was trying to catch race conditions / code
> problems. I left the check in for now. 

Ah, OK.  I missed that in the logic flow.  Does it perhaps make sense to move 
the offline into its own nicely named function?  It might add to the initial 
readability of scsi_unjam_host.  I see it was problematic because the offline 
loop is bound up inside the host loop.

James


