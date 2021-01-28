Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.7 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 46C8EC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 20:30:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E76AC6146D
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Jan 2021 20:29:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229817AbhA1U3n (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Jan 2021 15:29:43 -0500
Received: from mx2.suse.de ([195.135.220.15]:57958 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229595AbhA1U3j (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Jan 2021 15:29:39 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id A88D5B130;
        Thu, 28 Jan 2021 20:28:57 +0000 (UTC)
Date:   Thu, 28 Jan 2021 21:28:56 +0100
From:   David Disseldorp <ddiss@suse.de>
To:     Roman Bolshakov <r.bolshakov@yadro.com>
Cc:     Dmitry Bogdanov <d.bogdanov@yadro.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>
Subject: Re: [PATCH v2] scsi: target: core: check SR field in REPORT LUNS
Message-ID: <20210128212856.1f1117e6@suse.de>
In-Reply-To: <YA/dSDH2NYSRi9Bi@SPB-NB-133.local>
References: <20210120102700.5514-1-d.bogdanov@yadro.com>
        <20210122234251.595d5b7a@suse.de>
        <YA/dSDH2NYSRi9Bi@SPB-NB-133.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Roman,

On Tue, 26 Jan 2021 12:13:44 +0300, Roman Bolshakov wrote:

> Hi David,
> 
> SELECT REPORT field can be used for vVOL (LU conglomerate) discovery and
> for well-known lun listing.
> 
> The field is used by VMware ESXi:
> https://support.purestorage.com/Solutions/VMware_Platform_Guide/User_Guides_for_VMware_Solutions/Virtual_Volumes_User_Guide/vVols_User_Guide%3A_Protocol_Endpoints
> 
> "PEs greatly extend the number of vVols that can be connected to an ESXi
> cluster; each PE can have up to 16,383 vVols per host bound to it
> simultaneously. Moreover, a new binding does not require a complete I/O
> rescan. Instead, ESXi issues a REPORT_LUNS SCSI command with SELECT
> REPORT to the PE to which the sub-lun is bound. The PE returns a list of
> sub-lun IDs for the vVols bound to that host. In large clusters,
> REPORT_LUNS is significantly faster than a full I/O rescan because it is
> more precisely targeted."

Interesting, thanks.

...
> With regards to bumping TCM to SPC-4, are there any objections if we
> submit a separate patch for that? Or resubmit a series with the patch?

I don't object to that. FWIW, the following crude metrics could be seen
as an argument in favour of SPC-4 versioning:
  linux> git grep -ic -e "SPC4" -e "SPC-4" -- drivers/target/
  drivers/target/target_core_alua.c:7
  drivers/target/target_core_alua.h:5
  drivers/target/target_core_device.c:1
  drivers/target/target_core_fabric_lib.c:5
  drivers/target/target_core_pr.c:37
  drivers/target/target_core_spc.c:19
  drivers/target/target_core_tmr.c:3
  drivers/target/target_core_transport.c:2
  drivers/target/target_core_ua.c:1
  drivers/target/target_core_ua.h:1
  drivers/target/target_core_xcopy.c:3
  drivers/target/target_core_xcopy.h:1
  linux> git grep -ic -e "SPC3" -e "SPC-3" -- drivers/target/
  drivers/target/target_core_alua.c:1
  drivers/target/target_core_configfs.c:14
  drivers/target/target_core_pr.c:75
  drivers/target/target_core_spc.c:4
  drivers/target/target_core_tmr.c:1
  drivers/target/target_core_transport.c:4
  drivers/target/target_core_ua.c:1

Most of the SPC3 target_core_pr and target_core_configfs matches above
are debug/error messages, rather than spec references.

Cheers, David
