From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v5 2/4] Documentation: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Tue, 26 Nov 2013 14:55:16 +0000
Message-ID: <20131126145515.GD5402@e106331-lin.cambridge.arm.com>
References: <1385449285-30764-1-git-send-email-lho@apm.com>
 <1385449285-30764-2-git-send-email-lho@apm.com>
 <1385449285-30764-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:55136 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756699Ab3KZOzx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 26 Nov 2013 09:55:53 -0500
Content-Disposition: inline
In-Reply-To: <1385449285-30764-3-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: "olof@lixom.net" <olof@lixom.net>, "tj@kernel.org" <tj@kernel.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>

On Tue, Nov 26, 2013 at 07:01:23AM +0000, Loc Ho wrote:
> Documentation: Add documentation for APM X-Gene SoC SATA host controller DTS binding
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  .../devicetree/bindings/ata/apm-xgene.txt          |  102 ++++++++++++++++++++
>  1 files changed, 102 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
> new file mode 100644
> index 0000000..879eee7
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
> @@ -0,0 +1,102 @@
> +* APM X-Gene 6.0 Gb/s SATA host controller and clock nodes
> +
> +SATA host controller nodes are defined to describe on-chip Serial ATA
> +controllers. Each SATA controller (pair of ports) have its own node. Its
> +corresponding clock nodes are shown below.
> +
> +Required properties:
> +- compatible		: Shall be "apm,xgene-ahci-sgmii" if mux'ed with SGMII
> +			  or "apm,xgene-ahci-pcie" if mux'ed with PCIe.
> +- reg			: First memory resource shall be the AHCI memory
> +			  resource.
> +			  Second memory resource shall be the host controller
> +			  memory resource.
> +- interrupt-parent	: Interrupt controller.

I don't think that's strictly required.

> +- interrupts		: Interrupt mapping for SATA host controller IRQ.
> +- clocks		: Reference to the clock entry.
> +- phys			: PHY reference with parameter 0.
> +- phy-names		: Name of the PHY. Shall be "sata-6g".
> +
> +Optional properties:
> +- status		: Shall be "ok" if enabled or "na" if disabled.
> +			  Default is "ok".

Why not use the more standard "disabled" string, as I asked you to
previously?

[...]

> +		sata2: sata@1a400000 {
> +			compatible = "apm,xgene-ahci-sgmii";
> +			reg = <0x0 0x1a400000 0x0 0x1000>,
> +			      <0x0 0x1f220000 0x0 0x10000>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <0x0 0x87 0x4>;
> +			status = "ok";
> +			clocks = <&sata23clk 0>;
> +			phys = <&phy2 0>;
> +			phy-names = "sata-6g";
> +		};
> +
> +		sata3: sata@1a800000 {
> +			compatible = "apm,xgene-ahci-pcie";
> +			reg = <0x0 0x1a800000 0x0 0x1000>,
> +			      <0x0 0x1f230000 0x0 0x10000>;
> +			interrupt-parent = <&gic>;
> +			interrupts = <0x0 0x88 0x4>;
> +			status = "ok";
> +			clocks = <&sata45clk 0>;
> +			phys = <&phy3 0>;
> +			phy-names = "sata-6g";
> +		};

The example is pointlessly huge. You could trim it down two these last
two nodes (with a phy node and some fixed clocks). 

Thanks,
Mark.
