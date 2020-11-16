Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD010C55ABD
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:34:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 75415207BC
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Nov 2020 08:34:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726569AbgKPIU5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Nov 2020 03:20:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:48558 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726176AbgKPIU5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 16 Nov 2020 03:20:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3E78BAFA8;
        Mon, 16 Nov 2020 08:20:56 +0000 (UTC)
Subject: Re: [PATCH v7 4/5] scsi_transport_fc: Added store fucntionality to
 set the rport port_state using sysfs
To:     Muneendra <muneendra.kumar@broadcom.com>,
        linux-scsi@vger.kernel.org, michael.christie@oracle.com
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
References: <1605070685-20945-1-git-send-email-muneendra.kumar@broadcom.com>
 <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <1f765db3-68bd-a76c-d7b8-2424e6b377c0@suse.de>
Date:   Mon, 16 Nov 2020 09:20:55 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.4.0
MIME-Version: 1.0
In-Reply-To: <1605070685-20945-5-git-send-email-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/11/20 5:58 AM, Muneendra wrote:
> Added a store functionality to set rport port_state using sysfs
> under  fc_remote_ports/rport-*/port_state
> 
> With this functionality the user can move the port_state from
> Marginal -> Online and Online->Marginal.
> 
> On Marginal :This interface will set SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> On Online :This interface will clear SCMD_NORETRIES_ABORT bit in
> scmd->state for all the pending io's on the scsi device associated
> with target port.
> 
> Below is the interface provided to set the port state to Marginal
> and Online.
> 
> echo "Marginal" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> echo "Online" >> /sys/class/fc_remote_ports/rport-X\:Y-Z/port_state
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> 
> ---
> v7:
> No change
> 
> v6:
> No change
> 
> v5:
> No change
> 
> v4:
> Addressed the error reported by kernel test robot
> Removed the code needed to traverse all the devices under rport
> to set/clear SCMD_NORETRIES_ABORT
> Removed unncessary comments.
> Return the error values on failure while setting the port_state
> 
> v3:
> Removed the port_state from starget attributes.
> Enabled the store functionality for port_state under remote port.
> used the starget_for_each_device to traverse around all the devices
> under rport
> 
> v2:
> Changed from a noretries_abort attribute under fc_transport/target*/ to
> port_state for changing the port_state to a marginal state
> ---
>   drivers/scsi/scsi_transport_fc.c | 56 ++++++++++++++++++++++++++++++--
>   1 file changed, 54 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
