From: Rusty Trivial Russell <rusty@rustcorp.com.au>
Subject: [TRIVIAL] Re: aic7xxx gcc3 warning fix
Date: Mon, 15 Jul 2002 17:09:48 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020715082121.7DC7C4277@lists.samba.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, dledford@redhat.com


[ Hi guys: recent gccs warn about multiline string literals (a
  deprecated gcc extension).  This patch was submitted via the Trivial
  Patch Monkey: please reply if you want me to push it to Linus. --RR ]=
=2E

=46rom: (via Rusty) Arnaud Launay <asl@launay.org>

  Le Tue, Jun 04, 2002 at 08:53:19AM +1000, Rusty Russell a =E9crit:
  > > Patch enclosed corrects the following warning in 2.5.20:
  > > aic7xxx_linux.c:401:27: warning: multi-line string literals are d=
eprecated
  > Wrong fix: remove the commas at the ends of lines...
 =20
  Hm, found only one other driver using multilines (drivers/media/video=
/c-qcam.c),
  patch enclosed uses the same kind of params.
 =20
  I hope I do not bother you, else just tell me.
 =20
  Regards,
  	Arnaud.
  --=20
  Flexion, extension !

--- trivial-2.5.25/drivers/scsi/aic7xxx/aic7xxx_linux.c.orig	Mon Jul 15=
 17:02:49 2002
+++ trivial-2.5.25/drivers/scsi/aic7xxx/aic7xxx_linux.c	Mon Jul 15 17:0=
2:49 2002
@@ -398,26 +398,26 @@
 MODULE_LICENSE("Dual BSD/GPL");
 #endif
 MODULE_PARM(aic7xxx, "s");
-MODULE_PARM_DESC(aic7xxx, "period delimited, options string.
-	verbose			Enable verbose/diagnostic logging
-	no_probe		Disable EISA/VLB controller probing
-	no_reset		Supress initial bus resets
-	extended		Enable extended geometry on all controllers
-	periodic_otag		Send an ordered tagged transaction periodically
-				to prevent tag starvation.  This may be
-				required by some older disk drives/RAID arrays.=20
-	reverse_scan		Sort PCI devices highest Bus/Slot to lowest
-	tag_info:<tag_str>	Set per-target tag depth
-	seltime:<int>		Selection Timeout(0/256ms,1/128ms,2/64ms,3/32ms)
-
-	Sample /etc/modules.conf line:
-		Enable verbose logging
-		Disable EISA/VLB probing
-		Set tag depth on Controller 2/Target 2 to 10 tags
-		Shorten the selection timeout to 128ms from its default of 256
-
-	options aic7xxx=3D'"verbose.no_probe.tag_info:{{}.{}.{..10}}.seltime:=
1"'
-");
+MODULE_PARM_DESC(aic7xxx, "period delimited, options string.n
+	verbose			Enable verbose/diagnostic loggingn
+	no_probe		Disable EISA/VLB controller probingn
+	no_reset		Supress initial bus resetsn
+	extended		Enable extended geometry on all controllersn
+	periodic_otag		Send an ordered tagged transaction periodicallyn
+				to prevent tag starvation.  This may ben
+				required by some older disk drives/RAID arrays. n
+	reverse_scan		Sort PCI devices highest Bus/Slot to lowestn
+	tag_info:<tag_str>	Set per-target tag depthn
+	seltime:<int>		Selection Timeout(0/256ms,1/128ms,2/64ms,3/32ms)n
+n
+	Sample /etc/modules.conf line:n
+		Enable verbose loggingn
+		Disable EISA/VLB probingn
+		Set tag depth on Controller 2/Target 2 to 10 tagsn
+		Shorten the selection timeout to 128ms from its default of 256n
+n
+	options aic7xxx=3D'"verbose.no_probe.tag_info:{{}.{}.{..10}}.seltime:=
1"'n"
+);
 #endif
=20
 static void ahc_linux_handle_scsi_status(struct ahc_softc *,
--=20
  Don't blame me: the Monkey is driving
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
