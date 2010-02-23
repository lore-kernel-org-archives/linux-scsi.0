From: =?UTF-8?B?UmVuw6kgQm9sbGRvcmY=?= <xsecute@googlemail.com>
Subject: Re: [Patch]: Enable SCSI Wait Scan only if BLK_DEV_INITRD is set.
Date: Tue, 23 Feb 2010 19:57:00 +0100
Message-ID: <4B8424FC.5060203@googlemail.com>
References: <4B830AEB.3010905@googlemail.com> <4B83FD7E.1070601@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-fx0-f219.google.com ([209.85.220.219]:34453 "EHLO
	mail-fx0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752952Ab0BWS5I (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Feb 2010 13:57:08 -0500
Received: by fxm19 with SMTP id 19so4157258fxm.21
        for <linux-scsi@vger.kernel.org>; Tue, 23 Feb 2010 10:57:07 -0800 (PST)
In-Reply-To: <4B83FD7E.1070601@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stefan Richter <stefanr@s5r6.in-berlin.de>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On 02/23/2010 05:08 PM, Stefan Richter wrote:
> Ren=C3=A9 Bolldorf wrote:
>
> (I'm not sure whether the maintainers are going to accept that change
> this time around, but anyway:)
>
>> diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
>> index 9191d1e..b785703 100644
>> --- a/drivers/scsi/Kconfig
>> +++ b/drivers/scsi/Kconfig
>> @@ -258,21 +258,22 @@ config SCSI_SCAN_ASYNC
>>    	  or async on the kernel's command line.
>>
>>    config SCSI_WAIT_SCAN
>> -	tristate  # No prompt here, this is an invisible symbol.
>> +	tristate "SCSI Wait Scan"
>>    	default m
>>    	depends on SCSI
>> +	depends on SCSI_SCAN_ASYNC
>>    	depends on MODULES
> [...]
>> +	depends on BLK_DEV_INITRD
>
> There needs to be an additional "depends on m" now that you made it
> visible, so that it cannot be set to y.
>
>> +	help
>> +	  scsi_wait_scan is a loadable module which waits until all the as=
ync scans are
>> +	  complete.  The idea is to use it in initrd/ initramfs scripts.  =
You modprobe
>> +	  it after all the modprobes of the root SCSI drivers and it will =
wait until
>> +	  they have all finished scanning their buses before allowing the =
boot to
>> +	  proceed.
> [...]
>> +	  People that use a initramfs should say Y or M.
>
> They "...should say M." actually.

Ok, updated. thx
I hope someone pick it up, because it's damn that the module will be=20
built even with no initramfs support.

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
diff --git a/drivers/scsi/Kconfig b/drivers/scsi/Kconfig
index 9191d1e..1cb07da 100644
--- a/drivers/scsi/Kconfig
+++ b/drivers/scsi/Kconfig
@@ -258,21 +258,23 @@ config SCSI_SCAN_ASYNC
  	  or async on the kernel's command line.

  config SCSI_WAIT_SCAN
-	tristate  # No prompt here, this is an invisible symbol.
+	tristate "SCSI Wait Scan"
  	default m
+	depends on m
  	depends on SCSI
+	depends on SCSI_SCAN_ASYNC
  	depends on MODULES
-# scsi_wait_scan is a loadable module which waits until all the async=20
scans are
-# complete.  The idea is to use it in initrd/ initramfs scripts.  You=20
modprobe
-# it after all the modprobes of the root SCSI drivers and it will wait=
=20
until
-# they have all finished scanning their buses before allowing the boot=
 to
-# proceed.  (This method is not applicable if targets boot independent=
ly in
-# parallel with the initiator, or with transports with=20
non-deterministic target
-# discovery schemes, or if a transport driver does not support=20
scsi_wait_scan.)
-#
-# This symbol is not exposed as a prompt because little is to be gaine=
d by
-# disabling it, whereas people who accidentally switch it off may=20
wonder why
-# their mkinitrd gets into trouble.
+	depends on BLK_DEV_INITRD
+	help
+	  scsi_wait_scan is a loadable module which waits until all the async=
=20
scans are
+	  complete.  The idea is to use it in initrd/ initramfs scripts.  You=
=20
modprobe
+	  it after all the modprobes of the root SCSI drivers and it will wai=
t=20
until
+	  they have all finished scanning their buses before allowing the boo=
t to
+	  proceed.  (This method is not applicable if targets boot=20
independently in
+	  parallel with the initiator, or with transports with=20
non-deterministic target
+	  discovery schemes, or if a transport driver does not support=20
scsi_wait_scan.)
+
+	  People that use a initramfs should say M here.

  menu "SCSI Transports"
  	depends on SCSI
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
