Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA07DC433DB
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:10:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8549964F6D
	for <linux-scsi@archiver.kernel.org>; Fri, 19 Mar 2021 08:10:52 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234317AbhCSIKT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 19 Mar 2021 04:10:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234249AbhCSIKI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 19 Mar 2021 04:10:08 -0400
Received: from mail-ed1-x52d.google.com (mail-ed1-x52d.google.com [IPv6:2a00:1450:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52611C06174A
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 01:10:08 -0700 (PDT)
Received: by mail-ed1-x52d.google.com with SMTP id l18so1498913edc.9
        for <linux-scsi@vger.kernel.org>; Fri, 19 Mar 2021 01:10:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=XgtABA/PScHZGookhQ2E5pGm9lq0LjK98naHGxTSbN8=;
        b=hmBFTr1ieWWvj9bJquI4yZ4G5aN2xAwvvT3hFBQq5kMEruiYFIVUIF8TDkrOflqbY/
         hff7nM7Ed9JBVGI+0ChwJZeE+u5ZuNH5nEuQZ+AwlVDtUS+6RuHtQEmPQXxPFVlUJo6Y
         gQ6ZkTuay0ZHuhDYIhKv13j3PfhZOATtVmMfJ+OnabVag6jzLurBkr+5vLiss3ZBHXwd
         PlIlaNgk1rByI27FN5D+lCndbTAQGD94OjzJqm7TEL3QedanK12tr7lkJ3ZH3u80V4RC
         jY3DHUNWLSgS/IxWrnqbk9CIR8GDa/BmC7SiCuuUCh9o6W0gYrtG8jcsGt09qr4EtKMI
         Ba+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=XgtABA/PScHZGookhQ2E5pGm9lq0LjK98naHGxTSbN8=;
        b=pe1HMGxUv7DdPNd5qucjZoH++ljKwV1umNQNT6KPvJJRy5OtP/Y8qTNCOuj9IqTpq0
         JGFqmaCyKx9Mzvp6+PcK/rRT2v7peBnqAdGQKR31m7IC28F7LNYBQ8PkqAPSEurwt8Vx
         m84wr0XcKrVoox1cpS+S8+upbPDGZPdQjsB16eWsr30PxSavPjW17gUJ8OhyFzcuMM3D
         1qgr1/4OvzPCDooZ8srojf+mzo640840GGOpTjVO0x032DLozItcyyAi3o6nfwsE1NZ0
         nZxem9Kqifh0TZOGPO/mL6MhhvyaxZQFuDNuVTKwJCSOGXiCl15q7kSZxzpqPYhOt8Ig
         Do8w==
X-Gm-Message-State: AOAM532FigiHk8SPut+7UoSi/qOhbhDQHSYBrrwGoh9jbJn8TUfivxwG
        1UDhnAqk5+SRN96q2L6sYiphWw==
X-Google-Smtp-Source: ABdhPJym1mhN5RQZ++Hm6Gazh+NWc10OyinKc4o0Sv9gWUyUob63YXlK9gxpT3ahmvMtfj5IGFkAgw==
X-Received: by 2002:a05:6402:cb8:: with SMTP id cn24mr8250200edb.105.1616141407037;
        Fri, 19 Mar 2021 01:10:07 -0700 (PDT)
Received: from dell ([91.110.221.194])
        by smtp.gmail.com with ESMTPSA id cw14sm3704018edb.8.2021.03.19.01.10.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 19 Mar 2021 01:10:06 -0700 (PDT)
Date:   Fri, 19 Mar 2021 08:10:03 +0000
From:   Lee Jones <lee.jones@linaro.org>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Alex Davis <letmein@erols.com>, Ali Akcaagac <aliakc@web.de>,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        Artur Paszkiewicz <artur.paszkiewicz@intel.com>,
        Badari Pulavarty <pbadari@us.ibm.com>,
        Bas Vermeulen <bvermeul@blackstar.xs4all.nl>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Brian King <brking@linux.vnet.ibm.com>,
        Brian King <brking@us.ibm.com>,
        Brian Macy <bmacy@sunshinecomputing.com>,
        "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>,
        Christoph Hellwig <hch@lst.de>,
        "C.L. Huang" <ching@tekram.com.tw>,
        Colin DeVilbiss <devilbis@us.ibm.com>,
        Dave Boutcher <boutcher@us.ibm.com>,
        Dave Boutcher <sleddog@us.ibm.com>,
        David Chaw <david_chaw@adaptec.com>, dc395x@twibble.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Doug Ledford <dledford@redhat.com>,
        Drew Eckhardt <drew@colorado.edu>,
        Erich Chen <erich@tekram.com.tw>,
        Eric Youngdale <eric@andante.org>,
        FUJITA Tomonori <tomof@acm.org>,
        Hannes Reinecke <hare@kernel.org>,
        Hannes Reinecke <hare@suse.de>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Jamie Lenehan <lenehan@twibble.org>,
        Jirka Hanika <geo@ff.cuni.cz>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        Karan Tilak Kumar <kartilak@cisco.com>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Kurt Garloff <garloff@suse.de>,
        Le Moal <damien.lemoal@hgst.com>,
        "Leonard N. Zubkoff" <lnz@dandelion.com>,
        Linda Xie <lxie@us.ibm.com>, linux-drivers@broadcom.com,
        Linux GmbH <hare@suse.com>, linuxppc-dev@lists.ozlabs.org,
        linux-scsi@vger.kernel.org,
        Luben Tuikov <luben_tuikov@adaptec.com>,
        "Manoj N. Kumar" <manoj@linux.ibm.com>, Marvell <jyli@marvell.com>,
        "Matthew R. Ochs" <mrochs@linux.ibm.com>,
        Michael Cyr <mikecyr@linux.ibm.com>,
        Michael Ellerman <mpe@ellerman.id.au>,
        MPT-FusionLinux.pdl@avagotech.com,
        MPT-FusionLinux.pdl@broadcom.com,
        "Nicholas A. Bellinger" <nab@kernel.org>,
        Oliver Neukum <oliver@neukum.org>,
        Paul Mackerras <paulus@samba.org>,
        Richard Gooch <rgooch@atnf.csiro.au>,
        Santiago Leon <santil@us.ibm.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Satish Kharat <satishkh@cisco.com>,
        Sesidhar Baddela <sebaddel@cisco.com>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        target-devel@vger.kernel.org, Torben Mathiasen <tmm@image.dk>,
        Tyrel Datwyler <tyreld@linux.ibm.com>,
        Uma Krishnan <ukrishn@linux.ibm.com>, willy@debian.org
Subject: Re: [PATCH 00/36] [Set 4] Rid W=1 warnings in SCSI
Message-ID: <20210319081003.GF2916463@dell>
References: <20210317091230.2912389-1-lee.jones@linaro.org>
 <yq1zgyzolqx.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <yq1zgyzolqx.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 18 Mar 2021, Martin K. Petersen wrote:

> 
> Lee,
> 
> > This set is part of a larger effort attempting to clean-up W=1 kernel
> > builds, which are currently overwhelmingly riddled with niggly little
> > warnings.
> 
> Applied to 5.13/scsi-staging, thanks! I fixed a few little things.

Thanks for your continued support Martin.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
