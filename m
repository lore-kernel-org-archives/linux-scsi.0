Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A787EE57CC
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:45:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238102AbjIMBpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:45:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231204AbjIMBp3 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:45:29 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EF9B10DF;
        Tue, 12 Sep 2023 18:45:25 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id af79cd13be357-76f14d80ea6so387658385a.2;
        Tue, 12 Sep 2023 18:45:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569524; x=1695174324; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4SY8lBflVzPPa8/hi0jm5+2V0KQ94dEfWm/WlNqSvV0=;
        b=CEhbHZddnLIDexrriZpWbxohoYj97YQdiQ9Yv5oXBxhanO/4NMUf8UYVfiYX9QYs+U
         IBR0StBIC6m+zeNB6+4vteVIAFq/gngGGxnpolcdTPnrzhBnkTUp3Il7ycif7FdcMKAw
         bfVcoLTxTXO89f4KsFf/MvLYeUQcEyCJS0Nt8OcjjJy+MN+t43O6OQ+kqjeOlMTkQnIX
         km9X7cqYmvApCa7XoPxGmcItrkm2TtSOm0hfaHmk2i6hQIObH/mb2RsT9HNdgRXV/9sr
         K97VdvNYKbBJyaD8RKHGkNp5U2gD43SJIgpnqB49bMqRY2TSJPSVKOnOhllbht4y7AQU
         c8/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569524; x=1695174324;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=4SY8lBflVzPPa8/hi0jm5+2V0KQ94dEfWm/WlNqSvV0=;
        b=KOeykDEjfM6bRVJyy10/ZFjJn02+8O9E/5nNPzUFg6b73uFRC2qSHPYkezgXDnHtYv
         vWU2JIJdTdrPD0KxZ/VXi7TUNBqOJKaEYubgmpBy8mhTsmdPq11Gj1xggPVF4iL12TEt
         ed4dzEAkp4s84BRR11MOWY7c+PobT6U7U1op2jyEQkfczp7sVBUPyVx9KRZUY1k7tJW9
         ccneIihQ1Pu1yKBW8AbIlZZGMNgWPH8WTqkBazRmFQkR2qB3ciyqTATDZjN2U9d/kHxC
         GfMT3AamR+fOLn8ds5xDaaYRecTNY63NKNO/n9HV4tytsl+4cg/DqGD+sgQbocZPyZ4v
         eWwg==
X-Gm-Message-State: AOJu0YxyGg+yUQW0IhD0mg+phkyAY3xzvX3xE3zLU2KpPNaXr3PAdOrX
        y+jN14vaYRO6S23rUQULpss=
X-Google-Smtp-Source: AGHT+IEfqYriG9BxaaPcsDJtLOLpP4QyDx1s/VLCUgZyt7u9Nw3A1gwQ+Lu8CIB8ihNoD1qfKN1owg==
X-Received: by 2002:a05:620a:4614:b0:770:ef0b:cf9c with SMTP id br20-20020a05620a461400b00770ef0bcf9cmr1358056qkb.9.1694569524545;
        Tue, 12 Sep 2023 18:45:24 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id bk21-20020aa78315000000b0068fece2c190sm1751160pfb.70.2023.09.12.18.45.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:45:24 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:45:19 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 07/19] scsi: sd: Do not issue commands to suspended disks
 on remove
Message-ID: <ZQEUL6uTFFfkgV6R@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-8-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-8-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:05PM +0900, Damien Le Moal wrote:
> If an error occurs when resuming a host adapter before the devices
> attached to the adapter are resumed, the adapter low level driver may
> remove the scsi host, resulting in a call to sd_remove() for the
> disks of the host. However, since this function calls sd_shutdown(),
> a synchronize cache command and a start stop unit may be issued with the
> drive still sleeping and the HBA non-functional. This causes PM resume
> to hang, forcing a reset of the machine to recover.
> 
> Fix this by checking a device host state in sd_shutdown() and by
> returning early doing nothing if the host state is not SHOST_RUNNING.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
