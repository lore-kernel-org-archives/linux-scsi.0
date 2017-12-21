From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH 19/43] qla2xxx: Fix session cleanup for N2N
Date: Thu, 21 Dec 2017 14:01:43 +0800
Message-ID: <201712211345.VH1w6C1l%fengguang.wu@intel.com>
References: <20171220065644.21511-20-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga02.intel.com ([134.134.136.20]:25154 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750782AbdLUGBv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Dec 2017 01:01:51 -0500
Content-Disposition: inline
In-Reply-To: <20171220065644.21511-20-himanshu.madhani@cavium.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
Cc: kbuild-all@01.org, James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com, himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org

Hi Quinn,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20171220]
[cannot apply to v4.15-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Driver-update/20171221-085840
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__


sparse warnings: (new ones prefixed by >>)


vim +4828 drivers/scsi/qla2xxx/qla_os.c

  4743	
  4744	static
  4745	void qla24xx_create_new_sess(struct scsi_qla_host *vha, struct qla_work_evt *e)
  4746	{
  4747		unsigned long flags;
  4748		fc_port_t *fcport =  NULL, *tfcp;
  4749		struct qlt_plogi_ack_t *pla =
  4750		    (struct qlt_plogi_ack_t *)e->u.new_sess.pla;
  4751		uint8_t free_fcport = 0;
  4752	
  4753		ql_dbg(ql_dbg_disc, vha, 0xffff,
  4754		    "%s %d %8phC enter\n",
  4755		    __func__, __LINE__, e->u.new_sess.port_name);
  4756	
  4757		spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
  4758		fcport = qla2x00_find_fcport_by_wwpn(vha, e->u.new_sess.port_name, 1);
  4759		if (fcport) {
  4760			fcport->d_id = e->u.new_sess.id;
  4761			if (pla) {
  4762				fcport->fw_login_state = DSC_LS_PLOGI_PEND;
  4763				memcpy(fcport->node_name,
  4764				    pla->iocb.u.isp24.u.plogi.node_name,
  4765				    WWN_SIZE);
  4766				qlt_plogi_ack_link(vha, pla, fcport, QLT_PLOGI_LINK_SAME_WWN);
  4767				/* we took an extra ref_count to prevent PLOGI ACK when
  4768				 * fcport/sess has not been created.
  4769				 */
  4770				pla->ref_count--;
  4771			}
  4772		} else {
  4773			spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
  4774			fcport = qla2x00_alloc_fcport(vha, GFP_KERNEL);
  4775			if (fcport) {
  4776				fcport->d_id = e->u.new_sess.id;
  4777				fcport->scan_state = QLA_FCPORT_FOUND;
  4778				fcport->flags |= FCF_FABRIC_DEVICE;
  4779				fcport->fw_login_state = DSC_LS_PLOGI_PEND;
  4780	
  4781				memcpy(fcport->port_name, e->u.new_sess.port_name,
  4782				    WWN_SIZE);
  4783			} else {
  4784				ql_dbg(ql_dbg_disc, vha, 0xffff,
  4785					   "%s %8phC mem alloc fail.\n",
  4786					   __func__, e->u.new_sess.port_name);
  4787	
  4788				if (pla)
  4789					kmem_cache_free(qla_tgt_plogi_cachep, pla);
  4790				return;
  4791			}
  4792	
  4793			spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
  4794			/* search again to make sure one else got ahead */
  4795			tfcp = qla2x00_find_fcport_by_wwpn(vha,
  4796			    e->u.new_sess.port_name, 1);
  4797			if (tfcp) {
  4798				/* should rarily happen */
  4799				ql_dbg(ql_dbg_disc, vha, 0xffff,
  4800				    "%s %8phC found existing fcport b4 add. DS %d LS %d\n",
  4801				    __func__, tfcp->port_name, tfcp->disc_state,
  4802				    tfcp->fw_login_state);
  4803	
  4804				free_fcport = 1;
  4805			} else {
  4806				list_add_tail(&fcport->list, &vha->vp_fcports);
  4807	
  4808			}
  4809			if (pla) {
  4810				qlt_plogi_ack_link(vha, pla, fcport,
  4811				    QLT_PLOGI_LINK_SAME_WWN);
  4812				pla->ref_count--;
  4813			}
  4814		}
  4815		spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
  4816	
  4817		if (fcport) {
  4818			if (N2N_TOPO(vha->hw))
  4819				fcport->flags &= ~FCF_FABRIC_DEVICE;
  4820	
  4821			if (pla) {
  4822				if (pla->iocb.u.isp24.status_subcode == ELS_PRLI) {
  4823					u16 wd3_lo;
  4824	
  4825					fcport->fw_login_state = DSC_LS_PRLI_PEND;
  4826					fcport->local = 0;
  4827					fcport->loop_id =
> 4828						le16_to_cpu(
  4829						    pla->iocb.u.isp24.nport_handle);
  4830					fcport->fw_login_state = DSC_LS_PRLI_PEND;
  4831					wd3_lo =
  4832					    le16_to_cpu(
  4833						pla->iocb.u.isp24.u.prli.wd3_lo);
  4834	
  4835					if (wd3_lo & BIT_7)
  4836						fcport->conf_compl_supported = 1;
  4837	
  4838					if ((wd3_lo & BIT_4) == 0)
  4839						fcport->port_type = FCT_INITIATOR;
  4840					else
  4841						fcport->port_type = FCT_TARGET;
  4842				}
  4843				qlt_plogi_ack_unref(vha, pla);
  4844			} else {
  4845				spin_lock_irqsave(&vha->hw->tgt.sess_lock, flags);
  4846				tfcp = qla2x00_find_fcport_by_nportid(vha,
  4847				    &e->u.new_sess.id, 1);
  4848				if (tfcp && (tfcp != fcport)) {
  4849					/*
  4850					 * We have a conflict fcport with same NportID.
  4851					 */
  4852					ql_dbg(ql_dbg_disc, vha, 0xffff,
  4853					    "%s %8phC found conflict b4 add. DS %d LS %d\n",
  4854					    __func__, tfcp->port_name, tfcp->disc_state,
  4855					    tfcp->fw_login_state);
  4856	
  4857					switch (tfcp->disc_state) {
  4858					case DSC_DELETED:
  4859						break;
  4860					case DSC_DELETE_PEND:
  4861						fcport->login_pause = 1;
  4862						tfcp->conflict = fcport;
  4863						break;
  4864					default:
  4865						fcport->login_pause = 1;
  4866						tfcp->conflict = fcport;
  4867						qlt_schedule_sess_for_deletion_lock
  4868							(tfcp);
  4869						break;
  4870					}
  4871				}
  4872				spin_unlock_irqrestore(&vha->hw->tgt.sess_lock, flags);
  4873				qla24xx_async_gnl(vha, fcport);
  4874			}
  4875		}
  4876	
  4877		if (free_fcport) {
  4878			qla2x00_free_fcport(fcport);
  4879			if (pla)
  4880				kmem_cache_free(qla_tgt_plogi_cachep, pla);
  4881		}
  4882	}
  4883	

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
