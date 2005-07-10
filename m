From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 23:24:07 +0200
Message-ID: <42D191F7.8030506@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org> <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave> <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave> <42D18171.8050207@s5r6.in-berlin.de> <20050710202734.GI14956@phunnypharm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20050710202734.GI14956@phunnypharm.org>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net
Cc: Ben Collins <bcollins@debian.org>, James Bottomley <James.Bottomley@SteelEye.com>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

Ben Collins wrote:
> So you're saying that generally, everything is working ok now, atleast
> where RBC is concerned?

Yes and no. The command and response conversions as they are now done
by scsi seem to work.

After the FX-3A I tried also the IceCube 800 which works too. Could
not try the IceCube 400 yet.

> So the sd driver doesn't implement something for the driver model to
> autoload it when it picks up a known type, without /etc/hotplug/scsi.agent
> entries?

Seems to be the case. And the last official hotplug scripts release
maps type 14 to "enclosure" and to no module.

> On Sun, Jul 10, 2005 at 10:13:37PM +0200, Stefan Richter wrote:
...
>> - Suddenly, the other problem reappeared. When I disconnect the disk,
>>   scsi_eh_0 stays there even though I am running the scsi_device_put
>>   modification in sbp2 (which helped before). This is accompanied by
>>   ieee1394's knodemgrd falling into D state.

Knodemgrd hanging in D state has _sometimes_ happened with older kernels
too. At the moment it looks suspiciously like it always happens (with
the new sbp2 code) if I disconnect a TYPE_RBC device, but it might be
mere coincidence. Anyway, there is obviously still some deadlock in device
management somewhere. I will try to find out whether that can happen with
1394 hardware other than SBP-2 too but it will take some time.

>> - As written in the other post, one of my 2.5" disks lets the system
>>   reboot shortly after the disk was attached. I have to find a way to
>>   identify the point of failure.

I let syslogd log synchronously and added
	printk(KERN_NOTICE "--- sleep 1s ---\n");
	msleep_interruptible(1000);
right at the end of print_inquiry() in scsi_scan.c. Yields:

Jul 10 22:32:26 shuttle kernel: scsi0 : SCSI emulation for IEEE-1394 SBP-2 Devices
Jul 10 22:32:26 shuttle kernel: ieee1394: sbp2: Node 1-00:1023: Using 36byte inquiry workaround
Jul 10 22:32:27 shuttle kernel: ieee1394: sbp2: Logged into SBP-2 device
Jul 10 22:32:27 shuttle kernel:   Vendor: Initio    Model: IC25N080ATMR04-0  Rev: 2.18
Jul 10 22:32:27 shuttle kernel:   Type:   Direct-Access                      ANSI SCSI revision: 02
Jul 10 22:33:28 shuttle syslogd 1.4.1: restart.

Maybe the MODE_SENSE response needs to be mangled for this device as if
it was an RBC device. (But remember, my older 2.5" disk says it's
Direct-Access and it worked without MODE_SENSE response conversion.)

Can unexpected MODE_SENSE responses lead to a reboot?

Furthermore, I never noticed before that this disk also triggers the 36byte
inquiry workaround. I will try it without the workaround.
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
