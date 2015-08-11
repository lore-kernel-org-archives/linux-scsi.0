From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: threads scsi_eh_ and scsi_tmf_ don't die when ib_srp reconnect
Date: Tue, 11 Aug 2015 13:28:04 -0700
Message-ID: <55CA5AD4.8080109@sandisk.com>
References: <55C8C0DC.7070505@clodo.ru> <55C8C39B.1010000@sandisk.com>
 <55C9FB62.1030004@clodo.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2on0063.outbound.protection.outlook.com ([207.46.100.63]:17536
	"EHLO na01-by2-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932739AbbHKU2K (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Aug 2015 16:28:10 -0400
In-Reply-To: <55C9FB62.1030004@clodo.ru>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "kkv@clodo.ru" <kkv@clodo.ru>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 08/11/2015 06:41 AM, Konstantin Krotov wrote:
> Hello, thanks for reply.
>
> I build a package version 2.0.34, but problem is reproduced:
> [  260.266374] scsi host15: ib_srp: REJ received
> [  260.266383] scsi host15: ib_srp: SRP LOGIN from
> fe80:0000:0000:0000:0002:c903:0008:c884 to
> fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
> [  260.266588] scsi host15: ib_srp: Connection 0/8 failed
> [  260.266700] scsi host15: ib_srp: Sending CM DREQ failed
>
> and increases the number of threads scsi_tmf_ and scsi_eh_ at every
> reconnect..

Hello Konstantin,

I have tried to reproduce this but without success so far. Whether I 
install upstream kernel v4.2-rc6 or another kernel version + 
ib_srp-backport on the initiator system, the result is the same when I 
block SRP login on the target system: the ib_srp driver keeps trying to 
log in without creating new SCSI hosts. Are you using a kernel from Greg 
KH's stable repository or another kernel ? And to which values were the 
ib_srp kernel module parameters set (cat /etc/modprobe.d/ib_srp.conf) ?

Bart.
