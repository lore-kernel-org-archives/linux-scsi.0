From: Andrew Brooks <arb@sat.dundee.ac.uk>
Subject: Re: Tagged overlapped commands
Date: Thu, 4 Dec 2014 15:59:04 +0000
Message-ID: <CAHOfOo1hgwtypU_YEantOKib+SG+F5OB9GpC0hFma+xNuXYb9A@mail.gmail.com>
References: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f172.google.com ([209.85.213.172]:39706 "EHLO
	mail-ig0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932512AbaLDP7Z (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Dec 2014 10:59:25 -0500
Received: by mail-ig0-f172.google.com with SMTP id hl2so18875776igb.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Dec 2014 07:59:24 -0800 (PST)
In-Reply-To: <CAHOfOo1WuW8MD=r1zEEfd+csNEWacQA4EYa95zhUn49MxbEEsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On 1 December 2014 at 12:24, Andrew Brooks <arb@sat.dundee.ac.uk> wrote:
>
> I'm having trouble writing to an LTO-5 tape drive connected via Adaptec 1405
> Writing aborts with this in syslog:
>
> st0: Sense Key : Aborted Command [current]
> st0: Add. Sense: Tagged overlapped commands (task tag 0)

If I enable debugging I get the following, does it help narrow down the problem?

14:02:25 kernel: [ 1372.991912] mv_sas.c 2067:phy 1 ctrl sts=0x00089800.
14:02:25 kernel: [ 1372.991914] mv_sas.c 2069:phy 1 irq sts = 0x01001001
14:02:25 kernel: [ 1372.995158] mv_sas.c 1957:Release slot [0] tag[0],
task [ffff88021e2161c0]:
14:02:25 kernel: [ 1373.488140] st0: Error 10000 (driver bt 0x0, host bt 0x1).
14:02:25 kernel: [ 1373.488432] mv_sas.c 753:SAS port 0 does not attachdevice.
14:02:25 kernel: [ 1373.490299] st0: Error 10000 (driver bt 0x0, host bt 0x1).
14:02:25 kernel: [ 1373.490302] st0: Error on write filemark.
14:02:25 kernel: [ 1373.506689] mv_sas.c 753:SAS port 0 does not attachdevice.
14:02:25 kernel: [ 1373.506707] st0: Error 10000 (driver bt 0x0, host bt 0x1).
14:02:27 kernel: [ 1375.392013] mv_sas.c 2005:phy1 Removed Device
14:02:27 kernel: [ 1375.395238] mv_sas.c 1353:found dev[0:1] is gone.
14:02:30 kernel: [ 1379.172027] mv_sas.c 2069:phy 1 irq sts = 0x00000085
14:02:30 kernel: [ 1379.172033] mv_sas.c 2118:notify plug in on phy[1]
14:02:30 kernel: [ 1379.176012] mv_sas.c 1181:phy 1 attach dev info is 80001
14:02:30 kernel: [ 1379.176012] mv_sas.c 1183:phy 1 attach sas addr is
7c325301a0100150
14:02:30 kernel: [ 1379.176012] mv_sas.c 277:phy 1 byte dmaded.
14:02:30 kernel: [ 1379.261430] sas: phy-2:1 added to port-2:0,
phy_mask:0x2 (500110a00153327c)
14:02:30 kernel: [ 1379.261433] mv_sas.c 1218:set wide port phy map 2
14:02:30 kernel: [ 1379.291229] sas: DOING DISCOVERY on port 0, pid:17
14:02:30 kernel: [ 1379.292725] scsi 2:0:1:0: Sequential-Access HP
Ultrium 5-SCSI   Z64D PQ: 0 ANSI: 6
14:02:30 kernel: [ 1379.296458] st 2:0:1:0: Attached scsi tape st0
14:02:30 kernel: [ 1379.296462] st 2:0:1:0: st0: try direct i/o: yes
(alignment 4 B)
14:02:30 kernel: [ 1379.296531] st 2:0:1:0: Attached scsi generic sg2 type 1
14:02:30 kernel: [ 1379.297314] sas: DONE DISCOVERY on port 0, pid:17, result:0
14:02:35 kernel: [ 1384.176006] mv_sas.c 2053:Get signature time out,
reset phy 1
14:02:35 kernel: [ 1384.176020] mv_sas.c 2067:phy 1 ctrl sts=0x00089800.
14:02:35 kernel: [ 1384.176024] mv_sas.c 2069:phy 1 irq sts = 0x00001001
14:02:36 kernel: [ 1384.672106] mv_sas.c 2069:phy 1 irq sts = 0x0100109F
14:02:36 kernel: [ 1384.676094] mv_sas.c 2118:notify plug in on phy[1]
14:02:36 kernel: [ 1384.676094] mv_sas.c 2143:plugin interrupt but phy1 is gone
14:02:36 kernel: [ 1385.168221] mv_sas.c 753:SAS port 0 does not attachdevice.
14:02:37 kernel: [ 1386.172012] mv_sas.c 753:SAS port 0 does not attachdevice.
14:02:38 kernel: [ 1386.496002] mv_sas.c 1181:phy 1 attach dev info is 80001
14:02:38 kernel: [ 1386.496002] mv_sas.c 1183:phy 1 attach sas addr is
7c325301a0100150
14:02:38 kernel: [ 1386.496002] mv_sas.c 277:phy 1 byte dmaded.
14:02:38 kernel: [ 1386.551563] mv_sas.c 1218:set wide port phy map 2
14:02:38 kernel: [ 1386.561489] sas: sas_form_port: phy1 belongs to
port0 already(1)!
14:02:38 kernel: [ 1386.551563] mv_sas.c 2011:phy1 Attached Device
