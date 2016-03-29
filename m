From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] sd: fixup capacity calculation for 4k drives
Date: Mon, 28 Mar 2016 21:14:24 -0400
Message-ID: <yq1io06t79r.fsf@sermon.lab.mkp.net>
References: <1458563249-91200-1-git-send-email-hare@suse.de>
	<yq1a8lr5n2y.fsf@sermon.lab.mkp.net> <56F0F0E8.6060302@suse.de>
	<1458656217.17965.48.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:36520 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751207AbcC2BOh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2016 21:14:37 -0400
In-Reply-To: <1458656217.17965.48.camel@localhost.localdomain> (Ewan
	D. Milne's message of "Tue, 22 Mar 2016 10:16:57 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

>>>>> "Ewan" == Ewan D Milne <emilne@redhat.com> writes:

Ewan/Hannes,

Sorry I dropped the ball on this. My eyes started bleeding.

Ewan> If we change the meaning of the scsi_disk->capacity field to be
Ewan> logical sectors, we also have to change sd_getgeo() in sd.c, do we
Ewan> not?

I did consider that before sending the original patch but didn't see a
problem. In looking closer, however, it does appear that we'd
inadvertently change the reported geometry for 4Kn devices that are
sufficiently small. So I fixed that up.

Ewan> The ->capacity field is also accessed by last_sector_hacks() in
Ewan> drivers/usb/storage/transport.c, although it kind of looks like
Ewan> that code might not have been correct for 4K sectors with the
Ewan> scaled value.

That case I had missed. Ew, gross! But yes, that was broken to begin
with.

I have to admit I was going back and forth how to fix this. But in the
end I find it really ugly that capacity suddenly changes from logical
blocks to block layer sectors. And I prefer to make that conversion
explicit when it is necessary.

Amended patch follows...

-- 
Martin K. Petersen	Oracle Linux Engineering
