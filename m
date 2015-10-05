From: Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH v3 13/13] scsi: ufs: Add exynos ufs platform data
Date: Mon, 05 Oct 2015 11:06:59 +0200
Message-ID: <14885029.SsJgQkuPcG@wuerfel>
References: <201510011845.GN7Kisc4%fengguang.wu@intel.com> <1790578.NZeHVGuJeN@wuerfel> <56123165.2060500@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <56123165.2060500@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: kbuild test robot <lkp@intel.com>, kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, JBottomley@odin.com, vinholikatti@gmail.com, amit.daniel@samsung.com, essuuj@gmail.com, devicetree@vger.kernel.org, Rob Herring <robh@kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Monday 05 October 2015 13:44:29 Alim Akhtar wrote:
> CCing Rob Herring,
> 
> Hi Arnd,
> 
> On 10/01/2015 04:59 PM, Arnd Bergmann wrote:
> > On Thursday 01 October 2015 18:46:34 kbuild test robot wrote:
> >> [auto build test results on v4.3-rc3 -- if it's inappropriate base, please ignore]
> >>
> >> config: x86_64-allmodconfig (attached as .config)
> >> reproduce:
> >>          git checkout 6e153e3bf7c68b019e987c5a0ffadebd9c7d4fbb
> >>          # save the attached .config to linux build tree
> >>          make ARCH=x86_64
> >>
> >> All error/warnings (new ones prefixed by >>):
> >>
> >>>> ERROR: "ufs_hba_exynos_ops" [drivers/scsi/ufs/ufshcd-pltfrm.ko] undefined!
> >>
> >>
> >
> > Ah, this seems to be a case of layering violation. It would be best to
> > restructure the code so that the exynos driver registers a platform_driver
> > by itself for the respective DT compatible string, and then calls
> > into the common code from its probe function, rather than having the
> > generic driver know about the specific backends.
> >
> > That approach will also make the generic driver more scalable as we
> > add further chip-specific variations, and matches what we do in other
> > drivers.
> >
> 
> Looks like some discussions on ufs variant driver probe method happened 
> here [1] few months back.
> [1]-> https://lkml.org/lkml/2015/6/3/180

Hmm, too bad we didn't catch it then, it's much more work to fix now.

> And since ufshcd-pltfrm is already a platform_driver, so I just add a 
> platform data for the variant driver.
> I should have add a IS_ENABLED for it to avoid the compilation error for 
> other ARCH.

I still think we should do this properly here. From looking at the qcom
driver, it seems to me that the integration there was done in a way that
could not work at all:

$ git grep -w ufs_hba_qcom_vops
drivers/scsi/ufs/ufs-qcom.c: * struct ufs_hba_qcom_vops - UFS QCOM specific variant operations
drivers/scsi/ufs/ufs-qcom.c:static const struct ufs_hba_variant_ops ufs_hba_qcom_vops = {
drivers/scsi/ufs/ufs-qcom.c:EXPORT_SYMBOL(ufs_hba_qcom_vops);

In short, nothing references the ufs_hba_qcom_vops symbol, so the driver
is never used, and if it did, it would not work for ufs being built-in
beause the symbol is marked 'static'.

Please do the samsung front-end as I suggested and send a patch to
convert the qcom front-end the same way. No need to test that one
as the current approach doesn't work.

	Arnd
