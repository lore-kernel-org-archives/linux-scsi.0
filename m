From: Douglas Gilbert <dougg@torque.net>
Subject: Re: aic94xx driver woes
Date: Sat, 31 Mar 2007 15:05:52 -0400
Message-ID: <460EB110.8060706@torque.net>
References: <460E90F3.9070601@torque.net> <460EA211.2060501@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:36810 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753202AbXCaTH7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 31 Mar 2007 15:07:59 -0400
In-Reply-To: <460EA211.2060501@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, James.Bottomley@SteelEye.com

Darrick J. Wong wrote:
> Douglas Gilbert wrote:
> 
>> So that is almost 12 months that I have been reporting
>> this driver as broken. Is it just me or my hardware?
> 
> I seem to recall you saying that the LSI Fusion card was plugged into
> the same expander as the 48300?  If so, does unplugging the Fusion card
> from the expander make it work?

Darrick,
There is a LSI Fusion card in the adjacent PCI-X
slot but it wasn't connected to anything so it
should not have been interfering.

I have another Fusion card in a second machine
which was off. I'll turn the second machine on
now to show the topology of my SAS domain.

Topology (seen from the second machine's MPT Fusion
phy which is both an initiator and a target):

# smp_discover -mb
Device <500605b0000033ef>, expander (only connected phys shown):
  phy   3:S:attached:[500605b00006f260:00  i(SSP+STP+SMP) t(SSP)]  3 Gbps
  phy   5:T:attached:[500605b000000af0:02 exp t(SMP)]  3 Gbps
  phy   6:T:attached:[50000d10002dc000:00  i(SSP+STP+SMP)]  3 Gbps
  phy   9:T:attached:[5000c500005208ee:01  t(SSP)]  3 Gbps
  phy  11:T:attached:[5000c50001b0213a:01  t(SSP)]  3 Gbps

# smp_discover -mb -s 0x500605b000000af0
Device <500605b000000af0>, expander (only connected phys shown):
  phy   2:S:attached:[500605b0000033ef:05 exp t(SMP)]  3 Gbps
  phy  10:T:attached:[5000c50001b02139:00  t(SSP)]  3 Gbps
  phy  11:T:attached:[5000c500005208ed:00  t(SSP)]  3 Gbps

James, note the SAS address of the first expander.

So with the second machine off, the expander entry
on 0x500605b0000033ef phy_id 3 is not there. [The
mainline aic94xx driver fails the same way with the
second machine off or on.]

>> aic94xx: Found sequencer Firmware version 1.1 (V17/10c6)
> 
> Have you tried the V30 sequencer?

No. But I note that Luben's driver is still using
V17/10c6 successfully (in lk 2.6.21-rc4).

How would I know that the official driver needs firmware,
where to get it and what was the recommended version
with a Kconfig entry like this:

config SCSI_AIC94XX
        tristate "Adaptec AIC94xx SAS/SATA support"
        depends on PCI
        select SCSI_SAS_LIBSAS
        select FW_LOADER
        help
                This driver supports Adaptec's SAS/SATA 3Gb/s 64 bit PCI-X
                AIC94xx chip based host adapters.

config AIC94XX_DEBUG
        bool "Compile in debug mode"
        default y
        depends on SCSI_AIC94XX
        help
                Compiles the aic94xx driver in debug mode.  In debug mode,
                the driver prints some messages to the console.

??

Is there some useful documentation somewhere else?
If so perhaps I link to it could be placed in the
Kconfig entry.


Doug Gilbert


