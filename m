Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1EE3C433EF
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Mar 2022 02:04:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbiCACEt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 28 Feb 2022 21:04:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230495AbiCACEr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Feb 2022 21:04:47 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 57993617B
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 18:04:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1646100245;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=JaCUSD2vTqwOwKJJzKBOPbfZizxvexTnRKWpUjmtfyU=;
        b=bd1EiugVWwvyPMhQw/LiEqMUIkPomIt3Z68h2NkQywLLhuHYJ1XKksHftbFwvTLANGToHa
        Ot5GqZG0eFGwl1BBLlZ2o9w+M3yB8xaoyTQbxFPoYw07HvOIkaoxM0jUovYPX08+0NbjhV
        kVs/p49BSe8g8Rk6fTVEN6ViFCzbcKE=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-501-hiVHqO9zNymaKuV60HGnvg-1; Mon, 28 Feb 2022 21:04:03 -0500
X-MC-Unique: hiVHqO9zNymaKuV60HGnvg-1
Received: by mail-qk1-f200.google.com with SMTP id m22-20020a05620a221600b005f180383baeso12974298qkh.15
        for <linux-scsi@vger.kernel.org>; Mon, 28 Feb 2022 18:04:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent
         :content-language:to:from:subject:cc:content-transfer-encoding;
        bh=JaCUSD2vTqwOwKJJzKBOPbfZizxvexTnRKWpUjmtfyU=;
        b=VKS5iJwNOCfIKW8UGxA/fAKdCfmzV8dGBtMw7eD2QpKbaNU/H3PF0SfzU61wKFNTZq
         1zqXkhdbzpEND4EfZNrqVN+A6OvA3ITgnGkzu6+7el8Y+qZB3tdtimHOTxO6AT4pJcoj
         in4DHdGVVaOcXbGaI/L1Fo4fWAT1hwZTgIyFv39zHb7hJPs8ANu0fa2a9pG3reLSiCqh
         8UXiFaM60V+kuzhFI0ho9FoNIlLqItflT1Yl7WWRI0w1FExyQwNJpkz+tSkbX1yAyYJ8
         ZwiI7DM8/sFivvOJZ7tYxkMqeZievJzSyfPmKGWFoRaW54eyW85EgortSEITK0TmPYq1
         /tuw==
X-Gm-Message-State: AOAM53234EK8r6x+JqKrRE+dLkTT871UHAzzF2M1/xTOfpfugfQuW9/J
        W9BINHw6uLSRdfRLygRUvsjNybW1dI2MzoLfyY0amiVTHRfSWU9dPYk9lTGur4ODORngXfw1DAM
        B5NPZfQh+GbuivtN6WeZIlA==
X-Received: by 2002:ac8:59d6:0:b0:2dd:226:9d7d with SMTP id f22-20020ac859d6000000b002dd02269d7dmr18466317qtf.372.1646100243284;
        Mon, 28 Feb 2022 18:04:03 -0800 (PST)
X-Google-Smtp-Source: ABdhPJz+IUB2hr74QXPnDooszKG62xt16/KuAcFHfGM+WDSG9L0tFQNkmqb18SPuQtwasI3eVUfGCg==
X-Received: by 2002:ac8:59d6:0:b0:2dd:226:9d7d with SMTP id f22-20020ac859d6000000b002dd02269d7dmr18466308qtf.372.1646100243047;
        Mon, 28 Feb 2022 18:04:03 -0800 (PST)
Received: from [192.168.0.14] (97-120-59-83.ptld.qwest.net. [97.120.59.83])
        by smtp.gmail.com with ESMTPSA id o24-20020a05620a15d800b00648a9cf86e7sm5779355qkm.33.2022.02.28.18.04.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Feb 2022 18:04:02 -0800 (PST)
Message-ID: <1cc5dd40-47e5-0756-db22-42e4e86468c5@redhat.com>
Date:   Mon, 28 Feb 2022 18:04:00 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Content-Language: en-US
To:     lsf-pc@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org
From:   Chris Leech <cleech@redhat.com>
Subject: [LSF/MM/BPF TOPIC] network storage transports managed within a
 container
Cc:     Lee Duncan <lduncan@suse.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

There are various challenges when users start trying to manage SAN
attachments from within a container, and how we deal with network
namespaces.  I think it would be worth a discussion around what can be
agreed on as desired behavior, and what it means to attach block
devices from a containerized environment.

iSCSI has a number of issues here with the kernel to iscsid
interfaces, netlink and sysfs, which are largely fixable without
needing to break anything.  But for kernel maintained network
connections, there's an issue of interacting with namespace lifetimes
without a process.

NVMe/TCP has avoided complex user-space control planes, but when I
checked subsystem connection occurred within the active namespace of
nvme-cli, but afterwords all fabrics subsystems were visible,
controllable, and disconnectable from any namespace.


Lee Duncan had submitted a proposal to discuss this for iSCSI last
year [1], partially based on some older work I did that never
completed [2] (I need to update that code)

[1]
https://lore.kernel.org/linux-scsi/e9f0297a-a914-ba83-f706-5a2d508c666b@suse.com/

[2] https://github.com/cleech/linux/commits/iscsi-netns-old-wip

- Chris Leech

