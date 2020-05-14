Return-Path: <SRS0=2tzU=64=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3FDCEC433E0
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:13:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 11082206D8
	for <linux-scsi@archiver.kernel.org>; Thu, 14 May 2020 17:13:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ON0dptBi"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbgENRNm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 May 2020 13:13:42 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32034 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726046AbgENRNl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 May 2020 13:13:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589476420;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=17vA0t2A0VufftgPHG98AzkbBCXMEeGxLNVaC7AH6Kg=;
        b=ON0dptBiQ4GlJWEmIga+9qkGwfYnlA+5rhEcp3C6iLvPtg63qhjEaOYnEoaT0k696fpDqn
        e+f/f+VVAb18rnRmZXOsTpoxhwLSBAPjltxqk7/OVnFDNioA+uSZ9W6swd/QcziHCQJb3P
        1v847IWyL5Tfwdt/ADDtbRhse7HWXEc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-174-B35y9vzcMtKwtbIlPsTPDw-1; Thu, 14 May 2020 13:13:38 -0400
X-MC-Unique: B35y9vzcMtKwtbIlPsTPDw-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id E95BD80183C;
        Thu, 14 May 2020 17:13:37 +0000 (UTC)
Received: from [10.3.128.23] (unknown [10.3.128.23])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2C0761002395;
        Thu, 14 May 2020 17:13:36 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v2 7/7] nvme: Add durable name for dev_printk
To:     Keith Busch <kbusch@kernel.org>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org
References: <20200513213621.470411-1-tasleson@redhat.com>
 <20200513213621.470411-8-tasleson@redhat.com>
 <20200513230455.GA1503@redsun51.ssa.fujisawa.hgst.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <5e2dc4ab-c97d-030d-7640-9b2c52ccc91e@redhat.com>
Date:   Thu, 14 May 2020 12:13:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200513230455.GA1503@redsun51.ssa.fujisawa.hgst.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/13/20 6:04 PM, Keith Busch wrote:
> On Wed, May 13, 2020 at 04:36:21PM -0500, Tony Asleson wrote:
>> +static int dev_to_nvme_durable_name(const struct device *dev, char *buf, size_t len)
>> +{
>> +	char serial[128];
>> +	ssize_t serial_len = wwid_show((struct device *)dev, NULL, serial);
> 
> wwid_show() can generate a serial larger than 128 bytes.

Looking at this again

return sprintf(buf, "nvme.%04x-%*phN-%*phN-%08x\n", 	
    subsys->vendor_id,
    serial_len, subsys->serial,
    model_len, subsys->model,
    subsys->ns_id);

'nvme.' = 5
vendor_id = 4
'-' = 1
serial (20 * 2) = 40
'-' = 1
model (40 * 2) = 80
'-' = 1
ns_id = 8
'\n' = 1

5 + 4 + 1 + 40 + 1 + 80 + 1 + 8 + 1 = 141

Does this match your understanding?

My mistake was thinking each byte of SN and Model = 1 character in
output, instead of 2.

This will also require the buffer used in dev_vprintk_emit to be quite a
bit bigger to accommodate max size.

>> +
>> +	if (serial_len > 0 && serial_len < len) {
>> +		serial_len -= 1;  // Remove the '\n' from the string
> 
> Comments in this driver should use the /* */ style.

OK, will revise.

> 
>> +		strncpy(buf, serial, serial_len);
>> +		return serial_len;
>> +	}
>> +	return 0;
>> +}
> 

Thanks
-Tony

