From: Luben Tuikov <ltuikov@yahoo.com>
Subject: [PATCH] [SCSI] Retrieve the Caching mode page
Date: Fri, 22 Oct 2010 21:24:36 -0700 (PDT)
Message-ID: <479061.81478.qm@web31812.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Greg KH <greg@kroah.com>, linux-usb@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk
List-Id: linux-scsi@vger.kernel.org

Some kernel transport drivers unconditionally disable
retrieval of the Caching mode page. One such for example is
the BBB/CBI transport over USB.=A0 Such a restraint is too
harsh as some devices do support the Caching mode
page. Unconditionally enabling the retrieval of this mode
page over those transports at their transport code level may
result in some devices failing and becoming unusable.

This patch implements a method of retrieving the Caching
mode page without unconditionally enabling it in the
transports which unconditionally disable it. The idea is to
ask for all supported pages, page code 0x3F, and then search
for the Caching mode page in the mode parameter data
returned. The sd driver already asks for all the mode pages
supported by the attached device by setting the page code to
0x3F in order to find out if the media is write protected by
reading the WP bit in the Device Specific Parameter
field. It then attempts to retrieve only the Caching mode
page by setting the page code to 8 and actually attempting
to retrieve it if and only if the transport allows it.

The method implemented here is that if the transport doesn't
allow retrieval of the Caching mode page and the device is
not RBC, then we ask for all pages supported by setting the
page code to 0x3F (similarly to how the WP bit is retrieved
above), and then we search for the Caching mode page in the
mode parameter data returned.

With this patch, devices over SATA, report this (no change):

Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] 976773168 512-byte =
logical blocks: (500 GB/465 GiB)
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: Attached scsi generic sg0=
 type 0
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Write Protect is of=
f
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Mode Sense: 00 3a 0=
0 00
Oct 22 18:45:58 localhost kernel: sd 0:0:0:0: [sda] Write cache: enable=
d, read cache: enabled, doesn't support DPO or FUA

Smart devices report their Caching mode page. This is a
change where we'd previously see the kernel making
assumption about the device's cache being write-through:

Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: Attached scsi generic sg2=
 type 0
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] 610472646 4096-byte=
 logical blocks: (2.50 TB/2.27 TiB)
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Write Protect is of=
f
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Mode Sense: 47 00 1=
0 08
Oct 22 18:45:58 localhost kernel: sd 6:0:0:0: [sdb] Write cache: enable=
d, read cache: enabled, supports DPO and FUA

And "dumb" devices over BBB, are correctly shown not to
support reporting the Caching mode page:

Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] 15663104 512-byte l=
ogical blocks: (8.01 GB/7.46 GiB)
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Write Protect is of=
f
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Mode Sense: 23 00 0=
0 00
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] No Caching mode pag=
e present
Oct 22 18:49:06 localhost kernel: sd 7:0:0:0: [sdc] Assuming drive cach=
e: write through

Signed-off-by: Luben Tuikov <ltuikov@yahoo.com>
---
 drivers/scsi/sd.c |   63 +++++++++++++++++++++++++++++++++++++++------=
-------
 1 files changed, 47 insertions(+), 16 deletions(-)

A note on the patch: I've removed the "len +=3D ..." statement,
since "data.length" already includes the mode parameter header length
and the block descriptor length. If the device returns correctly
formatted mode parameter data then this statement would most certainly
add those two lengths to the data twice resulting in an incorrect "len"
length.

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index ffa0689..81e83d7 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1867,10 +1867,14 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsi=
gned char *buffer)
 	int old_rcd =3D sdkp->RCD;
 	int old_dpofua =3D sdkp->DPOFUA;
=20
-	if (sdp->skip_ms_page_8)
-		goto defaults;
-
-	if (sdp->type =3D=3D TYPE_RBC) {
+	if (sdp->skip_ms_page_8) {
+		if (sdp->type =3D=3D TYPE_RBC)
+			goto defaults;
+		else {
+			modepage =3D 0x3F;
+			dbd =3D 0;
+		}
+	} else if (sdp->type =3D=3D TYPE_RBC) {
 		modepage =3D 6;
 		dbd =3D 8;
 	} else {
@@ -1898,13 +1902,11 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsi=
gned char *buffer)
 	 */
 	if (len < 3)
 		goto bad_sense;
-	if (len > 20)
-		len =3D 20;
-
-	/* Take headers and block descriptors into account */
-	len +=3D data.header_length + data.block_descriptor_length;
-	if (len > SD_BUF_SIZE)
-		goto bad_sense;
+	else if (len > SD_BUF_SIZE) {
+		sd_printk(KERN_NOTICE, sdkp, "Truncating mode parameter "
+			  "data from %d to %d bytes\n", len, SD_BUF_SIZE);
+		len =3D SD_BUF_SIZE;
+	}
=20
 	/* Get the data */
 	res =3D sd_do_mode_sense(sdp, dbd, modepage, buffer, len, &data, &ssh=
dr);
@@ -1912,16 +1914,45 @@ sd_read_cache_type(struct scsi_disk *sdkp, unsi=
gned char *buffer)
 	if (scsi_status_is_good(res)) {
 		int offset =3D data.header_length + data.block_descriptor_length;
=20
-		if (offset >=3D SD_BUF_SIZE - 2) {
-			sd_printk(KERN_ERR, sdkp, "Malformed MODE SENSE response\n");
-			goto defaults;
+		while (offset < len) {
+			u8 page_code =3D buffer[offset] & 0x3F;
+			u8 spf       =3D buffer[offset] & 0x40;
+
+			if (page_code =3D=3D 8 || page_code =3D=3D 6) {
+				/* We're interested only in the first 3 bytes.
+				 */
+				if (len - offset <=3D 2) {
+					sd_printk(KERN_ERR, sdkp, "Incomplete "
+						  "mode parameter data\n");
+					goto defaults;
+				} else {
+					modepage =3D page_code;
+					goto Page_found;
+				}
+			} else {
+				/* Go to the next page */
+				if (spf && len - offset > 3)
+					offset +=3D 4 + (buffer[offset+2] << 8) +
+						buffer[offset+3];
+				else if (!spf && len - offset > 1)
+					offset +=3D 2 + buffer[offset+1];
+				else {
+					sd_printk(KERN_ERR, sdkp, "Incomplete "
+						  "mode parameter data\n");
+					goto defaults;
+				}
+			}
 		}
=20
-		if ((buffer[offset] & 0x3f) !=3D modepage) {
+		if (modepage =3D=3D 0x3F) {
+			sd_printk(KERN_ERR, sdkp, "No Caching mode page "
+				  "present\n");
+			goto defaults;
+		} else if ((buffer[offset] & 0x3f) !=3D modepage) {
 			sd_printk(KERN_ERR, sdkp, "Got wrong page\n");
 			goto defaults;
 		}
-
+	Page_found:
 		if (modepage =3D=3D 8) {
 			sdkp->WCE =3D ((buffer[offset + 2] & 0x04) !=3D 0);
 			sdkp->RCD =3D ((buffer[offset + 2] & 0x01) !=3D 0);
--=20
1.7.0.1
