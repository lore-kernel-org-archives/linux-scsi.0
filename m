From: Christoph Hellwig <hch@lst.de>
Subject: support ranges TRIM for libata
Date: Mon, 20 Mar 2017 16:43:12 -0400
Message-ID: <20170320204319.12628-1-hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([65.50.211.133]:49433 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1755293AbdCTUnX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Mar 2017 16:43:23 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: tj@kernel.org, martin.petersen@oracle.com, axboe@kernel.dk
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org

This series implements rangeѕ discard for ATA SSDs.  Compared to the
initial NVMe support there are two things that complicate the ATA
support:

 - ATA only suports 16-bit long ranges
 - the whole mess of generating a SCSI command first and then
   translating it to an ATA one.

This series adds support for limited range size to the block layer,
and stops translating discard commands - instead we add a new
Vendor Specific SCSI command that contains the TRIM payload when
the device asks for it.
