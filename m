From: Al Viro <viro@ftp.linux.org.uk>
Subject: Re: TYPE_RBC cache fixes (sbp2.c affected)
Date: Mon, 20 Feb 2006 06:08:45 +0000
Message-ID: <20060220060845.GS27946@ftp.linux.org.uk>
References: <20050516015955.GL1150@parcelfarce.linux.theplanet.co.uk> <43EA8128.9000205@s5r6.in-berlin.de> <20060208235415.GL27946@ftp.linux.org.uk> <43EDB35F.40709@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <43EDB35F.40709@s5r6.in-berlin.de>
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
Cc: linux-scsi@vger.kernel.org, linux1394-devel@lists.sourceforge.net
List-Id: linux-scsi@vger.kernel.org

On Sat, Feb 11, 2006 at 10:50:23AM +0100, Stefan Richter wrote:
> Yes, I will do so as soon I got spare time.
> MODE_SENSE_10 seemed to be the trigger, as mentioned in 
> http://marc.theaimsgroup.com/?l=linux-scsi&m=112128914912105 . Also note 
> that this device reports to implement Direct-Access, unlike most other 
> SBP-2 HDDs which pose as Direct-Access-RBC.

OK, I think I've seen one that does it.  Behold the lossage:

	* bugger does, indeed, report itself to be type 0
	* OK, says sd_read_cache_type().  Page 8 for you, then.
	* so called "SCSI device" spits out...
<drumroll> RBC page 6.  Sans mode page headers.

So we see 0x86 0x0b where the data length should've been.  And bytes 3 and 2
of device size where the block descriptors size should've been.  Since sd.c
doesn't expect that level of idiocy (it should, but...) we adjust length
down from ~34000 to 20 _and_ blindly add block descriptors size.  Or what
we assume to be one.

Then we proceed to call scsi_mode_sense() with buffer created by kmalloc(512,
GFP_DMA) and len... well, anywhere up to 64Kb.   One of the first things it
does is memset(buffer, 0, len).


That's an Initio bridge, BTW.  I suspect that the best we can do is to
blacklist the little shit with "don't trust that one, it's really type 14".
If it reacts to request for page 6 in a saner fashion, that is...


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://sel.as-us.falkag.net/sel?cmd=lnk&kid=103432&bid=230486&dat=121642
