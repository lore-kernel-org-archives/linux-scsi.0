From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [patch] qla1280 update for 2.6.1-mm4
Date: 19 Jan 2004 12:03:11 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1074531798.1894.17.camel@mulgrave>
References: <16395.51364.833229.536552@gargle.gargle.HOWL>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:7398 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265377AbUASRD3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 Jan 2004 12:03:29 -0500
In-Reply-To: <16395.51364.833229.536552@gargle.gargle.HOWL>
List-Id: linux-scsi@vger.kernel.org
To: Jes Sorensen <jes@trained-monkey.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Andrew Morton <akpm@osdl.org>, jeremy@sgi.com

On Mon, 2004-01-19 at 07:08, Jes Sorensen wrote:
> I am attaching the latest patch for qla1280, which includes Andrew's and
> James' patches (modulo the 64 bit enable part) as well changes to make
> it handle pci_set_dma_mask() correctly and switch to only use one of the
> two SCSI command issuing versions depending on whether the driver is
> compiled for 64 or 32 bit DMA. The old code effectively did this anyway,
> but with this change it is no longer compiling in the part not used.

OK, put it in the tree, thanks.

Something to think about (I'm not asking you to change it) is whether
you really want to use 64 bit descriptors on all 64 bit machines.  The
way the qla1280 single issue queue is organised it looks like we eat up
slots (and, worse, overflow slots) quite a bit faster in 64 bit
addressing mode.  Therefore, it seems like the driver would operate more
efficiently in 32 bit mode, so it might be worth a runtime check even on
64 bit machines to see whether the addressing mode is really necessary
(i.e. no physical memory > 4GB for instance).

James


