Return-Path: <SRS0=B1Ch=6Z=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F416C47255
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 17:15:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 48F5A206D7
	for <linux-scsi@archiver.kernel.org>; Mon, 11 May 2020 17:15:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CenGbeSg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730814AbgEKRPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 May 2020 13:15:19 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:45617 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729731AbgEKRPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2020 13:15:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589217318;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=zLMCWnI+g1sNy6IPUS5WeLtM2KBsMrBBwB3Mc9zU9Eg=;
        b=CenGbeSgtWZJYJ/N0wq3oIqSvsUOE7mQ8wlW+16egl8uK732kF1uarCzmwdRI9NJ+Y4Ge3
        qeYlng2sA8BiNpmxlJmREv1CbaXtW5wPm+QKkSjfyzuzG+ysgFD/PoXi9oVcihiADdlwoQ
        C7eKe2qjHMxYXfNUylyuPMtfIaQOJlU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-17-MVoBktSGMqOA-zWY1dTIkQ-1; Mon, 11 May 2020 13:15:16 -0400
X-MC-Unique: MVoBktSGMqOA-zWY1dTIkQ-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6E037107ACF2;
        Mon, 11 May 2020 17:15:14 +0000 (UTC)
Received: from [10.10.116.128] (ovpn-116-128.rdu2.redhat.com [10.10.116.128])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 25771100164D;
        Mon, 11 May 2020 17:15:13 +0000 (UTC)
Subject: Re: [PATCH 11/15] target: add sysfs support
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     bvanassche@acm.org, bstroesser@ts.fujitsu.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, Hannes Reinecke <hare@suse.de>
References: <20200510215744.21999-1-mchristi@redhat.com>
 <20200510215744.21999-12-mchristi@redhat.com>
 <20200511063002.GA1260895@kroah.com>
From:   Mike Christie <mchristi@redhat.com>
Message-ID: <aad8269e-f9ee-ebc7-6e54-aa4b5b6021b8@redhat.com>
Date:   Mon, 11 May 2020 12:15:12 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <20200511063002.GA1260895@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/11/20 1:30 AM, Greg Kroah-Hartman wrote:
> On Sun, May 10, 2020 at 04:57:40PM -0500, Mike Christie wrote:
>> These next two patches add a sysfs interface that reports the target
>> layer's I_T nexuses/sessions. For the non-SCSI people cc'd, this just means
>> we are reporting a server's connections to remote clients.
>>
>> This patch adds the upper level dirs which shows/organizes our local port
>> (tpgts below) and the connection (session below). The next patch will then
>> add the dirs/files for each connection/session which exports info like
>> ACL/permissions and SCSI port values.
>>
>> Here is the general layout:
>>
>> [sys]# tree scsi_target/
>> scsi_target/
>> |-- fabric/target module
>> |   `-- target name
>> |       `-- tpgt_$target_port_group_number
>> |           `-- sessions
>> |               `-- initiator name - session ID number
>> |                   |-- acl
>> |                   `-- transport_id
>> |                       |-- name
>> |                       |-- proto
>> |                       `-- session_id
>>
>> Here is an example with the scsi target layer's iSCSI driver:
>>
>> scsi_target/
>> |-- iscsi
>> |   `-- iqn.1999-09.com.tcmu:minna
>> |       `-- tpgt_1
>> |           `-- sessions
>> |               `-- iqn.2005-03.com.ceph:ini1-1
>> |                   |-- acl
>> |                   `-- transport_id
>> |                       |-- name
>> |                       |-- proto
>> |                       `-- session_id
>> |-- fc
>> |-- loopback
>> |-- qla2xxx_tcm
>>
>>
>> Note/Question for Greg:
>>
>> We are not exporting info in the upper level dirs like "fabric/target
>> module", "target name", tpgt, etc and just need those dirs to be able to
>> organize/view the endpoints of the session. So, in this patch I made a new
>> top level dir scsi_target and made the other dirs with
>> kobject_create_and_add. It looks like we could also add device structs in
>> the target related structs, use classes, and build the tree/hierarchy that
>> way too. It was not clear to me when to use one or the other.
> 
> Never use kobject calls in a driver subsystem like you have here, as
> those objects will not be seen by userspace tools that get uevents.
> Just use real 'struct devices' if you really really need a deep
> directory tree.
> 
> But I would push back here, why do you feel you want such a deep tree?
> What are you getting from this?  Why do you need that "sessions"
> directory at all?

I do not need the sessions under the tpgt dir and will drop it. The
target subsystem does not have a bus or use device structs at all right
now. And, I saw how other code that does not have a bus like btrfs/ext4
use kobject_create_and_add() to group/organize objects and went wild
with dirs :)

And, I can move the code to device structs, but had a question about the
deep tree question.

A common operation will be that userspace knows the names of the objects
above the session in the tree already. Apps then want to read in a
specific session or scan the specific sessions in a target or a tpgt.
The deep tree makes it easy to build the sysfs path and scan/read the
specific object/objects.

I wanted to avoid the issue where apps have with the flat layout where
they have to scan every session when they just want something specific.

Will a deep tree be ok for this type of reason?

