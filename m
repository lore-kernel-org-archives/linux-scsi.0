Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF614C64EC4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Mar 2023 06:57:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbjCCG5h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Mar 2023 01:57:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229734AbjCCG5g (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2023 01:57:36 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D160329148
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 22:57:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1677826654; x=1709362654;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=h6o+qH748RiJrnvZ5x1FcoTbX18JCtSOtr2uOHizk7c=;
  b=f3Cnybsva+lWedhKlyaYHgj5oQXx8/PQFv3W4XXjW9L9J5bbx6SMLuS9
   LdPLqtoe8Sx8b0CnGUndsCvlhis+6TyxEdUxofizXQWBRajc4NzvBx9jM
   pIRLePKkHYPEVO8Wsdmq0tJZITvpuFtkj0dI6Z2RHsP2eet9Hd5xVhTdR
   /gFZCWYhl/PW5Z5N2bLVxFr1dbMOSachQxrXPeGQiVplbWC4Od3qyqdDv
   tXqY1mOVx+f2yR7JVLV8Ov7x0EoJ3kBPsItGpvhwwbxZI7smm2hi6Exey
   t4gEmcJyP9Ls05gc88kvBMLHZHJaWV5S/9kAgSYYRBT+OSoVg2t21CrVg
   A==;
X-IronPort-AV: E=Sophos;i="5.98,229,1673884800"; 
   d="scan'208";a="336685902"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 03 Mar 2023 14:57:32 +0800
IronPort-SDR: wmM6u7HeX6FLL0Xd36+j5XuvFwJrboNpUA8gvyIiBPHUWPY/fkEx1ouovPjqEU4xUpnyBktyGP
 rbL5Dulgoy0MeBEfuWAX4mlxYY8F8avwmXZdof+wpqLhJiwyR9YuES2loYz1Vt3iUCxZty5tSP
 4ejFEloobcTabKCmg7U8b9+C5aW33SI6cNhZS2tnHUMzxwRluG1WhL8XQUXRX5E9EpxXESDiwv
 PG4cjYt5dF0OFk5Dl4FeKdBPhU1/q8UPKk0fI5fMAiljRrugXtEtntSsXdyNTspkHE5BZZic8D
 ZKw=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 22:14:20 -0800
IronPort-SDR: NxVr9Yi+ud0OrIPJwlS3MUNQ0PQ3YEO7ptuJQtmpAmqUot0RUk42FZWqgcanpx4gXGCc2yPfZy
 9OtotDncJrc4SwbzTBlc0nRuCX8yTTfHOkhBSFPQlvBiygPplap/svDywIA5sl0zCoe5GtxBJe
 lfcB7JkcrTBWGEn5VXhx994xKIiP53HFfqLvhxcKVNvnDo/lHpjKthjXr2Osd0g6QUGeQrRVGo
 WGq8IVhZ1BW1lembV1knuDl/dkh0Cfd0E21fJDSE76W2FS0SbkXhB41NjR0jQwPf6jMWltwa7E
 c6g=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 02 Mar 2023 22:57:33 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PSf186VmKz1RvTp
        for <linux-scsi@vger.kernel.org>; Thu,  2 Mar 2023 22:57:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1677826650; x=1680418651; bh=h6o+qH748RiJrnvZ5x1FcoTbX18JCtSOtr2
        uOHizk7c=; b=TZIy31DeOx4uii6oGm2q46ruHwzfh8G2pVGWgb8zweKTkNavoT6
        HMn63pzLT/6qRGUheQVtsg77aqPorn9pht9SdaVwCYDQ+RMc75FIu5vAPES7NP+Z
        +z7xpRLhmCH1UQVxGWuCjg/M6NT1SObpFsJYprg0ixEhFUIz80s0a7u/H5B+5Fri
        ZarB0kgZRHtetbhOwLuTaHEiuH1upDpxSHWl/2yJv1Eqaqou5QQXmEwKq3dkmGbC
        CzQ9+aJCmzKySv8n/QqABKSUMsVyfdVqd4vtvce/NeAC1yrWZdx5KdautEkQXGrh
        NSHg63Ada4fZwjiLqjaYiDL6d5WlRNh3cag==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aOf8k4-iszY6 for <linux-scsi@vger.kernel.org>;
        Thu,  2 Mar 2023 22:57:30 -0800 (PST)
Received: from [10.225.163.47] (unknown [10.225.163.47])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PSf1555s3z1RvLy;
        Thu,  2 Mar 2023 22:57:29 -0800 (PST)
Message-ID: <821d9c72-5d19-4099-cb65-f3056f6a46c5@opensource.wdc.com>
Date:   Fri, 3 Mar 2023 15:57:28 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [LSF/MM/BPF TOPIC] Hybrid SMR HDDs / Zone Domains & Realms
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        Khazhy Kumykov <khazhy@chromium.org>,
        lsf-pc@lists.linux-foundation.org, linux-block@vger.kernel.org,
        linux-scsi@vger.kernel.org
References: <CACGdZYKXqNe08VqcUrrAU8pJ=f88W08V==K6uZxRgynxi0Hyhg@mail.gmail.com>
 <ad8b054a-26a5-ea60-9c66-4a6b63ca27ef@acm.org>
 <54fb85ac-7c45-f77f-11d7-9cb072f702fb@opensource.wdc.com>
 <569dc9d2-3e6c-0efc-560c-bfcacfbfbda7@acm.org>
 <8e3643a5-80bd-8c02-8e83-a2c1341babcc@opensource.wdc.com>
 <c719261e-203e-18f2-b72a-de0c64011efe@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <c719261e-203e-18f2-b72a-de0c64011efe@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/3/23 03:26, Bart Van Assche wrote:
> On 3/1/23 18:03, Damien Le Moal wrote:
>> But that is the issue: zones in the middle of each domain can be
>> activated/deactivated dynamically using zone activate command. So there is
>> always the possibility of ending up with a swiss cheese lun, full of hole of
>> unusable LBAs because the other domains (other LUN) activated some zones which
>> deactivate the equivalent zone(s) in the other domain.
>>
>> With your idea, the 2 luns would not be independent as they both would be using
>> LBAs are mapped against a single set of physical blocks. Zone activate command
>> allows controlling which domains has the mapping active. So activating a zone in
>> one domains results in the zone[s] using the same mapping in the other domain to
>> be deactivated.
> 
> Hi Damien,
> 
> Your reply made me realize that I should have provided more information. 
> What I'm proposing is the following:
> * Do not use any of the domains & realms features from ZBC-2.
> * Do not make any zones visible to the host before configuration of the 
> logical units has finished. Only make the logical units visible to the 
> host after configuration of the logical units has finished. Do not 
> support reconfiguration of the logical units while these are in use by 
> the host.
> * Only support active zones. Do not support inactive zones.
> * Introduce a new mechanism for configuring the logical units.

That is not how the zone domains/zone realms feature is defined. Matching this
would require specifications changes. But an even bigger problem is that this
would not work for ATA drives (ZAC-2) as the concept of LUNs does not exist.

> 
> This is not a new idea. The approach described above is already 
> supported since considerable time by UFS devices. The provisioning 
> mechanism supported by UFS devices is defined in the UFS standard and is 
> not based on SCSI commands.
> 
> Bart.
> 

-- 
Damien Le Moal
Western Digital Research

