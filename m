From: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3 08/12] qla2xxx: Add framework for Async fabric
 discovery.
Date: Thu, 19 Jan 2017 09:11:25 +0100 (CET)
Message-ID: <alpine.DEB.2.20.1701190909480.3148@hadrien>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
Cc: target-devel@vger.kernel.org, bart.vanassche@gmail.com, hch@infradead.org, nab@linux-iscsi.org, giridhar.malavali@cavium.com, linux-scsi@vger.kernel.org, himanshu.madhani@cavium.com, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

Hello,

I don't have the compete context, but I have the impression that there
should be a goto done at which sp can be NULL.

julia

---------- Forwarded message ----------
Date: Thu, 19 Jan 2017 12:38:31 +0800
From: kbuild test robot <fengguang.wu@intel.com>
To: kbuild@01.org
Cc: Julia Lawall <julia.lawall@lip6.fr>
Subject: Re: [PATCH v3 08/12] qla2xxx: Add framework for Async fabric discovery.

In-Reply-To: <1484781585-27252-9-git-send-email-himanshu.madhani@cavium.com>

Hi Quinn,

[auto build test WARNING on next-20170118]
[cannot apply to scsi/for-next v4.9-rc8 v4.9-rc7 v4.9-rc6 v4.10-rc4]
[if your patch is applied to the wrong git tree, please drop us a note to help improve the system]

url:    https://github.com/0day-ci/linux/commits/Himanshu-Madhani/qla2xxx-Feature-updates-for-target/20170119-105115
:::::: branch date: 2 hours ago
:::::: commit date: 2 hours ago

>> drivers/scsi/qla2xxx/qla_init.c:269:5-11: ERROR: sp is NULL but dereferenced.

git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout 8cf2e24938dd5d941b2edc9786f8e1ad8c80d9af
vim +269 drivers/scsi/qla2xxx/qla_init.c

3822263eb Madhuranath Iyengar 2010-05-04  253  	lio->timeout = qla2x00_async_iocb_timeout;
9ba56b95a Giridhar Malavali   2012-02-09  254  	sp->done = qla2x00_async_logout_sp_done;
ac280b670 Andrew Vasquez      2009-08-20  255  	rval = qla2x00_start_sp(sp);
ac280b670 Andrew Vasquez      2009-08-20  256  	if (rval != QLA_SUCCESS)
ac280b670 Andrew Vasquez      2009-08-20  257  		goto done_free_sp;
ac280b670 Andrew Vasquez      2009-08-20  258
7c3df1320 Saurav Kashyap      2011-07-14  259  	ql_dbg(ql_dbg_disc, vha, 0x2070,
8cf2e2493 Quinn Tran          2017-01-18  260  	    "Async-logout - hdl=%x loop-id=%x portid=%02x%02x%02x %8phC.\n",
cfb0919c1 Chad Dupuis         2011-11-18  261  	    sp->handle, fcport->loop_id, fcport->d_id.b.domain,
8cf2e2493 Quinn Tran          2017-01-18  262  		fcport->d_id.b.area, fcport->d_id.b.al_pa,
8cf2e2493 Quinn Tran          2017-01-18  263  		fcport->port_name);
ac280b670 Andrew Vasquez      2009-08-20  264  	return rval;
ac280b670 Andrew Vasquez      2009-08-20  265
ac280b670 Andrew Vasquez      2009-08-20  266  done_free_sp:
9ba56b95a Giridhar Malavali   2012-02-09  267  	sp->free(fcport->vha, sp);
ac280b670 Andrew Vasquez      2009-08-20  268  done:
8cf2e2493 Quinn Tran          2017-01-18 @269  	sp->fcport->flags &= ~FCF_ASYNC_SENT;
ac280b670 Andrew Vasquez      2009-08-20  270  	return rval;
ac280b670 Andrew Vasquez      2009-08-20  271  }
ac280b670 Andrew Vasquez      2009-08-20  272
5ff1d5841 Andrew Vasquez      2010-05-04  273  static void
9ba56b95a Giridhar Malavali   2012-02-09  274  qla2x00_async_adisc_sp_done(void *data, void *ptr, int res)
5ff1d5841 Andrew Vasquez      2010-05-04  275  {
9ba56b95a Giridhar Malavali   2012-02-09  276  	srb_t *sp = (srb_t *)ptr;
9ba56b95a Giridhar Malavali   2012-02-09  277  	struct srb_iocb *lio = &sp->u.iocb_cmd;

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
