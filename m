Return-Path: <SRS0=k4K9=7A=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6227C433E0
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 19:39:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AFD4820643
	for <linux-scsi@archiver.kernel.org>; Mon, 18 May 2020 19:39:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ftESmO+Q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728315AbgERTjq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 18 May 2020 15:39:46 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:25463 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727987AbgERTjq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 18 May 2020 15:39:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589830784;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=elcnZwqR+coazwj7IQdMXJlNU9TW6tqy6BaIJjAVsVY=;
        b=ftESmO+QZ4WWHVqpQvc2+6jg0d8DzrfPhu2rqd8j7vYVrHRVlaEEzvYgS0E30QlS17Tk1H
        0s4twL0LoOTOUg5aM8apxtHgfyvnJ+kgeRtsyU7BGpz0uepVYxI0LMsJiPqrMNHS2UmTvP
        /qKw51fM4MXwSWVNvBn9yyHsSjU2OXg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-380-4Acsoz8PNpeiPq8WpmIw5Q-1; Mon, 18 May 2020 15:39:41 -0400
X-MC-Unique: 4Acsoz8PNpeiPq8WpmIw5Q-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E5F3C107ACCD;
        Mon, 18 May 2020 19:39:39 +0000 (UTC)
Received: from [10.10.118.151] (ovpn-118-151.rdu2.redhat.com [10.10.118.151])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6343E5D9DC;
        Mon, 18 May 2020 19:39:39 +0000 (UTC)
Subject: Re: [PATCH v2] scsi: target: tcmu: userspace must not complete queued
 commands
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
References: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <cbc8d169-2bf0-34ed-ccd7-e4a6f74260e7@redhat.com>
Date:   Mon, 18 May 2020 14:39:38 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200518164833.12775-1-bstroesser@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/18/20 11:48 AM, Bodo Stroesser wrote:
> When tcmu queues a new command - no matter whether in command
> ring or in qfull_queue - a cmd_id from IDR udev->commands is
> assigned to the command.
> 
> If userspaces sends a wrong command completion containing the
> cmd_id of a command on the qfull_queue, tcmu_handle_completions()
> finds the command in the IDR and calls tcmu_handle_completion()
> for it. This might do some nasty things, because commands in
> qfull_queue do not have a valid dbi list.
> 
> To fix this bug, we no longer add queued commands to the idr.
> Instead the cmd_id is assign when a command is written to
> the command ring.
> 
> Due to this change I had to adapt the source code at several
> places where up to now an idr_for_each had been done.
> 
> Signed-off-by: Bodo Stroesser <bstroesser@ts.fujitsu.com>

Acked-by: Mike Christie <mchristi@redhat.com>

