From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: [PATCH] aacraid 2.6: Fix aacraid probe breakageinscsi-block-2.6.git
Date: Mon, 15 Aug 2005 13:28:49 -0400
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189F01708AFB@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:12942 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S964857AbVHORbJ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Aug 2005 13:31:09 -0400
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

BTW, while applying this patch to my code, I discovered a missing
component (applied post patch)

@@ -1389,4 +1369,5 @@
                        setinqstr(cardtype, (void *)
(inq_data.inqd_vid), (sizeof(container_types)/sizeof(char *)));
                        inq_data.inqd_pdt = INQD_PDT_PROC;      /*
Processor device */
+				aac_internal_transfer(scsicmd,
&inq_data, 0, sizeof(inq_data));
                        scsicmd->result = DID_OK << 16 |
COMMAND_COMPLETE << 8 | SAM_STAT_GOOD;
                        scsicmd->scsi_done(scsicmd);

Sincerely -- Mark Salyzyn

-----Original Message-----
From: James Bottomley [mailto:James.Bottomley@SteelEye.com] 
Sent: Monday, August 15, 2005 1:20 PM
To: Salyzyn, Mark
Cc: Mark Haverkamp; linux-scsi
Subject: RE: [PATCH] aacraid 2.6: Fix aacraid probe
breakageinscsi-block-2.6.git

On Mon, 2005-08-15 at 13:06 -0400, Salyzyn, Mark wrote:
> The code does not 'damage' the scsi-misc tree version, so why not
apply
> it to the scsi-misc tree as well at least to make sure it does not
> (extending the test coverage)? What is the scsi-block timetable for
> downstream?

OK, that's true ... there's no reason not to.

> I have almost religiously applied all patches that touch the driver to
> the Adaptec branch here. The net result is I have caught some gaffs
> early on because we always have some test or Q/A program ready to give
> it coverage.

Yes, early and often ... just in case the scsi-block merge gets delayed
again.

James


