From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] target code updates to support scanned targets
Date: Tue, 15 Feb 2005 18:33:17 -0600
Message-ID: <1108513997.5539.76.camel@mulgrave>
References: <7526e305050215152950f5a69e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:58086 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261958AbVBPAdV (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 15 Feb 2005 19:33:21 -0500
In-Reply-To: <7526e305050215152950f5a69e@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Scsi <joe.scsi@gmail.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2005-02-15 at 15:29 -0800, Joe Scsi wrote:
> I see the internal changes to scsi_scan.c that this refers to, but
> I'm not totally clear on what a driver should do to allocate a target
> and scan it when it finds out about a new target port.

A driver doesn't allocate a target.  In this code, a target device is
purely a LUN container and is managed by the mid-layer.  The driver
requests the scan of a target by parent device, channel and id.  This
request for a scan creates and parents the target object, but reaps it
again if no actual LUNs are discovered.

James


