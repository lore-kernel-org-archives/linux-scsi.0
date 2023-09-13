Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A86B5EE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:49:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238118AbjIMBtR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:49:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIMBtQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:49:16 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D736CAF;
        Tue, 12 Sep 2023 18:49:12 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id af79cd13be357-76de9c23e5cso393341085a.3;
        Tue, 12 Sep 2023 18:49:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569752; x=1695174552; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=itx2QLiKELbUPRCy5gwClYMpI/LYjk9Y/AkzcknMnvQ=;
        b=N5j6EycHR6ONgUeVFJqrHQnrfhX+3ISWAjMHEJfP9FwZ3r2oID/xTqmSpH1qXEdGXH
         0P81N+T1FC1J+iLmJ61qvgat1j52f7Ss2+tUwt/mFOhCua0GClV4lUL/3U/E2cgN2elz
         j0948OLt79gjY49Ght6zf3XJXa9l2jx3aJ4mEaXlIOwqhEyo+1t3asTOOODE4u1YJhYr
         +lWun+ETDV+/c+wLAEakA6INgitiqeX6g3M6Uq28pQ81J+GtvNDoAJdyez/m/B0NatWZ
         RUpotLpXlwXf1kfzuSDCNDQKhEly7zbr1tzaU3K+7f3iBwtdn+KwEjfsMcOUFPGp6lJo
         ZOhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569752; x=1695174552;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=itx2QLiKELbUPRCy5gwClYMpI/LYjk9Y/AkzcknMnvQ=;
        b=Qe6YSP/S5+2MpVDF0ALyBZTQapYHH9sDF/L01br3LMpXP77uXfoQxsDSMcgPafRGeZ
         RWlgzRPAPGOQiq7yn2qAobcxxZqeyuOK1C3fJKbjEwUJBC53CFItOSa6x4fZM8i6jop8
         fPe74GSTWqDUklTex25L7qOZr5rcFH0u+5LWc/lQ3Q+ezDagfjG2TfDbKWUnR8I1JbF0
         B63F5dIYZ+oLf6hQ8T4Q0DXHmzjbQZ2EOIu4U0Yo31E0wI2RExlI9g/obwHO1RjPaAI5
         6c9pGU8Qzi8Uomz9MeMQTY5fWKB13JMWJsykSzdoGGN3fHFMvanDDIOVWctdnzfFOe24
         6GbA==
X-Gm-Message-State: AOJu0Yz5y7jrIeeoRTaGOpbnsWrTKIUZQor4fzItQ81UAPlWCr7bdYUY
        7RpV33en+gpMixKbIswcRmc=
X-Google-Smtp-Source: AGHT+IHPaaVF6ELL4HU3JnK3Yqe1pZo1l1lmHIwW6+VHCInHXr2F9D5RA/bFTe0uMIXX0t7JdhvrAw==
X-Received: by 2002:a05:620a:7ed:b0:76f:456:3916 with SMTP id k13-20020a05620a07ed00b0076f04563916mr973330qkk.43.1694569751959;
        Tue, 12 Sep 2023 18:49:11 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id ay29-20020a056a00301d00b0068fd653321esm3219759pfb.58.2023.09.12.18.49.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:49:11 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:49:06 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 17/19] ata: libata-eh: Improve reset error messages
Message-ID: <ZQEVEgz7eYNPUbic@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-18-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-18-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:15PM +0900, Damien Le Moal wrote:
> Some drives are really slow to spinup on resume, resulting is a very
> slow response to COMRESET and to error messages such as:
> 
> ata1: COMRESET failed (errno=-16)
> ata1: link is slow to respond, please be patient (ready=0)
> ata1: SATA link up 6.0 Gbps (SStatus 133 SControl 300)
> ata1.00: configured for UDMA/133
> 
> Given that the slowness of the response is indicated with the message
> "link is slow to respond..." and that resets are retried until the
> device is detected as online after up to 1min (ata_eh_reset_timeouts),
> there is no point in printing the "COMRESET failed" error message. Let's
> not scare the user with non fatal errors and only warn about reset
> failures in ata_eh_reset() when all reset retries have been exhausted.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
