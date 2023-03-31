Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 98576C761A6
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 15:07:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231654AbjCaPHj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 11:07:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230226AbjCaPHi (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 11:07:38 -0400
X-Greylist: delayed 11886 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 31 Mar 2023 08:06:54 PDT
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [96.44.175.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D3291DFBE
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 08:06:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1680275208;
        bh=nVcH5Rcn34Wh14BOzeh6dRnlFo6hzf1EpRVFrRh7Lx0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=UtiT01GBY0BzZC6T6AoemBE3qshuBS7Vyo2dIWci+LDB+nbyuhcs7CKlfb1dLbgA1
         0FA0rnA55QN5oGX7jbECz9U+NN4LS5vm3sjZcjey9lT69mxB9jvje148mULNbNO3NL
         EtFQnS6+qX7YVbVBHwWtum6/bJ+cEVXFc06GJDl8=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id C47FF128696A;
        Fri, 31 Mar 2023 11:06:48 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id uVSS4KJsireh; Fri, 31 Mar 2023 11:06:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1680275208;
        bh=nVcH5Rcn34Wh14BOzeh6dRnlFo6hzf1EpRVFrRh7Lx0=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=UtiT01GBY0BzZC6T6AoemBE3qshuBS7Vyo2dIWci+LDB+nbyuhcs7CKlfb1dLbgA1
         0FA0rnA55QN5oGX7jbECz9U+NN4LS5vm3sjZcjey9lT69mxB9jvje148mULNbNO3NL
         EtFQnS6+qX7YVbVBHwWtum6/bJ+cEVXFc06GJDl8=
Received: from lingrow.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4302:c21::c14])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits))
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id 2A74512868F7;
        Fri, 31 Mar 2023 11:06:48 -0400 (EDT)
Message-ID: <488bb066654104bc6b84fdc45595232305519597.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Tomas Henzl <thenzl@redhat.com>,
        Mike Christie <michael.christie@oracle.com>,
        linux-scsi@vger.kernel.org
Date:   Fri, 31 Mar 2023 11:06:46 -0400
In-Reply-To: <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
References: <20230330164943.11607-1-thenzl@redhat.com>
         <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
         <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
         <457808a0-1ec2-d846-075c-7f8812a7a416@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2023-03-31 at 16:11 +0200, Tomas Henzl wrote:
> On 3/31/23 13:48, James Bottomley wrote:
> > On Thu, 2023-03-30 at 12:12 -0500, Mike Christie wrote:
[...]
> > > Are we going to do:
> > > 1. __scsi_remove_device sets the state to SDEV_CANCEL at the
> > > beginning of the function
> > 
> > It will also interfere with target and host device removal.  They
> > traverse their own lists and assume that anything in DEL is already
> > being removed, which won't be the case here.  So basically, after
> > this happens it's impossible to clean the device trees.  It also
> > means any I/O to the root device wouldn't be allowed.
>  
> How will it interfere? After a return from sd_remove or via
> device_unregister->__scsi_remove_device the device state is SDEV_DEL
> regardless whether this patch has been added or not. Or is
> sd_shutdown called directly?

I thought it was called directly from the restart logic via the
device_shutdown() call (see kernel/reboot.c:kernel_restart_prepare())
and was completely independent of any other state transitions within
the device model ... however, I'd really like *you* to confirm this.

I think by the time it's called, we're already in the system death
throes, so if there were going to be an orderly shut down it's already
happened, but if not, once you set a devices state to DEL, it will
defeat any later attempt to do orderly remove of the host or target.

> > I assume the contention is that if we get here, we're either going
> > for immediate shutdown or all the root device remounting to read
> > only has already been done?  If so, could you say that?
>  
> I can't say that, quite the opposite (see body of the mail). When the
> system goes shutdown the individual device's .shutdown is called.
> Just moments after sd shutdown the LLD shutdown is entered and the
> driver stops any I/O immediately anyway. With this patch the I/O is
> stopped before reaching LLD with a reasonable message and without
> error correction mechanism in place.
> 
> I also assume that no I/O after sd_shutdown was projected when it was
> written as there is a cache sync followed by a device power down.

It seems reasonable, but can you validate that?  Shutdown is called
both from reboot and kexec and if we stop IO to a quiescing root device
before it completes, so that all filesystems come back dirty, we'll
have a lot of unhappy users ...

James

