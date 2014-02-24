From: Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH v13 2/3] ata: Add APM X-Gene SoC AHCI SATA host
 controller driver
Date: Mon, 24 Feb 2014 13:31:29 -0500
Message-ID: <20140224183129.GA2522@htj.dyndns.org>
References: <1393221265-13057-1-git-send-email-lho@apm.com>
 <1393221265-13057-2-git-send-email-lho@apm.com>
 <1393221265-13057-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1393221265-13057-3-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Loc.

Almost there.  Just one more thing.

On Sun, Feb 23, 2014 at 10:54:24PM -0700, Loc Ho wrote:
....
> +static int xgene_ahci_init_memram(struct xgene_ahci_context *ctx)
> +{
> +	void __iomem *diagcsr = ctx->csr_base + SATA_DIAG_OFFSET;
> +	int try;
> +	u32 val;
> +
> +	val = readl(diagcsr + CFG_MEM_RAM_SHUTDOWN);
> +	if (val == 0) {
> +		dev_dbg(ctx->dev, "memory already released from shutdown\n");
> +		return 0;
> +	}
> +	dev_dbg(ctx->dev, "Release memory from shutdown\n");
> +	/* SATA controller memory in shutdown. Remove from shutdown. */
> +	writel(0x0, diagcsr + CFG_MEM_RAM_SHUTDOWN);
> +	readl(diagcsr + CFG_MEM_RAM_SHUTDOWN); /* Force a barrier */
> +
> +	/* Check for at least ~1ms */
> +	try = 1000;
> +	do {
> +		val = readl(diagcsr + BLOCK_MEM_RDY);
> +		if (val != 0xFFFFFFFF)
> +			usleep_range(1, 100);
> +	} while (val != 0xFFFFFFFF && try-- > 0);
> +	if (try <= 0) {
> +		dev_err(ctx->dev, "failed to release memory from shutdown\n");
> +		return -ENODEV;
> +	}
> +	return 0;
> +}

Hmm... ISTR raising this issue before but the above is way more
elaborate than necessary.  This isn't in any sense a hot path and 1ms
is short enough to handle it simply.  If the only thing being
addressed here is that the init may take upto 1ms, you might as well
just do

	writel(0x0, diagcsr + CFG_MEM_RAM_SHUTDOWN);
	readl(diagcsr + CFG_MEM_RAM_SHUTDOWN); /* Force a barrier */
	msleep(1);	/* reset may take upto 1ms */
	if (readl(diagcsr + BLOCK_MEM_RDY) != 0xFFFFFFFF) {
		dev_err(...);
		return -ENODEV;
	}
	return 0;

Thanks.

-- 
tejun
