From: "lindar_liu" <lindar_liu@usish.com>
Subject: Re: [RFC][PATCH 5/5] Add pm8001 SAS/SATA HBA driver resend
Date: Thu, 2 Jul 2009 10:30:34 +0800
Message-ID: <C99FE528BF0A4B669B2DE199C3E2D810@usish.com.cn>
References: <7070AF0E3911400C93DCB795F4E5CE09@usish.com.cn> <20090702021420.GG5480@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from usish.com ([210.5.144.203]:55194 "EHLO sr-smtp.usish.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753094AbZGBCsS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 1 Jul 2009 22:48:18 -0400
In-Reply-To: <20090702021420.GG5480@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: 'Matthew Wilcox' <matthew@wil.cx>, 'jack wang' <jack_wang@usish.com>
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org, jeff@garzik.org, tom_peng@usish.com


Re: [RFC][PATCH 5/5] Add pm8001 SAS/SATA HBA driver resend

On Thu, Jul 02, 2009 at 09:43:57AM +0800, jack wang wrote:
> diff --git a/drivers/scsi/pm8001/Kconfig b/drivers/scsi/pm8001/Kconfig
> new file mode 100644
> index 0000000..4db6021
> --- /dev/null
> +++ b/drivers/scsi/pm8001/Kconfig
> @@ -0,0 +1,48 @@
> + config SCSI_PM8001
> + 	tristate "PMC-Sierra SPC 8001 SAS/SATA Based Host Adapter driver"
> + 	depends on PCI && SCSI
> + 	select SCSI_SAS_LIBSAS
> + 	help
> +		This driver supports PMC-Sierra PCIE SAS/SATA 8x6G SPC 8001
> chip
> +		based host adapters.

Not really enough here to justify a separate Kconfig file.  How about
putting this bit in drivers/scsi/Kconfig instead of in its own file?
[lindar] ok,we will address it when next send.
> diff --git a/drivers/scsi/pm8001/Makefile b/drivers/scsi/pm8001/Makefile
> new file mode 100644
> index 0000000..6e668ae
> --- /dev/null
> +++ b/drivers/scsi/pm8001/Makefile
> @@ -0,0 +1,47 @@
> +#
> +# Kernel configuration file for the PM8001 SAS/SATA 8x6G based HBA driver
> +#
> +# Copyright (C) 2008-2009  USI Co., Ltd.
> +# Copyright (C) 2009 Jack Wang <jack_wang@usish.com>
> +
> +# This program is free software; you can redistribute it and/or
> +# modify it under the terms of the GNU General Public License
> +# as published by the Free Software Foundation; either version 2
> +# of the License, or (at your option) any later version.
> +
> +# This program is distributed in the hope that it will be useful,
> +# but WITHOUT ANY WARRANTY; without even the implied warranty of
> +# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
> +# GNU General Public License for more details.
> +
> +# NO WARRANTY
> +# THE PROGRAM IS PROVIDED ON AN "AS IS" BASIS, WITHOUT WARRANTIES OR
> +# CONDITIONS OF ANY KIND, EITHER EXPRESS OR IMPLIED INCLUDING, WITHOUT
> +# LIMITATION, ANY WARRANTIES OR CONDITIONS OF TITLE, NON-INFRINGEMENT,
> +# MERCHANTABILITY OR FITNESS FOR A PARTICULAR PURPOSE. Each Recipient is
> +# solely responsible for determining the appropriateness of using and
> +# distributing the Program and assumes all risks associated with its
> +# exercise of rights under this Agreement, including but not limited to
> +# the risks and costs of program errors, damage to or loss of data,
> +# programs or equipment, and unavailability or interruption of
operations.
> +
> +# DISCLAIMER OF LIABILITY
> +# NEITHER RECIPIENT NOR ANY CONTRIBUTORS SHALL HAVE ANY LIABILITY FOR ANY
> +# DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
> +# DAMAGES (INCLUDING WITHOUT LIMITATION LOST PROFITS), HOWEVER CAUSED AND
> +# ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR
> +# TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE
> +# USE OR DISTRIBUTION OF THE PROGRAM OR THE EXERCISE OF ANY RIGHTS
GRANTED
> +# HEREUNDER, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGES
> +
> +# You should have received a copy of the GNU General Public License
> +# along with this program; if not, write to the Free Software
> +# Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA
> 02110-1301,
> +# USA.

I'm not sure you need a copyright notice in the Makefile.  I don't think
what you have here is even copyrightable:
[lindar] ok,we will address it when next send.
> +obj-$(CONFIG_SCSI_PM8001) += pm8001.o
> +pm8001-y += pm8001_init.o \
> +	     pm8001_sas.o  \
> +	     pm8001_ctl.o  \
> +	     pm8001_hwi.o
> \ No newline at end of file

And you should look into putting a newline at the end of files.
[lindar] ok,we will address it when next send.
> +++ b/drivers/scsi/pm8001/pm8001_chips.h
> +#define READ_LE_32(ADDR32, DMA_ADDR, OFFSET)	\
> +	(*((u32 *)ADDR32)) = (*((u32 *)(((u8 *)DMA_ADDR) + (OFFSET))))
> +
> +#define WRITE_LE_32(DMA_ADDR, OFFSET, VALUE32)	\
> +	(*((u32 *)(((u8 *)DMA_ADDR)+(OFFSET)))) = (u32)(VALUE32)
> +
> +#define READ_LE_16(ADDR16, DMA_ADDR, OFFSET)	\
> +	(*((u16 *)ADDR16)) = (*((u16 *)(((u8 *)DMA_ADDR) + (OFFSET))))

Don't these macros assume that the processor is little-endian?  Have you
tested this driver on a big-endian platform, like powerpc, for example?
[lindar] ok,we will address it when next send.
> +/**
> + * pm8001_ctl_verify_adapter - validates chip_number passed from
> application
> + * @ppm8001_ha: per adapter object
> + * @chip_number: chip id.
> + *
> + * Return (-1) means error, else chip_number.
> + */
> +static int
> +pm8001_ctl_verify_adapter(int chip_number, struct pm8001_hba_info
> **ppm8001_ha)
> +{
> +	struct pm8001_hba_info *pm8001_ha;
> +	printk(KERN_INFO "chip_number = %d \n", chip_number);
> +
> +	list_for_each_entry(pm8001_ha, &hba_list, list) {
> +		printk(KERN_INFO "pm8001_ha->id = %x \n", pm8001_ha->id);

Is this a debugging printk left in, or do you really intend this to be
emitted to the kernel log?
[lindar] ok,we will address it when next send.
> +		if (pm8001_ha->id != chip_number)
> +			continue;
> +		*ppm8001_ha = pm8001_ha;
> +		return chip_number;
> +	}
> +	*ppm8001_ha = NULL;
> +	return -1;
> +}
> +
> +/**
> + * pm8001_ctl_ioctl_main - main ioctl entry point
> + * @file - (struct file)
> + * @cmd - ioctl opcode
> + * @arg -
> + */
> +static long
> +pm8001_ctl_ioctl_main(struct file *file, unsigned int cmd, void __user
> *arg)
> +{
> +	long ret = 0;
> +	u16 arg_length;
> +	struct pm8001_ioctl_payload __user *payload = (void __user *) arg;
> +	struct pm8001_ioctl_payload	*ioctl_payload ;
> +	DECLARE_COMPLETION_ONSTACK(completion);
> +	struct pm8001_hba_info *pm8001_ha = NULL;
> +	arg_length = sizeof(struct pm8001_ioctl_payload) + payload->length;
> +	ioctl_payload = kmalloc(arg_length, GFP_KERNEL);
> +
> +	if (copy_from_user(ioctl_payload, payload, arg_length)) {
> +		pm8001_printk("copy data from user space @ %p failed\n",
> +		payload);
> +		return -EFAULT;
> +	}
> +
> +	if (pm8001_ctl_verify_adapter(ioctl_payload->id, &pm8001_ha) == -1
> ||
> +		!pm8001_ha) {
> +		pm8001_printk("find the chip fail \n");
> +		return -ENODEV;
> +	}
> +
> +	pm8001_ha->nvmd_completion = &completion;
> +	switch (cmd) {
> +	case IOCTL_GET_EVENT_LOG1:
> +		PM8001_IOCTL_DBG(pm8001_ha,
> +			pm8001_printk("cmd:IOCTL_GET_EVENT_LOG1 \n"));
> +		ioctl_payload->status = IOCTL_STATUS_OK;
> +		if ((4096 + 32) < ioctl_payload->offset) {
> +			ioctl_payload->status = IOCTL_STATUS_NO_MORE_DATA;
> +			ioctl_payload->length = 0;
> +			ret = IOCTL_CALL_FAIL;
> +		}
> +		memcpy(ioctl_payload->func_specific,
> +		pm8001_ha->memoryMap.region[AAP1].virt_ptr +
> +		ioctl_payload->offset, ioctl_payload->length);
> +		if (copy_to_user((void *)arg, (void *)ioctl_payload,
> +			arg_length)) {
> +			pm8001_printk("copy to user ERROR\n");
> +			ret = -EFAULT;
> +		}
> +		kfree(ioctl_payload);
> +		return ret;
> +	case IOCTL_GET_EVENT_LOG2:
> +		PM8001_IOCTL_DBG(pm8001_ha,
> +			pm8001_printk(" cmd: IOCTL_GET_EVENT_LOG2 \n"));
> +		ioctl_payload->status = IOCTL_STATUS_OK;
> +		if ((4096+32) < ioctl_payload->offset) {
> +			ioctl_payload->status = IOCTL_STATUS_NO_MORE_DATA;
> +			ioctl_payload->length = 0;
> +			ret = IOCTL_CALL_FAIL;
> +		}
> +		memcpy(ioctl_payload->func_specific,
> +			(u8 *)pm8001_ha->memoryMap.region[IOP].virt_ptr,
> +			ioctl_payload->length);
> +		if (copy_to_user((void *)arg,
> +			(void *)ioctl_payload, arg_length)) {
> +			pm8001_printk("copy to user ERROR\n");
> +			ret = -EFAULT;
> +		}
> +		kfree(ioctl_payload);
> +		return ret;
> +	case IOCTL_FW_CONTROL:
> +		PM8001_IOCTL_DBG(pm8001_ha,
> +			pm8001_printk(" cmd: IOCTL_FW_CONTROL \n"));
> +		ret = PM8001_CHIP_DISP->fw_flash_update_req(pm8001_ha,
> +			0, ioctl_payload);
> +		break;
> +	case IOCTL_NVMD_GET:
> +		PM8001_IOCTL_DBG(pm8001_ha,
> +			pm8001_printk(" cmd: IOCTL_NVMD_GET \n"));
> +		ret = PM8001_CHIP_DISP->get_nvmd_req(pm8001_ha,
> +			0, ioctl_payload);
> +		break;
> +	case IOCTL_NVMD_SET:
> +		PM8001_IOCTL_DBG(pm8001_ha,
> +			pm8001_printk(" cmd: IOCTL_NVMD_SET \n"));
> +		ret = PM8001_CHIP_DISP->set_nvmd_req(pm8001_ha,
> +			0, ioctl_payload);
> +		break;
> +	default:
> +		return IOCTL_CALL_INVALID_CODE;
> +	}
> +	wait_for_completion(&completion);
> +	if (copy_to_user((void *)arg, (void *)ioctl_payload, arg_length)) {
> +		printk(KERN_INFO "copy to user ERROR\n");
> +		ret = -EFAULT;
> +	}
> +	kfree(ioctl_payload);
> +	return ret;
> +}
> +
> +/**
> + * pm8001_ctl_ioctl - main ioctl entry point (unlocked)
> + * @file - (struct file)
> + * @cmd - ioctl opcode
> + * @arg -
> + */
> +static long
> +pm8001_ctl_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
> +{
> +	long ret;
> +	lock_kernel();
> +	ret = pm8001_ctl_ioctl_main(file, cmd, (void __user *)arg);
> +	unlock_kernel();
> +	return ret;
> +}

Umm ... you probably don't need lock_kernel here.  And ioctls are
generally discouraged.  We've been encouraging people to use SG_IO to
send commands down like this.
[lindar] ok,we will address it when next send.
> +++ b/drivers/scsi/pm8001/pm8001_defs.h
> +#define PCI_VENDOR_ID_PMC_Sierra	0x11f8
> +#define PCI_DEVICE_ID_8001		0x8001

It should be in all caps ... and it should be in include/linux/pci_ids.h,
between PCI_VENDOR_ID_COMPEX and PCI_VENDOR_ID_RP.
[lindar] ok,we will address it when next send.
There's undoubtably more things to comment on ...

[lindar] Thanks for your comments.
-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

