From: Kyuho Choi <chlrbgh0@gmail.com>
Subject: Re: [PATCH 4.19 009/118] scsi: ufs: Fix hynix ufs bug with quirk on
 hi36xx SoC
Date: Mon, 17 Dec 2018 17:24:38 +0900
Message-ID: <CAP2JTQJyOad9Tbc8t_K-Xp8q5EpdgeQbaDfTAJgkYUWWpw=TRg@mail.gmail.com>
References: <20181211151644.216668863@linuxfoundation.org> <20181211151644.599741132@linuxfoundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20181211151644.599741132@linuxfoundation.org>
Sender: stable-owner@vger.kernel.org
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org, Vinayak Holikatti <vinholikatti@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, Wei Li <liwei213@huawei.com>, Dmitry Shmidt <dimitrysh@google.com>, John Stultz <john.stultz@linaro.org>, Sasha Levin <sashal@kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi Greg,

About Hinyx's "hB8aL1" ufs device. For support Kirin AP series, they
are need to apply below VS_DebugSaveConfigTime expand patch.

On 12/12/18, Greg Kroah-Hartman <gregkh@linuxfoundation.org> wrote:
> 4.19-stable review patch.  If anyone has any objections, please let me
> know.
>
> ------------------
>
> [ Upstream commit 8e4829c6f7470722c1f5a1dc5769ebe09ef036d6 ]
>
> Hynix ufs has deviations on hi36xx platform which will result in ufs bursts
> transfer failures.
>
> To fix the problem, the Hynix device must set the register
> VS_DebugSaveConfigTime to 0x10, which will set time reference for
> SaveConfigTime is 250 ns. The time reference for SaveConfigTime is 40 ns by
> default.
>
> This patch is necessary to boot on HiKey960 boards that use Hynix UFS chips
> (H28U62301AMR model: hB8aL1).
>
> Cc: Vinayak Holikatti <vinholikatti@gmail.com>
> Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: linux-scsi@vger.kernel.org
> Signed-off-by: Wei Li <liwei213@huawei.com>
> Signed-off-by: Dmitry Shmidt <dimitrysh@google.com>
> [jstultz: Forward ported from older code, slight tweak to commit message]
> Signed-off-by: John Stultz <john.stultz@linaro.org>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> Signed-off-by: Sasha Levin <sashal@kernel.org>
> ---
>  drivers/scsi/ufs/ufs-hisi.c   | 9 +++++++++
>  drivers/scsi/ufs/ufs_quirks.h | 6 ++++++
>  drivers/scsi/ufs/ufshcd.c     | 2 ++
>  3 files changed, 17 insertions(+)
>
> diff --git a/drivers/scsi/ufs/ufs-hisi.c b/drivers/scsi/ufs/ufs-hisi.c
> index 46df707e6f2c..452e19f8fb47 100644
> --- a/drivers/scsi/ufs/ufs-hisi.c
> +++ b/drivers/scsi/ufs/ufs-hisi.c
> @@ -20,6 +20,7 @@
>  #include "unipro.h"
>  #include "ufs-hisi.h"
>  #include "ufshci.h"
> +#include "ufs_quirks.h"
>
>  static int ufs_hisi_check_hibern8(struct ufs_hba *hba)
>  {
> @@ -390,6 +391,14 @@ static void ufs_hisi_set_dev_cap(struct
> ufs_hisi_dev_params *hisi_param)
>
>  static void ufs_hisi_pwr_change_pre_change(struct ufs_hba *hba)
>  {
> +	if (hba->dev_quirks & UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME) {
> +		pr_info("ufs flash device must set VS_DebugSaveConfigTime 0x10\n");
> +		/* VS_DebugSaveConfigTime */
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(0xD0A0), 0x10);
> +		/* sync length */
> +		ufshcd_dme_set(hba, UIC_ARG_MIB(0x1556), 0x48);
> +	}
> +
>  	/* update */
>  	ufshcd_dme_set(hba, UIC_ARG_MIB(0x15A8), 0x1);
>  	/* PA_TxSkip */
> diff --git a/drivers/scsi/ufs/ufs_quirks.h b/drivers/scsi/ufs/ufs_quirks.h
> index 71f73d1d1ad1..5d2dfdb41a6f 100644
> --- a/drivers/scsi/ufs/ufs_quirks.h
> +++ b/drivers/scsi/ufs/ufs_quirks.h
> @@ -131,4 +131,10 @@ struct ufs_dev_fix {
>   */
>  #define UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME	(1 << 8)
>
> +/*
> + * Some UFS devices require VS_DebugSaveConfigTime is 0x10,
> + * enabling this quirk ensure this.
> + */
> +#define UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME	(1 << 9)
> +
>  #endif /* UFS_QUIRKS_H_ */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> index 54074dd483a7..0b81d9d03357 100644
> --- a/drivers/scsi/ufs/ufshcd.c
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -230,6 +230,8 @@ static struct ufs_dev_fix ufs_fixups[] = {
>  	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL, UFS_DEVICE_NO_VCCQ),
>  	UFS_FIX(UFS_VENDOR_SKHYNIX, UFS_ANY_MODEL,
>  		UFS_DEVICE_QUIRK_HOST_PA_SAVECONFIGTIME),
> +	UFS_FIX(UFS_VENDOR_SKHYNIX, "hB8aL1" /*H28U62301AMR*/,
> +		UFS_DEVICE_QUIRK_HOST_VS_DEBUGSAVECONFIGTIME),
>
>  	END_FIX
>  };
> --
> 2.19.1
>
>
>
>
