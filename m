Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18054EEAA5D
	for <linux-scsi@archiver.kernel.org>; Thu, 14 Sep 2023 17:26:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239657AbjINR1B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 14 Sep 2023 13:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239636AbjINR0u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Sep 2023 13:26:50 -0400
Received: from mail-pl1-f171.google.com (mail-pl1-f171.google.com [209.85.214.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5C5C630FC;
        Thu, 14 Sep 2023 10:25:47 -0700 (PDT)
Received: by mail-pl1-f171.google.com with SMTP id d9443c01a7336-1bf6ea270b2so9437835ad.0;
        Thu, 14 Sep 2023 10:25:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694712347; x=1695317147;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IjSdNGrGDVw1GsjsQXFC9tRcvdaXmu/HXzm4uDToAvA=;
        b=kUEtkzyaAChKa3SycECJo4WMwGLi4y6JmV88gftCk9gowHUPGCOVOJmyrhCI0PZrU0
         /ivzLTkbKnjlKAROk58KpqGDrS8EemEACtFFmT+0/+4f99zcA/zLllqSg0tjFUuzBrkV
         jH4wdxRUBzpQpeAx62ei+aChKeuKWgaYQm9lxRzGMPVbkdXsaBOCixn6Xph8UThRZp+E
         egtxLFdBobOIBICrjvd7my6ftgspS51XejstXNSlXly1mYCFvcGWbXPVUJ+hfCGtxtbR
         8OcFFfXrrLETkK7eVyArUaTNcF378/t7S3vRoeel0+VrWUI+zTF9AQDMWS++LwjGB1wH
         OSNg==
X-Gm-Message-State: AOJu0YxmBBo2Br0gjQ49s/GItlT4tcJi4mgyQZ+LrFM0PCC//l06SnIr
        p4VdRkUVvkwTs0qJVAqfz4ExZsNH1vU=
X-Google-Smtp-Source: AGHT+IGPoMou88Sh6vDx+pGHESc5K1/YWYkMRhR7cNs+Bn41SF25DpfEy7WXy/oQvRfgpeW606cz1w==
X-Received: by 2002:a17:902:ab95:b0:1bd:d92d:6b2 with SMTP id f21-20020a170902ab9500b001bdd92d06b2mr5880096plr.10.1694712346613;
        Thu, 14 Sep 2023 10:25:46 -0700 (PDT)
Received: from ?IPV6:2601:647:5f00:5f5:4a46:e57b:bee0:6bc6? ([2601:647:5f00:5f5:4a46:e57b:bee0:6bc6])
        by smtp.gmail.com with ESMTPSA id ik26-20020a170902ab1a00b001b89b7e208fsm1880035plb.88.2023.09.14.10.25.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 14 Sep 2023 10:25:46 -0700 (PDT)
Message-ID: <f45fb721-aa64-4a10-952e-cf5236a5d1e3@acm.org>
Date:   Thu, 14 Sep 2023 10:25:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 05/19] ata: libata-scsi: Fix delayed scsi_rescan_device()
 execution
To:     Damien Le Moal <dlemoal@kernel.org>, linux-ide@vger.kernel.org
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-6-dlemoal@kernel.org>
Content-Language: en-US
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20230911040217.253905-6-dlemoal@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/10/23 21:02, Damien Le Moal wrote:
> Commit 6aa0365a3c85 ("ata: libata-scsi: Avoid deadlock on rescan after
> device resume") modified ata_scsi_dev_rescan() to check the scsi device
> "is_suspended" power field to ensure that the scsi device associated
> with an ATA device is fully resumed when scsi_rescan_device() is
> executed. However, this fix is problematic as:
> 1) it relies on a PM internal field that should not be used without PM
>     device locking protection.
> 2) The check for is_suspended and the call to ata_scsi_dev_rescan() are
>     not atomic and a suspend PM even may be triggered between them,
>     casuing ata_scsi_dev_rescan() to be called on a suspended device,
>     resulting in that function blocking while holding the scsi device
>     lock, which would deadlock a following resume operation.
> These problems can trigger PM deadlocks on resume, especially with
> resume operations triggered quickly after or during suspend operations.
> E.g., a simple bash script like:
> 
> for (( i=0; i<10; i++ )); do
> 	echo "+2 > /sys/class/rtc/rtc0/wakealarm
> 	echo mem > /sys/power/state
> done
> 
> that triggers a resume 2 seconds after starting suspending a system can
> quickly lead to a PM deadlock preventing the system from correctly
> resuming.
> 
> Fix this by replacing the check on is_suspended with a check on the scsi
> device state inside ata_scsi_dev_rescan(), while holding the scsi device
> lock, thus making the device rescan atomic with regard to PM operations.
> Additionnly, make sure that scheduled rescan tasks are first cancelled
> before suspending an ata port.

One patch per subsystem please. I think this patch can be split easily 
into an ATA patch and a SCSI core patch.

Thanks,

Bart.
