Return-Path: <SRS0=NMWN=AO=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB6A0C433E2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 14:15:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AB91920723
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jul 2020 14:15:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kroah.com header.i=@kroah.com header.b="X4zSbtnO";
	dkim=pass (2048-bit key) header.d=messagingengine.com header.i=@messagingengine.com header.b="BcZNo9Jl"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbgGCOPh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jul 2020 10:15:37 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:37865 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726035AbgGCOPh (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jul 2020 10:15:37 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.nyi.internal (Postfix) with ESMTP id 0955B5803F1;
        Fri,  3 Jul 2020 10:15:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Fri, 03 Jul 2020 10:15:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=z
        KWBYny3iDOXqfEov6mNFlQwdTq6pPlOUJ3jHU1Ut0o=; b=X4zSbtnOChdOfdwj4
        ZsHpWEPgI/P4NvAlL45g+qH4wxO/o8Ld1NZmdnj9cFAfq+J8hKUxCToDyxmPztt9
        AASsj2Po/V6y+BqZZkCiD74IdhlVHm37lKLznTwxVgBcVwHJthAX0ASQtI0Ch960
        9J3N+Xe/DibLRGpYHuYHYR0GR3ehGVK03cCyKhkqk9O1pLKYb1my36LVwUIm4uvx
        Wu4qkRgAmOFjzhsTCZWl7pourJ+0PQW3KTuM5S8XaMdHH5Na8BSmkbjpOmQfKa93
        iGXF2NK1QHLaOE77wjcqea0JWr0q+OVCuA6MYZr3+g8LCFEh+9uMFSgwZLeSyHoJ
        ciP6w==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=zKWBYny3iDOXqfEov6mNFlQwdTq6pPlOUJ3jHU1Ut
        0o=; b=BcZNo9JlcfpZeWiB7hF613yGVEH8R2lVktXE743yxza6iUxP0gRC1PRIA
        ITPN6kR+aLTJcAJSPK26W5DkkOxvxO/fuzqOo7zh6E3yyDZeiKljrNap83yiIX56
        Dl1+3Wx2L6bLFg0k4iJGGQQKyqu9W9YBp7o2DgOGWQn/DhfclsTLHBPopS/r3eAl
        IvFZbfjj8nUUxdHhmyxWHFuMTfutcL4crBC6FJKQK5d/oIpBoHyXruwVWCxlW6ac
        KVoA3mQ9yeb6o+EeNsaqmEO5vCg7yeq/ho4TaFnwVQPX2nMlv8C1AYvgo1vJ8b3c
        aGF5nQmg4pBcRsvhmi4WcrJhz/lMQ==
X-ME-Sender: <xms:hj3_Xgd15l6i8u60POAo9lPUt9JoboitO7gjz_g8FfoPWXYdQA--JQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduiedrtdeigdejhecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeevtdeile
    euteeggefgueefhfevgfdttefgtefgtddvgeejheeiuddvtdekffehffenucfkphepkeef
    rdekiedrkeelrddutdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:hj3_XiM6rrFxfFy3o52UMRun9Kel2Se49FZb6Nt86w3yx4Z4t2Txfw>
    <xmx:hj3_XhiLDhkLLUyFzJ8l_uv1YkNyyaLkpMerDR9pP7wx5A8HtvGVrw>
    <xmx:hj3_Xl81LAuYy5RGopuh-7y-iebfknPPDOYVjMSDOJGlp0-3H0jcpw>
    <xmx:iD3_XtnyJedGjxeQsK7bra1krYBGsnzUMCi1KLafmTPTaDV3g0QxWg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id B62FD3060061;
        Fri,  3 Jul 2020 10:15:33 -0400 (EDT)
Date:   Fri, 3 Jul 2020 16:15:38 +0200
From:   Greg KH <greg@kroah.com>
To:     Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Keith Busch <kbusch@kernel.org>,
        Christoph Hellwig <hch@lst.de>,
        Sagi Grimberg <sagi@grimberg.me>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Javier =?iso-8859-1?Q?Gonz=E1lez?= <javier@javigon.com>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 2/2] block: add max_active_zones to blk-sysfs
