From: Avri Altman <Avri.Altman@wdc.com>
Subject: Re: [PATCH V14 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Mon, 24 Sep 2018 10:03:29 +0000
Message-ID: <SN6PR04MB4925D198F7AE8961254F43C9FC170@SN6PR04MB4925.namprd04.prod.outlook.com>
References: <1537770516-28410-1-git-send-email-sayalil@codeaurora.org>,<1537770516-28410-3-git-send-email-sayalil@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1537770516-28410-3-git-send-email-sayalil@codeaurora.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

> obj-$(CONFIG_SCSI_UFS_QCOM) +=3D ufs-qcom.o
>obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd-core.o
>ufshcd-core-objs :=3D ufshcd.o ufs-sysfs.o
>+obj-$(CONFIG_SCSI_UFS_PROVISION) +=3D ufs-configfs.o
Isn't ufs-configfs should be part of ufshcd-core? like ufs-sysfs ?


>+static ssize_t ufs_config_desc_show(struct config_item *item, char *buf,
>+                                   u8 index)
>+{
The read part already exist in ufs-sysfs.


>+ssize_t ufshcd_desc_configfs_store(struct config_item *item, const char *=
buf,
>+                                  size_t count, u8 index)
>+{


>+
>+       /*
>+        * First read the current configuration descriptor
>+        * and then update with user provided parameters
>+        */
if originally only lun0 was configured, and you want to configure a new set=
 of luns -=20
luns 8 to 15 (config index 0x1) - won't the read fail in that case?

Thanks,
Avri=
