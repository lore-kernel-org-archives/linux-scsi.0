From: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 20:48:45 +0900
Message-ID: <20080122204845E.fujita.tomonori@lab.ntt.co.jp>
References: <e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
	<20080122122657R.fujita.tomonori@lab.ntt.co.jp>
	<4795D479.1080805@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <4795D479.1080805-d+Crzxg7Rs0@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: vst-d+Crzxg7Rs0@public.gmane.org
Cc: stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Tue, 22 Jan 2008 14:33:13 +0300
Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:

> FUJITA Tomonori wrote:
> > The big problem of stgt iSER is disk I/Os (move data between disk and
> > page cache). We need a proper asynchronous I/O mechanism, however,
> > Linux doesn't provide such and we use a workaround, which incurs large
> > latency. I guess, we cannot solve this until syslets is merged into
> > mainline.
> 
> Hmm, SCST also doesn't have ability to use asynchronous I/O, but that 
> doesn't prevent it from showing good performance.

I don't know how SCST performs I/Os, but surely, in kernel space, you
can performs I/Os asynchronously. Or you use an event notification
mechanism with multiple kernel threads performing I/Os synchronously.

Xen blktap has the same problem as stgt. IIRC, Xen mainline uses a
kernel patch to add a proper event notification to AIO though redhat
uses the same workaround as stgt instead of applying the kernel patch.
