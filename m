From: Tejun Heo <htejun@gmail.com>
Subject: Re: [PATCH 3/3] faster workaround
Date: Tue, 23 Oct 2007 17:08:01 +0900
Message-ID: <471DABE1.40301@gmail.com>
References: <200710081709.18253.bs@q-leap.de>	<200710101112.20448.bs@q-leap.de>	<200710111409.56210.bs@q-leap.de>	<200710111433.23833.bs@q-leap.de>	<20071011142628.48272a4a@the-village.bc.nu>	<470E30F9.5060705@garzik.org> <20071011155024.46007973@the-village.bc.nu> <470E3A35.4000104@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <470E3A35.4000104@garzik.org>
Sender: linux-ide-owner@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Bernd Schubert <bs@q-leap.de>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Jeff Garzik wrote:
> Alan Cox wrote:
>>> 2) Once we identified, over time, the set of drives affected by this
>>> 3112 quirk (aka drives that didn't fully comply to SATA spec), the
>>> debugging of corruption cases largely shifted to the standard
>>> routine: update the BIOS, replace the
>>> cables/RAM/power/mainboard/slot/etc. to be certain of problem location.
>>
>> Except for the continued series of later SI + Nvidia chipset (mostly)
>> pattern which seems unanswered but also being later chips I assume
>> unrelated to this problem.
> 
> The SIL_FLAG_MOD15WRITE flag is set in sil_port_info[] is set according
> to the best info we have from SiI, which indicates that 3114 and 3512 do
> not have the same problem as the 3112.

I don't think this data corruption problem w/ sil3114 is related to
m15w.  m15w workaround slows down things quite a bit and is likely to
hide problems on PCI bus side.  There are reports of data corruption
with 3114 on nvidia (most common), via and now amd chipsets.  There's
one on intel too but IIRC wasn't too definite.

According to a user, freebsd didn't have data corruption problem on the
same hardware.  I copied PCI FIFO setup code (ours is broken BTW) but it
didn't fix the problem.

I'll try to reproduce the problem locally and hunt it down.

Thanks.

-- 
tejun
