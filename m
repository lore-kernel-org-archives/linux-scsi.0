Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.6 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 708FAC433E2
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 13:41:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4BBE922365
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 13:41:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Bcwu71ba"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726935AbgGNNlr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 09:41:47 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:49461 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725906AbgGNNlq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 14 Jul 2020 09:41:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594734105;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=T4Plj9PfUi2DeyVprMWl3dCa4CGzKbm/4lsd0XiSja4=;
        b=Bcwu71balzmXhR8NHkAJdwaS9tDSiZh7xEn0KmfaD0V+rFRq43KCpYzly1hEK8cu6A/NYS
        CFEeoHsqjMIaNEvUTzaHdPfxm8E234E27pc4mgEk9zPmjAMx6+7QtqefF1Hf7PwH6WtdBF
        nzbda/YpScImoIaJtBFkjYsKPwHkbBQ=
Received: from mail-qv1-f70.google.com (mail-qv1-f70.google.com
 [209.85.219.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-486-hMWqxeT8NXyuaRMDhpQwMA-1; Tue, 14 Jul 2020 09:41:41 -0400
X-MC-Unique: hMWqxeT8NXyuaRMDhpQwMA-1
Received: by mail-qv1-f70.google.com with SMTP id t12so9672230qvw.5
        for <linux-scsi@vger.kernel.org>; Tue, 14 Jul 2020 06:41:41 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T4Plj9PfUi2DeyVprMWl3dCa4CGzKbm/4lsd0XiSja4=;
        b=NL9QCgpqU3wevMIq145gFMFB9o1U/CYcMkI/dcNTYThzmCTmL+3mwREKpvBnmeiqZI
         eUcBHcAT95PeXyJT3UXp313G+vTO2wb2i+LVvyEq6RnZwVTDCKPu5vMKad6W0ckil0JN
         DTsuCkfaodK+i6P3cVCV1GTodC2PGQTPJeAYfKt8PxxnrwEBTxPptkBl9BhWIavXDKqS
         ql5784UX56Gib7PrQkG4toHoviIfdpb8/yiQcDgOYT+JR7bqINNef8kGRg/dNif+oSu9
         x0dvcCR1hzzD5jN9CumxUAn6u2J4AUHZg1++wUXInWuZ/W3UZ5vaAp/x/KOo5sC5qey0
         26EA==
X-Gm-Message-State: AOAM531svGAvR+YkbyYYVH+b5plAzcUW7jIhnOr96hEYPSPEzIlslBXV
        UutnQXg0pKYc9KHxG0Q5I/j50glqQNvYRQG/iITximsb7S9ZGuG5IGjKYfSezvCdD3YTKpjrjJx
        T7M4/+8rrfCf5mouu+bEXkg==
X-Received: by 2002:a37:aa10:: with SMTP id t16mr4272907qke.422.1594734101032;
        Tue, 14 Jul 2020 06:41:41 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJziG2YbOKFb2g0BJJyzZfVgAajsdjdGVHFoN/bKmwEZB4C2JhP+jIFzo2beCbsMKrbWZe6fsg==
X-Received: by 2002:a37:aa10:: with SMTP id t16mr4272886qke.422.1594734100740;
        Tue, 14 Jul 2020 06:41:40 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id i57sm25362566qte.75.2020.07.14.06.41.38
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 14 Jul 2020 06:41:39 -0700 (PDT)
Message-ID: <92deedd5d128361947b1381a1309606c67d082e6.camel@redhat.com>
Subject: Re: [PATCH] iscsi: qedi (qed_int.c) disable "MFW indication via
 attention" SPAM every 5 minutes
From:   Laurence Oberman <loberman@redhat.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-scsi@vger.kernel.org, QLogic-Storage-Upstream@cavium.com,
        netdev@vger.kernel.org, aelior@marvell.com,
        GR-everest-linux-l2@marvell.com
Date:   Tue, 14 Jul 2020 09:41:37 -0400
In-Reply-To: <20200713.175825.1534786004215530376.davem@davemloft.net>
References: <1594674941-32092-1-git-send-email-loberman@redhat.com>
         <20200713.175825.1534786004215530376.davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2020-07-13 at 17:58 -0700, David Miller wrote:
> From: Laurence Oberman <loberman@redhat.com>
> Date: Mon, 13 Jul 2020 17:15:41 -0400
> 
> > This is likely firmware causing this but its starting to annoy
> customers.
> > Change the message level to verbose to prevent the spam.
> > 
> > Signed-off-by: Laurence Oberman <loberman@redhat.com>
> 
> "iscsi:" doesn't belong in this Subject line.
> 
> Please look at recent changes to this driver and what commit header
> line subsystem prefixes and layout is being used.
> 
> Thanks.
> 

Hi Dave, I will resend.
The challenge is that while the proposed fix is in qed_int.c it only
manifests when the ISCSI persinality is enabled on the card.

I will set as appropriate header but mention the qedi ISCSI connection
in the V2 of this patch.

Thanks
Laurence

