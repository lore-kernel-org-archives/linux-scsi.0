From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCHv2]sd: Don't treat succeeded SYNC as error
Date: Tue, 10 May 2016 09:00:39 -0700
Message-ID: <1462896039.2320.21.camel@linux.vnet.ibm.com>
References: <CAMGffE=C8mr_G=X8quAO44_0+1u_YNHDULwpBEJzSJnU4A4q9Q@mail.gmail.com>
	 <5727266E.7040905@suse.de> <1462196672.2665.5.camel@linux.vnet.ibm.com>
	 <CAMGffEmxzPrTKv=6Z=Nsiquk6L0OvZ3spYUR47CYUbaf5Spbeg@mail.gmail.com>
	 <CAMGffEmCz1vcpOgPznC+Yn7XuikbaFUFVDmQv_T4KjZqOt4hnQ@mail.gmail.com>
	 <CAMGffEnM_w8us49dCJWHU=UeDhyk53DRt5AD=sdezY3=Rv=omQ@mail.gmail.com>
	 <1462892898.2320.18.camel@linux.vnet.ibm.com>
	 <CAMGffEnxn203HX6JDxUO21vtV3FyRpy6qdArgzX4zNPgGp8JLA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e33.co.us.ibm.com ([32.97.110.151]:56003 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751948AbcEJQKB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 10 May 2016 12:10:01 -0400
Received: from localhost
	by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
	Tue, 10 May 2016 10:09:59 -0600
In-Reply-To: <CAMGffEnxn203HX6JDxUO21vtV3FyRpy6qdArgzX4zNPgGp8JLA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jinpu Wang <jinpu.wang@profitbricks.com>
Cc: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, Sebastian Parschauer <s.parschauer@gmx.de>, Bart Van Assche <bart.vanassche@sandisk.com>

On Tue, 2016-05-10 at 17:46 +0200, Jinpu Wang wrote:
> On Tue, May 10, 2016 at 5:08 PM, James Bottomley
> <jejb@linux.vnet.ibm.com> wrote:
[...]
> > Actually, I think this is symptomatic of a much bigger problem. 
> >  Now that the FS can send zero length non BLOCK_PC request, we're 
> > not treating failure correctly.  blk_update_request() will always
> > finish them becuase they have no bytes outstanding (not having any 
> > in the first case).  So I think we need a special exception for all 
> > zero length commands which complete with a failure to allow them to
> > retry (if required).
> 
> Which request do you mean, I only find FLUSH?

Flush is the only one currently, but zero length fs requests didn't
exist when this bit of SCSI was coded, which is why all the code judges
request completion on have we completed all the bytes (which is
obviously true if you had no bytes to send in the first place).

> I will test your patch.

Thanks.

James

> Thanks,
> Jack
> 
> > 
> > James
> > 
> > ---
> > 
> > diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> > index 8106515..5a97866 100644
> > --- a/drivers/scsi/scsi_lib.c
> > +++ b/drivers/scsi/scsi_lib.c
> > @@ -911,9 +911,12 @@ void scsi_io_completion(struct scsi_cmnd *cmd,
> > unsigned int good_bytes)
> >         }
> > 
> >         /*
> > -        * If we finished all bytes in the request we are done now.
> > +        * special case: failed zero length commands always need to
> > +        * drop down into the retry code. Otherwise, if we finished
> > +        * all bytes in the request we are done now.
> >          */
> > -       if (!scsi_end_request(req, error, good_bytes, 0))
> > +       if (!(good_bytes == 0 && blk_rq_bytes(req) == 0 && result
> > != 0) &&
> > +           !scsi_end_request(req, error, good_bytes, 0))
> >                 return;
> > 
> >         /*
> > 
> 
> 
> 

