Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B646A31593
	for <linux-scsi@vger.kernel.org>; Wed,  6 Dec 2023 11:17:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="p5en7/pP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD8CEC433C8;
	Wed,  6 Dec 2023 11:17:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1701861436;
	bh=gvY0LwkFuS7ixR5SlQYIdlUtxHf1OCuXpDZAqJh4fmc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=p5en7/pPxTpa/muofj345pgVWwgX/blV0jTQ7LyS59u2rTgS5SK6CswVed1Wn+duv
	 6hm3rncGMzMbizSPkIaI//TRd5HubPGg7rtAYIBADEMhilreLVe9U4I6YxJKn4tirr
	 am4FGYvaTTVF5MDJ6hwK3D5Mq+DAetRpxbD6tH8xihU5Hil0O3pBXcNSR/ejwsfUuA
	 5zAx4TecjPKotwFVm/WqR+GQ01ERjRNnY5UwClyr8kufctDG29GCHcN9GG3jsA3SRz
	 TuVL3zZesz7o1oEnstPzxBZYn7BxHX4BnNRvZDKepp2huXVUOUEEnQyrx4fKkVga7O
	 XlkVFDaaZvAlQ==
Date: Wed, 6 Dec 2023 16:47:07 +0530
From: Manivannan Sadhasivam <mani@kernel.org>
To: Nitin Rawat <quic_nitirawa@quicinc.com>
Cc: Manivannan Sadhasivam <mani@kernel.org>,
	"James E.J. Bottomley" <jejb@linux.ibm.com>,
	"Martin K. Petersen" <martin.petersen@oracle.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-arm-kernel@lists.infradead.org,
	linux-mediatek@lists.infradead.org, quic_cang@quicinc.com,
	Manish Pandey <quic_mapa@quicinc.com>
Subject: Re: [PATCH V1] scsi: ufs: core: store min and max clk freq from OPP
 table
Message-ID: <20231206111707.GA12802@thinkpad>
References: <20231206053628.32169-1-quic_nitirawa@quicinc.com>
 <20231206075447.GA4954@thinkpad>
 <f30d3c21-f355-d535-480b-2fd36167bcfd@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <f30d3c21-f355-d535-480b-2fd36167bcfd@quicinc.com>

On Wed, Dec 06, 2023 at 04:35:24PM +0530, Nitin Rawat wrote:
> 
> 
> On 12/6/2023 1:24 PM, Manivannan Sadhasivam wrote:
> > On Wed, Dec 06, 2023 at 11:06:28AM +0530, Nitin Rawat wrote:
> > > OPP support will make use of OPP table in device tree and removes
> > > freq-table-hz property from device tree.
> > > 
> > > With OPP enabled in devicetree, clki->min_freq and clki->maxfreq
> > > currently is not getting updated and the value is set to 0.
> > > 
> > > Soc vendors like qcom, mediatek uses clki->minfreq and clki->maxfreq
> > > in vendor specific file. These frequencies values are used to update
> > > vendor specific configurations. Since the value is 0, it is causing
> > > functional issue.
> > 
> > How about,
> > 
> > "OPP support added by commit 72208ebe181e ("scsi: ufs: core: Add support
> > for parsing OPP") doesn't update the min_freq and max_freq of each clocks
> > in 'struct ufs_clk_info'.
> > 
> > But these values are used by the vendor host drivers internally for controller
> > configuration. When the OPP support is enabled in devicetree, these values will
> > be 0, causing boot issues on the respective platforms.
> > 
> > So let's parse the min_freq and max_freq of all clocks while parsing the OPP
> > table."
> > 
> > > 
> > > Add code to store the min and max ufs clk frequency from OPP table.
> 
> Sure. Will update in next patchset.
> 
> > > 
> > > Fixes: 72208ebe181e ("scsi: ufs: core: Add support for parsing OPP")
> > > Co-developed-by: Manish Pandey <quic_mapa@quicinc.com>
> > > Signed-off-by: Manish Pandey <quic_mapa@quicinc.com>
> > > Signed-off-by: Nitin Rawat <quic_nitirawa@quicinc.com>
> > > ---
> > >   drivers/ufs/host/ufshcd-pltfrm.c | 56 ++++++++++++++++++++++++++++++++
> > >   1 file changed, 56 insertions(+)
> > > 
> > > diff --git a/drivers/ufs/host/ufshcd-pltfrm.c b/drivers/ufs/host/ufshcd-pltfrm.c
> > > index da2558e274b4..12fa6f7d6a97 100644
> > > --- a/drivers/ufs/host/ufshcd-pltfrm.c
> > > +++ b/drivers/ufs/host/ufshcd-pltfrm.c
> > > @@ -13,6 +13,7 @@
> > >   #include <linux/pm_opp.h>
> > >   #include <linux/pm_runtime.h>
> > >   #include <linux/of.h>
> > > +#include <linux/clk.h>
> > 
> > Sort includes alphabetically.
> 
> Sure. Will update in next patchset
> 
> > 
> > > 
> > >   #include <ufs/ufshcd.h>
> > >   #include "ufshcd-pltfrm.h"
> > > @@ -213,6 +214,55 @@ static void ufshcd_init_lanes_per_dir(struct ufs_hba *hba)
> > >   	}
> > >   }
> > > 
> > > +/**
> > > + * ufshcd_config_min_max_clk_freq - update min and max freq
> > 
> > "ufshcd_parse_clock_min_max_freq - Parse MIN and MAX frequencies of clocks"
> > 
> > > + * @hba: per adapter instance
> > > + *
> > > + * This function store min and max freq for all the clocks.
> > > + *
> > 
> > "This function parses MIN and MAX frequencies of all clocks required by the
> > vendor host drivers."
> > 
> > > + * Returns 0 for success and non-zero for failure
> > > + */
> > > +static int ufshcd_config_min_max_clk_freq(struct ufs_hba *hba)
> > > +{
> > > +	struct list_head *head = &hba->clk_list_head;
> > > +	struct dev_pm_opp *opp;
> > > +	struct ufs_clk_info *clki;
> > 
> > Please maintain reverse Xmas tree order. It's not a rule for this driver, but my
> > own preference.
> > 
> > > +	unsigned long freq;
> > > +	u8 idx = 0;
> > > +	int ret;
> > 
> > This won't be needed if all the return values are directly returned as I shared
> > below.
> 
> 
> Will Addressed all ret comments in next patchset.
> > 
> > > +
> > > +	list_for_each_entry(clki, head, list) {
> > > +		if (!clki->name)
> > > +			continue;
> > > +
> > > +		clki->clk = devm_clk_get(hba->dev, clki->name);
> > > +		if (!IS_ERR_OR_NULL(clki->clk)) {
> > 
> > This function won't return NULL, so IS_ERR() is sufficient.
> > 
> > > +			/* Find Max Freq */
> > > +			freq = ULONG_MAX;
> > > +			opp = dev_pm_opp_find_freq_floor_indexed(hba->dev, &freq, idx);
> > 
> > Use idx++ and get rid of the increment at the end of the 'if' condition.
> 
> If we increment idx++ here, dev_pm_opp_find_freq_ceil_indexed will use
> incremented idx which is not correct. Hence i added at end after both the
> call.

Ah, right. Please increment it in dev_pm_opp_find_freq_ceil_indexed() instead.

- Mani

-- 
மணிவண்ணன் சதாசிவம்
