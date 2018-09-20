From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 4/6] qla2xxx_nvmet: Add FC-NVMe Target handling
Date: Thu, 20 Sep 2018 12:57:14 +0300
Message-ID: <20180920095713.o7wqmeb4nwricksp@mwanda>
References: <20180914212811.11463-5-himanshu.madhani@cavium.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20180914212811.11463-5-himanshu.madhani@cavium.com>
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
Cc: James.Bottomley@HansenPartnership.com, himanshu.madhani@cavium.com, kbuild-all@01.org, martin.petersen@oracle.com, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi Anil,

I love your patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Add-FC-NVMe-Target-support/20180916-090108
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next

smatch warnings:
drivers/scsi/qla2xxx/qla_target.c:891 qlt_queue_purex() warn: taking sizeof binop
drivers/scsi/qla2xxx/qla_target.c:902 qlt_queue_purex() error: memcpy() 'p->purex_pyld' too small (4 vs 44)

# https://github.com/0day-ci/linux/commit/51867b7ad96cb9b1d5a96effc476a2e5a48293ae
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 51867b7ad96cb9b1d5a96effc476a2e5a48293ae
vim +891 drivers/scsi/qla2xxx/qla_target.c

51867b7a Anil Gurumurthy 2018-09-14  868  
51867b7a Anil Gurumurthy 2018-09-14  869  static void qlt_queue_purex(scsi_qla_host_t *vha,
51867b7a Anil Gurumurthy 2018-09-14  870  	struct atio_from_isp *atio)
51867b7a Anil Gurumurthy 2018-09-14  871  {
51867b7a Anil Gurumurthy 2018-09-14  872  	struct qla_tgt_purex_op *p;
51867b7a Anil Gurumurthy 2018-09-14  873  	unsigned long flags;
51867b7a Anil Gurumurthy 2018-09-14  874  	struct purex_entry_24xx *purex =
51867b7a Anil Gurumurthy 2018-09-14  875  		(struct purex_entry_24xx *)&atio->u.raw;
51867b7a Anil Gurumurthy 2018-09-14  876  	uint16_t len = purex->frame_size;
51867b7a Anil Gurumurthy 2018-09-14  877  	uint8_t *purex_pyld_tmp;
51867b7a Anil Gurumurthy 2018-09-14  878  
51867b7a Anil Gurumurthy 2018-09-14  879  	p = kzalloc(sizeof(*p), GFP_ATOMIC);
51867b7a Anil Gurumurthy 2018-09-14  880  	if (p == NULL)
51867b7a Anil Gurumurthy 2018-09-14  881  		goto out;
51867b7a Anil Gurumurthy 2018-09-14  882  
51867b7a Anil Gurumurthy 2018-09-14  883  	p->vha = vha;
51867b7a Anil Gurumurthy 2018-09-14  884  	memcpy(&p->atio, atio, sizeof(*atio));
51867b7a Anil Gurumurthy 2018-09-14  885  
51867b7a Anil Gurumurthy 2018-09-14  886  	ql_dbg(ql_dbg_disc + ql_dbg_buffer, vha, 0xff11,
51867b7a Anil Gurumurthy 2018-09-14  887  	    "Dumping the Purex IOCB received\n");
51867b7a Anil Gurumurthy 2018-09-14  888  	ql_dump_buffer(ql_dbg_disc + ql_dbg_buffer, vha, 0xe012,
51867b7a Anil Gurumurthy 2018-09-14  889  		(uint8_t *)purex, 64);
51867b7a Anil Gurumurthy 2018-09-14  890  
51867b7a Anil Gurumurthy 2018-09-14 @891  	p->purex_pyld = kzalloc(sizeof(purex->entry_count * 64), GFP_ATOMIC);
                                                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
The parens are wrong so

51867b7a Anil Gurumurthy 2018-09-14  892  	if (p->purex_pyld == NULL) {
51867b7a Anil Gurumurthy 2018-09-14  893  		kfree(p);
51867b7a Anil Gurumurthy 2018-09-14  894  		goto out;
51867b7a Anil Gurumurthy 2018-09-14  895  	}
51867b7a Anil Gurumurthy 2018-09-14  896  	purex_pyld_tmp = (uint8_t *)p->purex_pyld;
51867b7a Anil Gurumurthy 2018-09-14  897  	p->purex_pyld_len = len;
51867b7a Anil Gurumurthy 2018-09-14  898  
51867b7a Anil Gurumurthy 2018-09-14  899  	if (len < PUREX_PYLD_SIZE)
51867b7a Anil Gurumurthy 2018-09-14  900  		len = PUREX_PYLD_SIZE;
51867b7a Anil Gurumurthy 2018-09-14  901  
51867b7a Anil Gurumurthy 2018-09-14 @902  	memcpy(p->purex_pyld, &purex->d_id, PUREX_PYLD_SIZE);
                                                       ^^^^^^^^^^^^^
it leads to a memory corruption warning as well.

51867b7a Anil Gurumurthy 2018-09-14  903  	purex_pyld_tmp += PUREX_PYLD_SIZE;
51867b7a Anil Gurumurthy 2018-09-14  904  	len -= PUREX_PYLD_SIZE;
51867b7a Anil Gurumurthy 2018-09-14  905  
