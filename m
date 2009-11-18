From: Kai Makisara <Kai.Makisara@kolumbus.fi>
Subject: Re: [Bug 14563] SCSI tape driver: Spurious EIO and kernel BUG
Date: Wed, 18 Nov 2009 23:55:10 +0200 (EET)
Message-ID: <alpine.LNX.2.00.0911182338070.13484@kai.makisara.local>
References: <bug-14563-11613@http.bugzilla.kernel.org/> <200911161919.nAGJJZ94028105@demeter.kernel.org> <20091117141437G.fujita.tomonori@lab.ntt.co.jp> <4B028253.1040407@jmbreuer.net> <alpine.LNX.2.00.0911172231040.20752@kai.makisara.local>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emh07.mail.saunalahti.fi ([62.142.5.117]:56499 "EHLO
	emh07.mail.saunalahti.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751314AbZKRVzU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Nov 2009 16:55:20 -0500
In-Reply-To: <alpine.LNX.2.00.0911172231040.20752@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@jmbreuer.net
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org

On Tue, 17 Nov 2009, Kai Makisara wrote:

> On Tue, 17 Nov 2009, linux-kernel@jmbreuer.net wrote:
> 
> > FUJITA Tomonori wrote:
> > >>> Performing tape backups using amanda 2.6.0-p2 [using 512kB block size] leads to
> > >>> spurious 'EIO' errors when writing to the tape; most of the time a kernel BUG
> > >>> is hit shortly thereafter.
> > >>>
...
> I don't have enough energy tonight to experiment (sleep deprived ;-) but I 
> have looked at the output and may have found something. The buffer size 
> 516096 B = 504 kB = 126 * 4096 looks suspicious, especially with 512 kB 
> fixed blocks. In this case the buffer should be at least one block. This 
> is given to enlarge_buffer() as argument.
> 
> Looking at enlarge_buffer(), it seems to me that if the allocation loop 
> near the end fails with segs < max_segs before got > new_size, we have a 
> bug: the allocation actually fails but it is returned as success. However, 
> I don't have any explanation why this would happen.
> 
> I will continue tomorrow (after work).
> 
OK, I have continued but not found the bug. I have also read the other 
messages from today. The problem seems to be related to direct i/o.

The logs from the problem case gives some information about what is 
happening. This is from the log with variable block size:

st0: Number of r/w requests 86, dio used in 1, pages 128.                                                    
st0: Block limits 1 - 16777215 bytes.                                                                        
st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
st0: Density 26, tape length: 0, drv buffer: 1
st0: Block size: 0, buffer size: 516096 (1 blocks).

The first line is from closing the file. It shows that, in this case, 
direct i/o was used in one write and the other ones have, for some reason, 
used the internal buffer. The aic7xxx driver supports 128 scatter/gather 
segments and so it is capable of using direct i/o up to 512 kB. It has 
gone to using buffer for some other reason (alignment?).

The following lines are from the next open. The buffer is (should be) 
deallocated at close() (normalize_buffer() called) but, in this case, 
something is wrong.

I have hacked the sym53c8xxx driver to support 128 s/g segments, enabled 
debugging in st, and added a printk to enlarge_buffer() showing the 
requested sizes. With dd, direct i/o is used for all writes, as expected.

Most of the evening I have been fighting with amanda to get it doing 
something. Now it works to some extent. Here is an excerpt from dmesg:

[ 8927.186369] st0: Rewinding tape.
[ 8927.304694] st: enlarge_buffer(524288)
[ 8927.339866] st0: Number of r/w requests 1, dio used in 0, pages 0.
[ 8927.882000] st: enlarge_buffer(4096)
[ 8927.882906] st0: Block limits 1 - 16777215 bytes.
[ 8927.883530] st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 8927.883539] st0: Density 26, tape length: 0, drv buffer: 1
[ 8927.883547] st0: Block size: 0, buffer size: 4096 (1 blocks).
[ 8927.883560] st0: No op on tape.
[ 8927.883567] st0: Rewinding tape.
[ 8927.890818] st: enlarge_buffer(524288)
[ 8927.926274] st0: Rewinding tape.
[ 8927.928806] st0: Rewinding tape.
[ 8927.959196] st0: Writing 1 filemarks.
[ 8964.922501] st0: Writing 1 filemarks.
[ 8967.184606] st0: Rewinding tape.
[ 8977.137173] st0: Number of r/w requests 182, dio used in 4, pages 512.
[ 9033.379568] st0: Block limits 1 - 16777215 bytes.
[ 9033.380174] st0: Mode sense. Length 11, medium 0, WBS 10, BLL 8
[ 9033.380179] st0: Density 26, tape length: 0, drv buffer: 1
[ 9033.380184] st0: Block size: 0, buffer size: 516096 (1 blocks).
[ 9033.380196] st0: No op on tape.

This shows that st has requested the 512 kB buffer. In the first case the 
buffer has been deallocated properly. In the second case, the buffer size 
is left at 516096. Something bad probably happens before this. One 
difference there is that in the first case the buffer has been used for 
all writes. In the second case the buffer is allocated after four direct 
writes.

Further experimentation has to wait for tomorrow.

Kai

