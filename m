From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: SCSI woes (followup)
Date: Tue, 24 Sep 2002 10:29:01 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200209241429.g8OET2r10804@localhost.localdomain>
References: <rmk@arm.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id HAA00404
	for <linux-scsi@vger.kernel.org>; Tue, 24 Sep 2002 07:29:08 -0700
In-Reply-To: Message from Russell King <rmk@arm.linux.org.uk>
   of "Tue, 24 Sep 2002 14:58:52 BST." <20020924145852.A28042@flint.arm.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Russell King <rmk@arm.linux.org.uk>
Cc: linux-scsi@vger.kernel.org

rmk@arm.linux.org.uk said:
> I think it is misplaced.  It locks the doors of devices that aren't
> even in use, which is just plain stupid. 

A better fix is probably to implement a flag to say whether the door should be 
locked or not.

The whole lock door before a command goes down philosophy looks slightly wrong 
to me.  I can see we want to lock the door for a mounted device and other 
conditions, but locking the door just to send down a test unit ready or 
inquiry doesn't seem correct.

Door locking is very similar to reservation maintenance.  Perhaps adding 
kernel code to maintain certain persistent but fragile states of the device 
might be in order.

> Incidentally, I've found another weirdness in the code.  We decide
> that we need to lock the door based on the "was_reset" flag, which we
> clear. However, st.c uses "was_reset" to decide whether to suspend
> operations (due to a bus reset).  The two uses of this flag seem to
> conflict each other.  How can we guarantee that st.c will see
> was_reset set if the request function clears it?  st.c appears to use
> scsi_request_fn, so I guess there's a conflict of use there.

The code is riddled with these.  Reset handling was really just bolted on to 
the code as an afterthought.

James


