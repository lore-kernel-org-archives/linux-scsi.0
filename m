Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9B627C54E94
	for <linux-scsi@archiver.kernel.org>; Tue, 24 Jan 2023 21:34:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234156AbjAXVez (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 24 Jan 2023 16:34:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55784 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232680AbjAXVey (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 24 Jan 2023 16:34:54 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8F9947422
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:34:53 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1674596093; x=1706132093;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=l0vqgWg4Laq8fXDcDcvrkmwUI/JNjdn7eQg93Xfna8w=;
  b=BfSvoiybz4aybK0Nr+yISzKoKweQ1+rhyCqCr1520w6xgUrLYGEzp6Fi
   AMLNez+UUGpcv3oMl3atwK3u99yAcLUqXyQ3vpNuBRMmSB5PF754ofBY7
   LsgyZmI5C9UrSj9EhgoRGzZo696Q96oiw+bBYiGnwRbDYiHim27OylF0V
   tBp08ssBDhv20bhlAY/WUCO/LNLAZlMnGeUBuphHVsH2+0hbIKxIaQBhQ
   sbkNmyCeu3j/Krr6uqJgqXrj3i1MJXJ902Yog30K3EJoF450emehh/39h
   vtcayXcd0qbp0NhffFLVeHNm4l3bz03PbuFmOrF60awZZGlPHwjNDQpYP
   Q==;
X-IronPort-AV: E=Sophos;i="5.97,243,1669046400"; 
   d="scan'208";a="221734962"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Jan 2023 05:34:51 +0800
IronPort-SDR: PueK0QWTtYdCRKs+YmGo3qruj7IzJXIFZ+yPAnSj7dAO3kFJ0rd8MNJdvyY1Xt2RfEmarXCzJe
 OVoitmYVny+E0cX7EMI+lZifQTVyeU/bbo3IGXy+9sfc5457rYLLexf/5pyBarV8F0esB2PMk0
 PO2HBw86edzRdvije6h7AyDFhGDLYqqtJdK9TiGka0AyeEzLUuTj2a4tZmcHeQdlc5RFie0tJw
 yMG0zNyxrAhgqlwVu2b1gHuKqj9UlCmHFwvm1+ESA+AYBKHTe+6mvVDlKxEb12E9IkGwuj/rES
 GLQ=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 12:46:39 -0800
IronPort-SDR: oqeCwTopVNCFb/fMJ6UjtG32ocMpC1OaMJJO9ERSxGZYqlXhnaV+qCKNJixJHwW1LabAfDnAKa
 P2EDNYR6WlSyChY96WMN/NuKlYggvLudbQ2dmuU2DsdqM3sUCcFEvFOeORiqXYK3CgYrGrr6vW
 EUR1K6GCWrNHrjn7Ddt6SLy0di8crj+caq8XmKvyshW44in8ZDteHUtwPZv1ir7iE6xCe6WCJg
 5cgiZgjZvhLC20HOfDcgWnpqyPjRUPZ7wKmzrHomJ44IpleIjt8Brqb2kQzD0ty9W3T2bOB8dY
 Sdk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 24 Jan 2023 13:34:52 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4P1gGz4rN6z1Rwtm
        for <linux-scsi@vger.kernel.org>; Tue, 24 Jan 2023 13:34:51 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1674596091; x=1677188092; bh=l0vqgWg4Laq8fXDcDcvrkmwUI/JNjdn7eQg
        93Xfna8w=; b=NeeStZ1+EYL0cwfnlm2SdOz1Ck0zOwriemujnG24kwk3LBiO2us
        3/pW02TrPx1zM3pPujNdPvtOTzs1106u8kmisWXokiKvMCmWsHnmT3R/y6sps9JR
        viDlDjdMoVFxS88Qcanlinbf1s32Ax1Wh9u9z8Awoeb7g70DY+zC6ZnizrI4t/KM
        K90aJwjkXTcrpRb+AsmrSh7NJdAMcANE8STaeWXYPHAsCm9F6H1oosFoPfcczKQX
        MIWeUun62NdNVxWcK7jXHq0+GGYVBHbu6h61P+NLGo5Clxj5PH2w5dABEbW+N1hQ
        XkpnJJL+LReAjmuN9tyJQMsEfZ7/Z71Znuw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id X8P7y8Ztfreb for <linux-scsi@vger.kernel.org>;
        Tue, 24 Jan 2023 13:34:51 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4P1gGx4cZfz1RvLy;
        Tue, 24 Jan 2023 13:34:49 -0800 (PST)
Message-ID: <891fdc9d-ad9a-7817-01c4-87c91861eb2f@opensource.wdc.com>
Date:   Wed, 25 Jan 2023 06:34:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v3 02/18] block: introduce BLK_STS_DURATION_LIMIT
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        Jens Axboe <axboe@kernel.dk>
Cc:     Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230124190308.127318-1-niklas.cassel@wdc.com>
 <20230124190308.127318-3-niklas.cassel@wdc.com>
 <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <517c119a-38cf-2600-0443-9bda93e03f32@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/25/23 04:29, Bart Van Assche wrote:
> On 1/24/23 11:02, Niklas Cassel wrote:
>> Introduce the new block IO status BLK_STS_DURATION_LIMIT for LLDDs to
>> report command that failed due to a command duration limit being
>> exceeded. This new status is mapped to the ETIME error code to allow
>> users to differentiate "soft" duration limit failures from other more
>> serious hardware related errors.
> 
> What makes exceeding the duration limit different from an I/O timeout 
> (BLK_STS_TIMEOUT)? Why is it important to tell the difference between an 
> I/O timeout and exceeding the command duration limit?

If the device fail to execute a command in time, it will either
1) Fail the command with an error and sense data set (policy 0xf for the
time limit)
2) Return a success status for the command with sense data set telling the
host "data not available". This (weird) case is in essence equivalent to
(1) but was defined to avoid the penalty of a queue abort with SATA drives
(NCQ command errors always result in all on-going commands being aborted).

In both cases, the drive is still responsive and operational.
BLK_STS_TIMEOUT is used if a command timed-out, indicating that the drive
is *not* responding. BLK_STS_TIMEOUT thus generally mean "something is
wrong" (not always, but most of the time.

So we cetainly do not want to overload BLK_STS_TIMEOUT to indicate failed
CDL IOs as that would not allow the user to distinguished from more
serious hardware issues.


-- 
Damien Le Moal
Western Digital Research

