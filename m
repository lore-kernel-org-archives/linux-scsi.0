From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/3] megaraid_sas: Convert printk to printk_<level>
Date: Tue, 27 Oct 2015 11:25:24 +0100
Message-ID: <1445941524.16404.36.camel@suse.de>
References: <1445934375-17784-1-git-send-email-wangweidong1@huawei.com>
	 <1445934375-17784-3-git-send-email-wangweidong1@huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445934375-17784-3-git-send-email-wangweidong1@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Weidong Wang <wangweidong1@huawei.com>, kashyap.desai@avagotech.com, sumit.saxena@avagotech.com, uday.lingala@avagotech.com, JBottomley@odin.com
Cc: megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 2015-10-27 at 16:26 +0800, Weidong Wang wrote:
> Reduce object size a little by using pr_<level>
> calls instead of printk(KERN_<LEVEL>.
>=20
> Signed-off-by: Weidong Wang <wangweidong1@huawei.com>
> ---
> =C2=A0drivers/scsi/megaraid/megaraid_sas_base.c | 14 +++++++-------
> =C2=A01 file changed, 7 insertions(+), 7 deletions(-)
>=20
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c
> b/drivers/scsi/megaraid/megaraid_sas_base.c
> index ed9846d..2287aa1 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -5889,7 +5889,7 @@ static int megasas_mgmt_fasync(int fd, struct
> file *filep, int mode)
> =C2=A0		return 0;
> =C2=A0	}
> =C2=A0
> -	printk(KERN_DEBUG "megasas: fasync_helper failed [%d]\n",
> rc);
> +	pr_debug("megasas: fasync_helper failed [%d]\n", rc);
> =C2=A0
> =C2=A0	return rc;
> =C2=A0}
> @@ -6233,7 +6233,7 @@ static int megasas_mgmt_ioctl_aen(struct file
> *file, unsigned long arg)
> =C2=A0	u32 wait_time =3D MEGASAS_RESET_WAIT_TIME;
> =C2=A0
> =C2=A0	if (file->private_data !=3D file) {
> -		printk(KERN_DEBUG "megasas: fasync_helper was not "
> +		pr_debug("megasas: fasync_helper was not "
> =C2=A0		=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0"called first\n");
> =C2=A0		return -EINVAL;
> =C2=A0	}
> @@ -6355,7 +6355,7 @@ static int megasas_mgmt_compat_ioctl_fw(struct
> file *file, unsigned long arg)
> =C2=A0
> =C2=A0	if (copy_in_user(&cioc->frame.hdr.cmd_status,
> =C2=A0			=C2=A0&ioc->frame.hdr.cmd_status, sizeof(u8))) {
> -		printk(KERN_DEBUG "megasas: error copy_in_user
> cmd_status\n");
> +		pr_debug("megasas: error copy_in_user
> cmd_status\n");
> =C2=A0		return -EFAULT;
> =C2=A0	}
> =C2=A0	return error;
> @@ -6455,7 +6455,7 @@ megasas_sysfs_set_dbg_lvl(struct device_driver
> *dd, const char *buf, size_t coun
> =C2=A0	int retval =3D count;
> =C2=A0
> =C2=A0	if (sscanf(buf, "%u", &megasas_dbg_lvl) < 1) {
> -		printk(KERN_ERR "megasas: could not set dbg_lvl\n");
> +		pr_err("megasas: could not set dbg_lvl\n");
> =C2=A0		retval =3D -EINVAL;
> =C2=A0	}
> =C2=A0	return retval;
> @@ -6480,7 +6480,7 @@ megasas_aen_polling(struct work_struct *work)
> =C2=A0	int error;
> =C2=A0
> =C2=A0	if (!instance) {
> -		printk(KERN_ERR "invalid instance!\n");
> +		pr_err("invalid instance!\n");
> =C2=A0		kfree(ev);
> =C2=A0		return;
> =C2=A0	}
> @@ -6740,7 +6740,7 @@ static int __init megasas_init(void)
> =C2=A0	rval =3D register_chrdev(0, "megaraid_sas_ioctl",
> &megasas_mgmt_fops);
> =C2=A0
> =C2=A0	if (rval < 0) {
> -		printk(KERN_DEBUG "megasas: failed to open device
> node\n");
> +		pr_debug("megasas: failed to open device node\n");
> =C2=A0		return rval;
> =C2=A0	}
> =C2=A0
> @@ -6752,7 +6752,7 @@ static int __init megasas_init(void)
> =C2=A0	rval =3D pci_register_driver(&megasas_pci_driver);
> =C2=A0
> =C2=A0	if (rval) {
> -		printk(KERN_DEBUG "megasas: PCI hotplug registration
> failed \n");
> +		pr_debug("megasas: PCI hotplug registration failed
> \n");
> =C2=A0		goto err_pcidrv;
> =C2=A0	}
> =C2=A0


Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>
