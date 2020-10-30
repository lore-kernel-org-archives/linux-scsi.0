Return-Path: <SRS0=glVe=EF=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E8D8AC00A89
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:04:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8C3B320724
	for <linux-scsi@archiver.kernel.org>; Fri, 30 Oct 2020 16:04:21 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="UzfI1Uba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbgJ3QEV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 30 Oct 2020 12:04:21 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:31005 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725844AbgJ3QEV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 30 Oct 2020 12:04:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604073859;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZOY0se4WQ8x55VAXnO7UrS7S0TCfPfbJZdpu+fnITnI=;
        b=UzfI1UbaMx9EDQYIDqXLWjLPC/bHcBnejLyoLIFpLldh/Tb2xdnQPPHV4wBdfJQU8uY8nw
        /zyHOhk7xXxo593hGNq8X75REQT2pdZWxH7M9XI/3I5SKdhS9KbcMthDCx0eJtHKcyxyXe
        XfNR0vszOq1LgTwW/Yz9wIhkvJDqJok=
Received: from mail-ej1-f69.google.com (mail-ej1-f69.google.com
 [209.85.218.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-WZ2gy6LYPOikyszFuw8Zwg-1; Fri, 30 Oct 2020 12:04:17 -0400
X-MC-Unique: WZ2gy6LYPOikyszFuw8Zwg-1
Received: by mail-ej1-f69.google.com with SMTP id ha4so2613906ejb.9
        for <linux-scsi@vger.kernel.org>; Fri, 30 Oct 2020 09:04:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:references:from:subject:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ZOY0se4WQ8x55VAXnO7UrS7S0TCfPfbJZdpu+fnITnI=;
        b=LX5ziWn57YkiZycGM3Dxdj2amHtxym5LUDkrPaobgsmp5P5T5mn+nxIbQGyFeg/Ro3
         JoAJXHCNE4i7gNw55Oe7XKmWkLC+RR4w/EBNQEiAMOrcIfR/+3A+3UWe1LUxDnYIsatj
         MHStYN6wFSgdkRiTmCu5GhLQf46keIN7eGsFY71K80NvkO8aOYgWEGpnaFjXmy7DlJkX
         ox2VGaK8Txoe4BMR+VKZr3vUGe0O4d93xdtcjWGB8j/DFsMWj2AX1zoBBkJCrrnufpFx
         yOvPBt5bFYmog9QtRtv5Si7cpU3Xsc2ONbp40RqvLeCKWAC3AQFaj2Y1+dWeJ/OB6aXk
         sJVA==
X-Gm-Message-State: AOAM532yKxET2Y6vpAHBZ7+u4IZBvPr19oWxr4bFOp5/oFRTvQr3Qi87
        zeND62d9JHntTJPYwG0TUyYSmMAMd04QYWCU7cGioNPsYPGkCjjExLsH52d6z7/+KzKlTcjnsxc
        YBIn7Amp9953m/LHyFKH8gA==
X-Received: by 2002:a17:906:7844:: with SMTP id p4mr3180823ejm.26.1604073854719;
        Fri, 30 Oct 2020 09:04:14 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1LhBtUe4RfD7vdz6T+WU0b0bdIKVll+yCKX7zLk8O+pUhvNlQ2Df5Opp8ngLp1ngs7C94iQ==
X-Received: by 2002:a17:906:7844:: with SMTP id p4mr3180802ejm.26.1604073854514;
        Fri, 30 Oct 2020 09:04:14 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:c8dd:75d4:99ab:290a? ([2001:b07:6468:f312:c8dd:75d4:99ab:290a])
        by smtp.gmail.com with ESMTPSA id h26sm3266273edr.71.2020.10.30.09.04.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 30 Oct 2020 09:04:13 -0700 (PDT)
To:     "Michael S. Tsirkin" <mst@redhat.com>,
        Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, jasowang@redhat.com,
        stefanha@redhat.com, virtualization@lists.linux-foundation.org
References: <1603326903-27052-1-git-send-email-michael.christie@oracle.com>
 <1603326903-27052-10-git-send-email-michael.christie@oracle.com>
 <20201030045053-mutt-send-email-mst@kernel.org>
From:   Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH 09/17] vhost scsi: fix cmd completion race
Message-ID: <5c319f1a-cf4c-f522-ecde-5b6b5a2e1ddd@redhat.com>
Date:   Fri, 30 Oct 2020 17:04:12 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.3.1
MIME-Version: 1.0
In-Reply-To: <20201030045053-mutt-send-email-mst@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 30/10/20 09:51, Michael S. Tsirkin wrote:
> On Wed, Oct 21, 2020 at 07:34:55PM -0500, Mike Christie wrote:
>> We might not do the final se_cmd put from vhost_scsi_complete_cmd_work.
>> When the last put happens a little later then we could race where
>> vhost_scsi_complete_cmd_work does vhost_signal, the guest runs and sends
>> more IO, and vhost_scsi_handle_vq runs but does not find any free cmds.
>>
>> This patch has us delay completing the cmd until the last lio core ref
>> is dropped. We then know that once we signal to the guest that the cmd
>> is completed that if it queues a new command it will find a free cmd.
>>
>> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> 
> Paolo, could you review this one?

I don't know how LIO does all the callbacks, honestly (I have only ever
worked on the virtio-scsi driver, not vhost-scsi, and I have only ever
reviewed some virtio-scsi spec bits of vhost-scsi).

The vhost_scsi_complete_cmd_work parts look fine, but I have no idea why
vhost_scsi_queue_data_in and vhost_scsi_queue_status call.

Paolo

