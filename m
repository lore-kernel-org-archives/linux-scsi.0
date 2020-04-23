Return-Path: <SRS0=QYJt=6H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 742E1C2BA19
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:12:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 522A4216FD
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Apr 2020 08:12:20 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OCk0NviP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726192AbgDWIMT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Apr 2020 04:12:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725854AbgDWIMT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 23 Apr 2020 04:12:19 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0544C03C1AB
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 01:12:18 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t9so2159162pjw.0
        for <linux-scsi@vger.kernel.org>; Thu, 23 Apr 2020 01:12:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=OS7eeMLxwuOao4/8KfJ1PwDLnIsaj/ITWtr5Xy64yEg=;
        b=OCk0NviPL5ChIaEj1tA6O4zsNcp6Vu0R/iEFZW1Mn3W6i1Ppf3QKeN99UmLQXzUNo5
         6CFOUsaSN56Xf9IXHcTnxL+W4s3NZdqZ6EIBRHrv7P46KNoqcClGxsjptyeHf5bWlFOq
         vviqWlTbNu8mZglHZIxZmvXdD1xJPx/AlNDa2ie5gAXkg80qheZL4vbkVspGltznj9vg
         AdcKMvwLv0Z6KMRbwZIUCa00vqZ+jfuUSrt9upa9rFFZZFxVBMwTP+NZw06HsTg1hLfx
         Uk4MHl0n3OmpLrzFzUdqEJA+quolQ88b/v5cipOv88r3XlJJ2nkoqrfJST/hoMSWPYCd
         stsQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=OS7eeMLxwuOao4/8KfJ1PwDLnIsaj/ITWtr5Xy64yEg=;
        b=bbYe6da523ONGLwTLNhR2M2hbhLmuFEsoFaipaxWCj3CWYDn5eSWAWNs/aX7QUuP0I
         2lBCh2yjZ6d87iTZXJ4FnzpLeKzYub/6uoZku2s4OtZh857lDRuFfszwVH083VwsjHMw
         ob4IL52WkKjiNmlqzEbrm3DG4NQEzmU7Mi2FPjNdaxd6b2oMA4hDOVNQcKXli9Y/PUcL
         RurzVoD0Rni8i5+TVTWpJ3Uoyhocc4/VzVp5Dw/rE5t81Rk3bta7R4cUBUee8OLy93Yn
         CK9HuGZurkbhivtR2jHnMEdAtXfcFAcO7YIqztuOXfxTQHkHgXsrHBlUAWT2xxmTb7No
         PnQw==
X-Gm-Message-State: AGi0PuZlTmSgNd6lsaxeLLUWAXBXoqRgggoptrOfErKy8T9yvMQRwJT/
        gXD7jJdEFxVuJ+DmG9HovRU=
X-Google-Smtp-Source: APiQypLZBvDxpcFip8FaX3CHb78d7iTtAqNmOsevG5GTPq3XV5BusqtPBuJS5AKHR4NjUsgZenv2xQ==
X-Received: by 2002:a17:902:d905:: with SMTP id c5mr537727plz.9.1587629538035;
        Thu, 23 Apr 2020 01:12:18 -0700 (PDT)
Received: from Ryzen-7-3700X.localdomain ([82.102.31.53])
        by smtp.gmail.com with ESMTPSA id s145sm1430112pgs.57.2020.04.23.01.12.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 23 Apr 2020 01:12:17 -0700 (PDT)
Date:   Thu, 23 Apr 2020 01:12:14 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Daniel Wagner <dwagner@suse.de>
Cc:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org,
        maier@linux.ibm.com, bvanassche@acm.org, herbszt@gmx.de,
        rdunlap@infradead.org, hare@suse.de,
        Ram Vegesna <ram.vegesna@broadcom.com>
Subject: Re: [PATCH v3 14/31] elx: libefc: FC node ELS and state handling
Message-ID: <20200423081214.GA2974@Ryzen-7-3700X.localdomain>
References: <20200412033303.29574-1-jsmart2021@gmail.com>
 <20200412033303.29574-15-jsmart2021@gmail.com>
 <20200415185603.hoaap564jde4v6bt@carbon>
 <d18094a8-32c2-f024-db46-7cec0cd21754@gmail.com>
 <20200423080508.jy7rwu4jumcxbkhx@beryllium.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423080508.jy7rwu4jumcxbkhx@beryllium.lan>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Apr 23, 2020 at 10:05:08AM +0200, Daniel Wagner wrote:
> Hi James,
> 
> On Wed, Apr 22, 2020 at 07:50:06PM -0700, James Smart wrote:
> > On 4/15/2020 11:56 AM, Daniel Wagner wrote:
> > ...
> > > > +	switch (evt) {
> > > > +	case EFC_EVT_ENTER:
> > > > +		efc_node_hold_frames(node);
> > > > +		/* Fall through */
> > > 
> > > 		fallthrough;
> > > 
> > 
> > Actually the patches that went in for -Wimplicit-fallthrough wants
> > /* fall through */
> 
> Ah okay, I though the fall through rules are active. Anyway, I am sure
> someone will run a script to report when to change.
> 
> Thanks,
> Daniel

Indeed, fallthrough; is preferred now, see commit f36d3eb89a43 ("checkpatch:
prefer fallthrough; over fallthrough comments") and the thread that is
linked in that commit.

Cheers,
Nathan
