From: Brian King <brking@us.ibm.com>
Subject: Re: [PATCH] Recognize missing LUNs for non-standard devices
Date: Tue, 07 Feb 2006 09:16:58 -0600
Message-ID: <43E8B9EA.7050707@us.ibm.com>
References: <Pine.LNX.4.44L0.0602070952410.5164-100000@iolanthe.rowland.org>
Reply-To: brking@us.ibm.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.145]:19157 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S1750765AbWBGPRE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Feb 2006 10:17:04 -0500
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e5.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id k17FH3Gt026995
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:17:03 -0500
Received: from d01av04.pok.ibm.com (d01av04.pok.ibm.com [9.56.224.64])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VERS6.8) with ESMTP id k17FH3Ii226660
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:17:03 -0500
Received: from d01av04.pok.ibm.com (loopback [127.0.0.1])
	by d01av04.pok.ibm.com (8.12.11/8.13.3) with ESMTP id k17FH3FI012983
	for <linux-scsi@vger.kernel.org>; Tue, 7 Feb 2006 10:17:03 -0500
In-Reply-To: <Pine.LNX.4.44L0.0602070952410.5164-100000@iolanthe.rowland.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Alan Stern <stern@rowland.harvard.edu>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI development list <linux-scsi@vger.kernel.org>

Alan Stern wrote:
> On Mon, 6 Feb 2006, Brian King wrote:
> 
>> Alan Stern wrote:
>>> Some protocols (like USB UFI) or devices that don't adhere to the SCSI
>>> standard may indicate a nonexistent LUN by returning INQUIRY information
>>> with Peripheral Device Type set to 0x1f (unknown or none) and Peripheral
>>> Qualifier set to 0 instead of 3 as the spec requires.  This patch (as650)
>>> causes PDT = 0x1f to be recognized as no LUN present regardless of the
>>> qualifier value, if the SCSI level is equal to 0.
>> This patch will break the ipr driver. The ipr adapter firmware reports a
>> logical scsi device which is used for RAID configuration. It reports
>> a Peripheral Device Type of 0x1f and a scsi level of 0, since it does
>> not claim compliance with any scsi level. 
> 
> I was afraid that might happen.  Okay, forget the patch.
> 
> How come you didn't mention the ipr driver before when I first raised the 
> possibility of making this change?

Sorry about that... I wanted to verify on my end that the scsi level getting
returned was 0 before doing so. Your repost was a reminder...

Brian

-- 
Brian King
eServer Storage I/O
IBM Linux Technology Center
