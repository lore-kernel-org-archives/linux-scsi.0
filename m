From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Wed, 11 May 2016 08:05:20 -0700
Message-ID: <1462979120.2356.4.camel@HansenPartnership.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
	 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com>
	 <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
	 <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
	 <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
	 <1462892898.2320.18.camel@linux.vnet.ibm.com> <5732CF6A.20802@suse.de>
	 <1462949004.2674.6.camel@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47850 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751324AbcEKPFY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2016 11:05:24 -0400
In-Reply-To: <1462949004.2674.6.camel@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Tue, 2016-05-10 at 23:43 -0700, James Bottomley wrote:
> On Wed, 2016-05-11 at 08:21 +0200, Hannes Reinecke wrote:
[..]
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 7cb66b0..68c0e74 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -693,7 +693,7 @@ static bool scsi_end_request(struct request
> > *req, int error,
> >         struct scsi_device *sdev = cmd->device;
> >         struct request_queue *q = sdev->request_queue;
> > 
> > -       if (blk_update_request(req, error, bytes))
> > +       if (bytes && blk_update_request(req, error, bytes))
> >                 return true;
> 
> Um, I think you mean 
> 
> if (bytes == 0 || blk_update_request())

Actually, even this would be wrong.  We expect scsi_end_request called
with blk_rq_bytes() to complete the request and return false.  If you
do the above, it won't and we'll trigger a BUG lower down (or retry
forever).

James


