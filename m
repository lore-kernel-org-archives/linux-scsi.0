Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 268A1C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 21 Mar 2022 12:56:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346113AbiCUM6F (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 21 Mar 2022 08:58:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347662AbiCUM5u (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2022 08:57:50 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D711B106638
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 05:56:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647867384; x=1679403384;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=rK+GWJIqnJbJS1w8TqvmeBh+mp1pponUH9/IsWJGSTM=;
  b=WWeFrFedtuhrfFPVgw8AqQlREnZbqIrCYwSf9k/gBeKf86MUT+7kgXJA
   XBaSGROzJv0gXxWWwiXKsaKIv49duFi0NgNoZO2TbwZRi7QZHbtwzZ6hK
   MAPuqIlb/9zkKLFkwJUWojRvyG+6a+OuCgGIdxM5krdr9xs/tAx2dGYX9
   2GXATBkDyGfTHiHXjLKf+jclY8RZ+1b4EtNMbk9q62BS0oZSe7oknIG6F
   DA3LYLRK1ZyGFr6W+OfuiWs9gqZ3tK5EukK2Sw//bYW5KeYZSsYyTKiFt
   3FFtlSZkj6OEP+uFTKpE0WEUaSpOxp665xOQ82fsWnJvJudFYQ7Jpjwc2
   A==;
X-IronPort-AV: E=Sophos;i="5.90,198,1643644800"; 
   d="scan'208";a="307823450"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 21 Mar 2022 20:56:24 +0800
IronPort-SDR: wD/OVjXW7vGEi4wOaMmsb76sKwogCminoauxaM6t9jxsbLeWgPHPxVbZM9KtMOCvrbXBDDQgDK
 5ZxFzdYmYpSfHnvUV2HYnjpOqJeU6UGPFeV7juVf0INcUvdsU1jA2Wfi9L3QXkxs0uf/q/2zJl
 wQMAMEPPlwTdbcLdUTiFZo6X4m7xkqgxc9kRe7urCO0IBWQBdglRZ9hCYvHtMrzGpTH0oSFsl3
 N+qfouDS76lsFlBBAC02dQJ1yRKazTEfiKCaDGN6u7NSSgJUkRFId3g+87oBI+W1u+sUINzDVA
 XP0ZNRkvOXZHgDYotzvGlWAP
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 05:28:21 -0700
IronPort-SDR: RmW8JSqiXiLsjqF7HHmlh3r7lGkcjepK99ief+ur/WRXlWebjRb49QH+f5XRroSgGuoAHWJv/J
 uVhnFyK6FOdiGooJ1nni7jdKHJxqoDTU/VE303L+awECGYQI/0VUpZvp4NDoKXrbCiYsRTTePn
 krheYycWuPbEwy2mHm3AynvwcidnseYogyVigQ/syiXXFi4iB2wMbJGu8YRkB8Xauvfa/Z44ha
 2CH/ju4dDxX6SqI8bR0GMtMlnS/hlQ4Vk3sdvMIl7aS7mQQn6uZaz57dxlhYb75YO+Rmb4dAGR
 JRg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Mar 2022 05:56:25 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KMZPN2VXYz1SVp1
        for <linux-scsi@vger.kernel.org>; Mon, 21 Mar 2022 05:56:24 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647867383; x=1650459384; bh=rK+GWJIqnJbJS1w8TqvmeBh+mp1pponUH9/
        IsWJGSTM=; b=QGQauSZKzkW1re87MwUl5vwsW8xp+yebBhpQKVe7LtCcQ9nyeuS
        4MWzkvefQ5KXU4vDJmFEU1C1FV2R4Hh7+8q+oVi/Z+ibFLBJ8xCYa4UXZar8z4Sb
        veMrkk31lo6YSihReKOZNLMQ1Xowfb+7YFzqRhxL2nFoYZfl0qIMQKjIRMFNV38W
        9GoX5fkQzx5t2TGbkGSgoznpa1yMY+fjALCoHr5gyWpFXdKo4Mu0edeAm6g6r3V5
        eUmHSZj2Vl0dE/jhVNyquG+ELVFDU7gwOVHr/ervjdtPuFQt0V4Q9X/UbO1C2lul
        dEi4ZY4zh1FKX/XeVq0unOAz+t3G6xnK0Aw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id vL1Yh7BMS1xn for <linux-scsi@vger.kernel.org>;
        Mon, 21 Mar 2022 05:56:23 -0700 (PDT)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KMZPM0LbXz1Rvlx;
        Mon, 21 Mar 2022 05:56:22 -0700 (PDT)
Message-ID: <f01cb35e-41be-d502-3274-177bac71186a@opensource.wdc.com>
Date:   Mon, 21 Mar 2022 21:56:19 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH] scsi: mpt3sas: fix use after free in
 _scsih_expander_node_remove()
Content-Language: en-US
To:     Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc:     linux-scsi <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>
References: <20220316031521.422488-1-damien.lemoal@opensource.wdc.com>
 <7164859f-fbf8-8e54-3c08-a40e31d7c231@opensource.wdc.com>
 <CAK=zhgqrxEW1chA0rzftFd2F29NmjNVQQ9EiapT8J2up0YOdkg@mail.gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <CAK=zhgqrxEW1chA0rzftFd2F29NmjNVQQ9EiapT8J2up0YOdkg@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/03/20 22:29, Sreekanth Reddy wrote:
> Damien,
> 
> Can we save the port_id to a local variable and use it while printking
> the "expander_remove" message? In older issue logs, in some cases we
> have observed that device removal at SML get's stuck. So, it will be
> easy to identify/debug whether device removal got stuck at the SML or
> not if we have a "expander_remove" print message after calling the
> mpt3sas_transport_port_remove() (i.e. after device is successfully
> unregistered at the SML).

OK. I will send a V2.

-- 
Damien Le Moal
Western Digital Research
