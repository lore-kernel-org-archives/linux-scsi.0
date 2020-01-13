Return-Path: <SRS0=nml+=3C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 823E4C33CAE
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 08:29:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 57F7D207E0
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jan 2020 08:29:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgAMI3D (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jan 2020 03:29:03 -0500
Received: from mga04.intel.com ([192.55.52.120]:15698 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728680AbgAMI3C (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Jan 2020 03:29:02 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga104.fm.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Jan 2020 00:29:02 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,428,1571727600"; 
   d="scan'208";a="217342928"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by orsmga008.jf.intel.com with ESMTP; 13 Jan 2020 00:29:01 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iqv5o-000FZK-JF; Mon, 13 Jan 2020 16:29:00 +0800
Date:   Mon, 13 Jan 2020 16:28:32 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [PATCH v6 27/37] sg: add sg v4 interface support
Message-ID: <202001131604.C85gbLUO%lkp@intel.com>
References: <20200112235755.14197-28-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200112235755.14197-28-dgilbert@interlog.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Douglas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on scsi/for-next]
[also build test WARNING on linus/master v5.5-rc6]
[cannot apply to mkp-scsi/for-next next-20200110]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-add-v4-interface/20200113-080059
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

New smatch warnings:
drivers/scsi/sg.c:504 sg_open() error: potential null dereference 'sfp'.  (sg_add_sfp returns null)

Old smatch warnings:
drivers/scsi/sg.c:3238 sg_find_srp_by_id() warn: statement has no effect 3

vim +/sfp +504 drivers/scsi/sg.c

   433	
   434	/*
   435	 * Corresponds to the open() system call on sg devices. Implements O_EXCL on
   436	 * a per device basis using 'open_cnt'. If O_EXCL and O_NONBLOCK and there is
   437	 * already a sg handle open on this device then it fails with an errno of
   438	 * EBUSY. Without the O_NONBLOCK flag then this thread enters an interruptible
   439	 * wait until the other handle(s) are closed.
   440	 */
   441	static int
   442	sg_open(struct inode *inode, struct file *filp)
   443	{
   444		bool o_excl, non_block;
   445		int min_dev = iminor(inode);
   446		int op_flags = filp->f_flags;
   447		int res;
   448		__maybe_unused int o_count;
   449		struct sg_device *sdp;
   450		struct sg_fd *sfp;
   451	
   452		nonseekable_open(inode, filp);
   453		o_excl = !!(op_flags & O_EXCL);
   454		non_block = !!(op_flags & O_NONBLOCK);
   455		if (o_excl && ((op_flags & O_ACCMODE) == O_RDONLY))
   456			return -EPERM;/* not permitted, need write access for O_EXCL */
   457		sdp = sg_get_dev(min_dev);	/* increments sdp->d_ref */
   458		if (IS_ERR(sdp))
   459			return PTR_ERR(sdp);
   460	
   461		/* Prevent the device driver from vanishing while we sleep */
   462		res = scsi_device_get(sdp->device);
   463		if (res)
   464			goto sg_put;
   465		res = scsi_autopm_get_device(sdp->device);
   466		if (res)
   467			goto sdp_put;
   468		res = sg_allow_if_err_recovery(sdp, non_block);
   469		if (res)
   470			goto error_out;
   471	
   472		mutex_lock(&sdp->open_rel_lock);
   473		if (op_flags & O_NONBLOCK) {
   474			if (o_excl) {
   475				if (atomic_read(&sdp->open_cnt) > 0) {
   476					res = -EBUSY;
   477					goto error_mutex_locked;
   478				}
   479			} else {
   480				if (SG_HAVE_EXCLUDE(sdp)) {
   481					res = -EBUSY;
   482					goto error_mutex_locked;
   483				}
   484			}
   485		} else {
   486			res = sg_wait_open_event(sdp, o_excl);
   487			if (res) /* -ERESTARTSYS or -ENODEV */
   488				goto error_mutex_locked;
   489		}
   490	
   491		/* N.B. at this point we are holding the open_rel_lock */
   492		if (o_excl)
   493			set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
   494	
   495		o_count = atomic_inc_return(&sdp->open_cnt);
   496		sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
   497		if (IS_ERR(sfp)) {
   498			atomic_dec(&sdp->open_cnt);
   499			res = PTR_ERR(sfp);
   500			goto out_undo;
   501		}
   502	
   503		filp->private_data = sfp;
 > 504		sfp->tid = (current ? current->pid : -1);
   505		mutex_unlock(&sdp->open_rel_lock);
   506		SG_LOG(3, sfp, "%s: minor=%d, op_flags=0x%x; %s count after=%d%s\n",
   507		       __func__, min_dev, op_flags, "device open", o_count,
   508		       ((op_flags & O_NONBLOCK) ? " O_NONBLOCK" : ""));
   509	
   510		res = 0;
   511	sg_put:
   512		kref_put(&sdp->d_ref, sg_device_destroy);
   513		/* if success, sdp->d_ref is incremented twice, decremented once */
   514		return res;
   515	
   516	out_undo:
   517		if (o_excl) {		/* undo if error */
   518			clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
   519			wake_up_interruptible(&sdp->open_wait);
   520		}
   521	error_mutex_locked:
   522		mutex_unlock(&sdp->open_rel_lock);
   523	error_out:
   524		scsi_autopm_put_device(sdp->device);
   525	sdp_put:
   526		scsi_device_put(sdp->device);
   527		goto sg_put;
   528	}
   529	

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
