From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 13/19] sg: sgat_elem_sz and sum_fd_dlens
Date: Mon, 27 May 2019 11:28:52 +0300
Message-ID: <20190527082852.GF24680@kadam>
References: <20190524184809.25121-14-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20190524184809.25121-14-dgilbert@interlog.com>
List-Unsubscribe: <https://lists.01.org/mailman/options/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=unsubscribe>
List-Archive: <http://lists.01.org/pipermail/kbuild/>
List-Post: <mailto:kbuild@lists.01.org>
List-Help: <mailto:kbuild-request@lists.01.org?subject=help>
List-Subscribe: <https://lists.01.org/mailman/listinfo/kbuild>,
 <mailto:kbuild-request@lists.01.org?subject=subscribe>
Errors-To: kbuild-bounces@lists.01.org
Sender: "kbuild" <kbuild-bounces@lists.01.org>
To: kbuild@01.org, Douglas Gilbert <dgilbert@interlog.com>
Cc: jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-scsi@vger.kernel.org, hare@suse.de, bart.vanassche@wdc.com, kbuild-all@01.org
List-Id: linux-scsi@vger.kernel.org

Hi Douglas,

Thank you for the patch! Perhaps something to improve:

url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-v4-interface-rq-sharing-multiple-rqs/20190525-161346
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

New smatch warnings:
drivers/scsi/sg.c:3374 sg_remove_sgat() error: we previously assumed 'sfp' could be null (see line 3367)

Old smatch warnings:
drivers/scsi/sg.c:4383 sg_proc_seq_show_dbg() warn: returning -1 instead of -ENOMEM is sloppy

# https://github.com/0day-ci/linux/commit/ecbddf3329c05a33a780f39084acb2f104067d6a
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout ecbddf3329c05a33a780f39084acb2f104067d6a
vim +/sfp +3374 drivers/scsi/sg.c

c5ad643d Douglas Gilbert 2019-05-24  3358  
c5ad643d Douglas Gilbert 2019-05-24  3359  /* Remove the data (possibly a sgat list) held by srp, not srp itself */
c5ad643d Douglas Gilbert 2019-05-24  3360  static void
c5ad643d Douglas Gilbert 2019-05-24  3361  sg_remove_sgat(struct sg_request *srp)
c5ad643d Douglas Gilbert 2019-05-24  3362  {
c5ad643d Douglas Gilbert 2019-05-24  3363  	struct sg_scatter_hold *schp = &srp->sgat_h; /* care: remove own data */
c5ad643d Douglas Gilbert 2019-05-24  3364  	struct sg_fd *sfp = srp->parentfp;
c5ad643d Douglas Gilbert 2019-05-24  3365  	struct sg_device *sdp;
c5ad643d Douglas Gilbert 2019-05-24  3366  
c5ad643d Douglas Gilbert 2019-05-24 @3367  	sdp = (sfp ? sfp->parentdp : NULL);
                                                       ^^^
Null heck

c5ad643d Douglas Gilbert 2019-05-24  3368  	SG_LOG(4, sdp, "%s: num_sgat=%d%s\n", __func__, schp->num_sgat,
c5ad643d Douglas Gilbert 2019-05-24  3369  	       ((srp->parentfp ? (sfp->rsv_srp == srp) : false) ?
c5ad643d Douglas Gilbert 2019-05-24  3370  		" [rsv]" : ""));
c5ad643d Douglas Gilbert 2019-05-24  3371  	if (!test_bit(SG_FRQ_DIO_IN_USE, srp->frq_bm))
c5ad643d Douglas Gilbert 2019-05-24  3372  		sg_remove_sgat_helper(sdp, schp);
c5ad643d Douglas Gilbert 2019-05-24  3373  
ecbddf33 Douglas Gilbert 2019-05-24 @3374  	if (sfp->tot_fd_thresh > 0) {
                                                    ^^^^^^^^^^^^^^^^^^
Unchecked dereference.

ecbddf33 Douglas Gilbert 2019-05-24  3375  		/* this is a subtraction, error if it goes negative */
ecbddf33 Douglas Gilbert 2019-05-24  3376  		if (atomic_add_negative(-schp->buflen, &sfp->sum_fd_dlens)) {
ecbddf33 Douglas Gilbert 2019-05-24  3377  			SG_LOG(2, sfp->parentdp,
ecbddf33 Douglas Gilbert 2019-05-24  3378  			       "%s: logic error: this dlen > %s\n",
ecbddf33 Douglas Gilbert 2019-05-24  3379  			       __func__, "sum_fd_dlens");
ecbddf33 Douglas Gilbert 2019-05-24  3380  			atomic_set(&sfp->sum_fd_dlens, 0);
ecbddf33 Douglas Gilbert 2019-05-24  3381  		}
ecbddf33 Douglas Gilbert 2019-05-24  3382  	}
c5ad643d Douglas Gilbert 2019-05-24  3383  	memset(schp, 0, sizeof(*schp));         /* zeros buflen and dlen */
^1da177e Linus Torvalds  2005-04-16  3384  }
^1da177e Linus Torvalds  2005-04-16  3385  
