Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82DF9C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Mar 2022 05:51:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232607AbiCRFw6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Mar 2022 01:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229912AbiCRFw4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Mar 2022 01:52:56 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3260928AC6C
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 22:51:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1647582698; x=1679118698;
  h=message-id:date:mime-version:subject:from:to:references:
   in-reply-to:content-transfer-encoding;
  bh=Im4gQWnsSw82rMSGabJHPg75PRMtK9ww1u3nhTuBrJQ=;
  b=eev68+3o7PCLNk4erViPcEugy1qE71Ip6V6mtyNUgKZuB3aK28k1b0EK
   fQzRFjj+GqlM8q6tph1wwnmTIfSIHlM39s/r1Bf9zp3VwPE89nrK3Khic
   qhIyAavyyL1pgb9bDeKw2a5HDgsUWG9gi17+/pXmVp+YceD/wGYL7okNr
   KYkFoMNS2Gwy9ixF/auo6VXb2TF9h2PpxKiyqMriSIIBdP/uedF0MoxAn
   LGucvU/LvOUqzhJOxe4Kq9sEYVPwDkN7HaLeYIEKvpHZiznaX1No2+Nh6
   C519uT6ycFS1AgWQDOqi/aRx62/2aOQvfVA7QaCJCU3kVmYsi8GvKJmft
   w==;
X-IronPort-AV: E=Sophos;i="5.90,191,1643644800"; 
   d="scan'208";a="194588700"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 18 Mar 2022 13:51:37 +0800
IronPort-SDR: kcHxqQP8He7AGSYmltTeX5yk31pJwsHjtWeMUB/ES5qdp4mujPpoFjjJlkrfxiVsSPf4phGcTQ
 A32M31akabHmYbVAgy2wd/2N/WBVvJdfz+JGNTlYcZT9BGxQTw3hNdzATSbHK13S81q/YKXpnF
 UkbE7wTh0emZ6s6mkMSr8yv5qqcElLq4QvW2NwurTZ+hlY7pWhoAhGm3QUqZZmE6ZIM0FIGq++
 2I4Uekk7O/MYpzaDbur2B5okoL6BB4wEjTiosrGLo1WVV4nLRkQxUqiA9SefGpboaN9d11NDl6
 OURKC8ZeG60PqyZU/jxpcR95
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 22:23:39 -0700
IronPort-SDR: JMU/cuDgEBHzwtfwwdSkgZtNaOt54o3UvCIgYsp5Lqppz7sjgGc+8DWzvoLBuV2kxtctLze6HU
 V+uc/X7kWVav1jpTFFdmB2gKSznmFKY/uGr1ii+3i2t4sFGUgJI3yX1qvMWXES7lH/Qkh8jhiu
 SgxUPsp2jusp0rKS1Af62zuMfttnpufEnZQcLGSayakD902n+FA8Zo178cZIdWdSLOTZD4g3Y1
 /R0XxiNP1wsXR1UXQJ14HMqDt73RVN7mYtLwjXOuZAGRpiE2yBmt4besg9klEfrr0fv0nxFhsC
 b4A=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 17 Mar 2022 22:51:38 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KKY6d2hZhz1Rwrw
        for <linux-scsi@vger.kernel.org>; Thu, 17 Mar 2022 22:51:37 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:references:to:from:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1647582696; x=1650174697; bh=Im4gQWnsSw82rMSGabJHPg75PRMtK9ww1u3
        nhTuBrJQ=; b=FVEYyjj1Sd7va4p0geU4hfeZ7T1aBYs7nLusk0bqfiPP8SeHflc
        0SyZTSzFuTptDdqq73zfaRRN3DC6E8KsmLyf1dVjdhLnYV0bOd496xLfufU90WlD
        s0lLiZpL2iWiHczzKCmT3l64a6L/sYAPBY/70m5s8zdBgT6cIl+uBpmu+SWPJ5lj
        5pPDE2Qxae26qrLuUGwWkWa3xEj6LvRHkDPW9o1PsP49FymPn2QdcLfFhvOMkez1
        oOcgRyXDF23UTf2zG8KtaTr3Js4t4PiKbH7T4Nd6COSVXQJ0Md7dlnvRXs6W2+76
        8tSD+sPEqny5BDPI1sZapV9zJzzGmP5Ps1A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id b7iTsf8vUJAT for <linux-scsi@vger.kernel.org>;
        Thu, 17 Mar 2022 22:51:36 -0700 (PDT)
Received: from [10.225.163.107] (unknown [10.225.163.107])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KKY6b6sJ9z1Rvlx;
        Thu, 17 Mar 2022 22:51:35 -0700 (PDT)
Message-ID: <7164859f-fbf8-8e54-3c08-a40e31d7c231@opensource.wdc.com>
Date:   Fri, 18 Mar 2022 14:51:34 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH] scsi: mpt3sas: fix use after free in
 _scsih_expander_node_remove()
