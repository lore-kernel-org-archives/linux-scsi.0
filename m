From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v2 5/5] Documentation: Add documentation for APM X-Gene SATA DTS binding
Date: Sun, 10 Nov 2013 21:39:09 +0100
Message-ID: <201311102139.10082.arnd@arndb.de>
References: <1383980431-6572-1-git-send-email-lho@apm.com> <1383980431-6572-5-git-send-email-lho@apm.com> <1383980431-6572-6-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.17.8]:62051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752100Ab3KJUjT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 10 Nov 2013 15:39:19 -0500
In-Reply-To: <1383980431-6572-6-git-send-email-lho@apm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-arm-kernel@lists.infradead.org
Cc: Loc Ho <lho@apm.com>, olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, jcm@redhat.com, Suman Tripathi <stripathi@apm.com>, Tuan Phan <tphan@apm.com>

On Saturday 09 November 2013, Loc Ho wrote:
> Documentation: Add documentation for APM X-Gene SATA DTS binding
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  .../devicetree/bindings/ata/apm-xgene.txt          |   84 ++++++++++++++++++++

Please Cc the devicetree-discuss mailing list for the binding submission.

> +SATA nodes are defined to describe on-chip Serial ATA controllers.
> +Each SATA controller (pair of ports) have its own node.
> +
> +Required properties:
> +- compatible		: Shall be "apm,xgene-ahci"
> +- reg			: First memory resource shall be the AHCI memory resource
> +			  Second memory resource shall be the Serdes memory resource
> +			  Third memory resource shall be the optional Serdes
> +			  memory resource if mux'ed with another IP
> +- interrupt-parent	: Interrupt controller
> +- interrupts		: Interrupt mapping for SATA IRQ
> +- #clock-cells		: Shall be value of 1

Why is there a #clock-cells entry here?

> +- clocks		: Reference to the clock entry
> +- clock-names		: Shall be "eth01clk", "eth23clk", or "eth45clk".

This makes no sense. The clock-names property needs to have a fixed
string according to the name of the clock input signal of the hardware,
not a name of the clock provider.

> +- serdes-diff-clk	: Shall be 0 for external, 1 internal differential,
> +			  or 2 internal single ended clock. Default is 0.
> +- gen-sel		: Shall be 1 (force Gen1), 2 (Force Gen2, or 3 Gen3).
> +			  Default is 3.
> +- EQA1			: Serdes EQ parameter for A1 chip. Default is 9.
> +- EQ			: Serdes EQ parameter for non-A1 chip. Default is 2.
> +- GENAVG		: Enable averaging Serdes calculation. Default is 0 for
> +			  A1 chip and 1 for non-A1 chip.
> +- LBA1			: Serdes loopback buffer for A1 chip. Default is 1;
> +- LB			: Serdes loopback buffer for non-A1 chip. Default is 0;
> +- LCA1			: Serdes loopback enable control for A1 chip. Default
> +			  is 1;
> +- LC			: Serdes loopback enable control for non-A1 chip.
> +			  Default is 0;
> +- CDRA1			: Serdes SPD select CDR for A1 chip. Default is 5.
> +- CDR			: Serdes SPD select CDR for non-A1 chip. Default is 5.
> +- PQA1			: Serdes PQ for A1 chip. Default is 8.
> +- PQ			: Serdes PQ for non-A1 chip. Default is 0xA.
> +- coherent		: Enable coherent (1 = enable, 0 = disable).
> +			  Default is 1.

This looks like a really bad binding. I would suggest that instead of having
individual register values in here, you hardwire the settings in the driver
based on the compatible string. It's pretty crazy to put register-level configuration
in the DT like this.

Further, you should probably use the generic PHY binding to create a separate driver
for the serdes PHY,

	Arnd
