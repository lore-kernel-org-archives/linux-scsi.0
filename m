From: Luben Tuikov <luben@splentec.com>
Subject: Re: [PATCH / RFC] scsi_error handler update. (1/4)
Date: Mon, 17 Feb 2003 12:28:32 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3E511BC0.6030509@splentec.com>
References: <3E495862.3050709@splentec.com>	<20030211212048.GC1114@beaverton.ibm.com> <3E49698D.3030402@splentec.com>	<20030211224119.A23149@infradead.org> <3E4AAA3F.8040002@splentec.com>	<20030212204634.A17425@infradead.org> <3E4AC0B5.9030208@splentec.com>	<20030213154748.A1965@infradead.org> <3E4BEA13.50402@splentec.com>	<20030213192440.A6660@redhat.com> <20030214165827.GA1165@beaverton.ibm.com>	<3E4D44EB.1090402@splentec.com> <1045258045.1726.31.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

James Bottomley wrote:
> On Fri, 2003-02-14 at 14:35, Luben Tuikov wrote:
> 
>>Points:
>>
>>1) If an object of type struct scsi_core exists, then this means
>>that SCSI Core is loaded, thus its representation in sysfs (and SCSI
>>Core itself, i.e. it represents itself... :-) ).
>>... this was the reason I wanted scsi_core in current-scsi-core,
>>alas, no one saw it...
> 
> 
> I don't see a benefit to multiple SCSI cores.  I can see people might want to
> replace the mid-layer entirely, but I can't see anyone wanting to run
> two mid-layers concurrently.

And I didn't say that there *was* a benefit to multiple SCSI cores.
I basically hinted at a design which simply *allows* multiple SCSI cores.
(Not the other way around.)

>>2) struct scsi_portal represents a service delivery subsystem type,
>>e.g. SPI, USB, FC, iSCSI, SAS, etc.  Nitty-gritty of the *actual*
>>delivery subsystem should have their own sub-sub structure, since
>>struct scsi_portal unifies them all for scsi_core and scsi_target's
>>sake.
> 
> 
> For this and all the rest, I suppose I'm showing my OO bias by saying I 
> do have a preference for encapsulation: That is hiding data structure
> unless you have a use for it.  So what I really want are arguments for why
> exposing these splits is useful.

Because a portal is something generic which allows access to the
target.  I.e. you don't need to know what the service delivery
subsystem is -- this is left to the LLDD an to the user.

struct scsi_portal *may** contain a union/pointer/whatever to a
struct which represents the service delivery subsystem (SPI, FC, etc),
should *it* export controls and the user wants to manipulate them.

* It, really doesn't have to.

-- 
Luben


