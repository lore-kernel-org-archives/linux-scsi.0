Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9967C4743E
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 13:09:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B0D266128A
	for <linux-scsi@archiver.kernel.org>; Tue,  8 Jun 2021 13:09:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232655AbhFHNL1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 8 Jun 2021 09:11:27 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:49618 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231162AbhFHNL1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 8 Jun 2021 09:11:27 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 40F751FD46;
        Tue,  8 Jun 2021 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623157773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSyVpRECJSyB0ONBdUo37nvnzwImgFpzmH7ifqfbPzs=;
        b=0Pe6DtF4A66MvPs6Q7P5Ga69RNbVFaWy6jB6p7EwTYLzggg5ioSCYxWugAXLGFyBXMjjev
        CFk6sMNLuYoQke39LDJPZph6KorIBUApjD81/dMxKTvNzFo23GqWW+7e5fB+FV+qpB49Up
        oudMReAAN1Qzw7S5F543gGtzKFX2HNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623157773;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSyVpRECJSyB0ONBdUo37nvnzwImgFpzmH7ifqfbPzs=;
        b=i2umO7VwzW79VTHD2pGB9Rtd+SH7cMfV6vOxukBZr32Mecic790Vr68Qk90r0sdmzsJn/y
        38hkw/iVFuWkvHDA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 353E8118DD;
        Tue,  8 Jun 2021 13:09:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623157773; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSyVpRECJSyB0ONBdUo37nvnzwImgFpzmH7ifqfbPzs=;
        b=0Pe6DtF4A66MvPs6Q7P5Ga69RNbVFaWy6jB6p7EwTYLzggg5ioSCYxWugAXLGFyBXMjjev
        CFk6sMNLuYoQke39LDJPZph6KorIBUApjD81/dMxKTvNzFo23GqWW+7e5fB+FV+qpB49Up
        oudMReAAN1Qzw7S5F543gGtzKFX2HNs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623157773;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FSyVpRECJSyB0ONBdUo37nvnzwImgFpzmH7ifqfbPzs=;
        b=i2umO7VwzW79VTHD2pGB9Rtd+SH7cMfV6vOxukBZr32Mecic790Vr68Qk90r0sdmzsJn/y
        38hkw/iVFuWkvHDA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id 8eDVDA1sv2DMXAAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 08 Jun 2021 13:09:33 +0000
Subject: Re: [PATCH v11 08/13] lpfc: vmid: Functions to manage vmids
To:     Muneendra Kumar <muneendra.kumar@broadcom.com>,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        tj@kernel.org, linux-nvme@lists.infradead.org
Cc:     jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>
References: <20210608043556.274139-1-muneendra.kumar@broadcom.com>
 <20210608043556.274139-9-muneendra.kumar@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <6f3e5eb9-22de-ba43-9591-1f3610172738@suse.de>
Date:   Tue, 8 Jun 2021 15:09:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.9.1
MIME-Version: 1.0
In-Reply-To: <20210608043556.274139-9-muneendra.kumar@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/8/21 6:35 AM, Muneendra Kumar wrote:
> From: Gaurav Srivastava <gaurav.srivastava@broadcom.com>
> 
> This patch contains the routines to save, retrieve and remove the vmids
> from the data structure. A hash table is used to save the vmids and
> the corresponding UUIDs associated with the application/VMs.
> 
> Signed-off-by: Gaurav Srivastava  <gaurav.srivastava@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
