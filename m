From: George Cherian <gcherian@caviumnetworks.com>
Subject: JMS56x not working reliably with uas driver
Date: Wed, 21 Dec 2016 17:09:18 +0530
Message-ID: <585A69E6.6040009@caviumnetworks.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------070009080100080707050508"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bl2nam02on0058.outbound.protection.outlook.com ([104.47.38.58]:36256
        "EHLO NAM02-BL2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1755041AbcLUMNS (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 21 Dec 2016 07:13:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: oneukum@suse.com
Cc: linux-scsi@vger.kernel.org, linux-usb@vger.kernel.org, hdegoede@redhat.com, stern@rowland.harvard.edu

--------------070009080100080707050508
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit

Hi Oliver,

I was working with this JMicron device and using the uas driver.
I am seeing the following 2 issues.

1) On connect I see the following messages.
xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or 
incorrect stream ring
  This was eliminated using the following scissor patch.

---------------------------------8<------------------------------------
[PATCH] usb: storage: unusual_uas: Add JMicron JMS56x to unusual device

This device gives the following error on detection.
xhci_hcd 0000:00:11.0: ERROR Transfer event for disabled endpoint or 
incorrect stream ring

The same error is not seen when it is added to unusual_device
list with US_FL_NO_REPORT_OPCODES passed.

Signed-off-by: George Cherian <george.cherian@cavium.com>
---
  drivers/usb/storage/unusual_uas.h | 7 +++++++
  1 file changed, 7 insertions(+)

diff --git a/drivers/usb/storage/unusual_uas.h 
b/drivers/usb/storage/unusual_uas.h
index cbea9f3..d292299 100644
--- a/drivers/usb/storage/unusual_uas.h
+++ b/drivers/usb/storage/unusual_uas.h
@@ -142,6 +142,13 @@ UNUSUAL_DEV(0x152d, 0x0567, 0x0000, 0x9999,
  		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
  		US_FL_BROKEN_FUA | US_FL_NO_REPORT_OPCODES),

+/* Reported-by George Cherian <george.cherian@cavium.com> */
+UNUSUAL_DEV(0x152d, 0x9561, 0x0000, 0x9999,
+                "JMicron",
+                "JMS56x",
+                USB_SC_DEVICE, USB_PR_DEVICE, NULL,
+                US_FL_NO_REPORT_OPCODES),
+
  /* Reported-by: Hans de Goede <hdegoede@redhat.com> */
  UNUSUAL_DEV(0x2109, 0x0711, 0x0000, 0x9999,
  		"VIA",
--------------------------------->8------------------------------------

2) On disconnect I am seeing the following issue

  scsi host4: uas_post_reset: alloc streams error -19 after reset
  sd 4:0:0:0: [sdb] Synchronizing SCSI cache

This is more fatal because after these messages the USB port becomes 
unusable. Even an lsusb invocation hangs for ever.

Also please note that the device works fine with usb-storage driver.
I am attaching the usbmon capture of disconnect using uas and 
usb-storage driver.

Any help in this regard is highly appreciated.

Regards,
-George

--------------070009080100080707050508
Content-Type: text/plain; charset="UTF-8"; name="uas_disconnect.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="uas_disconnect.txt"