Content-Language: en-US
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
To:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Sathya Prakash <sathya.prakash@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        Suganath Prabu Subramani 
        <suganath-prabu.subramani@broadcom.com>,
        MPT-FusionLinux.pdl@broadcom.com
References: <20220316031521.422488-1-damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220316031521.422488-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/16/22 12:15, Damien Le Moal wrote:
> The function mpt3sas_transport_port_remove() called in
> _scsih_expander_node_remove() frees the port field of the sas_expander
> structure, leading to the following use-after-free spat from Kasan when
> the ioc_info() call following that function is executed (e.g. when doing
> rmmod of the driver module):
> 
> [ 3479.371167] ==================================================================
> [ 3479.378496] BUG: KASAN: use-after-free in _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.386936] Read of size 1 at addr ffff8881c037691c by task rmmod/1531
> [ 3479.393524]
> [ 3479.395035] CPU: 18 PID: 1531 Comm: rmmod Not tainted 5.17.0-rc8+ #1436
> [ 3479.401712] Hardware name: Supermicro Super Server/H12SSL-NT, BIOS 2.1 06/02/2021
> [ 3479.409263] Call Trace:
> [ 3479.411743]  <TASK>
> [ 3479.413875]  dump_stack_lvl+0x45/0x59
> [ 3479.417582]  print_address_description.constprop.0+0x1f/0x120
> [ 3479.423389]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.429469]  kasan_report.cold+0x83/0xdf
> [ 3479.433438]  ? _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.439514]  _scsih_expander_node_remove+0x710/0x750 [mpt3sas]
> [ 3479.445411]  ? _raw_spin_unlock_irqrestore+0x2d/0x40
> [ 3479.452032]  scsih_remove+0x525/0xc90 [mpt3sas]
> [ 3479.458212]  ? mpt3sas_expander_remove+0x1d0/0x1d0 [mpt3sas]
> [ 3479.465529]  ? down_write+0xde/0x150
> [ 3479.470746]  ? up_write+0x14d/0x460
> [ 3479.475840]  ? kernfs_find_ns+0x137/0x310
> [ 3479.481438]  pci_device_remove+0x65/0x110
> [ 3479.487013]  __device_release_driver+0x316/0x680
> [ 3479.493180]  driver_detach+0x1ec/0x2d0
> [ 3479.498499]  bus_remove_driver+0xe7/0x2d0
> [ 3479.504081]  pci_unregister_driver+0x26/0x250
> [ 3479.510033]  _mpt3sas_exit+0x2b/0x6cf [mpt3sas]
> [ 3479.516144]  __x64_sys_delete_module+0x2fd/0x510
> [ 3479.522315]  ? free_module+0xaa0/0xaa0
> [ 3479.527593]  ? __cond_resched+0x1c/0x90
> [ 3479.532951]  ? lockdep_hardirqs_on_prepare+0x273/0x3e0
> [ 3479.539607]  ? syscall_enter_from_user_mode+0x21/0x70
> [ 3479.546161]  ? trace_hardirqs_on+0x1c/0x110
> [ 3479.551828]  do_syscall_64+0x35/0x80
> [ 3479.556884]  entry_SYSCALL_64_after_hwframe+0x44/0xae
> [ 3479.563402] RIP: 0033:0x7f1fc482483b
> ...
> [ 3479.943087] ==================================================================
> 
> Fix this by reversing the calls to ioc_info() and
> mpt3sas_transport_port_remove().
> 
> Fixes: 7d310f241001 ("scsi: mpt3sas: Get device objects using sas_address & portID")
> Cc: stable@vger.kernel.org
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>> ---
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> index 00792767c620..a3a898262f2d 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -11055,15 +11055,15 @@ _scsih_expander_node_remove(struct MPT3SAS_ADAPTER *ioc,
>  			    mpt3sas_port->hba_port);
>  	}
>  
> -	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
> -	    sas_expander->sas_address_parent, sas_expander->port);
> -
>  	ioc_info(ioc,
>  	    "expander_remove: handle(0x%04x), sas_addr(0x%016llx), port:%d\n",
>  	    sas_expander->handle, (unsigned long long)
>  	    sas_expander->sas_address,
>  	    sas_expander->port->port_id);
>  
> +	mpt3sas_transport_port_remove(ioc, sas_expander->sas_address,
> +	    sas_expander->sas_address_parent, sas_expander->port);
> +
>  	spin_lock_irqsave(&ioc->sas_node_lock, flags);
>  	list_del(&sas_expander->list);
>  	spin_unlock_irqrestore(&ioc->sas_node_lock, flags);


Broadcom team,

Please review !


-- 
Damien Le Moal
Western Digital Research
