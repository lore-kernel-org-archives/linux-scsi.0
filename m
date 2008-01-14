From: Hans de Goede <j.w.r.degoede@hhs.nl>
Subject: Re: PATCH: usb-storage-psc1350-v4.patch (was Linux	scsi	/	usb-mass-storage
 and HP printer cardreader bug + fix)
Date: Mon, 14 Jan 2008 20:27:17 +0100
Message-ID: <478BB795.4040305@hhs.nl>
References: <47854051.1060307@hhs.nl> <4785F6CD.6050907@panasas.com>	 <4785F908.3080307@hhs.nl> <47860106.3090509@panasas.com>	 <4787CE08.5000304@hhs.nl> <1200303645.11301.15.camel@littletux>	 <478B2F90.7010105@hhs.nl>  <20080114160310.GH14375@one-eyed-alien.net>	 <1200328388.3159.20.camel@localhost.localdomain>  <478BABF0.1040403@hhs.nl> <1200337759.3159.58.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp6.versatel.nl ([62.58.50.97]:43394 "EHLO smtp6.versatel.nl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751290AbYANT0B (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 14 Jan 2008 14:26:01 -0500
In-Reply-To: <1200337759.3159.58.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Matthew Dharm <mdharm-scsi@one-eyed-alien.net>, Guillaume Bedot <littletux@zarb.org>, Boaz Harrosh <bharrosh@panasas.com>, USB Storage list <usb-storage@lists.one-eyed-alien.net>, fedora-kernel-list@redhat.com, USB development list <linux-usb-devel@lists.sourceforge.net>, David Brown <usb-storage2@davidb.org>, linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org

James Bottomley wrote:
>>> Plus what is the rq->nr_sectors > sdp->sector_size /
>>> 512 test supposed to be doing?  that being true is supposed to be a
>>> guarantee of the block layer (and if something goes wrong there's a
>>> check for this lower down).
>>>
>> It first is was just:
>> rq->nr_sectors > 1
>>
>> Then I changed it to also do the right thing for 1024 and larger sector disks. 
>> The whole purpose is to not read the last sector in a larger then one sector 
>> read, so the amount of sectors gets reduced by one if (block + rq->nr_sectors 
>> == get_capacity(disk)) but we do want still want to be able to read the last 
>> sector by itself, so we must not reduce the no sectors to be read by one if it 
>> is already one.
> 
> Yes, I know that.  What I mean is the block subsystem sends reads and
> writes down in increments of the sector size.  Checking if the current
> number of pending sectors is greater than the current block size is
> checking that guarantee.  The current code already has a check in it to
> see if this guarantee is observed ... you don't need to check it again.
> 

I'm not checking for the guarantee, I'm checking that the read > 1 
realsize_sector, before decrementing the number of _512_bytes_sectors by 
realsize_sector, this check must be there, as after reading all but the last 
sector, another request will be send with 1 realsize_sector size, for which
(block + rq->nr_sectors) == get_capacity(disk) will still hold true, in this 
case this_count must not be lowered, otherwise this_count will become 0 in this 
case and the last sector will never get read.

I hope that clarifies why that code is there, if not can you tell how you would 
want the code to look by just giving the full if statement as it should be, I 
think we are somehow misunderstanding each other.

Regards,

Hans
