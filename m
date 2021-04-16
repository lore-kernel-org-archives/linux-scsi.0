Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F24F2C433B4
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 11:39:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C0DD66115B
	for <linux-scsi@archiver.kernel.org>; Fri, 16 Apr 2021 11:39:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241974AbhDPLkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 16 Apr 2021 07:40:12 -0400
Received: from mga01.intel.com ([192.55.52.88]:51854 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235422AbhDPLkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 16 Apr 2021 07:40:11 -0400
IronPort-SDR: EfC3ZXI3+HVc9HpUVxOODfuBrQiv4VEH65kIMP9kbcUtjL3xGc8dzVWugZ7SlvyRobI8TL+ln5
 QiUWC/ACmOaQ==
X-IronPort-AV: E=McAfee;i="6200,9189,9955"; a="215559899"
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="gz'50?scan'50,208,50";a="215559899"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2021 04:39:46 -0700
IronPort-SDR: FZ6eLv7MaJmInwkDkX2gokt40n1lMOs2n4d44rckndGGEyLefstF4C3ZILafWpclbTNVMy207E
 HfTxk//WgHtg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.82,226,1613462400"; 
   d="gz'50?scan'50,208,50";a="399887198"
Received: from lkp-server01.sh.intel.com (HELO a48ff7ddd223) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 16 Apr 2021 04:39:43 -0700
Received: from kbuild by a48ff7ddd223 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lXMp4-00004F-Eh; Fri, 16 Apr 2021 11:39:42 +0000
Date:   Fri, 16 Apr 2021 19:39:37 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mike Christie <michael.christie@oracle.com>, lduncan@suse.com,
        martin.petersen@oracle.com, mrangankar@marvell.com,
        svernekar@marvell.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com
Cc:     kbuild-all@lists.01.org,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v3 09/17] scsi: qedi: fix race during abort timeouts
Message-ID: <202104161932.IKLfImK0-lkp@intel.com>
References: <20210416020440.259271-10-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="wRRV7LY7NUeQGEoC"
Content-Disposition: inline
In-Reply-To: <20210416020440.259271-10-michael.christie@oracle.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--wRRV7LY7NUeQGEoC
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Mike,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20210415]
[cannot apply to mkp-scsi/for-next rdma/for-next v5.12-rc7]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Mike-Christie/libicsi-and-qedi-TMF-fixes/20210416-100636
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: alpha-randconfig-r016-20210416 (attached as .config)
compiler: alpha-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/9d4a83c1316e3dad2bd5687563584509a3d6557c
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mike-Christie/libicsi-and-qedi-TMF-fixes/20210416-100636
        git checkout 9d4a83c1316e3dad2bd5687563584509a3d6557c
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross W=1 ARCH=alpha 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/scsi/qedi/qedi_fw.c: In function 'qedi_process_cmd_cleanup_resp':
>> drivers/scsi/qedi/qedi_fw.c:741:6: warning: variable 'rtid' set but not used [-Wunused-but-set-variable]
     741 |  u32 rtid = 0;
         |      ^~~~


vim +/rtid +741 drivers/scsi/qedi/qedi_fw.c

