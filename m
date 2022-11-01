Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EEE12C433FE
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Nov 2022 22:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231298AbiKAWFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Nov 2022 18:05:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231284AbiKAWFC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Nov 2022 18:05:02 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C16AE1A06A
        for <linux-scsi@vger.kernel.org>; Tue,  1 Nov 2022 15:04:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1667340274; x=1698876274;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5CGKrYuzz8WgBdihOCdFccZcZ/Ts0hXQ5XFSPqoX6eI=;
  b=mI5P+JcPc07aZJOohg7c5rsqZx5hv+6nrN6mzHOzolJcOoZK1npHPdCq
   eM5Wdkj2yEOZqoETjyN+2O3Q+VCVZ+5XxCzq9QV3kR69f0OqIIbT/TUWp
   AEaBm5ef2SRzIIz/xb/d1po8zahNSBQOOENvJfMDYLfEqaeq7RmmOjHVP
   lWsxcpnmQ2FlaXiPmjl70L03+fqK9N5FpNMkAMrtoA1OsYx/VDeEbiKnv
   yBTs83NvNCx3gG9bT1v+iVMlXnXo+zukUa5t6Aj5kO0EpYcZpf9ru8LO7
   pmT+lo/n+wgffEwfqWtydoZ48TBPg0GQFezn9CZCZqWSSUYvMVNFH6xOG
   A==;
X-IronPort-AV: E=Sophos;i="5.95,232,1661788800"; 
   d="scan'208";a="215600069"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 02 Nov 2022 06:04:33 +0800
IronPort-SDR: YTDA1JOJOthX+Rmyj1Ynm51QtMkZT4zILwA3EMrl2gZ8CIMrT92C+e+tPDgoEwhLrDBCfu3Yry
 JWIx7Dr9laeRcnXClzF0Mr720opE5G1eGjZBPZbX6EBFgkgcmvLsC/GpcG2y6FK9Qk5cHL4nYT
 1CmH6FmyrMCt4pybr3aoVn5m3L0lSzjG5kJJ9MEca1SAdg9ltPe5QQQr/oJQPSmkhT09JFeDpZ
 GKSqbrD90ybAdK060SYHBbjXOPyzhFXJ0wSawHZDjsR9NRlIixlSgKp+jfbmQUbgrESFnoeuN3
 Ipf9SEkGdJV1f3wwWbmOVwPm
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Nov 2022 14:23:48 -0700
IronPort-SDR: kGiNK84I9yrGn0eAWdV4V5aDzrAsjsnDfFUY5HUx7pEGDBhJkZFeIVUbr4XO5On46PSnPdgUvV
 qPOFyTr7p8QaYeJWVkvsTrb/mFG5gbO2KOfde2c/p3TgvU1AhTBNWTqb7TePRd7z4nJxjwIDY+
 C8FmPmQprWL19efPj69WH6cxGjXID9jRICTDgOGQrCzgIUXtjXndmp9gkhHLeUyg/akahJber5
 oqTUfnbZznoFHx4/2Uhg/7AqleJY/xd9P1bQKiWi/Wu83LNgTyPhmtlylH5VEonBVmg1BEN0MY
 scQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 01 Nov 2022 15:04:34 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N23w10xHFz1RvTr
        for <linux-scsi@vger.kernel.org>; Tue,  1 Nov 2022 15:04:33 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1667340272; x=1669932273; bh=5CGKrYuzz8WgBdihOCdFccZcZ/Ts0hXQ5XF
        SPqoX6eI=; b=HxL9/O2xXOrC9k286qGg/EqcFkpZLqbyYL294e4iaP5vjUP67ai
        xwV+Lqe7VDi052Y9x+hJJb27j5vE4cDQPwUHsF6nVzCLR1IlyzFMixjdHrTBLb0g
        pNIA9weBhKZN6dbNyqUd1M6/Ux2qiRBv8xxgtL0a1f3q/1zGTBJA2a/B7wC8vPwz
        vXad6wBqIIfStKG7ApSQDykOh3ZE1Pb0HsOG6eacX3iJm6H/E0F7iMYayrzhVN+x
        vbMfOiBeYlrNSzQcsNDR0yWaT/bH/hORxQgvMhkay4KtDjUepUW5AGHxxz/abWxQ
        hF9wxgh+ICSuIzfIIiq6gMMHwtYCGZ+gB7A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Ym3wYKzhOgjs for <linux-scsi@vger.kernel.org>;
        Tue,  1 Nov 2022 15:04:32 -0700 (PDT)
