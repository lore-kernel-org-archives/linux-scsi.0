From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: Kernel oops in 2.6.1 when loading aha152x_cs.ko
Date: 10 Jan 2004 10:03:20 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1073747000.1945.5.camel@mulgrave>
References: <6.0.0.22.0.20040109124348.01b86068@pop-server.kc.rr.com>
	<1073698638.2026.3.camel@opiate>
	<6.0.0.22.0.20040109221955.01b86f28@pop-server.kc.rr.com>
	<1073716698.2026.18.camel@opiate>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-FXImgeBiWLzi1PFr9bdR"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:9382 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265215AbUAJPDW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 10 Jan 2004 10:03:22 -0500
In-Reply-To: <1073716698.2026.18.camel@opiate>
List-Id: linux-scsi@vger.kernel.org
To: Eric Kerin <eric@bootseg.com>
Cc: "Larry W. Finger" <Larry.Finger@lwfinger.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>


--=-FXImgeBiWLzi1PFr9bdR
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Sat, 2004-01-10 at 01:38, Eric Kerin wrote:
> Let's try this again, with the proper check. This one even compiles!

Actually, you're still on slightly the wrong track.  The quick fix, as I
told Russell on this list is in aha152x_stub.c.

If you want to code that up as a patch and test it, I'll apply it.

James


--=-FXImgeBiWLzi1PFr9bdR
Content-Disposition: inline
Content-Type: message/rfc822

Return-Path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.sc.steeleye.com (hancock.sc.steeleye.com
	[172.17.4.1]) by pogo.mtv1.steeleye.com (8.12.8/8.12.8) with ESMTP id
	i08IfQcY029542 for <jejb@pogo.mtv1.steeleye.com>; Thu, 8 Jan 2004 10:41:26
	-0800
Received: from localhost.localdomain (orville.steeleye.com [65.114.3.136])
	by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id i08IA9a15345;
	Thu, 8 Jan 2004 13:10:09 -0500
Received: from vger.kernel.org (vger.kernel.org [67.72.78.212]) by
	localhost.localdomain (8.12.8/8.12.8) with ESMTP id i08Iil75009143; Thu, 8
	Jan 2004 13:44:48 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand id
	S265880AbUAHSGK (ORCPT <rfc822;Eddie.Williams@steeleye.com> + 2 others);
	Thu, 8 Jan 2004 13:06:10 -0500
Received: (majordomo@vger.kernel.org) by vger.kernel.org id S265814AbUAHSGK
	(ORCPT <rfc822;linux-scsi-outgoing>); Thu, 8 Jan 2004 13:06:10 -0500
Received: from stat1.steeleye.com ([65.114.3.130]:64983 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP id S265880AbUAHSFw
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Jan 2004 13:05:52 -0500
Received: from midgard.sc.steeleye.com (midgard.sc.steeleye.com
	[172.17.6.40]) by hancock.sc.steeleye.com (8.11.6/linuxconf) with ESMTP id
	i08I5ea15118; Thu, 8 Jan 2004 13:05:42 -0500
Subject: Re: Fwd: Kernel Oops with Adaptec 1460D (PCMCIA SCSI-Controller)
	and Kernel 2.6.0
From: James Bottomley <James.Bottomley@steeleye.com>
To: Russell King <rmk@arm.linux.org.uk>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>
In-Reply-To: <20040108112905.B14674@flint.arm.linux.org.uk>
References: <20040108112905.B14674@flint.arm.linux.org.uk>
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
X-Mailer: Ximian Evolution 1.0.8 (1.0.8-9) 
Date: 08 Jan 2004 13:05:40 -0500
Message-Id: <1073585142.2915.31.camel@mulgrave>
Mime-Version: 1.0
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
X-Spam-Status: No, hits=-8.6 required=5.0
	tests=AWL,BAYES_01,EMAIL_ATTRIBUTION,IN_REP_TO,QUOTED_EMAIL_TEXT,
	REFERENCES,REPLY_WITH_QUOTES,USER_AGENT_XIMIAN, X_MAILING_LIST
	autolearn=ham version=2.55
X-Spam-Level: 
X-Spam-Checker-Version: SpamAssassin 2.55 (1.174.2.19-2003-05-19-exp)
X-Evolution-Source: imap://jejb@172.16.1.1/

On Thu, 2004-01-08 at 06:29, Russell King wrote:
> Could someone look into this - it seems that it's more of a scsi
> bug than a pcmcia bug.

The problem seems to be this code in aha152x.c:

#ifndef PCMCIA
#define driver_template aha152x_driver_template
#include "scsi_module.c"
#endif

Since it's still behaving as a legacy driver (by calling
register_scsi()), it needs the aha152x_driver_template.legacy_hosts list
initialised (which is done in scsi_module.c).

The true fix would be to convert aha152x to the new API.  However, a
quick fix is probably to add

	INIT_LIST_HEAD(&s.legacy_hosts);

just before the call to aha152x_probe_one() in aha152x_stub.c

James


-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--=-FXImgeBiWLzi1PFr9bdR--