ZmZmZjgwMWY1ZWZiOGEwMCA1NzUzMDYyMSBDIElpOjQ6MDAyOjEgMDoxMjggMSA9IDA4CmZm
ZmY4MDFmNWVmYjhhMDAgNTc1MzA2NTQgUyBJaTo0OjAwMjoxIC0xMTU6MTI4IDIgPApmZmZm
ODAxZjYxMjg1YTAwIDU3NTMwNjc3IFMgQ2k6NDowMDI6MCBzIGEzIDAwIDAwMDAgMDAwMyAw
MDA0IDQgPApmZmZmODAxZjYxMjg1YTAwIDU3NTMxNjE4IEMgQ2k6NDowMDI6MCAwIDQgPSBj
MTAyNDAwMApmZmZmODAxZjYxMjg1YTAwIDU3NTMxNjM0IFMgQ286NDowMDI6MCBzIDIzIDAx
IDAwMTkgMDAwMyAwMDAwIDAKZmZmZjgwMWY2MTI4NWEwMCA1NzUzMTk5MiBDIENvOjQ6MDAy
OjAgMCAwCmZmZmY4MDFmNjEyODVhMDAgNTc1MzIyMjUgUyBDaTo0OjAwMjowIHMgYTMgMDAg
MDAwMCAwMDAzIDAwMDQgNCA8CmZmZmY4MDFmNjEyODVhMDAgNTc1MzMwMTAgQyBDaTo0OjAw
MjowIDAgNCA9IGMxMDIwMDAwCmZmZmY4MDFmNjEyODVhMDAgNTc1MzMwMjIgUyBDbzo0OjAw
MjowIHMgMjMgMDMgMDAxYyAwMDAzIDAwMDAgMApmZmZmODAxZjYxMjg1YTAwIDU3NTMzNDA1
IEMgQ286NDowMDI6MCAwIDAKZmZmZjgwMWY2MTI4NWEwMCA1NzU1MzE2NSBTIENpOjQ6MDAy
OjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWY2MTI4NWEwMCA1NzU1NDE3
NCBDIENpOjQ6MDAyOjAgMCA0ID0gYjEwMjAwMDAKZmZmZjgwMWY2MTI4NWEwMCA1NzU3MzE2
NCBTIENpOjQ6MDAyOjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWY2MTI4
NWEwMCA1NzU3NDA2NCBDIENpOjQ6MDAyOjAgMCA0ID0gYjEwMjAwMDAKZmZmZjgwMWY2MTI4
NWEwMCA1NzU5MzE2OSBTIENpOjQ6MDAyOjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwK
ZmZmZjgwMWY2MTI4NWEwMCA1NzU5NDIxNCBDIENpOjQ6MDAyOjAgMCA0ID0gYjEwMjAwMDAK
ZmZmZjgwMWY1ZWZiOGEwMCA1NzY0MjYxMiBDIElpOjQ6MDAyOjEgMDoxMjggMSA9IDA4CmZm
ZmY4MDFmNWVmYjhhMDAgNTc2NDI2MjEgUyBJaTo0OjAwMjoxIC0xMTU6MTI4IDIgPApmZmZm
ODAxZjVlZmI4YTAwIDU3NjU4NjEyIEMgSWk6NDowMDI6MSAwOjEyOCAxID0gMDgKZmZmZjgw
MWY1ZWZiOGEwMCA1NzY1ODYxOCBTIElpOjQ6MDAyOjEgLTExNToxMjggMiA8CmZmZmY4MDFm
NWVmYjhhMDAgNTc2NzQ2MTEgQyBJaTo0OjAwMjoxIDA6MTI4IDEgPSAwOApmZmZmODAxZjVl
ZmI4YTAwIDU3Njc0NjE3IFMgSWk6NDowMDI6MSAtMTE1OjEyOCAyIDwKZmZmZjgwMWY1ZWZi
OGEwMCA1NzY5MDYxMCBDIElpOjQ6MDAyOjEgMDoxMjggMSA9IDA4CmZmZmY4MDFmNWVmYjhh
MDAgNTc2OTA2MTUgUyBJaTo0OjAwMjoxIC0xMTU6MTI4IDIgPApmZmZmODAxZjVlZmI4YTAw
IDU3NzA2NjA5IEMgSWk6NDowMDI6MSAwOjEyOCAxID0gMDgKZmZmZjgwMWY1ZWZiOGEwMCA1
NzcwNjYxNSBTIElpOjQ6MDAyOjEgLTExNToxMjggMiA8CmZmZmY4MDFmNWVmYjhhMDAgNTc3
MjI2MDkgQyBJaTo0OjAwMjoxIDA6MTI4IDEgPSAwOApmZmZmODAxZjVlZmI4YTAwIDU3NzIy
NjE0IFMgSWk6NDowMDI6MSAtMTE1OjEyOCAyIDwKZmZmZjgwMWY1ZWZiOGEwMCA1NzczODYx
MSBDIElpOjQ6MDAyOjEgMDoxMjggMSA9IDA4CmZmZmY4MDFmNWVmYjhhMDAgNTc3Mzg2MTYg
UyBJaTo0OjAwMjoxIC0xMTU6MTI4IDIgPApmZmZmODAxZjVlZmI4YTAwIDU3NzU0NjEwIEMg
SWk6NDowMDI6MSAwOjEyOCAxID0gMDgKZmZmZjgwMWY1ZWZiOGEwMCA1Nzc1NDYxNSBTIElp
OjQ6MDAyOjEgLTExNToxMjggMiA8CmZmZmY4MDFmNWVmYjhhMDAgNTc3NzA2MDcgQyBJaTo0
OjAwMjoxIDA6MTI4IDEgPSAwOApmZmZmODAxZjVlZmI4YTAwIDU3NzcwNjEyIFMgSWk6NDow
MDI6MSAtMTE1OjEyOCAyIDwKZmZmZjgwMWY1ZWZiOGEwMCA1Nzc4NjYwOSBDIElpOjQ6MDAy
OjEgMDoxMjggMSA9IDA4CmZmZmY4MDFmNWVmYjhhMDAgNTc3ODY2MTQgUyBJaTo0OjAwMjox
IC0xMTU6MTI4IDIgPApmZmZmODAxZjVlZmI4YTAwIDU3ODAyNjA4IEMgSWk6NDowMDI6MSAw
OjEyOCAxID0gMDgKZmZmZjgwMWY1ZWZiOGEwMCA1NzgwMjYxMyBTIElpOjQ6MDAyOjEgLTEx
NToxMjggMiA8CmZmZmY4MDFmNjEyODVhMDAgNTc4MDMxOTggUyBDaTo0OjAwMjowIHMgYTMg
MDAgMDAwMCAwMDAzIDAwMDQgNCA8CmZmZmY4MDFmNjEyODVhMDAgNTc4MDQxMDkgQyBDaTo0
OjAwMjowIDAgNCA9IGEwMDIwMTAwCmZmZmY4MDFmNjEyODVhMDAgNTc4MDQxMjIgUyBDbzo0
OjAwMjowIHMgMjMgMDEgMDAxNCAwMDAzIDAwMDAgMApmZmZmODAxZjYxMjg1YTAwIDU3ODA0
NTM5IEMgQ286NDowMDI6MCAwIDAKZmZmZjgwMWY2MTI4NWEwMCA1NzgwNDU1MyBTIENvOjQ6
MDAyOjAgcyAyMyAwMSAwMDFkIDAwMDMgMDAwMCAwCmZmZmY4MDFmNjEyODVhMDAgNTc4MDQ4
NzYgQyBDbzo0OjAwMjowIDAgMApmZmZmODAxZjYxMjg1YTAwIDU3ODA0ODkwIFMgQ286NDow
MDI6MCBzIDIzIDAxIDAwMTkgMDAwMyAwMDAwIDAKZmZmZjgwMWY2MTI4NWEwMCA1NzgwNTE4
NSBDIENvOjQ6MDAyOjAgMCAwCmZmZmY4MDFmNjEyODVhMDAgNTc4MDUxOTkgUyBDbzo0OjAw
MjowIHMgMjMgMDEgMDAxMCAwMDAzIDAwMDAgMApmZmZmODAxZjYxMjg1YTAwIDU3ODA1NzM1
IEMgQ286NDowMDI6MCAwIDAKZmZmZjgwMWY2MTI4NWEwMCA1NzgwNTc0OSBTIENpOjQ6MDAy
OjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWY2MTI4NWEwMCA1NzgwNjQ5
MSBDIENpOjQ6MDAyOjAgMCA0ID0gYTAwMjAwMDAKZmZmZjgwMWY2MTI4NWEwMCA1NzgwNjUw
NiBTIENpOjQ6MDAyOjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWY2MTI4
NWEwMCA1NzgwNjg5NSBDIENpOjQ6MDAyOjAgMCA0ID0gYTAwMjAwMDAKZmZmZjgwMWY2MTI4
NWEwMCA1NzgwNjkxMCBTIENpOjQ6MDAyOjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwK
ZmZmZjgwMWY2MTI4NWEwMCA1NzgwNzM1NSBDIENpOjQ6MDAyOjAgMCA0ID0gYTAwMjAwMDAg
Cg==
--------------070009080100080707050508
Content-Type: text/plain; charset="UTF-8"; name="usb_storage_disconnect.txt"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="usb_storage_disconnect.txt"

