Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8E807C7EE23
	for <linux-scsi@archiver.kernel.org>; Sun, 21 May 2023 18:29:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231826AbjEUS3B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 21 May 2023 14:29:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbjEUS2P (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 21 May 2023 14:28:15 -0400
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 437878F;
        Sun, 21 May 2023 11:28:13 -0700 (PDT)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id 493CD342241;
        Sun, 21 May 2023 21:28:11 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=5S94Uo8ISe0OqAk9N+KM+Xw6eUrmAJxOw5/V93a57hc=; b=
        XgrtieGQTZ7SbShboPpk41CfY4ay8dUxQLODb+R7iBIQUSSFQ3PBdjsDcua/QhVw
        ybBziUWDupwg9WDRR0YjCHaLJAdkwwTutkcl7MZpfwcRoRw+wMrQLEf5PCRz0hUU
        Lr4kycV5eMWGotxd3PyxOtx25RGy7u0e7SI+xy4DqR8=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id 3ADD83420D1;
        Sun, 21 May 2023 21:28:11 +0300 (MSK)
Received: from T-EXCH-09.corp.yadro.com (172.17.11.59) by
 T-EXCH-08.corp.yadro.com (172.17.11.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1118.9; Sun, 21 May 2023 21:28:10 +0300
Received: from yadro.com (10.178.192.41) by T-EXCH-09.corp.yadro.com
 (172.17.11.59) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Sun, 21 May
 2023 21:28:08 +0300
Date:   Sun, 21 May 2023 21:28:06 +0300
From:   Konstantin Shelekhin <k.shelekhin@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     Martin Petersen <martin.petersen@oracle.com>,
        <target-devel@vger.kernel.org>, <linux-scsi@vger.kernel.org>,
        <linux@yadro.com>, Dmitry Bogdanov <d.bogdanov@yadro.com>
Subject: Re: [PATCH 2/2] scsi: target: iblock: Report space allocation errors
Message-ID: <ZGpitkN0tMJeOA-8@yadro.com>
References: <20230517141537.80936-1-k.shelekhin@yadro.com>
 <20230517141537.80936-3-k.shelekhin@yadro.com>
 <80a07968-e33f-efba-cd7a-6e3047a520c4@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <80a07968-e33f-efba-cd7a-6e3047a520c4@oracle.com>
X-Originating-IP: [10.178.192.41]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-09.corp.yadro.com (172.17.11.59)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 20, 2023 at 01:05:01PM -0500, Mike Christie wrote:
> On 5/17/23 9:15 AM, Konstantin Shelekhin wrote:
> > When a thin provisioned block device lacks free LBA it ends bio requests
> > with BLK_STS_NOSPC. Currently iblock treats bio status as a boolean and
> > terminates failed requests with LOGICAL UNIT COMMUNICATION FAILURE if
> > the status is non-zero. Thus, initiators see space allocation errors as
> > I/O errors.
> >
> > This commit modifies the iblock_req structure to store the status of the
> > first failed bio instead of the total number of failed bios. The status
> > is then used to set the specific sense reason.
> >
> 
> You posted this patch before right? I think it didn't get picked up because
> the kernel bot keeps flagging the mixing of the blk_status_t and atomic_t.
> Just build with sparse C=1 and you should see it.

Dammit, I thought I fixed this the last time. Will fix and resend.

