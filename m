From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: [SCSI] be2iscsi: WRB Initialization and Failure code path change
Date: Thu, 31 Jan 2013 22:56:06 +0300
Message-ID: <20130131195606.GA4063@elgon.mountain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22112 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752937Ab3AaT4O (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 31 Jan 2013 14:56:14 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jayamohan.kallickal@emulex.com
Cc: linux-scsi@vger.kernel.org

Hello Jayamohan,

I had a question about 3ec7827134a9: "[SCSI] be2iscsi: WRB
Initialization and Failure code path change" from Apr 3, 2012.

drivers/scsi/be2iscsi/be_main.c
  2683          for (index = 0; index < phba->params.cxns_per_ctrl * 2; index += 2) {
                                                                        ^^^^^^^^^^
We are allocating every other element in the array.  Why?

  2684                  pwrb_context = &phwi_ctrlr->wrb_context[index];
  2685                  pwrb_context->pwrb_handle_base =
  2686                                  kzalloc(sizeof(struct wrb_handle *) *
  2687                                          phba->params.wrbs_per_cxn, GFP_KERNEL);
  2688                  if (!pwrb_context->pwrb_handle_base) {
  2689                          beiscsi_log(phba, KERN_ERR, BEISCSI_LOG_INIT,
  2690                                      "BM_%d : Mem Alloc Failed. Failing to load\n");
  2691                          goto init_wrb_hndl_failed;
  2692                  }

[snip]

  2746  init_wrb_hndl_failed:
  2747          for (j = index; j > 0; j--) {
                     ^^^^^^^^^^^^^^^^^^^^^
Here we are freeing every element in the array except ->wrb_context[0].
Some of the elements were not allocated, and doesn't skipping zero lead
to a memory leak?

  2748                  pwrb_context = &phwi_ctrlr->wrb_context[j];
  2749                  kfree(pwrb_context->pwrb_handle_base);
  2750                  kfree(pwrb_context->pwrb_handle_basestd);
  2751          }
  2752          return -ENOMEM;
  2753  }

regards,
dan carpenter

