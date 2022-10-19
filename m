Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 12308C4332F
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Oct 2022 10:17:01 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231548AbiJSKQ7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Oct 2022 06:16:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49980 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231688AbiJSKQU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Oct 2022 06:16:20 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 938D4107CEA
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 02:57:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1666173444; x=1697709444;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=sp2+V3olAKYqj+WXfh1w+hgEwPcXhPFgM+cldgLIgKI=;
  b=j+qTNu0eYTJ5Z4kQ/LV4BiXtuNWXtEYjfgWZxGwgEudSOupw8OBS4Tjk
   hTXsOLj5FrsyLQbrDr/JH+4mve9cV3MIQe5ImSHgPoAbph1lUwRQhSquz
   1cyWCIki1smB6R0Ndth8jMCxOkiP8rj2WhdSdhypJV4v8bF+lLx3L9L93
   7+K3HPjgJthRg6ZsZ+CL/v3UQe+jc9YvVGKhcxFIpyGa1hl+jAkprwX3T
   XSQy/8quGiV9vmdf8Cp2e+/0W+v5vcNbUl43e2PtZd7yKVLDWtKV+9j36
   MPZuYNhu/gSBDUuqF9In/IKO2Lt2I8dvsTDaQbaT1DfxfVMoPfTzqULh1
   g==;
X-IronPort-AV: E=Sophos;i="5.95,195,1661788800"; 
   d="scan'208";a="214212675"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Oct 2022 17:53:23 +0800
IronPort-SDR: sZ2Pq5wMdQZW0B84Ef+VNXRNu4Se0+d/qKBl+ksVIs2TDQ1X5oVMQGBCZ2GJvOlssx0WlyNy/K
 Lp2OFQ98QjfuN7zhTFEx7m+07gqavacOjk6XhO36c7w2F1Vx6AopI3uNI5ad4kM77kbocuqY4e
 /lIAm5btGjr2OEIKmj10u7hbmyhKe0TqeDFe8hCKf3dYvcQVxoeS8O+B+XngBUOB+kk9x7hJ1P
 EcsJEYvXfIIIYRMfZj6pUHAk15hGAGbYUHzhygObUvpPjBj+BehnNzlF1fOppGDAncJpHXDMnP
 VEJCcm201t29XHZuPBa0ASc3
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 02:12:54 -0700
IronPort-SDR: 2lZBlGEeCVax+UWsdTlEMUYrqGJHR4ty59CAGlLpUUTCsSeY0Nor37cGclFD4Yaa25l+EjlBIt
 yDujKx2sUYmLnq0WJ+Ms6phuIMkp3sEnUP02CKK9O9Fiep/kDu1wQ1EuwQAaWrck40ny7uGlFm
 uIAJoI3E4xLfG8FTkapKPRpuXS5DhDDO2nc9g8hpWOXyAURKYvIFPaWv4Twdo01/E0E6E3mfxb
 23cKr6lyqrI3K9Sv3ZCq+k+7hGq3IbVcV80OOuC5iUkepmd/4kYdiMa7O3bSQxb+xj66a3bkAN
 U7w=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Oct 2022 02:53:21 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MsmJJ0d5Rz1RwtC
        for <linux-scsi@vger.kernel.org>; Wed, 19 Oct 2022 02:53:20 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1666173199; x=1668765200; bh=sp2+V3olAKYqj+WXfh1w+hgEwPcXhPFgM+c
        ldgLIgKI=; b=AVLZ3r/q8w1EjVpjbYk5kBfCR/8MYkGRTh26o7GV7o2uYu3/ZPW
        bAUWNIAAwM+OUOIPFhFkZyH7K2q1z2DDp1yA1712VUg5eNy7ELZZXwPn8S4qrpCa
        8mYEQJM+GEESyAKEEkGplopSEcqxmY+JRhVo6YX34Td/Idmvd3ClNLKNo2QmNDF1
        OQSWx8HuI0HNxfXi/9tmrjMo8UhRYxxFHxKNMzLAWSa0BGx3ZRKW3XodbzWE503H
        Lqa0gOBpHibz4DAgXFflSfb+I9q8MTPBgwLS0igqtDstjTQBEhvQu01sjEXxGps8
        i4OuAW84BHzOuQw6vj4hj7cDyhkjlaMtNiQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id aI3V9PBtpNxV for <linux-scsi@vger.kernel.org>;
        Wed, 19 Oct 2022 02:53:19 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MsmJG4GYDz1RvLy;
        Wed, 19 Oct 2022 02:53:18 -0700 (PDT)
Message-ID: <73cf04c5-3ebd-3aaa-701b-91be59ed035d@opensource.wdc.com>
Date:   Wed, 19 Oct 2022 18:53:17 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: libata and software reset
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <Niklas.Cassel@wdc.com>,
        Hannes Reinecke <hare@suse.de>
Cc:     "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Xiang Chen <chenxiang66@hisilicon.com>
References: <046e86d2-17e1-e85d-08a1-744ef975171c@huawei.com>
 <7e8ef4b4-928f-895f-05ef-df111a052e8e@opensource.wdc.com>
 <a5026aa0-2674-9b2d-1a0f-ed3847fa69cc@opensource.wdc.com>
 <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <28c7127f-f577-9a43-2f2f-80ef89d85a0e@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/19/22 18:42, John Garry wrote:
> On 19/10/2022 06:04, Damien Le Moal wrote:
>> On 10/19/22 14:03, Damien Le Moal wrote:
>>> On 10/18/22 22:24, John Garry wrote:
>>>> Hi guys,
>>>>
>>>> In the hisi_sas driver there are times in which we need to issue an ATA
>>>> software reset. For this we use hisi_sas_softreset_ata_disk() ->
>>>> sas_execute_ata_cmd() -> sas_execute_tmf(), which uses libsas "slow
>>>> task" mechanism to issue the command.
>>> Something is wrong here... The reset command sent by that function is
>>> for ATAPI (DEVICE RESET command). There is no device reset command for
>>> SATA disks following the ACS standard.
> 
> Yeah, that looks wrong.
> 
>>>
>>> So hisi_sas_softreset_ata_disk() seems totally bogus to me, unless you
>>> have a CD/DVD drive connected to the HBA:)
> 
> Sure
> 
>>>
>>> This is why the softreset function is a port operation defined by LLDs.
>>> How you reset the device depends on the adapter. E.g., for AHCI, you
>>> need to send a host2device FIS with the software reset bit set.
> 
> This would be quite a standard method, right?

The TF part should be standard. Would need to dig in SATA-IO specs to
check. How the TF/FIS should be issued/polled for is definitely
dependent on the adapter itself I think, exactly like issuing a qc is.

> 
>> See: ahci_do_softreset() for AHCI.
> 
> For ahci_do_softreset(), do you just implicitly use ATA_CMD_NOP as the
> command?

To be frank, it is the first time I really look at the reset code :)
I need to read SATA-IO specs to understand why it is doing things like that.

> 
> For hisi_sas, maybe ATA_CMD_DEV_RESET is silently ignored when issued
> for a SATA disk, but having SRST set/unset still takes effect (and that
> is how it still works). I need to check on that.

Yes, it may be that having the ATA_SRST bit set causes the device to
ignore the command field, hence you never saw any problem. Still feels
terribly wrong to use an ATAPI command for an ATA disk. ATAPI device
reset command code is 0x08 which is not defined as a command code in ACS.

> 
> Thanks,
> John

-- 
Damien Le Moal
Western Digital Research

