Return-Path: <SRS0=iRB6=6A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48810C2BB85
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:06:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 2F15A2051A
	for <linux-scsi@archiver.kernel.org>; Thu, 16 Apr 2020 10:06:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2504669AbgDPKGB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 16 Apr 2020 06:06:01 -0400
Received: from mga02.intel.com ([134.134.136.20]:38870 "EHLO mga02.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2504378AbgDPKFy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 16 Apr 2020 06:05:54 -0400
IronPort-SDR: bzu0HXqmTP3+zqUhauTmrfsa9nt1lFXliZt+g1E3dCLfiV+ZCxJSjA1epdpmxEtxuxmnwjidTC
 +xbK+Vpcje3w==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:05:53 -0700
IronPort-SDR: RjBv+uX+qdBSawkGTFreimgV4amAPsx7yEe1IJ3aQIXgdP4x219JR8hl3o9eqO/hwoAVeQq9M9
 UXTLT5nwMsgA==
X-IronPort-AV: E=Sophos;i="5.72,390,1580803200"; 
   d="scan'208";a="427781153"
Received: from ellenfax-mobl2.ger.corp.intel.com (HELO localhost) ([10.249.44.122])
  by orsmga005-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Apr 2020 03:05:42 -0700
From:   Jani Nikula <jani.nikula@linux.intel.com>
To:     Jonathan Corbet <corbet@lwn.net>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Paul Mackerras <paulus@samba.org>,
        Madhuparna Bhowmik <madhuparnabhowmik04@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Ricardo Ribalda Delgado <ribalda@kernel.org>,
        Luca Ceresoli <luca@lucaceresoli.net>,
        dmaengine@vger.kernel.org, Matthias Maennich <maennich@google.com>,
        Harry Wei <harryxiyou@gmail.com>, x86@kernel.org,
        ecryptfs@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        target-devel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Hans Verkuil <hverkuil-cisco@xs4all.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Johannes Berg <johannes.berg@intel.com>,
        Jacopo Mondi <jacopo@jmondi.org>,
        Tyler Hicks <code@tyhicks.com>, Vinod Koul <vkoul@kernel.org>,
        Alex Shi <alex.shi@linux.alibaba.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, linux-scsi@vger.kernel.org,
        Michael Ellerman <mpe@ellerman.id.au>, netdev@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linuxppc-dev@lists.ozlabs.org, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH v2 0/2] Don't generate thousands of new warnings when building docs
In-Reply-To: <20200320171020.78f045c5@lwn.net>
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
References: <cover.1584716446.git.mchehab+huawei@kernel.org> <20200320171020.78f045c5@lwn.net>
Date:   Thu, 16 Apr 2020 13:05:39 +0300
Message-ID: <87a73b4ufg.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 20 Mar 2020, Jonathan Corbet <corbet@lwn.net> wrote:
> On Fri, 20 Mar 2020 16:11:01 +0100
> Mauro Carvalho Chehab <mchehab+huawei@kernel.org> wrote:
>
>> This small series address a regression caused by a new patch at
>> docs-next (and at linux-next).
>
> I don't know how I missed that mess, sorry.  I plead distracting times or
> something like that.  Heck, I think I'll blame everything on the plague
> for at least the next few weeks.
>
> Anyway, I've applied this, thanks for cleaning it up.

There's still more fallout from the autosectionlabel extension
introduced in 58ad30cf91f0 ("docs: fix reference to
core-api/namespaces.rst"), e.g. in i915.rst.

The biggest trouble is, if you have headings in kernel-doc comments,
Sphinx is unable pinpoint where the dupes are. For example:

 Documentation/gpu/i915.rst:610: WARNING: duplicate label gpu/i915:layout, other instance in
 Documentation/gpu/i915.rst

However there is no "layout" label in i915.rst. The one being warned
about I can dig into based on the line number, but not the second
one. You have to resort to grepping the source. And avoiding duplicate
subsection headings in completely isolated places is a minefield.

BR,
Jani.


-- 
Jani Nikula, Intel Open Source Graphics Center