Message-ID: <20200703141538.GB2953162@kroah.com>
References: <20200702181922.24190-1-niklas.cassel@wdc.com>
 <20200702181922.24190-3-niklas.cassel@wdc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200702181922.24190-3-niklas.cassel@wdc.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jul 02, 2020 at 08:19:22PM +0200, Niklas Cassel wrote:
> Add a new max_active zones definition in the sysfs documentation.
> This definition will be common for all devices utilizing the zoned block
> device support in the kernel.
> 
> Export max_active_zones according to this new definition for NVMe Zoned
> Namespace devices, ZAC ATA devices (which are treated as SCSI devices by
> the kernel), and ZBC SCSI devices.
> 
> Add the new max_active_zones member to struct request_queue, rather
> than as a queue limit, since this property cannot be split across stacking
> drivers.
> 
> For SCSI devices, even though max active zones is not part of the ZBC/ZAC
> spec, export max_active_zones as 0, signifying "no limit".
> 
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> Reviewed-by: Javier González <javier@javigon.com>
> ---
>  Documentation/block/queue-sysfs.rst |  7 +++++++
>  block/blk-sysfs.c                   | 14 +++++++++++++-
>  drivers/nvme/host/zns.c             |  1 +
>  drivers/scsi/sd_zbc.c               |  1 +
>  include/linux/blkdev.h              | 16 ++++++++++++++++
>  5 files changed, 38 insertions(+), 1 deletion(-)
> 
> diff --git a/Documentation/block/queue-sysfs.rst b/Documentation/block/queue-sysfs.rst
> index f01cf8530ae4..f261a5c84170 100644
> --- a/Documentation/block/queue-sysfs.rst
> +++ b/Documentation/block/queue-sysfs.rst
> @@ -117,6 +117,13 @@ Maximum number of elements in a DMA scatter/gather list with integrity
>  data that will be submitted by the block layer core to the associated
>  block driver.
>  
> +max_active_zones (RO)
> +---------------------
> +For zoned block devices (zoned attribute indicating "host-managed" or
> +"host-aware"), the sum of zones belonging to any of the zone states:
> +EXPLICIT OPEN, IMPLICIT OPEN or CLOSED, is limited by this value.
> +If this value is 0, there is no limit.

Shouldn't this all be in Documentation/ABI/ to describe the sysfs files?
All other kernel subsystems use that format, why is block special?


> +
>  max_open_zones (RO)
>  -------------------
>  For zoned block devices (zoned attribute indicating "host-managed" or
> diff --git a/block/blk-sysfs.c b/block/blk-sysfs.c
> index fa42961e9678..624bb4d85fc7 100644
> --- a/block/blk-sysfs.c
> +++ b/block/blk-sysfs.c
> @@ -310,6 +310,11 @@ static ssize_t queue_max_open_zones_show(struct request_queue *q, char *page)
>  	return queue_var_show(queue_max_open_zones(q), page);
>  }
>  
> +static ssize_t queue_max_active_zones_show(struct request_queue *q, char *page)
> +{
> +	return queue_var_show(queue_max_active_zones(q), page);
> +}
> +
>  static ssize_t queue_nomerges_show(struct request_queue *q, char *page)
>  {
>  	return queue_var_show((blk_queue_nomerges(q) << 1) |
> @@ -677,6 +682,11 @@ static struct queue_sysfs_entry queue_max_open_zones_entry = {
>  	.show = queue_max_open_zones_show,
>  };
>  
> +static struct queue_sysfs_entry queue_max_active_zones_entry = {
> +	.attr = {.name = "max_active_zones", .mode = 0444 },
> +	.show = queue_max_active_zones_show,
> +};

__ATTR_RO()?

thanks,

greg k-h
