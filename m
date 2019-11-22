Return-Path: <SRS0=RMqd=ZO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C3922C43215
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 18:26:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 990872068F
	for <linux-scsi@archiver.kernel.org>; Fri, 22 Nov 2019 18:26:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="LExwGuLY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726759AbfKVS0T (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 22 Nov 2019 13:26:19 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:33568 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKVS0T (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 22 Nov 2019 13:26:19 -0500
Received: by mail-wr1-f67.google.com with SMTP id w9so9818989wrr.0
        for <linux-scsi@vger.kernel.org>; Fri, 22 Nov 2019 10:26:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=Y/IHVHc1ELnmcLONQTBZ1j/UV45S8Rkhyv/6XVAgC8M=;
        b=LExwGuLY2hcu/Lb7XI78C+LUCJAt9IWplowRhrPHHEkgGDWz/9ANMaEVMVFVEzuGNC
         PjvopKvv71MvejydvDPKy3MYNNtzNHylKOj9mfMlhtBGv34veavPhEdupgp48+DXxzuM
         TzFRiO52XYyGj6tPaq97WGgF0Gb5hyU9hSwzs=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=Y/IHVHc1ELnmcLONQTBZ1j/UV45S8Rkhyv/6XVAgC8M=;
        b=kB65K24WOBmfC2ILOfYnf2Z2YyK77ssQvitbib6XzHtdLoeX3MyWHXm91K2DPLtQH6
         aR6iEC3VPi16YrhDUpkmfNHtelqOpbwxpnur3m69O9Jq+v7KrN7gPeBxYu3Fnox0AXCo
         cJ5gqr6tyvY8MGK2dCuZCJTfE2P1DmaaB00hlu20/VyTWxIJXBziVx6vqNX1bQrylDcj
         jvXoFqkFg21QBXbbl488HQifJs1YQIH1sJqOtWpnli5wCuhru10kcWjHBMibTp37kq86
         KcKFMrGkS70xunBJBZ1HVOq2brZvdr1uBevIPuuGjGuHYVC4RdHONEnFLL16dmNaVJRP
         +NSg==
X-Gm-Message-State: APjAAAWDYDWW4Y7Dyaj68OEF9ZjnAxXcI7NjbxwAXc5IyFtL6W1OTTdG
        9sBLNs2YT4LlrKPFHTP63QAhvQ==
X-Google-Smtp-Source: APXvYqwpDV/fQopgTPz1WnxrAmWyitWl3mUmZYllDphkr6ye73bUYmMyHcO6lj4Dw8gf0rdv/evOlQ==
X-Received: by 2002:adf:db8e:: with SMTP id u14mr10316775wri.274.1574447176773;
        Fri, 22 Nov 2019 10:26:16 -0800 (PST)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c10sm4316768wml.37.2019.11.22.10.26.12
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 22 Nov 2019 10:26:15 -0800 (PST)
Subject: Re: [PATCH 4/4] scsi: core: don't limit per-LUN queue depth for SSD
To:     Bart Van Assche <bvanassche@acm.org>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>
Cc:     Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org,
        "James E . J . Bottomley" <jejb@linux.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Chaitra P B <chaitra.basappa@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
        "Ewan D . Milne" <emilne@redhat.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <bart.vanassche@wdc.com>
References: <20191118103117.978-1-ming.lei@redhat.com>
 <20191118103117.978-5-ming.lei@redhat.com>
 <1081145f-3e17-9bc1-2332-50a4b5621ef7@suse.de>
 <20191121005323.GB24548@ming.t460p>
 <336f35fc-2e22-c615-9405-50297b9737ea@suse.de>
 <20191122080959.GC903@ming.t460p>
 <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <7e44d961-a089-e073-1e35-5890e75b0ba7@broadcom.com>
Date:   Fri, 22 Nov 2019 10:26:11 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.1
MIME-Version: 1.0
In-Reply-To: <5f84476f-95b4-79b6-f72d-4e2de447065c@acm.org>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



On 11/22/2019 10:14 AM, Bart Van Assche wrote:
> Thanks for having shared these numbers. I think this is very useful 
> information. Do these results show the performance drop that happens 
> if /sys/block/.../device/queue_depth exceeds .can_queue? What I am 
> wondering about is how important these results are in the context of 
> this discussion. Are there any modern SCSI devices for which a SCSI 
> LLD sets scsi_host->can_queue and scsi_host->cmd_per_lun such that the 
> device responds with BUSY? What surprised me is that only three SCSI 
> LLDs call scsi_track_queue_full() (mptsas, bfa, esp_scsi). Does that 
> mean that BUSY responses from a SCSI device or HBA are rare?

That's because most of the drivers, which had queue full ramp up/ramp 
down in them and would have called scsi_track_queue_full() converted 
over to the moved-queue-full-handling-in-the-mid-layer, indicated by 
sht->track_queue_depth = 1.

Yes - it is still hit a lot!

-- james

