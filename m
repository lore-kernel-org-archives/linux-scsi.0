From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: [PATCH 00/18, v2] Make ib_srp better suited for H.A. purposes
Date: Sun, 15 Jan 2012 09:28:37 +0000
Message-ID: <CAO+b5-qv0LRFZ3QkyS+bFXF7Sx7WPeqgSX3q5Ph-jCFKNU0uCw@mail.gmail.com>
References: <3109536.qySrY1Ts3e@asus>
	<1326579013.8227.4.camel@obelisk.thedillows.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1326579013.8227.4.camel-1q1vX8mYZiGLUyTwlgNVppKKF0rrzTr+@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Sat, Jan 14, 2012 at 10:10 PM, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org> wrote:
> On Sat, 2012-01-14 at 12:36 +0000, Bart Van Assche wrote:
> > This patch series makes the ib_srp driver better suited for use in a H.A.
>
> What kernel version is this based on?

3.2.0+ (commit 2145199c4f0db7c517dd788abec301dc84b91bd0 in Linus'
tree, which has timestamp 2012-01-14 04:48:42)

> Patch 17 (srp_transport: Add transport layer recovery support) doesn't
> apply with 'git am'. I haven't investigated why yet, so it may be quite
> simple.

Hmm, that's strange. As far as I can see what arrived on the
linux-scsi mailing list is identical to the patches I prepared, and
I've just checked that these apply cleanly on top of Linus' tree. By
the way, this patch series is available on github too:
http://github.com/bvanassche/linux/commits/srp-ha/

$ wget -qO- 'http://marc.info/?l=linux-scsi&m=132654542724428&q=raw' |
diff -u 0009-srp_transport-Fix-atttribute-registration.patch -
--- 0009-srp_transport-Fix-atttribute-registration.patch
2012-01-14 12:31:45.937467613 +0000
+++ -   2012-01-15 09:22:33.334832958 +0000
@@ -1,8 +1,3 @@
-From 8404320e4f4803bd24f538811017249a4741e3d2 Mon Sep 17 00:00:00 2001
-From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
-Date: Fri, 21 Oct 2011 19:31:07 +0200
-Subject: [PATCH 09/18] srp_transport: Fix atttribute registration
-
 Register transport attributes after the attribute array has been
 set up instead of before. The current code can trigger a race
 condition because the code reading the attribute array can run
@@ -43,3 +38,8 @@
 --
 1.7.7

+
+--
+To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
+the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+More majordomo info at  http://vger.kernel.org/majordomo-info.html
\ No newline at end of file

$ wget -qO- 'http://marc.info/?l=linux-scsi&m=132654548224434&q=raw' |
diff -u 0010-srp_transport-Simplify-attribute-initialization-code.patch
-
--- 0010-srp_transport-Simplify-attribute-initialization-code.patch
 2012-01-14 12:31:45.937467613 +0000
+++ -   2012-01-15 09:24:06.834890984 +0000
@@ -1,8 +1,3 @@
-From 4be682ea0060478f62da9c14c3c7086fcbd5373d Mon Sep 17 00:00:00 2001
-From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
-Date: Sat, 10 Sep 2011 16:31:57 +0200
-Subject: [PATCH 10/18] srp_transport: Simplify attribute initialization code
-
 Eliminate the private_rport_attrs[] array and the SETUP_*() macros
 used to set up that array since the information in that array
 duplicates the information in the static device attributes. Also,
@@ -72,3 +67,8 @@
 --
 1.7.7

+
+--
+To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
+the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+More majordomo info at  http://vger.kernel.org/majordomo-info.html
\ No newline at end of file

$ wget -qO- 'http://marc.info/?l=linux-scsi&m=132654649324672&q=raw' |
diff -u 0017-srp_transport-Add-transport-layer-recovery-support.patch
-
--- 0017-srp_transport-Add-transport-layer-recovery-support.patch
 2012-01-14 12:31:45.947467719 +0000
+++ -   2012-01-15 09:20:19.774797158 +0000
@@ -1,8 +1,3 @@
-From a736f1b201dbda07f397d5a345738abc549a239e Mon Sep 17 00:00:00 2001
-From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
-Date: Sat, 14 Jan 2012 08:44:52 +0000
-Subject: [PATCH 17/18] srp_transport: Add transport layer recovery support
-
 Add the necessary functions in the SRP transport module to allow
 an SRP initiator driver to implement transport layer recovery.
 This includes:
@@ -567,3 +562,8 @@
 --
 1.7.7

+
+--
+To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
+the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
+More majordomo info at  http://vger.kernel.org/majordomo-info.html
\ No newline at end of file
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
