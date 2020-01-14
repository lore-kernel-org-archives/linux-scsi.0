Return-Path: <SRS0=+W3W=3D=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3FC4C33CB1
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:21:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A531624670
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jan 2020 10:21:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729112AbgANKVj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jan 2020 05:21:39 -0500
Received: from smtp.infotech.no ([82.134.31.41]:58916 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727285AbgANKVj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jan 2020 05:21:39 -0500
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id DE9CF2041C0;
        Tue, 14 Jan 2020 11:21:36 +0100 (CET)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id t7YZbYgG2OxT; Tue, 14 Jan 2020 11:21:36 +0100 (CET)
Received: from [82.134.31.177] (unknown [82.134.31.177])
        by smtp.infotech.no (Postfix) with ESMTPA id BD49E204188;
        Tue, 14 Jan 2020 11:21:36 +0100 (CET)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v6 27/37] sg: add sg v4 interface support
To:     kbuild test robot <lkp@intel.com>
Cc:     kbuild-all@lists.01.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, hare@suse.de
References: <20200112235755.14197-28-dgilbert@interlog.com>
 <202001131604.C85gbLUO%lkp@intel.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <6132474f-0f08-e3da-14b3-16bab23f2a5c@interlog.com>
Date:   Tue, 14 Jan 2020 11:21:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <202001131604.C85gbLUO%lkp@intel.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-01-13 9:28 a.m., kbuild test robot wrote:
> Hi Douglas,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on linus/master v5.5-rc6]
> [cannot apply to mkp-scsi/for-next next-20200110]
> [if your patch is applied to the wrong git tree, please drop us a note to help
> improve the system. BTW, we also suggest to use '--base' option to specify the
> base tree in git format-patch, please see https://stackoverflow.com/a/37406982]
> 
> url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-add-v4-interface/20200113-080059
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> 
> If you fix the issue, kindly add following tag
> Reported-by: kbuild test robot <lkp@intel.com>
> 
> New smatch warnings:
> drivers/scsi/sg.c:504 sg_open() error: potential null dereference 'sfp'.  (sg_add_sfp returns null)
> 
> Old smatch warnings:
> drivers/scsi/sg.c:3238 sg_find_srp_by_id() warn: statement has no effect 3

__attribute__((nonnull(<n>))) only applies to function arguments, not its
return value. So there seems no way to tell the compiler: this function,
that returns a pointer, should/will never return the NULL pointer; feel
free to check that.

sg_add_sfp() is such a function, if it fails its retval is either a valid
pointer _or_ IS_ERR(retval) is true. It follows that sfp->tid on line 504
can never be a null dereference.

Doug Gilbert

> 
> vim +/sfp +504 drivers/scsi/sg.c
> 
>     433	
>     434	/*
>     435	 * Corresponds to the open() system call on sg devices. Implements O_EXCL on
>     436	 * a per device basis using 'open_cnt'. If O_EXCL and O_NONBLOCK and there is
>     437	 * already a sg handle open on this device then it fails with an errno of
>     438	 * EBUSY. Without the O_NONBLOCK flag then this thread enters an interruptible
>     439	 * wait until the other handle(s) are closed.
>     440	 */
>     441	static int
>     442	sg_open(struct inode *inode, struct file *filp)
>     443	{
>     444		bool o_excl, non_block;
>     445		int min_dev = iminor(inode);
>     446		int op_flags = filp->f_flags;
>     447		int res;
>     448		__maybe_unused int o_count;
>     449		struct sg_device *sdp;
>     450		struct sg_fd *sfp;
>     451	
>     452		nonseekable_open(inode, filp);
>     453		o_excl = !!(op_flags & O_EXCL);
>     454		non_block = !!(op_flags & O_NONBLOCK);
>     455		if (o_excl && ((op_flags & O_ACCMODE) == O_RDONLY))
>     456			return -EPERM;/* not permitted, need write access for O_EXCL */
>     457		sdp = sg_get_dev(min_dev);	/* increments sdp->d_ref */
>     458		if (IS_ERR(sdp))
>     459			return PTR_ERR(sdp);
>     460	
>     461		/* Prevent the device driver from vanishing while we sleep */
>     462		res = scsi_device_get(sdp->device);
>     463		if (res)
>     464			goto sg_put;
>     465		res = scsi_autopm_get_device(sdp->device);
>     466		if (res)
>     467			goto sdp_put;
>     468		res = sg_allow_if_err_recovery(sdp, non_block);
>     469		if (res)
>     470			goto error_out;
>     471	
>     472		mutex_lock(&sdp->open_rel_lock);
>     473		if (op_flags & O_NONBLOCK) {
>     474			if (o_excl) {
>     475				if (atomic_read(&sdp->open_cnt) > 0) {
>     476					res = -EBUSY;
>     477					goto error_mutex_locked;
>     478				}
>     479			} else {
>     480				if (SG_HAVE_EXCLUDE(sdp)) {
>     481					res = -EBUSY;
>     482					goto error_mutex_locked;
>     483				}
>     484			}
>     485		} else {
>     486			res = sg_wait_open_event(sdp, o_excl);
>     487			if (res) /* -ERESTARTSYS or -ENODEV */
>     488				goto error_mutex_locked;
>     489		}
>     490	
>     491		/* N.B. at this point we are holding the open_rel_lock */
>     492		if (o_excl)
>     493			set_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
>     494	
>     495		o_count = atomic_inc_return(&sdp->open_cnt);
>     496		sfp = sg_add_sfp(sdp);		/* increments sdp->d_ref */
>     497		if (IS_ERR(sfp)) {
>     498			atomic_dec(&sdp->open_cnt);
>     499			res = PTR_ERR(sfp);
>     500			goto out_undo;
>     501		}
>     502	
>     503		filp->private_data = sfp;
>   > 504		sfp->tid = (current ? current->pid : -1);
>     505		mutex_unlock(&sdp->open_rel_lock);
>     506		SG_LOG(3, sfp, "%s: minor=%d, op_flags=0x%x; %s count after=%d%s\n",
>     507		       __func__, min_dev, op_flags, "device open", o_count,
>     508		       ((op_flags & O_NONBLOCK) ? " O_NONBLOCK" : ""));
>     509	
>     510		res = 0;
>     511	sg_put:
>     512		kref_put(&sdp->d_ref, sg_device_destroy);
>     513		/* if success, sdp->d_ref is incremented twice, decremented once */
>     514		return res;
>     515	
>     516	out_undo:
>     517		if (o_excl) {		/* undo if error */
>     518			clear_bit(SG_FDEV_EXCLUDE, sdp->fdev_bm);
>     519			wake_up_interruptible(&sdp->open_wait);
>     520		}
>     521	error_mutex_locked:
>     522		mutex_unlock(&sdp->open_rel_lock);
>     523	error_out:
>     524		scsi_autopm_put_device(sdp->device);
>     525	sdp_put:
>     526		scsi_device_put(sdp->device);
>     527		goto sg_put;
>     528	}
>     529	
> 
> ---
> 0-DAY kernel test infrastructure                 Open Source Technology Center
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation
> 

