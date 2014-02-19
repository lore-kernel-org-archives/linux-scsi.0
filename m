From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: loading scsi_debug with data integrity hits BUG_ON
Date: Wed, 19 Feb 2014 22:22:52 +0900
Message-ID: <CAC5umyjVedpiUu4yffiT4n5kCUPSTgsuPucj1Nwc_TuwtoPLVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-oa0-f44.google.com ([209.85.219.44]:33334 "EHLO
	mail-oa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753660AbaBSNWx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Feb 2014 08:22:53 -0500
Received: by mail-oa0-f44.google.com with SMTP id g12so386917oah.3
        for <linux-scsi@vger.kernel.org>; Wed, 19 Feb 2014 05:22:53 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>

After commit 5837c80e870b ("bio-integrity: Fix bio_integrity_verify
segment start bug"), loading scsi_debug with data integrity enabled
(for example modprobe scsi_debug dif=1 dix=1) starts hitting BUG_ON()
at bio_integrity_verify():

        BUG_ON(total > bio->bi_integrity->bip_iter.bi_size);

Because bip_iter.bi_size has already been set to zero at this point
as a result of consuming bip_iter.

I can resolve this issue by removing the BUG_ON().  But I would like
to ask whether we should preserve an alternative assert, or not
before submitting the patch that simply removing the line.
