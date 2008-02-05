From: "Bart Van Assche" <bart.vanassche@gmail.com>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Tue, 5 Feb 2008 17:25:44 +0100
Message-ID: <e2e108260802050825u68ef2ee9m6e085acb6b474fe@mail.gmail.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>
	 <1201639331.3069.58.camel@localhost.localdomain>
	 <47A05CBD.5050803@vlnb.net> <47A7049A.9000105@vlnb.net>
	 <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1759467AbYBEQ03@vger.kernel.org>
In-Reply-To: <e2e108260802040553j2f3bf8c2n9fae132e000990f7@mail.gmail.com>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Vladislav Bolkhovitin <vst@vlnb.net>, Vu Pham <vuhuong@mellanox.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, scst-devel@lists.sourceforge.net, linux-kernel@vger.kernel.org, "Nicholas A. Bellinger" <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

Regarding the performance tests I promised to perform: although until
now I only have been able to run two tests (STGT + iSER versus SCST +
SRP), the results are interesting. I will run the remaining test cases
during the next days.

About the test setup: dd and xdd were used to transfer 2 GB of data
between an initiator system and a target system via direct I/O over an
SDR InfiniBand network (1GB/s). The block size varied between 512
bytes and 1 GB, but was always a power of two.

Expected results:
* The measurement results are consistent with the numbers I published earlier.
* During data transfers all data is transferred in blocks between 4 KB
and 32 KB in size (according to the SCST statistics).
* For small and medium block sizes (<= 32 KB) transfer times can be
modeled very well by the following formula: (transfer time) = (setup
latency) + (bytes transferred)/(bandwidth). The correlation numbers
are very close to one.
* The latency and bandwidth parameters depend on the test tool (dd
versus xdd), on the kind of test performed (reading versus writing),
on the SCSI target and on the communication protocol.
* When using RDMA (iSER or SRP), SCST has a lower latency and higher
bandwidth than STGT (results from linear regression for block sizes <=
32 KB):
           Test          Latency(us) Bandwidth (MB/s) Correlation
   STGT+iSER, read, dd   64          560              0.999995
   STGT+iSER, read, xdd  65          556              0.999994
   STGT+iSER, write, dd  53          394              0.999971
   STGT+iSER, write, xdd 54          445              0.999959
   SCST+SRP, read, dd    39          657              0.999983
   SCST+SRP, read, xdd   41          668              0.999987
   SCST+SRP, write, dd   52          449              0.999962
   SCST+SRP, write, xdd  52          516              0.999977

Results that I did not expect:
* A block transfer size of 1 MB is not enough to measure the maximal
throughput. The maximal throughput is only reached at much higher
block sizes (about 10 MB for SCST + SRP and about 100 MB for STGT +
iSER).
* There is one case where dd and xdd results are inconsistent: when
reading via SCST + SRP and for block sizes of about 1 MB.
* For block sizes > 64 KB the measurements differ from the model. This
is probably because all initiator-target transfers happen in blocks of
32 KB or less.

For the details and some graphs, see also
http://software.qlayer.com/display/iSCSI/Measurements .

Bart Van Assche.
