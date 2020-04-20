Return-Path: <SRS0=Uzsj=6E=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B101C3815B
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:43:32 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 6E2F7206DD
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Apr 2020 17:43:32 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K9M5Lold"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726319AbgDTRnc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Apr 2020 13:43:32 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:53967 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726013AbgDTRnb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Apr 2020 13:43:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1587404610;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Criq6qil6H1tZf/WS5dREIUW0DXvPGTUw1WFAbdrW4g=;
        b=K9M5LoldEdPWngtlYJQ2lqnKe9ndmUZ45Zc80V2gAtFn8tyYdfOMNXcCa5GnoiJ35bF/b0
        BFA8KfI2AHgLgjrzmp8qzOhbSrJTITftZZVW0IknZoRblXGj5zRwM46DuQ9kr5Wm4e0r3T
        NTqNPiYVhf4YGCJ8lQHCbhl6SdDOmbY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-413-yEvN6wAcObqd27Bsnfqlaw-1; Mon, 20 Apr 2020 13:43:27 -0400
X-MC-Unique: yEvN6wAcObqd27Bsnfqlaw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 41F6118C8C24;
        Mon, 20 Apr 2020 17:43:20 +0000 (UTC)
Received: from [10.10.118.198] (ovpn-118-198.rdu2.redhat.com [10.10.118.198])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 8CEF4A103F;
        Mon, 20 Apr 2020 17:43:19 +0000 (UTC)
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
To:     Bodo Stroesser <bstroesser@ts.fujitsu.com>, jsmart2021@gmail.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
 <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5E9DDF37.2020102@redhat.com>
Date:   Mon, 20 Apr 2020 12:43:19 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <4416ba8f-5eae-9dfd-7e39-0f91d37d62e3@ts.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/20/2020 12:39 PM, Bodo Stroesser wrote:
> 
> 
> On 04/14/20 07:15, Mike Christie wrote:
>> +static ssize_t session_acl_show(struct se_session *se_sess, char *page)
>> +{
>> +    struct se_node_acl *acl;
>> +    ssize_t len;
>> +
>> +    acl = se_sess->se_node_acl;
>> +    if (!acl)
>> +        return -ENOTCONN;
>> +
>> +    if (acl->dynamic_node_acl) {
>> +        page[0] = '\0';
>> +        len = 0;
>> +    } else {
>> +        len = snprintf(page, PAGE_SIZE, "%s\n", acl->initiatorname);
>> +    }
>> +
>> +    return len;
>> +}
> 
> Would it be a good idea to provide more info about initiators using
> dynamic acl?
> 
> For example the file could be named "initiatorname" instead of "acl" and

I added this info in another dir/file. I was just about to post a update.

The acl is just a way to reference the configfs dir the info would be
located in since you can symlink.

> always provide the initiatorname, while a boolean file "acl" could
> return "Y" or "1" for explicit acls, but "N" or "0" for dynamic acls.

I was trying to not duplicate what is already in configfs.

