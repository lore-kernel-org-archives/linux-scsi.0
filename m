From: Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH] mpt3sas: Avoid sleeping in interrupt context
Date: Wed, 1 Mar 2017 09:04:58 -0800
Message-ID: <20170301170458.GA3486@vader.DHCP.thefacebook.com>
References: <20170301170036.11540-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f46.google.com ([74.125.83.46]:36134 "EHLO
        mail-pg0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750813AbdCARdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2017 12:33:01 -0500
Received: by mail-pg0-f46.google.com with SMTP id s67so22415836pgb.3
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2017 09:32:27 -0800 (PST)
Content-Disposition: inline
In-Reply-To: <20170301170036.11540-1-bart.vanassche@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>, Sagi Grimberg <sagi@grimberg.me>, Christoph Hellwig <hch@lst.de>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>, "# v4 . 10+" <stable@vger.kernel.org>

On Wed, Mar 01, 2017 at 09:00:36AM -0800, Bart Van Assche wrote:
> Commit 669f044170d8 ("scsi: srp_transport: Move queuecommand() wait
> code to SCSI core") can make scsi_internal_device_block() sleep.
> However, the mpt3sas driver can call this function from an interrupt
> handler. Hence add a second argument to scsi_internal_device_block()
> that restores the old behavior of this function for the mpt3sas
> handler.
> 
> The call chain that triggered an "IRQ handler enabled interrupts"
> complaint is as follows:
> 
> _base_interrupt()
> -> _base_async_event()
>    -> mpt3sas_scsih_event_callback()
>       -> _scsih_check_topo_delete_events()
>          -> _scsih_block_io_to_children_attached_directly()
>             -> _scsih_block_io_device()
>                -> _scsih_internal_device_block()
>                   -> scsi_internal_device_block()
> 
> Reported-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Omar Sandoval <osandov@osandov.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: Sagi Grimberg <sagi@grimberg.me>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Sathya Prakash <sathya.prakash@broadcom.com>
> Cc: Chaitra P B <chaitra.basappa@broadcom.com>
> Cc: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
> Cc: Sreekanth Reddy <Sreekanth.Reddy@broadcom.com>
> Cc: <stable@vger.kernel.org> # v4.10+

Thanks, Bart, you can add

Tested-by: Omar Sandoval <osandov@fb.com>
