From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 00/30] FCoE VN2VN fixes
Date: Fri, 26 Aug 2016 15:48:43 +0200
Message-ID: <20160826134843.ogmj24w36mgpvyqn@c203.arch.suse.de>
References: <1472212913-39810-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48766 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753039AbcHZNsp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 26 Aug 2016 09:48:45 -0400
Content-Disposition: inline
In-Reply-To: <1472212913-39810-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, Christoph Hellwig <hch@lst.de>, Johannes Thumshirn <jth@kernel.org>, linux-scsi@vger.kernel.org, Mike Snitzer <snitzer@redhat.com>, Martin Wilck <martin.wilck@suse.com>

On Fri, Aug 26, 2016 at 02:01:23PM +0200, Hannes Reinecke wrote:
> Hi all,
> 
> here's a patchset to get VN2VN running on non-DCB fabrics.
> With it it's possible to run FCoE VN2VN over virtio, allowing
> for a fully virtualized FC testbed. Which would make it ideal
> to integrate into Mike's mptest test suite.
> It also irons out some generic issues with the libfc stack,
> like another round for kref handling updates and handling PRLI correctly.
> (The PRLI problems even have a workaround in iPXE, so it's time to do
> something about it ...)
> 
> As usual, comments and reviews are welcome.
> 
> Hannes Reinecke (29):
>   libfc: Revisit kref handling
>   libfc: additional debugging messages
>   libfc: spurious I/O error under high load
>   libfc: Do not login if the port is already started
>   libfc: use configured lport R_A_TOV when sending
>   libfc: use configured e_d_tov for remote port state
>   libfc: do not overwrite DID_TIME_OUT status
>   libfc: use error code for fc_rport_error()
>   libfc: Send LS_RJT responses on frame allocation
>   libfc: don't advance state machine for incoming FLOGI
>   libfc: Fixup disc_mutex handling
>   libfc: Do not drop down to FLOGI for fc_rport_login()
>   libfc: Implement RTV responder
>   libfc: Rework PRLI handling
>   libfc: Return LS_RJT_BUSY for PRLI in status PLOGI
>   libfc: Clarify ramp-down messages
>   libfc: sanitize E_D_TOV and R_A_TOV setting
>   libfc: safeguard against invalid exchange index
>   libfc: quarantine timed out xids
>   libfc: don't fail sequence abort for completed
>   libfc: Do not drop out-of-order frames
>   libfc: reset timeout on queue full
>   libfc: wait for E_D_TOV when out-of-order sequence is received
>   fcoe: set default TC priority
>   fcoe: inhibit writing invalid values into the 'enabled'
>   fcoe: correct sending FIP VLAN packets on VLAN 0
>   fcoe: FIP debugging
>   fcoe: filter out frames from invalid vlans

I _think_ I already reviewed them (at least I do have a deja-vu when I
read 'Revisit kref handling')

> 
> Wei Yongjun (1):
>   fcoe: Use kfree_skb() instead of kfree()

This one is already in Linus' tree as commit
ea0a95d7f162bfa1c9df74471f0064f71cdf80ea.


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
