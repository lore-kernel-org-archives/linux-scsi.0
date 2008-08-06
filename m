From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] Don't register integrity profile for disabled disks
Date: Wed, 06 Aug 2008 14:46:41 -0400
Message-ID: <yq1promugku.fsf@sermon.lab.mkp.net>
References: <yq1y73auid5.fsf@sermon.lab.mkp.net>
	<1218046669.7493.36.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:59631 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752612AbYHFSrN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Aug 2008 14:47:13 -0400
In-Reply-To: <1218046669.7493.36.camel@localhost.localdomain> (James Bottomley's message of "Wed\, 06 Aug 2008 11\:17\:49 -0700")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

James> This is a possible thing to have happen for devices with SCSI-2
James> reservations ... and that's not a permanenet condition.  When
James> the reservation is released, tools usually do a BLKRRPART, but
James> that won't pick up the DIF information ... perhaps this should
James> be in sd_revalidate_disk?

sd_revalidate_disk can be called before the gendisk exists so I can't
register the profile from there.  At one point I tried shuffling
add_disk and revalidate in sd_probe but that caused problems with
sysfs.

I haven't tried reordering since the SCSI sysfs revamp.  I'll try that
out so just drop the patch for now.  It's mostly cosmetic anyway.

-- 
Martin K. Petersen	Oracle Linux Engineering

