From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v3 2/2] ata: Fix the dma state machine lockup for the
 IDENTIFY DEVICE PIO mode command.
Date: Thu, 19 Jun 2014 10:10:47 -0400
Message-ID: <20140619141047.GA26904@htj.dyndns.org>
References: <1403160654-31612-1-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403160654-31612-1-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 19, 2014 at 12:20:54PM +0530, Suman Tripathi wrote:
> +	/*
> +	 * Restart the dma engine if the last cmd issued
> +	 * is IDENTIFY DEVICE command
> +	 */
> +	if (unlikely(ctx->last_cmd[ap->port_no] == ATA_CMD_ID_ATA))
> +		ahci_restart_engine(ap);

Is it really only for IDENTIFY?  Are other PIO commands okay?  The
previous version applied it to all PIO commands, right?

-- 
tejun
