From: John Garry <john.garry@huawei.com>
Subject: Re: [PATCH v4 03/32] scsi: hisi_sas: add initial bare main driver
Date: Tue, 17 Nov 2015 16:24:37 +0000
Message-ID: <564B54C5.9030601@huawei.com>
References: <201511170040.GfC7Pkvq%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <201511170040.GfC7Pkvq%fengguang.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: kbuild test robot <lkp@intel.com>
Cc: "kbuild-all@01.org" <kbuild-all@01.org>, "JBottomley@odin.com" <JBottomley@odin.com>, "robh+dt@kernel.org" <robh+dt@kernel.org>, "pawel.moll@arm.com" <pawel.moll@arm.com>, "mark.rutland@arm.com" <mark.rutland@arm.com>, "ijc+devicetree@hellion.org.uk" <ijc+devicetree@hellion.org.uk>, "galak@codeaurora.org" <galak@codeaurora.org>, "arnd@arndb.de" <arnd@arndb.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>, Linuxarm <linuxarm@huawei.com>, "john.garry2@mail.dcu.ie" <john.garry2@mail.dcu.ie>, "hare@suse.de" <hare@suse.de>, "xuwei (O)" <xuwei5@hisilicon.com>, "zhangfei.gao@linaro.org" <zhangfei.gao@linaro.org>
List-Id: linux-scsi@vger.kernel.org

I'll follow up with a fix in patchset v5. However kernel linking seems 
broken for this config without my patches.

arch/x86/built-in.o: In function `hv_machine_crash_shutdown':

mshyperv.c:(.text+0xa1ec4): undefined reference to 
`native_machine_crash_shutdown'

John

