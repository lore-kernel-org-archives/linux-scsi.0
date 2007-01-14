From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] ieee1394: sbp2: lower block queue alignment requirement
Date: Sun, 14 Jan 2007 13:19:47 -0600
Message-ID: <1168802387.2780.1.camel@mulgrave.il.steeleye.com>
References: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:33896 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751631AbXANTT6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 14 Jan 2007 14:19:58 -0500
In-Reply-To: <tkrat.37326df2d568d12d@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Sun, 2007-01-14 at 19:45 +0100, Stefan Richter wrote:
> I wonder, do we need this call to blk_queue_dma_alignment() at all?
> Does the block layer perhaps provide sufficient alignment guarantees?

The block layer currently provides sector (512) byte alignment
guarantees.  However, there has been talk in SCSI of reducing that to
word (4) since that's what most intelligent PCI controllers can cope
with.  If you have any alignment constraints, they should be expressed
in the slave configure.

James


