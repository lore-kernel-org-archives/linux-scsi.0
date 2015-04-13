From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 3/3] target/file: Fix UNMAP with DIF protection support
Date: Mon, 13 Apr 2015 18:07:14 +0300
Message-ID: <552BDBA2.4040406@dev.mellanox.co.il>
References: <1428934918-4004-1-git-send-email-akinobu.mita@gmail.com> <1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f177.google.com ([209.85.212.177]:34853 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932443AbbDMPHS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Apr 2015 11:07:18 -0400
Received: by widdi4 with SMTP id di4so76771939wid.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Apr 2015 08:07:16 -0700 (PDT)
In-Reply-To: <1428934918-4004-3-git-send-email-akinobu.mita@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>, target-devel@vger.kernel.org
Cc: Nicholas Bellinger <nab@linux-iscsi.org>, Sagi Grimberg <sagig@mellanox.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

On 4/13/2015 5:21 PM, Akinobu Mita wrote:
> When UNMAP command is issued with DIF protection support enabled,
> the protection info for the unmapped region is remain unchanged.
> So READ command for the region causes data integrity failure.
>
> This fixes it by invalidating protection info for the unmapped region
> by filling with 0xff pattern.  This change also adds helper function
> fd_do_prot_fill() in order to reduce code duplication with existing
> fd_format_prot().
>
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Nicholas Bellinger <nab@linux-iscsi.org>
> Cc: Sagi Grimberg <sagig@mellanox.com>
> Cc: "Martin K. Petersen" <martin.petersen@oracle.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> Cc: target-devel@vger.kernel.org
> Cc: linux-scsi@vger.kernel.org
> ---
>   drivers/target/target_core_file.c | 86 +++++++++++++++++++++++++++------------
>   1 file changed, 61 insertions(+), 25 deletions(-)
>
> diff --git a/drivers/target/target_core_file.c b/drivers/target/target_core_file.c
> index 4c7a6c8..cbb0cc2 100644
> --- a/drivers/target/target_core_file.c
> +++ b/drivers/target/target_core_file.c
> @@ -541,6 +541,56 @@ fd_execute_write_same(struct se_cmd *cmd)
>   	return 0;
>   }
>
> +static int
> +fd_do_prot_fill(struct se_device *se_dev, sector_t lba, sector_t nolb,
> +		void *buf, size_t bufsize)
> +{
> +	struct fd_dev *fd_dev = FD_DEV(se_dev);
> +	struct file *prot_fd = fd_dev->fd_prot_file;
> +	sector_t prot_length, prot;
> +	loff_t pos = lba * se_dev->prot_length;
> +
> +	if (!prot_fd) {
> +		pr_err("Unable to locate fd_dev->fd_prot_file\n");
> +		return -ENODEV;
> +	}
> +
> +	prot_length = nolb * se_dev->prot_length;
> +
> +	for (prot = 0; prot < prot_length;) {
> +		sector_t len = min_t(sector_t, bufsize, prot_length - prot);
> +		ssize_t ret = kernel_write(prot_fd, buf, len, pos + prot);
> +
> +		if (ret != len) {
> +			pr_err("vfs_write to prot file failed: %zd\n", ret);
> +			return ret < 0 ? ret : -ENODEV;
> +		}
> +		prot += ret;
> +	}
> +
> +	return 0;
> +}
> +
> +static int
> +fd_do_prot_unmap(struct se_cmd *cmd, sector_t lba, sector_t nolb)
> +{
> +	void *buf;
> +	int rc;
> +
> +	buf = (void *)__get_free_page(GFP_KERNEL);
> +	if (!buf) {
> +		pr_err("Unable to allocate FILEIO prot buf\n");
> +		return -ENOMEM;
> +	}
> +	memset(buf, 0xff, PAGE_SIZE);
> +
> +	rc = fd_do_prot_fill(cmd->se_dev, lba, nolb, buf, PAGE_SIZE);
> +
> +	free_page((unsigned long)buf);
> +
> +	return rc;
> +}
> +
>   static sense_reason_t
>   fd_do_unmap(struct se_cmd *cmd, void *priv, sector_t lba, sector_t nolb)
>   {
> @@ -548,6 +598,12 @@ fd_do_unmap(struct se_cmd *cmd, void *priv, sector_t lba, sector_t nolb)
>   	struct inode *inode = file->f_mapping->host;
>   	int ret;
>
> +	if (cmd->se_dev->dev_attrib.pi_prot_type) {
> +		ret = fd_do_prot_unmap(cmd, lba, nolb);
> +		if (ret)
> +			return TCM_LOGICAL_UNIT_COMMUNICATION_FAILURE;
> +	}
> +
>   	if (S_ISBLK(inode->i_mode)) {
>   		/* The backend is block device, use discard */
>   		struct block_device *bdev = inode->i_bdev;
> @@ -870,48 +926,28 @@ static int fd_init_prot(struct se_device *dev)
>
>   static int fd_format_prot(struct se_device *dev)
>   {
> -	struct fd_dev *fd_dev = FD_DEV(dev);
> -	struct file *prot_fd = fd_dev->fd_prot_file;
> -	sector_t prot_length, prot;
>   	unsigned char *buf;
> -	loff_t pos = 0;
>   	int unit_size = FDBD_FORMAT_UNIT_SIZE * dev->dev_attrib.block_size;
> -	int rc, ret = 0, size, len;
> +	int ret;
>
>   	if (!dev->dev_attrib.pi_prot_type) {
>   		pr_err("Unable to format_prot while pi_prot_type == 0\n");
>   		return -ENODEV;
>   	}
> -	if (!prot_fd) {
> -		pr_err("Unable to locate fd_dev->fd_prot_file\n");
> -		return -ENODEV;
> -	}
>
>   	buf = vzalloc(unit_size);
>   	if (!buf) {
>   		pr_err("Unable to allocate FILEIO prot buf\n");
>   		return -ENOMEM;
>   	}
> -	prot_length = (dev->transport->get_blocks(dev) + 1) * dev->prot_length;
> -	size = prot_length;
>
>   	pr_debug("Using FILEIO prot_length: %llu\n",
> -		 (unsigned long long)prot_length);
> +		 (unsigned long long)(dev->transport->get_blocks(dev) + 1) *
> +					dev->prot_length);
>
>   	memset(buf, 0xff, unit_size);
> -	for (prot = 0; prot < prot_length; prot += unit_size) {
> -		len = min(unit_size, size);
> -		rc = kernel_write(prot_fd, buf, len, pos);
> -		if (rc != len) {
> -			pr_err("vfs_write to prot file failed: %d\n", rc);
> -			ret = -ENODEV;
> -			goto out;
> -		}
> -		pos += len;
> -		size -= len;
> -	}
> -
> -out:
> +	ret = fd_do_prot_fill(dev, 0, dev->transport->get_blocks(dev) + 1,
> +			      buf, unit_size);
>   	vfree(buf);
>   	return ret;
>   }
>

Thanks for this needed patch.

Reviewed-by: Sagi Grimberg <sagig@mellanox.com>
