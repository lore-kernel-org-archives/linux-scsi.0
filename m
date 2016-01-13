From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 1/1] scsi: add Synology to 1024 sector blacklist
Date: Wed, 13 Jan 2016 11:27:12 +0100
Message-ID: <56962680.6020303@redhat.com>
References: <1452206045-18332-1-git-send-email-mchristi@redhat.com>
 <56953DEF.1050306@redhat.com>
 <1452677624.27508.70.camel@haakon3.risingtidesystems.com>
 <56961BC0.6090101@redhat.com>
 <1452678977.27508.82.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f66.google.com ([74.125.82.66]:33601 "EHLO
	mail-wm0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755216AbcAMK1S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jan 2016 05:27:18 -0500
Received: by mail-wm0-f66.google.com with SMTP id u188so36004463wmu.0
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jan 2016 02:27:18 -0800 (PST)
In-Reply-To: <1452678977.27508.82.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org



On 13/01/2016 10:56, Nicholas A. Bellinger wrote:
> Nope, or at least not in iblock_configure_device() code.
> 
> The MAXIMUM TRANSFER LENGTH in block limits EVPD for IBLOCK is
> queue_max_hw_sectors() * bdev_logical_block_size, and
> queue_max_segments() is not considered atm.
> 
> Is there a case where MTL needs to be the smaller of the two..?

Given enough fragmentation of the t_data_sg, the actual MTL will be
queue_max_segments() * PAGE_SIZE bytes.

I think it's a bug in LIO that target_alloc_sgl always does order-0
allocation.  But until that is fixed, LIO will be susceptible to this
problem, at least for PSCSI backends (for BLOCK and FILEIO, the block
and VFS layers can always split one I/O down to multiple requests).

Paolo
