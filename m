From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
Subject: Re: [PATCH v0 2/3] ata: Fix the link down in first attempt for the
 APM X-Gene SoC AHCI SATA host controller driver.
Date: Fri, 20 Jun 2014 19:25:58 +0400
Message-ID: <53A45286.2040000@cogentembedded.com>
References: <1403253147-14341-1-git-send-email-stripathi@apm.com> <1403253147-14341-3-git-send-email-stripathi@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1403253147-14341-3-git-send-email-stripathi@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Suman Tripathi <stripathi@apm.com>, olof@lixom.net, tj@kernel.org, arnd@arndb.de
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, ddutile@redhat.com, jcm@redhat.com, patches@apm.com, Loc Ho <lho@apm.com>
List-Id: linux-scsi@vger.kernel.org

On 06/20/2014 12:32 PM, Suman Tripathi wrote:

> This patch fixes the link down issue by retry for the APM X-Gene SoC
> SATA host controller driver. Due to board design issue and short margin
> limitation, it is observed that once out of many thousands power cycle
> test, the sata link may not link up.

> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>   drivers/ata/ahci_xgene.c | 9 +++++++++
>   1 file changed, 9 insertions(+)

> diff --git a/drivers/ata/ahci_xgene.c b/drivers/ata/ahci_xgene.c
> index 5f0f750..d43b6ce 100644
> --- a/drivers/ata/ahci_xgene.c
> +++ b/drivers/ata/ahci_xgene.c
[...]
> @@ -235,15 +238,21 @@ static int xgene_ahci_do_hardreset(struct ata_link *link,
>   	u8 *d2h_fis = pp->rx_fis + RX_FIS_D2H_REG;
>   	void __iomem *port_mmio = ahci_port_base(ap);
>   	struct ata_taskfile tf;
> +	int link_down_retry = 0;
>   	int rc;
>   	u32 val;
>
> +hardreset_retry:
>   	/* clear D2H reception area to properly wait for D2H FIS */
>   	ata_tf_init(link->device, &tf);
>   	tf.command = ATA_BUSY;
>   	ata_tf_to_fis(&tf, 0, 0, d2h_fis);
>   	rc = sata_link_hardreset(link, timing, deadline, online,
>   				 ahci_check_ready);
> +
> +	if (!*online)
> +		if (link_down_retry++ < MAX_LINK_DOWN_RETRY)

    Could be folded into single *if* (and so indentation decreased).

> +			goto hardreset_retry;

WBR, Sergei

