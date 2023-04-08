Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB605C7619A
	for <linux-scsi@archiver.kernel.org>; Sat,  8 Apr 2023 23:50:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbjDHXuo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 8 Apr 2023 19:50:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229450AbjDHXun (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 8 Apr 2023 19:50:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7268A7D9F
        for <linux-scsi@vger.kernel.org>; Sat,  8 Apr 2023 16:49:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1680997794;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=+b4CPK/d/63dBociVbqVxZl8Ud7NtT4rqI0mMs6Hxtk=;
        b=DnNzppWNsd6MX+p4Bi67QFf1WxVdkp1tdjejic//3eeSJ7GFPo6mvK3+HdNeYmKhMBxR5U
        ZyrHMSg/MCFCTvLJlAQCMS0uLGYB5aqDdzJv1pRmniW2iRuH+ueyA2jdmATXTVqiogApnq
        XBypQ9iS0xrr22a8bnBzvsY/VyP6R+U=
Received: from mail-qt1-f197.google.com (mail-qt1-f197.google.com
 [209.85.160.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-348-zIXIocZEN5uSs2XqcX9MvQ-1; Sat, 08 Apr 2023 19:49:52 -0400
X-MC-Unique: zIXIocZEN5uSs2XqcX9MvQ-1
Received: by mail-qt1-f197.google.com with SMTP id 13-20020ac8570d000000b003e37d3e6de2so1644337qtw.16
        for <linux-scsi@vger.kernel.org>; Sat, 08 Apr 2023 16:49:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1680997792; x=1683589792;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+b4CPK/d/63dBociVbqVxZl8Ud7NtT4rqI0mMs6Hxtk=;
        b=qGUYaMtj/oUPLAj/dK5LfjEzPis15fMEKilUz2tWjQMWeE/gUYIPD19dD+Pe33/pCy
         hoApjzAM21+EnXa3ScA6UEcK9sTlYXydE2R2hAxccEGZUkrtAz8kVRmtXUfpS3uoJZ+A
         SeVCrOl4UdbQYia0bFi4IocxRXqXrKPyP50/nd9/IelucdnOBrtDXTZfyM5p5QcrDXV/
         0Z20mvs6VIYq2Gl88b1cAQQ2snEeyMcoldrIUs+VhOw/Gx4PJlRLv3PfVE8sG4g9SuJ+
         Ux2FFdcS9hneGu1xdBtBnbiMegMCpaxzOEjXIOfPGqgCaFMn21KThHobUrdPDNnpiMSL
         5ZLg==
X-Gm-Message-State: AAQBX9e4N4y8Gym67MhL9t381wzwPNbyr8KFMILAeaEcnQ2pPHuhT0j/
        IqL/ciMdH43vvENyft273iswlGzy7kZZGjGVyvRvGWftugapZVe1vaIPGILISoOQ2K1pJ6au/tl
        71HwMeLmynnNqHNdiHPuP4Q==
X-Received: by 2002:a05:6214:5186:b0:56e:bd59:40f1 with SMTP id kl6-20020a056214518600b0056ebd5940f1mr10078621qvb.48.1680997792522;
        Sat, 08 Apr 2023 16:49:52 -0700 (PDT)
X-Google-Smtp-Source: AKy350b9s+Hn8oRc0vE2U8KfoKsbxZieFmgtqG234h8LuJIMlXuXejttqZ3UaUVb6KZSrvnW4iKEoA==
X-Received: by 2002:a05:6214:5186:b0:56e:bd59:40f1 with SMTP id kl6-20020a056214518600b0056ebd5940f1mr10078605qvb.48.1680997792302;
        Sat, 08 Apr 2023 16:49:52 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id 206-20020a370ad7000000b0074589d41342sm2311955qkk.17.2023.04.08.16.49.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 08 Apr 2023 16:49:51 -0700 (PDT)
Date:   Sat, 8 Apr 2023 16:49:50 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Subject: Re: question about mpt3sas commit fae21608c31c
Message-ID: <7ome37kxwh3jrq65vgare4n2ft6jxr5tb6opkadajacdmks7kf@bpw3ig2wmmjm>
References: <gn42g3poxa4aqgttt3ck6cb5jwhpwovm3l7hay5z65d5tlfec3@kfs5mtqb2rlh>
 <hwlhzyqc42lnkifu6izsrx4lpqgjltjnrrcyzxhxmawgx3emeg@qxadku6yknpa>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <hwlhzyqc42lnkifu6izsrx4lpqgjltjnrrcyzxhxmawgx3emeg@qxadku6yknpa>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Apr 08, 2023 at 01:59:21PM -0700, Jerry Snitselaar wrote:
> On Sat, Apr 08, 2023 at 12:18:29PM -0700, Jerry Snitselaar wrote:
> > We've had some people trying to track a problem for months revolving
> > around a system hanging at shutdown, and last thing they see being a
> > message from mpt3sas about a reset. They quickly bisected down to the
> > commit below, and reverted it made the problem go away for the
> > customer.
> > 
> > b424eaa1b51c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
> > 
> 
> That should be (grabbed the wrong commit id):
> 
> fae21608c31c ("scsi: mpt3sas: Transition IOC to Ready state during shutdown")
>
> > I got asked to look at something since I recently at another issue
> > that involved mpt3sas at shutdown, so I was looking through the
> > history, saw this commit being mentined. Looking at it, I'm not sure
> > why it is doing what is doing.
> > 
> > It says it is to perform a soft reset, but that was already happening before this commit via:
> > 
> > scsih_shutdown -> mpt3sas_base_detach -> mpt3sas_base_free_resources -> _base_make_ioc_ready(ioc, SOFT_RESET);
> > 
> > The original submission [1] had the following commit message:
> > 
> > "During shutdown just move the IOC state to Ready state
> > by issuing MUR. No need to free any IOC memory pools."
> > 
> > But is now skipping more than not freeing the memory pools. It no
> > longer frees memory that was kalloc'd, it doesn't unmap something that
> > was iomapped, it no longer cleans up the fault reset workqueue, and no
> > longer calls the pci cleanup code. It also no longer does the things
> > it moved to scsih_shutdown under the pci access mutex, nor uses the if
> > condition that was in mpt3sas_base_free_resources.
> > 
> > [1] https://lore.kernel.org/r/20210705145951.32258-1-sreekanth.reddy@broadcom.com
> > 
> > 
> > Am I missing something, and what the commit does here is really okay?
> > 


It looks like this deals with the fault reset workqueue no longer being cleaned up:

0fde22c5420e ("scsi: mpt3sas: Stop fw fault watchdog work item during system shutdown")

I still have questions about the other stuff that is skipped, or what
problem was actually being solved by skipping the dma pool
cleanup. Doesn't skipping that leave mappings behind in the iommu?

Is any of this memory a location that the firmware was trying to write
to before that is mentioned in the commit message?

Regards,
Jerry

> > 
> > Regards,
> > Jerry
> > 
> 

