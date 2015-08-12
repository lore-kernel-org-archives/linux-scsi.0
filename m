From: Konstantin Krotov <kkv@clodo.ru>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Wed, 12 Aug 2015 08:15:32 +0300
Message-ID: <55CAD674.4040104@clodo.ru>
References: <55C8C0DC.7070505@clodo.ru> <55C8C39B.1010000@sandisk.com> <55C9FB62.1030004@clodo.ru> <55CA5AD4.8080109@sandisk.com>
Reply-To: kkv@clodo.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f174.google.com ([209.85.217.174]:36805 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753755AbbHLFPo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2015 01:15:44 -0400
Received: by lbbpu9 with SMTP id pu9so3270527lbb.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Aug 2015 22:15:42 -0700 (PDT)
In-Reply-To: <55CA5AD4.8080109@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>



11.08.2015 23:28, Bart Van Assche =D0=BF=D0=B8=D1=88=D0=B5=D1=82:
> On 08/11/2015 06:41 AM, Konstantin Krotov wrote:
>> Hello, thanks for reply.
>>
>> I build a package version 2.0.34, but problem is reproduced:
>> [  260.266374] scsi host15: ib_srp: REJ received
>> [  260.266383] scsi host15: ib_srp: SRP LOGIN from
>> fe80:0000:0000:0000:0002:c903:0008:c884 to
>> fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
>> [  260.266588] scsi host15: ib_srp: Connection 0/8 failed
>> [  260.266700] scsi host15: ib_srp: Sending CM DREQ failed
>>
>> and increases the number of threads scsi_tmf_ and scsi_eh_ at every
>> reconnect..
>
> Hello Konstantin,
>
> I have tried to reproduce this but without success so far. Whether I
> install upstream kernel v4.2-rc6 or another kernel version +
> ib_srp-backport on the initiator system, the result is the same when =
I
> block SRP login on the target system: the ib_srp driver keeps trying =
to
> log in without creating new SCSI hosts.

> Are you using a kernel from Greg KH's stable repository or another ke=
rnel ? And to which values were the
yes, sources from upstream, 3.19.1

> ib_srp kernel module parameters set (cat /etc/modprobe.d/ib_srp.conf)=
 ?
srp.konf missing, i load modules with the default settings:
allow_ext_sg:N
ch_count:0
cmd_sg_entries:12
dev_loss_tmo:600
enable_imm_data:Y
fast_io_fail_tmo:15
indirect_sg_entries:12
prefer_fr:N
reconnect_delay:20
register_always:N
srp_sg_tablesize:0
topspin_workarounds:1

>
> Bart.

--=20
WBR
Konstantin V. Krotov

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
