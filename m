From: Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v9 2/4] Documentation: Add documentation for APM X-Gene
 SoC SATA host controller DTS binding
Date: Wed, 15 Jan 2014 11:18:39 +0000
Message-ID: <20140115111839.GB25824@e106331-lin.cambridge.arm.com>
References: <1389769910-15505-1-git-send-email-lho@apm.com>
 <1389769910-15505-2-git-send-email-lho@apm.com>
 <1389769910-15505-3-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
Content-Disposition: inline
In-Reply-To: <1389769910-15505-3-git-send-email-lho@apm.com>
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
Cc: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Suman Tripathi <stripathi@apm.com>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "jcm@redhat.com" <jcm@redhat.com>, "patches@apm.com" <patches@apm.com>, "tj@kernel.org" <tj@kernel.org>, "dmilburn@redhat.com" <dmilburn@redhat.com>, "olof@lixom.net" <olof@lixom.net>, Tuan Phan <tphan@apm.com>, "linux-arm-kernel@lists.infradead.org" <linux-arm-kernel@lists.infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, Jan 15, 2014 at 07:11:48AM +0000, Loc Ho wrote:
> Signed-off-by: Loc Ho <lho@apm.com>
> Signed-off-by: Tuan Phan <tphan@apm.com>
> Signed-off-by: Suman Tripathi <stripathi@apm.com>
> ---
>  .../devicetree/bindings/ata/apm-xgene.txt          |   68 ++++++++++++++++++++
>  1 files changed, 68 insertions(+), 0 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ata/apm-xgene.txt
> 
> diff --git a/Documentation/devicetree/bindings/ata/apm-xgene.txt b/Documentation/devicetree/bindings/ata/apm-xgene.txt
> new file mode 100644
> index 0000000..3d1421a
> --- /dev/null
> +++ b/Documentation/devicetree/bindings/ata/apm-xgene.txt
> @@ -0,0 +1,68 @@
> +* APM X-Gene 6.0 Gb/s SATA host controller nodes
> +
> +SATA host controller nodes are defined to describe on-chip Serial ATA
> +controllers. Each SATA controller (pair of ports) have its own node.
> +
> +Required properties:
> +- compatible		: Shall be "apm,xgene-ahci-sgmii" if mux'ed with SGMII
> +			  or "apm,xgene-ahci-pcie" if mux'ed with PCIe.
> +- reg			: First memory resource shall be the AHCI memory
> +			  resource.
> +			  Second memory resource shall be the host controller
> +			  memory resource.
> +- interrupts		: Interrupt mapping for SATA host controller IRQ.

s/Interrupt-mapping/interrupt-specifier/

> +- clocks		: Reference to the clock entry.
> +- phys			: PHY reference with parameter 0.

The specific value of the phy-specifier shouldn't matter to this
binding. What should matter is what it logically corresponds to.

> +- phy-names		: Name of the PHY. Shall be "sata-6g".

Could you define phys in terms of phy-names please? It makes the
relationship clearer:

- phys: a list of phandles + phy-sciefiers, one for each entry in
  phy-names

- phy-names: Should contain:
  * "sata-6g" for the SATA PHY <notes about requirements go here>

Cheers,
Mark.