ZmZmZjgwMWZkZTliNzEwMCAyNTA4MjYxNDQxIEMgSWk6NDowMDI6MSAwOjEyOCAxID0gMDgK
ZmZmZjgwMWZkZTliNzEwMCAyNTA4MjYxNDc1IFMgSWk6NDowMDI6MSAtMTE1OjEyOCAyIDwK
ZmZmZjgwMWZkYWY4NDIwMCAyNTA4MjYxNTkxIFMgQ2k6NDowMDI6MCBzIGEzIDAwIDAwMDAg
MDAwMyAwMDA0IDQgPApmZmZmODAxZmRhZjg0MjAwIDI1MDgyNjI1NjEgQyBDaTo0OjAwMjow
IDAgNCA9IGEwMDI0MTAwCmZmZmY4MDFmZGFmODQyMDAgMjUwODI2MjU5NiBTIENvOjQ6MDAy
OjAgcyAyMyAwMSAwMDEwIDAwMDMgMDAwMCAwCmZmZmY4MDFmZGFmODQyMDAgMjUwODI2MzA2
MCBDIENvOjQ6MDAyOjAgMCAwCmZmZmY4MDFmZGFmODQyMDAgMjUwODI2MzExOCBTIENvOjQ6
MDAyOjAgcyAyMyAwMSAwMDE5IDAwMDMgMDAwMCAwCmZmZmY4MDFmZGFmODQyMDAgMjUwODI2
MzU2OSBDIENvOjQ6MDAyOjAgMCAwCmZmZmY4MDFmZGFmODRlMDAgMjUwODMwMzYxOSBTIENp
OjQ6MDAyOjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWZkYWY4NGUwMCAy
NTA4MzA0NTY4IEMgQ2k6NDowMDI6MCAwIDQgPSBhMDAyMDAwMApmZmZmODAxZmRhZjhjYjAw
IDI1MDgzNDMwOTAgUyBDaTo0OjAwMjowIHMgYTMgMDAgMDAwMCAwMDAzIDAwMDQgNCA8CmZm
ZmY4MDFmZGFmOGNiMDAgMjUwODM0NDA1NyBDIENpOjQ6MDAyOjAgMCA0ID0gYTAwMjAwMDAK
ZmZmZjgwMWZkYWY4Y2IwMCAyNTA4MzgzMDkwIFMgQ2k6NDowMDI6MCBzIGEzIDAwIDAwMDAg
MDAwMyAwMDA0IDQgPApmZmZmODAxZmRhZjhjYjAwIDI1MDgzODQwMDIgQyBDaTo0OjAwMjow
IDAgNCA9IGEwMDIwMDAwCmZmZmY4MDFmZGFmOGNiMDAgMjUwODQyMzEyNCBTIENpOjQ6MDAy
OjAgcyBhMyAwMCAwMDAwIDAwMDMgMDAwNCA0IDwKZmZmZjgwMWZkYWY4Y2IwMCAyNTA4NDI0
MTc4IEMgQ2k6NDowMDI6MCAwIDQgPSBhMDAyMDAwMApmZmZmODAxZmRhZjhjYjAwIDI1MDg0
NjMwOTMgUyBDaTo0OjAwMjowIHMgYTMgMDAgMDAwMCAwMDAzIDAwMDQgNCA8CmZmZmY4MDFm
ZGFmOGNiMDAgMjUwODQ2Mzk5MiBDIENpOjQ6MDAyOjAgMCA0ID0gYTAwMjAwMDAK
--------------070009080100080707050508--
