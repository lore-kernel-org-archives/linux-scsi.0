From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: PATCH for disabling write cache on SATA drives
Date: Tue, 29 Jun 2004 23:03:16 -0400
Sender: linux-ide-owner@vger.kernel.org
Message-ID: <40E22D74.4000600@pobox.com>
References: <1F6D1D1660975A4887628A011443A1BC07734C05@uswaumsx13medge.med.ge.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1F6D1D1660975A4887628A011443A1BC07734C05@uswaumsx13medge.med.ge.com>
To: "Edwards, Scott (MED, Kelly IT Resouces)" <James.Edwards@med.ge.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org, "'sedwards@xmission.com'" <sedwards@xmission.com>
List-Id: linux-scsi@vger.kernel.org

Edwards, Scott (MED, Kelly IT Resouces) wrote:
> On Monday, June 28, 2004 at 6:12 PM, Jeff Garzik wrote:
> 
> 
>>On Fri, Jun 25, 2004 at 06:21:24PM -0500, Edwards, Scott (MED, Kelly
> 
> IT Resouces) wrote:
> 
>>>I don't know if this is useful for anyone or if anyone even cares,
> 
> but just
> 
>>>in case someone does, this is the patch I made to disable the write
> 
> cache on
> 
>>>the Serial ATA drives.  It doesn't make the write cache controllable
> 
> from
> 
>>>the user level, it just ALWAYS disables it.  (I tried to make one
> 
> that could
> 
>>>be sent via an ioctl, but there were far too many things that I
> 
> didn't
> 
>>>understand and it didn't work.)  Since I have never done this before
> 
> I don't
> 
>>>know if there is some protocol that I missed, if so I'm sorry.  If
> 
> there are
> 
>>>glaring stupid mistakes (very likely) please let me know.
>>
>>In principle your patch is fine, but I would really like to find a
>>better way of allowing the user to do this.
>>
>>My immediate guess would be to use the standard SCSI method of
> 
> disabling
> 
>>write cache, and have that initiate wbcache disable on the SATA side.
>>
>>Long term, this would be augmented by an "ATA passthru" opcode or
> 
> ioctl.
> 
>>	Jeff
> 
> 
> I first tried to make a real scsi ioctl command in libata-scsi.c, so I
> could just use the scsiinfo program to disable the write cache.  I  made
> a xlat_mode_select command but it didn't work and management didn't want
> me
> spending more time trying to figure it out.  And really for it to work
> correctly there would have to be a xlat_mode_sense because now it is
> just 
> simulated (in ata_scsi_simulate).
> 
> I'm willing to work on it on my own time as soon as I get a SATA drive, 
> if someone would be willing to advise me on how to send the ATA commands
> to the drive (I think this is where it failed before).

Basically, it involves the translation of MODE SELECT, something I've 
been meaning to add, but is low priority.  If you wanted to work on 
that, that would be quite useful.

The following is a proposal for translating ATA to SCSI:
http://www.t10.org/ftp/t10/document.04/04-196r0.pdf

In that proposal, it describes the use of MODE SELECT Caching Mode Page 
(8h).

Note that, in addition to actually issuing the SET FEATURES command, to 
disable/enable writeback caching, you must update libata's internal copy 
of the IDENTIFY DEVICE page.  This involves either re-issuing IDENTIFY 
DEVICE (difficult), or simply updating the 'enabled' bit in the 
internally cached data (easy).

	Jeff


