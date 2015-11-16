From: Alim Akhtar <alim.akhtar@gmail.com>
Subject: Re: [PATCH v5 00/11] exynos-ufs: add support for Exynos
Date: Mon, 16 Nov 2015 06:31:09 +0530
Message-ID: <CAGOxZ51jKb_UYG-UmsN17zpAwR92KXt0KjGq8gCotmsvCsfHkA@mail.gmail.com>
References: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1447046787-480-1-git-send-email-alim.akhtar@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Alim Akhtar <alim.akhtar@samsung.com>
Cc: linux-scsi@vger.kernel.org, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@odin.com>, vinayak holikatti <vinholikatti@gmail.com>, Vivek Gautam <gautam.vivek@samsung.com>, Seungwon Jeon <essuuj@gmail.com>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, kishon <kishon@ti.com>
List-Id: linux-scsi@vger.kernel.org

Hi Kishon,

Any more concern on the PHY part of this series?

Thanks!

On Mon, Nov 9, 2015 at 10:56 AM, Alim Akhtar <alim.akhtar@samsung.com> wrote:
> This patch-set introduces UFS (Universal Flash Storage) host support
> for Samsung Exynos SoC. Mostly, it consists of UFS PHY and host specific driver.
> And it also contains some quirks handling for Exynos.
>
> NOTE: ** This series has a dependency on [4]. **
>
> -Changes since v4:
> * Removed platform specific PHY ops as suggested by Kishon
> * Rebased on the top of Yaniv Gardi's work [4]
> * make use of newly introduce ufshcd_{get,set}_variant
> * other small changes and improvements.
> * rebased on the top of linux next-20151109
>
> -Changes since v3:
> * Fixed compilation warrings as reported by "Kbuild Test Robot"[5].
> * Restructure the driver to make it as a platform driver, rebased on top of [4].
> * Addressed review comments from Arnd Bergmann[5].
> * Other misc changes and improvements.
>
> -Changes since v2:
> * Addressed review comments from Kishon[1] and Rob Herring [2]
> * Splited ufs dt binding documetation from ufs driver patch
>
> -Changes since v1:
> * Addressed review comments from Alexey[3] and various review comments from Amit.
> * Updated email id of Seungwon as his samsung id is void now.
> * Added ufs platform data
>
> [1]-> https://lkml.org/lkml/2015/9/18/29
> [2]-> https://lkml.org/lkml/2015/9/21/668
> [3]-> https://lkml.org/lkml/2015/8/23/124
> [4]-> https://lkml.org/lkml/2015/10/28/271
> [5]-> https://lkml.org/lkml/2015/10/1/402
>
> This patch set is tested on exynos7-espresso board.
>
>
> Alim Akhtar (1):
>   Documentation: samsung-phy: Add dt bindings for UFS
>
> Seungwon Jeon (10):
>   phy: exynos-ufs: add UFS PHY driver for EXYNOS SoC
>   scsi: ufs: add quirk to contain unconformable utrd field
>   scsi: ufs: add quirk to fix mishandling utrlclr/utmrlclr
>   scsi: ufs: add quirk not to allow reset of interrupt aggregation
>   scsi: ufs: add quirk to enable host controller without hce
>   scsi: ufs: add specific callback for nexus type
>   scsi: ufs: add add specific callback for hibern8
>   scsi: ufs: make ufshcd_config_pwr_mode of non-static func
>   Documentation: devicetree: ufs: Add DT bindings for exynos UFS host
>     controller
>   scsi: ufs-exynos: add UFS host support for Exynos SoCs
>
>  .../devicetree/bindings/phy/samsung-phy.txt        |   22 +
>  .../devicetree/bindings/ufs/ufs-exynos.txt         |  104 ++
>  drivers/phy/Kconfig                                |    7 +
>  drivers/phy/Makefile                               |    1 +
>  drivers/phy/phy-exynos-ufs.c                       |  241 ++++
>  drivers/phy/phy-exynos-ufs.h                       |   85 ++
>  drivers/phy/phy-exynos7-ufs.h                      |   89 ++
>  drivers/scsi/ufs/Kconfig                           |   12 +
>  drivers/scsi/ufs/Makefile                          |    1 +
>  drivers/scsi/ufs/ufs-exynos-hw.c                   |  131 ++
>  drivers/scsi/ufs/ufs-exynos-hw.h                   |   43 +
>  drivers/scsi/ufs/ufs-exynos.c                      | 1304 ++++++++++++++++++++
>  drivers/scsi/ufs/ufs-exynos.h                      |  247 ++++
>  drivers/scsi/ufs/ufshcd.c                          |  168 ++-
>  drivers/scsi/ufs/ufshcd.h                          |   54 +
>  drivers/scsi/ufs/ufshci.h                          |   26 +-
>  drivers/scsi/ufs/unipro.h                          |   47 +
>  include/linux/phy/phy-exynos-ufs.h                 |   85 ++
>  18 files changed, 2647 insertions(+), 20 deletions(-)
>  create mode 100644 Documentation/devicetree/bindings/ufs/ufs-exynos.txt
>  create mode 100644 drivers/phy/phy-exynos-ufs.c
>  create mode 100644 drivers/phy/phy-exynos-ufs.h
>  create mode 100644 drivers/phy/phy-exynos7-ufs.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos-hw.h
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.c
>  create mode 100644 drivers/scsi/ufs/ufs-exynos.h
>  create mode 100644 include/linux/phy/phy-exynos-ufs.h
>
> --
> 1.7.10.4
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Regards,
Alim
