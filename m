Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87453C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 17:49:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 64E0420780
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 17:49:38 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=oracle.com header.i=@oracle.com header.b="EBWHr8MM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733294AbgFWRti (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 13:49:38 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:48732 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733236AbgFWRth (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 13:49:37 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NHkU8U052004;
        Tue, 23 Jun 2020 17:49:31 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : mime-version : in-reply-to :
 content-type : content-transfer-encoding; s=corp-2020-01-29;
 bh=7K5gka4v1sYMhTHRsTe/SGfJEw5xbL/SewTNXudZia4=;
 b=EBWHr8MMpqcVTFstzB1GgfsByPNmRS6zhGgAZ+vopjVtFeOP3qyrmCHTw0425zGmADF9
 6kCnyXBoojtjuARt/U37L8730nIf0vplQ54P9Y/8eqWsTVT5fTrqLA/yTKlr0uc8YUzn
 nPaHfXttleplKYOF4lnoqWgQ+KeeeYEJdP3UC6gBZgvat8qPZDhESgfoONtFrL6n+Ket
 TDNtP0fWgeu7nt5K1MLkw1ZD5zIeVOyUNYPlfmc6Fp6yCx2Pxd//4kvFcHuwOnQytkCj
 eWgd1ZIGF5KRfFIKp+KAxmmxODrIHWzvpdniDbyL6UmFipPIckvagY8WPyeDbQbLwr2J Zg== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by userp2130.oracle.com with ESMTP id 31uk2rsaxy-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Tue, 23 Jun 2020 17:49:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05NHnCSF093788;
        Tue, 23 Jun 2020 17:49:31 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by userp3030.oracle.com with ESMTP id 31uk42ajje-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Jun 2020 17:49:30 +0000
Received: from abhmp0002.oracle.com (abhmp0002.oracle.com [141.146.116.8])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05NHnRVS028385;
        Tue, 23 Jun 2020 17:49:27 GMT
Received: from [10.159.241.230] (/10.159.241.230)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Tue, 23 Jun 2020 17:49:27 +0000
Subject: Re: [PATCH] scsi: target: tcmu: Call flush_dcache_page() with proper
 page struct
To:     kernel test robot <lkp@intel.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, chris@zankel.net, jcmvbkbc@gmail.com,
        linux-xtensa@linux-xtensa.org
References: <1592592105-11497-1-git-send-email-henry.willard@oracle.com>
 <202006200926.OYiV11oq%lkp@intel.com>
