From: Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>
Subject: Re: [PATCH 4/6] mpt3sas: Introduce Base function for cloning.
Date: Wed, 24 Jan 2018 11:14:40 +0530
Message-ID: <CA+RiK64DhFTBeJvUOJ_mAjSJ-YryqhubEiLhg=qjAYZY=-X=2w@mail.gmail.com>
References: <1516365462-14708-5-git-send-email-suganath-prabu.subramani@broadcom.com>
 <201801210109.6fbXCSxH%fengguang.wu@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f174.google.com ([209.85.216.174]:32938 "EHLO
        mail-qt0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750992AbeAXFol (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 24 Jan 2018 00:44:41 -0500
Received: by mail-qt0-f174.google.com with SMTP id d8so7612008qtm.0
        for <linux-scsi@vger.kernel.org>; Tue, 23 Jan 2018 21:44:41 -0800 (PST)
In-Reply-To: <201801210109.6fbXCSxH%fengguang.wu@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild-all@01.org
Cc: linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org, Sathya Prakash <Sathya.Prakash@broadcom.com>, Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>

Hi All,

We tried to reproduce below error
"drivers/scsi/mpt3sas/mpt3sas_base.c:315:10: error: implicit
declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);"

with base code and Make file flags (sparse) as mentioned under
reproduce in auto build test log.

We are not seeing this error. We have reviewed the code and it seems
to be fine. Let us know if we miss something here.

base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
reproduce:
        # apt-get install sparse
        make ARCH=x86_64 allmodconfig
        make C=1 CF=-D__CHECK_ENDIAN__

  drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_clone_sg_entries':
   drivers/scsi/mpt3sas/mpt3sas_base.c:315:10: error: implicit
declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    mpt3sas_scsih_issue_locked_tm
   drivers/scsi/mpt3sas/mpt3sas_base.c:315:8: warning: assignment
makes pointer from integer without a cast
    scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
    ^
   At top level:
   drivers/scsi/mpt3sas/mpt3sas_base.c:278:13: warning:
'_clone_sg_entries' defined but not used
    static void _clone_sg_entries(struct MPT3SAS_ADAPTER
    ^~~~~~~~~~~~~~~~~
   cc1: some warnings being treated as errors


Thanks,
Suganath Prabu S

On Sat, Jan 20, 2018 at 11:37 PM, kbuild test robot <lkp@intel.com> wrote:
> Hi Suganath,
>
> I love your patch! Perhaps something to improve:
>
> [auto build test WARNING on scsi/for-next]
> [also build test WARNING on v4.15-rc8 next-20180119]
> [if your patch is applied to the wrong git tree, please drop us a note to help improve the system]
>
> url:    https://github.com/0day-ci/linux/commits/Suganath-Prabu-S/mpt3sas-Add-PCI-device-ID-for-Andromeda/20180121-002454
> base:   https://git.kernel.org/pub/scm/linux/kernel/git/jejb/scsi.git for-next
> reproduce:
>         # apt-get install sparse
>         make ARCH=x86_64 allmodconfig
>         make C=1 CF=-D__CHECK_ENDIAN__
>
>
> sparse warnings: (new ones prefixed by >>)
>
>>> drivers/scsi/mpt3sas/mpt3sas_base.c:142:24: sparse: cast from restricted __le32
>    drivers/scsi/mpt3sas/mpt3sas_base.c:142:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:142:24: expected unsigned int val
>    drivers/scsi/mpt3sas/mpt3sas_base.c:142:24: got restricted __le32 <noident>
>>> drivers/scsi/mpt3sas/mpt3sas_base.c:142:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:142:64: expected void volatile
>    drivers/scsi/mpt3sas/mpt3sas_base.c:142:64: got void COPYING CREDITS Documentation Kbuild Kconfig MAINTAINERS Makefile README arch block certs crypto drivers firmware fs include init ipc kernel lib mm net samples scripts security sound tools usr virt
>    drivers/scsi/mpt3sas/mpt3sas_base.c:162:24: sparse: cast removes address space of expression
>    drivers/scsi/mpt3sas/mpt3sas_base.c:315:24: sparse: undefined identifier 'mpt3sas_scsih_scsi_lookup_get'
>    drivers/scsi/mpt3sas/mpt3sas_base.c:1164:42: sparse: incorrect type in assignment (different base types) @@ expected unsigned short Event @@ got short Event @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:1165:49: sparse: incorrect type in assignment (different base types) @@ expected unsigned int EventContext @@ got ed int EventContext @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:1383:64: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:1432:52: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:2964:32: sparse: cast removes address space of expression
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3256:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3256:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3256:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3256:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3256:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned long val @@ got restunsigned long val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3411:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3433:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3456:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3477:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:3498:16: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:4950:24: sparse: incorrect type in argument 1 (different base types) @@ expected unsigned int val @@ got restrunsigned int val @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:4971:20: sparse: cast to restricted __le16
>    drivers/scsi/mpt3sas/mpt3sas_base.c:4980:20: sparse: cast to restricted __le16
>    drivers/scsi/mpt3sas/mpt3sas_base.c:4994:36: sparse: cast to restricted __le16
>    drivers/scsi/mpt3sas/mpt3sas_base.c:6175:55: sparse: incorrect type in argument 2 (different address spaces) @@ expected void volatile @@ got oid volatile @@
>    drivers/scsi/mpt3sas/mpt3sas_base.c:315:53: sparse: call with no type!
>    drivers/scsi/mpt3sas/mpt3sas_base.c: In function '_clone_sg_entries':
>    drivers/scsi/mpt3sas/mpt3sas_base.c:315:10: error: implicit declaration of function 'mpt3sas_scsih_scsi_lookup_get'; did you mean
>     scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>     mpt3sas_scsih_issue_locked_tm
>    drivers/scsi/mpt3sas/mpt3sas_base.c:315:8: warning: assignment makes pointer from integer without a cast
>     scmd = mpt3sas_scsih_scsi_lookup_get(ioc, smid);
>     ^
>    At top level:
>    drivers/scsi/mpt3sas/mpt3sas_base.c:278:13: warning: '_clone_sg_entries' defined but not used
>     static void _clone_sg_entries(struct MPT3SAS_ADAPTER
>     ^~~~~~~~~~~~~~~~~
>    cc1: some warnings being treated as errors
>
> vim +142 drivers/scsi/mpt3sas/mpt3sas_base.c
>
>    103
>    104  /**
>    105   * _scsih_set_fwfault_debug - global setting of ioc->fwfault_debug.
>    106   *
>    107   */
>    108  static int
>    109  _scsih_set_fwfault_debug(const char *val, const struct kernel_param *kp)
>    110  {
>    111          int ret = param_set_int(val, kp);
>    112          struct MPT3SAS_ADAPTER *ioc;
>    113
>    114          if (ret)
>    115                  return ret;
>    116
>    117          /* global ioc spinlock to protect controller list on list operations */
>    118          pr_info("setting fwfault_debug(%d)\n", mpt3sas_fwfault_debug);
>    119          spin_lock(&gioc_lock);
>    120          list_for_each_entry(ioc, &mpt3sas_ioc_list, list)
>    121                  ioc->fwfault_debug = mpt3sas_fwfault_debug;
>    122          spin_unlock(&gioc_lock);
>    123          return 0;
>    124  }
>    125  module_param_call(mpt3sas_fwfault_debug, _scsih_set_fwfault_debug,
>    126          param_get_int, &mpt3sas_fwfault_debug, 0644);
>    127
>    128  /**
>    129   * _base_clone_to_sys_mem - Writes/copies data to system/BAR0 region
>    130   *
>    131   * @dst_iomem: Pointer to the destinaltion location in BAR0 space.
>    132   * @src: Pointer to the Source data.
>    133   * @size: Size of data to be copied.
>    134   */
>    135  static void
>    136  _base_clone_to_sys_mem(void *dst_iomem, void *src, u32 size)
>    137  {
>    138          int i;
>    139          __le32 *src_virt_mem = (__le32 *)(src);
>    140
>    141          for (i = 0; i < size/4; i++)
>  > 142                  writel(cpu_to_le32(src_virt_mem[i]), dst_iomem + (i * 4));
>    143  }
>    144
>
> ---
> 0-DAY kernel test infrastructure                Open Source Technology Center
> https://lists.01.org/pipermail/kbuild-all                   Intel Corporation
