Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 89E69C7EE2D
	for <linux-scsi@archiver.kernel.org>; Tue, 23 May 2023 17:28:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237843AbjEWR17 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 May 2023 13:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237760AbjEWR14 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 May 2023 13:27:56 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935F41A7
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:27:52 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-64d604cc0aaso13591b3a.2
        for <linux-scsi@vger.kernel.org>; Tue, 23 May 2023 10:27:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684862872; x=1687454872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=v73SNWkJH3oIBfAgDFu9oHuE573I+sUvec66+59twXo=;
        b=e2z3Kg3pPBYPGUfrCD+XwFdRW9xZfNyCbg2bb0DXZFzDjqKkk8/aCdUxFSRmxvwqBI
         omNhossXs9KI4w2k0bWuEppgH7brABawOb3OYUCcBgrtQZ7Gq1dULK1tIIX3JunmGeG9
         IxooEGBc4NR7zMYGNXVZz7G77MuzJ00JgtWRQ=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684862872; x=1687454872;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=v73SNWkJH3oIBfAgDFu9oHuE573I+sUvec66+59twXo=;
        b=E1s5bhCICHtNHqdeHvjHaBDNZj51q/H06dtJQ0mXA6ftDogy+ivcDNTlY4BZSHWxrs
         O2S2AnojTrx/B2qkQ7Xt2hSD5MblICoEZuNvqTpJ6GpTlskGkFUao8fZ+YHsxWhmSLUj
         rwp+hvJhbcPswZh745rXZYn99CAmeYN4Y2B8ejJ46fSIcUWGafimAi+7H+gWWLLRpcgT
         jrXVXJapDStId6q/y0peeCfxa+C0df5FlAEP6utId2PVZix29j0DotdzS0ZiUExVMUFa
         /gjLAuWaJH5gUngm7igIKkD/xoWPb7OiHUb4QF5GwHkiViyA6x2gjoBHdQSJJnMHcZNJ
         8IdQ==
X-Gm-Message-State: AC+VfDyeb+OW89E0EkSUdtHO1lNyVa1N+lskX4fWKo1geAxIO/OfrJaK
        OhWe1A2pe/e8b4oIEcu/A6zDWLHLo2o/q4CPhGY=
X-Google-Smtp-Source: ACHHUZ5Xdk89VGymw7Iyy95VEjMiZMV432tMAIVjPE0sOuBGYOXzvURg046DkfzdvUECWza0gKecUA==
X-Received: by 2002:a05:6a20:3d83:b0:104:bd18:9857 with SMTP id s3-20020a056a203d8300b00104bd189857mr18080676pzi.11.1684862871990;
        Tue, 23 May 2023 10:27:51 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id x7-20020a62fb07000000b0063d670ad850sm6182343pfm.92.2023.05.23.10.27.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 10:27:51 -0700 (PDT)
Date:   Tue, 23 May 2023 10:27:51 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH 2/2][next] scsi: lpfc: Use struct_size() helper
Message-ID: <202305231026.594B2F913D@keescook>
References: <cover.1684358315.git.gustavoars@kernel.org>
 <99e06733f5f35c6cd62e05f530b93107bfd03362.1684358315.git.gustavoars@kernel.org>
 <202305171601.B3FF9D0BB@keescook>
 <ZGzQt2VFG4P/Vufn@work>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZGzQt2VFG4P/Vufn@work>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, May 23, 2023 at 08:41:59AM -0600, Gustavo A. R. Silva wrote:
> On Wed, May 17, 2023 at 04:01:47PM -0700, Kees Cook wrote:
> > On Wed, May 17, 2023 at 03:23:01PM -0600, Gustavo A. R. Silva wrote:
> > > Prefer struct_size() over open-coded versions of idiom:
> > > 
> > > sizeof(struct-with-flex-array) + sizeof(typeof-flex-array-elements) * count
> > > 
> > > where count is the max number of items the flexible array is supposed to
> > > contain.
> > > 
> > > Link: https://github.com/KSPP/linux/issues/160
> > > Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> > > ---
> > >  drivers/scsi/lpfc/lpfc_ct.c | 6 ++----
> > >  1 file changed, 2 insertions(+), 4 deletions(-)
> > > 
> > > diff --git a/drivers/scsi/lpfc/lpfc_ct.c b/drivers/scsi/lpfc/lpfc_ct.c
> > > index e880d127d7f5..3b95c56023bf 100644
> > > --- a/drivers/scsi/lpfc/lpfc_ct.c
> > > +++ b/drivers/scsi/lpfc/lpfc_ct.c
> > > @@ -3748,8 +3748,7 @@ lpfc_vmid_cmd(struct lpfc_vport *vport,
> > >  		rap->obj[0].entity_id_len = vmid->vmid_len;
> > >  		memcpy(rap->obj[0].entity_id, vmid->host_vmid, vmid->vmid_len);
> > >  		size = RAPP_IDENT_OFFSET +
> > > -			sizeof(struct lpfc_vmid_rapp_ident_list) +
> > > -			sizeof(struct entity_id_object);
> > > +			struct_size(rap, obj, rap->no_of_objects);
> > 
> > Has rap->no_of_objects always been "1"? (i.e. there was a prior
> > multiplication here before...
> 
> Mmh.. not sure what multiplication you are talking about. I based these
> changes on the fact that rap->no_of_objects is set to cpu_to_be32(1);
> for both instances. It doesn't show up in the context of the patch, so
> here you go:
> 
> 3747                 rap->no_of_objects = cpu_to_be32(1);

Ah-ha! So, yeah, this patch is bad then, since no_of_objects will be a
big-endian "1".

This change:

+			struct_size(rap, obj, rap->no_of_objects);

needs to explicitly be:

+			struct_size(rap, obj, 1);

Or, alternatively, just drop the patch entirely.

-- 
Kees Cook
