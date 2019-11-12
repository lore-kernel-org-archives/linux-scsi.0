Return-Path: <SRS0=nPvI=ZE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36190C17441
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 23:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D9CB821925
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Nov 2019 23:41:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727044AbfKLXlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Nov 2019 18:41:46 -0500
Received: from mga09.intel.com ([134.134.136.24]:33861 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726910AbfKLXlq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 12 Nov 2019 18:41:46 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 12 Nov 2019 15:41:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.68,298,1569308400"; 
   d="gz'50?scan'50,208,50";a="405774474"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 12 Nov 2019 15:41:36 -0800
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1iUfmx-000HFa-Ko; Wed, 13 Nov 2019 07:41:35 +0800
Date:   Wed, 13 Nov 2019 07:41:26 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     kbuild-all@lists.01.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi_dh_rdac: avoid crash during rescan
Message-ID: <201911130742.3SwyQpqR%lkp@intel.com>
References: <20191111104522.99531-1-hare@suse.de>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6cp4vxtngoqur52j"
Content-Disposition: inline
In-Reply-To: <20191111104522.99531-1-hare@suse.de>
X-Patchwork-Hint: ignore
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--6cp4vxtngoqur52j
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Hannes,

I love your patch! Yet something to improve:

[auto build test ERROR on mkp-scsi/for-next]
[also build test ERROR on v5.4-rc7 next-20191112]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Hannes-Reinecke/scsi_dh_rdac-avoid-crash-during-rescan/20191113-021538
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: x86_64-rhel-7.6-kasan (attached as .config)
compiler: gcc-7 (Debian 7.4.0-14) 7.4.0
reproduce:
        # save the attached .config to linux build tree
        make ARCH=x86_64 

If you fix the issue, kindly add following tag
Reported-by: kbuild test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/scsi/device_handler/scsi_dh_rdac.c: In function 'check_ownership':
>> drivers/scsi/device_handler/scsi_dh_rdac.c:437:12: error: invalid storage class for function 'initialize_controller'
    static int initialize_controller(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:437:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    static int initialize_controller(struct scsi_device *sdev,
    ^~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:465:12: error: invalid storage class for function 'set_mode_select'
    static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
               ^~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:485:12: error: invalid storage class for function 'mode_select_handle_sense'
    static int mode_select_handle_sense(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:527:13: error: invalid storage class for function 'send_mode_select'
    static void send_mode_select(struct work_struct *work)
                ^~~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:585:12: error: invalid storage class for function 'queue_mode_select'
    static int queue_mode_select(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:611:12: error: invalid storage class for function 'rdac_activate'
    static int rdac_activate(struct scsi_device *sdev,
               ^~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:647:21: error: invalid storage class for function 'rdac_prep_fn'
    static blk_status_t rdac_prep_fn(struct scsi_device *sdev, struct request *req)
                        ^~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:659:12: error: invalid storage class for function 'rdac_check_sense'
    static int rdac_check_sense(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:724:12: error: invalid storage class for function 'rdac_bus_attach'
    static int rdac_bus_attach(struct scsi_device *sdev)
               ^~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:771:13: error: invalid storage class for function 'rdac_bus_detach'
    static void rdac_bus_detach( struct scsi_device *sdev )
                ^~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:792:13: error: initializer element is not constant
     .prep_fn = rdac_prep_fn,
                ^~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:792:13: note: (near initialization for 'rdac_dh.prep_fn')
   drivers/scsi/device_handler/scsi_dh_rdac.c:793:17: error: initializer element is not constant
     .check_sense = rdac_check_sense,
                    ^~~~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:793:17: note: (near initialization for 'rdac_dh.check_sense')
   drivers/scsi/device_handler/scsi_dh_rdac.c:794:12: error: initializer element is not constant
     .attach = rdac_bus_attach,
               ^~~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:794:12: note: (near initialization for 'rdac_dh.attach')
   drivers/scsi/device_handler/scsi_dh_rdac.c:795:12: error: initializer element is not constant
     .detach = rdac_bus_detach,
               ^~~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:795:12: note: (near initialization for 'rdac_dh.detach')
   drivers/scsi/device_handler/scsi_dh_rdac.c:796:14: error: initializer element is not constant
     .activate = rdac_activate,
                 ^~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:796:14: note: (near initialization for 'rdac_dh.activate')
>> drivers/scsi/device_handler/scsi_dh_rdac.c:799:19: error: invalid storage class for function 'rdac_init'
    static int __init rdac_init(void)
                      ^~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:823:20: error: invalid storage class for function 'rdac_exit'
    static void __exit rdac_exit(void)
                       ^~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/scatterlist.h:5,
                    from include/scsi/scsi.h:10,
                    from drivers/scsi/device_handler/scsi_dh_rdac.c:22:
>> include/linux/compiler.h:302:44: error: initializer element is not constant
      __PASTE(__addressable_##sym, __LINE__) = (void *)&sym;
                                               ^
   include/linux/init.h:189:2: note: in expansion of macro '__ADDRESSABLE'
     __ADDRESSABLE(fn)     \
     ^~~~~~~~~~~~~
   include/linux/init.h:200:35: note: in expansion of macro '___define_initcall'
    #define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
                                      ^~~~~~~~~~~~~~~~~~
   include/linux/init.h:229:30: note: in expansion of macro '__define_initcall'
    #define device_initcall(fn)  __define_initcall(fn, 6)
                                 ^~~~~~~~~~~~~~~~~
   include/linux/init.h:234:24: note: in expansion of macro 'device_initcall'
    #define __initcall(fn) device_initcall(fn)
                           ^~~~~~~~~~~~~~~
   include/linux/module.h:85:24: note: in expansion of macro '__initcall'
    #define module_init(x) __initcall(x);
                           ^~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:829:1: note: in expansion of macro 'module_init'
    module_init(rdac_init);
    ^~~~~~~~~~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:15,
                    from include/asm-generic/bug.h:19,
                    from arch/x86/include/asm/bug.h:83,
                    from include/linux/bug.h:5,
                    from include/linux/scatterlist.h:7,
                    from include/scsi/scsi.h:10,
                    from drivers/scsi/device_handler/scsi_dh_rdac.c:22:
   drivers/scsi/device_handler/scsi_dh_rdac.c:830:13: error: initializer element is not constant
    module_exit(rdac_exit);
                ^
   include/linux/init.h:237:50: note: in definition of macro '__exitcall'
     static exitcall_t __exitcall_##fn __exit_call = fn
                                                     ^~
   drivers/scsi/device_handler/scsi_dh_rdac.c:830:1: note: in expansion of macro 'module_exit'
    module_exit(rdac_exit);
    ^~~~~~~~~~~
   include/linux/init.h:237:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     static exitcall_t __exitcall_##fn __exit_call = fn
     ^
   include/linux/module.h:97:24: note: in expansion of macro '__exitcall'
    #define module_exit(x) __exitcall(x);
                           ^~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:830:1: note: in expansion of macro 'module_exit'
    module_exit(rdac_exit);
    ^~~~~~~~~~~
   In file included from include/linux/module.h:18:0,
                    from drivers/scsi/device_handler/scsi_dh_rdac.c:27:
   include/linux/moduleparam.h:24:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    static const char __UNIQUE_ID(name)[]       \
    ^
   include/linux/module.h:159:32: note: in expansion of macro '__MODULE_INFO'
    #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
                                   ^~~~~~~~~~~~~
   include/linux/module.h:222:42: note: in expansion of macro 'MODULE_INFO'
    #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
                                             ^~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:832:1: note: in expansion of macro 'MODULE_DESCRIPTION'
    MODULE_DESCRIPTION("Multipath LSI/Engenio/NetApp E-Series RDAC driver");
    ^~~~~~~~~~~~~~~~~~
>> drivers/scsi/device_handler/scsi_dh_rdac.c:835:1: error: expected declaration or statement at end of input
    MODULE_LICENSE("GPL");
    ^~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c: At top level:
   drivers/scsi/device_handler/scsi_dh_rdac.c:237:13: warning: 'send_mode_select' used but never defined
    static void send_mode_select(struct work_struct *work);
                ^~~~~~~~~~~~~~~~
   drivers/scsi/device_handler/scsi_dh_rdac.c:527:13: warning: 'send_mode_select' defined but not used [-Wunused-function]
    static void send_mode_select(struct work_struct *work)
                ^~~~~~~~~~~~~~~~
--
   drivers/scsi//device_handler/scsi_dh_rdac.c: In function 'check_ownership':
   drivers/scsi//device_handler/scsi_dh_rdac.c:437:12: error: invalid storage class for function 'initialize_controller'
    static int initialize_controller(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:437:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    static int initialize_controller(struct scsi_device *sdev,
    ^~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:465:12: error: invalid storage class for function 'set_mode_select'
    static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
               ^~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:485:12: error: invalid storage class for function 'mode_select_handle_sense'
    static int mode_select_handle_sense(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:527:13: error: invalid storage class for function 'send_mode_select'
    static void send_mode_select(struct work_struct *work)
                ^~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:585:12: error: invalid storage class for function 'queue_mode_select'
    static int queue_mode_select(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:611:12: error: invalid storage class for function 'rdac_activate'
    static int rdac_activate(struct scsi_device *sdev,
               ^~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:647:21: error: invalid storage class for function 'rdac_prep_fn'
    static blk_status_t rdac_prep_fn(struct scsi_device *sdev, struct request *req)
                        ^~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:659:12: error: invalid storage class for function 'rdac_check_sense'
    static int rdac_check_sense(struct scsi_device *sdev,
               ^~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:724:12: error: invalid storage class for function 'rdac_bus_attach'
    static int rdac_bus_attach(struct scsi_device *sdev)
               ^~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:771:13: error: invalid storage class for function 'rdac_bus_detach'
    static void rdac_bus_detach( struct scsi_device *sdev )
                ^~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:792:13: error: initializer element is not constant
     .prep_fn = rdac_prep_fn,
                ^~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:792:13: note: (near initialization for 'rdac_dh.prep_fn')
   drivers/scsi//device_handler/scsi_dh_rdac.c:793:17: error: initializer element is not constant
     .check_sense = rdac_check_sense,
                    ^~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:793:17: note: (near initialization for 'rdac_dh.check_sense')
   drivers/scsi//device_handler/scsi_dh_rdac.c:794:12: error: initializer element is not constant
     .attach = rdac_bus_attach,
               ^~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:794:12: note: (near initialization for 'rdac_dh.attach')
   drivers/scsi//device_handler/scsi_dh_rdac.c:795:12: error: initializer element is not constant
     .detach = rdac_bus_detach,
               ^~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:795:12: note: (near initialization for 'rdac_dh.detach')
   drivers/scsi//device_handler/scsi_dh_rdac.c:796:14: error: initializer element is not constant
     .activate = rdac_activate,
                 ^~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:796:14: note: (near initialization for 'rdac_dh.activate')
   drivers/scsi//device_handler/scsi_dh_rdac.c:799:19: error: invalid storage class for function 'rdac_init'
    static int __init rdac_init(void)
                      ^~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:823:20: error: invalid storage class for function 'rdac_exit'
    static void __exit rdac_exit(void)
                       ^~~~~~~~~
   In file included from include/linux/string.h:6:0,
                    from include/linux/scatterlist.h:5,
                    from include/scsi/scsi.h:10,
                    from drivers/scsi//device_handler/scsi_dh_rdac.c:22:
>> include/linux/compiler.h:302:44: error: initializer element is not constant
      __PASTE(__addressable_##sym, __LINE__) = (void *)&sym;
                                               ^
   include/linux/init.h:189:2: note: in expansion of macro '__ADDRESSABLE'
     __ADDRESSABLE(fn)     \
     ^~~~~~~~~~~~~
   include/linux/init.h:200:35: note: in expansion of macro '___define_initcall'
    #define __define_initcall(fn, id) ___define_initcall(fn, id, .initcall##id)
                                      ^~~~~~~~~~~~~~~~~~
   include/linux/init.h:229:30: note: in expansion of macro '__define_initcall'
    #define device_initcall(fn)  __define_initcall(fn, 6)
                                 ^~~~~~~~~~~~~~~~~
   include/linux/init.h:234:24: note: in expansion of macro 'device_initcall'
    #define __initcall(fn) device_initcall(fn)
                           ^~~~~~~~~~~~~~~
   include/linux/module.h:85:24: note: in expansion of macro '__initcall'
    #define module_init(x) __initcall(x);
                           ^~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:829:1: note: in expansion of macro 'module_init'
    module_init(rdac_init);
    ^~~~~~~~~~~
   In file included from include/linux/printk.h:6:0,
                    from include/linux/kernel.h:15,
                    from include/asm-generic/bug.h:19,
                    from arch/x86/include/asm/bug.h:83,
                    from include/linux/bug.h:5,
                    from include/linux/scatterlist.h:7,
                    from include/scsi/scsi.h:10,
                    from drivers/scsi//device_handler/scsi_dh_rdac.c:22:
   drivers/scsi//device_handler/scsi_dh_rdac.c:830:13: error: initializer element is not constant
    module_exit(rdac_exit);
                ^
   include/linux/init.h:237:50: note: in definition of macro '__exitcall'
     static exitcall_t __exitcall_##fn __exit_call = fn
                                                     ^~
   drivers/scsi//device_handler/scsi_dh_rdac.c:830:1: note: in expansion of macro 'module_exit'
    module_exit(rdac_exit);
    ^~~~~~~~~~~
   include/linux/init.h:237:2: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
     static exitcall_t __exitcall_##fn __exit_call = fn
     ^
   include/linux/module.h:97:24: note: in expansion of macro '__exitcall'
    #define module_exit(x) __exitcall(x);
                           ^~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:830:1: note: in expansion of macro 'module_exit'
    module_exit(rdac_exit);
    ^~~~~~~~~~~
   In file included from include/linux/module.h:18:0,
                    from drivers/scsi//device_handler/scsi_dh_rdac.c:27:
   include/linux/moduleparam.h:24:1: warning: ISO C90 forbids mixed declarations and code [-Wdeclaration-after-statement]
    static const char __UNIQUE_ID(name)[]       \
    ^
   include/linux/module.h:159:32: note: in expansion of macro '__MODULE_INFO'
    #define MODULE_INFO(tag, info) __MODULE_INFO(tag, tag, info)
                                   ^~~~~~~~~~~~~
   include/linux/module.h:222:42: note: in expansion of macro 'MODULE_INFO'
    #define MODULE_DESCRIPTION(_description) MODULE_INFO(description, _description)
                                             ^~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:832:1: note: in expansion of macro 'MODULE_DESCRIPTION'
    MODULE_DESCRIPTION("Multipath LSI/Engenio/NetApp E-Series RDAC driver");
    ^~~~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:835:1: error: expected declaration or statement at end of input
    MODULE_LICENSE("GPL");
    ^~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c: At top level:
   drivers/scsi//device_handler/scsi_dh_rdac.c:237:13: warning: 'send_mode_select' used but never defined
    static void send_mode_select(struct work_struct *work);
                ^~~~~~~~~~~~~~~~
   drivers/scsi//device_handler/scsi_dh_rdac.c:527:13: warning: 'send_mode_select' defined but not used [-Wunused-function]
    static void send_mode_select(struct work_struct *work)
                ^~~~~~~~~~~~~~~~

vim +/initialize_controller +437 drivers/scsi/device_handler/scsi_dh_rdac.c

fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  436  
ca9f0089867c9e Hannes Reinecke     2008-07-17 @437  static int initialize_controller(struct scsi_device *sdev,
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  438  		struct rdac_dh_data *h, char *array_name, u8 *array_id)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  439  {
3278255741326b Hannes Reinecke     2016-11-03  440  	int err = SCSI_DH_IO, index;
3278255741326b Hannes Reinecke     2016-11-03  441  	struct c4_inquiry *inqp = &h->inq.c4;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  442  
3278255741326b Hannes Reinecke     2016-11-03  443  	if (!scsi_get_vpd_page(sdev, 0xC4, (unsigned char *)inqp,
3278255741326b Hannes Reinecke     2016-11-03  444  			       sizeof(struct c4_inquiry))) {
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  445  		/* get the controller index */
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  446  		if (inqp->slot_id[1] == 0x31)
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  447  			index = 0;
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  448  		else
a53becc9a9dbe4 Chandra Seetharaman 2011-07-20  449  			index = 1;
3569e5374df66a Moger, Babu         2012-02-02  450  
3569e5374df66a Moger, Babu         2012-02-02  451  		spin_lock(&list_lock);
d6857595394f1f Chandra Seetharaman 2011-07-27  452  		h->ctlr = get_controller(index, array_name, array_id, sdev);
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  453  		if (!h->ctlr)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  454  			err = SCSI_DH_RES_TEMP_UNAVAIL;
1a5dc166cd8843 Hannes Reinecke     2016-03-03  455  		else {
1a5dc166cd8843 Hannes Reinecke     2016-03-03  456  			list_add_rcu(&h->node, &h->ctlr->dh_list);
1a5dc166cd8843 Hannes Reinecke     2016-03-03  457  			h->sdev = sdev;
1a5dc166cd8843 Hannes Reinecke     2016-03-03  458  		}
3569e5374df66a Moger, Babu         2012-02-02  459  		spin_unlock(&list_lock);
3278255741326b Hannes Reinecke     2016-11-03  460  		err = SCSI_DH_OK;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  461  	}
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  462  	return err;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  463  }
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  464  
ca9f0089867c9e Hannes Reinecke     2008-07-17 @465  static int set_mode_select(struct scsi_device *sdev, struct rdac_dh_data *h)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  466  {
3278255741326b Hannes Reinecke     2016-11-03  467  	int err = SCSI_DH_IO;
3278255741326b Hannes Reinecke     2016-11-03  468  	struct c2_inquiry *inqp = &h->inq.c2;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  469  
3278255741326b Hannes Reinecke     2016-11-03  470  	if (!scsi_get_vpd_page(sdev, 0xC2, (unsigned char *)inqp,
3278255741326b Hannes Reinecke     2016-11-03  471  			       sizeof(struct c2_inquiry))) {
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  472  		/*
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  473  		 * If more than MODE6_MAX_LUN luns are supported, use
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  474  		 * mode select 10
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  475  		 */
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  476  		if (inqp->max_lun_supported >= MODE6_MAX_LUN)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  477  			h->ctlr->use_ms10 = 1;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  478  		else
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  479  			h->ctlr->use_ms10 = 0;
3278255741326b Hannes Reinecke     2016-11-03  480  		err = SCSI_DH_OK;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  481  	}
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  482  	return err;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  483  }
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  484  
ca9f0089867c9e Hannes Reinecke     2008-07-17 @485  static int mode_select_handle_sense(struct scsi_device *sdev,
3278255741326b Hannes Reinecke     2016-11-03  486  				    struct scsi_sense_hdr *sense_hdr)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  487  {
3278255741326b Hannes Reinecke     2016-11-03  488  	int err = SCSI_DH_IO;
ee14c674e8fc57 Christoph Hellwig   2015-08-27  489  	struct rdac_dh_data *h = sdev->handler_data;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  490  
3278255741326b Hannes Reinecke     2016-11-03  491  	if (!scsi_sense_valid(sense_hdr))
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  492  		goto done;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  493  
3278255741326b Hannes Reinecke     2016-11-03  494  	switch (sense_hdr->sense_key) {
7687fb9209422d Chauhan, Vijay      2009-03-04  495  	case NO_SENSE:
7687fb9209422d Chauhan, Vijay      2009-03-04  496  	case ABORTED_COMMAND:
7687fb9209422d Chauhan, Vijay      2009-03-04  497  	case UNIT_ATTENTION:
7687fb9209422d Chauhan, Vijay      2009-03-04  498  		err = SCSI_DH_RETRY;
7687fb9209422d Chauhan, Vijay      2009-03-04  499  		break;
7687fb9209422d Chauhan, Vijay      2009-03-04  500  	case NOT_READY:
3278255741326b Hannes Reinecke     2016-11-03  501  		if (sense_hdr->asc == 0x04 && sense_hdr->ascq == 0x01)
7687fb9209422d Chauhan, Vijay      2009-03-04  502  			/* LUN Not Ready and is in the Process of Becoming
7687fb9209422d Chauhan, Vijay      2009-03-04  503  			 * Ready
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  504  			 */
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  505  			err = SCSI_DH_RETRY;
7687fb9209422d Chauhan, Vijay      2009-03-04  506  		break;
7687fb9209422d Chauhan, Vijay      2009-03-04  507  	case ILLEGAL_REQUEST:
3278255741326b Hannes Reinecke     2016-11-03  508  		if (sense_hdr->asc == 0x91 && sense_hdr->ascq == 0x36)
7687fb9209422d Chauhan, Vijay      2009-03-04  509  			/*
7687fb9209422d Chauhan, Vijay      2009-03-04  510  			 * Command Lock contention
7687fb9209422d Chauhan, Vijay      2009-03-04  511  			 */
d2d06d4fe0f2cc Hannes Reinecke     2016-01-22  512  			err = SCSI_DH_IMM_RETRY;
7687fb9209422d Chauhan, Vijay      2009-03-04  513  		break;
7687fb9209422d Chauhan, Vijay      2009-03-04  514  	default:
dd784edcfc080f Moger, Babu         2009-09-03  515  		break;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  516  	}
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  517  
dd784edcfc080f Moger, Babu         2009-09-03  518  	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
dd784edcfc080f Moger, Babu         2009-09-03  519  		"MODE_SELECT returned with sense %02x/%02x/%02x",
dd784edcfc080f Moger, Babu         2009-09-03  520  		(char *) h->ctlr->array_name, h->ctlr->index,
3278255741326b Hannes Reinecke     2016-11-03  521  		sense_hdr->sense_key, sense_hdr->asc, sense_hdr->ascq);
dd784edcfc080f Moger, Babu         2009-09-03  522  
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  523  done:
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  524  	return err;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  525  }
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  526  
970f3f47e7c97c Chandra Seetharaman 2009-10-21 @527  static void send_mode_select(struct work_struct *work)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  528  {
970f3f47e7c97c Chandra Seetharaman 2009-10-21  529  	struct rdac_controller *ctlr =
970f3f47e7c97c Chandra Seetharaman 2009-10-21  530  		container_of(work, struct rdac_controller, ms_work);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  531  	struct scsi_device *sdev = ctlr->ms_sdev;
ee14c674e8fc57 Christoph Hellwig   2015-08-27  532  	struct rdac_dh_data *h = sdev->handler_data;
3278255741326b Hannes Reinecke     2016-11-03  533  	int err = SCSI_DH_OK, retry_cnt = RDAC_RETRY_COUNT;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  534  	struct rdac_queue_data *tmp, *qdata;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  535  	LIST_HEAD(list);
92eb506262a2a3 Stephen Kitt        2018-03-09  536  	unsigned char cdb[MAX_COMMAND_SIZE];
3278255741326b Hannes Reinecke     2016-11-03  537  	struct scsi_sense_hdr sshdr;
3278255741326b Hannes Reinecke     2016-11-03  538  	unsigned int data_size;
3278255741326b Hannes Reinecke     2016-11-03  539  	u64 req_flags = REQ_FAILFAST_DEV | REQ_FAILFAST_TRANSPORT |
3278255741326b Hannes Reinecke     2016-11-03  540  		REQ_FAILFAST_DRIVER;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  541  
970f3f47e7c97c Chandra Seetharaman 2009-10-21  542  	spin_lock(&ctlr->ms_lock);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  543  	list_splice_init(&ctlr->ms_head, &list);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  544  	ctlr->ms_queued = 0;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  545  	ctlr->ms_sdev = NULL;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  546  	spin_unlock(&ctlr->ms_lock);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  547  
c85f8cb9254e60 Chandra Seetharaman 2008-11-05  548   retry:
57adf5d4cfd319 Martin Wilck        2019-09-04  549  	memset(cdb, 0, sizeof(cdb));
57adf5d4cfd319 Martin Wilck        2019-09-04  550  
3278255741326b Hannes Reinecke     2016-11-03  551  	data_size = rdac_failover_get(ctlr, &list, cdb);
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  552  
dd784edcfc080f Moger, Babu         2009-09-03  553  	RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
dd784edcfc080f Moger, Babu         2009-09-03  554  		"%s MODE_SELECT command",
dd784edcfc080f Moger, Babu         2009-09-03  555  		(char *) h->ctlr->array_name, h->ctlr->index,
c85f8cb9254e60 Chandra Seetharaman 2008-11-05  556  		(retry_cnt == RDAC_RETRY_COUNT) ? "queueing" : "retrying");
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  557  
fcbfffe2c5cbec Christoph Hellwig   2017-02-23  558  	if (scsi_execute(sdev, cdb, DMA_TO_DEVICE, &h->ctlr->mode_select,
fcbfffe2c5cbec Christoph Hellwig   2017-02-23  559  			data_size, NULL, &sshdr, RDAC_TIMEOUT * HZ,
fcbfffe2c5cbec Christoph Hellwig   2017-02-23  560  			RDAC_RETRIES, req_flags, 0, NULL)) {
3278255741326b Hannes Reinecke     2016-11-03  561  		err = mode_select_handle_sense(sdev, &sshdr);
c85f8cb9254e60 Chandra Seetharaman 2008-11-05  562  		if (err == SCSI_DH_RETRY && retry_cnt--)
c85f8cb9254e60 Chandra Seetharaman 2008-11-05  563  			goto retry;
d2d06d4fe0f2cc Hannes Reinecke     2016-01-22  564  		if (err == SCSI_DH_IMM_RETRY)
d2d06d4fe0f2cc Hannes Reinecke     2016-01-22  565  			goto retry;
c85f8cb9254e60 Chandra Seetharaman 2008-11-05  566  	}
dd784edcfc080f Moger, Babu         2009-09-03  567  	if (err == SCSI_DH_OK) {
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  568  		h->state = RDAC_STATE_ACTIVE;
dd784edcfc080f Moger, Babu         2009-09-03  569  		RDAC_LOG(RDAC_LOG_FAILOVER, sdev, "array %s, ctlr %d, "
dd784edcfc080f Moger, Babu         2009-09-03  570  				"MODE_SELECT completed",
dd784edcfc080f Moger, Babu         2009-09-03  571  				(char *) h->ctlr->array_name, h->ctlr->index);
dd784edcfc080f Moger, Babu         2009-09-03  572  	}
ca9f0089867c9e Hannes Reinecke     2008-07-17  573  
970f3f47e7c97c Chandra Seetharaman 2009-10-21  574  	list_for_each_entry_safe(qdata, tmp, &list, entry) {
970f3f47e7c97c Chandra Seetharaman 2009-10-21  575  		list_del(&qdata->entry);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  576  		if (err == SCSI_DH_OK)
970f3f47e7c97c Chandra Seetharaman 2009-10-21  577  			qdata->h->state = RDAC_STATE_ACTIVE;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  578  		if (qdata->callback_fn)
970f3f47e7c97c Chandra Seetharaman 2009-10-21  579  			qdata->callback_fn(qdata->callback_data, err);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  580  		kfree(qdata);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  581  	}
970f3f47e7c97c Chandra Seetharaman 2009-10-21  582  	return;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  583  }
970f3f47e7c97c Chandra Seetharaman 2009-10-21  584  
970f3f47e7c97c Chandra Seetharaman 2009-10-21 @585  static int queue_mode_select(struct scsi_device *sdev,
970f3f47e7c97c Chandra Seetharaman 2009-10-21  586  				activate_complete fn, void *data)
970f3f47e7c97c Chandra Seetharaman 2009-10-21  587  {
970f3f47e7c97c Chandra Seetharaman 2009-10-21  588  	struct rdac_queue_data *qdata;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  589  	struct rdac_controller *ctlr;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  590  
970f3f47e7c97c Chandra Seetharaman 2009-10-21  591  	qdata = kzalloc(sizeof(*qdata), GFP_KERNEL);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  592  	if (!qdata)
970f3f47e7c97c Chandra Seetharaman 2009-10-21  593  		return SCSI_DH_RETRY;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  594  
ee14c674e8fc57 Christoph Hellwig   2015-08-27  595  	qdata->h = sdev->handler_data;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  596  	qdata->callback_fn = fn;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  597  	qdata->callback_data = data;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  598  
970f3f47e7c97c Chandra Seetharaman 2009-10-21  599  	ctlr = qdata->h->ctlr;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  600  	spin_lock(&ctlr->ms_lock);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  601  	list_add_tail(&qdata->entry, &ctlr->ms_head);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  602  	if (!ctlr->ms_queued) {
970f3f47e7c97c Chandra Seetharaman 2009-10-21  603  		ctlr->ms_queued = 1;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  604  		ctlr->ms_sdev = sdev;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  605  		queue_work(kmpath_rdacd, &ctlr->ms_work);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  606  	}
970f3f47e7c97c Chandra Seetharaman 2009-10-21  607  	spin_unlock(&ctlr->ms_lock);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  608  	return SCSI_DH_OK;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  609  }
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  610  
3ae31f6a7b6e44 Chandra Seetharaman 2009-10-21 @611  static int rdac_activate(struct scsi_device *sdev,
3ae31f6a7b6e44 Chandra Seetharaman 2009-10-21  612  			activate_complete fn, void *data)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  613  {
ee14c674e8fc57 Christoph Hellwig   2015-08-27  614  	struct rdac_dh_data *h = sdev->handler_data;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  615  	int err = SCSI_DH_OK;
3425fbfe229324 Moger, Babu         2011-04-08  616  	int act = 0;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  617  
ca9f0089867c9e Hannes Reinecke     2008-07-17  618  	err = check_ownership(sdev, h);
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  619  	if (err != SCSI_DH_OK)
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  620  		goto done;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  621  
3425fbfe229324 Moger, Babu         2011-04-08  622  	switch (h->mode) {
3425fbfe229324 Moger, Babu         2011-04-08  623  	case RDAC_MODE:
3425fbfe229324 Moger, Babu         2011-04-08  624  		if (h->lun_state == RDAC_LUN_UNOWNED)
3425fbfe229324 Moger, Babu         2011-04-08  625  			act = 1;
3425fbfe229324 Moger, Babu         2011-04-08  626  		break;
3425fbfe229324 Moger, Babu         2011-04-08  627  	case RDAC_MODE_IOSHIP:
3425fbfe229324 Moger, Babu         2011-04-08  628  		if ((h->lun_state == RDAC_LUN_UNOWNED) &&
3425fbfe229324 Moger, Babu         2011-04-08  629  		    (h->preferred == RDAC_PREFERRED))
3425fbfe229324 Moger, Babu         2011-04-08  630  			act = 1;
3425fbfe229324 Moger, Babu         2011-04-08  631  		break;
3425fbfe229324 Moger, Babu         2011-04-08  632  	default:
3425fbfe229324 Moger, Babu         2011-04-08  633  		break;
3425fbfe229324 Moger, Babu         2011-04-08  634  	}
3425fbfe229324 Moger, Babu         2011-04-08  635  
3425fbfe229324 Moger, Babu         2011-04-08  636  	if (act) {
970f3f47e7c97c Chandra Seetharaman 2009-10-21  637  		err = queue_mode_select(sdev, fn, data);
970f3f47e7c97c Chandra Seetharaman 2009-10-21  638  		if (err == SCSI_DH_OK)
970f3f47e7c97c Chandra Seetharaman 2009-10-21  639  			return 0;
970f3f47e7c97c Chandra Seetharaman 2009-10-21  640  	}
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  641  done:
3ae31f6a7b6e44 Chandra Seetharaman 2009-10-21  642  	if (fn)
3ae31f6a7b6e44 Chandra Seetharaman 2009-10-21  643  		fn(data, err);
3ae31f6a7b6e44 Chandra Seetharaman 2009-10-21  644  	return 0;
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  645  }
fbd7ab3eb53a3b Chandra Seetharaman 2008-05-01  646  

:::::: The code at line 437 was first introduced by commit
:::::: ca9f0089867c9e476cf2e6d4615d2aae887171b2 [SCSI] scsi_dh: Update RDAC device handler

:::::: TO: Hannes Reinecke <hare@suse.de>
:::::: CC: James Bottomley <James.Bottomley@HansenPartnership.com>

---
0-DAY kernel test infrastructure                 Open Source Technology Center
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org Intel Corporation

--6cp4vxtngoqur52j
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
WXEE/wXjKb16tg8DAA==

--6cp4vxtngoqur52j--
