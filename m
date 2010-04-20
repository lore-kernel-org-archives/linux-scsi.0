From: Lennert Buytenhek <buytenh@wantstofly.org>
Subject: mvsas mvs_pci_alloc() error handling
Date: Tue, 20 Apr 2010 16:13:44 +0200
Message-ID: <20100420141344.GO4586@mail.wantstofly.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.wantstofly.org ([80.101.37.227]:58880 "EHLO
	mail.wantstofly.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754809Ab0DTOca (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Apr 2010 10:32:30 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Yan <ayan@marvell.com>, Ke Wei <kewei@marvell.com>, Ying Chu <jasonchu@marvell.com>
Cc: linux-scsi@vger.kernel.org

When playing with mvsas (on 2.6.34-rc4 ish), I ran into this:

	WARNING: at /data/buytenh/linux-2.6/mm/vmalloc.c:1368 __vunmap+0x58/0xdc()
	Trying to vfree() nonexistent vm area (f0800000)

If ->chip_ioremap() fails, mvs_pci_alloc() will call mvs_free(), which
calls ->chip_iounmap(), which tries to free something that couldn't be
allocated in the first place.


A quick second glance at mvs_pci_alloc() turns up more fishy stuff,
for example:

        do {
                mvi = mvs_pci_alloc(pdev, ent, shost, nhost);
                if (!mvi) {
                        rc = -ENOMEM;
                        goto err_out_regions;
                }

                mvs_init_sas_add(mvi);

                mvi->instance = nhost;
                rc = MVS_CHIP_DISP->chip_init(mvi);
                if (rc) {
                        mvs_free(mvi);
                        goto err_out_regions;
                }
                nhost++;
        } while (nhost < chip->n_host);

I.e. if mvs_pci_alloc() or ->chip_init() fails for an mvi, we will free
this mvi but not any of the ones previously allocated in this loop.