Received: from [10.225.163.24] (unknown [10.225.163.24])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N23vz4LTVz1RvLy;
        Tue,  1 Nov 2022 15:04:31 -0700 (PDT)
Message-ID: <1a7a2b3b-59e8-ac81-2322-5821030c6cd6@opensource.wdc.com>
Date:   Wed, 2 Nov 2022 07:04:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH] scsi: scsi_debug: Make the READ CAPACITY response
 compliant with ZBC
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Douglas Gilbert <dgilbert@interlog.com>
References: <20221031224755.2607812-1-bvanassche@acm.org>
 <af9b39f5-037f-5dea-8c14-0e020e275b9a@opensource.wdc.com>
 <54e0d667-8f14-5788-c1ce-5b9d6d8a0060@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <54e0d667-8f14-5788-c1ce-5b9d6d8a0060@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/2/22 01:28, Bart Van Assche wrote:
> On 10/31/22 20:23, Damien Le Moal wrote:
>> On 11/1/22 07:47, Bart Van Assche wrote:
>>> --- a/drivers/scsi/scsi_debug.c
>>> +++ b/drivers/scsi/scsi_debug.c
>>> @@ -1899,6 +1899,10 @@ static int resp_readcap16(struct scsi_cmnd *scp,
>>>   			arr[14] |= 0x40;
>>>   	}
>>>   
>>> +	/* Set RC BASIS = 1 for host-managed devices. */
>>
>> No it is not necessarily set. It is up to the device vendor to choose if
>> RC_BASIS is set or not, based on the device implementation.
>> Applicability of RC = 0 or RC = 1 depends on the presence of conventional
>> zones. so:
>>
>> 1) If there are conventional zones, then using RC_BASIS = 1 or = 0 are
>> both OK with HM devices. In the case of RC_BASIS = 0, the host can issue a
>> report zones and get the device max lba from the report header (sd_zbc.c
>> does that).
>> 2) If there are no conventional zones, then using RC_BASIS = 0 does not
>> make much sense, but nothing in the ZBC text prevent it either...
>>
>> So we should refine this and maybe add an option to allow specifying rc
>> basis ?
> Hi Damien,
> 
> If I remember correctly the conclusion from a previous conversation is 
> that setting RC BASIS = 1 for host-managed devices is what is done by 
> all SMR vendors and is always correct for host-managed devices.
> 
> I think the description of the my patch is correct, namely that it makes 
> the READ CAPACITY response compliant with ZBC. I did not claim that my 
> patch is the only possible approach for making the READ CAPACITY 
> response ZBC compliant.

Yes, your patch is correct given how scsi_debug always reports the total
drive capacity. So to clarify with regards to the specs and what is
allowed to do, I think that this comment:

/* Set RC BASIS = 1 for host-managed devices. */

should be changed to something like this:

/*
 * Given that scsi_debug READ CAPACITY implementation always reports
 * the total disk capacity, set RC BASIS = 1 for host-managed ZBC devices.
 */

Thoughts ?

With that changed, I think your patch is good to go !

> Are there any use cases for reporting RC BASIS = 0 in combination with 
> the capacity of conventional zones for host-managed devices other than 
> testing the Linux kernel ZBC code?

No use case specific to this I think, given that the kernel always
corrects the reported capacity to the entire drive cap, the user never
sees any difference between rc basis = 0 and rc basis = 1, at least for a
system that support host-managed SMR.
I only was thinking about sd tests :)

And for systems that do not support HM SMR, we would not even see the
drive anyway.

> 
> Thanks,
> 
> Bart.

-- 
Damien Le Moal
Western Digital Research

