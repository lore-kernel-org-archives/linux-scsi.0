From: Fengguang Wu <fengguang.wu@intel.com>
Subject: [scsi:for-next 92/128] drivers/scsi/qla2xxx/qla_isr.c:1684:56:
 warning: 'rval' may be used uninitialized in this function
Date: Sat, 15 Sep 2012 07:57:28 +0800
Message-ID: <20120914235728.GA32759@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga11.intel.com ([192.55.52.93]:1818 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751244Ab2INX5n (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 14 Sep 2012 19:57:43 -0400
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Saurav Kashyap <saurav.kashyap@qlogic.com>
Cc: Yuanhan Liu <yuanhan.liu@intel.com>, kernel-janitors@vger.kernel.org, James Bottomley <JBottomley@Parallels.com>, Chad Dupuis <chad.dupuis@qlogic.com>, linux-scsi@vger.kernel.org

Hi Saurav,

FYI, there are new compile warnings show up in

tree:   git://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
head:   71cfff4af0525891941199b142b759d00b293959
commit: 387fddaa3564503c9f82d091d2ebe390f3af62a1 [92/128] [SCSI] qla2xxx: Implementation of bidirectional.
config: x86_64-allmodconfig

All error/warnings:

drivers/scsi/qla2xxx/qla_isr.c: In function 'qla2x00_status_entry':
drivers/scsi/qla2xxx/qla_isr.c:1684:56: warning: 'rval' may be used uninitialized in this function [-Wmaybe-uninitialized]
drivers/scsi/qla2xxx/qla_isr.c:1558:11: note: 'rval' was declared here

It could be uninitialized due to the test in line 1598.

vim +1684 drivers/scsi/qla2xxx/qla_isr.c
  1596         switch (comp_status) {
  1597         case CS_COMPLETE:
> 1598                 if (scsi_status == 0) {
  1599                         bsg_job->reply->reply_payload_rcv_len =
  1600
  bsg_job->reply_payload.payload_len;
  1601                         rval = EXT_STATUS_OK;
  1602                 }
  1603                 goto done;
  1604 
...
  1674			ql_dbg(ql_dbg_user, vha, 0x70bb,
  1675			    "Command completed with completion status=0x%x "
  1676			    "thread_id=%d\n", comp_status, thread_id);
  1677			rval = EXT_STATUS_ERR;
  1678			break;
  1679		}
  1680			bsg_job->reply->reply_payload_rcv_len = 0;
  1681	
  1682	done:
  1683		/* Return the vendor specific reply to API */
> 1684		bsg_job->reply->reply_data.vendor_reply.vendor_rsp[0] = rval;
  1685		bsg_job->reply_len = sizeof(struct fc_bsg_reply);
  1686		/* Always return DID_OK, bsg will send the vendor specific response
  1687		 * in this case only */
  1688		sp->done(vha, sp, (DID_OK << 6));
  1689	
  1690	}

---
0-DAY kernel build testing backend         Open Source Technology Centre
Fengguang Wu, Yuanhan Liu                              Intel Corporation
