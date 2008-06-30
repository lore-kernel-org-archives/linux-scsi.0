From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 04 of 10] scsi: Support devices with protection information (DIF)
Date: Mon, 30 Jun 2008 11:24:35 -0400
Message-ID: <yq17ic7c5e4.fsf@sermon.lab.mkp.net>
References: <2fd66ca994dbf1ed6d14.1214407363@sermon.lab.mkp.net>
	<1214665658.3658.18.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:36156 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760311AbYF3PYr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Jun 2008 11:24:47 -0400
In-Reply-To: <1214665658.3658.18.camel@localhost.localdomain> (James Bottomley's message of "Sat\, 28 Jun 2008 10\:07\:38 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org

>>>>> "James" == James Bottomley <James.Bottomley@HansenPartnership.com> writes:

[Protection sgl alloc + init]

James> I'm afraid you can't do it like this because it will violate
James> our forward progress guarantees.  If this is the last spare
James> command required for writeout, you need to guarantee either
James> this allocation will succeed, or we can proceed without the DIF
James> data.

We can't just turn off DIF -- that would violate the integrity
guarantees.  But I'll move the protection sgl to the host command
pool.



>> + if (inq_result[5] & 0x1) + sdev->protection = 1;

James> Is there a reason to have a separate flag here

Not really.  I used to key off of sdp->protection quite a bit but I
think the only place I use it now is during sd discovery.  So this can
simply go away...

-- 
Martin K. Petersen	Oracle Linux Engineering

