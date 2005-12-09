From: Ming Zhang <mingz@ele.uri.edu>
Subject: Re: Ang: Re: [Stgt-devel] Re: stgt a
	new	version of iscsi target?
Date: Fri, 09 Dec 2005 10:00:11 -0500
Message-ID: <1134140412.12014.38.camel@localhost.localdomain>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>
	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>
	 <1134071268.3259.29.camel@mulgrave>  <439900A2.4040009@cs.wisc.edu>
Reply-To: mingz@ele.uri.edu
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <iscsitarget-devel-admin@lists.sourceforge.net>
In-Reply-To: <439900A2.4040009@cs.wisc.edu>
Sender: iscsitarget-devel-admin@lists.sourceforge.net
Errors-To: iscsitarget-devel-admin@lists.sourceforge.net
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Post: <mailto:iscsitarget-devel@lists.sourceforge.net>
List-Help: <mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/iscsitarget-devel>,
	<mailto:iscsitarget-devel-request@lists.sourceforge.net?subject=subscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=iscsitarget-devel>
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, Vladislav Bolkhovitin <vst@vlnb.net>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2005-12-08 at 21:57 -0600, Mike Christie wrote:
> James Bottomley wrote:
> > 
> > Additionally, it's perfectly possible for all of this to be done zero
> > copy on the data.  A user space target mmaps the data on its storage
> > device and then does a SG_IO type scatter gather user virtual region
> > pass to the underlying target infrastructure.  We already have this
> > demonstrated in the SG_IO path, someone just needs to come up with the
> > correct implementation for a target path.
> > 
> 
> I guess I am going to try to do some work in userspace so we can 
> benchmark things and see how much performance drops.
> 
> For your suggestion, are you referring to the sg.c mmap path? I was 
> thinking that maybe we could modify dm so it can do mmap like sg.c does. 
> The dm device would be the target device and would sit above the real 
> device or another MD/DM/Loop/ramdsik device or whatever so when 
> userspace decides to execute the command it would inform the dm device 
> and that kernel driver would just then send down the bios.
> 
> For something like qlogic or mpt would this basically work like the 
> following:
> 
> 1. dm mmap is called and our dm_target (dm drivers like dm-multipath or 
> dm-raid are called dm_targets) does like sg.c sg_mmap* and sg_vma* ops.
> 2. HW interrupt comes in and we allocate a scatterlist with pages from #1.
> 3. netlink (or whatever is the favorite interface) a message to 
> userpsace to tell it we have a command ready.
> 4. userspace decides if it is a read or write and if it is a read or 
> write then userspace tells the dm device to read/write some pages.
> 5. dm's bi_endio is called when io is finished so we netlink to 
> userspace and then userspaces netlinks back to the kernel and tells the 
> LLD like qlogic that some data and/or a responce or sense is ready for 
> it to transfer.

we can count how many system calls and context switches will occur for
each request here. will this be a source of high response time?

i guess we really need to have both a kernel and user space
implementation here to compare.




-------------------------------------------------------
This SF.net email is sponsored by: Splunk Inc. Do you grep through log files
for problems?  Stop!  Download the new AJAX search engine that makes
searching your log files as easy as surfing the  web.  DOWNLOAD SPLUNK!
http://ads.osdn.com/?ad_id=7637&alloc_id=16865&op=click
