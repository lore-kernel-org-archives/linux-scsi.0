From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag support
 for internal command indexing
Date: Tue, 21 Apr 2015 18:03:14 +0530
Message-ID: <e1ce6d2a2c88186f3d665bd9d8133c1f@mail.gmail.com>
References: <201504201235.t3KCZWSY016519@palmhbs0.lsi.com> <20150421104210.GC8920@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f175.google.com ([209.85.216.175]:36130 "EHLO
	mail-qc0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750775AbbDUMdQ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Apr 2015 08:33:16 -0400
Received: by qcpm10 with SMTP id m10so74941374qcp.3
        for <linux-scsi@vger.kernel.org>; Tue, 21 Apr 2015 05:33:15 -0700 (PDT)
In-Reply-To: <20150421104210.GC8920@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Tuesday, April 21, 2015 4:12 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH RESEND 6/18] megaraid_sas : Use Block layer tag
support
>for internal command indexing
>
>This patch needs to be split up:  the return_cmd calling convenion
changes
>should be a pach on it's own, the various new debug printks should be a
patch
>on their own, or better jsut be dropped.

I can work on this. Logically, there can be two patches- 1) BLK tag
support 2) changes in calling convention of return_cmd (this patch will
revert the changes done by patch- 90dc9d9 megaraid_sas : MFI MPT linked
list corruption fix).
So patch #2 will be very much dependent on patch #1. If someone applies
patch #2 without applying patch#1, then bug fixed by  "90dc9d9
megaraid_sas : MFI MPT linked list corruption fix " will be exposed again.
That's why I club these two patches in a single patch. Regarding debug
prints, that can be removed.
>
>Also please drop the BLK_TAG_REFCOUNT/DEBUG code that shouldn't be ina
>production driver.
