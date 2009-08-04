From: James Smart <James.Smart@Emulex.Com>
Subject: Re: FCP target reset
Date: Tue, 4 Aug 2009 12:03:57 -0400
Message-ID: <4A785BED.7070608@emulex.com>
References: <20090803162302.GA9872@schmichrtp.de.ibm.com> <4A774AC8.8080805@emulex.com> <4A7847E4.8090304@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:42776 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932649AbZHDQEF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2009 12:04:05 -0400
In-Reply-To: <4A7847E4.8090304@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "dgilbert@interlog.com" <dgilbert@interlog.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



Douglas Gilbert wrote:
> It looks like "target reset" is being phased out of SCSI
> terminology and being partially replaced by "hard reset".

Well, there's still an "I_T Nexus Reset" within the TMF area, which FCP-4 
provides no mapping for, but does define how to create a I_T Nexus loss event.

Headache is there's history... SPI BDRs did full target resets and killed i/o 
for all initiators. Target Reset and FCP-2 gave same kind of semantic. FCP-3 
and later tried to make initiators better citizens and isolate reset semantics 
if possible. Unfortunately, there's lots of users that equate FC to SCSI, SCSI 
to SPI, and assume SPI-like semantics. So changing things just to be 
standard-compliant always seems to upset someone (and it's usually the most 
critical someone).

> The third paragraph in the introduction of draft SAM-5
> (sam5r02.pdf section 1.1) states:
> 
> "The following concepts from previous versions of this
>   standard are made obsolete by this standard:
>     a)    support for the SPI-5 SCSI transport protocol;
>     b)    Contingent Allegiance;
>     c)    the TARGET RESET task management function;
>     d)    basic task management model;
>     e)    untagged tasks; and
>     f)    linked command function."
> 
> The TARGET RESET task management function last appeared
> in SAM-2 (ANSI INCITS 366-2003).
> 
> A "hard reset" is associated with a power cycle at an
> initiator, target or somewhere in between. There is no
> SCSI task management function to generate a hard reset.
> 
> Some transports have the ability to generate hard resets
> via non-SCSI protocols. For example in SAS a target can
> be reset with a SMP PHY CONTROL request to an expander
> phy attached to a phy on that target. SAS also has a lower
> order "link reset" which is invisible at the SCSI protocol
> level.
> 
> So is there a "hard reset" hook somewhere in FCP-3 ?

Only mapping in FCP-4 is Loop-based. Nothing for non-Loop.

All other events correspond to I_T Nexus Loss and center around login/logout.

For the target_reset entry point, I assume generating something for an I_T 
Nexus Loss should be fine. However, it goes against those SPI-isms mentioned 
above and can also be a real pain for the driver (discovery sucks). Given all 
the history, the OEM test scripts, and bars we've passed to date, I'm very 
hesitant to move away from Target Reset.

If we're really going to solve it, it probably requires more than the simple 
heirarchial device/tgt/bus/adapter reset escalation entry points (ex: does bus 
reset hard-reset all targets, or just terminate local I_T nexus related ios ?) 
- and another can of worms.


-- james s

