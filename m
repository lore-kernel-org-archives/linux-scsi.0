Return-Path: <SRS0=af2F=6L=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7824C54FD0
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 09:18:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C456F20656
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Apr 2020 09:18:09 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=yadro.com header.i=@yadro.com header.b="rVoc49W4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726786AbgD0JSJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Apr 2020 05:18:09 -0400
Received: from mta-02.yadro.com ([89.207.88.252]:51884 "EHLO mta-01.yadro.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726639AbgD0JSJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 27 Apr 2020 05:18:09 -0400
Received: from localhost (unknown [127.0.0.1])
        by mta-01.yadro.com (Postfix) with ESMTP id 8159A47D0B;
        Mon, 27 Apr 2020 09:18:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=yadro.com; h=
        content-transfer-encoding:mime-version:x-mailer:content-type
        :content-type:references:in-reply-to:date:date:from:from:subject
        :subject:message-id:received:received:received; s=mta-01; t=
        1587979085; x=1589793486; bh=JiNF3YJSq7vmXtXuNUMihHhMSJmpUZopZmW
        FH8KR0hA=; b=rVoc49W4WAr/Q+gQJ3T5UvZyeo3ksJ2b3EoszHLuuqBZ7TuSjl6
        k8tWbYPWBx1ba7iN1EAPyDAvH/wZPvC+MTcufttOxg24guRg1wSihi/oqviZ/Huv
        OU7ayiOb+EWkVfKh8JR1vqPB7Td8FgYmCiuetD40MGcT42wns3grBDNE=
X-Virus-Scanned: amavisd-new at yadro.com
Received: from mta-01.yadro.com ([127.0.0.1])
        by localhost (mta-01.yadro.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id YbE-kMmxVt-p; Mon, 27 Apr 2020 12:18:05 +0300 (MSK)
Received: from T-EXCH-02.corp.yadro.com (t-exch-02.corp.yadro.com [172.17.10.102])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Postfix) with ESMTPS id 9134040311;
        Mon, 27 Apr 2020 12:18:04 +0300 (MSK)
Received: from vdubeyko-laptop (10.199.2.2) by T-EXCH-02.corp.yadro.com
 (172.17.10.102) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384_P384) id 15.1.669.32; Mon, 27
 Apr 2020 12:18:05 +0300
Message-ID: <b8648e0b817def5416d73215c1174589547e336d.camel@yadro.com>
Subject: Re: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target reset
From:   Viacheslav Dubeyko <v.dubeiko@yadro.com>
To:     Bart Van Assche <bvanassche@acm.org>, <linux-scsi@vger.kernel.org>
CC:     <hmadhani@marvell.com>, <jejb@linux.ibm.com>,
        <martin.petersen@oracle.com>, <linux@yadro.com>,
        <r.bolshakov@yadro.com>
Date:   Mon, 27 Apr 2020 12:18:04 +0300
In-Reply-To: <fcbbfdac-1a79-51ac-beae-ea4b38f21798@acm.org>
References: <1d7b21bf9f7676643239eb3d60eaca7cfa505cf0.camel@yadro.com>
         <fcbbfdac-1a79-51ac-beae-ea4b38f21798@acm.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.199.2.2]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-02.corp.yadro.com (172.17.10.102)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Sun, 2020-04-26 at 18:55 -0700, Bart Van Assche wrote:
> On 2020-04-24 05:10, Viacheslav Dubeyko wrote:
> > From: Viacheslav Dubeyko <v.dubeiko@yadro.com>
> > Date: Fri, 10 Apr 2020 11:07:08 +0300
> > Subject: [PATCH 1/3] scsi: qla2xxx: Fix warning after FC target
> > reset
> > 
> > Currently, FC target reset finishes with the warning
> > message.
> 
> Hi Slava,
> 
> For future patch submissions, please include a cover letter with the
> patch series and also use threaded mode, e.g. by setting
> sendemail.thread = true in ~/.gitconfig.
> 
> A summary of what Martin Petersen expects from contributors is
> available
> at 
> https://lore.kernel.org/ksummit-discuss/yq1o8zqeqhb.fsf@oracle.com/.
> 

Frankly speaking, I don't see the logical relations among these three
fixes. So, I didn't prepare the cover letter because of this. I believe
that three independent patches could be better than patchset. What do
you think?

I am using the Evolution for sending the patches. I am not completely
sure that sendemail.thread = true in ~/.gitconfig can change the
Evolution's behavior. Is it something wrong with the Evolution's
settings?

Thanks,
Slava.


