From: Chip Coldwell <coldwell@redhat.com>
Subject: sg.c: sg_rb_correct4mmap
Date: Tue, 21 Mar 2006 11:20:35 -0500 (Eastern Standard Time)
Message-ID: <Pine.WNT.4.64.0603211106550.3756@chiptop>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:57518 "EHLO mx1.redhat.com")
	by vger.kernel.org with ESMTP id S932318AbWCUQUs (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 21 Mar 2006 11:20:48 -0500
Received: from int-mx1.corp.redhat.com (int-mx1.corp.redhat.com [172.16.52.254])
	by mx1.redhat.com (8.12.11.20060308/8.12.11) with ESMTP id k2LGKdrX006753
	for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2006 11:20:39 -0500
Received: from mail.boston.redhat.com (mail.boston.redhat.com [172.16.76.12])
	by int-mx1.corp.redhat.com (8.12.11.20060308/8.11.6) with ESMTP id k2LGKYaT005161
	for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2006 11:20:34 -0500
Received: from chiptop (vpn83-177.boston.redhat.com [172.16.83.177])
	by mail.boston.redhat.com (8.12.8/8.12.8) with ESMTP id k2LGKYOH007749
	for <linux-scsi@vger.kernel.org>; Tue, 21 Mar 2006 11:20:34 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


I'm trying to understand the purpose of this function in the SCSI generic 
driver (sg.c):

sg_rb_correct4mmap(Sg_scatter_hold * rsv_schp, int startFinish)
{
         struct scatterlist *sg = rsv_schp->buffer;
         struct page *page;
         int k, m;

         SCSI_LOG_TIMEOUT(3, printk("sg_rb_correct4mmap: startFinish=%d, scatg=%d\n",
                                    startFinish, rsv_schp->k_use_sg));
         /* N.B. correction _not_ applied to base page of each allocation */
         for (k = 0; k < rsv_schp->k_use_sg; ++k, ++sg) {
                 for (m = PAGE_SIZE; m < sg->length; m += PAGE_SIZE) {
                         page = sg->page;
                         if (startFinish)
                                 get_page(page);
                         else {
                                 if (page_count(page) > 0)
                                         __put_page(page);
                         }
                 }
         }
}

Judging from the comment, it would seem that the intention is to get/put 
every page in a scatterlist except the first one.  But that isn't what it 
does; if 2*PAGE_SIZE <= sg->length < N*PAGE_SIZE, then this logic will 
call get_page (or __put_page) N-2 times on the same page, rather than once 
on each of the N-2 pages after the first.

More generally, why is this operation needed at all, when the 
sg_vma_nopage function will presumably do the required get_page?

Chip

-- 
Charles M. "Chip" Coldwell
Senior Software Engineer
Red Hat, Inc

