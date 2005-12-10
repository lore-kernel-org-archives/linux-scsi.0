From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: stgt a new version of iscsi target?
Date: Sat, 10 Dec 2005 12:07:33 -0600
Message-ID: <439B1965.90603@cs.wisc.edu>
References: <OF6932015B.01CF53D9-ONC12570D0.00462028@capvert.ins>	 <43972C2D.9060500@cs.wisc.edu>  <43987F75.2000301@vlnb.net>	 <1134071268.3259.29.camel@mulgrave>  <4399A2D7.2040402@vlnb.net> <1134143298.3598.21.camel@mulgrave> <439AF52B.7060203@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:59267 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1161008AbVLJSH5 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Dec 2005 13:07:57 -0500
In-Reply-To: <439AF52B.7060203@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, johan@capvert.se, iscsitarget-devel@lists.sourceforge.net, mingz@ele.uri.edu, stgt <stgt-devel@lists.berlios.de>, Robert Whitehead <WRWHITEHEAD@novell.com>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org, Christoph Hellwig <hch@infradead.org>

Vladislav Bolkhovitin wrote:
> James Bottomley wrote:
> 
>> On Fri, 2005-12-09 at 18:29 +0300, Vladislav Bolkhovitin wrote:
>>
>>>> Additionally, it's perfectly possible for all of this to be done zero
>>>> copy on the data.  A user space target mmaps the data on its storage
>>>> device and then does a SG_IO type scatter gather user virtual region
>>>> pass to the underlying target infrastructure.  We already have this
>>>> demonstrated in the SG_IO path, someone just needs to come up with the
>>>> correct implementation for a target path.
>>>
>>>
>>> I'm not completely understand how it will work. Consider, there are 
>>> READ/WRITE commands with random data sizes arrive from an initiator. 
>>> Are you going to do map/unmap for each command individually or alloc 
>>> data buffers for commands from a premapped area and live with 
>>> possible its fragmentation? If map/unmap individually, then I should 
>>> say that those are very expensive operations.
>>
>>
>> You do it the same way an array does:  the model for SPI is read command
>> phase, disconnect, process command (i.e. set up areas) reconnect for
>> data transfer.
>>
>> map/unmap are really only necessary if you're emulating the data store,
>> but it's a fairly cheap operation on linux: it just causes the creation
>> of a vm_area.  If it's a pass through, you can use SG_IO to pull it in
>> and the SG_IO like output to shoot it out again, effectively using a
>> piece of user memory as a zero copy buffer.
>>
>> Fragmentation isn't an issue because the I/O goes via sg lists , all
>> that's needed is a bunch of pages.
> 
> 
> OK, I see what you meant, thanks.
> 
>> I do have to say that I consider operation in interrupt context (or even
>> kernel context) to be a disadvantage.  Compared with the response times
>> that most arrays have to SCSI commands, the kernel context switch time
>> isn't that significant.
> 
> 
> Are you sure that there are no now or will be available in the nearest 
> feature such (eg iSCSI) SCSI arrays with response time/latency so small 
> that having 5 (five) context switches or more per command, some of which 
> include map/unmap operations, will not increase the latency too much? I 
> mean, eg NFS server, which originally was user space daemon and many 
> people didn't want it in the kernel. Eventually, it's in. I don't see 
> any fundamental difference between NFS server and SCSI target server, 

Isn't the reason a NFS server is still in the kernel is becuase some of 
the locking difficulties?
