Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0434C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:16:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B7160206E6
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 20:16:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="L7tVZzix"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731349AbgEKUQQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 16:16:16 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:57845 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727873AbgEKUQQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 16:16:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589228174;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6zZWLFKbl6hJYTd+tUrCgA+jCSY0ie2hd2RDRhiY244=;
        b=L7tVZzixGaa2Qq0J4Q4ofwUiq/GhsU79jTcfuF/HjvsdJeZA9MmY0Zznlsc7ZhfPNwIzsS
        rANKFUb7IYhni4PzyYUsq8HuWJHnuvWVI8FnZzSH7APchekm9QuofeasMgzThsk+xnfF4x
        Gu9BZbfwBtqpw5oxxBV0AQ7om2ZKPRU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-229-ghVy75HWPSOIZRVDQ-lSow-1; Mon, 11 May 2020 16:16:10 -0400
X-MC-Unique: ghVy75HWPSOIZRVDQ-lSow-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 044658014D6;
        Mon, 11 May 2020 20:16:09 +0000 (UTC)
Received: from [10.10.118.195] (ovpn-118-195.rdu2.redhat.com [10.10.118.195])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C18E570947;
        Mon, 11 May 2020 20:16:07 +0000 (UTC)
Subject: Re: [PATCH 12/15] target: add sysfs session helper functions
To:     Bart Van Assche <bvanassche@acm.org>,
        Bodo Stroesser <bstroesser@ts.fujitsu.com>,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Hannes Reinecke <hare@suse.de>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-13-mchristi@redhat.com>
 <66e9bbf8-fdb2-d819-a496-75a1dea779cf@ts.fujitsu.com>
 <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <5234c678-92e6-0689-1eca-aa0c252adf58@redhat.com>
Date:   Mon, 11 May 2020 15:16:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <a3686299-8fab-3cf7-0641-5e7c98a7292d@acm.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/20 2:21 PM, Bart Van Assche wrote:
> On 2020-05-11 11:39, Bodo Stroesser wrote:
>> On 05/10/20 23:57, Mike Christie wrote:
>>> This patch adds helpers to add/remove a dir per session. There is only 2
>>> files/dirs initially.
>>>
>>
>> ...
>>
>>> +
>>> +int target_sysfs_add_session(struct se_portal_group *se_tpg,
>>> +                 struct se_session *se_sess)
>>> +{
>>> +    int ret;
>>> +
>>> +    /*
>>> +     * Copy ACL name so we don't have to worry about mixing configfs
>>> +     * and sysfs refcounts.
>>> +     */
>>> +    if (!se_sess->se_node_acl->dynamic_node_acl) {
>>> +        se_sess->acl_name = kstrdup(se_sess->se_node_acl->initiatorname,
>>> +                        GFP_KERNEL);
>>> +        if (!se_sess->acl_name)
>>> +            return -ENOMEM;
>>> +    }
>>> +
>>> +    ret = kobject_add(&se_sess->kobj, se_tpg->sessions_kobj, "%s-%d",
>>> +              se_sess->tpt_id->name, se_sess->sid);
>>> +    if (ret) {
>>> +        pr_err("Could not add session%d to sysfs. Error %d.\n",
>>> +               se_sess->sid, ret);
>>> +        goto free_acl_name;
>>> +    }
>>> +
>>> +    ret = add_transport_id_attrs(se_sess);
>>> +    if (ret)
>>> +        goto del_kobj;
>>> +
>>> +    if (se_sess->tfo->session_attrs) {
>>> +        ret = sysfs_create_group(&se_sess->kobj,
>>> +                     se_sess->tfo->session_attrs);
>>> +        if (ret)
>>> +            goto rm_tpt_id_grps;
>>> +    }
>>> +
>>> +    ret = sysfs_create_link(tcm_core_sessions_kobj, &se_sess->kobj,
>>> +                se_sess->kobj.name);
>>
>> I would prefer to have links named "session-%d" or "%d" only, of course
>> with se_sess->sid as the value for '%d'.

Yeah for the part of your comment that got chopped I can see your point.
For the dynamic acl case (userspace did not create an ACL so the kernel
made a tmp one), then doing session-$id will be easier for userspace to
lookup a specific session since it does not know the initiator name and
only knows the session id.

> 
> Isn't se_sess->sid a property that is filled in by the iSCSI target
> driver only? Is se_sess->sid zero for all other target drivers than the
> iSCSI target driver?

No, in this patch in transport_alloc_session() I added a common sid
allocator so all sessions have a unique id across all targets.

> 
>> If userspace knows the session-id only, such names make it easier to
>> find the corresponding link.
> 
> Personally I prefer the %s-%d naming scheme. I think that naming scheme
> has the following advantages:
> 1. No need to run cat ... to retrieve the initiator name.
> 2. It becomes possible to derive from the 'ls' output which initiators
> created multiple sessions.
> 3. All sessions created by the same initiator appear consecutively.
>

Ccing Hannes, because he was also saying that we should use generic
names like target-%X, session-$d, etc. If we change all the code to use
generic names for the target/fabric/tpgt/session, then examples like #2
or similar ones like using tree to see the topology from a SCSI'ish view
would not work.

In the end, we have this issue with SCSI on the initiator side, and it's
a pain, but not a show stopper.

