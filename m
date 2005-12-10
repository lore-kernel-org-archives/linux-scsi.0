From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH] sbp2: better check of transfer direction (protects from panic or oops)
Date: Sat, 10 Dec 2005 18:21:36 +0000
Message-ID: <20051210182136.GB19765@infradead.org>
References: <200512082144.jB8Li6Ul022982@einhorn.in-berlin.de> <20051209171922.GW19441@conscoop.ottawa.on.ca> <4399D477.8010504@s5r6.in-berlin.de> <439AE0B5.4080808@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux1394-devel-admin@lists.sourceforge.net>
Content-Disposition: inline
In-Reply-To: <439AE0B5.4080808@s5r6.in-berlin.de>
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
Cc: Jody McIntyre <scjody@modernduck.com>, linux1394-devel@lists.sourceforge.net, Ben Collins <bcollins@debian.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Dec 10, 2005 at 03:05:41PM +0100, Stefan Richter wrote:
> I learned now of many more points which set the transfer direction. It 
> can apparently even come from userspace.

It can be specified with sg.

> >I also wonder if there could ever be something else execpt DMA_NONE, 
> >DMA_TO_DEVICE, or DMA_FROM_DEVICE being passed to sbp2. If it is 
> >guaranteed that scsi_cmnd.sc_data_direction is one of these three, we 
> >should remove ieee1394/sbp2.h::sbp2scsi_direction_table[].
> 
> AFAIU it is still possibly that DMA_BIDIRECTIONAL is passed down. 
> However I think now that we should delete sbp2scsi_direction_table 
> anyway and simply reject DMA_BIDIRECTIONAL. This is what a few other 
> SCSI low-level drivers do, and I think it is appropriate for a low-level 
> driver to fail such commands instead of converting them to a "known" 
> direction.

Yes, please.


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
