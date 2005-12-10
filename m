From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: stgt a new version of iscsi target?
Date: Sat, 10 Dec 2005 18:32:59 +0300
Message-ID: <439AF52B.7060203@vlnb.net>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>	 <1134071268.3259.29.camel@mulgrave>  <4399A2D7.2040402@vlnb.net> <1134143298.3598.21.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <1134143298.3598.21.camel@mulgrave>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Fri, 2005-12-09 at 18:29 +0300, Vladislav Bolkhovitin wrote:
> 
>>>Additionally, it's perfectly possible for all of this to be done zero
>>>copy on the data.  A user space target mmaps the data on its storage
>>>device and then does a SG_IO type scatter gather user virtual region
>>>pass to the underlying target infrastructure.  We already have this
>>>demonstrated in the SG_IO path, someone just needs to come up with the
>>>correct implementation for a target path.
>>
>>I'm not completely understand how it will work. Consider, there are 
>>READ/WRITE commands with random data sizes arrive from an initiator. Are 
>>you going to do map/unmap for each command individually or alloc data 
>>buffers for commands from a premapped area and live with possible its 
>>fragmentation? If map/unmap individually, then I should say that those 
>>are very expensive operations.
> 
> You do it the same way an array does:  the model for SPI is read command
> phase, disconnect, process command (i.e. set up areas) reconnect for
> data transfer.
> 
> map/unmap are really only necessary if you're emulating the data store,
> but it's a fairly cheap operation on linux: it just causes the creation
> of a vm_area.  If it's a pass through, you can use SG_IO to pull it in
> and the SG_IO like output to shoot it out again, effectively using a
> piece of user memory as a zero copy buffer.
> 
> Fragmentation isn't an issue because the I/O goes via sg lists , all
> that's needed is a bunch of pages.

OK, I see what you meant, thanks.

> I do have to say that I consider operation in interrupt context (or even
> kernel context) to be a disadvantage.  Compared with the response times
> that most arrays have to SCSI commands, the kernel context switch time
> isn't that significant.

Are you sure that there are no now or will be available in the nearest 
feature such (eg iSCSI) SCSI arrays with response time/latency so small 
that having 5 (five) context switches or more per command, some of which 
include map/unmap operations, will not increase the latency too much? I 
mean, eg NFS server, which originally was user space daemon and many 
people didn't want it in the kernel. Eventually, it's in. I don't see 
any fundamental difference between NFS server and SCSI target server, 
especially considering that SCSI is synchroneous protocol, where the 
latency matters a lot, and usually there is some FS over exported SCSI 
device, which not always does bulk data operations.

Vlad


-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
