Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD517ECAAD2
	for <linux-scsi@archiver.kernel.org>; Mon, 29 Aug 2022 09:14:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbiH2JOT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 29 Aug 2022 05:14:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229556AbiH2JOS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 29 Aug 2022 05:14:18 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3BCF5A3D2
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 02:14:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1661764457;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=OFqf6jpqGJefPSf8RmNEVl/OkAv1jhf4SeDG5OJei+8=;
        b=f6ayHFa6rQeotZuiumkkY1C8x/q7E9mgwMx4VvzS74Nt7y/14FCx+PRg8GY+hTpExKz6XV
        DYaCWqJYfADv1dbpFuDEb31+QhH2Be2I9+oToPRLIFQDV3LBxcGx3pZWd8ju2ya0zEw9gr
        2oeEyD8tvxqbcIxJLTcQT3HC2eveCZ4=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-292-ktKbOGVkNzuUYGd2-Nt67A-1; Mon, 29 Aug 2022 05:14:15 -0400
X-MC-Unique: ktKbOGVkNzuUYGd2-Nt67A-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-340862314d9so106087057b3.3
        for <linux-scsi@vger.kernel.org>; Mon, 29 Aug 2022 02:14:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc;
        bh=OFqf6jpqGJefPSf8RmNEVl/OkAv1jhf4SeDG5OJei+8=;
        b=V253xugxxZQhlpfQr6IP4TzTHy5qDvhIQu8lNUPLQTmNzizWaV3PQKy73DxMxs9JYj
         BBUcQ2LHFs7M8zh5EJhFgoXS90thUX/vlEE15k2GmIAb+uYFIaDEdI49mGztypviOATj
         7wDo1HzlRnoH38CpTPfOwvgmEEYIB9DCcrLci0UX+7Uva6gsk1wiXGl3ocum7YMLrbbU
         Axa8wy0mjcIc5gE5KYs8vnTtVxnpePY7uILjvm0C667gt5w7D7Ory1lIucH2bPPOcKBr
         yr9rDn6zWyspfK1SK0iqFxDz1k7s0//lGpfxb5N0SCucEh5AFxaR9TAk9ek6rGAVlOae
         LAdA==
X-Gm-Message-State: ACgBeo0EOys3JA3753jrbpfr5G0NzhX+E4yz12D08l1tagJqTSO4MQW1
        ZSR9bhFINjxWZBC1rUvOkV5BSEstuflmz/x4ETgfn1kwZmPaNPW0/tmyepJpZJnxjJNgPSFmXDJ
        j0ICsAjr38hAq/QTxM214uNU7jZPp1xmd0xHA6g==
X-Received: by 2002:a25:e209:0:b0:67c:234a:f08c with SMTP id h9-20020a25e209000000b0067c234af08cmr7658997ybe.19.1661764455534;
        Mon, 29 Aug 2022 02:14:15 -0700 (PDT)
X-Google-Smtp-Source: AA6agR6EEqBQtFrRqd+gk9N1hDzBlYSS0Nyoj3xaQ0XvaWtDvbx3VWsXMKjyVI7tr/u2+X1b22viDSDEftHfS56Wq4E=
X-Received: by 2002:a25:e209:0:b0:67c:234a:f08c with SMTP id
 h9-20020a25e209000000b0067c234af08cmr7658991ybe.19.1661764455384; Mon, 29 Aug
 2022 02:14:15 -0700 (PDT)
MIME-Version: 1.0
References: <20220821220502.13685-1-bvanassche@acm.org>
In-Reply-To: <20220821220502.13685-1-bvanassche@acm.org>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Mon, 29 Aug 2022 17:14:06 +0800
Message-ID: <CAFj5m9Ka4-Ee9E7Wo4R7+FrscYZ+GU4EThoweFNRMOR6rPMxJA@mail.gmail.com>
Subject: Re: [PATCH 0/4] Revert "Call blk_mq_free_tag_set() earlier"
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Ming Lei <ming.lei@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

On Mon, Aug 22, 2022 at 6:05 AM Bart Van Assche <bvanassche@acm.org> wrote:
>
> Hi Martin,
>
> Since a device, target or host reference may be held when scsi_remove_host()
> or scsi_remove_target() is called and since te patch series "Call
> blk_mq_free_tag_set() earlier" makes these functions wait until all references
> are gone, that patch series may trigger a deadlock. Hence this request to
> revert the patch series "Call blk_mq_free_tag_set() earlier".

Care to share the deadlock details? Such as dmesg log or theory behind.

Thanks,
Ming

