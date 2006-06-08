From: "Lev A. Melnikovsky" <leva@hotmail.com>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Fri, 9 Jun 2006 01:13:41 +0400 (MSD)
Message-ID: <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
 <Pine.LNX.4.60.0606072312410.9588@poirot.grange>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from [212.45.14.9] ([212.45.14.9]:25288 "EHLO ari.home")
	by vger.kernel.org with ESMTP id S964980AbWFHVNf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jun 2006 17:13:35 -0400
In-Reply-To: <Pine.LNX.4.60.0606072312410.9588@poirot.grange>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Cc: linux-scsi@vger.kernel.org

Dear Guennadi,

> Return the active request for retry to the upper layer in case of
> "reselect without disconnect" instead of just losing it.
Oh, thank you for the patch. Now the scan is finished even if several 
"reselect: w/o disconnected cmds <02-0> with active srb" happened during 
the operation. A funny artifact though can be seen at the picture (this is 
a ~800KB map of Japan http://kapitza.ras.ru/~leva/Japan.jpg ). It looks 
like during each reselect a chunk of data is lost (or maybe transferred 
twice?) and the data stream gets an offset. My understanding is that the 
scan data are 8bits per color component which gives 24bits/pixel.

Any idea why it happens and how to fix it?

   On Wed, 7 Jun 2006 at 11:28pm, Guennadi Liakhovetski wrote:

> Now, below is a patch... That's about all I can say about it:-) The
> reselect routine didn't seem right to me, specifically, it checks for "no
> active request-block or active request-block is not disconnected" and then
> sends an abort to the device, but if there was indeed an active srb, it
> gets lost, AFAICS. FWIW, tmscsim does the same... The patch below tries to
> complete the command before dropping it on the floor... Any reviews
> appreciated.
>
> And there's one more page_address there in dc395x...
>
> Warning, Lev - this patch may explode your scanner, or upload your bank
> account info to p2p servers, or send your gpg keys to microsoft, or...
> You've been warned:-) You might want to wait for some comments to the
> patch...
Thanks for the warning :-)

-L.