From:   Henry Willard <henry.willard@oracle.com>
Message-ID: <c5b68f83-ea07-d947-0ef0-9712942f621b@oracle.com>
Date:   Tue, 23 Jun 2020 10:49:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <202006200926.OYiV11oq%lkp@intel.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 mlxscore=0
 adultscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2006120000
 definitions=main-2006230124
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9661 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 phishscore=0 mlxlogscore=999 impostorscore=0 lowpriorityscore=0
 bulkscore=0 mlxscore=0 spamscore=0 clxscore=1011 suspectscore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2006120000 definitions=main-2006230124
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/19/20 6:31 PM, kernel test robot wrote:
> Hi Henry,
>
> Thank you for the patch! Perhaps something to improve:
>
> [auto build test WARNING on mkp-scsi/for-next]
> [also build test WARNING on scsi/for-next v5.8-rc1 next-20200618]
> [If your patch is applied to the wrong git tree, kindly drop us a note.
> And when submitting patch, we suggest to use  as documented in
> https://git-scm.com/docs/git-format-patch]
>
> url:    https://github.com/0day-ci/linux/commits/Henry-Willard/scsi-target-tcmu-Call-flush_dcache_page-with-proper-page-struct/20200620-024740
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
> config: xtensa-allyesconfig (attached as .config)
> compiler: xtensa-linux-gcc (GCC) 9.3.0
> reproduce (this is a W=1 build):
>          wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>          chmod +x ~/bin/make.cross
>          # save the attached .config to linux build tree
>          COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=xtensa
>
> If you fix the issue, kindly add following tag as appropriate
> Reported-by: kernel test robot <lkp@intel.com>
>
> All warnings (new ones prefixed by >>, old ones prefixed by <<):
>
> In file included from include/linux/kernel.h:11,
> from include/linux/list.h:9,
> from include/linux/preempt.h:11,
> from include/linux/spinlock.h:51,
> from drivers/target/target_core_user.c:9:
> include/linux/scatterlist.h: In function 'sg_set_buf':
> arch/xtensa/include/asm/page.h:193:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> 193 |  ((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
> |         ^~
> include/linux/compiler.h:78:42: note: in definition of macro 'unlikely'
> 78 | # define unlikely(x) __builtin_expect(!!(x), 0)
> |                                          ^
> include/linux/scatterlist.h:143:2: note: in expansion of macro 'BUG_ON'
> 143 |  BUG_ON(!virt_addr_valid(buf));
> |  ^~~~~~
> arch/xtensa/include/asm/page.h:201:32: note: in expansion of macro 'pfn_valid'
> 201 | #define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
> |                                ^~~~~~~~~
> include/linux/scatterlist.h:143:10: note: in expansion of macro 'virt_addr_valid'
> 143 |  BUG_ON(!virt_addr_valid(buf));
> |          ^~~~~~~~~~~~~~~
> In file included from ./arch/xtensa/include/generated/asm/bug.h:1,
> from include/linux/bug.h:5,
> from include/linux/thread_info.h:12,
> from include/asm-generic/preempt.h:5,
> from ./arch/xtensa/include/generated/asm/preempt.h:1,
> from include/linux/preempt.h:78,
> from include/linux/spinlock.h:51,
> from drivers/target/target_core_user.c:9:
> include/linux/dma-mapping.h: In function 'dma_map_resource':
> arch/xtensa/include/asm/page.h:193:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> 193 |  ((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
> |         ^~
> include/asm-generic/bug.h:144:27: note: in definition of macro 'WARN_ON_ONCE'
> 144 |  int __ret_warn_once = !!(condition);            |                           ^~~~~~~~~
> include/linux/dma-mapping.h:352:19: note: in expansion of macro 'pfn_valid'
> 352 |  if (WARN_ON_ONCE(pfn_valid(PHYS_PFN(phys_addr))))
> |                   ^~~~~~~~~
> In file included from include/linux/mm_types_task.h:16,
> from include/linux/mm_types.h:5,
> from include/linux/mmzone.h:21,
> from include/linux/gfp.h:6,
> from include/linux/umh.h:4,
> from include/linux/kmod.h:9,
> from include/linux/module.h:16,
> from drivers/target/target_core_user.c:10:
> drivers/target/target_core_user.c: In function 'tcmu_flush_dcache_range':
> arch/xtensa/include/asm/page.h:193:9: warning: comparison of unsigned expression >= 0 is always true [-Wtype-limits]
> 193 |  ((pfn) >= ARCH_PFN_OFFSET && ((pfn) - ARCH_PFN_OFFSET) < max_mapnr)
> |         ^~
> arch/xtensa/include/asm/page.h:201:32: note: in expansion of macro 'pfn_valid'
> 201 | #define virt_addr_valid(kaddr) pfn_valid(__pa(kaddr) >> PAGE_SHIFT)
> |                                ^~~~~~~~~
> drivers/target/target_core_user.c:605:7: note: in expansion of macro 'virt_addr_valid'
> 605 |   if (virt_addr_valid(start))
> |       ^~~~~~~~~~~~~~~
>>> drivers/target/target_core_user.c:600:15: warning: variable 'pg' set but not used [-Wunused-but-set-variable]
> 600 |  struct page *pg;
> |               ^~
>
> vim +/pg +600 drivers/target/target_core_user.c
>
>     595	
>     596	static inline void tcmu_flush_dcache_range(void *vaddr, size_t size)
>     597	{
>     598		unsigned long offset = offset_in_page(vaddr);
>     599		void *start = vaddr - offset;
>   > 600		struct page *pg;
>     601	
>     602		size = round_up(size+offset, PAGE_SIZE);
>     603	
>     604		while (size) {
>     605			if (virt_addr_valid(start))
>     606				pg = virt_to_page(start);
>     607			else if (is_vmalloc_addr(start))
>     608				pg = vmalloc_to_page(start);
>     609			else
>     610				break;
>     611	
>     612			flush_dcache_page(pg);
>     613			start += PAGE_SIZE;
>     614			size -= PAGE_SIZE;
>     615		}
>     616	}
>     617	
>
> ---
> 0-DAY CI Kernel Test Service, Intel Corporation
> https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
It doesn't really matter in this case because this patch has been 
superseded by a different fix, but the warning appears to be caused by 
an incorrect implementation of flush_dcache_page() in 
arch/xtensa/include/asm/cacheflush.h. Depending on the variant and 
options, flush_dcache_page can be defined as "do { } while (0)", which 
covers the default null implementation of flush_dcache_page().

Thanks,
Henry
