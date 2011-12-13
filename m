From: Joe Perches <joe@perches.com>
Subject: drivers/scsi/bfa/bfa_fcpim.c: boolean and / or confusion
Date: Mon, 12 Dec 2011 16:02:43 -0800
Message-ID: <1323734563.3837.6.camel@joe2Laptop>
References: <4EE688FC.8090606@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from perches-mx.perches.com ([206.117.179.246]:33458 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753709Ab1LMACq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 12 Dec 2011 19:02:46 -0500
In-Reply-To: <4EE688FC.8090606@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: roel <roel.kluin@gmail.com>, Jing Huang <huangj@brocade.com>, "James E.J. Bottomley" <JBottomley@parallels.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, LKML <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2011-12-13 at 00:06 +0100, roel wrote:
> The test not [val1] or not [val2] always evaluates to true

Looking at drivers with:

$ grep -rP --include=*.[ch] "(\b[\w\[\]\>\._\-]+)\s*\!\=\s*[\w\[\]\>\._\-]+\s*\)\s*\|\|\s*\(\s*\1\s*\!\=" drivers

drivers/scsi/bfa/bfa_fcpim.c:			    ((cdb->scsi_cdb[0] != INQUIRY) ||
			    (cdb->scsi_cdb[0] != REPORT_LUNS))) {

Likely the || should be &&

