Return-Path: <SRS0=ULGd=EP=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3BDA1C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 05:41:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id DD4C520897
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 05:41:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729474AbgKIFlt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 00:41:49 -0500
Received: from mail-1.ca.inter.net ([208.85.220.69]:58322 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729391AbgKIFlt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 00:41:49 -0500
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id F37DC2EA16B;
        Mon,  9 Nov 2020 00:41:47 -0500 (EST)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id nb+tua23EEig; Mon,  9 Nov 2020 00:32:56 -0500 (EST)
Received: from [192.168.48.23] (host-104-157-204-209.dyn.295.ca [104.157.204.209])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id 759FC2EA077;
        Mon,  9 Nov 2020 00:41:46 -0500 (EST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi_debug: change store from vmalloc to sgl
To:     kernel test robot <lkp@intel.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, bostroesser@gmail.com, bvanassche@acm.org,
        ddiss@suse.de, hare@suse.de
References: <20201106003852.24113-1-dgilbert@interlog.com>
 <202011091353.o6V6Hxmc-lkp@intel.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <f74d2ef8-c791-e8d0-0d37-a848f417c8e3@interlog.com>
Date:   Mon, 9 Nov 2020 00:41:46 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <202011091353.o6V6Hxmc-lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-11-09 12:24 a.m., kernel test robot wrote:
> Hi Douglas,
> 
> Thank you for the patch! Yet something to improve:
> 
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on mkp-scsi/for-next v5.10-rc3 next-20201106]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use '--base' as documented in
> https://git-scm.com/docs/git-format-patch]
> 
> url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/scsi_debug-change-store-from-vmalloc-to-sgl/20201106-084105
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> config: riscv-allyesconfig (attached as .config)
> compiler: riscv64-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # https://github.com/0day-ci/linux/commit/210cfb290b96c8543a20986a703b6134692e069a
>          git remote add linux-review https://github.com/0day-ci/linux
>          git fetch --no-tags linux-review Douglas-Gilbert/scsi_debug-change-store-from-vmalloc-to-sgl/20201106-084105
>          git checkout 210cfb290b96c8543a20986a703b6134692e069a
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=riscv
> 
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
> 
> All errors (new ones prefixed by >>):
> 
>     drivers/scsi/scsi_debug.c: In function 'do_device_access':
>>> drivers/scsi/scsi_debug.c:2970:9: error: implicit declaration of function 'sgl_copy_sgl' [-Werror=implicit-function-declaration]
>      2970 |   ret = sgl_copy_sgl(store_sgl, sip->n_elem - sgl_i, rem,

Hi Robot,
Perhaps you can't read English. This patch submission says:

    'This patch depends on: "[PATCH v4 0/4] scatterlist: add new
     capabilities".'

And that patchset has been submitted to the linux-block list for
consideration.

Doug Gilbert

>           |         ^~~~~~~~~~~~
>     drivers/scsi/scsi_debug.c: In function 'comp_write_worker':
>>> drivers/scsi/scsi_debug.c:3034:9: error: implicit declaration of function 'sgl_compare_sgl_idx' [-Werror=implicit-function-declaration]
>      3034 |   equ = sgl_compare_sgl_idx(store_sgl, sip->n_elem - sgl_i, rem,
>           |         ^~~~~~~~~~~~~~~~~~~
>     drivers/scsi/scsi_debug.c: In function 'unmap_region':
>>> drivers/scsi/scsi_debug.c:3505:5: error: implicit declaration of function 'sgl_memset'; did you mean 'memset'? [-Werror=implicit-function-declaration]
>      3505 |     sgl_memset(store_sgl, sip->n_elem - sgl_i, rem, val,
>           |     ^~~~~~~~~~
>           |     memset
>     cc1: some warnings being treated as errors
> 
> vim +/sgl_copy_sgl +2970 drivers/scsi/scsi_debug.c
> 
>    2938	
>    2939	/* Returns number of bytes copied or -1 if error. */
>    2940	static int do_device_access(struct sdeb_store_info *sip, struct scsi_cmnd *scp,
>    2941				    u32 data_inout_off, u64 lba, u32 n_blks, bool do_write)
>    2942	{
>    2943		int ret;
>    2944		u32 lb_size = sdebug_sector_size;
>    2945		u64 block, sgl_i, rem, lba_start, rest = 0;
>    2946		enum dma_data_direction dir;
>    2947		struct scsi_data_buffer *sdb = &scp->sdb;
>    2948		struct scatterlist *store_sgl;
>    2949	
>    2950		if (do_write) {
>    2951			dir = DMA_TO_DEVICE;
>    2952			write_since_sync = true;
>    2953		} else {
>    2954			dir = DMA_FROM_DEVICE;
>    2955		}
>    2956	
>    2957		if (!sdb->length || !sip)
>    2958			return 0;
>    2959		if (scp->sc_data_direction != dir)
>    2960			return -1;
>    2961		block = do_div(lba, sdebug_store_sectors);
>    2962		if (block + n_blks > sdebug_store_sectors)
>    2963			rest = block + n_blks - sdebug_store_sectors;
>    2964		lba_start = block * lb_size;
>    2965		sgl_i = lba_start >> sip->elem_pow2;
>    2966		rem = lba_start - (sgl_i ? (sgl_i << sip->elem_pow2) : 0);
>    2967		store_sgl = sip->sgl + sgl_i;	/* O(1) to each store sg element */
>    2968	
>    2969		if (do_write)
>> 2970			ret = sgl_copy_sgl(store_sgl, sip->n_elem - sgl_i, rem,
>    2971					   sdb->table.sgl, sdb->table.nents, data_inout_off,
>    2972					   (n_blks - rest) * lb_size);
>    2973		else
>    2974			ret = sgl_copy_sgl(sdb->table.sgl, sdb->table.nents, data_inout_off,
>    2975					   store_sgl, sip->n_elem - sgl_i, rem,
>    2976					   (n_blks - rest) * lb_size);
>    2977	
>    2978		if (ret != (n_blks - rest) * lb_size)
>    2979			return ret;
>    2980	
>    2981		if (rest == 0)
>    2982			goto fini;
>    2983		if (do_write)
>    2984			ret += sgl_copy_sgl(sip->sgl, sip->n_elem, 0, sdb->table.sgl, sdb->table.nents,
>    2985					    data_inout_off + ((n_blks - rest) * lb_size), rest * lb_size);
>    2986		else
>    2987			ret += sgl_copy_sgl(sdb->table.sgl, sdb->table.nents,
>    2988					    data_inout_off + ((n_blks - rest) * lb_size),
>    2989					    sip->sgl, sip->n_elem, 0, rest * lb_size);
>    2990	fini:
>    2991		return ret;
>    2992	}
>    2993	
>    2994	/* Returns number of bytes copied or -1 if error. */
>    2995	static int do_dout_fetch(struct scsi_cmnd *scp, u32 num, u8 *doutp)
>    2996	{
>    2997		struct scsi_data_buffer *sdb = &scp->sdb;
>    2998	
>    2999		if (!sdb->length)
>    3000			return 0;
>    3001		if (scp->sc_data_direction != DMA_TO_DEVICE)
>    3002			return -1;
>    3003		return sg_copy_buffer(sdb->table.sgl, sdb->table.nents, doutp,
>    3004				      num * sdebug_sector_size, 0, true);
>    3005	}
>    3006	
>    3007	/* If sip->storep+lba compares equal to arr(num) or scp->sdb, then if miscomp_idxp is non-NULL,
>    3008	 * copy top half of arr into sip->storep+lba and return true. If comparison fails then return
>    3009	 * false and write the miscompare_idx via miscomp_idxp. Thsi is the COMAPARE AND WRITE case.
>    3010	 * For VERIFY(BytChk=1), set arr to NULL which causes a sgl (store) to sgl (data-out buffer)
>    3011	 * compare to be done. VERIFY(BytChk=3) sets arr to a valid address and sets miscomp_idxp
>    3012	 * to NULL.
>    3013	 */
>    3014	static bool comp_write_worker(struct sdeb_store_info *sip, u64 lba, u32 num,
>    3015				      const u8 *arr, struct scsi_cmnd *scp, size_t *miscomp_idxp)
>    3016	{
>    3017		bool equ;
>    3018		u64 block, lba_start, sgl_i, rem, rest = 0;
>    3019		u32 store_blks = sdebug_store_sectors;
>    3020		const u32 lb_size = sdebug_sector_size;
>    3021		u32 top_half = num * lb_size;
>    3022		struct scsi_data_buffer *sdb = &scp->sdb;
>    3023		struct scatterlist *store_sgl;
>    3024	
>    3025		block = do_div(lba, store_blks);
>    3026		if (block + num > store_blks)
>    3027			rest = block + num - store_blks;
>    3028		lba_start = block * lb_size;
>    3029		sgl_i = lba_start >> sip->elem_pow2;
>    3030		rem = lba_start - (sgl_i ? (sgl_i << sip->elem_pow2) : 0);
>    3031		store_sgl = sip->sgl + sgl_i;	/* O(1) to each store sg element */
>    3032	
>    3033		if (!arr) {	/* sgl to sgl compare */
>> 3034			equ = sgl_compare_sgl_idx(store_sgl, sip->n_elem - sgl_i, rem,
>    3035						  sdb->table.sgl, sdb->table.nents, 0,
>    3036						  (num - rest) * lb_size, miscomp_idxp);
>    3037			if (!equ)
>    3038				return equ;
>    3039			if (rest > 0)
>    3040				equ = sgl_compare_sgl_idx(sip->sgl, sip->n_elem, 0, sdb->table.sgl,
>    3041							  sdb->table.nents, (num - rest) * lb_size,
>    3042							  rest * lb_size, miscomp_idxp);
>    3043		} else {
>    3044			equ = sdeb_sgl_cmp_buf(store_sgl, sip->n_elem - sgl_i, arr,
>    3045					       (num - rest) * lb_size, 0);
>    3046			if (!equ)
>    3047				return equ;
>    3048			if (rest > 0)
>    3049				equ = sdeb_sgl_cmp_buf(sip->sgl, sip->n_elem, arr,
>    3050						       (num - rest) * lb_size, 0);
>    3051		}
>    3052		if (!equ || !miscomp_idxp)
>    3053			return equ;
>    3054	
>    3055		/* Copy "top half" of dout (args: 4, 5 and 6) into store sgl (args 1, 2 and 3) */
>    3056		sgl_copy_sgl(store_sgl, sip->n_elem - sgl_i, rem,
>    3057			     sdb->table.sgl, sdb->table.nents, top_half,
>    3058			     (num - rest) * lb_size);
>    3059		if (rest > 0) {	/* for virtual_gb need to handle wrap-around of store */
>    3060			u32 src_off =  top_half + ((num - rest) * lb_size);
>    3061	
>    3062			sgl_copy_sgl(sip->sgl, sip->n_elem, 0,
>    3063				     sdb->table.sgl, sdb->table.nents, src_off,
>    3064				     rest * lb_size);
>    3065		}
>    3066		return true;
>    3067	}
>    3068	
> 
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
> 

