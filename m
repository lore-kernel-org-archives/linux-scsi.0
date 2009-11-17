From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Tue, 17 Nov 2009 23:00:28 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911172231040.20752@kai.makisara.local>
References: <bug-14563-11613@http.bugzilla.kernel.org/> <200911161919.nAGJJZ94028105@demeter.kernel.org> <20091117141437G.fujita.tomonori@lab.ntt.co.jp> <4B028253.1040407@jmbreuer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh01.mail.saunalahti.fi ([62.142.5.107]:34255 "EHLO
	emh01.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751639AbZKQVAi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Nov 2009 16:00:38 -0500
In-Reply-To: <4B028253.1040407@jmbreuer.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@jmbreuer.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Tue, 17 Nov 2009, linux-kernel@jmbreuer.net wrote:

> FUJITA Tomonori wrote:
> >>> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> >>> spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> >>> is hit shortly thereafter.
> >>>
> >> Can you try this with debugging enabled in st? (Edit st.c to
> >> '#define DEBUG 1' and recompile the module.) This might give more 
> >> information about the source of the EIO and the code path it uses.
> > 
> > Sorry about that bug.
> > 
> > Looks like that st drivers messes up memory management but the log
> > doesn't give enough information.
> > 
> > As Kai suggested, please enable the debug option and send the new log.
> 
> I've attached the relevant information to
> http://bugzilla.kernel.org/show_bug.cgi?id=14563
> 
Thanks for the logs. I was hoping that they would show why that EIO 
happens. However, they do give other probably useful information.

I don't have enough energy tonight to experiment (sleep deprived ;-) but I 
have looked at the output and may have found something. The buffer size 
516096 B = 504 kB = 126 * 4096 looks suspicious, especially with 512 kB 
fixed blocks. In this case the buffer should be at least one block. This 
is given to enlarge_buffer() as argument.

Looking at enlarge_buffer(), it seems to me that if the allocation loop 
near the end fails with segs < max_segs before got > new_size, we have a 
bug: the allocation actually fails but it is returned as success. However, 
I don't have any explanation why this would happen.

I will continue tomorrow (after work).

Kai

