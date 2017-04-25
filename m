From: Jon Derrick <jonathan.derrick@intel.com>
Subject: Re: [PATCH] nvme-scsi: Use correct byte ordering for eui64 in Dev ID
 VPD
Date: Tue, 25 Apr 2017 14:55:19 -0600
Message-ID: <894f6326-35e9-583b-80a8-f7df54c683b0@intel.com>
References: <20170425201809.1683-1-jonathan.derrick@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([134.134.136.65]:20501 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1954126AbdDYUzE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Apr 2017 16:55:04 -0400
In-Reply-To: <20170425201809.1683-1-jonathan.derrick@intel.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: axboe@fb.com
Cc: linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org, keith.busch@intel.com, hch@infradead.org, sagi@grimberg.me

On 04/25/2017 02:18 PM, Jon Derrick wrote:
> NVME specifies an EUI64/NGUID in little-endian format, while SCSI
> specifies that the Device Identification VPD use big-endian for EUI
> formats. The current code copies this bytestream directly from the
> Identification Namespace page, meaning we just need to reverse the
> bytestream when passing it on to the VPD.
> 

This seems to hold true for NGUID devices, but Keith just pointed out to
me that it may not hold true for EUI64 devices. It seems like that case
needs byte swiveling within each field. So I'll NAK for now until I can
figure out if that's the case.
