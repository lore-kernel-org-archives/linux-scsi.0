From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] ISCSI-SCST performance (with also IET and STGT	data)
Date: Tue, 31 Mar 2009 21:37:40 +0400
Message-ID: <49D254E4.8050806@vlnb.net>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net> <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1761845AbZCaRh6@vger.kernel.org>
In-Reply-To: <e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: iscsitarget-devel@lists.sourceforge.net, scst-devel <scst-devel@lists.sourceforge.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, stgt@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Bart Van Assche, on 03/30/2009 10:53 PM wrote:
> On Mon, Mar 30, 2009 at 8:33 PM, Vladislav Bolkhovitin <vst@vlnb.net>=
 wrote:
>> Bart Van Assche, on 03/30/2009 10:06 PM wrote:
>>> These are indeed interesting results. There are some aspects of the
>>> test setup I do not understand however:
>>> * All tests have been run with buffered I/O instead of direct I/O
>>> (iflag=3Ddirect / oflag=3Ddirect). My experience is that the result=
s of
>>> tests with direct I/O are easier to reproduce (less variation betwe=
en
>>> runs). So I have been wondering why the tests have been run with
>>> buffered I/O instead ?
>> Real applications use buffered I/O, hence it should be used in tests=
=2E It
>>  evaluates all the storage stack on both initiator and target as a w=
hole.
>> The results are very reproducible, variation is about 10%.
>=20
> Most applications do indeed use buffered I/O. Database software
> however often uses direct I/O. It might be interesting to publish
> performance results for both buffered I/O and direct I/O.

Yes, sure

> A quote from
> the paper "Asynchronous I/O Support in Linux 2.5" by Bhattacharya e.a=
=2E
> (Linux Symposium, Ottawa, 2003):
>=20
> Direct I/O (raw and O_DIRECT) transfers data between a user buffer an=
d
> a device without copying the data through the kernel=92s buffer cache=
=2E
> This mechanism can boost performance if the data is unlikely to be
> used again in the short term (during a disk backup, for example), or
> for applications such as large database management systems that
> perform their own caching.

Please don't misread phrase "unlikely to be used again in the short=20
term". If you have read-ahead, all your cached data is *likely* to be=20
used "again" in the near future after they were read from storage,=20
although only once in the first read by application. The same is true=20
for write-back caching, where data written to the cache once for each=20
command. Both read-ahead and write back are very important for good=20
performance and O_DIRECT throws them away. All the modern HDDs have a=20
memory buffer (cache) at least 2MB big on the cheapest ones. This cache=
=20
is essential for performance, although how can it make any difference i=
f=20
the host computer has, say, 1000 times more memory?

Thus, to work effectively with O_DIRECT an application has to be very=20
smart to workaround the lack of read-ahead and write back.

I personally consider O_DIRECT (as well as BLOCKIO) as nothing more tha=
n=20
a workaround for possible flaws in the storage subsystem. If O_DIRECT=20
works better, then in 99+% cases there is something in the storage=20
subsystem, which should be fixed to perform better.

To be complete, there is one case where O_DIRECT and BLOCKIO have an=20
advantage: both of them transfer data zero-copy. So they are good if=20
your memory is too slow comparing to storage (InfiniBand case, for=20
instance) and additional data copy hurts performance noticeably.

> Bart.
>=20
> ---------------------------------------------------------------------=
---------
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
>=20
