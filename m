From: Martin Peschke3 <MPESCHKE@de.ibm.com>
Subject: Re: [PATCH] retry HARDWARE ERROR for IBM ESS (using BLIST)
Date: Mon, 29 Nov 2004 10:48:19 +0100
Message-ID: <OFBDF5C509.28F9ED44-ONC1256F5B.0033FA0F-C1256F5B.0036776D@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate2.de.ibm.com ([195.212.29.151]:14038 "EHLO
	mtagate2.de.ibm.com") by vger.kernel.org with ESMTP id S261641AbUK2JsP
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 29 Nov 2004 04:48:15 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, linux-scsi-owner@vger.kernel.org, willy@www.linux.org.uk





> On Fri, Nov 26, 2004 at 05:42:15PM +0100, Martin Peschke3 wrote:
> > +     case HARDWARE_ERROR:
> > +           if (scsi_get_device_flags(scmd->device,
> > +                               scmd->device->vendor,
> > +                               scmd->device->model)
> > +               & BLIST_RETRY_HWERROR)
> > +                 return NEEDS_RETRY;
> > +           else
> > +                 return SUCCESS;
> > +
> >       case ILLEGAL_REQUEST:
> >       case BLANK_CHECK:
> >       case DATA_PROTECT:
> > -     case HARDWARE_ERROR:
> >       default:
> >             return SUCCESS;
>
> You could actually fall through here, rather than having an else.  I
don't
> know which style we currently prefer (though we should certainly comment
> a fall-through).

well, I rather expected Christoph to keep on picking on me... ;)

But seriously, I had considered both and didn't like the idea of
having to make sure, using a comment, that an intentionally left-out
return will never be misunderstood as a bug.
I don't know which style is prefered, though.

James, what do you think? How are the odds of this workaround?

Martin

