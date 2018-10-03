From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH V14 2/2] scsi: ufs: Add configfs support for UFS provisioning
Date: Wed, 3 Oct 2018 11:01:52 -0700
Message-ID: <CAE=gft6dLW5zzrOg470kS=O8rMgPr02Nb4NL9pEtpymc83ms+w@mail.gmail.com>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org> <1537770516-28410-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537770516-28410-3-git-send-email-sayalil@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
To: sayali <sayalil@codeaurora.org>
Cc: subhashj@codeaurora.org, cang@codeaurora.org, vivek.gautam@codeaurora.org, Rajendra Nayak <rnayak@codeaurora.org>, Vinayak Holikatti <vinholikatti@gmail.com>, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, asutoshd@codeaurora.org, riteshh@codeaurora.org, stummala@codeaurora.org, adrian.hunter@intel.com, Joel Becker <jlbec@evilplan.org>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Sep 23, 2018 at 11:29 PM Sayali Lokhande <sayalil@codeaurora.org> wrote:
>
> This patch adds configfs support to provision UFS device at
> runtime. This feature can be primarily useful in factory or
> assembly line as some devices may be required to be configured
> multiple times during initial system development phase.
> Configuration Descriptors can be written multiple times until
> bConfigDescrLock attribute is zero.
>
> Configuration descriptor buffer consists of Device and Unit
> descriptor configurable parameters which are parsed from vendor
> specific provisioning file and then passed via configfs node at
> runtime to provision ufs device.
> CONFIG_CONFIGFS_FS and CONFIG_SCSI_UFS_PROVISION needs to be enabled
> for using this feature.
>
> Usage:
> 1) To read current configuration descriptor with index X
>    (where index X can be 0/1/2/3) :
>    cat /config/<device_name>/ufs_config_desc_X
>
> 2) To write configuration descriptor with index X :
>    echo <config_desc_buf> > /config/<device_name>/ufs_config_desc_X
>
> Signed-off-by: Sayali Lokhande <sayalil@codeaurora.org>
> ---
>  Documentation/ABI/testing/configfs-driver-ufs |  12 ++
>  drivers/scsi/ufs/Kconfig                      |  10 ++
>  drivers/scsi/ufs/Makefile                     |   1 +
>  drivers/scsi/ufs/ufs-configfs.c               | 237 ++++++++++++++++++++++++++
>  drivers/scsi/ufs/ufshcd.c                     |   3 +-
>  drivers/scsi/ufs/ufshcd.h                     |  18 ++
>  6 files changed, 280 insertions(+), 1 deletion(-)
>  create mode 100644 Documentation/ABI/testing/configfs-driver-ufs
>  create mode 100644 drivers/scsi/ufs/ufs-configfs.c
>
> diff --git a/Documentation/ABI/testing/configfs-driver-ufs b/Documentation/ABI/testing/configfs-driver-ufs
> new file mode 100644
> index 0000000..6743ea9
> --- /dev/null
> +++ b/Documentation/ABI/testing/configfs-driver-ufs
> @@ -0,0 +1,12 @@
> +What:          /config/*/ufs_config_desc_X
> +Date:          Jun 2018
> +KernelVersion: 4.20
> +Description:
> +               This file shows bytes of the current ufs configuration descriptor
> +               with index X (where X = 0/1/2/3) set in device. This can be used to
> +               provision ufs device if bConfigDescrLock is 0.
> +               For more details, refer 14.1.6.3 Configuration Descriptor and
> +               table 14-12 - Unit Descriptor configurable parameters from specs for
> +               description and format of each configuration descriptor parameter.
> +               Parameters of Configuration descriptor buffer for respective index
> +               needs to be passed as bytes in space separated format.
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> index e27b4d4..6e7ff35 100644
> --- a/drivers/scsi/ufs/Kconfig
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -100,3 +100,13 @@ config SCSI_UFS_QCOM
>
>           Select this if you have UFS controller on QCOM chipset.
>           If unsure, say N.
> +
> +config SCSI_UFS_PROVISION
> +       bool "Runtime UFS Provisioning support"
> +       depends on SCSI_UFSHCD && CONFIGFS_FS
> +       help
> +         This enables runtime UFS provisioning support. This can be used
> +         primarily during assembly line as some devices may be required to
> +         be configured multiple times during initial development phase.
> +
> +         If unsure, say N.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> index 918f579..09880b9 100644
> --- a/drivers/scsi/ufs/Makefile
> +++ b/drivers/scsi/ufs/Makefile
> @@ -5,5 +5,6 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) += tc-dwc-g210-pltfrm.o ufshcd-dwc.o tc-d
>  obj-$(CONFIG_SCSI_UFS_QCOM) += ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) += ufshcd-core.o
>  ufshcd-core-objs := ufshcd.o ufs-sysfs.o
> +obj-$(CONFIG_SCSI_UFS_PROVISION) += ufs-configfs.o

Hi Sayali,
Can you try both of your patches with "make allmodconfig". There seem
to be a few issues compiling in that configuration. Also, as it stands
this file is either not compiled in, or baked into the kernel, where
it really should go into the driver. Check out the patch below for how
Guenter patched things up in our tree:

https://chromium-review.googlesource.com/c/chromiumos/third_party/kernel/+/1255524
