Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D3ACC433E0
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:41:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C6E8622CBB
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 18:41:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="cWxbsmb+"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729064AbgHFSlw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 14:41:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:27447 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727891AbgHFSlo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 14:41:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1596739302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aWG0tiwckPiXTTzMj6No1cMhXlR5WHX+oAkTVDiT6Jw=;
        b=cWxbsmb+ThYLIZjNxJCtaFtcoAXiz4sqCXi5EGUH4b6nst2NzEVsiemcG80DScQzyN+z/r
        wOEu/K2mUGxn5p5yMvCs7spfhDVtxRDebGnDipOsLybWI9oA5PNeeoucP9+YWZ9KPia0Bh
        k+Qj04coeYxGOxcztpWp1SrGL+llbi0=
Received: from mail-wr1-f69.google.com (mail-wr1-f69.google.com
 [209.85.221.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-387-5b5_BcS0M_Grs_27PwcpEw-1; Thu, 06 Aug 2020 14:41:40 -0400
X-MC-Unique: 5b5_BcS0M_Grs_27PwcpEw-1
Received: by mail-wr1-f69.google.com with SMTP id 89so15107269wrr.15
        for <linux-scsi@vger.kernel.org>; Thu, 06 Aug 2020 11:41:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=aWG0tiwckPiXTTzMj6No1cMhXlR5WHX+oAkTVDiT6Jw=;
        b=h+Uo/Ghv4Glt/JVP/kcktCYc770DCAX39MLGv69o1JkQa2zhtt+qvvmxCNuBvRtaZa
         RTABoFkGM2NxF3iPwgEJXy9HBNc8Gb8QUEYi5YzJq5ISdP8l5Rfl1nhRirk8aFNYpXz3
         DWzHhcANAQz4DlCbI+Cmd1hYBum/I4ZGShq3eXnKRXGBNlrnnzIDaLZirxKoib117+G/
         NHmZRJJ2o7Q3AlpzeMXARmU6zJFCefMvz2jTS5f8jyClAiVjk5dkN/dXlnhOjCdVXSSs
         +loaUfQGaSU2E8NpQPorOd6W71xTH++qdtGNuxRxrAv2fkGIvVCO7OZ5rgjGVGE5A0wo
         pR6Q==
X-Gm-Message-State: AOAM533QeZWJilbptDZNAjtnH6rzxCiP3CZP22sJldBlg8/BzrVIv/rL
        8mGKAqLYYuLmBCbmO3H6iNOiWTZvDp7KFsG66srZ9YM/9UKWbNN4tF+NXwrRKo7IXi0TUU9lRdC
        cpzrmQv8GrPPLGlcgVBezjA==
X-Received: by 2002:a5d:630b:: with SMTP id i11mr9092740wru.95.1596739298943;
        Thu, 06 Aug 2020 11:41:38 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyD/HfNnmltJvv8GloTLnMDbaqiNdhBu60REohKxUb0ankbCKMR4fnue7noTmVsGSgUorLxqA==
X-Received: by 2002:a5d:630b:: with SMTP id i11mr9092720wru.95.1596739298701;
        Thu, 06 Aug 2020 11:41:38 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:7841:78cc:18c6:1e20? ([2001:b07:6468:f312:7841:78cc:18c6:1e20])
        by smtp.gmail.com with ESMTPSA id s131sm7458669wme.17.2020.08.06.11.41.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2020 11:41:38 -0700 (PDT)
Subject: Re: [RFC 16/16] lpfc: vmid: Introducing vmid in io path.
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>,
        James Smart <james.smart@broadcom.com>,
        Hannes Reinecke <hare@suse.de>, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
Cc:     emilne@redhat.com, mkumar@redhat.com,
        Gaurav Srivastava <gaurav.srivastava@broadcom.com>,
        James Smart <jsmart2021@gmail.com>,
        Ming Lei <tom.leiming@gmail.com>, Tejun Heo <tj@kernel.org>
References: <1596507196-27417-1-git-send-email-muneendra.kumar@broadcom.com>
 <1596507196-27417-17-git-send-email-muneendra.kumar@broadcom.com>
 <61d2fd75-84ea-798b-aee9-b07957ac8f1b@suse.de>
 <08b9825b-6abb-c077-ac0d-bd63f10f2ac2@broadcom.com>
 <aa595605c2f776148e03a8e5dd69168a@mail.gmail.com>
 <227c5ba1-8a9c-3ec9-5a0f-662a4736c66f@redhat.com>
 <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <eec84df0-1cee-e386-c18e-73ac8e0b89a3@redhat.com>
Date:   Thu, 6 Aug 2020 20:41:36 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <b3350b999d5500ddef49a25aafee2ea6@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 06/08/20 18:26, Muneendra Kumar M wrote:
> Hi Paolo,
> 
>> 3.As part of this interface user/deamon will provide the details of VM such
>> as UUID,PID on VM creation to the transport .
>> The VM process, or the container process, is likely to be unprivileged and
>> cannot obtain the permissions needed to do this; therefore, you need to
>> cope with the situation where there is no PID yet in the cgroup, because
>> the tool >that created the VM or container might be initializing the
>> cgroup, but it might not have started the VM yet.  In that case there would
>> be no PID.
> 
> Agreed.A
> small doubt. If the VM is started (running)then we can have the PID and   we
> can use the  PID?

Yes, but it's too late when the VM is started.  In general there's no
requirement that a cgroup is setup shortly before it is populated.

>> Would it be possible to pass a file descriptor for the cgroup directory in
>> sysfs, instead of the PID?
> Yes we can do that.
>> Also what would the kernel API look like for this?  Would it have to be
>> driver-specific?
> 
> The API should be generic and it should not be driver-specific.

So it would be a new file in /dev, whose only function is to set up a
UUID for a cgroup?

Paolo

