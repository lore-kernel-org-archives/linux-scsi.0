From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: [Scst-devel] [Iscsitarget-devel] ISCSI-SCST	performance (with
 also IET and STGT data)
Date: Thu, 02 Apr 2009 11:38:51 +0400
Message-ID: <49D46B8B.5000708@vlnb.net>
References: <49D10256.8030307@vlnb.net>	<e2e108260903301106y2b750c23kfab978567f3de3a0@mail.gmail.com>	<49D11096.3070804@vlnb.net>	<e2e108260903301153x38e86097vd29c47507da2879f@mail.gmail.com>	<49D254E4.8050806@vlnb.net>	<E2BB8074E5500C42984D980D4BD78EF9029E3D0B@MFG-NYC-EXCH2.mfg.prv>	<e2e108260903312329u118a54bfn3107fdca4b3e2b1d@mail.gmail.com>	<FA7F6940-CD5C-4460-9777-2F7AE3657B8E@gmail.com> <1238617423.3318.82.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from moutng.kundenserver.de ([212.227.126.188]:58890 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756500AbZDBHjB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Apr 2009 03:39:01 -0400
In-Reply-To: <1238617423.3318.82.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Ross Walker <rswwalker@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, iSCSI Enterprise Target Developer List <iscsitarget-devel@lists.sourceforge.net>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Ross S. W. Walker" <RWalker@medallion.com>, scst-devel <scst-devel@lists.sourceforge.net>, "stgt@vger.kernel.org" <stgt@vger.kernel.org>, Bart Van Assche <bart.vanassche@gmail.com>

James Bottomley, on 04/02/2009 12:23 AM wrote:
> On Wed, 2009-04-01 at 08:20 -0400, Ross Walker wrote:
>> On Apr 1, 2009, at 2:29 AM, Bart Van Assche <bart.vanassche@gmail.com>  
>> wrote:
>>
>>> On Tue, Mar 31, 2009 at 8:43 PM, Ross S. W. Walker
>>> <RWalker@medallion.com> wrote:
>>>> IET just needs to fix how it does it workload with CFQ which
>>>> somehow SCST has overcome. Of course SCST tweaks the Linux kernel to
>>>> gain some extra speed.
>>> I'm not familiar with the implementation details of CFQ, but I know
>>> that one of the changes between SCST 1.0.0 and SCST 1.0.1 is that the
>>> default number of kernel threads of the scst_vdisk kernel module has
>>> been increased to 5. Could this explain the performance difference
>>> between SCST and IET for FILEIO and BLOCKIO ?
>> Thank for the update. IET has used 8 threads per target for ages now,  
>> I don't think it is that.
>>
>> It may be how the I/O threads are forked in SCST that causes them to  
>> be in the same I/O context with each other.
>>
>> I'm pretty sure implementing a version of the patch that was used for  
>> the dump command (found on the LKML) will fix this.
>>
>> But thanks goes to Vlad for pointing this dificiency out so we can fix  
>> it to help make IET even better.
> 
> SCST explicitly fiddles with the io context to get this to happen.  It
> has a hack to block to export alloc_io_context:
> 
> http://marc.info/?t=122893564800003

Correct, although I wouldn't call it "fiddle", rather "grouping" ;)

But that's not the only reason for good performance. Particularly, it 
can't explain Bart's tmpfs results from the previous message, where the 
majority of I/O done to/from RAM without any I/O scheduler involved. (Or 
does I/O scheduler also involved with tmpfs?) Bart has 4GB RAM, if I 
remember correctly, i.e. the test data set was 25% of RAM.

Thanks,
Vlad

