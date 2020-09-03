Return-Path: <SRS0=xo/b=CM=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.0 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 88E67C2D0E4
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 20:54:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74C23206EB
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Sep 2020 20:54:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgICUy1 convert rfc822-to-8bit (ORCPT
        <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Sep 2020 16:54:27 -0400
Received: from mx2.suse.de ([195.135.220.15]:50268 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726088AbgICUy1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 3 Sep 2020 16:54:27 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 5C36EAB7D;
        Thu,  3 Sep 2020 20:54:26 +0000 (UTC)
Date:   Thu, 3 Sep 2020 22:54:24 +0200
From:   David Disseldorp <ddiss@suse.de>
To:     Michael Christie <michael.christie@oracle.com>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [RFC PATCH] scsi: target: detect XCOPY NAA descriptor conflicts
Message-ID: <20200903225424.331f1d94@suse.de>
In-Reply-To: <7F596A9A-2116-4BA8-8A32-E98EDE996D8C@oracle.com>
References: <20200813002142.13820-1-ddiss@suse.de>
        <2155E745-0E65-441B-93AF-7B4C0A53F5F4@oracle.com>
        <20200903002336.083e88a4@suse.de>
        <7F596A9A-2116-4BA8-8A32-E98EDE996D8C@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 3 Sep 2020 10:36:58 -0500, Michael Christie wrote:

> > On Sep 2, 2020, at 5:23 PM, David Disseldorp <ddiss@suse.de> wrote:
> > 
> > Hi Mike,
> > 
> > On Tue, 1 Sep 2020 22:17:51 -0500, Michael Christie wrote:
> >   
> >>> --- a/drivers/target/target_core_xcopy.c
> >>> +++ b/drivers/target/target_core_xcopy.c
> >>> @@ -68,8 +68,14 @@ static int target_xcopy_locate_se_dev_e4_iter(struct se_device *se_dev,
> >>> 	if (rc != 0)
> >>> 		return 0;
> >>> 
> >>> -	info->found_dev = se_dev;
> >>> 	pr_debug("XCOPY 0xe4: located se_dev: %p\n", se_dev);
> >>> +	if (info->found_dev) {
> >>> +		pr_warn("XCOPY 0xe4 descriptor conflict for se_dev %p and %p\n",
> >>> +			info->found_dev, se_dev);
> >>> +		target_undepend_item(&info->found_dev->dev_group.cg_item);
> >>> +		return -ENOTUNIQ;
> >>> +	}
> >>> +	info->found_dev = se_dev;    
> >> 
> >> Was it valid to copy to/from the same LUN? You would copy from/to different src/destinations on that LUN. Would your patch break that?  
> > 
> > XCOPY allows for copies to occur on the same LUN or between separate
> > src/destinations. The intention of this patch is that regardless of the
> > source or destination, if the NAA WWN could refer to multiple LUNs on
> > the same target (via target_for_each_device()) then the XCOPY should
> > fail and force the initiator to fallback to initiator driver copy.  
> 
> So is the answer to my question a maybe but it probably will never happen?

A src=dest XCOPY? I think it's just as likely as a cross device XCOPY.
The UUID collision error is probably unlikely to be triggered because:
- XCOPY is a pretty exotic SCSI command mostly used by ESXi
- Users may already provide a vpd_unit_serial with enough unique
  hexadecimal characters(?)
- The initiator could detect the NAA WWN collision itself by comparing
  the INQUIRY(dev-id)->NAA between other LUNs on the target, and thereby
  detect+avoid sending XCOPY requests with ambiguous src/dest WWNs

> If the user has multiple backend devices with the same serial, then your patch would now return error right?

Yes, XCOPY will now fail if the src or dest NAA WWN matches more than
one se_dev. Keep in mind that the NAA WWN is derived from only the
hexadecimal characters of the vpd_unit_serial (see
spc_parse_naa_6h_vendor_specific), so collision might be more likely.

> Is the reason that this patch is a RFC to try and figure out if that case is valid or ever happens? If so, the only way I could see that happening on purpose is if someone was trying to bypass a device issue.

Sorry, I should have mode this more clear in the patch itself. The
reasons for RFC are:
- there might be a better approach. I considered detecting NAA WWN
  collisions when the vpd_unit_serial is set via configfs. Throwing a
  configfs error might break existing setups, rather than just
  triggering the XCOPY error (allowing for subsequent READ/WRITE
  fallback).
- I've tested this with libiscsi's iscsi-dd (-x) and test suite, but not
  against the ESXi initiator yet.

> For example, I create 2 tcmu devices. They both point to the same real device. Then export dev1 through target port1 and dev2 through target port2. Each tcmu device would then have it’s own data/cmd ring and locking, so you do not hit those perf issues. I do this for perf testing. I don’t think that type of thing is common or ever done, so I think the patch would be ok if that is a concern and it’s better than possible data corruption.
> 
> Code wise it looks ok to me.

Thanks a lot for the feedback, Mike.

Cheers, David
