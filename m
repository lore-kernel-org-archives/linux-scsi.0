Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8CBD4C6FA82
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Sep 2022 08:21:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiITIVF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Sep 2022 04:21:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231173AbiITIUM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 20 Sep 2022 04:20:12 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E082B48B
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 01:18:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1663661912;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=nYBXnM221OKkMmYnX56agU4HA29O1+0qE07dmbgFr1Y=;
        b=UYQL6cEZya3EUjGuAX728tyovitTPhL9jkC0WN7/7QCtsPIrwcJ+AxME126OXPejI6Jpo0
        OR4D/2h/lpa8hU9NR/KxM7EYRApNN4J2C204Zt5ulVc5l7W8qmtPlfWQpjFjQXVjYD7FR1
        X/o3F4atgzIWhZLcyjuwVDMW4/R8vC4=
Received: from mail-wr1-f70.google.com (mail-wr1-f70.google.com
 [209.85.221.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_128_GCM_SHA256) id
 us-mta-210-yyRNnJiUOeaOMyiZkviQeg-1; Tue, 20 Sep 2022 04:18:31 -0400
X-MC-Unique: yyRNnJiUOeaOMyiZkviQeg-1
Received: by mail-wr1-f70.google.com with SMTP id e18-20020adfa452000000b00228a420c389so827211wra.16
        for <linux-scsi@vger.kernel.org>; Tue, 20 Sep 2022 01:18:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=nYBXnM221OKkMmYnX56agU4HA29O1+0qE07dmbgFr1Y=;
        b=Y5c2ir8lNSn3Cwtx4usGPKsQ3RIExbv/TVpdWJrOQay+s0tTjFJ8RvngkfybPi1jXd
         PWJpqFeNYaD3HHbjGp5YToulqMitIVIvrhOFLSMc9n4Q+e3kbsSTEeyxI8cdd8jSOzPM
         anFLyEJxOlgx904P9qBs3GFgQfbsI2/enec6f+TMT3GHKO4P5SPdOZIGv4DvE58S50gO
         kwcBzBJpv+Ygu/njBtfNUYrR7DsaifSq18DkqWkfugU0Z53ED9sbD1wauAE8okRghlM5
         73Ec4786XQYIQeK5npVPXaOuwEtwIjW4WYCTZhVUkLcRNQ7Hk95bl9y3QynMEko5557M
         Cqpw==
X-Gm-Message-State: ACrzQf1p5W2PZb6eut3TSi+bvDfpXVCUBMfiWLCOagICu4l0B2Cpje5w
        tZA67HiRgYL5gHg5CHXpCkAm0BBVTt/DTmHaALtZveOcG+NybNMmEeqazTgMq0nBk121GWUA33y
        IJhkgJ1/tk9A4R9cJrtGkZw==
X-Received: by 2002:a5d:4ec5:0:b0:228:6707:8472 with SMTP id s5-20020a5d4ec5000000b0022867078472mr13700973wrv.12.1663661910616;
        Tue, 20 Sep 2022 01:18:30 -0700 (PDT)
X-Google-Smtp-Source: AMsMyM5Gc746EtqOMp12PC/ZhI3qlffavJ9O8HKgnaDgO6702xNdn3VPX99CEZYZBDDZBLY3QzW+vw==
X-Received: by 2002:a5d:4ec5:0:b0:228:6707:8472 with SMTP id s5-20020a5d4ec5000000b0022867078472mr13700953wrv.12.1663661910369;
        Tue, 20 Sep 2022 01:18:30 -0700 (PDT)
Received: from sgarzare-redhat (host-87-11-6-69.retail.telecomitalia.it. [87.11.6.69])
        by smtp.gmail.com with ESMTPSA id z22-20020a05600c0a1600b003b4868eb6bbsm1749112wmp.23.2022.09.20.01.18.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Sep 2022 01:18:29 -0700 (PDT)
Date:   Tue, 20 Sep 2022 10:18:24 +0200
From:   Stefano Garzarella <sgarzare@redhat.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     vdasa@vmware.com, vbhakta@vmware.com, namit@vmware.com,
        bryantan@vmware.com, zackr@vmware.com,
        linux-graphics-maintainer@vmware.com, doshir@vmware.com,
        gregkh@linuxfoundation.org, davem@davemloft.net,
        pv-drivers@vmware.com, joe@perches.com, netdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-rdma@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 0/3] MAINTAINERS: Update entries for some VMware drivers
Message-ID: <20220920081824.vshwiv3lt5crlxdj@sgarzare-redhat>
References: <20220906172722.19862-1-vdasa@vmware.com>
 <20220919104147.1373eac1@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20220919104147.1373eac1@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 19, 2022 at 10:41:47AM -0700, Jakub Kicinski wrote:
>On Tue,  6 Sep 2022 10:27:19 -0700 vdasa@vmware.com wrote:
>> From: Vishnu Dasa <vdasa@vmware.com>
>>
>> This series updates a few existing maintainer entries for VMware
>> supported drivers and adds a new entry for vsock vmci transport
>> driver.
>
>Just to be sure - who are you expecting to take these in?
>

FYI Greg already queued this series in his char-misc-next branch:
https://git.kernel.org/pub/scm/linux/kernel/git/gregkh/char-misc.git/log/?h=char-misc-next

Thanks,
Stefano

