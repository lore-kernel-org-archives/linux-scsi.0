Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AC160C6379F
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:10:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235641AbjAQHKZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235858AbjAQHKX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:10:23 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D3A9016
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 23:10:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673939422; x=1705475422;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=q2V3NWgG/L/DSDCbEmm1VVQTHZwJxPmbKdUQ/aAJDqU=;
  b=J6YlAnegYtyAtbIEAxN785ZL+w7RH0Icl+uBa8HtkfYi5fmGK3VpIbqX
   PjnqpSZi0KqNJrL/8awhR/S+ckMMJfK2wFhFQZ7PJJQPwgv0O3p2XZ4at
   LDOD7QHJJJuRe8UtpqtarF3qtu7ksRERRZtzMRYSchlMRwaN7BXXjHqzR
   lBJkzbLKUl5vxgaUIOk00PD2Id9FTjwsAkrah01UidxcJ/67Vxh1JGvZE
   efcR6U6AdQCk6NIVpTqDhnIu2PK8BFjBrFx9ADwDpgJVd1iYXhlEzqWkG
   Lm0yWJaBZIG5fk+9a9xmlbQHGlRTOT4NQ4ZSlz8KU8BShDSKYdsJPwOfh
   w==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669046400"; 
   d="scan'208";a="221066034"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2023 15:10:18 +0800
IronPort-SDR: bA/yBvvphZGHET306Xs+H4MkuGw9khh48mtCR3D539Mc6ZVEzhOLJKiEWIRZjxb5wFpq+GLUAb
 iamovXqM64IIOj3VygW/poK7L6DV4MeVyAnPrvibETd7Bkch3r1JqGYN+uBJgiGYrOafpvmbYe
 CNZootBiqV5VXbPlxYI+JhoFaFO5YKIjWFIIoClQcYjYruhZeFFOWRf/RKVAyQTf1nEpKa7d76
 9w/L4fAiOBfEFXwDVQzXBEOWCRhuyzV1GFIEexSeGpSmxqUthDc//2zscICaj1qNSg7xybdFqZ
 BF4=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 22:28:00 -0800
IronPort-SDR: Xt6u257ZqQ4NWXiZMHg8JO/aslX9u+LmsMGjEx9fAo/FPFGZ1AVW55ERlWJ6Ww+xEB8bXIsuuq
 O28VQeOR+qqv4OozLjjtHnw3EkFYR6rKmHe6qhp3lF4/bZolPjri8RY/gL8DKlJ7dnZagZXrMv
 R+96sJZA5HqR71lEDzIy4IPwSduJ5Ptg4Of4oTMyLBPfkpACLwLTcBUizgG5C3cnqhnzxX4UGf
 H+1w4qzhLT9Av2JWvp4IEO0Pjz9p39jr3liwSH0IwlWynLYPBfM+v5VZrDSQAIVWNNFK/amjgC
 tA4=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 23:10:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nx0Qf1W9sz1Rwt8
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 23:10:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1673939417; x=1676531418; bh=q2V3NWgG/L/DSDCbEmm1VVQTHZwJxPmbKdU
        Q/aAJDqU=; b=W4w/NhrRr35fGiw++8g0VuA85AvFEl8y56V1TXQuFhJKoOgFt+v
        uAG7jb0/jULdOZE8fm+vCJjlIcccVxfvuChA1kYk6H3iDoZu9SeMaiwkS3Uw0xZ+
        wt+GDLCWWbvLuSxLDE2zP96MMAQCl2X7znS2/FdyQqMYwyO5/yQOh1DvQ22UyAcY
        I75VPwFvXx0jN4aDwxS5DRzifkH1KAW3STgMQ9mzMay1+5J0ByoSFDuM6VyI9QSL
        XAg11N0m2G4GjGobKICLRG/ggudsCMRP8rgF5b1kbZ7Mw5UvrKTlWRsHAybTgws+
        +JNBR8wfuWBf2Nx3mPaWANWusFDHo0gwbsA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id x7PxNTu7c4md for <linux-scsi@vger.kernel.org>;
        Mon, 16 Jan 2023 23:10:17 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nx0Qc58DWz1RvLy;
        Mon, 16 Jan 2023 23:10:16 -0800 (PST)
Message-ID: <04ab7f5a-9ba2-09f3-7aff-61cde2696d25@opensource.wdc.com>
Date:   Tue, 17 Jan 2023 16:10:15 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not
 set CHECK_CONDITION
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>,
        Niklas Cassel <niklas.cassel@wdc.com>
Cc:     Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-2-niklas.cassel@wdc.com>
 <Y8Y6/xa3thf4/UNy@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y8Y6/xa3thf4/UNy@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 15:06, Christoph Hellwig wrote:
>>  void ata_scsi_set_sense(struct ata_device *dev, struct scsi_cmnd *cmd,
>> -			u8 sk, u8 asc, u8 ascq)
>> +			bool check_condition, u8 sk, u8 asc, u8 ascq)
>>  {
>>  	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
>>  
>>  	if (!cmd)
>>  		return;
>>  
>> -	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
>> +	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
>> +	if (check_condition)
>> +		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
>>  }
> 
> Adding a bool parameter do do something conditional at the end
> of a function is always a bad idea.  Just split out a
> __ata_scsi_set_sense helper that doesn't set the flag.

What about passing the SAM_STAT_XXX status to set as an argument ?
Most current call site will be modified to pass SAM_STAT_CHECK_CONDITION,
and we could add a wrapper ata_scsi_set_check_condition_sense() to
simplify this most common case.

-- 
Damien Le Moal
Western Digital Research

