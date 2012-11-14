From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] Use SCSI read/write(16) with >2TB drives
Date: Wed, 14 Nov 2012 02:17:35 +0100
Message-ID: <50A2F12F.9060209@redhat.com>
References: <1352854453-3781-1-git-send-email-hernejj@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:20825 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932152Ab2KNBRy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Nov 2012 20:17:54 -0500
In-Reply-To: <1352854453-3781-1-git-send-email-hernejj@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Jason J. Herne" <hernejj@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, JBottomley@parallels.com, stern@rowland.harvard.edu

Il 14/11/2012 01:54, Jason J. Herne ha scritto:
>  	blk_queue_physical_block_size(sdp->request_queue,
>  				      sdkp->physical_block_size);
>  	sdkp->device->sector_size = sector_size;
> +
> +	/* Use read/write(16) for > 2TB disks */
> +	sdp->use_16_for_rw = (sdkp->capacity > 0xffffffff);
>  }

This needs to be done before this bit:

        /* Rescale capacity to 512-byte units */
        if (sector_size == 4096)
                sdkp->capacity <<= 3;
        else if (sector_size == 2048)
                sdkp->capacity <<= 2;
        else if (sector_size == 1024)
                sdkp->capacity <<= 1;
        else if (sector_size == 256)
                sdkp->capacity >>= 1;

For example, for a 4K-sector disk the "threshold" would be 16TB (2^12 *
2^32).

Paolo
