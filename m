Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 14925C3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:16:13 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id E91ED20728
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 21:16:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726178AbgCEVQM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 16:16:12 -0500
Received: from mail-pl1-f193.google.com ([209.85.214.193]:35909 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgCEVQM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 16:16:12 -0500
Received: by mail-pl1-f193.google.com with SMTP id g12so3178914plo.3
        for <linux-scsi@vger.kernel.org>; Thu, 05 Mar 2020 13:16:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=mRy0QXwPQyZJPqAhJuywWDK9M11rkux+kVjPm7zQzS0=;
        b=FZdU6E2r0NEdzNwC2KvFYv5E3xT9eSIbhiIOvcbm5c6GuqJH59MFU9Gv34FIDIv975
         G/UH73EB33qfcCgBJpU2oNaW32vgvpmRN0mV6G8RDlk9s3xKrs303DBbeXDkve7eDoXY
         vYCaELQao1rgpPhUGaQRRbVxYJVDPMlwYh2yL8ioIgZpEoTgLZbH53xLPx57UwbM5Pr2
         l0JrR3+XyC/gTIzwcUQ5OX82iT//oaMjFaq9pFmu6skYglm1pUfryxvIl+wUFlg88WDF
         A5faFGGOXGmwaJGqM4UlMj6irEk6R/S45gU3Rc6iqW6DuS5yWxbCA4UX13z3lffFKj1+
         kxMg==
X-Gm-Message-State: ANhLgQ3xy6EGW6oXPTSB/RCvFpv8fkizCw74+KPDENfivtUXsTYuz+0l
        jb5c25foX8q6yeKx+N31N+Y=
X-Google-Smtp-Source: ADFU+vveZbE8ake7pQqO0YibzLIkJEnOkBMHlJ2EgU6987ZyTh4GtB4Z90lkmLZrrJqg7IouAuuoQQ==
X-Received: by 2002:a17:902:2e:: with SMTP id 43mr74899pla.326.1583442970886;
        Thu, 05 Mar 2020 13:16:10 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:fb9c:664d:d2ad:c9b5? ([2620:15c:2c1:200:fb9c:664d:d2ad:c9b5])
        by smtp.gmail.com with ESMTPSA id a36sm32330380pga.32.2020.03.05.13.16.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 05 Mar 2020 13:16:09 -0800 (PST)
Subject: Re: [PATCH v2] iscsi: Report connection state on sysfs
To:     open-iscsi@googlegroups.com,
        Gabriel Krisman Bertazi <krisman@collabora.com>
Cc:     lduncan@suse.com, cleech@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, kernel@collabora.com,
        Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
References: <20200305153521.1374259-1-krisman@collabora.com>
 <bc70bd6d-6d13-4d1c-8559-140411e361d9@acm.org> <854kv2bobx.fsf@collabora.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b2b62579-b2b6-b797-501b-186ac24df399@acm.org>
Date:   Thu, 5 Mar 2020 13:16:08 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <854kv2bobx.fsf@collabora.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/5/20 11:20 AM, Gabriel Krisman Bertazi wrote:
> Bart Van Assche <bvanassche@acm.org> writes:
> 
>> On 3/5/20 7:35 AM, Gabriel Krisman Bertazi wrote:
>>> +static const struct {
>>> +	int value;
>>> +	char *name;
>>> +} connection_state_names[] = {
>>> +	{ISCSI_CONN_UP, "up"},
>>> +	{ISCSI_CONN_DOWN, "down"},
>>> +	{ISCSI_CONN_FAILED, "failed"}
>>> +};
>>> +
>>> +static const char *connection_state_name(int state)
>>> +{
>>> +	int i;
>>> +
>>> +	for (i = 0; i < ARRAY_SIZE(connection_state_names); i++) {
>>> +		if (connection_state_names[i].value == state)
>>> +			return connection_state_names[i].name;
>>> +	}
>>> +	return NULL;
>>> +}
>>> +
>>> +static ssize_t show_conn_state(struct device *dev,
>>> +			       struct device_attribute *attr, char *buf)
>>> +{
>>> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
>>> +
>>> +	return sprintf(buf, "%s\n", connection_state_name(conn->state));
>>> +}
>>> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
>>> +			NULL);
>>
>> What has been changed in v2 compared to v1? Please always include a
>> changelog when posting a new version.
>>
>> Additionally, it seems like the comment I posted on v1 has not been
>> addressed?
> 
> Hi Bart,
> 
> v2 no longer has the dependency for specific values for the state, as
> you requested.  It follows the pattern in similar places in the iscsi
> code.  Why would designated initializers be better than my solution?

Hi Gabriel,

How about removing the loop as follows?

static const char *const connection_state_names[] = {
	[ISCSI_CONN_UP]     = "up",
	[ISCSI_CONN_DOWN]   = "down",
	[ISCSI_CONN_FAILED] = "failed",
};

...
	if ((unsigned)conn->state < ARRAY_SIZE(connection_state_names))
		return sprintf(buf, "%s\n",
			connection_state_names[conn->state]);
	else
		...
...

Thanks,

Bart.
