Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 298E8C88CB2
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Jun 2023 18:09:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237222AbjFLSJQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Jun 2023 14:09:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236626AbjFLSJO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Jun 2023 14:09:14 -0400
Received: from mail-pg1-f181.google.com (mail-pg1-f181.google.com [209.85.215.181])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 334CFA7;
        Mon, 12 Jun 2023 11:09:14 -0700 (PDT)
Received: by mail-pg1-f181.google.com with SMTP id 41be03b00d2f7-53fb4ee9ba1so2338273a12.3;
        Mon, 12 Jun 2023 11:09:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686593353; x=1689185353;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=dxFJ05SbfKEOQvpyxzRSqyRDqHU1EpMTWsbLFp+Xs4s=;
        b=iZygAhA0+z8vkMjhbLJYdlY4JgQxNHEn54GjE/0ewadDMwugrgVv7A+II8VGWLv9hq
         XYNDTvRL+gp2xTSZjYgtHnqfM+pEUyZDKGZKLAEyX7FGBaieG+4HdYebt8FhApbNmoVL
         egpV2QloADi2dPr5jlREIua12/1oCx1BVL0YS13r4agbVEfblApF4E8XqVtcGWQAxM+K
         u6/S1JJ0imnIk7WF/I0tFJgTh7t81QxY7Q0WWyyrqdrZAZIqtucdMIv1jQeaDw9P530b
         ZAVQ6AtXcN1itJEtGsVc8G7yiS4SIqqamvfZ0HzM7xSub3YbnKKyl0eugpMNuFwtv7OV
         CuAg==
X-Gm-Message-State: AC+VfDxFhYndl6jehRNn4x6pHfXpxoSpkYuEj3xBKjuA6jDAMtvns4XG
        vyFX9+yOEew2XuNfIMBbpnU=
X-Google-Smtp-Source: ACHHUZ6el7qwDF2D1TzoKzMTN5Xagk9HwwXnD+uPD2F4Ls7+bduHBavZLmB90W074Or/qm6+L49xBA==
X-Received: by 2002:a17:90a:6807:b0:25b:f0fa:ab3a with SMTP id p7-20020a17090a680700b0025bf0faab3amr2109345pjj.18.1686593353531;
        Mon, 12 Jun 2023 11:09:13 -0700 (PDT)
Received: from [192.168.3.219] ([98.51.102.78])
        by smtp.gmail.com with ESMTPSA id fy11-20020a17090b020b00b00256353eb8f2sm3867227pjb.5.2023.06.12.11.09.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 12 Jun 2023 11:09:13 -0700 (PDT)
Message-ID: <326c1eac-b4ab-ab54-7617-b162a87f9557@acm.org>
Date:   Mon, 12 Jun 2023 11:09:11 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.11.2
Subject: Re: [PATCH v5 6/7] scsi: replace scsi_target_block() by
 scsi_block_targets()
Content-Language: en-US
To:     mwilck@suse.com, "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>, Ming Lei <ming.lei@redhat.com>
Cc:     James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>
References: <20230612165049.29440-1-mwilck@suse.com>
 <20230612165049.29440-7-mwilck@suse.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230612165049.29440-7-mwilck@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/12/23 09:50, mwilck@suse.com wrote:
> From: Martin Wilck <mwilck@suse.com>
> 
> All callers (fc_remote_port_delete(), __iscsi_block_session(),
> __srp_start_tl_fail_timers(), srp_reconnect_rport(), snic_tgt_del()) pass
> parent devices of scsi_target devices to scsi_target_block().
> 
> Rename the function to scsi_block_targets(), and simplify it by assuming
> that it is always passed a parent device. Also, have callers pass the
> Scsi_Host pointer to scsi_block_targets(), as every caller has this pointer
> readily available.
> 
> Suggested-by: Christoph Hellwig <hch@lst.de>
> Suggested-by: Bart Van Assche <bvanassche@acm.org>
> Signed-off-by: Martin Wilck <mwilck@suse.com>
> Reviewed-by: Hannes Reinecke <hare@suse.de>
> Cc: Karan Tilak Kumar <kartilak@cisco.com>
> Cc: Sesidhar Baddela <sebaddel@cisco.com>

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
