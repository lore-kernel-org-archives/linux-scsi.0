From: Andrew Vasquez <andrew.vasquez@qlogic.com>
Subject: Re: [PATCH] qla2xxx: Fix to allow to reset devices using sg interface (sg_reset)
Date: Thu, 27 Jul 2006 15:49:32 -0700
Message-ID: <20060727224932.GT2338@jdlab1.qlogic.org>
References: <44C61AE4.2010600@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pat.qlogic.com ([198.70.193.2]:46966 "EHLO avexch1.qlogic.com")
	by vger.kernel.org with ESMTP id S1751399AbWG0Wte (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 27 Jul 2006 18:49:34 -0400
Content-Disposition: inline
In-Reply-To: <44C61AE4.2010600@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: linux-scsi@vger.kernel.org, linux-driver@qlogic.com

On Tue, 25 Jul 2006, Vladislav Bolkhovitin wrote:

> Currently it is impossible to reset provided by Qlogic QLA2xxx driver 
> SCSI devices externally using corresponding sg devices, particularly via 
> sg_reset utility, because qla2xxx driver in qla2xxx_eh_device_reset() 
> function checks if the input scsi_cmnd has its private data (CMD_SP()) 
> attached. Then the found pointer isn't used anywhere inside of 
> qla2xxx_eh_device_reset(). If the RESET request comes from sg device, it 
> doesn't have such private data.
> 
> The attached patch removes check for non-NULL CMD_SP() from 
> qla2xxx_eh_device_reset(), hence allows to reset QLA2xxx's devices using 
> corresponding sg devices.

hmm... actually this change should propegate to the bus and host reset
handlers as well.  I have a series of small fixes queued for
submission, I'll add you patch (with the bus/host deltas) to the
queue.

Thanks,
Andrew Vasquez
