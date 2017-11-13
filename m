From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 4/4] qla2xxx_nvmet: Add FC-NVMe Target handling
Date: Mon, 13 Nov 2017 11:24:02 +0300
Message-ID: <20171113082402.yt7ixsjrbonssqqd@mwanda>
References: <20171106195530.17408-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20171106195530.17408-5-himanshu.madhani@cavium.com>
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
Cc: himanshu.madhani@cavium.com, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

[ Ha ha.  The kbuild-bot automatically inserts complimentary things that
  "I love your patch."  In fact, I have not looked at your patch at all,
  I'm just forwarding this email from a robot after glancing at the
  code.  - dan carpenter ]

Hi Anil,

I love your patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on next-20171110]
[cannot apply to v4.14]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Add-FC-NVMe-Target-support/20171107-153645
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next

drivers/scsi/qla2xxx/qla_target.c:886 qlt_queue_purex() warn: taking sizeof binop
drivers/scsi/qla2xxx/qla_target.c:893 qlt_queue_purex() error: memcpy() 'p->purex_pyld' too small (4 vs 44)

# https://github.com/0day-ci/linux/commit/9c5e24e821aa40552221b3103bc914bc4cd42293
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 9c5e24e821aa40552221b3103bc914bc4cd42293
vim +886 drivers/scsi/qla2xxx/qla_target.c

