Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47022EB64DD
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Aug 2023 21:20:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232839AbjHNVUC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Aug 2023 17:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232846AbjHNVT6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Aug 2023 17:19:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F251733
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 14:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692047937;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=vLYjJnIRIAUyriMJxKfff//gose6O9+YEAXEmSpK93M=;
        b=aN3YUnN6lMhYoV4FR56QDifA+Pf+Z3zCbBWi2leWvHxLuwSKnpKUiGEiYGSFEGUr5pjJQy
        yGleuEnzpFwvDFg/7T1MMtCJudtK/J07U0sK9BX1boAwdTZNP3jZGs4as/NBuxrys1GeYv
        Y1RYgUxe+BvZPvooz5iwBI3Zl1VPKHA=
Received: from mail-yw1-f197.google.com (mail-yw1-f197.google.com
 [209.85.128.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-604-jY7GoEsRMIK4iqUIAWndpQ-1; Mon, 14 Aug 2023 17:18:50 -0400
X-MC-Unique: jY7GoEsRMIK4iqUIAWndpQ-1
Received: by mail-yw1-f197.google.com with SMTP id 00721157ae682-586a5ac5c29so63809617b3.1
        for <linux-scsi@vger.kernel.org>; Mon, 14 Aug 2023 14:18:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692047930; x=1692652730;
        h=user-agent:in-reply-to:content-disposition:mime-version:references
         :message-id:subject:cc:to:from:date:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=vLYjJnIRIAUyriMJxKfff//gose6O9+YEAXEmSpK93M=;
        b=jV1qal5gaFHRf2RknEtk3Tz0ZKU9aL6xhwzpq6ZjxmWwHubeO9teXqlViq9KuW6vwP
         iqZ4ROVpBY9z05sV7rSGw2dZ+qyuBOFr4ZqUdxTwgQGRei/iFwJyQwvoISYekuIRNNPg
         7AijjAgBS4v5LDCpaoOnw8UG3vhkfgrh59mRHcEth3EMzV5BjzcTqcX3rRyUvuSlKe9u
         2wFWj/VaizMudooEbHNLAeZ1p7sl7ur4NTRRgAaw5IoMQtOwOXrCdzft+5V+7CrMehYP
         vgJ9PSOY+oDoyV6rlnPGglmvUpayir/Y5qyLgoa+dZakRuv3BfojRPr5yDwe663VxfJr
         2gmg==
X-Gm-Message-State: AOJu0YwwydU6Z1W6k3q5LFJHYIbPq0PgiYuxRePrZCb8mIW4sUp13FTI
        aEb/UE9kUsnryLtIju6SvRg5bCkP/Au1o0Z8Hvv0GPUip7gELbZpvH2waWC38viOeKY4jqwGTCl
        LMIvweeDdpL5NlP+B5UONgg==
X-Received: by 2002:a81:c30a:0:b0:577:1a4e:51f with SMTP id r10-20020a81c30a000000b005771a4e051fmr10676438ywk.39.1692047930156;
        Mon, 14 Aug 2023 14:18:50 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IHO+bDMZUZsF60J7boyFJj8Dmlloyous2h7m+z4zdyZrHWM3pIEvs8ji7OnOXAo43dEgw56pw==
X-Received: by 2002:a81:c30a:0:b0:577:1a4e:51f with SMTP id r10-20020a81c30a000000b005771a4e051fmr10676428ywk.39.1692047929907;
        Mon, 14 Aug 2023 14:18:49 -0700 (PDT)
Received: from brian-x1 (c-73-214-169-22.hsd1.pa.comcast.net. [73.214.169.22])
        by smtp.gmail.com with ESMTPSA id z20-20020a81a254000000b00583b5564c1dsm2990707ywg.135.2023.08.14.14.18.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Aug 2023 14:18:49 -0700 (PDT)
Date:   Mon, 14 Aug 2023 17:18:47 -0400
From:   Brian Masney <bmasney@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        alim.akhtar@samsung.com, avri.altman@wdc.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hugo@hugovil.com, quic_nguyenb@quicinc.com
Subject: Re: [PATCH v3 1/2] scsi: ufs: core: convert to dev_err_probe() in
 hba_init
Message-ID: <ZNqaN5+Ft5PAE43x@brian-x1>
References: <20230814184352.200531-1-bmasney@redhat.com>
 <20230814184352.200531-2-bmasney@redhat.com>
 <f01040be-dfa5-fe60-fba5-410fccc1d50e@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f01040be-dfa5-fe60-fba5-410fccc1d50e@acm.org>
User-Agent: Mutt/2.2.9 (2022-11-12)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 14, 2023 at 12:31:31PM -0700, Bart Van Assche wrote:
> On 8/14/23 11:43, Brian Masney wrote:
> > diff --git a/drivers/ufs/core/ufshcd.c b/drivers/ufs/core/ufshcd.c
> > index 129446775796..409d176542e1 100644
> > --- a/drivers/ufs/core/ufshcd.c
> > +++ b/drivers/ufs/core/ufshcd.c
> > @@ -9235,8 +9235,9 @@ static int ufshcd_variant_hba_init(struct ufs_hba *hba)
> >   	err = ufshcd_vops_init(hba);
> >   	if (err)
> > -		dev_err(hba->dev, "%s: variant %s init failed err %d\n",
> > -			__func__, ufshcd_get_var_name(hba), err);
> > +		dev_err_probe(hba->dev, err,
> > +			      "%s: variant %s init failed err %d\n",
> > +			      __func__, ufshcd_get_var_name(hba), err);
> >   out:
> >   	return err;
> >   }
> 
> This opportunity could have been used to improve the grammar of the reported
> error message. Anyway:

That's what I originally did in v1, however I was asked to split out the
cleanup into a different patch. Split out, I think the cleanup on it's
own isn't worth it's own patch, so that's why I dropped it.

https://lore.kernel.org/lkml/20230808142650.1713432-2-bmasney@redhat.com/

> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks!

Brian

