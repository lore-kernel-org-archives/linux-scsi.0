From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: changes to ieee1394/sbp2 outside of linux1394.org
Date: Mon, 11 Jul 2005 00:32:15 +0200
Message-ID: <42D1A1EF.1060006@s5r6.in-berlin.de>
References: <200507091237.j69Cbtrv003425@einhorn.in-berlin.de> <1120922306.5008.5.camel@mulgrave> <20050709230656.GS29099@phunnypharm.org> <20050710033431.GB13883@havoc.gtf.org> <20050710043645.GF2972@phunnypharm.org> <1121009100.5078.4.camel@mulgrave> <42D15C28.5030705@s5r6.in-berlin.de> <1121019274.5078.22.camel@mulgrave> <42D18171.8050207@s5r6.in-berlin.de> <20050710202734.GI14956@phunnypharm.org> <42D191F7.8030506@s5r6.in-berlin.de> <42D19BF8.9080507@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <42D19BF8.9080507@s5r6.in-berlin.de>
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

I wrote:
>>>> - As written in the other post, one of my 2.5" disks lets the system
>>>>   reboot shortly after the disk was attached.
>>
>> Maybe the MODE_SENSE response needs to be mangled for this device as if
>> it was an RBC device. (But remember, my older 2.5" disk says it's
>> Direct-Access and it worked without MODE_SENSE response conversion.)
> 
> No difference with sbp2's former MODE_SENSE conversion put back into
> sbp2_check_sbp2_response().

I tested again with all conversions reactivated in sbp2 and with
sdev->use_10_for_rw = 1, sdev->use_10_for_ms = 1 removed from
sbp2scsi_slave_configure again --- i.e. the old pseudo TYPE_DISK
mangling completely reinstated. This prevents the reboot and lets
me access the disk again.

That is, scsi's mid or high level definitely needs protection from
bogus TYPE_DISKs like this one --- in one way or another.
-- 
Stefan Richter
-=====-=-=-= -=== -=-==
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.Net email is sponsored by the 'Do More With Dual!' webinar happening
July 14 at 8am PDT/11am EDT. We invite you to explore the latest in dual
core and dual graphics technology at this free one hour event hosted by HP,
AMD, and NVIDIA.  To register visit http://www.hp.com/go/dualwebinar
