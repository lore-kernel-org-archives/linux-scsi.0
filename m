From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [PATCH 05/19] sg: replace rq array with lists
Date: Mon, 27 May 2019 10:11:42 +0300
Message-ID: <20190527071142.GD24680@kadam>
References: <20190524184809.25121-6-dgilbert@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <kbuild-bounces@lists.01.org>
Content-Disposition: inline
In-Reply-To: <20190524184809.25121-6-dgilbert@interlog.com>
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
drivers/scsi/sg.c:3637 sg_proc_seq_show_dbg() warn: returning -1 instead of -ENOMEM is sloppy

Old smatch warnings:
drivers/scsi/sg.c:3520 sg_proc_dbg_sreq() error: uninitialized symbol 'is_dur'.

# https://github.com/0day-ci/linux/commit/c5ad643d999d34c92f76e1459be33e2c1321f699
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout c5ad643d999d34c92f76e1459be33e2c1321f699
vim +3637 drivers/scsi/sg.c

c5ad643d9 Douglas Gilbert 2019-05-24  3610  
c5ad643d9 Douglas Gilbert 2019-05-24  3611  /* Called via dbg_seq_ops once for each sg device */
b600cfdd9 Douglas Gilbert 2019-05-24  3612  static int
c5ad643d9 Douglas Gilbert 2019-05-24  3613  sg_proc_seq_show_dbg(struct seq_file *s, void *v)
^1da177e4 Linus Torvalds  2005-04-16  3614  {
c5ad643d9 Douglas Gilbert 2019-05-24  3615  	bool found = false;
c5ad643d9 Douglas Gilbert 2019-05-24  3616  	bool trunc = false;
c5ad643d9 Douglas Gilbert 2019-05-24  3617  	const int bp_len = SG_PROC_DEBUG_SZ;
c5ad643d9 Douglas Gilbert 2019-05-24  3618  	int n = 0;
c5ad643d9 Douglas Gilbert 2019-05-24  3619  	int k = 0;
c5ad643d9 Douglas Gilbert 2019-05-24  3620  	unsigned long iflags;
^1da177e4 Linus Torvalds  2005-04-16  3621  	struct sg_proc_deviter *it = (struct sg_proc_deviter *)v;
b600cfdd9 Douglas Gilbert 2019-05-24  3622  	struct sg_device *sdp;
c5ad643d9 Douglas Gilbert 2019-05-24  3623  	int *fdi_p;
c5ad643d9 Douglas Gilbert 2019-05-24  3624  	char *bp;
c5ad643d9 Douglas Gilbert 2019-05-24  3625  	char *disk_name;
c5ad643d9 Douglas Gilbert 2019-05-24  3626  	char b1[128];
^1da177e4 Linus Torvalds  2005-04-16  3627  
c5ad643d9 Douglas Gilbert 2019-05-24  3628  	b1[0] = '\0';
cc833acbe Douglas Gilbert 2014-06-25  3629  	if (it && (0 == it->index))
cc833acbe Douglas Gilbert 2014-06-25  3630  		seq_printf(s, "max_active_device=%d  def_reserved_size=%d\n",
c5ad643d9 Douglas Gilbert 2019-05-24  3631  			   (int)it->max, def_reserved_size);
c5ad643d9 Douglas Gilbert 2019-05-24  3632  	fdi_p = it ? &it->fd_index : &k;
c5ad643d9 Douglas Gilbert 2019-05-24  3633  	bp = kzalloc(bp_len, __GFP_NOWARN | GFP_KERNEL);
c5ad643d9 Douglas Gilbert 2019-05-24  3634  	if (!bp) {
c5ad643d9 Douglas Gilbert 2019-05-24  3635  		seq_printf(s, "%s: Unable to allocate %d on heap, finish\n",
c5ad643d9 Douglas Gilbert 2019-05-24  3636  			   __func__, bp_len);
c5ad643d9 Douglas Gilbert 2019-05-24 @3637  		return -1;
                                                        ^^^^^^^^^
-1 is -EPERM.

c5ad643d9 Douglas Gilbert 2019-05-24  3638  	}
c6517b794 Tony Battersby  2009-01-21  3639  	read_lock_irqsave(&sg_index_lock, iflags);
c6517b794 Tony Battersby  2009-01-21  3640  	sdp = it ? sg_lookup_dev(it->index) : NULL;
cc833acbe Douglas Gilbert 2014-06-25  3641  	if (NULL == sdp)
cc833acbe Douglas Gilbert 2014-06-25  3642  		goto skip;
c5ad643d9 Douglas Gilbert 2019-05-24  3643  	read_lock(&sdp->sfd_llock);
cc833acbe Douglas Gilbert 2014-06-25  3644  	if (!list_empty(&sdp->sfds)) {
c5ad643d9 Douglas Gilbert 2019-05-24  3645  		found = true;
c5ad643d9 Douglas Gilbert 2019-05-24  3646  		disk_name = (sdp->disk ? sdp->disk->disk_name : "?_?");
cc833acbe Douglas Gilbert 2014-06-25  3647  		if (atomic_read(&sdp->detaching))
c5ad643d9 Douglas Gilbert 2019-05-24  3648  			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
c5ad643d9 Douglas Gilbert 2019-05-24  3649  				 disk_name, "detaching pending close\n");
cc833acbe Douglas Gilbert 2014-06-25  3650  		else if (sdp->device) {
c5ad643d9 Douglas Gilbert 2019-05-24  3651  			n = sg_proc_dbg_sdev(sdp, bp, bp_len, fdi_p);
c5ad643d9 Douglas Gilbert 2019-05-24  3652  			if (n >= bp_len - 1) {
c5ad643d9 Douglas Gilbert 2019-05-24  3653  				trunc = true;
c5ad643d9 Douglas Gilbert 2019-05-24  3654  				if (bp[bp_len - 2] != '\n')
c5ad643d9 Douglas Gilbert 2019-05-24  3655  					bp[bp_len - 2] = '\n';
c5ad643d9 Douglas Gilbert 2019-05-24  3656  			}
c5ad643d9 Douglas Gilbert 2019-05-24  3657  		} else {
c5ad643d9 Douglas Gilbert 2019-05-24  3658  			snprintf(b1, sizeof(b1), " >>> device=%s  %s\n",
c5ad643d9 Douglas Gilbert 2019-05-24  3659  				 disk_name, "sdp->device==NULL, skip");
cc833acbe Douglas Gilbert 2014-06-25  3660  		}
^1da177e4 Linus Torvalds  2005-04-16  3661  	}
c5ad643d9 Douglas Gilbert 2019-05-24  3662  	read_unlock(&sdp->sfd_llock);
cc833acbe Douglas Gilbert 2014-06-25  3663  skip:
c6517b794 Tony Battersby  2009-01-21  3664  	read_unlock_irqrestore(&sg_index_lock, iflags);
c5ad643d9 Douglas Gilbert 2019-05-24  3665  	if (found) {
c5ad643d9 Douglas Gilbert 2019-05-24  3666  		if (n > 0) {
c5ad643d9 Douglas Gilbert 2019-05-24  3667  			seq_puts(s, bp);
c5ad643d9 Douglas Gilbert 2019-05-24  3668  			if (seq_has_overflowed(s))
c5ad643d9 Douglas Gilbert 2019-05-24  3669  				goto s_ovfl;
c5ad643d9 Douglas Gilbert 2019-05-24  3670  			if (trunc)
c5ad643d9 Douglas Gilbert 2019-05-24  3671  				seq_printf(s, "   >> Output truncated %s\n",
c5ad643d9 Douglas Gilbert 2019-05-24  3672  					   "due to buffer size");
c5ad643d9 Douglas Gilbert 2019-05-24  3673  		} else if (b1[0]) {
c5ad643d9 Douglas Gilbert 2019-05-24  3674  			seq_puts(s, b1);
c5ad643d9 Douglas Gilbert 2019-05-24  3675  			if (seq_has_overflowed(s))
c5ad643d9 Douglas Gilbert 2019-05-24  3676  				goto s_ovfl;
c5ad643d9 Douglas Gilbert 2019-05-24  3677  		}
c5ad643d9 Douglas Gilbert 2019-05-24  3678  	}
c5ad643d9 Douglas Gilbert 2019-05-24  3679  s_ovfl:
c5ad643d9 Douglas Gilbert 2019-05-24  3680  	kfree(bp);
^1da177e4 Linus Torvalds  2005-04-16  3681  	return 0;
^1da177e4 Linus Torvalds  2005-04-16  3682  }
^1da177e4 Linus Torvalds  2005-04-16  3683  
