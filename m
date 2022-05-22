Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CD111C433FE
	for <linux-scsi@archiver.kernel.org>; Sun, 22 May 2022 22:22:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351844AbiEVWWp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 May 2022 18:22:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351676AbiEVWWn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 May 2022 18:22:43 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D995125C78
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 15:22:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653258162; x=1684794162;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=g7+JeN4wnrl6dFXGk3nhuKNxU3bxTCBHH+iqteHxNFE=;
  b=qom7J0UPljuV3SlsejTAR0GN9eLFTyZF/Jge45CqmuPhYNKyFMsRQh5V
   Cpl0J1+8UrYYAiOtPI1aMQBT2+nIxD9XOaeAY+/bbG++pcLOsBaM4B5a5
   WeUmHP7Rw/4ldnDvNZcj2XC7DM2bzVsjqP1+PhvvhGk2oxjtcB7kMT+ui
   klOoaC42KiVmtbkDHvVYqg4ym74HBAG8846VbKaxXVlu9PBb6LktUhXEZ
   MbEQcg/uD4eia0yQ81Sqxi8MMXJkRUOkL3Gq1wslYHcq3TgdbtVhRDLx9
   7HGxhHt2x/AWoAymtukIc5rBtNb8iEgZqloGodYfnvwZK11kH+XRlF+Mu
   w==;
X-IronPort-AV: E=Sophos;i="5.91,244,1647273600"; 
   d="scan'208";a="305310282"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 23 May 2022 06:22:41 +0800
IronPort-SDR: +c/iwmiKy8b0LyupN3gcmRpLYq4LwcigrHEcw/VzRXLrA3iqAnBWqFNTJ44dQwiL0lFEzZ0Xmc
 7be63DmqdWQrLNRnzncNYkP/q9SGEZSETNUHMm8E5wPh5zlaaaJcTcApuILnBUYkqsRnSuPxTS
 FwpaPdt/73O9FWOt8fpYJPKtGKHRYFlz12CYyVnUx8NhgCELov9jogtALSEF6CQ0kuNThhjzMK
 ZLdHZ4vswhheYZcA2LepMYMWwkbyeanpbgcJDTTg8o33BlfcLqJLM5e3cAuoUkUMpkifMK5J0E
 VhHC9xqRxZEOp2Bqmha6hIDk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2022 14:42:16 -0700
IronPort-SDR: RPItbeQa+5Gpi/cN5+r0A0Ez02rzCPtkdr21BwvH98vQPB2IFCzUGN5cYuMrr6svqJjPCciel4
 hdUxl7REroC9QCebtRrBTEbQJr04yS3dajLI11jCmRp1Nb0xtKg6XVJabYzCRfkWdxS4MXNM9n
 LzWuSsT1Jiad3M+nDW9uJkpXzkRFHNp8o6zSlYH7rJJYjXUdBaDTXiihnm6hFthd9M65EKMqGy
 roCeQEkHOG3eCtikhUuTd40GOZMklC5Igsawd/PZnUz5kbVSHo1FLYCWgeVOUkSN5FOuzw0Gvt
 OBE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 22 May 2022 15:22:41 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4L5w2847Tcz1SVp2
        for <linux-scsi@vger.kernel.org>; Sun, 22 May 2022 15:22:40 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653258159; x=1655850160; bh=g7+JeN4wnrl6dFXGk3nhuKNxU3bxTCBHH+i
        qteHxNFE=; b=cFP8EjCWYzIn0k4ie3WKPohm2MCo0AumuYqBQTKCtVbOnF5ahgC
        3DMD77wHEBGNIby9QYVO8Kyj8ThYO13/AhkkmwvMo1hw6M+usps0UivIXgCdZseU
        9A6F5n+Fh6VrhIr7wexiIbbqwP/tasyeStlJ/r5Q78CNt8JpJvfsexJ4TyKQTbY2
        aY7WAwIjYDT4mh9L4oSbx4j06Oa3+BPww0WpgkiA5gn05hxU90tfn4OZw+TdYdiC
        O82vY1I2LjR+sEaV1nVlyE1A1wP+OTnEVYJ/WTGpbJJtbREAsy8XMVCmYRSC0I1S
        oStpPqSyJ5iYY82wZ98GYO9okFFzZCtC3dw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hdNceKn_Lxpn for <linux-scsi@vger.kernel.org>;
        Sun, 22 May 2022 15:22:39 -0700 (PDT)
Received: from [10.89.85.73] (c02drav6md6t.dhcp.fujisawa.hgst.com [10.89.85.73])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4L5w252KbGz1Rvlc;
        Sun, 22 May 2022 15:22:37 -0700 (PDT)
Message-ID: <15f94ea2-fa97-3122-60dd-a87a3dd8a7db@opensource.wdc.com>
Date:   Mon, 23 May 2022 07:22:35 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH 0/4] DMA mapping changes for SCSI core
Content-Language: en-US
To:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>
Cc:     joro@8bytes.org, will@kernel.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, m.szyprowski@samsung.com,
        robin.murphy@arm.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-scsi@vger.kernel.org,
        liyihang6@hisilicon.com, chenxiang66@hisilicon.com,
        thunder.leizhen@huawei.com
References: <1653035003-70312-1-git-send-email-john.garry@huawei.com>
 <20220522131345.GB25785@lst.de>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220522131345.GB25785@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/05/22 22:13, Christoph Hellwig wrote:
> The whole series looks fine to me.  I'll happily queue it up in the
> dma-mapping tree if the SCSI and ATA maintainers are ok with that.
> 

Fine with me. I sent an acked-by for the libata bit.

-- 
Damien Le Moal
Western Digital Research
