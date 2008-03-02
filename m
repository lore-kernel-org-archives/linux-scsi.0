From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 1/9] scsi: Add helper code so transport classes/driver
 can control queueing
Date: Sun, 02 Mar 2008 03:08:13 -0600
Message-ID: <47CA6E7D.8000205@cs.wisc.edu>
References: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:47045 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752822AbYCBJIY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 2 Mar 2008 04:08:24 -0500
In-Reply-To: <1204448602-5435-1-git-send-email-michaelc@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, david.somayajulu@qlogic.com, andrew.vasquez@qlogic.com, James.Smart@Emulex.com, Eric.Moore@lsil.com

Oh yeah, these patches were made over scsi-rc-fixes and can be applied 
over the target resets ones (the target reset ones can be applied over 
these too).

michaelc@cs.wisc.edu wrote:
> From: Mike Christie <michaelc@cs.wisc.edu>
> 
> SCSI-ml manages the queueing limits for the device and host, but
> does not do so at the target level. However something something similar
> can come in userful when a driver is transitioning a transport object to
> the the blocked state, becuase at that time we do not want to queue
> io and we do not want the queuecommand to be called again.
> 
> The patch adds code similar to the exisiting SCSI_ML_*BUSY handlers.
> You can now return SCSI_MLQUEUE_TARGET_BUSY when we hit
> a transport level queueing issue like the hw cannot allocate some
> resource at the iscsi session/connection level, or the target has temporarily
> closed or shrunk the queueing window, or if we are transitioning
> to the blocked state.
> 
> For bnx2i we will also need to be able to limit queueing at this level.
> bnx2i will hook into libiscsi, but will allocate a scsi host per
> netdevice/hba, so unlike pure software iscsi/iser which is allocating
> a host per session, it cannot set the scsi_host->can_queue and return
> SCSI_MLQUEUE_HOST_BUSY to reflect queueing limits on the transport.
> 
> The iscsi class/driver can also set a scsi_target->can_queue value which
> reflects the max commands the driver/class can support. For iscsi this
> reflects the number of commands we can support for each session due to
> session/connection hw limits, driver limits, and to also reflect the
> session/targets's queueing window.
> 
