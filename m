From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: On patch "Let scsi_cmnd->cmnd use request->cmd buffer"
Date: Sun, 4 May 2008 15:01:19 +0200 (CEST)
Message-ID: <tkrat.4814bd8a1738df8c@s5r6.in-berlin.de>
References: <tkrat.5db1d90bfe8d480e@s5r6.in-berlin.de>
	<481DA8EF.3010405@panasas.com>
	<tkrat.46744b15c43493a1@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-bounces@lists.sourceforge.net>
In-Reply-To: <tkrat.46744b15c43493a1@s5r6.in-berlin.de>
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
Cc: linux-scsi@vger.kernel.org, Boaz Harrosh <bharrosh@panasas.com>
List-Id: linux-scsi@vger.kernel.org

On  4 May, Stefan Richter wrote:
> Boaz Harrosh wrote:
>> cmd->cmd_len is now guarantied to be set properly at all cases.
>> And some commands you want to support will not be set correctly
>> by COMMAND_SIZE().
...
> --- linux.orig/drivers/ieee1394/sbp2.c
> +++ linux/drivers/ieee1394/sbp2.c
...
>  	memset(orb->cdb, 0, 12);
> -	memcpy(orb->cdb, scsi_cmd, COMMAND_SIZE(*scsi_cmd));
> +	memcpy(orb->cdb, SCpnt->cmnd, SCpnt->cmd_len);
...

Wait a minute...

drivers/ieee1394/sbp2.[ch] and drivers/firewire/fw-sbp2.c hardwire the
maximum size of the command descriptor block (command_block field in the
command block ORB as per SBP-2 clause 5.1.2) to 12 bytes.

We need to use BLK_MAX_CDB there, don't we?

(Besides, we should keep an eye on unit_characteristics.ORB_size as per
SBP-2 clause 7.4.8, but that's another story.)
-- 
Stefan Richter
-=====-==--- -=-= --=--
http://arcgraph.de/sr/



-------------------------------------------------------------------------
This SF.net email is sponsored by the 2008 JavaOne(SM) Conference 
Don't miss this year's exciting event. There's still time to save $100. 
Use priority code J8TL2D2. 
http://ad.doubleclick.net/clk;198757673;13503038;p?http://java.sun.com/javaone
