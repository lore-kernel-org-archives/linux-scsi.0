Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 994F9C433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:27:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 04C5623120
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 17:27:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1596734865;
	bh=VvUA6rJhbUih/gowdSUfSL8B1gmDjmzSGJaDRpCAUXg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=qN/iWQZbqZN1AmyUtKxmx6r/gYEst6bv3KQnxM95XUvlytYOhWTd2oSq16zmM7mhw
	 ucHcYBqyas5IKPEaeJ9eJwcX7+ABc5uf+TjPkIbYTTQoeMVZHvLXcxixmPwgbb1Diu
	 xPYv7yz9ECIFGtkqCK7vzI3rkRyfOC+VpsN6+qI4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729952AbgHFR1W (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 13:27:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729547AbgHFRBd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 13:01:33 -0400
Received: from mail-qk1-x744.google.com (mail-qk1-x744.google.com [IPv6:2607:f8b0:4864:20::744])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 261C5C0A888E;
        Thu,  6 Aug 2020 07:41:39 -0700 (PDT)
Received: by mail-qk1-x744.google.com with SMTP id l64so38319254qkb.8;
        Thu, 06 Aug 2020 07:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=+JOavwuu2af6Eh0MFH0vO7WhBEI3v+aXxyBlp4DnUwo=;
        b=in0QYmMWivT+TgpmxfP9EOitkGBUTODZQATNpwhGG4ifZpOUcaESDr6A+rH/1QzzwS
         Ikqq8LC3/LG0mgkiG0pPe7R9xt0zAOGQpp+txt+VT16mZXyGVk1H+DE1pj2P4743umYh
         KeRxJi4q30q20bpr1fWvn4ZFhmf1qks87ZJnaF0L7GPmW8hSkTcuTnenvbdSRdqcacas
         cEdW4/oj656K4z6Zfkh2zYwulgPuM5+onO9Nk5kr6QWmFIdIOKDB6v/0oTHGuFMilmsS
         eLLLNfuz0Cu+5ZCzIglQc/PXlnQjGJ53caoAcydM1r/q1W7uOmNO92EnvZvQVgsmHemM
         22gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=+JOavwuu2af6Eh0MFH0vO7WhBEI3v+aXxyBlp4DnUwo=;
        b=UkOFVcDWsIvhff51mn2MR7jr1Ftx0kRZDCpdAdrhuTjucXdKosLMxXM8aLazT1gdQs
         ma5tT7F0poZODRJo4Xbh2lr0vXGL/WeiJT6PG0/ETkTAUyL6tw3pe2JxcpX5pPQnUFMJ
         1H3cP4EAaQKPmMx+LCUnVr+OihtrzJ6IJPhuD/k0hexM45TVZYHg8L+quz3KNbhVZJ8+
         g9M3Llor7j+vKFSpbtY0hL+r/ZEcK+oDMvZ0dRLpMToCyLh8xkC5qJn9nltiWKQsSu7p
         fG8d6do44YPv7+MB0K5R2JQl+izSCBAsfjtk4DWKVe1HXd/9+ye3cg9rCxXrIn0i/Q4c
         gq5g==
X-Gm-Message-State: AOAM5313+HZfhglDUw6VOVdKaRF1tlVnXvZsqP10SxtrrlSJ85Fx1eI1
        h91FmzuhHEjqXYFapDpCeR4=
X-Google-Smtp-Source: ABdhPJzDB6bJdLBN/WCp6ELbFInICLymDe2gzcRSha7BfKUQ/cSXwh1jexiUQjiELqjeywwQn4kWGg==
X-Received: by 2002:a05:620a:b8d:: with SMTP id k13mr9094494qkh.450.1596724897903;
        Thu, 06 Aug 2020 07:41:37 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2e8b])
        by smtp.gmail.com with ESMTPSA id r6sm4821874qtu.93.2020.08.06.07.41.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 06 Aug 2020 07:41:36 -0700 (PDT)
Date:   Thu, 6 Aug 2020 10:41:35 -0400
From:   Tejun Heo <tj@kernel.org>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org, pbonzini@redhat.com, emilne@redhat.com,
        mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
Message-ID: <20200806144135.GC4520@mtj.thefacebook.com>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello,

On Thu, Aug 06, 2020 at 06:04:36PM +0530, Muneendra Kumar M wrote:
> 1)	blkcg will have a new field to store driver specific information as
> "blkio_cg_ priv_data"(in the current patch it is app_identifier) as Tejun
> said he doesn’t mind cgroup data structs carrying extra bits for stuff.

I'd make it something more specific - lpfc_app_id or something along that
line.

> 2)	scsi transport will provide a new interface(sysfs) as register_vm_fabric
> 3)	As part of this interface user/deamon will provide the details of VM such
> as UUID,PID on VM creation to the transport .
> 4)	With VM PID information we need to find the associated blkcg and needs to
> update the UUID info in blkio_cg_ priv_data.

You can pass in cgroup ID or open fd to uniquely identify a cgroup.

Thanks.

-- 
tejun
