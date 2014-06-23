From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v1 2/3] ata: Fix the link down in first attempt for the
 APM X-Gene SoC AHCI SATA host controller driver.
Date: Mon, 23 Jun 2014 14:29:29 -0400
Message-ID: <20140623182929.GB18451@mtj.dyndns.org>
References: <1403518538-30697-1-git-send-email-stripathi@apm.com>
 <1403518538-30697-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1403518538-30697-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello,

On Mon, Jun 23, 2014 at 03:45:37PM +0530, Suman Tripathi wrote:
> @@ -234,15 +237,20 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
>  	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
>  	void __iomem *port_mmio = ahci_port_base(ap);
>  	struct ata_taskfile tf;
> +	int link_down_retry = 0;
>  	int rc;
>  	u32 val;
> 
> -	/* clear D2H reception area to properly wait for D2H FIS */
> -	ata_tf_init(link->device, &tf);
> -	tf.command = ATA_BUSY;
> -	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> -	rc = sata_link_hardreset(link, timing, deadline, online,
> +	do {
> +		/* clear D2H reception area to properly wait for D2H FIS */
> +		ata_tf_init(link->device, &tf);
> +		tf.command = ATA_BUSY;
> +		ata_tf_to_fis(&tf, 0, 0, d2h_fis);
> +		rc = sata_link_hardreset(link, timing, deadline, online,
>  				 ahci_check_ready);
> +		if (*online)
> +			break;
> +	} while (link_down_retry++ < MAX_LINK_DOWN_RETRY);

Hmm... so it's retrying w/o extending deadline if the link is reported
to be offline.  This definitely needs comment explaining what's going
on.  Wouldn't it make more sense to change @timing instead rather than
retrying resets?  sata_sil24 already does something similar.  Does,
f.e., using sata_deb_timing_long for @timing make the problem go away?

Thanks.

-- 
tejun
