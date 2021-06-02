Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37579C47083
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 21:07:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 146CE613EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 21:07:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229620AbhFBVIm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 17:08:42 -0400
Received: from mail-ed1-f47.google.com ([209.85.208.47]:44872 "EHLO
        mail-ed1-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229541AbhFBVIl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 17:08:41 -0400
Received: by mail-ed1-f47.google.com with SMTP id u24so4525019edy.11;
        Wed, 02 Jun 2021 14:06:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=1s237lY/zDGiCSLNMNYFLWwPxsCMomPG/HHc5c6xiWk=;
        b=qshs3QjH6ea6wFSnZCa0aBOM7j1av/OEZbx3CwX9cK5dUzys71Z9vT/cW37ZJgaC2q
         U940eOXuAKqkdlOUjwXyCfDg5Jr9DUw7uYKQqP/xbxvf9D4Q8557QgBASz+PFeilHSSm
         oWklJmZJlPde9QhAhjY+L8BOYifCiAGMLgpIrbD6Tq92nQy4aqic8eRKjN/bZktr+QeT
         o5Iyz7Klj7wYG6QXM+Ilv3HEjhh+f77Kr1JemoLt3hDK4/pTsIWaERmzmZaSYXx3sJu3
         BK6xgxtS85Fiav1Up0IHpG+jvZI04K0t0v9Yp7Z352zJJT2stk8t46XdsC/o2BakYudA
         oRSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=1s237lY/zDGiCSLNMNYFLWwPxsCMomPG/HHc5c6xiWk=;
        b=o1vtVmj/xT3xYtv4Hm/ss2+fQRMZENYJYDOOZIOniKldnwXYzkSR598bh54b1dcpVo
         WRCY7H9yI6fzXRsfT8+84Vw02RuhgEqYOpJ86yNhSmTlWvEpfcXhblQ16MVpp/eyu33x
         L9rVm627gQ2K21+B1dS2SErUgaAKkIDQJjHyKy6FLiY5e0OKX3Yi3tR54nELzWKhSkIV
         Cbo9MIJJzodrGGqsSJ+vqnzjsA7JMEUgN43NdoyqXYMrEiZlkh3USHqjITiXaATxQEji
         dTyNAUPVIyDPforITndAkvU/xgjEvBdhQ8q9WAZz6Hl6tjcLBjaFBZulUFWeuPmvQ7Ml
         ikDQ==
X-Gm-Message-State: AOAM533//ql0DIEcZZlXQq+bVXXp6n3Z5K7chmR1yKO/QdO5USUfghz4
        q1q+PBSygCJRXCIiB+5n0k0=
X-Google-Smtp-Source: ABdhPJy8oSVfq5Kq1zd562cl3lP3jTqC7YeW2cxgwiupMkHOiAVy26b79xcSYACXuX+Ib3ZocGtO+Q==
X-Received: by 2002:aa7:da94:: with SMTP id q20mr3410853eds.310.1622667948153;
        Wed, 02 Jun 2021 14:05:48 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bec5d.dynamic.kabel-deutschland.de. [95.91.236.93])
        by smtp.googlemail.com with ESMTPSA id o64sm600883eda.83.2021.06.02.14.05.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 14:05:47 -0700 (PDT)
Message-ID: <aaa62a02184b590c8845183c4bbad9a0e9ab36aa.camel@gmail.com>
Subject: Re: [PATCH v2 4/4] scsi: ufs: Use UPIU query trace in
 devman_upiu_cmd
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Wed, 02 Jun 2021 23:05:44 +0200
In-Reply-To: <7689e5022787716596534e9123fdc295@codeaurora.org>
References: <20210531104308.391842-1-huobean@gmail.com>
         <20210531104308.391842-5-huobean@gmail.com>
         <7689e5022787716596534e9123fdc295@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.4-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-06-02 at 10:29 +0800, Can Guo wrote:
> >        spin_lock_irqsave(hba->host->host_lock, flags);
> > @@ -6732,6 +6733,8 @@ static int
> > ufshcd_issue_devman_upiu_cmd(struct
> > ufs_hba *hba,
> >                        err = -EINVAL;
> >                }
> >        }
> > +     ufshcd_add_query_upiu_trace(hba, err ? UFS_QUERY_ERR : 
> > UFS_QUERY_COMP,
> > +                                 (struct utp_upiu_req *)lrbp-
> > >ucd_rsp_ptr);
> >   out:
> >        blk_put_request(req);
> 
> 
> What about ufshcd_exec_dev_cmd()?
> 


Can,
thanks for your veiew.
yes, ufshcd_exec_dev_cmd() is only to send
UPIU command frame, and doesn't include CDB. It already uses
ufshcd_add_query_upiu_trace() to trace UPIU frame. 

Kind regards,
Bean

> Thanks,
> 
> Can Guo.

