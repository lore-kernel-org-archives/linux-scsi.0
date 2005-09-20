From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Wed, 21 Sep 2005 08:39:06 +1000
Message-ID: <43308F8A.1020808@torque.net>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>  <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>  <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local>  <1127061365.800.1.camel@max> <432D97F2.5040508@cs.wisc.edu>  <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local>  <432D9D53.3070706@cs.wisc.edu>  <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local>  <432F100D.7050007@cs.wisc.edu>  <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local> <1127247630.5589.30.camel@mulgrave> <Pine.LNX.4.61.0509202342590.4741@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:26581 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S1750700AbVITWkI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Sep 2005 18:40:08 -0400
In-Reply-To: <Pine.LNX.4.61.0509202342590.4741@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Mike Christie <michaelc@cs.wisc.edu>, SCSI Mailing List <linux-scsi@vger.kernel.org>

Kai Makisara wrote:
> On Tue, 20 Sep 2005, James Bottomley wrote:
> 
> 
>>On Tue, 2005-09-20 at 22:23 +0300, Kai Makisara wrote:
>>
>>>>Yeah I think this is due to the MAX_PHYS_SEGMENTS limit. The hw segments is
>>>>set by scsi_lib in scsi_alloc_queue and is the sg_tablesize value on the host.
>>>>Right now all I do is return a error when someone violates one of the limits,
>>>>but I think the right thing to do is have the ULDs take some of these values
>>>>into account when they build their lists. However if I do that we will not be
>>>>able to make large requests since the MAX_PHYS_SEGMENTS/SCSI_MAX_PHYS_SEGMENTS
>>>>will limit them. Umm let me rethink.
>>
>>There's already the code in SCSI to increase this to 256 (and
>>potentially beyond) if it becomes necessary.
>>
> 
> The current default segment size limit is 64 kB. This multiplied by 128 
> gives 8 MB. This should be large enough for all tape usage I know.
> 
> ...
> 
>>>What I don't quite like is that being able to do this requires setting 
>>>SCSI adapter parameters (use_clustering, max_sectors) to values that are 
>>>not used by most drivers today. Changing is in most cases trivial but this 
>>>has to be done. Otherwise the users needing large block sizes feel that 
>>>these enhancements are a regression.
>>
>>OK, but this is troubling either way:  Previously the LLD was simply
>>lying about its ability to support more sectors and clustering and you
>>called its bluff by sending such commands.  Now the bio layer is
>>actually enforcing these limits.
>>
> 
> I agree that it is good to have a common layer to enforce the limits. 
> Currently st has had to check the limits (it checks some and for others 
> relies on that all decent SCSI HBAs support what st tries to do). Based 
> on my earlier experience, I just doubt a little that the limits will be 
> updated but I hope to be proven wrong here :-)
> 
> 
>>The fix has got to be to update the LLDs so they're reporting their
>>capabilities truthfully.
>>
> 
> If this happens, it is very good. (I hope this includes the alignment 
> constraints, too :-)

... or perhaps the LLD could complain (rather than
the block layer) if it gets a scatter gather list
that it can't handle, since that may be dynamic
(e.g. depend on other requests the LLD is processing
at the time). Both the st and sg drivers could produce
a reasonable error to their application clients in this
case.

The SCSI device may also have data size limits
(e.g. the Block Limits VPD page in SBC-2). And that
VPD page makes an interesting distinction: between
maximum and optimum transfer size. Also these limits
apply to a disk's block commands (e.g. READ and WRITE)
but not to other data bearing commands (e.g. WRITE
BUFFER for uploading firmware).

Basically if an app is using st to talk to a SCSI
tape device, the kernel block layer and the LLD
should only be heard from if they can't do what was
requested. No second guessing please.

Doug Gilbert