On 16/11/2015 17:35, kbuild test robot wrote:
> Hi John,
>
> [auto build test ERROR on scsi/for-next]
> [also build test ERROR on v4.4-rc1 next-20151116]
>
> url:https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151116-215304
> base:https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git  for-next
> config: i386-randconfig-s0-11162304 (attached as .config)
> reproduce:
>          # save the attached .config to linux build tree
>          make ARCH=i386
>
> All error/warnings (new ones prefixed by >>):
>
> warning: (SCSI_HISI_SAS && TCM_IBLOCK) selects BLK_DEV_INTEGRITY which has unmet direct dependencies (BLOCK)
> warning: (SCSI_HISI_SAS) selects SCSI_SAS_LIBSAS which has unmet direct dependencies (SCSI)
>     block/bio-integrity.c: In function 'bio_integrity_alloc':
>>> block/bio-integrity.c:50:26: error: dereferencing pointer to incomplete type 'struct bio'
>       struct bio_set *bs = bio->bi_pool;
>                               ^
>>> block/bio-integrity.c:51:22: error: 'BIO_POOL_NONE' undeclared (first use in this function)
>       unsigned long idx = BIO_POOL_NONE;
>                           ^
>     block/bio-integrity.c:51:22: note: each undeclared identifier is reported only once for each function it appears in
>     In file included from include/uapi/linux/stddef.h:1:0,
>                      from include/linux/stddef.h:4,
>                      from include/uapi/linux/posix_types.h:4,
>                      from include/uapi/linux/types.h:13,
>                      from include/linux/types.h:5,
>                      from include/uapi/linux/capability.h:16,
>                      from include/linux/capability.h:15,
>                      from include/linux/sched.h:15,
>                      from include/linux/blkdev.h:4,
>                      from block/bio-integrity.c:23:
>>> block/bio-integrity.c:54:16: error: dereferencing pointer to incomplete type 'struct bio_set'
>       if (!bs || !bs->bio_integrity_pool) {
>                     ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>>> block/bio-integrity.c:54:2: note: in expansion of macro 'if'
>       if (!bs || !bs->bio_integrity_pool) {
>       ^
>>> block/bio-integrity.c:55:24: error: invalid application of 'sizeof' to incomplete type 'struct bio_integrity_payload'
>        bip = kmalloc(sizeof(struct bio_integrity_payload) +
>                             ^
>     In file included from arch/x86/include/asm/string.h:2:0,
>                      from include/linux/string.h:17,
>                      from include/linux/dynamic_debug.h:111,
>                      from include/linux/printk.h:277,
>                      from include/linux/kernel.h:13,
>                      from include/linux/sched.h:17,
>                      from include/linux/blkdev.h:4,
>                      from block/bio-integrity.c:23:
>>> block/bio-integrity.c:66:24: error: dereferencing pointer to incomplete type 'struct bio_integrity_payload'
>       memset(bip, 0, sizeof(*bip));
>                             ^
>     arch/x86/include/asm/string_32.h:325:52: note: in definition of macro 'memset'
>      #define memset(s, c, count) __builtin_memset(s, c, count)
>                                                         ^
>>> block/bio-integrity.c:69:18: error: implicit declaration of function 'bvec_alloc' [-Werror=implicit-function-declaration]
>        bip->bip_vec = bvec_alloc(gfp_mask, nr_vecs, &idx,
>                       ^
>>> block/bio-integrity.c:73:23: error: implicit declaration of function 'bvec_nr_vecs' [-Werror=implicit-function-declaration]
>        bip->bip_max_vcnt = bvec_nr_vecs(idx);
>                            ^
>     block/bio-integrity.c: In function 'bio_integrity_free':
>>> block/bio-integrity.c:100:38: error: implicit declaration of function 'bio_integrity' [-Werror=implicit-function-declaration]
>       struct bio_integrity_payload *bip = bio_integrity(bio);
>                                           ^
>>> block/bio-integrity.c:100:38: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
>     In file included from include/uapi/linux/stddef.h:1:0,
>                      from include/linux/stddef.h:4,
>                      from include/uapi/linux/posix_types.h:4,
>                      from include/uapi/linux/types.h:13,
>                      from include/linux/types.h:5,
>                      from include/uapi/linux/capability.h:16,
>                      from include/linux/capability.h:15,
>                      from include/linux/sched.h:15,
>                      from include/linux/blkdev.h:4,
>                      from block/bio-integrity.c:23:
>>> block/bio-integrity.c:103:23: error: 'BIP_BLOCK_INTEGRITY' undeclared (first use in this function)
>       if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
>                            ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:103:2: note: in expansion of macro 'if'
>       if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
>       ^
>     block/bio-integrity.c:108:24: error: 'BIO_POOL_NONE' undeclared (first use in this function)
>        if (bip->bip_slab != BIO_POOL_NONE)
>                             ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:108:3: note: in expansion of macro 'if'
>        if (bip->bip_slab != BIO_POOL_NONE)
>        ^
>>> block/bio-integrity.c:109:4: error: implicit declaration of function 'bvec_free' [-Werror=implicit-function-declaration]
>         bvec_free(bs->bvec_integrity_pool, bip->bip_vec,
>         ^
>     block/bio-integrity.c: In function 'bio_integrity_add_page':
>     block/bio-integrity.c:133:38: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
>       struct bio_integrity_payload *bip = bio_integrity(bio);
>                                           ^
>     block/bio-integrity.c: In function 'bio_integrity_enabled':
>>> block/bio-integrity.c:163:29: error: implicit declaration of function 'bdev_get_integrity' [-Werror=implicit-function-declaration]
>       struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
>                                  ^
>     In file included from include/uapi/linux/stddef.h:1:0,
>                      from include/linux/stddef.h:4,
>                      from include/uapi/linux/posix_types.h:4,
>                      from include/uapi/linux/types.h:13,
>                      from include/linux/types.h:5,
>                      from include/uapi/linux/capability.h:16,
>                      from include/linux/capability.h:15,
>                      from include/linux/sched.h:15,
>                      from include/linux/blkdev.h:4,
>                      from block/bio-integrity.c:23:
>>> block/bio-integrity.c:165:7: error: implicit declaration of function 'bio_is_rw' [-Werror=implicit-function-declaration]
>       if (!bio_is_rw(bio))
>            ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:165:2: note: in expansion of macro 'if'
>       if (!bio_is_rw(bio))
>       ^
>>> block/bio-integrity.c:175:6: error: implicit declaration of function 'bio_data_dir' [-Werror=implicit-function-declaration]
>       if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
>           ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:175:2: note: in expansion of macro 'if'
>       if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
>       ^
>>> block/bio-integrity.c:175:37: error: dereferencing pointer to incomplete type 'struct blk_integrity'
>       if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
>                                          ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:175:2: note: in expansion of macro 'if'
>       if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
>       ^
>>> block/bio-integrity.c:176:19: error: 'BLK_INTEGRITY_VERIFY' undeclared (first use in this function)
>           (bi->flags & BLK_INTEGRITY_VERIFY))
>                        ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:175:2: note: in expansion of macro 'if'
>       if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
>       ^
>>> block/bio-integrity.c:180:19: error: 'BLK_INTEGRITY_GENERATE' undeclared (first use in this function)
>           (bi->flags & BLK_INTEGRITY_GENERATE))
>                        ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/bio-integrity.c:179:2: note: in expansion of macro 'if'
>       if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
>       ^
>     block/bio-integrity.c: At top level:
>>> block/bio-integrity.c:198:10: warning: 'struct blk_integrity' declared inside parameter list
>               unsigned int sectors)
>               ^
>>> block/bio-integrity.c:198:10: warning: its scope is only this definition or declaration, which is probably not what you want
>     In file included from include/linux/kernel.h:11:0,
>                      from include/linux/sched.h:17,
>                      from include/linux/blkdev.h:4,
>                      from block/bio-integrity.c:23:
>     block/bio-integrity.c: In function 'bio_integrity_intervals':
>     block/bio-integrity.c:200:29: error: dereferencing pointer to incomplete type 'struct blk_integrity'
>       return sectors >> (ilog2(bi->interval) - 9);
>                                  ^
>     include/linux/log2.h:87:23: note: in definition of macro 'ilog2'
>       __builtin_constant_p(n) ? (  \
>                            ^
>     block/bio-integrity.c: At top level:
>     block/bio-integrity.c:204:13: warning: 'struct blk_integrity' declared inside parameter list
>                  unsigned int sectors)
>                  ^
>     block/bio-integrity.c: In function 'bio_integrity_bytes':
> --
>     In file included from block/blk.h:5:0,
>                      from block/blk-integrity.c:31:
>>> include/linux/blk-mq.h:61:18: error: field 'kobj' has incomplete type
>       struct kobject  kobj;
>                       ^
>>> include/linux/blk-mq.h:117:2: error: unknown type name 'softirq_done_fn'
>       softirq_done_fn  *complete;
>       ^
>     include/linux/blk-mq.h: In function 'blk_mq_rq_from_pdu':
>>> include/linux/blk-mq.h:241:22: error: invalid application of 'sizeof' to incomplete type 'struct request'
>       return pdu - sizeof(struct request);
>                           ^
>     include/linux/blk-mq.h: In function 'blk_mq_rq_to_pdu':
>>> include/linux/blk-mq.h:245:2: error: invalid use of undefined type 'struct request'
>       return rq + 1;
>       ^
>     In file included from block/blk.h:6:0,
>                      from block/blk-integrity.c:31:
>     block/blk-mq.h: At top level:
>>> block/blk-mq.h:25:18: error: field 'kobj' has incomplete type
>       struct kobject  kobj;
>                       ^
>     In file included from include/asm-generic/percpu.h:6:0,
>                      from arch/x86/include/asm/percpu.h:551,
>                      from arch/x86/include/asm/preempt.h:5,
>                      from include/linux/preempt.h:64,
>                      from include/linux/spinlock.h:50,
>                      from include/linux/seqlock.h:35,
>                      from include/linux/time.h:5,
>                      from include/uapi/linux/timex.h:56,
>                      from include/linux/timex.h:56,
>                      from include/linux/sched.h:19,
>                      from include/linux/blkdev.h:4,
>                      from block/blk-integrity.c:23:
>     block/blk-mq.h: In function '__blk_mq_get_ctx':
>>> block/blk-mq.h:79:22: error: dereferencing pointer to incomplete type 'struct request_queue'
>       return per_cpu_ptr(q->queue_ctx, cpu);
>                           ^
>     include/linux/percpu-defs.h:206:47: note: in definition of macro '__verify_pcpu_ptr'
>       const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
>                                                    ^
>     include/linux/percpu-defs.h:250:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
>      #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
>                                                    ^
>>> block/blk-mq.h:79:9: note: in expansion of macro 'per_cpu_ptr'
>       return per_cpu_ptr(q->queue_ctx, cpu);
>              ^
>     In file included from block/blk-integrity.c:31:0:
>     block/blk.h: In function '__blk_get_queue':
>>> block/blk.h:54:2: error: implicit declaration of function 'kobject_get' [-Werror=implicit-function-declaration]
>       kobject_get(&q->kobj);
>       ^
>     block/blk.h: At top level:
>>> block/blk.h:62:3: warning: 'struct request_list' declared inside parameter list
>        gfp_t gfp_mask);
>        ^
>>> block/blk.h:62:3: warning: its scope is only this definition or declaration, which is probably not what you want
>     block/blk.h:63:25: warning: 'struct request_list' declared inside parameter list
>      void blk_exit_rl(struct request_list *rl);
>                              ^
>     block/blk.h: In function 'blk_mark_rq_complete':
>>> block/blk.h:108:48: error: dereferencing pointer to incomplete type 'struct request'
>       return test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
>                                                     ^
>     block/blk.h: In function '__elv_next_request':
>>> block/blk.h:130:9: error: implicit declaration of function 'list_entry_rq' [-Werror=implicit-function-declaration]
>         rq = list_entry_rq(q->queue_head.next);
>              ^
>     In file included from include/uapi/linux/stddef.h:1:0,
>                      from include/linux/stddef.h:4,
>                      from include/uapi/linux/posix_types.h:4,
>                      from include/uapi/linux/types.h:13,
>                      from include/linux/types.h:5,
>                      from include/uapi/linux/capability.h:16,
>                      from include/linux/capability.h:15,
>                      from include/linux/sched.h:15,
>                      from include/linux/blkdev.h:4,
>                      from block/blk-integrity.c:23:
>>> block/blk.h:150:6: error: implicit declaration of function 'queue_flush_queueable' [-Werror=implicit-function-declaration]
>          !queue_flush_queueable(q)) {
>           ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>>> block/blk.h:149:3: note: in expansion of macro 'if'
>        if (fq->flush_pending_idx != fq->flush_running_idx &&
>        ^
>>> block/blk.h:154:16: error: implicit declaration of function 'blk_queue_bypass' [-Werror=implicit-function-declaration]
>        if (unlikely(blk_queue_bypass(q)) ||
>                     ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/blk.h:154:3: note: in expansion of macro 'if'
>        if (unlikely(blk_queue_bypass(q)) ||
>        ^
>>> block/blk.h:154:7: note: in expansion of macro 'unlikely'
>        if (unlikely(blk_queue_bypass(q)) ||
>            ^
>     block/blk.h: In function 'elv_activate_rq':
>>> block/blk.h:164:7: error: dereferencing pointer to incomplete type 'struct elevator_queue'
>       if (e->type->ops.elevator_activate_req_fn)
>            ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/blk.h:164:2: note: in expansion of macro 'if'
>       if (e->type->ops.elevator_activate_req_fn)
>       ^
>     block/blk.h: In function 'elv_deactivate_rq':
>     block/blk.h:172:7: error: dereferencing pointer to incomplete type 'struct elevator_queue'
>       if (e->type->ops.elevator_deactivate_req_fn)
>            ^
>     include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
>       if (__builtin_constant_p((cond)) ? !!(cond) :   \
>                                 ^
>     block/blk.h:172:2: note: in expansion of macro 'if'
>       if (e->type->ops.elevator_deactivate_req_fn)
>       ^
>     In file included from block/blk-integrity.c:31:0:
>     block/blk.h: In function 'blk_do_io_stat':
>>> block/blk.h:237:20: error: 'REQ_TYPE_FS' undeclared (first use in this function)
>        (rq->cmd_type == REQ_TYPE_FS);
>                         ^
>     block/blk.h:237:20: note: each undeclared identifier is reported only once for each function it appears in
>     block/blk-integrity.c: In function 'blk_rq_count_integrity_sg':
>>> block/blk-integrity.c:50:19: error: storage size of 'iter' isn't known
>       struct bvec_iter iter;
>                        ^
>>> block/blk-integrity.c:53:2: error: implicit declaration of function 'bio_for_each_integrity_vec' [-Werror=implicit-function-declaration]
>       bio_for_each_integrity_vec(iv, bio, iter) {
>       ^
> ..
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                    Intel Corporation
