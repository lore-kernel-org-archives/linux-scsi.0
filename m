From: Avri Altman <Avri.Altman@wdc.com>
Subject: RE: [PATCH V15 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Tue, 16 Oct 2018 09:43:22 +0000
Message-ID: <SN6PR04MB4925BBEF6D9360B64DCF7F88FCFE0@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1539680382-31136-1-git-send-email-sayalil@codeaurora.org>
 <1539680382-31136-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1539680382-31136-3-git-send-email-sayalil@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

> +++ b/drivers/scsi/ufs/Makefile
> @@ -4,6 +4,8 @@ obj-$(CONFIG_SCSI_UFS_DWC_TC_PCI) +=3D tc-dwc-g210-
> pci.o ufshcd-dwc.o tc-dwc-g210.
>  obj-$(CONFIG_SCSI_UFS_DWC_TC_PLATFORM) +=3D tc-dwc-g210-pltfrm.o
> ufshcd-dwc.o tc-dwc-g210.o
>  obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
>  obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
> -ufshcd-core-objs :=3D ufshcd.o ufs-sysfs.o
> +ufshcd-core-objs-y :=3D ufshcd.o ufs-sysfs.o
> +ufshcd-core-objs-$(CONFIG_SCSI_UFS_PROVISION) +=3D ufs-configfs.o
> +ufshcd-core-objs :=3D $(ufshcd-core-objs-y)
This will work, but I think it should be:
ufshcd-core-y                          +=3D ufshcd.o ufs-sysfs.o
ufshcd-core-$( CONFIG_SCSI_UFS_PROVISION) +=3D ufs-configfs.o

Also, you may want to rebase your patches with Martin's 4.20/scsi-queue

Thanks,
Avri
