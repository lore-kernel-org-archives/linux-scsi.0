From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Fri, 9 Jun 2006 00:00:41 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606082349110.12855@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
 <Pine.LNX.4.60.0606072312410.9588@poirot.grange> <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:21428 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S965002AbWFHWAn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 18:00:43 -0400
In-Reply-To: <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Fri, 9 Jun 2006, Lev A. Melnikovsky wrote:

> Dear Guennadi,
> 
> > Return the active request for retry to the upper layer in case of
> > "reselect without disconnect" instead of just losing it.
> Oh, thank you for the patch. Now the scan is finished even if several
> "reselect: w/o disconnected cmds <02-0> with active srb" happened during the
> operation.

Wow, really! So, we are on the right track.

> A funny artifact though can be seen at the picture (this is a
> ~800KB map of Japan http://kapitza.ras.ru/~leva/Japan.jpg ). It looks like
> during each reselect a chunk of data is lost (or maybe transferred twice?) and
> the data stream gets an offset. My understanding is that the scan data are
> 8bits per color component which gives 24bits/pixel.

Nice pic, if you took a bit further West you'd scan Vladivostok - that's 
where I come from:-)

> Any idea why it happens and how to fix it?

Well, I think, we just have to chose the right error-cods to return, this 
controls the mid-layer bahaviour - whether to abort, or to resubmit, or 
whatever. The error I returned (DID_SOFT_ERROR) means "retry". Honestly, I 
don't know what's the correct error-code here. I can only guess. Well, 
please, try DID_ABORT. Also, you can strace the application with complete 
data log (strace -xx -s 1024 -o/tmp/scan.trace) and try to find if there 
are duplicated blocks... Maybe we should just report an error to the 
application and let it re-try? It seemed logical to me to ask for a retry. 
James?

>   On Wed, 7 Jun 2006 at 11:28pm, Guennadi Liakhovetski wrote:
> 
> > Warning, Lev - this patch may explode your scanner, or upload your bank
> > account info to p2p servers, or send your gpg keys to microsoft, or...
> > You've been warned:-) You might want to wait for some comments to the
> > patch...
> Thanks for the warning :-)

Thanks for your courage:-)

Guennadi
---
Guennadi Liakhovetski
