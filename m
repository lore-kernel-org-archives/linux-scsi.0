From: kbuild test robot <fengguang.wu@intel.com>
Subject: [scsi:for-next 14/27] drivers/scsi/qla2xxx/qla_os.c:364
 qla2x00_free_req_que() info: redundant null check on req->outstanding_cmds
 calling kfree()
Date: Mon, 17 Dec 2012 20:45:54 +0800
Message-ID: <50cf1402.D18vi8fJJPt89aXx%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga03.intel.com ([143.182.124.21]:47642 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752254Ab2LQMr5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 17 Dec 2012 07:47:57 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Saurav Kashyap <saurav.kashyap@qlogic.com>, James Bottomley <JBottomley@Parallels.com>

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   e3ff197a750d2912d0bb2a0161c23c18bad250ad
commit: 99cc149bbdd78a3f18c6b366e1c239f62d59d096 [14/27] [SCSI] qla2xxx: Determine the number of outstanding commands based on available resources.


smatch warnings:

+ drivers/scsi/qla2xxx/qla_os.c:364 qla2x00_free_req_que() info: redundant null check on req->outstanding_cmds calling kfree()
  drivers/scsi/qla2xxx/qla_os.c:686 qla2xxx_queuecommand() error: potential NULL dereference 'rport'.

vim +364 drivers/scsi/qla2xxx/qla_os.c

73208dfd Anirban Chakraborty 2008-12-09  348  
73208dfd Anirban Chakraborty 2008-12-09  349  fail_rsp_map:
73208dfd Anirban Chakraborty 2008-12-09  350  	kfree(ha->req_q_map);
73208dfd Anirban Chakraborty 2008-12-09  351  	ha->req_q_map = NULL;
73208dfd Anirban Chakraborty 2008-12-09  352  fail_req_map:
73208dfd Anirban Chakraborty 2008-12-09  353  	return -ENOMEM;
73208dfd Anirban Chakraborty 2008-12-09  354  }
73208dfd Anirban Chakraborty 2008-12-09  355  
2afa19a9 Anirban Chakraborty 2009-04-06  356  static void qla2x00_free_req_que(struct qla_hw_data *ha, struct req_que *req)
73208dfd Anirban Chakraborty 2008-12-09  357  {
73208dfd Anirban Chakraborty 2008-12-09  358  	if (req && req->ring)
73208dfd Anirban Chakraborty 2008-12-09  359  		dma_free_coherent(&ha->pdev->dev,
73208dfd Anirban Chakraborty 2008-12-09  360  		(req->length + 1) * sizeof(request_t),
73208dfd Anirban Chakraborty 2008-12-09  361  		req->ring, req->dma);
73208dfd Anirban Chakraborty 2008-12-09  362  
99cc149b Chad Dupuis         2012-12-07  363  	if (req && req->outstanding_cmds)
99cc149b Chad Dupuis         2012-12-07 @364  		kfree(req->outstanding_cmds);
99cc149b Chad Dupuis         2012-12-07  365  
73208dfd Anirban Chakraborty 2008-12-09  366  	kfree(req);
73208dfd Anirban Chakraborty 2008-12-09  367  	req = NULL;
73208dfd Anirban Chakraborty 2008-12-09  368  }
73208dfd Anirban Chakraborty 2008-12-09  369  
2afa19a9 Anirban Chakraborty 2009-04-06  370  static void qla2x00_free_rsp_que(struct qla_hw_data *ha, struct rsp_que *rsp)
2afa19a9 Anirban Chakraborty 2009-04-06  371  {
2afa19a9 Anirban Chakraborty 2009-04-06  372  	if (rsp && rsp->ring)

---
0-DAY kernel build testing backend         Open Source Technology Center
Fengguang Wu, Yuanhan Liu                              Intel Corporation
