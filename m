From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] first cut at fixing unable to requeue with no outstanding
 commands
Date: Tue, 01 Oct 2002 11:14:12 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210011514.g91FEC703750@localhost.localdomain>
References: <patmans@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA19422
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 08:14:15 -0700
Received: from localhost.localdomain (sshppp-200.mtv1.steeleye.com [172.16.1.200])
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) with ESMTP id IAA19331
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 08:14:13 -0700
Received: from mulgrave (jejb@localhost)
	by localhost.localdomain (8.11.6/linuxconf) with ESMTP id g91FEC703750
	for <linux-scsi@vger.kernel.org>; Tue, 1 Oct 2002 11:14:13 -0400
In-Reply-To: Message from Patrick Mansfield <patmans@us.ibm.com>
   of "Tue, 01 Oct 2002 08:01:15 PDT." <20021001080115.A27028@eng2.beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

patmans@us.ibm.com said:
> What about applications and devices that only send one IO at a time?
> They could still hang.

> We have: tape (st or osst), sg usage, partitioning, scanning, direct
> use of the block device (i.e. dd if=/dev/sda), and probably others. 

I don't believe so.

Unplugging is a global thing.  The request function for a plugged queue will 
always be run, that's a guarantee, so using this approach, the queue will 
stall but never hang forever.

I think for a rejection of a command with none outstanding, a stall is what 
you want (give the host/device time to recover from whatever the problem is).  
The length of the stall will be dependent on I/O pressure in the system, which 
is also roughly what you want: we can afford to give a device quite a while to 
recover if we're not desparate to get I/O to it. We can also handle BUSY 
returns this way too...

James


