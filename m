From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] Don't register integrity profile for disabled disks
Date: Wed, 06 Aug 2008 11:17:49 -0700
Message-ID: <1218046669.7493.36.camel@localhost.localdomain>
References: <yq1y73auid5.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:59716 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753427AbYHFSRx (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 14:17:53 -0400
In-Reply-To: <yq1y73auid5.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-08-06 at 14:08 -0400, Martin K. Petersen wrote:
> Avoid registering a block integrity profile if the disk has been
> disabled earlier in the probe process.

This is a possible thing to have happen for devices with SCSI-2
reservations ... and that's not a permanenet condition.  When the
reservation is released, tools usually do a BLKRRPART, but that won't
pick up the DIF information ... perhaps this should be in
sd_revalidate_disk?

James


