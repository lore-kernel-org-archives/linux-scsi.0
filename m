From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 108771] scsi: ses: kasan: ses_enclosure_data_process use after
 free on boot SAS2X28
Date: Wed, 09 Dec 2015 12:35:21 +0000
Message-ID: <bug-108771-11613-lsPP1EZkGJ@https.bugzilla.kernel.org/>
References: <bug-108771-11613@https.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.kernel.org ([198.145.29.136]:41727 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752867AbbLIMfZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Dec 2015 07:35:25 -0500
Received: from mail.kernel.org (localhost [127.0.0.1])
	by mail.kernel.org (Postfix) with ESMTP id CFA42204AE
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 12:35:23 +0000 (UTC)
Received: from bugzilla2.web.kernel.org (bugzilla2.web.kernel.org [172.20.200.52])
	by mail.kernel.org (Postfix) with ESMTP id A789E20524
	for <linux-scsi@vger.kernel.org>; Wed,  9 Dec 2015 12:35:21 +0000 (UTC)
In-Reply-To: <bug-108771-11613@https.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

https://bugzilla.kernel.org/show_bug.cgi?id=108771

--- Comment #2 from Pavel Tikhomirov <ptikhomirov@virtuozzo.com> ---
On 12/08/2015 07:16 PM, James Bottomley wrote:
> On Mon, 2015-12-07 at 14:01 +0000, bugzilla-daemon@bugzilla.kernel.org
> wrote:
>> https://bugzilla.kernel.org/show_bug.cgi?id=108771
>>
>> --- Comment #1 from Pavel Tikhomirov <ptikhomirov@virtuozzo.com> ---
>> Aditional info about enclosue(from that node, but older 3.10 based kernel):
>>
>> [root@p9 crash]# modprobe sg
>> [root@p9 crash]#  sg_map -i
>> /dev/sg0  LSI       SAS2X28           0e12
>> /dev/sg1  /dev/sda  LSI  MR9260-4i  2.13
>> [root@p9 crash]# lsscsi -gs
>> [1:0:16:0]   enclosu LSI      SAS2X28          0e12  -          /dev/sg0
>> -
>> [1:2:0:0]    disk    LSI      MR9260-4i        2.13  /dev/sda   /dev/sg1
>> 3.99TB
>> [root@p9 crash]#  sg_ses /dev/sg0
>>    LSI       SAS2X28           0e12
>> Supported diagnostic pages:
>>    Supported Diagnostic Pages [sdp] [0x0]
>>    Configuration (SES) [cf] [0x1]
>>    Enclosure Status/Control (SES) [ec,es] [0x2]
>>    Element Descriptor (SES) [ed] [0x7]
>>    Additional Element Status (SES-2) [aes] [0xa]
>>    Download Microcode (SES-2) [dm] [0xe]
>> [root@p9 crash]#  sg_ses /dev/sg1
>>    LSI  MR9260-4i  2.13
>>      disk device (not an enclosure)
>> Supported diagnostic pages:
>
> OK, can you give us the contents of pages 1, 2 and 10 with
>
> sg_ses --page=1 --hex /dev/sg0
> sg_ses --page=2 --hex /dev/sg0
> sg_ses --page=10 --hex /dev/sg0
>
> The version of the kernel you do this on doesn't really matter.

Here are these pages:

[root@p9 ~]# sg_ses --page=1 --hex /dev/sg0
   LSI       SAS2X28           0e12
Response in hex from diagnostic page: Configuration (SES)
  00     01 00 00 c9 00 00 00 00  11 00 09 2c 50 03 04 80 
...........,P...
  10     00 a7 1e bf 4c 53 49 20  20 20 20 20 53 41 53 32    ....LSI 
  SAS2
  20     58 32 38 20 20 20 20 20  20 20 20 20 30 65 31 32    X28 
  0e12
  30     11 22 33 44 55 00 00 00  17 0c 00 0b 04 01 00 13 
."3DU...........
  40     03 03 00 04 12 02 00 0f  02 02 00 0e 0e 01 00 09 
................
  50     18 01 00 0d 19 0e 00 0e  11 02 00 0e 44 72 69 76 
............Driv
  60     65 20 53 6c 6f 74 73 54  65 6d 70 65 72 61 74 75    e 
SlotsTemperatu
  70     72 65 20 53 65 6e 73 6f  72 73 46 61 6e 73 56 6f    re 
SensorsFansVo
  80     6c 74 61 67 65 20 53 65  6e 73 6f 72 73 50 6f 77    ltage 
SensorsPow
  90     65 72 20 53 75 70 70 6c  69 65 73 45 6e 63 6c 6f    er 
SuppliesEnclo
  a0     73 75 72 65 53 41 53 20  45 78 70 61 6e 64 65 72    sureSAS 
Expander
  b0     73 53 41 53 20 43 6f 6e  6e 65 63 74 6f 72 73 45    sSAS 
ConnectorsE
  c0     74 68 65 72 6e 65 74 20  70 6f 72 74 73             thernet ports
[root@p9 ~]# sg_ses --page=2 --hex /dev/sg0
   LSI       SAS2X28           0e12
Response in hex from diagnostic page: Enclosure Status (SES)
  00     02 00 00 c0 00 00 00 00  00 00 00 00 05 00 00 00 
................
  10     05 00 00 00 01 00 00 00  05 00 00 00 05 00 00 00 
................
  20     01 00 00 00 05 00 00 00  05 00 00 00 01 00 00 00 
................
  30     05 00 00 00 05 00 00 00  01 00 00 00 00 00 00 00 
................
  40     01 00 2c 00 00 00 00 00  05 00 00 50 05 00 00 50 
..,........P...P
  50     05 00 00 50 00 00 00 00  01 00 01 f9 01 00 04 b3 
...P............
  60     00 00 00 00 47 80 00 20  47 80 00 20 00 00 00 00    ....G.. G.. 
....
  70     01 00 00 00 00 00 00 00  01 00 00 00 00 00 00 00 
................
  80     01 11 ff 00 01 11 ff 00  01 20 00 00 01 20 00 00    ......... 
... ..
  90     01 20 00 00 01 20 00 00  01 20 00 00 01 20 00 00    . ... ... 
... ..
  a0     01 20 00 00 01 20 00 00  01 20 00 00 01 20 00 00    . ... ... 
... ..
  b0     01 20 00 00 01 20 00 00  00 00 00 00 00 00 00 00    . ... 
..........
  c0     00 00 00 00                                         ....
[root@p9 ~]# sg_ses --page=10 --hex /dev/sg0
   LSI       SAS2X28           0e12
Response in hex from diagnostic page: Additional Element Status (SES-2)
  00     0a 00 01 fc 00 00 00 00  16 22 00 00 01 00 00 00 
........."......
  10     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  20     00 00 00 00 00 00 00 00  00 00 00 00 16 22 00 01 
............."..
  30     01 00 00 01 00 00 00 00  00 00 00 00 00 00 00 00 
................
  40     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  50     16 22 00 02 01 00 00 02  00 00 00 01 50 03 04 80 
."..........P...
  60     00 a7 1e bf 50 03 04 80  00 a7 1e ae 00 00 00 00 
....P...........
  70     00 00 00 00 16 22 00 03  01 00 00 03 00 00 00 00 
....."..........
  80     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  90     00 00 00 00 00 00 00 00  16 22 00 04 01 00 00 04 
........."......
  a0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  b0     00 00 00 00 00 00 00 00  00 00 00 00 16 22 00 05 
............."..
  c0     01 00 00 05 00 00 00 01  50 03 04 80 00 a7 1e bf 
........P.......
  d0     50 03 04 80 00 a7 1e b1  00 00 00 00 00 00 00 00 
P...............
  e0     16 22 00 06 01 00 00 06  00 00 00 00 00 00 00 00 
."..............
  f0     00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  100    00 00 00 00 16 22 00 07  01 00 00 07 00 00 00 00 
....."..........
  110    00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  120    00 00 00 00 00 00 00 00  16 22 00 08 01 00 00 08 
........."......
  130    00 00 00 01 50 03 04 80  00 a7 1e bf 50 03 04 80 
....P.......P...
  140    00 a7 1e b4 00 00 00 00  00 00 00 00 16 22 00 09 
............."..
  150    01 00 00 09 00 00 00 00  00 00 00 00 00 00 00 00 
................
  160    00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  170    16 22 00 0a 01 00 00 0a  00 00 00 00 00 00 00 00 
."..............
  180    00 00 00 00 00 00 00 00  00 00 00 00 00 00 00 00 
................
  190    00 00 00 00 16 22 00 0b  01 00 00 0b 00 00 00 01 
....."..........
  1a0    50 03 04 80 00 a7 1e bf  50 03 04 80 00 a7 1e b7 
P.......P.......
  1b0    00 00 00 00 00 00 00 00  16 46 00 15 1c 40 00 00 
.........F...@..
  1c0    50 03 04 80 00 a7 1e bf  00 ff 00 ff 00 ff 00 ff 
P...............
  1d0    01 ff 01 ff 01 ff 01 ff  ff ff ff ff ff ff ff ff 
................
  1e0    02 00 03 01 04 02 05 03  06 04 07 05 08 06 09 07 
................
  1f0    0a 08 0b 09 0c 0a 0d 0b  ff ff ff ff ff ff ff ff 
................

Thanks a lot,
Pavel

>
> Thanks,
>
> James
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

-- 
You are receiving this mail because:
You are watching the assignee of the bug.
