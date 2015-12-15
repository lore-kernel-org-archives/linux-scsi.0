From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: re: qla2xxx: ISP27xx add tests for incomplete template.
Date: Tue, 15 Dec 2015 23:04:37 +0300
Message-ID: <20151215200437.GA22468@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:29190 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752199AbbLOUEp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Dec 2015 15:04:45 -0500
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: joe.carnuccio@qlogic.com
Cc: linux-scsi@vger.kernel.org

Hello Joe Carnuccio,

The patch 299f5e27ac5f: "qla2xxx: ISP27xx add tests for incomplete
template." from Sep 25, 2014, leads to the following static checker
warning:

	drivers/scsi/qla2xxx/qla_tmpl.c:779 qla27xx_walk_template()
	warn: should this be 'count == -1'

drivers/scsi/qla2xxx/qla_tmpl.c
   764  static void
   765  qla27xx_walk_template(struct scsi_qla_host *vha,
   766          struct qla27xx_fwdt_template *tmp, void *buf, ulong *len)
   767  {
   768          struct qla27xx_fwdt_entry *ent = (void *)tmp + tmp->entry_offset;
   769          ulong count = tmp->entry_count;
   770  
   771          ql_dbg(ql_dbg_misc, vha, 0xd01a,
   772              "%s: entry count %lx\n", __func__, count);
   773          while (count--) {
   774                  if (qla27xx_find_entry(ent->hdr.entry_type)(vha, ent, buf, len))
   775                          break;
   776                  ent = qla27xx_next_entry(ent);
   777          }
   778  
   779          if (count)
   780                  ql_dbg(ql_dbg_misc, vha, 0xd018,
   781                      "%s: residual count (%lx)\n", __func__, count);

The static checker assumes that we are testing to see if the loop ended
with a break or not.  These are normally bugs because if we did not
break the count is set to (ulong)-1.

This code is sort of weird.  It's just debugging so I guess it doesn't
matter.  Are we expecting -1?

   782  
   783          if (ent->hdr.entry_type != ENTRY_TYPE_TMP_END)
   784                  ql_dbg(ql_dbg_misc, vha, 0xd019,
   785                      "%s: missing end (%lx)\n", __func__, count);
   786  
   787          ql_dbg(ql_dbg_misc, vha, 0xd01b,
   788              "%s: len=%lx\n", __func__, *len);
   789  
   790          if (buf) {
   791                  ql_log(ql_log_warn, vha, 0xd015,
   792                      "Firmware dump saved to temp buffer (%ld/%p)\n",
   793                      vha->host_no, vha->hw->fw_dump);
   794                  qla2x00_post_uevent_work(vha, QLA_UEVENT_CODE_FW_DUMP);
   795          }
   796  }

regards,
dan carpenter
