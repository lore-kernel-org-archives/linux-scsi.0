Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-9.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74914C56201
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 19:03:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0B556206CA
	for <linux-scsi@archiver.kernel.org>; Wed, 25 Nov 2020 19:03:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="I/hFdSZ6"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731429AbgKYTC4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 25 Nov 2020 14:02:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54358 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730650AbgKYTC4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Nov 2020 14:02:56 -0500
Received: from mail-ej1-x644.google.com (mail-ej1-x644.google.com [IPv6:2a00:1450:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00A0AC0613D4;
        Wed, 25 Nov 2020 11:02:55 -0800 (PST)
Received: by mail-ej1-x644.google.com with SMTP id o9so4550447ejg.1;
        Wed, 25 Nov 2020 11:02:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Z/DMutLBZGxo9NPXVt+YC6BHVS50FEMIayBNNBBTrxg=;
        b=I/hFdSZ61wW4zv+ApmY7lxUsaIp8/Ht/WLIjx4mGzVGJkA07n2VIuxhY3jEvUXPQvv
         ZNjIjH6KgoPIfMWoSjoaxhaQNNkUwhwCeuxTKLhQZfX3QuMcY/ttJ50cXsMHM+ii0nir
         aE9+flY3yltw4sgY2OEoHQaAAyG3WiqH64Hwxl/PRH/K9QIg7kFD93Ackwr7eAhKS/nv
         NUhd+259EsOF7v1Kvy2uj1afCr02O28+Hy+GjeO4MBqZtON/cHP4noWjjn92vDSTKtkO
         /kmNA/brbx92McZ2es0qIxUEbsBZlcwfNnS/PgUWni1yEw4/6DMtBFjI8mnEk16di+P9
         B12w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Z/DMutLBZGxo9NPXVt+YC6BHVS50FEMIayBNNBBTrxg=;
        b=a5NG2kI3INyvdrxCc+Z9aB4T/9NPzM+C9bB2wxhzwrP8YDtE/xj7bVFe44+HX4QZlA
         cVwxTrFHSG9XqILyhEWDeT8HqCvOfvbAMUve4qCgsAuYWGnQRDB/+h/S3Qg9oTGRW/Bh
         Vx4KyiFvqd4E+zv8OL8wWV3HgPnZRK9Xy9O4DkB/8LG/hHlrT7EQNaHcO2BSaZzVpxQ6
         pFFo5bFfh1jn8DpI7LOQ16gWYHJHmJMfM2yvEVapwPIBI7mr0QtikjiKkXezyCeEz84b
         nuWTeUYNhTO+z5dL3qlkjNB5QewNUazJ/PNHi+32EvCm+2sKAqlb78+Wfdt8O1OIec/a
         80ug==
X-Gm-Message-State: AOAM5330yOfoKDRH87M8AdmjA8I1ilTqe52X1IUvg+4S2NezXbA7rEsu
        BaQl7E2tm+nAuBNDnsk4K+E=
X-Google-Smtp-Source: ABdhPJxkgZy0zQvvllzF/7233lrCrSWXzA0K5vAOZZHx4EYh2eVjg1/FdLcZ0he5sbY8SpK7RzLMig==
X-Received: by 2002:a17:906:35da:: with SMTP id p26mr4512672ejb.256.1606330974561;
        Wed, 25 Nov 2020 11:02:54 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee2a.dynamic.kabel-deutschland.de. [95.91.238.42])
        by smtp.googlemail.com with ESMTPSA id s19sm1271788ejz.69.2020.11.25.11.02.52
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Wed, 25 Nov 2020 11:02:53 -0800 (PST)
Message-ID: <4e84df2ecb17dfb1fc8070953d8690b29615f409.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: ufs: Refector ufshcd_setup_clocks() to
 remove skip_ref_clk
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     asutoshd@codeaurora.org, nguyenb@codeaurora.org,
        hongwus@codeaurora.org, ziqichen@codeaurora.org,
        rnayak@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com, saravanak@google.com, salyzyn@google.com,
        Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tomas Winkler <tomas.winkler@intel.com>,
        Bean Huo <beanhuo@micron.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Satya Tangirala <satyat@google.com>,
        open list <linux-kernel@vger.kernel.org>
Date:   Wed, 25 Nov 2020 20:02:52 +0100
In-Reply-To: <9484cba7b95c6c6fcbafd96bc35c1dee@codeaurora.org>
References: <1606202906-14485-1-git-send-email-cang@codeaurora.org>
         <1606202906-14485-2-git-send-email-cang@codeaurora.org>
         <9070660d115dd96c70bc3cc90d5c7dab833f36a8.camel@gmail.com>
         <d112935400a5ef115a384a4c753b6d04@codeaurora.org>
         <0b0c545d80f9a0e8106a634063c23a8f0ba895fc.camel@gmail.com>
         <9484cba7b95c6c6fcbafd96bc35c1dee@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-11-25 at 20:28 +0800, Can Guo wrote:
> > On Wed, 2020-11-25 at 08:53 +0800, Can Guo wrote:
> > > > > +       bool always_on_while_link_active;
> > > > 
> > > > Can,
> > > > using a sentence as a parameter name looks a little bit clumsy
> > > > to
> > > > me.
> > > > The meaning has been explained in the comments section. How
> > > > about
> > > > simplify it and in line with other parameters in the structure?
> > > > 
> > > 
> > > Do you have a better name in mind?
> > > 
> > 
> > no specail input in mind, maybe just "bool eternal_on"
> 
> It is like plain "always_on", but it cannot tell the whole story.
> If it is not something crutial, let's just let it go first so long
> as it does not break the original functionality. What do you say?
> 
> Thanks,
> 
> Can Guo.

Can, 

yes, it is not functional change, but always_on_while_link_active is
too fat, and not non-productive way.
anyway, 

Reviewed-by: Bean Huo <beanhuo@micron.com>


