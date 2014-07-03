From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v5 1/2] libahci: Implement the function
 ahci_restart_engine to restart the port dma engine.
Date: Thu, 3 Jul 2014 10:03:35 -0400
Message-ID: <20140703140335.GD16191@htj.dyndns.org>
References: <1404296108-16233-1-git-send-email-stripathi@apm.com>
 <1404296108-16233-2-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f174.google.com ([209.85.216.174]:54155 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932327AbaGCODj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Jul 2014 10:03:39 -0400
Content-Disposition: inline
In-Reply-To: <1404296108-16233-2-git-send-email-stripathi@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>

Hello,

On Wed, Jul 02, 2014 at 03:45:07PM +0530, Suman Tripathi wrote:
> +int ahci_restart_engine(struct ata_port *ap)
> +{
> +	struct ahci_host_priv *hpriv = ap->host->private_data;
> +
> +	ahci_stop_engine(ap);
> +	ahci_start_fis_rx(ap);
> +	hpriv->start_engine(ap);
> +
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(ahci_restart_engine);

I don't get this function.  No other ahci needs it and it's not even
contained libahci proper.  It calls back to the calling low level
driver.  Why not just expose ahci_start_fis_rx() and implement the
above in xgene?

Thanks.

-- 
tejun
