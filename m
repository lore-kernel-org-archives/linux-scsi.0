From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [Scst-devel] Re: Ang: Re: [Stgt-devel] Re: [Iscsitarget-devel]
 stgt a new version of iscsi target?
Date: Fri, 09 Dec 2005 10:48:18 -0500
Message-ID: <1134143298.3598.21.camel@mulgrave>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>
	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>
	 <1134071268.3259.29.camel@mulgrave>  <4399A2D7.2040402@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <4399A2D7.2040402@vlnb.net>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: Mike Christie <michaelc@cs.wisc.edu>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Fri, 2005-12-09 at 18:29 +0300, Vladislav Bolkhovitin wrote:
> > Additionally, it's perfectly possible for all of this to be done zero
> > copy on the data.  A user space target mmaps the data on its storage
> > device and then does a SG_IO type scatter gather user virtual region
> > pass to the underlying target infrastructure.  We already have this
> > demonstrated in the SG_IO path, someone just needs to come up with the
> > correct implementation for a target path.
> 
> I'm not completely understand how it will work. Consider, there are 
> READ/WRITE commands with random data sizes arrive from an initiator. Are 
> you going to do map/unmap for each command individually or alloc data 
> buffers for commands from a premapped area and live with possible its 
> fragmentation? If map/unmap individually, then I should say that those 
> are very expensive operations.

You do it the same way an array does:  the model for SPI is read command
phase, disconnect, process command (i.e. set up areas) reconnect for
data transfer.

map/unmap are really only necessary if you're emulating the data store,
but it's a fairly cheap operation on linux: it just causes the creation
of a vm_area.  If it's a pass through, you can use SG_IO to pull it in
and the SG_IO like output to shoot it out again, effectively using a
piece of user memory as a zero copy buffer.

Fragmentation isn't an issue because the I/O goes via sg lists , all
that's needed is a bunch of pages.

James




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
