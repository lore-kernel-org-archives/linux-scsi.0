Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 96D83EE49AF
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Aug 2023 18:15:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229754AbjHVSPW (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Aug 2023 14:15:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60144 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229503AbjHVSPU (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Aug 2023 14:15:20 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5F52133
        for <linux-scsi@vger.kernel.org>; Tue, 22 Aug 2023 11:14:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1692728079;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/zRrC0ByLslG0XHXfemJ/E6fgwJwZ/dPZkZMvJyskAU=;
        b=MwavZmryQQTcqrys7D5jFBqb17glYuty21uR4rpXqxKoj0EmwezTnLhOgudWVAqFwXEPnj
        6e4R4pf2ch40oh+Yc7+hTfDGSFOHZ1KHMejOj0f0J6RFBq+BdhhpI3Y0HROiqDtVgTIkFo
        LGhbIUcx6ilChOt1lHlPhY9ai/tS2w4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-365-CxTEOfUAOPOH_whEFI--sA-1; Tue, 22 Aug 2023 14:14:35 -0400
X-MC-Unique: CxTEOfUAOPOH_whEFI--sA-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2A91285CBE0;
        Tue, 22 Aug 2023 18:14:35 +0000 (UTC)
Received: from jmeneghi.bos.com (unknown [10.22.10.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D7DB52026D76;
        Tue, 22 Aug 2023 18:14:34 +0000 (UTC)
From:   John Meneghini <jmeneghi@redhat.com>
To:     linux-scsi@vger.kernel.org
Cc:     Kai.Makisara@kolumbus.fi, loberman@redhat.com, jmeneghi@redhat.com,
        jhutz@cmu.edu
Subject: [PATCH 2/2] scsi: tape: add unexpected rewind handling
Date:   Tue, 22 Aug 2023 14:14:13 -0400
Message-Id: <20230822181413.1210647-2-jmeneghi@redhat.com>
In-Reply-To: <20230822181413.1210647-1-jmeneghi@redhat.com>
References: <20230822181413.1210647-1-jmeneghi@redhat.com>
MIME-Version: 1.0
Content-type: text/plain
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Handle the unexpected condition where the tape drive reports
that tape is rewinding.

Patch one in this series was designed to handle an unexpected third
party reset condition on the tape device by setting pos_unknown
following a POR Unit Attention. Because we do not have access to
an Amazon VTL application Laurance and I tried to repoduce the
aforementioned POR data corruption problem by using a physical tape
drive with a multi-initiator iSCSI gateway.

We were easily able to issue the third party reset from initiator 1
while initiator 2 had a backup in progress. We saw the tape drive
automatically rewind following the reset, and the st driver on
initiator 2 attempt to write a filemark with MTEOM. However, we
discovered our tape drive (an HP Ultrium 5-SCSI Z64D) never sends a
Unit Attention of any kind. Instead, following the third party
reset, the tape drive continually returned "No Sense, Rewind
operation in progress".

Here are the test results w/out this patch.

<<< Rest by other initiator
st 33:0:0:0: [st0] Error: 2, cmd: a 0 0 28 0 0
st 33:0:0:0: [st0] Sense Key : No Sense [current]
st 33:0:0:0: [st0] Add. Sense: Rewind operation in progress
st 33:0:0:0: [st0] Error on write:
st 33:0:0:0: [st0] Number of r/w requests 35913, dio used in 35913...
st 33:0:0:0: [st0] Async write waits 0, finished 0.
st 33:0:0:0: [st0] Error: 2, cmd: 10 0 0 0 1 0     <<< write filemark
st 33:0:0:0: [st0] Sense Key : No Sense [current]
st 33:0:0:0: [st0] Add. Sense: Rewind operation in progress
st 33:0:0:0: [st0] Error on write filemark.
st 33:0:0:0: [st0] Buffer flushed, 1 EOF(s) written  <<< flush buffer
st 33:0:0:0: [st0] Rewinding tape.
st 33:0:0:0: [st0] Error: 2, cmd: 1 0 0 0 0 0
st 33:0:0:0: [st0] Sense Key : No Sense [current]
st 33:0:0:0: [st0] Add. Sense: Rewind operation in progress

With the patch:

<<< Rest by other initiator
st 32:0:0:0: [st0] Error: 8000002, cmd: a 0 0 28 0 0
st 32:0:0:0: [st0] Sense Key : No Sense [current]
st 32:0:0:0: [st0] Add. Sense: Rewind operation in progress
st 32:0:0:0: [st0] Error on write:
<<< no write filemark or flush buffer >>>
st 32:0:0:0: [st0] Number of r/w requests 1624, dio used in 1624...
st 32:0:0:0: [st0] Rewinding tape.
st 32:0:0:0: [st0] Error: 8000002, cmd: 1 0 0 0 0 0
st 32:0:0:0: [st0] Sense Key : No Sense [current]
st 32:0:0:0: [st0] Add. Sense: Rewind operation in progress

I'm providing this patch because I think it's valuable for testing
purposes and it should be safe. Any time the device unexpectedly
reports "Rewind is in progress", it should be safe to set
pos_unknown in the driver.

Tested-by: Laurence Oberman <loberman@redhat.com>
Signed-off-by: John Meneghini <jmeneghi@redhat.com>
---
 drivers/scsi/st.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index 338aa8c42968..b641490ed9d1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -416,6 +416,9 @@ static int st_chk_result(struct scsi_tape *STp, struct st_request * SRpnt)
 		STp->cleaning_req = 1; /* ASC and ASCQ => cleaning requested */
 	if (cmdstatp->have_sense && scode == UNIT_ATTENTION && cmdstatp->sense_hdr.asc == 0x29)
 		STp->pos_unknown = 1; /* ASC => power on / reset */
+	if (cmdstatp->have_sense && cmdstatp->sense_hdr.asc == 0
+			&& cmdstatp->sense_hdr.ascq == 0x1a)
+		STp->pos_unknown = 1; /* ASCQ => rewind in progress */
 
 	STp->pos_unknown |= STp->device->was_reset;
 
-- 
2.39.3

