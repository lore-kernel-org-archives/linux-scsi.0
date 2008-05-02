From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: HELP: Is writeq an atomic operation??
Date: Fri, 2 May 2008 17:31:50 -0600
Message-ID: <0631C836DBF79F42B5A60C8C8D4E822901047B52@NAMAIL2.ad.lsil.com>
References: <adaod7o2sxh.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:56562 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760103AbYEBXc0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 19:32:26 -0400
Content-class: urn:content-classes:message
In-Reply-To: <adaod7o2sxh.fsf@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <rdreier@cisco.com>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Friday, May 02, 2008 5:22 PM,  Roland Dreier wrote:
>  > Yeah,  I forgot I have a #ifndef writeq, then defined the 
> x86_64 version
>  > of that.   I've not tested on x86, so I'm not sure whether 
> it works.
>  > How are you handling writeq when its not defined, as the 
> case in x86?
> 
> Write two writel() inside a spinlock to avoid any transactions in the
> middle (the HW I'm dealing with can deal with two 32-bit transactions,
> as long as nothing comes in the middle).  If your hardware demands a
> single 64-bit transaction, you may be in trouble, because I'm not sure
> all 32-bit systems can generate such a PCIe transaction.
> 
> You can see include/linux/mlx4/doorbell.h for exactly what I did.
> 

Thanks for the code sample.   Yes, I need to send a single atomic 64-bit
transaction.

Eric
