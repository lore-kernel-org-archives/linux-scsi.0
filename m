Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 02C8BC4338F
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:08:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0C5860F11
	for <linux-scsi@archiver.kernel.org>; Fri, 20 Aug 2021 18:08:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236070AbhHTSJ3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 20 Aug 2021 14:09:29 -0400
Received: from mga12.intel.com ([192.55.52.136]:63668 "EHLO mga12.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236021AbhHTSJZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 20 Aug 2021 14:09:25 -0400
X-IronPort-AV: E=McAfee;i="6200,9189,10082"; a="196396976"
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="gz'50?scan'50,208,50";a="196396976"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Aug 2021 11:08:46 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.84,338,1620716400"; 
   d="gz'50?scan'50,208,50";a="680366339"
Received: from lkp-server01.sh.intel.com (HELO d053b881505b) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 20 Aug 2021 11:08:43 -0700
Received: from kbuild by d053b881505b with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1mH8wd-000V5K-5A; Fri, 20 Aug 2021 18:08:43 +0000
Date:   Sat, 21 Aug 2021 02:07:44 +0800
From:   kernel test robot <lkp@intel.com>
To:     CGEL <cgel.zte@gmail.com>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Cc:     kbuild-all@lists.01.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        jing yangyang <jing.yangyang@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: Re: [PATCH linux-next] scsi/ncr53c8xx: Use bitwise instead of
 arithmetic operator for flags
Message-ID: <202108210143.H7kfGMOL-lkp@intel.com>
References: <20210820031235.12535-1-jing.yangyang@zte.com.cn>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="G4iJoqBmSsgzjUCe"
Content-Disposition: inline
In-Reply-To: <20210820031235.12535-1-jing.yangyang@zte.com.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


--G4iJoqBmSsgzjUCe
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi CGEL,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on next-20210819]

url:    https://github.com/0day-ci/linux/commits/CGEL/scsi-ncr53c8xx-Use-bitwise-instead-of-arithmetic-operator-for-flags/20210820-111510
base:    33e65b1f975cd2814fc0ea9617250fc4c1d7a553
config: parisc-defconfig (attached as .config)
compiler: hppa-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/1c952d92c3d9f7e1609d3770e0c9194fdcf05603
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review CGEL/scsi-ncr53c8xx-Use-bitwise-instead-of-arithmetic-operator-for-flags/20210820-111510
        git checkout 1c952d92c3d9f7e1609d3770e0c9194fdcf05603
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross ARCH=parisc 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/scsi/ncr53c8xx.c: In function 'ncr_getclock':
>> drivers/scsi/ncr53c8xx.c:7913:53: warning: suggest parentheses around comparison in operand of '|' [-Wparentheses]
    7913 |         if (mult > 1 && (stest1 & (DBLEN | DBLSEL)) == DBLEN | DBLSEL) {


vim +7913 drivers/scsi/ncr53c8xx.c

  7897	
  7898	/*
  7899	 *	Get/probe NCR SCSI clock frequency
  7900	 */
  7901	static void __init ncr_getclock (struct ncb *np, int mult)
  7902	{
  7903		unsigned char scntl3 = INB(nc_scntl3);
  7904		unsigned char stest1 = INB(nc_stest1);
  7905		unsigned f1;
  7906	
  7907		np->multiplier = 1;
  7908		f1 = 40000;
  7909	
  7910		/*
  7911		**	True with 875 or 895 with clock multiplier selected
  7912		*/
> 7913		if (mult > 1 && (stest1 & (DBLEN | DBLSEL)) == DBLEN | DBLSEL) {
  7914			if (bootverbose >= 2)
  7915				printk ("%s: clock multiplier found\n", ncr_name(np));
  7916			np->multiplier = mult;
  7917		}
  7918	
  7919		/*
  7920		**	If multiplier not found or scntl3 not 7,5,3,
  7921		**	reset chip and get frequency from general purpose timer.
  7922		**	Otherwise trust scntl3 BIOS setting.
  7923		*/
  7924		if (np->multiplier != mult || (scntl3 & 7) < 3 || !(scntl3 & 1)) {
  7925			unsigned f2;
  7926	
  7927			ncr_chip_reset(np, 5);
  7928	
  7929			(void) ncrgetfreq (np, 11);	/* throw away first result */
  7930			f1 = ncrgetfreq (np, 11);
  7931			f2 = ncrgetfreq (np, 11);
  7932	
  7933			if(bootverbose)
  7934				printk ("%s: NCR clock is %uKHz, %uKHz\n", ncr_name(np), f1, f2);
  7935	
  7936			if (f1 > f2) f1 = f2;		/* trust lower result	*/
  7937	
  7938			if	(f1 <	45000)		f1 =  40000;
  7939			else if (f1 <	55000)		f1 =  50000;
  7940			else				f1 =  80000;
  7941	
  7942			if (f1 < 80000 && mult > 1) {
  7943				if (bootverbose >= 2)
  7944					printk ("%s: clock multiplier assumed\n", ncr_name(np));
  7945				np->multiplier	= mult;
  7946			}
  7947		} else {
  7948			if	((scntl3 & 7) == 3)	f1 =  40000;
  7949			else if	((scntl3 & 7) == 5)	f1 =  80000;
  7950			else 				f1 = 160000;
  7951	
  7952			f1 /= np->multiplier;
  7953		}
  7954	
  7955		/*
  7956		**	Compute controller synchronous parameters.
  7957		*/
  7958		f1		*= np->multiplier;
  7959		np->clock_khz	= f1;
  7960	}
  7961	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--G4iJoqBmSsgzjUCe
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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
vzEBAA==

--G4iJoqBmSsgzjUCe--
