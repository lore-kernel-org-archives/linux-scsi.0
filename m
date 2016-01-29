From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] pmcraid: PMC-Sierra MaxRAID driver to support 6Gb/s SAS
 RAID controller
Date: Fri, 29 Jan 2016 13:39:49 +0300
Message-ID: <20160129103949.GA6359@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29779 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752732AbcA2KkG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Jan 2016 05:40:06 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: anil_ravindranath@pmc-sierra.com
Cc: linux-scsi@vger.kernel.org

Hello Anil Ravindranath,

The patch 89a368104150: "[SCSI] pmcraid: PMC-Sierra MaxRAID driver to
support 6Gb/s SAS RAID controller" from Aug 25, 2009, leads to the
following static checker warning:

	drivers/scsi/pmcraid.c:3376 pmcraid_copy_sglist()
	error: overflow detected.  __copy_from_user() 'kaddr' is 4096 bytes.  limit = '0-u32max'

drivers/scsi/pmcraid.c
  3331  static int pmcraid_copy_sglist(
  3332          struct pmcraid_sglist *sglist,
  3333          unsigned long buffer,
  3334          u32 len,
  3335          int direction
  3336  )
  3337  {
  3338          struct scatterlist *scatterlist;
  3339          void *kaddr;
  3340          int bsize_elem;
  3341          int i;
  3342          int rc = 0;
  3343  
  3344          /* Determine the actual number of bytes per element */
  3345          bsize_elem = PAGE_SIZE * (1 << sglist->order);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
This sets bsize_elem to PAGE_SIZE or higher.

  3346  
  3347          scatterlist = sglist->scatterlist;
  3348  
  3349          for (i = 0; i < (len / bsize_elem); i++, buffer += bsize_elem) {
  3350                  struct page *page = sg_page(&scatterlist[i]);
  3351  
  3352                  kaddr = kmap(page);
  3353                  if (direction == DMA_TO_DEVICE)
  3354                          rc = __copy_from_user(kaddr,
  3355                                                (void *)buffer,
  3356                                                bsize_elem);
  3357                  else
  3358                          rc = __copy_to_user((void *)buffer, kaddr, bsize_elem);
  3359  
  3360                  kunmap(page);
  3361  
  3362                  if (rc) {
  3363                          pmcraid_err("failed to copy user data into sg list\n");
  3364                          return -EFAULT;
  3365                  }
  3366  
  3367                  scatterlist[i].length = bsize_elem;
  3368          }
  3369  
  3370          if (len % bsize_elem) {
  3371                  struct page *page = sg_page(&scatterlist[i]);
  3372  
  3373                  kaddr = kmap(page);
                        ^^^^^^^^^^^^^^^^^^
This maps a single page.  Apparently, on x86_64 it's a no-op?  Likely
this code was not tested on a HIGHMEM system (x86_32 with more than 1G
of RAM).

  3374  
  3375                  if (direction == DMA_TO_DEVICE)
  3376                          rc = __copy_from_user(kaddr,
                                                      ^^^^^
  3377                                                (void *)buffer,
  3378                                                len % bsize_elem);
                                                      ^^^^^^^^^^^^^^^^^
We're copying more than PAGE_SIZE potentially.

Anyway, something odd is going on here, and I don't know what to do
about it.

  3379                  else
  3380                          rc = __copy_to_user((void *)buffer,
  3381                                              kaddr,
  3382                                              len % bsize_elem);
  3383  
  3384                  kunmap(page);
  3385  
  3386                  scatterlist[i].length = len % bsize_elem;
  3387          }

regards,
dan carpenter
