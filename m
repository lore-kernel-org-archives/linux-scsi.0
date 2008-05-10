From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
Date: Sat, 10 May 2008 17:31:53 +0200 (CEST)
Message-ID: <tkrat.635f52f7035be2bc@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
Content-Disposition: INLINE
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux1394-devel>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
Sender: linux1394-devel-bounces@lists.sourceforge.net
Errors-To: linux1394-devel-bounces@lists.sourceforge.net
To: linux1394-devel@lists.sourceforge.net
Cc: Tino Keitel <tino.keitel@gmx.de>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

I wrote:
> 1) FireWire to IDE or to SATA chipset
> 2) start bit is honored:
>    "sg_start --stop" stops the motor and "sg_start" restarts it
> 3) power condition field is honored:
>    "sg_start --pc=3D3" stops the motor and "sg_start --pc=3D1 restarts it
> 4) peripheral device type claimed by the firmware
> 5) vendor and model of the enclosure
> =

> =

> 1)           2)     3)     4)    5)
> bridge       start  pc     PDT   enclosure
> --------------------------------------------------------------
> INIC-2430    yes    yes    SBC   AVLAB 2.5" Drive Kit
> INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 1 HDD
> INIC-2430    yes    yes    SBC   IOI FWB-IDE01AB, 2 HDDs, JBOD
> =

> OXFW911      yes    yes    RBC   MacPower Icecube
> OXUF922      yes    yes    RBC   MacPower Icecube 800+
> OXFW912      yes    yes    RBC   MacPower Igloo
> OXFW912      yes    yes    RBC   VulcanTech DualDrive 2nd gen.
> OXUF924DSB   yes    yes    SBC   MacPower Taurus, 1 HDD
> OXUF924DSB   no     no     SBC   MacPower Taurus, 2 HDDs, JBOD
> =

> PL-3507      no     no     RBC   MacPower Prefect II =B9

  PL-3507      no     yes    RBC   Mapower MAP-KC21C1 =B2

> TSB42AA9     no     yes    SBC   DViCO MomoBay CX-1
> TSB42AA9A    yes    yes    RBC   DViCO MomoBay FX-3A

  EFI firmware no     no     RBC   Apple Mac mini x86 in target mode =B3


=B9) As mentioned, with firmware from MacPower.

=B2) Same firmware_revision as with Tino's disk, i.e. apparently firmware
   from Prolific.  Same findings as Tino's:
   "sg_start --stop" is accepted but does not stop the motor.
   "sg_start --pc=3D3" or "=3D2" stop the motor.
   "sg_start --pc=3D1" or a read command restarts the motor.
   "sg_start" does not restart the motor.

=B3) "sg_start --stop" is accepted but does not stop the motor.
   "sg_start --pc=3D3" or "=3D1" fails with "invalid field in cdb".
   This is of course against the spec, because RBC includes power
   condition.

Moreover, when OS X shuts down, it apparently sends START STOP UNIT
without power condition to FireWire disks.  Therefore we also should
rather _not_ use power condition per default.

I will send a patch which uses the power condition field only for
PL-3507 and DViCO CX-1.
-- =

Stefan Richter
-=3D=3D=3D=3D=3D-=3D=3D--- -=3D-=3D -=3D-=3D-
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference =

Don't miss this year's exciting event. There's still time to save $100. =

Use priority code J8TL2D2. =

http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/java=
one
