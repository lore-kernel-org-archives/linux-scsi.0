From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 16:14:39 +0100
Message-ID: <e2e108260801220714w6aa564b5q2140a4e5651a11f@mail.gmail.com>
References: <20080117174542.GC29650@osc.edu> <479096D2.8090003@vlnb.net>
	<e2e108260801200136g7f17b8a0g89a54cc1d73bbc34@mail.gmail.com>
	<20080122122657R.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <20080122122657R.fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Content-Disposition: inline
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>
Cc: stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, vst-d+Crzxg7Rs0@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

On Jan 22, 2008 4:26 AM, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org> wrote:
>
> First, I recommend you to examine iSER stuff more since it has some
> parameters unlike SRP, which effects the performance, IIRC. At least,
> you could get the iSER performances similar to Pete's.

Apparently open-iscsi uses the following defaults:
node.session.iscsi.FirstBurstLength = 262144
node.session.iscsi.MaxBurstLength = 16776192
node.conn[0].tcp.window_size = 524288
node.conn[0].iscsi.MaxRecvDataSegmentLength = 131072

I have tried to change some of these parameters to a larger value, but
this did not have a noticeable effect (read bandwidth increased less
than 1%):
$ iscsiadm --mode node --targetname
iqn.2007-05.com.example:storage.disk2.sys1.xyz --portal
192.168.102.5:3260 --op update -n node.session.iscsi.FirstBurstLength
-v 16776192
$ iscsiadm --mode node --targetname
iqn.2007-05.com.example:storage.disk2.sys1.xyz --portal
192.168.102.5:3260 --op update -n node.session.iscsi.MaxBurstLength -v
16776192
$ iscsiadm --mode node --targetname
iqn.2007-05.com.example:storage.disk2.sys1.xyz --portal
192.168.102.5:3260 --op update -n
"node.conn[0].iscsi.MaxRecvDataSegmentLength" -v 16776192

Bart.
