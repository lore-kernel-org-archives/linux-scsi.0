Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1723AC433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Mar 2022 12:50:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231528AbiCNMwG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Mar 2022 08:52:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239352AbiCNMwA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Mar 2022 08:52:00 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34337EB1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Mar 2022 05:50:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B15AE1F388;
        Mon, 14 Mar 2022 12:50:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1647262231; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N37TTnn2utj4I/pgjrB5NDzuJTSw1PpPf0cQec9YUOI=;
        b=Lvt/GVsGYVp+7GTyrMnqxMiQuW3CTTnYhnWVamcrb+Z+jo1lZl3FXsc+tYi5tw5/l0odnu
        8VYttt2TbBkXd7K8iGiCrUdC7INISezoAd4VcAeiE4vI6cofKuJe7Zt7KdZoTvNd8jK8mA
        v89gXTUIEVgbNdRI9UX1ZOAGWtbtfWc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1647262231;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=N37TTnn2utj4I/pgjrB5NDzuJTSw1PpPf0cQec9YUOI=;
        b=jbmte+oVnYLPn734zuzSAReopgKjWsNA460BPoKFhYMYU2Qoypgl22Zq+9mnqcjOsJbuH+
        B8sFhzjXV8dm4xAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A0C7313B34;
        Mon, 14 Mar 2022 12:50:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id OBLgJhc6L2KiSwAAMHmgww
        (envelope-from <hare@suse.de>); Mon, 14 Mar 2022 12:50:31 +0000
Message-ID: <81d6a8c3-8fc8-cae4-cbfb-32594dec55b6@suse.de>
Date:   Mon, 14 Mar 2022 13:50:31 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Lee Duncan <lduncan@suse.com>, Chris Leech <cleech@redhat.com>,
        lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
References: <1cc5dd40-47e5-0756-db22-42e4e86468c5@redhat.com>
 <ab4cb09f-cecb-0c1c-36e7-07db2556bc61@suse.com>
From:   Hannes Reinecke <hare@suse.de>
Subject: Re: [LSF/MM/BPF TOPIC] network storage transports managed within a
 container
In-Reply-To: <ab4cb09f-cecb-0c1c-36e7-07db2556bc61@suse.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/1/22 20:20, Lee Duncan wrote:
> On 2/28/22 18:04, Chris Leech wrote:
>> There are various challenges when users start trying to manage SAN
>> attachments from within a container, and how we deal with network
>> namespaces.  I think it would be worth a discussion around what can be
>> agreed on as desired behavior, and what it means to attach block
>> devices from a containerized environment.
>>
>> iSCSI has a number of issues here with the kernel to iscsid
>> interfaces, netlink and sysfs, which are largely fixable without
>> needing to break anything.  But for kernel maintained network
>> connections, there's an issue of interacting with namespace lifetimes
>> without a process.
>>
>> NVMe/TCP has avoided complex user-space control planes, but when I
>> checked subsystem connection occurred within the active namespace of
>> nvme-cli, but afterwords all fabrics subsystems were visible,
>> controllable, and disconnectable from any namespace.
>>
>>
>> Lee Duncan had submitted a proposal to discuss this for iSCSI last
>> year [1], partially based on some older work I did that never
>> completed [2] (I need to update that code)
>>
>> [1]
>> https://lore.kernel.org/linux-scsi/e9f0297a-a914-ba83-f706-5a2d508c666b@suse.com/ 
>>
>>
>> [2] https://github.com/cleech/linux/commits/iscsi-netns-old-wip
>>
>> - Chris Leech
>>
> 
> I would certainly be interested in attending this.
> 
Count me in.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
