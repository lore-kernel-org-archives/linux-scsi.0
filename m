From: "Elliott, Robert (Server Storage)" <Elliott@hp.com>
Subject: RE: [PATCH 1/3] libata: Whitelist SSDs that are known to properly
 return zeroes after TRIM
Date: Fri, 5 Dec 2014 22:58:09 +0000
Message-ID: <94D0CD8314A33A4D9D801C0FE68B4029593FA1F3@G4W3202.americas.hpqcorp.net>
References: <1415336894-15327-1-git-send-email-martin.petersen@oracle.com>
 <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <1415336894-15327-2-git-send-email-martin.petersen@oracle.com>
Content-Language: en-US
Sender: linux-fsdevel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Paolo Bonzini <pbonzini@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>, "linux-fsdevel@vger.kernel.org" <linux-fsdevel@vger.kernel.org>, "neilb@suse.de" <neilb@suse.de>
List-Id: linux-scsi@vger.kernel.org



> -----Original Message-----
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Martin K. Petersen
> Sent: Thursday, 06 November, 2014 11:08 PM
> To: linux-scsi@vger.kernel.org; linux-ide@vger.kernel.org; linux-
> fsdevel@vger.kernel.org; neilb@suse.de
> Cc: Martin K. Petersen
> Subject: [PATCH 1/3] libata: Whitelist SSDs that are known to properly return
> zeroes after TRIM
> 
> As defined, the DRAT (Deterministic Read After Trim) and RZAT (Return
> Zero After Trim) flags in the ATA Command Set are unreliable in the
> sense that they only define what happens if the device successfully
> executed the DSM TRIM command. TRIM is only advisory, however, and the
> device is free to silently ignore all or parts of the request.
> 
> In practice this renders the DRAT and RZAT flags completely useless and
> because the results are unpredictable we decided to disable discard in
> MD for 3.18 to avoid the risk of data corruption.
> 
> Hardware vendors in the real world obviously need better guarantees than
> what the standards bodies provide. Unfortuntely those guarantees are
> encoded in product requirements documents rather than somewhere we can
> key off of them programatically. So we are compelled to disabling
> discard_zeroes_data for all devices unless we explicitly have data to
> support whitelisting them.
> 
> This patch whitelists SSDs from a few of the main vendors. None of the
> whitelists are based on written guarantees. They are purely based on
> empirical evidence collected from internal and external users that have
> tested or qualified these drives in RAID deployments.
> 
> The whitelist is only meant as a starting point and is by no means
> comprehensive:
> 
>    - All intel SSD models except for 510
>    - Micron M5*
>    - Samsung SSDs
>    - Seagate SSDs
> 

That description and Paolo's reply:
> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> owner@vger.kernel.org] On Behalf Of Paolo Bonzini
> Sent: Friday, 05 December, 2014 10:45 AM
...
> I have a Crucial_CT256MX1 (i.e. MX100) and it does reliably zero.

make me concerned about this whitelist approach.

I think you need a manufacturer assertion that this is indeed
the design intent; you cannot be certain based on observation
from outside.

Since the SCSI and ATA standards allow ignoring the hint, it 
might be honored most of the time, but ignored in some rare
cases (e.g., drive firmware has a malloc() failure that only
happens when the drive is handling an overtemperature
condition and six other problems at the same time).

Maybe there should be two levels:
* vendor asserts the drive is designed to always honor the hint
* community observes the drive always seems to honor the hint

and a sysfs flag for users to select the level at which 
they feel safe.

A user running 3 replicas of the data in different sites 
might be more trusting than a user for which this is the 
only copy of the data.

---
Rob Elliott    HP Server Storage




