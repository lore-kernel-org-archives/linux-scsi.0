From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RESEND] scsi: Fix sense information setting in fixed
 sized format
Date: Thu, 17 Sep 2015 07:24:23 -0700
Message-ID: <1442499863.4073.4.camel@HansenPartnership.com>
References: <1441298973-27735-1-git-send-email-sagig@mellanox.com>
	 <1441306948.23183.328.camel@localhost.localdomain>
	 <55FAB53C.3080102@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33987 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751643AbbIQOYY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2015 10:24:24 -0400
In-Reply-To: <55FAB53C.3080102@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: emilne@redhat.com, linux-scsi@vger.kernel.org

On Thu, 2015-09-17 at 15:42 +0300, Sagi Grimberg wrote:
> On 9/3/2015 10:02 PM, Ewan Milne wrote:
> > On Thu, 2015-09-03 at 19:49 +0300, Sagi Grimberg wrote:
> >> In fixed size sense format the information field is a four byte
> >> field.
> >>
> >> Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
> >> Reviewed-by: Martin K. Petersen <martin.petersen@oracle.com>
> >> Reviewed-by: Bart Van Assche <bart.vanassche@sandisk.com>
> >> Reviewed-by: Christoph Hellwig <hch@lst.de>
> >> ---
> >>   drivers/scsi/scsi_common.c | 2 +-
> >>   1 file changed, 1 insertion(+), 1 deletion(-)
> >>
> >> diff --git a/drivers/scsi/scsi_common.c b/drivers/scsi/scsi_common.c
> >> index 41432c10dda2..8cfb7eeb5bbc 100644
> >> --- a/drivers/scsi/scsi_common.c
> >> +++ b/drivers/scsi/scsi_common.c
> >> @@ -270,7 +270,7 @@ void scsi_set_sense_information(u8 *buf, u64 info)
> >>   		put_unaligned_be64(info, &ucp[4]);
> >>   	} else if ((buf[0] & 0x7f) == 0x70) {
> >>   		buf[0] |= 0x80;
> >> -		put_unaligned_be64(info, &buf[3]);
> >> +		put_unaligned_be32(info, &buf[3]);
> >>   	}
> >>   }
> >>   EXPORT_SYMBOL(scsi_set_sense_information);
> >
> > Looks correct per SPC-4 4.5.3
> >
> > And you did post a patch to target for the case where the sector
> > did not fit in 32 bits, which requires descriptor format sense, so...
> >
> > Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> 
> James, can you pick this up please?

It went quietly via the target tree.  I did keep an eye on it because
the target disruption in scsi_sommon.c was why I couldn't send the rest
of your sense descriptor patches via scsi.

commit 12306b425d0dbab7b60f54e02d67cf3dfae494d1

James



