From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/6]  mpt2sas: Power cycling cascaded expanders causes
 kernel panic
Date: Thu, 30 Jul 2009 09:08:11 -0500
Message-ID: <1248962891.3880.18.camel@mulgrave.site>
References: <20090730125127.GB20582@lsi.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42037 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750921AbZG3OIQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 30 Jul 2009 10:08:16 -0400
In-Reply-To: <20090730125127.GB20582@lsi.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Kashyap, Desai" <kashyap.desai@lsi.com>
Cc: linux-scsi@vger.kernel.org, Eric.Moore@lsi.com, Sathya.Prakash@lsi.com

On Thu, 2009-07-30 at 18:21 +0530, Kashyap, Desai wrote:
> Code cleanup of the host reset handling of the driver, and fix host plug work thread deadlocks, and kernel panics.
> 
> Summary of the changes:
> 
> (1) removed ioc->ioc_reset_in_progress flag, replaced with ioc->shost_recovery.
> (2) removed the spin lock around reading ioc->shost_recovery.
> (3) removed changing shost state during host reset handling; such as SHOST_RECOVERY 
> (4) moved rescanning the devices, updating handles, and deleting not responding devices to the same contents at the host reset handling.
> (5) return SCSI_MLQUEUE_DEVICE_BUSY from _qcmd when sas_target_priv_data->tm_busy is set
> (6) set SDEV_RUNNING from contents of the interrupt, instead of work threads
> (7) when there is a failure during _scsih_expander_add, need to call mpt2sas_transport_port_remove to properly tear down the port.

Will you please *not* do this.  A kernel panic fix should be completely
separate from code cleanups (primarily because it will likely need
backporting to stable kernels).  The rule is one patch per functional
change (code cleanups, since they technically should have no functional
changes, can be in a single patch).

Could we have a pointer to the panic and an indication whether
backporting to stable is necessary?

James


