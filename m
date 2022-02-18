Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 43104C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Feb 2022 04:19:00 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229719AbiBRETO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 23:19:14 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229572AbiBRETN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 23:19:13 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDC1E129B98
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 20:18:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645157937; x=1676693937;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NHtkgbMh6NXQ8widMJrekjBEmQlk/5ZVl1GQklUkRAU=;
  b=MAh54K71VZ/XY5E1iDOy0B50l3wNDJ3jdIIooxkUukGCSEeigbfS28t1
   uWIvCvdHhLr9x2KbGTx1bZM5/sSSkRaFAqevh8r0oOv8WCpq2GVhSmtMW
   5hJniPCKOcgMZtOXOBafhN9rfadn6lT9xKr+1gTGS7uSgaXr+MHVJAstP
   OoXlVPxWlpJIoAMe0A4Qf1jQtvOTBNnpt464b5t+tKSKU4AWjI1d3qZOZ
   wkbavdCblkvJFH8zZd2U4qWbW/vNIxdN9xUA+IkIpdp4r6IjCX5fhy5+1
   u10LsUXkzaV2vyD7sCYltwFwwUW6jE3WPEGAMXlSwfZ8Rm4Rb4DnifS1+
   w==;
X-IronPort-AV: E=Sophos;i="5.88,377,1635177600"; 
   d="scan'208";a="194229784"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Feb 2022 12:18:57 +0800
IronPort-SDR: 0J55EuspXwe00zAmVw8fAvgIrS3YAzyGzGvxtHSAX5+p/2hfZ71QcY/mqdVpEzEGd5wfFvtuQm
 /zLzAwRDIEx0hc0HyjUnfnd3XVfnYV1GuQl2aln/JpbMi6Bpiu27Hpy+enqvLv3Ao7v+SNX23W
 6LetnLyuWk4l8J0K1MiX7xycs5CydPFwxznvmy3PoKmw2qad1ZlZc0WEJahmay76z+ZrDY9cF/
 fv+6EONYUBY80LlbJILHmcOjsPD6S8ULRbMZH+2Q5vCo0xQGhdwD/6RGHO7bgvmJ/96gduNfjW
 OX/Qnt+MGYBdggWtBpyiL/7l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 19:50:33 -0800
IronPort-SDR: 6wywAZvUzRV3gZy+ODZGogYgWObYPFbLorZBbTGoJYtVQw/j6oe2pp8TBHnnxp3qTL7Qp7VkP1
 rDVVzdBq1Bq91BSSuM9Sje4Ngzx9Nk0MVQMtXL84MsJkRqc1/iNhgxBn9awKDoeYXPCS9xmFkw
 UrOoirOB8Y60V8+WaBwO4ZS7yRriXijHHYoCBFfvMG/p04W4RbL9w/8AIhmiEVabIEeKGi7nci
 ydoObZ3Qf1ydFCyDXuVhAANcfcQZbotDS1MP1tLL4B0zgxEy0fP7pV/fc9cU5juXpgeS98kVuz
 Di8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Feb 2022 20:18:55 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K0JNb0JdVz1SVp0
        for <linux-scsi@vger.kernel.org>; Thu, 17 Feb 2022 20:18:54 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645157933; x=1647749934; bh=NHtkgbMh6NXQ8widMJrekjBEmQlk/5ZVl1G
        QklUkRAU=; b=qtG86AepzypzOHFq4PqMoqkS5YbSGB0RYRLaBHmsDX4yZb1aEKb
        LPHHgRKPVeUUjaD68MKGugmNlK9gReNg/E13JKTrZCDem5620LTPWX25tyVyKeCP
        eFy9vSGehdJ+q55/4kuxKLxn1SK+o7QDOe1LLB1MmQfCCOiH9iVG4gwkBgp4chDK
        2nzP9h3byeo1Umji/RC/mCYm2Wrl+nJkp3vuWueeyhnCXNBMOzn63KPFuCzVjicZ
        4rDK9hyjxDjmRqM5fn43KapPvAe4B/I6RTcQj+4/n7JxuChpsKOmqVssD3I5I9Z8
        20tClbD2Zh+uTMsG5Tasn4vzlOT+VqjY4Cw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 89q5IHYmruDQ for <linux-scsi@vger.kernel.org>;
        Thu, 17 Feb 2022 20:18:53 -0800 (PST)
Received: from [10.225.163.78] (unknown [10.225.163.78])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K0JNV75Syz1Rwrw;
        Thu, 17 Feb 2022 20:18:50 -0800 (PST)
Message-ID: <5ecf520e-588c-d756-1cb8-2224535b550e@opensource.wdc.com>
Date:   Fri, 18 Feb 2022 13:18:49 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 00/18] scsi: libsas and users: Factor out LLDD TMF code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, artur.paszkiewicz@intel.com,
        jinpu.wang@cloud.ionos.com, chenxiang66@hisilicon.com, hch@lst.de
Cc:     Ajish.Koshy@microchip.com, yanaijie@huawei.com,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, linuxarm@huawei.com,
        liuqi115@huawei.com, Viswas.G@microchip.com
References: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1645112566-115804-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/18/22 00:42, John Garry wrote:
> The LLDD TMF code is almost identical between hisi_sas, pm8001, and mvsas
> drivers.
> 
> This series factors out that code into libsas, thus reducing much
> duplication and giving a net reduction of ~350 LoC.
> 
> There are some subtle differences between the core TMF handler and each
> of the LLDDs old implementation, so any review and testing is appreciated.
> 
> Some other minor patches are thrown in:
> - Delete unused macro in hisi_sas driver
> - Delete unused libsas callback
> - Delete unused SAS_SG_ERR
> - Add enum for response frame datapres field
> - Handle unrecognised errors in sas_scsi_find_task()
> 
> I have another follow-up series to factor out the internal abort code,
> which is common to hisi_sas and pm8001 drivers.
> 
> Based on mkp-scsi 5.18 staging queue at commit ac2beb4e3bd7

I tested this series with my pm8001 v5 series on top. Everything looks
good, no problems detected with both SAS and SATA drives tests. So feel
free to add:

Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Martin,

This series and my pm8001 series have a conflict. When applying the
pm8001 patches on top of these libsas changes, patch 28 has a fairly
easy to resolve conflict. Let me know if you want me to send a v6
rebased on top of this.

Thanks !


-- 
Damien Le Moal
Western Digital Research
