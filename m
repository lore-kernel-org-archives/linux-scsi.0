From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] sbp2: better check of transfer direction (protects from
 panic or oops)
Date: Fri, 09 Dec 2005 20:01:11 +0100
Message-ID: <4399D477.8010504@s5r6.in-berlin.de>
References: <200512082144.jB8Li6Ul022982@einhorn.in-berlin.de> <20051209171922.GW19441@conscoop.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20051209171922.GW19441@conscoop.ottawa.on.ca>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Jody McIntyre <scjody@modernduck.com>
Cc: linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, Andrew de Quincey <adq@lidskialf.net>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

(Adding linux-scsi@vger.kernel.org again since there are more question 
marks than I thought...)

Jody McIntyre wrote:
> On Thu, Dec 08, 2005 at 10:42:02PM +0100, Stefan Richter wrote:
> 
>>sbp2: better check of transfer direction (protects from panic or oops)
>>
>>Move transfer direction check in sbp2_create_command_orb() up a bit to catch
>>more error cases.  Now we log an error note and proceed happily instead of a
>>kernel panic or oops.  Debugging and original variant of the patch by Andrew
>>de Quincey.
> 
> 
> Do you still want this if Jens' patch is applied to the SCSI subsystem?
> Extra checks are nice, but extra code is not :)  It's up to you...
> 
> Cheers,
> Jody

scsi_prep_fn() is not the only path which may set the transfer 
direction. Unless *all* paths are guaranteed to send us a proper 
direction, we still need the patch for sbp2_create_command_orb().

If all *known* paths are fixed, we could consider to override a bad 
transfer direction silently like e.g. usb_storage does. But we should 
not leave sbp2_create_command_orb() as fragile as it currently is.

I wonder if I know all paths where the direction could be set.

I also wonder if there could ever be something else execpt DMA_NONE, 
DMA_TO_DEVICE, or DMA_FROM_DEVICE being passed to sbp2. If it is 
guaranteed that scsi_cmnd.sc_data_direction is one of these three, we 
should remove ieee1394/sbp2.h::sbp2scsi_direction_table[].

> 
> 
> 
>>Problem became apparent when iPods were to be ejected:
>>http://marc.theaimsgroup.com/?l=linux1394-devel&m=113399994920181
>>http://marc.theaimsgroup.com/?l=linux1394-user&m=112152701817435
>>
>>Signed-off-by: Stefan Richter <stefanr@s5r6.in-berlin.de>
>>Cc: Ben Collins <bcollins@debian.org>
>>Cc: Andrew de Quincey <adq@lidskialf.net>
>>
>>---
>> drivers/ieee1394/sbp2.c |   24 ++++++++++++++----------
>> 1 files changed, 14 insertions(+), 10 deletions(-)
>>
>>--- linux/drivers/ieee1394.orig/sbp2.c	2005-11-24 23:10:21.000000000 +0100
>>+++ linux/drivers/ieee1394/sbp2.c	2005-12-08 22:06:49.000000000 +0100
>>@@ -1785,6 +1785,20 @@ static int sbp2_create_command_orb(struc
>> 	}
>> 
>> 	/*
>>+	 * Sanity check, in case we got a bogus direction from upper layers
>>+	 * or if sbp2scsi_direction_table is inadequate.
>>+	 */
>>+	if (orb_direction != ORB_DIRECTION_NO_DATA_TRANSFER &&
>>+	    scsi_request_bufflen == 0) {
>>+		SBP2_ERR("Transfer direction is \"%s\" but request buffer "
>>+			 "length is 0. This is a bug! Enforcing transfer "
>>+			 "direction DMA_NONE",
>>+			 orb_direction == ORB_DIRECTION_WRITE_TO_MEDIA ?
>>+			 "out" : "in");
>>+		orb_direction = ORB_DIRECTION_NO_DATA_TRANSFER;
>>+	}
>>+
>>+	/*
>> 	 * Set-up our pagetable stuff... unfortunately, this has become
>> 	 * messier than I'd like. Need to clean this up a bit.   ;-)
>> 	 */
>>@@ -1900,16 +1914,6 @@ static int sbp2_create_command_orb(struc
>> 			command_orb->misc |= ORB_SET_DATA_SIZE(scsi_request_bufflen);
>> 			command_orb->misc |= ORB_SET_DIRECTION(orb_direction);
>> 
>>-			/*
>>-			 * Sanity, in case our direction table is not
>>-			 * up-to-date
>>-			 */
>>-			if (!scsi_request_bufflen) {
>>-				command_orb->data_descriptor_hi = 0x0;
>>-				command_orb->data_descriptor_lo = 0x0;
>>-				command_orb->misc |= ORB_SET_DIRECTION(1);
>>-			}
>>-
>> 		} else {
>> 			/*
>> 			 * Need to turn this into page tables, since the
>>


-- 
Stefan Richter
-=====-=-=-= ==-- -=--=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
