Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.2 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15556C47082
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 17:53:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D137961278
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 17:53:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233572AbhFHRzk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 13:55:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:41832 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233870AbhFHRzg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 8 Jun 2021 13:55:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CB82361278;
        Tue,  8 Jun 2021 17:53:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623174823;
        bh=SIWlEu0hNZVwGKPMGgZrrhKZ3SDxUyr/aaxpvV+NqSc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p1TLVHnimIENzlL4Gstl2gBAtnZIMkjVSGzOLjdmYy5I7YqHL/pe+zDTA1IDspEi5
         Htq4YPv6CH/4HOU6sCdlvgfgsX5GEiV37FCvkjnvQ8ZnbJkkFVUythZU4KeKMnnbvg
         mVePR2Q3IHnh8puEkrnit03JzRdjw614jpMgHRV/GJ1AS/UNUBimfTCMBnFQM3GpG3
         9R+QDtGOEb+A59TpPORtkZSMwyMrJCxu2bBMBWhrv3LVeHstODllT5UA32lPeeRYnY
         IkH3D2IXHRhwuuO9qu1DwcLGA8A6anqa22mashZtA1/D80cPmQPxE9+FFyHV04I568
         kPJ+7ZJPYcbjg==
Date:   Tue, 8 Jun 2021 10:53:30 -0700
From:   Nathan Chancellor <nathan@kernel.org>
To:     kernel test robot <lkp@intel.com>
Cc:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        linux-scsi@vger.kernel.org, kernel-team@android.com,
        kbuild-all@lists.01.org, clang-built-linux@googlegroups.com,
        Stanley Chu <stanley.chu@mediatek.com>,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v1 2/3] scsi: ufs: Optimize host lock on transfer
 requests send/compl paths
Message-ID: <YL+umjDMd4Rao/Ns@Ryzen-9-3900X>
References: <1621845419-14194-3-git-send-email-cang@codeaurora.org>
 <202105241912.BEjpMmeK-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202105241912.BEjpMmeK-lkp@intel.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 24, 2021 at 07:25:57PM +0800, kernel test robot wrote:
> Hi Can,
> 
> Thank you for the patch! Perhaps something to improve:
> 
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on next-20210524]
> [cannot apply to scsi/for-next v5.13-rc3]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Can-Guo/Optimize-host-lock-on-TR-send-compl-paths-and-utilize-UTRLCNR/20210524-163847
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: arm64-randconfig-r011-20210524 (attached as .config)
> compiler: clang version 13.0.0 (https://github.com/llvm/llvm-project 93d1e5822ed64abd777eb94ea9899e96c4c39fbe)
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # install arm64 cross compiling tool for clang build
>         # apt-get install binutils-aarch64-linux-gnu
>         # https://github.com/0day-ci/linux/commit/efe94162bf7973be4ed6496871b9bc9ea54e2819
>         git remote add linux-review https://github.com/0day-ci/linux
>         git fetch --no-tags linux-review Can-Guo/Optimize-host-lock-on-TR-send-compl-paths-and-utilize-UTRLCNR/20210524-163847
>         git checkout efe94162bf7973be4ed6496871b9bc9ea54e2819
>         # save the attached .config to linux build tree
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross ARCH=arm64 
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All warnings (new ones prefixed by >>):

Looks like this build warning never got taken care of before the patch
was accepted because I see it on next-20210608.

> >> drivers/scsi/ufs/ufshcd.c:2959:6: warning: variable 'lrbp' is used uninitialized whenever 'if' condition is true [-Wsometimes-uninitialized]
>            if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>                ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    include/linux/compiler.h:78:22: note: expanded from macro 'unlikely'
>    # define unlikely(x)    __builtin_expect(!!(x), 0)
>                            ^~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/ufs/ufshcd.c:2981:32: note: uninitialized use occurs here
>                                        (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>                                                               ^~~~
>    drivers/scsi/ufs/ufshcd.c:2959:2: note: remove the 'if' if its condition is always false
>            if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>            ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>    drivers/scsi/ufs/ufshcd.c:2939:25: note: initialize the variable 'lrbp' to silence this warning
>            struct ufshcd_lrb *lrbp;
>                                   ^
>                                    = NULL
>    1 warning generated.
> 
> 
> vim +2959 drivers/scsi/ufs/ufshcd.c
> 
>   2924	
>   2925	/**
>   2926	 * ufshcd_exec_dev_cmd - API for sending device management requests
>   2927	 * @hba: UFS hba
>   2928	 * @cmd_type: specifies the type (NOP, Query...)
>   2929	 * @timeout: time in seconds
>   2930	 *
>   2931	 * NOTE: Since there is only one available tag for device management commands,
>   2932	 * it is expected you hold the hba->dev_cmd.lock mutex.
>   2933	 */
>   2934	static int ufshcd_exec_dev_cmd(struct ufs_hba *hba,
>   2935			enum dev_cmd_type cmd_type, int timeout)
>   2936	{
>   2937		struct request_queue *q = hba->cmd_queue;
>   2938		struct request *req;
>   2939		struct ufshcd_lrb *lrbp;
>   2940		int err;
>   2941		int tag;
>   2942		struct completion wait;
>   2943	
>   2944		down_read(&hba->clk_scaling_lock);
>   2945	
>   2946		/*
>   2947		 * Get free slot, sleep if slots are unavailable.
>   2948		 * Even though we use wait_event() which sleeps indefinitely,
>   2949		 * the maximum wait time is bounded by SCSI request timeout.
>   2950		 */
>   2951		req = blk_get_request(q, REQ_OP_DRV_OUT, 0);
>   2952		if (IS_ERR(req)) {
>   2953			err = PTR_ERR(req);
>   2954			goto out_unlock;
>   2955		}
>   2956		tag = req->tag;
>   2957		WARN_ON_ONCE(!ufshcd_valid_tag(hba, tag));
>   2958	
> > 2959		if (unlikely(test_bit(tag, &hba->outstanding_reqs))) {
>   2960			err = -EBUSY;

Should this goto be adjusted to out_put_tag then drop the out label?

>   2961			goto out;
>   2962		}
>   2963	
>   2964		init_completion(&wait);
>   2965		lrbp = &hba->lrb[tag];
>   2966		WARN_ON(lrbp->cmd);
>   2967		err = ufshcd_compose_dev_cmd(hba, lrbp, cmd_type, tag);
>   2968		if (unlikely(err))
>   2969			goto out_put_tag;
>   2970	
>   2971		hba->dev_cmd.complete = &wait;
>   2972	
>   2973		ufshcd_add_query_upiu_trace(hba, UFS_QUERY_SEND, lrbp->ucd_req_ptr);
>   2974		/* Make sure descriptors are ready before ringing the doorbell */
>   2975		wmb();
>   2976	
>   2977		ufshcd_send_command(hba, tag);
>   2978		err = ufshcd_wait_for_dev_cmd(hba, lrbp, timeout);
>   2979	out:
>   2980		ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : UFS_QUERY_COMP,
>   2981					    (struct utp_upiu_req *)lrbp->ucd_rsp_ptr);
>   2982	
>   2983	out_put_tag:
>   2984		blk_put_request(req);
>   2985	out_unlock:
>   2986		up_read(&hba->clk_scaling_lock);
>   2987		return err;
>   2988	}
>   2989	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

Cheers,
Nathan
