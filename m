From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [PATCH] fix sym2 negotiation
Date: Fri, 27 Aug 2004 19:54:44 +0300 (EEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.58.0408271945130.1977@kai.makisara.local>
References: <1093113450.1732.334.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fep01-0.kolumbus.fi ([193.229.0.41]:3493 "EHLO
	fep01-app.kolumbus.fi") by vger.kernel.org with ESMTP
	id S266615AbUH0Qyp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 Aug 2004 12:54:45 -0400
In-Reply-To: <1093113450.1732.334.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: willy@debian.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sat, 21 Aug 2004, James Bottomley wrote:

> The problems with domain validation were just the tip of the iceberg in
> the sym2 driver.  Most of its problems seem to come from an overly
> complex set of negotiating rules, which I've swept away with this patch.
> 
...

This is a success report.

A couple of days ago I noticed that my HP 5713A tape drive failed domain 
validation. The logs showed that this has happened for a long time. I 
inserted some printks into spi_dv_device_compare_inquiry in 
spi_transport_spi.c. The printks indicated that the drive returned sense 
data at first inquiry in the function. The sense code was ILLEGAL REQUEST 
and ASC/ASCQ showed "Invalid message error".

After installing the small sym2 patch for old Quantum Atlas drives, the 
problem did not disappear. After installing additionally this patch the 
domain validation now succeeds.

-- 
Kai
