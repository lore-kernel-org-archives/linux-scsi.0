From: Jan Kara <jack@suse.cz>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 21:55:24 +0100
Message-ID: <20140108205524.GA15313@quack.suse.cz>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz>
 <20140107155830.GA28395@infradead.org>
 <CA+QCeVRiwHU+C5utaLQXf_MpjoYMYEF4LKRyDPaqcd=H6n-RRw@mail.gmail.com>
 <20140108140307.GA588@infradead.org>
 <CA+QCeVQy08m9oBM1ULE_KAjd-36ao35p7-BCWErJewyr3m6NGg@mail.gmail.com>
 <20140108152610.GA5863@infradead.org>
 <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CA+QCeVRXAXAk2Zv2gtdvT+c80hbpcvezz_dvk9aUjwPbVp7pnQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Sergey Meirovich <rathamahata@gmail.com>
Cc: Christoph Hellwig <hch@infradead.org>, Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed 08-01-14 19:30:38, Sergey Meirovich wrote:
> On 8 January 2014 17:26, Christoph Hellwig <hch@infradead.org> wrote:
> >
> > On my laptop SSD I get the following results (sometimes up to 200MB/s,
> > sometimes down to 100MB/s, always in the 40k to 50k IOps range):
> >
> > time elapsed (sec.):    5
> > bandwidth (MiB/s):      160.00
> > IOps:                   40960.00
> 
> Any direct attached storage I've tried was faster for me as well,
> indeed. I have already posted IIRC
> "06:00.0 RAID bus controller: LSI Logic / Symbios Logic MegaRAID SAS
> 2208 [Thunderbolt] (rev 05)"   - 1Gb BBU RAM
> sysbench seqwr aio 4k:                     326.24Mb/sec 20879.56 Requests/sec
> 
> That is good that you mentioned SSD. I've tried fnic HBA zoned to EMC
> XtremIO (SSD only based storage)
>      14.43Mb/sec 3693.65 Requests/sec for sequential 4k.
  You see big degradation only in SAN environments because they have
generally higher latency to complete a single request. And given appending
direct IO is completely synchronous, the latency is the only thing that
really matters for performance. I've also seen my desktop-grade SATA drive
perform better than some enterprise grade SAN for this particular
workload...

> So far I've seen so massive degradation only in SAN environment. I
> started my investigation with RHEL6.5 kernel so below table is from it
> but the trend is the same as for mainline it seems.
> 
> Chunk size Bandwidth MiB/s
> ================================
> 64M                512
> 32M                510
> 16M                492
> 8M                  451
> 4M                  436
> 2M                  350
> 1M                  256
> 512K               191
> 256K               165
> 128K               142
> 64K                 101
> 32K                 65
> 16K                 39
> 8K                   20
> 4K                   11
  Yes, that's expected. The latency to complete a request consists of some
fixed overhead + time to write data. So for small request sizes the latency
is constant (corresponding to bandwidth growing linearly with the request
size) and for larger request sizes latency somewhat grows so bandwidth grows
slower and slower (as the time to write the data forms larger and larger
part of the total latency)...

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
