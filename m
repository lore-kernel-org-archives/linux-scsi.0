From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH v2 2/3] qla2xxx: on session delete return nvme
 cmd
Date: Wed, 26 Jun 2019 09:20:22 +0300
Message-ID: <20190626062022.GB18776@kadam>
References: <20190618181021.16547-3-hmadhani@marvell.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20190618181021.16547-3-hmadhani@marvell.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org
Cc: James.Bottomley@HansenPartnership.com, hmadhani@marvell.com, kbuild-all@01.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Himanshu,

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Fix-crashes-with-FC-NVMe-devices/20190619-074559
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
drivers/scsi/qla2xxx/qla_nvme.c:245 qla_nvme_ls_req() warn: variable dereferenced before check 'fcport' (see line 242)
drivers/scsi/qla2xxx/qla_nvme.c:496 qla_nvme_post_cmd() warn: variable dereferenced before check 'fcport' (see line 494)
drivers/scsi/qla2xxx/qla_nvme.c:510 qla_nvme_post_cmd() error: we previously assumed 'qpair' could be null (see line 496)

Old smatch warnings:
drivers/scsi/qla2xxx/qla_nvme.c:190 qla_nvme_abort_work() warn: variable dereferenced before check 'fcport' (see line 183)

# https://github.com/0day-ci/linux/commit/69efeca5ca5e394664f54ef8e349a31b0f424507
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 69efeca5ca5e394664f54ef8e349a31b0f424507
vim +/fcport +245 drivers/scsi/qla2xxx/qla_nvme.c

e84067d7 Duane Grigsby               2017-06-21  230  static int qla_nvme_ls_req(struct nvme_fc_local_port *lport,
e84067d7 Duane Grigsby               2017-06-21  231      struct nvme_fc_remote_port *rport, struct nvmefc_ls_req *fd)
e84067d7 Duane Grigsby               2017-06-21  232  {
9dd9686b Darren Trapp                2018-03-20  233  	struct qla_nvme_rport *qla_rport = rport->private;
9dd9686b Darren Trapp                2018-03-20  234  	fc_port_t *fcport = qla_rport->fcport;
e84067d7 Duane Grigsby               2017-06-21  235  	struct srb_iocb   *nvme;
e84067d7 Duane Grigsby               2017-06-21  236  	struct nvme_private *priv = fd->private;
e84067d7 Duane Grigsby               2017-06-21  237  	struct scsi_qla_host *vha;
e84067d7 Duane Grigsby               2017-06-21  238  	int     rval = QLA_FUNCTION_FAILED;
e84067d7 Duane Grigsby               2017-06-21  239  	struct qla_hw_data *ha;
e84067d7 Duane Grigsby               2017-06-21  240  	srb_t           *sp;
e84067d7 Duane Grigsby               2017-06-21  241  
e84067d7 Duane Grigsby               2017-06-21 @242  	vha = fcport->vha;
                                                              ^^^^^^^^^^^
Dereference.

e84067d7 Duane Grigsby               2017-06-21  243  	ha = vha->hw;
69efeca5 Quinn Tran                  2019-06-18  244  
69efeca5 Quinn Tran                  2019-06-18 @245  	if (!ha->flags.fw_started || (fcport && fcport->deleted))
                                                                                      ^^^^^^
Check for NULL is too late.

69efeca5 Quinn Tran                  2019-06-18  246  		return rval;
69efeca5 Quinn Tran                  2019-06-18  247  
e84067d7 Duane Grigsby               2017-06-21  248  	/* Alloc SRB structure */
e84067d7 Duane Grigsby               2017-06-21  249  	sp = qla2x00_get_sp(vha, fcport, GFP_ATOMIC);
e84067d7 Duane Grigsby               2017-06-21  250  	if (!sp)
e84067d7 Duane Grigsby               2017-06-21  251  		return rval;
e84067d7 Duane Grigsby               2017-06-21  252  
e84067d7 Duane Grigsby               2017-06-21  253  	sp->type = SRB_NVME_LS;
