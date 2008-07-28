From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [DO NOT APPLY] sd take advantage of rotation speed
Date: Mon, 28 Jul 2008 09:10:29 -0500
Message-ID: <1217254229.3503.58.camel@localhost.localdomain>
References: <20080619160342.GJ4392@parisc-linux.org>
	 <20080625134705.GZ20851@kernel.dk> <4862552A.5010900@gmail.com>
	 <48627184.9010609@panasas.com> <20080625165759.GC20851@kernel.dk>
	 <20080625172015.GR4392@parisc-linux.org>	<20080625172638.GE20851@kernel.dk>
	 <yq1d4m575je.fsf@sermon.lab.mkp.net>  <488DCB5A.9080105@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:57656 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751529AbYG1OK7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jul 2008 10:10:59 -0400
In-Reply-To: <488DCB5A.9080105@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: rwheeler@redhat.com
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Jens Axboe <jens.axboe@oracle.com>, Matthew Wilcox <matthew@wil.cx>, Boaz Harrosh <bharrosh@panasas.com>, linux-scsi@vger.kernel.org

On Mon, 2008-07-28 at 09:36 -0400, Ric Wheeler wrote:
> One other thought - is there a way to give non-rotational devices also 
> some indication of latency? (FLASH is slower than enterprise SSD is 
> slower than DRAM ramdisk for example)?

Not at the moment ... since libata uses SAT, we're bound by what the SBC
mode pages can do for us, so the VPD only reports rotational speed (or a
specific flag for non rotation) and form factor.  There was once a
flexible disk mode page that showed some of this, but it's been listed
as obsolete since SBC-2.

There are, perhaps other VPD parameters we should be paying attention
to, like Block Limits (B0) which shows optimal transfer length and
granularity.

James


