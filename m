From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 34/35] scsi: Move eh_device_reset_handler() to use
 scsi_device as argument (fwd)
Date: Sat, 24 Jun 2017 06:47:33 -0400 (EDT)
Message-ID: <alpine.DEB.2.20.1706240646060.2945@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:3824 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751271AbdFXKri (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 24 Jun 2017 06:47:38 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>, Hannes Reinecke <hare@suse.com>, kbuild-all@01.org

Hello,

It looks like the goto on line 2374 could result in the io_lock not being
released.

julia

---------- Forwarded message ----------
Date: Sat, 24 Jun 2017 13:27:41 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH 34/35] scsi: Move eh_device_reset_handler() to use
    scsi_device as argument

Hi Hannes,

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on next-20170623]
[cannot apply to v4.12-rc6]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/SCSI-EH-argument-reshuffling/20170624-071433
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
:::::: branch date: 6 hours ago
:::::: commit date: 6 hours ago

>> drivers/scsi/fnic/fnic_scsi.c:2546:1-7: preceding lock on line 2369

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout fb100e8dae35309fce9f6f27ae70b8498ebb479a
vim +2546 drivers/scsi/fnic/fnic_scsi.c

67125b028 Hiral Patel       2013-09-12  2363  		atomic64_inc(&fnic_stats->misc_stats.rport_not_ready);
5df6d737d Abhijeet Joglekar 2009-04-17  2364  		goto fnic_device_reset_end;
67125b028 Hiral Patel       2013-09-12  2365  	}
fb100e8da Hannes Reinecke   2017-06-23  2366  	/* The last tag is reserved for device reset */
fb100e8da Hannes Reinecke   2017-06-23  2367  	sc = scsi_host_find_tag(sdev->host, fnic->fnic_max_tag_id - 1);
5df6d737d Abhijeet Joglekar 2009-04-17  2368  	io_lock = fnic_io_lock_hash(fnic, sc);
5df6d737d Abhijeet Joglekar 2009-04-17 @2369  	spin_lock_irqsave(io_lock, flags);
fb100e8da Hannes Reinecke   2017-06-23  2370  	if (CMD_SP(sc)) {
5df6d737d Abhijeet Joglekar 2009-04-17  2371  		/*
fb100e8da Hannes Reinecke   2017-06-23  2372  		 * Reset tag busy
5df6d737d Abhijeet Joglekar 2009-04-17  2373  		 */
fb100e8da Hannes Reinecke   2017-06-23  2374  		goto fnic_device_reset_end;
fb100e8da Hannes Reinecke   2017-06-23  2375  	}
fb100e8da Hannes Reinecke   2017-06-23  2376  	CMD_FLAGS(sc) = FNIC_DEVICE_RESET;
5df6d737d Abhijeet Joglekar 2009-04-17  2377  	io_req = mempool_alloc(fnic->io_req_pool, GFP_ATOMIC);
5df6d737d Abhijeet Joglekar 2009-04-17  2378  	if (!io_req) {
5df6d737d Abhijeet Joglekar 2009-04-17  2379  		spin_unlock_irqrestore(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2380  		goto fnic_device_reset_end;
5df6d737d Abhijeet Joglekar 2009-04-17  2381  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2382  	memset(io_req, 0, sizeof(*io_req));
5df6d737d Abhijeet Joglekar 2009-04-17  2383  	io_req->port_id = rport->port_id;
5df6d737d Abhijeet Joglekar 2009-04-17  2384  	CMD_SP(sc) = (char *)io_req;
5df6d737d Abhijeet Joglekar 2009-04-17  2385  	io_req->dr_done = &tm_done;
fb100e8da Hannes Reinecke   2017-06-23  2386
5df6d737d Abhijeet Joglekar 2009-04-17  2387  	CMD_STATE(sc) = FNIC_IOREQ_CMD_PENDING;
5df6d737d Abhijeet Joglekar 2009-04-17  2388  	CMD_LR_STATUS(sc) = FCPIO_INVALID_CODE;
5df6d737d Abhijeet Joglekar 2009-04-17  2389  	spin_unlock_irqrestore(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2390
03298552c Hiral Patel       2013-02-12  2391  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host, "TAG %x\n", tag);
5df6d737d Abhijeet Joglekar 2009-04-17  2392
5df6d737d Abhijeet Joglekar 2009-04-17  2393  	/*
5df6d737d Abhijeet Joglekar 2009-04-17  2394  	 * issue the device reset, if enqueue failed, clean up the ioreq
5df6d737d Abhijeet Joglekar 2009-04-17  2395  	 * and break assoc with scsi cmd
5df6d737d Abhijeet Joglekar 2009-04-17  2396  	 */
5df6d737d Abhijeet Joglekar 2009-04-17  2397  	if (fnic_queue_dr_io_req(fnic, sc, io_req)) {
5df6d737d Abhijeet Joglekar 2009-04-17  2398  		spin_lock_irqsave(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2399  		io_req = (struct fnic_io_req *)CMD_SP(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2400  		if (io_req)
5df6d737d Abhijeet Joglekar 2009-04-17  2401  			io_req->dr_done = NULL;
5df6d737d Abhijeet Joglekar 2009-04-17  2402  		goto fnic_device_reset_clean;
5df6d737d Abhijeet Joglekar 2009-04-17  2403  	}
03298552c Hiral Patel       2013-02-12  2404  	spin_lock_irqsave(io_lock, flags);
14eb5d905 Hiral Patel       2013-02-12  2405  	CMD_FLAGS(sc) |= FNIC_DEV_RST_ISSUED;
03298552c Hiral Patel       2013-02-12  2406  	spin_unlock_irqrestore(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2407
5df6d737d Abhijeet Joglekar 2009-04-17  2408  	/*
5df6d737d Abhijeet Joglekar 2009-04-17  2409  	 * Wait on the local completion for LUN reset.  The io_req may be
5df6d737d Abhijeet Joglekar 2009-04-17  2410  	 * freed while we wait since we hold no lock.
5df6d737d Abhijeet Joglekar 2009-04-17  2411  	 */
5df6d737d Abhijeet Joglekar 2009-04-17  2412  	wait_for_completion_timeout(&tm_done,
5df6d737d Abhijeet Joglekar 2009-04-17  2413  				    msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
5df6d737d Abhijeet Joglekar 2009-04-17  2414
5df6d737d Abhijeet Joglekar 2009-04-17  2415  	spin_lock_irqsave(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2416  	io_req = (struct fnic_io_req *)CMD_SP(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2417  	if (!io_req) {
5df6d737d Abhijeet Joglekar 2009-04-17  2418  		spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2419  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
03298552c Hiral Patel       2013-02-12  2420  				"io_req is null tag 0x%x sc 0x%p\n", tag, sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2421  		goto fnic_device_reset_end;
5df6d737d Abhijeet Joglekar 2009-04-17  2422  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2423  	io_req->dr_done = NULL;
5df6d737d Abhijeet Joglekar 2009-04-17  2424
5df6d737d Abhijeet Joglekar 2009-04-17  2425  	status = CMD_LR_STATUS(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2426
5df6d737d Abhijeet Joglekar 2009-04-17  2427  	/*
5df6d737d Abhijeet Joglekar 2009-04-17  2428  	 * If lun reset not completed, bail out with failed. io_req
5df6d737d Abhijeet Joglekar 2009-04-17  2429  	 * gets cleaned up during higher levels of EH
5df6d737d Abhijeet Joglekar 2009-04-17  2430  	 */
5df6d737d Abhijeet Joglekar 2009-04-17  2431  	if (status == FCPIO_INVALID_CODE) {
67125b028 Hiral Patel       2013-09-12  2432  		atomic64_inc(&reset_stats->device_reset_timeouts);
5df6d737d Abhijeet Joglekar 2009-04-17  2433  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
5df6d737d Abhijeet Joglekar 2009-04-17  2434  			      "Device reset timed out\n");
03298552c Hiral Patel       2013-02-12  2435  		CMD_FLAGS(sc) |= FNIC_DEV_RST_TIMED_OUT;
03298552c Hiral Patel       2013-02-12  2436  		spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2437  		int_to_scsilun(sc->device->lun, &fc_lun);
03298552c Hiral Patel       2013-02-12  2438  		/*
1259c5dc7 Sesidhar Beddel   2013-09-09  2439  		 * Issue abort and terminate on device reset request.
1259c5dc7 Sesidhar Beddel   2013-09-09  2440  		 * If q'ing of terminate fails, retry it after a delay.
03298552c Hiral Patel       2013-02-12  2441  		 */
03298552c Hiral Patel       2013-02-12  2442  		while (1) {
03298552c Hiral Patel       2013-02-12  2443  			spin_lock_irqsave(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2444  			if (CMD_FLAGS(sc) & FNIC_DEV_RST_TERM_ISSUED) {
03298552c Hiral Patel       2013-02-12  2445  				spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2446  				break;
03298552c Hiral Patel       2013-02-12  2447  			}
03298552c Hiral Patel       2013-02-12  2448  			spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2449  			if (fnic_queue_abort_io_req(fnic,
03298552c Hiral Patel       2013-02-12  2450  				tag | FNIC_TAG_DEV_RST,
03298552c Hiral Patel       2013-02-12  2451  				FCPIO_ITMF_ABT_TASK_TERM,
03298552c Hiral Patel       2013-02-12  2452  				fc_lun.scsi_lun, io_req)) {
03298552c Hiral Patel       2013-02-12  2453  				wait_for_completion_timeout(&tm_done,
03298552c Hiral Patel       2013-02-12  2454  				msecs_to_jiffies(FNIC_ABT_TERM_DELAY_TIMEOUT));
03298552c Hiral Patel       2013-02-12  2455  			} else {
03298552c Hiral Patel       2013-02-12  2456  				spin_lock_irqsave(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2457  				CMD_FLAGS(sc) |= FNIC_DEV_RST_TERM_ISSUED;
03298552c Hiral Patel       2013-02-12  2458  				CMD_STATE(sc) = FNIC_IOREQ_ABTS_PENDING;
03298552c Hiral Patel       2013-02-12  2459  				io_req->abts_done = &tm_done;
03298552c Hiral Patel       2013-02-12  2460  				spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2461  				FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
03298552c Hiral Patel       2013-02-12  2462  				"Abort and terminate issued on Device reset "
03298552c Hiral Patel       2013-02-12  2463  				"tag 0x%x sc 0x%p\n", tag, sc);
03298552c Hiral Patel       2013-02-12  2464  				break;
03298552c Hiral Patel       2013-02-12  2465  			}
03298552c Hiral Patel       2013-02-12  2466  		}
03298552c Hiral Patel       2013-02-12  2467  		while (1) {
03298552c Hiral Patel       2013-02-12  2468  			spin_lock_irqsave(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2469  			if (!(CMD_FLAGS(sc) & FNIC_DEV_RST_DONE)) {
03298552c Hiral Patel       2013-02-12  2470  				spin_unlock_irqrestore(io_lock, flags);
03298552c Hiral Patel       2013-02-12  2471  				wait_for_completion_timeout(&tm_done,
03298552c Hiral Patel       2013-02-12  2472  				msecs_to_jiffies(FNIC_LUN_RESET_TIMEOUT));
03298552c Hiral Patel       2013-02-12  2473  				break;
03298552c Hiral Patel       2013-02-12  2474  			} else {
03298552c Hiral Patel       2013-02-12  2475  				io_req = (struct fnic_io_req *)CMD_SP(sc);
03298552c Hiral Patel       2013-02-12  2476  				io_req->abts_done = NULL;
03298552c Hiral Patel       2013-02-12  2477  				goto fnic_device_reset_clean;
03298552c Hiral Patel       2013-02-12  2478  			}
03298552c Hiral Patel       2013-02-12  2479  		}
03298552c Hiral Patel       2013-02-12  2480  	} else {
03298552c Hiral Patel       2013-02-12  2481  		spin_unlock_irqrestore(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2482  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2483
5df6d737d Abhijeet Joglekar 2009-04-17  2484  	/* Completed, but not successful, clean up the io_req, return fail */
5df6d737d Abhijeet Joglekar 2009-04-17  2485  	if (status != FCPIO_SUCCESS) {
5df6d737d Abhijeet Joglekar 2009-04-17  2486  		spin_lock_irqsave(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2487  		FNIC_SCSI_DBG(KERN_DEBUG,
5df6d737d Abhijeet Joglekar 2009-04-17  2488  			      fnic->lport->host,
5df6d737d Abhijeet Joglekar 2009-04-17  2489  			      "Device reset completed - failed\n");
5df6d737d Abhijeet Joglekar 2009-04-17  2490  		io_req = (struct fnic_io_req *)CMD_SP(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2491  		goto fnic_device_reset_clean;
5df6d737d Abhijeet Joglekar 2009-04-17  2492  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2493
5df6d737d Abhijeet Joglekar 2009-04-17  2494  	/*
5df6d737d Abhijeet Joglekar 2009-04-17  2495  	 * Clean up any aborts on this lun that have still not
5df6d737d Abhijeet Joglekar 2009-04-17  2496  	 * completed. If any of these fail, then LUN reset fails.
5df6d737d Abhijeet Joglekar 2009-04-17  2497  	 * clean_pending_aborts cleans all cmds on this lun except
5df6d737d Abhijeet Joglekar 2009-04-17  2498  	 * the lun reset cmd. If all cmds get cleaned, the lun reset
5df6d737d Abhijeet Joglekar 2009-04-17  2499  	 * succeeds
5df6d737d Abhijeet Joglekar 2009-04-17  2500  	 */
fb100e8da Hannes Reinecke   2017-06-23  2501  	if (fnic_clean_pending_aborts(fnic, sc)) {
5df6d737d Abhijeet Joglekar 2009-04-17  2502  		spin_lock_irqsave(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2503  		io_req = (struct fnic_io_req *)CMD_SP(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2504  		FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
5df6d737d Abhijeet Joglekar 2009-04-17  2505  			      "Device reset failed"
5df6d737d Abhijeet Joglekar 2009-04-17  2506  			      " since could not abort all IOs\n");
5df6d737d Abhijeet Joglekar 2009-04-17  2507  		goto fnic_device_reset_clean;
5df6d737d Abhijeet Joglekar 2009-04-17  2508  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2509
5df6d737d Abhijeet Joglekar 2009-04-17  2510  	/* Clean lun reset command */
5df6d737d Abhijeet Joglekar 2009-04-17  2511  	spin_lock_irqsave(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2512  	io_req = (struct fnic_io_req *)CMD_SP(sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2513  	if (io_req)
5df6d737d Abhijeet Joglekar 2009-04-17  2514  		/* Completed, and successful */
5df6d737d Abhijeet Joglekar 2009-04-17  2515  		ret = SUCCESS;
5df6d737d Abhijeet Joglekar 2009-04-17  2516
5df6d737d Abhijeet Joglekar 2009-04-17  2517  fnic_device_reset_clean:
5df6d737d Abhijeet Joglekar 2009-04-17  2518  	if (io_req)
5df6d737d Abhijeet Joglekar 2009-04-17  2519  		CMD_SP(sc) = NULL;
5df6d737d Abhijeet Joglekar 2009-04-17  2520
5df6d737d Abhijeet Joglekar 2009-04-17  2521  	spin_unlock_irqrestore(io_lock, flags);
5df6d737d Abhijeet Joglekar 2009-04-17  2522
5df6d737d Abhijeet Joglekar 2009-04-17  2523  	if (io_req) {
14eb5d905 Hiral Patel       2013-02-12  2524  		start_time = io_req->start_time;
5df6d737d Abhijeet Joglekar 2009-04-17  2525  		fnic_release_ioreq_buf(fnic, io_req, sc);
5df6d737d Abhijeet Joglekar 2009-04-17  2526  		mempool_free(io_req, fnic->io_req_pool);
5df6d737d Abhijeet Joglekar 2009-04-17  2527  	}
5df6d737d Abhijeet Joglekar 2009-04-17  2528
5df6d737d Abhijeet Joglekar 2009-04-17  2529  fnic_device_reset_end:
4d7007b49 Hiral Patel       2013-02-12  2530  	FNIC_TRACE(fnic_device_reset, sc->device->host->host_no,
4d7007b49 Hiral Patel       2013-02-12  2531  		  sc->request->tag, sc,
4d7007b49 Hiral Patel       2013-02-12  2532  		  jiffies_to_msecs(jiffies - start_time),
4d7007b49 Hiral Patel       2013-02-12  2533  		  0, ((u64)sc->cmnd[0] << 32 |
4d7007b49 Hiral Patel       2013-02-12  2534  		  (u64)sc->cmnd[2] << 24 | (u64)sc->cmnd[3] << 16 |
4d7007b49 Hiral Patel       2013-02-12  2535  		  (u64)sc->cmnd[4] << 8 | sc->cmnd[5]),
4d7007b49 Hiral Patel       2013-02-12  2536  		  (((u64)CMD_FLAGS(sc) << 32) | CMD_STATE(sc)));
4d7007b49 Hiral Patel       2013-02-12  2537
5df6d737d Abhijeet Joglekar 2009-04-17  2538  	FNIC_SCSI_DBG(KERN_DEBUG, fnic->lport->host,
5df6d737d Abhijeet Joglekar 2009-04-17  2539  		      "Returning from device reset %s\n",
5df6d737d Abhijeet Joglekar 2009-04-17  2540  		      (ret == SUCCESS) ?
5df6d737d Abhijeet Joglekar 2009-04-17  2541  		      "SUCCESS" : "FAILED");
67125b028 Hiral Patel       2013-09-12  2542
67125b028 Hiral Patel       2013-09-12  2543  	if (ret == FAILED)
67125b028 Hiral Patel       2013-09-12  2544  		atomic64_inc(&reset_stats->device_reset_failures);
67125b028 Hiral Patel       2013-09-12  2545
5df6d737d Abhijeet Joglekar 2009-04-17 @2546  	return ret;
5df6d737d Abhijeet Joglekar 2009-04-17  2547  }
5df6d737d Abhijeet Joglekar 2009-04-17  2548
5df6d737d Abhijeet Joglekar 2009-04-17  2549  /* Clean up all IOs, clean up libFC local port */

:::::: The code at line 2546 was first introduced by commit
:::::: 5df6d737dd4b0fe9eccf943abb3677cfea05a6c4 [SCSI] fnic: Add new Cisco PCI-Express FCoE HBA

:::::: TO: Abhijeet Joglekar <abjoglek@cisco.com>
:::::: CC: James Bottomley <James.Bottomley@HansenPartnership.com>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
