Return-Path: <SRS0=749Z=X4=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.4 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 52992C10F14
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 18:37:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2544620865
	for <linux-scsi@archiver.kernel.org>; Thu,  3 Oct 2019 18:37:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LiDNR0sx"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389445AbfJCSh1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 3 Oct 2019 14:37:27 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:33435 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2389444AbfJCSh1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 3 Oct 2019 14:37:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1570127846;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aRF9kPah5DKTJt09B4SdbjbSrVQuRqyXTFnwgzzjJFY=;
        b=LiDNR0sxoCduKPKFRrxBwRCwZbi2HtxFGnhUBU4RJUsSg/s1yiSIvFs5DCNMqPC0m7anXw
        Ok7LxMFky4tiYmpMPSVuhQMGTLNo9a068i0XZuYHMn3DPHwKbPJ/WOyyg18+LMFgd1T5/D
        xdovQ6NK54WGmHRYCKvsV163yw0GMHI=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-136-PBSq7NopMTKXQoGaqJdbzg-1; Thu, 03 Oct 2019 14:37:24 -0400
Received: by mail-qk1-f198.google.com with SMTP id o133so3662957qke.4
        for <linux-scsi@vger.kernel.org>; Thu, 03 Oct 2019 11:37:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=P65jf9IkuorBXo9fByas2+hnyAEOoVGAUKjEPY43/E4=;
        b=GRJPfq4b6S8Lf3uw1hJKymSsz3UvRZN14fGAg530XRdv/L02q1blAAsmoo3hkZbMwz
         PFUamjB772aN5FtKob9tR5lapYnckon9nD1we1qkcyLVfnNBErIIoTYEWrbLxnhhuqYK
         yIVWkZd6KnLzrOKi64qyPmsjMGCSgG9liIJ8RJK6GlyVugj79DykL1k0Dbipn48QgEgX
         vxTthPaOMhVgSTANk0UDFtNcRwYvcrFR7kW1BuiLqDTh2HFQhjwu91WBc2n1NuDKnAwa
         npNv1OJAhXifFQTbKEgBgJlIGqHVPRa9As0nZbPjmO7pHqym0xOO+iCN512lOUFSgjrV
         /Exw==
X-Gm-Message-State: APjAAAU0GiO9QEeAs69yJNpXhWkNjyLbHo/O4Eh550XZH/Pz/tbHfzVa
        ojPWsW6lcWbrghiKrjyo9hGFsO0+nePzmZhBvlWhMozvTe71qDh+TIoN5l4Vp0DVleSW0nNwYOw
        GlaImc60PDrPuBXRWOYpEBQ==
X-Received: by 2002:a0c:94fc:: with SMTP id k57mr9659915qvk.210.1570127844039;
        Thu, 03 Oct 2019 11:37:24 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwYjR9KPPW/bPt2tQRe+FL44DkGG0OglpSIYY1TYp3hh0I3MEwzA1UON8ry5cxrQne5nB96WQ==
X-Received: by 2002:a0c:94fc:: with SMTP id k57mr9659859qvk.210.1570127843583;
        Thu, 03 Oct 2019 11:37:23 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id n4sm1686830qkc.61.2019.10.03.11.37.22
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 03 Oct 2019 11:37:23 -0700 (PDT)
Message-ID: <7928c78bb3e7c7a37b6b75683233bad841c43d9b.camel@redhat.com>
Subject: Re: [Open-FCoE] FICON target support
From:   Laurence Oberman <loberman@redhat.com>
To:     Christian Svensson <christian@cmd.nu>,
        Hannes Reinecke <hare@suse.de>
Cc:     Bart Van Assche <bvanassche@acm.org>, linux-scsi@vger.kernel.org,
        fcoe-devel@open-fcoe.org
Date:   Thu, 03 Oct 2019 14:37:22 -0400
In-Reply-To: <CADiuDASkpY_2HD4rfc2hxDOQPkbxKpgVv1EeSS60ZZhwqag_2w@mail.gmail.com>
References: <CADiuDASOCJbnwLs-LEp0aCX+T4dMvFfKQv_zsypHW-iSF8wW=Q@mail.gmail.com>
         <5c5609d8-e4b4-3561-ece9-93746fd46206@acm.org>
         <69308786-81d8-a9df-2d7b-df37c3f93026@suse.de>
         <CADiuDATRN_85Tu3uw1WBtY=m8KrqKV5zpYrsggYdAOH23dwU=Q@mail.gmail.com>
         <9612602b-29c0-04d7-b76e-5593d0936eba@suse.de>
         <CADiuDARPit+kKtQe-UGktUuxEXRMvoq7PGVPKo9DrLRkSTwNAA@mail.gmail.com>
         <17f0639d-bd44-c193-af29-df539be722fe@suse.de>
         <CADiuDASfjq=xyuTEF2VZtb+dV78_VdMRkfFrr4ujs0zPXjv7Ew@mail.gmail.com>
         <CADiuDASkpY_2HD4rfc2hxDOQPkbxKpgVv1EeSS60ZZhwqag_2w@mail.gmail.com>
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7)
Mime-Version: 1.0
X-MC-Unique: PBSq7NopMTKXQoGaqJdbzg-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2019-10-03 at 18:38 +0200, Christian Svensson wrote:
> Hi,
>=20
> An update if you're curious about this. I found that DE5-Net FPGA
> cards are reasonably priced right now on eBay, so I started a project
> to implement FICON target support. You can find more information on
> github: https://github.com/bluecmd/fejkon
>=20
> Essentially it's a 4x SFP+ port card for $300-$400 that I will export
> as "fc0-3" netdev's using ARPHRD_FCFABRIC type.
> This allows libpcap to capture raw FC directly on the netdev. The
> devices will be fully TX/RX capable.
>=20
> FICON and normal FCP will be implemented in userspace by reading /
> writing packets straight to the netdev.
> I assume this will be CPU intensive but for my purposes it should be
> fine. Maybe it is a good solution for people that want a more modern
> Fibre Channel analyzer as well.
>=20
> Regards,
> Christian

Very interesting and thanks for sharing
Regards
Laurence

