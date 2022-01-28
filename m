Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99994C433F5
	for <linux-scsi@archiver.kernel.org>; Fri, 28 Jan 2022 06:37:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346539AbiA1GhU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 28 Jan 2022 01:37:20 -0500
Received: from esa5.hgst.iphmx.com ([216.71.153.144]:56702 "EHLO
        esa5.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242672AbiA1GhT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 28 Jan 2022 01:37:19 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1643351839; x=1674887839;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=f0aF2YEl6Gt/wfhd0sYDp8dpaOwGv98M9EizSp2BmQQ=;
  b=YA+ZG7jr2Oyw4Dq89ooxf1HWAGss85JuH9LQfUdLc4W2MKOUH4yGiLpe
   /d0siUBosyx1S1nRuRNGbc3JW7JfTnvbIg82eugs2zQ6d2GGTHw7PdgZk
   SsO4h3BCyvvQfsc0Vh7XlYFOmrTDIGLq2/MjdO2J/dw19tSqmnvVkvnvv
   gLUjsunlHzD/tJJaNHqGJc/0GRn42Cg16iZBoNoVJ4jNTn8MpoVyU6C3r
   H6oolQruaHayLRdOsriL8wkL6+MHfpOKMeAgy2JmERh3GoXo7kXgwi6Ky
   n57Fnt0cZ3S+Ewy6i7mBuP2VZ3c/PSW1oiKYCkyrMexHGmSIzDtvng92K
   w==;
X-IronPort-AV: E=Sophos;i="5.88,322,1635177600"; 
   d="scan'208";a="191604889"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 28 Jan 2022 14:37:18 +0800
IronPort-SDR: 5Eqh96Woc3SSsvmlItcj0BgruDgaTcL4YR50alnugwiManaVjv4O/0DJd/nww0Qg7LV2nQ1Siz
 GDC3+ugz8jCMBnKKumK1v6kqBHMLVeLr29JW/kfe+Q01V/Z9STN6+3e5NUeCdymTAg3OKQgWTw
 cPgF46xy9XwE/ssoH7qdvo0LMXNYuB3B8Eb0ujzYEQT6E+yR3UzPrdnFcCzgSPfcySxXiNgIRu
 EU/GKHeuQ1Xxsztvuo7IuTIEumOmCcKLl3hOHaw8FYIlvW6UE9Qi7Ih2CFOrklYVyZZ+I+ryMc
 RL05mYb0Xic7au/a4K4FQUOL
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 22:09:22 -0800
IronPort-SDR: IRmeTy8QbAKaMN4n6SBLyxTFB+49ka4nhZ8UkzJEAkv/kYjxlKnOuTpPfk+GjPVPVmXPHSmFnE
 JgNnH4z6nO33jzp7jT7o6JqMT7mnmA5Xqvn3eLAO2vBmCyDQ55/SMN2499PsGUTjr634sZ3/su
 r5GjZC2Wm8cM0uAdW/nHEzKhxapHy4ZGVM2Zk9HwRBzAyV2v4WKbeHcaFCD0yDFhREoOsi/Pzb
 BJwLh7+KXRAWdtHTZbJqsZVDpPZ+1t8R5aqgaVAVtTTzu3bm7gtZFiN4s9waYQQ/yESTjT+FRZ
 uxo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2022 22:37:18 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4JlSRy2BCrz1SVp7
        for <linux-scsi@vger.kernel.org>; Thu, 27 Jan 2022 22:37:18 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1643351837; x=1645943838; bh=f0aF2YEl6Gt/wfhd0sYDp8dpaOwGv98M9Ei
        zSp2BmQQ=; b=FjZ2I7I61NOTuUecbaVMmXwCsR8py2i63yykWYrI5w9nyIVBGsl
        6m7qTtNRdugbdugUznZoHrcUnwNmPS2eckV9fxWd6lU3lAt8Fb8Im+jUGwe1MeRG
        zC6oyCiOJNaYWmjr/o11a29NHcBHhhX/sxRBxpm20dSQxRgid0Z3DBWdwOHcrfS8
        4itCjLkdAT9GSprG6YL3Ny0X2MMz1ptIXtKJ82vWCJBOeiaQ6s+DybDoyFZRLoo3
        PZ8JOVDmd1N+bUqhsjDEMQu6blJwVDXYwold7hdSERbczNyJDCInz0HTJRMTArhC
        Aeb33kDT4RQka15Ix7UnoEkITViWFA894qA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id FDCu247UHe4l for <linux-scsi@vger.kernel.org>;
        Thu, 27 Jan 2022 22:37:17 -0800 (PST)
Received: from [10.225.163.58] (unknown [10.225.163.58])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4JlSRt5W1bz1RvlN;
        Thu, 27 Jan 2022 22:37:14 -0800 (PST)
Message-ID: <a8fae323-1877-058a-b03e-d175a725213f@opensource.wdc.com>
Date:   Fri, 28 Jan 2022 15:37:13 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH 00/16] scsi: libsas and users: Factor out LLDD TMF code
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, artur.paszkiewicz@intel.com,
        jinpu.wang@cloud.ionos.com, chenxiang66@hisilicon.com,
        Ajish.Koshy@microchip.com
