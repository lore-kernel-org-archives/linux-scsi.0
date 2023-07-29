Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99D70C0015E
	for <linux-scsi@archiver.kernel.org>; Sat, 29 Jul 2023 08:09:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230176AbjG2IJH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 29 Jul 2023 04:09:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57234 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbjG2IJG (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 29 Jul 2023 04:09:06 -0400
Received: from so254-32.mailgun.net (so254-32.mailgun.net [198.61.254.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C96C53C30
        for <linux-scsi@vger.kernel.org>; Sat, 29 Jul 2023 01:09:04 -0700 (PDT)
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=equiv.tech; q=dns/txt;
 s=mx; t=1690618142; x=1690625342; h=In-Reply-To: Content-Type: MIME-Version:
 References: Message-ID: Subject: Subject: Cc: To: To: From: From: Date:
 Sender: Sender; bh=CozDmRp1bkHwGB5inh5kVVb5HQMFeVPssjH7f8Z8xA4=;
 b=kk3swVL/l0Lw/AEpHNjjSxaaGjsIo7yq2oqP+b6+UqyTljPcXJnBbuqFBbNwJZSipV2rVnDPWJ5MTfFiWgyIJYfekCGDUYfQ+5bTf4im0nxHzfOZbyrlGJZNSo8qoJtH+10kLU4rcD1PzoVdz3MRHw+6l2kbQZSxkW6PUyapRmFF6cI7ZNM5I6c3hjOz3cCSCwYbjvdfM49FzDd6lzL1Pwp8ih2sG5tzzBAj9cJlX1Vx3q6w3gcJOfrHbLQ3c40021uWlM+1NPHhqjlenSgVlH9zE/hJ9AkUwY6S9oD6coR4le0IYCuxtoMi9jJTYSWUWHeNLzdqkwINLnHVljxpRQ==
X-Mailgun-Sending-Ip: 198.61.254.32
X-Mailgun-Sid: WyI0OWM5MyIsImxpbnV4LXNjc2lAdmdlci5rZXJuZWwub3JnIiwiOTNkNWFiIl0=
Received: from mail.equiv.tech (equiv.tech [142.93.28.83]) by dab6b325100a with SMTP id
 64c4c91e13929ab6cba6da30 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sat, 29 Jul 2023 08:09:02 GMT
Sender: james@equiv.tech
Date:   Sat, 29 Jul 2023 01:09:01 -0700
From:   James Seo <james@equiv.tech>
To:     Kees Cook <keescook@chromium.org>
Cc:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] scsi: mpt3sas: Use flexible arrays when less
 obviously possible
Message-ID: <ZMTJHZLu7szzsx1s@equiv.tech>
References: <20230725161331.27481-1-james@equiv.tech>
 <20230725161331.27481-3-james@equiv.tech>
 <202307281508.32604C856@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <202307281508.32604C856@keescook>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi, thanks for reviewing.

On Fri, Jul 28, 2023 at 03:26:57PM -0700, Kees Cook wrote:
> Doing build comparisons here, I see a lot of binary changes. They may
> be, as you say, harmless, and since you've actually got hardware then
> this is a good verification of the changes, but I do wonder if this
> needs more detailed commit log (or split up patches).
> 
> However, the problem I see is that this code was already doing weird
> stuff with structs that appear to not have been using flex arrays
> actually. With "pahole" I can see struct MPT3SAS_ADAPTER changes:
> 
> -       Mpi2IOUnitPage8_t          iounit_pg8;           /*  3668    40 */
> -       Mpi2IOCPage1_t             ioc_pg1_copy;         /*  3708    24 */
> +       Mpi2IOUnitPage8_t          iounit_pg8;           /*  3668    16 */
> +       Mpi2IOCPage1_t             ioc_pg1_copy;         /*  3684    24 */
> 
> struct _MPI2_CONFIG_PAGE_IO_UNIT_8 (Mpi2IOUnitPage8_t) is in the
> _middle_ of struct MPT3SAS_ADAPTER.... :|

In this particular case, the flex array member of iounit_pg8 is never
used, and iounit_pg8 itself is never used outside of the function
that fetches and sets it on the per-adapter struct MPT3SAS_ADAPTER.

iounit_pg8 could probably be removed, now that I think about it.
Maybe I will.

> In the earlier attempts at this conversion, it seemed that some of these
> are actually fixed-size:
> 
> https://lore.kernel.org/lkml/20210202235118.GA314410@embeddedor/

Yes, I tried to leave such terminal arrays alone. But I'll revisit
each change in this commit.

> I think this patch needs to be broken up into per-struct changes, so
> they can be reviewed individually.

Sure, I can do that. I'll resubmit this commit and the one following
(which depends on this commit) as a new series with more details.
Hopefully this will encourage the Broadcom folks who know this driver
best to chime in as well.

By the way, I noticed you've done something like this in the past to
preserve struct size for userspace, just in case:

	/* MPI2_IOUNIT8_SENSOR		Sensor[1]; */
	union {
		MPI2_IOUNIT8_SENSOR	_LegacyPadding;
		__DECLARE_FLEX_ARRAY(MPI2_IOUNIT8_SENSOR, Sensor);
	};

I don't think userspace is a concern for us here, but would you be
more comfortable if I did this too/instead?

James
