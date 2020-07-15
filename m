Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DEAR_SOMETHING,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6EADEC433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 14:11:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4CA7A205CB
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 14:11:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PsQvPj2f"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbgGOOLd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 10:11:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:20781 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726332AbgGOOLc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 10:11:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594822291;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MJRQJtBqYrdIScDOMxZSe6bZiKvtpdga/BVlfd0A6rw=;
        b=PsQvPj2foruSlSAK1RzDknQ881q9vPqVarGiN+SHHFI4PoeY03HGsVCG5DjTqWhox/t0p8
        87T14cBz9z/AqKLo59lYvilLY1UJRYlFfpi8pswH4r3QXtndAPgIAYl0i4R7uDQTSq0VYq
        fFipnVreqokXdifotnHLsvJpc0Twh+4=
Received: from mail-qk1-f199.google.com (mail-qk1-f199.google.com
 [209.85.222.199]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-328-ZuzJMjEiO-yva9KjBrou4g-1; Wed, 15 Jul 2020 10:11:29 -0400
X-MC-Unique: ZuzJMjEiO-yva9KjBrou4g-1
Received: by mail-qk1-f199.google.com with SMTP id j79so1561257qke.5
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 07:11:29 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=MJRQJtBqYrdIScDOMxZSe6bZiKvtpdga/BVlfd0A6rw=;
        b=b7Xh4Gv//y826ngL6Dw1GsElYGK3e5bMd2bgW64AhxZjTg4zE/qPuVDcRiZECtlc7s
         DyJQiYl2QP3ITEEd1K5i3iMrAdq7JK/mUP2B4CmFA5htkRD9ziPmpN7dg9l0taiZko1f
         fmSsLBkPNqUxjDmzXuYnKhcMBEzJfvMxDriWTohKAnHnYJxA777M2nX/5pp/N9KiJ0nf
         cmfUK67g8bawm2DpmNeW85Gw1aTrUJw9UnufCuFWuK+Rp4xzYyZdW8Pe23zxdjM33GBW
         0sM3E7ILETKvP6MrJKGsoEGkYuMaYEPJH+ZnCzztd7lHa42z3UVzYpUqXlK2neEhrBsY
         ajsw==
X-Gm-Message-State: AOAM533m/u29nnbzAm3tj8rS+itGExv7a2MZAgTMQIHWcrPmZVCVdiBx
        lawEH5lT0Ataadcr/+3bS+GlupdC2HxVKgT/uS8auFgW615dilYeDROxWxVig8HVGCSTkF0Yt3w
        n9WuGKDh0rBJCZN+X52AFaA==
X-Received: by 2002:ac8:4f50:: with SMTP id i16mr9693476qtw.216.1594822288620;
        Wed, 15 Jul 2020 07:11:28 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzBIm7L9+dR1XhOSSlLhWxbMcf82TWnR2bqcmt5/V9o+GJDcQO0jJ8+d+rkNBY4JSWvzSj6sQ==
X-Received: by 2002:ac8:4f50:: with SMTP id i16mr9693449qtw.216.1594822288306;
        Wed, 15 Jul 2020 07:11:28 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id m26sm3458272qtc.83.2020.07.15.07.11.27
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 07:11:27 -0700 (PDT)
Message-ID: <88d19544aa6d74d5780379eef0ffa1012d30066a.camel@redhat.com>
Subject: Re: LIO Scsi Target
From:   Laurence Oberman <loberman@redhat.com>
To:     Sadegh Ali <sadegh.ali.2084@gmail.com>, linux-scsi@vger.kernel.org
Date:   Wed, 15 Jul 2020 10:11:25 -0400
In-Reply-To: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
References: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-15 at 12:18 +0430, Sadegh Ali wrote:
> Dear sir
> 
> we are considering to build SCSI Target system with ZFS filesystem
> backend using Linux
> I searched that two modules are available for Linux SCSI target, LIO,
> and SCST
> but it seems LIO project that streamed to the kernel is not updated
> for a while (about 7 years)
> Is the LIO module project dead? or suspended?
> Is any person or community available to respond to technical problems
> and fix bugs or develop new features or support new hardware?
> 
> with best regards
> 

There has definitely been a pause in the LIO target code updates.
In fact we use it a lot here (qla2xxx and SRP) at Red Hat but we have
remained on the 4.5 kernel with my jammer patch in the lab because
later updates have been  seeing lots of problems.
I reported this to Marvell and they were looking into it but its been a
long time.

The ISCSI module is very stable but my issues had been mostly with the
qla2xxx target module.

Many vendors who have this in their products took a snapshot many
kernels back and I am not sure how much has been shared back to
upstream.

I have not tested recent upstream kernels for ages so I am also
intrested to know who has been using either the qla2xxx modules or the
SRP module successfully with recent kernels.

Regards
Laurence

