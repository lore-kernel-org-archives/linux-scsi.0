Return-Path: <SRS0=6k2I=4A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4509C2BA83
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 16:10:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BB2682168B
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Feb 2020 16:10:56 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Hh/9JA8c"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728595AbgBLQKw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Feb 2020 11:10:52 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:26639 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728575AbgBLQKw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 12 Feb 2020 11:10:52 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581523851;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SVVq6qjRCsdQwLjJ3Pl2oKorAivzLQr7S00rXFIKNVM=;
        b=Hh/9JA8ckC15wtm2NIqgxhL5Dzdqu2WOyQKpRyusIpH+T2NIsD7j8zE/ECnD1GXWUlIWVY
        3sKN/bJitoPm2KpyiP/KMCM3fpuwEAFdYduhjnLw23xlTQfT8k81dO04wjoJLtf9edfYyw
        4GRZ0IympuO9am3MK8Ks1Ak7ryiU8S0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-166-y1KLSIPVOpe_iMVvs1g-Og-1; Wed, 12 Feb 2020 11:10:47 -0500
X-MC-Unique: y1KLSIPVOpe_iMVvs1g-Og-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 7DA7D107ACCC;
        Wed, 12 Feb 2020 16:10:45 +0000 (UTC)
Received: from emilne (unknown [10.18.25.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C5AF45C100;
        Wed, 12 Feb 2020 16:10:44 +0000 (UTC)
Message-ID: <eac106d0fd30e20b6df4287f8bc01844191d29c6.camel@redhat.com>
Subject: Re: [PATCH] scsi: Delete scsi_use_blk_mq
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     John Garry <john.garry@huawei.com>,
        Bart Van Assche <bvanassche@acm.org>,
        jejb@linux.vnet.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 12 Feb 2020 11:10:44 -0500
In-Reply-To: <2e2ead7d-503e-3881-b837-7c689a4d44c6@huawei.com>
References: <1581355992-139274-1-git-send-email-john.garry@huawei.com>
         <3795ab1d-5282-458b-6199-91e3def32463@acm.org>
         <2e2ead7d-503e-3881-b837-7c689a4d44c6@huawei.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2020-02-11 at 11:50 +0000, John Garry wrote:
> On 10/02/2020 22:37, Bart Van Assche wrote:
> > On 2/10/20 9:33 AM, John Garry wrote:
> > > -module_param_named(use_blk_mq, scsi_use_blk_mq, bool, S_IWUSR | 
> > > S_IRUGO);
> 
> Hi Bart,
> 
> > Will this change cause trouble to shell scripts that set or read this 
> > parameter (/sys/module/scsi_mod/parameters/use_blk_mq)? 
> 
> The entry in Documentation/admin-guide/kernel-parameters.txt is gone for 
> 2 years now.
> 
> And it is not an archaic module param, it was introduced 6 years ago. As 
> such, I'd say that if a shell script was setup to access this parameter, 
> then it would prob also pre-check if it exists and gracefully accept 
> that it may not.
> 
> I will also note that there is still scsi_sysfs.c:show_use_blk_mq(), 
> which would stay.
> 
> What will the
> > impact be on systems where scsi_mod.use_blk_mq=Y is passed by GRUB to 
> > the kernel at boot time, e.g. because it has been set in the 
> > GRUB_CMDLINE_LINUX variable in /etc/default/grub?
> 
> The kernel should any params that does not recognize.
> 
> 
> Having said all that, I don't feel too strongly about deleting this - 
> it's only some tidy-up.
> 
> Thanks,
> John
> 

I think we should remove it.  It is not good to have a kernel parameter
that people used to be able to set to "N" that no longer does that.

-Ewan


