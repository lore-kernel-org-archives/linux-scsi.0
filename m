From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: linux kernel panic when ejecting ieee1394 ipod
Date: Thu, 08 Dec 2005 03:44:42 +0100
Message-ID: <43979E1A.30801@s5r6.in-berlin.de>
References: <200512072358.15398.adq_dvb@lidskialf.net> <200512080119.48740.adq@lidskialf.net> <200512080159.10913.adq_dvb@lidskialf.net> <200512080209.17757.adq_dvb@lidskialf.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
In-Reply-To: <200512080209.17757.adq_dvb@lidskialf.net>
Sender: linux1394-devel-admin@lists.sourceforge.net
Errors-To: linux1394-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:linux1394-devel@lists.sourceforge.net>
List-Help: <mailto:linux1394-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux1394-devel>,
	<mailto:linux1394-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=linux1394-devel>
To: Andrew de Quincey <adq_dvb@lidskialf.net>
Cc: linux1394-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Andrew de Quincey wrote:
> On Thursday 08 December 2005 01:59, Andrew de Quincey wrote:
>>eject -s sends the following SCSI packet command to the sbp/ipod device:
>>
>>1b 00 00 00 02 00 with a direction of DMA_NONE
>>
>>eject -r results in the same via the CDROMEJECT translator in
>>scsi_cmd_ioctl(), but with a direction of DMA_TO_DEVICE. Thats what crashes
>>it - looks like its trying to set up a DMA transfer for 0 bytes or
>>something. I just added a really horrible hack to the start of
>>sbp2_send_command() to check, as follows:
>>
>>   if (*cmd == 0x1b) {
>>      SCpnt->sc_data_direction = 3;
>>   }
>>
>>Now, eject -r works perfectly. Though thats obviously not a good way to fix
>>it :)

That was a long time ago when sbp2 had to take care of data direction. I 
think we don't want to go back there. :-)

> Possible "proper" patch attached - no idea if its a good way to do this. 
> Basically if it gets a command with a scsi_request_bufflen of zero bytes, it 
> forces dma_dir to DMA_NONE.
> 
> The ipod works perfectly with this now.
...
[in sbp2_create_command_orb]
> +	/* check for duff DMA transfer direction with a zero length buffer */
> +	if (scsi_request_bufflen == 0)
> +		dma_dir = DMA_NONE;

What if you replace WRITE by READ in 
drivers/scsi/scsi_ioctl.c::scsi_cmd_ioctl()::case CDROMEJECT ?

And BTW, can/should this latter case block be converted to use 
scsi_execute() or scsi_execute_req()?
-- 
Stefan Richter
-=====-=-=-= ==-- -=---
http://arcgraph.de/sr/


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
