From: Tejun Heo <tj@kernel.org>
Subject: Re: MD/RAID time out writing superblock
Date: Mon, 14 Sep 2009 16:41:56 +0900
Message-ID: <4AADF3C4.5060004@kernel.org>
References: <92cb16daad8278b0aa98125b9e1d057a@localhost> <4A95573A.6090404@redhat.com> <1571f45804875514762f60c0097171e6@localhost> <d086b110526f8bac2f562850dfc70b03@localhost> <4A970154.2020507@redhat.com> <4A9B8583.9050601@kernel.org> <4A9BBC4A.6070708@redhat.com> <4A9BC023.10903@kernel.org> <20090907114442.GG18831@arachsys.com> <20090907115927.GU8710@arachsys.com> <20090909120218.GB21829@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20090909120218.GB21829@arachsys.com>
Sender: linux-ide-owner@vger.kernel.org
To: Chris Webb <chris@arachsys.com>
Cc: linux-scsi@vger.kernel.org, Ric Wheeler <rwheeler@redhat.com>, Andrei Tanas <andrei@tanas.ca>, NeilBrown <neilb@suse.de>, linux-kernel@vger.kernel.org, IDE/ATA development list <linux-ide@vger.kernel.org>, Jeff Garzik <jgarzik@redhat.com>, Mark Lord <mlord@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Hello, Chris.

Chris Webb wrote:
> Chris Webb <chris@arachsys.com> writes:
> 
>> I've also noticed that during this recovery, I'm seeing lots of timeouts but
>> they don't seem to interrupt the resync:
>>
>>   05:47:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>   05:47:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
>>   05:47:39         res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
>>   05:47:39 ata5.00: status: { DRDY }
>>   05:47:39 ata5: hard resetting link
>>   05:47:49 ata5: softreset failed (device not ready)
>>   05:47:49 ata5: hard resetting link
>>   05:47:49 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>   05:47:49 ata5.00: configured for UDMA/133
>>   05:47:49 ata5: EH complete
>>   
>>   08:17:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>   08:17:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
>>   08:17:39         res 40/00:00:35:83:f8/00:00:4d:00:00/40 Emask 0x4 (timeout)
>>   08:17:39 ata5.00: status: { DRDY }
>>   08:17:39 ata5: hard resetting link
>>   08:17:49 ata5: softreset failed (device not ready)
>>   08:17:49 ata5: hard resetting link
>>   08:17:49 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>   08:17:49 ata5.00: configured for UDMA/133
>>   08:17:49 ata5: EH complete
>>   
>>   10:22:39 ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>>   10:22:39 ata5.00: cmd ec/00:01:00:00:00/00:00:00:00:00/00 tag 0 pio 512 in
>>   10:22:39         res 40/00:00:00:4f:c2/00:00:00:00:00/40 Emask 0x4 (timeout)
>>   10:22:39 ata5.00: status: { DRDY }
>>   10:22:39 ata5: hard resetting link
>>   10:22:49 ata5: softreset failed (device not ready)
>>   10:22:49 ata5: hard resetting link
>>   10:22:50 ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>>   10:22:51 ata5.00: configured for UDMA/133
>>   10:22:51 ata5: EH complete
> 
> ... the difference being that a timeout which causes a super_written failure
> seems to return an I/O error whereas the others don't:

The aboves are IDENTIFY.  Who's issuing IDENTIFY regularly?  It isn't
from the regular IO paths or md.  It's probably being issued via SG_IO
from userland.  These failures don't affect normal operation.

>   ata5.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x6 frozen
>   ata5.00: cmd ea/00:00:00:00:00/00:00:00:00:00/a0 tag 0
>           res 40/00:00:00:00:00/00:00:00:00:00/a0 Emask 0x4 (timeout)
>   ata5.00: status: { DRDY }
>   ata5: hard resetting link
>   ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
>   ata5.00: configured for UDMA/133
>   ata5: EH complete
>   end_request: I/O error, dev sde, sector 1465147272
>   md: super_written gets error=-5, uptodate=0
>   raid10: Disk failure on sde3, disabling device.
> 
> I wonder what's different about these two timeouts such that one causes an I/O
> error and the other just causes a retry after reset? Presumably if the latter
> was also just a retry, everything would be (closer to being) fine.

Because this error is actually seen by the md layer and FLUSH in
general can't be retried cleanly.  On retrial, the drive goes on and
retry the sectors after the point of failure.  I'm not sure whether
FLUSH is actually failing here or it's a communication glitch.  At any
rate, if FLUSH is failing or timing out, the only right thing to do is
to kick it out of the array as keeping after retrying may lead to
silent data corruption.  Seriously, it's most likely a hardware
malfunction although I can't tell where the problem is with the given
data.  Get the hardware fixed.

Thanks.

-- 
tejun
