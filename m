Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C4365C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:10:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1FE852311B
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:10:01 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="dW8PU+sM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730185AbgHFRJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:09:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730026AbgHFRGB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:06:01 -0400
Received: from mail-ot1-x32d.google.com (mail-ot1-x32d.google.com [IPv6:2607:f8b0:4864:20::32d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0A39C034608
        for <linux-scsi@vger.kernel.org>; Thu,  6 Aug 2020 05:34:43 -0700 (PDT)
Received: by mail-ot1-x32d.google.com with SMTP id x24so11884621otp.3
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 05:34:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=DQzpnS8fr6jm2iRUKTT+8uPER0rWAMgK1qYP0hO2mN8=;
        b=dW8PU+sMZlFCQuye9xK/etp27hrc0yDNj1O/ibFjFd0u91P8MsMMs1wSYbUrwyAP2D
         pwe1nCpAHeVLOkg+ls7rg2iQStVrgE5cX0R05E42xPEZ580r3kOxBi2xUJfqxMZaCNqg
         4xMjk70WinlhmepCCePSxNp766We+DQyLO0Zg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=DQzpnS8fr6jm2iRUKTT+8uPER0rWAMgK1qYP0hO2mN8=;
        b=sKp3wI667URoxT3N+2gZIFRLNZFndiYyBWMQhmF/xZgcUuf018vj1JRkskDzo3pdAv
         I/Kp5lMasuNZwotg3YDfSTRx2n3PImoBtGGDL5kqjkwHw3zC/gl/PIGLTpcwXeUKtiDV
         KZRjyL8YbaGtkhHLRHCeVqWq2OrQjvcTtnBIvWG82Ms6yIcF/Ueo9tj2+I7golw6RdS7
         D3QJqACYCPYYpV1jfzhO6Uj6QzgaqnsTj9rmpCcjdxhbTJ7OPMIXnSZm3mDL1c9iTFni
         kbhRZfbsdzoojgoiARwKzO5l6odR7+b7APSaEUBJEnGLCT33wukviossCnlcBpTqd9AE
         A4aQ==
X-Gm-Message-State: AOAM531EBnSuFs4oX4nsnIELVfczCQGGDRuoMl/HxPdRuI+jY3vam5Le
        fcq37AN8dWQk7iJlqjge9vgYzV3QvPruZZcagakpnRmIfC0=
X-Google-Smtp-Source: ABdhPJwp+H41ENza8xFswVq6f+iz+1qozZ8ksWJ66+CB+SLCktL6wADXXlTKvVI0+u8Nft5hLxnaiVYRwju+2IseuAs=
X-Received: by 2002:a05:6830:1e71:: with SMTP id m17mr7323482otr.188.1596717279387;
 Thu, 06 Aug 2020 05:34:39 -0700 (PDT)
From:   Muneendra Kumar M <muneendra.kumar@broadcom.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de> <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
In-Reply-To: <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
thread-index: AQIDyhmBPqdmqCKUdNTZliBUbPkt/AI5BKetAom9APICL6c0jKiYs6nw
Date:   Thu, 6 Aug 2020 18:04:36 +0530
Message-ID: <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
Subject: RE: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     pbonzini@redhat.com, emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi James,

As Tejun and Ming is suggesting to have interface close to the usage as
fabric infrasture I was thinking of this approach from the inputs provided
by you in the below mail.
Please provide your inputs on this approach.

1)	blkcg will have a new field to store driver specific information as
"blkio_cg_ priv_data"(in the current patch it is app_identifier) as Tejun
said he doesn=E2=80=99t mind cgroup data structs carrying extra bits for st=
uff.
2)	scsi transport will provide a new interface(sysfs) as register_vm_fabric
3)	As part of this interface user/deamon will provide the details of VM suc=
h
as UUID,PID on VM creation to the transport .
4)	With VM PID information we need to find the associated blkcg and needs t=
o
update the UUID info in blkio_cg_ priv_data.
5)	Once we update the blkio_cg_ priv_data with vmid all the io=E2=80=99s is=
sued from
VM will have the UUID info as part of blkcg.

With this  we can also address the concerns raised by Tejun and the
existing lpfc patches still holds good.

Regards,
Muneendra.

-----Original Message-----
From: James Smart [mailto:james.smart@broadcom.com]
Sent: Thursday, August 6, 2020 5:08 AM
To: Hannes Reinecke <hare@suse.de>; Muneendra
<muneendra.kumar@broadcom.com>; linux-block@vger.kernel.org;
linux-scsi@vger.kernel.org
Cc: pbonzini@redhat.com; emilne@redhat.com; mkumar@redhat.com; Gaurav
Srivastava <gaurav.srivastava@broadcom.com>; James Smart
<jsmart2021@gmail.com>
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.


That's actually what's supposed to be happening. fastpath uses the uuid to
look up a vmid tag. If no vmid tag, kick off the fabric traffic that will
get one but don't wait for it to complete. Any io issued while that process
is occurring will be not be vmid tagged.    I'll circle back on lpfc to mak=
e
sure this is happening.

In the mean time - the most important patch to review is the cgroup patch -
patch1.

If we wanted to speed the driver's io path up, one thing to consider is
adding a driver-settable value on the blkcg structure.  Once the fabric
traffic obtained the vmid, the driver would set the blkcg structure with th=
e
value.  In this scenario though, as the vmid is destroyed as of link down,
the driver needs a way, independent of an io, to reach into the blkcg struc=
t
to clear the vmid value.  We also need to be sure the blkcg struct won't be
on top of a multipath device or something such that the blkcg struct may be
referenced by a different scsi host - I assume we're good in that area.

-- james
