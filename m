From: kbuild test robot <lkp@intel.com>
Subject: Re: [PATCH v4 03/32] scsi: hisi_sas: add initial bare main driver
Date: Tue, 17 Nov 2015 01:35:13 +0800
Message-ID: <201511170040.GfC7Pkvq%fengguang.wu@intel.com>
References: <1447679178-220222-4-git-send-email-john.garry@huawei.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="sdtB3X0nJg68CQEu"
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1447679178-220222-4-git-send-email-john.garry@huawei.com>
Sender: linux-kernel-owner@vger.kernel.org
Cc: kbuild-all@01.org, JBottomley@odin.com, robh+dt@kernel.org, pawel.moll@arm.com, mark.rutland@arm.com, ijc+devicetree@hellion.org.uk, galak@codeaurora.org, arnd@arndb.de, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, linuxarm@huawei.com, john.garry2@mail.dcu.ie, hare@suse.de, xuwei5@hisilicon.com, zhangfei.gao@linaro.org, john.garry@huawei.com
List-Id: linux-scsi@vger.kernel.org


--sdtB3X0nJg68CQEu
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi John,

[auto build test ERROR on scsi/for-next]
[also build test ERROR on v4.4-rc1 next-20151116]

url:    https://github.com/0day-ci/linux/commits/John-Garry/HiSilicon-SAS-driver/20151116-215304
base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
config: i386-randconfig-s0-11162304 (attached as .config)
reproduce:
        # save the attached .config to linux build tree
        make ARCH=i386 

All error/warnings (new ones prefixed by >>):

warning: (SCSI_HISI_SAS && TCM_IBLOCK) selects BLK_DEV_INTEGRITY which has unmet direct dependencies (BLOCK)
warning: (SCSI_HISI_SAS) selects SCSI_SAS_LIBSAS which has unmet direct dependencies (SCSI)
   block/bio-integrity.c: In function 'bio_integrity_alloc':
>> block/bio-integrity.c:50:26: error: dereferencing pointer to incomplete type 'struct bio'
     struct bio_set *bs = bio->bi_pool;
                             ^
>> block/bio-integrity.c:51:22: error: 'BIO_POOL_NONE' undeclared (first use in this function)
     unsigned long idx = BIO_POOL_NONE;
                         ^
   block/bio-integrity.c:51:22: note: each undeclared identifier is reported only once for each function it appears in
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/uapi/linux/capability.h:16,
                    from include/linux/capability.h:15,
                    from include/linux/sched.h:15,
                    from include/linux/blkdev.h:4,
                    from block/bio-integrity.c:23:
