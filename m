From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH] preview - block layer help to detect sequential IO
Date: Thu, 12 Jan 2017 14:05:47 +0530
Message-ID: <56630fc76f5f73a05ba94e665993a83e@mail.gmail.com>
References: <1484138217-20486-1-git-send-email-kashyap.desai@broadcom.com> <201701120337.YvBymhBv%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <201701120337.YvBymhBv%fengguang.wu@intel.com>
Sender: linux-block-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: kbuild-all@01.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, axboe@kernel.dk, martin.petersen@oracle.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>
List-Id: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: kbuild test robot [mailto:lkp@intel.com]
> Sent: Thursday, January 12, 2017 1:18 AM
> To: Kashyap Desai
> Cc: kbuild-all@01.org; linux-scsi@vger.kernel.org;
linux-block@vger.kernel.org;
> axboe@kernel.dk; martin.petersen@oracle.com; jejb@linux.vnet.ibm.com;
> sumit.saxena@broadcom.com; Kashyap desai
> Subject: Re: [PATCH] preview - block layer help to detect sequential IO
>
> Hi Kashyap,
>
> [auto build test ERROR on v4.9-rc8]
> [cannot apply to block/for-next linus/master linux/master next-20170111]
[if
> your patch is applied to the wrong git tree, please drop us a note to
help
> improve the system]
>
> url:
https://github.com/0day-ci/linux/commits/Kashyap-Desai/preview-block-
> layer-help-to-detect-sequential-IO/20170112-024228
> config: i386-randconfig-a0-201702 (attached as .config)
> compiler: gcc-6 (Debian 6.2.0-3) 6.2.0 20160901
> reproduce:
>         # save the attached .config to linux build tree
>         make ARCH=i386
>
> All errors (new ones prefixed by >>):
>
>    block/blk-core.c: In function 'add_sequential':
> >> block/blk-core.c:1899:16: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>      blk_ewma_add(t->sequential_io_avg,


This error fixable. For now, I just wanted to get high level review of the
idea.
Below defines are required to use sequential_io and sequential_io_avg. I
have enable BCACHE for my testing in .config.

#if defined(CONFIG_BCACHE) || defined(CONFIG_BCACHE_MODULE)
        unsigned int    sequential_io;
        unsigned int    sequential_io_avg;
#endif

Looking for high level review comment.

` Kashyap


>                    ^
>    block/blk-core.c:1893:10: note: in definition of macro 'blk_ewma_add'
>             (ewma) *= (weight) - 1;
\
>              ^~~~
> >> block/blk-core.c:1899:16: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>      blk_ewma_add(t->sequential_io_avg,
>                    ^
>    block/blk-core.c:1894:10: note: in definition of macro 'blk_ewma_add'
>             (ewma) += (val) << factor;
\
>              ^~~~
> >> block/blk-core.c:1900:5: error: 'struct task_struct' has no member
named
> 'sequential_io'
>        t->sequential_io, 8, 0);
>         ^
>    block/blk-core.c:1894:20: note: in definition of macro 'blk_ewma_add'
>             (ewma) += (val) << factor;
\
>                        ^~~
> >> block/blk-core.c:1899:16: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>      blk_ewma_add(t->sequential_io_avg,
>                    ^
>    block/blk-core.c:1895:10: note: in definition of macro 'blk_ewma_add'
>             (ewma) /= (weight);
\
>              ^~~~
> >> block/blk-core.c:1899:16: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>      blk_ewma_add(t->sequential_io_avg,
>                    ^
>    block/blk-core.c:1896:10: note: in definition of macro 'blk_ewma_add'
>             (ewma) >> factor;
\
>              ^~~~
>    block/blk-core.c:1902:3: error: 'struct task_struct' has no member
named
> 'sequential_io'
>      t->sequential_io = 0;
>       ^~
>    block/blk-core.c: In function 'generic_make_request_checks':
>    block/blk-core.c:2012:7: error: 'struct task_struct' has no member
named
> 'sequential_io'
>       task->sequential_io  = i->sequential;
>           ^~
>    In file included from block/blk-core.c:14:0:
>    block/blk-core.c:2020:21: error: 'struct task_struct' has no member
named
> 'sequential_io'
>       sectors = max(task->sequential_io,
>                         ^
>    include/linux/kernel.h:747:2: note: in definition of macro '__max'
>      t1 max1 = (x);     \
>      ^~
>    block/blk-core.c:2020:13: note: in expansion of macro 'max'
>       sectors = max(task->sequential_io,
>                 ^~~
>    block/blk-core.c:2020:21: error: 'struct task_struct' has no member
named
> 'sequential_io'
>       sectors = max(task->sequential_io,
>                         ^
>    include/linux/kernel.h:747:13: note: in definition of macro '__max'
>      t1 max1 = (x);     \
>                 ^
>    block/blk-core.c:2020:13: note: in expansion of macro 'max'
>       sectors = max(task->sequential_io,
>                 ^~~
>    block/blk-core.c:2021:14: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>              task->sequential_io_avg) >> 9;
>                  ^
>    include/linux/kernel.h:748:2: note: in definition of macro '__max'
>      t2 max2 = (y);     \
>      ^~
>    block/blk-core.c:2020:13: note: in expansion of macro 'max'
>       sectors = max(task->sequential_io,
>                 ^~~
>    block/blk-core.c:2021:14: error: 'struct task_struct' has no member
named
> 'sequential_io_avg'
>              task->sequential_io_avg) >> 9;
>                  ^
>    include/linux/kernel.h:748:13: note: in definition of macro '__max'
>      t2 max2 = (y);     \
>                 ^
>    block/blk-core.c:2020:13: note: in expansion of macro 'max'
>       sectors = max(task->sequential_io,
>                 ^~~
>
> vim +1899 block/blk-core.c
>
>   1887	}
>   1888
>   1889	static void add_sequential(struct task_struct *t)
>   1890	{
>   1891	#define blk_ewma_add(ewma, val, weight, factor)
\
>   1892	({
\
> > 1893	        (ewma) *= (weight) - 1;
\
>   1894	        (ewma) += (val) << factor;
\
>   1895	        (ewma) /= (weight);
\
>   1896	        (ewma) >> factor;
\
>   1897	})
>   1898
> > 1899		blk_ewma_add(t->sequential_io_avg,
> > 1900			 t->sequential_io, 8, 0);
>   1901
>   1902		t->sequential_io = 0;
>   1903	}
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology
Center
> https://lists.01.org/pipermail/kbuild-all                   Intel
Corporation
