Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6E82C43334
	for <linux-scsi@archiver.kernel.org>; Sun, 12 Jun 2022 22:51:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237326AbiFLWvU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Jun 2022 18:51:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232947AbiFLWvT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Jun 2022 18:51:19 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8B11417051
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 15:51:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655074275; x=1686610275;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=VGi9rGalprjkv4emLGIhVhUXQ49JSjVRps/v58K9I6Q=;
  b=T9KddTSQo0JUtOy0nykXd3c9TN3Q7cDKtGFPs6PvQDIhtdsFTv0mYFzy
   JojEdMOgzUJbr4jO4fuvnBRRLX4GZ4/sLuk76ZtlDNx7sB5p///gkQMDz
   daUDQQUe/7ZFap4mcZCORMhVrJfp2Asi+LobjOYKwHPCl6SFc7FBNxLF8
   3DEDzRC6QRWj5rFC0DLPZvYTt0/jxgFg26/p6Bi+NROFHNrXYgzAUynlf
   Q4wl3Utgw9HkLpZE2oaOz5xjQRmLhHymhKD5q0fkRBLLlvwjufjjulp/P
   vYsxXJKOHSGnS4nnLAshG/cTL8+DG/U7Gn+x1pApAD9YNoALNZcPMBruK
   g==;
X-IronPort-AV: E=Sophos;i="5.91,296,1647273600"; 
   d="scan'208";a="202939966"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 06:51:15 +0800
IronPort-SDR: l1N3ypP3NEpHm9j5Ce+++QQts1gXjybgXyvU59grX+XLJmP4Vtmtw2qfRiqKskLM0cd2OB6iNM
 ikpLXgfPUuipBe45i75KXwq5FEuxG7gAiPfa+MEDg9DvM2+smOk3V+edwdrrCmoVZUNd2LzyHY
 VboXAV/9DI2xL0xmDeUibsu/dKiJ/JwPJlgkjmqsrgJzroi+Hp4IAR8y5fAaK1TS5TW4AqkNHL
 XrUtw1B4qeP0TJmegSSSuFRR10cTE+caQ1HGfmN3t0HAos8i/fAlHPFlVEo69u/jFcqnOZEi+X
 nvWe8RWSyqu0GtNLc6oRS9mB
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2022 15:14:20 -0700
IronPort-SDR: KwGHRih/mFLRrBVHcZ3RRxmBHmaE0ghRsc+mV+WCtRBp40FYPVZ5BTkntTHhnpOhCZrYKlCS2l
 /lS+olz65SulhYr3CFqBuHpMiPr7pwfHRnQgIeqWeIGDiTPVDPkpMkRoFz5C0DmdvuoQMmrfgf
 ZNkltzikt5f3PJNhfIxvDjT9+Sa0kDvItnechSCrfm/YiZKlYZrWvDzNPrInh1VgzORdG+x1kg
 dH0+F7xf3szk74gaU551oAa+eTrSRJ+ezTgtpRya/yGCyT4EnAv0TfkhKeOlM3vTq14glu/4zS
 cd0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2022 15:51:13 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LLqgK0zl9z1SVnx
        for <linux-scsi@vger.kernel.org>; Sun, 12 Jun 2022 15:51:09 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655074268; x=1657666269; bh=VGi9rGalprjkv4emLGIhVhUXQ49JSjVRps/
        v58K9I6Q=; b=OwwIw7HkIp3DgsNTOAYIJVqVj61F0YAlk/LSTIAOznmoJFNpnqZ
        mUrbO3himG/q6iOjPCoAWPciHZIEpBxwALWoM4mTPnrbUJW7OoS42QhCvkpEdo7p
        s+peZ+BMn9lojIYkGOYeBAuFQp7bS1/mWSCRDp6ins74KwPM7TvCzZGKObfWspEP
        CkA4VZOWIgWVwiT54du6EWSUH+HDKJTOtUTox8QWKRBQnGbxVbqFS+dPnDOITf+5
        qck76+6sP475If+T9pfaRziYsMUaaJ+GuUlqOf4v+tkyAKybJx/fItMk39Fk2PNc
        K81xHgzVZdYJqias3j3aSM8oUa+YsK9nu0Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id DToXf6_I5pgK for <linux-scsi@vger.kernel.org>;
        Sun, 12 Jun 2022 15:51:08 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LLqgJ0ZkLz1Rvlc;
        Sun, 12 Jun 2022 15:51:07 -0700 (PDT)
Message-ID: <3a1430e6-8c95-7e5e-dff2-c2e38b147f9b@opensource.wdc.com>
Date:   Mon, 13 Jun 2022 07:51:06 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2] scsi: scsi_debug: fix zone transition to full
 condition
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>,
        Niklas Cassel <niklas.cassel@wdc.com>
References: <20220608011302.92061-1-damien.lemoal@opensource.wdc.com>
 <yq1a6akwji4.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1a6akwji4.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/22 01:51, Martin K. Petersen wrote:
> 
> Damien,
> 
>> Fixes: 0d1cf9378bd4 ("scsi: scsi_debug: Add ZBC zone commands")
> 
> Not sure where this SHA is from?
> 
> I fixed it up...

Oops. Off by one character. Missing the leading "f".
The sha is:

f0d1cf9378bd ("scsi: scsi_debug: Add ZBC zone commands")

Sorry about that.


-- 
Damien Le Moal
Western Digital Research
