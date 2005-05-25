From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: NBD (vs. iSCSI vs. EATA vs...)
Date: Thu, 26 May 2005 01:41:54 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0505260103430.6612@poirot.grange>
References: <1416215015.20050504193114@dns.toxicfilms.tv>
 <1115236116.7761.19.camel@dhollis-lnx.sunera.com>  <1104082357.20050504231722@dns.toxicfilms.tv>
  <1115305794.3071.5.camel@dhollis-lnx.sunera.com>  <20050507150538.GA800@favonius>
  <Pine.LNX.4.60.0505102352430.9008@poirot.grange> <1115923927.5042.18.camel@mulgrave>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:44746 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S261612AbVEYXmh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 25 May 2005 19:42:37 -0400
In-Reply-To: <1115923927.5042.18.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Paul.Clements@steeleye.com

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

