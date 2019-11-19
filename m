Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E905C43215
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:36:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 18CF02240C
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 23:36:05 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="GKCdZvYn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727038AbfKSXgE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 18:36:04 -0500
Received: from mail-wr1-f45.google.com ([209.85.221.45]:38378 "EHLO
        mail-wr1-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726874AbfKSXgE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Nov 2019 18:36:04 -0500
Received: by mail-wr1-f45.google.com with SMTP id i12so25972163wro.5
        for <linux-scsi@vger.kernel.org>; Tue, 19 Nov 2019 15:36:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to;
        bh=u19BeCFiVnNBqiINu4cmpfBmJ02SJ/fxTUpeWLVeAt0=;
        b=GKCdZvYnPgLuXVpB4bDKMPL3CIJZJOCekr6xClSqViQQi+zwgrSIVaov6cN/4tGC90
         A4u4ZgIRE8ENbaMgxA8aSIoJ9OCWQNf3oATJKWgxGbYfv/fWXCXzmiB25we0+Ywr+ZTl
         y4miwaM/JTGFiAWdddCZM/pPd1XMRXtF4vQiA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to;
        bh=u19BeCFiVnNBqiINu4cmpfBmJ02SJ/fxTUpeWLVeAt0=;
        b=B2guZNpMVhO8D0+G0qGtuSYI9iajqBw9OArDwHRx0t/S57XEdMuoVSE1VJ6frydAxx
         ywEqUgroewCotUQVKaQepUQvGN3RkCI/MmR9jUYAt3e7yyOAFyd6NtVqVSoZeTVZH7/Y
         yjs+5fm2Nzn18q0sNTyaTnVVP1q5DhqXRQywBTKUCsjd4Kd853LZvLIXg4MKA3bX7kw3
         YX2p/LKrWo8fRMuo4p15vW+/A/LwYdHMdJiyIP0Ds2qp8+y+iXl6jUDtcWDdn+WIvupo
         Jb4bXOwrXepXs4/vWylRywk1V2F9zDLywBMFeqoVVBFnzD7TuQ/Ec8pzdWl7zh/qJTgP
         Bh8w==
X-Gm-Message-State: APjAAAVD0ZreEVkhUEGut3fKpnHbTNstg1iVfCQw/b4srXf/65OXWxvL
        ESY0zYGXw4KD6zgIb7EExjjOpLkMCVwcIOqsg/4z6Q==
X-Google-Smtp-Source: APXvYqw4QFuneTasciE21GNsONTL+ye/9ekgNIWdVNyAR7X9aLSAn75QFcyxIWOCbsmA3NUrSl4FRD91k0KWM4mVeeE=
X-Received: by 2002:adf:db4e:: with SMTP id f14mr38479548wrj.257.1574206561798;
 Tue, 19 Nov 2019 15:36:01 -0800 (PST)
From:   Sumanesh Samanta <sumanesh.samanta@broadcom.com>
References: <1574194079-27363-1-git-send-email-sumanesh.samanta@broadcom.com>
 <1574194079-27363-2-git-send-email-sumanesh.samanta@broadcom.com> <8357148d-e819-4a3c-9834-25080e036781@acm.org>
In-Reply-To: <8357148d-e819-4a3c-9834-25080e036781@acm.org>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 14.0
Thread-Index: AQI3eggT/McHkvzRPAOxlHKa/248ZAGXzjzyAd7rGiSms7lsQA==
Date:   Tue, 19 Nov 2019 16:35:59 -0700
Message-ID: <e4a7540785d14eea7ccf0f7bd02c05f4@mail.gmail.com>
Subject: RE: [PATCH 1/1] scsi core: limit overhead of device_busy counter for SSDs
To:     Bart Van Assche <bvanassche@acm.org>, axboe@kernel.dk,
        linux-block@vger.kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        ming.lei@redhat.com,
        Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        chaitra.basappa@broadcom.com,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>, emilne@redhat.com,
        hch@lst.de, hare@suse.de, bart.vanassche@wdc.com
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Bart,

Thanks for pointing this out.
Yes, the purpose of my patch is exactly same as Ming's patch you referred
to, albeit it achieves the same purpose in a different way.

If the earlier patch makes it upstream, then my patch is not needed.

Thanks,
Sumanesh


-----Original Message-----
From: Bart Van Assche [mailto:bvanassche@acm.org]
Sent: Tuesday, November 19, 2019 4:22 PM
To: Sumanesh Samanta; axboe@kernel.dk; linux-block@vger.kernel.org;
jejb@linux.ibm.com; martin.petersen@oracle.com; linux-scsi@vger.kernel.org;
ming.lei@redhat.com; sathya.prakash@broadcom.com;
chaitra.basappa@broadcom.com; suganath-prabu.subramani@broadcom.com;
kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
shivasharan.srikanteshwara@broadcom.com; emilne@redhat.com; hch@lst.de;
hare@suse.de; bart.vanassche@wdc.com
Subject: Re: [PATCH 1/1] scsi core: limit overhead of device_busy counter
for SSDs

On 11/19/19 12:07 PM, Sumanesh Samanta wrote:
> From: root <sumanesh.samanta@broadcom.com>
>
> Recently a patch was delivered to remove host_busy counter from SCSI mid
> layer. That was a major bottleneck, and helped improve SCSI stack
> performance.
> With that patch, bottle neck moved to the scsi_device device_busy counter.
> The performance issue with this counter is seen more in cases where a
> single device can produce very high IOPs, for example h/w RAID devices
> where OS sees one device, but there are many drives behind it, thus being
> capable of very high IOPs. The effect is also visible when cores from
> multiple NUMA nodes send IO to the same device or same controller.
> The device_busy counter is not needed by controllers which can manage as
> many IO as submitted to it. Rotating media still uses it for merging IO,
> but for non-rotating SSD drives it becomes a major bottleneck as described
> above.
>
> A few weeks back, a patch was provided to address the device_busy counter
> also but unfortunately that had some issues:
> 1. There was a functional issue discovered:
> https://lists.01.org/hyperkitty/list/lkp@lists.01.org/thread/VFKDTG4XC4VHWX5KKDJJI7P36EIGK526/
> 2. There was some concern about existing drivers using the device_busy
> counter.
>
> This patch is an attempt to address both the above issues.
> For this patch to be effective, LLDs need to set a specific flag
> use_per_cpu_device_busy in the scsi_host_template. For other drivers ( who
> does not set the flag), this patch would be a no-op, and should not affect
> their performance or functionality at all.
>
> Also, this patch does not fundamentally change any logic or functionality
> of the code. All it does is replace device_busy with a per CPU counter. In
> fast path, all cpu increment/decrement their own counter. In relatively
> slow path. they call scsi_device_busy function to get the total no of IO
> outstanding on a device. Only functional aspect it changes is that for
> non-rotating media, the number of IO to a device is not restricted.
> Controllers which can handle that, can set the use_per_cpu_device_busy
> flag in scsi_host_template to take advantage of this patch. Other
> controllers need not modify any code and would work as usual.
> Since the patch does not modify any other functional aspects, it should
> not have any side effects even for drivers that do set the
> use_per_cpu_device_busy flag.

Hi Sumanesh,

Can you have a look at the following patch series and see whether it has
perhaps the same purpose as your patch?

https://lore.kernel.org/linux-scsi/20191118103117.978-1-ming.lei@redhat.com/

Thanks,

Bart.
