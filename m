From: Christof Schmitt <christof.schmitt@de.ibm.com>
Subject: Re: fc_remote_port_delete and returning SCSI commands from LLD
Date: Wed, 21 Oct 2009 17:24:37 +0200
Message-ID: <20091021152437.GA19717@schmichrtp.de.ibm.com>
References: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.17.162]:37010 "EHLO
	mtagate2.de.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753905AbZJUPYe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 21 Oct 2009 11:24:34 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate2.de.ibm.com (8.13.1/8.13.1) with ESMTP id n9LFOcqt025176
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 15:24:38 GMT
Received: from d12av03.megacenter.de.ibm.com (d12av03.megacenter.de.ibm.com [9.149.165.213])
	by d12nrmr1607.megacenter.de.ibm.com (8.13.8/8.13.8/NCO v10.0) with ESMTP id n9LFObNo3403808
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 17:24:37 +0200
Received: from d12av03.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id n9LFObnh025290
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 17:24:37 +0200
Received: from schmichrtp.de.ibm.com (schmichrtp.mainz.de.ibm.com [9.155.42.186])
	by d12av03.megacenter.de.ibm.com (8.12.11.20060308/8.12.11) with SMTP id n9LFObnc025284
	for <linux-scsi@vger.kernel.org>; Wed, 21 Oct 2009 17:24:37 +0200
Content-Disposition: inline
In-Reply-To: <20091020144027.GA17717@schmichrtp.de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Tue, Oct 20, 2009 at 04:40:27PM +0200, Christof Schmitt wrote:
> If the remote_port status is not BLOCKED, this will trigger the SCSI
> midlayer error handling which cannot do much during the interruption
> to the hardware and will mark the SCSI devices 'offline'. In order to
> prevent this, the rule would be: First call fc_remote_port_delete to
> set the remote port (or in the case of an HBA interruption all remote
> ports) to BLOCKED, and only after this step call scsi_done to pass the
> SCSI commands back to the upper layers.

I just stumbled across a loop that blocks the SCSI error handling
thread:

	spin_lock_irqsave(shost->host_lock, flags);
	while (rport->port_state == FC_PORTSTATE_BLOCKED) {
		spin_unlock_irqrestore(shost->host_lock, flags);
		msleep(1000);
		spin_lock_irqsave(shost->host_lock, flags);
	}
	spin_unlock_irqrestore(shost->host_lock, flags);

This seems to be popular among FC drivers. Is this the preferred way
to synchronize the FC transport class state changes with the SCSI
midlayer error recovery?

Christof
