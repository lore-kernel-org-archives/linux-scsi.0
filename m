From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: SCSI Tape and CPIO
Date: Sun, 10 Aug 2003 22:32:38 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.56.0308102225500.1576@kai.makisara.local>
References: <200308101231.26631.ntorys@cybertor.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep06-0.kolumbus.fi ([193.229.0.57]:62168 "EHLO
	fep06-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S270622AbTHJTck (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 10 Aug 2003 15:32:40 -0400
In-Reply-To: <200308101231.26631.ntorys@cybertor.com>
List-Id: linux-scsi@vger.kernel.org
To: Nick Torys <ntorys@cybertor.com>
Cc: linux-scsi@vger.kernel.org

On Sun, 10 Aug 2003, Nick Torys wrote:

> Hi,
>
> Sorry to bug you, but I noticed that so far every release of 2.6.0-
> kernel has been veeeeeery slow in dumping data to my SCSI tape, while
> 2.4.xx's have been/are very fast.
>
If you are using fixed block mode and don't specify any "block" size in
the cpio command (or use a buffering program), this is understandable. The
2.4 driver uses a buffer in the driver and, by default, uses 32 kB writes
to tape. The 2.6 driver uses direct i/o between user buffer and the device
and this means each 512 bytes are written as separate SCSI transaction.
This affects throughput ;-)

You can fall back to driver buffering by using the try_direct_io=0
module/kernel parameter. A better alternative is to specify blocking in
the cpio parameters.

If this does not explain your problem, please tell the drive mode
(fixed/variable block), block size, and the command you are using. These
should enable explaining the loss of speed.

-- 
Kai
