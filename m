Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3554AEE4993
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 18:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbjHVSPU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:15:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHVSPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 14:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FBD6113
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 11:14:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692728071;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=Pkepc8GiCKrqebzKoL3JlUiAz8YvXiTwpLQhzEwmjfo=;
        b=BI0tEp07KyOiCqmrHTxpU0hf3V6Hn88LePd9KR4IuOCG/HvJhs0u6HQAd83N/vb//0q/OU
        bolTKPVv2XKM/3lMzDle2mu/EK8CDCPHJJDGRuiLWAOj+KqrLqGTWUWNETh6Guo8Fl1J1/
        qS4C9cJSiSCS07Hk+kgZsB7ymSfhxrc=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-121-PY-HrwljPVaQ6wG-xsM6Iw-1; Tue, 22 Aug 2023 14:14:29 -0400
X-MC-Unique: PY-HrwljPVaQ6wG-xsM6Iw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 593A0858EED;
        Tue, 22 Aug 2023 18:14:29 +0000 (UTC)
Received: from jmeneghi.bos.com (unknown [10.22.10.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 899612026D76;
        Tue, 22 Aug 2023 18:14:28 +0000 (UTC)
From:   John Meneghini <jmeneghi@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kai.Makisara@kolumbus.fi, loberman@redhat.com, jmeneghi@redhat.com,
        jhutz@cmu.edu
Subject: [PATCH 1/2] scsi: tape: add third party poweron reset handling
Date:   Tue, 22 Aug 2023 14:14:12 -0400
Message-Id: <20230822181413.1210647-1-jmeneghi@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Many tape devices will automatically rewind following a poweron/reset.
This can result in data loss as other operations in the driver can write
to the tape when the position is unknown. E.g. MTEOM can write a
filemark at the beginning of the tape. This patch adds code to detect
poweron/reset unit attentions and prevents the driver from writing to
the tape when the position could be unknown.

Customer reported problem description:

We have experienced an issue with the SCSI tape driver (st) which has
led to data loss for us on two separate occasions in production, as well
as in a third case in which we were able to reproduce the failure in our
test environment.

The tape device involved is an Amazon Tape Gateway, a virtual tape
library (VTL) appliance which presents as a series of iSCSI targets
(multiple tape drives and a changer) and is backed by storage in Amazon
S3. The problem is a general one and not limited to any particular SCSI
transport or tape device, though the nature of both iSCSI and the VTL
make data loss somewhat more likely with this combination than with a
physical tape drive.

The observed behavior occurs when an error causes the VTL tape gateway
process (on the appliance) to crash and restart. This interrupts the
iSCSI TCP connections and, when it occurs during a write, causes the
write to fail with EIO. However, we then find that the virtual tape in
question is now completely blank. We raised this issue with AWS support,
thinking this must be a bug in the VTL appliance, but that turns out not
to be the case.

Per AWS support, when the gateway crashes in this manner, its notion of
the current tape position is reset to the beginning of the tape. It also
sets a unit attention condition, such that the next request results in a
CHECK CONDITION status with sense key UNIT ATTENTION and asc/ascq
indicating a device reset. According to their logs the next command
being sent is WRITE FILEMARK, which results in writing an FM at the
beginning of the tape, effectively discarding its contents.

In fact, once the write fails with EIO, our software attempts to recover
by rewinding and repositioning the tape, then resuming operation. If
this fails, it attempts to rewind and reposition again, write a marker
at the end of the tape, and then unmount. It does not under any
circumstances write either data or filemarks without having successfully
positioned the tape to a known point.

What actually happens is that, since the last operation was a write, the
kernel executes an implied MTWEOF operation (which translate to a Write
Filemarks command) before the rewind that was actually requested. This
seems not entirely unreasonable, provided the tape position is known.
However, once this request fails (due to the unit attention condition),
our next rewind attempt also triggers an implied MTWEOF, which does
_not_ fail (the unit attention condition persists only until the
initiator has been notified); this is the command that unexpectedly
erases the tape.

Our analysis is that the st driver is in fact completely ignoring the
UNIT ATTENTION and associated reset notification from the device. This
is not a condition that can be detected in the transport or mid-layer,
as it occurs entirely within the target and is reported only via the
UNIT ATTENTION sense key. The upper driver (i.e. st) needs to detect
this indication and reset its internal model of the device to an unknown
state.

Suggested-by: Jeffrey Hutzelman <jhutz@cmu.edu>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 14d7981ddcdd..338aa8c42968 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -414,6 +414,8 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 	if (cmdstatp->have_sense &&
 	    cmdstatp->sense_hdr.asc == 0 && cmdstatp->sense_hdr.ascq == 0x17)
 		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
+	if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
+		STp->pos_unknown = 1; /* ASC => power on / reset */
 
 	STp->pos_unknown |= STp->device->was_reset;
 
-- 
2.39.3

