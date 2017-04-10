From: Laurence Oberman <loberman@redhat.com>
Subject: tcm_qla2xxx and target mode not stable at all on 4.10+
Date: Mon, 10 Apr 2017 14:12:27 -0400 (EDT)
Message-ID: <998487471.13567360.1491847947133.JavaMail.zimbra@redhat.com>
References: <477228971.13566693.1491847793447.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:40300 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752672AbdDJSMc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 10 Apr 2017 14:12:32 -0400
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 4ABC5804E0
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 18:12:27 +0000 (UTC)
Received: from colo-mx.corp.redhat.com (colo-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.20])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4100377D53
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 18:12:27 +0000 (UTC)
Received: from zmail22.collab.prod.int.phx2.redhat.com (zmail22.collab.prod.int.phx2.redhat.com [10.5.83.26])
        by colo-mx.corp.redhat.com (Postfix) with ESMTP id 386E918521C9
        for <linux-scsi@vger.kernel.org>; Mon, 10 Apr 2017 18:12:27 +0000 (UTC)
In-Reply-To: <477228971.13566693.1491847793447.JavaMail.zimbra@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI List <linux-scsi@vger.kernel.org>

Hello

I have had issues with the target mode working since moving to 4.10+.
I am using a qla25xx card at 8Gbit
Latest testing with 4.11 RC6 sees the same issue.

Going back to 4.10.4 I can map targets but when I use my jammer I get into other issues.

Its rock solid on 4.9 with the jammer.

I will be going back now and testing from 4.9+ and later and report back but wanted
to make the folks on this list aware of it. 

We loop in 

[ 1654.895663] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0000).


Log
----
[ 1617.374267] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1617.627264] ignoring deprecated emulate_fua_read attribute
[ 1617.654380] ignoring deprecated emulate_dpo attribute
[ 1622.822301] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1627.522678] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1632.209884] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1636.895416] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1642.271975] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1645.478152] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1648.609477] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1650.192484] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1651.771651] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1653.350823] Rounding down aligned max_sectors from 4294967295 to 4294967288
[ 1653.552445] qla2xxx [0000:0a:00.0]-00af:4: Performing ISP error recovery - ha=ffff8817c8e00000.
[ 1654.802967] qla2xxx [0000:0a:00.0]-500a:4: LOOP UP detected (4 Gbps).
[ 1654.857970] qla2xxx [0000:0a:00.0]-5032:4: Invalid completion handle (0) -- timed-out.
[ 1654.895663] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0000).
[ 1654.933551] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0501).
[ 1654.971256] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (5c03).
[ 1655.009369] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (6400).
[ 1655.047874] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (1c01).
[ 1655.086435] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (5834).
[ 1655.124292] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (6407).
[ 1655.162292] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (1c01).
[ 1655.200088] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0002).
[ 1655.237939] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (5838).
[ 1684.982064] qla2xxx [0000:0a:00.0]-1119:4: MBX Command timeout for cmd 27, iocontrol=8 jiffies=1001521c0 mb[0-3]=[0x4000 0x0 0xc8f1 0xc8] mb7 0x17 host_status 0x14 hccr 0x40
[ 1685.070674] qla2xxx [0000:0a:00.0]-d001:4: Firmware dump saved to temp buffer (4/ffffc9001bf31000), dump status flags (0x3f).
[ 1685.126059] qla2xxx [0000:0a:00.0]-8033:4: Unable to reinitialize FCE (256).
[ 1685.172066] qla2xxx [0000:0a:00.0]-8034:4: Unable to reinitialize EFT (258).
[ 1715.253118] qla2xxx [0000:0a:00.0]-1015:4: cmd=0x69, waited 30049 msecs
[ 1715.284860] qla2xxx [0000:0a:00.0]-1119:4: MBX Command timeout for cmd 69, iocontrol=0 jiffies=10015981f mb[0-3]=[0x4001 0x4953 0x5020 0x2532] mb7 0x1 host_status 0x40018002 hccr 0x0
[ 1715.362716] qla2xxx [0000:0a:00.0]-d009:4: Firmware has been previously dumped (ffffc9001bf31000) -- ignoring request.
[ 1715.414674] qla2xxx [0000:0a:00.0]-101e:4: Mailbox cmd timeout occurred, cmd=0x69, mb[0]=0x69. Scheduling ISP abort 
[ 1715.414679] qla2xxx [0000:0a:00.0]-00af:4: Performing ISP error recovery - ha=ffff8817c8e00000.
[ 1716.713072] qla2xxx [0000:0a:00.0]-500a:4: LOOP UP detected (4 Gbps).
[ 1716.803096] qla2xxx [0000:0a:00.0]-803b:4: Firmware ready **** FAILED ****.
[ 1717.202630] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (1c01).
[ 1717.210468] qla2xxx [0000:0a:00.1]-00af:6: Performing ISP error recovery - ha=ffff8817c88e0000.
[ 1717.282428] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (5834).
[ 1717.319999] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (6407).
[ 1717.359180] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (1c01).
[ 1717.396856] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0002).
[ 1717.434517] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (5838).
[ 1717.472756] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0502).
[ 1717.511664] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (4c0c).
[ 1717.549481] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (580c).
[ 1717.587457] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0105).
[ 1717.625668] qla2xxx [0000:0a:00.0]-5030:4: Error entry - invalid handle/queue (0502).
[ 1718.405038] qla2xxx [0000:0a:00.1]-500a:6: LOOP UP detected (4 Gbps).
[ 1718.471018] qla2xxx [0000:0a:00.1]-5032:6: Invalid completion handle (0) -- timed-out.
[ 1718.508840] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (0000).
[ 1718.546805] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (0501).
[ 1718.584290] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (5c03).
[ 1718.621662] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (6400).
[ 1718.659165] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (1c01).
[ 1718.696545] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (5834).
[ 1718.733939] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (6407).
[ 1718.771513] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (1c01).
[ 1718.808688] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (0002).
[ 1718.846384] qla2xxx [0000:0a:00.1]-5030:6: Error entry - invalid handle/queue (5838).

Thanks
Laurence
