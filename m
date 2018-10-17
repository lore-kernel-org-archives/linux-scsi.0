From: "Bean Huo (beanhuo)" <beanhuo@micron.com>
Subject: RE: [PATCH V15 2/2] scsi: ufs: Add configfs support for UFS
 provisioning
Date: Wed, 17 Oct 2018 07:56:02 +0000
Message-ID: <BYAPR08MB4533120DFDB3803DB8B2E8B8DBFF0@BYAPR08MB4533.namprd08.prod.outlook.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: Sayali Lokhande <sayalil@codeaurora.org>, "subhashj@codeaurora.org" <subhashj@codeaurora.org>, "cang@codeaurora.org" <cang@codeaurora.org>, "vivek.gautam@codeaurora.org" <vivek.gautam@codeaurora.org>, "rnayak@codeaurora.org" <rnayak@codeaurora.org>, "vinholikatti@gmail.com" <vinholikatti@gmail.com>, "jejb@linux.vnet.ibm.com" <jejb@linux.vnet.ibm.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>, "evgreen@chromium.org" <evgreen@chromium.org>, "riteshh@codeaurora.org" <riteshh@codeaurora.org>
Cc: "stummala@codeaurora.org" <stummala@codeaurora.org>, "adrian.hunter@intel.com" <adrian.hunter@intel.com>, "jlbec@evilplan.org" <jlbec@evilplan.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi, Sayali

>Subject: [EXT] [PATCH V15 2/2] scsi: ufs: Add configfs support for UFS
>provisioning
>
>This patch adds configfs support to provision UFS device at runtime. This
>feature can be primarily useful in factory or assembly line as some device=
s
>may be required to be configured multiple times during initial system
>development phase.
>Configuration Descriptors can be written multiple times until
>bConfigDescrLock attribute is zero.
>
>Configuration descriptor buffer consists of Device and Unit descriptor
>configurable parameters which are parsed from vendor specific provisioning
>file and then passed via configfs node at runtime to provision ufs device.
>CONFIG_CONFIGFS_FS and CONFIG_SCSI_UFS_PROVISION needs to be enabled
>for using this feature.
>
>Usage:
>1) To read current configuration descriptor with index X
>   (where index X can be 0/1/2/3) :
>   cat /config/<device_name>/ufs_config_desc_X
>
>2) To write configuration descriptor with index X :
>   echo <config_desc_buf> > /config/<device_name>/ufs_config_desc_X
>
>
I tested on my platform and got these error:

cat /sys/kernel/config/ff3b0000.ufs/ufs_config_desc_0=20
0x90 0x1 0x0 0x1 0x0 0x1 0x7f 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x1 0x1 0=
x0 0x3 0x0 0x0 0x0 0x2=20
0x1 0xc 0x2 0x0 0x0 0x0 0x0 0x0 0x1 0x2 0x0 0x3 0x0 0x0 0x0 0x2 0x1 0xc 0x2=
 0x0 0x0 0x0 0x0 0x0
 0x1 0x0 0x0 0x3 0x0 0x0 0x0 0x4 0x1 0xc 0x2 0x0 0x0 0x0 0x0 0x0 0x1 0x0 0x=
0 0x0 0x0 0x0 0x1d=20
0xc7 0x1 0xc 0x2 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x=
c 0x0 0x0 0x0 0x0=20
0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0xc 0x0 0x0 0x0 0x0 0x0 0x0 0x0=
 0x0 0x0 0x0 0x0=20
0x0 0x0 0x0 0x0 0xc 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0 0x0=
 0x0 0xc 0x0 0x0
 0x0 0x0 0x0 0x0

cat /sys/kernel/config/ff3b0000.ufs/ufs_config_desc_1=20
[   63.631734] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 1, err =3D 252
[   63.643059] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 1, err =3D 252
[   63.653602] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 1, err =3D 252
cat /sys/kernel/config/ff3b0000.ufs/ufs_config_desc_2=20
[   77.946097] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 2, err =3D 252
[   77.957212] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 2, err =3D 252
[   77.968534] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 2, err =3D 252
cat /sys/kernel/config/ff3b0000.ufs/ufs_config_desc_3
[   82.237656] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 3, err =3D 252
[   82.248374] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 3, err =3D 252
[   82.259117] ufshcd-hisi ff3b0000.ufs: __ufshcd_query_descriptor: opcode =
0x01 for idn 1 failed, index 3, err =3D 252
