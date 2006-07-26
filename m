From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC] fc transport: extensions for fast fail and dev loss
Date: Wed, 26 Jul 2006 10:20:53 +0100
Message-ID: <20060726092053.GA4155@infradead.org>
References: <1150829123.16981.1.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:22210 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S1750719AbWGZJUz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Jul 2006 05:20:55 -0400
Content-Disposition: inline
In-Reply-To: <1150829123.16981.1.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: linux-scsi@vger.kernel.org

On Tue, Jun 20, 2006 at 02:45:23PM -0400, James Smart wrote:
> Folks,
> 
> The following addresses some long standing todo items I've had in the
> FC transport. They primarily arise when considering multipathing, or
> trying to marry driver internal state to transport state. It is intended
> that this same type of functionality would be usable in other transports
> as well.
> 
> Here's what is contained:
> 
> - dev_loss_tmo LLDD callback :
>   Currently, there is no notification to the LLDD of when the transport
>   gives up on the device returning and starts to return DID_NO_CONNECT
>   in the queuecommand helper function. This callback notifies the LLDD
>   that the transport has now given up on the rport, thereby acknowledging
>   the prior fc_remote_port_delete() call. The callback also expects the
>   LLDD to initiate the termination of any outstanding i/o on the rport.

I think this is fine.

> - fast_io_fail_tmo and LLD callback:
>   There are some cases where it may take a long while to truly determine
>   device loss, but the system is in a multipathing configuration that if
>   the i/o was failed quickly (faster than dev_loss_tmo), it could be
>   redirected to a different path and completed sooner (assuming the 
>   multipath thing knew that the sdev was blocked).

shouldn't we just always fail REQ_FAILFAST requests ASAP and totally
ignore any kind of devloss timeout for them?

>   This attribute is an exported "recommendation" by the LLDD and transport
>   on what the lowest setting for dev_loss_tmo should be for a multipathing
>   environment. Thus, the admin only needs to cat this attribute to obtain
>   the value to echo into dev_loss_tmo.

This kind of policy really doesn't belong into the kernel.  I'd rather
see a nice userspace command to get this right for the user as part of
sg_utils or Jeffs infamous blktool.

> I have one criticism of these changes. The callbacks are calling into
> the LLDD with an rport post the driver's rport_delete call. What it means
> is that we are essentially extending the lifetime of an rport until the
> dev_loss_tmo call occurs.

Which is okay as long as it's documented well enough.

