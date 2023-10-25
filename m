Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 929B3C0032E
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Oct 2023 11:57:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234986AbjJYL55 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Oct 2023 07:57:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234901AbjJYL54 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Oct 2023 07:57:56 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F8B136;
        Wed, 25 Oct 2023 04:57:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698235074;
        bh=8j+d/OeCRcJDpiWK1ANEg7BZYZ947nhDCPtvOegqyhE=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=IiuogP24QAdg4NhnMT43UNVIdVrt9hCHijZ9E7oVo5826p3QRoJ1ENbuR0UeJ/VZR
         7NxbaV9vqgzxVDZr3R0sEdJgzWUPkFAOUqZ2rfIWOyEGjtcjq6seDWZlPnSk4H55TY
         bMlaikWBT3reXbh6GHfT4HFEWaRKXXPzR6qRO2Q8=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 89C0312868E8;
        Wed, 25 Oct 2023 07:57:54 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id zMx10O1PrDwo; Wed, 25 Oct 2023 07:57:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1698235074;
        bh=8j+d/OeCRcJDpiWK1ANEg7BZYZ947nhDCPtvOegqyhE=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=IiuogP24QAdg4NhnMT43UNVIdVrt9hCHijZ9E7oVo5826p3QRoJ1ENbuR0UeJ/VZR
         7NxbaV9vqgzxVDZr3R0sEdJgzWUPkFAOUqZ2rfIWOyEGjtcjq6seDWZlPnSk4H55TY
         bMlaikWBT3reXbh6GHfT4HFEWaRKXXPzR6qRO2Q8=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C6D5D1286803;
        Wed, 25 Oct 2023 07:57:53 -0400 (EDT)
Message-ID: <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
Date:   Wed, 25 Oct 2023 07:57:51 -0400
In-Reply-To: <20231025070117.464903-1-dlemoal@kernel.org>
References: <20231025070117.464903-1-dlemoal@kernel.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2023-10-25 at 16:01 +0900, Damien Le Moal wrote:
> +++ b/include/scsi/scsi_device.h
> @@ -164,6 +164,7 @@ struct scsi_device {
>  
>         bool manage_system_start_stop; /* Let HLD (sd) manage system
> start/stop */
>         bool manage_runtime_start_stop; /* Let HLD (sd) manage
> runtime start/stop */
> +       bool manage_shutdown;   /* Let HLD (sd) manage shutdown */
>  

I think at least 85% of the world gets confused about the difference
between runtime/system start/stop and shutdown.  Could we at least
point to a doc explaining it in a comment here?

James

