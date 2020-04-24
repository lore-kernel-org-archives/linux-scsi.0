Return-Path: <SRS0=qHBX=6I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BDB4BC54FCB
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:22:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A83452084D
	for <linux-scsi@archiver.kernel.org>; Fri, 24 Apr 2020 15:22:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728229AbgDXPWE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 24 Apr 2020 11:22:04 -0400
Received: from mga05.intel.com ([192.55.52.43]:52933 "EHLO mga05.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726959AbgDXPWD (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 24 Apr 2020 11:22:03 -0400
IronPort-SDR: hRYIqthK7STcSv5oC1vqwBGFRp7DHapUjqQHzxOTijRp3TfQFeIcdzW6EMDM37gWLAWT5MxQqo
 KTl/2nyctGNw==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 24 Apr 2020 08:22:01 -0700
IronPort-SDR: TmPNE4EMPfhvkQGBrEi+m0l0C29TKQGySNXdd87zpFW+3YBhlUPQ7ZufzGhJhkArnIy2RdKNH4
 /QMFQa511fsw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,311,1583222400"; 
   d="scan'208";a="457936938"
Received: from lkp-server01.sh.intel.com (HELO lkp-server01) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 24 Apr 2020 08:21:59 -0700
Received: from kbuild by lkp-server01 with local (Exim 4.89)
        (envelope-from <lkp@intel.com>)
        id 1jS09P-0003an-Bf; Fri, 24 Apr 2020 23:21:59 +0800
Date:   Fri, 24 Apr 2020 23:21:15 +0800
From:   kbuild test robot <lkp@intel.com>
To:     Douglas Gilbert <dgilbert@interlog.com>, linux-scsi@vger.kernel.org
Cc:     kbuild-all@lists.01.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de
Subject: Re: [PATCH v9 25/40] sg: replace rq array with lists
Message-ID: <202004242322.LN5S78ti%lkp@intel.com>
References: <20200421215258.14348-26-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200421215258.14348-26-dgilbert@interlog.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Douglas,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[cannot apply to scsi/for-next linus/master v5.7-rc2 next-20200424]
[if your patch is applied to the wrong git tree, please drop us a note to help
improve the system. BTW, we also suggest to use '--base' option to specify the
base tree in git format-patch, please see https://stackoverflow.com/a/37406982]

url:    https://github.com/0day-ci/linux/commits/Douglas-Gilbert/sg-add-v4-interface/20200423-165610
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
reproduce:
        # apt-get install sparse
        # sparse version: v0.6.1-191-gc51a0382-dirty
        make ARCH=x86_64 allmodconfig
        make C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__'

If you fix the issue, kindly add following tag as appropriate
Reported-by: kbuild test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)

   /usr/lib/gcc/x86_64-linux-gnu/7/include/stddef.h:417:9: sparse: sparse: preprocessor token offsetof redefined
   include/linux/stddef.h:17:9: sparse: this was the original definition
>> drivers/scsi/sg.c:2889:20: sparse: sparse: incorrect type in initializer (different base types) @@    expected int gfp @@    got restricted gfp_t [usertyint gfp @@
>> drivers/scsi/sg.c:2889:20: sparse:    expected int gfp
>> drivers/scsi/sg.c:2889:20: sparse:    got restricted gfp_t [usertype]
>> drivers/scsi/sg.c:2892:51: sparse: sparse: restricted gfp_t degrades to integer
>> drivers/scsi/sg.c:2892:49: sparse: sparse: incorrect type in argument 2 (different base types) @@    expected restricted gfp_t [usertype] flags @@    got  [usertype] flags @@
>> drivers/scsi/sg.c:2892:49: sparse:    expected restricted gfp_t [usertype] flags
>> drivers/scsi/sg.c:2892:49: sparse:    got unsigned int
   drivers/scsi/sg.c:2894:51: sparse: sparse: restricted gfp_t degrades to integer
   drivers/scsi/sg.c:2894:49: sparse: sparse: incorrect type in argument 2 (different base types) @@    expected restricted gfp_t [usertype] flags @@    got  [usertype] flags @@
   drivers/scsi/sg.c:2894:49: sparse:    expected restricted gfp_t [usertype] flags
   drivers/scsi/sg.c:2894:49: sparse:    got unsigned int

vim +2889 drivers/scsi/sg.c

  2878	
  2879	/*
  2880	 * Makes a new sg_request object. If 'first' is set then use GFP_KERNEL which
  2881	 * may take time but has improved chance of success, otherwise use GFP_ATOMIC.
  2882	 * Note that basic initialization is done but srp is not added to either sfp
  2883	 * list. On error returns twisted negated errno value (not NULL).
  2884	 */
  2885	static struct sg_request *
  2886	sg_mk_srp(struct sg_fd *sfp, bool first)
  2887	{
  2888		struct sg_request *srp;
> 2889		int gfp =  __GFP_NOWARN;
  2890	
  2891		if (first)      /* prepared to wait if none already outstanding */
> 2892			srp = kzalloc(sizeof(*srp), gfp | GFP_KERNEL);
  2893		else
  2894			srp = kzalloc(sizeof(*srp), gfp | GFP_ATOMIC);
  2895		if (srp) {
  2896			atomic_set(&srp->rq_st, SG_RS_INACTIVE);
  2897			srp->parentfp = sfp;
  2898			return srp;
  2899		} else {
  2900			return ERR_PTR(-ENOMEM);
  2901		}
  2902	}
  2903	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
