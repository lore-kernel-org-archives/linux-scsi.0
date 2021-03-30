Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8A872C433E1
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 10:57:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CD12619A7
	for <linux-scsi@archiver.kernel.org>; Tue, 30 Mar 2021 10:57:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231852AbhC3K5E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 30 Mar 2021 06:57:04 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:20321 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231827AbhC3K44 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 30 Mar 2021 06:56:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1617101815;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rYqzNHiuAl/aoLjb89NUxhkCMXfILPBrl172tqHnnHE=;
        b=CNfyjNv8F23LnMAJNDnUNFKhwn/+7qb3AMe4+LBSVke3MjdtxoflURxkmkRK1pxz29h/wa
        vnfIkHKNay0CZroZ6iXTvyo6Xn63R2rHoOCxuLAkmRYilhPRBTOBrNjn4OI/wGtZljeK1R
        LcBsMTqOVdAh6cAaCzlQRs3q0Qh8TMU=
Received: from mail-ej1-f70.google.com (mail-ej1-f70.google.com
 [209.85.218.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-463-44RPSvlQNMeS_9LckLvCew-1; Tue, 30 Mar 2021 06:56:53 -0400
X-MC-Unique: 44RPSvlQNMeS_9LckLvCew-1
Received: by mail-ej1-f70.google.com with SMTP id d6so6985604ejd.15
        for <linux-scsi@vger.kernel.org>; Tue, 30 Mar 2021 03:56:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rYqzNHiuAl/aoLjb89NUxhkCMXfILPBrl172tqHnnHE=;
        b=j92YCTl+1yo3RfgYiOQ5SI3f7VrmsXQ+UtTsF5LBAd2Tc+VTBO8NIGx8mX8B/ewY6B
         3hn2ubCXM/x17AZ+035q+gCTopjKRbpgnBk5u4W9RLhXTGM1Z3WhSCPCF616DBQXjiLM
         fi3Xrz/4skATr8+XWQo7IvKNz4ZGLQN5mO2nk1f/XG/n5cXxyxZh7q/MtxWSGSSej3B4
         nYF00kepX9sVt8hyHuS68Nn0U66dossiZJqqxxDbdBjtfdNF0+5Osnhr7S0MhWeL3bl6
         iVjLNCW0sSNb62SUat2345h1aXNLCLL8O0eYj/TNI0/4XaoJJ2GtjMokxrEgSrZROyb8
         6KAQ==
X-Gm-Message-State: AOAM530cl1a4fDLAqXyFWeYi5mKv3Qnli/JSD5IlZTAI4JAGyzNFnoPV
        Tv7cIHHQnK8hcIBeAT6+Y835WvXZNKYWJTrQLy7tbvu2hNK1MTbEjFaQ3eG1UtmvB3Y3DGK94Rk
        yMDbTDHngqtMYOrl1yCn7Lg==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr32945880edd.283.1617101812709;
        Tue, 30 Mar 2021 03:56:52 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxk85EwNcCIjfgTHncBkIRpyvOFJP73cc6LgtyJnG141Ecwyc7yx0+jNJ7jYIvKmaPJ/RYKmg==
X-Received: by 2002:a05:6402:270e:: with SMTP id y14mr32945855edd.283.1617101812562;
        Tue, 30 Mar 2021 03:56:52 -0700 (PDT)
Received: from x1.localdomain (2001-1c00-0c1e-bf00-1054-9d19-e0f0-8214.cable.dynamic.v6.ziggo.nl. [2001:1c00:c1e:bf00:1054:9d19:e0f0:8214])
        by smtp.gmail.com with ESMTPSA id gq9sm5631143ejb.62.2021.03.30.03.56.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Mar 2021 03:56:52 -0700 (PDT)
Subject: Re: [PATCH 11/11] [RFC] drm/i915/dp: fix array overflow warning
To:     Arnd Bergmann <arnd@kernel.org>, linux-kernel@vger.kernel.org,
        Martin Sebor <msebor@gcc.gnu.org>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        David Airlie <airlied@linux.ie>,
        Daniel Vetter <daniel@ffwll.ch>, imre.deak@intel.com
Cc:     Arnd Bergmann <arnd@arndb.de>, x86@kernel.org,
        Ning Sun <ning.sun@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        Simon Kelley <simon@thekelleys.org.uk>,
        James Smart <james.smart@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Anders Larsen <al@alarsen.net>, Tejun Heo <tj@kernel.org>,
        Serge Hallyn <serge@hallyn.com>,
        Imre Deak <imre.deak@intel.com>,
        linux-arm-kernel@lists.infradead.org,
        tboot-devel@lists.sourceforge.net, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, ath11k@lists.infradead.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org, cgroups@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        =?UTF-8?B?VmlsbGUgU3lyasOkbMOk?= <ville.syrjala@linux.intel.com>,
        Manasi Navare <manasi.d.navare@intel.com>,
        Uma Shankar <uma.shankar@intel.com>,
        Ankit Nautiyal <ankit.k.nautiyal@intel.com>,
        Gwan-gyeong Mun <gwan-gyeong.mun@intel.com>,
        Animesh Manna <animesh.manna@intel.com>,
        Sean Paul <seanpaul@chromium.org>
References: <20210322160253.4032422-1-arnd@kernel.org>
 <20210322160253.4032422-12-arnd@kernel.org>
From:   Hans de Goede <hdegoede@redhat.com>
Message-ID: <949db606-ac48-69ae-b0f7-b1cba6fc2d7f@redhat.com>
Date:   Tue, 30 Mar 2021 12:56:51 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20210322160253.4032422-12-arnd@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi,

On 3/22/21 5:02 PM, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> gcc-11 warns that intel_dp_check_mst_status() has a local array of
> fourteen bytes and passes the last four bytes into a function that
> expects a six-byte array:
> 
> drivers/gpu/drm/i915/display/intel_dp.c: In function ‘intel_dp_check_mst_status’:
> drivers/gpu/drm/i915/display/intel_dp.c:4556:22: error: ‘drm_dp_channel_eq_ok’ reading 6 bytes from a region of size 4 [-Werror=stringop-overread]
>  4556 |                     !drm_dp_channel_eq_ok(&esi[10], intel_dp->lane_count)) {
>       |                      ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> drivers/gpu/drm/i915/display/intel_dp.c:4556:22: note: referencing argument 1 of type ‘const u8 *’ {aka ‘const unsigned char *’}
> In file included from drivers/gpu/drm/i915/display/intel_dp.c:38:
> include/drm/drm_dp_helper.h:1459:6: note: in a call to function ‘drm_dp_channel_eq_ok’
>  1459 | bool drm_dp_channel_eq_ok(const u8 link_status[DP_LINK_STATUS_SIZE],
>       |      ^~~~~~~~~~~~~~~~~~~~
> 
> Clearly something is wrong here, but I can't quite figure out what.
> Changing the array size to 16 bytes avoids the warning, but is
> probably the wrong solution here.

The drm displayport-helpers indeed expect a 6 bytes buffer, but they
usually only consume 4 bytes.

I don't think that changing the DP_DPRX_ESI_LEN is a good fix here,
since it is used in multiple places, but the esi array already gets
zero-ed out by its initializer, so we can just pass 2 extra 0 bytes
to give drm_dp_channel_eq_ok() call the 6 byte buffer its prototype
specifies by doing this:

diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
index 897711d9d7d3..147962d4ad06 100644
--- a/drivers/gpu/drm/i915/display/intel_dp.c
+++ b/drivers/gpu/drm/i915/display/intel_dp.c
@@ -4538,7 +4538,11 @@ intel_dp_check_mst_status(struct intel_dp *intel_dp)
 	drm_WARN_ON_ONCE(&i915->drm, intel_dp->active_mst_links < 0);
 
 	for (;;) {
-		u8 esi[DP_DPRX_ESI_LEN] = {};
+		/*
+		 * drm_dp_channel_eq_ok() expects a 6 byte large buffer, but
+		 * the ESI info only contains 4 bytes, pass 2 extra 0 bytes.
+		 */
+		u8 esi[DP_DPRX_ESI_LEN + 2] = {};
 		bool handled;
 		int retry;
 

So i915 devs, would such a fix be acceptable ?

Regards,

Hans






> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/gpu/drm/i915/display/intel_dp.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/gpu/drm/i915/display/intel_dp.c b/drivers/gpu/drm/i915/display/intel_dp.c
> index 8c12d5375607..830e2515f119 100644
> --- a/drivers/gpu/drm/i915/display/intel_dp.c
> +++ b/drivers/gpu/drm/i915/display/intel_dp.c
> @@ -65,7 +65,7 @@
>  #include "intel_vdsc.h"
>  #include "intel_vrr.h"
>  
> -#define DP_DPRX_ESI_LEN 14
> +#define DP_DPRX_ESI_LEN 16
>  
>  /* DP DSC throughput values used for slice count calculations KPixels/s */
>  #define DP_DSC_PEAK_PIXEL_RATE			2720000
> 

