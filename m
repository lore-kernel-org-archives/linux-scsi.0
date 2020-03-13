Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9DE26C2BB1D
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 16:33:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7F88C206E7
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 16:33:32 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbgCMQdb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 12:33:31 -0400
Received: from mga02.intel.com ([134.134.136.20]:45298 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726406AbgCMQdb (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 12:33:31 -0400
X-Amp-Result: UNKNOWN
X-Amp-Original-Verdict: FILE UNKNOWN
X-Amp-File-Uploaded: False
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga101.jf.intel.com with ESMTP/TLS/DHE-RSA-AES256-GCM-SHA384; 13 Mar 2020 09:33:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.70,549,1574150400"; 
   d="scan'208";a="235370978"
Received: from smile.fi.intel.com (HELO smile) ([10.237.68.40])
  by fmsmga007.fm.intel.com with ESMTP; 13 Mar 2020 09:33:27 -0700
Received: from andy by smile with local (Exim 4.93)
        (envelope-from <andriy.shevchenko@linux.intel.com>)
        id 1jCnFY-009Iu7-V1; Fri, 13 Mar 2020 18:33:28 +0200
Date:   Fri, 13 Mar 2020 18:33:28 +0200
From:   Andy Shevchenko <andriy.shevchenko@linux.intel.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Keith Busch <kbusch@kernel.org>,
        Sagi Grimberg <sagi@grimberg.me>, Jens Axboe <axboe@fb.com>,
        Felipe Balbi <balbi@kernel.org>,
        Harvey Harrison <harvey.harrison@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H . Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v2 3/5] treewide: Consolidate
 {get,put}_unaligned_[bl]e24() definitions
Message-ID: <20200313163328.GY1922688@smile.fi.intel.com>
References: <20200313023718.21830-1-bvanassche@acm.org>
 <20200313023718.21830-4-bvanassche@acm.org>
 <20200313091537.GQ1922688@smile.fi.intel.com>
 <615a0134-26ab-6591-632f-bf85d26ed60b@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <615a0134-26ab-6591-632f-bf85d26ed60b@acm.org>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Mar 13, 2020 at 07:54:49AM -0700, Bart Van Assche wrote:
> On 2020-03-13 02:15, Andy Shevchenko wrote:
> > On Thu, Mar 12, 2020 at 07:37:16PM -0700, Bart Van Assche wrote:
> >> +static inline void __put_unaligned_be24(u32 val, u8 *p)
> > 
> > 	const u32 val
> 
> Hi Andy,
> 
> Thanks for the review. The above suggestion surprises me: as far as I
> can tell almost nobody declares function arguments that are passed by
> value as 'const' in the Linux kernel:
> 
> $ git grep -nH '(const[^\*,]*,' | wc -l
>    1065
> 
> That number is negligible compared to the number of function declarations:
> 
> $ git grep -nH '(.*);$' | wc -l
> 2692721

It's a surprising "argument".
If 100500 do worse it doesn't mean 3000 shouldn't do it better.
And of course first grep is incomplete and second one too broad.

Just for (generic) headers:

$ git grep -n '[a-z_0-9]([^)]*\bconst [^)]\+)' -- include | wc -l
4342

$ git grep -n '[a-z_0-9]([^)]\+)' -- include | wc -l
69672

~6% in headers. I don't think it's negligible.

You have at least two advantages on this:
a) we really don't modify the content of the input value;
b) it will be consistent with the rest of consolidated helpers.

-- 
With Best Regards,
Andy Shevchenko


