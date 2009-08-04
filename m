From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: reading errors on JMicron JM20337 USB-SATA
Date: Tue, 4 Aug 2009 14:43:21 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.0908041437340.3102-100000@iolanthe.rowland.org>
References: <alpine.LFD.2.00.0908042155580.6078@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:40824 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933146AbZHDSnV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 14:43:21 -0400
In-Reply-To: <alpine.LFD.2.00.0908042155580.6078@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <melnikovsky@mail.ru>
Cc: Boaz Harrosh <bharrosh@panasas.com>, SCSI development list <linux-scsi@vger.kernel.org>, Artur Skawina <art.08.09@gmail.com>, USB list <linux-usb@vger.kernel.org>

On Tue, 4 Aug 2009, Lev A. Melnikovsky wrote:

> Hello,
> 
> I was advised to move this thread [ http://marc.info/?t=124916632000003&r=1&w=2 ]
> to the linux-scsi mailing list. In my opinion the original problem 
> descriptions can be considered as a follow-up to a year old thread on 
> "JMicron JM20337 USB-SATA data corruption bugfix" [ http://marc.info/?l=linux-kernel&m=121653150327283&w=2 ].
> The JMicron bridge is connected to a SATA disk with genuine errors (bad 
> sectors, just in case: I am not going to use it but to recover some data 
> from it). Unfortunately when a bad block is read no error is returned, 
> instead a caller is blocked indefinitely (at least for two hours or until 
> the USB cable is removed). The system log is filled with repetitive
> 
> sd 3:0:0:0: [sdf] Sense Key : 0x0 [current]
> sd 3:0:0:0: [sdf] ASC=0x0 ASCQ=0x0
> 
> Alan Stern has suggested that this should be fixed as following:
> 
> AS> Tell them that scsi_end_request() mustn't call scsi_requeue_command() 
> AS> if bytes == 0.
> 
> Is this the right thing to do?

To explain a little farther: The JMicron USB-SATA bridge has a nasty 
habit of not reporting errors correctly.  It provides Check Condition 
status but SK, ASC, and ASCQ are all zero.  In this case we're talking 
about read errors.

This combination of codes causes scsi_end_request() to requeue the
command, thereby resetting the block layer's cancellation timer.  
However if bytes == 0 then no forward progress was made in executing
the command, so the retry fails at exactly the same spot as before and
the system keeps retrying indefinitely.

Alan Stern

