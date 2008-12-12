From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Intel X25-M MLC SSD benchmarks - How can I be sure i am erased block aligned ?
Date: Thu, 11 Dec 2008 18:24:51 -0700
Message-ID: <20081212012451.GG26095@parisc-linux.org>
References: <5d96567b0812111240i60f70974y815a0775006da05f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5d96567b0812111240i60f70974y815a0775006da05f@mail.gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Raz <raziebe@gmail.com>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Dec 11, 2008 at 10:40:41PM +0200, Raz wrote:
> > ________________________________
> > From: Matthew Wilcox [mailto:matthew@wil.cx]
> > Sent: Thu 12/11/2008 5:44 AM
> > To: Raz Ben-Yehuda
> > Cc: linux-ide@vger.kernel.org; linux-scsi@vger.kernel.org
> > Subject: Re: Intel X25-M MLC SSD benchmarks
> >
> > On Thu, Dec 11, 2008 at 12:12:37AM +0200, Raz Ben-Yehuda wrote:
> >> I did not want to dive into details because it does not matter. Whether
> >> noop,deadline, deadline parameters...
> >> As for the controller I used 4 different controllers. Adaptec,AHCI and
> >> Intel as Integrated chips on the 1025W-UR supermicro motherboard, and a
> >> 4-th controller SuperMicro UIO Adaptec aac card.
> >> All gave same results for most dd writes commands.
> >> dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct , and many
> >> other variants such erase block size ( 128K ) , several erase block size
> >> and so on. Kernel is 2.6.18-8.el5.
> >
> >>>OK, I suspect you aren't giving the drive enough work to do for it to
> >>>perform at its best.  Try doing something like this:
> >
> >>>for i in $(seq 0 9); do \
> >  >>     dd if=/dev/zero of=/dev/sda bs=1M count=1000 oflag=direct \
> >  >>               seek=$(($i * 1000)) & \
> >>>done
> >
> did that. nothing. also, I would like to note that IO flow is quite
> weird.iostats reports 70GB/s in the first few seconds, and then it
> degrades to 20
>  MB/s and less. could it be that I am not erase-block aligment ?

That doesn't sound likely to me.  Erase block size isn't a huge issue
with these drives.  I've been trying to replicate your problem, but I'm
not having any luck; unfortunately I only have access to an X25-E drive
(not an X25-M) and I'm seeing 175-185MB/s when it's attached to an AHCI
controller, just with a single dd (I haven't even played with the
elevator).  I'm trying to get hold of an X25-M drive, but I don't know
when I'll receive one.

> how does SSD aligments interacts with a controller ?

Controllers can generally send down large enough IOs that it isn't a
problem.  And the Intel SSDs are smart enough that you shouldn't have to
align to erase block boundaries to make them go fast.

-- 
Matthew Wilcox				Intel Open Source Technology Centre
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