ace7f46ba5fde7 Manish Rangankar 2016-12-01  729  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  730  static void qedi_process_cmd_cleanup_resp(struct qedi_ctx *qedi,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  731  					  struct iscsi_cqe_solicited *cqe,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  732  					  struct iscsi_task *task,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  733  					  struct iscsi_conn *conn)
ace7f46ba5fde7 Manish Rangankar 2016-12-01  734  {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  735  	struct qedi_work_map *work, *work_tmp;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  736  	u32 proto_itt = cqe->itid;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  737  	u32 ptmp_itt = 0;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  738  	itt_t protoitt = 0;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  739  	int found = 0;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  740  	struct qedi_cmd *qedi_cmd = NULL;
ace7f46ba5fde7 Manish Rangankar 2016-12-01 @741  	u32 rtid = 0;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  742  	u32 iscsi_cid;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  743  	struct qedi_conn *qedi_conn;
8712f467d4a560 Christos Gkekas  2017-10-14  744  	struct qedi_cmd *dbg_cmd;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  745  	struct iscsi_task *mtask;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  746  	struct iscsi_tm *tmf_hdr = NULL;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  747  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  748  	iscsi_cid = cqe->conn_id;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  749  	qedi_conn = qedi->cid_que.conn_cid_tbl[iscsi_cid];
967823d6c3980a Manish Rangankar 2018-02-26  750  	if (!qedi_conn) {
967823d6c3980a Manish Rangankar 2018-02-26  751  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_INFO,
967823d6c3980a Manish Rangankar 2018-02-26  752  			  "icid not found 0x%x\n", cqe->conn_id);
967823d6c3980a Manish Rangankar 2018-02-26  753  		return;
967823d6c3980a Manish Rangankar 2018-02-26  754  	}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  755  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  756  	/* Based on this itt get the corresponding qedi_cmd */
ace7f46ba5fde7 Manish Rangankar 2016-12-01  757  	spin_lock_bh(&qedi_conn->tmf_work_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  758  	list_for_each_entry_safe(work, work_tmp, &qedi_conn->tmf_work_list,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  759  				 list) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  760  		if (work->rtid == proto_itt) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  761  			/* We found the command */
ace7f46ba5fde7 Manish Rangankar 2016-12-01  762  			qedi_cmd = work->qedi_cmd;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  763  			if (!qedi_cmd->list_tmf_work) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  764  				QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  765  					  "TMF work not found, cqe->tid=0x%x, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  766  					  proto_itt, qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  767  				WARN_ON(1);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  768  			}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  769  			found = 1;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  770  			mtask = qedi_cmd->task;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  771  			tmf_hdr = (struct iscsi_tm *)mtask->hdr;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  772  			rtid = work->rtid;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  773  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  774  			list_del_init(&work->list);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  775  			kfree(work);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  776  			qedi_cmd->list_tmf_work = NULL;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  777  		}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  778  	}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  779  	spin_unlock_bh(&qedi_conn->tmf_work_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  780  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  781  	if (found) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  782  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  783  			  "TMF work, cqe->tid=0x%x, tmf flags=0x%x, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  784  			  proto_itt, tmf_hdr->flags, qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  785  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  786  		if ((tmf_hdr->flags & ISCSI_FLAG_TM_FUNC_MASK) ==
ace7f46ba5fde7 Manish Rangankar 2016-12-01  787  		    ISCSI_TM_FUNC_ABORT_TASK) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  788  			spin_lock_bh(&conn->session->back_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  789  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  790  			protoitt = build_itt(get_itt(tmf_hdr->rtt),
ace7f46ba5fde7 Manish Rangankar 2016-12-01  791  					     conn->session->age);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  792  			task = iscsi_itt_to_task(conn, protoitt);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  793  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  794  			spin_unlock_bh(&conn->session->back_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  795  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  796  			if (!task) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  797  				QEDI_NOTICE(&qedi->dbg_ctx,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  798  					    "IO task completed, tmf rtt=0x%x, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  799  					    get_itt(tmf_hdr->rtt),
ace7f46ba5fde7 Manish Rangankar 2016-12-01  800  					    qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  801  				return;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  802  			}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  803  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  804  			dbg_cmd = task->dd_data;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  805  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  806  			QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  807  				  "Abort tmf rtt=0x%x, i/o itt=0x%x, i/o tid=0x%x, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  808  				  get_itt(tmf_hdr->rtt), get_itt(task->itt),
ace7f46ba5fde7 Manish Rangankar 2016-12-01  809  				  dbg_cmd->task_id, qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  810  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  811  			if (qedi_cmd->state == CLEANUP_WAIT_FAILED)
ace7f46ba5fde7 Manish Rangankar 2016-12-01  812  				qedi_cmd->state = CLEANUP_RECV;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  813  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  814  			spin_lock(&qedi_conn->list_lock);
28b35d17f9f857 Nilesh Javali    2020-09-08  815  			if (likely(dbg_cmd->io_cmd_in_list)) {
28b35d17f9f857 Nilesh Javali    2020-09-08  816  				dbg_cmd->io_cmd_in_list = false;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  817  				list_del_init(&dbg_cmd->io_cmd);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  818  				qedi_conn->active_cmd_count--;
28b35d17f9f857 Nilesh Javali    2020-09-08  819  			}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  820  			spin_unlock(&qedi_conn->list_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  821  			qedi_cmd->state = CLEANUP_RECV;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  822  			wake_up_interruptible(&qedi_conn->wait_queue);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  823  		}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  824  	} else if (qedi_conn->cmd_cleanup_req > 0) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  825  		spin_lock_bh(&conn->session->back_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  826  		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  827  		protoitt = build_itt(ptmp_itt, conn->session->age);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  828  		task = iscsi_itt_to_task(conn, protoitt);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  829  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_SCSI_TM,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  830  			  "cleanup io itid=0x%x, protoitt=0x%x, cmd_cleanup_cmpl=%d, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  831  			  cqe->itid, protoitt, qedi_conn->cmd_cleanup_cmpl,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  832  			  qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  833  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  834  		spin_unlock_bh(&conn->session->back_lock);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  835  		if (!task) {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  836  			QEDI_NOTICE(&qedi->dbg_ctx,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  837  				    "task is null, itid=0x%x, cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  838  				    cqe->itid, qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  839  			return;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  840  		}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  841  		qedi_conn->cmd_cleanup_cmpl++;
ace7f46ba5fde7 Manish Rangankar 2016-12-01  842  		wake_up(&qedi_conn->wait_queue);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  843  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  844  		QEDI_INFO(&qedi->dbg_ctx, QEDI_LOG_TID,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  845  			  "Freeing tid=0x%x for cid=0x%x\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  846  			  cqe->itid, qedi_conn->iscsi_conn_id);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  847  
ace7f46ba5fde7 Manish Rangankar 2016-12-01  848  	} else {
ace7f46ba5fde7 Manish Rangankar 2016-12-01  849  		qedi_get_proto_itt(qedi, cqe->itid, &ptmp_itt);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  850  		protoitt = build_itt(ptmp_itt, conn->session->age);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  851  		task = iscsi_itt_to_task(conn, protoitt);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  852  		QEDI_ERR(&qedi->dbg_ctx,
ace7f46ba5fde7 Manish Rangankar 2016-12-01  853  			 "Delayed or untracked cleanup response, itt=0x%x, tid=0x%x, cid=0x%x, task=%p\n",
ace7f46ba5fde7 Manish Rangankar 2016-12-01  854  			 protoitt, cqe->itid, qedi_conn->iscsi_conn_id, task);
ace7f46ba5fde7 Manish Rangankar 2016-12-01  855  	}
ace7f46ba5fde7 Manish Rangankar 2016-12-01  856  }
ace7f46ba5fde7 Manish Rangankar 2016-12-01  857  

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--wRRV7LY7NUeQGEoC
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

H4sICOxteWAAAy5jb25maWcAjDzLcty2svt8xZSzSRZJ9LB147qlBQiCHJwhCQoAZ0besBR5
7KgiSy49ck/+/naDLwBsjrJIrOluNIBGo18A+OMPP67Y68vjt5uXu9ub+/t/Vl8PD4enm5fD
59WXu/vD/65StaqUXYlU2l+BuLh7eP3vbzf33/+8WX349fTs15Nfnm5PV5vD08PhfsUfH77c
fX2F9nePDz/8+ANXVSbzlvN2K7SRqmqt2NvLd679L/fI65evt7ern3LOf159/PX815N3XiNp
WkBc/jOA8onR5ceT85OTkbZgVT6iRnCRIoskSycWABrIzs7fTxwKD3HiDWHNTMtM2ebKqomL
h5BVISvhoVRlrG64VdpMUKmv2p3SG4CAWH5c5U7K96vnw8vr90lQiVYbUbUgJ1PWXutK2lZU
25ZpGKkspb08PwMuY5dlLQsBsjV2dfe8enh8Qcbj1BRnxTC3d++mdj6iZY1VROOkkSAZwwqL
TXtgKjLWFNaNiwCvlbEVK8Xlu58eHh8OP48EZsdwVuMAzLXZypr73Y64Whm5b8urRjSCGNeO
Wb5uHdaTvVbGtKUolb5umbWMr/3uGiMKmRDMWAPaPbFZs60AUQN/h4BRgpyKCR9B3YLCAq+e
X/94/uf55fBtWtBcVEJL7ta/1irxBuujzFrtaAxfyzpUo1SVTFYhzMiSImrXUmicyPWceWkk
Ui4ipn5G+fnjSkXS5JkJl+7w8Hn1+CWSRcyfg9ptxFZU1gzCs3ffDk/PlPys5BvYDgIE5C1Q
pdr1J1T7UgUDBGANfahUcmKVu1YyLUTEKWAh83WrhYGeS9gZ5Pxmwx241VqIsrbA1VkENzde
N7/Zm+e/Vi/QanUDHJ5fbl6eVze3t4+vDy93D1+j2UKDlnGumsrKKp+GmpgUVYgLUHHA22VM
uz33p2SZ2RjLrCFkUhvpk8LPcRen0rCkECkpgn8xKzd7zZuVoZa1um4B5/cNP1uxh/WjbJjp
iP3mEQgn6Xj0ekagZqAmFRTcasbFOLx+xuFMxr226f7wJzLA3JoQc5GbtWCp8N1DodDSZmAH
ZGYvT/9nUihZ2Q2Y30zENOedgM3tn4fPr/eHp9WXw83L69Ph2YH7QRPYyIUB/9Oz3z0TmmvV
1N7QapaL1mmj0BMUbCzPo5+DeQ9gG/jH09Ri0/cQ99jutLQiYXwzwxi+Fp4Hz5jUbYiZPGEG
7p5V6U6mdk2IXtvFlh28lim1TXqsTktGNMpg238SerldKraSC6IlbCPcsKQDHEYkdHYMn9RH
0c5OUxtK8c1IwyzzTCJ4blPDDjCB77SmrQzZE7hVHeEG3ZEpIHw2lbA0KawH39QK1BGtLwRP
gbjccrkQxY2YHAY4ZFj9VIAR5syGdmtYflGwa58v6iMsjgtkdEqyTZSybfc3LWfeqhqchfwk
2kxpt15Kl6ziVNgSUxv4YxI9xhTWCzRcIFJzU2+Ab8EsMvY2U535c1m0nSVYc4mLFHQEspoF
Ntka9o7vHrsgrHOFHtRZJW8gjWcKRJGBuLTPZHECzIAUmmAEDSQI0U9QI499rXx6I/OKFX6A
7wbrA1yo4QPMOrBJTHqBvVRtowO3y9KthGH2svKkAEwSprX05bpBkuvSzCFtIOgR6kSAamnl
VgRL663OpIsABvUuFKN1FRfZOe+M0v4NL4PoG8Yv0pTcKJ3iAbN2DNSGxUQg9NNuSxic4kOY
0yeA9eHpy+PTt5uH28NK/H14gJCAgSviGBRAzDRFACRzZ6yoLkaH9i+7GRhuy66PwYF5fZmi
SboO/dytrJmFLGwTGJ+CUUkDMvDZsQRUQoOz7AOoCIdOopAGzBvsMVUuYddMpxDABOraZBlk
d84RO4EwMI/BXraidEYcM1iZSSCQyssQIA7JZNFp9SjJMAMdtb2o154vuHif+IlRWXqx0hjP
M0iqNFhcmHhnXnuCTxAFt53HjBMIw0JEnVuMNdsCVgv22HmQablUbNAz4+KvMW8eF8kNfOiA
3BwdBSvAOB3B74sjSPAFm9NjzLcMgnbwZUdoOEsgQykE7fQ7mrQ+u3h/BC+S0zfwF+/r48MA
kos30LSb7fEyF8fEWOyPj7C4rvZH0CXToAjHCCSo+1H8hpljBBUEE7Jo6IimJ1EYCh0XY6Ug
bGUbcYSk5sdFUZ9tjmA1261lSoUSPR6Mg2RBFtwj3lgB8xYeN+QxPFiqYwMHqTB9bAUsCK46
gt/JIs2kpqYO9sNz2Z0xaZkfJvRauv0Qg7hkBNVFDKuv99LMDdd6B4q/tnNpX4myodYIi0gl
ux4iuTZLedAY8RBsayMgnGhFFQt98GNCJwo8YunC5GlcIbwFo38aVEPOz0gBA2Zh7QED6eAS
6uzDBTE4bHNy9j4qxJyenZyQxJdIPOX1OOut75gCCz9GBk1ZXrvaqirG0srgwm6ebv+8eznc
YoL7y+fDd2AEIcHq8TtWob2Yg2tm1lFwaiAhybyVdgvl3B6sLASXmHZwrKzMlcGUtasmtXat
IaH3VAhX9fwMeTRYeGkzrFioVETdYPm4VGlfgTWBn21zZteYVykMGHIRcXftq1J2pQEI7PZ8
nUc0O3BGrQSlc/o1VrenooNVQ6XKH9VWQpYcFqFwyhEVjHvQXsEx5vBGr9KmEMaFcJgNYHgb
btekMeF2VWmKuTlE84yHsYvC6rPMTQP9VGHG3gVrnZwx6l/afyDCvjDnRXowP4ALMJ5cYoCY
ZUGeijVKP3QM/ESnfFxtf/nj5vnwefVXF5R+f3r8cncfFPSQqN0IXYkiiL2OtY0DtDe02ytt
lJgtCU+PXHZhMIq+PJnm1q8PlSn2K2dBXCACtfHrNAnKJCzlGG4kLO9VAxl7iMGkOjE5CYRw
cQ6HjFLk4Euvj6Bae3oyR2OYGSjGgIBtqazFuJc618BKVJni2U23P3TMYpdQyfRUwYJcEdI2
UfFZRWHEc2XoMK8bIiY7GbUOTrZgeVTNiph5d94ERpPr6xr3ykwz65unlztUjpX95/vBz7mY
BqfrDnvSLRYoArExMIzVREPtJrmf8H5TZbLjDUvY2EHTAWGZljTPknGa50RhUmXeoCnS8ujI
TL7QPSRw2p8u1bapqDlB2FMymqnI5BvjxROxi9+PdutprddDbzTitfc1qryCCESGGwhgaO9d
CaQ7x1JT0dhTHaCTqqvCpeDrwiNPD7m5TsKdNCCS7Io+Kwr6G/XCVKeey+hU3tSyapvKmebg
5KrHoxPu8cdwZFtXfV5q7CP71k5W4r+H29eXmz/uD+6sfOVKEi/PflqayCorLbpB2g50aMO1
rClr04UJqvGta9ckBMIGfN87xMBe9L2Xv9O5Xo8vpaHOKTBQgrir9vVracpuzuXh2+PTP6vy
5uHm6+EbGYJlYDKD6hsCWoyNsJ4Gmz48QMBzXGnQzgZbzNQF+PzaugUBV24u30dxAV/YPK6I
okWtdHi4BgZKR53AP9bF910JamCwvobYJU11a+PqSAKBAve2hQukIMaCaMezDsab/HDUVsK8
YQiVY3z5/uTjxUBRCdg7NcSBGLBsyiD+KQTYcAa7i1zbTMP48USGNCHhMQbYq9k5wRxLuirE
Mthd5nI8tPpUK+XVOj8lTeBnPp1nENSRXX0yXcWPSvnSoQSGp3ObYPFAPiged8bp95SDE47v
RIyavKysk+z9I2eB1x1yHWQCCBQRzGySVuwhLhhierc1qsPL/z0+/QUB3nxPgLZu/K66320q
WXCs2FRyTwjGFsGc4Wd/3ETTgkJ6KrrP/Ho8/gJ9z5XP0AGxsEzwczgMz3TGwvMthzFN0taq
kPx6qW237aIBuYWUxkpu4rGtI4AwdQSBfEf5V2dwiTbiegZY6Fqgk7E8qJPv09odlwnyBF0G
aiLr7riFMxNCh4irhdAwOEkFXCYT0Gop5ho8sKsxy8TaADmCumPak0LeGLHosH2tgGZQV3XU
CCBtuuaU+eixeDJGtdJMU63cDqpl0KKDwQ4CnS0bSr07itY21ZBDeaJxE1uIoyow4GojBV3h
69hurVzoskm9Pj14ppp4/ACaRrikIZ3qToN3lsOQwu2GFmqxAzoFjQflMCSwtx8BHa8pME42
tjYOodnOIZaGiThYOWO18nYY9gJ/5n6WEaOS4ILGAOUNDd9BFzulKEbrbrPOwGYBfp34xYgR
vhU5MwS8L03FYDyZWyjVjTQF1f9WVIrkeC0YdWFhxMsCQlElqTGmnJ4rT3OyqyShK/dDNJJI
ygEP2GGNZs1wJY7ydbI/SuFW4Q2KSh0lGFTlKJGT2FEKkN1RvI7GEaEHWV++u3394+72XbgK
ZfrBSHJT1dsL3zNsL3p3gQWsjMLAPsxUaBYB1V0xQA/apow638XdexG40w7S+dPACDhgq7Is
PnWOaQa/GcBHQxYOsJQ1VUnu2izauQvSDQC7yI6HSCOpzMqhZp0gsDPxwWhDFzzrHuIcrJjR
mttxmHmqoL3IL9pitzA5h12XjIyKR4LoMkinIXUxsqX9HBgxf/5lPVvCDjZzDx0Ue6FLMw69
afDeMkbgi04Y70TDBCCLWDhMGmgg73JFXgiRyjoq6fnEmSzswskkiGiGnIKJlM+mjqBh5i6K
R8CKc5k+L9107xm1SHQWXy/wkecL4KU2NtO8DSqnAWZoNaY3i0OdJtLfpVjf3P4VFK0HxjTP
qJXXyHDrSRB/tWmStyr5D6+CskSHGiyti9KcgqNhpKO5pQZmzU6J5Vyk7487QsZHRrBEhv1G
ytL1GW0TndKab6Nb7z2YWf9eki0hx/dvfw8QPLmQvIwwBQvnhrCyVozup0302cXv70MWHQzW
stsoE7I485cWfw0lgQi6PY8AMm4nrOd1jM82h7zBq6ZomebBhDpIK/MSdK1SatEM9IRbkEjb
zeQNylLT0UCP5lm5VJtzZsIE1ZQeRJ3i4oB+Pzk79eqPE6zNtzrwlB6q3JIpVSp4kH12v2cp
ZlHw4MeZv+qs2PgMti2rwdWF4MLWHgeu6sAH4m+IM64rOrhzaItnmBXtiNM0ChAAgOcbZOlq
f/bBJy5YTd3NqtcqEMxFoXY1q2aAuRYPiGodBLke2CU8RJ8+SaZZXorQ6vn4taLm5lOEoaCP
KVUii+CgzMfi2gfFMR/ZhJIeUDmgxB4C9FS/MbJ8ZEIg0CS5QR/tIJbeUWKU4xvDGUid0ns2
WQiBe+dDcC9hgrZV0f/h7s1KXC1GRUlek64ItMCvHxN1qsr4OBLPRgxX0J1Dvno9vB7An/7W
H4YEDrmnbnlyNWMBaVcSWx8Hzsia/oAOPM0ArLV/FXaAuuiX6Fj7if0ANFlCAYnmVlwVBDTJ
5kCezO6QIxiCvSMztIyeTk6OOzUYgVK9wL+CMv9jS60JmV3RnZtN0iNm/fC1WrhGNlBchUdo
cXuVxsUqBGdXSxjONoKiJ1RsTSxKLQU1DegPMEfGSRbRHcPCj3unRSbXvg/uZmff/P7m+fnu
y91tFJdjO17MWAEIL0mQBY8Bb7msUncpfdbU2Rz6ItVAku2OsG7OzwJH2oGOPPnoCeJsKR6W
2UYV8AF6MQdDXr+bQ+NHOqOw6oxmIfQcXuIbzeDeuyt7OjAFw/o33+DT1jmKx0X9Hl4l11aQ
mE64c3gp7Cxe61H4OHlBrsMwWCXT+UwZtzFLAHWHH8ubGknwwtNCl4gupZ7ZK4QbyIKL2QZE
TMWO8atF99J11szIcqlo79CbRARvZAcEN01J8YPhUbXwAY2x7ZxZVMTwOi8VVXsaCGRGiqKr
fOBpz5G2OYv1B7i5LgmH0KPQhi8fK3Q0vdlYJLN8OCo8YiwzmXleJOWec00rgy+lFD7g9rIm
cOzM3e+hYMOfQVHbRxdU2uIRpMySfCu+wLHEg7A3eI5lhh6nalFtzU5aTlXEt/1RnJdC9ZDo
aGMEF5Aqhg8LuysvFKsQMT0xntalkNUm6gl1PdYUhLW5oYrEDjWL0x1U1tShU2U8c7k2cbzh
JAWZWwguzsH+GqwdB6grbXX4qzVlGkFgEBGkXMtoTNz4ELwIqESJl5PaHKfPAo3ob8Rhw3jv
zCl4wYyJraze4z2K6zZ8/pVcjQ/w+xP21cvhuX9UHaxHvbGQgJI3AWYtI4R/aD8xXbNSs5Se
i2/b4Aeeo4WAhIdXOTCXoQIFRPzn9OP5x7C5NN3JazdJSDrSw993t4dV+nT3d3BtC4m3s+Fs
9zx8MYBAU/CF6/jc5cnbIzi8yNhdOqAfzBNDHFcwvLCEj69EulC/BaWmnanDLJTaAFeabMGz
A3KqAPhNjCiy+OqIk3Zy/3p4eXx8+XP1uZvQ51jmiXVXInwttf2CT7/XXCa2MUnU7QB2T137
O8/0sEfKJc5taTdL3LWl39YMNIbW6w7dMG3jHhHWrt+T4ISHh0oeitn1OV3294icMN8iYvnF
nro+0M+Il2cn5/uZnGp2erInhJSBkBaZpbY4nUv8nM9gRSM40+mc/xb+o9mXehvqDQJaXI4A
6uQW0tlNTzVuukVN9UrEGdhVTZeiM3wvOvVhrBasnK5K92C8uqKbwr90vpNaFEGGN0Aw2PGg
WLkJH2M4EH41IQKZ+npGJD2nxrMcKyyngRN29Z1Td/wE0SP5GLtvhrZLFAqv2e2YrsAtmzlv
d88dJuKeHOM9HpGnCUGGrx66G/8dCYafFLvheCKqpU7oxRt3AwnXKWtNU+NlRqKDXSDtAIw1
r6BRIZNBgBEkPo/qi1mnc4j7nITmBEJzvNyIGlTQ2PEe5L+hunz37e7h+eXpcN/++fJuRlgK
P1oawegffEGPiGVB+yzNcPNweEVLsgHKinoGNlJBgotiwjdh++7t//itKZ1tpB/adL+HcYdA
WdVN4Dd7eF6Tdhvjn49R+vyxni5+h+D4TTSTWfiLosDGQZzpgJGD46Jet/QXmKrMUxz4ARF2
Li0rQmDlX1/vAW3ojxC65sFHbRBk1mnBZ868Otw8rbK7wz0+Hf/27fWhrxutfoI2P/d203Pt
jpP/qSUE4E46PTkJgSjbhhXzEWd+9bwHtPIsmn1dfTg/J0CxRCcEsKDFGvmUAdJzmkFnwnTg
2QCNnU+tg81pq31NrFwHJDifZztdfSCBPbUXoP+r9Rs41WPVxNP4rnYwWD3iEsYAi7+00qNT
mLa7hT1xgVQGdD34WIRL1PC2emmiIifsGkwpJ6C75Bxeoc6YLNQ2fFgh7NoC0ZCSznR7KSXo
X6J6y5EpzSNQ/KP/GJgJgcQXKgDsLtcnDfk9GMAyU5dxC4RRJd05UY2VRgNT+Bdk6BvnxDPS
6Xst8bDa2lKVf5x6aSIBzb6aFuHcS8QMpIWViEiOGFdsTNT74pd7nOSt/+0JhDAbMYXYM5Zz
K9V2gSHEU2HzmnUp+JTvQspZNA450zWE3T4+vDw93uO3pqaUKOg9s/D/U/JVMKLxq4GzgsuI
mH3Vyy3QHj9rsZ+tWyk5BJFrWbu2xNZ4vvv6sLt5OriR80f4w7x+//749OLdykdG6S7qMN05
lnOoqOcw/OINDV1g4lARJ4w+wjdex4bfvcN5/AMW4O4e0Yd4etMDiGWqbuVuPh/w+yoOPa0u
fveOEhVn/8/Zky25jSP5vl9RTxszEeMxSd0b4QeIh0gXryIoifILo9qubldMtV1TVd72/P0i
AYJCggnJsQ8+lJk4iSMzkUcUI/cXE0qNV6MmM6cRxPSZqEt1khP5cRX49h5XwMkymRDEyAvq
+tSM/nj0zhh3Tfzty/P3x294Mnsh9ctQWNaOHqBDNKpkcmLEdeKKAarR5fBabHRv7MLYqde/
Ht8+f6V3tHkIHQfdYxuHdqXuKgx2sMt71z0xCM7j7wLFbVC/e7BI7UPTJhqKKXerYTDvPt+/
fLn57eXxyx8P6EA6wXs/1XS0XAWGui1bB94GvdIJyGxJWYm1IT6fZB+toJ9qZGCHJp1cDPqG
1RmS8wcAxGEMpekjePzNDD9uTaCiRoCGtO0kN0pN6VhbwUSBXYZtxUas4845N7Uv1IPptJ9h
WpiKRg0uoEd9qIQDFRPy/vnxC/h9qjUyWVu6ZMuzxaojGqp533VU96HEcn2h/1BU3CTBtNKm
k5iZuZAdHT3Hnnj8PPBXN9Xo1DV2aq/CB6RxXjsMUsWctEVNyp5idZQRyy1zxbpRdSZZUxxZ
E6vovJP7LXl8+fMvuB6evouD6sXwvjzKPYMUOBok+c4IIkyekXEnRN6xNSPS77mUDP6nxkhV
aqBH7scc0ZkS7MTBMIBUINsjGnVBEOICjNYMX9UBBY6ERwfOghofRGqym+zg/GKDqrshPbEU
Go7goZK+iYvqgL9h0d9V3LCNJhtS6KGS2hnaeYzBVe/7wz4XP5g0DstMhVwT75BfrfqNJa8B
JhjibAIsCnQsDaVNJ2o4VCAekFo/CRZUAJnIW1nGVSW/r2M3KY37j9epJF6kGfarHQDT10SN
gBuLDA+m1aVGM+N1UgnBL0TR1kA7eY5bN7ayKzmpQmpHC6+zZ/7z/csrdq5vIZbKSnr0YyWV
QJju/o4m+ioZyxpQ8Tlk8MoLqChr5PhOQ3SPd76zgn5fDsHncNiIKSH42ldlfiKneToNcnb2
4r+CI4UwACqUX/ty/+31SUnz+f1/JvO1zW/FNrSGZYUoSVokm5ZJSxr4lUmL9G5RjwCcW0Gb
eNEnjgcU+TGq2vWdah3Y1IBZQXOBSgd2ENtJPeGONycr3jdV8T55un8VzNXXx+fp7SnXTJLh
Kj/GURxarAjAxYYYORS86pJMPs5XMsSIazxwEGxZedvLeLu9jyu3sMFF7Bxjof3MJ2ABAYMH
IqTsHkdQRLydrFbAiPuV4v40GmLDWTuGFRagsgBsy7XFr+Yf3J9LyWn3z8/wuDwAIZiCorr/
LE4h+5tWoLvqYN7q4YUCjQoCExSkybTEhtaKsFnqM6xngjs9FdV+0oSc6P4AQakoJxpZhRC8
mkHxoOXMK6NUYR0fnn5/B9LC/eO3hy83oqrp+yoebhEuFpTvh9xTeYOVH2qCBNC1kNvI/sDi
d99WLcuVnt4MyjBgxWUL4ZUA6wfryTkUGId/9Pj6r3fVt3chjHuimUPdjKpwNyOPzutzpJTa
gnPES0ecJAC0J2QAq6ChJxXlxH2qDcTEFUpQWY7hJiro4MTZWd8CXyfs2APthLGNw1BMxh9i
+IYSAhWVTQgyEE5TJjgXh+OHTbu1ozzqeCdEi6P2GSZadiCvo6i5+W/1byDEzuLmTxVegjye
JRneenfgx2kcxUMT1yvGQ9pvqYdlwKQnwYIjjqlCtnaChQCW08FnCuxttf1oFpaxStAzr4Ah
rrBKhhAaZiOgxs4ZZZCnYiVCeMUxWqK4CYd3yjP7rEC0+rd0uPGogGDT559DEU8VfwDV79J2
FRJJm/RBqTEAA/UUAwTpEZuTASyBgLBmqAsFRSyHBLWs2dlhY/VSNEei7pbH189TtlncULxq
eJ9nfJYfvAAHAIsWwaLro7qip1fFYITkHuTkp0IWq6gDts2Swnrol6BV16EXezEJm1nA5x4d
YleIEHnF9/ACHzeErdFAlgrZJKetM1kd8c3aCxgdpoHnwcbzUOoMBQsolbWeylaQLBYeYhAH
1Db1V6tLZWWHNp6h40iLcDlbGExOxP3lGumfOH2NIQ1hiwLyKS15z6MkNp/nQa8k+HWj9fpQ
sxJ796cZz8RfEDGFNooJg2GLqhM6FmdYQZ3OCtOzNqAN5gd8Hu8YGS9mwBesW65XxvPgAN/M
wm45gQrWsl9v0jo2Rzng4tj3vLl52lqdH0e4XfmetYAVzH4IPwN7xvm+UMyznpv24ef9600G
tgs//pQxy1+/3r+Im/wNZB1o8uYJLpovYus+PsN/zflrgWklN///o17qPBgfV/VuAcdJBpxy
TQs7ghU43lFva3GYIheXbVj0B8phQS5BGZHbYlD10hzA5ztuRNCLMWVCpBAcbIYYUPMoPFOK
KyYzQ7KqH0pWf3q4fxU3/oPg0r5/lpMqJdH3j18e4M8/X17fJB/79eHp+f3jt9+/3wgxFcI0
y2vZOHAFrO+SuIHQmrgtUOliSyMAshbFRQWQ2hHUZQRY7oqDDcgdaTx4Lm3eOhocxfmt+YBp
kIu+oUtRjoLxW4h06RCIgUSqTJJpBFWYLxAEBEDvufe//fjj98ef9gyeH/8mc6CzSlweqFRQ
Jcn5XSAzWyeetIyyaGWq37AsQadUNdE0bigUq5JkW7Hm0vRPHjTHsuLUWAY++QVgHJMYjtJp
Nw6XQdcRiDzzF92M6qSQjlfzjvZQ0DRhES3npGGlDrIqZIcce0eNZU/rIFxuZhcbSOt2tqRi
gWiCj/Ixl1iQdZaRzWbt2l8Fl9ZDuw78GTG/ACemsOTr1dxfkKsvCgNPzHtvRbRzkZXxcVo/
PxxviY3Is6xgZuDnEZGHGy9eLqeYtikEuzKFHzImPkVHrY82XC9Dz/P11qjevj68uDaH4pq/
vz38z82f38URKA5XQS5Oyvun1+83Lw///vH4Io7N54fPj/dPOrTxb9/FpDzfv9z/+YBTgOgu
zKWam5gBWLtzqtNRGwbBak19kbRdLpbe9uKau4uWC9paeCDYF2JWVoFrC+q5gvDHWgSfnCAy
NnJhxqxqWBZBVkKUhQS5UcgyKDGGhAwmPogJBLjrYJX9Gjp08/af54ebv4m7/1//uHm7f374
x00YvRNszt+nH4IbnQ3TRsFaArYjYDjVouxfKF85S0f0F0mSV7udS0aXBBw8DBg/lVPrPTnM
VvM4r9bU8zqjJlsIViQ4k39TGA6JPh3wPNtyRhewPyJApSULyuypUE09tnDW9lij+y88bUeZ
KgXLKoBp6Yh9Eid19DL10/RTdbvtTJG5vwUQzadEJsm27AJFYY0REJ2YfDP65DYOLFK9EmfH
XpxWndwyVkVpze2pFdQbdLhp6PTbMNsiX0FT5i8C+iY8E8ypS0WhWUj0lGXhCnVrAMClymVQ
1yEv3NnhVVM0MZemgTk79QX/sPA8491fE6nUrPp1lpZ4B1IlkzjTS2CyQrB0H4j2mli+QLft
SWUAc86GoN/Y495cHffmV8a9+fVxb35t3Bt73JMu4VFPP/Jmjq0RBtCFkLrqbjhwRj79K+S+
mFwMdStktMruAARZ5KfplmZNWHBKTy+xsWg8QAkdd0xeUIJFUdkezkKXRhWk+lxjRznFRkx3
oRCMZyQ0gFNS2sbvkFLdLHUJHxCnccGatr6zJ3Of8DScngQKbBs50jSE5DEhhHwHboIUFATU
ea2OzD0X16MpIqgLLGc8tczD1PhPzXYKMiM0ZVvTzF7+NM/j4Zd1AZektn9gVbqZv/Htgy+x
jWBNqC3SI1zmyNkkibSxQxk2i9ma1KvJm7ye7gXI70i6RmgsUxb81tBbh/+2wp6KxSxci43u
vBeyupl2pW4oQwibBExTXNXeyWXRJ2w60AEltoZzfu5y1icoymoBsABdVQbQ1nKNlVh3910c
4V+JfX6Fs83ip318wSRuVnMLfIxW/sa+0amO1AV19dbFWsk0aD8leOASODrBWKxOGuc8q+SW
cE2kZsImb6mqs+kE0DcRs9sX0LTu+XEKjguCluV7NuESLRFkvMEQDwrpAbHF7JAwUCaQipvG
tHIBlHQLsCqoi7PbsWH2+tfj21cxRd/e8SS5+Xb/9vi/DzePkInx9/vPSIkpK2G0++OIIzKF
SnAYH5gFuqsaMzSRrELs5tBfBp0FlpyfLGUheJbj5FUSmNARWApKzFcPM/YTh9hBmWWQArAk
y+PMigFc9LWT8wYsWNFRh4yObDD0wK40IUOGKjFhUiDZcyqZDES4uvFnm/nN3xIh3B/Fn79T
6n3I1Haks7VpVF9W/GQu3ot169LKsSwLTQVBkWEHr2Hy6UdF6w1SQSA9mSOT44D3FhfxDTte
QlvB6yboqth4P3/+Agl5a+k+ZGKJEWMTRQOPfrWCKI/KqpDjJV+o5z26RwLrCpg8RJ5k9OIF
bFxSux0wsDCUX7F58hT9p0kczE+yg/j4B5DY6lwsZRIoPXH5vszc2CxqVyvxpe2pkPBgQW05
QLNiyzhnUWU1fIZTfU3FWfUJJz8agVOzRdkNV+xOcTjG4gvHuC4NlUMDvXwetw6KFuSatjl9
8JckXnXHQz21WktjxwTzKq+QST54jI5LzoS2ZhBDCUlNhkJCcHai6PH17eXxtx9vD1+0VTYz
0qMhYyHtLfOLRXSrMaTdQ8Eji8j2kj3EJXzkWWjagMW5oVOehQvfeKQcLKsE1OR0ztD1xvz2
h6qxOE99qJ/qtMIppYzusIjVbUwnvzXJdrFDajaJchaCPRAZggfRtTHukOBsLYnBflFs+fXm
C/bJkSELUdFh3k2Suz2k5KWlCpOuuT5vsDAqV1CrgWjbVCxSy+Ksdp7PiULbsACBxgylUXaG
yjksUSqEbFeVM/u3bU8ilWyIl5W5oW2DmTM1br0dIrnpaO8WEoWfkhDdPDVdYibAG+vydJ2d
xs4cFgtp7T0qdsj2tOBtUike/ipZ1jSOPMCIiofXq5JppahTOyrtZEJDkcg0yZBxwfZ5Zjkl
BL43pwVRSUw1F8874/g5ZuW2KqN+PTceh6Ji43vGghNVLYKl5UwpD6gua8Lq6nRHthvylCQu
9uqtUC+iOLC4MwVRC4tasgot/rErEf/MJrAcvHobon5+e0rZ8VpvP4ELqXHAy999WYMKqhTH
KMSM7WNrBEYFyf5j1vL9tYnbVdXOEdjIoEr37BjTXJZBNQmWM5B8LCYR8oYSKtW2Iz/ASCQo
WFkZn67Iu3lvZoUdAPiUkEAsF0mQHVREk2nnrPNpkHcLF28vcPw4rX2A2WejgYGDvMCZNRW2
JgVThUPuMgpUCFGzMGNUCHBydM1zFjaOOEYWlfRcvvI9gIzHpoq44GHYV2GcVzokHE4XMMW7
OnpqqFlIYpaXHXmGlawd+nKuT4GoUfD1bB14jsbFf+OGTt2HqZqqrAozlEOCE0slNQQyHy40
qraBgG2lSGCXdTlCmp3AA876DiLJ44Ph2udezzbeNZrykEWkJGDQVLfGShAcbBU65nfILac8
QK/wMnVccib+Z1YlPg2pDjaK3VlK67uczZBu8S4PrRlXEDg6yMkY0JNLwRxgJ44eumt3ZvxU
8aPP8wABYoyeqjWtZ0uAVBUtEgh2M4cYBmh0IVgbWglcRmxTWOtkWmmD/Y+apTenZHuzRAy8
tqF5WvuzDc5qB5C2olmaZu0vN9fWZSMWOP2CZRJBIE1DTB5/UzVyVghx0pnaZSSLY1cgbE1R
5axJxB9Tf4lUvxDYpo0sQBiBxUZJQAczBYxJ4FMj9vcMhdqv9DFDIXB5uAm8me+amewqg8oL
flWE4VUIbmXOkLOarJX3CxpZW0Dek7hNr7axv3J481NZ1daDZXQM+y7fufaIUbqN070j25NJ
dZXicO1IPWafLM5OQfrjwophMiWYOQiM6pVN9nUqJ+edRBF1vQrWwTQgBXG0gfBFaM+doYJF
biAjLliiErXV6QkxEfwoIGZNuTgL2ybb7cBNOaXstpOsi6V3mtbhFFl2A6Su+JlCqu+tVlgE
74Zk9VrAH4poaLderzbLrV2RFs/tys4EYbGY+3PP0ZpAS1MI1JgArufrtT+FrghSFY1Wz+vY
cJgJWZg5mh3kSlxXJITgYShnYBbWOTg7m7C8ay0i6cfXHdnJIgS7gNb3fD/EiEFGoIG+t7MQ
ktOdwlREHuuLnBGt7xj9yOziKkuZr5nldo0QWaz9yHxfTT6pQl17s84ud6ebIEoM96ldZLgC
XYXEXWcMWW8hcU5bkDb2vc7M4Bg3TKySLOR2g1ENzHPgaBCwbbj2rZUoC83XBHC5IhtYbhwN
HLI25jy2Cw3+JTuxs4MG/qY+ogovIu1+kGa1t5zSLHWrLtfgvHuqZNZuWUmx6QoNL2cgoYVW
dUp9NKlOurokNqNmUhQHFDVPwUCuEmMuLHgVDppRE5jVd3PP30yha285t6Btui+js+83wG6K
H09vj89PDz+xT+EwjX2x76aTpOCu2JCIRic67PB1gWmKTMjQaNIHm3p+wWVXYPsOSNChOwYM
mhQdL6DaDOIk5LUtj3BqXABGMaSRx2E2QPhzpfsDZFHXkwJy/LYay6SoGB0RTmBi1KUKZ0yD
yqURKwYBZHgFOXNatEaP56lRGII4y+CB9rsKIELWWqS37BjjrNAArSHbKhl/aYgRvfYXHq5I
AQMMFHzsam0KeAAUf5DKU/cYbmZ/1bkQm95frdkUG0ahfJixxzDg+pjM0WNSlGY0Y41QSjU3
HhDFNiuoZqNis/QoD3RNwJvNyvOmlQr4moSLo2S1wLaEJm5DG61rkl2+DDxi6kq40tceVSvw
CrTIrSmKkK/WM0ra1BRNGWXcsiwxp4/vt1xqHMAG8xKJ3UGWC2lssZxRr7ASXwarYDKsrXRf
chVpCrG799bqi2telcF6vbY2TRj4G+IzfWL7Zs+JkXTrYOZ7OMGhRt6yvMiIj3MnWI7jEUfj
B1xKZo7QpQQDt/Cx86zc+FE4ZL5zlM3qlDgHeBY3Detd6iogOeRLh0gzjj4V8uuldcLuQt+f
dFkdKLM+Dqn9e8zxzMDv82tnITgykrtLJ2EkUUE8A0Du0vYJ3OLWIl7cXia37RsFcEPfJxID
abMpjp81+cZfoeWtYZNcBzb+iLI1amh6bEpkkpAub3OrpwLSO4L/D1grAPEAdc5Is1gEyPns
mIljyqdNU1Lfu0UdFL97/Do4AGlF/YDE4fIH4LTfAL3wJUd0womCvI7DtiETBh7DcrY0r8MB
MM01CXX5t/bvnqWTrvqTIdtot7E5XvsF+Txk0hhP2AN2O5+hHz23ElcIkGAPYw4sN8SPiYCC
lq8RKSVhjwTcZLUBLMPcQl6MOI/DdoKTTzsIj1p15bSAwtgeT4LSU08tDI0rreYFKK8xDEdu
B4jegagl94cTWKc3/LYJiyFIkaHcCAtOSy+ASpAgpCHgRNaCrBS5kQXfobCAI9pKTKHBSEg6
1xVmMQZTAfUBHm2pqTfXqHyNNzZO1li/+hDtWrOs64nUpmk4nl5gccj4SvCaiKVTBQF/EU5m
DlZoGTUcIiBWpTRQN2SDvCNqbYtogNJqQ7AaygkKXal6zB/rxWB1oO2NXV81WVmFFf6a9WI+
jdEsYNbxCiD6jAaMnYtBztOCMpIxv8mgbzLUVdk2blrGpxDc5xEaUqR4DY/giUHeiIEEE0RX
R3ybZiU4JxGVapT9/j0lwHqGY5Zkpt3EALD6rqF4o2mo9YWKY76m2RI053GUMZrNQmRaiWdc
elke+p4p5miI1esRnIqNUG1h6zWurSsuXJdwjsiUtu46ncPk2qQhwyGZBK2hbT/mfrDw7d/2
gAUQsQe5v8a/raQ48vd01iAPnbaUh8R8zCxy7t+nU8QsaeVTBNbP5iQDxPcbKgWZWZfUtcdl
aTR115b4YhkAehXatkQNO9laIExwzGcLh2n2OdPMkWeX5H0lk9rSA5iS9rAbqFGab3GinFz4
ZwhkD0EHvPhtm4BbqN6StCR8YkVmIpMGNzgov6QarftnsHgvk51rv25RyZfH1/vfnh6+WIH2
hRzGT5QILAbZoStNAn7Fn7IOZ57nei0uKQld7Gm0whLW2E7cA8bIoU1YphvYhN3GORX1xaBh
dlI1A+daNYeiE4vGTLciXQ5wohexqqgsHBmPHCYJB9SU8qX49vzjzRkwQCf1MX9aTKSCJYk4
l4shxda5JxLHZYKu28LhfqCICtY2WWcTjXFYn+6/fTm777xaPewhMmSMcv1gOKRZMVUsFpaH
TRyXfffB94L5ZZrTh9VyjUk+Viei6figgNY444PFWhtfwR2EUZW9jU+TCC7/x9iVNceNI+m/
orfZjdje4U3wYR5YJKuKNlEFE6zDfqnQWJppxdqWQ1Lvdv/7RQI8cCQoP7RblV8S95EA8rCb
EYq7gouy8qGtsM1TMQxwJaZ1ufqtbqqqpioN81QdbBm+J2s8+/IgZvcOTfzjRvxAkfFK2MF4
07dlJ9YLIfslbkMPx1O1V5221l4tGpK+p62tIyhJljsqSeMUm/8S2gaxlYCgyIIfLXpUj36v
bH49qtlIiWxKHDiF2sa4R7MRxE65CkoTO/U0nRb8/f3Lg/R43v79eGf7tzArhThOtDjkz1tL
giSyieJf28WiAsRGwjhq2SphIbIK2E7NCHSqSKPSP8IsSPDg4mYtKnSz8rY52GatcPDWZeZ4
slpkV9LGDIE3UW4HnqaGa5kZ6bAjyow29BQGH0MkxS0l42Y4PnhhnTsbxWGbhFqffr9/uf/6
BrE0bL+OhiXNWXfZchQDvZOu1w+8Kyd/dDPnxKBJHheNtshOgwbcNq0QsNCH19OhvRbkxgY9
5qG6xfASRbKnw/CPKM2005aMegG3OWCI4Kzh/PEFPAw5uiPjOtWUffe5snSzFESiNHCSOzz/
+E0CrypdKWC5Hn1UChAirWvN10YLmhrKM0B1zkMv/+b/CC0Oc0XUiG6XjeAHTpEycSHwesJl
TRxVdbiib44THmYtB10WtEwz7EfstXzENxXNYvRNa2QY144PQ7kzA9PhODZw1zlvm8+sRD33
m9+t5S7To6WMqMn/kawwbcpT3cM7dRimQkhf4fRXZNS1YFwyrnWrZdJkgj2LnPoI2jIcF98s
I7rl3a1jaEMs0ErBJVN7AGdx75W8Ah1FGdmj3bWVWAFQLyaKlwo58UsYp+7gY3oEIY1olHF2
rW2sJ06JVLyeQ+0TCHfHrt62fA8LMaZWeNtx/TBx/HLUVfcPp64zl3DpIELGiNeVZxWVG9EC
9+dqPDYhbQ6yNB5haQx07ywlLaMtyI51p2csqTKm1njPsEh2EgGnsSooBibrAovS/FH3qtuy
snPUFa4VgetRRyXpUkKY++POLhYo+B+3GrfYqHrQWzdWw5koQykJWYA2uF7lwrgpkxi/iFh4
VDtiJ/qZpaoG4+FtQa7wHttr1wz10OnPQYx1rXqIGTVs4ILk7qtfDIATtrwXMm+/wfMBLQ+3
JEBfaBdYNw8T4nyU6Mc4pgV21lR3PGVachdd72trAX30YXCF4kbiWT60pdahEv8x7Hwvlszu
88YMZzDR5DXVyjeTl/Qp8NtKPafh1Z/4IF2tqcBG7vkzqpDDv25dJH7c5OETnMKbZNB90qPi
SdpesFrnX0GmJ1y9GLAxIhPIV9iMFRzipLXEUYMil9/+/fzy9Pb791ej1GLb2h03rVUkILJq
ixEN9yVWwnNms4AMUXks/5OsuhOFE/TfwQXlWpA6lWkbpnFqN44kZ7Gn8ojTVEmmdZ5ivkpH
kFgKDkAWhy5MR0hCymeiRgGXpolJOkg3LJFFlCZB4phzMum8FWeXwqmsIGeoDs8IFtnVTOes
332OBNYf9eHw+tfr2+P3u39C1KQxsMd/gE/Qb3/dPX7/5+PDw+PD3d9Hrt+EeA3eRP/T7JoK
5teOtdYQrxuIsC7Dm9le+C1YHGjQ2K4Wm+tOxmYwNTYAbWhzxs6XgO2s9+KJdlNBzNvDBxlT
yfP1x4ayrra/P0JVUa/0MCyqUq+E8WH/McYEaNWzdIrMqFFdwwPluP1Psar9EDKQ4Pm7ml/3
D/c/33zzqm6P8DBwipwM+uPmOGxPX77cjmIT95RtKI9cSAxOdYb24DiaNxjOLcSxsG/mdNe1
c/m1sWmWXexiH42gXlMjt9xZndCVyJpeq8MQPAua56aFDisiRp82K60ctlucNjYanrasBdpt
7/Ncx1CfS0a8N8P7xl46DF02IXUrxfVwpq/TkizJ357A97wWaFq60SoNuZQx11stG5j4+Pnr
/2BuhQR4C1NCbhV4UnJH7Q94ALlT5hR3cG99aIbLsZea+lLSE2I7hXhJd2/Pd+DPXYwRMbAf
ZAgyMdplxq//rTsMccsz1UikI2Q57QV68kg3AhD4+8T0t/X2QPWrcI0fVKm3J/GZeSMDKYm/
8CwUoElPMFbGvLGn9rFUdVkEmWFVPSG0YlHMAyxi5sQiThs78zw3I9cwDbC1Z2YY6PZqVg3I
rOxoyV16/5GYnngmQBkt4+9SU0VmKxJu67mrwGmPPx5f71/vfj79+Pr28g3zE+NjsYtJQagr
3eJXPMk7w+eLDsQ+oNC2dii6YW41EsDT3wBhZcQBmgpRKw3nw/lxa+2g0ydt/2l8kLfGi8cO
QG5glfG2MpNu59CiOs7rJZWW1zyW0UyUxYKKVPT9/udPIQzIfJ3lWH4HXuinKJPLkZrNl8fe
4tohpyW1vpTMasPbdoD/BWGA1wPdXRVDv9Ze++5SWylK4+ez0zIbknFd611Rm8OXMMqdTHlJ
y7SOQC9tg3uPUGzOzZ6JHq9uyp95hRrXS3SOpm50AQX7572+H6107CwfSurjnz/Fmux2eFmz
NCXE7W5Ft2MMmSwHZnciBE63+0GNRbu/JTVy22Wkr2Us5IMije3WGalm4KsFye0CiEMRUUGN
zQIMrK0iElo61tr+b7WnmmDb+hfa2dSRV3TpdAx3iiQZNnUekoisMYjKhfRy9jXXh/Lw5Tbo
cTQleZZ+jTnD4iKJnVJ2jOSocDt22bgOuz2ZZymurK66QO4/fryv0iEleNSKsa+4yIBk73BE
IbavKvzSJUHs9suFkqJI0DGA9PUcysQZA1ZfDQS9ZB8HpJAbwb4rzJyh2jYKMt1jqkaqqzgK
r2hRkSIp3QIh1q8O10W211cb5DOZ3Pnp5e0PIcKtbCzlbtc3u9KQ9dUoEcLkiem5oKlN31yM
Y/0lvFWIp8zwt/97Gs8J9P7VDHUhPlGRXKXuhe5HZ0FqHiW6vYmJkAhHwgvFAFMoWOh8Z4RG
Qsqs14V/uzeiGYl05GFHedAx0ld0ThuMDBUIUh9ArMbVIRlMGFycYupMOqse0MVMI/MmH2H3
PzoH8RY6DnyAPVQ06L3sktjbFLikrXPkxFOknHiLRJoA1bo1WMIcGTHjyNAkcek4Tvrvx44E
EuUnxjrD2FGne40xDCbLqxMDm3nAjcNweSVFlCoAXaVliHYHHkE4tII/A9g9g0wPxFQOYg59
vpXVQIokLV2kukSBfgaY6NANWYDTiY9udJuB4KoREwvf4LvbVC8fPn2/+RSBkwOkZeZClEVo
hjycENH0YY67p7FYIu/nzr5ilb/lDBJY6Tk5AHR9oAkAkcIUuCfEI+YvKYJfpx5JcYgzXeV3
oVdJmEUdlhfUMknzfCW/uhnkJaLizdLMk44j66AsRYx9Lvo5CVOsnw0OfU/SgSjNcSDXD7sa
kIrMcIAUgaeAaYE6stc5MtNidh7ldBMn+epAUoJcsZbBKMnl7hTdladdA90cFQmyRkwvwljR
+kGsHulKrqeKh0EQoW1SF0WB2kpYK6P8KUQq46pZEcdLScvLnNKEUc7bEcWaMWJpnSeh7qxf
pxu714LQMIiwNxCTI/V/jD25mBwFViIBxCEOhHmOAkWUoJFcy3oQ9VsN5So50OwEkEUeQD8g
mgDeHvthvRQ8RlPkVW6EFJyBa3vblgeQZ4VY2mFfsqap0aIMV4a/jk8clfinbPtbxXpccdxm
ZB5fmROffA4Gf7brXDxbDdgLEXWjEKtSm34EH94r327FsThIt9jHAJFo64n2MjOlcZ7i+kaK
g1ZhnJNYDILK7Y3tIIT401AOugHXBO66NCS2CtgMRQH3RKqZeISAgt20aTgyiMd3r4OL7Nt9
FsbobGo3tET9NWgMzIwpOSMDwbbNCf5QmXLFRBeiXh9Gq8Oiaw+NEW5xBuQSn/oAZCEZAVfr
TYPRXcfkQJpbShUpMpEBiEJ0zZBQhCvLahyeGiZRhiwoCkDKAeJKhDQJ0LMgQ/KQSFhgJZdQ
ht9C6TzF2pAQDHGYx0glIJQ0uipKIPYVKcsSn2qyxoNKZQZHgTeTKGyBzhpasdjaSB2eocpQ
2WDGGY9ikqGrH20O2yjcUMTRps3Z52I9iZFhQTOUmsfowKR5ulobwbDWswImWG4EG7CUoCUj
2KinBJvUtEDTLdAFR9Cx074Gp1GMyFESSLAJLgF0grOK5HGG33jqPEm01pqHoVLXOi1X92VO
GodqELNxrVrAkedIkwpAnHORBQ2AIkjQ7Jh0treSnbxML7TGYtRwJjbz4WQQBKMsw/KWUI6J
6BPHBjzcbZHtQuxdt2q7ZUiG7YGzUw8ByqwQZRPex2n0zgwXPOAr7B0extPEY0Q5M/EuI0LW
WB2lURrocYaN/QmdfAqAoImnzrx31VhiEvo2AuUGzbMTvFMjwRQFOaroZLJgG6haeQk6wQBL
EvRSQ2MhGUEPQJSJJllf6BjN8iwZcDXnkeXaiG0SWYE+pQn/EAakRGaXWO6TQGz+KJLGWY6c
m05VXRh22zoQBejWdK1ZE0bru+KXLvP5TZ1Y+GbAI8tOuDj9IANHkLFdXJDjP7HSCqBaO48i
WnTz2YE2QpZYmzONEOATbG8UQBQG6EYooOzii0c1l4ryKsnprzEVa+KeYtrEmADCqz1cqDg+
HgwcE/AkEKOLKR8GnqerLU5phsmG4hAURqQmIbLUlDXPSYQBojUJNiDaQxkFyIgHumm9MtPj
CEtoqHJk6x72tEqReTNQFmJbn6Sj40Ei2OOhxpAEWMEEHS0wZWmIjMlzW2YkKxFgAH8AGB18
nLn0C4nzPN7hADEChGpA4QUiH4BUQtLR2aoQOJ56NKQ0xk6s/QO6KyswQ83dNB4xK/ZbtHQC
aXRoCT9hErQ47xbAxZG/BVti7mINbfpdcwBTutESYomfHNjM1h3hRD4aNxoT9dK30vwXHDwz
7M5iYqwbpfm6O0K8+IbdLi1vsBR1xi3c+PB96fE4gH0CRpxg4V5hSi/TB2babl3fLSQwgFvZ
m+1bFuXEy7Rc27LTxI7idXPe9s2nVZ6lp0/KgnOVC/SokOZRSoDu2HOtaiaKo309A4fjpfx8
POEqeTOXsiJSQeeV90fMI/7MfmTNQWpsioT16OMzgwxc71xYX+7fvv7+8PzvO/by+Pb0/fH5
j7e73fP/Pr78eDYe4KdUIJS3ygS6D6m1ySDmMdJYNtPheGRoS1l8rMRDVGD8+sAf0zcr7Pdg
wI/bYU4TH3ZqNGA8I4fSR1kGh6WoMhVY2p6D86qqRGMILZcK7kAD9bcgKxBkNHJ0gS9t28PD
tIuMuoAIUl/Qeow6OGttANc08fWKfl52Lc3DILxdatToLYuDoOEbgPXPlP6T/dHyci3mQBk5
iSqtOl7+9s/718eHZQhU9y8Plpvl1W6n7VUIdhd0HspyTipFv5BR+05eIkHLA9ikBPRu4oIH
T3wa3+Cp4sh5a3iUNfwFAgtnve7FEEgyHq/hGQGSqlrw7YYnOaFWOqM7wk3f1jvnAzCJs1Nc
JqfB4qkdOHtaTWFi8HyvDOdmr4h4zUwmO4cR9byLS0ePbrJANn/dVDUgqjPKPeN6/gvAj6g7
Q8CX4jufTmUHP1QVRQPJ6Wy2/0eJ2cooSuMS/K//648fX8F8wBvBgm5rOyyZoGhaI8uEBDqP
89Dj8GqE0dt7RttK0/DUPymHiOSBs4FLDDyA3sAK2wos4vDsO8MnJAAQHaMI9LOSpE66oE5e
VxYF0vjfk5GtS7/QrHBr0KC2fv1MNK37ZjLB71xmHH2BWVDTYALaGjbNGFdNgc8ATiO7ti4L
dqs4gaaZxkzF7lxH0NLDkdTugF/FALgrhwYMZPhth3rjkV1QhWbELo3odgxlURYVdiH2bSaO
orLh0LLsh0qIQ7ytsLoBKPIxNIU7Jmi6wSQQuBnFDjJWwU0YxZZGiX/iRnB4oEll5YoeTXeK
ArDVlYFGCKOG//aF6AxESc5Q3T011pUikP2Z0tpBnysXOA3siQNUkmFUUwFoppMEV3MeGUgR
YFddMxo59ZVk9DluQYnz0ZBZzxcWqF9USdokVJpkS31YQ4RUjWsWAMiqbSqmmL8lUF1nHR/S
ANXtlKDSJjdLCqZOTjP0h3TIUJ1xQHlTIXsKb5M8s/2ySICm+gXRTLIUgyX942ciRqGx8pSb
axoETuBNo7x8oAwNywmYtDMx8xnaW0njOL3eBl6V9tbi2gAoKskJ/gA8JtnRk6cMtp0ZqHKF
QWqoFSgNMFSlRkG5tVJMuv8YtQgQqqE7NpVZGjbYdR2BNPNtEJNVgfMh0EnmH6CSobCNS1yG
9c1LMIllL8bucaezFCZwTFh5qj2xmAUHRDT0hnkViYDP1DxGxnlH4zR2hs1QxSkpVhrkE70S
TKtMLiNXkjoLmzg37A/lrsSeaKSooyxqLDlMET2yTJSYxAtNw8DZ/4G60nPSYgTXcpxh35Ii
wCRwpAdBjUNHaHNY0mBFrlN2LNaad9xTZVd0dYb+hAn5yVfY5fPImQB8ADEDG5jjOrV1crxU
dRHbQbUnU5s1IX9KWX/hnFOeiV5d9oVDxcU7H7tBaR0hiYBzmZPyh8RPFNVVX5jhIlLeQ87s
S/svXEIg2RHd3YMBmXLNAsHRhWQpXsrpXLNaurJOY3Pn1zB1XFn93j15aNg8KnDIHG866Ldh
03pyEssxJDQVCQ0s8kxbiwk/+WnjpDykcYqeGiwmQtDOM3f8hd7yrogDT6eCdkCUh+udCnt2
HmJpSwRtNKmBj3ajuyua2DtN0KlFH01ZQFmeYRAmgZto6jH0M7h8avgGE8kStHgSytC+W8Rs
HErRNpaQqXNlgeieYNeI+FpsOlDgmKHnY2MRnuZ4trS8wBp4TvAsBUQKPMeKhaJbcIylSYiX
hRGS4v0kEHzppOxTXkR4D4rzS4jOEYngXSuQCK+tQFJ0pbPPSQsyy8HIYAAj5eSdkcu25Ipv
C2x7+tKEpgihoWexIHnU0iwu8ktc6IXNwiPDbJsOTSxQRrIyVMEWhr7kbNP0/WfW6u6Mb+UA
LmnQL+aTHVJgecJbLS4INGiyQ0ICdMD0Az1HnsbmEWUl6mnK5OGhZ8PiKSV5hp3cNZ7lpOhi
3S414z1omPgsyEpPxp8JiRLshsTiyQ9Y2qDIFIrp4sGmEx+KRXHmaU51oEPtQ22m3LNlYVbi
HqYCbTWJhf6amUdLB0NXCcTwXBM3PVoSC8d8YsAQQ+K3Zl5XbtqN9jzT25cZgkBL4w21a1H/
pT34SKqOtRH1su1vh2YGDLqYpR56htI/nPF0+PHwWQPmYgJUHj4fJwx7C1S6CAxNlwqB/eOm
RrErxb9plREXVpa+ohQrytLd1eiLE7cBlXEvblVTSXvbY4/eokqeEdcOeTp5jL1qHLtGfFP3
Zy1Ol/vG8vjwdD8du97++vlovA2OBSwpPBIgZbQYy0PZHXe34fwLvOBtdhDHrV9i7kvwjPA+
H6/7d5tyjuLiaVNprbxgmh8Wp6WmD89t3ci4yXZa4gdYenVLYOHz08Pjc9I9/fjjz7vnn3Dm
1Z6yVDrnpNOWoYVm3mxodOjlRvSyHopewWV9tqMfKUCdh2l7kJvxYaebOMk0t13J9zLgfCX+
ctDLQYx5vXWwemkDTHMcudTaalqERx+i87ufJI6KGHf/evr29vjy+HB3/yq6+tvj1zf4++3u
b1sJ3H3XP/6b9moo+0cG5NS62hwoVbsymGQ7bk7byFpbFzrSj5JOG3rUFda1L2jZdUfDjEkk
osUdUhFb0AkAjCLlSPz3Lp8c4iiTOdZ1N0OKdP/j69O3b/cvf2Fhp9XQgiXTvKuSPOUfD0/P
Yvp8fQanIv919/Pl+evj6+uz6EPwJPf9yYyyrdIazvIi02gQBdRlnqDBame8ILqD3ZHclFkS
phWSICDoG5DCKWexsRsrcsXjOCAuNY11C6+F2sVR6RSqO8dRULZVFG9s7FSXYZw4y4EQAHLT
ZnWhxwXe72q9YFHOKcMEQMUgd97NsBWnrKs+v3+t+5T7t5rPjHaH8rLMJl9Ukys4nX1ZI71J
iDUN7EKRpU6QY4yckCtGzkxLGAOATXmlGYGLeAzTFMdmIGHhbWWBppldJkHMHOJHHhgmfuNo
7Egmypk5gGjfPAydxlHkKzLs4Ron9zxMTnOQpSF6ZNDw1J1qZ5YHgTNyh0tEsHYfLkURYCcA
DXYaB6huZc/sGkfy6KaNJhik98YYRoZmbsRKH2ftNUrJaKeu73XomH38sZK2242STJB5LAdz
jp/TdQ7skm7B4wSdDrH5Pr0Aqed6dOIoYlJg9toj/v+cPcly47iSv6J4h4nuQ09bkrV4JvpA
kZSIFjcT1FYXhtrFqlK0bTlk1Xtdfz+ZABcsCbliTrYyk9iRyARyWc/nQ2v4yojPWz8Wbfi6
oVKG7/QCbOXf9Uv9eh1gCGNrHDd5MAWVamjxUIlo7ge0euwy++Pod0nydAYaYGb4ANFWa3Qe
+dZsMoro4/J2YTKHSlAMrt9fQSLpa2jTIRgoedye3p9qOGlf6zMG366f37RPzTGeje9u7eFk
Mpo93FpO9OtS0/dSBLwNmueyVkRwN1B2OGd2s9semziBLM/n53eMHAsydv18fhu81v8ZfLmA
VAifEfKiLYsImtXl+Pbt9PRuh333Vkoww+0K9JViYQHw6hRjffM/hkqGnKCwE8x5AOuTAvSL
QQEL+PJyfKkHf33/8gX6GygfNGUvF+SiIj8T3y2OT38/n75+uw7+axD7gZ3jrlfr/UZ+b9RQ
yjbP89exSGelEvbD0uPXZTCaaKyjx8mX4ZvFE0YsPVLcW+wMo3WCrrHA+5hqPndchhpU5EuY
QiNfy6jhgC4bbus9LsfsBGQo1Z6GsgTpse2d080iLFvKvnFbGKVZTMfu6MkWwXRIWh0pI1D4
ez9NHdWYE9as3Q9WaFtLFIj7Y7liQd87P9eYZvPt+djuaWpR40b1nSmfksCzE60EmyQ5dGmI
/CzeJCn/Y35H44tsx/8YTfrufNS2ls5iPW35PNukelyX1I6oHrHA5lmREVKIBX3ksbII01UZ
kXMMhEbG1A61wYoc37Qxeq3G8bf6CZP24LeWCS5+6N2XoW4fKKB+saFER4HLcy0VGoI2mE1Y
hy3CeM1Ss2A/wucDR8l+xODXQS+niXtjFZRtDEMTDZ146GvhrMjMXIuwQ14Y2UIRDNOxytKC
cWrRIkGY8EpLrIOwOPSNzDoI/bQOXS1ahcmCFdaaWS0LMjc6ouKsYJn6ToPQLdt6ccDMcqBi
8V7jKGt9CM0vdl5cZmQid1FLuAONU41tLZp0KITrlQ5l6HVigEqrvj+9Bcl4EVfuWBp5RrHr
MMWw66VZXey3oQ5VYBiYgDTbZmYjMC41bgdHOxJvxXyR0FQvLIGxKsx2JN5BXMaZdRShXFKu
OjBIO/omGaVlmBQqNPYGZoZkYmJ1eKrm20YAZr1f6yA469DPDVaRMjQK0FrUeVh68UENfS2g
mHvMD0hgf+LQaD1vr4rxmTGBeezhlWzKfGuHAuogfD+dY5oXDKQY8zvgKnSCWIlM+EZLSIVA
DPPVOJ/qRZWh50iUJbFhjMnGyNwlgmKT5rG5lYvEmMQVvrV6XGVcHUjOll5t4hXln9kBS3a2
rWRb2t5QILOchw7ZTuAj2IAu/lRGmONJRtRVm6bCodXOwjEL4K7KOWn6jgyKsSQrjZ24Z2mS
6aBPYZHpg9tCiDHDPPCw/1wLSforV9FmYSwMCfehY/i8Ln5ZR2qc01oodUR3oaB14aKXBTB5
MaNc1OQusmJDq+X0CaQoyUVkvkKWYSSmkrBqlWUB064YzZLMjzp71zavK0GL/ckin1UxK0sQ
5cIUzmeFoeoX/grQDMGAMHz9KAu20qGbOGeVZtcgv09Tw/hLJI9Gj83I41WksraN6jy3kW5v
xndpCiKjH1ZpuGufEFtJWde8cVKshyQsonVpzcOCM669byB6CQWjKyma65scRSMMDqmHDjni
sYhiPGLMS3SnzYKNX8aMl9Y4cjGQItomX9ijLx4oN8AW00D60/8xUtFyZvq1jKnI/P61iHDK
FVMyne3v7nDkHY3e40KRE6N9KODBYuV7lNzSUViT1kJhSNOQe5zCWtmxEBX2DTGhBTp0A5+o
SmsGBb4scYlwEIddvQzJtgroksd0Q8gUHWKe95vR8C7KzVHViDBk8HC6v0mzhBUDJd2kyZrW
OAk2BIG60eP5cGiPaweGhmZmByXSd2+HYu5Np5OH2Y16sWjdN7OFSq9ZnfsCWLzHJVmgqQbd
cm9cz/3n4zuRYkvmrzcWFAgqqZbMdCOcow2qUvj0yEi0cAL+z0AMQJmBWBmCyv6G126D8+uA
+5wN/vp+HSzitchyyoPBy/FH+xR7fH4/D/6qB691/bn+/L8DTPyklhTVz2+DL+fL4OV8qQen
1y9nvfUNnTFJEmi+XqsoVBU1aVT7ziu9pWeNdotegrxjuGSSdIwHIzKNp0oE/3sl3QweBIUa
BcfETSY07s9NkvMoc5Tqxd4m8Fx9y9LQ0tFIwrVXJJSqpNI02mwFw+k7RxPYXbVZTEekbaPY
qB5XGTh7OX49vX7Vbk9Vdh/4c0fwKoFGzYaWuAHNcuNBXsK2FIvt4ZXMJz0nkCnIaT5mDFcb
AUiHQ3jz5SbwjdFiue2noJ9XQcpvGByIrguOERS+vi4kOLMPeYFYecEqpK1mOpoAPR8K40ZN
xid4Pl5h874MVs/f60F8/FFf2o2fCO4ES+jl/LnWzIYED2IZLEXy6kTUuPPHZnMRJuQrtzCC
FO6Rl3jZYbLwn+2nFCkG3BRq+zZ4elTBDgGiLWdJHtOufA0ZZbgglkCEDy2hcXK00MpeVD3u
xqB0NAlPHCWzZO/AWMnHNGwZrgqLEYmUAfr1e7f1cTgp2xHBTkQebfIzXeZ1fB8mbOoaWcCp
1vDi1Aw25WZv8bRwy0PKmUhKsqus1G+FBNgUMVqu6R9m/tRa5v5BBAZy1MGC9mZIF5jKgFUg
GlMqpegN3qYGMPQoPavOpQivkiUTee1kYHv3ycBACl9sV3SyKtFVl9BTFh7oK1u2KEw/LdGp
bOcVBSPztIqvQ1NpCCMellIyWrJ9uTFYOiwyvA9a7nToAeiMlRx+EsO3H+lglKnh72gy3BvK
WMRB24F/xpM7a+pa3P2UTIkhRghTgsMkYD4Dq1cw/hlfhwezXK+03xdx3efffryfnkCpF4yX
lv7ySCsuzXKpb/gho5ytxJEgEkAZWbrbrTs2YyMq6r+jPVrZJPeVUKennkmCFq2hoUDpeBqJ
fcKr9p2uQDbYVl5JNwlo8MslmjX3dA3/UV6P+mmoL6e3b/UFOt7rnSb7aVUa4NKuHhYNCyf0
CXPA8r03mlFPJ+LM3toFIWxsqjppbrkJt3AoQKh5riqwVcaeWcAnVr1eEkwm46kFByl0NJqN
SGAVmNqRQKhWXWK8svXG2Myr0V1JznyXTlE/a8XDnqVDqiuanFp9Qy8wEXzGWWnwoKWtecHp
z6vY4Cjt0jKhIZ4D5vfZwuRgyyq0q8kjlPMtwtAiTPBVn9SxltYuWlabrW+C5BOkXjmlXy6r
0mym/HdpsZkWThz5FJUcZboEHC63SN1Spb7ruO1IwhuVAA6trPkNMbqjLVI4hT+szJynDkPN
a4c05pJuwBLWH6zCj5rQzL6rDNcjsUEG6+VnyJoF8zOkpU8fhavj56/1dfB2qdHE6oxBzZ7O
r19OX79fjsT1J17OWzdmjsdywUZurBHJYuzhalNKL93XReqM3T73SpTM7HPz9hZZKVvRUCbR
6afhWs6P02zNDEa8wt2G4UwNqHgitFsnwDfXfEvjmwfEyuYsK7x2ze1aECp76tD6WxqKz66q
XbjwPWt347MQpRurmTA/XHNtReUhD5X+iZ+wlPOEgKl3sRJYlMPZcKg98SrUaDrFqLUpaZYo
q+qxLCRi45MBviUyCsacN3ayepUiPIlqMi3hvIR6htM+4zQOUPnjrf7Nl0Ec3p7rf+rL70Gt
/Brw/5yuT9/s1yFZJuZlz9lYdGAy1uwL/z+lm83y0AXk9XitB8n5MxE6TjYiyDHzdZKpxgUS
k26ZcGvqsFTrHJVoMh5aFfEdK9X39USNqJTvCh4+gpZKAHkwn6k5MlqwuGVQZx0+ljEXiUnH
EIbVxjP8XOAD1FEsfguI33nwO35047VFKcW4pkUQDyJ1oXegClPF+j6ox5nqVdjjjRiDiCiY
n0X4H2Xw1X8Yl8vE/FSiMhDVCo+T2rNO1abgciMNtU6nKB+GzhYEOz/hkSPSS0fYxFa92dAl
/lWz7PSohMWL0NsYDdwtuNEpL/bVhBFiKbAliDlW5+Xg+8Zc+YvZ8M7s6lb44LnnabtZjO+s
rzbGoGioIGJT2D9GX5u7f/1dSzTr0Vp1EX80+pnxiC08++OkXFNDug/TLHXMauLRNpY9iZcY
WYJ6mjDBMOPUdsVnX92qRTyiGr54PayyTIQUnDh//Swmb18E3aLAy5QUr6yiHV5SpCuxCQQz
QCNP4sZNfOh55XBEhgqQ6BQOpsmDZzXM4+MpHcVGojFBw9jo6MJPpmM18kwPnZhQYY98RwFH
FNCsCm177wnK6YOezr6D3w0pVV2gu/gS+lcylz11XSnQuimBrAeDtt3b1QN44iwnzid3e6LN
+WTSJZ5wf4tW1HTLyUymHXo6tqvsnNSdizAYadFMZBvK8eTBHj3CDlwbczOEiTRB8D0MIWBC
Y3/yMFSDHckirLCPCviBWDCTyT9WM7vYieT+FyRoVT8lM4gINOPj4TIeDx/sAW1QIz1rk7Fl
xcPrX8+n179/Gf4qxJZitRg0dtvfMcE7ZTc0+KU3y/q1P+nlNOEFZ2K1RgYhdPczifdFSD9+
CTxG1HINgow8aNno9LtyZjWnjUbhKpKvkvHwvnMSWz4f378JJ7HyfAGJ8hbPK8r5ZDghx7y8
nL5+1YQj1faF261sjGIwDD2tHGtkGXDoKKNu7DQy0MXW5iJvUEkZODBRCMIhSA6ls5GdEeZH
9fv5xlmIBwrzlpWHjztrxsKmqVorJ33piQk5vV2Pfz3X74OrnJV+xaf1VfqNN9rc4BecvOvx
Asrer9Z8d5NUeClnYfpx/0W8BOcQ5I68BBpRGpYynoCrDPQBcHLubrRN72m9Q/o0dKt4geyC
2vVWSQv52EHabkoZny1YDNPdLzpvODyAvOGxOA7Nq3bgRMe/v7/hrAh/i/e3un76piVbyENv
vTFErt7+kfq6rbgofbzK7VuCgFag6ipAYOSDhHig7jMQC5gyi3y9nAbYek/963J9uvuXStAq
SFpF6TYJ7csuwAxOr7A6vxylcYTyBUvLpczNYZYlMHlBRnDv8FqIChVabVgoUp7oaAwe0mg7
nbEnNs/SpFtiGdZwb5fiLRaTTyEfm82WuDD7RDlL9wR7Waj1acCHY9KBSSWY3bs+nd07k0Mo
ZNMZ7endkkSHZD6Z0v6XLQ1mt3hwGLUoNOghd6M3RExnBSWiyN34ug2EbIL5xB9r8QMbBOPx
cHRH1iZRjiR0BtGtJu2BYGLXLHJNakHZVMTd1IUZOzFOxJxAJPfDUgvvqMGb7B0GbvE4Hq2J
3dPFgDIrNwImd7NhhrBuERz0lIc7j5qNJcgyZCbGrlDYP0OiEQCfzIck/G5EzEuYgD43I+i3
AKeWFsDHI6rJBcaYIyN+td2dJMQYBLDb591xkTM3N0KrcS9FXwum0qOIZ3MxYteDznZ7dcPq
GQ3JJK/aqDz4xM6SmC5BmD06+6kRh1i3Ufqg9V6cR2Qw0Z6njeZTB1N0RQFQSSa3mR3yzDmm
gksYaf+l0M3uyeUR8NH9HX1r0pFYuRosEl6uh7PSI0MDdlt6XtJDgZjxTWYMBFrsyhbOk+no
npj1xeP9/I7eDfnEp+MJNgS4Xoj9++mQPiZdsqrz628get8+oJvbRZKLlPAfHZ6965qZq6JD
mAEx247NxiK8YufgymsQzi6327jK4mDJuHJXHmCektYJwoKZt88KZtuiZNCoxFMc8HvqKkxX
LA21Evp40JGXpmGs16x5teBVZIHWdStp1tCNbLCrvD1DekoqW/K4CjVDCJlNgwFsqkT3y+O9
bi/RJOySk18FuYYUnvQRllElq6SkEEpPdqJxhsVsA7XJtAtTAIZmYQhAKjX3EUilkqybAv/5
VL9elSnw+CH1q9LoJvzQb9r7mapAfwiUIhebpe0EIwpFOyJ1SvhOwEm2IQuqkmwbVmlWsiXF
uxoie8khlIfxEtvMLQyo17kDKpSHUN6oNKqM0aVunDb73sKvgaFFX6z7sETB/f1sTu1jluBg
+4zpJovwY6QpFKCihnFzD1wloMZ5DqPBpnZQBGFH0D54KgmlsCr49hK7wWx03RV+Vj5bEkUg
JhecI0xZ8Wh+FGBMNIlyfOypb7cI4GHhZ7q2IirxGeUhr9GA5u4wSMECig1tmQG4ZDlVsxQg
/2mDtOlQMyAaQvCqkcrNsQ1yNVgO/MKHQ+37BoYNp5bM0t8qvG4rEoWxrFRtnCSwYKqf61bP
4yZJsJEmTLN2kSB0ODFhW5752gVEA4bWk6Mt0egDzRsvQLTe9Xz7yiM5PV3O7+cv10H0462+
/LYdfP1ev181d8ku6M1t0r76VREeFhtqqnnprbSRygvGkxE+FCu7OsPIAuZvk+t0UHkHJjgQ
+4QhTv8Y3d3Pb5CBtqhSKhlAG+KEcf9mHMGGjnHvZ8hw4/wUGabqoyh1OmHa120Ns5SgfJgP
qRv1Bp+KAqZazp6+4EC3CdcQaEJ9q/2SirMV6VfTEG0T0MNVIaqBz0eqN5ACrLhHtGgt/8aM
CslVzGfDkbLVipJPDFW+WYcy2KW1KbzXz5fz6bN6RkeJfki1JHaRIi0UOU4rXi3zlYdpamke
mTI4DXlOp34ROxqNmtIw1dNHJw0ncX0lIln1wyFgAUtGBkiLsLrmM6k0y7BSx/e/6ysV8MnA
9I0COQ3lP+gyW1JpHZcsjANhsKzf9EYJvpwi++AVzUPWuT/Swn83AEOQa6F6txqgLjXGukHh
DgMdkDO0W9JwjAUP4iVn46kjcJ2SqA6JiW7Zgn8LqXKWqy76mJbWj5X7FviB15hxlq03uU2I
uX5hUYXa/sLAzrIQdW810FsXajrVw/18QpVr3rcpGM4m4/uhEzVxoob3Lsy9E6OGr1IwfuCH
MzWmooEzYnWpWC7XGuUdrVbdRcC3cagWwV+QpUi0eTmmoLY+Pdh98hkb10Q7TtQn9UaJ2voK
l4x2PGdpLAUNebHyfH76e8DP3y9U6lHxbKepghKSF9lCWWoMmPi4aort1+siDiRKg3IMzq61
VPg7oscVbIJyer9QeTDZPmXLeSxeZNQjKIPR2SihECSPq1/ry+lpIJCD/Pi1Fi9oihtcz/Q+
INXrEXLLsvMBLeqX87XGELLEJUCI0TjwIUM5vToYrMyGV7bRY+2iZBVvL+9fidJz0NKVgvGn
0EBMWMpNiCJ5t3VrdSisEKN97VhhOxligt1f+I/3a/0yyF4H/rfT26/4TvV0+gJj2VvWySP4
5fn8FcD8rF/2tccvgZbhAS/n4+en84vrQxIvvcD3+e/LS12/Px1hKh/PF/boKuQjUvkC+9/J
3lWAhRPI8FWsovh0rSV28f30jE+23SBRr/KsDPeYvFiJt06+EP586aL4x+/HZxgncyDbIxPv
Ux7x0AvjvBVEm4rIL9UFgsZ21urYn55Pr/+4BozCdk+fP7WuOoUDkxZsl0X42F2hyJ+D1RkI
X89qNxsUnMTbxuQU1PggTLxUuUBQiWAsMHKEZ9wyaiToQsnhaKavYRTKLs8adROjluhxDuqA
2R8iMkjf+Src0o/54b70+4gj4T/Xp/NrG4XBsn6VxNWSeyAHKCdtA9ftuBqgkgfLQozHej7E
HiPsjpzNtc7MFlymenjmBl6UmLXKI6riyWRyR6lPDb51ICQ+BRSsbDTndsToxNj3BW38wcjU
52mpRR2An1XCaf9wxDHHay7ipAF26QjsjRRw+K9AuaCtlJCgzLLY/TUsfPeXaDzizF6xTUJT
0u8X7M42EcCbLIycS0RdKh5RVFAvp0H8UTNiNhm/m2uyNvaSWWBXHmy+tR7uSGh3VQkq/UhV
QRrvSZZnfqm6YBQhOvL2nFmdTolbFH7CYYzgl096ukgyeTu+2plFl6zPgCufyaIDyCF/vQt+
2A9Nc3HX+MvaQBHluAo09MJPqjVmFUVXYdPTFr9p3lNgZRSFwU1IOiye6KFKwllYqHnaNZwX
bzMdhc8ILNnPk0f9Ckn2aA9DRvQLkfneq0bzNBFOzQ4UdtvscuLlwkmtSoJkOnXYNCBh5odx
VuLCCMiIdUjTpQqLuN4EBcF8swnCFcVK+disZX36uzLxzPE9ZWcEpeqdk+jhTeAnXlpR9wmA
ifMuck5eX/BJ9vgKh8PL+fV0PV+om8NbZN1y1hPHoZv5T9zLpEGR6UFiG1C1YHBQF7AjfXKc
uvubdjw8RXsSpknGz87wSAei4s8Dz6IuZAny6W83uF6OTxj0xWJZvFQ+hR+oPpVZtfC0Zdkj
/q+yI1luW0f+isunmSrnxYvs2IccIBKSGHEzSFqSLyzF1nNU8VaSXPMyXz/dAEFhaSiZQxZ1
N7Gj0Wj0Aq1oLStFRElHX1oxAViQyEXUm5uRStmeyDSE1ExQcp7asq/XMHeV+AROiF4XXdUT
vyY45Bq6tvo3tRExZnS8PH8O9t+jVo4seET6kEmXApAF5/vMRqZflicso6MXi8dfbs4tiQPB
rp2ngeruwXauYKcKQ6gtSmN3V0kxt3/hKebIY1WaZE4UBAQp5uMmaLPGWsD/cyehlqEraVxv
V90r61FE6hwlj4ttvyWp6AQxlZxHRxJV9strNHiUHM9MmsDSJGY1b9GvmInK9NgGUFJkJj8E
Ge7c8QnuQO2c1TXVHcBf+J9cyPqKKoE5j+gh1FQVjxrhmAPvSQZ+2YNg2Q6NLtn7PhyESaKn
DQZFlI+4ROnfhrF1HuLvYFALdNgeRiyaWGlWE5gGdHR2koR2YCAmHYJ6AqkFSfJRQX5+YK6+
eZV++81QfrOH0YA671CSECPnojuTcUDMdZXGb52y7s4yykTMbVPU1LPJ3GymXZjtzoiQIk/R
PqCKREO9iyDJjInc/Sy8KMajCrcAUVYRKdS+SRrSFufRkAAbWcPTprICKPQ0OI7WLCmMinoC
F7xpWlBrzaQymzSshTMJGmKNaV9bj5ULUbK6sbtBfWLR5JiYEeiCO0fRembQCgy3dx64Gu3r
4KP2DmR10iojT1J3MkbnTsclAIeXIlPbxgeTg6SRB7iXJFFjaG869a18iE3ybzwKhJvWVeBz
F4aSsqKha2R6X1DAAdVWAJNelhp/X9Ux/V0hSJHpHq4AHkvBKWaUvpnew3yOvGBU+RDlyNxa
ifLQlkeq0a3nc9REoVvZIoDHaBt5JBalHVHeAsMteVxZOFxpJtfrQS7v2yOGTQJCEWyEZJwz
DFhllagMiiyNWNDGKFEYyS+s0WXBTyTz3Ncnf+KDqHTQkALLiJlpXWQwhY4MGaIasr4mhQgd
bApbC24UeDvKgKlbzs8KRGmSZAFRbawEjAA8qgbW1lQwd4XBoLSBgBsFzETKFg5aaf+WDz9M
q79R5RzMHaDnvw54AmdbMRbmLUejvAWhwMUQd3ebOrGXJVJGtyKFu66dqs3xJ1Fkn+O7WMp3
nniXVMUNXMDdU71Ik0Ccmnv4gjzKmriPBqPbQdettKtF9XnE6s98jn/nNd26kcNoswq+c9p6
p4gofsHq3mAF8+uWGPFmcPFlzyfc8hVEf5MU+KpT8frr8cfu7+tjUxsn1xQtWh/qmbrub1cf
j2+YdtTvsRTNzCZJwNR+k5cw1FeZq18CsYsY6jqpTcd89eo1SdJYmI+lUy5ysyrPJ6jOSnJg
1T/7baX1E36/+olDUyC5YqWdoi2cyOSxxIDqLRx7OI0ZOcczl8yYBnU2iBZfnzjfw28VjN9q
4NBvnMZ4rCVI+m3kChca0m1+w36qx8zgUOAqyhw5NIqwarKMBTTifVFhkR4JDBEBzks8zhwp
H4nuaTshhVRyhPOFwLfsA+0CATuh/X27ZmHMlDYHKeG3RCVGhqTlKJMMLdb8dirciN0VjYCO
UEse2LY5eeq3kjAsj7gOkdmSUHXbsGpCLow794aTJTnIOPayKrLw/piUoTV3m88H3goF4FXo
A9HVY9w1JQTddnncDheqw9a10SGAjpOt9AoqSJWWIoNVOLRtHUqMf8Xd3z2rnuLr+nABF4ev
Z6fng1OfLEUdhl7mli5YkcC092haG63pBiSdRzWJDlV3PTj/o+pQpP6D+g7U5PZdj9mfNl7T
e2PvERw//3fw4+HYa0Hkq0xdErSOOIQXjHIP1mNU5P7KGKbe6kEY/sH9enxM4OQqkhziakCg
Mauj4KyCK0Af8RPOszs7BKKzgdRvxcktzTylMdCHiCjcg62D+JffHuMxeJ/kPqHMrUDCnxVi
6hzPGunxD4SQArlEXHikFwHNkEQOXPJqRibMUMTtmd0wgBjWl6Vsq7y/sUVhRi9SmBQkMgqr
y26lZULGc5W/qcWEa0XGkvzr8c/V5nX1/Nfb5unY6R1+lyVjEUr51BHpWz5UPuTmwyam5rCE
MDXg+mJhVYa3FmV/Dvc+ihloIhTseIpEbhFxUrEhjEETlwfCxOuxxdWOeTwau32x/cuf9JiY
dQdPRT6GUYw4PoEnhelYgies81MtHKO1bliPvgcVyJ3KuMaQc5tclJH7ux2bYZE6GJ5XnfOW
MWllBPOJ9O1UDC1Li+4zPcxJLicesxtEGA6OZvX6o6D+MOLlJHT6R0lARI+Zs3FZ6NS/KS1e
I386N1sJo7QvCuFreHPT2Q1+7A+J9fbt+vry5tPZsYnW97MW7mfWajJxXy4oV1mbxE5pb+Gu
ydwSDsn5gc8pT06HJNx4J5ksTXJmD5qBOQ9iLg5USW0zh+QyWPDVgYKpUAsWyc1F+PObS/rB
3ymAPGQsksFNqPFfBjYmqQpcde114IOzc9O+yUWduV2RDnCB5umqvI80ItQvjb+gmz4IlRda
lhp/RZf3hQbfhKo5ox2lLZLQeusJnNU2LZLrVhCwxoah5yhcDVjuNk56nnKMTRdsnCLJa94I
0jpMk4gCDnEz0VuPWYgkTU1DAo0ZM07DBTeTCmlwEmHyhZjqQ5I3CXkUm50nW1c3Ymr5OyCi
qUfGSo9T62kYfoaD6OdJZEUx7QBwCRcZS5N7JRtpJ9U9XVK0M8sczHpOVpbLq4ePzXr3y3ez
nfKFcVzgLxA9bhtM3OAcRF0mOphOJEN3QVNKVsp4HvsFtvGkLeBjpnUbBkoqxJOIeWqPXmqL
M15JU7FaJBE1Tf4BqCGWgk2X14ncYUw7H5kJ3np0yUxLD+mZMmEi5jn0uZEOp+WiZSkISW4G
DY+MtGCBMYgkBSpEPLmJQqsmHX/efl+/fv7YrjaYyOfTj9Xz+2pzTAwlrBxY6wH/n54IFvb0
MEldZMWC2s89BStLBg0V5IxqJCZWpPQQPqF38wqQdA+RAVEv8E3nH036enqf7M0LyOakBYvL
hLqM9CQLZjpu7YedjdAa0oyobZQKcncxy9u0ygLV7glazkQaiM+GT3KSrruljAq0mArq+AL0
5KPy4U8kFvYAMPnUMeo4VJpWMR1cVx5RTIZrwLE7Rnebx7f/vJ78Wr4sT57flo/v69eT7fLv
FVCuH08wbtcT8smT5fv7EvbT5mS7el6/fvxzsn1ZPvw82b29vP16O/n+/vexYqxTeT09+rHc
PK5e0TZrz2CVWdUKCvl1tH5d79bL5/V/Zdxx4w0IlxNsbhi1XKlSjIFJMC6eYimBQHkeMSbG
C9JqMyy6SRod7lHvruAeJro3c9ghUnloaWvhWED9tHoT2/x6370dPWAqwbfNkeJV++FQxPic
y8rELaMDn/twuCqTQJ+0mkZJaWXtcBD+JxMrqIEB9EmF+cCxh5GEvm5PNzzYEhZq/LQsfeqp
aU6nS0DFoU8K8g1wQL/cDu5/0FRh6v4G7kTS6KjGo7PzaytSXYfIm5QG+tXLf4gpb+oJyCEe
vA8Po54AP74/rx8+/Vz9OnqQq/Fps3z/8ctbhKJiXkmxvxJ4RFQYkYQiJoqsMuvaq3vYiDt+
fnl5Zl32lAnxx+7H6nW3fljuVo9H/FV2Arbh0X/Wux9HbLt9e1hLVLzcLb1eRWaOFz0lBCya
gPDHzk/LIl2cXZhB3vr9NU4wDpXfIX6b3BG9nzBgUnd6FobS8xEFlq3fxqE/pNFo6MNqfxFG
xJLjkf9tKmYerCDqKKnGzIlKQJqdCVYSc8kwekXdUFp03UD0ftIjM8FQtoGBscL6aFakgG6t
c2h4uMY79ZGyB1g/rbY7vzIRXZwTE4Fgf0TmJJscpmzKz/1RVXB/EKHw+uw0Tkb+GiXLD67O
LB4QMIIugXUpfSz8noosPrs69df3hJ1RwPPLKwp8eUbtb0BQvmA9T7jwi0J7nWExJgqblZd2
vAx11Mq8WP4iYtwfd4C1NXHg5s0wqaglLSJK3dDPbjGz4wA4iL3O2ON7LONw3yfDb2gKFUXC
0jkbuEuy1KomAwF0XJ1TfRzJf2nFb7flJ+yeUQkVHR5KsEjun15wpJYgIRMHxIBoXc0PjBHc
Y8nx7+D74VML5e3lfbPabi3BtB8a+YJJNCD0Vi+R1wNq0af3BxaNfPn0WtyZNSqf8OXr49vL
Uf7x8n21UR7sWpr21mdeJW1UipzSs+iuieHYiWhkYiYUr1UYJ1WDiYtIQw+DwivyW4KhoDm6
15ULD4uCVqtkYbc+jQpdo12yoOjbU4ic4i4mGnbSHZ0wwyVG8fsPGsVzKSoWQ3ylJteZNOgL
l4Sd1/b05g3jef19s4RbzubtY7d+Jc7SNBmSrFDCgb2RiO7c8rPq+jQkTnGEg58rEmr3IJIU
C326ONAxfV6CcItP7WeHSA410jh3yWY6wuPhxgbOzokvoGGIGFZnGGTxnJJ59niQyg/xe02G
VZ8OCDkfKOBGLUwfJA/VRnmOaThIEj/Qm4FEZc884tTTvEEVRZaFrtn4LC3GSdSO52loFPYU
QX0zqxZZxlGtKlWx+Ei6r81Als0w7WiqZmiTzS9Pb9qIi06Lyz0/pXIaVddoIXaHWCyDovii
tXABrMwj7OTdRTttHrclV4YH0reg0yT7stBqs8NYCnAv2sqUGtv10+ty97FZHT38WD38XL8+
mYEn0RCjrQX6eMRa123o5Tx8Zdi0dFg+rwUzR8b73qNQ5i+D05srS8VX5DETC7c5tIpTlQwc
CFM9VDVNrE2E/2BMVE6BICvFMJ5XbWlFbNSwdghXcThEBeUOhU4+TLTS+tQ0uGWO8f8QNhrH
MHHG8GmXbxCI86hctCMhPY3NRWOSpDwPYHNet02dmK/lUSFiy5laJJnMNzy0ojiqpwzTS773
Q5cJ0iy/PDhMJtI0JMrKeTRROlLBrStOBJsd5AALdHZlU/gXo6hN6qa1v7LvZvCTeC/q4LCp
+XBxbXMQA0PHb+5ImJixOhBUVFIMyTc1wF1ZR6t90EZmdp9k6F9BI0Pf0N85jbWXx0Vm9Jlo
gWn9ty8LoTH34Wh3i+JFau3ge3XGOlDTjNGGUiWbxowW1DZeNKjJ9pk2ig6Yop/fI9j93c6v
rzyY9LgvfdrEim7cAZn5ZLaH1RPYOh4C4wP65Q6jb+ZcdtDALOr9Zr63aZ5hO7awqiqiBDbs
HYcWCTP2Liwf3Kymo7wCSQ9HaxMj3I1ubHs35ZhasFII4Dlj87FQ4mRIZ1ZKgdZsH7IHxLE4
Fm3dXg1g55gDIXFlEjzGdbk9vzVOmnGqRsjYQtKnrfdxMjp0a7KztLDCKeDvQ5sqT233uyi9
b2tmzHwiblFoNKrIysRK5xInmfUbIyAI1DHWwnzaxUgQReoMX160Kg5YYugEKhjHzFbI4Rty
PiY70h+L3mlnP/NoWUFC3zfr191PmZTg8WW1ffJf11XSWxlXzjpVEBixLp5Kf/hIW104H8Yp
HHpp/0LwJUhx2yS8/tobzGohyiuhp8DInbr+mFuRqONFzrLEywVqgZ0AlSAjDguUDbkQQGWl
WA2OTa9zWD+vPu3WL524sZWkDwq+MUbSeOjDFuBdj3I4ElC/8g2WsXOtOS+BC2D4i4w0vIeb
qryEsspkBBwD7VRoRlgzc92qVlTK8xOdazJm5YV1MbJN6Ne8cMtQT6MzzqZoWtGn3dLi2Z+O
kBX6r1un8er7x9MTPt4lr9vd5uPFDtieMbwbgLQozNSae2D/gqiu519P/zmjqNxszT4OHwMa
mbBgLyAbTs7O1KInMXCrGf5NShY9GT4xScoMQzWQL8dWge7bajN0csl6gREPDqRdi3rpdmcX
3a60TqJ7ce0LswKa4YaFuwDPK9qMWRWHZA4rdxBal+L7DMh7VZFURW4J1+p75edYBcCE9Gjj
R9Zha+NkNE1injUerW2CHdZEImrkZgwXA5sH9s6BqB02uTNMZwarSJuhJiZtOBDvOJh27EC+
4DfIfA1OAGdt3KF4Hquj1/3yLvMh8nXGtULvkYJyBOux5Rik0rHXQBW4TZoJGAdOJOUanAY8
FvNCxgDAuOIoi2iXFttqYL+G3aZVEydAv3pcQvqj4u19e3KUvj38/HhXbGyyfH2yA/thWj00
YShArKIcTkw8hkZpgC/ZSFxv6F5guPNVxajG+1ZTQitrmP+C9tNQyHbSwDjUrKKW5ewWWDkw
9Lh7g+nDuRzqoDK+A/b9+CGTbxscwFolvoUTgj3d594EgyjSnRAcjinnpaMAUHd6fH3dM7d/
bd/Xr/giC514+dit/lnBf1a7h7/++uvf/hGMwnFT83nApr5bDl0o3gMkvy9EzCqeHSLowgUo
BbfO3hGyS4LJR5nXM9+azVRTDkm4VTQKfh9VsapgxpL6QASn/2fQPbFH3MqNTS1MFDDgCGib
HB+WYDWpe7DPPaaKBx4Yz44ChKKUs8qPgKtWu/LJOXpc7pZHeCo+oNbICjoq5ybxj43S9afv
Fgutz1JIZSNKJxRQvLqNWc1QNhWNDhPh7M9Ai+3GRYJ3Nmr7UMdRQ21aZyVoSRKOKgyBSMFD
awdxGBpl/x0lomIBwgoAgSB+azql6ajGVovtDgILU0Kn0OKmhVYxO0AWQRWy0X5ZNdzpHPfT
iqHTlh+rYfn8/mNJjZrMa6bdqIC3AR/ZHzS9DFlPeGZJwm555oWsXm13uJeQ40YY/Xb5tDJs
mxvrvFPGm/tg1hbYnRgF5XPZSW9iHDLcfR7r2RuadwsYr0mFOBw3xo4ss2/kiCVplTLrVo4w
Jd1JAfD3xfUGyF4pGZtybfdN9kFSJYU+Y8M0I+Skf9AUP9aRakgW6XZ4ggqIJ1Fx1y1HUzMl
QPJDRS1OgcqJYb7qptPYDFEo3xKkdrxSsdNNeJbkMquTA7Yp0TNNNQIPDHezS/2Tv8+leqhI
CwxqH1xNMtILyDZtXwb1blMXcCG/GhCyuWzshM/jJrMUH6oTSvvRxbsm69d0VVTSJsTqIQYo
6oK2I5cEUsFAZXqS2F4vYwKbxjR9lqC5o66TQIwRM4IrnQMWqAqu5WXV7bb7PG5jk5iyoxgl
OcbfrCmlmvxslIgMzl2/NhUahDqpklomDHGZErA/FbjSYkO9ggVLI1HqfYdEGG8rDi7KYhlf
jfoOGlh5y1bNjdQUhccQLhcRg1kPTbi8AnVXD+9LhIc+lNbMyODMA4JnfSNti2X6LPDMmpUG
73/D7k/UzNEBAA==

--wRRV7LY7NUeQGEoC--
