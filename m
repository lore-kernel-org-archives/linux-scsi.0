From: James.Smart@Emulex.Com
Subject: RE: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Tue, 21 Sep 2004 13:07:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0B1E13B586976742A7599D71A6AC733C086575@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:57058 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S267863AbUIURH7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 13:07:59 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: hch@infradead.org
Cc: linux-scsi@vger.kernel.org

The snippet was the result of interacting with our ppc64 partner. Yes - it makes more sense to have the user set this.

-- james

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@infradead.org]
> Sent: Tuesday, September 21, 2004 12:56 PM
> To: Smart, James
> Cc: linux-scsi@vger.kernel.org
> Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
> 
> 
> Hmm, compilation fails for me on ppc64.  The culprit is a 
> little makefile
> fragment which has been in the driver since the beginning:
> 
> ifeq ($(shell uname -m),ppc64)
> ifndef ($(CROSS_COMPILE))
> CROSS_COMPILE := $(shell if [ -e 
> /usr/local/ppc64-current3.0/bin/powerpc64-linux-gcc ]; then \
>     echo /usr/local/ppc64-current3.0/bin/powerpc64-linux-; \
>     else if [ -e /opt/cross/bin/powerpc64-linux-gcc ]; then \
>     echo /opt/cross/bin/powerpc64-linux- ; fi fi)
> endif
> endif
> 
> I don't have a compiler in either of this places, shouldn't 
> it be better
> to rely on the user to always insert the proper CROSS_COMPILE command
> line?  I have for example a ~/bin/make64 script:
> 
> ---- snip ----
> CROSS_COMPILE=powerpc64-unknown-linux-gnu- make ARCH=ppc64 $*
> ---- snip ----
> 
