Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D725EC4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:19:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230072AbiKZCTS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:19:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229980AbiKZCTR (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:19:17 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 378BE1A3AB
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:18:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669429104;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BpvLrYADNwYvUBlDhe1N+t7q4hEhqyGYFfumYmsnV00=;
        b=A8v+Wthf17Od6zSvCICSL1IBEsnrQSaGI9Z46SlH+EkxzqiY4ToEq6Y3cG3lbeGbvGqd0O
        3WLByTV2YQu+GL3TLiK45L3HUTegGsQG6m/NfRtgYges4iTh9Wg3DBgU8Vz3BRwEX8ZWRW
        rc8DfFsJSLsZiGLapN3BmGofQUoAReo=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-10--nUU2VhRM5-YvgMI74Sf-w-1; Fri, 25 Nov 2022 21:18:20 -0500
X-MC-Unique: -nUU2VhRM5-YvgMI74Sf-w-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.rdu2.redhat.com [10.11.54.3])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 7784D800186;
        Sat, 26 Nov 2022 02:18:19 +0000 (UTC)
Received: from T590 (ovpn-8-17.pek2.redhat.com [10.72.8.17])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 9502F111F3C1;
        Sat, 26 Nov 2022 02:18:10 +0000 (UTC)
Date:   Sat, 26 Nov 2022 10:18:04 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Yu Kuai <yukuai1@huaweicloud.com>
Cc:     John Garry <john.g.garry@oracle.com>, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-block <linux-block@vger.kernel.org>,
        "zhangyi (F)" <yi.zhang@huawei.com>,
        "yukuai (C)" <yukuai3@huawei.com>, ming.lei@redhat.com
Subject: Re: Why is MEGASAS_SAS_QD set to 256?
Message-ID: <Y4F3XG3lMCCKlLAr@T590>
References: <1c4d66ca-fe1a-3d1a-d7f9-4981d2fc9eb1@huaweicloud.com>
 <e11cdb17-053c-390c-9c48-36790eb70cc5@oracle.com>
 <2b89210a-222c-a919-ab5b-c76830308f92@huaweicloud.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2b89210a-222c-a919-ab5b-c76830308f92@huaweicloud.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.3
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Nov 26, 2022 at 09:15:53AM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2022/11/25 20:33, John Garry 写道:
> > On 24/11/2022 03:45, Yu Kuai wrote:
> > > Hi,
> > > 
> > > While upgrading kernel from 4.19 to 5.10, I found that fio 1 thread 4k
> > > sequential io performance is dropped(160Mib -> 100 Mib), root cause is
> > > that queue_depth is changed from 64 to 256.
> > > 
> > > commit 6e73550670ed1c07779706bb6cf61b99c871fc42
> > > scsi: megaraid_sas: Update optimal queue depth for SAS and NVMe devices
> > > 
> > > diff --git a/drivers/scsi/megaraid/megaraid_sas.h
> > > b/drivers/scsi/megaraid/megaraid_sas.h
> > > index bd8184072bed..ddfbe6f6667a 100644
> > > --- a/drivers/scsi/megaraid/megaraid_sas.h
> > > +++ b/drivers/scsi/megaraid/megaraid_sas.h
> > > @@ -2233,9 +2233,9 @@ enum MR_PD_TYPE {
> > > 
> > >   /* JBOD Queue depth definitions */
> > >   #define MEGASAS_SATA_QD        32
> > > -#define MEGASAS_SAS_QD 64
> > > +#define MEGASAS_SAS_QD 256
> > >   #define MEGASAS_DEFAULT_PD_QD  64
> > > -#define MEGASAS_NVME_QD                32
> > > +#define MEGASAS_NVME_QD        64
> > > 
> > > 
> > > And with the default nr_requests 256, 256 queue_depth will make the
> > > elevator has no effect, specifically io can't be merged in this test
> > > case. Hence it doesn't make sense to me to set default queue_depth to
> > > 256.
> > > 
> > > Is there any reason why MEGASAS_SAS_QD is changed to 64?
> > > 
> > > Thanks,
> > > Kuai
> > > 
> > 
> > Which type of drive do you use?
> 
> SAS SSDs
> 
> BTW, I also test with nvme as well, the default elevator is deadline and
> queue_depth seems too small, and performance is far from optimal.
> 
> Current default values don't seem good to me... 😒

If you want aggressive merge on sequential IO workload, the queue depth need
to be a bit less, then more requests can be staggered into scheduler queue,
and merge chance is increased.

If you want good perf on random IO perf, the queue depth needs to
be deep enough to have enough parallelism for saturating SSD internal.

But we don't recognize sequential/random IO pattern, and usually fixed
queue depth is used.

Thanks,
Ming

