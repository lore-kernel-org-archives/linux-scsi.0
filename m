From: Mukul Kotwani <mkotwani@yahoo.com>
Subject: Re: Performance
Date: Sat, 3 Aug 2002 13:03:28 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020803200328.70214.qmail@web14006.mail.yahoo.com>
References: <Pine.LNX.4.44.0208031845190.3186-100000@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.44.0208031845190.3186-100000@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: Simon Trimmer <simon@urbanmyth.org>
Cc: Craig Tierney <ctierney@hpti.com>, linux-scsi@vger.kernel.org

I do get about 23000 IOPs if I do sequential 512 byte
reads. And there, the block driver seems to be merging
requests into one big chunk. Thats the reason I tried
random reads instead of sequential , and I have the
QLA2340, which I guess is better than the 220x series.
And the sequential performance is not the correct
indicator because of the merging. Thats the reason I
tried random. Did u get 18k IOPS on random or
sequential? And I am using the latest JBODs from IBM,
15k RPM drives, so drives is not the reason got poor
performance.

The load generator is IOMeter/dynamo,which is pretty
much the standard in the Windows world. And the same
card with the same storage using Qlogic drivers gives
7000 IOPs on random reads to 13 LUns with 20
outstanding IOs on Windows, where Linux with the same
settings gives 250! And I did try to vary the
queuedepth of the drivers, and that does not seem to
make a difference. So its a straight comparison, same
card, same storage, same load generator.

Same for the 512k sequential reads. I see 64k requests
on the wire even though I claim to support 1024
sectors  and a scatter gather list of 248! 

Any pointers?

Thanks,
Mukul

 
--- Simon Trimmer <simon@urbanmyth.org> wrote:
> Those numbers do seem rather poor, using Matt
> Jacob's linux qlogic driver as
> an initiator I can easily get 18,000 ops/s on 230x
> series isp cards with a
> userspace app. I don't have recent figures for isp
> 220x cards but around 7k
> ops/s matches some old notes and given the right
> workload you can pretty much
> max out the channel.
> 
> Most of the block io experts have steered clear of
> the thread, this might be
> because a lot of performance measurement depends on
> the load generator, your
> scsi targets, the workload actually presented to
> them, whether OS readahead /
> request merging fires etc etc etc. It's not so clear
> cut and simple anymore
> for a straight answer!
> 
> Chances are the qlogic isp cards have more than
> enough grunt for most people.
> If not, they are probably doing something wrong or
> can afford multiport
> variants! :)
> 
> -Simon
> Simon Trimmer <simon@urbanmyth.org>
> 
> 
> On Fri, 2 Aug 2002, Mukul Kotwani wrote:
> > Running IOMeter against the Qlogic with IBM 15kRPM
> > JBODS, Im getting:
> >
> > 1) For 512 byte 100%random reads, I get *just* 260
> > IOPs per sec.On Windows with IOMeter, I get about
> 7000
> > foir the same config.
> >
> >
> > 2) For 512k 100%sequential reads, I see 30MB per
> sec.
> > Windows gives 85MB/sec
> >
> > I see the similar performance with my driver on
> Linux.
> > I dont know whyit is so low, cannot be that low as
> > compared to windws, a few MB/sec or a few hundred
> IOPs
> > per sec difference is OK, but this difference is
> TOO
> > huge. I tried a bunch of diff host template
> params,
> > but doesnt seem to make a difference.
> >
> > Has anyone dont any testing with IOMeter? Or is
> there
> > any other toold I can use to test IOPs/througput?
> >
> >
> > Thanks,
> > Mukul
> >
> > --- Craig Tierney <ctierney@hpti.com> wrote:
> > > For the Qlogic 2200F I am able to push 100 MB/s
> for
> > > reads and writes using multiple threads to a
> > > filesystem
> > > that is striped across mutliple host ports on
> the
> > > SAN.  Backend RAID is a
> > > Data Direct Networks SAN.  For a single thread
> to a
> > > ext3 filesystem
> > > and 2.4.18, I get about 70 MB/s for reads and
> > > writes.
> > >
> > > I have no Iops/sec numbers.
> > >
> > > Craig
> > >
> > >
> > > > Hello!
> > > > Does anyone have any performace numbers of a
> Qlogic
> > > > HBA? No of IOps/sec Max MBs /sec?
> > > >
> > > > Thanks!
> > > > M
> 
> 
> 


__________________________________________________
Do You Yahoo!?
Yahoo! Health - Feel better, live better
http://health.yahoo.com
