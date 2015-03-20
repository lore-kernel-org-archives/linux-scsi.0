From: Ewan Milne <emilne@redhat.com>
Subject: Re: iSCSI regression with linux 3.9 and 4.0
Date: Fri, 20 Mar 2015 11:46:05 -0400
Message-ID: <1426866365.19806.81.camel@localhost.localdomain>
References: <20150320135742.63df219b@leda.localdomain>
	 <1426859486.19806.30.camel@localhost.localdomain>
	 <20150320153104.086f3b46@leda.localdomain>
	 <1426863883.19806.65.camel@localhost.localdomain>
	 <20150320162441.684366b6@leda.localdomain>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:59073 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbbCTPqN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Mar 2015 11:46:13 -0400
In-Reply-To: <20150320162441.684366b6@leda.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christian Hesse <list@eworm.de>
Cc: linux-scsi@vger.kernel.org

On Fri, 2015-03-20 at 16:24 +0100, Christian Hesse wrote:
> Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 11:04:
> > On Fri, 2015-03-20 at 15:31 +0100, Christian Hesse wrote:
> > > Ewan Milne <emilne@redhat.com> on Fri, 2015/03/20 09:51:
> > > > On Fri, 2015-03-20 at 13:57 +0100, Christian Hesse wrote:
> > > > > Hello everybody!
> > > > > 
> > > > > I reported this issue at LKML [0] but received no answer. Hopefully
> > > > > linux-scsi is a better place...
> > > > > 
> > > > > Beginning with linux 3.19 I see an iSCSI regressen. This works
> > > > > perfectly with linux 3.18.x (tested with 3.18.6) and before. Effected
> > > > > kernels I tested are 3.19.0, 3.19.2 and 4.0rc4.r199.gb314aca.
> > > > > 
> > > > > The logs tell the story:
> > > > > 
> > > > > [snip log]
> > > > > 
> > > > > [0] https://lkml.org/lkml/2015/2/19/91
> > > > 
> > > > Sense key 0x5 ASC/ASCQ 0x24 0x00 is ILLEGAL REQUEST, INVALID FIELD IN
> > > > CDB.  The CDB was 2A 00 34 5B 07 FF 00 2F 88 00, which is a WRITE_10
> > > > to LBA 878381055 with a length of 12168 blocks (a little less than 6MB).
> > > > It looks like this is within the reported capacity of the device, and
> > > > there are no other bits set in the CDB.
> > > > 
> > > > Looks like you could get this error if RWWP (reject without write
> > > > protection) is set in the control mode page.  I don't see any messages
> > > > about the protection type, though.  What does sysfs report?
> > > 
> > > Is that what you are interested in?
> > > 
> > > # cat protection_mode protection_type 
> > > none
> > > 0
> > > 
> > > In case it matters: The iSCSI device is LUKS encrypted, that is why device
> > > mapper shows up.
> > > 
> > > I removed the discard option from filesystem's default mount option, but
> > > that brings no difference except the message is not printed.
> > 
> > It is most likely the device that is returning the error, there is a
> > place in the iSCSI Initiator that generates an ILLEGAL REQUEST sense,
> > but it is not the same ASC/ASCQ.
> > 
> > There was this change:
> > 
> > commit bcdb247c6b6a1f3e72b9b787b73f47dd509d17ec
> > Author: Martin K. Petersen <martin.petersen@oracle.com>
> > Date:   Tue Jun 3 18:45:51 2014 -0400
> > 
> >     sd: Limit transfer length
> >     
> >     Until now the per-command transfer length has exclusively been gated by
> >     the max_sectors parameter in the scsi_host template. Given that the size
> >     of this parameter has been bumped to an unsigned int we have to be
> >     careful not to exceed the target device's capabilities.
> >     
> >     If the if the device specifies a Maximum Transfer Length in the Block
> >     Limits VPD we'll use that value. Otherwise we'll use 0xffffffff for
> >     devices that have use_16_for_rw set and 0xffff for the rest. We then
> >     combine the chosen disk limit with max_sectors in the host template. The
> >     smaller of the two will be used to set the max_hw_sectors queue limit.
> >     
> >     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> >     Reviewed-by: Ewan D. Milne <emilne@redhat.com>
> >     Signed-off-by: Christoph Hellwig <hch@lst.de>
> > 
> > What is the value of max_sectors_kb and queue_max_sectors_kb in sysfs
> > for the device?  Is it different than what is reported on 3.18?
> 
> I found 'max_sectors_kb' which is inside in directory called 'queue'. Is that
> the value you asked for?
> 
> for 4.0 git:
> 
> # cat max_sectors_kb
> 32767

If you change max_sectors_kb to a lower value (e.g. 512) can you get the
device to work?

There is a max_hw_sectors_kb value but you can't change it.  Is it
32768 also for 4.0?

Your device reports a maximum transfer length of 2^32-1 blocks but
I suspect that it might not be actually able to do that.  I don't see
what else would be causing the error.  Maybe there is a transport
limitation that is getting in the way?

-Ewan

> 
> for 3.18.6:
> 
> # cat max_sectors_kb
> 512
> 
> > Does your target support the Block Limits VPD (page B0)?  (i.e. can
> > you run "sg_inq /dev/sda -p bl" from the sg3_utils package?)
> 
> This does not differ for different kernels. I think this is expected.
> 
> # sg_inq /dev/sdb -p bl
> VPD INQUIRY: Block limits page (SBC)
>   Maximum compare and write length: 1 blocks
>   Optimal transfer length granularity: 1 blocks
>   Maximum transfer length: 4294967295 blocks
>   Optimal transfer length: 4294967295 blocks
>   Maximum prefetch, xdread, xdwrite transfer length: 0 blocks
>   Maximum unmap LBA count: 8388607
>   Maximum unmap block descriptor count: 1
>   Optimal unmap granularity: 16383
>   Unmap granularity alignment valid: 0
>   Unmap granularity alignment: 0
>   Maximum write same length: 0xffffffff blocks
>   Maximum atomic transfer length: 0
>   Atomic alignment: 0
>   Atomic transfer length granularity: 0


