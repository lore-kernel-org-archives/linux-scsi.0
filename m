Return-Path: <SRS0=HJ87=Y2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4AA1ACA9EC7
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 13:14:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id F395321726
	for <linux-scsi@archiver.kernel.org>; Sat,  2 Nov 2019 13:14:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726979AbfKBNOm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 Nov 2019 09:14:42 -0400
Received: from mga18.intel.com ([134.134.136.126]:34630 "EHLO mga18.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726380AbfKBNOm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 2 Nov 2019 09:14:42 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga106.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 02 Nov 2019 06:14:41 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,259,1569308400"; 
   d="gz'50?scan'50,208,50";a="284524295"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 02 Nov 2019 06:14:38 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iQtEk-000DkJ-CE; Sat, 02 Nov 2019 21:14:38 +0800
Date:   Sat, 2 Nov 2019 21:14:26 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     kbuild-all@lists.01.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 09/24] scsi: Kill obsolete linux-specific status codes
Message-ID: <201911022141.iTiIsVvv%lkp@intel.com>
References: <20191031110452.73463-10-hare@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="lrmvgtopaj22uha3"
Content-Disposition: inline
In-Reply-To: <20191031110452.73463-10-hare@suse.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--lrmvgtopaj22uha3
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hannes,

I love your patch! Yet something to improve:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on v5.4-rc5 next-20191031]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/Revamp-SCSI-result-values/20191102-095955
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: i386-randconfig-a002-201943 (attached as .config)
compiler: gcc-6 (Debian 6.3.0-18+deb9u1) 6.3.0 20170516
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/scsi/nsp32.c: In function 'nsp32_queuecommand_lck':
>> drivers/scsi/nsp32.c:938:25: error: 'CHECK_CONDITION' undeclared (first use in this function)
     SCpnt->SCp.Status    = CHECK_CONDITION;
                            ^~~~~~~~~~~~~~~
   drivers/scsi/nsp32.c:938:25: note: each undeclared identifier is reported only once for each function it appears in

vim +/CHECK_CONDITION +938 drivers/scsi/nsp32.c

