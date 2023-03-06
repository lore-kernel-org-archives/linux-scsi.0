Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5157EC61DA4
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Mar 2023 01:41:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229558AbjCFBlm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 5 Mar 2023 20:41:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229437AbjCFBlk (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 5 Mar 2023 20:41:40 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96EAE11168
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 17:41:39 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678066899; x=1709602899;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=+qnX6G2RqJZ7Ts55825gkuKxqao9G/yWG5F5xSkh1LE=;
  b=lWHmMk7FfF0mB6ucqroTlR6zE735BHNbLZo4F6Yhec9Zz58yc8OTlMfq
   PfZ6kKgc9oT4TYk0Q55QQqeyH54BzySMRlkvMfZmWHyjMC1oqdU9y1IKI
   bphdN6irWFrL4wFOjUb8FViX0q0tdrujhXx1OEC0KASaYYQCaklChiyz0
   RjmOOdmhYHDrATA00wHLqcN1bqm/4rJJ+ALAxjnfeDn1stDYb3WIXVErE
   jhGXMo8WFHHTU1qohWpTl2ILNEUTbXbUu07Vrtp1OtCWnvVIzU6QT+Xfd
   3Dyefgh1IB0/xJJRxag8Q4aRSNvzHglZ4J3gU7UmZ5Ibtz4nB1v9rn/uD
   w==;
X-IronPort-AV: E=Sophos;i="5.98,236,1673884800"; 
   d="scan'208";a="224861048"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Mar 2023 09:41:39 +0800
IronPort-SDR: v8SYB6/sFnBWscv4L8J/e/egpbqmsTBOlzUsXIb4YlSu7pBUx34joKBXlshR6351PibPkmgkkz
 lVH+/LJrYLqhff/eiyEwprMidd8+ePm3q4n0drsLO1o0BbjivoaRO8IJzlJZUKTWXon6jFLkGR
 O9sGfsYUmC5enoAIol39DaWCcoZ5Y5ou/9o+sf0HV5ynV+Ohomu6y8C65cF6EyZ1pm23v9sFFT
 J9g2OKJwBCZbZWDFQx4rFHwN0ihjiibA1c0div3s9BCfHZaEFwDVLNzkYxY5kyZu9H+P288Lgd
 5RA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 16:58:20 -0800
IronPort-SDR: mIJcm3b/zeUin+QiocSZdrdCHwFTUF/Oml8/gHPbBxZKxzATqR1CGPDIsvKmeOgXzbMP9RoYbA
 dhLIjOLPZA/xW0hPSGsJbVisKj+tZdhBgdEKALD4jSc05auXXYOznwZ0HdShirpUaYr5KGVAog
 Nk58xn892MoLaGtck5VON/4fTcsMjtHPD3IyRyKl4QuoPAEDw7l28MYNhWRXqfOpDSTK97OLd+
 PCwSy7isM23UXHSd1T8HGQd9rtMO9GxfJ2PUTvEkmI5usospeVw5ZI60EYGFqEETV4BuC87j+P
 nH4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Mar 2023 17:41:39 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PVLsG12tHz1Rx15
        for <linux-scsi@vger.kernel.org>; Sun,  5 Mar 2023 17:41:38 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1678066897; x=1680658898; bh=+qnX6G2RqJZ7Ts55825gkuKxqao9G/yWG5F
        5xSkh1LE=; b=lh05hNgfVDqvNoiz2fzngL6Y+Og9ERjZ7jCLpx+7t6iF4Icy1Vf
        gHTkWg1EZjNHPQoaleLmlGvmdvION9ks3eV3KZbgrNba2LZbJhzGgJRob7t5PbFP
        aYsvFa0b5DG7zN8HGjm3Z+oQosE5Gl6JPIkhlzAgfxYSRPiW4ezgz8+rYRniv5Hy
        IGqWqiKJMFS7ZVdS6jtfV1NdQGO68O10D93rWTdCsdBZzw5SL9ZZ73v9ImyXWMbO
        zDrRzignl51DaL8R0dpZiZdWpBWX+W1e+BFzZAsCPvTUQFOQwlAwNG+9Ckxt4RdR
        yBDyoRN//PG3PPApiId1gQ46hAHlPmgjW9g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5igHdZFbtM3j for <linux-scsi@vger.kernel.org>;
        Sun,  5 Mar 2023 17:41:37 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PVLs94v1nz1RvLy;
        Sun,  5 Mar 2023 17:41:33 -0800 (PST)
Message-ID: <551993a1-6661-75b6-84ee-79ab31a812b2@opensource.wdc.com>
Date:   Mon, 6 Mar 2023 10:41:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 04/81] ata: Declare SCSI host templates const
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-5-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230304003103.2572793-5-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/4/23 09:29, Bart Van Assche wrote:
> Make it explicit that ATA host templates are not modified.
>=20
> Cc: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Note: please cc linux-ide for ATA patches.

I cannot take this as it causes a warning without all patches.

drivers/ata/libata-scsi.c:4198:41: error: passing argument 1 of
=E2=80=98scsi_host_alloc=E2=80=99 discards =E2=80=98const=E2=80=99 qualif=
ier from pointer target type
[-Werror=3Ddiscarded-qualifiers]
 4198 |                 shost =3D scsi_host_alloc(sht, sizeof(struct ata_=
port *));
      |                                         ^~~

Martin,

Can you take this one ?

Acked-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

--=20
Damien Le Moal
Western Digital Research

