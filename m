From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] scsi_debug lk 2.6.0t6
Date: Wed, 8 Oct 2003 17:35:17 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031009003517.GC16877@beaverton.ibm.com>
References: <3F829CCF.3020104@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.131]:7166 "EHLO e33.co.us.ibm.com")
	by vger.kernel.org with ESMTP id S261841AbTJIAbd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Oct 2003 20:31:33 -0400
Content-Disposition: inline
In-Reply-To: <3F829CCF.3020104@torque.net>
List-Id: linux-scsi@vger.kernel.org
To: Douglas Gilbert <dougg@torque.net>
Cc: linux-scsi@vger.kernel.org

Douglas Gilbert [dougg@torque.net] wrote:
> Another annoyance that I was unable to get to the bottom
> of was during "rmmod scsi_debug" **:
>   Synchronizing SCSI cache for disk sda: <4>FAILED
>     status = 0, message = 00, host = 1, driver = 00
> That is a DID_NO_CONNECT error. So the LLD host is
> being shut down before the sd driver gets a chance to
> send through a SYNCHRONIZE CACHE command. If the user
> instigates a rmmod (as distinct from the hardware
> saying the host/device is gone), shouldn't a window
> be left open for such a flushing type command. This
> problem seems to have appeared recently.

It is related to the state added to scsi_remove_host a while ago to
stop IO flow.

To allow a window as you indicate we would need some method to determine
rmmod vs. unexpected disconnect.

1.) One method would be to add a argument to to scsi_remove_host to
allow passing the type of remove from the LLDD.

2.) Another method would be to call a new function to shutdown the
children of the host prior to module removal (also setting a flag to
stop furthur IO). Then if there was any driver specific actions needed
prior to scsi_remove_host the LLDD could have the freedom to do what
every it needed.

The sd_shutdown function is already registered as a shutdown function. The
only reason it is not called twice is the we never alter the
detach_state of the sd struct device. I am unclear what impact the power
changes have on these interfaces.

-andmike
--
Michael Anderson
andmike@us.ibm.com

