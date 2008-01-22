From: "Bart Van Assche" <bart.vanassche-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: Re: Performance of SCST versus STGT
Date: Tue, 22 Jan 2008 13:32:08 +0100
Message-ID: <e2e108260801220432l353b1d76xd2707b5e6f336aef@mail.gmail.com>
References: <e2e108260801170127w2937b2afg9bef324efa945e43@mail.gmail.com>
	<20080117184052F.fujita.tomonori@lab.ntt.co.jp>
	<478F246C.4040400@vlnb.net>
	<20080117190558K.fujita.tomonori@lab.ntt.co.jp>
	<20080117174542.GC29650@osc.edu>
	<e2e108260801220204k4b914ea1o9b47c0b22c6d098b@mail.gmail.com>
	<4795D4A7.5000105@vlnb.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="===============1770018139=="
Return-path: <stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
In-Reply-To: <4795D4A7.5000105-d+Crzxg7Rs0@public.gmane.org>
List-Unsubscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=unsubscribe>
List-Archive: <https://lists.berlios.de/pipermail/stgt-devel>
List-Post: <mailto:stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org>
List-Help: <mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=help>
List-Subscribe: <https://lists.berlios.de/mailman/listinfo/stgt-devel>,
	<mailto:stgt-devel-request-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org?subject=subscribe>
Sender: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
Errors-To: stgt-devel-bounces-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
To: Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org>
Cc: James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org, stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, FUJITA Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, scst-devel-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org
List-Id: linux-scsi@vger.kernel.org

--===============1770018139==
Content-Type: multipart/alternative;
	boundary="----=_Part_12046_17773148.1201005128934"

------=_Part_12046_17773148.1201005128934
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Jan 22, 2008 12:33 PM, Vladislav Bolkhovitin <vst-d+Crzxg7Rs0@public.gmane.org> wrote:
>
> What are the new SRPT/iSER numbers?

You can find the new performance numbers below. These are all numbers for
reading from the remote buffer cache, no actual disk reads were performed.
The read tests have been performed with dd, both for a block size of 512
bytes and of 1 MB. The tests with small block size learn more about latency,
while the tests with large block size learn more about the maximal possible
throughput.

.............................................................................................
.                           .   STGT read     SCST read    .    STGT
read      SCST read    .
.                           .  performance   performance   .
performance    performance   .
.                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB,
MB/s)   (1 MB, MB/s)  .
.............................................................................................
. Ethernet (1 Gb/s network) .      77             78       .        77
      89       .
. IPoIB    (8 Gb/s network) .     163            185       .
201            239       .
. iSER     (8 Gb/s network) .     250            N/A       .
360            N/A       .
. SRP      (8 Gb/s network) .     N/A            421       .
N/A            683       .
.............................................................................................

My conclusion from the above numbers: the performance difference between
STGT and SCST is small for a Gigabit Ethernet network. The faster the
network technology, the larger the difference between SCST and STGT.

Bart.

------=_Part_12046_17773148.1201005128934
Content-Type: text/html; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

<span style="font-family: courier new,monospace;">On Jan 22, 2008 12:33 PM, Vladislav Bolkhovitin &lt;<a href="mailto:vst-d+Crzxg7Rs0@public.gmane.org">vst-d+Crzxg7Rs0@public.gmane.org</a>&gt; wrote:</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">
&gt; </span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">&gt; What are the new SRPT/iSER numbers?</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">You can find the new performance numbers below. These are all numbers for reading from the remote buffer cache, no actual disk reads were performed. The read tests have been performed with dd, both for a block size of 512 bytes and of 1 MB. The tests with small block size learn more about latency, while the tests with large block size learn more about the maximal possible throughput.
</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">.............................................................................................
</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">.&nbsp; &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; . &nbsp; STGT read&nbsp;&nbsp;&nbsp;&nbsp; SCST read &nbsp;&nbsp; .&nbsp; &nbsp; STGT read&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; SCST read&nbsp;&nbsp;&nbsp; .<br>.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp; performance&nbsp;&nbsp; performance&nbsp;&nbsp; . &nbsp; performance&nbsp;&nbsp;&nbsp; performance&nbsp;&nbsp; .
<br>.&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp; (0.5K, MB/s)&nbsp; (0.5K, MB/s)&nbsp; .&nbsp;&nbsp; (1 MB, MB/s)&nbsp;&nbsp; (1 MB, MB/s)&nbsp; .<br>.............................................................................................</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">. Ethernet (1 Gb/s network) . &nbsp;&nbsp;&nbsp;&nbsp; 77&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 78&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 77&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp;&nbsp;&nbsp; 89&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .<br>. IPoIB&nbsp;&nbsp;&nbsp; (8 Gb/s network) . &nbsp;&nbsp;&nbsp; 163&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 185&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 201&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; &nbsp; 239&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .
</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">. iSER&nbsp;&nbsp;&nbsp;&nbsp; (8 Gb/s network) . &nbsp;&nbsp;&nbsp; 250&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; N/A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 360&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp;&nbsp; N/A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .</span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">. SRP&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; (8 Gb/s network) . &nbsp;&nbsp;&nbsp; N/A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 421&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; N/A&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; &nbsp; 683&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; .</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">
.............................................................................................</span><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;"></span><br style="font-family: courier new,monospace;">
<span style="font-family: courier new,monospace;">My conclusion from the above numbers: the performance difference between STGT and SCST is small for a Gigabit Ethernet network. The faster the network technology, the larger the difference between SCST and STGT.
</span><br style="font-family: courier new,monospace;"><br style="font-family: courier new,monospace;"><span style="font-family: courier new,monospace;">Bart.</span>

------=_Part_12046_17773148.1201005128934--

--===============1770018139==
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

_______________________________________________
Stgt-devel mailing list
Stgt-devel-0fE9KPoRgkgATYTw5x5z8w@public.gmane.org
https://lists.berlios.de/mailman/listinfo/stgt-devel

--===============1770018139==--