9c5e24e8 Anil Gurumurthy 2017-11-06  863  
9c5e24e8 Anil Gurumurthy 2017-11-06  864  static void qlt_queue_purex(scsi_qla_host_t *vha,
9c5e24e8 Anil Gurumurthy 2017-11-06  865  	struct atio_from_isp *atio)
9c5e24e8 Anil Gurumurthy 2017-11-06  866  {
9c5e24e8 Anil Gurumurthy 2017-11-06  867  	struct qla_tgt_purex_op *p;
9c5e24e8 Anil Gurumurthy 2017-11-06  868  	unsigned long flags;
9c5e24e8 Anil Gurumurthy 2017-11-06  869  	struct purex_entry_24xx *purex =
9c5e24e8 Anil Gurumurthy 2017-11-06  870  		(struct purex_entry_24xx *)&atio->u.raw;
9c5e24e8 Anil Gurumurthy 2017-11-06  871  	uint16_t len = purex->frame_size;
9c5e24e8 Anil Gurumurthy 2017-11-06  872  	uint8_t *purex_pyld_tmp;
9c5e24e8 Anil Gurumurthy 2017-11-06  873  
9c5e24e8 Anil Gurumurthy 2017-11-06  874  	p = kzalloc(sizeof(*p), GFP_ATOMIC);
9c5e24e8 Anil Gurumurthy 2017-11-06  875  	if (p == NULL)
9c5e24e8 Anil Gurumurthy 2017-11-06  876  		goto out;
9c5e24e8 Anil Gurumurthy 2017-11-06  877  
9c5e24e8 Anil Gurumurthy 2017-11-06  878  	p->vha = vha;
9c5e24e8 Anil Gurumurthy 2017-11-06  879  	memcpy(&p->atio, atio, sizeof(*atio));
9c5e24e8 Anil Gurumurthy 2017-11-06  880  
9c5e24e8 Anil Gurumurthy 2017-11-06  881  	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xff11,
9c5e24e8 Anil Gurumurthy 2017-11-06  882  	    "Dumping the Purex IOCB received\n");
9c5e24e8 Anil Gurumurthy 2017-11-06  883  	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe012,
9c5e24e8 Anil Gurumurthy 2017-11-06  884  		(uint8_t *)purex, 64);
9c5e24e8 Anil Gurumurthy 2017-11-06  885  
9c5e24e8 Anil Gurumurthy 2017-11-06 @886  	p->purex_pyld = kzalloc(sizeof(purex->entry_count * 64), GFP_ATOMIC);
9c5e24e8 Anil Gurumurthy 2017-11-06  887  	purex_pyld_tmp = (uint8_t *)p->purex_pyld;
9c5e24e8 Anil Gurumurthy 2017-11-06  888  	p->purex_pyld_len = len;
9c5e24e8 Anil Gurumurthy 2017-11-06  889  
9c5e24e8 Anil Gurumurthy 2017-11-06  890  	if (len < PUREX_PYLD_SIZE)
9c5e24e8 Anil Gurumurthy 2017-11-06  891  		len = PUREX_PYLD_SIZE;
9c5e24e8 Anil Gurumurthy 2017-11-06  892  
9c5e24e8 Anil Gurumurthy 2017-11-06 @893  	memcpy(p->purex_pyld, &purex->d_id, PUREX_PYLD_SIZE);
9c5e24e8 Anil Gurumurthy 2017-11-06  894  	purex_pyld_tmp += PUREX_PYLD_SIZE;
9c5e24e8 Anil Gurumurthy 2017-11-06  895  	len -= PUREX_PYLD_SIZE;
9c5e24e8 Anil Gurumurthy 2017-11-06  896  
9c5e24e8 Anil Gurumurthy 2017-11-06  897  	while (len > 0) {
9c5e24e8 Anil Gurumurthy 2017-11-06  898  		int cpylen;
9c5e24e8 Anil Gurumurthy 2017-11-06  899  		struct __status_cont *cont_atio;
9c5e24e8 Anil Gurumurthy 2017-11-06  900  
9c5e24e8 Anil Gurumurthy 2017-11-06  901  		cont_atio = (struct __status_cont *)qlt_get_next_atio_pkt(vha);
9c5e24e8 Anil Gurumurthy 2017-11-06  902  		cpylen = len > CONT_SENSE_DATA ? CONT_SENSE_DATA : len;
9c5e24e8 Anil Gurumurthy 2017-11-06  903  		ql_log(ql_log_info, vha, 0xff12,
9c5e24e8 Anil Gurumurthy 2017-11-06  904  		    "cont_atio: %p, cpylen: %#x\n", cont_atio, cpylen);
9c5e24e8 Anil Gurumurthy 2017-11-06  905  
9c5e24e8 Anil Gurumurthy 2017-11-06  906  		memcpy(purex_pyld_tmp, &cont_atio->data[0], cpylen);
9c5e24e8 Anil Gurumurthy 2017-11-06  907  
9c5e24e8 Anil Gurumurthy 2017-11-06  908  		purex_pyld_tmp += cpylen;
9c5e24e8 Anil Gurumurthy 2017-11-06  909  		len -= cpylen;
9c5e24e8 Anil Gurumurthy 2017-11-06  910  	}
9c5e24e8 Anil Gurumurthy 2017-11-06  911  
9c5e24e8 Anil Gurumurthy 2017-11-06  912  	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xff11,
9c5e24e8 Anil Gurumurthy 2017-11-06  913  	    "Dumping the Purex IOCB(%p) received\n", p->purex_pyld);
9c5e24e8 Anil Gurumurthy 2017-11-06  914  	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe011,
9c5e24e8 Anil Gurumurthy 2017-11-06  915  		(uint8_t *)p->purex_pyld, p->purex_pyld_len);
9c5e24e8 Anil Gurumurthy 2017-11-06  916  
9c5e24e8 Anil Gurumurthy 2017-11-06  917  	INIT_LIST_HEAD(&p->cmd_list);
9c5e24e8 Anil Gurumurthy 2017-11-06  918  
9c5e24e8 Anil Gurumurthy 2017-11-06  919  	spin_lock_irqsave(&vha->cmd_list_lock, flags);
9c5e24e8 Anil Gurumurthy 2017-11-06  920  	list_add_tail(&p->cmd_list, &vha->purex_atio_list);
9c5e24e8 Anil Gurumurthy 2017-11-06  921  	spin_unlock_irqrestore(&vha->cmd_list_lock, flags);
9c5e24e8 Anil Gurumurthy 2017-11-06  922  
9c5e24e8 Anil Gurumurthy 2017-11-06  923  out:
9c5e24e8 Anil Gurumurthy 2017-11-06  924  	return;
9c5e24e8 Anil Gurumurthy 2017-11-06  925  }
9c5e24e8 Anil Gurumurthy 2017-11-06  926  
