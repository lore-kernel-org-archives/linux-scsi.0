Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C11C0C2D0A3
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 22:32:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63FD2206CB
	for <linux-scsi@archiver.kernel.org>; Mon,  9 Nov 2020 22:32:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="hBSkS5ZZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730121AbgKIWc2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 9 Nov 2020 17:32:28 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:36547 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729706AbgKIWc1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 9 Nov 2020 17:32:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604961146;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=ilWn6M2YeSNAy1OjrKgETUEYS6rW9P62pTXErbsPxXU=;
        b=hBSkS5ZZM/2yMLx0Q7UeHV1O1D/PDxh+CRQ8tsUnGZGu0IRACOYqUN3dWNPIkl03OYBwBc
        8gLsm/qx5Ihg57FemU3L6wl4rycR7C/6Vaf/hogm7mbx89Mhb/CX68IAdr1iWznvbjJrLW
        sMm7Fc/lbFGcDR6pYyR/rAtO+pAPblo=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-477-xWfjFHSCM-OH6wr39Rnmtg-1; Mon, 09 Nov 2020 17:32:24 -0500
X-MC-Unique: xWfjFHSCM-OH6wr39Rnmtg-1
Received: by mail-wr1-f71.google.com with SMTP id f4so1821629wru.21
        for <linux-scsi@vger.kernel.org>; Mon, 09 Nov 2020 14:32:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ilWn6M2YeSNAy1OjrKgETUEYS6rW9P62pTXErbsPxXU=;
        b=tgIeAxyFJ5fl83AGxiNK7cy7mgXKc9x9PKStIiKkshmHNBIqD5a1DobNJ2g9TEORKs
         Gj87+lwrsGMbrqF67+mkZAx9UektGVNUYn3yKIRAYLI8qdRRpV5kd+b5MDq26F2ik78i
         RCUU9aNkD8VYR5A6wdC355ceooTP8d+7RFuIUBl7JdBQBHFO85O9VrI9XK4TMcL16N8O
         UN/DMBKdn116R3tWSc93yYwbANQnzQASlBcs5+CxZbrzrNbrnBVGPK3NVPm7WwxVmVZn
         l8QgKBKtywERBd5tO2U3N7V2qPDyVwnxXzuq5hMjulauMxFD5dIH+jdW0oMbhl7Gu7Nb
         bauQ==
X-Gm-Message-State: AOAM532u7Dfor327ilqdHjXEPuXQ0iLfgu0EbOnEAw8YzHai9avm1EOY
        6TieVPic7XaV6If14TamvDVhVuVmHbkKH6FD00rX5ZCYFRizm7NrRp2OF9S8tTkUXMfKq1hHBMn
        saWAm1GJ2tcaCaHUsnSCD3Q==
X-Received: by 2002:adf:9544:: with SMTP id 62mr20108968wrs.223.1604961143332;
        Mon, 09 Nov 2020 14:32:23 -0800 (PST)
X-Google-Smtp-Source: ABdhPJyh47AqupUQogPqD176lZqagmPngj1Pmkx6eJjzzl/nhQE8xwUWQt+djiOvPwM7ngtjJEbr0g==
X-Received: by 2002:adf:9544:: with SMTP id 62mr20108951wrs.223.1604961143173;
        Mon, 09 Nov 2020 14:32:23 -0800 (PST)
Received: from redhat.com (bzq-79-176-118-93.red.bezeqint.net. [79.176.118.93])
        by smtp.gmail.com with ESMTPSA id y185sm841543wmb.29.2020.11.09.14.32.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 14:32:21 -0800 (PST)
Date:   Mon, 9 Nov 2020 17:32:18 -0500
From:   "Michael S. Tsirkin" <mst@redhat.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Jason Wang <jasowang@redhat.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        pbonzini@redhat.com, stefanha@redhat.com,
        virtualization@lists.linux-foundation.org
Subject: Re: [PATCH 06/11] vhost: support delayed vq creation
Message-ID: <20201109173058-mutt-send-email-mst@kernel.org>
References: <1604528804-2878-1-git-send-email-michael.christie@oracle.com>
 <1604528804-2878-7-git-send-email-michael.christie@oracle.com>
 <56056e8d-d6ff-9a6e-2a7e-1ea1737b1d27@redhat.com>
 <54285b79-637e-3dcd-382f-ddeff44f6019@oracle.com>
 <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc22b679-08c1-85bb-515a-8f63de7148a2@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Nov 09, 2020 at 02:30:36PM -0600, Mike Christie wrote:
> On 11/9/20 12:41 PM, Mike Christie wrote:
> > 
> > If you want to pair this patchset down to it's bare bug fixes that
> > prevent users from getting IO errors, I would do ring.addr check only
> > approach for this bug fix patchset.
> 
> Oh yeah, just so we don't have to burn an extra day, above I'm proposing I
> repost the original patchset:
> 
> https://lore.kernel.org/linux-scsi/1600712588-9514-1-git-send-email-michael.christie@oracle.com/t/
> 
> for the bug fix only patches. It will have the compile error fixed and
> Bart's comment handled.
> 
> To even trim it down more I can also drop the last 2 patches:
> 
> 0007-vhost-remove-work-arg-from-vhost_work_flush.patch
> 0008-vhost-scsi-remove-extra-flushes.patch
> 
> and send separately in a cleanups patchset since the extra flushes it kills
> don't really hurt.

Makes sense to me.

-- 
MST

