From: Roland Dreier <rdreier@cisco.com>
Subject: Re: HELP: Is writeq an atomic operation??
Date: Fri, 02 May 2008 16:21:46 -0700
Message-ID: <adaod7o2sxh.fsf@cisco.com>
References: <0631C836DBF79F42B5A60C8C8D4E822901047B4A@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-6.cisco.com ([171.71.176.117]:42902 "EHLO
	sj-iport-6.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937548AbYEBXVr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 May 2008 19:21:47 -0400
In-Reply-To: <0631C836DBF79F42B5A60C8C8D4E822901047B4A@NAMAIL2.ad.lsil.com>
	(Eric Moore's message of "Fri, 2 May 2008 17:13:08 -0600")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsi.com>
Cc: David Miller <davem@davemloft.net>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

 > Yeah,  I forgot I have a #ifndef writeq, then defined the x86_64 version
 > of that.   I've not tested on x86, so I'm not sure whether it works.
 > How are you handling writeq when its not defined, as the case in x86?

Write two writel() inside a spinlock to avoid any transactions in the
middle (the HW I'm dealing with can deal with two 32-bit transactions,
as long as nothing comes in the middle).  If your hardware demands a
single 64-bit transaction, you may be in trouble, because I'm not sure
all 32-bit systems can generate such a PCIe transaction.

You can see include/linux/mlx4/doorbell.h for exactly what I did.

 - R.
