From: Pat LaVarre <p.lavarre@ieee.org>
Subject: Re: [PATCH 2.4] rewritable USB DVD-RAM vs. mode sense op choice
Date: Mon, 23 Aug 2004 10:46:21 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <F631591B-F523-11D8-BFA2-00039398BB5E@ieee.org>
References: <1092673789.4297.7.camel@patlinux.iomegacorp.com> <2004082315485
	0.GC2301@suse.de>
Mime-Version: 1.0 (Apple Message framework v619)
Content-Type: text/plain;
	charset=US-ASCII;
	format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from email-out2.iomega.com ([147.178.1.83]:3034 "EHLO
	email.iomega.com") by vger.kernel.org with ESMTP id S265978AbUHWQqR
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 23 Aug 2004 12:46:17 -0400
In-Reply-To: <20040823154850.GC2301@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: linux-scsi@vger.kernel.org

Jens A:

>> -	cmd[0] = MODE_SENSE;
>> +	memset(cmd, '\0', sizeof cmd);
>
> 	memset(cmd, 0, sizeof(cmd));
>
>> +	cmd[0] = MODE_SENSE_10;
>>  	cmd[1] = (scsi_CDs[i].device->scsi_level <= SCSI_2) ?
>>  		 ((scsi_CDs[i].device->lun << 5) & 0xe0) : 0;
>>  	cmd[2] = 0x2a;
>> -	cmd[4] = 128;
>> -	cmd[3] = cmd[5] = 0;
>> +	cmd[8] = 128;
>>  	rc = sr_do_ioctl(i, cmd, buffer, 128, 1, SCSI_DATA_READ, NULL);
>
> This gives me a bad vibe - I'm assuming your device is failing the
> 6-byte mode sense? This has to work with devices that don't support
> MODE_SENSE_10,

Clear design goal, thank you.

>  if you want it to work for you as well, then make the
> MODE_SENSE_10 a fall back when MODE_SENSE fails. You cannot rely on the
> change you made.

Clear instruction, thank you, I will do.

> the MODE_SENSE_10 a fall back when MODE_SENSE fails

I believe the specs on the web instead tell us to try MODE_SENSE_10 
first and then fall back to MODE_SENSE.  I hear you requesting the 
reverse, I will deliver what I hear you request.

> your device is failing ... ?

Help, I have more than one device.

My Iomega REV drive works here because that device accepts both ops, 
implementing the SFF/ ANSI MMC specification for op x5A and the 
incompatible ANSI SPC specification for op x1A.  To achieve 
compatibility, I believe every host should try both ops and every 
device should accept both ops.

I mean only to say that I see Linux 2.4 sr_mod mischaracterises the 
many DVD/ CD devices that do reject op x1A while accepting only op x5A 
MODE_SENSE_10.

I hesitate to accept the Linux name MODE_SENSE for the op x1A, because 
I do not find that claim well-founded in the web for PDT x05 = DVD/ CD 
= MMC.  I remember Mt Fuji in particular neglects to name op x1A.

> your device is failing ... ?

In this thread I meant to share the example of 2.4 sr_mod 
mischaracterising a USB DVD-RAM drive that rejects op x1A.

I hear of PATAPI DVD/CD devices that reject op x1A also.  I imagine 
ide-cd works only by trying op x5A, and not just x1A.  Want me to 
check?  I don't yet know how to trace in Linux the plain hex of the 
CDB's that ide-cd sends.

Pat LaVarre

