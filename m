From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: sd_mod or usb-storage fails to read a single good block (was:
 ehci_hcd fails to read a single good block)
Date: Wed, 25 Apr 2012 11:34:38 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1204251126320.1471-100000@iolanthe.rowland.org>
References: <545679.82050.qm@web100009.mail.kks.yahoo.co.jp>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:39324 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754355Ab2DYPej (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Apr 2012 11:34:39 -0400
In-Reply-To: <545679.82050.qm@web100009.mail.kks.yahoo.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Norman Diamond <n0diamond@yahoo.co.jp>
Cc: linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 18 Apr 2012, Norman Diamond wrote:

> Alan Stern wrote:
> > On Tue, 17 Apr 2012, Norman Diamond wrote:
> >> Yes it does look like changing this bridge to CAPACITY_HEURISTICS =
from FIX_CAPACITY is likely to help a bit.
> >=20
> > That's easy enough.
>=20
> Yeah I know, even I could do that one  ^_^
>=20
> >> I think that heuristics should also accept multiples of 63 even if=
 the total is odd.=A0 This doesn't solve everything but will probably h=
elp more.
> >=20
> > Okay, if nobody objects.
>=20
> I'm nobody and I don't object  ^_^
> (Of course we have to wait to see if anyone knows a real reason that =
this would be a problem.)
>=20
> >> I think that handling of FIX_CAPACITY should check for multiples o=
f 63 and report the apparent likelihood that FIX_CAPACITY probably wasn=
't the right setting for the bridge (if it's a bridge).=A0 This doesn't=
 solve everything but will probably help more.
> >=20
> > The FIX_CAPACITY code runs in a different module.=A0 It has no way =
to know whether the device is a bridge or not.
>=20
> The quirks table could be made available, but values stored in the
> table don't say if the device is a bridge.  OK, then I still think
> this:  I think that handling of FIX_CAPACITY should check for
> multiples of 63 and report the apparent likelihood that FIX_CAPACITY
> probably wasn't the right setting for the device.
>=20
> In addition, I have a feeling that if a device has FIX_CAPACITY but
> the number of reported blocks is even then I doubt the accuracy of
> FIX_CAPACITY.  The reason is that flash memory devices tend to have
> physical sectors that are even multiples of logical sectors.

=46IX_CAPACITY applies to all kinds of devices, not just those using
flash memory.  There have been examples posted in the archives of
devices which really do have an odd number of blocks.  (I don't
remember whether any of these devices needs the FIX_CAPACITY flag,
though.)

> I do think the handling of FIX_CAPACITY should report when devices
> report capacities that are either multiples of 63 or 2 (or both), so
> that further testing can be done.  The existing code to do the
> decrement anyway can remain the same until further testing is done.
>=20
> >> The addition of TEST_CAPACITY doesn't solve everything but will pr=
obably help more.
> >=20
> > That will require a certain amount of work, with the possibility of=
 breaking some systems.=A0 I'd rather not do it if there's no clear and=
 pressing need.
>=20
> Two indistinguishable versions of the Prolific bridge show that there
> is a need.  One version needs the decrement (probably) and the other
> version doesn't (definitely).

No, the two indistinguishable versions show there is a need to change=20
the existing FIX_CAPACITY flag to CAPACITY_HEURISTICS.

Below are two patches that do pretty much what you are asking for. =20
Please test just the first and then both together.

Alan Stern


Patch #1: Change the logic for CAPACITY_HEURISTICS to look for total=20
sizes that are divisible by 63, and log a message if FIX_CAPACITY ends=20
up decrementing a size that is already divisible by 63.

Index: usb-3.4/drivers/scsi/sd.c
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.4.orig/drivers/scsi/sd.c
+++ usb-3.4/drivers/scsi/sd.c
@@ -51,6 +51,7 @@
 #include <linux/async.h>
 #include <linux/slab.h>
 #include <linux/pm_runtime.h>
+#include <linux/math64.h>
 #include <asm/uaccess.h>
 #include <asm/unaligned.h>
=20
@@ -1914,6 +1915,7 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	int sector_size;
 	struct scsi_device *sdp =3D sdkp->device;
 	sector_t old_capacity =3D sdkp->capacity;
+	u32 n;
=20
 	if (sd_try_rc16_first(sdp)) {
 		sector_size =3D read_capacity_16(sdkp, sdp, buffer);
@@ -1954,14 +1956,18 @@ sd_read_capacity(struct scsi_disk *sdkp,
 	 *
 	 * If we know the reported capacity is wrong, decrement it.  If
 	 * we can only guess, then assume the number of blocks is even
-	 * (usually true but not always) and err on the side of lowering
-	 * the capacity.
+	 * (usually true but not always) or divisible by 63 (the usual
+	 * number of sectors per track reported by ATA drives), and err
+	 * on the side of lowering the capacity.
 	 */
+	div_u64_rem(sdkp->capacity, 2 * 63, &n);
 	if (sdp->fix_capacity ||
-	    (sdp->guess_capacity && (sdkp->capacity & 0x01))) {
+	    (sdp->guess_capacity && (n % 2 =3D=3D 1 || n % 63 =3D=3D 1))) {
 		sd_printk(KERN_INFO, sdkp, "Adjusting the sector count "
 				"from its reported value: %llu\n",
 				(unsigned long long) sdkp->capacity);
+		if (n % 63 =3D=3D 0)
+			sd_printk(KERN_INFO, sdkp, "(This adjustment may be incorrect)\n");
 		--sdkp->capacity;
 	}
=20


Patch #2: Change the unusual_devs entry for the Prolific USB-(S)ATA=20
bridge; replace FIX_CAPACITY with CAPACITY_HEURISTICS.

Index: usb-3.4/drivers/usb/storage/unusual_devs.h
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
--- usb-3.4.orig/drivers/usb/storage/unusual_devs.h
+++ usb-3.4/drivers/usb/storage/unusual_devs.h
@@ -839,14 +839,16 @@ UNUSUAL_DEV( 0x067b, 0x2317, 0x0001, 0x0
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
 		US_FL_NOT_LOCKABLE ),
=20
-/* Reported by Richard -=3D[]=3D- <micro_flyer@hotmail.com> */
-/* Change to bcdDeviceMin (0x0100 to 0x0001) reported by
- * Thomas Bartosik <tbartdev@gmx-topmail.de> */
+/* Reported by Richard -=3D[]=3D- <micro_flyer@hotmail.com>
+ * Change to bcdDeviceMin (0x0100 to 0x0001) reported by
+ * Thomas Bartosik <tbartdev@gmx-topmail.de>
+ * Change to US_FL_CAPACITY_HEURISTICS reported by
+ * Norman Diamond <n0diamond@yahoo.co.jp> */
 UNUSUAL_DEV( 0x067b, 0x2507, 0x0001, 0x0100,
 		"Prolific Technology Inc.",
 		"Mass Storage Device",
 		USB_SC_DEVICE, USB_PR_DEVICE, NULL,
-		US_FL_FIX_CAPACITY | US_FL_GO_SLOW ),
+		US_FL_CAPACITY_HEURISTICS | US_FL_GO_SLOW ),
=20
 /* Reported by Alex Butcher <alex.butcher@assursys.co.uk> */
 UNUSUAL_DEV( 0x067b, 0x3507, 0x0001, 0x0101,

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
