Return-Path: <SRS0=tLTu=A4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42D6BC433DF
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 19:47:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FB2320684
	for <linux-scsi@archiver.kernel.org>; Fri, 17 Jul 2020 19:47:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Xz/ZdGIF"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728795AbgGQTrX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 17 Jul 2020 15:47:23 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:57244 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728739AbgGQTrX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 17 Jul 2020 15:47:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595015241;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=eCmhCWwIJ6CKG2s7cwMGJnhsahUrbS+DMabjHA0qqv0=;
        b=Xz/ZdGIFUuB8BGfAwexFL99+fXJeMTrKS6q5Zf39xhLmIPNrD5PMAh/IDWyxPn21pgmSuE
        iiy8ci9MevF6bB7Bv7J2NEESDdPjC4Q5T0npIXFUrsA+AFEQpdLSg4TxYAJ/s7PsMy/4TA
        hMZI0/1vYB9AnrR6PifEmL6uhQia5U0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-115-9SgCXpOSO7mFrw412bUIFw-1; Fri, 17 Jul 2020 15:47:19 -0400
X-MC-Unique: 9SgCXpOSO7mFrw412bUIFw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 52E3C100CC85;
        Fri, 17 Jul 2020 19:47:18 +0000 (UTC)
Received: from [10.3.128.8] (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id AEDEB10013C4;
        Fri, 17 Jul 2020 19:47:16 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v3 5/8] ata_dev_printk: Use dev_printk
To:     Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-6-tasleson@redhat.com>
 <CGME20200624103532eucas1p2c0988207e4dfc2f992d309b75deac3ee@eucas1p2.samsung.com>
 <d817c9dd-6852-9233-5f61-1c0bc0f65ca4@samsung.com>
 <7ed08b94-755f-baab-0555-b4e454405729@redhat.com>
 <cfff719b-dc12-a06a-d0ee-4165323171de@samsung.com>
 <20200714081750.GB862637@kroah.com>
 <dff66d00-e6c3-f9ef-3057-27c60e0bfc11@samsung.com>
 <20200717100610.GA2667456@kroah.com>
 <e6517dd6-b6b6-ead3-2e60-03832e0c43bf@samsung.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <84fec7af-3f51-c956-d2ca-41581e0f3cbb@redhat.com>
Date:   Fri, 17 Jul 2020 14:47:15 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <e6517dd6-b6b6-ead3-2e60-03832e0c43bf@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/17/20 5:27 AM, Bartlomiej Zolnierkiewicz wrote:
> 
> On 7/17/20 12:06 PM, Greg Kroah-Hartman wrote:
> 
>> Just use the device name and don't worry about it, I doubt anyone will
>> notice, unless the name is _really_ different.
>
> Well, Geert has noticed and complained pretty quickly:
> 
> https://lore.kernel.org/linux-ide/alpine.DEB.2.21.2003241414490.21582@ramsan.of.borg/
> 
> Anyway, I don't insist that hard on keeping the old names and
> I won't be the one handling potential bug-reports.. (added Jens to Cc:).

I would think having sysfs use one naming convention and the logging
using another would be confusing for users, but apparently they've
managed this long with that.


It appears changes are being rejected because of logging content
differences, implying we shouldn't be changing printk usage to dev_printk.

Should I re-work my changes to support dev_printk path in addition to
utilizing printk_emit functionality so that we can avoid user space
visible log changes?  I don't see a way to make the transition from
printk to dev_printk without having user visible changes to message content.

Thanks
-Tony

