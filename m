Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C84ECC433DB
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:34:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 78DBE64FAD
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Mar 2021 15:34:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233985AbhCKPdz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Mar 2021 10:33:55 -0500
Received: from mx2.suse.de ([195.135.220.15]:34498 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234096AbhCKPdW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Mar 2021 10:33:22 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8F481AC16;
        Thu, 11 Mar 2021 15:33:20 +0000 (UTC)
Subject: Re: [PATCH v8 00/16] blkcg:Support to track FC storage blk io traffic
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0a61914b-3a32-2982-623a-838f10351f47@suse.de>
Date:   Thu, 11 Mar 2021 16:33:19 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <1614835646-16217-1-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/21 6:27 AM, Muneendra wrote:
> This Patch added a unique application identifier i.e
> app_id  knob to  blkcg which allows identification of traffic
> sources at an individual cgroup based Applications
> (ex:virtual machine (VM))level in both host and
> fabric infrastructure.
> 
> Added a new sysfs attribute appid_store to set the application identfier
> in  the blkcg associted with cgroup id under
> /sys/class/fc/fc_udev_device/*
> 
> With this new interface the user can set the application identfier
> in  the blkcg associted with cgroup id.
> 
> This capability can be utilized by multiple block transport infrastructure
> like fc,iscsi,roce.
> 
> Existing FC fabric will use this feature and the description of
> the use case is below.
> 
> Various virtualization technologies used in Fibre Channel
> SAN deployments have created the opportunity to identify
> and associate traffic with specific virtualized applications.
> The concepts behind the T11 Application Services standard is
> to provide the general mechanisms needed to identify
> virtualized services.
> It enables the Fabric and the storage targets to
> identify, monitor, and handle FC traffic
> based on vm tags by inserting application specific identification
> into the FC frame.
> 
> The patches were cut against  5.12/scsi-queue tree
> 
> v8:
> Modified the structure member,log messages and function declarations
> Added proper error codes and return values
> 
> v7:
> Modified the Kconfig comments
> 
> v6:
> Addressed the issues reported by kernel test robot
> Modified the Kconfig files as per standard
> 
> v5:
> Renamed the function cgroup_get_from_kernfs_id to
> cgroup_get_from_id.
> 
> Moved the input validation at the beginning of the function in
> Renamed the arguments appropriatley.
> 
> Changed Return code to non-numeric/SymbolChanged Return code
> to non-numeric/Symbol
> 
> Modified the comments.
> 
> v4:
> Addressed the error reported by  kernel test robot
> 
> v3:
> removed RFC.
> 
> Renamed the functions and app_id to more specific
> Addressed the reference leaks in blkcg_set_app_identifier
> Added a new config BLK_CGROUP_FC_APPID and made changes to
> select the same under SCSI_FC_ATTRS
> 
> V2:
> renamed app_identifier to app_id.
> removed the  sysfs interface blkio.app_identifie under
> /sys/fs/cgroup/blkio
> Ported the patch on top of 5.10/scsi-queue.
> Removed redundant code due to changes since last submit.
> Added a fix for issuing QFPA command.
> 
> 
> 
> Gaurav Srivastava (12):
>    lpfc: vmid: Add the datastructure for supporting VMID in lpfc
>    lpfc: vmid: Supplementary data structures for vmid and APIs
>    lpfc: vmid: Forward declarations for APIs
>    lpfc: vmid: VMID params initialization
>    lpfc: vmid: Add support for vmid in mailbox command, does vmid
>      resource allocation and vmid cleanup
>    lpfc: vmid: Implements ELS commands for appid patch
>    lpfc: vmid: Functions to manage vmids
>    lpfc: vmid: Implements CT commands for appid.
>    lpfc: vmid: Appends the vmid in the wqe before sending
>    lpfc: vmid: Timeout implementation for vmid
>    lpfc: vmid: Adding qfpa and vmid timeout check in worker thread
>    lpfc: vmid: Introducing vmid in io path.
> 
> Muneendra (4):
>    cgroup: Added cgroup_get_from_id
>    blkcg: Added a app identifier support for blkcg
>    nvme: Added a newsysfs attribute appid_store
>    scsi: Made changes in Kconfig to select BLK_CGROUP_FC_APPID
> 
>   block/Kconfig                    |   9 +
>   drivers/nvme/host/fc.c           |  73 ++++++-
>   drivers/scsi/Kconfig             |  13 ++
>   drivers/scsi/lpfc/lpfc.h         | 121 ++++++++++
>   drivers/scsi/lpfc/lpfc_attr.c    |  47 ++++
>   drivers/scsi/lpfc/lpfc_crtn.h    |  11 +
>   drivers/scsi/lpfc/lpfc_ct.c      | 249 ++++++++++++++++++++-
>   drivers/scsi/lpfc/lpfc_disc.h    |   1 +
>   drivers/scsi/lpfc/lpfc_els.c     | 364 ++++++++++++++++++++++++++++++-
>   drivers/scsi/lpfc/lpfc_hbadisc.c | 153 +++++++++++++
>   drivers/scsi/lpfc/lpfc_hw.h      | 124 ++++++++++-
>   drivers/scsi/lpfc/lpfc_hw4.h     |  12 +
>   drivers/scsi/lpfc/lpfc_init.c    | 106 +++++++++
>   drivers/scsi/lpfc/lpfc_mbox.c    |   6 +
>   drivers/scsi/lpfc/lpfc_scsi.c    | 337 ++++++++++++++++++++++++++++
>   drivers/scsi/lpfc/lpfc_sli.c     |  63 ++++++
>   drivers/scsi/lpfc/lpfc_sli.h     |   8 +
>   include/linux/blk-cgroup.h       |  56 +++++
>   include/linux/cgroup.h           |   6 +
>   kernel/cgroup/cgroup.c           |  26 +++
>   20 files changed, 1775 insertions(+), 10 deletions(-)
> 
Hmm. Can you please include the existing 'Reviewed-by' tags?
It's getting really hard to figure out which patches I've already 
reviewed and which needs an additional review.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
