Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7D777C63797
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 07:15:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234181AbjAQHPM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 02:15:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58340 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232887AbjAQHPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 02:15:07 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 366FB222E4
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 23:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673939705; x=1705475705;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=qZNzQDc/ZbS4BJ95C7XcQsakw7aagTetVs9swLtBGv8=;
  b=RmeWa98MqsQnqEVo28dcTh7QcoBV5izAUgh+3VM2LXEuiTQHcXFo1tfL
   QkPNsEqq/KzBWApQNIK52ZNHIV55mnV4IiANg0x56eLtnb9Py9zdWBeS4
   lD1iSG/O+V3zEtqJzsLwLlprJojcSylplE5fm7FiBWxK/PMiX429Rt1LX
   jE5l1zySvHHb8eB4Gk3kpMr670tYTPR6YImdWDsP6ZholV7YvXt5n6FtK
   1BRmnEQoZtcXvYL7pNYSVDtLzEeYvsMnuAu91lZheavp3p7aerYQq/eF0
   vkDATr/xsD9umwLfZ1/GVnFs8LbbvR09ypkSAtfN+lls70mCvAHkW6xEz
   A==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669046400"; 
   d="scan'208";a="221066477"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2023 15:15:04 +0800
IronPort-SDR: id25oFQgLtkjtQZI9ugx2hQHg6HtVNnNzg9M1urpUgAAHujIeBUfRGnNx4N4Zii9N1wQi7K851
 kGiqNYstR4iAMadNHdBy4bxdEh2vPs1ywwA/INY//eyhx720xEl89dZqTmfn73iXIUul3ze1to
 h0fRR+ERZppMryxNBDoAm9V0k5g9YJzsayTH4sNk0N5XumXBQkdvR3CEnXR2l5XOEqodqasV6S
 IZoPuXWzTuI2M8Vt4a1YtXVxTNm9z7kV2hJLUQ+q4Sq415l9fbKrobcS9yspxU41MrIQPKO3V3
 YbA=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 22:27:01 -0800
IronPort-SDR: 7QYSQh3BBJYxK6wfW8TjBFc0a2y/IJgOSMKnmmowkacLFjfbR16Dd9Jn7QGdse9rG6B3QYPhrR
 it5YHJCgpNZiRHR0GpWrmIFP90MNYyaCim1juMtJeuIoZ3yVKTw3dAuxx6OuoKLFVoMk3MtyN7
 bSl0olJKPSnkzges0/TDUqrrsGKuTF3KOWKPTJwwkmk4ZBja/DVLNdvPhWwpuA9s2BXmDXfzK/
 7Yj2Neh7yHrUks5oEUEYKOb+67Xbplxc6icH1EL8DAiv/8vy+XBvi4xLfNifsHs0hw6YjrQcIh
 WdA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 23:15:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nx0X80PMBz1Rwt8
        for <linux-scsi@vger.kernel.org>; Mon, 16 Jan 2023 23:15:04 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1673939703; x=1676531704; bh=qZNzQDc/ZbS4BJ95C7XcQsakw7aagTetVs9
        swLtBGv8=; b=GQDzwhGr1EGOzFNtBfMTNEJIisfeTB9e4TKX/SaucLLO6cdnnQU
        Q0xH+WdwQAdDAggJgps/fPqQmkLMVT+rKbzHiDp+X+ghSktfbZ7mvww9iADJd8Qo
        zwm6LRiogDP7yUQVBoFDx38mw6oWaxbe4TK7+we7Bav6wRiHMOlGYrVVf4G9zuGi
        gUrWk61EG4ESfWPZ9Ip7IXHdps+7p9nefwPrzIJy2/Wk0E+7Hs6l195AFbtqMDMA
        zOHkIq8JSEiEQvJcknQkGTk06q+2boqbi/etpqzWO7rvIrOgyxJV86k+RCvpcpwk
        NbQGeoV5ngE8oLCIEZOWzd7SDyxrrCNw0IQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eDmjKbOLp33r for <linux-scsi@vger.kernel.org>;
        Mon, 16 Jan 2023 23:15:03 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nx0X64PZGz1RvLy;
        Mon, 16 Jan 2023 23:15:02 -0800 (PST)
Message-ID: <b1c381c4-5bb5-f697-ef35-686edb1404dd@opensource.wdc.com>
Date:   Tue, 17 Jan 2023 16:15:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 01/18] ata: libata: allow ata_scsi_set_sense() to not
 set CHECK_CONDITION
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-2-niklas.cassel@wdc.com>
 <Y8Y6/xa3thf4/UNy@infradead.org>
 <04ab7f5a-9ba2-09f3-7aff-61cde2696d25@opensource.wdc.com>
 <Y8ZKUnVtxlpOzXKR@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y8ZKUnVtxlpOzXKR@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 16:12, Christoph Hellwig wrote:
> On Tue, Jan 17, 2023 at 04:10:15PM +0900, Damien Le Moal wrote:
>>>> +			bool check_condition, u8 sk, u8 asc, u8 ascq)
>>>>  {
>>>>  	bool d_sense = (dev->flags & ATA_DFLAG_D_SENSE);
>>>>  
>>>>  	if (!cmd)
>>>>  		return;
>>>>  
>>>> -	scsi_build_sense(cmd, d_sense, sk, asc, ascq);
>>>> +	scsi_build_sense_buffer(d_sense, cmd->sense_buffer, sk, asc, ascq);
>>>> +	if (check_condition)
>>>> +		set_status_byte(cmd, SAM_STAT_CHECK_CONDITION);
>>>>  }
>>>
>>> Adding a bool parameter do do something conditional at the end
>>> of a function is always a bad idea.  Just split out a
>>> __ata_scsi_set_sense helper that doesn't set the flag.
>>
>> What about passing the SAM_STAT_XXX status to set as an argument ?
>> Most current call site will be modified to pass SAM_STAT_CHECK_CONDITION,
>> and we could add a wrapper ata_scsi_set_check_condition_sense() to
>> simplify this most common case.
> 
> What's the point of that?

Trying to get to a pretty solution keeping a single line for setting sense
+ status. But sure, splitting out the status setting works too.

-- 
Damien Le Moal
Western Digital Research

