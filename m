From: Girish K S <girish.shivananjappa@linaro.org>
Subject: Re: [PATCH 1/4] [SCSI] ufshcd: UFS Host controller driver
Date: Fri, 10 Feb 2012 00:45:39 +0530
Message-ID: <CAGxe1ZGDy-MWetg_rki2ms1Yy0dn4WqfrJgK+wPrucojyt-fHw@mail.gmail.com>
References: <1328158649-4137-1-git-send-email-vinholikatti@gmail.com>
	<1328158649-4137-2-git-send-email-vinholikatti@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qy0-f174.google.com ([209.85.216.174]:35387 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758336Ab2BITPl convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Feb 2012 14:15:41 -0500
In-Reply-To: <1328158649-4137-2-git-send-email-vinholikatti@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vinayak Holikatti <vinholikatti@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, patches@linaro.org, linux-samsung-soc@vger.kernel.org, saugata.das@linaro.org, arnd@arndb.de, venkat@linaro.org, vishak.g@samsung.com, k.rajesh@samsung.com, yejin.moon@samsung.com, Santosh Yaraganavi <santoshsy@gmail.com>, Sree kumar <sreekumar.c@samsung.com>

On 2 February 2012 10:27, Vinayak Holikatti <vinholikatti@gmail.com> wr=
ote:
> From: Santosh Yaraganavi <santoshsy@gmail.com>
>
> This patch adds support for Universal Flash Storage(UFS)
> host controllers. The UFS host controller driver
> includes host controller initialization method.
>
> The Initialization process involves following steps:
> =A0- Initiate UFS Host Controller initialization process by writing
> =A0 to Host controller enable register
> =A0- Configure UFS Host controller registers with host memory space
> =A0 datastructure offsets.
> =A0- Unipro link startup procedure
> =A0- Check for connected device
> =A0- Configure UFS host controller to process requests
> =A0- Enable required interrupts
> =A0- Configure interrupt aggregation
>
> Signed-off-by: Santosh Yaraganavi <santoshsy@gmail.com>
> Signed-off-by: Vinayak Holikatti <vinholikatti@gmail.com>
> Reviewed-by: Arnd Bergmann <arnd@arndb.de>
> Reviewed-by: Saugata Das <saugata.das@linaro.org>
> Reviewed-by: Vishak G <vishak.g@samsung.com>
> Reviewed-by: Girish K S <girish.shivananjappa@linaro.org>
> ---
> =A0drivers/scsi/Kconfig =A0 =A0 =A0| =A0 =A01 +
> =A0drivers/scsi/Makefile =A0 =A0 | =A0 =A01 +
> =A0drivers/scsi/ufs/Kconfig =A0| =A0 49 ++
> =A0drivers/scsi/ufs/Makefile | =A0 =A02 +
> =A0drivers/scsi/ufs/ufs.h =A0 =A0| =A0203 +++++++++
> =A0drivers/scsi/ufs/ufshcd.c | 1091 +++++++++++++++++++++++++++++++++=
++++++++++++
> =A0drivers/scsi/ufs/ufshci.h | =A0360 +++++++++++++++
> =A07 files changed, 1707 insertions(+), 0 deletions(-)
> =A0create mode 100644 drivers/scsi/ufs/Kconfig
> =A0create mode 100644 drivers/scsi/ufs/Makefile
> =A0create mode 100644 drivers/scsi/ufs/ufs.h
> =A0create mode 100644 drivers/scsi/ufs/ufshcd.c
> =A0create mode 100644 drivers/scsi/ufs/ufshci.h
>
> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
> index 16570aa..477a91a 100644
> --- a/drivers/scsi/Kconfig
> +++ b/drivers/scsi/Kconfig
> @@ -619,6 +619,7 @@ config SCSI_ARCMSR
>
> =A0source "drivers/scsi/megaraid/Kconfig.megaraid"
> =A0source "drivers/scsi/mpt2sas/Kconfig"
> +source "drivers/scsi/ufs/Kconfig"
>
> =A0config SCSI_HPTIOP
> =A0 =A0 =A0 =A0tristate "HighPoint RocketRAID 3xxx/4xxx Controller su=
pport"
> diff --git a/drivers/scsi/Makefile b/drivers/scsi/Makefile
> index 2b88749..c832974 100644
> --- a/drivers/scsi/Makefile
> +++ b/drivers/scsi/Makefile
> @@ -108,6 +108,7 @@ obj-$(CONFIG_MEGARAID_LEGACY) =A0 =A0 =A0 +=3D me=
garaid.o
> =A0obj-$(CONFIG_MEGARAID_NEWGEN) =A0+=3D megaraid/
> =A0obj-$(CONFIG_MEGARAID_SAS) =A0 =A0 +=3D megaraid/
> =A0obj-$(CONFIG_SCSI_MPT2SAS) =A0 =A0 +=3D mpt2sas/
> +obj-$(CONFIG_SCSI_UFSHCD) =A0 =A0 =A0+=3D ufs/
> =A0obj-$(CONFIG_SCSI_ACARD) =A0 =A0 =A0 +=3D atp870u.o
> =A0obj-$(CONFIG_SCSI_SUNESP) =A0 =A0 =A0+=3D esp_scsi.o =A0 sun_esp.o
> =A0obj-$(CONFIG_SCSI_GDTH) =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0+=3D gdth.o
> diff --git a/drivers/scsi/ufs/Kconfig b/drivers/scsi/ufs/Kconfig
> new file mode 100644
> index 0000000..8f27f9d
> --- /dev/null
> +++ b/drivers/scsi/ufs/Kconfig
> @@ -0,0 +1,49 @@
> +#
> +# Kernel configuration file for the UFS Host Controller
> +#
> +# This code is based on drivers/scsi/ufs/Kconfig
> +# Copyright (C) 2011 =A0Samsung Samsung India Software Operations
> +#
> +# Santosh Yaraganavi <santosh.sy@samsung.com>
> +# Vinayak Holikatti <h.vinayak@samsung.com>
> +
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License
> +# as published by the Free Software Foundation; either version 2
> +# of the License, or (at your option) any later version.
> +
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> +# GNU General Public License for more details.
> +
> +# NO WARRANTY
> +# THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
> +# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHO=
UT
> +# LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMEN=
T,
> +# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipien=
t is
> +# solely responsible for determining the appropriateness of using an=
d
> +# distributing the Program and assumes all risks associated with its
> +# exercise of rights under this Agreement, including but not limited=
 to
> +# the risks and costs of program errors, damage to or loss of data,
> +# programs or equipment, and unavailability or interruption of opera=
tions.
> +
> +# DISCLAIMER OF LIABILITY
> +# NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FO=
R ANY
> +# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> +# DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSE=
D AND
> +# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,=
 OR
> +# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF=
 THE
> +# USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS G=
RANTED
> +# HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write to the Free Software
> +# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A00=
2110-1301,
> +# USA.
> +
> +config SCSI_UFSHCD
> + =A0 =A0 =A0 tristate "Universal Flash Storage host controller drive=
r"
> + =A0 =A0 =A0 depends on PCI && SCSI
> + =A0 =A0 =A0 ---help---
> + =A0 =A0 =A0 This is a generic driver which supports PCIe UFS Host c=
ontrollers.
> diff --git a/drivers/scsi/ufs/Makefile b/drivers/scsi/ufs/Makefile
> new file mode 100644
> index 0000000..adf7895
> --- /dev/null
> +++ b/drivers/scsi/ufs/Makefile
> @@ -0,0 +1,2 @@
> +# UFSHCD makefile
> +obj-$(CONFIG_SCSI_UFSHCD) +=3D ufshcd.o
> diff --git a/drivers/scsi/ufs/ufs.h b/drivers/scsi/ufs/ufs.h
> new file mode 100644
> index 0000000..96b5cae
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufs.h
> @@ -0,0 +1,203 @@
> +/*
> + * Universal Flash Storage Host controller driver
> + *
> + * This code is based on drivers/scsi/ufs/ufs.h
> + * Copyright (C) 2011-2012 Samsung India Software Operations
> + *
> + * Santosh Yaraganavi <santosh.sy@samsung.com>
> + * Vinayak Holikatti <h.vinayak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES O=
R
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITH=
OUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEME=
NT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipie=
nt is
> + * solely responsible for determining the appropriateness of using a=
nd
> + * distributing the Program and assumes all risks associated with it=
s
> + * exercise of rights under this Agreement, including but not limite=
d to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of oper=
ations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY F=
OR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUS=
ED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY=
, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT O=
=46 THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A0=
02110-1301,
> + * USA.
> + */
> +
> +#ifndef _UFS_H
> +#define _UFS_H
> +
> +#define TASK_REQ_UPIU_SIZE_DWORDS =A0 =A0 =A08
> +#define TASK_RSP_UPIU_SIZE_DWORDS =A0 =A0 =A08
> +
> +#define MAX_CDB_SIZE =A0 =A0 =A0 =A0 =A0 16
> +#define ALIGNED_UPIU_SIZE =A0 =A0 =A0128
> +
> +#define UPIU_HEADER_DWORD(byte3, byte2, byte1, byte0)\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 ((byte3 << 24) | (byte2=
 << 16) |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(byte1 << 8) | (byte=
0))
> +
> +/*
> + * UFS Protocol Information Unit related definitions
> + */
> +
> +/* Task management functions */
> +enum {
> + =A0 =A0 =A0 UFS_ABORT_TASK =A0 =A0 =A0 =A0 =A0=3D 0x01,
> + =A0 =A0 =A0 UFS_ABORT_TASK_SET =A0 =A0 =A0=3D 0x02,
> + =A0 =A0 =A0 UFS_CLEAR_TASK_SET =A0 =A0 =A0=3D 0x04,
> + =A0 =A0 =A0 UFS_LOGICAL_RESET =A0 =A0 =A0 =3D 0x08,
> + =A0 =A0 =A0 UFS_QUERY_TASK =A0 =A0 =A0 =A0 =A0=3D 0x80,
> + =A0 =A0 =A0 UFS_QUERY_TASK_SET =A0 =A0 =A0=3D 0x81
> +};
> +
> +/* UTP UPIU Transaction Codes Initiator to Target */
> +enum {
> + =A0 =A0 =A0 UPIU_TRANSACTION_NOP_OUT =A0 =A0 =A0 =A0=3D 0x00,
> + =A0 =A0 =A0 UPIU_TRANSACTION_COMMAND =A0 =A0 =A0 =A0=3D 0x01,
> + =A0 =A0 =A0 UPIU_TRANSACTION_DATA_OUT =A0 =A0 =A0 =3D 0x02,
> + =A0 =A0 =A0 UPIU_TRANSACTION_TASK_REQ =A0 =A0 =A0 =3D 0x04,
> + =A0 =A0 =A0 UPIU_TRANSACTION_QUERY_REQ =A0 =A0 =A0=3D 0x26
> +};
> +
> +/* UTP UPIU Transaction Codes Target to Initiator */
> +enum {
> + =A0 =A0 =A0 UPIU_TRANSACTION_NOP_IN =A0 =A0 =A0 =A0 =3D 0x20,
> + =A0 =A0 =A0 UPIU_TRANSACTION_RESPONSE =A0 =A0 =A0 =3D 0x21,
> + =A0 =A0 =A0 UPIU_TRANSACTION_DATA_IN =A0 =A0 =A0 =A0=3D 0x22,
> + =A0 =A0 =A0 UPIU_TRANSACTION_TASK_RSP =A0 =A0 =A0 =3D 0x24,
> + =A0 =A0 =A0 UPIU_TRANSACTION_READY_XFER =A0 =A0 =3D 0x31,
> + =A0 =A0 =A0 UPIU_TRANSACTION_QUERY_RSP =A0 =A0 =A0=3D 0x36
> +};
> +
> +/* UPIU Read/Write flags */
> +enum {
> + =A0 =A0 =A0 UPIU_CMD_FLAGS_READ =A0 =A0 =3D 0x40,
> + =A0 =A0 =A0 UPIU_CMD_FLAGS_WRITE =A0 =A0=3D 0x20
> +
> +};
> +
> +/* UPIU Task Attributes */
> +enum {
> + =A0 =A0 =A0 UPIU_TASK_ATTR_SIMPLE =A0 =3D 0x00,
> + =A0 =A0 =A0 UPIU_TASK_ATTR_ORDERED =A0=3D 0x01,
> + =A0 =A0 =A0 UPIU_TASK_ATTR_HEADQ =A0 =A0=3D 0x02,
> + =A0 =A0 =A0 UPIU_TASK_ATTR_ACA =A0 =A0 =A0=3D 0x03
> +};
> +
> +/* UTP QUERY Transaction Specific Fields OpCode */
> +enum {
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_NOP =A0 =A0 =A0 =A0 =A0 =3D 0x0,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_READ_DESC =A0 =A0 =3D 0x1,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_WRITE_DESC =A0 =A0=3D 0x2,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_READ_ATTR =A0 =A0 =3D 0x3,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_WRITE_ATTR =A0 =A0=3D 0x4,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_READ_FLAG =A0 =A0 =3D 0x5,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_SET_FLAG =A0 =A0 =A0=3D 0x6,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_CLEAR_FLAG =A0 =A0=3D 0x7,
> + =A0 =A0 =A0 UPIU_QUERY_OPCODE_TOGGLE_FLAG =A0 =3D 0x8
> +};
> +
> +/* UTP Transfer Request Command Type (CT) */
> +enum {
> + =A0 =A0 =A0 UPIU_COMMAND_SET_TYPE_SCSI =A0 =A0 =A0=3D 0x0,
> + =A0 =A0 =A0 UPIU_COMMAND_SET_TYPE_UFS =A0 =A0 =A0 =3D 0x1,
> + =A0 =A0 =A0 UPIU_COMMAND_SET_TYPE_QUERY =A0 =A0 =3D 0x2
> +};
> +
> +enum {
> + =A0 =A0 =A0 MASK_SCSI_STATUS =A0 =A0 =A0 =A0=3D 0xFF,
> + =A0 =A0 =A0 MASK_TASK_RESPONSE =A0 =A0 =A0=3D 0xFF00,
> + =A0 =A0 =A0 MASK_RSP_UPIU_RESULT =A0 =A0=3D 0xFFFF
> +};
> +
> +/**
> + * struct utp_upiu_header - UPIU header structure
> + * @dword_0: UPIU header DW-0
> + * @dword_1: UPIU header DW-1
> + * @dword_2: UPIU header DW-2
> + */
> +struct utp_upiu_header {
> + =A0 =A0 =A0 u32 dword_0;
> + =A0 =A0 =A0 u32 dword_1;
> + =A0 =A0 =A0 u32 dword_2;
> +};
> +
> +/**
> + * struct utp_upiu_cmd - Command UPIU structure
> + * @header: UPIU header structure DW-0 to DW-2
> + * @data_transfer_len: Data Transfer Length DW-3
> + * @cdb: Command Descriptor Block CDB DW-4 to DW-7
> + */
> +struct utp_upiu_cmd {
> + =A0 =A0 =A0 struct utp_upiu_header header;
> + =A0 =A0 =A0 u32 exp_data_transfer_len;
> + =A0 =A0 =A0 u8 cdb[MAX_CDB_SIZE];
> +};
> +
> +/**
> + * struct utp_upiu_rsp - Response UPIU structure
> + * @header: UPIU header DW-0 to DW-2
> + * @residual_transfer_count: Residual transfer count DW-3
> + * @reserved: Reserver DW-4 to DW-7
> + * @sense_data_len: Sense data length DW-8 U16
> + * @sense_data: Sense data field DW-8 to DW-12
> + */
> +struct utp_upiu_rsp {
> + =A0 =A0 =A0 struct utp_upiu_header header;
> + =A0 =A0 =A0 u32 residual_transfer_count;
> + =A0 =A0 =A0 u32 reserved[4];
> + =A0 =A0 =A0 u16 sense_data_len;
> + =A0 =A0 =A0 u8 sense_data[18];
> +};
> +
> +/**
> + * struct utp_upiu_task_req - Task request UPIU structure
> + * @header - UPIU header structure DW0 to DW-2
> + * @input_param1: Input param 1 DW-3
> + * @input_param2: Input param 2 DW-4
> + * @input_param3: Input param 3 DW-5
> + * @reserved: Reserver DW-6 to DW-7
> + */
> +struct utp_upiu_task_req {
> + =A0 =A0 =A0 struct utp_upiu_header header;
> + =A0 =A0 =A0 u32 input_param1;
> + =A0 =A0 =A0 u32 input_param2;
> + =A0 =A0 =A0 u32 input_param3;
> + =A0 =A0 =A0 u32 reserved[2];
> +};
> +
> +/**
> + * struct utp_upiu_task_rsp - Task Management Response UPIU structur=
e
> + * @header: UPIU header structure DW0-DW-2
> + * @output_param1: Ouput param 1 DW3
> + * @output_param2: Output param 2 DW4
> + * @reserved: Reserver DW-5 to DW-7
> + */
> +struct utp_upiu_task_rsp {
> + =A0 =A0 =A0 struct utp_upiu_header header;
> + =A0 =A0 =A0 u32 output_param1;
> + =A0 =A0 =A0 u32 output_param2;
> + =A0 =A0 =A0 u32 reserved[3];
> +};
> +
> +#endif /* End of Header */
> diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
> new file mode 100644
> index 0000000..c82eeea
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshcd.c
> @@ -0,0 +1,1091 @@
> +/*
> + * Universal Flash Storage Host controller driver
> + *
> + * This code is based on drivers/scsi/ufs/ufshcd.c
> + * Copyright (C) 2011-2012 Samsung India Software Operations
> + *
> + * Santosh Yaraganavi <santosh.sy@samsung.com>
> + * Vinayak Holikatti <h.vinayak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES O=
R
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITH=
OUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEME=
NT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipie=
nt is
> + * solely responsible for determining the appropriateness of using a=
nd
> + * distributing the Program and assumes all risks associated with it=
s
> + * exercise of rights under this Agreement, including but not limite=
d to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of oper=
ations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY F=
OR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUS=
ED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY=
, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT O=
=46 THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A0=
02110-1301,
> + * USA.
> + */
> +
> +#include <linux/module.h>
> +#include <linux/kernel.h>
> +#include <linux/init.h>
> +#include <linux/pci.h>
> +#include <linux/interrupt.h>
> +#include <linux/io.h>
> +#include <linux/delay.h>
> +#include <linux/slab.h>
> +#include <linux/spinlock.h>
> +#include <linux/workqueue.h>
> +#include <linux/errno.h>
> +#include <linux/types.h>
> +#include <linux/wait.h>
> +
> +#include <asm/irq.h>
> +#include <asm/byteorder.h>
> +#include <scsi/scsi.h>
> +#include <scsi/scsi_cmnd.h>
> +#include <scsi/scsi_host.h>
> +#include <scsi/scsi_dbg.h>
> +
> +#include "ufs.h"
> +#include "ufshci.h"
> +
> +#define UFSHCD "ufshcd"
> +#define UFSHCD_DRIVER_VERSION "0.1"
> +
> +#ifndef NULL
> +#define NULL 0
> +#endif =A0/* NULL */
> +
> +#define BYTES_TO_DWORDS(p) =A0 =A0 (p >> 2)
> +#define UFSHCD_MMIO_BASE =A0 =A0 =A0 (hba->mmio_base)
> +
> +enum {
> + =A0 =A0 =A0 UFSHCD_MAX_CHANNEL =A0 =A0 =A0=3D 1,
> + =A0 =A0 =A0 UFSHCD_MAX_ID =A0 =A0 =A0 =A0 =A0 =3D 1,
> + =A0 =A0 =A0 UFSHCD_MAX_LUNS =A0 =A0 =A0 =A0 =3D 8,
> + =A0 =A0 =A0 UFSHCD_CAN_QUEUE =A0 =A0 =A0 =A0=3D 32,
> + =A0 =A0 =A0 BYTES_128 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 128,
> + =A0 =A0 =A0 BYTES_1024 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 1024
> +};
> +
> +/* UFSHCD states */
> +enum {
> + =A0 =A0 =A0 UFSHCD_STATE_OPERATIONAL,
> + =A0 =A0 =A0 UFSHCD_STATE_RESET,
> + =A0 =A0 =A0 UFSHCD_STATE_ERROR
> +};
> +
> +/* Interrupt configuration options */
> +enum {
> + =A0 =A0 =A0 UFSHCD_INT_DISABLE,
> + =A0 =A0 =A0 UFSHCD_INT_ENABLE,
> + =A0 =A0 =A0 UFSHCD_INT_CLEAR
> +};
> +
> +/* Interrupt aggregation options */
> +enum {
> + =A0 =A0 =A0 INT_AGGR_RESET,
> + =A0 =A0 =A0 INT_AGGR_CONFIG
> +};
> +
> +/**
> + * struct uic_command - UIC command structure
> + * @command: UIC command
> + * @argument1: UIC command argument 1
> + * @argument2: UIC command argument 2
> + * @argument3: UIC command argument 3
> + * @cmd_active: Indicate if UIC command is outstanding
> + * @result: UIC command result
> + * @callback: routine to be called when UIC command completes
> + */
> +struct uic_command {
> + =A0 =A0 =A0 u32 command;
> + =A0 =A0 =A0 u32 argument1;
> + =A0 =A0 =A0 u32 argument2;
> + =A0 =A0 =A0 u32 argument3;
> + =A0 =A0 =A0 int cmd_active;
> + =A0 =A0 =A0 int result;
> +};
> +
> +/**
> + * struct ufs_hba - per adapter private structure
> + * @mmio_base: UFSHCI base register address
> + * @ucdl_virt_addr: UFS Command Descriptor virtual address
> + * @utrdl_virt_addr: UTP Transfer Request Descriptor virtual address
> + * @utmrdl_virt_addr: UTP Task Management Descriptor virtual address
> + * @utrdl_virt_addr_aligned: UTRD Aligned vitual address
> + * @utmrdl_virt_addr_aligned: UTMRD Aligned virtual address
> + * @ucdl_size: Memory size of UCD command block
> + * @utrdl_size: Memory size of UTRDL block
> + * @utmrdl_size: Memory size of UTMRDL block
> + * @ucdl_dma_addr: UFS Command Descriptor DMA address
> + * @utrdl_dma_addr: UTRDL DMA address
> + * @utmrdl_dma_addr: UTMRDL DMA address
> + * @utrdl_dma_addr_aligned: UTRDL aligned DMA address
> + * @utmrdl_dma_addr_aligned: UTMRDL aligned DMA address
> + * @ucdl_dma_addr_aligned: UCD aligned DMA address
> + * @dma_size:
> + * @host: Scsi_Host instance of the driver
> + * @pdev: PCI device handle
> + * @lrb: local reference block
> + * @capabilities: UFS Controller Capabilities
> + * @nutrs: Transfer Request Queue depth supported by controller
> + * @nutmrs: Task Management Queue depth supported by controller
> + * @active_uic_cmd: handle of active UIC command
> + * @ufshcd_state: UFSHCD states
> + * @int_enable_mask: Interrupt Mask Bits
> + * @uic_workq: Work queue for UIC completion handling
> + */
> +struct ufs_hba {
> + =A0 =A0 =A0 void __iomem *mmio_base;
> +
> + =A0 =A0 =A0 /* Virtual memory reference */
> + =A0 =A0 =A0 void *ucdl_virt_addr;
> + =A0 =A0 =A0 void *utrdl_virt_addr;
> + =A0 =A0 =A0 void *utmrdl_virt_addr;
> + =A0 =A0 =A0 void *utrdl_virt_addr_aligned;
> + =A0 =A0 =A0 void *utmrdl_virt_addr_aligned;
> + =A0 =A0 =A0 void *ucdl_virt_addr_aligned;
> +
> + =A0 =A0 =A0 size_t ucdl_size;
> + =A0 =A0 =A0 size_t utrdl_size;
> + =A0 =A0 =A0 size_t utmrdl_size;
> +
> + =A0 =A0 =A0 /* DMA memory reference */
> + =A0 =A0 =A0 dma_addr_t ucdl_dma_addr;
> + =A0 =A0 =A0 dma_addr_t utrdl_dma_addr;
> + =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr;
> + =A0 =A0 =A0 dma_addr_t utrdl_dma_addr_aligned;
> + =A0 =A0 =A0 dma_addr_t utmrdl_dma_addr_aligned;
> + =A0 =A0 =A0 dma_addr_t ucdl_dma_addr_aligned;
> +
> + =A0 =A0 =A0 size_t dma_size;
> +
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct pci_dev *pdev;
> +
> + =A0 =A0 =A0 struct ufshcd_lrb *lrb;
> +
> + =A0 =A0 =A0 u32 capabilities;
> + =A0 =A0 =A0 int nutrs;
> + =A0 =A0 =A0 int nutmrs;
> + =A0 =A0 =A0 u32 ufs_version;
> +
> + =A0 =A0 =A0 struct uic_command active_uic_cmd;
> +
> + =A0 =A0 =A0 u32 ufshcd_state;
> + =A0 =A0 =A0 u32 int_enable_mask;
> +
> + =A0 =A0 =A0 /* Work Queues */
> + =A0 =A0 =A0 struct work_struct uic_workq;
> +};
> +
> +/**
> + * struct ufshcd_lrb - command control block
> + * @utr_descriptor_ptr: UTRD address of the command
> + * @ucd_cmd_ptr: UCD address of the command
> + * @ucd_rsp_ptr: Response UPIU address for this command
> + * @ucd_prdt_ptr: PRDT address of the command
> + */
> +struct ufshcd_lrb {
> + =A0 =A0 =A0 struct utp_transfer_req_desc *utr_descriptor_ptr;
> + =A0 =A0 =A0 struct utp_upiu_cmd *ucd_cmd_ptr;
> + =A0 =A0 =A0 struct utp_upiu_rsp *ucd_rsp_ptr;
> + =A0 =A0 =A0 struct ufshcd_sg_entry *ucd_prdt_ptr;
> +};
> +
> +/**
> + * ufshcd_get_ufs_version - Get the UFS version supported by the HBA
> + * @hba - Pointer to adapter instance
> + *
> + * Returns UFSHCI version supported by the controller
> + */
> +static inline u32 ufshcd_get_ufs_version(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 return readl(UFSHCD_MMIO_BASE + REG_UFS_VERSION);
> +}
> +
> +/**
> + * ufshcd_is_device_present - Check if any device connected to
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 the host cont=
roller
> + * @reg_hcs - host controller status register value
> + *
> + * Returns 0 if device present, non-zeo if no device detected
> + */
> +static inline int ufshcd_is_device_present(u32 reg_hcs)
> +{
> + =A0 =A0 =A0 return (DEVICE_PRESENT & reg_hcs) ? 0 : -1;
> +}
> +
> +/**
> + * ufshcd_get_lists_status - Check UCRDY, UTRLRDY and UTMRLRDY
> + * @reg: Register value of host controller status
> + *
> + * Returns integer, 0 on Success and positive value if failed
> + */
> +static inline int ufshcd_get_lists_status(u32 reg)
> +{
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* The mask 0xFF is for the following HCS register bi=
ts
> + =A0 =A0 =A0 =A0* Bit =A0 =A0 =A0 =A0 =A0Description
> + =A0 =A0 =A0 =A0* =A00 =A0 =A0 =A0 =A0 =A0 Device Present
> + =A0 =A0 =A0 =A0* =A01 =A0 =A0 =A0 =A0 =A0 UTRLRDY
> + =A0 =A0 =A0 =A0* =A02 =A0 =A0 =A0 =A0 =A0 UTMRLRDY
> + =A0 =A0 =A0 =A0* =A03 =A0 =A0 =A0 =A0 =A0 UCRDY
> + =A0 =A0 =A0 =A0* =A04 =A0 =A0 =A0 =A0 =A0 HEI
> + =A0 =A0 =A0 =A0* =A05 =A0 =A0 =A0 =A0 =A0 DEI
> + =A0 =A0 =A0 =A0* 6-7 =A0 =A0 =A0 =A0 =A0reserved
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 return (((reg) & (0xFF)) >> 1) ^ (0x07);
> +}
> +
> +/**
> + * ufshcd_get_uic_cmd_result - Get the UIC command result
> + * @hba: Pointer to adapter instance
> + *
> + * This function gets the result of UIC command completion
> + * Returns 0 on success, non zero value on error
> + */
> +static inline int ufshcd_get_uic_cmd_result(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 return readl(UFSHCD_MMIO_BASE + REG_UIC_COMMAND_ARG_2) =
&
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0MASK_UIC_COMMAND_RESULT;
> +}
> +
> +/**
> + * ufshcd_free_hba_memory - Free allocated memory for LRB request
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 and task lists
> + * @hba: Pointer to adapter instance
> + */
> +static inline void ufshcd_free_hba_memory(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 kfree(hba->lrb);
> + =A0 =A0 =A0 hba->lrb =3D NULL;
> +
> + =A0 =A0 =A0 if (hba->utmrdl_virt_addr_aligned) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba-=
>utmrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba=
->utmrdl_virt_addr, hba->utmrdl_dma_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utmrdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utmrdl_virt_addr_aligned =3D NULL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (hba->utrdl_virt_addr_aligned) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba-=
>utrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba=
->utrdl_virt_addr, hba->utrdl_dma_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utrdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utrdl_virt_addr_aligned =3D NULL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 if (hba->ucdl_virt_addr_aligned) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba-=
>ucdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba=
->ucdl_virt_addr, hba->ucdl_dma_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->ucdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->ucdl_virt_addr_aligned =3D NULL;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * ufshcd_config_int_aggr - Configure interrupt aggregation values
> + * =A0 =A0 =A0 =A0 =A0 =A0 currently there is no use case where we w=
ant to configure
> + * =A0 =A0 =A0 =A0 =A0 =A0 interrupt aggregation dynamically. So to =
configure interrupt
> + * =A0 =A0 =A0 =A0 =A0 =A0 aggregation, #define INT_AGGR_COUNTER_THR=
ESHOLD_VALUE and
> + * =A0 =A0 =A0 =A0 =A0 =A0 INT_AGGR_TIMEOUT_VALUE are used.
> + * @hba: per adapter instance
> + * @option: Interrupt aggregation option
> + */
> +static inline void
> +ufshcd_config_int_aggr(struct ufs_hba *hba, int option)
> +{
> + =A0 =A0 =A0 switch (option) {
> + =A0 =A0 =A0 case INT_AGGR_RESET:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel((INT_AGGR_ENABLE |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 INT_AGGR_COUNTER_AND_TI=
MER_RESET),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_UTP_TRANSFER_REQ=
_INT_AGG_CONTROL));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case INT_AGGR_CONFIG:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel((INT_AGGR_ENABLE |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 INT_AGGR_PARAM_WRITE |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 INT_AGGR_COUNTER_THRESH=
OLD_VALUE |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 INT_AGGR_TIMEOUT_VALUE)=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0REG_UTP_TRANSFER_REQ=
_INT_AGG_CONTROL));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * ufshcd_hba_stop - put the controller in reset state
> + * @hba: per adapter instance
> + */
> +static inline void ufshcd_hba_stop(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 writel(0, (UFSHCD_MMIO_BASE + REG_CONTROLLER_ENABLE));
> +}
> +
> +/**
> + * ufshcd_hba_capabilities - Read controller capabilities
> + * @hba: per adapter instance
> + */
> +static inline void ufshcd_hba_capabilities(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 u32 capabilities;
> +
> + =A0 =A0 =A0 capabilities =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 readl(UFSHCD_MMIO_BASE + REG_CONTROLLER=
_CAPABILITIES);
> + =A0 =A0 =A0 hba->capabilities =3D capabilities;
> +
> + =A0 =A0 =A0 /* nutrs and nutmrs are 0 based values */
> + =A0 =A0 =A0 hba->nutrs =3D (capabilities & MASK_TRANSFER_REQUESTS_S=
LOTS) + 1;
> + =A0 =A0 =A0 hba->nutmrs =3D
> + =A0 =A0 =A0 ((capabilities & MASK_TASK_MANAGEMENT_REQUEST_SLOTS) >>=
 16) + 1;
> +}
> +
> +/**
> + * ufshcd_send_uic_command - Send UIC commands to unipro layers
> + * @hba: per adapter instance
> + * @uic_command: UIC command
> + */
> +static inline void
> +ufshcd_send_uic_command(struct ufs_hba *hba, struct uic_command *uic=
_cmnd)
> +{
> + =A0 =A0 =A0 /* Clear interrupt status register */
> + =A0 =A0 =A0 writel((readl(UFSHCD_MMIO_BASE + REG_INTERRUPT_STATUS))=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_INTERRUPT_STATUS=
));
> +
> + =A0 =A0 =A0 /* Write Args */
> + =A0 =A0 =A0 writel(uic_cmnd->argument1,
> + =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE + REG_UIC_COMMAND_ARG_1))=
;
> + =A0 =A0 =A0 writel(uic_cmnd->argument2,
> + =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE + REG_UIC_COMMAND_ARG_2))=
;
> + =A0 =A0 =A0 writel(uic_cmnd->argument3,
> + =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE + REG_UIC_COMMAND_ARG_3))=
;
> +
> + =A0 =A0 =A0 /* Write UIC Cmd */
> + =A0 =A0 =A0 writel((uic_cmnd->command & COMMAND_OPCODE_MASK),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UIC_COMMAND));
> +}
> +
> +/**
> + * ufshcd_int_config - enable/disable interrupts
> + * @hba: per adapter instance
> + * @option: interrupt option
> + */
> +static void ufshcd_int_config(struct ufs_hba *hba, u32 option)
> +{
> + =A0 =A0 =A0 switch (option) {
> + =A0 =A0 =A0 case UFSHCD_INT_ENABLE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(hba->int_enable_mask,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMIO_BASE + REG_INT=
ERRUPT_ENABLE));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 case UFSHCD_INT_DISABLE:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (UFSHCI_VERSION_10 =3D=3D hba->ufs_v=
ersion)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(readl(UFSHCD_MMI=
O_BASE + REG_INTERRUPT_ENABLE),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (UFSHCD_MMI=
O_BASE + REG_INTERRUPT_ENABLE));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 else
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(0, (UFSHCD_MMIO_=
BASE + REG_INTERRUPT_ENABLE));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 default:
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "Invalid inter=
rupt option\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 } /* end of switch */
> +}
> +
> +/**
> + * ufshcd_memory_alloc - allocate memory for host memory space data =
structures
> + * @hba: per adapter instance
> + *
> + * 1) Allocate DMA memory for Command Descriptor array
> + * =A0 =A0 Each command descriptor consist of Command UPIU, Response=
 UPIU and PRDT
> + * 2) Align allocated command descriptor address to 128 byte align.
> + * 3) Allocate DMA memory for UTP Transfer Request Descriptor List (=
UTRDL).
> + * 4) Align UTRDL address to 1KB (UFSHCI spec)
> + * 5) Allocate DMA memory for UTP Task Management Request Descriptor=
 List
> + * =A0 =A0 (UTMRDL)
> + * 6) Align UTMRDL address to 1KB (UFSHCI spec)
> + * 7) Allocate the memory for local reference block(lrb).
> + *
> + * Returns 0 for success, non-zero in case of failure
> + */
> +static int ufshcd_memory_alloc(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Allocate memory for UTP command descriptors.
> + =A0 =A0 =A0 =A0* UFSHCI requires 128 byte alignement of UCD and
> + =A0 =A0 =A0 =A0* 64 byte alignement for PRDT. So allocating extra 1=
28 bytes
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 hba->ucdl_size =3D
> + =A0 =A0 =A0 (sizeof(struct utp_transfer_cmd_desc) * hba->nutrs) + B=
YTES_128;
> + =A0 =A0 =A0 hba->ucdl_virt_addr =3D dma_alloc_coherent(&hba->pdev->=
dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0hba->ucdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0&hba->ucdl_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL);
> + =A0 =A0 =A0 if (NULL =3D=3D hba->ucdl_virt_addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Command Descriptor Mem=
ory allocation failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto ucd_fail;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Align UCD to 128 bytes */
> + =A0 =A0 =A0 hba->ucdl_virt_addr_aligned =3D
> + =A0 =A0 =A0 (void *) ALIGN((unsigned long) hba->ucdl_virt_addr, BYT=
ES_128);
> + =A0 =A0 =A0 hba->ucdl_dma_addr_aligned =3D ALIGN(hba->ucdl_dma_addr=
, BYTES_128);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Allocate memory for UTP Transfer descriptors.
> + =A0 =A0 =A0 =A0* UFSHCI requires 1kb alignement of UTRD. So allocat=
ing
> + =A0 =A0 =A0 =A0* extra 1024 bytes
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 hba->utrdl_size =3D
> + =A0 =A0 =A0 (sizeof(struct utp_transfer_req_desc) * hba->nutrs) + B=
YTES_1024;
> + =A0 =A0 =A0 hba->utrdl_virt_addr =3D dma_alloc_coherent(&hba->pdev-=
>dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 &hba->utrdl_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 GFP_KERNEL);
> + =A0 =A0 =A0 if (NULL =3D=3D hba->utrdl_virt_addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Transfer Descriptor Me=
mory allocation failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto utrd_fail;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* alignement UTRD to 1kb */
> + =A0 =A0 =A0 hba->utrdl_virt_addr_aligned =3D
> + =A0 =A0 =A0 (void *) ALIGN((unsigned long) hba->utrdl_virt_addr, BY=
TES_1024);
> + =A0 =A0 =A0 hba->utrdl_dma_addr_aligned =3D ALIGN(hba->utrdl_dma_ad=
dr, BYTES_1024);
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* Allocate memory for UTP Task Management descriptor=
s
> + =A0 =A0 =A0 =A0* UFSHCI requires 1kb alignement of UTMRD. So alloca=
ting
> + =A0 =A0 =A0 =A0* extra 1024 bytes
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 hba->utmrdl_size =3D
> + =A0 =A0 =A0 sizeof(struct utp_task_req_desc) * hba->nutmrs + BYTES_=
1024;
> + =A0 =A0 =A0 hba->utmrdl_virt_addr =3D dma_alloc_coherent(&hba->pdev=
->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0hba->utmrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0&hba->utmrdl_dma_addr,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0GFP_KERNEL);
> + =A0 =A0 =A0 if (NULL =3D=3D hba->utmrdl_virt_addr) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Task Management Descriptor Memory allo=
cation failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto utmrd_fail;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* alignement UTMRD to 1kb */
> + =A0 =A0 =A0 hba->utmrdl_virt_addr_aligned =3D
> + =A0 =A0 =A0 (void *) ALIGN((unsigned long) hba->utmrdl_virt_addr, B=
YTES_1024);
> + =A0 =A0 =A0 hba->utmrdl_dma_addr_aligned =3D ALIGN(hba->utmrdl_dma_=
addr, BYTES_1024);
> +
> + =A0 =A0 =A0 /* Allocate memory for local reference block */
> + =A0 =A0 =A0 hba->lrb =3D kcalloc(hba->nutrs, sizeof(struct ufshcd_l=
rb), GFP_KERNEL);
> + =A0 =A0 =A0 if (NULL =3D=3D hba->lrb) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "LRB Memory al=
location failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto lrb_fail;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +lrb_fail:
> + =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba->utmrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utmrdl_virt_ad=
dr, hba->utmrdl_dma_addr);
> + =A0 =A0 =A0 hba->utmrdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 hba->utmrdl_virt_addr_aligned =3D NULL;
> +utmrd_fail:
> + =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba->utrdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->utrdl_virt_add=
r, hba->utrdl_dma_addr);
> + =A0 =A0 =A0 hba->utrdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 hba->utrdl_virt_addr_aligned =3D NULL;
> +utrd_fail:
> + =A0 =A0 =A0 dma_free_coherent(&hba->pdev->dev, hba->ucdl_size,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->ucdl_virt_addr=
, hba->ucdl_dma_addr);
> + =A0 =A0 =A0 hba->ucdl_virt_addr =3D NULL;
> + =A0 =A0 =A0 hba->ucdl_virt_addr_aligned =3D NULL;
> +ucd_fail:
> + =A0 =A0 =A0 return -ENOMEM;
> +}
> +
> +/**
> + * ufshcd_host_memory_configure - configure local reference block wi=
th
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 memory of=
fsets
> + * @hba: per adapter instance
> + *
> + * Configure Host memory space
> + * 1) Update Corresponding UTRD.UCDBA and UTRD.UCDBAU with UCD DMA
> + * address.
> + * 2) Update each UTRD with Response UPIU offset, Response UPIU leng=
th
> + * and PRDT offset.
> + * 3) Save the corresponding addresses of UTRD, UCD.CMD, UCD.RSP and=
 UCD.PRDT
> + * into local reference block.
> + */
> +static void ufshcd_host_memory_configure(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 struct utp_transfer_cmd_desc *cmd_descp;
> + =A0 =A0 =A0 struct utp_transfer_req_desc *utrdlp;
> + =A0 =A0 =A0 dma_addr_t cmd_desc_dma_addr;
> + =A0 =A0 =A0 dma_addr_t cmd_desc_element_addr;
> + =A0 =A0 =A0 u16 response_offset;
> + =A0 =A0 =A0 u16 prdt_offset;
> + =A0 =A0 =A0 int cmd_desc_size;
> + =A0 =A0 =A0 int i;
> +
> + =A0 =A0 =A0 utrdlp =3D (struct utp_transfer_req_desc *)hba->utrdl_v=
irt_addr_aligned;
> + =A0 =A0 =A0 cmd_descp =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_transfer_cmd_desc *)hba->uc=
dl_virt_addr_aligned;
> +
> + =A0 =A0 =A0 response_offset =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsetof(struct utp_transfer_cmd_desc, =
response_upiu);
> + =A0 =A0 =A0 prdt_offset =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 offsetof(struct utp_transfer_cmd_desc, =
prd_table);
> +
> + =A0 =A0 =A0 cmd_desc_size =3D sizeof(struct utp_transfer_cmd_desc);
> + =A0 =A0 =A0 cmd_desc_dma_addr =3D hba->ucdl_dma_addr_aligned;
> +
> + =A0 =A0 =A0 for (i =3D 0; i < hba->nutrs; i++) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Configure UTRD with command descript=
or base address */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 cmd_desc_element_addr =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (cmd_de=
sc_dma_addr + (cmd_desc_size * i));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 utrdlp[i].command_desc_base_addr_lo =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le32(cmd_desc_element_addr);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 utrdlp[i].command_desc_base_addr_hi =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le32(cmd_desc_element_addr >> 32);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* Response upiu and prdt offset should=
 be in double words */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 utrdlp[i].response_upiu_offset =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(BYTES_TO_DWORDS(response_offset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 utrdlp[i].prd_table_offset =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(BYTES_TO_DWORDS(prdt_offset));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 utrdlp[i].response_upiu_length =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 cpu_to_=
le16(ALIGNED_UPIU_SIZE);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[i].utr_descriptor_ptr =3D (utr=
dlp + i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[i].ucd_cmd_ptr =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_upiu_cmd *)=
(cmd_descp + i);
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[i].ucd_rsp_ptr =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct utp_upiu_rsp *)=
cmd_descp[i].response_upiu;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 hba->lrb[i].ucd_prdt_ptr =3D
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (struct ufshcd_sg_entry=
 *)cmd_descp[i].prd_table;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * ufshcd_dme_link_startup - Notify Unipro to perform link startup
> + * @hba: per adapter instance
> + *
> + * UIC_CMD_DME_LINK_STARTUP command must be issued to Unipro layer,
> + * in order to intitialize the Unipro link startup procedure.
> + * Once the Unipro links are up, the device connected to the control=
ler
> + * is detected.
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_dme_link_startup(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 struct uic_command *uic_cmd;
> + =A0 =A0 =A0 unsigned long flags;
> +
> + =A0 =A0 =A0 /* check if controller is ready to accept UIC commands =
*/
> + =A0 =A0 =A0 if (((readl(UFSHCD_MMIO_BASE + REG_CONTROLLER_STATUS)) =
&
> + =A0 =A0 =A0 =A0 =A0 UIC_COMMAND_READY) =3D=3D 0x0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Controller not ready"
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 " to accept UIC command=
s\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 spin_lock_irqsave(hba->host->host_lock, flags);
> + =A0 =A0 =A0 uic_cmd =3D &hba->active_uic_cmd;
> + =A0 =A0 =A0 uic_cmd->command =3D UIC_CMD_DME_LINK_STARTUP;
> + =A0 =A0 =A0 uic_cmd->argument1 =3D 0;
> + =A0 =A0 =A0 uic_cmd->argument2 =3D 0;
> + =A0 =A0 =A0 uic_cmd->argument3 =3D 0;
> +
> + =A0 =A0 =A0 /* Enable UIC related interrupts */
> + =A0 =A0 =A0 hba->int_enable_mask |=3D UIC_COMMAND_COMPL;
> + =A0 =A0 =A0 ufshcd_int_config(hba, UFSHCD_INT_ENABLE);
> +
> + =A0 =A0 =A0 /* sending UIC commands to controller */
> + =A0 =A0 =A0 ufshcd_send_uic_command(hba, uic_cmd);
> + =A0 =A0 =A0 spin_unlock_irqrestore(hba->host->host_lock, flags);
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * ufshcd_make_hba_operational - Make UFS controller operatinal
> + * @hba: per adapter instance
> + *
> + * To bring UFS host controller to operational state,
> + * 1. Check if device is present
> + * 2. Configure run-stop-registers
> + * 3. Enable required interrupts
> + * 4. Configure interrupt aggregation
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_make_hba_operational(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 u32 reg;
> +
> + =A0 =A0 =A0 /* check if device present */
> + =A0 =A0 =A0 reg =3D readl((UFSHCD_MMIO_BASE + REG_CONTROLLER_STATUS=
));
> + =A0 =A0 =A0 if (ufshcd_is_device_present(reg)) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev, "cc: Device no=
t present\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* UCRDY, UTMRLDY and UTRLRDY bits must be 1
> + =A0 =A0 =A0 =A0* DEI, HEI bits must be 0
> + =A0 =A0 =A0 =A0*/
> + =A0 =A0 =A0 if (!(ufshcd_get_lists_status(reg))) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(UTP_TASK_REQ_LIST_RUN_STOP_BIT,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_R=
UN_STOP));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(UTP_TRANSFER_REQ_LIST_RUN_STOP_B=
IT,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LI=
ST_RUN_STOP));
> + =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Host controller not re=
ady to process requests");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Enable required interrupts */
> + =A0 =A0 =A0 hba->int_enable_mask |=3D (UTP_TRANSFER_REQ_COMPL |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UIC_=
ERROR |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UTP_=
TASK_REQ_COMPL |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0DEVI=
CE_FATAL_ERROR |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0CONT=
ROLLER_FATAL_ERROR |
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0SYST=
EM_BUS_FATAL_ERROR);
> + =A0 =A0 =A0 ufshcd_int_config(hba, UFSHCD_INT_ENABLE);

UFS host controller specification Section 7.2.1, step 11,  mentions
that the aggregation control register should be set if run/stop bit is
not enabled.
But In this case the run/ stop bit is set above before configuring the
aggregation register. Please check for the same in other places from
where it is called.

> +
> + =A0 =A0 =A0 /* Configure interrupt aggregation */
> + =A0 =A0 =A0 ufshcd_config_int_aggr(hba, INT_AGGR_CONFIG);
> +
> + =A0 =A0 =A0 hba->ufshcd_state =3D UFSHCD_STATE_OPERATIONAL;
> +
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * ufshcd_controller_enable - initialize the controller
> + * @hba: per adapter instance
> + *
> + * The controller resets its self and controller firmware start of d=
ay is
> + * kickes off. When controller is ready it will set the Host Control=
ler
> + * Status bit to 1.
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int ufshcd_controller_enable(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 int retry;
> +
> + =A0 =A0 =A0 /*
> + =A0 =A0 =A0 =A0* msleep of 1 and 5 used in this function might resu=
lt in msleep(20),
> + =A0 =A0 =A0 =A0* but it was necessary to send the UFS FPGA to reset=
 mode during
> + =A0 =A0 =A0 =A0* development and testing of this driver. msleep can=
 be changed to
> + =A0 =A0 =A0 =A0* mdelay and retry count can be reduced based on the=
 controller.
> + =A0 =A0 =A0 =A0*/
> +
> + =A0 =A0 =A0 /* change controller state to "reset state" */
> + =A0 =A0 =A0 writel(0, (UFSHCD_MMIO_BASE + REG_CONTROLLER_ENABLE));
> + =A0 =A0 =A0 msleep(5);
> +
> + =A0 =A0 =A0 writel(CONTROLLER_ENABLE,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_CONTROLLER_ENABL=
E));
> + =A0 =A0 =A0 msleep(1);
> +
> + =A0 =A0 =A0 /* wait for the host controller to complete initializat=
ion */
> + =A0 =A0 =A0 retry =3D 10;
> + =A0 =A0 =A0 while (((readl(UFSHCD_MMIO_BASE + REG_CONTROLLER_ENABLE=
)) &
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0CONTROLLER_ENABLE) !=3D 0x1) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (retry) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 retry--;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 } else {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "Contro=
ller enable failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -EINVAL;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 msleep(5);
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 return 0;
> +}
> +
> +/**
> + * ufshcd_initialize_hba - start the initialization process
> + * @hba: per adapter instance
> + *
> + * Initialize the Controller
> + * 1) Enable the controller via ufshcd_controller_enable.
> + * 2) Program the Transfer Request List Address with the starting ad=
dress of
> + * UTRDL.
> + *
> + * 3) Program the Task Management Request List Address with starting=
 address
> + * of UTMRDL.
> + *
> + * Returns 0 on success, non-zero value on failure.
> + */
> +static int ufshcd_initialize_hba(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 if (ufshcd_controller_enable(hba))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return -1;
> +
> + =A0 =A0 =A0 /* Configure TR/TM address registers */
> + =A0 =A0 =A0 writel(hba->utrdl_dma_addr_aligned,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TRANSFER_REQ=
_LIST_BASE_L));
> + =A0 =A0 =A0 writel((hba->utrdl_dma_addr_aligned >> 32),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TRANSFER_REQ=
_LIST_BASE_H));
> + =A0 =A0 =A0 writel(hba->utmrdl_dma_addr_aligned,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TASK_REQ_LIS=
T_BASE_L));
> + =A0 =A0 =A0 writel((hba->utmrdl_dma_addr_aligned >> 32),
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_MMIO_BASE + REG_UTP_TASK_REQ_LIS=
T_BASE_H));
> +
> + =A0 =A0 =A0 /* Initialize unipro link startup procedure */
> + =A0 =A0 =A0 return ufshcd_dme_link_startup(hba);
> +}
> +
> +/**
> + * ufshcd_uic_cc_handler - handle UIC command completion
> + * @work: pointer to a work queue structure
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static void ufshcd_uic_cc_handler (struct work_struct *work)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba;
> +
> + =A0 =A0 =A0 hba =3D container_of(work, struct ufs_hba, uic_workq);
> +
> + =A0 =A0 =A0 if ((UIC_CMD_DME_LINK_STARTUP =3D=3D hba->active_uic_cm=
d.command) &&
> + =A0 =A0 =A0 =A0 =A0 !(ufshcd_get_uic_cmd_result(hba))) {
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (ufshcd_make_hba_operational(hba))
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&hba->pdev->dev=
,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 "cc: hb=
a not operational state\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 return;
> + =A0 =A0 =A0 }
> +}
> +
> +/**
> + * ufshcd_sl_intr - Interrupt service routine
> + * @hba: per adapter instance
> + * @intr_status: contains interrupts generated by the controller
> + */
> +static void ufshcd_sl_intr(struct ufs_hba *hba, u32 intr_status)
> +{
> + =A0 =A0 =A0 if (intr_status & UIC_COMMAND_COMPL)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 schedule_work(&hba->uic_workq);
> +}
> +
> +/**
> + * ufshcd_intr - Main interrupt service routine
> + * @irq: irq number
> + * @__hba: pointer to adapter instance
> + *
> + * Returns IRQ_HANDLED - If interrupt is valid
> + * =A0 =A0 =A0 =A0 =A0 =A0 IRQ_NONE - If invalid interrupt
> + */
> +static irqreturn_t ufshcd_intr(int irq, void *__hba)
> +{
> + =A0 =A0 =A0 unsigned long flags;
> + =A0 =A0 =A0 u32 intr_status;
> + =A0 =A0 =A0 irqreturn_t retval =3D IRQ_NONE;
> + =A0 =A0 =A0 struct ufs_hba *hba =3D __hba;
> +
> + =A0 =A0 =A0 spin_lock_irqsave(hba->host->host_lock, flags);
> + =A0 =A0 =A0 intr_status =3D readl(UFSHCD_MMIO_BASE + REG_INTERRUPT_=
STATUS);
> +
> + =A0 =A0 =A0 if (intr_status) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 ufshcd_sl_intr(hba, intr_status);
> +
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 /* If UFSHCI 1.0 then clear interrupt s=
tatus register */
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (UFSHCI_VERSION_10 =3D=3D hba->ufs_v=
ersion)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 writel(intr_status,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0(UFSHCD_=
MMIO_BASE + REG_INTERRUPT_STATUS));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 retval =3D IRQ_HANDLED;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 spin_unlock_irqrestore(hba->host->host_lock, flags);
> + =A0 =A0 =A0 return retval;
> +}
> +
> +static struct scsi_host_template ufshcd_driver_template =3D {
> + =A0 =A0 =A0 .module =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D THIS_MODULE=
,
> + =A0 =A0 =A0 .name =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D UFSHCD,
> + =A0 =A0 =A0 .proc_name =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D UFSHCD,
> + =A0 =A0 =A0 .this_id =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D -1,
> +};
> +
> +/**
> + * ufshcd_shutdown - main funciton to put the controller in reset st=
ate
> + * @pdev: pointer to PCI device handle
> + */
> +static void ufshcd_shutdown(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 ufshcd_hba_stop((struct ufs_hba *)pci_get_drvdata(pdev)=
);
> +}
> +
> +#ifdef CONFIG_PM
> +/**
> + * ufshcd_suspend - suspend power management function
> + * @pdev: pointer to PCI device handle
> + * @state: power state
> + *
> + * Returns -ENOSYS
> + */
> +static int ufshcd_suspend(struct pci_dev *pdev, pm_message_t state)
> +{
> + =A0 =A0 =A0 return -ENOSYS;
> +}
> +
> +/**
> + * ufshcd_resume - resume power management function
> + * @pdev: pointer to PCI device handle
> + *
> + * Returns -ENOSYS
> + */
> +static int ufshcd_resume(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 return -ENOSYS;
> +}
> +#endif /* CONFIG_PM */
> +
> +/**
> + * ufshcd_hba_free - free allocated memory for
> + * =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 host memory space data st=
ructures
> + * @hba: per adapter instance
> + */
> +static void ufshcd_hba_free(struct ufs_hba *hba)
> +{
> + =A0 =A0 =A0 iounmap(UFSHCD_MMIO_BASE);
> + =A0 =A0 =A0 ufshcd_free_hba_memory(hba);
> + =A0 =A0 =A0 pci_release_regions(hba->pdev);
> +}
> +
> +/**
> + * ufshcd_remove - deallocate PCI/SCSI host and host memory space
> + * =A0 =A0 =A0 =A0 =A0 =A0 data structure memory
> + * @pdev - pointer to PCI handle
> + */
> +static void ufshcd_remove(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 struct ufs_hba *hba =3D pci_get_drvdata(pdev);
> +
> + =A0 =A0 =A0 /* disable interrupts */
> + =A0 =A0 =A0 ufshcd_int_config(hba, UFSHCD_INT_DISABLE);
> + =A0 =A0 =A0 free_irq(pdev->irq, hba);
> +
> + =A0 =A0 =A0 ufshcd_hba_stop(hba);
> + =A0 =A0 =A0 ufshcd_hba_free(hba);
> +
> + =A0 =A0 =A0 scsi_remove_host(hba->host);
> + =A0 =A0 =A0 scsi_host_put(hba->host);
> + =A0 =A0 =A0 pci_set_drvdata(pdev, NULL);
> + =A0 =A0 =A0 pci_clear_master(pdev);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +}
> +
> +/**
> + * ufshcd_set_dma_mask - Set dma addressing
> + * @pdev: PCI device struct
> + *
> + * Returns 0 for success, non-zero for failure
> + */
> +static int ufshcd_set_dma_mask(struct pci_dev *pdev)
> +{
> + =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 do {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(64));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pci_set_consist=
ent_dma_mask(pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMA_BIT_MASK(64));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 break;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 }
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pci_set_dma_mask(pdev, DMA_BIT_=
MASK(32));
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 if (!err)
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D pci_set_consist=
ent_dma_mask(pdev,
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DMA_BIT_MASK(32));
> + =A0 =A0 =A0 } while (0);
> +
> + =A0 =A0 =A0 return err;
> +}
> +
> +/**
> + * ufshcd_probe - probe routine of the driver
> + * @pdev: pointer to PCI device handle
> + * @id: PCI device id
> + *
> + * Returns 0 on success, non-zero value on failure
> + */
> +static int __devinit
> +ufshcd_probe(struct pci_dev *pdev, const struct pci_device_id *id)
> +{
> + =A0 =A0 =A0 struct Scsi_Host *host;
> + =A0 =A0 =A0 struct ufs_hba *hba;
> + =A0 =A0 =A0 int ufs_hba_len;
> + =A0 =A0 =A0 int err;
> +
> + =A0 =A0 =A0 ufs_hba_len =3D sizeof(struct ufs_hba);
> + =A0 =A0 =A0 err =3D pci_enable_device(pdev);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "pci_enable_device =
failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_error;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pci_set_master(pdev);
> +
> + =A0 =A0 =A0 host =3D scsi_host_alloc(&ufshcd_driver_template, ufs_h=
ba_len);
> + =A0 =A0 =A0 if (!host) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "scsi_host_alloc fa=
iled\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_disable;
> + =A0 =A0 =A0 }
> + =A0 =A0 =A0 hba =3D (struct ufs_hba *)host->hostdata;
> +
> + =A0 =A0 =A0 err =3D pci_request_regions(pdev, UFSHCD);
> + =A0 =A0 =A0 if (err < 0) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "request regions fa=
iled\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_disable;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 hba->mmio_base =3D pci_ioremap_bar(pdev, 0);
> + =A0 =A0 =A0 if (!hba->mmio_base) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "memory map failed\=
n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 err =3D -ENOMEM;
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_release_regions;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 err =3D ufshcd_set_dma_mask(pdev);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "set dma mask faile=
d\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_iounmap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 hba->host =3D host;
> + =A0 =A0 =A0 hba->pdev =3D pdev;
> +
> + =A0 =A0 =A0 /* Read capabilities registers */
> + =A0 =A0 =A0 ufshcd_hba_capabilities(hba);
> +
> + =A0 =A0 =A0 /* Get UFS version supported by the controller */
> + =A0 =A0 =A0 hba->ufs_version =3D ufshcd_get_ufs_version(hba);
> +
> + =A0 =A0 =A0 /* Allocate memory for host memory space */
> + =A0 =A0 =A0 err =3D ufshcd_memory_alloc(hba);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Memory allocation =
failed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_iounmap;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Configure LRB */
> + =A0 =A0 =A0 ufshcd_host_memory_configure(hba);
> +
> + =A0 =A0 =A0 host->can_queue =3D hba->nutrs;
> + =A0 =A0 =A0 host->max_id =3D UFSHCD_MAX_ID;
> + =A0 =A0 =A0 host->max_lun =3D UFSHCD_MAX_LUNS;
> + =A0 =A0 =A0 host->max_channel =3D UFSHCD_MAX_CHANNEL;
> + =A0 =A0 =A0 host->unique_id =3D host->host_no;
> +
> + =A0 =A0 =A0 /* Initialize work queues */
> + =A0 =A0 =A0 INIT_WORK(&hba->uic_workq, ufshcd_uic_cc_handler);
> +
> + =A0 =A0 =A0 /* IRQ registration */
> + =A0 =A0 =A0 err =3D request_irq(pdev->irq, ufshcd_intr, IRQF_SHARED=
, UFSHCD, hba);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "request irq failed=
\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_lrb_free;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 pci_set_drvdata(pdev, hba);
> +
> + =A0 =A0 =A0 err =3D scsi_add_host(host, &pdev->dev);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "scsi_add_host fail=
ed\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_irq;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 /* Initialization routine */
> + =A0 =A0 =A0 err =3D ufshcd_initialize_hba(hba);
> + =A0 =A0 =A0 if (err) {
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 dev_err(&pdev->dev, "Initialization fai=
led\n");
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 goto out_free_irq;
> + =A0 =A0 =A0 }
> +
> + =A0 =A0 =A0 return 0;
> +
> +out_free_irq:
> + =A0 =A0 =A0 free_irq(pdev->irq, hba);
> +out_lrb_free:
> + =A0 =A0 =A0 ufshcd_free_hba_memory(hba);
> +out_iounmap:
> + =A0 =A0 =A0 iounmap(hba->mmio_base);
> +out_release_regions:
> + =A0 =A0 =A0 pci_release_regions(pdev);
> +out_disable:
> + =A0 =A0 =A0 scsi_host_put(host);
> + =A0 =A0 =A0 pci_clear_master(pdev);
> + =A0 =A0 =A0 pci_disable_device(pdev);
> +out_error:
> + =A0 =A0 =A0 return err;
> +}
> +
> +static DEFINE_PCI_DEVICE_TABLE(ufshcd_pci_tbl) =3D {
> + =A0 =A0 =A0 { 0x144D, 0xC00C, PCI_ANY_ID, PCI_ANY_ID, 0, 0, 0 },
> + =A0 =A0 =A0 { } =A0 =A0 /* terminate list */
> +};
> +
> +MODULE_DEVICE_TABLE(pci, ufshcd_pci_tbl);
> +
> +static struct pci_driver ufshcd_pci_driver =3D {
> + =A0 =A0 =A0 .name =3D UFSHCD,
> + =A0 =A0 =A0 .id_table =3D ufshcd_pci_tbl,
> + =A0 =A0 =A0 .probe =3D ufshcd_probe,
> + =A0 =A0 =A0 .remove =3D __devexit_p(ufshcd_remove),
> + =A0 =A0 =A0 .shutdown =3D ufshcd_shutdown,
> +#ifdef CONFIG_PM
> + =A0 =A0 =A0 .suspend =3D ufshcd_suspend,
> + =A0 =A0 =A0 .resume =3D ufshcd_resume,
> +#endif
> +};
> +
> +/**
> + * ufshcd_init - Driver registration routine
> + */
> +static int __init ufshcd_init(void)
> +{
> + =A0 =A0 =A0 return pci_register_driver(&ufshcd_pci_driver);
> +}
> +module_init(ufshcd_init);
> +
> +/**
> + * ufshcd_exit - Driver exit clean-up routine
> + */
> +static void __exit ufshcd_exit(void)
> +{
> + =A0 =A0 =A0 pci_unregister_driver(&ufshcd_pci_driver);
> +}
> +module_exit(ufshcd_exit);
> +
> +
> +MODULE_AUTHOR("Santosh Yaragnavi, Vinayak Holikatti");
> +MODULE_DESCRIPTION("Generic UFS host controller driver");
> +MODULE_LICENSE("GPL");
> +MODULE_VERSION(UFSHCD_DRIVER_VERSION);
> diff --git a/drivers/scsi/ufs/ufshci.h b/drivers/scsi/ufs/ufshci.h
> new file mode 100644
> index 0000000..f8701b7
> --- /dev/null
> +++ b/drivers/scsi/ufs/ufshci.h
> @@ -0,0 +1,360 @@
> +/*
> + * Universal Flash Storage Host controller driver
> + *
> + * This code is based on drivers/scsi/ufs/ufshci.h
> + * Copyright (C) 2011-2012 Samsung India Software Operations
> + *
> + * Santosh Yaraganavi <santosh.sy@samsung.com>
> + * Vinayak Holikatti <h.vinayak@samsung.com>
> + *
> + * This program is free software; you can redistribute it and/or
> + * modify it under the terms of the GNU General Public License
> + * as published by the Free Software Foundation; either version 2
> + * of the License, or (at your option) any later version.
> + *
> + * This program is distributed in the hope that it will be useful,
> + * but WITHOUT ANY WARRANTY; without even the implied warranty of
> + * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. =A0See the
> + * GNU General Public License for more details.
> + *
> + * NO WARRANTY
> + * THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES O=
R
> + * CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITH=
OUT
> + * LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEME=
NT,
> + * MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipie=
nt is
> + * solely responsible for determining the appropriateness of using a=
nd
> + * distributing the Program and assumes all risks associated with it=
s
> + * exercise of rights under this Agreement, including but not limite=
d to
> + * the risks and costs of program errors, damage to or loss of data,
> + * programs or equipment, and unavailability or interruption of oper=
ations.
> +
> + * DISCLAIMER OF LIABILITY
> + * NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY F=
OR ANY
> + * DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIA=
L
> + * DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUS=
ED AND
> + * ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY=
, OR
> + * TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT O=
=46 THE
> + * USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS =
GRANTED
> + * HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> + * You should have received a copy of the GNU General Public License
> + * along with this program; if not, write to the Free Software
> + * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA =A0=
02110-1301,
> + * USA.
> + */
> +
> +#ifndef _UFSHCI_H
> +#define _UFSHCI_H
> +
> +/* UFSHCI Registers */
> +enum {
> + =A0 =A0 =A0 REG_CONTROLLER_CAPABILITIES =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 0x00,
> + =A0 =A0 =A0 REG_UFS_VERSION =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =3D 0x08,
> + =A0 =A0 =A0 REG_CONTROLLER_DEV_ID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x10,
> + =A0 =A0 =A0 REG_CONTROLLER_PROD_ID =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D 0x14,
> + =A0 =A0 =A0 REG_INTERRUPT_STATUS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=3D 0x20,
> + =A0 =A0 =A0 REG_INTERRUPT_ENABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0=3D 0x24,
> + =A0 =A0 =A0 REG_CONTROLLER_STATUS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x30,
> + =A0 =A0 =A0 REG_CONTROLLER_ENABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x34,
> + =A0 =A0 =A0 REG_UIC_ERROR_CODE_PHY_ADAPTER_LAYER =A0 =A0=3D 0x38,
> + =A0 =A0 =A0 REG_UIC_ERROR_CODE_DATA_LINK_LAYER =A0 =A0 =A0=3D 0x3C,
> + =A0 =A0 =A0 REG_UIC_ERROR_CODE_NETWORK_LAYER =A0 =A0 =A0 =A0=3D 0x4=
0,
> + =A0 =A0 =A0 REG_UIC_ERROR_CODE_TRANSPORT_LAYER =A0 =A0 =A0=3D 0x44,
> + =A0 =A0 =A0 REG_UIC_ERROR_CODE_DME =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D 0x48,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_INT_AGG_CONTROL =A0 =A0=3D 0x4C,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LIST_BASE_L =A0 =A0 =A0 =A0=3D 0x5=
0,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LIST_BASE_H =A0 =A0 =A0 =A0=3D 0x5=
4,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_DOOR_BELL =A0 =A0 =A0 =A0 =A0=3D 0=
x58,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LIST_CLEAR =A0 =A0 =A0 =A0 =3D 0x5=
C,
> + =A0 =A0 =A0 REG_UTP_TRANSFER_REQ_LIST_RUN_STOP =A0 =A0 =A0=3D 0x60,
> + =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_BASE_L =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x70,
> + =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_BASE_H =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x74,
> + =A0 =A0 =A0 REG_UTP_TASK_REQ_DOOR_BELL =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x78,
> + =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_CLEAR =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 0x7C,
> + =A0 =A0 =A0 REG_UTP_TASK_REQ_LIST_RUN_STOP =A0 =A0 =A0 =A0 =A0=3D 0=
x80,
> + =A0 =A0 =A0 REG_UIC_COMMAND =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0 =3D 0x90,
> + =A0 =A0 =A0 REG_UIC_COMMAND_ARG_1 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x94,
> + =A0 =A0 =A0 REG_UIC_COMMAND_ARG_2 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x98,
> + =A0 =A0 =A0 REG_UIC_COMMAND_ARG_3 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =3D 0x9C
> +};
> +
> +/* Controller capability masks */
> +enum {
> + =A0 =A0 =A0 MASK_TRANSFER_REQUESTS_SLOTS =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x0000001F,
> + =A0 =A0 =A0 MASK_TASK_MANAGEMENT_REQUEST_SLOTS =A0 =A0 =A0=3D 0x000=
70000,
> + =A0 =A0 =A0 MASK_64_ADDRESSING_SUPPORT =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x01000000,
> + =A0 =A0 =A0 MASK_OUT_OF_ORDER_DATA_DELIVERY_SUPPORT =3D 0x02000000,
> + =A0 =A0 =A0 MASK_UIC_DME_TEST_MODE_SUPPORT =A0 =A0 =A0 =A0 =A0=3D 0=
x04000000
> +};
> +
> +/* UFS Version 08h */
> +#define MINOR_VERSION_NUM_MASK =A0 =A0 =A0 =A0 UFS_MASK(0xFFFF, 0)
> +#define MAJOR_VERSION_NUM_MASK =A0 =A0 =A0 =A0 UFS_MASK(0xFFFF, 16)
> +
> +/* Controller UFSHCI version */
> +enum {
> + =A0 =A0 =A0 UFSHCI_VERSION_10 =3D 0x00010000,
> + =A0 =A0 =A0 UFSHCI_VERSION_11 =3D 0x00010100
> +};
> +
> +/*
> + * HCDDID - Host Controller Identification Descriptor
> + * =A0 =A0 =A0 - Device ID and Device Class 10h
> + */
> +#define DEVICE_CLASS =A0 UFS_MASK(0xFFFF, 0)
> +#define DEVICE_ID =A0 =A0 =A0UFS_MASK(0xFF, 24)
> +
> +/*
> + * HCPMID - Host Controller Identification Descriptor
> + * =A0 =A0 =A0 - Product/Manufacturer ID =A014h
> + */
> +#define MANUFACTURE_ID_MASK =A0 =A0UFS_MASK(0xFFFF, 0)
> +#define PRODUCT_ID_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UFS_MASK(0xFF=
=46F, 16)
> +
> +#define UFS_BIT(x) =A0 =A0 (1L << (x))
> +
> +#define UTP_TRANSFER_REQ_COMPL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS_B=
IT(0)
> +#define UIC_DME_END_PT_RESET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS=
_BIT(1)
> +#define UIC_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =A0UFS_BIT(2)
> +#define UIC_TEST_MODE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0UFS_BIT(3)
> +#define UIC_POWER_MODE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 UFS_BIT(4)
> +#define UIC_HIBERNATE_EXIT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 U=
=46S_BIT(5)
> +#define UIC_HIBERNATE_ENTER =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0U=
=46S_BIT(6)
> +#define UIC_LINK_LOST =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0UFS_BIT(7)
> +#define UIC_LINK_STARTUP =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 UFS_BIT(8)
> +#define UTP_TASK_REQ_COMPL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 U=
=46S_BIT(9)
> +#define UIC_COMMAND_COMPL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
UFS_BIT(10)
> +#define DEVICE_FATAL_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 U=
=46S_BIT(11)
> +#define CONTROLLER_FATAL_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS_B=
IT(16)
> +#define SYSTEM_BUS_FATAL_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS_B=
IT(17)
> +
> +#define UFSHCD_ERROR_MASK =A0 =A0 =A0(UIC_ERROR |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 DEVICE_=
=46ATAL_ERROR |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CONTROL=
LER_FATAL_ERROR |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SYSTEM_=
BUS_FATAL_ERROR)
> +
> +#define INT_FATAL_ERRORS =A0 =A0 =A0 (DEVICE_FATAL_ERROR |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 CONTROL=
LER_FATAL_ERROR |\
> + =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 SYSTEM_=
BUS_FATAL_ERROR)
> +
> +/* HCS - Host Controller Status 30h */
> +#define DEVICE_PRESENT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 UFS_BIT(0)
> +#define UTP_TRANSFER_REQ_LIST_READY =A0 =A0 =A0 =A0 =A0 =A0UFS_BIT(1=
)
> +#define UTP_TASK_REQ_LIST_READY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0UFS_BIT(2)
> +#define UIC_COMMAND_READY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
UFS_BIT(3)
> +#define HOST_ERROR_INDICATOR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS=
_BIT(4)
> +#define DEVICE_ERROR_INDICATOR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS_B=
IT(5)
> +#define UIC_POWER_MODE_CHANGE_REQ_STATUS_MASK =A0UFS_MASK(0x7, 8)
> +
> +/* HCE - Host Controller Enable 34h */
> +#define CONTROLLER_ENABLE =A0 =A0 =A0UFS_BIT(0)
> +
> +/* UECPA - Host UIC Error Code PHY Adapter Layer 38h */
> +#define UIC_PHY_ADAPTER_LAYER_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0UFS_BIT(31)
> +#define UIC_PHY_ADAPTER_LAYER_ERROR_CODE_MASK =A0 =A0 =A0 =A0 =A00x1=
=46
> +
> +/* UECDL - Host UIC Error Code Data Link Layer 3Ch */
> +#define UIC_DATA_LINK_LAYER_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0UFS_BIT=
(31)
> +#define UIC_DATA_LINK_LAYER_ERROR_CODE_MASK =A0 =A00x7FFF
> +#define UIC_DATA_LINK_LAYER_ERROR_PA_INIT =A0 =A0 =A00x2000
> +
> +/* UECN - Host UIC Error Code Network Layer 40h */
> +#define UIC_NETWORK_LAYER_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0UFS_BIT(31)
> +#define UIC_NETWORK_LAYER_ERROR_CODE_MASK =A0 =A0 =A00x7
> +
> +/* UECT - Host UIC Error Code Transport Layer 44h */
> +#define UIC_TRANSPORT_LAYER_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0UFS_BIT=
(31)
> +#define UIC_TRANSPORT_LAYER_ERROR_CODE_MASK =A0 =A00x7F
> +
> +/* UECDME - Host UIC Error Code DME 48h */
> +#define UIC_DME_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0UFS_BIT(31)
> +#define UIC_DME_ERROR_CODE_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00x1
> +
> +#define INT_AGGR_TIMEOUT_VAL_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A00xFF
> +#define INT_AGGR_COUNTER_THRESHOLD_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0UFS_MASK(0x1F, 8)
> +#define INT_AGGR_COUNTER_AND_TIMER_RESET =A0 =A0 =A0 UFS_BIT(16)
> +#define INT_AGGR_STATUS_BIT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0U=
=46S_BIT(20)
> +#define INT_AGGR_PARAM_WRITE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 UFS=
_BIT(24)
> +#define INT_AGGR_ENABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A0 =A0 =A0UFS_BIT(31)
> +
> +/* UTRLRSR - UTP Transfer Request Run-Stop Register 60h */
> +#define UTP_TRANSFER_REQ_LIST_RUN_STOP_BIT =A0 =A0 UFS_BIT(0)
> +
> +/* UTMRLRSR - UTP Task Management Request Run-Stop Register 80h */
> +#define UTP_TASK_REQ_LIST_RUN_STOP_BIT =A0 =A0 =A0 =A0 UFS_BIT(0)
> +
> +/* UICCMD - UIC Command */
> +#define COMMAND_OPCODE_MASK =A0 =A0 =A0 =A0 =A0 =A00xFF
> +#define GEN_SELECTOR_INDEX_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xFFF=
=46
> +
> +#define MIB_ATTRIBUTE_MASK =A0 =A0 =A0 =A0 =A0 =A0 UFS_MASK(0xFFFF, =
16)
> +#define RESET_LEVEL =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xFF
> +
> +#define ATTR_SET_TYPE_MASK =A0 =A0 =A0 =A0 =A0 =A0 UFS_MASK(0xFF, 16=
)
> +#define CONFIG_RESULT_CODE_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xFF
> +#define GENERIC_ERROR_CODE_MASK =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A00xFF
> +
> +/* UIC Commands */
> +enum {
> + =A0 =A0 =A0 UIC_CMD_DME_GET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x0=
1,
> + =A0 =A0 =A0 UIC_CMD_DME_SET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x0=
2,
> + =A0 =A0 =A0 UIC_CMD_DME_PEER_GET =A0 =A0 =A0 =A0 =A0 =A0=3D 0x03,
> + =A0 =A0 =A0 UIC_CMD_DME_PEER_SET =A0 =A0 =A0 =A0 =A0 =A0=3D 0x04,
> + =A0 =A0 =A0 UIC_CMD_DME_POWERON =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x10,
> + =A0 =A0 =A0 UIC_CMD_DME_POWEROFF =A0 =A0 =A0 =A0 =A0 =A0=3D 0x11,
> + =A0 =A0 =A0 UIC_CMD_DME_ENABLE =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x12,
> + =A0 =A0 =A0 UIC_CMD_DME_RESET =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x14,
> + =A0 =A0 =A0 UIC_CMD_DME_END_PT_RST =A0 =A0 =A0 =A0 =A0=3D 0x15,
> + =A0 =A0 =A0 UIC_CMD_DME_LINK_STARTUP =A0 =A0 =A0 =A0=3D 0x16,
> + =A0 =A0 =A0 UIC_CMD_DME_HIBER_ENTER =A0 =A0 =A0 =A0 =3D 0x17,
> + =A0 =A0 =A0 UIC_CMD_DME_HIBER_EXIT =A0 =A0 =A0 =A0 =A0=3D 0x18,
> + =A0 =A0 =A0 UIC_CMD_DME_TEST_MODE =A0 =A0 =A0 =A0 =A0 =3D 0x1A
> +};
> +
> +/* UIC Config result code / Generic error code */
> +enum {
> + =A0 =A0 =A0 UIC_CMD_RESULT_SUCCESS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D 0x00,
> + =A0 =A0 =A0 UIC_CMD_RESULT_INVALID_ATTR =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 0x01,
> + =A0 =A0 =A0 UIC_CMD_RESULT_FAILURE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0=3D 0x01,
> + =A0 =A0 =A0 UIC_CMD_RESULT_INVALID_ATTR_VALUE =A0 =A0 =A0 =3D 0x02,
> + =A0 =A0 =A0 UIC_CMD_RESULT_READ_ONLY_ATTR =A0 =A0 =A0 =A0 =A0 =3D 0=
x03,
> + =A0 =A0 =A0 UIC_CMD_RESULT_WRITE_ONLY_ATTR =A0 =A0 =A0 =A0 =A0=3D 0=
x04,
> + =A0 =A0 =A0 UIC_CMD_RESULT_BAD_INDEX =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
=3D 0x05,
> + =A0 =A0 =A0 UIC_CMD_RESULT_LOCKED_ATTR =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x06,
> + =A0 =A0 =A0 UIC_CMD_RESULT_BAD_TEST_FEATURE_INDEX =A0 =3D 0x07,
> + =A0 =A0 =A0 UIC_CMD_RESULT_PEER_COMM_FAILURE =A0 =A0 =A0 =A0=3D 0x0=
8,
> + =A0 =A0 =A0 UIC_CMD_RESULT_BUSY =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
 =A0 =3D 0x09,
> + =A0 =A0 =A0 UIC_CMD_RESULT_DME_FAILURE =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D=
 0x0A
> +};
> +
> +#define MASK_UIC_COMMAND_RESULT =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =
=A0 =A0 =A00xFF
> +
> +#define INT_AGGR_COUNTER_THRESHOLD_VALUE =A0 =A0 =A0 (0x1F << 8)
> +#define INT_AGGR_TIMEOUT_VALUE =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 (0x02=
)
> +
> +/*
> + * Request Descriptor Definitions
> + */
> +
> +/* Transfer request command type */
> +enum {
> + =A0 =A0 =A0 UTP_CMD_TYPE_SCSI =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x0,
> + =A0 =A0 =A0 UTP_CMD_TYPE_UFS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x1=
,
> + =A0 =A0 =A0 UTP_CMD_TYPE_DEV_MANAGE =A0 =A0 =A0 =A0 =3D 0x2
> +};
> +
> +enum {
> + =A0 =A0 =A0 UTP_SCSI_COMMAND =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=3D 0x0=
0000000,
> + =A0 =A0 =A0 UTP_NATIVE_UFS_COMMAND =A0 =A0 =A0 =A0 =A0=3D 0x1000000=
0,
> + =A0 =A0 =A0 UTP_DEVICE_MANAGEMENT_FUNCTION =A0=3D 0x20000000,
> + =A0 =A0 =A0 UTP_REQ_DESC_INT_CMD =A0 =A0 =A0 =A0 =A0 =A0=3D 0x01000=
000
> +};
> +
> +/* UTP Transfer Request Data Direction (DD) */
> +enum {
> + =A0 =A0 =A0 UTP_NO_DATA_TRANSFER =A0 =A0=3D 0x00000000,
> + =A0 =A0 =A0 UTP_HOST_TO_DEVICE =A0 =A0 =A0=3D 0x02000000,
> + =A0 =A0 =A0 UTP_DEVICE_TO_HOST =A0 =A0 =A0=3D 0x04000000
> +};
> +
> +/* Overall command status values */
> +enum {
> + =A0 =A0 =A0 OCS_SUCCESS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 0x0,
> + =A0 =A0 =A0 OCS_INVALID_CMD_TABLE_ATTR =A0 =A0 =A0=3D 0x1,
> + =A0 =A0 =A0 OCS_INVALID_PRDT_ATTR =A0 =A0 =A0 =A0 =A0 =3D 0x2,
> + =A0 =A0 =A0 OCS_MISMATCH_DATA_BUF_SIZE =A0 =A0 =A0=3D 0x3,
> + =A0 =A0 =A0 OCS_MISMATCH_RESP_UPIU_SIZE =A0 =A0 =3D 0x4,
> + =A0 =A0 =A0 OCS_PEER_COMM_FAILURE =A0 =A0 =A0 =A0 =A0 =3D 0x5,
> + =A0 =A0 =A0 OCS_ABORTED =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D=
 0x6,
> + =A0 =A0 =A0 OCS_FATAL_ERROR =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =3D 0x7=
,
> + =A0 =A0 =A0 OCS_INVALID_COMMAND_STATUS =A0 =A0 =A0=3D 0x0F,
> + =A0 =A0 =A0 MASK_OCS =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=
=3D 0x0F
> +};
> +
> +/**
> + * struct ufshcd_sg_entry - UFSHCI PRD Entry
> + * @base_addr: Lower 32bit physical address DW-0
> + * @upper_addr: Upper 32bit physical address DW-1
> + * @reserved: Reserved for future use DW-2
> + * @size: size of physical segment DW-3
> + */
> +struct ufshcd_sg_entry {
> + =A0 =A0 =A0 u32 =A0 =A0base_addr;
> + =A0 =A0 =A0 u32 =A0 =A0upper_addr;
> + =A0 =A0 =A0 u32 =A0 =A0reserved;
> + =A0 =A0 =A0 u32 =A0 =A0size;
> +};
> +
> +/**
> + * struct utp_transfer_cmd_desc - UFS Commad Descriptor structure
> + * @command_upiu: Command UPIU Frame address
> + * @response_upiu: Response UPIU Frame address
> + * @prd_table: Physcial Region Descriptor
> + */
> +struct utp_transfer_cmd_desc {
> + =A0 =A0 =A0 u8 command_upiu[ALIGNED_UPIU_SIZE];
> + =A0 =A0 =A0 u8 response_upiu[ALIGNED_UPIU_SIZE];
> + =A0 =A0 =A0 struct ufshcd_sg_entry =A0 =A0prd_table[SG_ALL];
> +};
> +
> +/**
> + * struct request_desc_header - Descriptor Header common to both UTR=
D and UTMRD
> + * @dword0: Descriptor Header DW0
> + * @dword1: Descriptor Header DW1
> + * @dword2: Descriptor Header DW2
> + * @dword3: Descriptor Header DW3
> + */
> +struct request_desc_header {
> + =A0 =A0 =A0 u32 dword_0;
> + =A0 =A0 =A0 u32 dword_1;
> + =A0 =A0 =A0 u32 dword_2;
> + =A0 =A0 =A0 u32 dword_3;
> +};
> +
> +/**
> + * struct utp_transfer_req_desc - UTRD structure
> + * @header: UTRD header DW-0 to DW-3
> + * @command_desc_base_addr_lo: UCD base address low DW-4
> + * @command_desc_base_addr_hi: UCD base address high DW-5
> + * @response_upiu_length: response UPIU length DW-6
> + * @response_upiu_offset: response UPIU offset DW-6
> + * @prd_table_length: Physical region descriptor length DW-7
> + * @prd_table_offset: Physical region descriptor offset DW-7
> + */
> +struct utp_transfer_req_desc {
> +
> + =A0 =A0 =A0 /* DW 0-3 */
> + =A0 =A0 =A0 struct request_desc_header header;
> +
> + =A0 =A0 =A0 /* DW 4-5*/
> + =A0 =A0 =A0 u32 =A0command_desc_base_addr_lo;
> + =A0 =A0 =A0 u32 =A0command_desc_base_addr_hi;
> +
> + =A0 =A0 =A0 /* DW 6 */
> + =A0 =A0 =A0 u16 =A0response_upiu_length;
> + =A0 =A0 =A0 u16 =A0response_upiu_offset;
> +
> + =A0 =A0 =A0 /* DW 7 */
> + =A0 =A0 =A0 u16 =A0prd_table_length;
> + =A0 =A0 =A0 u16 =A0prd_table_offset;
> +};
> +
> +/**
> + * struct utp_task_req_desc - UTMRD structure
> + * @header: UTMRD header DW-0 to DW-3
> + * @task_req_upiu: Pointer to task request UPIU DW-4 to DW-11
> + * @task_rsp_upiu: Pointer to task response UPIU DW12 to DW-19
> + */
> +struct utp_task_req_desc {
> +
> + =A0 =A0 =A0 /* DW 0-3 */
> + =A0 =A0 =A0 struct request_desc_header header;
> +
> + =A0 =A0 =A0 /* DW 4-11 */
> + =A0 =A0 =A0 u32 task_req_upiu[TASK_REQ_UPIU_SIZE_DWORDS];
> +
> + =A0 =A0 =A0 /* DW 12-19 */
> + =A0 =A0 =A0 u32 task_rsp_upiu[TASK_RSP_UPIU_SIZE_DWORDS];
> +};
> +
> +#endif /* End of Header */
> --
> 1.7.5.4
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
