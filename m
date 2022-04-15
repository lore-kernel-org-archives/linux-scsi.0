Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3A066C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 15 Apr 2022 05:10:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345280AbiDOFNB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 15 Apr 2022 01:13:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349944AbiDOFMv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Apr 2022 01:12:51 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 841B58149C
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2022 22:08:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649999311; x=1681535311;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Fza98p6Hk/Oo3R5YjAQC2Nws92s1JhenlM6js5zQuBI=;
  b=eH7fhRQ5Emf7mnVoxYT0vT1ynrsoefol7CjLKx/XFK1lQ81oC9FnkImk
   0NvSAhootdN/mtykKo57EDtbn7QC7BqNjq7L/dHxLEFE6ljGWqWQIm0i3
   BW5OG8PE8TF6wOemfDnO5HzDUZnLBPyHAYk2akTrdI//A9C6bbVD9C8CG
   6QbLAAhWuHhV9fk4K+f8Pjrbv15O0S56sdANUVtss7i9WT7pH9QsV4tH5
   kCwbUNkuqTLEkoJQ/bUoE233322a65AFm2rEvTmKcnFsaa+C4zrvzX79x
   SMjZjjguqq845PbqpRFsFxIU8MBB741m0wBEDKq9MFre5pFWtmZ0idIkm
   g==;
X-IronPort-AV: E=Sophos;i="5.90,261,1643644800"; 
   d="scan'208";a="309936207"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Apr 2022 13:08:28 +0800
IronPort-SDR: 7dY4UdOY5EnEnSYd6y7s76QpphmD9Qr39TzlJakKad56A3lpCYIaY1f382n87Q4WNO9yHKqFy7
 AYZaDa+g6a/GOd06Kj0kwKDDuRU5Hndz1INgCvBBGpWDjNgl2m/comSaD3jRqQIh3zbVpxBwMn
 HC8/IS03W+FeQgnCNZjLzeSAd+4+05A625v/Q3lEw3rSAUKoM1Em2M+L+XFqTRyTWfHdqpF0VV
 DJyhOfVrkSG6gbWjT7uskxtK/LPHNYUkjHwEQJG5H311u0OwhdWkC5dogbOyzM7DBJc5TD1Cnb
 TWVWt7eFmO6L2vfzkzpDVtQv
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 21:38:53 -0700
IronPort-SDR: E9rtI9yNyC5IBb+/ffI/okStEP/rpEhyAs7WyWBHW3M3RiGrB1ZIPPmS+lfHgFawAl+iACaPd3
 pMwH0kE4Fj2ZyQdqUE+gRo6ZAyXefVZyV9DYodYTolgK6C8IHGqls291JhAFIgVxfjzTRHYqJ1
 8xKc6V0Y+J7pSDt7HFvruOAlqwovbjp88VpJAzunZ4oCMnRJnTD4VdbDGNOC2O7QJvDHNC4NJm
 9knI4a4IkfTjezUNKGSGgt49Rf8McToigAFh/WKcekNxK9dpndDLiBJTxhdKIermtBzTtpyiiP
 h+8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Apr 2022 22:08:29 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Kfkqw0SNDz1SVny
        for <linux-scsi@vger.kernel.org>; Thu, 14 Apr 2022 22:08:28 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649999306; x=1652591307; bh=Fza98p6Hk/Oo3R5YjAQC2Nws92s1JhenlM6
        js5zQuBI=; b=ImgmXK0ljefxmjcwwGCZe/P1ZAiYRfxiStEm0q2wFeKQMvkTL85
        MoEiv1WWngR6yiDdywhy6m6c7CHetStsP2KPL7aGmRBSEDoQ0BBkWf7uSl7GctxX
        seFLiVHTqharLpAbcplk3yzDBSQpNNHnyTWqCGnT6SDEQPGGz4njOldB2JpZjV0c
        Fn1jBi13ZsAeHMQyLgImvLHIeNwH3xSreGo+kohOYlio/FQU9mPmWWTRsJd3G6Vg
        s7uGQ1kCv0yoS1gOWClHM7ArPs0jj6m4kJVcJWYcgsITqalXpkzGP3XvQ+R3owbL
        r+qmM2ogk4tvzMNidepDhru5fT38QuGd/Yg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UqazBQwU-c7q for <linux-scsi@vger.kernel.org>;
        Thu, 14 Apr 2022 22:08:26 -0700 (PDT)
Received: from [10.225.163.9] (unknown [10.225.163.9])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Kfkqn6sCZz1Rvlx;
        Thu, 14 Apr 2022 22:08:21 -0700 (PDT)
Message-ID: <d7a39cfc-9b28-f0d6-bf62-4351c55daec2@opensource.wdc.com>
Date:   Fri, 15 Apr 2022 14:08:20 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 27/27] direct-io: remove random prefetches
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     dm-devel@redhat.com, linux-xfs@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, linux-um@lists.infradead.org,
        linux-block@vger.kernel.org, drbd-dev@lists.linbit.com,
        nbd@other.debian.org, ceph-devel@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        xen-devel@lists.xenproject.org, linux-bcache@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-mtd@lists.infradead.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org, linux-btrfs@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        cluster-devel@redhat.com, jfs-discussion@lists.sourceforge.net,
        linux-nilfs@vger.kernel.org, ntfs3@lists.linux.dev,
        ocfs2-devel@oss.oracle.com, linux-mm@kvack.org
References: <20220415045258.199825-1-hch@lst.de>
 <20220415045258.199825-28-hch@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415045258.199825-28-hch@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/15/22 13:52, Christoph Hellwig wrote:
> Randomly poking into block device internals for manual prefetches isn't
> exactly a very maintainable thing to do.  And none of the performance
> criticil direct I/O implementations still use this library function

s/criticil/critical

> anyway, so just drop it.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>


-- 
Damien Le Moal
Western Digital Research
