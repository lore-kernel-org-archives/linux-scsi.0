From: Luben Tuikov <luben@splentec.com>
Subject: Re: slave_destroy called in scsi_scan.c:scsi_probe_and_add_lun()
Date: Tue, 17 Dec 2002 22:22:44 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3DFFEA04.2000803@splentec.com>
References: <170040000.1040080786@aslan.btc.adaptec.com> <20021217054102.GH13989@redhat.com> <797140000.1040156703@aslan.btc.adaptec.com> <20021217222459.GD28100@redhat.com> <20021217223341.A26529@infradead.org> <3DFFAB33.F174D272@digeo.com> <20021218010050.GF28100@redhat.com> <3DFFCDC0.C456BBDB@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3DFFCDC0.C456BBDB@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: Doug Ledford <dledford@redhat.com>, Christoph Hellwig <hch@infradead.org>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-scsi@vger.kernel.org

Andrew Morton wrote:
> 
[...]
> So I expect that in practice we would be unlikely to go beyond
> 128 requests per direction per queue.  But it should be an
> option, and it should work well.

I have an actual number: 512*. This is the number which /proc/slabinfo
tells me, and I suspect that the number of active (LLDD owner) commands
is a lot less than this.**

* I get this number when writing (I->T) just over 100 GiB file,
using a ``mini'' scsi-core which I wrote for a project at work.
And this, 512, number is the largest value I've seen so far,
i.e. the largest pool.

** I can actually obtain the exact (average) number of active commands
but I don't think that there's any need to. (QED)

But, yes, using the slab allocator (with the appropriate flags(!), etc...)
isn't a bad idea at all.

-- 
Luben


