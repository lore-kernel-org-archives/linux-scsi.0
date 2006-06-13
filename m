From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: Error using DC315U to drive ScanJet 4c
Date: Tue, 13 Jun 2006 23:44:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0606132327190.7684@poirot.grange>
References: <Pine.LNX.4.64.0606042013200.14649@nev.ubzr>
 <Pine.LNX.4.60.0606041850090.13574@poirot.grange> <Pine.LNX.4.64.0606042201460.14649@nev.ubzr>
 <Pine.LNX.4.60.0606042022540.24306@poirot.grange> <Pine.LNX.4.64.0606051150440.4038@nev.ubzr>
 <Pine.LNX.4.60.0606051242150.4149@poirot.grange> <Pine.LNX.4.64.0606060050360.7237@nev.ubzr>
 <Pine.LNX.4.60.0606060008330.22057@poirot.grange> <Pine.LNX.4.64.0606070253580.14004@nev.ubzr>
 <Pine.LNX.4.60.0606072312410.9588@poirot.grange> <Pine.LNX.4.64.0606090054530.20041@nev.ubzr>
 <Pine.LNX.4.60.0606082349110.12855@poirot.grange> <Pine.LNX.4.64.0606140019310.20812@nev.ubzr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.21]:6105 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932341AbWFMVol (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Jun 2006 17:44:41 -0400
In-Reply-To: <Pine.LNX.4.64.0606140019310.20812@nev.ubzr>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Lev A. Melnikovsky" <leva@hotmail.com>
Cc: linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@steeleye.com>

On Wed, 14 Jun 2006, Lev A. Melnikovsky wrote:

> Dear Guennadi,
> 
>   On Fri, 9 Jun 2006 at 12:00am, Guennadi Liakhovetski wrote:
> 
> > Nice pic, if you took a bit further West you'd scan Vladivostok - that's
> > where I come from:-)
> OK, moving West :-)
> 
> http://kapitza.ras.ru/~leva/Vladik.jpg

Nice, thanks, but, unfortunately

"You don't have permission to access /~leva/Vladik.jpg on this server."

:-)

> > Well, I think, we just have to chose the right error-cods to return, this
> > controls the mid-layer bahaviour - whether to abort, or to resubmit, or
> > whatever. The error I returned (DID_SOFT_ERROR) means "retry". Honestly, I
> > don't know what's the correct error-code here. I can only guess. Well,
> > please, try DID_ABORT.
> Unfortunately this does not help. The picture above was acquired using
> DID_ABORT. There's probably some minor difference in the driver behaviour but
> I can not reliably say anything yet.

As you see, I couldn't see the picture, but I believe you it is not 
pretty:-)

> > Also, you can strace the application with complete
> Well, stracing sane will be the last thing I'm going to try, honestly :-)

I would've thought so... But, actually, I don't think it would be bigger 
than the scsi log you took... So, if you directly save the output to a 
file, like

strace -tt -xx -s4096 -o/tmp/scan.strace ...

and, no, not sane but scanimage - just call it from the command line under 
strace, but only if just comparing sizes fails (below)

> > Lev, an easier possibility to test if bytes are lost or repeated: just scan
> > an image several times, saving it in an UNcompressed format, then, I think,
> > the size should always be the same, right? Then you can just compare which
> > file is bigger - the correct or the damaged one.
> Image compression (jpeg) does not change the image dimensions. And dimensions
> are always the same. Anyway, "sane" knows these dimensions beforehand...

Emn, no, not image dimensions, but file-size. I would just put an image in 
the scanner, and without further touching it just call scanimage from the 
command-line several times, waiting to get 1 corrupted and 1 proper image. 
And, I think, jpeg compresses "graphically", so, jpeg files might differ 
even if you don't the image being scanned. Whereas uncompressed 
image-formats should produce constant-size files. That's what I would 
compare. Still, I think, at some point it would be interesting to compare 
the actual data coming from /dev/sg* in error and error-free cases.

> I remember you mentioned TRM-S1040 datasheet, is it publicly available? How do
> I get one?

I think, I also mentioned that I wouldn't mind having it too. No, I didn't 
find it online and nobody offered me one until now.

Thanks
Guennadi
---
Guennadi Liakhovetski
