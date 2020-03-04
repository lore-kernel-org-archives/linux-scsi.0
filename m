Return-Path: <SRS0=THiH=4V=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49687C3F2CE
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 23:34:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 207E520842
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Mar 2020 23:34:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388468AbgCDXeE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Mar 2020 18:34:04 -0500
Received: from mail-pl1-f195.google.com ([209.85.214.195]:42306 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388407AbgCDXeE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2020 18:34:04 -0500
Received: by mail-pl1-f195.google.com with SMTP id u3so1758699plr.9
        for <linux-scsi@vger.kernel.org>; Wed, 04 Mar 2020 15:34:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gykwNNuyk2Q7gDAHD6Zsfoyme0Udz5ys84EX9qpMQOk=;
        b=G0aQS7ztnIjfDrhQsrj6RJwkhHD3zHLHcP6n4mZSuK6SUvXLvaxDJtBcE8prUyR5gZ
         xi/733gKDWJ9Cz8IhMqZex4Cm5uC8/g5QS2xNAF+cqUjWBPtxNLHgg9Cs56iaJ/ZT98+
         eQmhkvcLWaqo1svqZx/l16KMRxXfqnyKsY+fKwhwoqumzuhE0NFHtr1B6P+8Gp2oHnvd
         jle63a6luA/WVtSGtEhl2ALvUjuJDOaAM1kDgYKqjrwajVF5uAVnFOIZCxlYHuiI+Dx/
         0yNqzjQvviMi6Sm3euPdYoyXEJ6f4Y5JtFhKmY7XLLpaIxAI9Uqt6psAYhePooAgVWcb
         xEJA==
X-Gm-Message-State: ANhLgQ1hw1wSqLyGlcdZ7EbOZwhrjPOf7crEqNVd8SP8FRhty9gEPqpW
        ST7TDPKRYQBK3KaVOdSSiQE=
X-Google-Smtp-Source: ADFU+vunIFBzrk2kHVbQsMwIE3QEfJmT24Q9dhH3B40X+8t3UP+gDLx3Fqcy4CfX5s9hMWD5GQKH3g==
X-Received: by 2002:a17:90a:9515:: with SMTP id t21mr5471524pjo.14.1583364843143;
        Wed, 04 Mar 2020 15:34:03 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id j12sm3903714pjd.4.2020.03.04.15.34.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 04 Mar 2020 15:34:02 -0800 (PST)
Subject: Re: [PATCH] iscsi: Report connection state on sysfs
To:     open-iscsi@googlegroups.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        lduncan@suse.com
Cc:     cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
References: <20200304225704.1221703-1-krisman@collabora.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <387eebf7-3256-3462-f91d-e42a5de4824d@acm.org>
Date:   Wed, 4 Mar 2020 15:34:01 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200304225704.1221703-1-krisman@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/20 2:57 PM, Gabriel Krisman Bertazi wrote:
> +static const struct {
> +	int state;
> +	char *name;
> +} connection_state_name[] = {
> +	{ISCSI_CONN_UP, "up"},
> +	{ISCSI_CONN_DOWN, "down"},
> +	{ISCSI_CONN_FAILED, "failed"}
> +};
> +
> +static ssize_t
> +show_conn_state(struct device *dev, struct device_attribute *attr,
> +		     char *buf)
> +{
> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
> +
> +	return sprintf(buf, "%s\n",
> +		       connection_state_name[conn->state].name);
> +}
> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
> +			NULL);

The above code can only work if ISCSI_CONN_UP == 0, ISCSI_CONN_DOWN == 1 
and ISCSI_CONN_FAILED == 2. Please don't hardcode such a dependency and 
use designated initializers instead.

Thanks,

Bart.
