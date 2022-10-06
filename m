Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6AE9DC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Oct 2022 19:27:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbiJFT1q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Oct 2022 15:27:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbiJFT1p (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Oct 2022 15:27:45 -0400
Received: from mail-io1-xd64.google.com (mail-io1-xd64.google.com [IPv6:2607:f8b0:4864:20::d64])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 949D99E6AD
        for <linux-scsi@vger.kernel.org>; Thu,  6 Oct 2022 12:27:44 -0700 (PDT)
Received: by mail-io1-xd64.google.com with SMTP id 187so2053127iov.10
        for <linux-scsi@vger.kernel.org>; Thu, 06 Oct 2022 12:27:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Er+HWa/JFvzG1+NiemEnZthCRt0hLUSPOoLZacm2EpI=;
        b=MAhE+KMcgGxfJ83/bEV8D1k4MSCohozl/cRiZEi3YsBAVrMPs9w/xAExe9jRt8deG4
         hE0+TBzZQF1UQ9659ORSEJahPII7JdlB8bxX755LkGI4mGxg/IA69HPJgtjm0YlOqqdh
         LNrkU3daZeroRkOgdI2GGoFg46qLafIW9AhLk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Er+HWa/JFvzG1+NiemEnZthCRt0hLUSPOoLZacm2EpI=;
        b=Vd034zoK35tAMXU5FlZJXcyJcmBEkepC06xtalTWw4eulmqJYviPyi5suScsExrDwL
         xqEgy2Af7FNe4X2xzoScZcjor+9NVCecSgdtnpaSdEca6H0Ax86X4LckI3vrOx7v3DRZ
         uPQVy5zSoE7TvBXxlgzP5ifIGzH3tKFRIodMRU0LVAVSJOp4D+sHYEcuchlBm8fsiy6h
         2fQBl35YKCFR6e0oFUmRPKKw9del2k/RyR28DlSk/6J1JhHtZMxelvq5KBwiqpZ+tMad
         f4xGVHtkSElnUtp8ilwk9RFXZluYwHXHC6PIrpgLjIjYmUo7Ov/thom5JGfZBlGRhwIV
         YGoA==
X-Gm-Message-State: ACrzQf3L2Z1LKBQUes/n7Ta/gq7U2mRlHncGa3u0El58l63GVD6YhCQ7
        ZJDAJhjBjTbY1fE+3w9BQgJ9/kNX28vMdTFEw9Hen6F57XqDeA==
X-Google-Smtp-Source: AMsMyM5w0TOp2/hIhKE309VebJ67rt46XJ2zdxibDSVSZrtELmYW8acfmXF/+Fb57UspaV2zpaVMPZe/PwYd
X-Received: by 2002:a05:6638:2393:b0:363:6c5d:9584 with SMTP id q19-20020a056638239300b003636c5d9584mr676965jat.232.1665084463632;
        Thu, 06 Oct 2022 12:27:43 -0700 (PDT)
Received: from c7-smtp.dev.purestorage.com ([208.88.159.129])
        by smtp-relay.gmail.com with ESMTPS id h23-20020a0566380f9700b0036371eb6d14sm15776jal.57.2022.10.06.12.27.43
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 06 Oct 2022 12:27:43 -0700 (PDT)
X-Relaying-Domain: purestorage.com
Received: from dev-ushankar.dev.purestorage.com (dev5.dev.purestorage.com [IPv6:2620:125:9007:640:7:70:36:0])
        by c7-smtp.dev.purestorage.com (Postfix) with ESMTP id D0BF41FED1;
        Thu,  6 Oct 2022 13:27:42 -0600 (MDT)
Received: by dev-ushankar.dev.purestorage.com (Postfix, from userid 1557716368)
        id CBB0AE40391; Thu,  6 Oct 2022 13:27:42 -0600 (MDT)
Date:   Thu, 6 Oct 2022 13:27:42 -0600
From:   Uday Shankar <ushankar@purestorage.com>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] restrict legal sdev_state transitions via sysfs
Message-ID: <20221006192742.GA2255620@dev-ushankar.dev.purestorage.com>
References: <20220924000241.2967323-1-ushankar@purestorage.com>
 <b5ac4103-87dc-f3ea-a2ef-67b3ef41bf66@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b5ac4103-87dc-f3ea-a2ef-67b3ef41bf66@oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 29, 2022 at 09:57:19PM -0500, Mike Christie wrote:
> On 9/23/22 7:02 PM, Uday Shankar wrote:
> > ---
> > Looking for feedback on the "allowed source states" list. The bug I hit
> > is solved by prohibiting transitions out of SDEV_BLOCKED, but I think
> > most others shouldn't be allowed either.
> 
> I think it's ok to be restrictive:
> 
> 1. BLOCKED is just broken. When the transport classes and scsi_lib transition
> out of that state they do a lot more than just set the set. We are leaving
> the kernel in mismatched state where the device state is running but the
> block layerand transport classes are not ready for IO.
> 
> 2. CREATED does not happen. We go into RUNNING then do scsi_sysfs_add_sdev so
> userspace should not see the CREATED state.
> 
> 3. I'm not 100% sure about SDEV_QUIESCE though. It looks like it has similar issues
> as BLOCKED where scsi_device_resume will undo things it did in scsi_device_quiesce,
> so we can't just set the state to RUNNING and expect things to work. I'm not
> sure about the scsi_transport_spi cases.
> 
> It would be best for James or Hannes to comment because they know that code well.

Adding Hannes to CC.

> 4. The transport classes are the ones that put devs in SDEV_TRANSPORT_OFFLINE
> and then transition them when they are ready. The block layer is at least in
> the correct state, but the transport classes may not be ready for IO since they
> are not expecting IO to be queued to them at that time.
> 
> > 
> >  drivers/scsi/scsi_sysfs.c | 8 ++++++++
> >  1 file changed, 8 insertions(+)
> > 
> > diff --git a/drivers/scsi/scsi_sysfs.c b/drivers/scsi/scsi_sysfs.c
> > index 9dad2fd5297f..b38c30fe681d 100644
> > --- a/drivers/scsi/scsi_sysfs.c
> > +++ b/drivers/scsi/scsi_sysfs.c
> > @@ -822,6 +822,14 @@ store_state_field(struct device *dev, struct device_attribute *attr,
> >  	}
> >  
> >  	mutex_lock(&sdev->state_mutex);
> > +	switch (sdev->sdev_state) {
> > +	case SDEV_RUNNING:
> > +	case SDEV_OFFLINE:
> > +		break;
> > +	default:
> > +		mutex_unlock(&sdev->state_mutex);
> > +		return -EINVAL;
> > +	}
> >  	if (sdev->sdev_state == SDEV_RUNNING && state == SDEV_RUNNING) {
> >  		ret = 0;
> >  	} else {
> > 
> > base-commit: 7f615c1b5986ff08a725ee489e838c90f8197bcd
> 
