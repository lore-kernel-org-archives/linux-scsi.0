From: Grant Grundler <grundler@google.com>
Subject: Re: [PATCH] libata: rewrite SCSI host scheme to be one per ATA host
Date: Thu, 23 Apr 2009 10:59:13 -0700
Message-ID: <da824cf30904231059v64328d47qa9e535ee194e65e@mail.gmail.com>
References: <20090422090929.GA14928@havoc.gtf.org>
	 <da824cf30904221208l42e41d38g5af52b1b3b5ea9a1@mail.gmail.com>
	 <49F04A66.4080303@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <49F04A66.4080303@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 23, 2009 at 4:00 AM, Jeff Garzik <jeff@garzik.org> wrote:
=2E..
> Sure there are compat issues, just like there are compat issues with =
the
> existing consensus goal of moving libata to the block layer -- part o=
f which
> implies that ATA disks would be served via a "native" block device ra=
ther
> than drivers/scsi/sd.c.
>
> So at least to me, it is axiomatic that these issues will be examined=
=2E

agree

>
> As to benefits, the phrase "more natural" means the code naturally al=
igns
> with existing object topologies (ata_host becomes analagous to Scsi_H=
ost),
> which always has a long list of technical benefits.
>
> - we get to remove all the ugly hacks currently in place that assume
> ata_port is _the_ first class object.
> - we get to remove all the workarounds where SCSI assumes it manipula=
tes all
> devices on a controller (not true in current libata)
> - SCSI (soon block) host-wide busy, block etc functionality now works=
 as
> expected
> - it makes the libata conversion from SCSI to block layer easier
> - it makes integration with SAS+SATA devices such as mvsas or ipr eas=
ier
> - the list goes on; that is just off the top of my head, before my mo=
rning
> Mountain Dew

Your initial list is good. In particular the issue around "SCSI Host-wi=
de busy"
working as expected. Of all the things listed, this is the only one tha=
t *I* can
clearly identify as a user visible functional change.

I'm not familiar with the the "workarounds where SCSI assumes it manipu=
lates
all devices on a controller" issue. The few SATA controllers I've looke=
d at can
deal with each port independently - e.g.  discovery and phy reset. Anyw=
ay, this
seems to be closely tied with "SCSI Host-wide Busy".

One reason I was thinking of NOT list above: "wide port" in SAS 2.0 con=
trollers.
aka "port aggregation". E.g. http://www.pmc-sierra.com/products/details=
/pm8005/

To change port aggregation on the fly requires the SCSI host controller=
 to be
manageable object. This should be a change in transport and not a chang=
e
in devices available....and there are some other problems with implemen=
ting
this but this is the main one I initially see.


> "more natural" also solves a longstanding user confusion/complaint ab=
out
> libata: =C2=A0users expected that libata would export each ATA "chann=
el" (bus) as
> a SCSI channel.

I haven't seen that complaint. And I'd be impressed by any "normal user=
s" that
know the difference between "host" and "channel". This sounds like a de=
veloper
complaint to me. AFAICT, users just accepted the initial mapping.

If the mapping is going to change, it makes sense to address
outstanding complaints.
But it'd be helpful to attribute the complaint/problem report to a real=
 person
and which HW they saw the issue on.

>> Mark already pointed out this might cause issues with Error Handling
>> (forcing a review of all that code). So before triggering other
>> developers (e.g. HW vendors) do that kind of work I'd like to hear
>> what the reward is going to be at the end.
>
> Are you aware that EH is already receiving a stream of updates, movin=
g it
> from SCSI to the block layer? =C2=A0This area has been in constant mo=
tion since,
> well, Tejun arrived and started improving things! =C2=A0:)

Yes, I have been following (and in generally very impressed with) Tejun=
's work.
I've read through about 1/2 of his patches. I clearly don't understand =
the
libata/SCSI subsystems as well he does.

But Tejun isn't the only person working on SATA drivers. AFAICT, the HW=
 vendors
are doing most of the work to support new SAS/SATA controllers. I'm
thinking of Marvell,
Intel, LSI, and Broadcom off the top of my head.   I'm sure there are o=
thers
(Silicon Image?). Having a moving target will just make it harder for t=
hem
to focus on their core business (building/supporting controllers)
instead of trying
to keep up with kernel.org. I think has historically been a bigger prob=
lem.

thanks,
grant
