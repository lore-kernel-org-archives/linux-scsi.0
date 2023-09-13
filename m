Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 15BA7EE3F3F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:47:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238105AbjIMBrE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:47:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230323AbjIMBrE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:47:04 -0400
Received: from mail-ot1-x329.google.com (mail-ot1-x329.google.com [IPv6:2607:f8b0:4864:20::329])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5471710DF;
        Tue, 12 Sep 2023 18:47:00 -0700 (PDT)
Received: by mail-ot1-x329.google.com with SMTP id 46e09a7af769-6bf01bcb1aeso4386293a34.3;
        Tue, 12 Sep 2023 18:47:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569619; x=1695174419; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=g35OKcQ+YJxpAsT6ZucrOEU/U1rUFBONnsPcTrigoK8=;
        b=J5Z/18ih+aNjSwaBp9g5alFFWM7bf2/RiEeGrep2foPj0YpB/71gR8cdRVbyNn3Ne9
         VOAa1vHSmHq1LmIJpvuOsSeON+dy+tmyMk+Ft/v8hC8/UoibLSjoddwlb5jbq7wAvcz3
         Znue9zA0HMQnNiBmXIqMeRh7djmLKcZ8qQqDsNKdLIXPAsq74HmY707ue943E2gvxnXm
         w04y9B6Bpfs0Iqf6N2dpL+Db1bxb+qNQa4VBxikvrb5Uvtmev13R0kXX8YDmNf2vhoPr
         fRgT+DHVNEZKOvwzl4rFpfQyNUbJP8X5yfDSMxK1tEF61NsLtWLt3DEyYMyqc68jtIzB
         YSoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569619; x=1695174419;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=g35OKcQ+YJxpAsT6ZucrOEU/U1rUFBONnsPcTrigoK8=;
        b=poNv+LRUwlTkYSWEvylYtl3b39PSFO0Ocoo2ey55tdq7dC3fhrG4TGMkODmePEVrYe
         Pj4WStyVlrcAeSFBn9LQE/nPuC/+5YzH+Xjmu/H+aZ60S2vIZo7Z3WLOD6lgIdR43qmf
         wJ8lY0UpX06PryWhX0fnaACEtDp93iwGkNX5zd1z0rEeedJtjcZxwCsgtcJUzty9hXMu
         Q8dlYWbdXYoylMofkqD8blwZXlgJlnAazZig4sqGGjnB9xAGGMJbp3fn4zsDrAFIsVsq
         Ko1fAnPgmigZTYsZEHC5MvUHZ3fAWp1Q9yMR/W6H8wnakXe192FVVQBpCOZa0MwWWyNR
         mGqQ==
X-Gm-Message-State: AOJu0Yz+avM41CI0SL7/UfpkBIBh8NKsCYCI4AXX9Nq7M8kGL9ZUsp1B
        cFgQ+yyP2YXqXfOoRhst9IE=
X-Google-Smtp-Source: AGHT+IGiJvJ6RF1z7z+van1fsQQmv7/4o/bWp8F69KAq2fhkP5Gs1CbZkHzbrJKVhW6xpMhiAGFh5w==
X-Received: by 2002:a9d:6257:0:b0:6bf:5b30:5b69 with SMTP id i23-20020a9d6257000000b006bf5b305b69mr1675827otk.17.1694569619542;
        Tue, 12 Sep 2023 18:46:59 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id a15-20020aa7864f000000b0068c69ed223esm3571796pfo.77.2023.09.12.18.46.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:46:59 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:46:55 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 11/19] ata: libata-core: Detach a port devices on shutdown
Message-ID: <ZQEUj1wUwIzITWdA@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-12-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-12-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:09PM +0900, Damien Le Moal wrote:
> Modify ata_pci_shutdown_one() to schedule EH to unload a port devices
> before freezing and thawing the port. This ensures that drives are
> cleanly disabled and transitioned to standby power mode when
> a PCI adapter is removed or the system is powered off.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
