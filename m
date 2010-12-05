From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: After memory pressure: can't read from tape anymore
Date: Sun, 5 Dec 2010 21:16:01 +0900
Message-ID: <20101205211537C.fujita.tomonori@lab.ntt.co.jp>
References: <1291395815.2814.376.camel@larosa>
	<1291399814.2881.66.camel@mulgrave.site>
	<1291546383.2814.2890.camel@larosa>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:54343 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab0LEMQg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 5 Dec 2010 07:16:36 -0500
In-Reply-To: <1291546383.2814.2890.camel@larosa>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lkolbe@techfak.uni-bielefeld.de
Cc: James.Bottomley@suse.de, kai.makisara@kolumbus.fi, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Kashyap.Desai@lsi.com

On Sun, 05 Dec 2010 11:53:03 +0100
Lukas Kolbe <lkolbe@techfak.uni-bielefeld.de> wrote:

> Well, 2MB blocksizes actually do work - bacula is reporting a blocksize
> of ~2MB for each drive while writing to it - only after there was memory
> pressure and a new tape got inserted, it is *not* possible anymore to
> write to the tape with these blocksizes, and dmesg tells me one of these
> every time bacula tries to read from or write to a tape:

I don't know how bacula works but I guess that it closes and reopen a
st device when you insert a new tape. The driver frees the memory when
it closes the device.


> [101883.958351] st0: Can't allocate 2097152 byte tape buffer.
> [103901.666608] st0: Can't allocate 10249541 byte tape buffer.
> 
> No idea why it's trying 10MB, though.
> 
> I tested with the patch from Fujita, and this messages from before
> applying the patch: 
> 
> [158544.348411] st: append_to_buffer offset overflow.
> 
> do not appear anymore.
> It didn't help on the not-being-able-to-write-after-memory-pressure
> matter, though.

There is no way to guarantee that we can allocate physically continuous
large memory.


> >  This isn't something we can work around
> > in the driver because the transaction can't be split ... it has to go
> > down as a single WRITE command with a single output data buffer.
> > 
> > The LSI 1068 is an upgradeable firmware system, so it's always possible
> > LSI can come up with a firmware update that increases the size (this
> > would also require a corresponding driver change), but it doesn't sound
> > to be something that can be done in the driver alone.
> 
> If only LSI's website were a little more clear on where to find updated
> firmware and what was the latest version :/.
n

I think that Desai said that your hardware can handle more sg
entries. You have a better chance to live with memory pressure. Try
the following patch with my patch. You need to set FUSION_MAX_SGE to
256 with kernel meunconfig (or whatever you like) and rebuild your
kernel. Make sure that the driver supports 256 entries like this:

fujita@calla:~$ cat /sys/class/scsi_host/host4/sg_tablesize
256

diff --git a/drivers/message/fusion/Kconfig b/drivers/message/fusion/Kconfig
index a34a11d..e70d65e 100644
--- a/drivers/message/fusion/Kconfig
+++ b/drivers/message/fusion/Kconfig
@@ -61,9 +61,9 @@ config FUSION_SAS
 	  LSISAS1078
 
 config FUSION_MAX_SGE
-	int "Maximum number of scatter gather entries (16 - 128)"
+	int "Maximum number of scatter gather entries (16 - 256)"
 	default "128"
-	range 16 128
+	range 16 256
 	help
 	  This option allows you to specify the maximum number of scatter-
 	  gather entries per I/O. The driver default is 128, which matches
