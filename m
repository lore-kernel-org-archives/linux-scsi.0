Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74C28CDB47E
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Oct 2023 15:41:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232410AbjJMPlq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Oct 2023 11:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58542 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232270AbjJMPlp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Oct 2023 11:41:45 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F877C9;
        Fri, 13 Oct 2023 08:41:45 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E96F9C433C7;
        Fri, 13 Oct 2023 15:41:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697211704;
        bh=WtbPqvXD8Sp/dZdaV6c5+xedVuADZeNktkl6UocO2vQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OLrrFrOx70w9wRHUO2/WbfZRJDcD6ULGeBlcbzzq2Qvy/LgaudtfdpL/5WAfzLrmK
         as0k8cc00B4vYeXBDj01em/D5j/kSmb9datCsxZqSI/wTI+bp1h6Yat69GLzEzZoRB
         +EASbtsyAeW6QwKqlWDEgVWWVotHzJGIkrBeUqZpeEtQCTMwwHDGbYcTMTudvyEU67
         ezLyTM3H1kGB5OHPoQlZH+U4/CUNmGIM+ONK1M351GpICPWDlks27Z+RMmNa8T9vRo
         yDXZacPNJTm6yfQ4ygkzhz1PWQj08a7zqEKirFx9QhdZ3TOFi0uDgzXucFlCULImMT
         xMeY2nNuQ/4AA==
Date:   Fri, 13 Oct 2023 17:41:41 +0200
From:   Simon Horman <horms@kernel.org>
To:     Wenchao Hao <haowenchao2@huawei.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Richard Cochran <richardcochran@gmail.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, louhongxiang@huawei.com
Subject: Re: [PATCH] scsi: libfc: Fix potential NULL pointer dereference in
 fc_lport_ptp_setup
Message-ID: <20231013154141.GO29570@kernel.org>
References: <20231011130350.819571-1-haowenchao2@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231011130350.819571-1-haowenchao2@huawei.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 11, 2023 at 09:03:50PM +0800, Wenchao Hao wrote:
> fc_lport_ptp_setup() did not check the return value of fc_rport_create()
> which is possible to return NULL which would cause a NULL pointer
> dereference. Address this issue by checking return value of
> fc_rport_create() and log error message on fc_rport_create() failed.
> 
> Signed-off-by: Wenchao Hao <haowenchao2@huawei.com>

Thanks,

I verified that fc_lport_ptp_setup can return NULL (if kzalloc fails).

Reviewed-by: Simon Horman <horms@kernel.org>
