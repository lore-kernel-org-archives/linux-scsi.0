From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [patch 1/1] sg: Free data buffers after calling blk_rq_unmap_user
Date: Thu, 17 Sep 2009 10:06:01 +0200
Message-ID: <4AB1EDE9.8090102@interlog.com>
References: <20090917071013.472963000@de.ibm.com> <20090917071553.766054000@de.ibm.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:37057 "EHLO elrond.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750883AbZIQIGD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 17 Sep 2009 04:06:03 -0400
In-Reply-To: <20090917071553.766054000@de.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christof Schmitt <christof.schmitt@de.ibm.com>
Cc: James Bottomley <James.Bottomley@suse.de>, linux-scsi@vger.kernel.org, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, stable@kernel.org

Christof Schmitt wrote:

 > From: Christof Schmitt <christof.schmitt@de.ibm.com>
 >
 > Running sg_luns on s390x with CONFIG_DEBUG_PAGEALLOC enabled fails
 > with EFAULT from the SG_IO ioctl. The EFAULT is the result from
 > copy_to_user failing in this call chain:
 >
 > sg_ioctl
 > sg_new_read
 > sg_finish_rem_req
 > blk_rq_unmap_user
 > __blk_rq_unmap_user
 > bio_uncopy_user
 > __bio_copy_iov
 > copy_to_user
 >
 > The sg driver calls sg_remove_scat to free the memory pages before
 > calling blk_rq_unmap_user that tries to copy the data back to
 > userspace. Change the order to first call blk_rq_unmap_user before
 > freeing the pages in sg_remove_scat.
 >
 > Acked-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
 > Cc: stable@kernel.org
 > Signed-off-by: Christof Schmitt <christof.schmitt@de.ibm.com>

Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
