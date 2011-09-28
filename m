From: "Eddie Wai" <eddie.wai@broadcom.com>
Subject: Re: bnx2i kthread madness
Date: Wed, 28 Sep 2011 10:29:41 -0700
Message-ID: <1317230982.3678.1000.camel@ltirv-waie-lx1>
References: <1317222318.24040.46.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mms3.broadcom.com ([216.31.210.19]:4842 "EHLO MMS3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753999Ab1I1R3y (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 28 Sep 2011 13:29:54 -0400
In-Reply-To: <1317222318.24040.46.camel@twins>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Peter Zijlstra <peterz@infradead.org>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <jejb@parisc-linux.org>


On Wed, 2011-09-28 at 08:05 -0700, Peter Zijlstra wrote:
> Hi,
> 
> I accidentally looked at all kthreads in existence on my system and
> found I had:
> 
> [iscsi_eh]
> [bnx2i_thread/0]
> [bnx2i_thread/1]
> [bnx2i_thread/2]
> [bnx2i_thread/3]
> [bnx2i_thread/4]
> [bnx2i_thread/5]
> [bnx2i_thread/6]
> [bnx2i_thread/7]
> [bnx2i_thread/8]
> [bnx2i_thread/9]
> [bnx2i_thread/10]
> [bnx2i_thread/11]
> [bnx2i_thread/12]
> [bnx2i_thread/13]
> [bnx2i_thread/14]
> [bnx2i_thread/15]
> [bnx2i_thread/16]
> [bnx2i_thread/17]
> [bnx2i_thread/18]
> [bnx2i_thread/19]
> [bnx2i_thread/20]
> [bnx2i_thread/21]
> [bnx2i_thread/22]
> [bnx2i_thread/23]
> 
> This left me wondering why, because I most certainly am not using iSCSI.
> I don't even know why its enabled in my .config (and it won't be long). 
> 
> Please fix this muck to not create useless threads.

Hello Peter,

Point noted.  In the current bnx2i driver, one kthread is created per
cpu core upon module init (and destroyed upon module exit).  The
kthreads are meant only to improve I/O performance when iSCSI is
employed.  Otherwise, I agree that they should not exist.

Eddie
> 
> 
> 


