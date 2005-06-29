From: Christoph Hellwig <hch@infradead.org>
Subject: Re: I want scsi_target_block() in interrupt context
Date: Wed, 29 Jun 2005 18:36:29 +0100
Message-ID: <20050629173629.GA32197@infradead.org>
References: <52fyv1dqer.fsf@topspin.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:37851 "EHLO
	pentafluge.infradead.org") by vger.kernel.org with ESMTP
	id S262317AbVF2Rgh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2005 13:36:37 -0400
Content-Disposition: inline
In-Reply-To: <52fyv1dqer.fsf@topspin.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rolandd@cisco.com>
Cc: linux-scsi@vger.kernel.org

On Wed, Jun 29, 2005 at 10:27:40AM -0700, Roland Dreier wrote:
> I'm working on an implementation of SCSI RDMA Protocol (SRP) on
> InfiniBand, and I'm running into an issue managing the number of
> commands that get queued.
> 
> The setup is like this: each SRP scsi_host can connect to multiple
> target ports.  Each target port can have multiple LUNs behind it.  To
> support this, for each connection, I create a device, set its parent
> to the scsi_host's shost_gendev, and then call scsi_scan_target to
> discover the LUNs behind the target port.
> 
> This mostly works fine, except the number of outstanding commands is
> limited per connection.  This doesn't fit that well with the Linux
> SCSI stack -- can_queue for the scsi_host doesn't work, since a single
> scsi_host can have multiple connections, and cmd_per_lun doesn't work
> since a single connection can have many LUNs.
> 
> What seems like it _would_ be exactly what I need would be calling
> scsi_target_block() on the device representing the connection.
> Unfortunately, scsi_target_block() uses all sorts of device model
> stuff that takes semaphores and hence potentially sleeps.  This means
> that I can't block a connection while holding a lock to prevent races.
> 
> So I don't see a race-free way I can ensure that I never queue up too
> many commands on a given connection.

Just allocate one scsi_host per connection.

