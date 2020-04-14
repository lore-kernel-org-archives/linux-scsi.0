Return-Path: <SRS0=dx4r=56=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 60DADC2BB1D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:28:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 401E92072D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Apr 2020 05:28:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="ZHMemlNq"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405523AbgDNF2q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Apr 2020 01:28:46 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:48488 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2405521AbgDNF2n (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Apr 2020 01:28:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586842122;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jzE20HMyNJxZ83FoxUA7Hr1483JHWW3IHwMw4o8I0Vg=;
        b=ZHMemlNq3xz0SLhz/tARrt+MUo1y5FCZ2ZbgT9PRy/NkSa/7/SBqHjWX6usCma8YT7E3AA
        hWzQ5oIxKNLPQOZHPbZ1HTlQ5OfXahW08Quot13lAKAZ+78lfg3i7//QlVCM7J+Aojqac0
        Q+mYhf6YjLVAW/pGnbOi2PNVHvnMLsA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-62-UXU98LYVPUWbmIBMnEhh6g-1; Tue, 14 Apr 2020 01:28:37 -0400
X-MC-Unique: UXU98LYVPUWbmIBMnEhh6g-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 97B691005510;
        Tue, 14 Apr 2020 05:28:36 +0000 (UTC)
Received: from [10.10.112.105] (ovpn-112-105.rdu2.redhat.com [10.10.112.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id F273196B93;
        Tue, 14 Apr 2020 05:28:35 +0000 (UTC)
Subject: Re: [RFC PATCH 3/5] target: add target_setup_session sysfs support
To:     jsmart2021@gmail.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-4-mchristi@redhat.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5E954A03.7020802@redhat.com>
Date:   Tue, 14 Apr 2020 00:28:35 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20200414051514.7296-4-mchristi@redhat.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/14/2020 12:15 AM, Mike Christie wrote:
> +/**
> + * target_setup_session - alloc and add a session to lio core
> + * @tpg: parent tpg
> + * @tag_num: if non-zero max num in-flight commands.
> + * @tag_size: if tag_num is non-zero, fabric driver's per cmd data in bytes.
> + * @sup_prot_ops: bitmask that defines which T10-PI modes are supported.
> + * @fabric_attrs: opt fabric driver session level attrs.
> + * @private: if setup_cb is non-NULL private will be passed to setup_cb.
> + * @setup_cb: opt function called before session has been added to lio core.
> + * @free_cb: function called during removal when all user refs have dropped.
> + *
> + * If the caller passes in a setup_cb that allocates resource a free_cb is
> + * required to free those resource during session removal.
> + *
> + * If the caller passes in fabric_attrs a free_cb is required, so resources
> + * it may access are freed when all users have dropped their references.
> + */
>  struct se_session *
>  target_setup_session(struct se_portal_group *tpg,
>  		     unsigned int tag_num, unsigned int tag_size,
>  		     enum target_prot_op prot_op,
> -		     const char *initiatorname, void *private,
> -		     int (*callback)(struct se_portal_group *,
> -				     struct se_session *, void *))
> +		     const char *initiatorname,
> +		     struct attribute_group *fabric_attrs, void *private,
> +		     int (*setup_cb)(struct se_portal_group *,
> +				     struct se_session *, void *),
> +		     void (*free_cb)(struct se_session *))
>  {
>  	struct se_session *sess;
> +	int rc;
>  

Hey James,

For this, I just added a single attribute group. For elx will you want
to add multiple dirs under the session? Would just an array of attribute
groups work or do you want multiple nested dirs?

