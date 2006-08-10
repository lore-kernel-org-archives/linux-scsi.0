From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: question on scsi_alloc_sdev()
Date: Thu, 10 Aug 2006 10:03:13 -0500
Message-ID: <1155222193.3670.23.camel@mulgrave.il.steeleye.com>
References: <44DB44B7.9080708@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:48572 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1161307AbWHJPDR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 10 Aug 2006 11:03:17 -0400
In-Reply-To: <44DB44B7.9080708@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Martin Peschke <mp3@de.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, 2006-08-10 at 16:37 +0200, Martin Peschke wrote:
> Does anybody know for sure whether scsi_alloc_sdev() is guaranteed to
> be called in process context or not?

It's always called in the scan or setup path, so yes, process context is
guaranteed.

> There seem to be contradictory signs in scsi_scan.c:
> scsi_alloc_sdev() uses GFP_ATOMIC, as related functions do.
> It might be called in a section protected by a mutex.

It is always protected by the scan mutex, but a mutex is a sleeping
lock, so it could also be GFP_KERNEL.

> I conducted a little experiment using might_sleep() in scsi_alloc_sdev()
> - no backtrace on the console, hence process context.
> 
> Or, is the purpose of GFP_ATOMIC just (SCSI) I/O avoidance, and sleeping
> isn't an issue?

I'm guessing it's just historical.

James


