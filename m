From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH 2.5.17] Making SCSI not copy the request structure
Date: Fri, 24 May 2002 09:00:55 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200205241300.g4OD0uT01742@localhost.localdomain>
References: <ARZEH@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id GAA06009
	for <linux-scsi@vger.kernel.org>; Fri, 24 May 2002 06:00:56 -0700
In-Reply-To: Message from "Aron Zeh" <ARZEH@de.ibm.com>
   of "Fri, 24 May 2002 09:52:19 +0200." <OF33C61840.B0D589F0-ONC1256BC3.0029F105@de.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Aron Zeh <ARZEH@de.ibm.com>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Doug Ledford <dledford@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>, patman@beaverton.ibm.com, linux-scsi@vger.kernel.org

ARZEH@de.ibm.com said:
> I think we are talking about two different things. If I am not
> mistaken, __scsi_insert_special is only called for character devices
> or ioctl (at least that is what it states in the description).
[...]
> The command is put into the mlqueue to be resent when a command
> completes.

True, but look what happens to it after that:

scsi_mlqueue_insert() -> scsi_insert_special_cmd -> __scsi_insert_special().

__scsi_insert_special() is the ultimate point you always get to in the 
mid-layer for pushing anything back to the block layer.

My theory is that because we set host or device blocked in scsi_mlqueue_insert 
which causes the termination of our request processing loop.  But, the block 
layer only expects this termination on exhaustion or plugging, so it thinks 
we're still processing commands, however we're actually not.  Thus, the 
request function is never called again and we get stuck I/Os.  The way to 
correct this is to tell the block layer we have stopped processing by plugging 
the device queue.  Actually, I think host_blocked and device_blocked could be 
eliminated in favour of relying on the device queue plugging status.

The test of this theory is just the previously mentioned change of the 0 to 1, 
could you try it since you seem to be able to reproduce the problem reliably.

James


