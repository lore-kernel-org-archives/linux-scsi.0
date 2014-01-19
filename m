From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH-v2 12/17] target/file: Add DIF protection init/format
 support
Date: Sun, 19 Jan 2014 14:31:14 +0200
Message-ID: <52DBC592.6010405@dev.mellanox.co.il>
References: <1390099480-29013-1-git-send-email-nab@daterainc.com> <1390099480-29013-13-git-send-email-nab@daterainc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1390099480-29013-13-git-send-email-nab@daterainc.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Sagi Grimberg <sagig@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Roland Dreier <roland@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 1/19/2014 4:44 AM, Nicholas A. Bellinger wrote:
> From: Nicholas Bellinger <nab@linux-iscsi.org>
>
> This patch adds support for DIF protection init/format support into
> the FILEIO backend.
>
> It involves using a seperate $FILE.protection for storing PI that is
> opened via fd_init_prot() using the common pi_prot_type attribute.
> The actual formatting of the protection is done via fd_format_prot()
> using the common pi_prot_format attribute, that will populate the
> initial PI data based upon the currently configured pi_prot_type.
>
> Based on original FILEIO code from Sagi.

Nice! see comments below...

> v1 changes:
>    - Fix sparse warnings in fd_init_format_buf (Fengguang)
>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: Or Gerlitz <ogerlitz@mellanox.com>
> Signed-off-by: Nicholas Bellinger <nab@linux-iscsi.org>
> ---
>   drivers/target/target_core_file.c |  137 +++++++++++++++++++++++++++++++++++++
>   drivers/target/target_core_file.h |    4 ++
>   2 files changed, 141 insertions(+)
>
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 0e34cda..119d519 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -700,6 +700,140 @@ static sector_t fd_get_blocks(struct se_device *dev)
>   		       dev->dev_attrib.block_size);
>   }
>   
> +static int fd_init_prot(struct se_device *dev)
> +{
> +	struct fd_dev *fd_dev = FD_DEV(dev);
> +	struct file *prot_file, *file = fd_dev->fd_file;
> +	struct inode *inode;
> +	int ret, flags = O_RDWR | O_CREAT | O_LARGEFILE | O_DSYNC;
> +	char buf[FD_MAX_DEV_PROT_NAME];
> +
> +	if (!file) {
> +		pr_err("Unable to locate fd_dev->fd_file\n");
> +		return -ENODEV;
> +	}
> +
> +	inode = file->f_mapping->host;
> +	if (S_ISBLK(inode->i_mode)) {
> +		pr_err("FILEIO Protection emulation only supported on"
> +		       " !S_ISBLK\n");
> +		return -ENOSYS;
> +	}
> +
> +	if (fd_dev->fbd_flags & FDBD_HAS_BUFFERED_IO_WCE)
> +		flags &= ~O_DSYNC;
> +
> +	snprintf(buf, FD_MAX_DEV_PROT_NAME, "%s.protection",
> +		 fd_dev->fd_dev_name);
> +
> +	prot_file = filp_open(buf, flags, 0600);
> +	if (IS_ERR(prot_file)) {
> +		pr_err("filp_open(%s) failed\n", buf);
> +		ret = PTR_ERR(prot_file);
> +		return ret;
> +	}
> +	fd_dev->fd_prot_file = prot_file;
> +
> +	return 0;
> +}
> +
> +static void fd_init_format_buf(struct se_device *dev, unsigned char *buf,
> +			       u32 unit_size, u32 *ref_tag, u16 app_tag,
> +			       bool inc_reftag)
> +{
> +	unsigned char *p = buf;
> +	int i;
> +
> +	for (i = 0; i < unit_size; i += dev->prot_length) {
> +		*((u16 *)&p[0]) = 0xffff;
> +		*((__be16 *)&p[2]) = cpu_to_be16(app_tag);
> +		*((__be32 *)&p[4]) = cpu_to_be32(*ref_tag);
> +
> +		if (inc_reftag)
> +			(*ref_tag)++;
> +
> +		p += dev->prot_length;
> +	}
> +}
> +
> +static int fd_format_prot(struct se_device *dev)
> +{
> +	struct fd_dev *fd_dev = FD_DEV(dev);
> +	struct file *prot_fd = fd_dev->fd_prot_file;
> +	sector_t prot_length, prot;
> +	unsigned char *buf;
> +	loff_t pos = 0;
> +	u32 ref_tag = 0;
> +	int unit_size = FDBD_FORMAT_UNIT_SIZE * dev->dev_attrib.block_size;
> +	int rc, ret = 0, size, len;
> +	bool inc_reftag = false;
> +
> +	if (!dev->dev_attrib.pi_prot_type) {
> +		pr_err("Unable to format_prot while pi_prot_type == 0\n");
> +		return -ENODEV;
> +	}
> +	if (!prot_fd) {
> +		pr_err("Unable to locate fd_dev->fd_prot_file\n");
> +		return -ENODEV;
> +	}
> +
> +	switch (dev->dev_attrib.pi_prot_type) {
redundant - see below.
> +	case TARGET_DIF_TYPE3_PROT:
> +		ref_tag = 0xffffffff;
> +		break;
> +	case TARGET_DIF_TYPE2_PROT:
> +	case TARGET_DIF_TYPE1_PROT:
> +		inc_reftag = true;
> +		break;
> +	default:
> +		break;
> +	}
> +
> +	buf = vzalloc(unit_size);
> +	if (!buf) {
> +		pr_err("Unable to allocate FILEIO prot buf\n");
> +		return -ENOMEM;
> +	}
> +
> +	prot_length = (dev->transport->get_blocks(dev) + 1) * dev->prot_length;
> +	size = prot_length;
> +
> +	pr_debug("Using FILEIO prot_length: %llu\n",
> +		 (unsigned long long)prot_length);
> +
> +	for (prot = 0; prot < prot_length; prot += unit_size) {
> +
> +		fd_init_format_buf(dev, buf, unit_size, &ref_tag, 0xffff,
> +				   inc_reftag);

I didn't send you my latest patches (my fault...).T10-PI format should 
only place
escape values throughout the protection file (fill it with 0xff). so I 
guess in this case
fd_init_formast_buf() boils down to memset(buf, 0xff, unit_size) once  
before the loop
and just loop until prot_length writing buf, no need to address 
apptag/reftag...

> +
> +		len = min(unit_size, size);
> +
> +		rc = kernel_write(prot_fd, buf, len, pos);
> +		if (rc != len) {
> +			pr_err("vfs_write to prot file failed: %d\n", rc);
> +			ret = -ENODEV;
> +			goto out;
> +		}
> +		pos += len;
> +		size -= len;
> +	}
> +
> +out:
> +	vfree(buf);
> +	return ret;
> +}
> +
> +static void fd_free_prot(struct se_device *dev)
> +{
> +	struct fd_dev *fd_dev = FD_DEV(dev);
> +
> +	if (!fd_dev->fd_prot_file)
> +		return;
> +
> +	filp_close(fd_dev->fd_prot_file, NULL);
> +	fd_dev->fd_prot_file = NULL;
> +}
> +
>   static struct sbc_ops fd_sbc_ops = {
>   	.execute_rw		= fd_execute_rw,
>   	.execute_sync_cache	= fd_execute_sync_cache,
> @@ -730,6 +864,9 @@ static struct se_subsystem_api fileio_template = {
>   	.show_configfs_dev_params = fd_show_configfs_dev_params,
>   	.get_device_type	= sbc_get_device_type,
>   	.get_blocks		= fd_get_blocks,
> +	.init_prot		= fd_init_prot,
> +	.format_prot		= fd_format_prot,
> +	.free_prot		= fd_free_prot,
>   };
>   
>   static int __init fileio_module_init(void)
> diff --git a/drivers/target/target_core_file.h b/drivers/target/target_core_file.h
> index 37ffc5b..583691e 100644
> --- a/drivers/target/target_core_file.h
> +++ b/drivers/target/target_core_file.h
> @@ -4,6 +4,7 @@
>   #define FD_VERSION		"4.0"
>   
>   #define FD_MAX_DEV_NAME		256
> +#define FD_MAX_DEV_PROT_NAME	FD_MAX_DEV_NAME + 16
>   #define FD_DEVICE_QUEUE_DEPTH	32
>   #define FD_MAX_DEVICE_QUEUE_DEPTH 128
>   #define FD_BLOCKSIZE		512
> @@ -15,6 +16,8 @@
>   #define FBDF_HAS_PATH		0x01
>   #define FBDF_HAS_SIZE		0x02
>   #define FDBD_HAS_BUFFERED_IO_WCE 0x04
> +#define FDBD_FORMAT_UNIT_SIZE	2048
> +
>   
>   struct fd_dev {
>   	struct se_device dev;
> @@ -29,6 +32,7 @@ struct fd_dev {
>   	u32		fd_block_size;
>   	unsigned long long fd_dev_size;
>   	struct file	*fd_file;
> +	struct file	*fd_prot_file;
>   	/* FILEIO HBA device is connected to */
>   	struct fd_host *fd_host;
>   } ____cacheline_aligned;
