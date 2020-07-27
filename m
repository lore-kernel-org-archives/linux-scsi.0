Return-Path: <SRS0=pIAL=BG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7F68DC433E3
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 15:45:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 534B32078A
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Jul 2020 15:45:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="M0JHIb1R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729040AbgG0Ppj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Jul 2020 11:45:39 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:48915 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726932AbgG0Ppi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jul 2020 11:45:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1595864738;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=2ehKZE7hXFk/qNeJii6krvpOJtqjgsejGlg6rhFX8+M=;
        b=M0JHIb1RazOKNTcC+H13bXeiqc3AJpK3ztzn2bP1Cddx7/sftdpAecIlm2y1VN+FK3QKNX
        uYHS56aTl5/1+zfs3qhh7yOx8NT7Icqe4xtwm2tRQfnAWaCqanrku815EHcJnTaliYAyFY
        plQIanMNY0806MBltO9uWIHGX/ioxOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-158-ht2TwzmtM9COOM4_UkitGw-1; Mon, 27 Jul 2020 11:45:35 -0400
X-MC-Unique: ht2TwzmtM9COOM4_UkitGw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 55C5D8005B0;
        Mon, 27 Jul 2020 15:45:34 +0000 (UTC)
Received: from [10.3.128.8] (unknown [10.3.128.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F077460BF4;
        Mon, 27 Jul 2020 15:45:32 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [v4 00/11] Add persistent durable identifier to storage log
 messages
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-scsi@vger.kernel.org, b.zolnierkie@samsung.com,
        axboe@kernel.dk
References: <20200724171706.1550403-1-tasleson@redhat.com>
 <20200726151035.GC20628@infradead.org>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <e3184753-bda1-fcfd-5cc2-7aa865d420fd@redhat.com>
Date:   Mon, 27 Jul 2020 10:45:31 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200726151035.GC20628@infradead.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/26/20 10:10 AM, Christoph Hellwig wrote:
> FYI, I think these identifiers are absolutely horrible and have no
> business in dmesg:

The identifiers are structured data, they're not visible unless you go
looking for them.

I'm open to other suggestions on how we can positively identify storage
devices over time, across reboots, replacement, and dynamic reconfiguration.

My home system has 4 disks, 2 are identical except for serial number.
Even with this simple configuration, it's not trivial to identify which
message goes with which disk across reboots.

-Tony

