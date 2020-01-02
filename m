Return-Path: <SRS0=pZIS=2X=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 967A5C3276C
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 22:52:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5E39820866
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Jan 2020 22:52:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="DAdsLIAU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgABWwt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 2 Jan 2020 17:52:49 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30116 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728580AbgABWwt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Jan 2020 17:52:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578005567;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+ro2StskuuiOygh3NiDGUwqcaIG+MVEbFmsA628V+UI=;
        b=DAdsLIAUPm0+STYw5+KxA0K/x5d8Oh3LjeshiRXuCM8Rj6yMbLb6TE1Zu3hDHdCWnlw64O
        mQXzRzQAI6vdXpX/36tBSM2YA7/jJ/cMGVg3vnHtJkT9GQbYrP0l9AtyBO6tQVZb0YmlkV
        ej8Y9MVddwrWHPNk2/rv/F+0X3Wx8LM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-399-d7SrF8PNMAe1zwPJniqu2g-1; Thu, 02 Jan 2020 17:52:46 -0500
X-MC-Unique: d7SrF8PNMAe1zwPJniqu2g-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4306B107ACC4;
        Thu,  2 Jan 2020 22:52:45 +0000 (UTC)
Received: from [10.3.112.12] (ovpn-112-12.phx2.redhat.com [10.3.112.12])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3147B5D9C9;
        Thu,  2 Jan 2020 22:52:43 +0000 (UTC)
From:   Tony Asleson <tasleson@redhat.com>
Subject: Re: [RFC 0/9] Add persistent durable identifier to storage log
 messages
Reply-To: tasleson@redhat.com
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20191223225558.19242-1-tasleson@redhat.com>
 <1577148654.29997.29.camel@HansenPartnership.com>
Organization: Red Hat
Message-ID: <833ef311-1918-3b47-18bb-bc59aabd0ba8@redhat.com>
Date:   Thu, 2 Jan 2020 16:52:42 -0600
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <1577148654.29997.29.camel@HansenPartnership.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/23/19 6:50 PM, James Bottomley wrote:
> On Mon, 2019-12-23 at 16:55 -0600, Tony Asleson wrote:
>> Today users have no easy way to correlate kernel log messages for
>> storage devices across reboots, device dynamic add/remove, or when
>> the device is physically or logically moved from from system to
>> system.  This is due to the existing log IDs which identify how the
>> device is attached and not a unique ID of what is
>> attached.  Additionally, even when the attachment hasn't changed,
>> it's not always obvious which messages belong to the device as the
>> different areas in the storage stack use different identifiers, eg.
>> (sda, sata1.00, sd 0:0:0:0).
>>
>> This change addresses this by adding a unique ID to each log
>> message.  It couples the existing structured key/value logging
>> capability and VPD 0x83 device identification.
> 
> I understand why, and using the best VPD identifier we have seems fine.
>  However, we're trying to dump printk in favour of dev_printk and its
> ilk, so resurrecting printk_emit instead of using dev_printk_emit looks
> a bit retrograde.  It does seem that ata_dev_printk should really be
> using dev_printk ... not sure about the block case.

I'll re-work the patch series to move towards dev_printk_emit.


Thanks
-Tony

