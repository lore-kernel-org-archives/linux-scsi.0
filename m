From: Sergey Meirovich <rathamahata@gmail.com>
Subject: Re: Terrible performance of sequential O_DIRECT 4k writes in SAN
 environment. ~3 times slower then Solars 10 with the same HBA/Storage.
Date: Wed, 8 Jan 2014 15:57:57 +0200
Message-ID: <CA+QCeVSruYZCQOGapU_y613ucaptkzQN34X83DmYiPXTkWFVzg@mail.gmail.com>
References: <CA+QCeVQRrqx=CrxyuAe7k0e0y4Nqo7x_8jtkuD99VM8L9Dxp+g@mail.gmail.com>
 <20140106201032.GA13491@quack.suse.cz> <52CC6A53.9010508@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <52CC6A53.9010508@emulex.com>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: Jan Kara <jack@suse.cz>, linux-scsi <linux-scsi@vger.kernel.org>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, Gluk <git.user@gmail.com>
List-Id: linux-scsi@vger.kernel.org

Hi James,

On 7 January 2014 22:57, James Smart <james.smart@emulex.com> wrote:
> Sergey,
>
> The Thor chipset is a bit old - a 4Gig adapter.  Most of our performance
> improvements, including parallelization, have gone into the 8G and 16G
> adapters. But you still should have seen significantly beyond what you
> reported.

First of all - thanks a lot!

I took Thor because we have exactly the same Thors in some of our
Solaris servers. I've also tried 6 different qlogics (mostly 8G) and
fnic (10G) as well. Surprisingly enough Thor was the fastest one for
seqwr 4k. Though in most of the cases machines were from our different
DCs and hence each one connected to yet another storage.

>
> We did a sanity check some hardware we already had set up with a Thor
> adapter.  We saw 23555 iop/s and 92.1 MB/s without needing to do much, well
> beyond what you've reported, and still not up to what we know the card can
> do.  There are some inefficiencies from the linux kernel and some locking
> deltas between our solaris and linux drivers - but not enough to account for
> what you are seeing.
>
> I expect the Direct IO filesystem behavior is the root issue.

The strangest thing to me that this is the problem with sequential
write. For example the fnic one machine is zoned to EMC XtremIO and
had results: 14.43Mb/sec 3693.65 Requests/sec for sequential 4k. The
same fnic machine perfrormed rather impressive for random 4k
451.11Mb/sec 115485.02 Requests/sec
