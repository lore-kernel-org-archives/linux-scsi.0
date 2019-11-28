Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9FD10C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 12:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7435D21789
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 12:09:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726281AbfK1MJk (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 07:09:40 -0500
Received: from mx2.suse.de ([195.135.220.15]:51884 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726191AbfK1MJk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 28 Nov 2019 07:09:40 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id 13DD1B14D;
        Thu, 28 Nov 2019 12:09:37 +0000 (UTC)
Subject: Re: [PATCH 08/11] aacraid: use scsi_host_quiesce() to wait for I/O to
 complete
To:     Balsundar.P@microchip.com, martin.petersen@oracle.com
Cc:     hch@lst.de, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, balsundar.p@microsemi.com,
        aacraid@microsemi.com
References: <20191120103114.24723-1-hare@suse.de>
 <20191120103114.24723-9-hare@suse.de>
 <MN2PR11MB38219640907865F47666CB83F3470@MN2PR11MB3821.namprd11.prod.outlook.com>
From:   Hannes Reinecke <hare@suse.de>
Openpgp: preference=signencrypt
Autocrypt: addr=hare@suse.de; prefer-encrypt=mutual; keydata=
 mQINBE6KyREBEACwRN6XKClPtxPiABx5GW+Yr1snfhjzExxkTYaINHsWHlsLg13kiemsS6o7
 qrc+XP8FmhcnCOts9e2jxZxtmpB652lxRB9jZE40mcSLvYLM7S6aH0WXKn8bOqpqOGJiY2bc
 6qz6rJuqkOx3YNuUgiAxjuoYauEl8dg4bzex3KGkGRuxzRlC8APjHlwmsr+ETxOLBfUoRNuE
 b4nUtaseMPkNDwM4L9+n9cxpGbdwX0XwKFhlQMbG3rWA3YqQYWj1erKIPpgpfM64hwsdk9zZ
 QO1krgfULH4poPQFpl2+yVeEMXtsSou915jn/51rBelXeLq+cjuK5+B/JZUXPnNDoxOG3j3V
 VSZxkxLJ8RO1YamqZZbVP6jhDQ/bLcAI3EfjVbxhw9KWrh8MxTcmyJPn3QMMEp3wpVX9nSOQ
 tzG72Up/Py67VQe0x8fqmu7R4MmddSbyqgHrab/Nu+ak6g2RRn3QHXAQ7PQUq55BDtj85hd9
 W2iBiROhkZ/R+Q14cJkWhzaThN1sZ1zsfBNW0Im8OVn/J8bQUaS0a/NhpXJWv6J1ttkX3S0c
 QUratRfX4D1viAwNgoS0Joq7xIQD+CfJTax7pPn9rT////hSqJYUoMXkEz5IcO+hptCH1HF3
 qz77aA5njEBQrDRlslUBkCZ5P+QvZgJDy0C3xRGdg6ZVXEXJOQARAQABtCpIYW5uZXMgUmVp
 bmVja2UgKFN1U0UgTGFicykgPGhhcmVAc3VzZS5kZT6JAkEEEwECACsCGwMFCRLMAwAGCwkI
 BwMCBhUIAgkKCwQWAgMBAh4BAheABQJOisquAhkBAAoJEGz4yi9OyKjPOHoQAJLeLvr6JNHx
 GPcHXaJLHQiinz2QP0/wtsT8+hE26dLzxb7hgxLafj9XlAXOG3FhGd+ySlQ5wSbbjdxNjgsq
 FIjqQ88/Lk1NfnqG5aUTPmhEF+PzkPogEV7Pm5Q17ap22VK623MPaltEba+ly6/pGOODbKBH
 ak3gqa7Gro5YCQzNU0QVtMpWyeGF7xQK76DY/atvAtuVPBJHER+RPIF7iv5J3/GFIfdrM+wS
 BubFVDOibgM7UBnpa7aohZ9RgPkzJpzECsbmbttxYaiv8+EOwark4VjvOne8dRaj50qeyJH6
 HLpBXZDJH5ZcYJPMgunghSqghgfuUsd5fHmjFr3hDb5EoqAfgiRMSDom7wLZ9TGtT6viDldv
 hfWaIOD5UhpNYxfNgH6Y102gtMmN4o2P6g3UbZK1diH13s9DA5vI2mO2krGz2c5BOBmcctE5
 iS+JWiCizOqia5Op+B/tUNye/YIXSC4oMR++Fgt30OEafB8twxydMAE3HmY+foawCpGq06yM
 vAguLzvm7f6wAPesDAO9vxRNC5y7JeN4Kytl561ciTICmBR80Pdgs/Obj2DwM6dvHquQbQrU
 Op4XtD3eGUW4qgD99DrMXqCcSXX/uay9kOG+fQBfK39jkPKZEuEV2QdpE4Pry36SUGfohSNq
 xXW+bMc6P+irTT39VWFUJMcSuQINBE6KyREBEACvEJggkGC42huFAqJcOcLqnjK83t4TVwEn
 JRisbY/VdeZIHTGtcGLqsALDzk+bEAcZapguzfp7cySzvuR6Hyq7hKEjEHAZmI/3IDc9nbdh
 EgdCiFatah0XZ/p4vp7KAelYqbv8YF/ORLylAdLh9rzLR6yHFqVaR4WL4pl4kEWwFhNSHLxe
 55G56/dxBuoj4RrFoX3ynerXfbp4dH2KArPc0NfoamqebuGNfEQmDbtnCGE5zKcR0zvmXsRp
 qU7+caufueZyLwjTU+y5p34U4PlOO2Q7/bdaPEdXfpgvSpWk1o3H36LvkPV/PGGDCLzaNn04
 BdiiiPEHwoIjCXOAcR+4+eqM4TSwVpTn6SNgbHLjAhCwCDyggK+3qEGJph+WNtNU7uFfscSP
 k4jqlxc8P+hn9IqaMWaeX9nBEaiKffR7OKjMdtFFnBRSXiW/kOKuuRdeDjL5gWJjY+IpdafP
 KhjvUFtfSwGdrDUh3SvB5knSixE3qbxbhbNxmqDVzyzMwunFANujyyVizS31DnWC6tKzANkC
 k15CyeFC6sFFu+WpRxvC6fzQTLI5CRGAB6FAxz8Hu5rpNNZHsbYs9Vfr/BJuSUfRI/12eOCL
 IvxRPpmMOlcI4WDW3EDkzqNAXn5Onx/b0rFGFpM4GmSPriEJdBb4M4pSD6fN6Y/Jrng/Bdwk
 SQARAQABiQIlBBgBAgAPBQJOiskRAhsMBQkSzAMAAAoJEGz4yi9OyKjPgEwQAIP/gy/Xqc1q
 OpzfFScswk3CEoZWSqHxn/fZasa4IzkwhTUmukuIvRew+BzwvrTxhHcz9qQ8hX7iDPTZBcUt
 ovWPxz+3XfbGqE+q0JunlIsP4N+K/I10nyoGdoFpMFMfDnAiMUiUatHRf9Wsif/nT6oRiPNJ
 T0EbbeSyIYe+ZOMFfZBVGPqBCbe8YMI+JiZeez8L9JtegxQ6O3EMQ//1eoPJ5mv5lWXLFQfx
 f4rAcKseM8DE6xs1+1AIsSIG6H+EE3tVm+GdCkBaVAZo2VMVapx9k8RMSlW7vlGEQsHtI0FT
 c1XNOCGjaP4ITYUiOpfkh+N0nUZVRTxWnJqVPGZ2Nt7xCk7eoJWTSMWmodFlsKSgfblXVfdM
 9qoNScM3u0b9iYYuw/ijZ7VtYXFuQdh0XMM/V6zFrLnnhNmg0pnK6hO1LUgZlrxHwLZk5X8F
 uD/0MCbPmsYUMHPuJd5dSLUFTlejVXIbKTSAMd0tDSP5Ms8Ds84z5eHreiy1ijatqRFWFJRp
 ZtWlhGRERnDH17PUXDglsOA08HCls0PHx8itYsjYCAyETlxlLApXWdVl9YVwbQpQ+i693t/Y
 PGu8jotn0++P19d3JwXW8t6TVvBIQ1dRZHx1IxGLMn+CkDJMOmHAUMWTAXX2rf5tUjas8/v2
 azzYF4VRJsdl+d0MCaSy8mUh
Message-ID: <4ec87e61-2e2f-a3b5-00f6-1e6abf9cb261@suse.de>
Date:   Thu, 28 Nov 2019 13:09:36 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <MN2PR11MB38219640907865F47666CB83F3470@MN2PR11MB3821.namprd11.prod.outlook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/28/19 12:45 PM, Balsundar.P@microchip.com wrote:
> NAK
> 
> After applying this patch, while IOs were running on physical drive, 
> issued controller reset from management utility.
> Observed below call trace. It is from scsi_device_quiesce().
> 
> Nov 27 19:24:21 ubuntu kernel: [ 1330.799311] INFO: task arcconf:2386 blocked for more than 120 seconds.
> Nov 27 19:24:21 ubuntu kernel: [ 1330.799841]       Not tainted 5.4.0-rc1+ #2
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800235] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800678] arcconf         D    0  2386   2173 0x00004000
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800682] Call Trace:
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800699]  __schedule+0x291/0x6f0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800703]  schedule+0x33/0xa0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800710]  blk_mq_freeze_queue_wait+0x4b/0xb0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800717]  ? wait_woken+0x80/0x80
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800721]  blk_mq_freeze_queue+0x1a/0x20
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800727]  scsi_device_quiesce+0x5d/0xb0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800730]  scsi_host_quiesce+0x41/0x60
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800742]  aac_send_shutdown+0x7c/0x180 [aacraid]
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800749]  aac_reset_adapter+0x29f/0x760 [aacraid]
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800757]  ? security_capable+0x3f/0x60
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800762]  aac_store_reset_adapter+0x41/0x60 [aacraid]
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800770]  dev_attr_store+0x17/0x30
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800777]  sysfs_kf_write+0x3c/0x50
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800779]  kernfs_fop_write+0x125/0x1a0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800785]  __vfs_write+0x1b/0x40
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800789]  vfs_write+0xb1/0x1a0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800792]  ksys_write+0xa7/0xe0
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800795]  __x64_sys_write+0x1a/0x20
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800802]  do_syscall_64+0x57/0x190
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800806]  entry_SYSCALL_64_after_hwframe+0x44/0xa9
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800810] RIP: 0033:0x7f67cfb7c2b7
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800819] Code: Bad RIP value.
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800821] RSP: 002b:00007ffeb23ca8c0 EFLAGS: 00000293 ORIG_RAX: 0000000000000001
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800823] RAX: ffffffffffffffda RBX: 0000000000000006 RCX: 00007f67cfb7c2b7
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800825] RDX: 0000000000000002 RSI: 00007ffeb23ca8f0 RDI: 0000000000000006
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800826] RBP: 00007ffeb23ca8f0 R08: 0000000000000000 R09: 0000000000000000
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800828] R10: 0000000000000000 R11: 0000000000000293 R12: 0000000000000002
> Nov 27 19:24:21 ubuntu kernel: [ 1330.800829] R13: 00007ffeb23cad20 R14: 00007ffeb23cadf0 R15: 00007ffeb23cac60
> 
Thanks for testing.
I'll have a look at the call trace and will come back to you with an
updated version.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      Teamlead Storage & Networking
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