Cc:     yanaijie@huawei.com, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        linuxarm@huawei.com, liuqi115@huawei.com, Viswas.G@microchip.com
References: <1643110372-85470-1-git-send-email-john.garry@huawei.com>
 <1893d9ef-042b-af3b-74ea-dd4d0210c493@opensource.wdc.com>
 <14df160f-c0f2-cc9f-56d4-8eda67969e0b@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <14df160f-c0f2-cc9f-56d4-8eda67969e0b@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/27/22 19:17, John Garry wrote:
> On 27/01/2022 06:37, Damien Le Moal wrote:
> 
> Hi Damien,
> 
>> I did some light testing of this series (boot + some fio runs) and
>> everything looks good using my "ATTO Technology, Inc. ExpressSAS 12Gb/s
>> SAS/SATA HBA (rev 06)" HBA (x86_64 host).
> 
> Yeah, unfortunately these steps prob won't exercise much of the code 
> changes here since I figure error handling would not kick in.
> 
> However using this same adapter type on my arm64 system has error 
> handling kick in almost straight away - and the handling looks sane. A 
> silver lining, I suppose ..

I ran some more tests. In particular, I ran libzbc compliance tests on a
20TB SMR drives. All tests pass with 5.17-rc1, but after applying your
series, I see command timeout that take forever to recover from, with
the drive revalidation failing after that.

[  385.102073] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[  385.108026] sas: sas_scsi_find_task: aborting task 0x000000007068ed73
[  405.561099] pm80xx0:: pm8001_exec_internal_task_abort  757:TMF task
timeout.
[  405.568236] sas: sas_scsi_find_task: task 0x000000007068ed73 is aborted
[  405.574930] sas: sas_eh_handle_sas_errors: task 0x000000007068ed73 is
aborted
[  411.192602] ata21.00: qc timeout (cmd 0xec)
[  431.672122] pm80xx0:: pm8001_exec_internal_task_abort  757:TMF task
timeout.
[  431.679282] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  431.685544] ata21.00: revalidation failed (errno=-5)
[  441.911948] ata21.00: qc timeout (cmd 0xec)
[  462.391545] pm80xx0:: pm8001_exec_internal_task_abort  757:TMF task
timeout.
[  462.398696] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x4)
[  462.404992] ata21.00: revalidation failed (errno=-5)
[  492.598769] ata21.00: qc timeout (cmd 0xec)
...

So there is a problem. Need to dig into this. I see this issue only with
libzbc passthrough tests. fio runs with libaio are fine.

>> And sparse/make C=1 complains about:
>>
>> drivers/scsi/libsas/sas_port.c:77:13: warning: context imbalance in
>> 'sas_form_port' - different lock contexts for basic block
> 
> I think it's talking about the port->phy_list_lock usage - it prob 
> doesn't like segments where we fall out a loop with the lock held (which 
> was grabbed in the loop). Anyway it looks ok. Maybe we can improve this.
> 
>>
>> But I have not checked if it is something that your series touch.
>>
>> And there is a ton of complaints about __le32 use in the pm80xx code...
>> I can try to have a look at these if you want, on top of your series.
> 
> I really need to get make C=1 working for me - it segfaults in any env I 
> have :(

I now have a 12 patch series that fixes *all* the sparse warnings. Some
of the fixes were trivial, but most of them are simply hard bugs with
the handling of le32 struct field values. There is no way that this
driver is working as-is on big-endian machines. Some calculations are
actually done using cpu_to_le32() values !

But even though these fixes should have essentially no effect on
little-endian x86_64, with my series applied, I see the same command
timeout problem as with your libsas update, and both series together
result in the same timeout issue too.

So it looks like "fixing" the code actually is revealing some other bug
that was previously hidden... This will take some time to debug.

Another problem I noticed: doing "rmmod pm80xx; modprobe pm80xx" result
in a failure of device scans. I get loops of "link is slow to respond
->reset". For the above tests, I had to reboot every time I changed the
driver module code. Another thing to look at.

Will try to spend some more time on this next week.

Cheers.


> 
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
