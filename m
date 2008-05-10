From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: Hack to fix not working spindown over Firewire
Date: Sun, 11 May 2008 00:53:05 +0200 (CEST)
Message-ID: <tkrat.8f92142276ccb4e5@s5r6.in-berlin.de>
References: <20080429232606.GA14261@dose.home.local>
	<481874BD.5010807@s5r6.in-berlin.de>
	<20080507180042.GA32629@dose.home.local>
	<tkrat.327b59f1366f8ea0@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
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
>    "sg_start --pc=3" stops the motor and "sg_start --pc=1 restarts it
> 4) peripheral device type claimed by the firmware
> 5) vendor and model of the enclosure
> 
> 
> 1)           2)     3)     4)    5)
> bridge       start  pc     PDT   enclosure
> --------------------------------------------------------------
...
> TSB42AA9     no     yes    SBC   DViCO MomoBay CX-1
> TSB42AA9A    yes    yes    RBC   DViCO MomoBay FX-3A

Correction:  While the FX-3A stops the motor if START STOP UNIT with an
equivalent to "sg_start --stop", it does not work correctly anymore
after it.  Certain commands after that will hang the firmware up;
notably those sent when sd_mod is probing the disk.  I.e. FX-3A fails
not exactly as CX-1, but similarly.
-- 
Stefan Richter
-=====-==--- -=-= -=-==
http://arcgraph.de/sr/


-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
