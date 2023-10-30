Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3697EC4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Oct 2023 08:14:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232021AbjJ3IOM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Oct 2023 04:14:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231945AbjJ3IOK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Oct 2023 04:14:10 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89CADA7
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 01:13:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1698653603;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=GkiKj1jauf9zRbsX1Urm2T9lRA/sSi8T6WmKDRj6T9Y=;
        b=frA2A93WpYxmFp7bNb0kzHmCDC4x3i+d34UHaK7mwiBA/N39n+Vv8NtjfWGDt7ReKmVVUw
        jSkpRSDRzFlSfIHXRPXtFAvBsY1reKepCjQTTelZXDIDShPdq1kutUSrOJSDtFYnmm2U/h
        9gEhvzstNcXpsRDj3mugapIcSbjIGTU=
Received: from mail-pg1-f198.google.com (mail-pg1-f198.google.com
 [209.85.215.198]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-77-6G5eZKNjONSJZCj5N7AtEg-1; Mon, 30 Oct 2023 04:13:22 -0400
X-MC-Unique: 6G5eZKNjONSJZCj5N7AtEg-1
Received: by mail-pg1-f198.google.com with SMTP id 41be03b00d2f7-5b84087a514so3054607a12.1
        for <linux-scsi@vger.kernel.org>; Mon, 30 Oct 2023 01:13:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698653601; x=1699258401;
        h=content-transfer-encoding:mime-version:references:in-reply-to:from
         :subject:cc:to:message-id:date:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to;
        bh=GkiKj1jauf9zRbsX1Urm2T9lRA/sSi8T6WmKDRj6T9Y=;
        b=Fb/YjVhxkTeRcU1HeTlrA/rVDekhptT+xiQossZgBNayqybfZgQXBj+kkeVFMqn6hx
         seWdUlDhKvbm6xoRB7/j1JPZHhUl/2+JQD7QgNE74VBSn6jAvwiQz5vSaeR+rycPR4wW
         YdFwGIzmi+ZLJNJ9zwWApXGSRLKGTNXhmAi/pJ+xQbTLujZH8fcs/JIjUpPQAK7s6tN6
         VkH81xbNsfpXoOKqw7g8dUwCBv9I9eNG/JDuIAGbpUIfPU04JOmyKE/56QPxINlefR7b
         625yjpmZWiKf50O49xNJQiPatsRMmsV+Okj9xqQL1aEEJWsQInoxmTWRqqEpsNDcLFi5
         GVkQ==
X-Gm-Message-State: AOJu0YwPNHvssjo9dKIgdpi3LRnmR1O6BtZ76Xbu2nk2KaP4WeRhohzx
        b0pmzj4DHOWxFPnb0na04iy5p0Rj7J+FIenRjHSFH7zF08cUHBfwYA+CC19jjswyav2ng3cuW/a
        uvV9HK2Ixx3z4MYVSr4eDzw==
X-Received: by 2002:a17:90a:f0c2:b0:280:299d:4b7e with SMTP id fa2-20020a17090af0c200b00280299d4b7emr6575315pjb.19.1698653600957;
        Mon, 30 Oct 2023 01:13:20 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEqce2/5NZQf6iAi2Uf6f0oJTQ/TXEEysV28rfkITtohtcF5KBqwdmCQ0aXHPJiiXnKVMO50Q==
X-Received: by 2002:a17:90a:f0c2:b0:280:299d:4b7e with SMTP id fa2-20020a17090af0c200b00280299d4b7emr6575304pjb.19.1698653600651;
        Mon, 30 Oct 2023 01:13:20 -0700 (PDT)
Received: from localhost ([240d:1a:c0d:9f00:91ec:2f0b:ae2b:204a])
        by smtp.gmail.com with ESMTPSA id s31-20020a17090a2f2200b0028017a2a8fasm4552505pjd.3.2023.10.30.01.13.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 30 Oct 2023 01:13:20 -0700 (PDT)
Date:   Mon, 30 Oct 2023 17:13:17 +0900 (JST)
Message-Id: <20231030.171317.1096475355592607869.syoshida@redhat.com>
To:     bvanassche@acm.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: sr: Fix a potential uninit-value in
 sr_get_events()
From:   Shigeru Yoshida <syoshida@redhat.com>
In-Reply-To: <c459dd2c-a281-7fc4-90cf-36a71e9548bc@acm.org>
References: <20230531164346.118438-1-syoshida@redhat.com>
        <c459dd2c-a281-7fc4-90cf-36a71e9548bc@acm.org>
X-Mailer: Mew version 6.9 on Emacs 28.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 31 May 2023 15:44:17 -0700, Bart Van Assche wrote:
> On 5/31/23 09:43, Shigeru Yoshida wrote:
>> diff --git a/drivers/scsi/sr.c b/drivers/scsi/sr.c
>> index 12869e6d4ebd..86b43c069a44 100644
>> --- a/drivers/scsi/sr.c
>> +++ b/drivers/scsi/sr.c
>> @@ -177,10 +177,13 @@ static unsigned int sr_get_events(struct
>> scsi_device *sdev)
>>     	result = scsi_execute_cmd(sdev, cmd, REQ_OP_DRV_IN, buf, sizeof(buf),
>>   				  SR_TIMEOUT, MAX_RETRIES, &exec_args);
>> +	if (result)
>> +		return 0;
>> +
>>   	if (scsi_sense_valid(&sshdr) && sshdr.sense_key == UNIT_ATTENTION)
>>   		return DISK_EVENT_MEDIA_CHANGE;
>>   -	if (result || be16_to_cpu(eh->data_len) < sizeof(*med))
>> +	if (be16_to_cpu(eh->data_len) < sizeof(*med))
>>   		return 0;
> 
> I think this change is wrong because it introduces an unintended
> behavior
> change. A better solution is probably to zero-initialize sshdr before
> scsi_execute_cmd() is called.

Hi Bart,

I'm very sorry for the very late response, and thank you so much for
your feedback. I'll prepare the v2 patch as you suggested.

Thanks,
Shigeru

> 
> Thanks,
> 
> Bart.
> 

