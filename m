Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D1652C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:45:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A542B61056
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Oct 2021 20:45:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhJ1UsL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Oct 2021 16:48:11 -0400
Received: from us-smtp-delivery-124.mimecast.com ([170.10.129.124]:43779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231316AbhJ1UsK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Oct 2021 16:48:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1635453942;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TNZhMUykwMIUELoAtzU5QjLe7Bo0nKj1aB9wpNQKrxs=;
        b=hvJektkMKwuPhqobWuPiFB/wq28dfqURA4yXKyAIybh6uv67Pd4gAweZau77DlDKh0gzf+
        KXnzLepfLuPIwWm42BecmVK8Mg45FkjVehe8lhOD+rWzEardjyIILQWK8vVetSsl5kL6Ri
        5x3/U1N1pikPEsooEYndyYufzL8sjww=
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com
 [209.85.160.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-51-V0O51ZEsPpmxAzpj3t0U6Q-1; Thu, 28 Oct 2021 16:45:41 -0400
X-MC-Unique: V0O51ZEsPpmxAzpj3t0U6Q-1
Received: by mail-qt1-f200.google.com with SMTP id x28-20020ac8701c000000b0029f4b940566so5264329qtm.19
        for <linux-scsi@vger.kernel.org>; Thu, 28 Oct 2021 13:45:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=TNZhMUykwMIUELoAtzU5QjLe7Bo0nKj1aB9wpNQKrxs=;
        b=MbYcLruj5SPxFes/GxnA/91yg+n8oaVbNNJthWDKprOqv7K7zEz7FMf1Q3y2U9aq9y
         eF02FxTYB3KQ4Z9AuZSRwDdPxAWdQPwRK69TBMrJoiIPX7aj37b2ACBeZf0MLVuYkWPX
         CEcBksfxB7QQy17nY2kSgWYMh2kkqEGR3YV5WkH06bvmJBlXJwtq0RX4HCSQ2Xt4M++G
         Ko/dWkZLcG8/fZyf6gsIq5koQCcL3jG5gHDGWSta5oQmXR/+yJ8p9eQyCgGrNXtuw0uI
         BhDUCCE1dpyvc/F/g/FiQ7dhLaXwMVfnnEgza83DhGXrD9+JrNJejQMVbTad+hJ+QOBv
         4YLA==
X-Gm-Message-State: AOAM531LpxqK1TpkuVxBZN7c1C2cBUzaimzhk1eLKZZD6AZPtlcl+jz6
        /mfPuBnc7Fp1IFylBjHdooqLthZ4KK4WQ7eew4MOZMGJQ1Ttnd2JNOUrpgTSifgqa6oHiTodOsj
        ZqFWVNxkV8zespj0nX+l2sQ==
X-Received: by 2002:ae9:ef0d:: with SMTP id d13mr5581539qkg.290.1635453940270;
        Thu, 28 Oct 2021 13:45:40 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJzrko4/M6m5nD78DZNZXLvnEcUWi/jbBgGecgTrbqTtQkBLjwi/xUNuPWpSc4bH0oCzMJtzhg==
X-Received: by 2002:ae9:ef0d:: with SMTP id d13mr5581534qkg.290.1635453940133;
        Thu, 28 Oct 2021 13:45:40 -0700 (PDT)
Received: from emilne (nat-pool-bos-t.redhat.com. [66.187.233.206])
        by smtp.gmail.com with ESMTPSA id q14sm2651139qtl.73.2021.10.28.13.45.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 28 Oct 2021 13:45:39 -0700 (PDT)
Message-ID: <de901c38a3a5282cff9e5e5a604b0a152c89693d.camel@redhat.com>
Subject: Re: [PATCH 2/2] scsi: core: simplify control flow in
 scmd_eh_abort_handler
From:   "Ewan D. Milne" <emilne@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 28 Oct 2021 16:45:38 -0400
In-Reply-To: <yq1mtmtygg2.fsf@ca-mkp.ca.oracle.com>
References: <20211025143952.17128-1-emilne@redhat.com>
         <20211025143952.17128-3-emilne@redhat.com>
         <yq1mtmtygg2.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-10-27 at 23:31 -0400, Martin K. Petersen wrote:
> Ewan,
> 
> > Simplify the nested conditionals in the function by using
> > a label for the error path, and remove duplicate code.
> 
> Oh, I see you shuffled things for the follow-on patch. That's
> better. I'd still like the stable fix to be smaller, though.
> 

Sure, let me work on it a bit more to get the first patch as
small as possible.  I'll submit a v2.

-Ewan