>> block/bio-integrity.c:54:16: error: dereferencing pointer to incomplete type 'struct bio_set'
     if (!bs || !bs->bio_integrity_pool) {
                   ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
>> block/bio-integrity.c:54:2: note: in expansion of macro 'if'
     if (!bs || !bs->bio_integrity_pool) {
     ^
>> block/bio-integrity.c:55:24: error: invalid application of 'sizeof' to incomplete type 'struct bio_integrity_payload'
      bip = kmalloc(sizeof(struct bio_integrity_payload) +
                           ^
   In file included from arch/x86/include/asm/string.h:2:0,
                    from include/linux/string.h:17,
                    from include/linux/dynamic_debug.h:111,
                    from include/linux/printk.h:277,
                    from include/linux/kernel.h:13,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from block/bio-integrity.c:23:
>> block/bio-integrity.c:66:24: error: dereferencing pointer to incomplete type 'struct bio_integrity_payload'
     memset(bip, 0, sizeof(*bip));
                           ^
   arch/x86/include/asm/string_32.h:325:52: note: in definition of macro 'memset'
    #define memset(s, c, count) __builtin_memset(s, c, count)
                                                       ^
>> block/bio-integrity.c:69:18: error: implicit declaration of function 'bvec_alloc' [-Werror=implicit-function-declaration]
      bip->bip_vec = bvec_alloc(gfp_mask, nr_vecs, &idx,
                     ^
>> block/bio-integrity.c:73:23: error: implicit declaration of function 'bvec_nr_vecs' [-Werror=implicit-function-declaration]
      bip->bip_max_vcnt = bvec_nr_vecs(idx);
                          ^
   block/bio-integrity.c: In function 'bio_integrity_free':
>> block/bio-integrity.c:100:38: error: implicit declaration of function 'bio_integrity' [-Werror=implicit-function-declaration]
     struct bio_integrity_payload *bip = bio_integrity(bio);
                                         ^
>> block/bio-integrity.c:100:38: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/uapi/linux/capability.h:16,
                    from include/linux/capability.h:15,
                    from include/linux/sched.h:15,
                    from include/linux/blkdev.h:4,
                    from block/bio-integrity.c:23:
>> block/bio-integrity.c:103:23: error: 'BIP_BLOCK_INTEGRITY' undeclared (first use in this function)
     if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
                          ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:103:2: note: in expansion of macro 'if'
     if (bip->bip_flags & BIP_BLOCK_INTEGRITY)
     ^
   block/bio-integrity.c:108:24: error: 'BIO_POOL_NONE' undeclared (first use in this function)
      if (bip->bip_slab != BIO_POOL_NONE)
                           ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:108:3: note: in expansion of macro 'if'
      if (bip->bip_slab != BIO_POOL_NONE)
      ^
>> block/bio-integrity.c:109:4: error: implicit declaration of function 'bvec_free' [-Werror=implicit-function-declaration]
       bvec_free(bs->bvec_integrity_pool, bip->bip_vec,
       ^
   block/bio-integrity.c: In function 'bio_integrity_add_page':
   block/bio-integrity.c:133:38: warning: initialization makes pointer from integer without a cast [-Wint-conversion]
     struct bio_integrity_payload *bip = bio_integrity(bio);
                                         ^
   block/bio-integrity.c: In function 'bio_integrity_enabled':
>> block/bio-integrity.c:163:29: error: implicit declaration of function 'bdev_get_integrity' [-Werror=implicit-function-declaration]
     struct blk_integrity *bi = bdev_get_integrity(bio->bi_bdev);
                                ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/uapi/linux/capability.h:16,
                    from include/linux/capability.h:15,
                    from include/linux/sched.h:15,
                    from include/linux/blkdev.h:4,
                    from block/bio-integrity.c:23:
>> block/bio-integrity.c:165:7: error: implicit declaration of function 'bio_is_rw' [-Werror=implicit-function-declaration]
     if (!bio_is_rw(bio))
          ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:165:2: note: in expansion of macro 'if'
     if (!bio_is_rw(bio))
     ^
>> block/bio-integrity.c:175:6: error: implicit declaration of function 'bio_data_dir' [-Werror=implicit-function-declaration]
     if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
         ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:175:2: note: in expansion of macro 'if'
     if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
     ^
>> block/bio-integrity.c:175:37: error: dereferencing pointer to incomplete type 'struct blk_integrity'
     if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
                                        ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:175:2: note: in expansion of macro 'if'
     if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
     ^
>> block/bio-integrity.c:176:19: error: 'BLK_INTEGRITY_VERIFY' undeclared (first use in this function)
         (bi->flags & BLK_INTEGRITY_VERIFY))
                      ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:175:2: note: in expansion of macro 'if'
     if (bio_data_dir(bio) == READ && bi->verify_fn != NULL &&
     ^
>> block/bio-integrity.c:180:19: error: 'BLK_INTEGRITY_GENERATE' undeclared (first use in this function)
         (bi->flags & BLK_INTEGRITY_GENERATE))
                      ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/bio-integrity.c:179:2: note: in expansion of macro 'if'
     if (bio_data_dir(bio) == WRITE && bi->generate_fn != NULL &&
     ^
   block/bio-integrity.c: At top level:
>> block/bio-integrity.c:198:10: warning: 'struct blk_integrity' declared inside parameter list
             unsigned int sectors)
             ^
>> block/bio-integrity.c:198:10: warning: its scope is only this definition or declaration, which is probably not what you want
   In file included from include/linux/kernel.h:11:0,
                    from include/linux/sched.h:17,
                    from include/linux/blkdev.h:4,
                    from block/bio-integrity.c:23:
   block/bio-integrity.c: In function 'bio_integrity_intervals':
   block/bio-integrity.c:200:29: error: dereferencing pointer to incomplete type 'struct blk_integrity'
     return sectors >> (ilog2(bi->interval) - 9);
                                ^
   include/linux/log2.h:87:23: note: in definition of macro 'ilog2'
     __builtin_constant_p(n) ? (  \
                          ^
   block/bio-integrity.c: At top level:
   block/bio-integrity.c:204:13: warning: 'struct blk_integrity' declared inside parameter list
                unsigned int sectors)
                ^
   block/bio-integrity.c: In function 'bio_integrity_bytes':
--
   In file included from block/blk.h:5:0,
                    from block/blk-integrity.c:31:
>> include/linux/blk-mq.h:61:18: error: field 'kobj' has incomplete type
     struct kobject  kobj;
                     ^
>> include/linux/blk-mq.h:117:2: error: unknown type name 'softirq_done_fn'
     softirq_done_fn  *complete;
     ^
   include/linux/blk-mq.h: In function 'blk_mq_rq_from_pdu':
>> include/linux/blk-mq.h:241:22: error: invalid application of 'sizeof' to incomplete type 'struct request'
     return pdu - sizeof(struct request);
                         ^
   include/linux/blk-mq.h: In function 'blk_mq_rq_to_pdu':
>> include/linux/blk-mq.h:245:2: error: invalid use of undefined type 'struct request'
     return rq + 1;
     ^
   In file included from block/blk.h:6:0,
                    from block/blk-integrity.c:31:
   block/blk-mq.h: At top level:
>> block/blk-mq.h:25:18: error: field 'kobj' has incomplete type
     struct kobject  kobj;
                     ^
   In file included from include/asm-generic/percpu.h:6:0,
                    from arch/x86/include/asm/percpu.h:551,
                    from arch/x86/include/asm/preempt.h:5,
                    from include/linux/preempt.h:64,
                    from include/linux/spinlock.h:50,
                    from include/linux/seqlock.h:35,
                    from include/linux/time.h:5,
                    from include/uapi/linux/timex.h:56,
                    from include/linux/timex.h:56,
                    from include/linux/sched.h:19,
                    from include/linux/blkdev.h:4,
                    from block/blk-integrity.c:23:
   block/blk-mq.h: In function '__blk_mq_get_ctx':
>> block/blk-mq.h:79:22: error: dereferencing pointer to incomplete type 'struct request_queue'
     return per_cpu_ptr(q->queue_ctx, cpu);
                         ^
   include/linux/percpu-defs.h:206:47: note: in definition of macro '__verify_pcpu_ptr'
     const void __percpu *__vpp_verify = (typeof((ptr) + 0))NULL; \
                                                  ^
   include/linux/percpu-defs.h:250:47: note: in expansion of macro 'VERIFY_PERCPU_PTR'
    #define per_cpu_ptr(ptr, cpu) ({ (void)(cpu); VERIFY_PERCPU_PTR(ptr); })
                                                  ^
>> block/blk-mq.h:79:9: note: in expansion of macro 'per_cpu_ptr'
     return per_cpu_ptr(q->queue_ctx, cpu);
            ^
   In file included from block/blk-integrity.c:31:0:
   block/blk.h: In function '__blk_get_queue':
>> block/blk.h:54:2: error: implicit declaration of function 'kobject_get' [-Werror=implicit-function-declaration]
     kobject_get(&q->kobj);
     ^
   block/blk.h: At top level:
>> block/blk.h:62:3: warning: 'struct request_list' declared inside parameter list
      gfp_t gfp_mask);
      ^
>> block/blk.h:62:3: warning: its scope is only this definition or declaration, which is probably not what you want
   block/blk.h:63:25: warning: 'struct request_list' declared inside parameter list
    void blk_exit_rl(struct request_list *rl);
                            ^
   block/blk.h: In function 'blk_mark_rq_complete':
>> block/blk.h:108:48: error: dereferencing pointer to incomplete type 'struct request'
     return test_and_set_bit(REQ_ATOM_COMPLETE, &rq->atomic_flags);
                                                   ^
   block/blk.h: In function '__elv_next_request':
>> block/blk.h:130:9: error: implicit declaration of function 'list_entry_rq' [-Werror=implicit-function-declaration]
       rq = list_entry_rq(q->queue_head.next);
            ^
   In file included from include/uapi/linux/stddef.h:1:0,
                    from include/linux/stddef.h:4,
                    from include/uapi/linux/posix_types.h:4,
                    from include/uapi/linux/types.h:13,
                    from include/linux/types.h:5,
                    from include/uapi/linux/capability.h:16,
                    from include/linux/capability.h:15,
                    from include/linux/sched.h:15,
                    from include/linux/blkdev.h:4,
                    from block/blk-integrity.c:23:
>> block/blk.h:150:6: error: implicit declaration of function 'queue_flush_queueable' [-Werror=implicit-function-declaration]
        !queue_flush_queueable(q)) {
         ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
>> block/blk.h:149:3: note: in expansion of macro 'if'
      if (fq->flush_pending_idx != fq->flush_running_idx &&
      ^
>> block/blk.h:154:16: error: implicit declaration of function 'blk_queue_bypass' [-Werror=implicit-function-declaration]
      if (unlikely(blk_queue_bypass(q)) ||
                   ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/blk.h:154:3: note: in expansion of macro 'if'
      if (unlikely(blk_queue_bypass(q)) ||
      ^
>> block/blk.h:154:7: note: in expansion of macro 'unlikely'
      if (unlikely(blk_queue_bypass(q)) ||
          ^
   block/blk.h: In function 'elv_activate_rq':
>> block/blk.h:164:7: error: dereferencing pointer to incomplete type 'struct elevator_queue'
     if (e->type->ops.elevator_activate_req_fn)
          ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/blk.h:164:2: note: in expansion of macro 'if'
     if (e->type->ops.elevator_activate_req_fn)
     ^
   block/blk.h: In function 'elv_deactivate_rq':
   block/blk.h:172:7: error: dereferencing pointer to incomplete type 'struct elevator_queue'
     if (e->type->ops.elevator_deactivate_req_fn)
          ^
   include/linux/compiler.h:147:28: note: in definition of macro '__trace_if'
     if (__builtin_constant_p((cond)) ? !!(cond) :   \
                               ^
   block/blk.h:172:2: note: in expansion of macro 'if'
     if (e->type->ops.elevator_deactivate_req_fn)
     ^
   In file included from block/blk-integrity.c:31:0:
   block/blk.h: In function 'blk_do_io_stat':
>> block/blk.h:237:20: error: 'REQ_TYPE_FS' undeclared (first use in this function)
      (rq->cmd_type == REQ_TYPE_FS);
                       ^
   block/blk.h:237:20: note: each undeclared identifier is reported only once for each function it appears in
   block/blk-integrity.c: In function 'blk_rq_count_integrity_sg':
>> block/blk-integrity.c:50:19: error: storage size of 'iter' isn't known
     struct bvec_iter iter;
                      ^
>> block/blk-integrity.c:53:2: error: implicit declaration of function 'bio_for_each_integrity_vec' [-Werror=implicit-function-declaration]
     bio_for_each_integrity_vec(iv, bio, iter) {
     ^
..

---
0-DAY kernel test infrastructure                Open Source Technology Center
https://lists.01.org/pipermail/kbuild-all                   Intel Corporation

--sdtB3X0nJg68CQEu
Content-Type: application/octet-stream
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
I5MYCzH/ARd6KgFhcwEA

--sdtB3X0nJg68CQEu--
