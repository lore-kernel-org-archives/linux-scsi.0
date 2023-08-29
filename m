Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14EA8C83F18
	for <linux-scsi@archiver.kernel.org>; Tue, 29 Aug 2023 22:23:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237064AbjH2WXC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 29 Aug 2023 18:23:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241074AbjH2WWw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 29 Aug 2023 18:22:52 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61D501A6
        for <linux-scsi@vger.kernel.org>; Tue, 29 Aug 2023 15:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1693347718;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=PqISBsTRAs8s0SDVGqAo0GVx9lg65p3h18k5XhcvCvU=;
        b=hVgg+5jIhr0JFIqC+O+qU50a7bFJxNsCEyb3VKhaWVytfnWF2NDHve0acU2ni5PNsdjXYs
        I3mrAPOU0Z8K+ga0g4q4rymTFKypeCzNXb645BDQpQerBDZl6MPe4D/A/c1/+lwWY/3tPX
        AMl8QFfmlpwzaw0drYe6DTXHHnQ7amU=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-287-ykalpRGnOsGFrqrdfHvWmA-1; Tue, 29 Aug 2023 18:21:57 -0400
X-MC-Unique: ykalpRGnOsGFrqrdfHvWmA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id B1424805F05;
        Tue, 29 Aug 2023 22:21:56 +0000 (UTC)
Received: from [10.22.9.144] (unknown [10.22.9.144])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 6E6C91678B;
        Tue, 29 Aug 2023 22:21:56 +0000 (UTC)
Message-ID: <7fb6c8ee-6e4c-eaca-83ac-7754172be05f@redhat.com>
Date:   Tue, 29 Aug 2023 18:21:55 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH 2/2] scsi: tape: add unexpected rewind handling
Content-Language: en-US
To:     =?UTF-8?Q?Kai_M=c3=a4kisara_=28Kolumbus=29?= 
        <kai.makisara@kolumbus.fi>
Cc:     linux-scsi@vger.kernel.org, loberman@redhat.com, jhutz@cmu.edu
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
 <20230822181413.1210647-2-jmeneghi@redhat.com>
 <4C6BF678-6623-48D1-8238-37B312BCA085@kolumbus.fi>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <4C6BF678-6623-48D1-8238-37B312BCA085@kolumbus.fi>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.5
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 8/24/23 05:13, "Kai Mäkisara (Kolumbus)" wrote:
> 
> 
>> On 22. Aug 2023, at 21.14, John Meneghini <jmeneghi@redhat.com> wrote:
>>
>> Handle the unexpected condition where the tape drive reports
>> that tape is rewinding.
>>
>> ...
>> I'm providing this patch because I think it's valuable for testing
>> purposes and it should be safe. Any time the device unexpectedly
>> reports "Rewind is in progress", it should be safe to set
>> pos_unknown in the driver.
>>
> I am a bit hesitant about this, because it does not recognize if the rewind in
> progress was initiated by the user or not. In immediate mode (ST_NOWAIT
> option), a user rewind may be still in progress when a (impatient) user
> tries to do something else.

That's fine.  We can drop this patch if you are uncomfortable with it.  The real need it patch 1, which is and will affect 
customers using the AWS tape gateway.

> One possibility would be to make this conditional on !STp->immediate.
> 
> Another, perhaps better, method would be to use the STps->rw state
> variable. A new state ST_REWINDING could be introduced (or state
> should be set to ST_IDLE when rewinding).
> 
> (Looking at the state, I think it should be set to something else than
> ST_WRITING more frequently. This could, in some cases prevent
> improper automatic writing of filemarks. See, for instance, the problem
> with failing rewinds in the report with PATCH 1/2.)

Agreed. This patch was only a improvised way to run the code I needed to test in patch 1/2.

Let's leave this patch out.

Thanks,

/John

