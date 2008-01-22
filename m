From: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 18:23:25 +0300
Message-ID: <47960A6D.6010602@vlnb.net>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>	
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>	
	<478F246C.4040400@vlnb.net>	
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>	
	<20080117174542.GC29650@osc.edu>	
	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>	
	<4795D4A7.5000105@vlnb.net>
	<e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <e2e108260801220432l353b1d76xd2707b5e6f336aef-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Bart Van Assche <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche wrote:
> On Jan 22, 2008 12:33 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org 
> <mailto:vst-d+Crzxg7Rs0@public.gmane.org>> wrote:
>>
>>  What are the new SRPT/iSER numbers?
> 
> You can find the new performance numbers below. These are all numbers 
> for reading from the remote buffer cache, no actual disk reads were 
> performed. The read tests have been performed with dd, both for a block 
> size of 512 bytes and of 1 MB. The tests with small block size learn 
> more about latency, while the tests with large block size learn more 
> about the maximal possible throughput.

If you want to compare performance of 512b vs 1MB blocks, your 
experiment isn't fully correct. You should use "iflag=direct" dd option 
for that.

> ............................................................................................. 
> 
> .                           .   STGT read     SCST read    .    STGT 
> read      SCST read    .
> .                           .  performance   performance   .   
> performance    performance   .
> .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, 
> MB/s)   (1 MB, MB/s)  .
> .............................................................................................
> . Ethernet (1 Gb/s network) .      77             78       .        
> 77             89       .
> . IPoIB    (8 Gb/s network) .     163            185       .       
> 201            239       .
> . iSER     (8 Gb/s network) .     250            N/A       .       
> 360            N/A       .
> . SRP      (8 Gb/s network) .     N/A            421       .       
> N/A            683       .
> .............................................................................................
> 
> My conclusion from the above numbers: the performance difference between 
> STGT and SCST is small for a Gigabit Ethernet network. The faster the 
> network technology, the larger the difference between SCST and STGT.

This is what I expected

> Bart.
