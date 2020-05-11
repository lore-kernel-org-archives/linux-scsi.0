Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E43C7C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:09:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B9FDD2080C
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 06:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728408AbgEKGJR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 02:09:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:44554 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725916AbgEKGJR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 11 May 2020 02:09:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id A2F4EAD6A;
        Mon, 11 May 2020 06:09:17 +0000 (UTC)
Subject: Re: [PATCH 02/15] target: separate acl name from port ids
To:     Mike Christie <mchristi@redhat.com>, bvanassche@acm.org,
        bstroesser@ts.fujitsu.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Cc:     "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Paolo Bonzini <pbonzini@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Juergen Gross <jgross@suse.com>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-3-mchristi@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6eced3be-7934-7492-f413-26f5fcf12f82@suse.de>
Date:   Mon, 11 May 2020 08:09:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200510215744.21999-3-mchristi@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/20 11:57 PM, Mike Christie wrote:
> The PGR code assumes the ACL name is going to be based on the SPC4
> transportID type of values. The problem is that for iSCSI we have an extra
> session id as part of the SCSI port id and some fabric modules support or
> would like to support non transportID values for the ACL name. For example,
> iSCSI and SRP would like to use the source address for the ACL name, but
> that is not a valud transportID value that you can get in a PGR request.
> 
> This patch adds a new transport_id struct which maps to the SPC4
> transportID. In the future it will be used for PGR commands instead of the
> ACL name. In this patchset it is used to export the initiator info in the
> session's sysfs dir, so tools can display the info and daemons that execute
> commands like PGRs in userspace can build a session id to I_T nexus mapping.
> 
> In this patch only srp is passing in different values for the transport id
> and acl name. The next patches will convert loop, scsi vhost and xen
> scsiback that are more complex due to their initiator name emulation.
> 
> Cc: Michael S. Tsirkin <mst@redhat.com>
> Cc: Jason Wang <jasowang@redhat.com>
> Cc: Paolo Bonzini <pbonzini@redhat.com>
> Cc: Stefan Hajnoczi <stefanha@redhat.com>
> Cc: Juergen Gross <jgross@suse.com>
> Signed-off-by: Mike Christie <mchristi@redhat.com>
> ---
> 
> V4:
> - Don't drop const char use. We still have target_setup_session allocate
> the transport_id struct, but because every uses format=0 we just need to
> pass in the transport_id's name.
> 
> V3:
> - drop format
> 
>   drivers/infiniband/ulp/srpt/ib_srpt.c    | 10 +++++---
>   drivers/scsi/ibmvscsi_tgt/ibmvscsi_tgt.c |  4 +--
>   drivers/scsi/qla2xxx/tcm_qla2xxx.c       |  2 +-
>   drivers/target/loopback/tcm_loop.c       |  3 ++-
>   drivers/target/sbp/sbp_target.c          |  2 +-
>   drivers/target/target_core_fabric_lib.c  | 41 +++++++++++++++++++++++++++++++
>   drivers/target/target_core_transport.c   | 42 ++++++++++++++++++++++++--------
>   drivers/target/tcm_fc/tfc_sess.c         |  3 ++-
>   drivers/usb/gadget/function/f_tcm.c      |  3 ++-
>   drivers/vhost/scsi.c                     |  1 +
>   drivers/xen/xen-scsiback.c               |  3 ++-
>   include/target/target_core_base.h        | 12 +++++++++
>   include/target/target_core_fabric.h      |  5 +++-
>   13 files changed, 108 insertions(+), 23 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
