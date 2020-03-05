Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E365C3F2D2
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 16:56:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 78FEA20637
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 16:56:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726092AbgCEQ4d (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 11:56:33 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:38848 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725990AbgCEQ4d (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 11:56:33 -0500
Received: by mail-pf1-f195.google.com with SMTP id g21so379354pfb.5
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2020 08:56:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1wUY0RDF3MMASgLEnkNdnYSFzMpxRmDzZ17GQ6stlW4=;
        b=iaCbgN2bM3J+CFmzZCzh3YmYWc2Z2Pq9EpGBUeHOEPHSVoIbmeEp1ppnD5XBAG8JB0
         aMPsS3Tf8vHScf2XPsidBdGj6b82Qtvkfpeuuvv6xTuxNaXE2Aos8kJlkoDdS7+jDPpO
         qJJhttlOkMZyKrfyaRMof0HLEjAqrlwA+p2p7ysj7weYRAlmhDoXDwnyDh/qknEPlheN
         tWyF3xGP04qaV4e/WbnVUf9uwESBeW5EUMNgoVOyj35rj9cwSIMI1erzqSJrPG/n3rZY
         g+p3MiWDqm55aXw4UKPoYLYkuSIx6Hbuq0VnYs5SzB54obM9dCTdGNQtPnarM/DfT54H
         SywQ==
X-Gm-Message-State: ANhLgQ2G8W+Qjq21sZl9UtQNbLmnbqslh9ChaWGyt1YkesPZMZwvhH2y
        g0VqLVijWLWCQ/qowbeMuGw=
X-Google-Smtp-Source: ADFU+vve6MFoc5e7+M3FrnQSgx6y4M1zVnAmFHKqSGIdgU3c1TOyRjTYmjwCIawEj8/zJN1YqP16gA==
X-Received: by 2002:a63:ed16:: with SMTP id d22mr8896214pgi.314.1583427390398;
        Thu, 05 Mar 2020 08:56:30 -0800 (PST)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id b9sm3660345pgi.75.2020.03.05.08.56.27
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 08:56:29 -0800 (PST)
Subject: Re: [PATCH v2] iscsi: Report connection state on sysfs
To:     open-iscsi@googlegroups.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        lduncan@suse.com
Cc:     cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
References: <20200305153521.1374259-1-krisman@collabora.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <bc70bd6d-6d13-4d1c-8559-140411e361d9@acm.org>
Date:   Thu, 5 Mar 2020 08:56:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200305153521.1374259-1-krisman@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/5/20 7:35 AM, Gabriel Krisman Bertazi wrote:
> +static const struct {
> +	int value;
> +	char *name;
> +} connection_state_names[] = {
> +	{ISCSI_CONN_UP, "up"},
> +	{ISCSI_CONN_DOWN, "down"},
> +	{ISCSI_CONN_FAILED, "failed"}
> +};
> +
> +static const char *connection_state_name(int state)
> +{
> +	int i;
> +
> +	for (i = 0; i < ARRAY_SIZE(connection_state_names); i++) {
> +		if (connection_state_names[i].value == state)
> +			return connection_state_names[i].name;
> +	}
> +	return NULL;
> +}
> +
> +static ssize_t show_conn_state(struct device *dev,
> +			       struct device_attribute *attr, char *buf)
> +{
> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
> +
> +	return sprintf(buf, "%s\n", connection_state_name(conn->state));
> +}
> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
> +			NULL);

What has been changed in v2 compared to v1? Please always include a 
changelog when posting a new version.

Additionally, it seems like the comment I posted on v1 has not been 
addressed?

Thanks,

Bart.
