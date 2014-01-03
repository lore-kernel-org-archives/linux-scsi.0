From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v7 4/4] arm64: Add APM X-Gene SoC SATA host controller DTS entries
Date: Fri, 3 Jan 2014 16:33:17 +0100
Message-ID: <201401031633.18110.arnd@arndb.de>
References: <1388708539-333-1-git-send-email-lho@apm.com> <1388708539-333-4-git-send-email-lho@apm.com> <1388708539-333-5-git-send-email-lho@apm.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1388708539-333-5-git-send-email-lho@apm.com>
Sender: linux-ide-owner@vger.kernel.org
To: Loc Ho <lho@apm.com>
Cc: olof@lixom.net, tj@kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org, jcm@redhat.com, patches@apm.com, Tuan Phan <tphan@apm.com>, Suman Tripathi <stripathi@apm.com>
List-Id: linux-scsi@vger.kernel.org

On Friday 03 January 2014, Loc Ho wrote:
> +                       sata23clk: sata23clk@1f22c000 {
> +                               compatible = "apm,xgene-device-clock";
> +                               #clock-cells = <1>;
> +                               clocks = <&socplldiv2 0>;
> +                               clock-names = "sata23clk";

> +                       };
> +
> +                       sata45clk: sata45clk@1f23c000 {
> +                               compatible = "apm,xgene-device-clock";
> +                               #clock-cells = <1>;
> +                               clocks = <&socplldiv2 0>;
> +                               clock-names = "sata45clk";

Something is wrong here: You have two devices with the same "compatible"
string but using different "clock-names" strings. The binding document
lists this as an optional property with the description  "shall be
the name of the device clock. If missing, use the device name", which
doesn't seem to make any sense.

Please fix the binding and the existing users of this, and don't introduce
any more broken instances. Since each device clock is documented to
have only one parent anyway, please just make it an anonymous clock.

	Arnd
