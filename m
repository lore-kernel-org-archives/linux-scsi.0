Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 561FFC4332F
	for <linux-scsi@archiver.kernel.org>; Sat, 28 Oct 2023 19:38:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbjJ1TiH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 28 Oct 2023 15:38:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229446AbjJ1TiD (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 28 Oct 2023 15:38:03 -0400
X-Greylist: delayed 301 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sat, 28 Oct 2023 12:38:00 PDT
Received: from rs227.mailgun.us (rs227.mailgun.us [209.61.151.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F3A5E0
        for <linux-scsi@vger.kernel.org>; Sat, 28 Oct 2023 12:37:59 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1698521879; x=1698529079; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Subject: Cc: To: To: From: From: Date:
 Sender: Sender; bh=QpCO1QyuJaAC5PC83erH8OzlntE7Ib+SBP/9JsGIOdU=;
 b=RyRi1L8YV4voHNNvygx8lmSvTKneaJX/AUti4fYE0W/yb8SuI2kqWMfXgsamLjsghm67T9Gupwbcqw+K/HMBy/sd4143+zaA730bbt2AcnvcVzc4IHHtK9H4zX2AzlL83Rwv4cYRdvcMxeGfwFnxlMRx09mNWzmJCcbPPaYYWFh/xf6PEECKPejSXxD1uI11DBNPCIaXd/SnM6F+ilUP1c0FajNHuuyeHUlV3JYK21cZMfps2nRpWKhxzIlrvtydBfhJViQLIJ74eRr1J94VwZ7Wa8YYLqwPknaM0SBzfVHvRY8IUjS9SZcDaNdKKwT+OQdSiIyo/HSGRALJ12wEYg==
X-Mailgun-Sending-Ip: 209.61.151.227
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by 60615d1b0698 with SMTP id
 653d61ea0459d77ac9eb68a1 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 28 Oct 2023 19:32:58 GMT
Sender: james@equiv.tech
Date:   Sat, 28 Oct 2023 12:32:57 -0700
From:   James Seo <james@equiv.tech>
To:     Kees Cook <keescook@chromium.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Borislav Petkov <bp@alien8.de>,
        Ranjan Kumar <ranjan.kumar@broadcom.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 00/12] scsi: mpt3sas: Use flexible arrays and do a few
 cleanups
Message-ID: <ZT1h6UIi2y2UwpdJ@equiv.tech>
References: <20230806170604.16143-1-james@equiv.tech>
 <yq1edjr25ed.fsf@ca-mkp.ca.oracle.com>
 <202310101748.5E39C3A@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202310101748.5E39C3A@keescook>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 10, 2023 at 05:49:38PM -0700, Kees Cook wrote:
> On Thu, Aug 24, 2023 at 11:00:57PM -0400, Martin K. Petersen wrote:
>> 
>>> Commit df8fc4e934c1 ("kbuild: Enable -fstrict-flex-arrays=3") has
>>> resulted in the only arrays that UBSAN_BOUNDS considers unbounded
>>> being trailing arrays declared with [] as the last member of a struct.
>>> Unbounded trailing arrays declared with [1] are common in mpt3sas,
>>> which is causing spurious warnings to appear in some situations, e.g.
>>> when more than one physical disk is connected:
>> 
>> Broadcom: Please review/test. Thanks!
> 
> Another thread ping. Is anyone at broadcom around? I'd really like to
> see this series (or some form of it) land to avoid all these runtime
> warnings...
> 
> -- 
> Kees Cook

Looks like this series was accepted for -rc1. Thanks!

One last thread ping for the Broadcom folks, just in case.

-James Seo
