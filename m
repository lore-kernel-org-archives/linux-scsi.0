From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH] Move SG_GET_SCSI_ID from sg to scsi
Date: Sun, 26 Mar 2006 13:05:22 -0700
Message-ID: <20060326200522.GA3486@parisc-linux.org>
References: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:1460 "EHLO
	palinux.hppa") by vger.kernel.org with ESMTP id S1751507AbWCZUFX
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 26 Mar 2006 15:05:23 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.58.0603262108500.13001@be1.lrz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bodo Eggert <7eggert@gmx.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, torvalds@osdl.org

On Sun, Mar 26, 2006 at 09:28:28PM +0200, Bodo Eggert wrote:
>          case SCSI_IOCTL_GET_PCI:
>                  return scsi_ioctl_get_pci(sdev, arg);
> +	case SG_GET_SCSI_ID:

You're using the old ioctl name here ...

> +		if (!access_ok(VERIFY_WRITE, arg, sizeof (struct scsi_ioctl_id)))
> +			return -EFAULT;
> +		else {
> +			struct scsi_ioctl_id __user *idp = arg;
> +
> +			__put_user((int) sdev->host->host_no,
> +				   &idp->host_no);

The cast isn't necessary; __put_user casts the argument to the type of
the pointer.

> +			__put_user(0, &idp->unused[0]);
> +			__put_user(0, &idp->unused[1]);

Is it time to repurpose the unused bytes for the 64-bit LUN?

> +struct scsi_ioctl_id { /* used by SCSI_IOCTL_GET_ID ioctl() */
> +    int host_no;        /* as in "scsi<n>" where 'n' is one of 0, 1, 2 etc */

tabs instead of spaces?

