From: Konstantin Krotov <kkv@clodo.ru>
Subject: threads scsi_eh_  and scsi_tmf_ don't die when ib_srp reconnect
Date: Mon, 10 Aug 2015 18:18:52 +0300
Message-ID: <55C8C0DC.7070505@clodo.ru>
Reply-To: kkv@clodo.ru
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-lb0-f172.google.com ([209.85.217.172]:35534 "EHLO
	mail-lb0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752843AbbHJPS6 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 10 Aug 2015 11:18:58 -0400
Received: by lbcbn3 with SMTP id bn3so2504893lbc.2
        for <linux-scsi@vger.kernel.org>; Mon, 10 Aug 2015 08:18:56 -0700 (PDT)
Received: from [192.168.1.184] ([31.28.11.22])
        by smtp.googlemail.com with ESMTPSA id r10sm4317220lar.2.2015.08.10.08.18.54
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Aug 2015 08:18:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

Hello list!


I was faced with the following problem:

Im exported to compute-node scsi disks through ib_srp from storages. And 
if reconnect occurs for any reason, eg

"[1201117.626498] scsi host62: ib_srp: REJ received
[1201117.626507] scsi host62: ib_srp: SRP LOGIN from 
fe80:0000:0000:0000:0002:c903:0009:1796 to 
fe80:0000:0000:0000:0002:c903:0009:c1a0 REJECTED, reason 0x00010001
[1201117.626656] scsi host62: ib_srp: Connection 0/8 failed"

i find threads in output ps:
"root     28047  0.0  0.0      0     0 ?        S    18:04   0:00 
[scsi_eh_62]
root     28048  0.0  0.0      0     0 ?        S<   18:04   0:00 
[scsi_tmf_62]"

Each reconnect generates two thread, which do not die.

kernel version 3.19.1

modinfo ib_srp
filename:       /lib/modules/3.19-3-amd64/updates/dkms/ib_srp.ko
release_date:   Apr 09 2015
version:        2.0.32#in-tree

-- 
WBR
Konstantin V. Krotov

