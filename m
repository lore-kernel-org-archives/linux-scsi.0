From: Dave Jones <davej@redhat.com>
Subject: Re: two leaks in scsi_alloc_sdev failure paths
Date: Thu, 9 Mar 2006 10:21:27 -0500
Message-ID: <20060309152126.GA30809@redhat.com>
References: <20060309033620.GA19906@redhat.com> <441044B6.3000802@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:46290 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S1751781AbWCIPVl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2006 10:21:41 -0500
Content-Disposition: inline
In-Reply-To: <441044B6.3000802@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Thu, Mar 09, 2006 at 09:07:34AM -0600, Brian King wrote:
 > Dave Jones wrote:
 > >If the scsi_alloc_queue or the slave_alloc calls in scsi_alloc_device fail,
 > >we forget to release the locally allocated sdev on the failure path.
 > 
 > Actually, I think the slave_alloc failure path works today, and this patch
 > breaks it. Today, in the slave_alloc failure path, the release function 
 > called
 > as a result of the put_device in out_device_destroy should end up freeing 
 > the sdev.

Correct, thanks.

 > Rather than this change, I think just adding a kfree(sdev) before the goto 
 > out would accomplish what you want.

looks a lot simpler.

Thanks.

		Dave



If the scsi_alloc_queue or the slave_alloc calls in scsi_alloc_device fail,
we forget to release the locally allocated sdev on the failure path.

Coverity #609
Signed-off-by: Dave Jones <davej@redhat.com>

--- linux-2.6/drivers/scsi/scsi_scan.c~	2006-03-09 10:19:51.000000000 -0500
+++ linux-2.6/drivers/scsi/scsi_scan.c	2006-03-09 10:20:20.000000000 -0500
@@ -252,6 +252,7 @@ static struct scsi_device *scsi_alloc_sd
 		/* release fn is set up in scsi_sysfs_device_initialise, so
 		 * have to free and put manually here */
 		put_device(&starget->dev);
+		kfree(sdev);
 		goto out;
 	}
 

-- 
http://www.codemonkey.org.uk
