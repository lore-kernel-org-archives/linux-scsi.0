From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...) (fwd)
Date: Sat, 28 May 2005 10:30:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505281029240.3721@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:29354 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S262308AbVE1Ics (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 28 May 2005 04:32:48 -0400
Received: from lyakh (helo=localhost)
	by poirot.grange with local-esmtp (Exim 3.35 #1 (Debian))
	id 1DbwiR-0000yx-00
	for <linux-scsi@vger.kernel.org>; Sat, 28 May 2005 10:30:43 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hi

3 my emails of 26.05 didn't make it through to the list, although James 
did receive at least one of them. I'll try again, sorry, if they do come 
doubled in the end.

Thanks
Guennadi
---
Guennadi Liakhovetski


---------- Forwarded message ----------
Date: Thu, 26 May 2005 01:41:54 +0200 (CEST)
From: Guennadi Liakhovetski <lyakh@poirot.grange>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Paul.Clements@steeleye.com
Subject: Re: NBD (vs. iSCSI vs. EATA vs...)

(Dropped most recepients of the original "ata over ethernet question" 
discussion, including lkml, from CC)

Hi

On Thu, 12 May 2005, James Bottomley wrote:
> However, there is room for improvement in nbd, notably the handling of
> packet commands, which looks to be eminently doable in the current
> infrastructure (this would basically make nbd a replicator for the linux
> block system, and would probably necessitate some client side changes to
> achieve).  If you have any thoughts in this direction, you could drop an
> email to the maintainer.

Ok, I came to a stage, when I start a server and a client, and then on the 
client side I can do open / close cycles, which would be respectively 
passed to the server, thus not keeping the server file(s) busy all the 
time. This allows, e.g., to export a CD-ROM, mount / umount it, eject it 
(not yet over nbd), insert a new one, mount, etc. Also, open errors are 
passed back, so, you get a nice "no medium" error on the client side 
without a CD.

IIUC, the suggestion from James to implement ATAPI translates in 
user-space terms to implementing respective ioctl's, because this is what 
nbd gets, and this is what nbd-server has to reproduce.

So, the work is not finished, at least some ioctl's are needed. I had to 
modify the kernel driver, and both the server and the client apps. No 
backward compatibility, sorry:-( What I'd like to do now is to ask - is 
there an interest in such changes to be integrated in the kernel / 
nbd-package. If there is one - what are your wishes? If we get that far, 
what should I post here - only the kernel patch, and user-space separately 
to sf (I think?), or both?

(see also my another post today to linux-scsi)

Thanks
Guennadi
---
Guennadi Liakhovetski

