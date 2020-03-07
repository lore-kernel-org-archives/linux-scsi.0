Return-Path: <SRS0=IrwI=4Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D1CAC10F25
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 00:49:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 12ACE20637
	for <linux-scsi@archiver.kernel.org>; Sat,  7 Mar 2020 00:49:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726833AbgCGAtB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 6 Mar 2020 19:49:01 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:45710 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726633AbgCGAtB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Mar 2020 19:49:01 -0500
Received: by mail-pf1-f196.google.com with SMTP id 2so1898430pfg.12
        for <linux-scsi@vger.kernel.org>; Fri, 06 Mar 2020 16:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=O2IFTGV2/8sXNAcc4XgejeiSdt2yZwnhs0Imj+KkeJQ=;
        b=JtvTQDJEwO+4bVTkBgpqhzuXijqlaMHx6Fu7Lxxq3X0V6MwOf4WYhbGd+y8EyHbEes
         jmrcCT2bhydPDWODOh6iUY65J2yDOR3vfkzId3ODDq7er8OMiUpPTWwk3zX2+Nl7JEor
         OPAOPzNfVJ9xpUTCge7gjJhPNNczcVAJ0HmHOV8eFvIj+fgG8knOKiLQuoGrUJl409r0
         zFirOBL9E8Sq9YVSnJqkJ3RossRX2v5WrmLD/crPZ7PcYueeMumZR5OiDLmXaSQCibYh
         iApdI2/vc0ZZU7mCA+NU/XjOsjO4sswckie4LHAtEfkNjl/BrxiT72K16VkoR5rXuLMR
         uWOQ==
X-Gm-Message-State: ANhLgQ39kjKgcC6/bx5lliafxCyEtfdWO/J5fue2EoFb25P/DYbfeIxp
        IIwTp/6Lq8EFFig8dQ3gWGU=
X-Google-Smtp-Source: ADFU+vujVHN1HymdKmGyFzcmEdeQkZp5C8Rz4jr0IJwFtb2UkxmzKRgZ4Nff+hndKTX5/e2xkgcZPg==
X-Received: by 2002:a63:334c:: with SMTP id z73mr3115032pgz.421.1583542139700;
        Fri, 06 Mar 2020 16:48:59 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id k9sm10565374pjo.19.2020.03.06.16.48.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 06 Mar 2020 16:48:58 -0800 (PST)
Subject: Re: [PATCH v2] iscsi: Report connection state on sysfs
To:     open-iscsi@googlegroups.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
References: <20200305153521.1374259-1-krisman@collabora.com>
 <bc70bd6d-6d13-4d1c-8559-140411e361d9@acm.org> <854kv2bobx.fsf@collabora.com>
 <b2b62579-b2b6-b797-501b-186ac24df399@acm.org> <85h7z12r20.fsf@collabora.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <be183875-967a-402a-7fb4-3d1db3bca0f8@acm.org>
Date:   Fri, 6 Mar 2020 16:48:57 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <85h7z12r20.fsf@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/6/20 11:59 AM, Gabriel Krisman Bertazi wrote:
> +static const char *const connection_state_names[] = {
> +	[ISCSI_CONN_UP] = "up",
> +	[ISCSI_CONN_DOWN] = "down",
> +	[ISCSI_CONN_FAILED] = "failed"
> +};
> +
> +static ssize_t show_conn_state(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
> +	const char *state = "unknown";
> +
> +	if (conn->state < ARRAY_SIZE(connection_state_names))
> +		state = connection_state_names[conn->state];
> +
> +	return sprintf(buf, "%s\n", state);
> +}
> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
> +			NULL);

Thank you for having made this change.

> +/* iscsi class connection state */
> +enum {
> +	ISCSI_CONN_UP = 0,
> +	ISCSI_CONN_DOWN,
> +	ISCSI_CONN_FAILED,
> +};
> +
>   struct iscsi_cls_conn {
>   	struct list_head conn_list;	/* item in connlist */
>   	struct list_head conn_list_err;	/* item in connlist_err */
> @@ -198,6 +205,7 @@ struct iscsi_cls_conn {
>   	struct iscsi_endpoint *ep;
>   
>   	struct device dev;		/* sysfs transport/container device */
> +	unsigned int state;
>   };

Can 'state' have another value than those declared in the enumeration 
type? If not, how about changing the type of 'state' from 'unsigned int' 
into 'enum ...'? If that change is made, a check will have to be added 
in show_conn_state() whether conn->state >= 0 since the C standard does 
not guarantee whether enumeration types are signed or unsigned.

Bart.
