From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: USB/SCSI slab corruption.
Date: Thu, 12 Jan 2006 19:30:32 -0600
Message-ID: <1137115833.3530.46.camel@mulgrave>
References: <20060112233606.GP19827@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:22452 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S964782AbWAMBal (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Jan 2006 20:30:41 -0500
In-Reply-To: <20060112233606.GP19827@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Jones <davej@redhat.com>
Cc: linux-scsi@vger.kernel.org, linux-usb-devel@lists.sourceforge.net

On Thu, 2006-01-12 at 18:36 -0500, Dave Jones wrote:
>  > SCSI device sdb: 321672960 512-byte hdwr sectors (164697 MB) 
>  > slab error in cache_free_debugcheck(): cache `sgpool-8': double free, or 
>  > memory outside object was overwritten 
>  >  [<c0153593>] cache_free_debugcheck+0x1ab/0x22f     [<c014d3c2>] 
>  > mempool_free+0x3a/0x73 
>  >  [<c01540e2>] kmem_cache_free+0x2a/0x69     [<c014d3c2>] 
>  > mempool_free+0x3a/0x73 
>  >  [<f8862c8b>] scsi_io_completion+0x207/0x4d2 [scsi_mod]     [<f885dcad>] 

This is a classic symptom of done() being called twice on the same
command.  Best guess would be a driver issue.

James


