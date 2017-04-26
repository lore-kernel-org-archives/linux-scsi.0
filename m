From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] nvme-scsi: Use correct byte ordering for eui64 in Dev ID
 VPD
Date: Wed, 26 Apr 2017 00:22:48 -0700
Message-ID: <20170426072248.GA8552@infradead.org>
References: <20170425201809.1683-1-jonathan.derrick@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:55895 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1953170AbdDZHXC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 26 Apr 2017 03:23:02 -0400
Content-Disposition: inline
In-Reply-To: <20170425201809.1683-1-jonathan.derrick@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jon Derrick <jonathan.derrick@intel.com>
Cc: axboe@fb.com, hch@infradead.org, sagi@grimberg.me, linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, keith.busch@intel.com

On Tue, Apr 25, 2017 at 02:18:09PM -0600, Jon Derrick wrote:
> NVME specifies an EUI64/NGUID in little-endian format, while SCSI
> specifies that the Device Identification VPD use big-endian for EUI
> formats. The current code copies this bytestream directly from the
> Identification Namespace page, meaning we just need to reverse the
> bytestream when passing it on to the VPD.

This will break existing setups that rely on VPD 0x83 for device
identification (which I think includes older SuSE distros).

And once you change the setup anyway please stop using this buggy
SCSI emulation.
