From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: RE: [PATCH] modify the type of element of MessageUnit_B in arcmsr
Date: Wed, 05 Mar 2008 09:30:15 -0600
Message-ID: <1204731015.3047.16.camel@localhost.localdomain>
References: <000901c87e93$dec71360$8800a8c0@Nick>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:40837 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751952AbYCEPaU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Mar 2008 10:30:20 -0500
In-Reply-To: <000901c87e93$dec71360$8800a8c0@Nick>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nick.cheng@areca.com.tw
Cc: 'Andrew Morton' <akpm@linux-foundation.org>, linux-scsi@vger.kernel.org, randy.dunlap@oracle.com, 'Tomas Henzl' <thenzl@redhat.com>, viro@ftp.linux.org.uk

On Wed, 2008-03-05 at 15:38 +0800, nickcheng wrote:
> James,
> Thanks for your care.
> I agree with your point of labeling the registers with their correct width.
> But I did see an error.
> I have a script to load/unload driver modules for Type B Adapter repeatedly.
> While unloading the former driver modules, it pops up the message,
> iounmap: bad address ffffc2000021f000
> Call Trace:
>  [<ffffffff881ec2a2>] :arcmsr:arcmsr_free_ccb_pool+0x54/0x8f

Aha, that's because of this, isn't it:

                iounmap(reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);
                iounmap(reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);

You're doing pointer subtraction on a uint32_t *, so it's subtracting in
units of four bytes.  In many ways, converting the two pointers to void
* isn't much better, because gcc can sometimes complain it doesn't know
the width of a void * for pointer subtraction ... but mostly it just
treats it as byte width.  What you actually want, to get the error to go
away is:

                iounmap((u8 *)reg->drv2iop_doorbell_reg - ARCMSR_DRV2IOP_DOORBELL);
                iounmap((u8 *)reg->ioctl_wbuffer_reg - ARCMSR_IOCTL_WBUFFER);

Which should ensure the pointer arithmetic is done correctly.  Of
course, the ideal would be to get rid of the pointer subtraction ... it
always ends up causing subtle and hard to find problems.

James


