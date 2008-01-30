From: Vu Pham <huongvp@yahoo.com>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Tue, 29 Jan 2008 17:15:09 -0800
Message-ID: <479FCF9D.3010503@yahoo.com>
References: <e2e108260801230622x42045058v926e84c60f2be7f4@mail.gmail.com>	<1201639331.3069.58.camel@localhost.localdomain>	<adazluoe2t3.fsf@cisco.com> <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp118.sbc.mail.sp1.yahoo.com ([69.147.64.91]:20778 "HELO
	smtp118.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1750758AbYA3BYg (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 29 Jan 2008 20:24:36 -0500
In-Reply-To: <20080130083239E.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: rdreier@cisco.com, vst@vlnb.net, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, James.Bottomley@HansenPartnership.com, scst-devel@lists.sourceforge.net, akpm@linux-foundation.org, torvalds@linux-foundation.org

FUJITA Tomonori wrote:
> On Tue, 29 Jan 2008 13:31:52 -0800
> Roland Dreier <rdreier@cisco.com> wrote:
> 
>>  > .                           .   STGT read     SCST read    .    STGT read      SCST read    .
>>  > .                           .  performance   performance   . performance    performance   .
>>  > .                           .  (0.5K, MB/s)  (0.5K, MB/s)  .   (1 MB, MB/s)   (1 MB, MB/s)  .
>>  > . iSER     (8 Gb/s network) .     250            N/A       .       360           N/A       .
>>  > . SRP      (8 Gb/s network) .     N/A            421       .       N/A           683       .
>>
>>  > On the comparable figures, which only seem to be IPoIB they're showing a
>>  > 13-18% variance, aren't they?  Which isn't an incredible difference.
>>
>> Maybe I'm all wet, but I think iSER vs. SRP should be roughly
>> comparable.  The exact formatting of various messages etc. is
>> different but the data path using RDMA is pretty much identical.  So
>> the big difference between STGT iSER and SCST SRP hints at some big
>> difference in the efficiency of the two implementations.
> 
> iSER has parameters to limit the maximum size of RDMA (it needs to
> repeat RDMA with a poor configuration)?
> 
> 
> Anyway, here's the results from Robin Humble:
> 
> iSER to 7G ramfs, x86_64, centos4.6, 2.6.22 kernels, git tgtd,
> initiator end booted with mem=512M, target with 8G ram
> 
>  direct i/o dd
>   write/read  800/751 MB/s
>     dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
>     dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct
> 

Both Robin (iser/stgt) and Bart (scst/srp) using ramfs

Robin's numbers come from DDR IB HCAs

Bart's numbers come from SDR IB HCAs:
Results with /dev/ram0 configured as backing store on the 
target (buffered I/O):
                     Read          Write             Read 
        Write
                   performance   performance 
performance   performance
                   (0.5K, MB/s)  (0.5K, MB/s)      (1 MB, 
MB/s)  (1 MB, MB/s)
STGT + iSER           250          48                 349 
        781
SCST + SRP            411          66                 659 
        746

Results with /dev/ram0 configured as backing store on the 
target (direct I/O):
                     Read          Write             Read 
        Write
                   performance   performance 
performance   performance
                   (0.5K, MB/s)  (0.5K, MB/s)      (1 MB, 
MB/s)  (1 MB, MB/s)
STGT + iSER             7.9         9.8               589 
        647
SCST + SRP             12.3         9.7               811 
        794

http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg13514.html

Here are my numbers with DDR IB HCAs, SCST/SRP 5G /dev/ram0 
block_io mode, RHEL5 2.6.18-8.el5

direct i/o dd
    write/read  1100/895 MB/s
      dd if=/dev/zero of=/dev/sdc bs=1M count=5000 oflag=direct
      dd of=/dev/null if=/dev/sdc bs=1M count=5000 iflag=direct

buffered i/o dd
    write/read  950/770 MB/s
      dd if=/dev/zero of=/dev/sdc bs=1M count=5000
      dd of=/dev/null if=/dev/sdc bs=1M count=5000

So when using DDR IB hcas:

               stgt/iser   scst/srp
direct I/O     800/751     1100/895
buffered I/O   1109/350    950/770


-vu
> http://www.mail-archive.com/linux-scsi@vger.kernel.org/msg13502.html
> 
> I think that STGT is pretty fast with the fast backing storage. 
> 
> 
> I don't think that there is the notable perfornace difference between
> kernel-space and user-space SRP (or ISER) implementations about moving
> data between hosts. IB is expected to enable user-space applications
> to move data between hosts quickly (if not, what can IB provide us?).
> 
> I think that the question is how fast user-space applications can do
> I/Os ccompared with I/Os in kernel space. STGT is eager for the advent
> of good asynchronous I/O and event notification interfances.
> 
> 
> One more possible optimization for STGT is zero-copy data
> transfer. STGT uses pre-registered buffers and move data between page
> cache and thsse buffers, and then does RDMA transfer. If we implement
> own caching mechanism to use pre-registered buffers directly with (AIO
> and O_DIRECT), then STGT can move data without data copies.
> 
> -------------------------------------------------------------------------
> This SF.net email is sponsored by: Microsoft
> Defy all challenges. Microsoft(R) Visual Studio 2008.
> http://clk.atdmt.com/MRT/go/vse0120000070mrt/direct/01/
> _______________________________________________
> Scst-devel mailing list
> Scst-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/scst-devel
> 

