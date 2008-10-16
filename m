From: "Miller, Mike (OS Dev)" <Mike.Miller@hp.com>
Subject: RE: [PATCH 2/2] cciss: fix regression in procfs display fw	version,
 obsoletes previous patch 2 of 2
Date: Thu, 16 Oct 2008 22:56:58 +0000
Message-ID: <0F5B06BAB751E047AB5C87D1F77A77884C019B4CEF@GVW0547EXC.americas.hpqcorp.net>
References: <20081016215016.GB25704@roadking.ldev.net>
 <20081016145642.2ba2adba.akpm@linux-foundation.org>
 <0F5B06BAB751E047AB5C87D1F77A77884C019B4CBE@GVW0547EXC.americas.hpqcorp.net>
 <20081016223251.GA10270@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from g1t0029.austin.hp.com ([15.216.28.36]:7693 "EHLO
	g1t0029.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754950AbYJPW6W convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Oct 2008 18:58:22 -0400
In-Reply-To: <20081016223251.GA10270@x200.localdomain>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Jens Axboe <jens.axboe@oracle.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> > > +     return_code = sendcmd_withirq(CISS_INQUIRY, i, inq_buff,
> > > > +             sizeof(InquiryData_struct), 0, 0 ,0, TYPE_CMD);
> > > > +     if (return_code == IO_OK) {
> > > > +             hba[i]->firm_ver[0] = inq_buff->data_byte[32];
> > > > +             hba[i]->firm_ver[1] = inq_buff->data_byte[33];
> > > > +             hba[i]->firm_ver[2] = inq_buff->data_byte[34];
> > > > +             hba[i]->firm_ver[3] = inq_buff->data_byte[35];
> > > > +     } else {         /* send command failed */
> > > > +             printk(KERN_WARNING "cciss: unable to
> > > determine firmware"
> > > > +                     " version of controller\n");
> > > > +     }
> > > > +
> > > >       cciss_procinit(i);
> > > >
> > > >       hba[i]->cciss_max_sectors = 2048;
> >
> > Sorry, in too much of a hurry. I'll fix (again).
>
> And inq_buff is leaked, if I'm not missing simething.
>
Sorry, Alexy, I can't see the leak. Is it in the failure case?
