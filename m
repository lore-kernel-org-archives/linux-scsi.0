From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Sun, 10 Jul 2005 13:14:33 -0500
Message-ID: <1121019274.5078.22.camel@mulgrave>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de>
	 <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org>
	 <20050710033431.GB13883@havoc.gtf.org>
	 <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave>
	 <42D15C28.5030705@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <42D15C28.5030705@s5r6.in-berlin.de>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, Jeff Garzik <jgarzik@pobox.com>
List-Id: linux-scsi@vger.kernel.org

On Sun, 2005-07-10 at 19:34 +0200, Stefan Richter wrote:
> Jul 10 18:30:17 shuttle kernel:   Type:   Unknown                            ANSI SCSI revision: 02

Sorry, that's expected: I had a patch that would identify it as RBC, but
there was another different one from someone else, and neither got
applied.  Can you try this:

http://sourceforge.net/mailarchive/message.php?msg_id=11828307

> Then silence.

Hmm, it sounds like the driver's not binding.  If you do a

ls -l /sys/class/scsi_device/<device>/device/driver

On this, do you see anything (it should be a link to the bound driver).

If there's nothing there, it sounds like sd.c is missing the RBC
attachment code, which was this hunk of the patch:

  @@ -1533,7 +1551,7 @@
  	int error;
  
  	error = -ENODEV;
 -	if ((sdp->type != TYPE_DISK) && (sdp->type != TYPE_MOD))
 +	if (sdp->type != TYPE_DISK && sdp->type != TYPE_MOD && sdp->type != TYPE_RBC)
  		goto out;
  
  	SCSI_LOG_HLQUEUE(3, printk("sd_attach: scsi device: <%d,%d,%d,%d>\n", 

Could you check that that's in sd.c

Thanks,

James




-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
