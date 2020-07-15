Return-Path: <SRS0=K8op=A2=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=BAYES_00,DEAR_SOMETHING,
	DKIMWL_WL_HIGH,DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 49B7EC433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 15:48:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 199D32065E
	for <linux-scsi@archiver.kernel.org>; Wed, 15 Jul 2020 15:48:02 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="MistEjbo"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726768AbgGOPsB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 15 Jul 2020 11:48:01 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:29724 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1725798AbgGOPsB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 15 Jul 2020 11:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594828079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=iHRFc2t+vxhrXbB4a0ddJym0nqFkKQ1CneMHAp3EP0A=;
        b=MistEjboQt4maTewc1IAnZeyhcOijmZMmbyO/UQxn5sQH2y+dIdQWmCJtHxpyiTj7lHWl8
        vUKrCv/3/K1q6AmdvJG1BUhGxZb0THV5YKOl5JHLz0mnydUWr/zaqtzSqSZWUDQtpNbNOR
        5Byk3Z0LlbgbVf/lenMmZ55D5UoZLOc=
Received: from mail-qk1-f200.google.com (mail-qk1-f200.google.com
 [209.85.222.200]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-359-Zn1II6kCOjeDVyaVfwm5Eg-1; Wed, 15 Jul 2020 11:47:56 -0400
X-MC-Unique: Zn1II6kCOjeDVyaVfwm5Eg-1
Received: by mail-qk1-f200.google.com with SMTP id 124so1739638qko.8
        for <linux-scsi@vger.kernel.org>; Wed, 15 Jul 2020 08:47:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=iHRFc2t+vxhrXbB4a0ddJym0nqFkKQ1CneMHAp3EP0A=;
        b=IiUz2Pu+6pIjbYSf8HQn4RMApana7g/8Ft6ighhKUmpNWX7T1L80Sc6/TcVNT/9Ogi
         mlgQL1wdhxQHbR+BBkvSwnB9CxSncjNDO/2WM91peXWBdWuQ7mfw9w5kNKNv/iEaZc0o
         kdl0ep5E7DBUu2E+wmOL9CPoZB/C6t5uPGV+ZgwUbceq5W4A/yujCm456WK+IezoDvWQ
         Df0LZN9oCXKd0QRwis50U/CYXg99THH82z5DPQyt5WqAjf0Z5cMjQ7FqsgPhZm8Py+G9
         PIQqNeNLZ/3LDUKWIAcIOUXWePHFAvMYktRJ5RSr3V59ClnGABQ4G+xNJ8egNo9oZ7Mp
         uGyA==
X-Gm-Message-State: AOAM532PoBNLrtMzgG1HV7ERW7ES0GpBnUuaLD4bdHaG1+XQC4bEYsay
        97bE3SIKbll/FTbxip8MYkiufkaN32pDgfonhl1d1PXDBhaIRzJ4wUr/GXTzMGTFffln4axuy3l
        ZZcOlNP7GPzuJ/WaGWkkSoQ==
X-Received: by 2002:a0c:e78b:: with SMTP id x11mr10368798qvn.103.1594828075863;
        Wed, 15 Jul 2020 08:47:55 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJxoPg6AWzuYhYMB3P6ZIMZeVVFTzrE46L7B67emNHDfJpmmsAzsqQYypmVe3I5Af+tOfiD7Sg==
X-Received: by 2002:a0c:e78b:: with SMTP id x11mr10368775qvn.103.1594828075533;
        Wed, 15 Jul 2020 08:47:55 -0700 (PDT)
Received: from loberhel7laptop ([2600:6c64:4e80:f1:4a17:2cf9:6a8a:f150])
        by smtp.gmail.com with ESMTPSA id q29sm3835897qtc.10.2020.07.15.08.47.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 15 Jul 2020 08:47:54 -0700 (PDT)
Message-ID: <a72b9fb8249f99b7a5387c0d2c493108c37fd339.camel@redhat.com>
Subject: Re: LIO Scsi Target
From:   Laurence Oberman <loberman@redhat.com>
To:     Sadegh Ali <sadegh.ali.2084@gmail.com>, linux-scsi@vger.kernel.org
Date:   Wed, 15 Jul 2020 11:47:53 -0400
In-Reply-To: <88d19544aa6d74d5780379eef0ffa1012d30066a.camel@redhat.com>
References: <CA+RHgKLt=ZOu_nnL6oX=LJVtJWE9i+ARE6A_VmGLeJaU1mYtSg@mail.gmail.com>
         <88d19544aa6d74d5780379eef0ffa1012d30066a.camel@redhat.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-5.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2020-07-15 at 10:11 -0400, Laurence Oberman wrote:
> On Wed, 2020-07-15 at 12:18 +0430, Sadegh Ali wrote:
> > Dear sir
> > 
> > we are considering to build SCSI Target system with ZFS filesystem
> > backend using Linux
> > I searched that two modules are available for Linux SCSI target,
> > LIO,
> > and SCST
> > but it seems LIO project that streamed to the kernel is not updated
> > for a while (about 7 years)
> > Is the LIO module project dead? or suspended?
> > Is any person or community available to respond to technical
> > problems
> > and fix bugs or develop new features or support new hardware?
> > 
> > with best regards
> > 
> 
> There has definitely been a pause in the LIO target code updates.
> In fact we use it a lot here (qla2xxx and SRP) at Red Hat but we have
> remained on the 4.5 kernel with my jammer patch in the lab because
> later updates have been  seeing lots of problems.
> I reported this to Marvell and they were looking into it but its been
> a
> long time.
> 
> The ISCSI module is very stable but my issues had been mostly with
> the
> qla2xxx target module.
> 
> Many vendors who have this in their products took a snapshot many
> kernels back and I am not sure how much has been shared back to
> upstream.
> 
> I have not tested recent upstream kernels for ages so I am also
> intrested to know who has been using either the qla2xxx modules or
> the
> SRP module successfully with recent kernels.
> 
> Regards
> Laurence

I should made it clearer that this comment below meant I had not tested
recent upstream kernel LIO modules qla2xxx and SRP.
I run the 4.5 kernel with a jammer patch for both qla2xxx and SRPtarget support in my lab. 

"I have not tested recent upstream kernels for ages so I am also
intrested to know who has been using either the qla2xxx modules or the
SRP module successfully with recent kernels."

