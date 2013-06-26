From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: NVMe: Add nvme-scsi.c (was Re: [PULL REQUEST] NVMe driver updates)
Date: Thu, 27 Jun 2013 01:28:45 +0200
Message-ID: <51CB792D.6030504@redhat.com>
References: <20130509202015.GJ6057@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20130509202015.GJ6057@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Matthew Wilcox <willy@linux.intel.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, linux-nvme@lists.infradead.org, linux-kernel@vger.kernel.org, linux-scsi <linux-scsi@vger.kernel.org>, Vishal Verma <vishal.l.verma@intel.com>
List-Id: linux-scsi@vger.kernel.org

Il 09/05/2013 22:20, Matthew Wilcox ha scritto:
>       NVMe: Add nvme-scsi.c

I couldn't find the original patch on LKML, so I'll just quote the
relevant piece of code.

> +int nvme_sg_io(struct nvme_ns *ns, struct sg_io_hdr __user *u_hdr)
> +{
> +	struct sg_io_hdr hdr;
> +	int retcode;
> +
> +	if (!capable(CAP_SYS_ADMIN))
> +		return -EACCES;

This should be EPERM, and also it should use the same checks as other
implementations of SG_IO, including:

- checking if it's operating on a partition, and requiring CAP_SYS_RAWIO
if so;

- allowing a limited number of commands even for !capable(CAP_SYS_RAWIO).

All this is done by scsi_cmd_blk_ioctl.

Paolo

> +	if (copy_from_user(&hdr, u_hdr, sizeof(hdr)))
> +		return -EFAULT;
> +	if (hdr.interface_id != 'S')
> +		return -EINVAL;
> +	if (hdr.cmd_len > BLK_MAX_CDB)
> +		return -EINVAL;
> +
> +	retcode = nvme_scsi_translate(ns, &hdr);
> +	if (retcode < 0)
> +		return retcode;
> +	if (retcode > 0)
> +		retcode = SNTI_TRANSLATION_SUCCESS;
> +	if (copy_to_user(__user u_hdr, &hdr, sizeof(sg_io_hdr_t)) > 0)
> +		return -EFAULT;
> +
> +	return retcode;
> +}
