From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v17 1/4] arm64: Add APM X-Gene SoC 15Gbps Multi-purpose
 PHY DTS entries
Date: Fri, 14 Mar 2014 12:08:53 +0100
Message-ID: <201403141208.53772.arnd@arndb.de>
References: <1394655573-32645-1-git-send-email-lho@apm.com>
 <1394655573-32645-2-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-arm-kernel-bounces+linux-arm-kernel=m.gmane.org@lists.infradead.org>
In-Reply-To: <1394655573-32645-2-git-send-email-lho@apm.com>
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
Cc: devicetree@vger.kernel.org, Suman Tripathi <stripathi@apm.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, jcm@redhat.com, patches@apm.com, tj@kernel.org, ddutile@redhat.com, olof@lixom.net, Tuan Phan <tphan@apm.com>, linux-arm-kernel@lists.infradead.org
List-Id: linux-scsi@vger.kernel.org

On Wednesday 12 March 2014, Loc Ho wrote:
> +                       sataphy1clk: sataphy1clk@1f21c000 {
> +                               compatible = "apm,xgene-device-clock";
> +                               #clock-cells = <1>;
> +                               clocks = <&socplldiv2 0>;
> +                               clock-names = "socplldiv2";

I think we still need to resolve the question regarding the
"clock-names" properties in your clock provider nodes. I've commented
on this in the past, since it shows up in all the x-gene drivers,
but it's very inconsistent.

The binding says

+- clock-names : shall be the name of the device clock. If missing, use the
+                device name.

which to me makes no sense. What will "use the device name", and
which device? Your clock driver doesn't actually use these strings,
so could you please fix the binding to remove this, and stop adding
the strings to any clock nodes?

Since nothing ever used these and they are marked "optional"
in the binding, I don't think there is a chance of breaking
anything by changing it now.

	Arnd
