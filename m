Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A7B31C76196
	for <linux-scsi@archiver.kernel.org>; Tue, 11 Apr 2023 18:06:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230310AbjDKSGN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 11 Apr 2023 14:06:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbjDKSGM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Apr 2023 14:06:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9521749C2
        for <linux-scsi@vger.kernel.org>; Tue, 11 Apr 2023 11:04:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1681236226;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=B3FiBjdgWlBkkLUpYsHnBiWcE8rxx2EUpI7csz5XeCw=;
        b=ZEAiLyLFcLe+VWB8qo34oxnyWdK3OQwxU1qkv0bw9OXADD0mpu6N/5U2LfHLHqq/6YVIue
        hht2SzUt0rLsP9nXx+2IQECiNnXnFTRc0AD53L6jzxrmgxlVkS7KiAmgKdIZqw9plXPHcf
        rntha5tTXrOCpTN+uVMuVfdSWqq/43k=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-551-5mtcnPw4Pdm_SWKoi2-NRw-1; Tue, 11 Apr 2023 14:03:40 -0400
X-MC-Unique: 5mtcnPw4Pdm_SWKoi2-NRw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.rdu2.redhat.com [10.11.54.6])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 89E8C884EC3;
        Tue, 11 Apr 2023 18:03:39 +0000 (UTC)
Received: from localhost (unknown [10.2.16.6])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id DD3772166B31;
        Tue, 11 Apr 2023 18:03:38 +0000 (UTC)
Date:   Tue, 11 Apr 2023 11:03:37 -0700
From:   Chris Leech <cleech@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
Subject: Re: [RFC PATCH 5/9] iscsi: set netns for iscsi_tcp hosts
Message-ID: <20230411180337.GA1234639@localhost>
Mail-Followup-To: Hannes Reinecke <hare@suse.de>,
        Lee Duncan <leeman.duncan@gmail.com>, linux-scsi@vger.kernel.org,
        open-iscsi@googlegroups.com, netdev@vger.kernel.org,
        Lee Duncan <lduncan@suse.com>
References: <cover.1675876731.git.lduncan@suse.com>
 <566c527d12f6ed56eeb40952fef7431a0ccdc78f.1675876735.git.lduncan@suse.com>
 <82eb95ac-2dca-7a7a-116a-2771c4551bab@suse.de>
 <ZDSoH193jm2jOZKA@localhost>
 <b3cad686-fa03-b7a4-01c3-9293a7421582@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b3cad686-fa03-b7a4-01c3-9293a7421582@suse.de>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.6
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Apr 11, 2023 at 08:58:54AM +0200, Hannes Reinecke wrote:
> On 4/11/23 02:21, Chris Leech wrote:
> > diff --git a/include/scsi/scsi_transport_iscsi.h b/include/scsi/scsi_transport_iscsi.h
> > index 0c3fd690ecf8..4d8a3d770bed 100644
> > --- a/include/scsi/scsi_transport_iscsi.h
> > +++ b/include/scsi/scsi_transport_iscsi.h
> > @@ -79,6 +79,9 @@ struct iscsi_transport {
> >   	struct iscsi_cls_session *(*create_session) (struct iscsi_endpoint *ep,
> >   					uint16_t cmds_max, uint16_t qdepth,
> >   					uint32_t sn);
> > +	struct iscsi_cls_session *(*create_unbound_session) (struct net *net,
> > +					uint16_t cmds_max, uint16_t qdepth,
> > +					uint32_t sn);
> >   	void (*destroy_session) (struct iscsi_cls_session *session);
> >   	struct iscsi_cls_conn *(*create_conn) (struct iscsi_cls_session *sess,
> >   				uint32_t cid);
> 
> I'm not _that_ happy with these two functions; but can't really see a way
> around it.
> Can't we rename the 'unbound' version to
> 'create_session_ns' or something?

Yes, in my mind I was matching the netlink commands, but those are
create_session and create_bound_session. I got it exactly backwards
with which one had the additional text.

I'm OK with changing to a shorter name, like the one you suggested.

Thanks,
- Chris

