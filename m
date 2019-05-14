From: Ulf Hansson <ulf.hansson@linaro.org>
Subject: Re: [RFC v2 08/11] arm64: dts: sdm845: Add ufs opps and power-domains
Date: Tue, 14 May 2019 09:53:34 +0200
Message-ID: <CAPDyKFppirfM7B9TB=jZzo67E=rdMnfVKEjdv0wn1zBAUoY_HA@mail.gmail.com>
References: <20190320094918.20234-1-rnayak@codeaurora.org> <20190320094918.20234-9-rnayak@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20190320094918.20234-9-rnayak@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Rajendra Nayak <rnayak@codeaurora.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-arm-msm <linux-arm-msm@vger.kernel.org>, Linux PM <linux-pm@vger.kernel.org>, linux-serial@vger.kernel.org, linux-spi@vger.kernel.org, dri-devel <dri-devel@lists.freedesktop.org>, linux-scsi <linux-scsi@vger.kernel.org>, Stephen Boyd <swboyd@chromium.org>, Viresh Kumar <viresh.kumar@linaro.org>, Doug Anderson <dianders@chromium.org>, "Rafael J. Wysocki" <rafael@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 20 Mar 2019 at 10:50, Rajendra Nayak <rnayak@codeaurora.org> wrote:
>
> Add the additional power domain and the OPP table for ufs on sdm845
> so the driver can set the appropriate performance state of the
> power domain while setting the clock rate.
>
> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> ---
>  arch/arm64/boot/dts/qcom/sdm845.dtsi | 20 +++++++++++++++++++-
>  1 file changed, 19 insertions(+), 1 deletion(-)
>
> diff --git a/arch/arm64/boot/dts/qcom/sdm845.dtsi b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> index 027ffe6e93e8..a3af4a1757b4 100644
> --- a/arch/arm64/boot/dts/qcom/sdm845.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sdm845.dtsi
> @@ -1140,6 +1140,21 @@
>                         };
>                 };
>
> +               ufs_opp_table: ufs-opp-table {
> +                       compatible = "operating-points-v2";
> +
> +                       opp-50000000 {
> +                               opp-hz = /bits/ 64 <50000000>;
> +                               required-opps = <&rpmhpd_opp_min_svs>;
> +                       };
> +
> +                       opp-200000000 {
> +                               opp-hz = /bits/ 64 <200000000>;
> +                               required-opps = <&rpmhpd_opp_nom>;
> +
> +                       };
> +               };
> +
>                 ufs_mem_hc: ufshc@1d84000 {
>                         compatible = "qcom,sdm845-ufshc", "qcom,ufshc",
>                                      "jedec,ufs-2.0";
> @@ -1148,7 +1163,7 @@
>                         phys = <&ufs_mem_phy_lanes>;
>                         phy-names = "ufsphy";
>                         lanes-per-direction = <2>;
> -                       power-domains = <&gcc UFS_PHY_GDSC>;
> +                       power-domains = <&gcc UFS_PHY_GDSC>, <&rpmhpd SDM845_CX>;

You probably want to use "power-domain-names" as well.

[...]

Kind regards
Uffe
