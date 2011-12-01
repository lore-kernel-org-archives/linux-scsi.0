From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: [PATCH 00/14] Make ib_srp better suited for H.A. purposes
Date: Thu, 1 Dec 2011 19:54:25 +0100
Message-ID: <201112011954.25811.bvanassche@acm.org>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>, Vu Pham <vuhuong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

This patch series makes the ib_srp driver better suited for use in a H.A.
setup because:
- Switchover without triggering read or write errors become possible. Such
  errors are bad because these can make a filesystem switch to read-only
  mode.
- A ping mechanism has been added that allows to reduce the switch-over
  time greatly.
- Disconnecting from a target without unloading ib_srp becomes possible.
- Switchover can be triggered explicitly by deleting an initiator device.

Where possible these mechanisms have been modelled after similar
functionality in the open-iscsi kernel code.

According to the measurements I ran these patches do not affect ib_srp
performance.

The individual patches are:
0001-ib_srp-Introduce-pr_fmt.patch
0002-ib_srp-Consolidate-repetitive-sysfs-code.patch
0003-ib_srp-Disallow-duplicate-logins.patch
0004-ib_srp-Set-block-layer-timeout.patch
0005-ib_srp-Avoid-that-late-SRP-replies-cause-trouble.patch
0006-ib_srp-Micro-optimize-completion-handlers.patch
0007-ib_srp-Introduce-srp_handle_qp_err.patch
0008-srp_transport-Document-sysfs-attributes.patch
0009-srp_transport-Fix-atttribute-registration-race.patch
0010-srp_transport-Simplify-attribute-initialization-code.patch
0011-ib_srp-Document-sysfs-attributes.patch
0012-ib_srp-Rework-error-handling.patch
0013-ib_srp-Implement-transport-layer-ping.patch
0014-ib_srp-Allow-SRP-disconnect-through-sysfs.patch
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
