From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 22:13:37 +0200
Message-ID: <42D18171.8050207@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>	 <20050710033431.GB13883@havoc.gtf.org>	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>	 <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <1121019274.5078.22.camel@mulgrave>
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
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Ben Collins <bcollins@debian.org>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Sun, 2005-07-10 at 19:34 +0200, Stefan Richter wrote:
>>Jul 10 18:30:17 shuttle kernel:   Type:   Unknown                            ANSI SCSI revision: 02
> 
> Sorry, that's expected: I had a patch that would identify it as RBC, but
> there was another different one from someone else, and neither got
> applied.  Can you try this:
> 
> http://sourceforge.net/mailarchive/message.php?msg_id=11828307

Yes, the type is logged as Direct-Access-RBC with that addition.

>>Then silence.
> 
> Hmm, it sounds like the driver's not binding.  If you do a
> 
> ls -l /sys/class/scsi_device/<device>/device/driver
> 
> On this, do you see anything (it should be a link to the bound driver).

"driver" does not exist. But the solution is too simple to be obvious:
# modprobe sd_mod
is followed by
Jul 10 21:45:14 shuttle kernel: SCSI device sda: 585940320 512-byte hdwr sectors (300001 MB)
Jul 10 21:45:14 shuttle kernel: SCSI device sda: drive cache: write back
Jul 10 21:45:14 shuttle kernel: SCSI device sda: 585940320 512-byte hdwr sectors (300001 MB)
Jul 10 21:45:14 shuttle kernel: SCSI device sda: drive cache: write back
Jul 10 21:45:14 shuttle kernel:  sda: sda1
Jul 10 21:45:14 shuttle kernel: Attached scsi disk sda at scsi1, channel 0, id 0, lun 0

So I added a mapping from type # 14 to TYPE_RBC and sd_mod to
/etc/hotplug/scsi.agent and it's back to normal. fdisk -l and hdparm -tT
play well.

And while they access the disk, no log notices come from sbp2 from the
points where conversions occured in the former code. (Only the initial
inquiry before sd_mod's attachment is logged as a former case for
conversion.)

> If there's nothing there, it sounds like sd.c is missing the RBC
> attachment code, which was this hunk of the patch:
> 
>   @@ -1533,7 +1551,7 @@
>   	int error;
>   
>   	error = -ENODEV;
>  -	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
>  +	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
>   		goto out;
>   
>   	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 
> 
> Could you check that that's in sd.c

sd.c contains the line with TYPE_RBC.

Alas, at least two problems remain:

  - Suddenly, the other problem reappeared. When I disconnect the disk,
    scsi_eh_0 stays there even though I am running the scsi_device_put
    modification in sbp2 (which helped before). This is accompanied by
    ieee1394's knodemgrd falling into D state.

  - As written in the other post, one of my 2.5" disks lets the system
    reboot shortly after the disk was attached. I have to find a way to
    identify the point of failure.
-- 
Stefan Richter
-=====-=-=-= -=== -=-=-
http://arcgraph.de/sr/



-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