^1da177e4c3f41 Linus Torvalds  2005-04-16   896  
f281233d3eba15 Jeff Garzik     2010-11-16   897  static int nsp32_queuecommand_lck(struct scsi_cmnd *SCpnt, void (*done)(struct scsi_cmnd *))
^1da177e4c3f41 Linus Torvalds  2005-04-16   898  {
^1da177e4c3f41 Linus Torvalds  2005-04-16   899  	nsp32_hw_data *data = (nsp32_hw_data *)SCpnt->device->host->hostdata;
^1da177e4c3f41 Linus Torvalds  2005-04-16   900  	nsp32_target *target;
^1da177e4c3f41 Linus Torvalds  2005-04-16   901  	nsp32_lunt   *cur_lunt;
^1da177e4c3f41 Linus Torvalds  2005-04-16   902  	int ret;
^1da177e4c3f41 Linus Torvalds  2005-04-16   903  
^1da177e4c3f41 Linus Torvalds  2005-04-16   904  	nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
fc3850458c176a Hans Wennborg   2014-08-05   905  		  "enter. target: 0x%x LUN: 0x%llx cmnd: 0x%x cmndlen: 0x%x "
^1da177e4c3f41 Linus Torvalds  2005-04-16   906  		  "use_sg: 0x%x reqbuf: 0x%lx reqlen: 0x%x",
^1da177e4c3f41 Linus Torvalds  2005-04-16   907  		  SCpnt->device->id, SCpnt->device->lun, SCpnt->cmnd[0], SCpnt->cmd_len,
2e91724658d5d6 FUJITA Tomonori 2007-05-26   908  		  scsi_sg_count(SCpnt), scsi_sglist(SCpnt), scsi_bufflen(SCpnt));
^1da177e4c3f41 Linus Torvalds  2005-04-16   909  
^1da177e4c3f41 Linus Torvalds  2005-04-16   910  	if (data->CurrentSC != NULL) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   911  		nsp32_msg(KERN_ERR, "Currentsc != NULL. Cancel this command request");
^1da177e4c3f41 Linus Torvalds  2005-04-16   912  		data->CurrentSC = NULL;
^1da177e4c3f41 Linus Torvalds  2005-04-16   913  		SCpnt->result   = DID_NO_CONNECT << 16;
^1da177e4c3f41 Linus Torvalds  2005-04-16   914  		done(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   915  		return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   916  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   917  
^1da177e4c3f41 Linus Torvalds  2005-04-16   918  	/* check target ID is not same as this initiator ID */
422c0d61d591cb Jeff Garzik     2005-10-24   919  	if (scmd_id(SCpnt) == SCpnt->device->host->this_id) {
9b13494c916dc0 Masanari Iida   2014-08-06   920  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "target==host???");
^1da177e4c3f41 Linus Torvalds  2005-04-16   921  		SCpnt->result = DID_BAD_TARGET << 16;
^1da177e4c3f41 Linus Torvalds  2005-04-16   922  		done(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   923  		return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   924  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   925  
^1da177e4c3f41 Linus Torvalds  2005-04-16   926  	/* check target LUN is allowable value */
^1da177e4c3f41 Linus Torvalds  2005-04-16   927  	if (SCpnt->device->lun >= MAX_LUN) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   928  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "no more lun");
^1da177e4c3f41 Linus Torvalds  2005-04-16   929  		SCpnt->result = DID_BAD_TARGET << 16;
^1da177e4c3f41 Linus Torvalds  2005-04-16   930  		done(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   931  		return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   932  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   933  
^1da177e4c3f41 Linus Torvalds  2005-04-16   934  	show_command(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   935  
^1da177e4c3f41 Linus Torvalds  2005-04-16   936  	SCpnt->scsi_done     = done;
^1da177e4c3f41 Linus Torvalds  2005-04-16   937  	data->CurrentSC      = SCpnt;
^1da177e4c3f41 Linus Torvalds  2005-04-16  @938  	SCpnt->SCp.Status    = CHECK_CONDITION;
^1da177e4c3f41 Linus Torvalds  2005-04-16   939  	SCpnt->SCp.Message   = 0;
2e91724658d5d6 FUJITA Tomonori 2007-05-26   940  	scsi_set_resid(SCpnt, scsi_bufflen(SCpnt));
^1da177e4c3f41 Linus Torvalds  2005-04-16   941  
2e91724658d5d6 FUJITA Tomonori 2007-05-26   942  	SCpnt->SCp.ptr		    = (char *)scsi_sglist(SCpnt);
2e91724658d5d6 FUJITA Tomonori 2007-05-26   943  	SCpnt->SCp.this_residual    = scsi_bufflen(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   944  	SCpnt->SCp.buffer	    = NULL;
^1da177e4c3f41 Linus Torvalds  2005-04-16   945  	SCpnt->SCp.buffers_residual = 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   946  
^1da177e4c3f41 Linus Torvalds  2005-04-16   947  	/* initialize data */
^1da177e4c3f41 Linus Torvalds  2005-04-16   948  	data->msgout_len	= 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   949  	data->msgin_len		= 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   950  	cur_lunt		= &(data->lunt[SCpnt->device->id][SCpnt->device->lun]);
^1da177e4c3f41 Linus Torvalds  2005-04-16   951  	cur_lunt->SCpnt		= SCpnt;
^1da177e4c3f41 Linus Torvalds  2005-04-16   952  	cur_lunt->save_datp	= 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   953  	cur_lunt->msgin03	= FALSE;
^1da177e4c3f41 Linus Torvalds  2005-04-16   954  	data->cur_lunt		= cur_lunt;
^1da177e4c3f41 Linus Torvalds  2005-04-16   955  	data->cur_id		= SCpnt->device->id;
^1da177e4c3f41 Linus Torvalds  2005-04-16   956  	data->cur_lun		= SCpnt->device->lun;
^1da177e4c3f41 Linus Torvalds  2005-04-16   957  
^1da177e4c3f41 Linus Torvalds  2005-04-16   958  	ret = nsp32_setup_sg_table(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   959  	if (ret == FALSE) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   960  		nsp32_msg(KERN_ERR, "SGT fail");
^1da177e4c3f41 Linus Torvalds  2005-04-16   961  		SCpnt->result = DID_ERROR << 16;
^1da177e4c3f41 Linus Torvalds  2005-04-16   962  		nsp32_scsi_done(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   963  		return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16   964  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16   965  
^1da177e4c3f41 Linus Torvalds  2005-04-16   966  	/* Build IDENTIFY */
^1da177e4c3f41 Linus Torvalds  2005-04-16   967  	nsp32_build_identify(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16   968  
^1da177e4c3f41 Linus Torvalds  2005-04-16   969  	/* 
^1da177e4c3f41 Linus Torvalds  2005-04-16   970  	 * If target is the first time to transfer after the reset
^1da177e4c3f41 Linus Torvalds  2005-04-16   971  	 * (target don't have SDTR_DONE and SDTR_INITIATOR), sync
^1da177e4c3f41 Linus Torvalds  2005-04-16   972  	 * message SDTR is needed to do synchronous transfer.
^1da177e4c3f41 Linus Torvalds  2005-04-16   973  	 */
422c0d61d591cb Jeff Garzik     2005-10-24   974  	target = &data->target[scmd_id(SCpnt)];
^1da177e4c3f41 Linus Torvalds  2005-04-16   975  	data->cur_target = target;
^1da177e4c3f41 Linus Torvalds  2005-04-16   976  
^1da177e4c3f41 Linus Torvalds  2005-04-16   977  	if (!(target->sync_flag & (SDTR_DONE | SDTR_INITIATOR | SDTR_TARGET))) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   978  		unsigned char period, offset;
^1da177e4c3f41 Linus Torvalds  2005-04-16   979  
^1da177e4c3f41 Linus Torvalds  2005-04-16   980  		if (trans_mode != ASYNC_MODE) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   981  			nsp32_set_max_sync(data, target, &period, &offset);
^1da177e4c3f41 Linus Torvalds  2005-04-16   982  			nsp32_build_sdtr(SCpnt, period, offset);
^1da177e4c3f41 Linus Torvalds  2005-04-16   983  			target->sync_flag |= SDTR_INITIATOR;
^1da177e4c3f41 Linus Torvalds  2005-04-16   984  		} else {
^1da177e4c3f41 Linus Torvalds  2005-04-16   985  			nsp32_set_async(data, target);
^1da177e4c3f41 Linus Torvalds  2005-04-16   986  			target->sync_flag |= SDTR_DONE;
^1da177e4c3f41 Linus Torvalds  2005-04-16   987  		}
^1da177e4c3f41 Linus Torvalds  2005-04-16   988  
^1da177e4c3f41 Linus Torvalds  2005-04-16   989  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
^1da177e4c3f41 Linus Torvalds  2005-04-16   990  			  "SDTR: entry: %d start_period: 0x%x offset: 0x%x\n",
^1da177e4c3f41 Linus Torvalds  2005-04-16   991  			  target->limit_entry, period, offset);
^1da177e4c3f41 Linus Torvalds  2005-04-16   992  	} else if (target->sync_flag & SDTR_INITIATOR) {
^1da177e4c3f41 Linus Torvalds  2005-04-16   993  		/*
^1da177e4c3f41 Linus Torvalds  2005-04-16   994  		 * It was negotiating SDTR with target, sending from the
^1da177e4c3f41 Linus Torvalds  2005-04-16   995  		 * initiator, but there are no chance to remove this flag.
^1da177e4c3f41 Linus Torvalds  2005-04-16   996  		 * Set async because we don't get proper negotiation.
^1da177e4c3f41 Linus Torvalds  2005-04-16   997  		 */
^1da177e4c3f41 Linus Torvalds  2005-04-16   998  		nsp32_set_async(data, target);
^1da177e4c3f41 Linus Torvalds  2005-04-16   999  		target->sync_flag &= ~SDTR_INITIATOR;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1000  		target->sync_flag |= SDTR_DONE;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1001  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1002  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1003  			  "SDTR_INITIATOR: fall back to async");
^1da177e4c3f41 Linus Torvalds  2005-04-16  1004  	} else if (target->sync_flag & SDTR_TARGET) {
^1da177e4c3f41 Linus Torvalds  2005-04-16  1005  		/*
^1da177e4c3f41 Linus Torvalds  2005-04-16  1006  		 * It was negotiating SDTR with target, sending from target,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1007  		 * but there are no chance to remove this flag.  Set async
^1da177e4c3f41 Linus Torvalds  2005-04-16  1008  		 * because we don't get proper negotiation.
^1da177e4c3f41 Linus Torvalds  2005-04-16  1009  		 */
^1da177e4c3f41 Linus Torvalds  2005-04-16  1010  		nsp32_set_async(data, target);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1011  		target->sync_flag &= ~SDTR_TARGET;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1012  		target->sync_flag |= SDTR_DONE;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1013  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1014  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1015  			  "Unknown SDTR from target is reached, fall back to async.");
^1da177e4c3f41 Linus Torvalds  2005-04-16  1016  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1017  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1018  	nsp32_dbg(NSP32_DEBUG_TARGETFLAG,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1019  		  "target: %d sync_flag: 0x%x syncreg: 0x%x ackwidth: 0x%x",
^1da177e4c3f41 Linus Torvalds  2005-04-16  1020  		  SCpnt->device->id, target->sync_flag, target->syncreg,
^1da177e4c3f41 Linus Torvalds  2005-04-16  1021  		  target->ackwidth);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1022  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1023  	/* Selection */
^1da177e4c3f41 Linus Torvalds  2005-04-16  1024  	if (auto_param == 0) {
^1da177e4c3f41 Linus Torvalds  2005-04-16  1025  		ret = nsp32_selection_autopara(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1026  	} else {
^1da177e4c3f41 Linus Torvalds  2005-04-16  1027  		ret = nsp32_selection_autoscsi(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1028  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1029  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1030  	if (ret != TRUE) {
^1da177e4c3f41 Linus Torvalds  2005-04-16  1031  		nsp32_dbg(NSP32_DEBUG_QUEUECOMMAND, "selection fail");
^1da177e4c3f41 Linus Torvalds  2005-04-16  1032  		nsp32_scsi_done(SCpnt);
^1da177e4c3f41 Linus Torvalds  2005-04-16  1033  	}
^1da177e4c3f41 Linus Torvalds  2005-04-16  1034  
^1da177e4c3f41 Linus Torvalds  2005-04-16  1035  	return 0;
^1da177e4c3f41 Linus Torvalds  2005-04-16  1036  }
^1da177e4c3f41 Linus Torvalds  2005-04-16  1037  

:::::: The code at line 938 was first introduced by commit
:::::: 1da177e4c3f41524e886b7f1b8a0c1fc7321cac2 Linux-2.6.12-rc2

:::::: TO: Linus Torvalds <torvalds@ppc970.osdl.org>
:::::: CC: Linus Torvalds <torvalds@ppc970.osdl.org>

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--lrmvgtopaj22uha3
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--lrmvgtopaj22uha3--
