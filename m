From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] p00001_scsi_tcq_queue_lock
Date: 06 Aug 2004 21:09:49 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1091815154.2421.15.camel@mulgrave>
References: <410FD03E.6040305@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:42657 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266217AbUHGEJw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 7 Aug 2004 00:09:52 -0400
In-Reply-To: <410FD03E.6040305@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: brking@us.ibm.com
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2004-08-03 at 10:49, Brian King wrote:
> Add locking to scsi_activate_tcq and scsi_deactivate_tcq to fix a race
> condition that can occur when disabling tcqing with commands in flight.

It's possible to do it like this.  However, we should really quiesce the
SCSI device before disabling tcq.  It is not legal in the scsi spec to
have both tagged and untagged commands outstanding.  Most drives do the
right thing and return BUSY to an untagged request if they have tags in
flight.  Also, we have to wait until all tags return before freeing the
block layer tag structures...and there's always the devices that do
strange things in this situation...

James


