From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [Announce] Emulex lpfcdriver v8.0.12 available
Date: Tue, 21 Sep 2004 17:56:13 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20040921175613.A25779@infradead.org>
References: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from imladris.demon.co.uk ([193.237.130.41]:36879 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S267851AbUIUQ4R (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Sep 2004 12:56:17 -0400
Content-Disposition: inline
In-Reply-To: <0B1E13B586976742A7599D71A6AC733C02F1C6@xbl3.ma.emulex.com>; from James.Smart@Emulex.Com on Mon, Sep 20, 2004 at 09:34:27PM -0400
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

Hmm, compilation fails for me on ppc64.  The culprit is a little makefile
fragment which has been in the driver since the beginning:

ifeq ($(shell uname -m),ppc64)
ifndef ($(CROSS_COMPILE))
CROSS_COMPILE := $(shell if [ -e /usr/local/ppc64-current3.0/bin/powerpc64-linux-gcc ]; then \
    echo /usr/local/ppc64-current3.0/bin/powerpc64-linux-; \
    else if [ -e /opt/cross/bin/powerpc64-linux-gcc ]; then \
    echo /opt/cross/bin/powerpc64-linux- ; fi fi)
endif
endif

I don't have a compiler in either of this places, shouldn't it be better
to rely on the user to always insert the proper CROSS_COMPILE command
line?  I have for example a ~/bin/make64 script:

---- snip ----
CROSS_COMPILE=powerpc64-unknown-linux-gnu- make ARCH=ppc64 $*
---- snip ----
