Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 23645C04FDE
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Dec 2022 00:29:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229632AbiLIA3k (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 19:29:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiLIA3i (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 19:29:38 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B21C3941B5
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 16:29:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670545777; x=1702081777;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qk9j8LVxjXBJSIxe9aNCa/SGxFRCLd8rLG0tmlR1LxU=;
  b=dJew+5WP55mmeGbNeQ/5C2gcG4q3S2oUAmyoQ2tho/TkRdjSLUNdiAoZ
   W0wlahvL691uht9OGEfJsFYSPHj9aHSFLc4wUiyh1vzRJnzR30S7RQydw
   9aJD6K4qJyEKZSNtiV1WR7Wz78Gii/fUKFUqGmBo8NxZ19Z+IYDUJGSXE
   iQ3a6wNAe0e2qa94rVkbWnAldUQc7AX67is/Iwe/anFaKIsRZwNyniKCB
   hZlTYbpXKcxcZHrKdbKxKZUQ+XjFWXqYkN+F8bzIhbbBc5bTd19TX9tkQ
   CUFL54+bR3yeDT0T9pVOR19E4UXFUhpERhKBFjGbSjiJYRC1dVfzn2lB4
   w==;
X-IronPort-AV: E=Sophos;i="5.96,228,1665417600"; 
   d="scan'208";a="218499348"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 09 Dec 2022 08:29:35 +0800
IronPort-SDR: kEadZBgSijbK6AvhaOMB0JW38WPXsuXeIi0zZxLpSK2plpZkV9cCZvd8bE7njuZixGRhe158Is
 CeVO17yqBNOuVMgE1vvzTZkeL0SRcz0RgwUeXJ2CG4A1Eg23XfQL4HU6UTeKleFD67K807h7a+
 NNAm98BMEftkx4fpJNH4tt+djrf20DCPPKhQUv6vWpG3J3SKsRA2+suBasjKVnBSs7hXCYv1rW
 2Bl/ys8dtpKBHi9EavrP6JDmTi7W+JdGDsYJNCzALUfsdKAPnoF46QzC9DRoxgqeYOpzq5n5s6
 0RQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 15:42:19 -0800
IronPort-SDR: MUNlXrRTVSgirV1QHtmqSyVm7jk1l3rRkEFPUT81MIM8wwdtzVPKbkD3eLPE8w/zfGm2pJdepq
 t0AaRYshhautN0yFv8LxMCrGRXh2dXvHaXUpklTbDNazLCRhdjFIaQq2u2pCZNp8D279p+vtqO
 OnxGkeJGFDB07D188W3lL78bIbTIJw9yqRihZDuPcqm9rVvywf6sMIm0LGvdUKzlR0wl1nd2GO
 fFIJelTYV8pq4rcHbwIfsEcygiHId9b5u/K59hLUIHGq0YH036n1Sq3GdAwIYYjSFMTzU8uHCx
 Wtk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 08 Dec 2022 16:29:37 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NSsNH0fZrz1RwqL
        for <linux-scsi@vger.kernel.org>; Thu,  8 Dec 2022 16:29:35 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670545774; x=1673137775; bh=qk9j8LVxjXBJSIxe9aNCa/SGxFRCLd8rLG0
        tmlR1LxU=; b=huebuoh6+rUFkVDfHWkwIdyIRMRkWTzAylli86kSWUThPdepn69
        dn8RJOqP8ddhUIT3MX36NTVEJdrxenavwp13bJnEvWIGoGBVmwzI03NGAR7TETY9
        a2zGxW1uSHZznctJSJkaQ/rwiVuuy6FloZgtZo148Q08VVK18r4XbYMZ50ub25yE
        tcRwCMDmuqSg1dpb7CSgwNK/VQUs0eSYireH1H6erTxZqDkmgkv8AT4Jasf9M3tM
        PA54Xq2VhYzj5BR+gPwUS8HO4qgVVjGaeS2HhzxjTuE5u+pYcXrkJ6AXASDkZdpO
        M7QdQJFRMm5vpqkfPVBLwL57p0UVDm4uXEA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id obqPmZS3k7_M for <linux-scsi@vger.kernel.org>;
        Thu,  8 Dec 2022 16:29:34 -0800 (PST)
Received: from [10.225.163.85] (unknown [10.225.163.85])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NSsNF3v33z1RvLy;
        Thu,  8 Dec 2022 16:29:33 -0800 (PST)
Message-ID: <510732e0-7962-cf54-c22c-f1d7066895f5@opensource.wdc.com>
Date:   Fri, 9 Dec 2022 09:29:32 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH 00/25] Add Command Duration Limits support
Content-Language: en-US
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <20221208105947.2399894-1-niklas.cassel@wdc.com>
 <daff011b-6aeb-e6ba-c71b-8b0ff9a21ef7@nvidia.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <daff011b-6aeb-e6ba-c71b-8b0ff9a21ef7@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/9/22 03:18, Chaitanya Kulkarni wrote:
> 
>> Kind regards,
>> Niklas & Damien
>>
>> Damien Le Moal (14):
>>    ata: libata: simplify qc_fill_rtf port operation interface
>>    ata: libata-scsi: improve ata_scsiop_maint_in()
>>    scsi: support retrieving sub-pages of mode pages
>>    scsi: support service action in scsi_report_opcode()
>>    block: introduce duration-limits priority class
>>    block: introduce BLK_STS_DURATION_LIMIT
>>    ata: libata: detect support for command duration limits
>>    ata: libata-scsi: handle CDL bits in ata_scsiop_maint_in()
>>    ata: libata-scsi: add support for CDL pages mode sense
>>    ata: libata: add ATA feature control sub-page translation
>>    ata: libata: set read/write commands CDL index
>>    scsi: sd: detect support for command duration limits
>>    scsi: sd: set read/write commands CDL index
>>    Documentation: sysfs-block-device: document command duration limits
>>
>> Niklas Cassel (11):
>>    ata: scsi: rename flag ATA_QCFLAG_FAILED to ATA_QCFLAG_EH
>>    ata: libata: move NCQ related ATA_DFLAGs
>>    ata: libata: fix broken NCQ command status handling
>>    ata: libata: respect successfully completed commands during errors
>>    ata: libata: allow ata_scsi_set_sense() to not set CHECK_CONDITION
>>    ata: libata: allow ata_eh_request_sense() to not set CHECK_CONDITION
>>    ata: libata-scsi: do not overwrite SCSI ML and status bytes
>>    scsi: core: allow libata to complete successful commands via EH
>>    scsi: move get_scsi_ml_byte() to scsi_priv.h
>>    scsi: sd: handle read/write CDL timeout failures
>>    ata: libata: handle completion of CDL commands using policy 0xD
>>
> 
> Out of 25 patches linux-block mailing list only got 3,
> was this on purpose ? see this and [1] :-

Not sure how Niklas sent the series.

Niklas,

For the next rev (we will need one to at least rebase on 6.2-rc1 I think),
please make sure to send all patches to all lists/maintainers.


-- 
Damien Le Moal
Western Digital Research

