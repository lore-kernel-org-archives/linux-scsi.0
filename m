Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5368AC433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Mar 2022 03:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239366AbiCJD4S (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Mar 2022 22:56:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43710 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239361AbiCJD4S (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Mar 2022 22:56:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3748412BF64;
        Wed,  9 Mar 2022 19:55:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C311961743;
        Thu, 10 Mar 2022 03:55:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84A1FC340E8;
        Thu, 10 Mar 2022 03:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646884517;
        bh=engZAFmljiWxkf2QOD63DeS0UkAeFcOu1WQRuCKqZSk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qkRL/RM9O++DRkjuRBHVgyX2Q1wbvAd4AKcSNV7coSzpz6j5Be9csVOQBeFj8p4Xv
         8MPaTJ1GiQuflIOQQQ5kxjZtxu3JQpAv6E/D5rq1AL5gqBvG/zQthhoAF+Jwsk6R+6
         epn9Gjwa3QKVIAG/qGKF5YpPCeMnCNhLUdnpVwVRB2ptxqn1Y663gnzmyYNVJK+/my
         4fQFL3E0dep0tHaBnNDlX8AtY+VLwqsuSVa19O9vETVZVm1QB5LW4tm6wWoy299wux
         RZf6j/wdVuoJG/GvpTAem49TUX7nIIfdmEz1IhfiCzbNu0at8wsNeBK0/PbpBkoRyj
         4o+4isdyhw2Aw==
Date:   Wed, 9 Mar 2022 22:03:47 -0600
From:   "Gustavo A. R. Silva" <gustavoars@kernel.org>
To:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 0/8] scsi: aacraid: Replace one-element arrays with
 flexible-array members
Message-ID: <20220310040347.GA2295236@embeddedor>
References: <cover.1645513670.git.gustavoars@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <cover.1645513670.git.gustavoars@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi all,

Friendly ping: who can review or comment on this series, please?

Thanks
--
Gustavo

On Tue, Feb 22, 2022 at 01:28:12AM -0600, Gustavo A. R. Silva wrote:
> This series aims to replace one-element arrays with flexible-array
> members in multiple structures in drivers/scsi/aacraid/aacraid.h.
> 
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> This helps with the ongoing efforts to globally enable -Warray-bounds
> and get us closer to being able to tighten the FORTIFY_SOURCE routines
> on memcpy().
> 
> These issues were found with the help of Coccinelle and audited and fixed,
> manually.
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.16/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> 
> Gustavo A. R. Silva (8):
>   scsi: aacraid: Replace one-element array with flexible-array member
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmap
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmap
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmap64
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmap64
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct sgmapraw
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct user_sgmapraw
>   scsi: aacraid: Replace one-element array with flexible-array member in
>     struct aac_aifcmd
> 
>  drivers/scsi/aacraid/aachba.c   | 76 +++++++++++----------------------
>  drivers/scsi/aacraid/aacraid.h  | 16 +++----
>  drivers/scsi/aacraid/commctrl.c |  5 +--
>  drivers/scsi/aacraid/comminit.c |  3 +-
>  4 files changed, 37 insertions(+), 63 deletions(-)
> 
> -- 
> 2.27.0
> 
