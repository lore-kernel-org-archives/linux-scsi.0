Return-Path: <SRS0=2e3T=ZN=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6295AC432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 06:42:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3EE102089D
	for <linux-scsi@archiver.kernel.org>; Thu, 21 Nov 2019 06:42:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbfKUGmw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 21 Nov 2019 01:42:52 -0500
Received: from mga09.intel.com ([134.134.136.24]:54407 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUGmw (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 21 Nov 2019 01:42:52 -0500
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga102.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 20 Nov 2019 22:42:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.69,224,1571727600"; 
   d="scan'208";a="238053494"
Received: from xsang-optiplex-9020.sh.intel.com (HELO xsang-OptiPlex-9020) ([10.239.159.135])
  by fmsmga002.fm.intel.com with ESMTP; 20 Nov 2019 22:42:49 -0800
Date:   Thu, 21 Nov 2019 14:50:00 +0800
From:   Oliver Sang <oliver.sang@intel.com>
To:     Ming Lei <ming.lei@redhat.com>, "Zhang, Rui" <rui.zhang@intel.com>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        James Bottomley <James.Bottomley@hansenpartnership.com>,
        Jens Axboe <axboe@kernel.dk>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Omar Sandoval <osandov@fb.com>, Christoph Hellwig <hch@lst.de>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Hannes Reinecke <hare@suse.de>,
        Laurence Oberman <loberman@redhat.com>,
        Bart Van Assche <bart.vanassche@wdc.com>, lkp@lists.01.org
Subject: Re: [scsi]  74eb6c22dc: suspend_stress.fail
Message-ID: <20191121065000.GA9619@xsang-OptiPlex-9020>
References: <20191008100945.24951-3-ming.lei@redhat.com>
 <20191104085021.GF13369@xsang-OptiPlex-9020>
 <20191116085443.GA24667@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191116085443.GA24667@ming.t460p>
User-Agent: Mutt/1.9.4 (2018-02-28)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 16, 2019 at 04:54:43PM +0800, Ming Lei wrote:
> Hello Oliver,
> 
> On Mon, Nov 04, 2019 at 04:50:21PM +0800, kernel test robot wrote:
> > FYI, we noticed the following commit (built with gcc-7):
> > 
> > commit: 74eb6c22dc70e395b333c9ca579855cd88db8845 ("[RFC PATCH V3 2/2] scsi: core: don't limit per-LUN queue depth for SSD")
> > url: https://github.com/0day-ci/linux/commits/Ming-Lei/scsi-core-avoid-host-wide-host_busy-counter-for-scsi_mq/20191009-015827
> > base: https://git.kernel.org/cgit/linux/kernel/git/jejb/scsi.git for-next
> > 
> > in testcase: suspend_stress
> > with following parameters:
> > 
> > 	mode: freeze
> > 	iterations: 10
> > 
> > 
> > 
> > on test machine: 4 threads Skylake with 8G memory
> > 
> > caused below changes (please refer to attached dmesg/kmsg for entire log/backtrace):
> > 
> > 
> > 
> > 
> > If you fix the issue, kindly add following tag
> > Reported-by: kernel test robot <oliver.sang@intel.com>
> > 
> > test started
> > 
> > (then just like hang)
> > (below is what looks like if test can pass
> > SUSPEND RESUME TEST STARTED
> > Suspend to freeze 1/10:
> > ...
> > Done
> > Sleep for 10 seconds
> > Suspend to freeze 2/10:
> > ...
> > Suspend to freeze 10/10:
> > ...
> > Sleep for 10 seconds
> > SUSPEND RESUME TEST SUCCESS)
> 
> From the dmesg via 'zcat kmsg.xz', looks there isn't any failure found.
> 'Suspend to freeze' has run successfully 10 times, and finally the
> message of 'SUSPEND RESUME TEST SUCCESS' does show in the log.
> 
> Could you double check if it is a valid report?

Hi Ming, sorry for confusion. this case didn't always fail in our tests, and unfortunately,
due to some code problem, the kmsg.xz attached in the original mail is from PASS test.
(In failed tests, we cannot generate the kmsg so far actually)

However, in our tests, the regression is clear, for parent commit, the test all passed,
for this commit, the tests are easy to fail.
69fdd747ae1fa088  74eb6c22dc70e395b333c9ca57  
----------------  --------------------------  
           :18          50%           9:18    suspend_stress.fail

@Rui also helped double confirm the regression by another power test - analyze_suspend, which
also shows this clear regression. Rui maybe could supply more information. Thanks!

> 
> Thanks,
> Ming
> 
