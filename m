Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 888F3C43217
	for <linux-scsi@archiver.kernel.org>; Mon, 30 May 2022 07:51:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234076AbiE3HvP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 May 2022 03:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60162 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234125AbiE3HvE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 May 2022 03:51:04 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D98872230
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 00:51:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653897063; x=1685433063;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=HaPGZSTF+M/Vie2GoNQv9Xg6rkhuwxNkYlYU8WtzlzY=;
  b=qdwu1eRrJcLBOKMccEHbipo3H1xno5QoGasxXalZGpOcQfXTYNCLkfV0
   HvYE/fiKX/SGhIrshzgQIS1TUPpseyD5mFfSz9a3oxlrZCVjjSnkQ4zzG
   atB7sgS/Y5lSSsQEEE3ziNf+kctEzFRWXvWA9fh9SvIjS0OIfutJmT3Qg
   fJm0A0R4doMQ9OAUQudS/OGnrPjdnDKg2Ddy4EqC4Q+NKphc2zuXEeCwe
   OKSsvEDmi9O+5ZXYRBrJ135s1TDnjVFoyg0cZYpjG7gzeyCqPuoXEiwKX
   u2VPjyzfflFQEdsaKTcVWOCbGhz/opGtWmCKaQzuuK3d8mJb7fcKKqcDJ
   A==;
X-IronPort-AV: E=Sophos;i="5.91,262,1647273600"; 
   d="scan'208";a="200542483"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 May 2022 15:51:01 +0800
IronPort-SDR: soGMaMRQswmZJYq4wkK8NpuxAq+w0yKrmoAGflnjyBdAdL8/JFInSkKbB/DEGHUQ9AecRA6M4D
 JNYCCsEI417oA5LRgolNtg1Kmk+KmuywkT+OmYidSapa0YH88PKjrB+oJ54A4pHFiueGJpHRnE
 4iWsC3Oc6+wW64gDqy/Gq8veFI6gwrwPQGZ82LMNOmwTNLjVPT5R7vGR8ZDOR0ndHHg8Np+tyg
 PMSvjiEb2gHJyweGhVl6t8zwdfJPKO/YInp6MPl6ckeuo74HX6zDr9i6tcpth7gYulUKVVHZ8l
 V+XIWkb9XMey6kvV/dguTEsj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 00:14:49 -0700
IronPort-SDR: VxYCbiwLJsfHqutlTfYpKeu+ckC0DPUVBHu63139mV6swy7cMRnQ+rWJRxceJrk+VUdAPj0vhd
 tl5JdCyFiMV2yimUa6a3cv1RadX6bexzPwVhzhbdDyDyZVrJ9f3yc8a9RHfQZZI7uV6pDJS9Vq
 +7f3v5pIbp3nPmVI2uXX3O83vDlYVRL6Ew6gCcFZauNmi/ZIRJfTlQNMdRH9DyUBqGepUh9YM+
 6opO1qUgiD13uYqYdpI/r+8B1rogzk3I+4YZJrbcAGbVG138yYcJvtRlMPiOsZwDPGlUvrX9xh
 PhQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 May 2022 00:51:01 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LBSJh3Tbkz1Rvlx
        for <linux-scsi@vger.kernel.org>; Mon, 30 May 2022 00:51:00 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653897060; x=1656489061; bh=HaPGZSTF+M/Vie2GoNQv9Xg6rkhuwxNkYlY
        U8WtzlzY=; b=Pub0ljuCQn5TJ/uw8ZxgV0ngkgqGFT7XWz0ooLHQw8Wjjil3BsJ
        MKHqCRK/kImnZyl7Rnn/QSbbJ94ESupdem8G6MTJc7yj//PIVPum2VsBKtzcEwiE
        naUEr7nmaIJGwGd0x2prT+7WucxEDbCtLpHNSwFd7sU7cQI6vL5q2ZfrAHenjWf8
        kdRrMmbSmYo8sZXEo52fbkXrqtVP2Ie8QUlFc0EuZkMv0o017K0bSuNNfP6GZlmP
        dwYa96gmeqvd85NnwvYLJzMAxtS23rryxkFznwm0kZD3D4M93Db6Vp1WL0s0vECs
        r5DfODYsdmnuPSATiaZadZZVpE8lIdCJLwA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id D6hVkFZVR2l7 for <linux-scsi@vger.kernel.org>;
        Mon, 30 May 2022 00:51:00 -0700 (PDT)
Received: from [10.225.163.61] (unknown [10.225.163.61])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LBSJg2J6Xz1Rvlc;
        Mon, 30 May 2022 00:50:59 -0700 (PDT)
Message-ID: <1f873c7a-d0cc-b413-f4e9-90d5c5c3faa5@opensource.wdc.com>
Date:   Mon, 30 May 2022 16:50:57 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH 2/2] scsi: sd_zbc: prevent zone information memory leak
Content-Language: en-US
To:     Johannes Thumshirn <Johannes.Thumshirn@wdc.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Dongliang Mu <mudongliangabcd@gmail.com>
References: <20220530014341.115427-1-damien.lemoal@opensource.wdc.com>
 <20220530014341.115427-3-damien.lemoal@opensource.wdc.com>
 <PH0PR04MB74163AD6E7785C0F842592229BDD9@PH0PR04MB7416.namprd04.prod.outlook.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <PH0PR04MB74163AD6E7785C0F842592229BDD9@PH0PR04MB7416.namprd04.prod.outlook.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/30/22 16:48, Johannes Thumshirn wrote:
> On 30/05/2022 03:43, Damien Le Moal wrote:
>> Make sure to always clear a scsi disk zone information, even for regular
>> disks. This ensures that there is no memory leak, even in the case of a
>> zoned disk changing type to a regular disk (e.g. with a reformat using
>> the FORMAT WITH PRESET command or other vendor proprietary command).
>>
>> This change also makes sure that the sdkp rev_mutex is never used while
>> not being initialized by gating sd_zbc_clear_zone_info() cleanup code
>> with a check on the zone_wp_update_buf field which is never NULL when
>> rev_mutex has been initialized.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>  drivers/scsi/sd_zbc.c | 15 ++++++++++-----
>>  1 file changed, 10 insertions(+), 5 deletions(-)
>>
>> diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
>> index 5b9fad70aa88..6245205b1159 100644
>> --- a/drivers/scsi/sd_zbc.c
>> +++ b/drivers/scsi/sd_zbc.c
>> @@ -788,6 +788,9 @@ static int sd_zbc_init_disk(struct scsi_disk *sdkp)
>>  
>>  static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
>>  {
>> +	if (!sdkp->zone_wp_update_buf)
>> +		return;
>> +
>>  	/* Serialize against revalidate zones */
>>  	mutex_lock(&sdkp->rev_mutex);
>>  
>> @@ -804,8 +807,7 @@ static void sd_zbc_clear_zone_info(struct scsi_disk *sdkp)
>>  
>>  void sd_zbc_release_disk(struct scsi_disk *sdkp)
>>  {
>> -	if (sd_is_zoned(sdkp))
>> -		sd_zbc_clear_zone_info(sdkp);
>> +	sd_zbc_clear_zone_info(sdkp);
>>  }
> 
> Now sd_zbc_release_disk() has become a simple rename of sd_zbc_clear_zone_info().
> I think it can go and we can use sd_zbc_clear_zone_info() in the callers instead.

Yes, I thought of that, but I wanted to keep the name to make it clear
that the "main" caller is scsi_disk_release(). But if you insist, we can
get rid of it :)

-- 
Damien Le Moal
Western Digital Research
