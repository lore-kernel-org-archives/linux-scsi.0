Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C209AC55189
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:35:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A418A2084D
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 01:35:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="t35S96Uw"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgDWBf3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 21:35:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36218 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725828AbgDWBf3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 21:35:29 -0400
Received: from mail-pf1-x443.google.com (mail-pf1-x443.google.com [IPv6:2607:f8b0:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2D6BC03C1AA
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:35:28 -0700 (PDT)
Received: by mail-pf1-x443.google.com with SMTP id w65so2081642pfc.12
        for <linux-scsi@vger.kernel.org>; Wed, 22 Apr 2020 18:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=L6p+kQtkyqGARHBU19Xz0M+B6272p3ThzJQZMvlxBa4=;
        b=t35S96UwmeknSMWAxAnPcI9+Qda2juKx9tFi/4u20xvIrzsKYEX5hpapIz43N8TaIO
         Ko2Qz5Wo138P8EjXJp4zML+lp+I40m7PXMcgcFeDJxsZhbZ83eZ4c9RVHafJePGGFBeV
         aufZj0tbXTRVHXsdLuH1eUWHXvTW6clgQe8HrxIUUDVHZS7T1FtBVg4DBiv/+0fUam/R
         i18XaRC6kRRTaL00pJ/mBceA6X8ic4MRoHs7bVMT8grCmBzlHnhp2QhwVDs/s5f0JuaJ
         2+SD+ehYYseNsUvSjbDQ1CGZ2s//ABO0ZRRpipL8VxmbVfQnNCKda4cN4GlEvf7aw0/E
         eqGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=L6p+kQtkyqGARHBU19Xz0M+B6272p3ThzJQZMvlxBa4=;
        b=nksf72mu9f60VNX98o3YcOsR2c2QJKmiXM5VUqO+h/X06cZMneeo8EIvKjR+L/Bvmd
         NeK0NinlUkOVNIZwGlikZZJ6oUyqY4MFbflteC+6HRY9/IX/6vAvCpDwP3/AHWVdA47l
         GOM6YQYFk+KMlU+SDo5Bv1Fo4ug+r/ke6ey9kwrH1Em7gaxQgk4qJSh+BGs+4Ob6dFc8
         2qpfSC8kD0o6NOCQctUNpPawuAt8MITA97jpxIaVG7SgJZD8OaFN5KbQ+eKWMledxD4C
         0R7uIN1NN3CDJaowTHYaYEphUG6b997CO7j4GOc33cQWaI/sgiaC/Uq+tHXyZ6zzkuGK
         B3ag==
X-Gm-Message-State: AGi0PuZaAxlKNX9KCh5DX8ajqtBveHmT8IeeqFQaQEZqrbiB7IC8Z3TS
        gWn09IdCx+FK13Vq+LVw/CqFaZja
X-Google-Smtp-Source: APiQypJoy6G3HTvg8v5BCYm/UXJhlNcZt29JRMj0dxLDac6uvX0ZujQPZszOVhDnoykUB9h6jbTa2A==
X-Received: by 2002:a63:6302:: with SMTP id x2mr1715657pgb.375.1587605728438;
        Wed, 22 Apr 2020 18:35:28 -0700 (PDT)
Received: from [10.230.185.141] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a196sm794176pfd.184.2020.04.22.18.35.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Apr 2020 18:35:27 -0700 (PDT)
Subject: Re: [PATCH v3 12/31] elx: libefc: Remote node state machine
 interfaces
To:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org
Cc:     dwagner@suse.de, maier@linux.ibm.com, bvanassche@acm.org,
        herbszt@gmx.de, natechancellor@gmail.com, rdunlap@infradead.org,
        Ram Vegesna <ram.vegesna@broadcom.com>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-13-jsmart2021@gmail.com>
 <1f711306-0c3d-ab28-6984-73299efe6e5f@suse.de>
From:   James Smart <jsmart2021@gmail.com>
Message-ID: <3f7d5a66-f366-70d4-3730-a75fe2e1a3b8@gmail.com>
Date:   Wed, 22 Apr 2020 18:35:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <1f711306-0c3d-ab28-6984-73299efe6e5f@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/2020 8:51 AM, Hannes Reinecke wrote:
> Relating to my previous comments: Can you elaborate about the lifetime 
> rules to the node? It looks as if any access to the node is being 
> guarded by the main efc->lock.
> Which, taken to extremes, would meant that one has to hold that lock for 
> _any_ access to the node; that would include I/O processing etc, too.
> I can't really see how that would scale to the IOPS you are pursuing, so 
> clearly that will not happen.
> So how _do_ you ensure the validity of a node if the lock is not held?
> 
> Cheers,
> 
> Hannes

This lock is defined for single EQ/RQ. For multi EQ/RQ which we will add 
in future, will have more granular locks and performance improvements.
All the State Machine Events are triggered from the EQ processing thread 
except vport creation and deletion.

Locking:
   Global lock per efc port "efc->lock"

Domain:
     efc_domain_cb --> (All the events are executed under efc lock)

     Async link up notification(EFC_HW_DOMAIN_FOUND)
          Alloc Domain, Start discovery
          Alloc Sport
     Async link down notification (EFC_HW_DOMAIN_LOST)
           Hold frames. (New frames will be moved to pending)
           Post Sport Shutdown.
           Post All Nodes Shutdown.

Sport:
     efc_lport_cb --> (All the events are executed under efc lock)

       HW sport registration (Mbox command responses) to complete sport 
allocation.

Vport :
     efc_sport_vport_new() --> New Vport

      efc_vport_sport_alloc() (Protected by efc lock)
      Alloc Sport, and start Sport SM

    efc_sport_vport_del()  --> Delete Vport

      Post shutdown event to the Sport. (Protected by efc lock)

Node:
    efc_remote_node_cb() --> (All the events are executed under efc lock)

        HW node registration (Mbox command responses) to complete node 
allocation.

Node lifeCycle:
    efc_domain_dispatch_frame:-

     EFC lock held
     efc_node_find() IF not found, Create one.
     when PLOGI is received, Register with hardware
     Upon PRLI completion, setup a new session with LIO.

    IO path:

      Find sport and node under EFC lock.
      If node can process commands, start IO processing.
      Each IO is added to the node->active_ios.

   Node deletion: (RSCN notification or LOGO received ..)

      EFC lock held
      Disable receiving fcp commands. (node->fcp_enabled)
      Disable IO allocation for this node.
      Remove LIO session.
      Deregister node with HW
      Waits for all active_ios to be completed/freed.
      Purge pending IOs.
      Free the Node.

In IO path, EFC lock is acquired to find the sport and node, release the 
EFC lock and continue with IO allocation and processing. Note: There is 
still an unsafe area where we check for 'node->hold_frames" without the 
lock. Node is assumed to be kept alive until all the IOs under the node 
are freed.  Adding the refcounting will remove this assumption.

-- james
