From: Konstantin Krotov <kkv@clodo.ru>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Tue, 11 Aug 2015 16:40:50 +0300
Message-ID: <55C9FB62.1030004@clodo.ru>
References: <55C8C0DC.7070505@clodo.ru> <55C8C39B.1010000@sandisk.com>
Reply-To: kkv@clodo.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f169.google.com ([209.85.217.169]:33992 "EHLO
	mail-lb0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934370AbbHKNk7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Aug 2015 09:40:59 -0400
Received: by lbbtg9 with SMTP id tg9so6451162lbb.1
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 06:40:55 -0700 (PDT)
In-Reply-To: <55C8C39B.1010000@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, linux-scsi@vger.kernel.org



10.08.2015 18:30, Bart Van Assche =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 08/10/2015 08:18 AM, Konstantin Krotov wrote:
>> I was faced with the following problem:
>>
>> Im exported to compute-node scsi disks through ib_srp from storages.=
 And
>> if reconnect occurs for any reason, eg
>>
>> "[1201117.626498] scsi host62: ib_srp: REJ received
>> [1201117.626507] scsi host62: ib_srp: SRP LOGIN from
>> fe80:0000:0000:0000:0002:c903:0009:1796 to
>> fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
>> [1201117.626656] scsi host62: ib_srp: Connection 0/8 failed"
>>
>> i find threads in output ps:
>> "root     28047  0.0  0.0      0     0 ?        S    18:04   0:00
>> [scsi_eh_62]
>> root     28048  0.0  0.0      0     0 ?        S<   18:04   0:00
>> [scsi_tmf_62]"
>>
>> Each reconnect generates two thread, which do not die.
>>
>> kernel version 3.19.1
>>
>> modinfo ib_srp
>> filename:       /lib/modules/3.19-3-amd64/updates/dkms/ib_srp.ko
>> release_date:   Apr 09 2015
>> version:        2.0.32#in-tree
>
> Hello Konstantin,
>
> Does the above output mean that you are using the ib_srp-backport dri=
ver
> ? If so, please upgrade to version v2.0.34. That version includes all
> SRP initiator fixes that have been posted on the linux-rdma and
> linux-scsi mailing lists for inclusion in Linux kernel v4.3.
>
> Bart.
>
Hello, thanks for reply.

I build a package version 2.0.34, but problem is reproduced:
[  260.266374] scsi host15: ib_srp: REJ received
[  260.266383] scsi host15: ib_srp: SRP LOGIN from=20
fe80:0000:0000:0000:0002:c903:0008:c884 to=20
fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
[  260.266588] scsi host15: ib_srp: Connection 0/8 failed
[  260.266700] scsi host15: ib_srp: Sending CM DREQ failed

and increases the number of threads scsi_tmf_ and scsi_eh_ at every=20
reconnect..

modinfo ib_srp
filename:       /lib/modules/3.19-3-amd64/updates/dkms/ib_srp.ko
release_date:   Jul 27 2015
version:        2.0.34#in-tree
license:        Dual BSD/GPL
description:    InfiniBand SCSI RDMA Protocol initiator
author:         Roland Dreier
srcversion:     75206A3E8C5F05BED61C20B
depends:=20
ib_core,scsi_transport_srp,ib_sa,scsi_mod,ib_cm,rdma_cm,scsi_transport_=
srp
vermagic:       3.19-3-amd64 SMP mod_unload modversions

modinfo scsi_transport_srp
filename:       /lib/modules/3.19-3-amd64/updates/dkms/scsi_transport_s=
rp.ko
license:        GPL
description:    SRP Transport Attributes
author:         FUJITA Tomonori
depends:        scsi_mod
vermagic:       3.19-3-amd64 SMP mod_unload modversions

--=20
WBR
Konstantin V. Krotov


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
