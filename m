From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v2 15/29] be2iscsi: Fix to make boot discovery
 non-blocking
Date: Mon, 22 Aug 2016 20:53:55 -0400 (EDT)
Message-ID: <alpine.DEB.2.10.1608222052300.4340@hadrien>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail2-relais-roc.national.inria.fr ([192.134.164.83]:48308 "EHLO
        mail2-relais-roc.national.inria.fr" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752142AbcHWAyA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 22 Aug 2016 20:54:00 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Cc: mchristi@redhat.com, linux-scsi@vger.kernel.org, kbuild-all@01.org

Please check the return on line 1517.  It looks suspicious that it does
not release the lock, unlike the return on line 1508.

julia

---

Hi Jitendra,

[auto build test WARNING on scsi/for-next]
[also build test WARNING on v4.8-rc3 next-20160822]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
[Suggest to use git(>=2.9.0) format-patch --base=<commit> (or --base=auto for convenience) to record what (public, well-known) commit your patch series was built on]
[Check https://git-scm.com/docs/git-format-patch for more information]

url:    https://github.com/0day-ci/linux/commits/Jitendra-Bhivare/be2iscsi-driver-update-11-2-0-0/20160819-175550
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
:::::: branch date: 4 days ago
:::::: commit date: 4 days ago

>> drivers/scsi/be2iscsi/be_mgmt.c:1517:2-8: preceding lock on line 1504

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout b9f267a2cf5f152fb5b5b907b715e0854f337ccd
vim +1517 drivers/scsi/be2iscsi/be_mgmt.c

b9f267a2 Jitendra Bhivare 2016-08-19  1498  	struct be_cmd_get_session_req *req;
b9f267a2 Jitendra Bhivare 2016-08-19  1499  	struct be_dma_mem *nonemb_cmd;
b9f267a2 Jitendra Bhivare 2016-08-19  1500  	struct be_mcc_wrb *wrb;
b9f267a2 Jitendra Bhivare 2016-08-19  1501  	struct be_sge *sge;
b9f267a2 Jitendra Bhivare 2016-08-19  1502  	unsigned int tag;
b9f267a2 Jitendra Bhivare 2016-08-19  1503
b9f267a2 Jitendra Bhivare 2016-08-19 @1504  	mutex_lock(&ctrl->mbox_lock);
b9f267a2 Jitendra Bhivare 2016-08-19  1505  	wrb = alloc_mcc_wrb(phba, &tag);
b9f267a2 Jitendra Bhivare 2016-08-19  1506  	if (!wrb) {
b9f267a2 Jitendra Bhivare 2016-08-19  1507  		mutex_unlock(&ctrl->mbox_lock);
b9f267a2 Jitendra Bhivare 2016-08-19  1508  		return 0;
b9f267a2 Jitendra Bhivare 2016-08-19  1509  	}
b9f267a2 Jitendra Bhivare 2016-08-19  1510
b9f267a2 Jitendra Bhivare 2016-08-19  1511  	nonemb_cmd = &phba->boot_struct.nonemb_cmd;
b9f267a2 Jitendra Bhivare 2016-08-19  1512  	nonemb_cmd->size = sizeof(*resp);
b9f267a2 Jitendra Bhivare 2016-08-19  1513  	nonemb_cmd->va = pci_alloc_consistent(phba->ctrl.pdev,
b9f267a2 Jitendra Bhivare 2016-08-19  1514  					      sizeof(nonemb_cmd->size),
b9f267a2 Jitendra Bhivare 2016-08-19  1515  					      &nonemb_cmd->dma);
b9f267a2 Jitendra Bhivare 2016-08-19  1516  	if (!nonemb_cmd->va)
b9f267a2 Jitendra Bhivare 2016-08-19 @1517  		return 0;
b9f267a2 Jitendra Bhivare 2016-08-19  1518
b9f267a2 Jitendra Bhivare 2016-08-19  1519  	req = nonemb_cmd->va;
b9f267a2 Jitendra Bhivare 2016-08-19  1520  	memset(req, 0, sizeof(*req));

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
