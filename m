From: Fengguang Wu <fengguang.wu@intel.com>
Subject: drivers/scsi/ipr.c:8448:2-19: alloc with no test
Date: Sat, 18 Aug 2012 21:46:13 +0800
Message-ID: <20120818134613.GA11000@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:28167 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755509Ab2HRNqU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 18 Aug 2012 09:46:20 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Brian King <brking@linux.vnet.ibm.com>
Cc: kernel-janitors@vger.kernel.org, Wayne Boyer <wayneb@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Hi Brian,

FYI, coccinelle warns about

  drivers/scsi/ipr.c:8448:2-19: alloc with no test, possible model on line 8457

vi +8448 drivers/scsi/ipr.c

  8443         if (ioa_cfg->sis64) {
  8444                 ioa_cfg->target_ids = kzalloc(sizeof(unsigned long) *
  8445                                               BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
  8446                 ioa_cfg->array_ids = kzalloc(sizeof(unsigned long) *
  8447                                              BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
> 8448                 ioa_cfg->vset_ids = kzalloc(sizeof(unsigned long) *
  8449                                             BITS_TO_LONGS(ioa_cfg->max_devs_supported), GFP_KERNEL);
  8450         }
  8451   

Thanks,
Fengguang
