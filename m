Return-Path: <SRS0=9vL1=57=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 03ABDC2BA19
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 17:35:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D51172076D
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Apr 2020 17:35:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hTgYxp3q"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411413AbgDORfk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Apr 2020 13:35:40 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:52440 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2411346AbgDORfi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Apr 2020 13:35:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1586972136;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ttFTwXAxc1FwtTarjlLjHKgZbsfvStWq3U3+jEUweoU=;
        b=hTgYxp3qOCEr/hxz9Kf+1IR8BaOJS+HxyGFFVabp4CqHkgHOaBqR0Pi4UmIajpkM2b5E5i
        kn2bbq/qUBqPiYYc0VGcFX2t1dBbbODX82awy5Gk8YkOfj0Ugp46jm7Z24cRsDK3wUbE35
        pOISeEuNz/fbI0J+yAhZcpQyWPKIWgw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-316-JvlHOTn-PkyD-J8EaaM45g-1; Wed, 15 Apr 2020 13:35:28 -0400
X-MC-Unique: JvlHOTn-PkyD-J8EaaM45g-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id AF76E104FC00;
        Wed, 15 Apr 2020 17:35:26 +0000 (UTC)
Received: from [10.10.115.103] (ovpn-115-103.rdu2.redhat.com [10.10.115.103])
        by smtp.corp.redhat.com (Postfix) with ESMTP id DAB4E60BF1;
        Wed, 15 Apr 2020 17:35:25 +0000 (UTC)
Subject: Re: [RFC PATCH 2/5] target: add sysfs session helper functions
To:     Bart Van Assche <bvanassche@acm.org>, jsmart2021@gmail.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, nab@linux-iscsi.org
References: <20200414051514.7296-1-mchristi@redhat.com>
 <20200414051514.7296-3-mchristi@redhat.com>
 <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5E9745DD.2060009@redhat.com>
Date:   Wed, 15 Apr 2020 12:35:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:38.0) Gecko/20100101
 Thunderbird/38.6.0
MIME-Version: 1.0
In-Reply-To: <20ecaf0e-698c-fb9c-26fd-a1f2dc79392e@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 04/14/2020 09:30 PM, Bart Van Assche wrote:
> On 2020-04-13 22:15, Mike Christie wrote:
>> @@ -537,8 +538,15 @@ void transport_deregister_session_configfs(struct se_session *se_sess)
>>  }
>>  EXPORT_SYMBOL(transport_deregister_session_configfs);
>>  
>> +
> 
> A single blank line is probably sufficient here?
> 

Yes. That was a cut and paste mistake when I was separating the code
into patches. Will fix.


>>  void transport_free_session(struct se_session *se_sess)
>>  {
>> +	kobject_put(&se_sess->kobj);
>> +}
>> +EXPORT_SYMBOL(transport_free_session);
>> +
>> +void __target_free_session(struct se_session *se_sess)
>> +{
>>  	struct se_node_acl *se_nacl = se_sess->se_node_acl;
>>  
>>  	/*
>> @@ -582,7 +590,6 @@ void transport_free_session(struct se_session *se_sess)
>>  	percpu_ref_exit(&se_sess->cmd_count);
>>  	kmem_cache_free(se_sess_cache, se_sess);
>>  }
>> -EXPORT_SYMBOL(transport_free_session);
> 
> Does this patch defer execution of the code inside
> transport_free_session() from when transport_free_session() is called to
> when the last reference to a session is dropped? Can that have

Yes.

> unintended side effects? How about keeping most of the code that occurs

Yes. For example, we drop the refcount on the ACL in
__target_free_session so that is now not done until the last session
rerfcount is done. I did this because we reference the acl in a sysfs file.


> in transport_free_session() in that function and only freeing the memory
> associated with the session if the last reference is dropped?
> 

I tried to minimize it already.

That is why I have the new session->fabric_free_cb in the next patch.
That way we do not need refcounts on structs like the tpg and can detach
that like normal in
transport_deregister_session/transport_deregister_session_configfs.

I will double check about what I can do about the ACL ref. We can do
things like copy the acl's name to the session, so we do not have to
reference the acl in sysfs.



> Thanks,
> 
> Bart.
> 

