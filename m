From: Thomas Beutin <tyrone@laokoon.IN-Berlin.DE>
Subject: Re: AIC7902 lockups on Intel SMP (Re: HD somtimes hanging)
Date: Thu, 24 Jul 2003 17:44:51 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030724174451.B14635@laokoon.bug.net>
References: <20030724151233.E9280@laokoon.bug.net> <1059057411.6798.30.camel@carwash.duncangibb.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hirsch.in-berlin.de ([192.109.42.6]:27071 "EHLO
	hirsch.in-berlin.de") by vger.kernel.org with ESMTP id S271692AbTGXP35
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jul 2003 11:29:57 -0400
Content-Disposition: inline
In-Reply-To: <1059057411.6798.30.camel@carwash.duncangibb.com>; from duncangibb@uk.dmgworldmedia.com on Thu, Jul 24, 2003 at 03:36:51PM +0100
List-Id: linux-scsi@vger.kernel.org
To: Duncan Gibb <duncangibb@uk.dmgworldmedia.com>
Cc: linux-scsi@vger.kernel.org

Hi Duncan,

On Thu, Jul 24, 2003 at 03:36:51PM +0100, Duncan Gibb wrote:
[...]
> Just before I read your post, I built a 2.4.21-bk17 kernel in the hope
> that this would have been fixed some time in the last couple of months. 
> I'm not really in to running experimental kernels, so usually I won't
> stray further than the -ac series.

what ist the Your version of the aic79xx driver in the 2.4.21-bk17
kernel?

----- BEGIN ------
# cat /proc/scsi/aic79xx/0 
Adaptec AIC79xx driver version: 1.3.0
aic7902: Ultra320 Wide Channel A, SCSI Id=7, PCI 33 or 66Mhz, 512 SCBs

Serial EEPROM:
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 0x17c8 
0x08f4 0x0146 0x2807 0x0010 0xffff 0xffff 0xffff 0xffff 
0xffff 0xffff 0xffff 0xffff 0xffff 0xffff 0x0410 0xb2d7 

Channel A Target 0 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 160.000MB/s transfers (80.000MHz DT, 16bit)
	Curr: 160.000MB/s transfers (80.000MHz DT, 16bit)
	Transmission Errors 0
	Channel A Target 0 Lun 0 Settings
		Commands Queued 48814
		Commands Active 0
		Command Openings 1
		Max Tagged Openings 0
		Device Queue Frozen Count 0
Channel A Target 1 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Curr: 3.300MB/s transfers
	Transmission Errors 0
	Channel A Target 1 Lun 0 Settings
		Commands Queued 963579
		Commands Active 0
		Command Openings 32
		Max Tagged Openings 32
		Device Queue Frozen Count 0
Channel A Target 2 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Curr: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Transmission Errors 1
	Channel A Target 2 Lun 0 Settings
		Commands Queued 412536
		Commands Active 0
		Command Openings 32
		Max Tagged Openings 32
		Device Queue Frozen Count 0
Channel A Target 3 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 4 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 5 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 6 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
	Goal: 3.300MB/s transfers
	Curr: 3.300MB/s transfers
	Transmission Errors 0
	Channel A Target 6 Lun 0 Settings
		Commands Queued 1
		Commands Active 0
		Command Openings 1
		Max Tagged Openings 0
		Device Queue Frozen Count 0
Channel A Target 7 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 8 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 9 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 10 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 11 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 12 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 13 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 14 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
Channel A Target 15 Negotiation Settings
	User: 320.000MB/s transfers (160.000MHz DT|IU|QAS, 16bit)
----- END ------


(Especially the current transfer rate on Channel A Target 1 is
somewhat less than expected.)

Maybe there is a new driver by Justin Gibbs, but i didn't found
anything for the 2.4.21 kernel in
http://people.freebsd.org/~gibbs/linux/SRC/

Do You think the problem goes away by using a non SMP kernel?
(I have no problem to compile a new kernel, but the machine
is in a server room and i have to make an appointment with
the security guards to enter the room where the server is,
so i don't want to reboot this beast sitting 30 minutes
away from it...)

Greetings from Berlin,
-tb
-- 
Thomas Beutin                             tb@laokoon.IN-Berlin.DE
Beam me up, Scotty. There is no intelligent live down in Redmond.
