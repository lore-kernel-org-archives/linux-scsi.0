From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] drivers/scsi/st.c: add reference count and related fixes
Date: Thu, 07 Jul 2005 08:24:10 -0500
Message-ID: <42CD2CFA.20902@us.ibm.com>
References: <92952AEF1F064042B6EF2522E0EEF437348354@EXNA.corp.stratus.com> <Pine.LNX.4.61.0507071332570.2964@kai.makisara.local>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.133]:33269 "EHLO
	e35.co.us.ibm.com") by vger.kernel.org with ESMTP id S261455AbVGGNYN
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 7 Jul 2005 09:24:13 -0400
Received: from westrelay02.boulder.ibm.com (westrelay02.boulder.ibm.com [9.17.195.11])
	by e35.co.us.ibm.com (8.12.10/8.12.9) with ESMTP id j67DOCOM521934
	for <linux-scsi@vger.kernel.org>; Thu, 7 Jul 2005 09:24:12 -0400
Received: from d03av03.boulder.ibm.com (d03av03.boulder.ibm.com [9.17.195.169])
	by westrelay02.boulder.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j67DOCAu283194
	for <linux-scsi@vger.kernel.org>; Thu, 7 Jul 2005 07:24:12 -0600
Received: from d03av03.boulder.ibm.com (loopback [127.0.0.1])
	by d03av03.boulder.ibm.com (8.12.11/8.13.3) with ESMTP id j67DOB2C023444
	for <linux-scsi@vger.kernel.org>; Thu, 7 Jul 2005 07:24:11 -0600
In-Reply-To: <Pine.LNX.4.61.0507071332570.2964@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: "Dailey, Nate" <Nate.Dailey@stratus.com>, linux-scsi@vger.kernel.org

Kai Makisara wrote:
>>The primary change is adding a kref to the Scsi_Tape structure, to avoid
>>an oops when the tape drive is removed while open. This includes
>>scsi_tape_get/put routines and scsi_tape_release, and changes to st_open
>>and st_release. This is all based on the SCSI disk & CD reference
>>counting code.
>>
> 
> You have added a new kref for this. Have you considered using the 
> existing cdev refcounting instead of a separate kref?
> 
> (When the new character device code was introduced, I got the impression 
> that the proper way for the st would be to embed the struct into struct 
> scsi_tape and make the destructor. The scsi_tapes[] array would not be 
> necessary any more because the struct scsi_tape would be accessible through 
> containerof(inode->i_cdev, struct scsi_tape, cdev).
> (An array would be still necessary for tape number allocation.)
> I did not implement this at that time because there was no real need for 
> the change and it seemed too complex to test just for fun.)

I'm not sure how you would do this since there is currently no way to
embed data in a cdev. Also, since there are multiple cdevs per scsi_tape,
it seems cleaner to use a new kref.


-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
