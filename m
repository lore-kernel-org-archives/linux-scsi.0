From: Jens Axboe <jaxboe@fusionio.com>
Subject: Re: I/O topology fixes for big physical block size
Date: Tue, 28 Sep 2010 07:24:10 +0900
Message-ID: <4CA1198A.2050004@fusionio.com>
References: <1285605664-27027-1-git-send-email-martin.petersen@oracle.com>	<4CA0CC38.5010804@fusionio.com> <20100927172309.GA13874@redhat.com>	<1285624684.2888.120.camel@mulgrave.site>	<4CA114A3.4010202@fusionio.com> <yq1hbhadear.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.fusionio.com ([64.244.102.31]:33126 "EHLO mx2.fusionio.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751752Ab0I0WYO (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2010 18:24:14 -0400
In-Reply-To: <yq1hbhadear.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <James.Bottomley@suse.de>, Mike Snitzer <snitzer@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 2010-09-28 07:14, Martin K. Petersen wrote:
>>>>>> "Jens" == Jens Axboe <jaxboe@fusionio.com> writes:
> 
> Jens> Yes, from a correctness point of view it doesn't matter, but when
> Jens> people go looking up fixes for whatever reason, it's much better
> Jens> to include such a fix in the original patch so it's not missed.
> 
> I have talked to a few standards people today. They are of the opinion
> that the device's usage of the physical block exponent is incorrect. And
> that the device must provide the Block Limits and the TP VPD if thin
> provisioning is enabled.
> 
> However, devices with 8KiB physical blocks are shipping and 16KiB ditto
> are right around the corner.  Which says to me that it's important to
> report the correct thing to userland so we can cause allocators to align
> on the right boundaries, etc. If we artificially clamp the physical
> block size parameter in the kernel we are losing information. Note that
> there are no kernel users of the physical block size parameter at all.

With the revised understanding that this is purely the IO hint, then yes
I agree we should not clamp it.

-- 
Jens Axboe

