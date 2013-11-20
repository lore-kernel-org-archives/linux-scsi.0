From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v2 2/4] Documentation: Add APM X-Gene SoC 6.0Gbps SATA
 PHY driver binding documentation
Date: Wed, 20 Nov 2013 09:43:28 +0000
Message-ID: <20131120094328.GS5914@e106331-lin.cambridge.arm.com>
References: <1384905197-3566-1-git-send-email-lho@apm.com>
 <1384905197-3566-2-git-send-email-lho@apm.com>
 <1384905197-3566-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1384905197-3566-3-git-send-email-lho@apm.com>
List-Unsubscribe: <http://lists.infradead.org/mailman/options/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=unsubscribe>
List-Archive: <http://lists.infradead.org/pipermail/linux-arm-kernel/>
List-Post: <mailto:linux-arm-kernel@lists.infradead.org>
List-Help: <mailto:linux-arm-kernel-request@lists.infradead.org?subject=help>
List-Subscribe: <http://lists.infradead.org/mailman/listinfo/linux-arm-kernel>,
 <mailto:linux-arm-kernel-request@lists.infradead.org?subject=subscribe>
Sender: "linux-arm-kernel" <linux-arm-kernel-bounces@lists.infradead.org>
Errors-To: linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org
To: Loc Ho <lho@apm.com>
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "tj@kernel.org" <tj@kernel.org>, "olof@lixom.net" <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Tue, Nov 19, 2013 at 11:53:15PM +0000, Loc Ho wrote:
> Documentation: Add APM X-Gene SoC 6.0Gbps SATA PHY driver binding documentation
> 
> Document the DTS binding for the X-Gene SoC SATA PHY driver.
> 
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  .../devicetree/bindings/ata/apm-xgene-phy.txt      |   61 ++++++++++++++++++++
>  1 files changed, 61 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
> new file mode 100644
> index 0000000..bbae164
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/apm-xgene-phy.txt
> @@ -0,0 +1,61 @@
> +* APM X-Gene 6.0 Gb/s SATA PHY nodes
> +
> +SATA PHY nodes are defined to describe on-chip Serial ATA PHY. Each SATA PHY
> +(pair of PHY) has its own node.
> +
> +Required properties:
> +- compatible		: Shall be "apm,xgene-ahci-phy" or
> +			  "apm,xgene-ahci-phy2". The "apm,xgene-ahci-phy"
> +			  describes an port shared with SGMII Ethernet port.
> +			  The "apm,xgene-ahci-phy2" describes an port not
> +			  shared with SGMII and the PLL located at another
> +			  memory resource region.

Is there not a better name available than "apm,xgene-ahci-phy2"?

> +- reg			: First PHY memory resource
> +			  Second separate PHY PLL clock memory resource if
> +			  type "apm,xgene-ahci-phy2"

Is ths PLL actually part of the PHY, or does it just feed the PHY?

> +- #phy-cells		: Shall be 0
> +
> +Optional properties:
> +- status		: Shall be "ok" if enabled or "na" if disabled. Default
> +			  is "ok".

Do not use "na", use the standard "disabled".

> +- txeyetuning		: Manual control to fine tune the capture of the serial
> +			  bit lines from the automatic calibrated position.
> +			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
> +			  Range from 0 to 0x7f. Default is 0xa.

If you have a property for which the name consists of multiple words,
split the words with '-'. 

What does this actually mean?

What units are these values in? 

What effect do those values have?

> +- txeyedirection	: Eye tuning manual control direction. 0 means sample
> +			  data earlier than the nominal sampling point. 1 means
> +			  sample data later than the nominal sampling point.
> +			  Two set of 3-tuple setting for Gen1, Gen2, and Gen3.
> +			  Default is 0x0.

Likewise, use '-'.

s/than/then/ ?

> +- txboostgain		: Frequency boost and DC gain control. Two set of
> +			  3-tuple setting for Gen1, Gen2, and Gen3. Range is
> +			  between 0 to 0x1f. Default is 0x3.

Use '-'.

What units are these values in?

> +- txspeed		: Tx operating speed. Two set of 3-tuple for
> +			  Gen1 (0x1), Gen2 (0x3), and Gen3 (0x7). Default is
> +			  0x7.


Units?

> +
> +NOTE: PHY override parameters are board specific setting.
> +
> +Example:
> +		sataphy0: sataphy@1f210000 {
> +			compatible = "apm,xgene-ahci-phy";
> +			reg = <0x0 0x1f210000 0x0 0x10000>;
> +			#phy-cells = <0>;
> +			status = "na";

Please eradicate all instances of "na".

> +		};
> +
> +		sataphy1: sataphy@1f220000 {
> +			compatible = "apm,xgene-ahci-phy";
> +			reg = <0x0 0x1f220000 0x0 0x10000>;
> +			#phy-cells = <0>;
> +			status = "ok";
> +		};
> +
> +		sataphy2: sataphy@1f230000 {
> +			compatible = "apm,xgene-ahci-phy2";
> +			reg = <0x0 0x1f230000 0x0 0x10000
> +			       0x0 0x1f2d0000 0x0 0x10000 >;

Nit: bracket list entries individually, and don't apply random spacing:

reg = <0x0 0x1f230000 0x0 0x10000>,
      <0x0 0x1f2d0000 0x0 0x10000>;

Thanks,
Mark.
