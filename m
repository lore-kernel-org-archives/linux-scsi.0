Return-Path: <SRS0=Uiav=5Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32642C2D0EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 19:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1972F212CC
	for <linux-scsi@archiver.kernel.org>; Tue, 31 Mar 2020 19:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728189AbgCaTHm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 Mar 2020 15:07:42 -0400
Received: from mx.sdf.org ([205.166.94.20]:55263 "EHLO mx.sdf.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726315AbgCaTHm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 31 Mar 2020 15:07:42 -0400
Received: from sdf.org (IDENT:lkml@sdf.lonestar.org [205.166.94.16])
        by mx.sdf.org (8.15.2/8.14.5) with ESMTPS id 02VJ4nq9017121
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits) verified NO);
        Tue, 31 Mar 2020 19:04:49 GMT
Received: (from lkml@localhost)
        by sdf.org (8.15.2/8.12.8/Submit) id 02VJ4nMt026853;
        Tue, 31 Mar 2020 19:04:49 GMT
Date:   Tue, 31 Mar 2020 19:04:48 +0000
From:   George Spelvin <lkml@SDF.ORG>
To:     Benjamin Block <bblock@linux.ibm.com>,
        Steffen Maier <maier@linux.ibm.com>
Cc:     linux-kernel@vger.kernel.org,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Vasily Gorbik <gor@linux.ibm.com>,
        Christian Borntraeger <borntraeger@de.ibm.com>,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        lkml@sdf.org
Subject: Re: [RFC PATCH v1 27/50] drivers/s390/scsi/zcsp_fc.c: Use
 prandom_u32_max() for backoff
Message-ID: <20200331190448.GB9912@SDF.ORG>
References: <202003281643.02SGhHN7015213@sdf.org>
 <20200331161321.GB17507@t480-pf1aa2c2>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200331161321.GB17507@t480-pf1aa2c2>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Mar 31, 2020 at 06:13:21PM +0200, Benjamin Block wrote:
> it would be nice, if you could address the mails to the
> driver-maintainers (`scripts/get_maintainer.pl drivers/s390/scsi/zfcp_fc.c`
> will tell you that this is me and Steffen); I'd certainly have noticed
> it earlier then :-).

How the $%$# did I mess that up?  I know choosing recipients for
this series was mostly manual, becase it didn't fit the usual
pattern of the entire series going to everyone affectrd by any part
of it.

And then there waqs a whole lot of shuffling things into a logical
order and grouping.

But I checked MAINTAINERS originally, I really did.  :-(

> On Fri, Nov 29, 2019 at 03:39:41PM -0500, George Spelvin wrote:
>> diff --git a/drivers/s390/scsi/zfcp_fc.c b/drivers/s390/scsi/zfcp_fc.c
>> index b018b61bd168e..d24cafe02708f 100644
>> --- a/drivers/s390/scsi/zfcp_fc.c
>> +++ b/drivers/s390/scsi/zfcp_fc.c
>> @@ -48,7 +48,7 @@ unsigned int zfcp_fc_port_scan_backoff(void)
>>  {
>>  	if (!port_scan_backoff)
>>  		return 0;
>> -	return get_random_int() % port_scan_backoff;
>> +	return prandom_u32_max(port_scan_backoff);
> 
> I think the change is fine. You are right, we don't need a crypto nonce
> here.
> 
> I think I'd let the zero-check stand as is, because the internal
> behaviour of prandom_u32_max() is, as you say, undocumented. This is not
> a performance critical code-path for us anyway.

I agree.  Sorry, that comment in the commit message was a bit of
a "not to self" that I didn't clean up.  Feel free to rm it when
queueing if you like.

> Steffen, do you have any objections? Otherwise I can queue this up -
> minus the somewhat mangled subject - for when we send something next time.

Thank you, I'll put it in my "accepted" pile.
