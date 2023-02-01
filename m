Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 616FDC05027
	for <linux-scsi@archiver.kernel.org>; Wed,  1 Feb 2023 08:58:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230496AbjBAI6K (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Feb 2023 03:58:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230147AbjBAI6I (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Feb 2023 03:58:08 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2CFCA34;
        Wed,  1 Feb 2023 00:58:08 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id AA92B341AC8;
        Wed,  1 Feb 2023 11:58:06 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=1xTMsF7sxaMIbDqVdmkeIiafhTW/Ro6iuot88plw54c=; b=
        bU8V+WYM+HC3C/ZzxKFIn5qgoveXCrs0SdBZchUubIdBtf9ZSxog1EmVM3jncdeS
        aC/AM3u+CveTALdPCLuDxbY6ykz6FdKHT6P/WxMHWD02A1TIH1xx3VZk8vlMvLY0
        pD894XP/cuc42DW8QzD+MaQn2NFNQwDk5ssC4eruAX0=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 9F884341A6B;
        Wed,  1 Feb 2023 11:58:06 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Wed, 1 Feb 2023
 11:58:06 +0300
Date:   Wed, 1 Feb 2023 11:58:06 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Nilesh Javali <njavali@marvell.com>,
        Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>
CC:     <linux-scsi@vger.kernel.org>, <linux@yadro.com>,
        Nilesh Javali <njavali@marvell.com>,
        <GR-QLogic-Storage-Upstream@marvell.com>,
        Mike Christie <michael.christie@oracle.com>
Subject: Re: [PATCH v2] scsi: qla2xxx: abort TMR commands
Message-ID: <20230201085806.GL31614@yadro.com>
References: <20221205130800.15816-1-d.bogdanov@yadro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221205130800.15816-1-d.bogdanov@yadro.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Dec 05, 2022 at 04:08:00PM +0300, Dmitry Bogdanov wrote:
> TCM calls aborted_task callback for TMR too and then releases the
> command. But qla2xx ignores that callback for TMR and leaks an FC
> exchange.
> Add terminating the exchange of task management IOCBs to free its
> FW resources.
> 
> Signed-off-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
> ---
> Changelog:
>   v2:
>      fix sparse warning 'expected restricted __le16' [usertype] control_flags
>      fix checkpatch warning 'quoted string split across lines'

Nilesh, could you please take a look on the patch?


