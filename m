From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [Patch] Fix oops on rmmod usb-storage
Date: Wed, 29 Sep 2004 14:58:01 -0400 (EDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44L0.0409291455180.1700-100000@ida.rowland.org>
References: <20040929183214.GA5771@us.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ida.rowland.org ([192.131.102.52]:27140 "HELO ida.rowland.org")
	by vger.kernel.org with SMTP id S267504AbUI2S6E (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Sep 2004 14:58:04 -0400
In-Reply-To: <20040929183214.GA5771@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@SteelEye.com>, Hannes Reinecke <hare@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, Matthew Dharm <mdharm-usb@one-eyed-alien.net>

On Wed, 29 Sep 2004, Mike Anderson wrote:

> Is it possible usb storage could do something else beside just ignore
> the commands like return them with DID_NO_CONNECT.
> 
> In storage_disconnect it looks like you set some state, wait for the
> current command, but do not set anything that queuecommand can look at
> to start rejecting commands.

No, there is a flag set: US_FLIDX_DISCONNECTING.  queuecommand could use 
that to reject commands.

On the other hand, considering the race between queuecommand and 
scsi_remove_host, it shouldn't matter if queuecommand accepts the 
commands.  After all, it's not really possible for the SCSI core to tell 
whether queuecommand was called before or after scsi_remove_host.

Alan Stern

