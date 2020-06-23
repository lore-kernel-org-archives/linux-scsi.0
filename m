Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 28548C433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 21:11:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F05D520706
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 21:11:58 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L/QXO8h3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403827AbgFWVLw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 17:11:52 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:58448 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2390197AbgFWUcI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 16:32:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592944327;
        h=from:from:reply-to:reply-to:subject:subject:date:date:
         message-id:message-id:to:to:cc:mime-version:mime-version:
         content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZNhU0Jw+QDG73Ku9z9a1ysMcjkSuO17wWVzu44xt7kY=;
        b=L/QXO8h3+KK7aF+PwmptBzbNyppU1IihO1kgRSn3+GW29ElS2JHNTRPSuPdBDALbGc3gQH
        c2ZGwY61/1R2Nl/jQ8Pf0qLHimaDU62gr4Y3Hvdl3TqqNBbc05iRq+CvFGYx2TM1Ixg5hJ
        LNY/yoFhAHW/UynR9gAA1H293Hd434M=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-lWNS7emhOgyaztWH1OZ89w-1; Tue, 23 Jun 2020 16:32:05 -0400
X-MC-Unique: lWNS7emhOgyaztWH1OZ89w-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id B0599106F731;
        Tue, 23 Jun 2020 20:32:04 +0000 (UTC)
Received: from [10.3.128.20] (unknown [10.3.128.20])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C2C997930B;
        Tue, 23 Jun 2020 20:32:03 +0000 (UTC)
Reply-To: tasleson@redhat.com
Subject: Re: [RFC PATCH v3 7/8] nvme: Add durable name for dev_printk
To:     Chaitanya Kulkarni <Chaitanya.Kulkarni@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>
References: <20200623191749.115200-1-tasleson@redhat.com>
 <20200623191749.115200-8-tasleson@redhat.com>
 <BYAPR04MB496553DF4EB78924AAEC1F2B86940@BYAPR04MB4965.namprd04.prod.outlook.com>
From:   Tony Asleson <tasleson@redhat.com>
Organization: Red Hat
Message-ID: <afad0484-17fe-d206-33a0-2d473dd68232@redhat.com>
Date:   Tue, 23 Jun 2020 15:32:02 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <BYAPR04MB496553DF4EB78924AAEC1F2B86940@BYAPR04MB4965.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/20 3:04 PM, Chaitanya Kulkarni wrote:
> On 6/23/20 12:18 PM, Tony Asleson wrote:
>> Corrections from Keith Busch review comments.
>>
>> Signed-off-by: Tony Asleson<tasleson@redhat.com>
>> ---
>>   drivers/nvme/host/core.c | 18 ++++++++++++++++++
>>   1 file changed, 18 insertions(+)
> This looks useful me, but why you still have an RFC fag ?

I have some questions in the cover letter that I was thinking should be
discussed before removing RFC, but maybe I'm going about this the wrong
way and should remove that?

