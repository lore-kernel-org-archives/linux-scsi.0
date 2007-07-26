From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Fri, 27 Jul 2007 02:28:12 +0900
Message-ID: <20070726022605N.tomof@acm.org>
References: <20070726190913A.fujita.tomonori@lab.ntt.co.jp>
	<664A4EBB07F29743873A87CF62C26D708B3A65@NAMAIL4.ad.lsil.com>
	<20070726020657P.tomof@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:52825 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933365AbXGZR2t (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Jul 2007 13:28:49 -0400
In-Reply-To: <20070726020657P.tomof@acm.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric.Moore@lsi.com
Cc: fujita.tomonori@lab.ntt.co.jp, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, dougg@torque.net, jens.axboe@oracle.com

From: FUJITA Tomonori <tomof@acm.org>
Subject: RE: [PATCH 3/3] mptsas: add SMP passthrough support via bsg
Date: Fri, 27 Jul 2007 02:09:05 +0900

> Use-space applications can put four memory addresses in the bsg (sg
> v4) interface: request, response, dout_xferp, and din_xferp.
> 
> For scsi commands, we use:
> 
> request -> pointer to a scsi command (cmdp in sgv3)
> response -> pointer to a sense buffer (sbp in sgv3)
> dout_xferp -> pointer to out data
> din_xferp -> pointer to in data
> 
> For smp request/response, we use:
> 
> request -> not used
> response -> not used
> dout_xferp -> pointer to a smp request frame
> din_xferp -> pointer to a smp response frame
> 
> 
> So we could use response field to send vendor's unique response to
> user space.
> 
> bsg wrongly assues the response field is used for sense buffer so the
> maxium length is SCSI_SENSE_BUFFERSIZE, 96 bytes. I think that it's a
> bit small for mpt's unique response. But, I'll fix the length
> limitation bug soon.

Oops, 96 bytes is large enough for mpt's unique response. Right?
