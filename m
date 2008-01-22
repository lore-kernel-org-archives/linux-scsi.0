From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 12:26:57 +0900
Message-ID: <20080122122657R.fujita.tomonori@lab.ntt.co.jp>
References: <20080117174542.GC29650@osc.edu> <479096D2.8090003@vlnb.net>
	<e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <e2e108260801200136g7f17b8a0g89a54cc1d73bbc34-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, vst-d+Crzxg7Rs0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Sun, 20 Jan 2008 10:36:18 +0100
"Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org> wrote:

> On Jan 18, 2008 1:08 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
> >
> > [ ... ]
> > So, seems I understood your slides correctly: the more valuable data for
> > our SCST SRP vs STGT iSER comparison should be on page 26 for 1 command
> > read (~480MB/s, i.e. ~60% from Bart's result on the equivalent hardware).
> 
> At least in my tests SCST performed significantly better than STGT.
> These tests were performed with the currently available
> implementations of SCST and STGT. Which performance improvements are

First, I recommend you to examine iSER stuff more since it has some
parameters unlike SRP, which effects the performance, IIRC. At least,
you could get the iSER performances similar to Pete's.


> possible for these projects (e.g. zero-copying), and by how much is it
> expected that these performance improvements will increase throughput
> and will decrease latency ?

The major bottleneck about RDMA transfer is registering the buffer
before transfer. stgt's iSER driver has pre-registered buffers and
move data between page cache and thsse buffers, and then does RDMA
transfer.

The big problem of stgt iSER is disk I/Os (move data between disk and
page cache). We need a proper asynchronous I/O mechanism, however,
Linux doesn't provide such and we use a workaround, which incurs large
latency. I guess, we cannot solve this until syslets is merged into
mainline.

The above approach still needs one memory copy (between the
pre-registered buffers and page cahce). If we need more performance,
we have to implement a new caching mechanism using the pre-registered
buffers instead of just using page cache. AIO with O_DIRECT enables us
to implement such caching mechanism (we can use eventfd so we don't
need something like syslets, that is, we can implement such now).

I'm not sure someone will implement such RDMA caching mechanism for
stgt. Pete and his colleagues implemented stgt iSER driver (thanks!)
but they are not interested in block I/Os (they are OSD people).
