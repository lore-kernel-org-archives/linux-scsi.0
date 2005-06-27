From: Christoph Hellwig <hch@lst.de>
Subject: odd sg_request munging code in i2o post-2.6.12
Date: Mon, 27 Jun 2005 22:55:20 +0200
Message-ID: <20050627205520.GA20272@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from verein.lst.de ([213.95.11.210]:34950 "EHLO mail.lst.de")
	by vger.kernel.org with ESMTP id S261783AbVF0Uzc (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Jun 2005 16:55:32 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: markus.lidel@shadowconnect.com
Cc: linux-scsi@vger.kernel.org

Markus, any chance you could try to send in changes that deal with
scsi internals through James SCSI tree?

You've sent some changes in that are rather odd:

 - created a include/scsi/sg_request.h header that duplicates
   struct sg_request, an internal data structure of the sg driver.
   This approach gets easily out of sync.
 - and poke into this data structure of an upper layer driver from a LLDD.
   That's a big "DON'T"  While of the current drivers only SG uses that
   field it's open to any ULD, and you're also not supporting SG_IO on
   non-sg devices.
   Besides that we are actively killing scsi_requests before 2.6.13,
   so you code will have to be remove by then.
