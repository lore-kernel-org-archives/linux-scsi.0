From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [PATCH 3/3] faster workaround
Date: Thu, 11 Oct 2007 10:59:01 -0400
Message-ID: <470E3A35.4000104@garzik.org>
References: <200710081709.18253.bs@q-leap.de>	<200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>	<200710111433.23833.bs@q-leap.de>	<20071011142628.48272a4a@the-village.bc.nu>	<470E30F9.5060705@garzik.org> <20071011155024.46007973@the-village.bc.nu>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20071011155024.46007973@the-village.bc.nu>
Sender: linux-ide-owner@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernd Schubert <bs@q-leap.de>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Alan Cox wrote:
>> The problem is that the 3112 generates Data FIS's of a size other than a 
>> multiple of 512 bytes.  Spec-legal, but exposed firmware bugs in many 
>> early SATA drives.  Early Seagate hard drives choked when the formula 
>> (sector%15)==1 was satisfied (or something along those lines).
> 
> And the 3114 is the same ?

3114 should not be affected by this problem (see below).

Most likely we are led down this road because the 'slow_down' module 
parameter has an excellent capacity for hiding all manner of problems.

As a tangent from this thread, this is why I was OK with adding the 
libata.dma even for SATA.  Sometimes knobs are found useful by users, 
though perhaps not its original intended use.  Sometimes masking a 
hardware problem can help you get through the rest of your day on hold 
with vendor support :)


>> 2) Once we identified, over time, the set of drives affected by this 
>> 3112 quirk (aka drives that didn't fully comply to SATA spec), the 
>> debugging of corruption cases largely shifted to the standard routine: 
>> update the BIOS, replace the cables/RAM/power/mainboard/slot/etc. to be 
>> certain of problem location.
> 
> Except for the continued series of later SI + Nvidia chipset (mostly)
> pattern which seems unanswered but also being later chips I assume
> unrelated to this problem.

The SIL_FLAG_MOD15WRITE flag is set in sil_port_info[] is set according 
to the best info we have from SiI, which indicates that 3114 and 3512 do 
not have the same problem as the 3112.

	Jeff


