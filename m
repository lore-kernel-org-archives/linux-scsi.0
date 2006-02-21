From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Tue, 21 Feb 2006 20:56:08 +0100
Message-ID: <43FB7058.4040008@s5r6.in-berlin.de>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de> <20060220060845.GS27946@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <20060220060845.GS27946@ftp.linux.org.uk>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Al Viro <viro@ftp.linux.org.uk>
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

Al Viro wrote:
> OK, I think I've seen one that does it.  Behold the lossage:
> 
> 	* bugger does, indeed, report itself to be type 0
> 	* OK, says sd_read_cache_type().  Page 8 for you, then.
> 	* so called "SCSI device" spits out...
> <drumroll> RBC page 6.  Sans mode page headers.
> 
> So we see 0x86 0x0b where the data length should've been.  And bytes 3 and 2
> of device size where the block descriptors size should've been.  Since sd.c
> doesn't expect that level of idiocy (it should, but...) we adjust length
> down from ~34000 to 20 _and_ blindly add block descriptors size.  Or what
> we assume to be one.
> 
> Then we proceed to call scsi_mode_sense() with buffer created by kmalloc(512,
> GFP_DMA) and len... well, anywhere up to 64Kb.   One of the first things it
> does is memset(buffer, 0, len).

Thanks a lot for the investigation & explanation.

> That's an Initio bridge, BTW.  I suspect that the best we can do is to
> blacklist the little shit with "don't trust that one, it's really type 14".
> If it reacts to request for page 6 in a saner fashion, that is...

2.6.16-rc4-mm1's sbp2 already detects most of the Initio bridges and 
flags them with skip_ms_page_8. It does so based on the 
firmware_revision config ROM entry. This seems to catch most Initio 
bridges but there was at least one report of a different 
firmware_revision key value. However all of them feature "Initio" as 
vendor string. I suppose I should let sbp2_slave_configure check for 
this string in sdev->vendor and for sdev->type == TYPE_DISK, then bend 
sdev->type to TYPE_RBC. (Or set skip_ms_page_8; I will check how my disk 
behaves when forced to TYPE_RBC...)
-- 
Stefan Richter
-=====-=-==- --=- =-=-=
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
