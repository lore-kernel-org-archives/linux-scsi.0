From: Greg KH <greg@kroah.com>
Subject: Re: [PATCH] hpsa: add heartbeat sysfs host attribute
Date: Fri, 12 Aug 2011 19:01:47 -0700
Message-ID: <20110813020147.GB15554@kroah.com>
References: <20110812180314.21808.59261.stgit@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out2.smtp.messagingengine.com ([66.111.4.26]:53872 "EHLO
	out2.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751093Ab1HMCDm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Aug 2011 22:03:42 -0400
Content-Disposition: inline
In-Reply-To: <20110812180314.21808.59261.stgit@beardog.cce.hp.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, stephenmcameron@gmail.com, thenzl@redhat.com, akpm@linux-foundation.org, mikem@beardog.cce.hp.com

On Fri, Aug 12, 2011 at 01:03:14PM -0500, Stephen M. Cameron wrote:
> From: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> 
> The cciss driver had a CCISS_HEARTBEAT ioctl which
> was not implemented in hpsa.  This ioctl returned a
> counter from a register on the Smart Array which the
> firmware would periodically update.  It can be used
> to detect certain kinds of faults (e.g. controller
> lockup) by noticing when the value remains constant
> for more than a second or two.
> 
> Signed-off-by: Stephen M. Cameron <scameron@beardog.cce.hp.com>
> ---
>  Documentation/scsi/hpsa.txt |    8 ++++++++
>  drivers/scsi/hpsa.c         |   18 ++++++++++++++++++
>  2 files changed, 26 insertions(+), 0 deletions(-)
> 
> diff --git a/Documentation/scsi/hpsa.txt b/Documentation/scsi/hpsa.txt
> index 891435a..0dac1e0 100644
> --- a/Documentation/scsi/hpsa.txt
> +++ b/Documentation/scsi/hpsa.txt
> @@ -47,6 +47,7 @@ HPSA specific entries in /sys
>    /sys/class/scsi_host/host*/firmware_revision
>    /sys/class/scsi_host/host*/resettable
>    /sys/class/scsi_host/host*/transport_mode
> +  /sys/class/scsi_host/host*/heartbeat
>  
>    the host "rescan" attribute is a write only attribute.  Writing to this
>    attribute will cause the driver to scan for new, changed, or removed devices
> @@ -78,6 +79,13 @@ HPSA specific entries in /sys
>    kexec tools to warn the user if they attempt to designate a device which is
>    unable to honor the reset_devices kernel parameter as a dump device.
>  
> +  The "heartbeat" read-only attribute returns the value of a heartbeat
> +  counter register on a Smart Array controller as a 32 bit unsigned
> +  hexadecimal integer (e.g: "0x12345678").  The value should change
> +  periodically, not less than once per second.  If this value fails to
> +  change for a period longer than one second, it means something has
> +  gone wrong (e.g. Smart Array controller firmware has locked up.)
> +

This all belongs in Documentation/ABI/ care to move it there instead?

greg k-h
