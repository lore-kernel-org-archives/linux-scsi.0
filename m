From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Mon, 6 Dec 2010 17:50:07 +0900
Message-ID: <20101206174923Q.fujita.tomonori@lab.ntt.co.jp>
References: <1291223211.2814.72.camel@larosa>
	<alpine.LNX.2.00.1012021823420.9213@kai.makisara.local>
	<alpine.LNX.2.00.1012060952570.7928@kai.makisara.local>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:43809 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751620Ab0LFIu0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 6 Dec 2010 03:50:26 -0500
In-Reply-To: <alpine.LNX.2.00.1012060952570.7928@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai.Makisara@kolumbus.fi
Cc: lkolbe@techfak.uni-bielefeld.de, linux-scsi@vger.kernel.org, fujita.tomonori@lab.ntt.co.jp

On Mon, 6 Dec 2010 09:59:11 +0200 (EET)
Kai Makisara <Kai.Makisara@kolumbus.fi> wrote:

> On Thu, 2 Dec 2010, Kai Makisara wrote:
> 
> > On Wed, 1 Dec 2010, Lukas Kolbe wrote:
> > 
> > > Am Dienstag, den 30.11.2010, 18:20 +0200 schrieb Kai Makisara:
> > > 
> > ...
> > > > If you see error with 64 kB block size, I would like to see any messages 
> > > > associated with these errors.
> > > 
> > > I have now hit this bug again. Trying to read and write a label from the
> > > tape drive in question results in this (via bacula's btape command):
> > > 
> ...
> > > [158529.011206] st1: Can't allocate 2097152 byte tape buffer.
> > > [158544.348411] st: append_to_buffer offset overflow.
> > > [158544.348416] st: append_to_buffer offset overflow.
> > > [158544.348418] st: append_to_buffer offset overflow.
> > > [158544.348419] st: append_to_buffer offset overflow.
> > > 
> > The messages except the first one are something that should never happen. 
> > I think that there is something wrong with returning from enlarge_buffer() 
> > when it fails. I will look at this when I have time.
> > 
> OK, today I have had some time (national holiday). I think I have tracked 
> down this problem. The patch at the end should fix it. Basically, 
> normalize_buffer() needs to know the order of the pages in order to 
> properly free the pages and update the buffer size. When allocation 
> failed, the order was not yet stored into the tape buffer definition. This 
> does explain the problem after allocation failed.

Ah, nice catch! I've not tested the patch but looks correct.


> Why allocation failed is 
> another problem which has been discussed elsewhere.

Yeah.

Thanks a lot!
