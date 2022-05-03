Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6A88AC433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  3 May 2022 09:41:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233679AbiECJoq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 May 2022 05:44:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233664AbiECJoY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 May 2022 05:44:24 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14367326F4
        for <linux-scsi@vger.kernel.org>; Tue,  3 May 2022 02:40:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651570837; x=1683106837;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=P+iOAd44yQAu6dFiULlp+J/3lk1X57kR5DCW90siNJg=;
  b=gJvWDLUf3PbCWGlejBzAbc93AC948rmh4muSowqRhzpIMKRMrD60xhH2
   RpFSxZbW0PgODYwLaEcxqbLDhZ4JrzFBKZr8NndZQ5JIcWNf1Hdl5mywh
   8RCYTmdTsLUHh5L1Ta0dwSs5hW0RjTSAjDxr11DvlqNn9u9Wh/WCbaERJ
   Jm/dKxjxbUKqAqJkmadnfUM9M6Q7uvsf526e6zZKgk6XaqcGPeCTvftqk
   0siMJWs/VfIlraN/TQAXwORE3YnAEdCeFVhqE9fehlvZLcGIEDdbkXrjN
   iYGDWMFBnVVAdvKzaEJKDI5GwNITQcU9oDfE6dhggWIEbI5zxPlTLUp9W
   g==;
X-IronPort-AV: E=McAfee;i="6400,9594,10335"; a="353879349"
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="353879349"
Received: from fmsmga004.fm.intel.com ([10.253.24.48])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 May 2022 02:40:36 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,194,1647327600"; 
   d="scan'208";a="631449685"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by fmsmga004.fm.intel.com with ESMTP; 03 May 2022 02:40:34 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nlp1G-000ALL-9h;
        Tue, 03 May 2022 09:40:34 +0000
Date:   Tue, 3 May 2022 17:39:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 13/24] aic7xxx: make BUILD_SCSIID() a function
Message-ID: <202205031715.Eiw7By3c-lkp@intel.com>
References: <20220502213820.3187-14-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220502213820.3187-14-hare@suse.de>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Hannes,

I love your patch! Perhaps something to improve:

[auto build test WARNING on mkp-scsi/for-next]
[also build test WARNING on jejb-scsi/for-next powerpc/next linus/master v5.18-rc5 next-20220502]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Hannes-Reinecke/scsi-EH-rework-prep-patches-part-1/20220503-054317
base:   https://git.kernel.org/pub/scm/linux/kernel/git/mkp/scsi.git for-next
config: arm64-randconfig-r022-20220502 (https://download.01.org/0day-ci/archive/20220503/202205031715.Eiw7By3c-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 363b3a645a1e30011cc8da624f13dac5fd915628)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install arm64 cross compiling tool for clang build
        # apt-get install binutils-aarch64-linux-gnu
        # https://github.com/intel-lab-lkp/linux/commit/5436bc0a0e277a5742af0b7b443b4591ce0e5b74
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Hannes-Reinecke/scsi-EH-rework-prep-patches-part-1/20220503-054317
        git checkout 5436bc0a0e277a5742af0b7b443b4591ce0e5b74
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=arm64 SHELL=/bin/bash drivers/scsi/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/scsi/aic7xxx/aic7xxx_osm.c:808:24: warning: operator '?:' has lower precedence than '|'; '|' will be evaluated first [-Wbitwise-conditional-parentheses]
                   (sdev->channel == 0) ? 0 : TWIN_CHNLB;
                   ~~~~~~~~~~~~~~~~~~~~ ^
   drivers/scsi/aic7xxx/aic7xxx_osm.c:808:24: note: place parentheses around the '|' expression to silence this warning
                   (sdev->channel == 0) ? 0 : TWIN_CHNLB;
                                        ^
                                       )
   drivers/scsi/aic7xxx/aic7xxx_osm.c:808:24: note: place parentheses around the '?:' expression to evaluate it first
                   (sdev->channel == 0) ? 0 : TWIN_CHNLB;
                   ~~~~~~~~~~~~~~~~~~~~~^~~~~~~~~~~~~~~~
   1 warning generated.


vim +808 drivers/scsi/aic7xxx/aic7xxx_osm.c

   800	
   801	
   802	static inline unsigned int ahc_build_scsiid(struct ahc_softc *ahc,
   803						    struct scsi_device *sdev)
   804	{
   805		unsigned int scsiid =
   806			((sdev->id << TID_SHIFT) & TID) |
   807			((sdev->channel == 0) ? ahc->our_id : ahc->our_id_b) |
 > 808			(sdev->channel == 0) ? 0 : TWIN_CHNLB;
   809		return scsiid;
   810	}
   811	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
