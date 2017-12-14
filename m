From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [bug report] scsi: qla2xxx: Fix memory leak in dual/target mode
Date: Thu, 14 Dec 2017 11:02:23 +0300
Message-ID: <20171214080223.eflsnwquncqmw4p5@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp2130.oracle.com ([156.151.31.86]:45319 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750795AbdLNJAF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Dec 2017 04:00:05 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: himanshu.madhani@cavium.com
Cc: linux-scsi@vger.kernel.org

Hello himanshu.madhani@cavium.com,

This is a semi-automatic email about new static checker warnings.

The patch 7867b98dceb7: "scsi: qla2xxx: Fix memory leak in
dual/target mode" from Dec 4, 2017, leads to the following Smatch
complaint:

    drivers/scsi/qla2xxx/qla_mid.c:586 qla25xx_delete_req_que()
    error: we previously assumed 'req' could be null (see line 580)

    drivers/scsi/qla2xxx/qla_mid.c:602 qla25xx_delete_rsp_que()
    error: we previously assumed 'rsp' could be null (see line 596)


drivers/scsi/qla2xxx/qla_mid.c
   579	
   580		if (req && vha->flags.qpairs_req_created) {
                    ^^^
Check for NULL

   581			req->options |= BIT_0;
   582			ret = qla25xx_init_req_que(vha, req);
   583			if (ret != QLA_SUCCESS)
   584				return QLA_FUNCTION_FAILED;
   585		}
   586		qla25xx_free_req_que(vha, req);
                                          ^^^
Unchecked dereference inside function.

   587	
   588		return ret;

	[ snip ]

   595	
   596		if (rsp && vha->flags.qpairs_rsp_created) {
                    ^^^ 
  597			rsp->options |= BIT_0;
   598			ret = qla25xx_init_rsp_que(vha, rsp);
   599			if (ret != QLA_SUCCESS)
   600				return QLA_FUNCTION_FAILED;
   601		}
   602		qla25xx_free_rsp_que(vha, rsp);
                                          ^^^
   603	
   604		return ret;

regards,
dan carpenter

regards,
dan carpenter
