Return-Path: <SRS0=wipa=CQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DD641C433E2
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 21:12:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 92B88215A4
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Sep 2020 21:12:34 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="iCX+XewK"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727789AbgIGVMe (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Sep 2020 17:12:34 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:37443 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726458AbgIGVMc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Sep 2020 17:12:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1599513151;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=IE54TnU5IbphO8Yd4KS+xxs9B4v4FaBOwqs4+qvR78I=;
        b=iCX+XewKazW+qwe25wof9WsccVOUzHdPCOnGrdRzLkFTfCkyg0mrA7U4rlEQQGJNr+XCkr
        mExiqmS5JvvAz4G4cWqXQzltt49vZZmMWU5EhCzTnXPj3W7ZnI3x+AlkbUfbpHt5HY7RNr
        PvWrVKa8L82DzhphNwfoq0dJUdJ6FaM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-482-JIz988JPNQygyJTxr1UkXw-1; Mon, 07 Sep 2020 17:12:29 -0400
X-MC-Unique: JIz988JPNQygyJTxr1UkXw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id CA4D8802B5E;
        Mon,  7 Sep 2020 21:12:28 +0000 (UTC)
Received: from localhost.localdomain (unknown [10.40.194.205])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 4771260BE2;
        Mon,  7 Sep 2020 21:12:28 +0000 (UTC)
Subject: Re: [PATCH] scsi: take module reference during async scan
To:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org
References: <20200907154745.20145-1-thenzl@redhat.com>
 <8dbf8936-0b56-b3c3-c62e-657bd2c931c8@acm.org>
From:   Tomas Henzl <thenzl@redhat.com>
Message-ID: <d9b5672c-0265-8275-74df-ce1193730b6d@redhat.com>
Date:   Mon, 7 Sep 2020 23:12:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <8dbf8936-0b56-b3c3-c62e-657bd2c931c8@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/7/20 6:57 PM, Bart Van Assche wrote:
> On 2020-09-07 08:47, Tomas Henzl wrote:
>> During an async scan the driver shost->hostt structures are used,
>> that may cause issues when the driver is removed at that time.
>> As protection take the module reference.
>>
>> Signed-off-by: Tomas Henzl <thenzl@redhat.com>
>> ---
>>  drivers/scsi/scsi_scan.c | 8 ++++++++
>>  1 file changed, 8 insertions(+)
>>
>> diff --git a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
>> index f2437a757..c9cc0862c 100644
>> --- a/drivers/scsi/scsi_scan.c
>> +++ b/drivers/scsi/scsi_scan.c
>> @@ -1825,6 +1825,8 @@ static void do_scan_async(void *_data, async_cookie_t c)
>>  
>>  	do_scsi_scan_host(shost);
>>  	scsi_finish_async_scan(data);
>> +
>> +	module_put(shost->hostt->module);
>>  }
>>  
>>  /**
>> @@ -1848,6 +1850,12 @@ void scsi_scan_host(struct Scsi_Host *shost)
>>  		return;
>>  	}
>>  
>> +	/* protection against surprise driver removal
>> +	 * module_put is called from do_scan_async
>> +	 */
>> +	if (!try_module_get(shost->hostt->module))
>> +		return;
>> +
>>  	/* register with the async subsystem so wait_for_device_probe()
>>  	 * will flush this work
>>  	 */
> 
> Shouldn't scsi_autopm_put_host(shost) be called if try_module_get() fails?

Thanks. Yes it should, I'll post a V2 if James agrees to this patch in
general in a parallel thread.


> 
> Please also update the following comment in scsi_scan_host():
> 
> 	/* scsi_autopm_put_host(shost) is called in scsi_finish_async_scan() */
It's late here so I'm tired and I miss something but how should I update
it ?


Thanks,
Tomas
> 
> Thanks,
> 
> Bart.
> 
> 

