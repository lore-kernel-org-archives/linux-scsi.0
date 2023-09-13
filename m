Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33A05EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:46:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbjIMBqY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:46:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBqX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:46:23 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F276110DF;
        Tue, 12 Sep 2023 18:46:19 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id 98e67ed59e1d1-26f3e26e55aso5005861a91.3;
        Tue, 12 Sep 2023 18:46:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569579; x=1695174379; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=uz5jvimXDRZsrKyDKbTnBUOxYb36sERQokfW2qOwmfA=;
        b=Mx2KhCKuCFeDgz3A8F4GWUsUe0apj6iB5QXwLj01boftuWp0wnLI+brXnR9MzegKDp
         W0Oa1/Ni5CHdpUBGXdz1m/eo6RbIijvyAboyq+a/FidgF6sVGFhTztIQhHGaicTpNqWK
         siv8RZidpYXjRbpfSZ2WigDFa2PIuyBGdQ7hoJfK46lF4/M6mVDkxtTMTK57cxgITpTJ
         DWv1+OqhpYC8sFnWLWdTxsElGAmgW/1sXuxFinseUigRglvIhWzsixC5eWj6X5TL9s08
         HUita9D3YBbqI65by0IYMf3l5Vjg7HQv8Ga7BdS23Q9ZVTeU/fGwzLacchDIwF1nfUo4
         p+0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569579; x=1695174379;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=uz5jvimXDRZsrKyDKbTnBUOxYb36sERQokfW2qOwmfA=;
        b=gn+XkwRvan7qgoI5jdQCDg6seAZ4H0lpNUO4LhvqWQ5TGRFNiBaOefrw/g+xHzUA4X
         se2MJCM26ANobsvaH71X6ChVFuyn82AHSaApoBAcIirZEGoWWBWywcwnfXnhgYdyCkZe
         T+7EpX1R77x7pZHDREX/nzpsAQlc36u5JDdTouQmiJMpPqJdG4VU2YUa5GMHnsRDdPpp
         +3csxF69Uc8cNk8dvggbSqrEu8Up8tiw1QIUEgOeP/ULneUKysYbGJxoQxMPky9TXf6d
         7fc9z/YGgIIZ9Z0yTlld9lPrFWDW+y9cZXaGzrhBqVm6ax6U+Ho9ynaaMCNYL2oi6vNb
         +WJw==
X-Gm-Message-State: AOJu0YzZmWMNqcAIc+ES8Qudbq9YEnAYguN+5RlsKY8i6i5MBpMxs3zX
        I6+Xb/wtaz8WGif34rLj+bg=
X-Google-Smtp-Source: AGHT+IFuP5wVy/TA63Ow33UmdQW0Gzgtt+3K+oX6q7lXs6O7wmpJjzzQIZq6TvvrARdLSindwObWQA==
X-Received: by 2002:a17:90a:7848:b0:267:f9ab:15bb with SMTP id y8-20020a17090a784800b00267f9ab15bbmr863198pjl.14.1694569579431;
        Tue, 12 Sep 2023 18:46:19 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id i9-20020a17090a718900b00268b9862343sm239367pjk.24.2023.09.12.18.46.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:46:19 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:46:15 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 09/19] ata: libata-scsi: Cleanup
 ata_scsi_start_stop_xlat()
Message-ID: <ZQEUZ7g0paBFW9uW@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-10-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-10-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:07PM +0900, Damien Le Moal wrote:
> Now that libata does its own internal device power mode management
> through libata EH, the scsi disk driver will not issue START STOP UNIT
> commands anymore. We can receive this command only from user passthrough
> operations. So there is no need to consider the system state and ATA
> port flags for suspend to translate the command.
> 
> Since setting up the taskfile for the verify and standby
> immediate commands is the same as done in ata_dev_power_set_active()
> and ata_dev_power_set_standby(), factor out this code into the helper
> function ata_dev_power_init_tf() to simplify ata_scsi_start_stop_xlat()
> as well as ata_dev_power_set_active() and ata_dev_power_set_standby().
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
