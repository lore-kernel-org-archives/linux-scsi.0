Return-Path: <SRS0=fWC9=4W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 570A8C3F2D1
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 19:20:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 391D22073D
	for <linux-scsi@archiver.kernel.org>; Thu,  5 Mar 2020 19:20:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725963AbgCETUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 5 Mar 2020 14:20:55 -0500
Received: from bhuna.collabora.co.uk ([46.235.227.227]:58716 "EHLO
        bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbgCETUz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Mar 2020 14:20:55 -0500
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 7CDEA29376E
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     open-iscsi@googlegroups.com, lduncan@suse.com, cleech@redhat.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        kernel@collabora.com, Khazhismel Kumykov <khazhy@google.com>,
        Junho Ryu <jayr@google.com>
Subject: Re: [PATCH v2] iscsi: Report connection state on sysfs
Organization: Collabora
References: <20200305153521.1374259-1-krisman@collabora.com>
        <bc70bd6d-6d13-4d1c-8559-140411e361d9@acm.org>
Date:   Thu, 05 Mar 2020 14:20:50 -0500
In-Reply-To: <bc70bd6d-6d13-4d1c-8559-140411e361d9@acm.org> (Bart Van Assche's
        message of "Thu, 5 Mar 2020 08:56:26 -0800")
Message-ID: <854kv2bobx.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Bart Van Assche <bvanassche@acm.org> writes:

> On 3/5/20 7:35 AM, Gabriel Krisman Bertazi wrote:
>> +static const struct {
>> +	int value;
>> +	char *name;
>> +} connection_state_names[] = {
>> +	{ISCSI_CONN_UP, "up"},
>> +	{ISCSI_CONN_DOWN, "down"},
>> +	{ISCSI_CONN_FAILED, "failed"}
>> +};
>> +
>> +static const char *connection_state_name(int state)
>> +{
>> +	int i;
>> +
>> +	for (i = 0; i < ARRAY_SIZE(connection_state_names); i++) {
>> +		if (connection_state_names[i].value == state)
>> +			return connection_state_names[i].name;
>> +	}
>> +	return NULL;
>> +}
>> +
>> +static ssize_t show_conn_state(struct device *dev,
>> +			       struct device_attribute *attr, char *buf)
>> +{
>> +	struct iscsi_cls_conn *conn = iscsi_dev_to_conn(dev->parent);
>> +
>> +	return sprintf(buf, "%s\n", connection_state_name(conn->state));
>> +}
>> +static ISCSI_CLASS_ATTR(conn, state, S_IRUGO, show_conn_state,
>> +			NULL);
>
> What has been changed in v2 compared to v1? Please always include a
> changelog when posting a new version.
>
> Additionally, it seems like the comment I posted on v1 has not been
> addressed?

Hi Bart,

v2 no longer has the dependency for specific values for the state, as
you requested.  It follows the pattern in similar places in the iscsi
code.  Why would designated initializers be better than my solution?

-- 
Gabriel Krisman Bertazi
