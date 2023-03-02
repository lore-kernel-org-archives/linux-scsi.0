Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 867CCC7EE36
	for <linux-scsi@archiver.kernel.org>; Thu,  2 Mar 2023 03:51:11 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbjCBDvK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 1 Mar 2023 22:51:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229715AbjCBDvI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2023 22:51:08 -0500
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00BDE32E69
        for <linux-scsi@vger.kernel.org>; Wed,  1 Mar 2023 19:51:01 -0800 (PST)
Received: by mail-qv1-xf35.google.com with SMTP id ks17so10849862qvb.6
        for <linux-scsi@vger.kernel.org>; Wed, 01 Mar 2023 19:51:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=soleen.com; s=google;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fzTjgY6pmauoRhbcUsPGjrkNqmIUEBSmPmq+35HbjTg=;
        b=Rkuxl05ESC6Da+YLV7H66DkVfB1H8MyYtOQTFidtgWYvhbtoHJdCqcJomw/klp4f4p
         XqBDwFnJdEAl0ucWx7CcTrs33pFqclCljuCmVnqweMj8LBzRRcsivrU/C4lkocoI9+yC
         C2mwzEPg/paf33J2Ji903B8EXrlrjNb+QaRv++UOOM2kcOMT0AMqQT7WBx3o8xEdIIht
         Nvihj11tox4hI7iUb3GIKpWeU1TLzUpq0QTI5SuYWe6pIduvYtTpTr3k6O5ufrXdsG9Y
         ok6hT9dX2S36ws37fXeesUMc/TS/FsilHh/kLZ8I7qRn6IZeYRPSJfWQ1VmEwgvv8ykT
         DsSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fzTjgY6pmauoRhbcUsPGjrkNqmIUEBSmPmq+35HbjTg=;
        b=hfvpO2UTMPhu06dr82sfn19jjkL5QO6ZHHq+wIfL0nQ+UvBxd3033kjKcMqa6bIdCp
         5UOvvMs4yQ6LNjkxGEVXd8MENBIi1IKQ5evVKZissSKo7M0yJCmbOTBCQ8wXHotOKhR9
         wQoNmAV2eFCkZKZv1MPKlrqLBwf//LHVi8SdbfPHyWemp2eEDrc1HSLWYhqwng3XV42p
         kxs8WugPuutlVM+v32SmLvYll/4Mw+2y+YwM7irYa+9cTyVEmYD/2bhrBcv7g+EtXf8l
         PVuP7i13UUx4J87L9zBx8MN67pena18bQG6JG+5oy8b/HveV4CLDKPdmcw7LxmQBu+6I
         AdMA==
X-Gm-Message-State: AO0yUKWM9AHpJjfFlKD5ccjJhwNhydWJK6+9dBXT7jqfdFogM4BH5b3B
        CtnwjOdefT4rG7XJXTlnRcoN1iagLlweJFW8c7su+w==
X-Google-Smtp-Source: AK7set8ZL6X672cfoaD5RsaDZWMHx5fDeqg32Dh9XQt6wt53fQihsEF2Gfjbea6c1Hmrrha2XrzWXFkxe3TZdU+vdG4=
X-Received: by 2002:a05:6214:4a43:b0:56e:9089:a447 with SMTP id
 ph3-20020a0562144a4300b0056e9089a447mr2200388qvb.0.1677729061071; Wed, 01 Mar
 2023 19:51:01 -0800 (PST)
MIME-Version: 1.0
References: <Y9KtCc+4n5uANB2f@casper.infradead.org> <8448beac-a119-330d-a2af-fc3531bdb930@linux.alibaba.com>
 <Y/UiY/08MuA/tBku@casper.infradead.org>
In-Reply-To: <Y/UiY/08MuA/tBku@casper.infradead.org>
From:   Pasha Tatashin <pasha.tatashin@soleen.com>
Date:   Wed, 1 Mar 2023 22:50:24 -0500
Message-ID: <CA+CK2bBYX-N8T_ZdzsHC7oJnHsmqHufdTUJj5OrdFk17uQ=fzw@mail.gmail.com>
Subject: Re: [LSF/MM/BPF TOPIC] State Of The Page
To:     Matthew Wilcox <willy@infradead.org>
Cc:     Gao Xiang <hsiangkao@linux.alibaba.com>,
        lsf-pc@lists.linux-foundation.org, linux-fsdevel@vger.kernel.org,
        linux-mm@kvack.org, linux-block@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-nvme@lists.infradead.org, bpf@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Feb 21, 2023 at 2:58=E2=80=AFPM Matthew Wilcox <willy@infradead.org=
> wrote:
>
> On Wed, Feb 22, 2023 at 02:08:28AM +0800, Gao Xiang wrote:
> > On 2023/1/27 00:40, Matthew Wilcox wrote:
> > > I'd like to do another session on how the struct page dismemberment
> > > is going and what remains to be done.  Given how widely struct page i=
s
> > > used, I think there will be interest from more than just MM, so I'd
> > > suggest a plenary session.
> >
> > I'm interested in this topic too, also I'd like to get some idea of the
> > future of the page dismemberment timeline so that I can have time to ke=
ep
> > the pace with it since some embedded use cases like Android are
> > memory-sensitive all the time.
>
> As you all know, I'm absolutely amazing at project management & planning
> and can tell you to the day when a feature will be ready ;-)
>
> My goal for 2023 is to get to a point where we (a) have struct page
> reduced to:
>
> struct page {
>         unsigned long flags;
>         struct list_head lru;
>         struct address_space *mapping;
>         pgoff_t index;
>         unsigned long private;
>         atomic_t _mapcount;
>         atomic_t _refcount;
>         unsigned long memcg_data;
> #ifdef LAST_CPUPID_NOT_IN_PAGE_FLAGS
>         int _last_cpupid;
> #endif
> };

This looks clean, but it is still 64-bytes. I wonder if we could
potentially reduce it down to 56 bytes by removing memcg_data.
Something like this might work:

1. On a 64-bit system flags field contains 19 unused bits, we could
potentially use the free bits in this field.
2. There are up-to 64K memcg ids. So in case this field contains memcg
pointer 16-bit id would be enough to convert to memcg pointer
3. In case memcg_data contains a pointer to a list of memcgs, there
could be a separate hash table data structure that contains pointers
to memcgs for slabs, or other users.

However, I am not sure how that would affect the performance, but it
would be very nice to reduce "struct page" by  8-bytes.

Pasha
