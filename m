Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6403DC00528
	for <linux-scsi@archiver.kernel.org>; Tue, 25 Jul 2023 17:28:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231539AbjGYR2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 25 Jul 2023 13:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231511AbjGYR23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Jul 2023 13:28:29 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1E5CE3
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2023 10:27:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1690306063;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=/+/nqT6fQIVWmc2UMyym2/MQImAiAAqOHD7/JM8jKDc=;
        b=AzPYh7M8Uh3Z1/OM83Pw6SQKqhACnIAm8hvlpCbzVJj/qmMDrCtDECTEekkBpUkI8gFLBC
        Ew7B5mmoGcb0ePWJ8MAdp+NHuLgE8xo9m1Q0JBW/q92WO2FcggjRdH0wvkT73d3bQM5A6U
        oj20gr3Ulc7A+N78ABTnlrqJo3JRAiE=
Received: from mimecast-mx02.redhat.com (66.187.233.73 [66.187.233.73]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-462-RHfb8bl_MICdb88O3e95xQ-1; Tue, 25 Jul 2023 13:27:38 -0400
X-MC-Unique: RHfb8bl_MICdb88O3e95xQ-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id D3E9D29A9D28;
        Tue, 25 Jul 2023 17:27:37 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.250])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 8E2A9492C13;
        Tue, 25 Jul 2023 17:27:36 +0000 (UTC)
Date:   Tue, 25 Jul 2023 10:27:34 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     ketan.mukadam@broadcom.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: be2iscsi: Add length check when parsing nlattrs
Message-ID: <ZMAGBrszXmlCMomv@rhel-developer-toolbox-latest>
References: <20230723075938.3713864-1-linma@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230723075938.3713864-1-linma@zju.edu.cn>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.10
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, Jul 23, 2023 at 03:59:38PM +0800, Lin Ma wrote:
> beiscsi_iface_set_param parses nlattr with nla_for_each_attr and assumes
> every attributes can be viewed as struct iscsi_iface_param_info.
> 
> This is not true because there is no any nla_policy to validate the
> attributes passed from the upper function iscsi_set_iface_params.
> 
> This patch adds the nla_len check before accessing the nlattr data and
> error return EINVAL if the length check fails.

Reviewed-by: Chris Leech <cleech@redhat.com>

