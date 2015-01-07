From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [dm-devel] [LSF/MM ATTEND] discuss blk-mq related to DM-multipath and status of XCOPY
Date: Wed, 07 Jan 2015 18:39:41 -0500
Message-ID: <yq1vbki40ua.fsf@sermon.lab.mkp.net>
References: <CAMM=eLdGQ4wQDHy0ACzDsYOs0AYC+KAcx7Mx7FmpBTV293d41Q@mail.gmail.com>
	<54AA90B1.1030201@suse.de> <yq17fwz8nwb.fsf@sermon.lab.mkp.net>
	<54ACEF13.7000508@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:49561 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755166AbbAGXkN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 18:40:13 -0500
In-Reply-To: <54ACEF13.7000508@suse.de> (Hannes Reinecke's message of "Wed, 07
	Jan 2015 09:32:19 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, device-mapper development <dm-devel@redhat.com>, Christoph Hellwig <hch@infradead.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:

Hannes> Not quite. XCOPY is optional, and the system works well without
Hannes> it.  So the exception handling would need to copy things by hand
Hannes> to avoid regressions.

Or defer to user space.

But it's really no different from how we do WRITE SAME which may or may
not work. If it fails we fall back to writing zeroes.

Hannes> Plus XCOPY requires some elaborate setup, and even if those
Hannes> succeeded the array might still fail the command.  _And_ there
Hannes> is no guarantee that that the XCOPY command is actually faster
Hannes> than the manual procedure.

It saves the data a roundtrip on the fabric. That itself may be more
valuable than a direct bandwidth win if there is concurrent I/O on the
wire.

-- 
Martin K. Petersen	Oracle Linux Engineering
