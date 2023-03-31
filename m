Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EE04AC6FD18
	for <linux-scsi@archiver.kernel.org>; Fri, 31 Mar 2023 11:48:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbjCaLsx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 31 Mar 2023 07:48:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbjCaLsw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 31 Mar 2023 07:48:52 -0400
Received: from bedivere.hansenpartnership.com (bedivere.hansenpartnership.com [IPv6:2607:fcd0:100:8a00::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD6F230C2
        for <linux-scsi@vger.kernel.org>; Fri, 31 Mar 2023 04:48:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1680263328;
        bh=OQpZuU6oLQdMW8iamNV6I0wrXIfeh3tH2cfEJP3U+qA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Hg9gr9kM38M+CYQTJLAZbq7hZU1yH7Y7YUxWUfOtGboo02w1VNSx0rzIudNNAkSJc
         uydq8vhUWzK1sFn88/ec5rkPwD1XYVZ23wZGOuss6cKg7fH9d+mH74Ad1/TXUSi23+
         S1l6svozVOV680xsTd2ZuDdrODjp/r4HnbMB0Pus=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 45C611281833;
        Fri, 31 Mar 2023 07:48:48 -0400 (EDT)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
 by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavis, port 10024)
 with ESMTP id jDC3YchuuwXX; Fri, 31 Mar 2023 07:48:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1680263328;
        bh=OQpZuU6oLQdMW8iamNV6I0wrXIfeh3tH2cfEJP3U+qA=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=Hg9gr9kM38M+CYQTJLAZbq7hZU1yH7Y7YUxWUfOtGboo02w1VNSx0rzIudNNAkSJc
         uydq8vhUWzK1sFn88/ec5rkPwD1XYVZ23wZGOuss6cKg7fH9d+mH74Ad1/TXUSi23+
         S1l6svozVOV680xsTd2ZuDdrODjp/r4HnbMB0Pus=
Received: from [IPv6:2601:5c4:4302:c21::a774] (unknown [IPv6:2601:5c4:4302:c21::a774])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (prime256v1) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (Client did not present a certificate)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id AA75E1281703;
        Fri, 31 Mar 2023 07:48:47 -0400 (EDT)
Message-ID: <e4dd3ea37807166820e3b3b7e5102e23ab6b3898.camel@HansenPartnership.com>
Subject: Re: [PATCH] scsi: sd: mark the scsi device in shutdown as deleted
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     Mike Christie <michael.christie@oracle.com>,
        Tomas Henzl <thenzl@redhat.com>, linux-scsi@vger.kernel.org
Date:   Fri, 31 Mar 2023 07:48:45 -0400
In-Reply-To: <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
References: <20230330164943.11607-1-thenzl@redhat.com>
         <af17886b-5b18-f71f-9fe7-ea929f30b5a6@oracle.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.42.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2023-03-30 at 12:12 -0500, Mike Christie wrote:
> On 3/30/23 11:49 AM, Tomas Henzl wrote:
> > Set the state to deleted in sd_shutdown so that the attached LLD
> > doesn't receive new I/O (can happen when in kexec) later after
> > LLD's shutdown function has been called.
> > 
> > Signed-off-by: Tomas Henzl <thenzl@redhat.com>
> > ---
> >  drivers/scsi/sd.c | 7 +++++++
> >  1 file changed, 7 insertions(+)
> > 
> > diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> > index 4f28dd617eca..8095f0302e66 100644
> > --- a/drivers/scsi/sd.c
> > +++ b/drivers/scsi/sd.c
> > @@ -3694,10 +3694,13 @@ static int sd_start_stop_device(struct
> > scsi_disk *sdkp, int start)
> >  static void sd_shutdown(struct device *dev)
> >  {
> >         struct scsi_disk *sdkp = dev_get_drvdata(dev);
> > +       struct scsi_device *sdp;
> >  
> >         if (!sdkp)
> >                 return;         /* this can happen */
> >  
> > +       sdp = sdkp->device;
> > +
> >         if (pm_runtime_suspended(dev))
> >                 return;
> >  
> > @@ -3710,6 +3713,10 @@ static void sd_shutdown(struct device *dev)
> >                 sd_printk(KERN_NOTICE, sdkp, "Stopping disk\n");
> >                 sd_start_stop_device(sdkp, 0);
> >         }
> > +
> > +       mutex_lock(&sdp->state_mutex);
> > +       scsi_device_set_state(sdp, SDEV_DEL);
> > +       mutex_unlock(&sdp->state_mutex);
> >  }
> 
> If this is run for device removal what state will be in here?
> 
> Are we going to do:
> 1. __scsi_remove_device sets the state to SDEV_CANCEL at the
> beginning of the function

It will also interfere with target and host device removal.  They
traverse their own lists and assume that anything in DEL is already
being removed, which won't be the case here.  So basically, after this
happens it's impossible to clean the device trees.  It also means any
I/O to the root device wouldn't be allowed.

I assume the contention is that if we get here, we're either going for
immediate shutdown or all the root device remounting to read only has
already been done?  If so, could you say that?

James

