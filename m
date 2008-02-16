From: FUJITA Tomonori <tomof@acm.org>
Subject: Re: ips.c broken since 2.6.23 on x86_64?
Date: Sat, 16 Feb 2008 09:41:48 +0900
Message-ID: <20080216094127E.tomof@acm.org>
References: <20080215011636.GA21124@tpepper-t42p.dolavim.us>
	<20080216010954M.tomof@acm.org>
	<20080215225057.GA3172@tpepper-t42p.dolavim.us>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mo11.iij4u.or.jp ([210.138.174.79]:53389 "EHLO mo11.iij4u.or.jp"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1762095AbYBPAuL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 15 Feb 2008 19:50:11 -0500
In-Reply-To: <20080215225057.GA3172@tpepper-t42p.dolavim.us>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: lnxninja@linux.vnet.ibm.com
Cc: tomof@acm.org, fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, Mark_Salyzyn@adaptec.comfujita.tomonori@lab.ntt.co.jp

On Fri, 15 Feb 2008 14:50:57 -0800
Tim Pepper <lnxninja@linux.vnet.ibm.com> wrote:

> On Sat 16 Feb at 01:09:43 +0900 tomof@acm.org said:
> > 
> > The first one is just reverting the data buffer accessors
> > conversion. It would be nice if we could just revert it but we
> > can't. These changes are necessary to compile the driver against post
> > 2.6.24.
> 
> Fujita-san,
> 
> Unfortunately (and not too surprisingly given what we've tried so far) with
> only the first of your series reverted the driver is working fine for me
> again.

Do you mean that you applied only the following two patches against
2.6.24, and then it doesn't work?

0001-ips-revert-the-changes-for-the-data-buffer-accessor.patch
0002-ips-kill-the-map_single-path-in-ips_scmd_buf_write.patch

If so, the second patch is broken. Did you saw BUG_ON message (I added
some BUG_ON to the patch)?


> I saw (eg: replies to http://lkml.org/lkml/2007/5/11/132) some possibly
> similar sounding issues with other drivers.  Could there be some memory
> uninitialised?  I did try changing all the ips.c kmalloc's to kzalloc's,
> but that didn't help.  Also that thread ties into pci gart.  The machines
> we've been using are liable to getting pci calgary although given my
> .config has:
>     CONFIG_GART_IOMMU=y
>     CONFIG_CALGARY_IOMMU=y
>     # CONFIG_CALGARY_IOMMU_ENABLED_BY_DEFAULT is not set
> and that when booting this mainline I don't see any Calgary related
> messages like I get from eg: Ubuntu's 2.6.22-14-server...I'm probably not
> actually running the calgary iommu code in these repros.

Yes, probabaly, your machine doesn't use any IOMMU hardware
(nommu_map_sg function was in your crash log).


> Anyway, I greatly appreciate your efforts so far in trying to find what
> could be wrong here!

Really sorry about the troubles and thanks for testing.
