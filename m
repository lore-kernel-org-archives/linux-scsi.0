From: Henk Jan Priester <hj@justcroft.com>
Subject: Re: Que: generic scsi driver (sg) SG_IO ioctl
Date: Fri, 17 Oct 2003 14:06:01 +0200 (CEST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0310171350440.2743-100000@mars.justcroft.intern>
References: <3F8E98EB.9B7F445E@satzbau-gmbh.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from siemens4.servercity.co.uk ([217.205.138.46]:43275 "EHLO
	justcroft.co.uk") by vger.kernel.org with ESMTP id S263423AbTJQMGG
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 17 Oct 2003 08:06:06 -0400
Received: from mars [62.59.36.110]
	by justcroft.co.uk [212.47.84.192]
	with SMTP (MDaemon.Standard.v4.0.2.R)
	for <linux-scsi@vger.kernel.org>; Fri, 17 Oct 2003 13:00:15 +0100
In-Reply-To: <3F8E98EB.9B7F445E@satzbau-gmbh.de>
List-Id: linux-scsi@vger.kernel.org
To: abel deuring <a.deuring@satzbau-gmbh.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 16 Oct 2003, abel deuring wrote:

> Henk Jan Priester wrote:
> > 
> > Hello,
> > 
> > I am currently writing a program to communicate with
> > Xerox Xpress Plotter using the generic SCSI driver (kernel 2.4.20).
> > 
> > I am using the ioctl SGIO to send the SCSI pakkets to the
> > plotter, everything works fine till I start sending the plot data.
> > (model enquiry is ok, roll selection is ok, print setup is ok)
> > The ioctl goes ok but the status = 8, masked_status = 4, which
> > is busy if I am correct.
> > Does anybody know what can be the problem if the in case?
> 
> I'd guess this simply means that the plotter doesn't accept commands at
> the moment. Let your program simply usleep() for a while and repeat the
> command.
> 
> > 
> > Is there also a limit on the pakket size you can send with ioctl
> > SG_IO command?
> 
> Sane (http://www.sane-project.org) uses in most cases 128 kB data
> blocks, and I have successfully tested SCSI reads with up to 1 MB and
> more. With an increasing data block size there is though an increasing
> probability that the SG driver may return a memory error, because it
> could not allocate enough buffer memory. There is a SG ioctl to set the
> size of a reserved buffer; if you don't use larger data blocks than
> defined with this ioctl call, everything should work fine.
> 
> The main execption for the SCSI data size are old ISA SCSI adapters. For
> these adpaters, the max SCSI data size is linited to 64 kB or even 32 kB
> -- I can't recall the exact value, and I can't test it at present. But
> that's probably not 
> 
> To be on the safe side, you can simply call 
> 
>     ioctl(fd, SG_SET_RESERVED_SIZE, &buffersize);
>     ioctl(fd, SG_GET_RESERVED_SIZE, &buffersize);
> 
> and you have the "really available" buffer size.

Abel,

Thanks for your reply. I allready had a timeout of about one minute.
(tried the command six times with a delay of 10 sec).
Stefan Voelkel pointed me a 16kb limit for ioctl.

I have changed the program that the data sent at once is less then 16kb
and the retry of the command is now 20 times with a delay of 10sec.
It now works but I don't which of the two changes fixed the
problem (I think the data size). The plotter is connected at a
customer system where I don't have easy access to. If I get the
possible to debug this locally I will try to found out
wat the reason was.

Anyway thanks for your suggestions.

Henk Jan

-- 
H.J. Priester                           email:	hjpriester@justcroft.com
Justcroft Technical Systems B.V.        Tel:   +31 70 3644131 
Atjehstraat  21, 2585 VG	        Fax:   +31 70 3107593	
The Netherlands                        	WWW:   www.justcroft.com 
-------------------------------------------------------------------------------


