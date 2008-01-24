From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: [Stgt-devel] Performance of SCST versus STGT
Date: Thu, 24 Jan 2008 17:16:10 +0100
Message-ID: <e2e108260801240816n93a234av4368f5e8b3e49bca@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	 <20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	 <478F246C.4040400@vlnb.net>
	 <20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	 <20080117174542.GC29650@osc.edu>
	 <e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	 <4795D4A7.5000105@vlnb.net>
	 <e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
	 <20080124070616.GA31633@porcupine.cita.utoronto.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wx-out-0506.google.com ([66.249.82.237]:13385 "EHLO
	wx-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752970AbYAXQQN (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Jan 2008 11:16:13 -0500
Received: by wx-out-0506.google.com with SMTP id h31so177563wxd.4
        for <linux-scsi@vger.kernel.org>; Thu, 24 Jan 2008 08:16:12 -0800 (PST)
In-Reply-To: <20080124070616.GA31633@porcupine.cita.utoronto.ca>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Robin Humble <robin.humble+stgt@anu.edu.au>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, James.Bottomley@hansenpartnership.com, stgt-devel@lists.berlios.de, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel@lists.sourceforge.net

On Jan 24, 2008 8:06 AM, Robin Humble <robin.humble+stgt@anu.edu.au> wrote:
> On Tue, Jan 22, 2008 at 01:32:08PM +0100, Bart Van Assche wrote:
> >
> >.............................................................................................
> >.                           .   STGT read     SCST read    .    STGT read      SCST read    .
> >.                           .  performance   performance   .   performance    performance   .
> >.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB >MB/s)   (1 MB, MB/s)  .
> >.............................................................................................
> >. Ethernet (1 Gb/s network) .      77             78       .         77            89       .
> >. IPoIB    (8 Gb/s network) .     163            185       .        201           239       .
> >. iSER     (8 Gb/s network) .     250            N/A       .        360           N/A       .
> >. SRP      (8 Gb/s network) .     N/A            421       .        N/A           683       .
> >............................................................................................
>

Results with /dev/ram0 configured as backing store on the target (buffered I/O):
                    Read          Write             Read          Write
                  performance   performance       performance   performance
                  (0.5K, MB/s)  (0.5K, MB/s)      (1 MB, MB/s)  (1 MB, MB/s)
STGT + iSER           250          48                 349          781
SCST + SRP            411          66                 659          746

Results with /dev/ram0 configured as backing store on the target (direct I/O):
                    Read          Write             Read          Write
                  performance   performance       performance   performance
                  (0.5K, MB/s)  (0.5K, MB/s)      (1 MB, MB/s)  (1 MB, MB/s)
STGT + iSER             7.9         9.8               589          647
SCST + SRP             12.3         9.7               811          794

Bart.
